---
name: 4r-code-review
description: "Trigger: 4R code review, review this change, review agent code, pre-commit review, is this done, quality gate before commit. Run a Risk/Readability/Reliability/Resilience review on a completed change before declaring it done."
license: Apache-2.0
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write, Grep, Glob, Bash
triggers:
  - 4r-code-review
  - 4R code review
  - review this change
  - review the code before commit
  - is this done
  - quality gate before commit
  - review agent-generated code
---

# 4R Code Review

## When to Use

Use this skill when a coding task is reported complete and BEFORE declaring it done, committing, pushing, or opening a PR — especially when the change was produced wholly or partly by a coding agent.

Use it to run a systematic, stack-agnostic review across four dimensions — **Risk, Readability, Reliability, Resilience** — that classifies findings by severity, surfaces fixable defects, and returns an explicit accept/block decision.

Do NOT use this skill to write the feature, design architecture from scratch, or audit non-code artifacts (use `reviewer` for PRDs, specs, and API contracts). This skill reviews a code diff, not prose.

## Operating Workflow

1. **Scope the diff.** Run `git diff` / `git diff --staged` (and `git status`) to get exactly what changed. Review the diff and its blast radius, not the whole repo.
2. **Tier the review.** Match effort to risk (see Decision Rules). Do not burn a deep 4R pass on a one-line doc typo; do not shortcut a change that touches auth, data, or money.
3. **Confirm intent match.** Verify the change does what the task asked AND ONLY that. Flag edits outside the intended scope, stray files, and unrequested behavior changes.
4. **Run the 4R passes.** Evaluate each dimension against `references/4r-dimensions.md`. Prioritize the AI failure patterns listed there — agent code passes the eye test and fails differently than human code.
5. **Gather evidence.** Run the test suite / linter / build when available. Treat "looks correct" as unproven until executed. Record commands and results.
6. **Classify and decide.** Tag every finding with severity, score each R 0–2, and return one verdict: Approve / Approve with follow-up / Request changes / Escalate.

## Core Rules

- Evidence over intention: tests run, errors handled, limits set, and observability must be VISIBLE in the change, not assumed.
- Code that looks correct is not evidence that it is correct. Trace the unhappy paths explicitly.
- Complexity is a budget. A change that adds branches, state, or abstraction must justify the cost; reject or simplify accidental or AI-inflated complexity.
- Be specific and actionable. Never say "security is missing" — name the file, line, failure mode, and the fix direction.
- Never approve a change with a Blocker in Risk or Resilience. A residual risk must be explicit, bounded, and proportional.

## The 4R Dimensions

| R | Central question | Covers |
|---|---|---|
| **Risk** | Does this add disproportionate risk to security or production? | Auth, secrets, trust boundaries, input validation, injection, blast radius, rollback. |
| **Readability** | Can another engineer maintain this without rebuilding the author's intent? | Naming, structure, duplication, complexity budget, AI slop. |
| **Reliability** | Is there real evidence it works on normal AND edge inputs? | Tests that catch bugs, edge cases, error handling, timeouts, correctness. |
| **Resilience** | When it fails, does the system recover or cascade? | Retries with backoff, fallback, graceful degradation, observability, isolation. |

Full per-dimension checklists, AI-specific failure patterns, and acceptance criteria are in `references/4r-dimensions.md` — read it before the 4R passes.

## Decision Rules

| Situation | Action |
|---|---|
| Diff is trivial (docs, comments, formatting) | Quick pass: intent match + Risk scan only; skip deep 4R. |
| Diff touches auth, secrets, payments, data, or infra | Full 4R + mandatory Escalate consideration; no Blockers allowed. |
| Agent-generated logic, new integration, or 2+ files | Full 4R; prioritize AI failure patterns and test quality. |
| Tests absent where change warrants them | Reliability ≤ 1; Request changes unless risk is low AND justified in writing. |
| Blocker in Risk or Resilience | Block. Do not approve regardless of other scores. |
| Change exceeds reviewer's authority or domain | Escalate to specialized/human review. |

### Severity

| Severity | Meaning |
|---|---|
| 🔴 Blocker | Probable vulnerability, data loss, critical regression, plausible cascade, unbounded risk in a sensitive zone. |
| 🟠 High | Missing tests on a critical path, absent timeout, wrong retry, excessive complexity in core logic, weak observability at a critical point. |
| 🟡 Medium | Improvable readability, bounded uncovered edge case, documentable debt without immediate impact. |
| 🔵 Low | Naming, minor structure, non-critical simplification. |

### Scorecard

Score each R 0–2 (0 = insufficient, 1 = acceptable with reservations, 2 = solid). Merge rule: minimum 1 per dimension, no 0 in Risk or Resilience, target average ≥ 1.5. Any security Blocker or plausible cascade invalidates the aggregate until fixed.

## Output Contract

Produce the report in `assets/4r-review-report.md`. Required sections: Context, one block per R (verdict Pass/Concern/Block + findings table), a severity-tagged findings list, the 0–2 scorecard, and a Final Decision (status + residual risk + required actions before merge + follow-ups). End with one explicit sentence: whether the change may be committed/pushed or must return to iteration.

## Quality Checklist

Before returning the review, verify:
- [ ] Review is based on the actual diff, with tests/linter/build run when available.
- [ ] Intent match confirmed: change does what was asked and nothing extra.
- [ ] All four R dimensions evaluated; AI failure patterns checked on agent code.
- [ ] Every finding cites a file/line, the failure mode, and an actionable fix.
- [ ] Severity assigned by impact; scorecard filled; merge rule applied.
- [ ] No Blocker left in Risk or Resilience before any Approve.
- [ ] Final decision is explicit and unambiguous.

## References

- `references/4r-dimensions.md` — per-dimension checklists, AI failure patterns, acceptance criteria. Read before the 4R passes.
- `assets/4r-review-report.md` — report template. Fill for every review.
