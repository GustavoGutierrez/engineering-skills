# Traceability Link Vocabulary

Full typed link definitions for the Traceability Manager skill.

## Link Type Specifications

### originates-from

**Direction**: Any artifact → Source artifact
**Meaning**: This artifact was created from or derived from the named source artifact.
**Usage**: Use when a spec, story, task, or API is created based on a PRD, PRP, or higher-level requirement. The source is the originating intent.
**Cardinality**: Many → One (many artifacts can originate from one source)
**Example**: `SPEC-auth.spec.md` originates-from `PRD-auth-v2.prd`

---

### refines

**Direction**: Lower-level artifact → Higher-level artifact
**Meaning**: This artifact provides more detail or clarification for the parent artifact without fully implementing it.
**Usage**: Use when a spec refines a story, when an API spec refines a functional spec, or when a task adds detail to a spec.
**Cardinality**: Many → One
**Example**: `SPEC-auth.spec.md` refines `STORY-oauth-login.story`

---

### implements

**Direction**: Task → Requirement or Spec
**Meaning**: This task directly delivers the behavior described in the requirement or spec.
**Usage**: Use when a task is the unit of work that produces a verifiable implementation of a requirement.
**Cardinality**: Many → One
**Example**: `TASK-auth-002` implements `REQ-AUTH-001`

---

### validated-by

**Direction**: Requirement or Spec → Test or Validation artifact
**Meaning**: This requirement is verified or validated by the named test, check, or validation artifact.
**Usage**: Use when linking acceptance criteria, requirements, or specs to their verification artifacts.
**Cardinality**: Many → Many
**Example**: `REQ-AUTH-001` validated-by `TEST-auth-login.spec.js`

---

### depends-on

**Direction**: Any artifact → Any artifact
**Meaning**: This artifact cannot be started or completed until the named artifact is resolved or delivered.
**Usage**: Use for technical dependencies, environmental dependencies, or sequential workflow dependencies. Not for inheritance or refinement — those use `refines` or `implements`.
**Cardinality**: Many → Many
**Example**: `TASK-auth-003` depends-on `TASK-auth-002` (auth module must exist before token refresh can be built)

---

### affects

**Direction**: Any artifact → Any artifact
**Meaning**: A change to this artifact is likely to impact the named artifact.
**Usage**: Use for lateral impact assessment — not a dependency chain, but a risk relationship. When the originating artifact changes, the affected artifact should be reviewed.
**Cardinality**: Many → Many
**Example**: `SPEC-auth.spec.md` affects `SPEC-checkout.spec.md` (auth changes may impact checkout flows)

---

### governed-by

**Direction**: Any artifact → Policy or Standard
**Meaning**: This artifact must comply with the named policy, standard, regulation, or architectural governing document.
**Usage**: Use when linking artifacts to security standards, compliance requirements, architectural decisions, or organizational policies.
**Cardinality**: Many → Many
**Example**: `API-auth endpoints` governed-by `POLICY-security-compliance`

---

## Coverage Rules by Artifact Type

| Artifact Type | Minimum Forward Coverage | Required Link Types |
| --- | --- | --- |
| Requirement (REQ) | At least one `validated-by` link to a test or validation | `implements` (from task), `validated-by` (to test) |
| Spec (SPEC) | At least one `implements` link to a task | `originates-from` or `refines`, `implements` |
| Story (STORY) | At least one `implements` link to a task | `refines` or `originates-from`, `implements` |
| Task (TASK) | At least one backward `implements` or `refines` link to a requirement or spec | `implements` or `refines` |
| API | At least one `refines` link to a requirement or spec | `refines`, `validated-by` |
| Test / Validation | At least one `validated-by` link back to a requirement | `validated-by` |

## Orphan Thresholds

| Orphan Type | Severity | Default Action |
| --- | --- | --- |
| `orphan-requirement` | High | Block implementation; require link to task or validation before proceeding |
| `orphan-task` | Medium | Require parent spec or requirement link; if no parent found, mark as infrastructure |
| `orphan-api` | High | Require `refines` link to requirement or spec before implementation |
| `orphan-validation` | Medium | Require `validated-by` link to requirement; if test is exploratory, mark accordingly |
| `orphan-policy` | Low | Flag for governance review; suggest applicable `governed-by` link |

## Change Impact Rules

1. **Immediate (distance 1)**: Directly linked artifacts — review and update links.
2. **Proximate (distance 2)**: Transitive links — verify coverage still holds.
3. **Lateral (affects)**: Cross-cutting concerns — assess for unintended side effects.

When a requirement changes:
- Trace all `implements` links forward.
- Trace all `originates-from` and `refines` links backward.
- Present the full impact set grouped by distance.

## Bidirectional Traceability Enforcement

Forward path must exist for every requirement:
`Requirement → (implements) → Task → (validated-by) → Test/Validation`

If any link in the chain is missing, the requirement is not fully covered.

Backward path must exist for every task:
`Task → (implements or refines) → Requirement or Spec`

If a task has no backward link, it may be ungoverned or derived from the wrong source.
