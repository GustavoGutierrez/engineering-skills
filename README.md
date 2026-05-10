# Engineering Skills

[![skills.sh](https://skills.sh/b/GustavoGutierrez/engineering-skills)](https://skills.sh/GustavoGutierrez/engineering-skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Skills](https://img.shields.io/badge/skills-24-6f42c1)](./README.md#skill-inventory)
[![PDF Guide](https://img.shields.io/badge/PDF-flows%20%26%20diagrams-red)](./docs/Engineering-skills.pdf)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Gustavo%20Guti%C3%A9rrez-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/gustavo-gutierrez-mercado)

A collection of reusable AI agent skills for engineering, product, architecture, and delivery workflows. Each skill packages a specific professional capability as structured guidance that an AI agent can load when the task matches its purpose.

The repository contains generic, domain-independent skills. They are designed to describe reusable behaviors, methods, quality standards, output structures, and decision rules rather than project-specific documentation or mutable business context.

## What This Repository Is Becoming

This repository is no longer just a set of prompts, coding helpers, or isolated writing assistants.

It is evolving into an **AI-Native Engineering Governance System** — a reusable capability layer for running a disciplined engineering lifecycle with AI support across:

- requirements engineering
- architecture and specification design
- governance and decision traceability
- validation and verification
- delivery planning and release control
- observability and operational readiness

In practice, it is moving closer to an **Autonomous Specification Engineering Platform** than to a simple agent toolbox. The collection now supports a flow that resembles modernized systems engineering, enterprise architecture automation, and AI-orchestrated SDLC execution.

From an enterprise perspective, the repository is designed to help an agent participate in the same control surfaces that matter to serious delivery organizations:

- requirement clarification and decomposition
- specification and architecture governance
- decision logging and traceability
- policy enforcement and risk control
- validation and quality gate design
- release coordination and operational readiness
- documentation and observability strategy

The result is a repository that can support **design-time rigor**, **delivery-time control**, and **production-time visibility** rather than only artifact generation.

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

Install a specific skill from this repository by selecting it with `--skill`. The full catalog is listed later in this README under **Skill Inventory**.

```bash
npx skills add gustavogutierrez/engineering-skills --skill context-engineer
npx skills add gustavogutierrez/engineering-skills --skill prd-writer
npx skills add gustavogutierrez/engineering-skills --skill api-spec-writer
npx skills add gustavogutierrez/engineering-skills --skill decision-record-writer
npx skills add gustavogutierrez/engineering-skills --skill observability-designer
npx skills add gustavogutierrez/engineering-skills --skill release-planner
```

To install any other skill, replace the slug with the exact name shown in the inventory table.

### Direct Skill Folder URL

The CLI also supports installing from a direct GitHub folder URL:

```bash
npx skills add https://github.com/GustavoGutierrez/engineering-skills/tree/main/skills/context-engineer
```

For this repository, prefer the `--skill` form above because it keeps the source as `gustavogutierrez/engineering-skills` while selecting the skill by name.

## skills.sh Publication

This repository is prepared for discovery through skills.sh. The directory lists skills from public GitHub sources based on installs performed through the skills CLI.

The skills.sh badge is shown at the top of this README and links to the published repository entry.

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

## Skill Map by Functional Group and SDLC Phase

The collection is organized below as a logical engineering flow rather than a flat list. Each group covers a distinct layer of a robust AI-assisted development system.

### 1. Foundation for AI-Assisted Engineering

These skills define how agents think, how context is shaped, and how prompt-driven workflows stay deterministic and reusable. They sit underneath the rest of the stack because every later artifact depends on good context hygiene and clear agent contracts.

| Skill | Purpose |
| --- | --- |
| `context-engineer` | Optimizes and structures context for agents and LLMs by reducing noise, prioritizing relevance, organizing memory, defining constraints, and managing token budgets. |
| `prompt-engineer` | Designs system prompts, prompt templates, and multi-agent orchestration contracts for deterministic, leak-resistant AI systems. |

### 2. Requirements and Product Definition

These skills turn raw ideas, stakeholder requests, and backlog inputs into structured requirement artifacts. This is the layer that makes intent explicit before architecture or implementation decisions are made.

| Skill | Purpose |
| --- | --- |
| `prd-writer` | Creates clear, measurable Product Requirements Documents that align product intent with delivery context. |
| `prp-writer` | Creates structured Product Requirements Prompts for AI-assisted development, including context, requirements, constraints, risks, and open questions. |
| `story-refiner` | Refines user stories using INVEST, gap detection, edge cases, dependencies, and split recommendations. |
| `acceptance-criteria-generator` | Transforms stories and specifications into precise, verifiable Gherkin acceptance criteria with happy path, failure path, and edge-case coverage. |

### 3. Specification and Architecture Design

These skills convert requirements into system shape: specifications, architecture, interfaces, workflows, and technical planning. Together they cover both solution intent and executable design structure.

| Skill | Purpose |
| --- | --- |
| `spec-architect` | Designs high-level functional and technical specifications with scope, modules, contracts, boundaries, responsibilities, constraints, and verification criteria. |
| `spec-writer` | Writes, rewrites, or normalizes implementation-ready specification files with verifiable requirements, guardrails, acceptance criteria, and validation plans. |
| `solution-architect` | Designs scalable, secure, cost-aware solution architectures with patterns, components, integrations, data flows, and tradeoffs. |
| `workflow-designer` | Designs state machines, orchestration workflows, saga patterns, and resilience strategies for distributed systems, AI agents, and async processes. |
| `api-spec-writer` | Designs complete OpenAPI contracts with endpoints, schemas, security, pagination, and standardized error handling. |
| `frontend-spec-writer` | Designs frontend component hierarchies, contracts, UX flows, state behavior, responsiveness, accessibility rules, and microinteractions. |
| `technical-planner` | Plans technical execution by sequencing phases, dependencies, implementation order, MVP scope, and incremental architecture delivery. |
| `togaf-writer` | Drafts TOGAF-aligned enterprise architecture artifacts using ADM, governance, baseline-to-target analysis, and migration planning. |

### 4. Governance, Decision Control, and Traceability

These skills make the system auditable and governable. They connect decisions, risks, policies, requirements, and implementation artifacts so that engineering work becomes explainable, reviewable, and safe to evolve.

| Skill | Purpose |
| --- | --- |
| `decision-record-writer` | Writes architecture decision records (ADRs) using an append-only supersession model with rationale, alternatives, tradeoffs, and consequences. |
| `risk-assessor` | Identifies and prioritizes technical, operational, scalability, security, delivery, and AI/spec ambiguity risks with concrete mitigations. |
| `compliance-guard` | Enforces architectural standards, governance policies, conventions, constraints, and specification guardrails across engineering artifacts. |
| `traceability-manager` | Maintains bidirectional requirement-to-implementation traceability with typed links, coverage checks, orphan detection, and change impact analysis. |

### 5. Implementation Planning, Validation, and Quality Gates

These skills prepare work for execution and verify that planned or produced artifacts are actually fit to build, test, and evolve. This layer is where the repository starts behaving like a full engineering control system rather than a writing toolkit.

| Skill | Purpose |
| --- | --- |
| `task-breakdown` | Breaks complex features, epics, or specs into executable tasks with sequencing, dependencies, ownership, and parallelization guidance. |
| `validation-strategist` | Designs layered validation and verification strategies across unit, component, feature, application, and release-candidate levels. |
| `reviewer` | Performs rigorous technical and quality reviews of artifacts for consistency, completeness, clarity, gaps, and standards alignment. |

### 6. Release, Observability, and Operational Readiness

These skills cover the late-stage SDLC path from “ready to ship” to “safe in production.” They help teams plan rollout, observe real behavior, and keep documentation and operations aligned after implementation.

| Skill | Purpose |
| --- | --- |
| `release-planner` | Designs release execution plans with rollout waves, migration sequencing, rollback strategy, communication, validation checkpoints, and go/no-go criteria. |
| `observability-designer` | Designs correlation-first observability strategies across logs, metrics, traces, workflow telemetry, AI telemetry, alerting, privacy, and telemetry cost. |
| `documentation-architect` | Designs scalable documentation systems covering information architecture, onboarding, architecture docs, operations docs, governance docs, and Mermaid-based diagram guidance. |

## Recommended Flows

The skills can be combined as repeatable operating flows depending on what part of the lifecycle the team is working on.

| Flow | Goal | Typical Skills |
| --- | --- | --- |
| **Product-to-Spec Flow** | Move from business intent to implementation-ready definition. | `context-engineer` → `prd-writer` → `prp-writer` → `story-refiner` → `acceptance-criteria-generator` → `spec-writer` |
| **Architecture Design Flow** | Turn requirements into solution structure, contracts, workflows, and technical execution shape. | `spec-architect` → `solution-architect` → `api-spec-writer` / `frontend-spec-writer` → `workflow-designer` → `technical-planner` |
| **Enterprise Governance Flow** | Add decision discipline, policy enforcement, and architecture oversight. | `togaf-writer` → `decision-record-writer` → `risk-assessor` → `compliance-guard` |
| **Traceability and Change Control Flow** | Connect requirements to implementation and keep change impact explicit. | `traceability-manager` → `decision-record-writer` → `validation-strategist` → `reviewer` |
| **Validation and Quality Flow** | Define how the system will be verified and reviewed before release. | `acceptance-criteria-generator` → `validation-strategist` → `reviewer` → `risk-assessor` |
| **Production Readiness Flow** | Prepare a change for controlled release, visibility, and safe operation. | `release-planner` → `observability-designer` → `documentation-architect` |
| **AI Agent System Flow** | Design robust AI-native workflows with prompt contracts, observability, and governance. | `context-engineer` → `prompt-engineer` → `workflow-designer` → `observability-designer` → `risk-assessor` → `compliance-guard` |

## Suggested End-to-End Flow

For a robust AI-assisted engineering workflow, a typical path through the repository is:

1. **Shape context and agent behavior** with `context-engineer` and `prompt-engineer`.
2. **Define intent** with `prd-writer`, `prp-writer`, `story-refiner`, and `acceptance-criteria-generator`.
3. **Design the system** with `spec-architect`, `spec-writer`, `solution-architect`, `workflow-designer`, `api-spec-writer`, `frontend-spec-writer`, `technical-planner`, and `togaf-writer` when enterprise framing is needed.
4. **Govern the design** with `decision-record-writer`, `risk-assessor`, `compliance-guard`, and `traceability-manager`.
5. **Prepare execution and proof** with `task-breakdown`, `validation-strategist`, and `reviewer`.
6. **Ship and operate safely** with `release-planner`, `observability-designer`, and `documentation-architect`.

This is why the repository increasingly behaves like an **AI-native engineering governance platform** instead of a flat prompt library.

## Skill Inventory

| Skill | Files |
| --- | --- |
| `acceptance-criteria-generator` | `skills/acceptance-criteria-generator/SKILL.md` / `skills/acceptance-criteria-generator.zip` |
| `api-spec-writer` | `skills/api-spec-writer/SKILL.md` / `skills/api-spec-writer.zip` |
| `compliance-guard` | `skills/compliance-guard/SKILL.md` / `skills/compliance-guard.zip` |
| `context-engineer` | `skills/context-engineer/SKILL.md` / `skills/context-engineer.zip` |
| `decision-record-writer` | `skills/decision-record-writer/SKILL.md` / `skills/decision-record-writer.zip` |
| `documentation-architect` | `skills/documentation-architect/SKILL.md` / `skills/documentation-architect.zip` |
| `frontend-spec-writer` | `skills/frontend-spec-writer/SKILL.md` / `skills/frontend-spec-writer.zip` |
| `observability-designer` | `skills/observability-designer/SKILL.md` / `skills/observability-designer.zip` |
| `prd-writer` | `skills/prd-writer/SKILL.md` / `skills/prd-writer.zip` |
| `prompt-engineer` | `skills/prompt-engineer/SKILL.md` / `skills/prompt-engineer.zip` |
| `prp-writer` | `skills/prp-writer/SKILL.md` / `skills/prp-writer.zip` |
| `release-planner` | `skills/release-planner/SKILL.md` / `skills/release-planner.zip` |
| `reviewer` | `skills/reviewer/SKILL.md` / `skills/reviewer.zip` |
| `risk-assessor` | `skills/risk-assessor/SKILL.md` / `skills/risk-assessor.zip` |
| `solution-architect` | `skills/solution-architect/SKILL.md` / `skills/solution-architect.zip` |
| `spec-architect` | `skills/spec-architect/SKILL.md` / `skills/spec-architect.zip` |
| `spec-writer` | `skills/spec-writer/SKILL.md` / `skills/spec-writer.zip` |
| `story-refiner` | `skills/story-refiner/SKILL.md` / `skills/story-refiner.zip` |
| `task-breakdown` | `skills/task-breakdown/SKILL.md` / `skills/task-breakdown.zip` |
| `technical-planner` | `skills/technical-planner/SKILL.md` / `skills/technical-planner.zip` |
| `togaf-writer` | `skills/togaf-writer/SKILL.md` / `skills/togaf-writer.zip` |
| `traceability-manager` | `skills/traceability-manager/SKILL.md` / `skills/traceability-manager.zip` |
| `validation-strategist` | `skills/validation-strategist/SKILL.md` / `skills/validation-strategist.zip` |
| `workflow-designer` | `skills/workflow-designer/SKILL.md` / `skills/workflow-designer.zip` |

## Skill Inventory Maintenance

When a skill is added, renamed, or removed, this README should be updated so the table remains an accurate overview of the repository contents.

## Visual Flows and Diagrams

If you want a faster way to understand how the skills can be combined across the engineering lifecycle, see the PDF guide:

- [Engineering Skills — flows and diagrams (PDF)](./docs/Engineering-skills.pdf)

The PDF provides visual references for recommended flows, skill relationships, and practical ways to understand when a skill fits before, during, or after specification and design work.

## Author

<a href="https://github.com/GustavoGutierrez">
  <img src="https://avatars.githubusercontent.com/u/3159203?v=4" width="64" alt="Gustavo Gutierrez" />
</a>

**[Gustavo Gutiérrez](https://github.com/GustavoGutierrez)** — Author and principal maintainer of this repository and [DevForge](https://github.com/GustavoGutierrez/devforge), [DevPixelForge (dpf)](https://github.com/GustavoGutierrez/devpixelforge), [Canopy Ruler](https://github.com/GustavoGutierrez/canopy-ruler), [Celador CLI](https://github.com/GustavoGutierrez/celador).

- LinkedIn: https://www.linkedin.com/in/gustavo-gutierrez-mercado
- GitHub: https://github.com/GustavoGutierrez

## Support

If Engineering Skills has been useful to you, consider supporting development:

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/Z8Z81YYSUI)
