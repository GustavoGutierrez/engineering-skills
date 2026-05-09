---
name: story-refiner
description: Refine user stories into sprint-ready backlog items using INVEST checks, gap analysis, Gherkin acceptance criteria, edge cases, dependencies, and structured refinement questions.
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - story-refiner
  - story refiner
  - refine user story
  - improve user story
  - backlog refinement
  - acceptance criteria
---

# Story Refiner

## Purpose

Use this skill to refine raw user stories into clear, testable, sprint-ready backlog items. The agent evaluates each story against INVEST, detects common gaps, asks focused refinement questions, and produces a structured improved story with acceptance criteria and negative scenarios.

This skill is domain-generic. It must work for any product, service, workflow, or delivery team without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Improve, rewrite, or refine a user story.
- Turn a rough requirement into a sprint-ready backlog item.
- Add acceptance criteria to a story.
- Check whether a story is ready for sprint planning.
- Split an oversized story into smaller stories.
- Reframe technical tasks into user-value-oriented stories.
- Identify missing edge cases, error scenarios, dependencies, or UX details.

Do not use this skill for enterprise architecture, PRD writing, full technical specifications, source code, implementation plans, or project documentation. Keep the output at backlog-item level.

## Core Operating Rules

1. **Use INVEST as the primary evaluation framework.** Every story must be checked for Independent, Negotiable, Valuable, Estimable, Small, and Testable.
2. **Preserve intent, improve expression.** Do not change the user's intended outcome unless a gap makes the story unsafe, unclear, or untestable.
3. **Refocus technical wording on user value.** If the input is a technical task, rewrite it as a user or business outcome while preserving necessary implementation constraints as notes.
4. **Make acceptance criteria observable.** Replace vague phrases with measurable, testable Given/When/Then criteria.
5. **Include unhappy paths.** Always check for error cases, alternative flows, empty states, permission failures, validation failures, unavailable dependencies, and recovery behavior.
6. **Split oversized work.** If the story is too large, propose 2-3 smaller stories with separate value and acceptance criteria direction.
7. **Ask only blocking questions.** If missing information prevents a correct refinement, ask specific questions. If a safe assumption exists, state it explicitly.
8. **Avoid implementation overreach.** Do not prescribe internal design, frameworks, database tables, or APIs unless the user provides them as constraints.
9. **Keep the story sprint-ready.** The refined output must be understandable by product, design, engineering, and QA.

## INVEST Evaluation Criteria

| Criterion | Question to Ask | Failure Signal | Refinement Action |
| --- | --- | --- | --- |
| Independent | Can this story be delivered without strict dependency on another story in the same sprint? | Requires multiple unfinished stories to provide value. | Identify dependency or split by independently valuable increments. |
| Negotiable | Does it leave room for delivery collaboration? | Reads like a rigid technical contract. | Reframe around outcome and constraints, not detailed design. |
| Valuable | Is the user or business value explicit? | Describes only a task or component. | Add clear `so that` value and identify beneficiary. |
| Estimable | Does the team have enough information to estimate effort? | Missing scope, actors, rules, data, or interfaces. | Add assumptions or ask targeted questions. |
| Small | Can it fit comfortably within a sprint? | Multiple workflows, roles, systems, or large unknowns. | Suggest smaller stories or an epic split. |
| Testable | Can QA objectively verify completion? | No acceptance criteria or vague outcomes. | Write observable Given/When/Then criteria. |

## Common Gap Detection

Actively detect and correct these issues:

| Gap | Detection Pattern | Required Response |
| --- | --- | --- |
| Vague acceptance criteria | Words like `fast`, `simple`, `works well`, `user-friendly`, `robust`, or `intuitive` without measurement. | Replace with observable behavior, thresholds, or explicit examples. |
| Happy-path only | No mention of errors, empty states, permissions, invalid input, unavailable dependencies, or recovery. | Add negative and alternative scenarios. |
| Purely technical task | Story focuses on internal components rather than user or business outcome. | Reframe using `As a [profile], I want [action], so that [value]`. |
| Missing UX context | No validation messages, visible states, accessibility expectations, or interaction feedback where user interaction exists. | Add UX notes and acceptance criteria for visible behavior. |
| Hidden dependencies | Needs upstream data, approvals, designs, access, integrations, or decisions. | List dependencies and ask blocking questions if needed. |
| Oversized story | Multiple actors, workflows, outcomes, or lifecycle stages. | Propose 2-3 smaller stories and mark original as an epic candidate. |
| Ambiguous actor | `user` is too broad for permissions, goals, or workflows. | Ask or infer a more specific role and mark assumptions. |
| Weak value statement | `so that` is missing or repeats the action. | Add a concrete user, operational, compliance, or business benefit. |

## Execution Workflow

### Phase 1: Ingest and Analyze

1. Read the raw story, notes, constraints, and any existing acceptance criteria.
2. Identify actor, action, value, scope, dependencies, risks, and unknowns.
3. Score each INVEST criterion as `Pass`, `Partial`, or `Fail`.
4. Produce a short `Detected Gaps` report.

### Phase 2: Progressive Refinement

1. If the story is too large, suggest 2-3 smaller stories before writing the final version.
2. If critical information is missing, ask specific blocking questions.
3. If missing information is non-blocking, proceed with stated assumptions.
4. Convert technical wording into user-value wording.
5. Add acceptance criteria, negative scenarios, dependencies, and notes.

### Phase 3: Generate the Refined Story

Produce a complete refined story using the required output structure.

## Required Output Structure

Use this format unless the user requests only a review or only acceptance criteria:

```markdown
# <Clear Story Title>

## Readiness Summary
- Status: Ready | Needs Clarification | Split Recommended
- Reason:

## INVEST Review
| Criterion | Status | Notes | Fix Applied |
| --- | --- | --- | --- |

## Detected Gaps
- <Gap and impact>

## Refined User Story
As a <specific actor>, I want <action or capability>, so that <clear value or outcome>.

## Acceptance Criteria
### AC1: <Observable behavior>
- Given <context>
- When <action>
- Then <expected result>

### AC2: <Observable behavior>
- Given <context>
- When <action>
- Then <expected result>

## Negative and Edge Scenarios
- Given <error or edge context>
- When <action>
- Then <safe, visible, or recoverable outcome>

## Dependencies
- <Dependency, owner if known, and why it matters>

## Assumptions
- <Assumption made to keep refinement moving>

## Open Questions
- <Only questions that block correctness, estimation, or testing>

## Suggested Splits
- <Smaller story title>: <value and scope>
```

## Splitting Rules

When a story fails `Small`, split by one or more of these dimensions:

- User role or permission level.
- Happy path before edge cases.
- Read-only before write/update behavior.
- One workflow step before end-to-end automation.
- One channel, platform, or interface before multiple channels.
- Core validation before advanced validation.
- Manual workflow before automated workflow.

Each split story must still provide independent value and include a testable outcome.

## Acceptance Criteria Rules

- Use English Given/When/Then wording.
- Each criterion must describe one observable behavior.
- Include at least one happy-path criterion when applicable.
- Include at least one negative or edge scenario when applicable.
- Avoid implementation details unless they are externally visible constraints.
- Replace vague performance or quality words with measurable thresholds or explicit examples.
- If a threshold is unknown, write `TBD threshold` and ask who can define it.

## Quality Checklist

Before presenting the result, verify:

- The output is written in English.
- The actor, action, and value are explicit.
- INVEST review is complete.
- Acceptance criteria are testable and observable.
- Error, empty, invalid, permission, and dependency scenarios were considered.
- Dependencies and assumptions are visible.
- Oversized work is split or marked as split recommended.
- The story avoids unnecessary technical implementation detail.
- The final output can be used by product, engineering, design, and QA without repeated clarification.

## Response Style

- Be direct, structured, and practical.
- Prefer concise tables for evaluation.
- Prefer Gherkin bullets for acceptance criteria.
- Use neutral role names such as `domain user`, `authorized user`, `operator`, `administrator`, or `system actor` when the exact persona is unknown.
- Mark unknowns as `TBD` instead of inventing business context.
