---
name: compliance-guard
description: "Validate specs, APIs, data models, architectures, ADRs, and generated artifacts against organizational or architectural rules; use when checking compliance, enforcing governance, validating against rules, policy enforcement, or checking constraint violations."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - compliance-guard
  - validate against rules
  - check compliance
  - policy enforcement
  - enforce governance
  - constraint violations
  - check against standards
  - validate architecture
  - validate API spec
  - validate data model
  - rule validation
  - compliance check
---

# Compliance Guard

## Purpose

Use this skill to validate artifacts (specs, API contracts, data models, architectures, ADRs, workflows, generated code) against a defined set of organizational or architectural rules. The skill produces structured compliance verdicts that distinguish blocking violations from warnings, support waiver workflows, and provide rule-level traceability.

This skill is domain-generic. It must work for any software system, API design, data model, or architecture without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Validate an artifact against a rule catalog or compliance checklist.
- Check if a spec, API, or architecture violates organizational constraints.
- Enforce naming conventions, structural patterns, or architectural principles.
- Run a compliance gate before approving an artifact for implementation.
- Audit generated code or synthetic artifacts for rule adherence.
- Identify which rules pass, which warn, and which fail.
- Recommend waivers or exceptions when a rule cannot be met.

Do not use this skill to invent governance rules, define organizational policy from scratch, or perform general quality review (use `reviewer` for that). This skill evaluates against provided or inferred rules — it does not define them unilaterally.

## Core Operating Rules

1. **Never invent governance.** If the user does not provide rules, ask for them before proceeding. Only infer universally common standards when the user explicitly requests inference.
2. **Classify every rule correctly.** Distinguish `constraint` (hard requirement), `convention` (agreed pattern), and `policy` (organizational rule with possible exceptions). Misclassification leads to wrong verdicts.
3. **Three-level verdict only.** Use `pass`, `pass with warnings`, or `fail` for each rule. Add `not verifiable` when evidence is insufficient to evaluate.
4. **Distinguish blocking from warnable.** Constraint violations are blocking; convention violations may be warnings; policy violations depend on waiver status.
5. **Recommend waivers when relevant.** If a rule cannot be met, suggest a waiver with rationale and traceability reference rather than failing silently.
6. **Be evidence-based.** Reference the specific artifact section, line, or pattern that triggered each finding.
7. **Use unique rule IDs.** Every rule has an ID (e.g., `API-001`, `ARCH-002`, `DATA-003`) for traceability.
8. **Preserve existing compliance state.** Acknowledge what passes correctly — a compliance review is not only about failures.

## Rule Classification

| Class | Definition | Verdict Impact |
| --- | --- | --- |
| **constraint** | Hard architectural or technical requirement that must never be violated. Zero tolerance. | Any violation = `fail` (blocking) |
| **convention** | Agreed pattern, style, or structural rule. Violations are warnings unless explicitly elevated to constraint. | Violation = `pass with warnings` (non-blocking unless user elevates) |
| **policy** | Organizational rule that may have documented exceptions or waivers. | Violation = `fail` unless a valid waiver reference is provided |

## Verdict Definitions

| Verdict | Meaning | Blocking? |
| --- | --- | --- |
| **pass** | Rule is satisfied. No action required. | No |
| **pass with warnings** | Rule is satisfied but has concerns (suboptimal pattern, incomplete evidence, edge case). | No — but should be addressed |
| **fail** | Rule is violated. Must be resolved or waived before proceeding. | Yes — blocks approval |
| **not verifiable** | Insufficient evidence in the artifact to evaluate this rule. Do not assume pass or fail. | No — but must be resolved before final approval |

## Verdict Aggregation

| Condition | Overall Verdict |
| --- | --- |
| All rules pass | `pass` |
| Any rule fails | `fail` (blocking) |
| No failures, any warnings | `pass with warnings` |
| Any `not verifiable` | `pass with warnings` (cannot close compliance gate) |
| Any constraint fails | `fail` regardless of other results |

## Rule Catalog Format

A rule catalog is a YAML list of rules. Each rule has:

```yaml
- id: "API-001"           # Unique ID (prefix categorizes: API, ARCH, DATA, OPS, NOMEN, etc.)
  class: constraint        # constraint | convention | policy
  description: "RFC 7807 problem responses"
  check: |
    Every error response MUST use RFC 7807 application/problem+json format.
    Must include "type", "title", "status", "detail", and may include "instance".
  severity: blocking       # blocking | warning — only for convention/policy
  example_good: |
    {"type": "https://example.com/probs/tenant-not-found", "title": "Tenant not found", "status": 404, "detail": "Tenant 'acme' does not exist"}
  example_bad: |
    {"error": "Tenant not found"}
  reference: "RFC 7807"   # Optional: external standard, ADR, or policy doc
```

When the user provides a catalog, apply it as-is. Do not modify rule definitions.

## Inference Rules (Only When Explicitly Requested)

If the user says "infer common standards" or "apply default rules", apply the following universally common rules only:

| ID | Class | Rule | Rationale |
| --- | --- | --- | --- |
| API-001 | constraint | RFC 7807 problem+json for all error responses | Interoperability |
| API-002 | constraint | Idempotency key required for all mutating operations | Safety under retry |
| API-003 | constraint | Timeout must be specified for all external calls | Resilience |
| ARCH-001 | constraint | No circular module dependencies | Maintainability |
| DATA-001 | constraint | Multi-tenant entities must include tenant_id | Tenant isolation |
| OPS-001 | convention | Healthcheck endpoint at /health | Operability |
| OPS-002 | convention | Retry with exponential backoff for transient failures | Resilience |
| NOMEN-001 | convention | kebab-case for URL paths, snake_case for JSON fields | Consistency |

Never infer constraint rules beyond the list above. Never infer policy rules.

## Evaluation Procedure

### Phase 1: Intake

1. Identify the artifact type (spec, API contract, data model, architecture, ADR, workflow, generated code).
2. Confirm whether the user provided a rule catalog.
   - If yes: load and apply the catalog.
   - If no: ask for the rule catalog. Do not proceed without rules unless the user explicitly requests inference.
3. Note which rules are verifiable with the provided evidence.

### Phase 2: Rule-by-Rule Evaluation

For each rule in the catalog:

1. Locate relevant content in the artifact.
2. Evaluate against the rule's check condition.
3. Assign verdict: `pass`, `pass with warnings`, `fail`, or `not verifiable`.
4. Record evidence (quote the specific section or pattern that triggered the finding).
5. If `fail` and a waiver is plausible, note the waiver recommendation.

### Phase 3: Synthesis

1. Aggregate per-rule verdicts to overall verdict.
2. List blocking failures first.
3. List warnings with context.
4. List `not verifiable` rules with explanation.
5. Produce the structured compliance report.

## Required Output Structure

```markdown
# Compliance Report: <Artifact Name>

## 1. Verdict

**Overall:** <pass | pass with warnings | fail>

<One-paragraph summary: how many rules passed, failed, warned, not verifiable.>

## 2. Compliance Summary

| Rule ID | Class | Rule Description | Verdict | Evidence |
| --- | --- | --- | --- | --- |
| API-001 | constraint | RFC 7807 problem responses | pass | §4.2 uses correct format |
| ARCH-001 | constraint | No circular dependencies | fail | Module A → Module B → Module C → Module A |
| OPS-001 | convention | Healthcheck endpoint | pass | GET /health returns 200 |
| DATA-001 | constraint | Multi-tenant tenant_id | not verifiable | No entity definitions present |
```

## 3. Blocking Violations

| ID | Rule | Evidence | Fix Required |
| --- | --- | --- | --- |
| ARCH-001 | No circular dependencies | Module payments → ledger → billing → payments | Break cycle: extract shared module |
```

## 4. Warnings and Recommendations

| ID | Rule | Concern | Suggested Action |
| --- | --- | --- | --- |
| OPS-003 | Retry backoff | Exponential backoff not defined | Add jittered exponential backoff with circuit breaker |
| NOMEN-002 | Field naming | Mixed snake_case and camelCase | Standardize to snake_case |
```

## 5. Not Verifiable Rules

| ID | Rule | Why Not Verifiable | Needed Evidence |
| --- | --- | --- | --- |
| DATA-001 | Multi-tenant tenant_id | No entity schema present | Provide entity definitions or data model |
```

## 6. Waiver Recommendations

| ID | Rule | Justification | Traceability Reference |
| --- | --- | --- | --- |
| API-010 | Sync-only API | Vendor requires synchronous response; async not supported by protocol | ADR-042, Waiver-2024-017 |
```

## 7. Rule Catalog Applied

| Rule ID | Category | Source |
| --- | --- | --- |
| API-001 | RFC 7807 compliance | User-provided catalog |
| ARCH-001 | No circular deps | Inferred common standard |
| DATA-001 | Tenant isolation | User-provided catalog |

## 8. Quality Checklist

| Check | Status |
| --- | --- |
| Every rule has a verdict | ✅ |
| Every fail has evidence | ✅ |
| Waiver candidates flagged | ✅ |
| Not verifiable rules explained | ✅ |
| Output in English | ✅ |
| No invented rules (without inference request) | ✅ |
```

## Rule ID Prefixes

Use these prefixes for consistent categorization:

| Prefix | Category |
| --- | --- |
| `API-` | API contracts, HTTP semantics, error formats, versioning |
| `ARCH-` | Architecture, module dependencies, system design |
| `DATA-` | Data models, entity schemas, tenant isolation, persistence |
| `OPS-` | Observability, healthchecks, retries, timeouts, circuit breakers |
| `NOMEN-` | Naming conventions, terminology, URL structure, field formats |
| `SEC-` | Security, auth, authorization, data protection |
| `WORKFLOW-` | Process, state machines, orchestration, workflow definitions |
| `ADR-` | Architecture Decision Records (checks ADR conventions) |

## Example Rule Catalog (YAML)

```yaml
rules:
  - id: "API-001"
    class: constraint
    description: "RFC 7807 problem+json for all error responses"
    check: "Every error response MUST use RFC 7807 application/problem+json format with type, title, status, detail."
    severity: blocking
    reference: "RFC 7807"

  - id: "API-002"
    class: constraint
    description: "Idempotency keys on mutating operations"
    check: "All POST, PUT, PATCH requests MUST accept an Idempotency-Key header and be safely retryable."
    severity: blocking

  - id: "API-003"
    class: constraint
    description: "Timeout on external calls"
    check: "Every call to an external service or database MUST specify a timeout."
    severity: blocking

  - id: "ARCH-001"
    class: constraint
    description: "No circular module dependencies"
    check: "Module dependency graph must be acyclic. No module may transitively import itself."
    severity: blocking

  - id: "ARCH-002"
    class: constraint
    description: "No synchronous blocking calls in async contexts"
    check: "In async service contexts, external calls must be non-blocking. Sync-over-async patterns are forbidden."
    severity: blocking
    reference: "Ops policy OP-03"

  - id: "DATA-001"
    class: constraint
    description: "Multi-tenant entities include tenant_id"
    check: "Every entity accessible across tenants MUST have a tenant_id field as the first attribute."
    severity: blocking

  - id: "OPS-001"
    class: convention
    description: "Healthcheck endpoint"
    check: "Service MUST expose a GET /health endpoint returning 200 when healthy."
    severity: warning

  - id: "OPS-002"
    class: convention
    description: "Retry with exponential backoff"
    check: "Transient failures MUST be retried with exponential backoff and jitter."
    severity: warning

  - id: "OPS-003"
    class: convention
    description: "Observability: structured logging"
    check: "All service logs MUST be structured (JSON) with trace_id, span_id, tenant_id where applicable."
    severity: warning

  - id: "NOMEN-001"
    class: convention
    description: "URL paths use kebab-case"
    check: "URL path segments MUST use kebab-case (e.g., /user-profiles, not /userProfiles or /user_profiles)."
    severity: warning

  - id: "NOMEN-002"
    class: convention
    description: "JSON fields use snake_case"
    check: "JSON request/response fields MUST use snake_case (e.g., created_at, not createdAt)."
    severity: warning
```

## Present Results to User

Lead with the overall verdict and the count of blocking failures. Present blocking violations first with clear evidence and required fixes. Then present warnings with suggested actions. If waivers are recommended, explain why and provide the traceability reference format the user should complete.

If any rules are `not verifiable`, explain what evidence is needed to close the compliance gate and ask whether to proceed with what can be verified or wait for complete evidence.

## Troubleshooting

- **No rules provided:** Ask the user for a rule catalog before proceeding. Do not invent governance.
- **Artifact is too large:** Ask which sections or rule categories to prioritize. Apply rules in order of severity (constraint > policy > convention).
- **Rule conflicts with evidence:** Re-examine the artifact section. If the rule genuinely cannot be evaluated, mark `not verifiable` with the specific reason.
- **Waiver candidate identified:** Flag it in the report with recommendation. Do not assume the waiver is granted.
- **User asks to "check everything":** Ask for a rule catalog or confirm which common rule sets to apply. Do not evaluate against rules the user has not seen or approved.
- **Rule inference requested:** Apply only the inferred common standards table above. Do not add constraint-level rules beyond that list. State clearly which rules were inferred.

(End of file — total 471 lines)