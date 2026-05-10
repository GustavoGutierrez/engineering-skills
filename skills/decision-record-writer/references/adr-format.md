# ADR Format Reference

Complete field explanations for writing Architecture Decision Records.

## ADR vs. Other Documents

ADRs document **architectural decisions** — choices that affect structure, behavior, or cross-cutting concerns of a system. ADRs are not:

- Feature specs (what to build)
- Task plans (how to implement)
- Project requirements (business goals)
- Technical specs (implementation details of one component)

An architectural decision has at least two plausible alternatives, tradeoffs, and consequences that affect the system's shape.

## Field-by-Field Guide

### Status

| Status | Meaning |
|---|---|
| `draft` | Writing in progress, not yet reviewed |
| `proposed` | Under review, not yet accepted |
| `accepted` | Approved and active |
| `deprecated` | No longer relevant but kept for audit |
| `superseded` | Replaced by a newer ADR |

Never use `rejected` — if an alternative was rejected, it belongs in Alternatives Considered with a Tradeoff note.

### Context

Write 2-4 sentences maximum. Include:
- Current state or problem triggering the decision
- Why the decision is needed now
- Any constraints shaping the choice

Do not repeat the title in the Context. The title is the decision; the Context explains the situation.

### Decision

State the decision in one specific, action-oriented sentence. Use active voice. Example:

**Good:** "Use synchronous replication with a single read replica for the primary datastore."

**Bad:** "We will evaluate different options for data storage." (vague, not a decision)

### Alternatives Considered

List each alternative with:
- A descriptive name
- A brief description (1-2 sentences)
- One trade-off or reason it was not chosen

Minimum two alternatives. Do not include straw men — each alternative must be a genuine option someone would consider.

Format:
```markdown
- **{Alternative Name}**: <description> — Tradeoff: <tradeoff or reason not chosen>
```

### Tradeoffs

Explicitly state what compromises the chosen path requires. Do not list only benefits.

Examples:
- "Chosing PostgreSQL over MongoDB trades schema flexibility for strong consistency and SQL query power."
- "Event-driven architecture trades simplicity for eventual consistency complexity in the read model."

### Consequences — Negative

This section is **mandatory**. Every decision has costs. Examples:
- "Postgres foreign key constraints add write latency of ~1-2ms per transaction."
- "Caching layer introduces staleness risk of up to 30 seconds."
- "Microservices increase operational complexity and require service mesh."

If the user refuses to provide negative consequences, note in Assumptions: "User declined to articulate negative consequences of this decision."

### Consequences — Risks

Format as `<risk>: <mitigation or fallback>`. Examples:
- "Primary store failure: mitigated by daily backups and point-in-time recovery."
- "Vendor lock-in: fallback is documented export procedure using standard data formats."

If no material risks exist, write: "No material risks identified beyond standard operational risks."

### Confidence

| Rating | When to Use |
|---|---|
| `high` | Well-understood tradeoffs, precedent exists, team has experience |
| `medium` | Some uncertainty about scale, partial precedent, some unknowns |
| `low` | New territory, novel technology, significant assumptions without validation |

Justify in one sentence.

### Review Trigger

Be specific. Examples:
- "Re-evaluate if request volume exceeds 10,000 rpm."
- "Revisit after 6 months or when the approved vendor releases a major version."
- "Revisit if latency p99 exceeds 200ms in production."

Vague triggers like "review annually" are not useful. Be specific about the condition or time box.

## Supersession Model

When decision X supersedes decision Y:

1. Update Y's Status to `superseded` and add `Superseded by: ADR-ID`
2. Write new ADR-X with `Supersedes: ADR-ID`
3. Both remain in the record

Never delete or rewrite Y. The audit trail is the value.

## ADR Numbering

ADRs are numbered sequentially in the filename when the number is meaningful. When dates are used as the primary identifier (preferred), the sequence is implied:

`adr-2026-01-15-choose-postgres-for-primary-store.md`

The date is the decision date, not the writing date.

## Markdown Formatting Rules

- Use `**Alternative Name**` for bold alternative names
- Use `-` for bullet items
- Use `###` for sub-sections (Consequences > Positive)
- Keep lines under 120 characters where practical
- Use inline code for ADR IDs: `ADR-001`
