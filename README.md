# Engineering Skills

[![skills.sh](https://skills.sh/b/GustavoGutierrez/engineering-skills)](https://skills.sh/GustavoGutierrez/engineering-skills)

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

Install this skill collection with the skills CLI:

```bash
npx skills add GustavoGutierrez/engineering-skills
```

After installation, the skills become available to supported AI agents and can be loaded when the user's request semantically matches a skill description or trigger.

## skills.sh Publication

This repository is prepared for discovery through skills.sh. The directory lists skills from public GitHub sources based on installs performed through the skills CLI.

To make the collection discoverable:

1. Keep this repository public on GitHub.
2. Keep each skill in `skills/{skill-name}/SKILL.md` with valid frontmatter.
3. Keep this README table synchronized with the actual skills.
4. Share the install command:

```bash
npx skills add GustavoGutierrez/engineering-skills
```

5. Once users install the repository through the CLI, the repository can be surfaced by skills.sh install telemetry.

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

## Skill Inventory Maintenance

When a skill is added, renamed, or removed, this README should be updated so the table remains an accurate overview of the repository contents.
