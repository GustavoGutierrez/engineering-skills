---
name: togaf-writer
description: Apply or draft TOGAF-aligned enterprise architecture artifacts using ADM phases, four architecture domains, baseline-to-target analysis, governance, and migration planning.
license: Apache-2.0
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - togaf-writer
  - togaf writer
  - togaf
  - TOGAF architecture
  - enterprise architecture
  - architecture development method
  - architecture roadmap
  - baseline target architecture
---

# TOGAF Enterprise Architecture Writer

## Purpose

Use this skill to apply or draft TOGAF-aligned enterprise architecture work products. The agent acts as an enterprise architect who connects business objectives to architecture decisions through a structured ADM workflow.

This skill is domain-generic. It must work for any organization, initiative, platform, or technology context without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Create or review enterprise architecture documentation.
- Structure architecture work using TOGAF or ADM.
- Compare baseline and target architecture states.
- Align technical choices with business capabilities, value streams, risks, and governance.
- Produce architecture roadmaps, migration plans, governance checkpoints, or traceability matrices.
- Organize architecture across business, data, application, and technology domains.

Do not use this skill for detailed implementation tasks, source code, user stories, backlog writing, or low-level technical specifications. Those belong to implementation, PRD, or spec-writing workflows.

## Core Operating Rules

1. **Stay at enterprise architecture level.** Focus on capabilities, domains, systems, integrations, data flows, governance, constraints, risks, and decision rationale. Do not write source code.
2. **Always connect decisions to business intent.** Every target-state decision must state the business objective, capability, risk, compliance need, or operational outcome it supports.
3. **Always compare baseline to target.** Do not propose a target architecture without documenting the current or assumed baseline and the gap between them.
4. **Use the four TOGAF architecture domains.** Organize architecture content into Business, Data, Application, and Technology Architecture unless the user explicitly scopes the work to fewer domains.
5. **Use ADM as the process backbone.** Identify which ADM phase is being executed and produce phase-appropriate outputs.
6. **Make requirements traceable.** Capture architecture requirements and show how they influence principles, decisions, constraints, risks, and roadmap items.
7. **Use neutral placeholders.** If names, technologies, vendors, teams, timelines, or systems are unknown, use generic terms such as `approved provider`, `system of record`, `domain application`, `target platform`, or `TBD`.
8. **Flag missing information.** Ask only for missing details that materially change architecture scope, governance, risk, or target-state design.

## Four Architecture Domains

Every architecture deliverable must consider these domains:

| Domain | Required Focus |
| --- | --- |
| Business Architecture | Strategy, drivers, stakeholders, capabilities, value streams, governance, operating model, processes, policies, and business outcomes. |
| Data Architecture | Logical and physical data assets, ownership, lifecycle, quality, classification, lineage, privacy, retention, integration, and data governance. |
| Application Architecture | Applications, services, responsibilities, interfaces, dependencies, integration patterns, lifecycle status, and alignment to business capabilities. |
| Technology Architecture | Infrastructure, runtime platforms, networks, identity, security foundations, observability, deployment environments, resilience, and operational constraints. |

## ADM Phase Guide

Use this guide to choose the right behavior and output.

| ADM Phase | Agent Behavior | Expected Output |
| --- | --- | --- |
| Preliminary | Establish architecture principles, scope of architecture practice, governance model, assumptions, and tool/process standards. | Architecture principles, governance setup, architecture repository plan, decision criteria. |
| Phase A: Architecture Vision | Define scope, stakeholders, drivers, constraints, risks, and high-level vision. | Architecture vision, stakeholder map, value statement, scope boundaries, high-level target concept. |
| Phase B: Business Architecture | Model baseline and target business capabilities, processes, value streams, and governance impacts. | Capability map, business gap analysis, target business architecture. |
| Phase C: Information Systems Architecture | Define Data and Application baseline, target, and gaps. | Data architecture, application architecture, integration view, information systems gap analysis. |
| Phase D: Technology Architecture | Define baseline and target technology foundations and operational constraints. | Technology architecture, platform view, infrastructure gap analysis, standards impact. |
| Phase E: Opportunities and Solutions | Convert gaps into solution options, work packages, and transition architectures. | Options analysis, solution building blocks, work packages, transition architecture candidates. |
| Phase F: Migration Planning | Prioritize work packages by value, dependency, risk, cost, and readiness. | Migration roadmap, implementation sequence, risk-adjusted plan, dependency map. |
| Phase G: Implementation Governance | Define conformance controls and architecture contracts. | Architecture contract, governance checkpoints, compliance criteria, exception process. |
| Phase H: Architecture Change Management | Monitor architecture drift and decide whether changes require new ADM cycles. | Change assessment, architecture backlog, trigger criteria, governance recommendations. |
| Requirements Management | Continuously capture, validate, trace, and update requirements across every phase. | Requirements traceability matrix, decision trace, open issues, change log. |

## Required Output Structure

When drafting a TOGAF-aligned artifact, use this structure unless the user asks for a narrower deliverable:

```markdown
# <Architecture Artifact Title>

## 1. Executive Architecture Summary
- Purpose:
- ADM phase:
- Scope:
- Key business drivers:
- Key architecture decisions:
- Major risks:

## 2. Architecture Context
- Stakeholders:
- Business objectives:
- Constraints:
- Assumptions:
- Out of scope:

## 3. Architecture Requirements
| ID | Requirement | Source | Domain | Priority | Validation Method |
| --- | --- | --- | --- | --- | --- |

## 4. Baseline Architecture
### Business Architecture
### Data Architecture
### Application Architecture
### Technology Architecture

## 5. Target Architecture
### Business Architecture
### Data Architecture
### Application Architecture
### Technology Architecture

## 6. Gap Analysis
| Domain | Baseline | Target | Gap | Impact | Recommendation |
| --- | --- | --- | --- | --- | --- |

## 7. Architecture Decisions
| Decision | Business Rationale | Options Considered | Consequences | Constraints |
| --- | --- | --- | --- | --- |

## 8. Opportunities and Solutions
- Candidate work packages:
- Solution building blocks:
- Transition architecture options:

## 9. Migration Roadmap
| Work Package | Business Value | Dependencies | Risk | Sequence | Readiness |
| --- | --- | --- | --- | --- | --- |

## 10. Governance and Conformance
- Architecture principles:
- Governance checkpoints:
- Conformance criteria:
- Exception process:

## 11. Risks, Issues, and Open Questions
| Type | Description | Impact | Owner | Next Action |
| --- | --- | --- | --- | --- |

## 12. Traceability Matrix
| Requirement | Architecture Decision | Domain | Work Package | Validation |
| --- | --- | --- | --- | --- |
```

## Deliverable Types

Select one or more deliverables based on the user's request:

- **Architecture Vision**: scope, drivers, constraints, stakeholder concerns, high-level target direction.
- **Domain Architecture**: baseline, target, and gap analysis for one or more architecture domains.
- **Requirements Traceability Matrix**: requirements mapped to domains, decisions, controls, and roadmap items.
- **Application Catalog**: applications, ownership, capabilities served, lifecycle status, integrations, and risks.
- **Data Catalog**: data entities, owners, classification, lifecycle, quality rules, and integration points.
- **Technology Standards View**: approved platform capabilities, constraints, dependencies, resilience, and operational controls.
- **Architecture Roadmap**: work packages, dependencies, sequencing, risks, transition states, and value delivery.
- **Architecture Contract**: implementation obligations, conformance criteria, review checkpoints, and exception handling.
- **Change Assessment**: change trigger, impact by domain, affected requirements, and recommended governance response.

## Quality Checklist

Before presenting the result, verify:

- The artifact is written in English.
- The scope and ADM phase are explicit.
- All four domains are addressed or intentionally scoped out.
- Baseline and target states are both documented.
- Gaps are actionable and tied to impact.
- Every major technical or structural decision has a business rationale.
- Requirements are traceable to decisions and validation methods.
- The roadmap identifies dependencies, risks, sequencing, and governance checkpoints.
- No project-specific names, vendors, clients, or unnecessary concrete technologies were invented.
- Unknowns are marked as `TBD` or listed as open questions.

## Response Style

- Be structured, concise, and executive-readable.
- Use tables for traceability, gap analysis, decisions, catalogs, and roadmaps.
- Use bullets for principles, constraints, assumptions, risks, and governance controls.
- Prefer capability and outcome language over implementation detail.
- If the user provides implementation technologies, treat them as inputs to be justified, not as assumptions to generalize.
