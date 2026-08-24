import { mkdtempSync, readFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterEach, describe, expect, test } from "vitest";
import { ApprovalStore } from "./approval_memory.js";
import {
  denialMessage,
  isGatedTool,
  isReadOnlyTool,
  normalizeToolName,
  ToolApprovalGate,
} from "./tool_approval.js";

describe("tool classification", () => {
  test("read / glob / grep are read-only regardless of casing", () => {
    expect(isReadOnlyTool("read")).toBe(true);
    expect(isReadOnlyTool("Read")).toBe(true);
    expect(isReadOnlyTool("GLOB")).toBe(true);
    expect(isReadOnlyTool(" grep ")).toBe(true);
    expect(isReadOnlyTool("bash")).toBe(false);
    expect(isReadOnlyTool("agent_send")).toBe(false);
  });

  test("bash / write / edit are gated regardless of casing", () => {
    expect(isGatedTool("bash")).toBe(true);
    expect(isGatedTool("Bash")).toBe(true);
    expect(isGatedTool("WRITE")).toBe(true);
    expect(isGatedTool("Edit")).toBe(true);
    expect(isGatedTool("read")).toBe(false);
    expect(isGatedTool("ask_user")).toBe(false);
    expect(isGatedTool("agent_send")).toBe(false);
  });

  test("normalizeToolName trims and lowercases", () => {
    expect(normalizeToolName("  Bash ")).toBe("bash");
  });
});

describe("ToolApprovalGate", () => {
  const gates: ToolApprovalGate[] = [];
  afterEach(() => {
    for (const gate of gates) gate.reset();
    gates.length = 0;
  });

  function makeGate(timeoutMs = 5_000): ToolApprovalGate {
    const gate = new ToolApprovalGate(timeoutMs);
    gates.push(gate);
    return gate;
  }

  test("allow settles a waiting tool_call", async () => {
    const gate = makeGate();
    const pending = gate.wait("tc_allow");
    expect(gate.pendingCount()).toBe(1);
    expect(gate.decide("tc_allow", "allow")).toBe(true);
    await expect(pending).resolves.toBe("allow");
    expect(gate.pendingCount()).toBe(0);
  });

  test("deny settles a waiting tool_call", async () => {
    const gate = makeGate();
    const pending = gate.wait("tc_deny");
    expect(gate.decide("tc_deny", "deny")).toBe(true);
    await expect(pending).resolves.toBe("deny");
  });

  test("timeout treats a missing approve_tool as deny", async () => {
    const gate = makeGate(15);
    await expect(gate.wait("tc_to")).resolves.toBe("timeout");
    expect(gate.pendingCount()).toBe(0);
  });

  test("first decision wins; later approve_tool is ignored", async () => {
    const gate = makeGate();
    const pending = gate.wait("tc_first");
    expect(gate.decide("tc_first", "deny")).toBe(true);
    expect(gate.decide("tc_first", "allow")).toBe(false);
    await expect(pending).resolves.toBe("deny");
    expect(gate.decide("tc_first", "allow")).toBe(false);
  });

  test("approve_tool arriving before tool_call is applied once", async () => {
    const gate = makeGate();
    expect(gate.decide("tc_pre", "allow")).toBe(true);
    expect(gate.decide("tc_pre", "deny")).toBe(false);
    await expect(gate.wait("tc_pre")).resolves.toBe("allow");
    expect(gate.pendingCount()).toBe(0);
  });

  test("rejectAll settles leftover waiters", async () => {
    const gate = makeGate();
    const pending = gate.wait("tc_stop");
    gate.rejectAll("deny");
    await expect(pending).resolves.toBe("deny");
    expect(gate.pendingCount()).toBe(0);
  });

  test("denialMessage maps timeout vs user deny", () => {
    expect(denialMessage("timeout")).toMatch(/timed out/i);
    expect(denialMessage("deny")).toMatch(/denied/i);
  });

  test("omitted scope is once: next matching call still waits", async () => {
    const gate = makeGate();
    const first = gate.wait("tc_once_a", { tool: "bash", args: { command: "echo hi" } });
    expect(gate.decide("tc_once_a", "allow")).toBe(true);
    await expect(first).resolves.toBe("allow");

    const second = gate.wait("tc_once_b", { tool: "bash", args: { command: "echo hi" } });
    expect(gate.pendingCount()).toBe(1);
    expect(gate.decide("tc_once_b", "deny")).toBe(true);
    await expect(second).resolves.toBe("deny");
  });

  test("session remembers the same pattern for the rest of this gate", async () => {
    const gate = makeGate();
    const first = gate.wait("tc_sess_a", { tool: "bash", args: { command: "echo hi" } });
    expect(gate.decide("tc_sess_a", "allow", { scope: "session" })).toBe(true);
    await expect(first).resolves.toBe("allow");
    expect(gate.sessionRuleCount()).toBe(1);

    await expect(
      gate.wait("tc_sess_b", { tool: "Bash", args: { command: "echo hi there" } }),
    ).resolves.toBe("allow");
    expect(gate.pendingCount()).toBe(0);

    const other = gate.wait("tc_sess_c", { tool: "bash", args: { command: "ls" } });
    expect(gate.pendingCount()).toBe(1);
    expect(gate.decide("tc_sess_c", "deny")).toBe(true);
    await expect(other).resolves.toBe("deny");
  });

  test("session deny also remembers", async () => {
    const gate = makeGate();
    const first = gate.wait("tc_sd_a", { tool: "write", args: { path: "src/a.ts" } });
    expect(gate.decide("tc_sd_a", "deny", { scope: "session" })).toBe(true);
    await expect(first).resolves.toBe("deny");
    await expect(
      gate.wait("tc_sd_b", { tool: "write", args: { path: "src/a.ts" } }),
    ).resolves.toBe("deny");
  });

  test("always persists to disk and reloads on a fresh gate", async () => {
    const dir = mkdtempSync(join(tmpdir(), "rp-gate-always-"));
    const path = join(dir, "approvals.json");
    const gate = new ToolApprovalGate(5_000, ApprovalStore.disk(path));
    gates.push(gate);

    const first = gate.wait("tc_al_a", { tool: "write", args: { path: "src/a.ts" } });
    expect(gate.decide("tc_al_a", "allow", { scope: "always", pattern: "src/**" })).toBe(true);
    await expect(first).resolves.toBe("allow");

    const saved = JSON.parse(readFileSync(path, "utf8")) as {
      version: number;
      rules: Array<{ tool: string; pattern: string; decision: string }>;
    };
    expect(saved.version).toBe(1);
    expect(saved.rules).toEqual([
      { tool: "write", pattern: "src/**", decision: "allow" },
    ]);

    const reloaded = new ToolApprovalGate(5_000, ApprovalStore.disk(path));
    gates.push(reloaded);
    await expect(
      reloaded.wait("tc_al_b", { tool: "WRITE", args: { path: "src/nested/b.ts" } }),
    ).resolves.toBe("allow");
    expect(reloaded.pendingCount()).toBe(0);
  });

  test("always deny persists and reloads", async () => {
    const dir = mkdtempSync(join(tmpdir(), "rp-gate-always-deny-"));
    const path = join(dir, "approvals.json");
    const gate = new ToolApprovalGate(5_000, ApprovalStore.disk(path));
    gates.push(gate);
    const first = gate.wait("tc_ad_a", { tool: "bash", args: { command: "rm -rf /" } });
    expect(gate.decide("tc_ad_a", "deny", { scope: "always" })).toBe(true);
    await expect(first).resolves.toBe("deny");

    const reloaded = new ToolApprovalGate(5_000, ApprovalStore.disk(path));
    gates.push(reloaded);
    await expect(
      reloaded.wait("tc_ad_b", { tool: "bash", args: { command: "rm -rf / tmp" } }),
    ).resolves.toBe("deny");
  });

  test("pre-decide with session is applied and remembered when wait arrives", async () => {
    const gate = makeGate();
    expect(gate.decide("tc_pre_s", "allow", { scope: "session" })).toBe(true);
    await expect(
      gate.wait("tc_pre_s", { tool: "bash", args: { command: "echo hi" } }),
    ).resolves.toBe("allow");
    await expect(
      gate.wait("tc_pre_s2", { tool: "bash", args: { command: "echo hi" } }),
    ).resolves.toBe("allow");
  });

  test("timeout is unchanged and is not remembered", async () => {
    const gate = makeGate(15);
    await expect(
      gate.wait("tc_to_mem", { tool: "bash", args: { command: "sleep 9" } }),
    ).resolves.toBe("timeout");
    const next = gate.wait("tc_to_mem2", { tool: "bash", args: { command: "sleep 9" } });
    expect(gate.pendingCount()).toBe(1);
    expect(gate.decide("tc_to_mem2", "allow")).toBe(true);
    await expect(next).resolves.toBe("allow");
  });

  test("first decision wins; later scoped approve is ignored", async () => {
    const gate = makeGate();
    const pending = gate.wait("tc_win", { tool: "bash", args: { command: "echo hi" } });
    expect(gate.decide("tc_win", "deny")).toBe(true);
    expect(gate.decide("tc_win", "allow", { scope: "always" })).toBe(false);
    await expect(pending).resolves.toBe("deny");
    expect(gate.sessionRuleCount()).toBe(0);
    expect(gate.alwaysRules()).toEqual([]);
  });
});
