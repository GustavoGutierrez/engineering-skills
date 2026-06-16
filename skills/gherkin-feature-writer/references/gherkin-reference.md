# Gherkin Syntax Reference

Standard Gherkin keywords and structures. English is the default; Gherkin is localizable via `# language: <code>` on the first line, but prefer English unless the project already uses another language.

## File rules
- One `.feature` file contains exactly one `Feature`.
- Each non-blank line starts with a keyword, except free-form description text under `Feature`, `Rule`, `Background`, `Scenario`, and `Scenario Outline`.
- Capitalize keywords. Indent with 2 spaces per level.
- Comments start with `#`. Tags start with `@` and sit on the line above the element.

## Primary keywords

| Keyword | Purpose | Aliases |
|---|---|---|
| `Feature` | High-level capability; groups scenarios. Must be the first primary keyword. | — |
| `Rule` (v6+) | Represents one business rule; groups related examples. | — |
| `Background` | Steps run before every scenario in the Feature/Rule. | — |
| `Scenario` | A single concrete behavior. | `Example` |
| `Scenario Outline` | A scenario template run once per `Examples` row. | `Scenario Template` |
| `Examples` | Data table feeding a Scenario Outline. | `Scenarios` |
| `Given` `When` `Then` `And` `But` `*` | Steps. | — |

## Feature with value statement

```gherkin
Feature: Subscription article access
  As a subscriber
  I want articles gated by my subscription level
  So that I only see content included in my plan
```

The `As a / I want / So that` block is free-form description text (ignored at runtime, valuable as documentation).

## Scenario

```gherkin
Scenario: Free subscribers see only free articles
  Given a free subscriber is logged in
  When they open the article list
  Then only free articles are shown
```

## Background (shared preconditions only)

```gherkin
Background:
  Given the article catalog is published
```

Do not put assertions in `Background`. Use it only for setup common to ALL scenarios; overuse hides context.

## Scenario Outline + Examples

```gherkin
Scenario Outline: Subscribers see articles for their level
  Given a "<level>" subscriber is logged in
  When they open the article list
  Then they see "<visibility>" articles

  Examples:
    | level   | visibility      |
    | free    | free            |
    | premium | free and premium|
```

Placeholders use `<name>` and must match `Examples` column headers. Use Scenario Outline only for variations of the SAME behavior — not as a dumping ground for dozens of boundary rows.

## Data Table (structured step argument)

```gherkin
Scenario: Import users from a roster
  Given the following users exist:
    | name  | role   |
    | Ada   | admin  |
    | Lin   | member |
  When the roster sync runs
  Then 2 users are active
```

## Doc String (multi-line text argument)

```gherkin
Scenario: Render a markdown note
  Given a note with body:
    """
    # Title
    A paragraph.
    """
  When the note is rendered
  Then the output contains a heading "Title"
```

Doc strings use triple quotes `"""` or triple backticks; an optional media type may follow the opening delimiter.

## Rule (group scenarios under a business rule)

```gherkin
Rule: Only admins can delete records

  Example: Admin deletes a record
    Given an admin is logged in
    When they delete a record
    Then the record is removed

  Example: Member cannot delete a record
    Given a member is logged in
    When they attempt to delete a record
    Then deletion is rejected
```

## Tags

```gherkin
@billing
Feature: Invoicing

  @smoke
  Scenario: Issue an invoice
    ...
```

A tag on `Feature` cascades to all its scenarios. Common conventions: `@smoke`, `@regression`, `@wip`. Use tags to filter test runs, not to encode behavior.
