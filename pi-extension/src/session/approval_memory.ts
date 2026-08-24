/**
 * Approval memory for gated tools (bash / write / edit).
 *
 * Session rules live in RAM for this Pi process. Always rules persist to
 * `~/.pi/remote/approvals.json` (0600, atomic write). Matching is shared by
 * the interactive, daemon, and `pi --mode rpc` factory paths.
 */

import {
  chmodSync,
  mkdirSync,
  readFileSync,
  renameSync,
  writeFileSync,
} from "node:fs";
import { dirname, join } from "node:path";
import { homedir } from "node:os";

function toolKey(name: string): string {
  return name.trim().toLowerCase();
}

export type ApprovalScope = "once" | "session" | "always";
export type RememberedDecision = "allow" | "deny";

export type ApprovalRule = {
  tool: string;
  pattern: string;
  decision: RememberedDecision;
};

export type ApprovalsFile = {
  version: 1;
  rules: ApprovalRule[];
};

export const APPROVALS_VERSION = 1 as const;

export function defaultApprovalsPath(): string {
  return join(homedir(), ".pi", "remote", "approvals.json");
}

export function parseApprovalScope(raw: unknown): ApprovalScope {
  if (raw === "session" || raw === "always" || raw === "once") return raw;
  return "once";
}

/** Command string (bash) or file path (write/edit). */
export function extractApprovalSubject(tool: string, args: unknown): string | null {
  if (!args || typeof args !== "object") return null;
  const record = args as Record<string, unknown>;
  const name = toolKey(tool);
  if (name === "bash") {
    return typeof record.command === "string" ? record.command : null;
  }
  if (name === "write" || name === "edit") {
    if (typeof record.path === "string") return record.path;
    if (typeof record.file_path === "string") return record.file_path;
    return null;
  }
  return null;
}

export function deriveApprovalPattern(
  tool: string,
  args: unknown,
  explicit?: string,
): string | null {
  const trimmed = typeof explicit === "string" ? explicit.trim() : "";
  if (trimmed) return trimmed;
  const subject = extractApprovalSubject(tool, args);
  return subject && subject.length > 0 ? subject : null;
}

/** Convert a glob to a RegExp. `*` = one path segment; `**` = any depth. */
export function globToRegExp(pattern: string): RegExp {
  const normalized = pattern.replace(/\\/g, "/");
  let out = "^";
  let i = 0;
  while (i < normalized.length) {
    const c = normalized[i]!;
    if (c === "*" && normalized[i + 1] === "*") {
      if (normalized[i + 2] === "/") {
        out += "(?:.*/)?";
        i += 3;
      } else {
        out += ".*";
        i += 2;
      }
    } else if (c === "*") {
      out += "[^/]*";
      i += 1;
    } else if (c === "?") {
      out += "[^/]";
      i += 1;
    } else {
      if (/[.+^${}()|[\]\\]/.test(c)) out += `\\${c}`;
      else out += c;
      i += 1;
    }
  }
  return new RegExp(`${out}$`);
}

export function globMatch(pattern: string, value: string): boolean {
  const p = pattern.replace(/\\/g, "/");
  const v = value.replace(/\\/g, "/");
  if (!/[*?]/.test(p)) return p === v;
  return globToRegExp(p).test(v);
}

/**
 * Bash: glob, or command prefix at a token boundary (`echo` matches
 * `echo hello` but not `echohello`). Write/edit: path glob (or exact).
 */
export function patternMatches(tool: string, pattern: string, subject: string): boolean {
  if (!pattern) return false;
  const name = toolKey(tool);
  if (name === "bash") {
    if (globMatch(pattern, subject)) return true;
    return subject === pattern || subject.startsWith(`${pattern} `);
  }
  return globMatch(pattern, subject);
}

export function ruleMatches(rule: ApprovalRule, tool: string, subject: string): boolean {
  if (toolKey(rule.tool) !== toolKey(tool)) return false;
  return patternMatches(rule.tool, rule.pattern, subject);
}

/** Deny matches win over allow so a persisted deny cannot be shadowed. */
export function matchRules(
  rules: readonly ApprovalRule[],
  tool: string,
  subject: string,
): RememberedDecision | null {
  let allow = false;
  for (const rule of rules) {
    if (!ruleMatches(rule, tool, subject)) continue;
    if (rule.decision === "deny") return "deny";
    allow = true;
  }
  return allow ? "allow" : null;
}

export function upsertRule(rules: ApprovalRule[], next: ApprovalRule): ApprovalRule[] {
  const tool = toolKey(next.tool);
  const pattern = next.pattern;
  const kept = rules.filter(
    (r) => !(toolKey(r.tool) === tool && r.pattern === pattern),
  );
  kept.push({ tool, pattern, decision: next.decision });
  return kept;
}

export function parseApprovalsFile(raw: unknown): ApprovalsFile {
  if (!raw || typeof raw !== "object") return { version: APPROVALS_VERSION, rules: [] };
  const obj = raw as Record<string, unknown>;
  const rulesIn = Array.isArray(obj.rules) ? obj.rules : [];
  const rules: ApprovalRule[] = [];
  for (const item of rulesIn) {
    if (!item || typeof item !== "object") continue;
    const row = item as Record<string, unknown>;
    if (typeof row.tool !== "string" || typeof row.pattern !== "string") continue;
    if (row.decision !== "allow" && row.decision !== "deny") continue;
    if (!row.tool.trim() || !row.pattern) continue;
    rules.push({
      tool: toolKey(row.tool),
      pattern: row.pattern,
      decision: row.decision,
    });
  }
  return { version: APPROVALS_VERSION, rules };
}

export function atomicWriteFile(filePath: string, contents: string): void {
  mkdirSync(dirname(filePath), { recursive: true, mode: 0o700 });
  try { chmodSync(dirname(filePath), 0o700); } catch { /* best-effort */ }
  const tmp = `${filePath}.${process.pid}.${Date.now()}.tmp`;
  writeFileSync(tmp, contents, { encoding: "utf8", mode: 0o600 });
  try { chmodSync(tmp, 0o600); } catch { /* umask may have masked mode */ }
  renameSync(tmp, filePath);
  try { chmodSync(filePath, 0o600); } catch { /* best-effort */ }
}

export class ApprovalStore {
  private rules: ApprovalRule[] = [];
  private loaded = false;

  constructor(private readonly filePath: string | null) {}

  static memory(): ApprovalStore {
    return new ApprovalStore(null);
  }

  static disk(filePath: string = defaultApprovalsPath()): ApprovalStore {
    return new ApprovalStore(filePath);
  }

  path(): string | null {
    return this.filePath;
  }

  snapshot(): ApprovalRule[] {
    this.ensureLoaded();
    return [...this.rules];
  }

  match(tool: string, subject: string): RememberedDecision | null {
    this.ensureLoaded();
    return matchRules(this.rules, tool, subject);
  }

  add(rule: ApprovalRule): void {
    this.ensureLoaded();
    this.rules = upsertRule(this.rules, rule);
    this.persist();
  }

  private ensureLoaded(): void {
    if (this.loaded) return;
    this.loaded = true;
    if (!this.filePath) return;
    try {
      const parsed = JSON.parse(readFileSync(this.filePath, "utf8")) as unknown;
      this.rules = parseApprovalsFile(parsed).rules;
    } catch {
      this.rules = [];
    }
  }

  private persist(): void {
    if (!this.filePath) return;
    const body: ApprovalsFile = { version: APPROVALS_VERSION, rules: this.rules };
    atomicWriteFile(this.filePath, `${JSON.stringify(body, null, 2)}\n`);
  }
}
