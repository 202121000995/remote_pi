/**
 * Mobile tool-approval gate (product fork Phase 1).
 *
 * Official wire types stay unchanged: ServerMessage `tool_request` is still
 * emitted from `tool_execution_start` (timeline), and ClientMessage
 * `approve_tool` { tool_call_id, decision: "allow" | "deny" } settles a
 * waiter opened by `pi.on("tool_call")`.
 *
 * Classification matches the original plan/05 whitelist:
 *   - read-only (`read`, `glob`, `grep`) auto-allow
 *   - dangerous (`bash`, `write`, `edit`) wait for approve_tool
 *   - everything else auto-allows so mesh / ask_user / custom tools keep working
 *
 * No `scope` / `host_status` / `tool_event` — first decision wins, later
 * `approve_tool`s for the same id are ignored.
 */

export const TOOL_APPROVAL_TIMEOUT_MS = 60_000;

export const READ_ONLY_TOOLS = ["read", "glob", "grep"] as const;
export const GATED_TOOLS = ["bash", "write", "edit"] as const;

export type ToolApprovalDecision = "allow" | "deny" | "timeout";

export function normalizeToolName(name: string): string {
  return name.trim().toLowerCase();
}

export function isReadOnlyTool(name: string): boolean {
  return (READ_ONLY_TOOLS as readonly string[]).includes(normalizeToolName(name));
}

export function isGatedTool(name: string): boolean {
  return (GATED_TOOLS as readonly string[]).includes(normalizeToolName(name));
}

export function denialMessage(decision: Exclude<ToolApprovalDecision, "allow">): string {
  return decision === "timeout"
    ? "Timed out waiting for tool approval"
    : "Denied by user";
}

type PendingSlot = {
  resolve: (decision: ToolApprovalDecision) => void;
  timer: ReturnType<typeof setTimeout>;
  settled: boolean;
};

export class ToolApprovalGate {
  private readonly pending = new Map<string, PendingSlot>();
  private readonly preDecided = new Map<string, Exclude<ToolApprovalDecision, "timeout">>();
  private readonly decided = new Set<string>();
  private timeoutMs: number;

  constructor(timeoutMs: number = TOOL_APPROVAL_TIMEOUT_MS) {
    this.timeoutMs = timeoutMs;
  }

  setTimeoutMs(timeoutMs: number): void {
    this.timeoutMs = timeoutMs;
  }

  wait(toolCallId: string, timeoutMs?: number): Promise<ToolApprovalDecision> {
    const pre = this.preDecided.get(toolCallId);
    if (pre) {
      this.preDecided.delete(toolCallId);
      this.decided.add(toolCallId);
      return Promise.resolve(pre);
    }
    return new Promise((resolve) => {
      const timer = setTimeout(() => {
        this.settle(toolCallId, "timeout");
      }, timeoutMs ?? this.timeoutMs);
      this.pending.set(toolCallId, { resolve, timer, settled: false });
    });
  }

  /**
   * Apply a phone's decision. First writer wins — including after the waiter
   * has already settled, so a second phone cannot park a leftover pre-decision.
   */
  decide(toolCallId: string, decision: "allow" | "deny"): boolean {
    if (this.decided.has(toolCallId)) return false;
    if (this.pending.has(toolCallId)) return this.settle(toolCallId, decision);
    if (this.preDecided.has(toolCallId)) return false;
    this.preDecided.set(toolCallId, decision);
    return true;
  }

  rejectAll(decision: ToolApprovalDecision = "deny"): void {
    for (const id of [...this.pending.keys()]) {
      this.settle(id, decision);
    }
    this.preDecided.clear();
  }

  reset(timeoutMs: number = TOOL_APPROVAL_TIMEOUT_MS): void {
    this.rejectAll("deny");
    this.preDecided.clear();
    this.decided.clear();
    this.timeoutMs = timeoutMs;
  }

  pendingCount(): number {
    return this.pending.size;
  }

  private settle(toolCallId: string, decision: ToolApprovalDecision): boolean {
    const slot = this.pending.get(toolCallId);
    if (!slot || slot.settled) return false;
    slot.settled = true;
    clearTimeout(slot.timer);
    this.pending.delete(toolCallId);
    this.decided.add(toolCallId);
    slot.resolve(decision);
    return true;
  }
}

/** Process-wide gate used by the extension factory (interactive + daemon/rpc). */
export const toolApprovalGate = new ToolApprovalGate();

export function _resetToolApprovalGateForTest(
  timeoutMs: number = TOOL_APPROVAL_TIMEOUT_MS,
): void {
  toolApprovalGate.reset(timeoutMs);
}
