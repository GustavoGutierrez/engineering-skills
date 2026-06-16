# Annotated scaffold — replace bracketed text and delete optional blocks you do not need.
# One Feature per file. Capitalize keywords. Write declaratively (intent, not UI mechanics).

@feature-tag
Feature: [Concise capability name]
  As a [role]
  I want [capability]
  So that [business value]

  # Optional — only for preconditions shared by ALL scenarios. No assertions here.
  Background:
    Given [shared precondition]

  @smoke
  Scenario: [One behavior, named as an outcome]
    Given [precondition / existing state]
    When [single action or event]
    Then [observable, verifiable outcome]
    And [additional outcome]

  # Use for the SAME behavior across a small set of meaningful inputs/outputs.
  Scenario Outline: [Behavior that varies by data]
    Given a "<input>" precondition
    When the action runs
    Then the result is "<expected>"

    Examples:
      | input   | expected        |
      | valueA  | outcomeA        |
      | valueB  | outcomeB        |

  # Optional — group scenarios under one business rule (Gherkin v6+).
  Rule: [Business rule statement]

    Example: [Concrete case satisfying the rule]
      Given [precondition]
      When [action]
      Then [outcome]


# ---------------------------------------------------------------------------
# Worked example (declarative). Delete before shipping your own feature.
# ---------------------------------------------------------------------------

@subscriptions
Feature: Article access by subscription level
  As a subscriber
  I want articles gated by my plan
  So that I only see content my subscription includes

  Background:
    Given the article catalog is published

  Scenario: Free subscribers see only free articles
    Given a free subscriber is signed in
    When they open the article list
    Then only free articles are shown

  Scenario Outline: Subscribers see articles for their level
    Given a "<level>" subscriber is signed in
    When they open the article list
    Then they see "<visibility>" articles

    Examples:
      | level   | visibility       |
      | free    | free             |
      | premium | free and premium |
