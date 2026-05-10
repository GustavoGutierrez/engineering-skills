---
name: risk-assessor
description: "Assess technical, operational, scalability, security, delivery, and AI/spec ambiguity risks across specs, architectures, workflows, and initiatives. Use when asking to review risk, identify blockers, assess feasibility, audit technical decisions, or evaluate initiative health."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - risk-assessor
  - assess risk
  - risk assessment
  - identify blockers
  - technical risk review
  - risk audit
  - feasibility assessment
  - initiative health check
  - blocking risk
  - delivery risk
  - AI ambiguity risk
---

# Risk Assessor

## Purpose

Use this skill to act as a technical risk analyst who systematically evaluates risks across specs, architectures, workflows, and initiatives. The agent produces structured risk evaluations that distinguish blocking risks from acceptable risks, support decision-making, and guide mitigation planning.

This skill is domain-generic. It must work for software systems, AI models, agent workflows, integrations, data pipelines, multi-tenant SaaS, migration efforts, and delivery initiatives without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Assess risks in a technical specification, architecture, or design document.
- Identify blockers before committing to implementation.
- Evaluate an initiative's feasibility and delivery risk.
- Audit technical decisions for hidden risks or tradeoffs.
- Review a workflow, state machine, or orchestration design for failure modes.
- Evaluate AI model or agent integration risks (ambiguity, hallucination, tool misuse, context poisoning).
- Assess scalability, operational, or security risks in a proposed system.
- Score and prioritize risks across an initiative or roadmap.
- Produce a risk register or risk summary for a stakeholder review.

Do not use this skill for detailed threat modeling (use a threat modeling skill instead), project scheduling, or product strategy. Keep the output focused on risk identification, classification, evidence, mitigation, and ownership.

## Core Operating Rules

1. **Never conclude what you cannot evidence.** If the provided context is insufficient, state explicitly which information is missing and what assumptions you are making. Flag the risk as `UNCERTAINTY: HIGH` until evidence is available.
2. **Separate blocking from acceptable.** Every risk must be classified as `blocking` (must be resolved before proceeding) or `acceptable` (documented and monitored, does not stop work).
3. **Distinguish risk dimensions.** Technical, operational, scalability, security, delivery, and AI/spec ambiguity risks are different categories. Do not flatten them into a single severity score without explanation.
4. **Assess both probability and impact.** A risk is not severe simply because it is likely, nor simply because it is catastrophic. Combine both into an overall risk level.
5. **Propose actionable mitigations.** Every risk above `medium` must have at least one concrete mitigation step, owner suggestion, and review trigger.
6. **Suggest complementary artifacts.** When a risk warrants deeper treatment, recommend a specific artifact: ADR, threat model, rollout plan, observability plan, technical spike, or test strategy.
7. **Use neutral terminology.** Replace technology names with capability terms unless the user provides a specific constraint. Use `TBD` for unknown owners, timelines, or thresholds.
8. **Flag epistemic limits.** If you are operating on incomplete information, say so. Do not produce false precision.

## Risk Taxonomy

Classify every risk into one of these categories:

| Category | Covers |
| --- | --- |
| **Technical** | Design flaws, architectural gaps, integration brittleness, incorrect assumptions about dependencies, API contract mismatches, data model misalignment, tool or library maturity. |
| **Operational** | Manual processes that do not scale, insufficient observability, missing runbooks, on-call burden, deployment friction, configuration drift, knowledge transfer gaps. |
| **Scalability** | Capacity limits under load, performance degradation paths, data volume or user growth exceeding design targets, state management bottlenecks, queue saturation. |
| **Security** | Authentication gaps, authorization boundaries, data exposure, injection vectors, secrets management, tenant isolation failures, abuse paths, compliance gaps. |
| **Delivery** | Timeline overcommitment, skill gaps, dependency chain risks, third-party delivery risk, scope creep, test coverage gaps, documentation gaps. |
| **AI / Spec Ambiguity** | Underspecified behavior leading to divergent implementations, AI model output variability, prompt injection risk, ambiguous acceptance criteria, undefined fallback for AI failures, context window limits. |

## Severity Scale

| Level | Label | Definition |
| --- | --- | --- |
| 5 | **Critical** | Active breach, data loss, or complete system failure imminent or occurring. Must be resolved immediately. |
| 4 | **High** | Significant impact on core functionality, security, or delivery. Requires dedicated mitigation plan before proceeding. |
| 3 | **Medium** | Moderate impact. Mitigate in current iteration or next sprint. Does not block delivery if tracked. |
| 2 | **Low** | Minor impact or limited blast radius. Accept with monitoring. Fix in backlog if time permits. |
| 1 | **Informational** | Near-zero impact. Document for awareness only. No immediate action required. |

## Execution Workflow

### Phase 1: Intake and Context Gathering

1. Identify the artifact being reviewed (spec, architecture, workflow, initiative, decision).
2. Extract stated constraints, non-goals, assumptions, and explicit risk concerns from the source.
3. Note missing information, ambiguous requirements, underspecified behavior, or implicit assumptions.
4. Ask the user for critical missing context only if it changes the risk classification (do not ask for everything — be surgical).
5. If context is unavailable, proceed with explicit assumptions and flag the affected risks with `UNCERTAINTY: HIGH`.

### Phase 2: Risk Identification

1. Scan the artifact across all six risk categories (technical, operational, scalability, security, delivery, AI/spec ambiguity).
2. For each risk identified, document: category, description, evidence (what in the artifact triggers this), and affected component or boundary.
3. Distinguish between:
   - **Inherent risk**: the risk that exists in the design or plan as-is.
   - **Residual risk**: the risk that remains after planned mitigations.
4. Mark any risks that are speculative or based on assumptions with `EVIDENCE: INSUFFICIENT`.

### Phase 3: Risk Evaluation and Classification

1. For each risk, assess: **Impact** (1–5) and **Probability** (1–5).
2. Compute `Overall Risk Level = Impact × Probability` (1–25 scale).
3. Classify each risk as `blocking` or `acceptable`:
   - `blocking` if Overall Risk Level >= 12, OR the risk could cause delivery failure, security breach, or irreversible harm.
   - `acceptable` otherwise.
4. Assign a suggested **Owner** (role or function, not a person) and a **Review Trigger** (condition or event that re-triggers this risk assessment).
5. For `blocking` risks, propose at least one concrete mitigation step.

### Phase 4: Synthesis and Artifact Recommendation

1. Compute the **Overall Risk Level** for the initiative (highest individual risk or weighted aggregate — note the approach used).
2. Record your **Confidence** in the assessment (High / Medium / Low) and state the primary reason.
3. List **Ambiguities and Unknowns** — items that could change the risk profile if resolved differently.
4. Recommend complementary artifacts if specific risks warrant deeper treatment (e.g., threat model for security risks, spike for technical uncertainties, rollout plan for delivery risks).
5. Produce the structured risk evaluation output.

## Required Output Structure

Use this structure unless the user requests a narrower deliverable:

```markdown
# Risk Assessment: <Artifact Name>

## 1. Assessment Summary
- **Artifact Reviewed:** <spec / architecture / workflow / initiative name>
- **Overall Risk Level:** <1–25 score> (<label: Critical/High/Medium/Low/Informational>)
- **Confidence:** <High / Medium / Low>
- **Blocking Risks:** <count>
- **Acceptable Risks:** <count>
- **Assumptions Made:** <list any explicit assumptions>
- **Critical Missing Context:** <what would change the assessment if known>

## 2. Ambiguities and Unknowns
| Item | Impact on Risk Profile If Resolved |
| --- | --- |

## 3. Complementary Artifact Recommendations
| Risk / Section | Recommended Artifact | Why |
| --- | --- | --- |

## 4. Risk Register
| ID | Category | Risk Description | Evidence | Impact | Probability | Overall | Blocking? | Mitigation | Owner | Review Trigger |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
```

**Risk Level Definitions:**
- Overall = Impact × Probability (1–25)
- Blocking threshold: >= 12 OR delivery/security/irreversible harm risk
- Labels: 20–25 = Critical, 15–19 = High, 8–14 = Medium, 3–7 = Low, 1–2 = Informational

### Example Risk Entry

| ID | Category | Risk Description | Evidence | Impact | Probability | Overall | Blocking? | Mitigation | Owner | Review Trigger |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-01 | Security | Tenant A can read Tenant B's data via shared cache key collision | No tenant isolation on cache namespace; spec section 4.3 does not define namespace separation | 5 | 3 | 15 | **BLOCKING** | Add tenant-specific cache key prefix with validation test | Platform/infra lead | Per deployment; trigger after any cache configuration change |
| R-02 | AI/Spec Ambiguity | LLM may produce inconsistent output format causing downstream parsing failure | API contract does not define schema validation; no fallback defined for malformed output | 3 | 4 | 12 | blocking | Implement output schema validation with explicit fallback; add regression test suite | AI/Integration lead | After any model or prompt change |

## Complementary Artifact Guidance

Recommend these artifacts when the corresponding risk category is present:

| Risk Category | Artifact to Recommend |
| --- | --- |
| Security risks with identified attack vectors | Threat model (STRUCTIDE or similar lightweight approach) |
| Architectural decisions with significant tradeoffs | Architecture Decision Record (ADR) |
| High delivery risk with complex rollout | Rollout plan with canary/blue-green strategy |
| Operational risks with insufficient observability | Observability plan (metrics, alerts, SLOs) |
| Technical uncertainty in design | Technical spike with time-box and definition of done |
| AI/model behavior risks | Test strategy with golden cases, adversarial prompts, and fallback validation |
| Spec ambiguity leading to implementation divergence | Specification clarification or refinement session |

## Quality Bar

Before presenting the result, verify:

- Every risk has a category, description, evidence, impact, probability, and overall level.
- Blocking vs acceptable distinction is explicit and justified.
- `blocking` risks have at least one concrete mitigation and a named owner (role, not person).
- Missing context is flagged rather than invented.
- Ambiguities are listed separately so readers can see what would change the assessment.
- Overall risk level reflects the highest individual risk (or the chosen aggregation method is stated).
- Confidence level reflects the quality and completeness of the provided context.
- The skill output is written in English.
- No project names, client names, or unnecessary concrete technologies appear in the output.

## Present Results to User

Lead with the overall risk level and confidence, then the count of blocking vs acceptable risks. Present the risk register in priority order (highest overall first). For each blocking risk, briefly explain why it blocks and what the mitigation path is. If confidence is low or context is missing, make that explicit before the register so the user calibrates their trust in the assessment.

## Troubleshooting

- **Context is too thin to assess:** Flag specific missing information and provide a preliminary assessment with `UNCERTAINTY: HIGH` on affected risks. Do not invent details to fill gaps.
- **User wants a risk score without analysis:** Explain that a score without evidence is misleading. Provide the structure with placeholder reasoning while flagging what is needed.
- **All risks are informational:** This may indicate the artifact is genuinely low-risk, or the reviewer has insufficient context. Verify the scope and ask if there are specific concern areas to investigate.
- **Conflicting risks (mitigation helps one but worsens another):** Document the tradeoff explicitly. Flag it as a decision point requiring human judgment rather than resolving it silently.
- **AI/spec ambiguity risks feel speculative:** Distinguish between spec ambiguity (concrete gap in the written spec) and AI behavior speculation (unproven concern). Treat spec ambiguity as a factual finding; treat AI behavior concerns as hypothesis to be tested via spike or test strategy.