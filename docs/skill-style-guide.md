# Skill Style Guide

Normative reference for creating and editing skills in this repository.

## What Is a Skill

A skill is a **runtime instruction contract** for an LLM agent — not human documentation, not a tutorial, not a project artifact.

A skill packages:

- **Behavior**: how to perform a task
- **Methodology**: step-by-step reasoning mode
- **Rules**: explicit constraints and decision rules
- **Output format**: expected structure and quality bar
- **Quality gates**: how to self-verify before returning

A skill must **not** contain project-specific context, business data, mutable requirements, or one-off decisions.

## The Core Rule: Reusable Capability, Not Project Context

| Must Contain | Must NOT Contain |
|---|---|
| Behavior, methodology, rules | Specific business context |
| Output format standards | Project or customer names |
| Decision rules and constraints | Unnecessary concrete technologies |
| Quality bar and verification | Temporary timeline details |
| Expected output structure | Mutable project requirements |

A skill that requires project context to function is not reusable. Prefer generic capability descriptions (e.g., `domain module`, `external dependency`, `system of record`) over vendor-specific names.

## SKILL.md Anatomy

```
skills/{skill-name}/
├── SKILL.md              # Required — main skill file
├── scripts/              # Optional — executable bash scripts
│   └── {script-name}.sh
├── references/           # Optional — documentation loaded only when needed
│   └── {topic}.md
└── assets/               # Optional — templates, schemas, fixtures
    └── {template}.md
```

**Progressive disclosure principle**: SKILL.md is loaded at L2 (triggered), references/assets are loaded at L3 (only when the skill body instructs it). Keep SKILL.md lean; move detail to supporting files.

## Frontmatter — Required Fields

```yaml
---
name: {skill-name}           # kebab-case, must match directory name
description: "Trigger: {essential trigger words users say}. {What this skill does}."
                             # One line, quoted, YAML-safe, <=250 chars.
                             # Include triggers essential first.
license: {SPDX identifier}  # e.g., MIT or Apache-2.0
metadata:
  author: gustavog-gutierrez
  version: "1.0"             # quoted string
allowed-tools: Read, Edit, Write  # minimum tools needed
triggers:
  - {skill-name}
  - {spaced name}
  - {natural language trigger}
  - {task-oriented trigger}
  # At minimum: exact name, spaced name, and 2+ user intents
---
```

### Frontmatter Rules

- `name` must exactly match the folder name (`skills/{skill-name}/`)
- `description` must be a single physical line, quoted, and YAML-safe
- If `description` contains `:` (colon), wrap the value in double quotes
- Special YAML characters (`:`, `#`, `{`, `}`, `[`, `]`) require quoting
- `metadata.version` must be a quoted string (`"1.0"`, not `1.0`)
- `metadata.author` must be `gustavog-gutierrez` for this repository
- `allowed-tools` lists only the minimum tools the skill actually needs

**Common YAML failure modes:**

```yaml
# WRONG — colon without quotes breaks YAML parsing
description: Design systems: patterns, components, and guidelines

# CORRECT — quotes make it YAML-safe
description: "Design systems: patterns, components, and guidelines"
```

## Description and Triggers

The `description` field is the L1 activation signal. Agents use it to decide whether to load the skill.

**Rules for `description`:**

- Write one concise sentence (recommended <=160 chars, hard limit <=250 chars)
- Place trigger words first — the phrases users or agents will actually say
- Describe behavior, not domain; describe capability, not project

**Good examples:**

```yaml
description: "Trigger: spec, requirements, acceptance criteria, implementation-ready documentation. Write or normalize *.spec.md files."
description: "Trigger: review, quality audit, QA gate, validate artifact, check for gaps. Perform rigorous technical reviews of artifacts."
```

**Bad examples:**

```yaml
description: >           # WRONG — folded block is not one line
  Write specs and requirements.
  Trigger: spec writing.
description: "Trigger:"   # WRONG — too vague, no behavior described
```

**Triggers field:** List at minimum the exact skill name, the spaced name, and two or more natural language phrases users would use to invoke the skill.

## SKILL.md Body Structure

Use this section order unless the skill's logic requires a different flow:

```markdown
# {Skill Title}

## When to Use

When the user asks for [capability] or needs [outcome].
Use this skill to [what it does].
Do NOT use this skill for [explicit exclusions].

## Operating Workflow

1. [Step one — concrete and actionable]
2. [Step two]
3. [Step three]

## Decision Rules

| Situation | Action |
|---|---|
| {condition A} | {action or output} |
| {condition B} | {action or output} |

## Output Contract

{Exact schema, format, or structure the skill must produce.}

## Quality Checklist

Before presenting output, verify:
- [ ] {criterion 1}
- [ ] {criterion 2}

## References

- [Topic](references/topic.md) — loaded only when skill body instructs it
```

**Rules for body content:**

- Use imperative voice: "Verify", "Check", "Return", "Fail with" — not "You should" or "It might"
- Keep sections short; prefer tables and checklists over prose
- Include explicit "Do NOT use this skill for X" to prevent misuse
- State expected output format concretely (schema, structure, key fields)
- Add a self-verification checklist so the agent can check before returning

## When to Use `assets/`, `references/`, or `scripts/`

| Need | Directory | Rationale |
|---|---|---|
| Code templates, schemas, fixtures, generated examples | `assets/` | Loaded on demand via skill body reference |
| Conceptual detail, edge case explanation, existing docs | `references/` | Loaded only when skill instructions require it |
| Deterministic tooling that must run identically every time | `scripts/` | Executed by the agent, not loaded as text |
| Long explanation that would bloat SKILL.md | Separate file | Keep SKILL.md under 500 lines |

**Progressive disclosure in practice:**

```markdown
## Files to Read

- `assets/spec-template.md`: reusable writing template
- `references/writing-principles.md`: condensed rules
```

The agent loads these only when the skill body instructs it.

## Style Rules

**Imperative, not tutorial:**
```markdown
# WRONG
You might want to try using the spec template, which can help you
write better requirements if you are new to this format.

# CORRECT
Use `assets/spec-template.md` as the writing scaffold.
```

**Specific and actionable, not vague:**
```markdown
# WRONG
Be careful about security issues.

# CORRECT
Never expose raw SQL in error responses. Return only error codes and
a generic message; log details server-side.
```

**Concrete output expectations:**
```markdown
# WRONG
The output should be good.

# CORRECT
Return a JSON object with required fields: status, payload.errors[],
and payload.data[]. Fail with {"status": "error", "error_code": "INVALID_INPUT"}
when field validation fails.
```

**Generic placeholders, not project names:**
```markdown
# WRONG
Connect to the AcmeCorp™ payment gateway using their SDK.

# CORRECT
Connect to the approved payment provider via its published API.
```

## Examples — How to Write Them

Use neutral, realistic placeholders. Include both happy path and edge cases.

**Good:**
```markdown
Example:

Input: "Create a spec for bulk user import with CSV validation"
Output:
- File: `bulk-user-import.spec.md`
- Sections: Objective, In Scope, Out of Scope, Functional Requirements,
  Guardrails, Verification Plan
- REQ IDs follow `REQ-{DOMAIN}-{NNN}` pattern
```

**Rules for examples:**
- Use neutral placeholders: `existing system of record`, `approved provider`, `domain user`
- Avoid vendor names, product names, or project-specific terms
- Include edge case examples (error states, empty inputs, boundary conditions)
- Show the exact output structure, not just the outcome

## Content Discoverability

Skills are loaded on demand. The `description` and `triggers` control discovery.

**Rules for discoverability:**

- Front-load trigger phrases users actually say: "spec", "review", "create spec", "audit"
- Put the capability in the description, not buried in the body
- `triggers` must include the skill name, spaced name, and 2+ natural language intents
- Avoid synonyms that users would not naturally say; match the words users will type

**Bad discoverability:**
```yaml
description: "Perform cross-agent consistency validation using semantic hashing."
# User would never trigger this with "check my PR" or "review the spec"
```

**Good discoverability:**
```yaml
description: "Trigger: review, quality audit, QA gate, validate artifact, check for gaps.
Audit artifacts for consistency, completeness, clarity, and standards compliance."
```

## Packaging

After creating or updating a skill, create the zip distribution:

```bash
cd skills
zip -r {skill-name}.zip {skill-name}/
```

**Packaging rules:**
- Zip file name must match directory name exactly: `{skill-name}.zip`
- Include all subdirectories (`scripts/`, `references/`, `assets/`) in the zip
- SKILL.md must be at the root of the zip (not nested)

## Validation Checklist

Before committing a new or modified skill, verify:

**Frontmatter:**
- [ ] `name` matches the directory name exactly
- [ ] `description` is one line, quoted, and contains no unescaped colons
- [ ] `license` is a valid SPDX identifier
- [ ] `metadata.author` is `gustavog-gutierrez`
- [ ] `metadata.version` is a quoted string
- [ ] `allowed-tools` lists only tools the skill actually uses
- [ ] `triggers` includes at minimum: exact name, spaced name, 2+ intents

**Body:**
- [ ] Written in English (unless skill is explicitly for localization)
- [ ] Imperative voice throughout — no "you might", "it could", "you should"
- [ ] No project names, customer names, or unnecessary vendor references
- [ ] Output format is specified concretely
- [ ] Self-verification checklist included

**Structure:**
- [ ] SKILL.md under 500 lines
- [ ] Long content moved to `references/` or `assets/`
- [ ] `scripts/` used for deterministic executable steps
- [ ] Section order follows standard anatomy or has a justified reason to differ

**Packaging:**
- [ ] `skills/{skill-name}.zip` exists and matches directory contents
- [ ] Zip root contains SKILL.md at top level

## Common Failure Modes

| Failure | Cause | Fix |
|---|---|---|
| Skill never triggers | `description` is too vague or too long; triggers missing | Lead with trigger words; keep <=250 chars |
| YAML parse error | Unquoted colons in `description` | Wrap `description` in double quotes |
| Context overflow | SKILL.md over 500 lines; embedded long docs | Move detail to `references/` or `assets/` |
| Project leakage | Hardcoded vendor/product names in examples | Use generic placeholders |
| Skill not reusable | Contains project-specific assumptions | Extract to reusable behavior; mark unknown as TBD |
| Output unpredictable | No output format specified | Define exact schema; include examples |
| Agent doesn't self-check | No quality checklist | Add self-verification checklist |

## Reference

This guide is the **normative source** for skill authoring in this repository. When `skill-creator` or any other skill references `docs/skill-style-guide.md`, this file is the authority.

For writing structured specs, see `skills/spec-writer/references/writing-principles.md`.