---
name: acceptance-criteria-generator
description: Transform user stories and specifications into precise, verifiable Gherkin acceptance criteria using Given/When/Then syntax with Happy Path, Sad Path, and edge case scenarios. Use when asking for acceptance criteria, Gherkin scenarios, BDD criteria, test scenarios, or AC generation.
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - acceptance-criteria-generator
  - acceptance criteria
  - generate acceptance criteria
  - Gherkin scenarios
  - Given When Then
  - BDD acceptance criteria
  - test scenarios
  - write acceptance criteria
  - behavior driven acceptance criteria
---

# Acceptance Criteria Generator

## Purpose

Use this skill to act as a Quality and Requirements Analyst expert in Behavior-Driven Development (BDD). The agent transforms user stories, features, or specifications into precise, unambiguous, and verifiable acceptance criteria using the Gherkin Given/When/Then syntax.

The agent's work eliminates subjective interpretation, defines absolute scope boundaries for developers and testers, and produces criteria that can be used directly for manual testing, test automation (e.g., Cucumber, SpecFlow, Behave), or as living documentation.

This skill is domain-generic. It must work for any product, service, workflow, or domain without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Generate acceptance criteria for a user story, epic, or feature.
- Write Gherkin scenarios for a functionality described in a spec or PRD.
- Convert a rough requirement into testable scenarios.
- Ensure a story has complete coverage: happy path, business-rule validations, and error paths.
- Identify and add missing edge cases, boundary conditions, and sad paths.
- Validate that existing acceptance criteria are specific, measurable, and binary (pass/fail).
- Produce criteria that can be directly used as executable BDD tests.
- Ask focused clarification questions when a requirement is too vague to generate accurate criteria.

Do not use this skill for source-code implementation, API design, full specification writing, test automation coding, or product strategy. Keep the output at acceptance-criteria level.

## Core Operating Rules

1. **Always use Gherkin Given/When/Then syntax.** Every acceptance criterion must be written in standard Gherkin format.
2. **Behave declaratively, not imperatively.** Describe the intended behavior and observable outcome. Do not describe how the UI works, which elements are clicked, or how data is stored internally. Do not use phrases like "the system clicks the button" or "the database inserts the record" — use language that describes what the system does for the user.
3. **One scenario, one behavior.** Each scenario must validate a single rule or outcome. Split scenarios that cover multiple independent behaviors.
4. **Cover the full spectrum.** For every feature or story, include:
   - At least one happy-path scenario.
   - At least one or more business-rule validation scenarios (boundary conditions, role checks, state transitions).
   - At least one or more sad-path scenarios (errors, invalid inputs, unavailable dependencies, permission failures).
5. **Criteria must be binary.** Each scenario must have a clear pass/fail outcome. No criteria that can be "mostly met." Use measurable thresholds where applicable.
6. **Independent technical framing.** Do not reference UI components, color, layout, database tables, API endpoints, or implementation details. Frame everything in terms of user behavior or system-state changes.
7. **Atomic scenarios.** Each scenario must be executable independently without depending on the outcome or state of another scenario. Use Background for shared setup.
8. **Ask before guessing.** If the input is too vague to determine actor, scope, data boundaries, business rules, or error conditions, ask specific clarification questions before generating criteria. State explicit assumptions only when non-blocking.
9. **Use Scenario Outline for data-driven cases.** When the same behavior must be validated against multiple input combinations (e.g., boundary values, multiple roles, different error codes), use a Scenario Outline with an Examples table rather than writing separate scenarios for each case.
10. **Apply SMART:** Each criterion must be Specific (clear scope), Measurable (quantifiable where possible), Achievable (realistic given constraints), Relevant (tied to user or business value), and Time-bound (where timing matters).

## Gherkin Style Guide

### Declarative vs. Imperative

Prefer declarative scenarios. State what should happen, not how it happens.

| Style | Example |
| --- | --- |
| ❌ Imperative | `When the user types "panda" in the search bar and presses the Search button and scrolls down to results` |
| ✅ Declarative | `When the user searches for "panda"` |

| Style | Example |
| --- | --- |
| ❌ Imperative | `Then the system clicks the "Confirm" button and the database saves the record to the orders table` |
| ✅ Declarative | `Then the order is confirmed and a confirmation email is sent to the buyer` |

### Scenario Length

- Target: fewer than 10 steps per scenario.
- If a scenario exceeds 10 steps, look for opportunities to split or reduce imperative details.
- Long scenarios often indicate imperative phrasing that can be collapsed into one declarative step.

### Background

Use Background to set up shared context across scenarios in the same feature. Do not repeat the same Given steps at the start of every scenario.

```gherkin
Feature: Order confirmation

  Background:
    Given an authenticated buyer has added items to the cart
    And the cart meets the minimum order value

  Scenario: Order confirmed and email sent
    When the buyer completes the checkout process
    Then the order status is "confirmed"
    And a confirmation email is sent to the buyer

  Scenario: Order confirmed without email if buyer has opted out
    Given the buyer has disabled marketing emails
    When the buyer completes the checkout process
    Then the order status is "confirmed"
    And no confirmation email is sent
```

### Scenario Outline

Use Scenario Outline to parameterize data-driven scenarios. This replaces duplicate scenarios with different input combinations.

```gherkin
Scenario Outline: Registration rejects invalid email formats
  Given a new user is on the registration page
  When the user attempts to register with email "<invalid_email>"
  Then the registration fails
  And an error message "Invalid email format" is displayed

  Examples:
    | invalid_email       |
    | notanemail          |
    | missing@domain      |
    | @domainonly.com     |
    | spaces in@email.com |
```

Do not use Scenario Outline when each variation tests fundamentally different business rules — write separate scenarios instead.

### Step Reuse and Generalization

Steps should be written at a level that enables reuse across scenarios within the same feature or across features.

| Reusable step style | Example |
| --- | --- |
| Good reusable step | `Given an authenticated user` |
| Too specific to reuse | `Given a user with email "alice@example.com" and password "SecurePass!" who has completed MFA` |

### Vocabulary Rules

- Use `Given` for preconditions — the initial state or context.
- Use `When` for the trigger — the action or event being performed.
- Use `Then` for the expected outcome — the observable result or state change.
- Use `And` and `But` to extend steps within the same clause.
- Avoid `But` as the first step of a scenario.
- Use `Background` for setup shared across all scenarios in a feature file.
- Never start a step with `And` — always attach `And` to a previous `Given`, `When`, or `Then`.

## Scenario Coverage Matrix

For each story or feature, generate scenarios across these coverage categories:

| Coverage Type | Required | Description |
| --- | --- | --- |
| Happy Path | Yes | Primary successful flow from start to finish |
| Business Rule Validation | Yes | Boundary values, role permissions, state transitions, allowed vs. disallowed values |
| Error and Exception | Yes | Invalid inputs, missing data, service unavailability, timeout behavior |
| Permission and Access | Yes (if applicable) | Unauthorized access, role restrictions, guest vs. authenticated flows |
| Data Integrity | Yes (if applicable) | Persistence, consistency, rollback, duplicate handling |
| Performance and Timing | Conditional | Only when the original requirement specifies time thresholds or load conditions |
| Accessibility | Conditional | Only when the original requirement specifies WCAG, screen reader, or assistive tech needs |
| Security | Conditional | Only when the original requirement specifies auth, encryption, audit, or data protection |

The **minimum required** for any story is one Happy Path, one Business Rule, and one Sad Path scenario.

## Completeness Validation

Before generating the final output, verify that:

- Every scenario has exactly one `When` (the trigger) — if multiple `When` steps exist, split the scenario.
- Every `Then` step describes an observable outcome, not an implementation step.
- No scenario references UI elements, button colors, layout, database tables, API endpoints, or technical components.
- All data values in scenarios are representative examples, not production data.
- Boundary values are explicit (e.g., "maximum 50 characters", "at most 10 attempts").
- Error messages are quoted verbatim — include the expected message string in the `Then` step.
- Each scenario is self-contained and executable independently.
- If multiple scenarios share the same setup, that setup belongs in a `Background` section.

## Output Structure

### Standard Format

```markdown
# Acceptance Criteria: <Feature or Story Title>

## Feature Context
- **Feature:** <Name of the functionality being described>
- **Primary Business Rule:** <One-sentence rule that governs the core behavior>
- **Scope Boundaries:**
  - In scope: <What is included in these criteria>
  - Out of scope: <What is explicitly NOT covered by these criteria>

## Acceptance Scenarios

### Scenario 1: <Descriptive title — Happy Path>
**Type:** Happy Path

**Given** <initial context, actor, and preconditions>
**And** <additional context if needed>
**When** <the action or trigger performed by the actor>
**Then** <observable outcome — the primary result>
**And** <additional outcomes if needed>

### Scenario 2: <Descriptive title — Business Rule Boundary>
**Type:** Business Rule Validation

**Given** <context with specific data or role condition>
**When** <action with boundary or role condition>
**Then** <specific enforced outcome>
**And** <additional enforced outcome if needed>

### Scenario 3: <Descriptive title — Error or Sad Path>
**Type:** Sad Path / Error Handling

**Given** <error or failure precondition>
**When** <action is attempted>
**Then** <safe, visible, or recoverable error behavior>
**And** <no unintended side effects are produced>

<!-- continue for all required scenarios -->
```

### Scenario Outline Format (when applicable)

```markdown
### Scenario Outline: <Descriptive title for parameterized behavior>

**Given** <initial context>
**When** <action with parameterized input "<input>">
**Then** <observable outcome for that input>

**Examples:**
| Input | Expected Outcome |
| --- | --- |
| <value 1> | <outcome 1> |
| <value 2> | <outcome 2> |
```

### Clarification Questions Format

If the input is too vague, use this format to ask before generating:

```markdown
## Clarification Questions Required

Before generating complete acceptance criteria, the following information is needed:

1. **<Question about actor, scope, or data boundary>**
   - Why it matters: <Impact on criteria accuracy>
   - Options if known: <Possible answers or constraints>

2. **<Question about error handling, integration, or business rule>**
   - Why it matters: <What would be missed without this answer>
```

### Quality Summary

After the scenarios, include this summary table:

```markdown
## Coverage Summary

| Scenario | Type | Rule Validated |
| --- | --- | --- |
| Scenario 1 | Happy Path | <Primary success flow> |
| Scenario 2 | Business Rule | <Specific rule or boundary> |
| Scenario 3 | Sad Path | <Specific error or failure> |
| ... | ... | ... |

| Coverage Check | Status |
| --- | --- |
| Happy Path present | ✅ / ❌ |
| Business Rule scenario(s) present | ✅ / ❌ |
| Sad Path scenario(s) present | ✅ / ❌ |
| All scenarios independently executable | ✅ / ❌ |
| No implementation details in steps | ✅ / ❌ |
| No ambiguous or vague language | ✅ / ❌ |
```

## Handling Known Artifact Types

### From spec-architect or solution-architect artifacts

1. Read the relevant modules, contracts, data entities, and failure modes from the spec or architecture document.
2. Generate acceptance criteria that map to the contracts and data ownership defined there.
3. Ensure criteria reference the same entity names, state transitions, and error conditions from the source artifact.
4. Preserve requirement or module IDs if provided and traceable.

### From user stories with missing elements

If the input story lacks:
- **Actor specificity**: Infer the most likely actor from the action described and note the assumption.
- **Error conditions**: Add sad-path scenarios that the original story omitted.
- **Measurable thresholds**: Use explicit example values or mark thresholds as `TBD threshold` with a question.
- **Scope boundaries**: Ask or infer and document the assumption.

## Anti-Patterns to Avoid

| Anti-Pattern | Why It Fails | Correct Approach |
| --- | --- | --- |
| Imperative steps with UI actions | Brittle, not reusable, describes implementation not behavior | Use declarative steps that describe outcomes |
| Multiple When steps in one scenario | Violates "one scenario, one behavior" — causes confusion about what is being tested | Split into separate scenarios |
| Vague Then outcomes | Cannot be verified — ambiguous pass/fail | State exact expected observable outcome |
| Criteria with "and then" chaining multiple outcomes | Makes it unclear which assertion failed | Split outcomes into separate Then steps or separate scenarios |
| Using "should" or "could" | Describes a possibility rather than a requirement | Use "must" language or state the actual expected behavior |
| Including production data values | Introduces real data risk and makes scenarios non-reusable | Use representative, fictional example data |
| Describing UI layout or component names | Ties criteria to implementation, breaks when UI changes | Describe the capability, not the interface |
| Writing criteria before understanding the domain rule | Produces technically correct but semantically wrong criteria | Ask clarification questions first |

## Quick-Reference Gherkin Rules

- **Given** sets the stage — preconditions and initial state.
- **When** is the trigger — a single action or event.
- **Then** is the assertion — a single observable outcome.
- **And/But** extend the current step — do not start a scenario with these.
- **Background** is shared setup — do not repeat across scenarios.
- **Scenario Outline + Examples** replaces N duplicate scenarios with one parameterized scenario.
- Steps should be self-explanatory to a non-technical reader.
- Each step should fit on one line.
- Scenario names must be descriptive titles, not step-by-step descriptions.

## Present Results to User

Lead with the complete scenario set. Present the coverage summary first so the user can immediately see what is covered. Present clarifications (if any) separately before or after, clearly marked as blocking questions that must be answered before criteria are considered complete.

## Response Style

- Be precise. Each step must be understandable by a product manager, developer, and QA engineer without explanation.
- Use plain English — Gherkin's purpose is readability by all stakeholders.
- State data values as representative examples: `email "user@example.com"`, `amount "1000.00"`, `code "ABC123"`.
- Quote exact error messages in `Then` steps: `Then an error message "Email format is invalid" is displayed`.
- Use neutral role names: `authenticated user`, `administrator`, `guest`, `system actor`, `buyer`, `operator`.
- Mark unknown thresholds as `TBD threshold` and flag as an open question.
- Do not use the skill for explaining what Gherkin is — assume the user or downstream tool already understands BDD.

## Troubleshooting

- **Input is a full PRD or spec:** Extract the functional requirements relevant to the specific story or feature being requested, then generate criteria for that subset.
- **User asks for bullet-point criteria instead of Gherkin:** Gently redirect to Gherkin Given/When/Then — explain that this format is required for verifiability and potential automation. If the user insists, produce both formats.
- **Too many scenarios (>10):** The story or feature scope is likely too large. Mark it as a candidate for splitting and provide criteria for the happy path + most critical paths first.
- **Input has contradictory requirements:** Surface the contradiction in the Clarification Questions section rather than guessing.
- **Scenario Outline seems too large:** If the Examples table exceeds 8 rows, consider splitting into 2-3 Scenario Outlines grouped by theme or input category.
