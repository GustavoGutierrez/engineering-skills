# Frontend Specification Reference

Detailed reusable patterns referenced by `SKILL.md`.

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
