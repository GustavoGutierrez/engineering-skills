---
name: frontend-spec-writer
description: "Design complete frontend specifications from product requirements: UX flows, component hierarchies, component contracts (props/events), state management, responsive breakpoints, accessibility rules, and API integration mapping. Use when asking to design a frontend spec, component architecture, UI specification, or view specification."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - frontend-spec-writer
  - frontend spec writer
  - design frontend
  - frontend design
  - component architecture
  - UI specification
  - view specification
  - UX flow design
  - frontend component design
---

# Frontend Specification Designer

## Purpose

Use this skill to act as a Frontend Architect and UI/UX Specialist. The agent transforms product requirements (PRDs), system specifications, or architecture artifacts into detailed, component-oriented Frontend Specifications that remove visual and technical ambiguity, enabling other agents or developers to implement the UI without questions about what to render or what logic to apply.

The agent designs the complete frontend layer: user flows, component contracts, state boundaries, responsive behavior, accessibility contracts, and API integration points.

This skill is domain-generic. It must work for any web application, SaaS product, dashboard, consumer app, or internal tool without embedding project-specific assumptions about styling libraries, component frameworks, or specific tech stacks.

## When to Use

Use this skill when the user asks to:

- Design a frontend specification for a screen, view, or feature.
- Define component hierarchies, contracts (props and events), and responsibilities.
- Map user interaction flows (happy paths, decision points, edge cases, error scenarios, loading states).
- Identify which state is local to a component and which state belongs in a global store.
- Specify responsive behavior and accessibility requirements per breakpoint.
- Define which API endpoints each view consumes and how network states are handled.
- Create a component API contract that any framework (React, Vue, Svelte, Angular, Astro) can implement.
- Define microinteractions, transition animations, and feedback behaviors.
- Break a screen into presentational (dumb) and container (smart) components with clear boundaries.

Do not use this skill for product strategy, visual design details (color palettes, typography, spacing), source code implementation, backend architecture, or CSS specification. Keep the output at the logical frontend specification level.

## Core Operating Rules

1. **Single Responsibility per Component.** Each component does one thing well. Separate presentational components (purely visual, stateless) from container components (manage logic, API calls, business rules).
2. **State proximity.** Keep state as close as possible to where it is used. Avoid passing props through multiple component levels (prop drilling) — use context, stores, or composables for shared state.
3. **Five UI states required for every view.** For every screen or component, always define: Ideal State (happy path), Empty State, Loading State, Error State, and Partial State. Never describe only the happy path.
4. **Framework independence.** Describe components, props, events, state, and behavior in conceptual terms that any modern framework can implement. Do not specify React/Vue/Svelte-specific APIs unless the user provides a framework constraint.
5. **Behavior over aesthetics.** Describe what the UI does, what interactions are possible, and what feedback is given — not color choices, font sizes, or exact layout grids. Use structural descriptions.
6. **Consume existing API contracts.** When an API contract exists from `api-spec-writer` or `solution-architect`, reference those endpoint definitions directly rather than inventing new data shapes.
7. **Trace to requirements.** Every UX flow, component, or state must map back to a specific functional requirement or user goal.
8. **Explicit microinteractions.** Define triggers, rules, and feedback for interactive elements (button presses, form submissions, transitions).
9. **Accessibility as a contract.** Define tab order, ARIA roles, accessible names, and keyboard navigation expectations for interactive components.
10. **Version the spec.** Include a spec version and date so that changes can be tracked relative to the source PRD or requirements artifact.

## Detailed Frontend Design Reference

The reusable reference for component classification, state placement, the five required UI states, component contract format, responsive rules, accessibility contracts, API integration mapping, microinteractions, and component tree examples lives in `references/frontend-spec-reference.md`.

Use that reference when deeper patterns are needed. In the main skill body, always enforce these condensed rules:

- Separate presentational, container, and layout responsibilities explicitly.
- Define local state, shared state, and server state independently.
- Document all five UI states for every meaningful view: ideal, empty, loading, error, and partial.
- Specify accessibility, API integration, and feedback behavior as contracts, not implementation guesses.
- Prefer framework-neutral component contracts unless the user has already constrained the stack.

## Execution Workflow

### Phase 1: Intake and Scope Definition

1. Identify the view or screen name, route/URL, and primary user goal.
2. Read the source artifact (PRD, spec, or architecture document) and extract functional requirements and user stories.
3. Identify all API contracts that the view will consume (reference existing `api-spec-writer` specs if available).
4. List all components needed and classify each as presentational, container, or layout.
5. List assumptions, missing information, and clarifications needed.

### Phase 2: UX Flow Mapping

1. Map the happy path from entry to goal completion.
2. Identify decision points and conditional branches.
3. Define sad path outcomes (errors, empty results, permission denied).
4. Define edge cases (concurrent actions, interrupted flows, session expiry).
5. Document each step including the component responsible, API call, and state change.

### Phase 3: Component Contract Definition

1. Define each component's props (inputs), events (outputs), and internal state.
2. Classify each component as presentational, container, or layout.
3. Define the five UI states for each major component.
4. Define responsive behavior and accessibility contracts per component.

### Phase 4: State and API Mapping

1. Classify each state as local, shared (global), or server state.
2. Define which component owns each API call and which components consume the data.
3. Define retry, cache, and error handling for each API call.

### Phase 5: Specification Assembly

1. Assemble the complete Frontend Specification using the required output structure.
2. Verify that every UX flow has a corresponding component in the tree.
3. Verify that every API call has a responsible container component.
4. Verify that all five UI states are defined for the main view.

## Required Output Structure

Use this structure for every frontend specification:

```markdown
# Frontend Specification: <View Name>

## Spec Metadata
- **Version:** 1.0.0
- **Date:** <YYYY-MM-DD>
- **Source Artifact:** <PRD name / requirement ID>
- **Route:** <URL path>
- **Primary User Goal:** <What the user accomplishes here>

## 1. View Context
- **View Name:** <Identifier>
- **Objective:** <One-sentence UX goal>
- **Route/URL:** <Path>

## 2. User Flow
### Happy Path
1. <Step>
2. <Step>
...

### Sad Paths
- <Error scenario 1>
- <Error scenario 2>

### Edge Cases
- <Edge case 1>

## 3. Component Tree and Hierarchy
<Complete tree with classification>

## 4. Component Contracts
### `<ComponentName />`
**Classification:** Presentational / Container / Layout

**Props (Inputs):**
| Prop | Type | Required | Default | Description |

**Events (Outputs):**
| Event | Payload | Description |

**Internal State:**
- <State name>: <description>

**API Consumed:**
- <Endpoint> — <responsible component>

**States:**
- Ideal:
- Empty:
- Loading:
- Error:
- Partial:

**Responsive Behavior:**
- Desktop:
- Tablet:
- Mobile:

**Accessibility:**
- Keyboard navigation:
- ARIA attributes:

## 5. State Management
| State | Type | Owner Component | Sharing Scope |
| --- | --- | --- | --- |

## 6. API Integration Map
| Endpoint | Method | Component | Trigger | Success State | Error State |
| --- | --- | --- | --- | --- | --- |

## 7. Microinteractions
| Element | Trigger | Rule | Feedback | Loops/Modes |
| --- | --- | --- | --- | --- |

## 8. Accessibility Contract
- Keyboard navigation:
- ARIA landmarks:
- Focus management:
- Screen reader announcements:
```

## Quality Checklist

Before presenting the result, verify:

- [ ] All five UI states (Ideal, Empty, Loading, Error, Partial) are defined for the main view.
- [ ] Every component is classified as Presentational, Container, or Layout.
- [ ] Component props and events are fully defined with types.
- [ ] State classification (local / shared / server) is explicit per state.
- [ ] All API endpoints consumed by the view are listed with responsible component.
- [ ] All interactive elements have microinteraction definitions (trigger, rule, feedback).
- [ ] Responsive behavior is defined for Mobile, Tablet, and Desktop breakpoints.
- [ ] Accessibility contract (keyboard, ARIA, focus) is defined for interactive components.
- [ ] No color, font size, or pixel-level visual details are specified (behavior only).
- [ ] The specification is written in English.
- [ ] The component tree matches the described UX flows.
- [ ] Prop drilling is avoided; shared state uses appropriate context/store patterns.

## Present Results to User

Lead with the component tree and happy path so the user can immediately see the structure of the view. Present component contracts in detail so developers know exactly what each component expects as input and what it emits as output. Highlight the state boundary decisions (local vs. shared vs. server) since these are the most common implementation mistakes. If the view consumes existing API contracts, reference those explicitly.

## Troubleshooting

- **Unclear component boundaries:** If two responsibilities are mixed in one component, split it along the presentational/container line or the layout/component line.
- **Too many props drilled:** If a prop is passed through more than two levels of components, extract it into a context, store, or composable.
- **State stored in wrong place:** If a component's own state changes another component's behavior through props, consider moving the state to a shared store or lifting it to the nearest common ancestor.
- **Missing error states:** If a component only describes the happy path, add Empty, Loading, Error, and Partial states as required by rule 3.
- **Framework-specific details:** If the user explicitly asks for React/Vue/Svelte implementation, use the framework-specific API names but keep the logical contract identical.
- **API contract unknown:** If the user asks to design the frontend before the API exists, define the expected data shapes as `TBD` schemas and note them as dependent on `api-spec-writer` output.