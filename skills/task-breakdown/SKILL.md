---
name: task-breakdown
description: Break complex features, epics, or specs into small executable tasks with logical sequencing, dependencies, ownership, acceptance signals, and parallelization guidance.
license: Apache-2.0
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - task-breakdown
  - task breakdown
  - break down feature
  - decompose epic
  - sprint task planning
  - agent task delegation
---

# Task Breakdown

## Purpose

Use this skill to decompose complex features, epics, specs, or delivery goals into small, executable tasks. The agent identifies subtasks, logical sequencing, dependencies, independently deliverable units, parallelizable work, and clear completion criteria.

This skill is domain-generic. It must work for any software system, workflow, team, or planning tool without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Break down a complex feature, epic, or specification into tasks.
- Prepare work for sprint planning or backlog grooming.
- Create tasks suitable for issue trackers.
- Split work for delegation to multiple agents or contributors.
- Identify implementation sequence and dependency order.
- Separate parallel work from sequential work.
- Convert high-level requirements into executable work packages.

Do not use this skill to write product strategy, enterprise architecture, source code, or detailed technical design. Use it after enough scope exists to create executable tasks.

## Core Operating Rules

1. **Decompose by deliverable outcome.** Each task must produce a concrete artifact, behavior, decision, test, integration, or validation result.
2. **Keep tasks small and executable.** A task should be understandable, assignable, and verifiable without requiring broad interpretation.
3. **Make dependencies explicit.** Every task must state what it depends on or confirm that it has no blocking dependency.
4. **Sequence foundation before dependent work.** Put setup, contracts, data shape, test scaffolding, and integration seams before feature tasks that rely on them.
5. **Separate parallel and sequential work.** Identify tasks that can run concurrently and tasks that must wait.
6. **Preserve independent value where possible.** Split tasks so completed work can be reviewed, tested, or integrated incrementally.
7. **Avoid fake precision.** Do not invent dates, estimates, owners, or tooling labels unless supplied. Use `TBD` or neutral placeholders.
8. **Include validation.** Every task must include a completion signal and verification method.
9. **Protect scope boundaries.** State out-of-scope work and avoid turning a task breakdown into architecture or implementation code.
10. **Optimize for delegation.** Tasks should be clear enough for separate agents or contributors to execute with minimal shared context.

## Decomposition Dimensions

Use these dimensions to split work:

| Dimension | Use When | Example Split Pattern |
| --- | --- | --- |
| Workflow Step | The feature spans multiple user or system steps. | Intake, validation, processing, result display, recovery. |
| Layer | Work crosses UI, domain logic, data, integration, or operations. | Contract first, data model, service behavior, interface, observability. |
| Capability | A feature includes multiple independently valuable capabilities. | Read-only before create/update, basic flow before advanced options. |
| Risk | Unknowns or external dependencies may block delivery. | Spike, proof, contract validation, fallback path. |
| Actor or Permission | Different users or systems need different behavior. | Authorized user flow, administrator flow, system actor flow. |
| State or Scenario | Behavior differs by state. | Empty state, valid state, invalid state, failure state. |
| Dependency Boundary | Multiple teams or components are involved. | Producer contract, consumer integration, end-to-end validation. |
| Release Increment | The full feature is too large for one increment. | Foundation, MVP slice, hardening, expansion. |

## Task Quality Rules

Each task must include:

- Clear title beginning with an action verb.
- Purpose or outcome.
- Scope boundaries.
- Dependencies.
- Expected output.
- Acceptance or completion criteria.
- Verification method.
- Parallelization status: `parallelizable`, `sequential`, or `blocked`.
- Suggested owner type when useful, such as `domain`, `platform`, `data`, `integration`, `quality`, or `operations`.

A task is not ready if it is vague, combines unrelated outcomes, lacks a verification method, hides dependencies, or requires unknown decisions before execution.

## Execution Workflow

### Phase 1: Intake and Scope Extraction

1. Identify the parent feature, epic, spec, or goal.
2. Extract capabilities, constraints, non-goals, and known dependencies.
3. Identify missing information that affects task boundaries.
4. Ask only blocking questions; otherwise proceed with stated assumptions.

### Phase 2: Decomposition

1. Split the work by deliverable outcome and dependency boundaries.
2. Separate foundation, implementation, integration, validation, and release-readiness work.
3. Detect tasks that are too large and split again.
4. Remove duplicate or overlapping tasks.

### Phase 3: Sequencing and Parallelization

1. Put prerequisite decisions, contracts, scaffolding, and environments first.
2. Group tasks into logical waves.
3. Mark tasks that can run in parallel.
4. Mark blocked tasks and the dependency that unblocks them.
5. Identify critical path tasks.

### Phase 4: Task Readiness Review

1. Add completion criteria and validation method to each task.
2. Confirm each task has a clear owner type or execution context.
3. Confirm the sequence supports incremental delivery.
4. Summarize risks, assumptions, and open questions.

## Required Output Structure

Use this format unless the user asks for a narrower deliverable:

```markdown
# <Feature or Epic Task Breakdown>

## 1. Breakdown Summary
- Parent scope:
- Goal:
- Assumptions:
- Out of scope:
- Recommended execution model: sequential | parallel | mixed

## 2. Dependency Overview
| Dependency | Type | Blocks | Required Resolution | Status |
| --- | --- | --- | --- | --- |

## 3. Execution Waves
### Wave 0: Discovery and Foundations
- Purpose:
- Exit criteria:

### Wave 1: Core Implementation
- Purpose:
- Exit criteria:

### Wave 2: Integration and Hardening
- Purpose:
- Exit criteria:

### Wave 3: Release Readiness
- Purpose:
- Exit criteria:

## 4. Task List
| ID | Task | Outcome | Dependencies | Parallelization | Owner Type | Verification |
| --- | --- | --- | --- | --- | --- | --- |

## 5. Task Details
### TASK-001: <Action-oriented title>
- Outcome:
- Scope:
- Dependencies:
- Acceptance criteria:
- Verification:
- Notes:

## 6. Parallelization Plan
- Can run in parallel:
- Must be sequential:
- Critical path:

## 7. Risks, Assumptions, and Open Questions
| Type | Item | Impact | Recommended Action |
| --- | --- | --- | --- |
```

## Sequencing Rules

- Discovery and risk-reduction tasks come before irreversible implementation.
- Contracts come before producer and consumer work when multiple components depend on them.
- Data shape and ownership come before data-dependent feature work.
- Test scaffolding comes before broad implementation when behavior is complex.
- Integration seams come before end-to-end integration.
- Observability and error handling come before release readiness.
- Documentation and handoff tasks come after the behavior is stable but before completion is claimed.

## Parallelization Rules

A task is parallelizable when:

- It has no dependency on another unfinished task in the same wave.
- Its contract or input is already stable.
- Its output can be reviewed independently.
- It does not mutate the same files, schemas, or shared decisions as another task unless coordination is explicit.

A task is sequential when:

- It depends on an unresolved decision, contract, schema, or environment.
- It consumes output from another task.
- It changes shared foundations that other tasks rely on.
- It is on the critical path for validation or release.

## Issue Tracker Readiness

When formatting for an issue tracker, each task should have:

- Title.
- Description.
- Acceptance criteria.
- Dependencies or blockers.
- Labels or owner type if provided by the user.
- Verification steps.
- Links to parent scope when known.

Do not invent issue IDs, project keys, assignees, sprint names, dates, or labels unless provided.

## Quality Checklist

Before presenting the breakdown, verify:

- The output is written in English.
- The parent feature or epic goal is clear.
- Tasks are small, executable, and independently verifiable.
- Dependencies are explicit.
- Execution order is logical.
- Parallelizable work is separated from sequential work.
- Foundation and risk-reduction tasks appear before dependent tasks.
- Every task has acceptance or completion criteria.
- Open questions are limited to blockers.
- No project-specific names, issue tracker keys, client names, vendors, or unnecessary concrete technologies were invented.

## Response Style

- Be concise, structured, and execution-oriented.
- Use tables for task lists, dependencies, and risks.
- Use action verbs in task titles.
- Use neutral owner types and placeholders when exact teams are unknown.
- Prefer waves and relative order over fixed dates unless dates are provided.
