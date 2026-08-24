/**
 * Mobile tool-approval gate (product fork Phase 1 + approval memory).
 *
 * Official wire types stay unchanged except for optional fields on the
 * existing ClientMessage:
 *   approve_tool { tool_call_id, decision: "allow" | "deny",
 *                  scope?: "once" | "session" | "always", pattern?: string }
 *
 * Classification matches the original plan/05 whitelist:
 *   - read-only (`read`, `glob`, `grep`) auto-allow
 *   - dangerous (`bash`, `write`, `edit`) wait for approve_tool
 *   - everything else auto-allows so mesh / ask_user / custom tools keep working
 *
 * Scope defaults to `once` when omitted (old clients). Session rules live
 * in this Pi process; always rules persist to `~/.pi/remote/approvals.json`.
 * First decision still wins per tool_call_id. Timeout is still deny.
 */

import {
  ApprovalStore,
  deriveApprovalPattern,
  extractApprovalSubject,
  matchRules,
  parseApprovalScope,
  upsertRule,
  type ApprovalRule,
  type ApprovalScope,
  type RememberedDecision,
} from "./approval_memory.js";

export const TOOL_APPROVAL_TIMEOUT_MS = 60_000;

export const READ_ONLY_TOOLS = ["read", "glob", "grep"] as const;
export const GATED_TOOLS = ["bash", "write", "edit"] as const;

export type ToolApprovalDecision = "allow" | "deny" | "timeout";

export type ToolApprovalDecideOpts = {
  scope?: ApprovalScope | string;
  pattern?: string;
};

export type ToolApprovalWaitCtx = {
  tool?: string;
  args?: unknown;
};

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
  tool?: string;
  args?: unknown;
};

type PreDecision = {
  decision: RememberedDecision;
  scope: ApprovalScope;
  pattern?: string;
};

export class ToolApprovalGate {
  private readonly pending = new Map<string, PendingSlot>();
  private readonly preDecided = new Map<string, PreDecision>();
  private readonly decided = new Set<string>();
  private sessionRules: ApprovalRule[] = [];
  private store: ApprovalStore;
  private timeoutMs: number;

  constructor(
    timeoutMs: number = TOOL_APPROVAL_TIMEOUT_MS,
    store: ApprovalStore = ApprovalStore.memory(),
  ) {
    this.timeoutMs = timeoutMs;
    this.store = store;
  }

  setTimeoutMs(timeoutMs: number): void {
    this.timeoutMs = timeoutMs;
  }

  useApprovalsFile(filePath: string | null): void {
    this.store = filePath ? ApprovalStore.disk(filePath) : ApprovalStore.memory();
  }

  matchRemembered(tool: string, args: unknown): RememberedDecision | null {
    const subject = extractApprovalSubject(tool, args);
    if (subject === null) return null;
    const session = matchRules(this.sessionRules, tool, subject);
    if (session) return session;
    return this.store.match(tool, subject);
  }

  wait(
    toolCallId: string,
    ctx?: ToolApprovalWaitCtx,
    timeoutMs?: number,
  ): Promise<ToolApprovalDecision> {
    const remembered = ctx?.tool
      ? this.matchRemembered(ctx.tool, ctx.args)
      : null;
    if (remembered) {
      this.decided.add(toolCallId);
      return Promise.resolve(remembered);
    }

    const pre = this.preDecided.get(toolCallId);
    if (pre) {
      this.preDecided.delete(toolCallId);
      this.decided.add(toolCallId);
      if (ctx?.tool) this.remember(pre.scope, pre.decision, ctx.tool, ctx.args, pre.pattern);
      return Promise.resolve(pre.decision);
    }
    return new Promise((resolve) => {
      const timer = setTimeout(() => {
        this.settle(toolCallId, "timeout");
      }, timeoutMs ?? this.timeoutMs);
      this.pending.set(toolCallId, {
        resolve,
        timer,
        settled: false,
        tool: ctx?.tool,
        args: ctx?.args,
      });
    });
  }

  /**
   * Apply a phone's decision. First writer wins — including after the waiter
   * has already settled, so a second phone cannot park a leftover pre-decision.
   * Optional `scope` of session/always is recorded only when this call is the
   * first decision for the tool_call_id.
   */
  decide(
    toolCallId: string,
    decision: RememberedDecision,
    opts?: ToolApprovalDecideOpts,
  ): boolean {
    const scope = parseApprovalScope(opts?.scope);
    const pattern = typeof opts?.pattern === "string" ? opts.pattern : undefined;

    if (this.decided.has(toolCallId)) return false;
    if (this.pending.has(toolCallId)) {
      const slot = this.pending.get(toolCallId);
      const applied = this.settle(toolCallId, decision);
      if (applied && slot?.tool) {
        this.remember(scope, decision, slot.tool, slot.args, pattern);
      }
      return applied;
    }
    if (this.preDecided.has(toolCallId)) return false;
    this.preDecided.set(toolCallId, { decision, scope, pattern });
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
    this.sessionRules = [];
    this.timeoutMs = timeoutMs;
  }

  pendingCount(): number {
    return this.pending.size;
  }

  sessionRuleCount(): number {
    return this.sessionRules.length;
  }

  alwaysRules(): ApprovalRule[] {
    return this.store.snapshot();
  }

  private remember(
    scope: ApprovalScope,
    decision: RememberedDecision,
    tool: string,
    args: unknown,
    explicitPattern?: string,
  ): void {
    if (scope === "once") return;
    const pattern = deriveApprovalPattern(tool, args, explicitPattern);
    if (!pattern) return;
    const rule: ApprovalRule = {
      tool: normalizeToolName(tool),
      pattern,
      decision,
    };
    this.sessionRules = upsertRule(this.sessionRules, rule);
    if (scope === "always") this.store.add(rule);
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
export const toolApprovalGate = new ToolApprovalGate(
  TOOL_APPROVAL_TIMEOUT_MS,
  ApprovalStore.disk(),
);

export function _resetToolApprovalGateForTest(
  timeoutMs?: number,
  approvalsPath?: string | null,
): void {
  toolApprovalGate.reset(timeoutMs ?? TOOL_APPROVAL_TIMEOUT_MS);
  toolApprovalGate.useApprovalsFile(approvalsPath ?? null);
}

export type { ApprovalScope, ApprovalRule, RememberedDecision };
