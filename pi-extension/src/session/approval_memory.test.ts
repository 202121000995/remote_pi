import { chmodSync, mkdtempSync, readFileSync, statSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { describe, expect, test } from "vitest";
import {
  ApprovalStore,
  deriveApprovalPattern,
  extractApprovalSubject,
  globMatch,
  matchRules,
  parseApprovalScope,
  parseApprovalsFile,
  patternMatches,
  upsertRule,
} from "./approval_memory.js";

function tmpFile(name = "approvals.json"): string {
  const dir = mkdtempSync(join(tmpdir(), "rp-approvals-"));
  return join(dir, name);
}

describe("parseApprovalScope", () => {
  test("omitted / unknown values default to once", () => {
    expect(parseApprovalScope(undefined)).toBe("once");
    expect(parseApprovalScope(null)).toBe("once");
    expect(parseApprovalScope("ONCE")).toBe("once");
    expect(parseApprovalScope("forever")).toBe("once");
  });

  test("accepts once / session / always", () => {
    expect(parseApprovalScope("once")).toBe("once");
    expect(parseApprovalScope("session")).toBe("session");
    expect(parseApprovalScope("always")).toBe("always");
  });
});

describe("extract + derive pattern", () => {
  test("bash uses command; write/edit use path or file_path", () => {
    expect(extractApprovalSubject("Bash", { command: "echo hi" })).toBe("echo hi");
    expect(extractApprovalSubject("write", { path: "src/a.ts" })).toBe("src/a.ts");
    expect(extractApprovalSubject("EDIT", { file_path: "lib/x.dart" })).toBe("lib/x.dart");
    expect(extractApprovalSubject("bash", { path: "nope" })).toBeNull();
    expect(extractApprovalSubject("read", { path: "x" })).toBeNull();
  });

  test("explicit pattern wins over derived subject", () => {
    expect(deriveApprovalPattern("bash", { command: "echo hi" }, "echo *")).toBe("echo *");
    expect(deriveApprovalPattern("bash", { command: "echo hi" })).toBe("echo hi");
    expect(deriveApprovalPattern("bash", { command: "echo hi" }, "  ")).toBe("echo hi");
  });
});

describe("pattern matching", () => {
  test("bash prefix matches at a token boundary", () => {
    expect(patternMatches("bash", "echo", "echo")).toBe(true);
    expect(patternMatches("bash", "echo", "echo hello")).toBe(true);
    expect(patternMatches("bash", "echo", "echohello")).toBe(false);
    expect(patternMatches("bash", "ls", "lsusb")).toBe(false);
  });

  test("bash glob matches the command string", () => {
    expect(patternMatches("bash", "echo *", "echo hello")).toBe(true);
    expect(patternMatches("bash", "echo *", "echo hello world")).toBe(true);
    expect(patternMatches("bash", "echo *", "echo rm -rf /")).toBe(true);
    expect(patternMatches("bash", "echo *", "printf hello")).toBe(false);
  });

  test("write/edit use path glob; tool name is case-insensitive", () => {
    expect(patternMatches("write", "src/**", "src/a.ts")).toBe(true);
    expect(patternMatches("Write", "src/**", "src/nested/b.ts")).toBe(true);
    expect(patternMatches("edit", "src/**", "lib/a.ts")).toBe(false);
    expect(patternMatches("edit", "app/lib/foo.dart", "app/lib/foo.dart")).toBe(true);
    expect(globMatch("*.ts", "foo.ts")).toBe(true);
    expect(globMatch("*.ts", "src/foo.ts")).toBe(false);
  });

  test("deny wins when both allow and deny match", () => {
    const decision = matchRules(
      [
        { tool: "bash", pattern: "echo *", decision: "allow" },
        { tool: "bash", pattern: "echo rm *", decision: "deny" },
      ],
      "bash",
      "echo rm -rf /",
    );
    expect(decision).toBe("deny");
  });

  test("upsert replaces the same tool+pattern", () => {
    const next = upsertRule(
      [{ tool: "bash", pattern: "echo *", decision: "allow" }],
      { tool: "BASH", pattern: "echo *", decision: "deny" },
    );
    expect(next).toEqual([{ tool: "bash", pattern: "echo *", decision: "deny" }]);
  });
});

describe("approvals.json store", () => {
  test("memory store never touches disk", () => {
    const store = ApprovalStore.memory();
    store.add({ tool: "bash", pattern: "echo", decision: "allow" });
    expect(store.path()).toBeNull();
    expect(store.match("bash", "echo hi")).toBe("allow");
  });

  test("disk store persists, chmod 0600, and reloads", () => {
    const path = tmpFile();
    const first = ApprovalStore.disk(path);
    first.add({ tool: "write", pattern: "src/**", decision: "allow" });
    first.add({ tool: "bash", pattern: "echo *", decision: "deny" });

    const raw = readFileSync(path, "utf8");
    const parsed = JSON.parse(raw) as { version: number; rules: unknown[] };
    expect(parsed.version).toBe(1);
    expect(parsed.rules).toHaveLength(2);
    expect(statSync(path).mode & 0o777).toBe(0o600);

    const reloaded = ApprovalStore.disk(path);
    expect(reloaded.match("WRITE", "src/a.ts")).toBe("allow");
    expect(reloaded.match("bash", "echo hi")).toBe("deny");
    expect(reloaded.match("bash", "ls")).toBeNull();
  });

  test("corrupt or partial files load as empty / skip bad rows", () => {
    const path = tmpFile();
    writeFileSync(path, "{not-json");
    expect(ApprovalStore.disk(path).snapshot()).toEqual([]);

    const path2 = tmpFile("partial.json");
    writeFileSync(path2, JSON.stringify({
      version: 1,
      rules: [
        { tool: "bash", pattern: "echo *", decision: "allow" },
        { tool: "write", pattern: "x", decision: "maybe" },
        { foo: 1 },
      ],
    }));
    expect(parseApprovalsFile(JSON.parse(readFileSync(path2, "utf8"))).rules).toEqual([
      { tool: "bash", pattern: "echo *", decision: "allow" },
    ]);
  });

  test("atomic write replaces a previous file", () => {
    const path = tmpFile();
    writeFileSync(path, '{"version":1,"rules":[]}');
    chmodSync(path, 0o644);
    const store = ApprovalStore.disk(path);
    store.add({ tool: "edit", pattern: "app/**", decision: "allow" });
    expect(statSync(path).mode & 0o777).toBe(0o600);
    expect(store.snapshot()).toEqual([
      { tool: "edit", pattern: "app/**", decision: "allow" },
    ]);
  });
});
