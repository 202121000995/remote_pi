import { afterEach, describe, expect, test } from "vitest";
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
});
