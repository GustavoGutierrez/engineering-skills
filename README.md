# Engineering Skills

A collection of reusable AI agent skills for engineering, product, architecture, and delivery workflows. Each skill packages a specific professional capability as structured guidance that an AI agent can load when the task matches its purpose.

The repository contains generic, domain-independent skills. They are designed to describe reusable behaviors, methods, quality standards, output structures, and decision rules rather than project-specific documentation or mutable business context.

## Repository Structure

```text
skills/
  {skill-name}/
    SKILL.md
    scripts/        # Optional executable code
    references/     # Optional documentation
    assets/         # Optional templates or resources
  {skill-name}.zip
```

## Install

Install all skills from this repository with the skills CLI:

```bash
npx skills add gustavogutierrez/engineering-skills --all
```

After installation, the skills become available to supported AI agents and can be loaded when the user's request semantically matches a skill description or trigger.

To inspect which skills the CLI detects in the repository before installing, run:

```bash
npx skills add gustavogutierrez/engineering-skills --list
```

### Install Individual Skills

Install a specific skill from this repository by selecting it with `--skill`:

```bash
npx skills add gustavogutierrez/engineering-skills --skill context-engineer
npx skills add gustavogutierrez/engineering-skills --skill prd-writer
npx skills add gustavogutierrez/engineering-skills --skill prp-writer
npx skills add gustavogutierrez/engineering-skills --skill spec-architect
npx skills add gustavogutierrez/engineering-skills --skill spec-writer
npx skills add gustavogutierrez/engineering-skills --skill story-refiner
npx skills add gustavogutierrez/engineering-skills --skill technical-planner
npx skills add gustavogutierrez/engineering-skills --skill solution-architect
npx skills add gustavogutierrez/engineering-skills --skill reviewer
npx skills add gustavogutierrez/engineering-skills --skill acceptance-criteria-generator
npx skills add gustavogutierrez/engineering-skills --skill workflow-designer
npx skills add gustavogutierrez/engineering-skills --skill api-spec-writer
npx skills add gustavogutierrez/engineering-skills --skill frontend-spec-writer
npx skills add gustavogutierrez/engineering-skills --skill prompt-engineer
```

### Direct Skill Folder URL

The CLI also supports installing from a direct GitHub folder URL:

```bash
npx skills add https://github.com/GustavoGutierrez/engineering-skills/tree/main/skills/context-engineer
```

For this repository, prefer the `--skill` form above because it keeps the source as `gustavogutierrez/engineering-skills` while selecting the skill by name.

## skills.sh Publication

This repository is prepared for discovery through skills.sh. The directory lists skills from public GitHub sources based on installs performed through the skills CLI.

The skills.sh badge is intentionally not shown here until the repository has a valid skills.sh badge resource. Add it later when `https://skills.sh/b/GustavoGutierrez/engineering-skills` resolves successfully.

To make the collection discoverable:

1. Keep this repository public on GitHub.
2. Keep each skill in `skills/{skill-name}/SKILL.md` with valid frontmatter.
3. Keep this README table synchronized with the actual skills.
4. Share the install command:

```bash
npx skills add gustavogutierrez/engineering-skills --all
```

5. Once users install the repository through the CLI, the repository can be surfaced by skills.sh install telemetry.

When skills.sh indexes individual skills, their public pages are expected to use the skill slug without the internal `skills/` folder segment. For example:

```text
https://skills.sh/gustavogutierrez/engineering-skills/context-engineer
```

The direct GitHub folder path may include `/skills/context-engineer`, but the expected skills.sh public URL does not.

## Available Skills

| Skill | Purpose | How to Use | When to Use | Files |
| --- | --- | --- | --- | --- |
| `context-engineer` | Optimizes and structures context for agents and LLMs by reducing noise, prioritizing relevance, organizing memory, defining constraints, and managing token budgets. | Load this skill with a prompt, conversation, document set, memory dump, or multi-agent workflow to produce a compact context package. | Use it to improve AI outputs, reduce token consumption, prepare agent handoffs, structure memory, or design context strategy for multi-agent systems. | `skills/context-engineer/SKILL.md` / `skills/context-engineer.zip` |
| `prd-writer` | Creates clear, measurable Product Requirements Documents that align product intent with delivery context. | Load this skill with a product idea, feature concept, or vague requirement to produce a PRD with summary, user stories, success criteria, scope, risks, and roadmap. | Use it at the beginning of an initiative when product requirements need to be clarified, aligned, and documented before planning or implementation. | `skills/prd-writer/SKILL.md` / `skills/prd-writer.zip` |
| `prp-writer` | Creates structured Product Requirements Prompts for AI-assisted development, including context, requirements, constraints, risks, and open questions. | Load this skill with a feature, system idea, or initiative to produce a complete PRP with standardized sections and depth appropriate to complexity. | Use it when a team needs a robust requirements prompt before asking AI agents or assistants to help with implementation. | `skills/prp-writer/SKILL.md` / `skills/prp-writer.zip` |
| `spec-architect` | Designs high-level functional and technical specifications with scope, modules, contracts, boundaries, responsibilities, constraints, and verification criteria. | Load this skill with a product intent, rough requirement, PRD, PRP, or complex system idea to produce an architecture-ready specification. | Use it before implementation for complex systems, agent-oriented architecture, SDD workflows, or any change that needs clear module boundaries and contracts. | `skills/spec-architect/SKILL.md` / `skills/spec-architect.zip` |
| `spec-writer` | Writes, rewrites, or normalizes `*.spec.md` files with verifiable requirements, guardrails, acceptance criteria, and validation plans. | Load this skill when a need, bug, feature, or existing behavior must become an implementation-ready specification. | Use it before coding when the expected behavior, scope, constraints, and Definition of Done must be explicit. | `skills/spec-writer/SKILL.md` / `skills/spec-writer.zip` |
| `task-breakdown` | Breaks complex features, epics, or specs into small executable tasks with logical sequencing, dependencies, ownership, acceptance signals, and parallelization guidance. | Load this skill with a feature, epic, spec, roadmap item, or delivery goal to produce execution waves, task details, dependencies, and parallelization guidance. | Use it for sprint planning, issue tracker preparation, agent delegation, parallel work planning, and decomposition of complex delivery goals. | `skills/task-breakdown/SKILL.md` / `skills/task-breakdown.zip` |
| `technical-planner` | Plans technical execution by organizing phases, dependencies, implementation order, infrastructure foundations, MVP scope, coordination points, and incremental architecture delivery. | Load this skill with a spec, architecture, PRD, PRP, roadmap goal, or complex system plan to produce a phased technical execution roadmap. | Use it for MVP planning, technical roadmaps, multi-team coordination, dependency sequencing, and incremental architecture rollout. | `skills/technical-planner/SKILL.md` / `skills/technical-planner.zip` |
| `togaf-writer` | Drafts TOGAF-aligned enterprise architecture artifacts using ADM, architecture domains, baseline-to-target analysis, governance, and roadmap planning. | Load this skill to structure architecture vision, gap analysis, traceability matrices, application or data catalogs, migration roadmaps, or architecture contracts. | Use it when the work requires enterprise-level architecture reasoning, business alignment, governance, and transition planning. | `skills/togaf-writer/SKILL.md` / `skills/togaf-writer.zip` |
| `story-refiner` | Refines user stories using INVEST, gap detection, Gherkin acceptance criteria, edge cases, dependencies, and split recommendations. | Load this skill with a raw story, requirement, or backlog item to produce a refined story with INVEST review, gaps, acceptance criteria, negative scenarios, assumptions, and open questions. | Use it during backlog refinement, sprint planning, or ticket preparation when a story must become clearer, smaller, more valuable, estimable, and testable. | `skills/story-refiner/SKILL.md` / `skills/story-refiner.zip` |
| `solution-architect` | Designs real technical solution architectures for scalable, secure, cost-aware systems by selecting patterns, components, integrations, data flows, and tradeoffs. | Load this skill with a system idea, architecture problem, or spec to produce FSM state models, C4 component diagrams, threat models, and tradeoff decisions. | Use it for senior solution architecture, SaaS architecture, LLM architecture, or architecture decisions after a spec. | `skills/solution-architect/SKILL.md` / `skills/solution-architect.zip` |
| `reviewer` | Rigorous technical and quality reviewer that audits artifacts (PRDs, specs, architectures, user stories, APIs) for consistency, completeness, clarity, gaps, and standards compliance. | Load this skill with an artifact to review and receive a structured audit with issues, severity, and suggested corrections. | Use it for quality audits, QA gates, technical validation, or before implementation. | `skills/reviewer/SKILL.md` / `skills/reviewer.zip` |
| `acceptance-criteria-generator` | Transforms user stories and specifications into precise, verifiable Gherkin acceptance criteria using Given/When/Then syntax with Happy Path, Sad Path, and edge case scenarios. | Load this skill with a user story or spec to produce structured Gherkin scenarios with preconditions, steps, and assertions. | Use it when asking for acceptance criteria, Gherkin scenarios, BDD criteria, or test scenarios. | `skills/acceptance-criteria-generator/SKILL.md` / `skills/acceptance-criteria-generator.zip` |
| `workflow-designer` | Designs state machines, orchestration workflows, saga patterns, and resilience strategies for distributed systems, AI agents, and complex async processes. | Load this skill with a business process, event-driven system, or agent workflow to produce FSM diagrams, saga choreography, HITL checkpoints, and resilience patterns. | Use it for workflow design, state machine design, saga patterns, or process resilience strategy. | `skills/workflow-designer/SKILL.md` / `skills/workflow-designer.zip` |
| `api-spec-writer` | Designs complete API contracts in OpenAPI 3.0/3.1 YAML with endpoints, schemas, security, pagination, error handling, and RFC 7807 problem details. | Load this skill with an API idea, data model, or integration requirement to produce a complete OpenAPI YAML spec. | Use it when designing an API, creating an OpenAPI spec, defining API endpoints, or writing API contracts. | `skills/api-spec-writer/SKILL.md` / `skills/api-spec-writer.zip` |
| `frontend-spec-writer` | Designs frontend component hierarchies, props/events contracts, UX flows, state management, responsive breakpoints, accessibility rules, and microinteractions. | Load this skill with UI requirements, user flows, or component lists to produce component classification, state diagrams, responsive rules, and accessibility contracts. | Use it for UI specification, component API design, or frontend architecture. | `skills/frontend-spec-writer/SKILL.md` / `skills/frontend-spec-writer.zip` |
| `prompt-engineer` | Designs System Prompts, prompt templates, and multi-agent orchestration contracts for deterministic, leak-proof AI systems. | Load this skill when creating agents, writing skill definitions, designing prompt templates with safe variable injection, or building multi-agent pipelines. | Use it for prompt injection defense, I/O contracts, agent role definitions, or system prompt architecture. | `skills/prompt-engineer/SKILL.md` / `skills/prompt-engineer.zip` |

## Skill Inventory Maintenance

When a skill is added, renamed, or removed, this README should be updated so the table remains an accurate overview of the repository contents.
