---
name: validation-strategist
description: "Design layered validation and verification strategies for software artifacts. Trigger: when designing a validation plan, QA strategy, release gates, verification layers, test strategy, entry/exit criteria, or multi-layer quality assurance."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - validation-strategist
  - validation strategy
  - design validation
  - verification layers
  - release gates
  - entry criteria
  - exit criteria
  - test strategy
  - multi-layer validation
  - integration validation
  - QA flow design
  - release readiness
  - validation and verification
---

# Validation Strategist

## Purpose

Use this skill to design a **multi-layer validation and verification strategy** for any software artifact or release. The output is a structured plan that maps what to validate at each layer, which environments and evidence are required, and what gates must pass before progressing.

This skill is domain-generic. It must work for PRDs, SDDs, RFCs, ADRs, ACs, NFRs, architectures, OpenAPI specs, workflows, and release plans without embedding project-specific assumptions.

## Core Distinction: Verification vs Validation

| Term | Definition | Focus |
| --- | --- | --- |
| **Verification** | "Did we build it right?" — checks implementation matches design. | Artifacts, traces, constraints |
| **Validation** | "Did we build the right thing?" — checks product meets user needs. | Outcomes, business value, real-world behavior |

A complete strategy uses **both**. Verification gives confidence in correctness; validation gives confidence in correctness.

## The Five Validation Layers

Design validation across these five layers, from narrowest to widest scope:

### Layer 1 — Unit
- **What**: Individual functions, methods, classes in isolation
- **Evidence**: Unit tests, code coverage, linting, type checks
- **Gates**: All tests pass; coverage above threshold; no critical lints
- **Metrics**: Pass rate, coverage %, cyclomatic complexity

### Layer 2 — Component
- **What**: Integration between modules within a service or package
- **Evidence**: Integration tests, contract tests, module-level mocks
- **Gates**: Component tests pass; contracts between modules verified
- **Metrics**: Integration pass rate, contract compliance

### Layer 3 — Feature
- **What**: End-to-end behavior of a single feature or user story
- **Evidence**: Feature tests, API contract tests, UI automation, Given/When/Then scenarios
- **Gates**: Feature acceptance criteria met; all happy and sad paths covered
- **Metrics**: Feature test pass rate, scenario coverage, critical path coverage

### Layer 4 — Application
- **What**: Multiple features working together across services
- **Evidence**: System tests, end-to-end tests, performance benchmarks, security scans
- **Gates**: Cross-feature flows work; NFRs met; security scan clean
- **Metrics**: System test pass rate, p99 latency, error rate, security findings

### Layer 5 — Release Candidate
- **What**: The deliverable in a production-like environment
- **Evidence**: Staging deployment, smoke tests, manual QA, canary rollout, rollback test
- **Gates**: Rollback procedure verified; monitoring and alerting operational; feature flags active; business metrics within expected range
- **Metrics**: Deployment success rate, time-to-production-ready, rollback success rate

## Layer Selection Principle

**Always prefer the lowest layer that gives enough signal.**

If Layer 1 unit tests prove correctness, do not require Layer 4 system tests for that specific check. Higher layers are slower, more expensive, and harder to debug. Reserve them for what lower layers cannot catch:
- Cross-service interactions → Layer 3–4
- User-facing flows → Layer 4–5
- Critical-path flows → Layer 5 (E2E reserved for flows where failure is catastrophic)

## E2E Abuse Prevention

End-to-end tests are a **limited resource**. Use them only when:
- The flow spans multiple services or domains.
- The consequence of failure is severe (data loss, security breach, financial impact).
- Lower-layer tests cannot simulate the failure mode.

If a flow can be validated at Layer 3 or 4 with reliable automation, do not add a Layer 5 E2E test.

## Validation Triggers and Environments

| Trigger | Environment | Evidence Required |
| --- | --- | --- |
| Code commit / PR | CI pipeline (isolated) | Unit + component tests; lint; type check |
| Feature complete | Feature environment | Feature tests; contract tests |
| Release candidate build | Staging / pre-production | System tests; smoke tests; security scan |
| Canary / production rollout | Production | Live metrics; error rates; business KPIs |
| Hotfix | Production with expedited gate | Targeted unit + integration tests; smoke suite |

## Entry and Exit Criteria per Layer

For each active layer, define:

**Entry criteria** — what must be true before running validation at this layer:
- Prior layers passed and gates closed.
- Required test artifacts exist and are passing.
- Environment is stable and isolated.

**Exit criteria** — what must be true to consider this layer passed:
- All gates passed with evidence attached.
- No open critical or high severity findings.
- Metrics within defined thresholds.

## Release Readiness Checklist

At Layer 5 (Release Candidate), validate all of the following before promoting to production:

| Check | Criteria |
| --- | --- |
| Unit + Component layers | All gates closed |
| Feature layer | All acceptance criteria verified |
| Application layer | NFRs met (performance, security, scalability) |
| Smoke test suite | 100% pass in staging |
| Rollback procedure | Documented, tested, and team knows the steps |
| Monitoring + alerting | All critical paths monitored; alerts firing correctly |
| Feature flags | Kill switches and rollbacks configured |
| Business metrics | Baseline metrics established for comparison post-release |
| Go/no-go decision | Authorized by defined stakeholder |

## Input Artifact Mapping

Adapt the validation strategy based on what artifact is provided:

| Artifact | Primary Validation Focus |
| --- | --- |
| **PRD** | Validation: does the product solve the stated problem? Trace requirements to acceptance criteria. |
| **SDD / Spec** | Verification: does implementation match spec? Trace REQs to test cases. |
| **RFC / Architecture** | Verification: does implementation follow the approved design? Trace decisions to components. |
| **ADR** | Verification: was the decision applied correctly? Trace decision to implemented behavior. |
| **AC (Acceptance Criteria)** | Verification: do tests prove ACs are met? Map each AC to test case. |
| **NFR (Non-Functional Requirements)** | Verification: do benchmarks prove NFRs are met? Measure and report. |
| **OpenAPI / API Contract** | Verification: do contract tests prove API matches spec? Use contract testing. |
| **Workflow** | Verification: does the implementation follow the state machine? Trace transitions to test scenarios. |
| **Release Plan** | Validation + Verification: can we ship safely? Apply full Layer 5 checklist. |

## Validation Strategy Output Structure

```markdown
# Validation Strategy: <Artifact Name>

## 1. Scope and Context
- Artifact type: <PRD / SDD / RFC / ADR / AC / NFR / OpenAPI / Workflow / Release Plan>
- Validation goal: <what we need to prove>
- Active layers: <which of the 5 layers apply>

## 2. Verification vs Validation Split
- Verification checks: <list>
- Validation checks: <list>

## 3. Layer-by-Layer Plan
| Layer | What to Validate | Evidence | Gates | Metrics |
| --- | --- | --- | --- | --- |

## 4. E2E Justification
- Critical flows requiring E2E: <list>
- Why lower layers are insufficient for each: <reason>

## 5. Environment and Trigger Map
| Trigger | Environment | Evidence |
| --- | --- | --- |

## 6. Entry/Exit Criteria
| Layer | Entry Criteria | Exit Criteria |
| --- | --- | --- |

## 7. Release Readiness (Layer 5 only)
| Check | Status | Notes |
| --- | --- | --- |
| Unit + Component gates closed | ✅/❌ | |
| Feature ACs verified | ✅/❌ | |
| NFRs met | ✅/❌ | |
| Smoke tests pass | ✅/❌ | |
| Rollback tested | ✅/❌ | |
| Monitoring active | ✅/❌ | |
| Go/no-go authorized | ✅/❌ | |

## 8. QA Flow Summary
<One-paragraph description of the end-to-end QA flow from commit to production>
```

## Quality Bar

Before presenting the validation strategy, verify:
- Verification and validation are treated as distinct activities with separate outputs.
- The lowest-layer principle is applied: no layer used beyond what it can meaningfully prove.
- E2E tests are justified and limited to critical paths.
- All five layers are evaluated; inactive layers are explicitly excluded with rationale.
- Entry and exit criteria are concrete and evidence-attached.
- The strategy is generic: no vendor names, project names, or concrete technology names unless essential.

## Troubleshooting

- **User provides no artifact type:** Ask for the artifact type or the primary deliverable being validated before designing the strategy.
- **All five layers requested for a simple change:** Apply the lowest-layer principle strictly. A one-line bug fix may only need Layer 1 evidence.
- **E2E tests are the only evidence available:** Flag this as a risk. E2E is slow, brittle, and expensive to maintain. Recommend building lower-layer test coverage.
- **No defined NFRs or ACs:** Treat this as a gap — the strategy should note that entry/exit criteria cannot be verified without defined thresholds.
- **Conflicting evidence from different layers:** Investigate the discrepancy. Lower-layer failures may indicate an environment issue; higher-layer failures always take priority.
