# 4R Dimensions — Detailed Checklists

Read this before running the 4R passes. Each dimension has alert signals, a checklist, and an acceptance criterion. The AI failure patterns at the end apply across all four dimensions and deserve priority when reviewing agent-generated code.

## 1. Risk

**Central question:** Does this change add disproportionate risk to security, production, or sensitive zones?

### Alert signals
- Touches authentication, authorization, sessions, cryptography, secrets, payments, sensitive data, or admin flows.
- Introduces new integrations, queries, file manipulation, system commands, or external resource access.
- Changes behavior on critical business paths or components likely to affect production.
- Ships a fix with no feature flag, validation, limit, rollback, or visible guardrail.

### Checklist
- Does the change cross new trust boundaries or modify existing controls?
- Does it validate input on the server, not only on the client?
- Does it prevent injection, secret exposure, privilege escalation, and sensitive-data leakage?
- Did the attack surface grow even if the change looks small?
- Are there safe defaults, restrictions, rate limits, or equivalent controls where applicable?
- Is there a rollout / rollback / isolation strategy for high-impact changes?

### Acceptance
Accept only when residual risk is explicit, bounded, and proportional to the benefit. If the change touches a sensitive zone without sufficient safeguards, block or escalate to specialized review.

## 2. Readability

**Central question:** Can another engineer understand, maintain, and modify this without reconstructing the author's or agent's intent?

### Alert signals
- Long functions or modules mixing multiple responsibilities.
- Generic names, comments that restate the code, or abstractions hiding simple logic.
- Duplication, excessive branching, implicit state, or hard-to-follow flow.
- AI slop: compiles and looks useful, but is inflated, inconsistent, or needlessly complex.

### Complexity budget
Treat complexity as a budget, not a side effect. Each change spends budget via branches, state, new integration, new config, and cognitive surface. If the cost rises, demand simplification, splitting the change, or better encapsulation.

### Checklist
- Is the main flow understandable without unnecessary mental jumps?
- Do names express intent and domain precisely?
- Does the structure respect reasonable responsibilities and clear boundaries?
- Could it be solved with less branching, less nesting, or less abstraction?
- Was "temporary" maintenance debt introduced with no ticket, context, or limit?
- Does the diff read as a coherent unit of change, or as an AI-generated collage?

### Acceptance
Accept only when an outsider to the original implementation can understand it and the area's complexity budget is not exceeded. If it works but is a hard-to-operate mess, return to iteration.

## 3. Reliability

**Central question:** Is there real evidence the change works under normal conditions and predictable edges?

### Alert signals
- No new tests where the change warrants them.
- Cosmetic coverage only, without validating domain invariants.
- Errors caught but not handled explicitly.
- No timeout, cancellation, or limit for external or expensive operations.

### Checklist
- Is there executable evidence the change does what it claims?
- Do tests cover the happy path, relevant edges, and expected failures?
- Would the tests actually fail if a bug were introduced, or do they just touch lines?
- Are mocks testing real behavior, or only wiring?
- Are invalid inputs, boundary states, and dependency errors modeled explicitly?
- Are timeouts, cancellation, idempotency, or sane limits present on remote/retryable operations?
- Do errors return actionable signals without leaking sensitive information?

### Acceptance
Accept only when evidence is sufficient to trust the behavior and critical paths are proven, not assumed. A change without relevant tests is acceptable only if risk is low, the reason is documented, and another strong validation exists.

## 4. Resilience

**Central question:** When this fails, does the system recover, degrade gracefully, or propagate the damage?

### Alert signals
- Remote dependency with no timeout or retry policy.
- Infinite or no-backoff retries that can cause retry storms.
- A local error that escalates to a global flow failure.
- Missing logs, metrics, or traces to understand incidents.

### Checklist
- What happens exactly if the dependency fails, responds slowly, or returns invalid data?
- Is there an explicit timeout appropriate to the context?
- Do retries have a limit, backoff, and an idempotency criterion?
- Is there graceful degradation, fallback, or failure isolation where applicable?
- Is there minimal useful observability: logs with context, metrics, traces, or equivalent events?
- Can a local failure cascade through coupling, shared state, or absence of bulkheads?

### Acceptance
Accept only when failure behavior is explicit, visible, and operable. If the design assumes permanent success or turns a partial failure into a systemic outage, it fails the 4R standard.

## AI Failure Patterns (priority for agent-generated code)

Agent code passes the eye test and fails differently than human code. Check these explicitly:

- **Hallucinated APIs / imports:** invented functions, wrong package, stray imports, dependency versions that do not exist.
- **Scope creep:** edits to files outside the task, unrequested behavior changes, reformatting unrelated code.
- **Happy-path bias:** core logic works; null/undefined on optional fields, empty results vs error, boundary values, timeouts vs connection-refused vs DNS failure, race conditions, and partial failures in batch operations are missed.
- **Hardcoded values:** literals, credentials, URLs, or magic numbers that should be config or parameters.
- **Test theater:** tests that mirror the implementation, assert only `toBeDefined`, over-mock, or would not fail if a bug were introduced.
- **Pattern drift:** imports a pattern from elsewhere instead of following existing codebase conventions; duplicates logic that already exists instead of reusing it.
- **Swallowed errors:** caught and logged-then-ignored, or fails open on unexpected input (especially in token/session validation).

## Severity Heuristics

- **Blocker:** probable vulnerability, data loss, critical regression, total absence of control in a sensitive zone, plausible cascade, change impossible to operate.
- **High:** insufficient tests on a critical flow, missing timeout, incorrect retry, excessive complexity in core logic, poor logging/observability at a critical point.
- **Medium:** improvable readability, bounded uncovered edge case, documentable debt without immediate impact.
- **Low:** naming, minor structure, non-critical simplification.
