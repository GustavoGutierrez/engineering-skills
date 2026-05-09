---
name: technical-planner
description: Plan technical execution for software systems by organizing phases, dependencies, sequencing, infrastructure foundations, MVP scope, coordination points, and incremental architecture delivery.
license: Apache-2.0
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - technical-planner
  - technical planner
  - technical roadmap
  - implementation plan
  - MVP technical plan
  - incremental architecture plan
---

# Technical Planner

## Purpose

Use this skill to plan the technical execution of a software system before implementation. The agent organizes work into realistic phases, identifies technical dependencies, defines implementation order, prioritizes infrastructure and base architecture, and creates an incremental delivery roadmap.

This skill is domain-generic. It must work for any software system, platform, team topology, or delivery model without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Create a technical roadmap or implementation plan.
- Plan an MVP from a technical perspective.
- Sequence work across infrastructure, architecture, services, data, integrations, and user-facing capabilities.
- Identify dependencies, blockers, risks, and coordination points.
- Prioritize foundational architecture before feature delivery.
- Coordinate multi-team or multi-component execution.
- Turn a high-level spec, architecture, PRD, PRP, or backlog into an executable technical plan.

Do not use this skill for detailed source code, story-level refinement, enterprise governance, or product strategy. Keep the output at execution-planning level.

## Core Operating Rules

1. **Plan execution, not code.** Define phases, sequencing, dependencies, risks, validation gates, and ownership. Do not write source code.
2. **Foundations before features.** Prioritize architecture runway, infrastructure, data foundations, environments, security controls, observability, and integration seams before dependent feature work.
3. **Sequence by dependency and learning value.** Early phases should reduce unknowns, validate risky assumptions, and unblock later work.
4. **Define incremental value.** Each phase should produce a usable capability, validated foundation, risk reduction, or integration milestone.
5. **Make dependencies explicit.** Track technical, team, environment, data, access, decision, approval, and external dependency types.
6. **Avoid false precision.** Use relative sequencing and readiness criteria unless the user provides real dates, capacity, or estimates.
7. **Protect MVP scope.** Separate must-have foundations and MVP capabilities from later enhancements.
8. **Plan for coordination.** Identify cross-team handoffs, shared contracts, integration checkpoints, and decision owners.
9. **Make verification part of every phase.** Each phase needs exit criteria, evidence, and rollback or contingency considerations.
10. **Use neutral placeholders.** If teams, technologies, environments, or providers are unknown, use generic terms such as `platform team`, `domain team`, `approved provider`, `target environment`, or `TBD`.

## Planning Inputs

Gather or infer these inputs before planning:

- Target outcome and MVP goal.
- Current baseline or starting point.
- Known constraints and non-goals.
- Required capabilities and major workflows.
- Architecture decisions already made.
- Technical risks and unknowns.
- Teams or owners involved.
- Environments, data, integrations, and access dependencies.
- Delivery constraints such as capacity, milestones, compliance, or operational readiness.

If these inputs are missing, proceed with explicit assumptions unless the missing detail changes sequencing, risk, or MVP scope.

## Dependency Types

Classify dependencies with this taxonomy:

| Type | Meaning | Planning Action |
| --- | --- | --- |
| Architecture | Foundational decisions, module boundaries, contracts, or platform direction. | Resolve before dependent implementation begins. |
| Infrastructure | Environments, runtime, deployment, networking, storage, identity, observability, or secrets. | Place early in the roadmap as architecture runway. |
| Data | Data model, migration, ownership, quality, lifecycle, privacy, or availability. | Schedule before features that read or write dependent data. |
| Integration | External systems, APIs, events, queues, imports, exports, or adapters. | Define contracts and test seams before end-to-end work. |
| Security and Compliance | Access control, audit, policy, approvals, threat modeling, or regulatory constraints. | Add early review and explicit exit criteria. |
| Team Coordination | Cross-team handoffs, shared components, review ownership, or release alignment. | Add coordination checkpoints and named owners. |
| Product or Design | Scope decisions, user flows, UX states, or acceptance criteria. | Mark as blocker or assumption depending on impact. |
| Operational Readiness | Monitoring, alerting, runbooks, support, migration, rollback, or incident response. | Include before release or production transition. |

## Execution Workflow

### Phase 1: Intake and Framing

1. Identify the desired outcome, MVP boundary, stakeholders, known constraints, and non-goals.
2. Establish baseline readiness and major unknowns.
3. Capture assumptions and blocking questions.
4. Define planning horizon as phases rather than fixed dates unless dates are provided.

### Phase 2: Foundation and Dependency Mapping

1. Identify foundational architecture and infrastructure work.
2. Map dependencies between modules, teams, data, integrations, and environments.
3. Highlight sequencing risks and parallelization opportunities.
4. Identify spikes or proofs needed to reduce uncertainty.

### Phase 3: Incremental Roadmap Design

1. Group work into phases with clear goals and exit criteria.
2. Place foundation work before dependent feature work.
3. Build MVP around the smallest coherent end-to-end capability.
4. Add transition phases for hardening, scale, operations, and migration.
5. Separate must-have, should-have, and later work.

### Phase 4: Coordination and Governance

1. Assign owners or owner placeholders.
2. Define integration checkpoints and dependency review cadence.
3. Add risk, assumption, issue, and dependency tracking.
4. Define release readiness, rollback, and operational handoff criteria.

## Required Output Structure

Use this format unless the user requests a narrower deliverable:

```markdown
# <Technical Execution Plan Title>

## 1. Executive Summary
- Goal:
- MVP outcome:
- Planning horizon:
- Key constraints:
- Major risks:

## 2. Scope and Assumptions
### In Scope
- <Included work>

### Out of Scope
- <Excluded work>

### Assumptions
- <Assumption>

### Open Questions
- <Blocking question>

## 3. Baseline Readiness
| Area | Current State | Readiness | Gap | Impact |
| --- | --- | --- | --- | --- |

## 4. Technical Workstreams
| Workstream | Purpose | Owner | Key Outputs | Dependencies |
| --- | --- | --- | --- | --- |

## 5. Dependency Map
| Dependency | Type | Blocks | Owner | Resolution Needed | Status |
| --- | --- | --- | --- | --- | --- |

## 6. Implementation Sequence
| Phase | Goal | Work Items | Entry Criteria | Exit Criteria | Validation Evidence |
| --- | --- | --- | --- | --- | --- |

## 7. MVP Definition
- Must-have foundations:
- Must-have capabilities:
- Explicitly deferred:
- MVP validation criteria:

## 8. Parallelization and Coordination Plan
- Work that can run in parallel:
- Work that must be sequential:
- Cross-team checkpoints:
- Integration checkpoints:

## 9. Risks and Mitigations
| Risk | Impact | Likelihood | Mitigation | Trigger | Owner |
| --- | --- | --- | --- | --- | --- |

## 10. Release and Operational Readiness
- Observability:
- Security and access:
- Runbooks and support:
- Rollback or contingency:
- Handoff criteria:

## 11. Roadmap Summary
| Order | Increment | Value Delivered | Dependencies Resolved | Readiness Signal |
| --- | --- | --- | --- | --- |
```

## Sequencing Rules

- Do architecture decisions before irreversible implementation.
- Do environment and deployment foundations before continuous delivery assumptions.
- Do contract design before multi-team parallel implementation.
- Do data ownership and migration planning before data-dependent features.
- Do security and access design before exposing sensitive workflows.
- Do observability before production readiness claims.
- Do end-to-end thin-slice validation before broad feature expansion.
- Do operational readiness before launch or handoff.

## MVP Planning Rules

An MVP technical plan must include:

- The smallest coherent end-to-end user or system capability.
- Required foundations that make the MVP safe to build and validate.
- Explicitly deferred capabilities.
- Risks accepted for MVP and risks that must be mitigated first.
- Validation signals that prove the MVP is useful, reliable enough, and technically viable.

## Multi-Team Coordination Rules

When multiple teams or components are involved:

- Define shared contracts before teams build against them.
- Identify owner for each workstream, contract, and dependency.
- Add integration checkpoints before final release.
- Track cross-team dependencies in a dependency map.
- Avoid assigning the same foundation to multiple owners unless ownership boundaries are explicit.
- Surface sequencing conflicts early instead of hiding them in the roadmap.

## Quality Checklist

Before presenting the plan, verify:

- The output is written in English.
- MVP scope is explicit.
- Phases are ordered by dependencies, risk reduction, and incremental value.
- Foundational infrastructure and base architecture appear before dependent features.
- Dependencies are classified and assigned owners or owner placeholders.
- Each phase has entry criteria, exit criteria, and validation evidence.
- Parallel and sequential work are clearly separated.
- Risks, assumptions, open questions, and operational readiness are visible.
- No project-specific names, client names, vendors, or unnecessary concrete technologies were invented.

## Response Style

- Be pragmatic, structured, and execution-oriented.
- Use tables for phases, dependencies, workstreams, risks, and roadmap summaries.
- Use short bullets for assumptions, MVP boundaries, and readiness checks.
- Prefer relative order such as `Phase 0`, `Phase 1`, and `Phase 2` over dates unless dates are provided.
- Mark unknowns as `TBD` when they affect sequencing or ownership.
