---
name: observability-designer
description: "Trigger: observability design, observability strategy, telemetry architecture, instrument a system, distributed observability, AI observability, workflow monitoring, design alerts. Design correlation-first observability strategies covering logs, metrics, traces, AI telemetry, and workflow visibility for distributed and AI-native systems."
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - observability-designer
  - observability designer
  - design observability
  - observability strategy
  - telemetry design
  - telemetry architecture
  - instrument a system for observability
  - distributed systems observability
  - AI observability design
  - LLM observability
  - workflow observability design
  - design alerting strategy
  - golden signals design
  - SLI SLO design
---

# Observability Designer

## Purpose

Use this skill to act as a senior observability architect who designs telemetry strategies for software systems. The skill produces structured, correlation-first observability strategies covering logs, metrics, traces, AI-specific telemetry, workflow observability, alerting, and telemetry cost and privacy policy.

This skill is domain-generic. It must work for any distributed system, AI-native system, async workflow, SaaS platform, or integration landscape without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Design an observability or telemetry strategy from scratch.
- Define a signal model (what to measure, at what granularity, with what labels).
- Establish a correlation-first instrumentation strategy (trace ID, request ID, workflow ID propagation).
- Design logging, metrics, and tracing schemas with consistent context.
- Plan alerting with SLI/SLO candidates and burn-rate thresholds.
- Design AI-specific telemetry (prompts, tokens, latency, tool calls, guardrail outcomes).
- Design workflow observability for async, multi-step, or agentic systems.
- Define telemetry cost policy, sampling strategy, and privacy redaction rules.
- Assess release-readiness from an observability perspective.

Do not use this skill for low-level instrumentation code, dashboard implementation, or vendor-specific configuration. Keep output at telemetry architecture and strategy level.

## Core Operating Rules

1. **Correlation before volume.** Always design identifier propagation (trace ID, request ID, workflow ID, span ID, tenant ID) before deciding what signals to emit. Without correlation, telemetry is a collection of isolated data points.
2. **Measure outcomes, not activities.** Emit signals that answer user-facing questions: is the system fast, available, correct, and safe? Avoid metrics that measure internal state without diagnostic value.
3. **Golden signals first.** For any user-facing service, start with latency, traffic, errors, and saturation. Build SLI/SLO candidates from those before adding domain-specific signals.
4. **Three pillars, one context.** Logs, metrics, and traces must share a common correlation context (trace ID, span ID). Design the correlation schema before the signal schema.
5. **AI telemetry is a first-class pillar.** Treat prompts, responses, token usage, latency, tool calls, retrieval context, evaluator outputs, and guardrail outcomes as distinct telemetry signals with correlation IDs.
6. **Workflow state is observable state.** Every workflow state transition, checkpoint, and compensating action must emit signals sufficient to reconstruct execution history without querying the workflow store directly.
7. **Privacy by design.** Classify telemetry fields as public, internal-only, or sensitive. Define redaction and sampling policy before instrumentation.
8. **Cost is a signal.** Budget telemetry volume per service. Define sampling, aggregation, and retention policy per signal class.
9. **Use generic placeholders.** When owner, platform, or technology is unknown, use `telemetry backend`, `workflow state store`, `model gateway`, `agent runtime`, or `TBD`.
10. **State assumptions explicitly.** If context is missing, state assumptions and list them as open questions.

## Signal Model Design

### Correlation ID Taxonomy

Design the full correlation ID hierarchy before any other signal design:

| ID Type | Scope | Propagation | Purpose |
| --- | --- | --- | --- |
| `trace_id` | End-to-end request | HTTP headers, message metadata, context propagation | Correlate all signals for one user/request journey |
| `span_id` | Single operation | Automatic per span | Isolate timing within a trace |
| `request_id` | External entry point | Generated at ingress, propagated | Index all work initiated by one external trigger |
| `workflow_id` | Workflow execution | Workflow engine generates | Correlate all steps in one workflow instance |
| `step_id` | Individual workflow step | Generated per step | Isolate per-step timing and errors |
| `tenant_id` | Multi-tenant context | Propagated on every signal | Filter by tenant in shared infrastructure |
| `user_id` | Session or identity | Propagated on user-facing signals | Attribute behavior to a user |
| `correlation_id` | Business-level identifier | Application-generated | Link business transaction across services |
| `agent_id` | AI agent instance | Model gateway or agent runtime | Attribute agent behavior |

### Log Signal Design

| Field | Required | Description |
| --- | --- | --- |
| `trace_id` | Yes | Links log to distributed trace |
| `span_id` | Yes (when inside a span) | Links to specific operation |
| `request_id` | Yes (at ingress) | Groups all logs from one request |
| `workflow_id` | Conditional | When log originates inside a workflow step |
| `tenant_id` | Conditional | Required in multi-tenant environments |
| `severity` | Yes | Structured: DEBUG, INFO, WARN, ERROR, FATAL |
| `timestamp` | Yes | ISO 8601 with timezone |
| `message` | Yes | Plain-text description; no secrets |
| `attributes` | Yes | Structured key-value pairs; no PII in plain text |
| `service_name` | Yes | Source service or component |
| `service_version` | No | Enables regression detection |
| `deployment_id` | No | Correlate with deployment |

**Log sampling rules:** Sample error logs at 100%. Sample debug/info logs at a configurable rate. Never sample FATAL logs.

**Redaction rules:** Never log PII, tokens, keys, passwords, or internal IPs in plain text. Use `[REDACTED]` placeholders or structured redaction. Validate redaction with regex audit.

### Metrics Signal Design

Use the four golden signals as the foundation:

| Signal | SLI Type | Metric Pattern | SLO Candidate |
| --- | --- | --- | --- |
| Latency | Timer | `svc.<name>.latency{quantile}` (p50, p95, p99) | P99 < X ms |
| Traffic | Counter | `svc.<name>.requests` (rate per second) | Availability > X% |
| Errors | Counter | `svc.<name>.errors` (rate; 4xx vs 5xx) | Error rate < X% |
| Saturation | Gauge | `svc.<name>.saturation` (CPU%, memory%, queue depth) | Utilization < X% |

**Metric labeling standard:** Every metric must include at minimum: `service_name`, `deployment_id`, `environment` (prod/staging). Use OpenTelemetry semantic conventions for attribute naming.

**Cardinality rules:** Keep metric label cardinality under control. Never use unbounded user IDs or request IDs as metric labels. Use `tenant_id` only with cardinality control.

### Trace Signal Design

Instrument spans to answer:

1. What operation was performed?
2. Which service and version?
3. Who called it (parent span)?
4. How long did it take?
5. What was the result (success, error, timeout)?

**Span naming convention:** Use `Component.Operation` format. Example: `OrderService.CreateOrder`, `PaymentGateway.Charge`, `ModelGateway.Invoke`.

**Span events:** Emit span events for key intra-span moments: retry attempts, cache hits, tool calls, guardrail evaluations.

**Context propagation:** Use W3C TraceContext (`traceparent` header) for HTTP, and broker-native metadata for message queues (Kafka headers, SQS message attributes).

**Span links:** For async or event-driven flows where parent-child relationship is not temporal, use span links to connect related spans without establishing a parent chain.

## AI Observability Strategy

Treat AI-specific telemetry as a distinct signal class with its own correlation hierarchy.

### Prompt and Response Telemetry

| Signal | Required Fields | Description |
| --- | --- | --- |
| `prompt` | trace_id, model_name, prompt_template_id, input_tokens | Full prompt or prompt template ID |
| `response` | trace_id, model_name, output_tokens, finish_reason | Full response or sample |
| `token_usage` | trace_id, model_name, input_tokens, output_tokens, total_tokens, cost | Token counts and cost |
| `latency` | trace_id, model_name, time_to_first_token, total_latency | TTFT and total latency in ms |

**Sampling prompt/response telemetry:** Always log token usage and latency. Log full prompts/responses only in staging or when debugging; use sampling in production with a 1% tail sample policy.

**Never log raw prompts containing PII or sensitive business data** in production telemetry. Use prompt template IDs instead of raw prompt content where possible.

### Tool Call and Retrieval Telemetry

| Signal | Required Fields | Description |
| --- | --- | --- |
| `tool_call` | trace_id, tool_name, tool_input (sanitized), tool_output (sanitized), latency_ms, success | Tool invocation metadata |
| `retrieval` | trace_id, retrieval_source, chunk_count, retrieval_latency_ms, relevance_score | RAG retrieval context |

**Sanitization:** Never emit raw user queries or private documents in tool call telemetry. Emit only template IDs, source references, and latency/success indicators.

### Guardrail and Evaluator Telemetry

| Signal | Required Fields | Description |
| --- | --- | --- |
| `guardrail_outcome` | trace_id, guardrail_name, passed, confidence, action_taken | Policy enforcement result |
| `evaluator_output` | trace_id, evaluator_name, score, threshold, passed | Quality evaluation result |
| `hallucination_score` | trace_id, model_name, score, method | Hallucination detection score |

### AI Observability SLI Candidates

| SLI | SLO Candidate | Alert Threshold |
| --- | --- | --- |
| Time-to-first-token P99 | < X ms | P99 > 2x baseline |
| Token throughput | > Y tokens/s per model | Drop > 30% |
| Guardrail block rate | < X% | Spike > 2x baseline |
| Cost per 1K tokens | < $X | Exceed budget by 20% |
| Error rate (model timeout, API error) | < X% | > SLO threshold |

## Workflow Observability Strategy

Design workflow telemetry as an extension of the trace context, not a separate system.

### Workflow Correlation Model

Every workflow execution must be correlated through:

1. `workflow_id`: globally unique workflow instance identifier.
2. `step_id`: per-step identifier within the workflow.
3. `trace_id`: entry trace that started the workflow.
4. `parent_step_id`: for nested workflows, the step that spawned the child.
5. `checkpoint_id`: for HITL checkpoints, the human decision identifier.

### Workflow Metrics

| Metric | Type | Description | Alert |
| --- | --- | --- | --- |
| `workflow.<name>.state.<state>.enter` | Counter | State entered | Any transition to FAILED |
| `workflow.<name>.state.<state>.duration_seconds` | Histogram | Time in state | p99 > state SLA |
| `workflow.<name>.step.<step>.failure_count` | Counter | Step failures | > 1% |
| `workflow.<name>.hitl.<checkpoint>.pending` | Gauge | HITL queue depth | Any timeout |
| `workflow.<name>.step.<step>.retry_count` | Counter | Total retries | > 3 per invocation |

### Workflow Traces

Emit structured trace events for every state transition with fields: `workflow_id`, `run_id`, `from_state`, `to_state`, `event`, `timestamp`, `duration_ms`, `step_outputs`, `error` (if any).

For async workflows where parent-child spans are not temporal, use span links to connect the initiating span with the asynchronously processed span.

## Alerting Strategy

### SLI/SLO Framework

1. **Define SLIs.** Identify the user-facing outcomes that matter (availability, latency, correctness, safety).
2. **Define SLOs.** Set explicit targets with a time window (e.g., "99.5% availability over 30 days").
3. **Define error budget.** Error budget = (1 - SLO target) × window. Alert when budget burn rate endangers the SLO.
4. **Define burn-rate alerts.** Google-style burn-rate alert: alert if error budget is consumed at > 10x rate in 1 hour, or > 3x rate in 6 hours.

### Alert Quality Rules

| Rule | Rationale |
| --- | --- |
| Alert on symptoms, not causes | User reports error, not "connection pool exhausted" |
| One alert per incident | Avoid alert storms from cascading failures |
| Include runbook link | On-call must know what to do without searching |
| Set NoData thresholds | Absence of metric is also an incident |
| Severity matches user impact | P1 for downtime; P2 for degradation |

## Telemetry Cost and Privacy Policy

### Cost Budget

| Signal Class | Volume Target | Sampling | Retention |
| --- | --- | --- | --- |
| Error logs | 100% | Always | 90 days |
| Business metrics | 100% | Always | 30 days |
| Performance metrics | 100% | Always | 30 days |
| Distributed traces | < 1% sampled | Tail-based, errors first | 7 days |
| AI prompt/response | < 1% | Head and tail sample | 7 days |
| Token usage | 100% | Always | 90 days |
| Workflow traces | < 5% sampled | Errors and slow paths | 14 days |

**Sampling principles:** Always capture errors at 100%. Always capture tail latency (p99) at 100%. Sample body content (prompts, responses, payloads) at < 1% with explicit consent.

### Privacy Classification

| Class | Examples | Policy |
| --- | --- | --- |
| Public | Metrics names, service names, error codes | No redaction needed |
| Internal | IP addresses, tenant IDs, deployment IDs | Propagate with access control |
| Sensitive | User IDs, email addresses, query content | Hash or tokenize; never log raw |
| Restricted | Passwords, API keys, PII, payment data | Must not leave service boundary |

**Redaction enforcement:** Enforce redaction in the telemetry collector or agent, not in application code. Application code should emit structured fields; collector enforces redaction rules.

## Execution Workflow

### Phase 1: Context and Scope

1. Identify the system's user-facing entry points, services, data stores, and external integrations.
2. Identify whether the system includes AI/LLM components, workflow/orchestration layers, or multi-tenant contexts.
3. List assumptions, missing information, and architecture-impacting questions.
4. Classify the system type: distributed API system, AI-native system, async workflow system, or hybrid.

### Phase 2: Correlation Architecture

1. Design the correlation ID hierarchy (trace_id, request_id, workflow_id, tenant_id, etc.).
2. Define where each ID is generated, where it is propagated, and what format each propagation uses.
3. Select the context propagation mechanism (W3C TraceContext, proprietary headers, broker metadata).
4. Verify that every service boundary passes all relevant correlation IDs.

### Phase 3: Signal Schema Design

1. Design log schema with required and optional fields.
2. Design metrics schema: golden signals first, then domain-specific signals.
3. Design span taxonomy and naming conventions.
4. If AI components exist: design prompt/response, token usage, tool call, and guardrail telemetry schemas.
5. If workflow components exist: design workflow state transition and step telemetry schemas.

### Phase 4: AI and Workflow Observability

1. Design AI-specific telemetry: prompts, responses, token usage, latency, tool calls, retrieval context, guardrail outcomes.
2. Design workflow observability: state metrics, transition traces, HITL checkpoint signals.
3. Verify correlation between AI telemetry and distributed trace IDs.
4. Define AI SLI/SLO candidates and alert thresholds.

### Phase 5: Alerting and Cost Strategy

1. Define SLI/SLO candidates with concrete thresholds.
2. Define burn-rate alerting strategy.
3. Define telemetry volume budget per signal class.
4. Define sampling policy and retention schedule.
5. Classify telemetry fields by privacy level.
6. Define redaction rules and enforcement point.

### Phase 6: Release-Readiness Assessment

1. Verify all user-facing entry points have trace IDs.
2. Verify all golden signal metrics are emitted for every service.
3. Verify error logs are sampled at 100%.
4. Verify PII redaction is enforced at the collector.
5. Verify SLO alerts have runbooks and escalation paths.
6. Verify AI telemetry captures token usage and latency for every model call.

## Required Output Structure

Use this structure unless the user requests a narrower deliverable:

```markdown
# Observability Strategy: <System Name>

## 1. Executive Summary
- System type: <Distributed API / AI-native / Async Workflow / Hybrid>
- Correlation model: <Brief description of the ID hierarchy>
- Key signals: <Top 5 most important signals>
- Highest-cost telemetry: <Where volume risk is highest>
- Open questions:

## 2. Signal Model
### 2.1 Correlation ID Taxonomy
| ID Type | Scope | Propagation | Format |
| --- | --- | --- | --- |

### 2.2 Log Schema
| Field | Required | Type | Description |

### 2.3 Metrics Schema
| Signal | Metric | Labels | SLO Candidate |

### 2.4 Trace Schema
| Span Name Pattern | Required Attributes | Span Events |

### 2.5 AI Observability Schema (if applicable)
| Signal | Required Fields | Sampling Policy |

### 2.6 Workflow Observability Schema (if applicable)
| Signal | Required Fields | Trigger |

## 3. Correlation Strategy
- Context propagation mechanism:
- Propagation points (entry, exit, async boundaries):
- Third-party and broker integration:

## 4. Logging Strategy
- Log levels and sampling rules:
- Structured field conventions:
- Redaction policy:

## 5. Metrics Strategy
- Golden signals per service:
- SLI/SLO candidates:
- Alerting strategy (burn-rate, thresholds):

## 6. Tracing Strategy
- Instrumentation boundaries:
- Span naming convention:
- Sampling strategy:
- Span link usage (async workflows):

## 7. AI Observability Strategy (if applicable)
### 7.1 Prompt/Response Telemetry
- Telemetry schema:
- Sampling policy:
- Privacy controls:

### 7.2 Token Usage and Cost
- Metrics:
- Budget thresholds:

### 7.3 Tool Call and Retrieval Telemetry
- Schema:
- Sanitization rules:

### 7.4 Guardrail and Evaluator Telemetry
- Schema:
- Alert thresholds:

### 7.5 AI SLI/SLO Candidates
| SLI | Target | Alert Threshold |

## 8. Workflow Observability Strategy (if applicable)
### 8.1 Workflow Correlation Model
| ID Type | Generator | Propagation |

### 8.2 Workflow Metrics
| Metric | Type | Alert Threshold |

### 8.3 Workflow Traces
- State transition events:
- HITL signals:

## 9. Telemetry Cost and Privacy Policy
### 9.1 Volume Budget
| Signal Class | Target Volume | Sampling | Retention |

### 9.2 Privacy Classification
| Field Type | Examples | Policy |

### 9.3 Redaction Rules
- Enforcement point:
- Audit policy:

## 10. Release-Readiness Observability Checklist
| Check | Status | Notes |
| --- | --- | --- |

## 11. Open Questions and Assumptions
| Item | Assumption | Blocker? |
| --- | --- | --- |
```

## Quality Checklist

Before presenting the result, verify:

- Every signal class has a defined correlation ID that links it to a trace.
- Golden signals (latency, traffic, errors, saturation) are defined for every user-facing service.
- AI-specific telemetry (prompts, tokens, latency, tool calls, guardrails) is designed as a distinct signal class with correlation IDs.
- Workflow observability includes state metrics, transition traces, and failure alerts.
- Telemetry cost budget is defined per signal class with sampling and retention rules.
- Privacy classification is applied to all telemetry fields with redaction rules defined.
- Alert strategy includes SLI/SLO candidates, burn-rate alerts, and runbook links.
- Every signal can answer: "is the system fast, available, correct, and safe?"
- The output uses generic placeholders and no vendor-specific names unless explicitly provided by the user.
- The skill output is written in English.

## Present Results to User

Lead with the correlation model and the signal model summary. Present the SLI/SLO candidates and telemetry cost policy as the most actionable parts. Highlight any open questions that block observability implementation. If the system includes AI components, call out the AI observability section as distinct and emphasize token cost tracking. If the user supplied prior architecture or spec artifacts, explicitly map the observability strategy back to those inputs.

## Troubleshooting

- **No existing architecture context:** Create a correlation-first strategy assuming a distributed system with at least one external entry point.
- **User asks for specific vendor configuration:** Provide vendor-neutral capability guidance first; add vendor-specific notes only if the user explicitly requests it.
- **AI components underspecified:** Define the AI observability schema using the minimum set (prompt template ID, model name, token counts, latency, guardrail outcome); mark full prompt logging as TBD pending privacy review.
- **Workflow observability unclear:** Assume a state-machine workflow with at least one async or long-running step; design HITL checkpoint signals as conditional.
- **Telemetry cost unbounded:** Start with a conservative 1% trace sampling policy and instrument error logs at 100%; expand sampling only after measuring actual volume.
- **Privacy requirements unknown:** Classify all user-provided content, tokenized identifiers, and raw prompts as Restricted; default to no raw content in telemetry until privacy review is complete.
