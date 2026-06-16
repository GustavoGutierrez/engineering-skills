# Gherkin Best Practices

Apply these when writing or normalizing `.feature` files. They keep scenarios readable as living documentation and maintainable as the product evolves.

## Declarative over imperative (most important)

Describe the intended behavior and its business value, not the keystrokes used to achieve it. Declarative scenarios survive UI changes; imperative ones break on every redesign.

**Imperative (avoid):**
```gherkin
Scenario: Search
  Given I open the browser
  And I navigate to "/login"
  And I type "ada" in the "#user" field
  And I click "#submit"
  When I type "panda" in the search bar
  And I press Enter
  Then ...
```

**Declarative (prefer):**
```gherkin
Scenario: Members can search the catalog
  Given a member is signed in
  When they search for "panda"
  Then matching results are shown
```

The mechanics (navigation, typing, clicking) belong in the step definitions, not the feature file.

## One scenario, one behavior

The Cardinal Rule of BDD. Each scenario specifies a single behavior, rule, or outcome. If a scenario verifies several behaviors, split it. A scenario is a requirement and acceptance criterion, not a procedure script.

## Keep scenarios short

Target a single-digit step count (< 10 steps). Long scenarios usually signal imperative steps or multiple behaviors crammed together. Reduce by writing declaratively and splitting behaviors.

## Write good titles

The title is the first thing read and is logged by runners. It must state the behavior in one concise line — name the outcome, not the procedure.
- Good: `Free subscribers see only free articles`
- Bad: `Test login and then search and check results`

## Correct step roles

- `Given` sets up state/preconditions — no actions, no assertions.
- `When` performs the single action/event under test.
- `Then` asserts an observable outcome — no actions.
- Avoid hidden conjunctions: replace `When I log in and search` with a `When` plus an `And` step, or fold setup into `Given`.

## Independent scenarios

No scenario may depend on state created by another. If deleting one scenario breaks others, the file has coupling problems. Each scenario must set up what it needs (declaratively) and run in isolation/any order.

## Use Background sparingly

Only for preconditions shared by ALL scenarios in the file. Never place assertions in `Background`. If only some scenarios need a setup step, keep it in those scenarios.

## Avoid Scenario Outline abuse

Use `Scenario Outline` for variations of the SAME behavior with a small, meaningful set of examples. Dozens of rows or exhaustive boundary combinations indicate testing at the wrong level — push those to unit tests, which run faster and give precise feedback. Reserve Gherkin for behaviors stakeholders care about.

## Consistency

- Capitalize keywords.
- Use a consistent third-person voice (e.g., "a member", "the system") rather than mixing "I"/"the user"/"you".
- Align data tables and keep column names meaningful.
- Consider a Gherkin lint rule set to enforce style across authors.

## Three Amigos

Good Gherkin comes from shared authorship — business, development, and testing perspectives. Phrase scenarios in domain language all three can read and challenge, not in technical jargon only one role understands.
