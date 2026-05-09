---
name: context-engineer
description: Optimize and structure context for agents and LLMs by reducing noise, prioritizing relevance, organizing memory, defining constraints, and managing token budgets.
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - context-engineer
  - context engineer
  - context engineering
  - optimize agent context
  - reduce token usage
  - structure LLM memory
---

# Context Engineer

## Purpose

Use this skill to optimize and structure context for agents and LLMs. The agent treats context as a scarce resource, reduces noise, prioritizes relevance, organizes memory, defines constraints, and produces compact context packages that improve output quality while reducing token use.

This skill is domain-generic. It must work for any agent workflow, prompt, memory system, multi-agent process, or LLM-assisted task without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Improve context quality for an AI agent or LLM.
- Reduce token usage without losing important meaning.
- Organize long conversations, documents, memories, or task context.
- Prepare handoff context for another agent.
- Define constraints, rules, and priorities for prompt engineering.
- Design context strategy for multi-agent systems.
- Decide what information should be included, summarized, retrieved, masked, or omitted.

Do not use this skill to solve the underlying domain task directly. Use it to shape the information environment that helps another agent or LLM perform the task correctly.

## Core Operating Rules

1. **Treat context as a scarce resource.** Include only information that changes the answer, decision, or execution path.
2. **Preserve fidelity over volume.** Compress wording, not meaning. Never remove constraints, decisions, risks, or facts needed for correctness.
3. **Prioritize task relevance.** Rank context by current task, user intent, constraints, recency, authority, and dependency impact.
4. **Separate facts from instructions.** Keep task facts, rules, constraints, examples, memory, and open questions in distinct sections.
5. **Prefer structured context.** Use tables, bullets, labels, and stable IDs instead of long narrative blocks.
6. **Minimize duplication.** Merge repeated facts and keep one authoritative version.
7. **Expose uncertainty.** Mark unknowns, stale information, conflicting facts, and assumptions explicitly.
8. **Design retrieval boundaries.** Decide what belongs in immediate context, what should be retrieved on demand, and what should be excluded.
9. **Optimize for downstream agents.** Context packages must be easy for another agent to execute without re-reading irrelevant material.
10. **Respect privacy and safety.** Remove secrets, credentials, unnecessary personal data, and irrelevant sensitive information.

## Context Taxonomy

Classify information before including it:

| Category | Include When | Handling Rule |
| --- | --- | --- |
| Objective | It defines the task outcome. | Always include in the first section. |
| User Intent | It explains what the user wants or values. | Preserve exact meaning; summarize only if long. |
| Hard Constraint | It limits allowed behavior or output. | Always include; never compress ambiguously. |
| Soft Preference | It influences style or tradeoffs. | Include if relevant to current task. |
| Decision | It records a chosen direction. | Include with rationale and date/context if known. |
| Fact | It describes current state or inputs. | Include only if needed for execution. |
| Dependency | It blocks or sequences work. | Include near tasks or execution plan. |
| Example | It clarifies expected pattern. | Include minimal representative examples only. |
| Memory | It comes from prior sessions or long-term context. | Include if relevant, current, and non-conflicting. |
| Noise | It does not affect the task. | Omit. |

## Relevance Scoring

Score candidate context using this rubric:

| Score | Meaning | Action |
| --- | --- | --- |
| 5 | Required for correctness or safety. | Include verbatim or near-verbatim. |
| 4 | Strongly affects implementation or decision quality. | Include compactly. |
| 3 | Useful background, but not decisive. | Summarize briefly or retrieve on demand. |
| 2 | Possibly useful later. | Move to deferred context or memory index. |
| 1 | Irrelevant, duplicated, stale, or distracting. | Omit. |

## Noise Reduction Techniques

Use these techniques deliberately:

- **Deduplication:** Merge repeated facts, instructions, and examples.
- **Abstraction:** Replace verbose details with stable concepts when specifics are not required.
- **Chunking:** Group related facts under clear headings.
- **Summarization:** Compress long history into decisions, constraints, and current state.
- **Observation masking:** Hide irrelevant observations while preserving the current task state.
- **Retrieval gating:** Keep low-priority context outside the prompt until needed.
- **Conflict marking:** Keep conflicting facts visible until resolved instead of silently choosing one.
- **Token-aware formatting:** Prefer compact tables and bullets over prose.

## Execution Workflow

### Phase 1: Context Intake

1. Identify the downstream task and expected output.
2. Collect candidate context from user input, documents, memory, constraints, and examples.
3. Separate current task context from historical or background context.
4. Detect secrets, sensitive data, duplicates, stale facts, and conflicts.

### Phase 2: Context Selection

1. Score each context item for relevance.
2. Include required objectives, constraints, decisions, dependencies, and validation criteria.
3. Summarize useful but non-critical context.
4. Exclude noise and defer low-priority context.
5. Mark open questions and assumptions.

### Phase 3: Context Structuring

1. Organize context into a compact package.
2. Put task objective and hard constraints first.
3. Add relevant facts, decisions, and dependencies.
4. Add output format and quality bar.
5. Add retrieval or memory notes for deferred information.

### Phase 4: Context Validation

1. Check that a downstream agent can act without guessing.
2. Check that no irrelevant or sensitive data remains.
3. Check that constraints are not weakened by summarization.
4. Check that token budget is respected.

## Required Output Structure

Use this format when producing an optimized context package:

```markdown
# <Context Package Title>

## 1. Task Objective
- Goal:
- Expected output:
- Success criteria:

## 2. Hard Constraints
- <Non-negotiable rule or limitation>

## 3. Relevant Facts
| Fact | Source/Confidence | Why It Matters |
| --- | --- | --- |

## 4. Decisions and Rationale
| Decision | Rationale | Impact |
| --- | --- | --- |

## 5. Dependencies and Blockers
| Item | Type | Blocks | Resolution |
| --- | --- | --- | --- |

## 6. Working Assumptions
- <Assumption and reason>

## 7. Open Questions
- <Question that affects correctness or execution>

## 8. Deferred Context
| Item | Why Deferred | Retrieve When |
| --- | --- | --- |

## 9. Output Contract for Downstream Agent
- Required sections:
- Forbidden actions:
- Quality bar:
- Verification method:
```

## Memory Organization Rules

When organizing memory or long-running context:

- Store stable decisions separately from transient observations.
- Store user preferences separately from project facts.
- Store constraints with rationale and scope.
- Mark stale or superseded information.
- Keep summaries updateable and avoid copying entire histories.
- Include retrieval keys or labels when useful.
- Preserve conflict notes until explicitly resolved.

## Multi-Agent Context Rules

For multi-agent systems:

- Give each agent only the context required for its role.
- Include shared constraints consistently across agents.
- Keep role-specific instructions separate from global rules.
- Provide handoff summaries with outputs, decisions, risks, and unresolved questions.
- Avoid leaking unrelated agent reasoning or irrelevant task history.
- Define what each agent may read, write, decide, and escalate.

## Token Budget Rules

- Put non-negotiable constraints before optional background.
- Prefer compact summaries over raw transcripts.
- Prefer references or retrieval instructions for large artifacts.
- Remove duplicate examples.
- Replace verbose logs with relevant events and error signatures.
- Keep recent raw context only when exact wording matters.
- If budget is tight, preserve constraints, current state, decisions, and verification criteria first.

## Quality Checklist

Before presenting the context package, verify:

- The output is written in English.
- The downstream task is explicit.
- Hard constraints are preserved.
- Relevant facts are prioritized.
- Noise, duplicates, and stale information are removed or marked.
- Assumptions and open questions are visible.
- Sensitive data and secrets are excluded.
- Deferred context includes retrieval conditions.
- The package is compact enough for the intended context window.
- No project-specific names, client names, vendors, or unnecessary concrete technologies were invented.

## Response Style

- Be concise, structured, and token-aware.
- Use headings, bullets, and tables.
- Prefer exact constraints and summarized background.
- State what was omitted and why when omission could affect confidence in the result.
- Mark unknowns as `TBD` instead of inventing context.
