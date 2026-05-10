---
name: traceability-manager
description: "Trigger: traceability, requirements traceability, forward traceability, backward traceability, change impact analysis, trace requirements to implementation, RTM, orphan detection, coverage model. Maintain bidirectional requirement-to-implementation traceability with typed links, coverage checks, impact analysis, and governance."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - traceability-manager
  - traceability manager
  - requirements traceability
  - forward traceability
  - backward traceability
  - change impact analysis
  - trace requirements to implementation
  - orphan detection
  - coverage model
  - RTM
---

# Traceability Manager

## When to Use

Use this skill when the user needs to:

- Establish or audit traceability between requirements and implementation artifacts.
- Detect orphans: requirements without coverage, tasks without parents, APIs without source requirements.
- Perform change impact analysis before modifying scoped requirements or artifacts.
- Build or validate a Requirements Traceability Matrix (RTM).
- Govern a traceability model: define typed links, coverage rules, and governance policies.
- Generate a traceability plan or model in Markdown format.

Do NOT use this skill for static spreadsheet management, project management tooling configuration, or business context documentation. It produces executable traceability artifacts and is designed for both human review and agent-driven workflows.

## Core Concepts

### Bidirectional Traceability

Traceability flows in two directions:

- **Forward traceability**: source requirement → design → code → tests → validation
- **Backward traceability**: artifact → source requirement (confirms every implemented item is justified)

Bidirectional traceability enables both coverage analysis (all requirements are implemented) and impact analysis (a change to any artifact can be traced back to its origin).

### Typed Link Vocabulary

Use this controlled set of link types:

| Link Type | Direction | Meaning |
| --- | --- | --- |
| `originates-from` | artifact → source | This artifact is derived from the named source artifact |
| `refines` | lower-level → higher-level | This requirement or task implements or clarifies the parent |
| `implements` | task → requirement | This task delivers the specified requirement |
| `validated-by` | requirement → test | This requirement is verified by the named test or validation |
| `depends-on` | any → any | This artifact requires the named artifact to be complete first |
| `affects` | any → any | A change to this artifact will impact the named artifact |
| `governed-by` | any → policy | This artifact must comply with the named policy or standard |

### Coverage Model

Every requirement must have at least one forward path to a validation artifact. The coverage model distinguishes:

| Coverage Level | Required Links |
| --- | --- |
| `uncovered` | No forward path to any validation artifact |
| `partially-covered` | Forward path exists but not all acceptance criteria are validated |
| `fully-covered` | Full forward path from requirement to acceptance criteria to validation |

### Orphan Detection

Orphan types this skill detects:

| Orphan Type | Definition |
| --- | --- |
| `orphan-requirement` | Requirement with no forward links to tasks or validation |
| `orphan-task` | Task with no backward link to a parent requirement or spec |
| `orphan-api` | API endpoint or contract not linked to a source requirement or spec |
| `orphan-validation` | Test or validation artifact not linked to a traced requirement |
| `orphan-policy` | Artifact with no `governed-by` link to a policy or standard |

## Operating Workflow

### Phase 1: Discover Artifacts

1. Identify the artifacts in scope: PRDs, PRPs, specs, stories, tasks, APIs, architectures, validation artifacts.
2. Use glob and grep across the project to find relevant files with known extensions (`*.md`, `*.spec.md`, `*.prd`, `*.prp`, `*.api.md`).
3. Build a preliminary inventory: artifact ID, type, file path, title or summary.

### Phase 2: Map Relationships

1. For each artifact, inspect content to identify explicit and implicit relationships.
2. Apply the typed link vocabulary to record each relationship.
3. Flag artifacts that lack explicit links as candidates for orphan detection.
4. Identify `governed-by` relationships by checking for embedded policy references.

### Phase 3: Coverage Analysis

1. For each requirement or spec, check for a forward chain to tasks and validation.
2. Classify each requirement into `fully-covered`, `partially-covered`, or `uncovered`.
3. For each validation artifact, verify it has a backward link to a traced requirement.
4. Record uncovered requirements and orphan artifacts.

### Phase 4: Impact Analysis

1. When a requirement or artifact changes, trace its forward and backward links.
2. Identify all artifacts affected in both directions.
3. For each affected artifact, assess the scope of the change.
4. Present the impact set ranked by proximity from the changed artifact.

### Phase 5: Produce Traceability Model

Generate the traceability model as a Markdown document using the required output structure.

## Decision Rules

| Situation | Action |
| --- | --- |
| Requirement has no forward link | Flag as `orphan-requirement`; do not implement until parent is identified |
| Task has no backward link | Flag as `orphan-task`; ask for parent requirement or mark as infrastructure |
| API has no source requirement | Flag as `orphan-api`; require a `refines` link to a requirement or spec before implementation |
| Validation has no backward link | Flag as `orphan-validation`; require a `validated-by` link to a requirement |
| Artifact has no policy link | Flag as `orphan-policy`; suggest a `governed-by` link to an applicable standard |
| Change to a requirement | Trace forward and backward; present full impact set before proceeding |
| Multiple artifacts share a `depends-on` | Consolidate the dependency chain; identify single source of truth |
| Conflicting links detected | Surface the conflict; do not resolve silently; present both paths for human decision |

## Traceability Model Output Structure

```markdown
# Traceability Model

## 1. Overview
- Total artifacts:
- Requirements:
- Tasks:
- APIs:
- Validation artifacts:
- Policies:

## 2. Artifact Inventory
| ID | Type | Title | File | Links Out | Links In | Coverage |
| --- | --- | --- | --- | --- | --- | --- |

## 3. Relationship Graph
| From | Link Type | To | Rationale |
| --- | --- | --- | --- |

## 4. Typed Link Definitions
| Link Type | From | To | Cardinality | Coverage Rule |
| --- | --- | --- | --- | --- |

## 5. Coverage Report
### Fully Covered
| Requirement | Forward Path | Validation |
| --- | --- | --- |

### Partially Covered
| Requirement | Missing Link | Recommendation |
| --- | --- | --- |

### Uncovered (Orphans)
| Requirement | Gap | Recommended Action |
| --- | --- | --- |

## 6. Orphan Report
| Orphan Type | ID | Title | File | Recommended Action |
| --- | --- | --- | --- | --- |

## 7. Change Impact Analysis (when triggered)
### Changed Artifact
- ID:
- Type:
- File:

### Forward Impact (downstream)
| Artifact | Distance | Change Scope |
| --- | --- | --- |

### Backward Impact (upstream justification)
| Artifact | Distance | Rationale |
| --- | --- | --- |

## 8. Governance
- Link integrity rules:
- Minimum coverage standard:
- Policy compliance requirements:

## 9. Recommendations
- Immediate:
- Short-term:
- Long-term:
```

## Traceability Plan Output Structure

When the user requests a traceability plan (vs. a snapshot model), use this structure:

```markdown
# Traceability Plan

## 1. Objectives
- What the traceability model must enable

## 2. Scope
- Artifacts included
- Artifacts excluded
- Boundaries

## 3. Typed Link Architecture
- Defined link types
- Directionality rules
- Cardinality constraints

## 4. Coverage Expectations
- Minimum coverage level per artifact type
- Coverage gap threshold for blocking

## 5. Governance Rules
- Who approves link additions
- Orphan resolution SLAs
- Change impact review triggers

## 6. Workflow Integration
- When to update traceability links
- Who is responsible for each artifact type
- Review cadence

## 7. Reporting
- Coverage reports: frequency and audience
- Orphan reports: frequency and owner
- Impact analysis triggers and audience

## 8. Maintenance
- Link hygiene rules
- Orphan detection schedule
- Coverage recalculation triggers
```

## Quality Checklist

Before presenting the traceability model or plan, verify:

- The output is written in English.
- All artifacts found in scope are listed in the inventory.
- Every relationship uses a defined typed link from the vocabulary.
- Uncovered requirements are listed separately with recommended actions.
- Orphan artifacts are classified by orphan type with recommended actions.
- Change impact analysis covers both forward and backward directions.
- No project-specific names, client names, or unnecessary vendor references were invented.
- The model specifies coverage expectations and governance rules.
- All unknowns are marked as `TBD` rather than invented.

## Files to Read

- `references/link-vocabulary.md` — full typed link definitions with usage examples (load only when the skill body instructs it)
