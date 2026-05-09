---
name: spec-writer
description: Write, rewrite, or normalize structured `*.spec.md` specification files for agent-driven development. Use this whenever the user asks for a spec, requirements, acceptance criteria, implementation-ready documentation, feature definition before coding, or wants an existing idea/codebase turned into an actionable spec, even if they do not explicitly say "spec".
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - spec-writer
  - spec writer
  - write a spec
  - create specification
  - acceptance criteria
  - implementation-ready documentation
---

# SDD Spec Writer

## When to Use

Use this skill when you need to:

- Create a new `*.spec.md` file from a feature request, bug report, or product idea.
- Rewrite a vague spec into a precise, verifiable, agent-operable document.
- Extract a spec from existing code, tests, routes, or workflows.
- Add acceptance criteria, guardrails, or traceable requirements before implementation starts.
- Normalize specification files so coding agents can implement them with less ambiguity.

## Goal

Produce a single `*.spec.md` file that is clear, bounded, verifiable, and directly usable by coding agents.

The spec must behave like an execution contract:

- It defines the intended outcome.
- It limits scope and unsafe changes.
- It makes verification explicit.
- It gives agents enough context to act without guessing.

## Critical Patterns

### 1. Separate intent from implementation detail

Write the spec around observable behavior and constraints first. Add implementation notes only when they are necessary to avoid wrong architectural choices.

### 2. Prefer one requirement per behavior

Each requirement must describe one behavior only. Do not combine multiple independent behaviors into a single requirement.

### 3. Make every requirement testable

Use stable IDs and write requirements in a way that can be verified:

`REQ-<DOMAIN>-<NNN>`: The system must or must not `<behavior>` when `<condition>` so that `<user or business outcome>`.

Good example:

`REQ-AUTH-001`: The system must reject a login attempt after 5 consecutive failures from the same IP within 15 minutes and return HTTP 429.

Bad example:

`REQ-AUTH-001`: The login should feel secure and robust.

### 4. Acceptance criteria must be observable

Use `Given / When / Then` for main flows and edge cases.

Example:

- Given an authenticated admin user
- When the user opens `/admin/users`
- Then the system must render the users table with at least one row and show edit and delete actions

### 5. Define boundaries explicitly

Every spec must include three guardrail groups:

- `Always allowed`
- `Ask before`
- `Never do`

This reduces unsafe or out-of-scope implementation by coding agents.

### 6. State scope with inclusions and exclusions

Every spec must say what is in scope and what is out of scope. If this is missing, agents will infer and overreach.

### 7. Make verification part of the contract

The spec must say how completion will be validated:

- unit tests
- integration tests
- manual checks
- performance or security checks
- files or commands expected to change or run

### 8. Ask for clarification only when ambiguity blocks correctness

If a missing detail changes behavior, data model, public contracts, or scope, pause and ask.
If the missing detail is editorial and a safe default exists, proceed and document the assumption in `Open Questions / Assumptions`.

## Operating Workflow

### Step 1. Gather inputs

Collect as much as possible from the user request and repository context:

- feature or problem statement
- target users or actors
- expected outcome
- constraints or dependencies
- relevant code paths if the spec comes from existing code

If the request is too vague, ask only for the missing information that changes the resulting behavior.

### Step 2. Inspect before writing

If code already exists, inspect the current implementation in read mode first and infer:

- current behavior
- impacted modules
- hidden constraints
- terminology already used by the project

Do not invent architecture that conflicts with the repository.

### Step 3. Write the spec using the required structure

Always create the output as `<feature-name>.spec.md`.

Use the exact section order below unless the user explicitly asks for a different format.

## Required `*.spec.md` Structure

````markdown
# <Feature or Change Title>

## Metadata
- Spec ID: SPEC-<DOMAIN>-<NNN>
- Status: draft | approved | implemented
- Owner: <team or person>
- Last Updated: YYYY-MM-DD
- Related Paths: <files, directories, routes, services>

## Objective
<One short paragraph describing the business or user outcome>

## Context
<Relevant background, current behavior, or repository facts>

## In Scope
- <explicit inclusion>

## Out of Scope
- <explicit exclusion>

## Actors
- <actor>: <role in the flow>

## Functional Requirements

### REQ-<DOMAIN>-001
<Verifiable requirement statement>

Acceptance Criteria
- Given <state>
- When <action>
- Then <observable result>

### REQ-<DOMAIN>-002
<Next requirement>

Acceptance Criteria
- Given <state>
- When <action>
- Then <observable result>

## Non-Functional Requirements
- NFR-<DOMAIN>-001: <performance, security, availability, observability, accessibility, etc.>

## Constraints and Dependencies
- <technical constraint>
- <external dependency>

## Guardrails

### Always Allowed
- <safe changes an agent may make>

### Ask Before
- <changes that require user confirmation>

### Never Do
- <forbidden changes>

## Relevant Components
- <path>: <why it matters>

## Verification Plan
- <tests to add or update>
- <manual validation steps>
- <commands or checks>

## Definition of Done
- <condition that must be true at completion>

## Open Questions / Assumptions
- <question or explicit assumption>
````

## Writing Rules

- Write documentation in English.
- Use short, direct sentences and active voice.
- Keep terminology consistent through the whole document.
- Prefer concrete numbers over vague adjectives.
- Do not mix requirements, design rationale, and task sequencing in the same bullet unless the user explicitly asks for that.
- Do not leave hidden scope. If something is excluded, say it explicitly.
- Do not use filler such as "user-friendly", "robust", or "fast" without measurable meaning.
- Do not create requirements without a trigger, behavior, and outcome.

## Agent-Operable Quality Bar

Before finalizing a spec, verify that it answers these questions:

1. What exactly is being changed?
2. What must the system do?
3. What must the system not do?
4. What files, modules, routes, or services are likely involved?
5. What constraints limit the implementation?
6. How will success be verified?
7. What requires confirmation before implementation?

If one of these is missing, the spec is not ready.

## Default Output Behavior

When the user asks for a spec and does not specify a filename:

- derive a kebab-case feature name
- create `<feature-name>.spec.md`
- use stable IDs inside the file
- keep placeholders only where facts are truly unknown

## Files to Read

- `assets/spec-template.md`: reusable writing template for `*.spec.md`
- `references/writing-principles.md`: condensed rules derived from the repository's SDD writing guide

## Example Prompts

Example 1:

Input: `Create a spec for bulk user import with CSV validation and duplicate detection.`

Output:
- Creates `bulk-user-import.spec.md`
- Defines scope, actors, REQ and NFR sections, guardrails, and verification plan

Example 2:

Input: `Turn the current device enrollment flow into a proper spec using the existing code.`

Output:
- Inspects current code first
- Writes a behavior-based spec instead of copying implementation details blindly

## Commands

```bash
# Locate existing specs
rg --files -g "*.spec.md"

# Locate feature-related code before writing a spec from existing behavior
rg -n "<feature-keyword>" src
```

## Resources

- **Template**: [assets/spec-template.md](assets/spec-template.md)
- **Writing principles**: [references/writing-principles.md](references/writing-principles.md)
