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

## Component Classification

### Presentational Components (Dumb / UI Components)

Purpose: Render UI based on props; emit events upward; have no knowledge of API calls or business logic.

Characteristics:
- Stateless or with purely UI-local state (e.g., `isDropdownOpen`).
- Receive all data through props.
- Emit events via callbacks (e.g., `onClick`, `onChange`, `onSubmit`).
- No direct store subscriptions or API calls.
- Typically pure functions of their props.

Examples:
- `<UserAvatar user={...} size="md" />`
- `<PriceDisplay amount={...} currency={...} />`
- `<DataTableColumnHeader label="Name" sortable={true} onSort={...} />`

### Container Components (Smart / Controller Components)

Purpose: Orchestrate data fetching, business logic, and state management; compose presentational components.

Characteristics:
- Own or subscribe to application state (global store, context, composable).
- Make API calls and handle responses.
- Compose and pass data to presentational components.
- Handle error states and loading states from API calls.
- May have UI-local state for interaction (modals, drawers, toggle visibility).

Examples:
- `<UserProfilePage userId={...} />` — fetches user, renders presentational components.
- `<ShoppingCartContainer />` — subscribes to cart store, orchestrates checkout flow.

### Layout Components

Purpose: Structure the page, define regions, and handle responsive behavior.

Characteristics:
- Define where child components are placed.
- Handle responsive breakpoint transitions.
- May hold navigation state (sidebar open/closed, active tab).
- Compose container and presentational components.

Examples:
- `<AppShell sidebar={...} main={...} />`
- `<GridLayout columns={3} responsive breakpoints={...} />`

## State Classification

### Local Component State (UI State)

State that belongs to a single component and does not need to be shared.

Examples:
- `isDropdownOpen` — dropdown visibility.
- `formInputValue` — text input current value.
- `activeTabIndex` — which tab is active.
- `isModalVisible` — modal visibility.

Rule: If the state is only used by one component and its direct children, it belongs locally. Do not hoist it to a global store.

### Shared State (Global / App State)

State that must be accessible across multiple unrelated components or views.

Examples:
- `currentUser` — authenticated user session.
- `theme` — light/dark mode preference.
- `notificationQueue` — toast messages across the app.
- `shoppingCart` — cart contents across header, product page, and checkout.
- `selectedLanguage` — locale for internationalization.

Rule: If two or more components that are not directly related need the same state, it belongs in a shared store, context, or composable.

### Server State (Remote / API State)

Data that comes from an API and must be fetched, cached, invalidated, and refreshed.

Examples:
- User list from `GET /users`.
- Product catalog from `GET /products`.
- Authentication token from the auth service.

Rule: Server state is not the same as global UI state. Use data-fetching patterns (TanStack Query, SWR, Vue Query, Apollo, etc.) for server state rather than storing API responses in global UI stores.

## Five Required UI States

For every view or screen, document all five states:

### 1. Ideal State (Happy Path)

The user arrives, data is loaded, and the primary user goal is achievable.

```markdown
**Ideal State — ProductListView**
When: User navigates to /products with a valid session and products exist.
Render: `<ProductGrid products={...} onProductClick={...} />`
Behavior: User can scroll, filter, sort, and click into product details.
```

### 2. Empty State

No data is available. Guide the user toward adding or configuring something.

```markdown
**Empty State — ProductListView**
When: User navigates to /products but no products exist.
Render: `<EmptyState
  title="No products yet"
  description="Add your first product to get started."
  actionLabel="Add Product"
  onAction={...}
/>`
Behavior: CTA button navigates to product creation flow.
```

### 3. Loading State

Data is being fetched. Show placeholders or spinners that match the layout structure.

```markdown
**Loading State — ProductListView**
When: API request is in flight.
Render: `<ProductGridSkeleton rows={6} columns={3} />`
Behavior: Skeleton layout matches the ideal state layout to prevent layout shift.
Microinteraction: Spinner or skeleton animation on buttons during form submission.
```

### 4. Error State

Something went wrong. Show a clear message, do not expose internal details, and provide a recovery action.

```markdown
**Error State — ProductListView**
When: API returns an error or network request fails.
Render: `<ErrorState
  title="Unable to load products"
  description="Something went wrong while loading your products."
  retryLabel="Try again"
  onRetry={...}
/>`
Behavior: Retry action re-fires the API call. No internal error details shown to user.
```

### 5. Partial / Degraded State

Some data loaded but not all — a mixed or degraded experience.

```markdown
**Partial State — ProductListView**
When: API returns partial results (some items failed to load).
Render: `<ProductGrid products={...} partialWarning="Some products may be missing." />`
Behavior: A banner or inline warning informs the user. Remaining products are rendered. Retry option available.
```

## UX Flow Specification

Define user flows step by step, including:

- Entry point (route, navigation, deep link).
- Trigger events (user action, API response, timer).
- Decision points (conditions that branch the flow).
- Each state's visual response.
- The API call made at each step.
- Error handling at each step.
- Happy path outcome.
- Sad path outcomes.

```markdown
## User Flow: CheckoutFlow

1. User clicks "Checkout" on CartView
   → Container component sets `checkoutState = "confirming"`
   → Renders `<CheckoutConfirmationPanel cart={cart} />`

2. User reviews order and clicks "Confirm Purchase"
   → `onConfirm` fires
   → Button enters loading state (spinner replaces label)
   → POST /payments is called with idempotency key

3. API returns 200 (success)
   → `checkoutState = "completed"`
   → Redirect to `/checkout/confirmation?orderId=xyz`

4. API returns 422 (validation error — card declined)
   → `checkoutState = "failed"`
   → Error card displayed below payment form
   → Retry available

5. API returns 500 (server error)
   → `checkoutState = "error"`
   → Generic error message displayed
   → Retry available

6. Network timeout (>10s)
   → Treat as 500
   → Circuit breaker triggers after 3 consecutive timeouts
```

## Component Contract Format

Define each component with this structure:

```markdown
### `<ComponentName />`

**Classification:** Presentational / Container / Layout

**Purpose:** One sentence describing what this component does.

**Props (Inputs):**
| Prop | Type | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `title` | string | Yes | — | Visible heading text |
| `items` | Item[] | Yes | [] | List of items to display |
| `isLoading` | boolean | No | false | Shows skeleton when true |
| `onItemSelect` | (item: Item) => void | No | — | Callback when user selects an item |

**Events (Outputs):**
| Event | Payload | Description |
| --- | --- | --- |
| `onItemSelect` | `{ item: Item }` | User selected an item from the list |
| `onLoadMore` | none | User scrolled to bottom, request next page |

**Internal State:**
- `isDropdownOpen` — boolean, local to this component

**API Consumed:**
- `GET /items` — orchestrated by this component (container)

**States:**
- Default: renders item list
- Loading: renders `<ItemListSkeleton />`
- Empty: renders `<EmptyState />`
- Error: renders `<ErrorState />` with retry

**Responsive Behavior:**
- Desktop: 3-column grid
- Tablet (< 1024px): 2-column grid
- Mobile (< 768px): single-column list with card layout

**Accessibility:**
- `role="listbox"` on the items container
- `role="option"` on each item
- `aria-label="Select item"` on trigger button
- Tab order: trigger → items → actions
```

## Responsive Breakpoints

Define behavior per breakpoint using this standard set:

| Breakpoint | Width | Layout Adjustments |
| --- | --- | --- |
| Mobile | < 768px | Single column; hamburger menu; cards replace table rows; stacked forms |
| Tablet | 768px – 1024px | 2-column grid; sidebar may collapse to icons; tabbed navigation |
| Desktop | > 1024px | Full layout; sidebar expanded; 3+ column grids; side panels |

For each responsive change, describe:
- Which component regions change.
- How navigation adapts.
- What happens to data tables (pagination, horizontal scroll, card view).
- How forms reflow.

## Accessibility Contract

For each component or view, define:

### Keyboard Navigation
- Tab order (first to last focusable element).
- Enter/Space activation for buttons and interactive elements.
- Escape key behavior (closes modals, dropdowns, popovers).
- Arrow key navigation for lists, menus, and tab panels.

### ARIA Attributes
- `role` — semantic role of the element.
- `aria-label` or `aria-labelledby` — accessible name for screen readers.
- `aria-describedby` — additional context for form fields.
- `aria-live` — for dynamically updated content (loading states, toast messages).
- `aria-disabled` — for disabled interactive elements.
- `aria-expanded` — for collapsible elements (accordions, dropdowns).

### Focus Management
- Where focus moves when a modal opens (trap inside modal).
- Where focus returns when a modal closes.
- How focus is restored after async operations.

## API Integration Mapping

For each view or page, define:

| API Endpoint | Method | Called By (Component) | Trigger | Response Handling | Error Handling |
| --- | --- | --- | --- | --- | --- |

For each API call, also document:
- Loading state: what is shown while the request is in flight.
- Success state: what is rendered when the response arrives.
- Error state: what is rendered if the request fails.
- Retry strategy: automatic retry with backoff or manual retry via user action.
- Cache behavior: stale-while-revalidate, cache-first, no-cache.

## Microinteractions Specification

Define microinteractions using the trigger-rule-feedback-loop model:

```markdown
### Button: PrimaryAction

**Trigger:** User clicks or presses Enter on the button.
**Rule:** If form is valid and API not in flight, submit. If form invalid, show validation. If API in flight, ignore.
**Feedback:**
  - On submit: Button label replaced by spinner, disabled.
  - On success: Toast notification appears, button re-enabled.
  - On error: Error message appears below button, button re-enabled.
**Loops/Modes:** Spinner runs until API response received or timeout (10s).

### Toggle: ThemeSwitcher

**Trigger:** User clicks the toggle.
**Rule:** Switch theme between light and dark; persist preference to localStorage.
**Feedback:** Toggle animates position; background color transitions in 200ms.
**Loops:** None.
```

## Component Tree and Hierarchy

Define the complete component tree for the view:

```markdown
## Component Tree: UserDashboardView

`<AppShell>`                          # Layout — sidebar + main
  `<Sidebar>`                         # Layout — navigation
    `<NavItem>` × N                  # Presentational
    `<NavDivider>`                    # Presentational
    `<ThemeSwitcher>`                 # Presentational + local state (theme)
  `</Sidebar>`
  `<MainContent>`                    # Layout — scrollable region
    `<PageHeader title="Dashboard">` # Presentational
    `<StatsGrid>`                     # Layout — responsive card grid
      `<StatCard>` × 4               # Presentational
    `</StatsGrid>`
    `<RecentActivityWidget>`         # Container — fetches activity
      `<ActivityItem>` × N           # Presentational
      `<EmptyState>` (internal)      # Conditional
      `<Skeleton>` (internal)        # Conditional
    `</RecentActivityWidget>`
  `</MainContent>`
`</AppShell>`
```

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