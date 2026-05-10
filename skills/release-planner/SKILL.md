---
name: release-planner
description: "Trigger: release planning, rollout strategy, release waves, phased rollout, migration sequencing, canary release, rollback planning, go no-go criteria. Design a complete release execution plan connecting technical deployment with operational coordination and stakeholder communication."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - release-planner
  - release planner
  - release planning
  - rollout strategy
  - release waves
  - phased rollout
  - migration sequencing
  - canary release
  - rollback planning
  - release execution plan
  - go no-go criteria
  - release checklist
  - deployment waves
  - release communication plan
  - monitoring checkpoints
  - feature flag rollout
---

# Release Planner

## Purpose

Use this skill to produce a complete, actionable **release execution plan** — the final stage artifact that bridges technical deployment readiness with operational coordination and stakeholder communication.

This skill is not a deployment checklist. It is a first-class planning artifact that integrates rollout waves, migration sequencing, risk mitigation, validation checkpoints, rollback strategy, observability, and communication into a single coherent plan.

This skill is domain-generic. It must work for any software release without embedding project-specific context, vendor names, or product names.

## When to Use

Use this skill when the user asks to:

- Design a rollout strategy for a production release.
- Plan phased release waves with validation gates between each wave.
- Sequence database migrations and data migrations alongside application releases.
- Define a canary or progressive rollout with traffic segmentation.
- Build a rollback plan with decision criteria, procedures, and ownership.
- Produce a go/no-go checklist with measurable criteria.
- Create a release communication plan for stakeholders.
- Map monitoring and observability checkpoints to release waves.
- Assess blast radius and backward/forward compatibility risks.
- Connect deployment sequence, migration plan, and rollout waves into one artifact.

Do not use this skill for application architecture, source-code implementation, product strategy, or project scheduling. Keep the output at release execution planning level.

## Core Operating Rules

1. **Treat deployment sequence, migration plan, and rollout waves as first-class artifacts.** Each serves a different purpose and must be planned separately, then integrated.
2. **Never plan a release without a defined rollback strategy.** If rollback is impossible or would cause data loss, the plan must flag this as a blocking constraint before any wave proceeds.
3. **Blast radius assessment drives wave sizing.** The smaller the blast radius per wave, the smaller the impact of a failed release.
4. **Backward/forward compatibility is a prerequisite for wave sequencing.** Incompatible changes must be resolved before wave planning begins.
5. **Observability must be active before the first user is exposed.** If monitoring cannot detect a failure within the observation window, the wave must not proceed.
6. **Data migration safety is non-negotiable.** Any wave that could leave data in an inconsistent state must be treated as higher risk and gated accordingly.
7. **Go/no-go criteria must be measurable, not subjective.** Use concrete thresholds: error rate delta, latency p99, business KPI deviation, or coverage percentage.
8. **Communication plan is a first-class artifact, not an afterthought.** Stakeholders must know when they will be informed, through which channel, and what the trigger conditions are.

## Release Anatomy: Five First-Class Artifacts

A complete release plan must contain all five of these artifacts:

| Artifact | Purpose | Output |
|---|---|---|
| **1. Deployment Sequence** | Ordered list of what goes out first, second, and last — and why | `deployment-order.md` — dependency graph with rationale |
| **2. Migration Plan** | How data and schema change safely across waves | `migration-plan.md` — backward-compatible migration steps |
| **3. Rollout Waves** | How exposure grows from zero to full across time segments | `wave-plan.md` — wave sizes, segmentation strategy, gate criteria |
| **4. Risk Mitigation** | Blast radius, compatibility risks, and mitigations per wave | `risk-mitigation.md` — per-wave risk register |
| **5. Rollback Strategy** | Decision criteria, procedures, and ownership for reverting each wave | `rollback-plan.md` — criteria, steps, owner per wave |

## Artifact 1: Deployment Sequence

### Definition

The ordered list of deployment steps required to put the release into production. Each step documents what is deployed, what dependencies it has, and what state the system is in after the step.

### Principles

- **Deploy consumers before producers** for backward-compatible changes (new schema first, then new code that writes to it).
- **Deploy producers before consumers** for forward-compatible changes (new code first, then new schema).
- **Database changes are always first or always last** — never interleaved with application code changes unless using the expand/migrate/contract pattern.
- **Feature flags enable decoupling** of deployment from release. Use them to hide unfinished features behind a kill switch.

### Deployment Order Template

```markdown
## Deployment Sequence

| Step | Component | Action | Pre-condition | Post-condition | Rollback |
|---|---|---|---|---|---|
| 1 | Database schema | Apply add-only migrations | Schema version N | Schema version N+1 (additive only) | Revert migration |
| 2 | Configuration | Deploy feature flag config | Flag off | Flag available in off state | Revert flag config |
| 3 | Application (read-only services) | Deploy new version | Old version serving reads | New version serving reads, no new writes | Redeploy old version |
| 4 | Application (write services) | Deploy new version | Write path on old version | Write path on new version | Redeploy old version |
| 5 | Migration completion | Enable new schema paths | Old and new paths both functional | New path exclusive | Revert migration + redeploy old app |
```

## Artifact 2: Migration Plan

### Definition

The plan for safely evolving data and schema across release waves. Covers database schema changes, data transformations, and any dual-write or dual-read patterns.

### The Expand/Migrate/Contract Pattern

Use this three-phase pattern for any schema change that would otherwise be breaking:

**Phase 1 — Expand (add new but keep old):**
- Add new column/table/index.
- Keep old column/table/index.
- Application writes to both old and new.
- Background process migrates existing data.

**Phase 2 — Migrate (verify data):**
- Verify migration completed with data integrity checks.
- Run reads against new path; confirm results match old path.
- Promote new path as primary.

**Phase 3 — Contract (remove old):**
- Stop writing to old column/table.
- Remove old column/table in a subsequent release.

### Migration Safety Heuristics

| Situation | Rule |
|---|---|
| Dropping a column or table | Never without at least one full release cycle of deprecation warning |
| Renaming a column | Use add + dual-write + migrate + contract pattern |
| Changing a data type | Expand first; migrate data; contract old type only after full wave success |
| Adding an index | Online index creation preferred; avoid table locks; schedule during low-traffic |
| Large data migration (>10M rows) | Run as background batch job per wave; never in a blocking transaction |
| Schema change that breaks old code | Must be resolved before wave 1; flag as blocking |

### Migration Plan Template

```markdown
## Migration Plan

### Schema Changes
| Step | Change | Compatibility | Wave | Rollback |

### Data Migrations
| Step | Query/Job | Volume | Blocking? | Batch Size | Wave |

### Dual-Write / Dual-Read Pattern
| Phase | State | Application Behavior |
|---|---|---|
| Expand | Both schemas writable | Write to old and new |
| Migrate | New primary, old verify | Read both; compare; log mismatches |
| Contract | New exclusive | Stop writing to old |
```

## Artifact 3: Rollout Waves

### Definition

The progressive increase in user or traffic exposure across defined waves. Each wave is gated by validation checkpoints before the next wave begins.

### Wave Sizing Heuristics

| Risk Profile | Wave 1 Size | Subsequent Waves |
|---|---|---|
| Low risk (bug fix, config-only, fully featured flag) | 1–5% or internal users | 10%, 25%, 50%, 100% |
| Medium risk (new feature, schema change) | 0.5–1% external users | 5%, 15%, 50%, 100% |
| High risk (breaking change, data migration, new service) | Internal-only or canary | 1%, 5%, 25%, 100% |

### Segmentation Strategy

Choose the segmentation that best matches the risk and the system's user topology:

- **Percentage of users** — simplest, uniform risk distribution.
- **Geographic region** — use when latency or data residency matters.
- **User cohort** — internal users, beta users, premium users.
- **Traffic weight** — route X% of requests to new version via load balancer or service mesh.
- **Feature flag** — enable new feature for a specific flag rule.

### Wave Gate Criteria

Before each wave advances, all of these must be true:

| Gate | Threshold |
|---|---|
| Error rate delta | < +0.5% above baseline |
| Latency p99 delta | < +10% above baseline |
| Business KPI deviation | Within ±5% of baseline window |
| Monitoring coverage | 100% of critical paths instrumented |
| Rollback readiness | Rollback procedure tested and documented |
| Stakeholder sign-off | Authorized before wave 3+ |

### Rollout Waves Template

```markdown
## Rollout Waves

### Wave Definition
| Wave | Segment | Size | Trigger | Hold Duration |

### Traffic Segmentation
| Segment | Strategy | Size | Instruments |

### Wave Gate Criteria
| Gate | Metric | Threshold | Observation Window |
|---|---|---|---|
```

## Artifact 4: Risk Mitigation

### Blast Radius Heuristics

| Change Type | Blast Radius | Mitigation Required |
|---|---|---|
| Pure configuration change | Single service restart | Feature flag, quick rollback |
| New feature (no schema change) | New code only | Canary wave, monitoring active |
| Schema change (additive) | Read path first, then write | Expand/migrate/contract, dual-read verification |
| Breaking schema change | Full system if done wrong | Blocking — resolve before wave 1 |
| Data migration job | Dependent reads/writes | Batch per wave, observability per batch |
| New service dependency | All consumers | Staged rollout with circuit breaker |

### Compatibility Risk Classification

| Risk | Classification | Rule |
|---|---|---|
| Old code reads new schema | Backward compatible | Safe to proceed |
| New code writes old schema | Forward compatible | Safe to proceed |
| Old code cannot handle new schema fields | Backward incompatible | Block wave 1 |
| New code assumes new schema (not present in old) | Forward incompatible | Block wave 1 until schema is deployed |

### Risk Mitigation Template

```markdown
## Risk Mitigation

### Blast Radius by Wave
| Wave | Change | Blast Radius | Affected Components | Mitigation |

### Compatibility Risks
| Risk | Type | Wave Affected | Resolution |

### Data Migration Risks
| Risk | Volume | Mitigation |
|---|---|---|
```

## Artifact 5: Rollback Strategy

### Definition

The documented, tested procedure for reverting each wave. Includes decision criteria, rollback triggers, step-by-step procedures, and ownership.

### Rollback Trigger Conditions

Define explicit, measurable triggers — never subjective:

| Trigger Type | Criteria |
|---|---|
| Error rate | Error rate exceeds +1% above baseline for > 5 minutes |
| Latency | p99 latency exceeds 2× baseline for > 3 minutes |
| Business impact | Conversion rate drops > 10% below baseline |
| Data integrity | Any data loss, corruption, or inconsistent state detected |
| Monitoring failure | Observability goes dark for > 2 minutes during wave |
| Manual override | Designated owner calls rollback based on qualitative judgment |

### Rollback Procedure Template

```markdown
## Rollback Strategy

### Rollback Triggers
| Trigger | Metric | Threshold | Owner |

### Rollback Procedures
| Wave | Step | Action | Owner | Time Budget |

### Rollback Ownership
| Role | Responsibility |
|---|---|
```

## Monitoring and Observability by Phase

### Pre-Release Baseline

Establish baseline metrics for all critical paths before wave 1:

- Error rate (5xx), latency (p50, p95, p99), throughput (requests/second).
- Business KPIs relevant to the release.
- Database query performance for affected schemas.

### Monitoring Checkpoints Per Wave

| Phase | Metrics to Watch | Alert Threshold | Observation Window |
|---|---|---|---|
| Wave 1 | Error rate, latency delta, new code paths | +0.5% errors or +10% latency | 30 minutes minimum |
| Wave 2+ | Same + business KPIs | Same + 5% KPI deviation | 15 minutes minimum |
| Full rollout | All paths stable | Return to baseline | 2 hours monitoring |

### Canary Analysis (Automated)

When using automated canary analysis tools (Argo Rollouts, Flagger, Spinnaker):

- Define `evaluate` criteria: error rate threshold, latency threshold.
- Set `analysisTemplate` with minimum weight and step count.
- Configure `autoRollback` on analysis failure.

## Communication Plan

### Stakeholder Communication Template

```markdown
## Communication Plan

### Pre-Release
| When | Audience | Channel | Message |
|---|---|---|---|
| T-72h | Engineering leads | Async / Slack | Release scope, wave plan, rollback triggers |
| T-48h | Product / stakeholders | Email / async | Release date, wave timeline, success criteria |
| T-24h | Operations / on-call | Sync / briefing | Monitoring plan, escalation path, contacts |

### During Release
| When | Audience | Channel | Trigger |
|---|---|---|---|
| Before each wave | Release lead | Direct | Go/no-go decision |
| Wave gate pass | Stakeholders | Channel per audience | Gate closed |
| Rollback trigger | Incident response | Pager / Slack | Rollback initiated |

### Post-Release
| When | Audience | Channel | Message |
|---|---|---|---|
| Post-wave 1 | All stakeholders | Email / Slack | Wave 1 complete, metrics summary |
| Full rollout | All stakeholders | Email / Slack | Release complete, metrics summary |
| Post-incident | Stakeholders + leadership | Incident report | Root cause, impact, remediation |
```

## Go/No-Go Criteria

### Pre-Wave Go Checklist

For each wave, all of the following must be green before proceeding:

| Criterion | Measure | Owner |
|---|---|---|
| Monitoring active | All critical paths instrumented; dashboards live | Observability / SRE |
| Baseline established | Pre-release metrics captured for comparison | SRE / Metrics |
| Rollback tested | Rollback procedure executed in staging or canary | Engineering lead |
| Database migrations complete | All migration steps verified; data integrity confirmed | DBA / Data lead |
| Feature flags configured | Kill switches and rollback flags in place | Engineering |
| Communication sent | Stakeholders informed of wave timeline | Release coordinator |
| Go/No-Go meeting held | Authorized by designated decision-maker | Release lead |

## Input Artifact Mapping

The skill adapts based on what input artifacts are provided:

| Artifact | Primary Planning Focus |
|---|---|
| **Release scope** | Deployment sequence, wave sizing, communication plan |
| **PRD / SDD / RFC** | Migration sequencing, compatibility risks, validation checkpoints |
| **Feature flags / rollouts** | Rollout waves, canary strategy, kill switch design |
| **Deployment architecture** | Blast radius per wave, rollback strategy, observability plan |
| **Data changes (schema, migration)** | Migration plan (expand/migrate/contract), data safety per wave |
| **Risk assessment** | Risk mitigation section, blast radius per wave, rollback triggers |
| **Validation plan** | Monitoring checkpoints per wave, go/no-go criteria |
| **Release calendar** | Communication plan timing, wave gates mapped to calendar |
| **Stakeholder constraints** | Wave sizing adjusted to constraints; communication plan customized |

If no artifact is provided, ask the user to specify the release scope before producing the plan.

## Output Structure

Use this structure for the complete release plan:

```markdown
# Release Plan: <Release Name>

## 1. Release Overview
- **Scope:** <what is being released>
- **Risk Profile:** <Low / Medium / High / Critical>
- **Wave Count:** <N waves>
- **Communication:** <stakeholder plan summary>

## 2. Deployment Sequence
[Artifact 1]

## 3. Migration Plan
[Artifact 2]

## 4. Rollout Waves
[Artifact 3]

## 5. Risk Mitigation
[Artifact 4]

## 6. Rollback Strategy
[Artifact 5]

## 7. Monitoring and Observability
[Monitoring checkpoints by wave]

## 8. Communication Plan
[Stakeholder communication template]

## 9. Go/No-Go Checklist
[Per-wave go/no-go criteria]

## 10. Integration Summary
<One paragraph: how all five artifacts connect into a coherent release story>
```

## Quality Bar

Before presenting the release plan, verify:

- All five first-class artifacts are present and fully developed.
- Migration plan uses expand/migrate/contract for any breaking schema changes.
- Rollback strategy exists for every wave, with measurable trigger criteria.
- Go/no-go criteria are measurable (concrete thresholds, not subjective).
- Blast radius is assessed for every wave; wave sizing reflects blast radius.
- Backward/forward compatibility is verified before wave 1; incompatible changes are flagged as blocking.
- Monitoring checkpoints are defined per wave and observation windows are specified.
- Communication plan covers pre-release, each wave transition, and post-release.
- The skill output is written in English.
- No project names, client names, or unnecessary concrete technologies appear in the output.
- Deployment sequence and migration plan are consistent with each other (no step in the sequence contradicts the migration plan).

## Present Results to User

Lead with the release risk profile and wave count. Present the wave plan first so the user sees the progression from low exposure to full rollout. Then present the rollback strategy so the user understands the safety net before reading the deployment sequence. Highlight any blocking items (incompatible changes, missing observability, absent rollback capability) as these prevent the plan from being actionable. If the release is high-risk, recommend reducing wave 1 size or adding an internal-only wave before external exposure.

## Troubleshooting

- **User provides no release scope:** Ask for the release scope, or at minimum the components being released and the target date.
- **Breaking schema change identified:** Flag this as a blocking constraint. The release cannot proceed safely until backward-compatible migration path is designed using expand/migrate/contract.
- **Rollback impossible (data migration already committed):** Flag this as a critical risk. The plan must document that rollback would cause data loss and is therefore not an option; mitigation must be in the migration plan itself.
- **No observability for critical paths:** Block wave 1 until monitoring is active. A release without observability is a blind release.
- **Wave sizing is uniform (all waves same size):** This is a smell. High-risk changes should have smaller early waves. If all waves are equal, the plan is not optimized for blast radius.
- **Communication plan missing for wave transitions:** Every wave transition is a stakeholder touchpoint. If the user has not defined who needs to be informed and when, the communication plan is incomplete.
- **No baseline metrics available:** Establish baseline before wave 1. Without baseline, go/no-go criteria cannot be evaluated objectively.
