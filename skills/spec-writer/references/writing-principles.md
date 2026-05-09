# SDD Specification Writing Principles

This reference condenses the repository guide in `799ab215.md` into operational rules for drafting `*.spec.md` files.

## Core Principles

1. Treat the spec as an executable contract, not as loose documentation.
2. Separate intent, design, and execution order whenever possible.
3. Prefer small, verifiable requirements over broad feature statements.
4. Keep the spec versioned with the repository and aligned with current code.
5. Write so an agent can verify completion without guessing.

## What Good Specs Always Include

- clear objective and context
- explicit scope and exclusions
- stable requirement IDs
- observable acceptance criteria
- non-functional constraints
- boundaries for safe agent behavior
- verification plan and completion conditions

## Requirement Pattern

Use this form:

`REQ-<DOMAIN>-<NNN>`: The system must or must not `<action>` when `<condition>` so that `<outcome>`.

Avoid:

- vague adjectives without metrics
- multiple behaviors in one requirement
- mixed terminology for the same concept
- undocumented architecture decisions that change implementation freedom

## Acceptance Criteria Pattern

Use:

- Given `<initial state>`
- When `<action>`
- Then `<observable result>`

Add edge-case criteria when the behavior has safety, permission, data integrity, or failure-mode implications.

## Agent Guardrails

Every spec should tell agents:

- what they may change safely
- what requires confirmation first
- what is forbidden

This is necessary for scope control and safer implementation.

## When Drafting from Existing Code

1. Inspect the repository first.
2. Infer current behavior from routes, services, tests, and component flow.
3. Normalize behavior into requirements.
4. Record gaps, inconsistencies, and assumptions explicitly.
5. Avoid copying implementation detail unless it constrains correctness.

## Final Review Checklist

- Is the business goal explicit?
- Is the scope bounded?
- Are the requirements testable?
- Are acceptance criteria present for main flows?
- Are constraints and dependencies documented?
- Are guardrails included?
- Is verification explicit?
