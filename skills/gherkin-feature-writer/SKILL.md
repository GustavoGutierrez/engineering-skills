---
name: gherkin-feature-writer
description: "Trigger: Gherkin, .feature file, write feature file, BDD scenario, Given When Then, Cucumber/Behave/SpecFlow, acceptance criteria as scenarios. Write declarative, standard-compliant Gherkin .feature files."
license: Apache-2.0
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write, Grep, Glob
triggers:
  - gherkin-feature-writer
  - write gherkin
  - write a feature file
  - create .feature file
  - BDD scenario
  - given when then
  - acceptance criteria as scenarios
---

# Gherkin Feature Writer

## When to Use

Use this skill when the user asks to write or normalize a `.feature` file, express behavior or acceptance criteria as Given/When/Then scenarios, or author BDD specs for Cucumber, Behave, SpecFlow, Reqnroll, or any Gherkin-compatible runner.

Use it to produce standard-compliant, **declarative** Gherkin that reads as living documentation and stays maintainable as the system evolves.

Do NOT use this skill to write step-definition / glue code, design the feature itself, or convert exhaustive boundary tables that belong in unit tests. This skill writes the specification, not the automation.

## Operating Workflow

1. **Capture the behavior.** Identify the feature, the business value, the actor, and the distinct behaviors to specify. If intent is unclear, ask one clarifying question before writing.
2. **One behavior per scenario.** Split each distinct rule/outcome into its own scenario. Apply the Cardinal Rule of BDD: one scenario, one behavior.
3. **Choose constructs.** Pick keywords and structures per the Decision Rules table. Read `references/gherkin-reference.md` for exact syntax before using Background, Scenario Outline, Data Tables, Doc Strings, or Rule.
4. **Write declaratively.** State intent and observable outcomes, not UI keystrokes. Apply `references/gherkin-best-practices.md`.
5. **Structure the file.** Follow the Output Contract, using `assets/feature-template.feature` as the scaffold. One `Feature` per file; capitalize keywords.
6. **Self-check.** Run the Quality Checklist before returning. Fix violations rather than reporting them.

## Decision Rules

| Situation | Use |
|---|---|
| High-level intent, business-readable spec | Declarative style (default) |
| Precondition shared by ALL scenarios in the file | `Background` (keep it short; only true shared setup) |
| Same behavior across several input/output sets | `Scenario Outline` + `Examples` with `<placeholder>` |
| Grouping scenarios under one business rule | `Rule` (Gherkin v6+) with nested examples |
| Structured input/output data for one step | Data Table (`\|`) or Doc String (`"""`) |
| Categorizing/filtering runs (smoke, wip, regression) | Tags (`@tag`) above Feature/Scenario |
| Step needs "and"/"but" continuation | `And` / `But` — never a conjunction inside one step |
| Dozens of boundary rows or exhaustive edge cases | Push to unit tests; keep Gherkin to stakeholder-relevant behavior |

### Keyword roles (do not mix)
- `Given` — preconditions / existing state. No actions, no assertions.
- `When` — the single action or event under test.
- `Then` — observable, verifiable outcome. No actions.
- `And` / `But` / `*` — continue the previous step type.

## Output Contract

Produce a valid `.feature` file with this structure (see `assets/feature-template.feature`):

```
@optional-feature-tags
Feature: <concise capability name>
  As a <role>
  I want <capability>
  So that <business value>

  Background:            # optional — shared preconditions only
    Given <shared state>

  @optional-scenario-tags
  Scenario: <one concise behavior, stated as outcome>
    Given <precondition>
    When <single action>
    Then <observable outcome>
    And <additional outcome>
```

Rules: one `Feature` per file; keep scenarios to a single-digit step count (<10); each scenario independent (no scenario depends on another's side effects); third-person consistent voice; descriptive scenario titles that name the behavior, not the procedure.

## Quality Checklist

Before returning the file, verify:
- [ ] Exactly one `Feature` with a value statement (role / capability / benefit).
- [ ] Each scenario covers ONE behavior with a behavior-naming title.
- [ ] Declarative phrasing — no UI mechanics (clicks, keystrokes, selectors).
- [ ] `Given`/`When`/`Then` used in their correct roles; no actions in `Then`, no assertions in `Given`.
- [ ] No single step contains a hidden "and"; chained steps use `And`/`But`.
- [ ] Scenarios are independent and under ~10 steps each.
- [ ] `Scenario Outline` used only for variations of the same behavior; `Examples` columns match `<placeholders>`.
- [ ] `Background` holds only setup shared by all scenarios; no assertions in it.
- [ ] Keywords capitalized; tables aligned; file ends in `.feature`.
- [ ] No exhaustive boundary data that belongs in unit tests.

## References

- `references/gherkin-reference.md` — standard keyword/syntax reference with examples. Read before using advanced constructs.
- `references/gherkin-best-practices.md` — declarative style, anti-patterns, titling, step-count rules.
- `assets/feature-template.feature` — annotated scaffold and worked declarative example.
