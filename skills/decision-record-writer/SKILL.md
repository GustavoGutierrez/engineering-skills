---
name: decision-record-writer
description: "Write Architecture Decision Records (ADRs) using append-only supersession model. Trigger: document architectural decision, create ADR, record decision rationale, architecture decision, technical decision log, or decision record."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - decision-record-writer
  - decision record writer
  - write an ADR
  - create an architecture decision record
  - document architectural decision
  - record decision rationale
  - architecture decision
  - technical decision log
  - write decision record
  - ADR
---

# Decision Record Writer

## When to Use

Use this skill when the user asks to document an architectural or technical decision, create an ADR, record a decision rationale, or log a technical choice. The output is a single Markdown ADR file following the append-only supersession model.

## Core Principle: Append-Only / Supersession

Accepted ADRs are **never rewritten**. When a decision is superseded:

- Write a new ADR with the same topic key
- The new ADR links to the one it supersedes
- Both remain in the record as an auditable trail

This produces an immutable, versioned decision log that preserves rationale over time.

## Operating Workflow

### Step 1. Evaluate the Request

Before writing, determine:

1. **Is there a real decision?** Reject requests that ask for vague statements, non-decisions, or feature descriptions. A decision requires a choice between two or more plausible alternatives with tradeoffs.
2. **Is it one decision per ADR?** If the request bundles multiple independent decisions, recommend splitting into separate ADRs.
3. **Can the decision be documented now?** If context, alternatives, or rationale are missing, ask for the missing pieces before writing.

If any of the above blocks progress, pause and ask.

### Step 2. Gather Minimal Viable Context

Collect:

- What is the decision topic (one per ADR)?
- What is the current state or problem?
- What alternatives are on the table?
- What tradeoffs exist between alternatives?
- What consequences (positive and negative) follow from each alternative?
- Who made or will make the decision and why now?

If the user cannot provide at least two plausible alternatives with tradeoffs, the ADR is not ready. Ask or decline.

### Step 3. Write the ADR

Use the required structure below. Output as `adr-{YYYY-MM-DD}-{slug}.md` where slug is a short kebab-case topic descriptor.

Follow the ADR Quality Standards strictly.

## Required ADR Structure

```markdown
# {Decision Title}

## Status
{draft | proposed | accepted | deprecated | superseded}

## Date
YYYY-MM-DD

## Context
<What is the current situation or problem that requires a decision? Why is this decision necessary now?>

## Decision
<What was decided. Be specific about what will be done or what approach was chosen.>

## Alternatives Considered
- **{Alternative A}**: <description> — Tradeoff: <why this was not chosen or what tradeoffs it carries>
- **{Alternative B}**: <description> — Tradeoff: <...>

## Tradeoffs
<Explicit tradeoffs of the chosen path. Do not list only pros; document the costs and compromises.>

## Consequences

### Positive
- <intended positive outcome>

### Negative
- <unintended downside, risk, or cost. This section is mandatory.>

### Risks
- <identified risk>: <mitigation or fallback>

## Scope
<What is covered by this decision>
- <inclusion>

## Out of Scope
<What is explicitly NOT covered>
- <exclusion>

## Deciders
- <name or role>

## Assumptions
- <explicit assumption being made>

## Related ADRs
- Supersedes: <ADR-ID or "none">
- Superseded by: <ADR-ID or "none">
- Related: <ADR-ID or "none">

## Confidence
{high | medium | low} — <brief justification>

## Review Trigger
<Condition or date that should trigger re-evaluation of this decision>
```

## ADR Quality Standards

### Alternatives Must Be Plausible

Do not create a "straw man" alternative that no one would consider. Each alternative must be a real option that someone debated. If only one path exists, the decision is a statement, not a decision — ask the user to confirm.

### Tradeoffs Must Be Explicit

For every chosen alternative, document at least:
- One real cost or compromise
- One reason the other alternatives were not chosen

Avoid listing only benefits. A decision without tradeoffs is not a decision — it is a fact.

### Consequences Must Include Negatives

The Negative Consequences section is **mandatory**. Every real decision has costs. If the user refuses to acknowledge negative consequences, document the refusal in Assumptions.

### Risks Must Be Identified

Every ADR must include at least one risk unless the decision is trivial. Risks without mitigations are still worth recording.

### One Decision Per ADR

If you detect multiple distinct decisions in the request:
1. Stop writing
2. Tell the user which decisions are mixed together
3. Recommend splitting into N separate ADRs
4. Ask which one to address first

Do not bundle decisions even if the user insists. Offer to process them sequentially.

### Refusal Conditions

Refuse to write an ADR when:
- Only one alternative is identified (no decision to make)
- No tradeoffs are provided or obtainable
- The "decision" is a feature description in disguise
- Critical context is missing and the user cannot provide it

When refusing, state the reason clearly and say what is needed to proceed.

## When to Ask Before Writing

Pause and ask when:
- The request mixes multiple decisions
- The user cannot name at least two alternatives with tradeoffs
- The decision is trivial (implementation detail with no architectural impact)
- Context is incomplete but the user insists on proceeding

Ask only for the information that changes the outcome. Do not over-ask.

## ADR Filename Convention

Derive from the decision topic. Use the date of the decision:

`adr-2026-01-15-choose-postgres-for-primary-store.md`

If draft: `adr-2026-01-15-choose-postgres-for-primary-store-draft.md`

## Quality Checklist

Before finalizing an ADR, verify:

1. Does the ADR contain at least two alternatives with tradeoffs?
2. Does the Tradeoffs section include at least one cost of the chosen path?
3. Does the Negative Consequences section include at least one real downside?
4. Does the Risks section contain at least one risk (or explicitly state "no material risks identified")?
5. Is the Status accurate?
6. Is the Review Trigger defined?
7. Is the Confidence rating justified?
8. Are Related ADRs links complete?

If any mandatory item is missing, do not finalize.

## Example Triggers

**Good trigger:** "We need to decide between Postgres and MongoDB for the primary store. The team is split and we have data volume of ~50k records/day."

→ Write an ADR with two real alternatives, tradeoffs, and consequences.

**Bad trigger:** "Create an ADR for our new auth system." → This is a feature, not a decision. Ask what architectural choice needs to be made.

## Files to Read

- `references/adr-format.md`: full ADR template and field explanations

## References

- **ADR format**: [references/adr-format.md](references/adr-format.md)
