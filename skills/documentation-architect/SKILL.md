---
name: documentation-architect
description: "Design scalable, navigable documentation ecosystems for onboarding, architecture, operations, ADRs, runbooks, and reference; use when asked to architect docs, plan information architecture, design doc systems, organize knowledge bases, structure living documentation, or fix documentation fragmentation."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write, WebSearch
triggers:
  - documentation-architect
  - documentation architect
  - document architecture
  - information architecture
  - design documentation ecosystem
  - documentation strategy
  - living documentation
  - docs-as-code
  - documentation site architecture
  - onboarding documentation structure
  - architecture decision documentation
---

# Documentation Architect

## Purpose

Use this skill to act as a senior documentation architect who designs scalable, navigable, and maintainable documentation ecosystems. The skill goes beyond writing individual docs — it shapes the entire system of documents: how they are organized, cross-linked, owned, updated, and discovered.

This skill is domain-generic. It must work for any software project, platform, or team without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Architect a documentation ecosystem from scratch or restructure an existing one.
- Design the information architecture for a project, platform, or knowledge base.
- Establish documentation ownership, lifecycle, and maintenance workflows.
- Resolve documentation fragmentation, discoverability, or onboarding gaps.
- Structure architecture decision records, runbooks, reference docs, or release notes.
- Integrate arc42, C4, ADRs, or diagram-as-code into a living doc system.
- Define docs-as-code conventions, tooling, and review workflows.
- Plan documentation for onboarding, operations, architecture evolution, or system handover.

Do not use this skill for writing a single document from scratch (use a spec-writer or document writer skill instead). Use this skill when the problem is systemic: the doc structure, the ecosystem design, or the workflow that surrounds the documents.

## Relationship to Other Skills

| Skill | Role | Use When |
|---|---|---|
| `spec-architect` | Designs system specs before implementation | Requirements are defined and you need a spec |
| `solution-architect` | Designs technical architecture | System-level decisions and patterns are needed |
| `decision-record-writer` | Writes individual ADRs | A decision needs to be captured in ADR format |
| `togaf-writer` | Produces enterprise architecture artifacts | TOGAF-aligned EA work products are required |
| **This skill** | Designs doc ecosystems, IA, and workflows | The problem is structural, not a single deliverable |

This skill operates at a higher level of abstraction: it decides what documents exist, how they relate, who owns them, when they are updated, and how people find them.

## Core Operating Rules

1. **Design the ecosystem first, documents second.** Start by mapping audience, use cases, ownership, and lifecycle before writing a single document structure.
2. **Separate living docs from historical docs from generated docs.** Each type has different ownership, update cadence, and tooling expectations.
3. **Audience first, structure second.** Navigation and discoverability must follow how people actually search, not how authors organize.
4. **Make cross-linking structural, not accidental.** Every doc should reference its related docs explicitly; don't rely on tribal knowledge or memory.
5. **Define doc ownership as clearly as code ownership.** If a document has no owner, it is not a living doc — it is an orphan.
6. **Make the maintenance workflow explicit.** Docs that are not updated become liabilities. Define who updates what, when, and how.
7. **Use neutral generic placeholders.** Say `external system`, `domain user`, `system of record`, `approved provider` instead of invented project names or vendors.
8. **Keep SKILL.md concise.** Detailed guidance for Mermaid, arc42, C4, ADRs, and docs-as-code lives in `references/` and is referenced from here.

## Document Categories

Every documentation ecosystem should address these three categories with distinct treatment:

### Living Documents

Documents that are actively maintained, reviewed, and updated as the system evolves.

| Type | Purpose | Update Trigger | Owner |
|---|---|---|---|
| Architecture Decision Records (ADRs) | Capture significant decisions with context and rationale | New or changed decision | Architect or Tech Lead |
| Runbooks | Operational procedures for normal and exceptional operations | Process or system change | Operations or SRE |
| Onboarding guides | Help new team members become productive | Major structural or process change | Engineering Manager |
| Architecture overview | System-level understanding for engineers and stakeholders | Architectural changes | Solution Architect |

### Historical Documents

Documents that capture what happened but are no longer actively maintained. They serve as a record, not a guide.

| Type | Purpose | Treatment |
|---|---|---|
| Release notes (past) | Historical record of shipped features and changes | Archive after 2 major versions |
| Old ADRs | Preserved decisions that still influence current design | Keep but mark as superseded |
| Migrated docs | Docs replaced during restructuring | Archive in `/archive` or equivalent |

### Generated Documents

Documents produced by tooling or CI/CD pipelines. They should not be manually edited.

| Type | Generated From | Owner |
|---|---|---|
| API reference | OpenAPI/AsyncAPI specs | CI/CD / Spec tool |
| Dependency inventory | Lock files | CI/CD |
| Test coverage reports | Test runs | CI/CD |
| Changelogs | Git history | Release tooling |

## Information Architecture Framework

### Layer 1 — Entry Points

Every ecosystem needs clear entry points mapped to user intent:

| Entry Point | User Intent | Typical Content |
|---|---|---|
| `/README` | Orientation, quick start | What is this, how to run it, who to ask |
| `/onboarding` | New team member getting productive | Environment setup, first tasks, key contacts |
| `/architecture` | Understanding the system | System overview, key decisions, diagrams |
| `/operations` | Keeping the system running | Runbooks, monitoring, deployment, rollback |
| `/reference` | Looking up specifics | API docs, config schemas, ADR index |
| `/contributing` | Making changes | Commit standards, review process, tooling |

### Layer 2 — Cross-Linking Structure

Documents should cross-link to related documents explicitly:

```markdown
## Related Documents

- [Architecture Overview](./architecture/overview.md) — system-level context
- [ADR-042](./decisions/adr-042.md) — decision behind this choice
- [Runbook: Deployment](./operations/runbooks/deployment.md) — how to deploy this service
```

Every document in a living ecosystem should have a `Related Documents` section or equivalent.

### Layer 3 — Navigation and Discoverability

Navigation must reflect how users think, not how authors organize:

- **By role**: Onboarding / Engineer / Operations / Stakeholder
- **By task**: Explore the system / Make a change / Operate the system / Contribute
- **By lifecycle**: Getting started / Deep dive / Reference / Archive

Choose one primary navigation model based on the primary audience mix.

## Documentation Lifecycle and Ownership

### Ownership Model

Assign explicit owners at the document level:

```markdown
| Document | Owner | Review Cadence | Update Trigger |
|---|---|---|---|
| Architecture Overview | Solution Architect | Quarterly | Any architectural change |
| ADRs | Tech Lead | On-change | New significant decision |
| Runbooks | SRE/Ops | Monthly | Process or system change |
| Onboarding | Engineering Manager | Quarterly | Team or process restructure |
```

### Version and Staleness

- Living docs should have a last-reviewed or last-updated date visible on the document.
- Docs older than 12 months with no update record should be flagged as stale.
- Stale docs should be reviewed, updated, or archived — never left as false information.

### Update Workflows

| Event | Action |
|---|---|
| New feature shipped | Update relevant runbook, ADR, and release notes |
| Architecture decision made | Create or update ADR; update architecture overview |
| Process change | Update onboarding and relevant runbook |
| Ownership change | Update doc owner field and notify stakeholders |

## Framework Integration Guide

### arc42

Apply arc42 structure at the documentation ecosystem level, not per document. A project using arc42 should have:

- `docs/arc42/01-chapter/` — executive summary and context
- `docs/arc42/04-chapter/` — solution strategy and architecture decisions
- `docs/arc42/05-06-chapter/` — building block and runtime views
- `docs/arc42/08-chapter/` — deployment, operations, and infrastructure

Each chapter is a document or document section with a clear owner.

### C4 Model for Diagrams

When the ecosystem includes architecture diagrams, use C4 as the modeling convention:

| Level | Diagram | Purpose |
|---|---|---|
| Context | `flowchart LR` or `C4Context` | External actors and system boundary |
| Container | `flowchart LR` with subgraphs | Deployable units, APIs, databases |
| Component | `flowchart TD` | Internal modules and responsibilities |
| Code | (optional) | Class/component details |

See `references/mermaid-diagrams-in-markdown.md` for Mermaid syntax, common pitfalls, and readability rules. See `references/architecture-diagram-examples.md` for production-ready examples of recurrent architecture diagram patterns.

### ADRs

ADR structure within the ecosystem:

- Located at `docs/decisions/adr-NNN-title.md`
- Naming: `adr-NNN-short-title.md` with zero-padded number
- Index at `docs/decisions/README.md` listing all ADRs with status
- Superseded ADRs kept but marked `Status: Superseded by ADR-XXX`

Link ADRs explicitly from architecture docs, runbooks, and onboarding where decisions are relevant.

## Doc-as-Code Workflow

When the ecosystem uses docs-as-code:

1. **Source of truth is markdown in the repo.** No external wikis for architecture or decision docs.
2. **PR-based doc reviews.** Docs are reviewed like code: PR, review, merge, deploy.
3. **Automated checks:**
   - Link validation (no broken cross-references)
   - Frontmatter completeness (owner, date, related docs)
   - Spelling and style consistency
   - Mermaid syntax validation (use live editor before committing)
4. **CI/CD publication.** Docs are published via the same pipeline that deploys the project.
5. **Version discipline.** Document version matches project version for living docs.

## Audience-First Structure Checklist

For every documentation ecosystem designed, verify:

- [ ] A new team member can find everything they need to be productive without asking
- [ ] An engineer can find the relevant ADR before making a significant change
- [ ] An operator can find the runbook for the procedure they need
- [ ] A stakeholder can find the current architecture without needing an explanation
- [ ] Documents are linked to related documents, not isolated
- [ ] Every living doc has an explicit owner
- [ ] Stale docs are flagged or archived
- [ ] Historical docs are clearly marked as historical
- [ ] Generated docs are not manually edited

## Execution Workflow

### Phase 1: Ecosystem Assessment

1. Identify the current documentation landscape: what exists, where it lives, who owns it.
2. Map audience segments and their primary use cases.
3. Identify gaps: missing docs, orphaned docs, duplicate docs, discoverability failures.
4. Determine what is living, historical, or generated today.

### Phase 2: Target Structure Design

1. Define the entry point hierarchy and primary navigation model.
2. Define document categories and assign owners.
3. Define cross-linking standards and related-docs requirements.
4. Define lifecycle: update triggers, review cadence, staleness threshold.

### Phase 3: Framework Integration

1. Apply arc42, C4, ADRs, or other required frameworks at the ecosystem level.
2. Define Mermaid usage standards and reference the syntax guide.
3. Define docs-as-code workflow and CI/CD requirements if applicable.

### Phase 4: Migration and Maintenance Plan

1. Identify which existing docs need to be created, updated, archived, or deleted.
2. Define the migration path with minimal disruption to active work.
3. Define the maintenance workflow: who does what and when.
4. Define the review cadence and ownership transfer process.

## Required Output Structure

Use this structure for a documentation ecosystem design:

```markdown
# <Project> Documentation Architecture

## 1. Ecosystem Summary
- Primary audience and use cases:
- Current state assessment:
- Target state summary:
- Key gaps identified:

## 2. Audience and Use Cases
| Audience | Primary Use Cases | Entry Points |
|---|---|---|
| New team members | Onboarding, environment setup | /onboarding |
| Engineers | Understand system, make changes | /architecture, /decisions |
| Operators | Run and maintain the system | /operations, /runbooks |
| Stakeholders | Understand architecture and status | /architecture (overview) |

## 3. Document Category Map
| Category | Documents | Owner | Update Trigger | Cadence |
|---|---|---|---|---|
| Living — Architecture | Architecture overview, ADR index | Solution Architect | Decision made | On-change |
| Living — Operations | Runbooks, deployment guide | SRE/Ops | Process change | Monthly |
| Living — Onboarding | Getting started, team guide | Engineering Manager | Structural change | Quarterly |
| Historical | Old release notes, superseded ADRs | — | — | Archived |
| Generated | API reference, dependency inventory | CI/CD | — | On-build |

## 4. Information Architecture
### Entry Point Structure
- `/` → README
- `/architecture/` → System overview and diagrams
- `/decisions/` → ADR index and records
- `/operations/` → Runbooks and operational guides
- `/onboarding/` → New member onboarding
- `/reference/` → API and configuration reference

### Cross-Linking Standards
- Every document includes a `Related Documents` section
- ADRs linked from architecture docs, runbooks, and onboarding where relevant
- Navigation reflects audience intent, not author organization

## 5. Framework Integration
### arc42 Application
| Section | Location | Owner |
|---|---|---|
| 01 — Executive Summary | /architecture/overview.md | Solution Architect |
| 04 — Solution Strategy | /architecture/decisions.md | Solution Architect |
| 05-06 — Building Block / Runtime | /architecture/components.md | Solution Architect |
| 08 — Deployment and Operations | /operations/deployment.md | SRE/Ops |

### C4 Diagram Plan
| Level | Diagram Type | Location |
|---|---|---|
| Context | flowchart LR | /architecture/context.mmd |
| Container | flowchart LR with subgraphs | /architecture/containers.mmd |
| Component | flowchart TD | /architecture/components.mmd |

### ADR Standards
- Location: `/decisions/adr-NNN-title.md`
- Index: `/decisions/README.md`
- Cross-links from architecture and operational docs

## 6. Doc-as-Code Workflow
- Markdown in repo, PR-based reviews
- Automated checks: link validation, frontmatter, Mermaid syntax
- CI/CD publication pipeline
- Owner review triggers on change

## 7. Maintenance and Ownership
| Document / Area | Owner | Review Cadence | Staleness Threshold |
|---|---|---|---|
| Architecture overview | Solution Architect | Quarterly | 12 months |
| ADR index | Tech Lead | On-change | 12 months |
| Runbooks | SRE | Monthly | 6 months |
| Onboarding | Engineering Manager | Quarterly | 12 months |

## 8. Migration Plan
| Action | Priority | Effort | Risk |
|---|---|---|---|
| Archive orphaned historical docs | High | Low | Low |
| Assign owners to living docs without owners | High | Low | Low |
| Create ADR index | Medium | Medium | Low |
| Restructure navigation to audience-first | Medium | High | Medium |
| Migrate to docs-as-code workflow | Low | High | Medium |

## 9. Open Questions
- [Question 1]
- [Question 2]
```

## Quality Bar

Before presenting the result, verify:

- The ecosystem addresses all major audience segments with clear entry points.
- Document categories are explicitly separated into living, historical, and generated.
- Every living document has an explicit owner and update cadence.
- Cross-linking is structural, not optional.
- arc42, C4, and ADR integration are applied at the ecosystem level, not the document level.
- Mermaid usage follows the syntax guide in `references/mermaid-diagrams-in-markdown.md`.
- The maintenance workflow is concrete enough to be executed.
- The output contains no invented project names, client names, or unnecessary concrete technologies.

## Present Results to User

Lead with the ecosystem map and the most critical gaps. Present the target structure before the migration plan. Make ownership and maintenance obligations visible and non-negotiable. If the user has an existing doc landscape, compare the target state to the current state and prioritize accordingly.

## Troubleshooting

- **No clear owner for a doc:** Flag it as orphaned and assign a temporary owner until a permanent one is defined.
- **Docs scattered across wikis and repo:** Establish the repo as the canonical source and migrate in phases.
- **Too many docs, no cross-links:** Start with an ADR index and a single top-level README; add cross-links in rounds.
- **Stale docs with no update path:** Archive them rather than leave them as misleading artifacts.
- **Mermaid rendering issues:** Always test on the target platform; see `references/mermaid-diagrams-in-markdown.md` for common pitfalls.