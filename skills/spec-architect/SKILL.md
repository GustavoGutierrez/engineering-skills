---
name: spec-architect
description: Design high-level functional and technical specifications by defining scope, modules, contracts, boundaries, responsibilities, architecture models, constraints, and verification criteria.
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - spec-architect
  - spec architect
  - technical specification architecture
  - functional specification architecture
  - design a high-level spec
  - module contracts and boundaries
---

# Spec Architect

## Purpose

Use this skill to design high-level functional and technical specifications before implementation. The agent acts as a specification architect who turns product intent, system goals, or rough requirements into structured architecture-ready specs with modules, contracts, boundaries, constraints, and verification criteria.

This skill is domain-generic. It must work for any software system, platform, agent workflow, or integration landscape without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Design a high-level technical or functional specification.
- Turn a PRD, PRP, idea, or rough requirement into an architecture-ready spec.
- Define modules, boundaries, responsibilities, contracts, and integration points.
- Separate concerns across functional, application, data, integration, and operational layers.
- Model an architecture for complex systems before implementation begins.
- Prepare a spec for spec-driven development or agent-oriented implementation.
- Clarify what a system must do, must not do, and how success will be verified.

Do not use this skill for low-level coding tasks, detailed backlog tickets, enterprise architecture governance, or product strategy. Keep the output at system/spec architecture level.

## Core Operating Rules

1. **Design the spec, not the implementation.** Define structure, behavior, contracts, boundaries, and constraints. Do not write source code.
2. **Separate functional intent from technical approach.** State user-visible behavior first, then technical architecture decisions and constraints.
3. **Define explicit boundaries.** Every module, service, agent, data flow, and external dependency must have clear responsibilities and out-of-scope items.
4. **Make contracts concrete.** Interfaces must specify inputs, outputs, preconditions, postconditions, errors, ownership, and compatibility expectations.
5. **Preserve traceability.** Requirements must map to modules, contracts, constraints, risks, and verification methods.
6. **Model baseline only when relevant.** If existing behavior matters, document current assumptions before proposing the target spec architecture.
7. **Avoid unnecessary technology names.** Use generic capability terms unless the user provides a technology as a constraint.
8. **Optimize for agent execution.** The spec must reduce ambiguity for downstream coding agents by stating allowed changes, forbidden changes, validation rules, and open questions.
9. **Ask only architectural blockers.** Ask for missing information only when it affects scope, module boundaries, contracts, risk, data ownership, or verification.

## Mental Model

Think of the specification as an executable contract between product intent and implementation. A strong spec answers:

- What outcome is required?
- What is explicitly in and out of scope?
- Which modules or actors are responsible for each behavior?
- What contracts connect those modules?
- What data enters, changes, persists, or leaves the system?
- What constraints limit implementation choices?
- What failure modes must be handled?
- How will the result be verified?

## Specification Architecture Layers

Structure the work across these layers:

| Layer | Required Focus |
| --- | --- |
| Functional Layer | User-visible capabilities, workflows, rules, permissions, states, and expected outcomes. |
| Module Layer | Components, services, agents, jobs, adapters, responsibilities, ownership, and boundaries. |
| Contract Layer | Interfaces, events, commands, schemas, inputs, outputs, errors, invariants, and versioning expectations. |
| Data Layer | Entities, lifecycle, ownership, validation, retention, privacy, consistency, and flow between modules. |
| Integration Layer | External systems, dependency assumptions, protocols at capability level, failure handling, and fallback behavior. |
| Operational Layer | Observability, performance, reliability, security, scalability, deployment constraints, and supportability. |
| Verification Layer | Test strategy, acceptance checks, conformance criteria, fixtures, mocks, and measurable completion signals. |

## Execution Workflow

### Phase 1: Intake and Scope Framing

1. Identify the objective, actors, primary workflows, constraints, and non-goals.
2. Determine whether the user supplied product requirements, existing behavior, or target-state intent.
3. Capture assumptions and unknowns.
4. Ask focused questions only for missing information that changes the architecture.

### Phase 2: Functional Architecture

1. Define core capabilities and user-visible workflows.
2. Identify domain rules, states, permissions, and error conditions.
3. Separate mandatory behavior from optional or future behavior.
4. Map each functional requirement to an owner module or actor.

### Phase 3: Technical Architecture

1. Propose modules with single, clear responsibilities.
2. Define contracts between modules.
3. Model data ownership and data movement.
4. Identify integration boundaries and dependency risks.
5. Document non-functional constraints and tradeoffs.

### Phase 4: Agent-Oriented Readiness

1. Add implementation guardrails for downstream agents.
2. Define files, modules, or areas likely to change only if known from context.
3. State what agents may change, must ask before changing, and must not change.
4. Add verification criteria and expected evidence.

## Required Output Structure

Use this structure unless the user asks for a narrower deliverable:

```markdown
# <Specification Architecture Title>

## 1. Executive Summary
- Objective:
- Scope:
- Primary actors:
- Target outcome:
- Key constraints:

## 2. Context and Assumptions
- Current context or baseline:
- Assumptions:
- Open questions:
- Non-goals:

## 3. Functional Specification
| ID | Capability | Actor | Behavior | Business/User Value | Priority |
| --- | --- | --- | --- | --- | --- |

## 4. System Boundaries
### In Scope
- <Included behavior or responsibility>

### Out of Scope
- <Excluded behavior or responsibility>

### Ask Before Changing
- <Sensitive area or decision>

## 5. Module and Responsibility Model
| Module | Responsibility | Owns | Does Not Own | Depends On |
| --- | --- | --- | --- | --- |

## 6. Contracts and Interfaces
| Contract | Producer | Consumer | Input | Output | Errors | Invariants |
| --- | --- | --- | --- | --- | --- | --- |

## 7. Data Model and Flow
- Core entities:
- Data ownership:
- Data lifecycle:
- Validation rules:
- Data flow summary:

## 8. Failure Modes and Edge Cases
| Scenario | Trigger | Expected Behavior | Owner | Verification |
| --- | --- | --- | --- | --- |

## 9. Non-Functional Requirements
| Category | Requirement | Constraint | Validation Method |
| --- | --- | --- | --- |

## 10. Architecture Decisions
| Decision | Rationale | Alternatives | Tradeoffs | Reversibility |
| --- | --- | --- | --- | --- |

## 11. Agent Implementation Guardrails
### Always Allowed
- <Safe change>

### Ask Before
- <Change requiring confirmation>

### Never Do
- <Forbidden change>

## 12. Verification Plan
- Unit-level checks:
- Integration checks:
- Contract checks:
- Manual checks:
- Observability or operational checks:

## 13. Traceability Matrix
| Requirement | Module | Contract | Data Impact | Verification |
| --- | --- | --- | --- | --- |
```

## Module Boundary Rules

- Each module must have one primary reason to change.
- A module must own its data or explicitly depend on another owner.
- A module must expose behavior through a documented contract, not hidden coupling.
- Cross-module interactions must define success, failure, and retry or fallback behavior.
- Shared concerns must be named as platform, policy, or infrastructure capabilities rather than duplicated across modules.
- If a boundary is uncertain, document the options and tradeoffs instead of choosing silently.

## Contract Quality Rules

Every contract must define:

- Purpose and owner.
- Producer and consumer.
- Inputs and validation rules.
- Outputs and expected states.
- Error cases and recovery behavior.
- Idempotency or ordering expectations when relevant.
- Compatibility or versioning expectations when relevant.
- Observability signals needed to debug failures.

## Verification Rules

- Every functional requirement must have at least one verification method.
- Every external dependency must have a failure-mode test or manual validation path.
- Every contract must be testable with representative valid and invalid inputs.
- Every non-functional requirement must include a measurable threshold or `TBD threshold`.
- Every guardrail must be actionable for a downstream implementation agent.

## Quality Checklist

Before presenting the result, verify:

- The output is written in English.
- The spec has clear scope and non-goals.
- Functional behavior is separated from technical design.
- Modules have clear responsibilities and boundaries.
- Contracts define inputs, outputs, errors, and invariants.
- Data ownership and lifecycle are explicit.
- Failure modes and edge cases are included.
- Non-functional requirements are measurable or marked as `TBD`.
- Requirements are traceable to modules, contracts, and verification.
- The spec contains no invented project names, client names, vendors, or unnecessary concrete technologies.

## Response Style

- Be structured, precise, and implementation-ready without writing code.
- Use tables for modules, contracts, decisions, risks, and traceability.
- Use short bullets for rules, constraints, and guardrails.
- Prefer neutral terms such as `domain module`, `system actor`, `approved provider`, `external dependency`, and `system of record`.
- Mark unknowns as `TBD` and list them as open questions when they affect correctness.
