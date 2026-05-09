---
name: api-spec-writer
description: Design complete API contracts in OpenAPI 3.0/3.1 YAML with endpoints, schemas, security, pagination, error handling, and RFC 7807 problem details. Use when asking to design an API, create an OpenAPI spec, define API endpoints, write API contracts, or generate a Swagger specification.
license: MIT
metadata:
  author: gustavog-gutierrez
  version: "1.0"
allowed-tools: Read, Edit, Write
triggers:
  - api-spec-writer
  - api spec writer
  - design API
  - API design
  - OpenAPI spec
  - OpenAPI specification
  - Swagger specification
  - API contract
  - REST API contract
  - generate OpenAPI
---

# API Contract and Specification Designer

## Purpose

Use this skill to act as an API Architect and Contract Designer expert. The agent transforms functional requirements, domain models, architecture decisions, or integration specifications into complete, valid, and testable API contracts written in OpenAPI 3.0/3.1 YAML format.

The agent produces human-readable endpoint documentation alongside machine-valid OpenAPI specifications that can be imported directly into API clients, code generators, testing tools, and documentation platforms.

This skill is domain-generic. It must work for any REST API, internal microservice, external-facing product API, partner integration, or webhook interface without embedding project-specific assumptions.

## When to Use

Use this skill when the user asks to:

- Design a complete or partial REST API from requirements, domain models, or integration needs.
- Write an OpenAPI (Swagger) 3.0 or 3.1 specification for an existing or planned API.
- Define endpoints, resource models, authentication schemes, and error responses for an API.
- Add pagination, filtering, sorting, rate limiting, or idempotency to list endpoints.
- Validate or improve an existing OpenAPI specification.
- Generate a machine-readable API contract that downstream tools can consume.
- Produce API documentation with request/response examples ready for developer consumption.
- Define webhook events, callback interfaces, or subscription models.

Do not use this skill for source-code implementation, database schema design, network topology, or product strategy. Keep the output at API contract and specification level.

## Core Operating Rules

1. **Strict RESTful semantics.** Use HTTP methods correctly: GET (read, safe, idempotent), POST (create), PUT (full replace), PATCH (partial update), DELETE (remove, idempotent). Use plural nouns for resource paths: `/users`, `/orders/123/items`, not `/getUser` or `/userById`.
2. **Strong typing everywhere.** Every request and response field must have a type, format, and optionality declaration. No fields should be described as "arbitrary JSON" unless intentionally polymorphic.
3. **Standard error responses always.** Use RFC 7807 Problem Details for all error payloads. Define consistent error schemas across all endpoints.
4. **Pagination on all list endpoints.** Every endpoint that returns a collection must include cursor-based or offset-based pagination parameters.
5. **Idempotency declared.** Any endpoint that creates, updates, or deletes state must declare whether it is idempotent and document the idempotency key mechanism if applicable.
6. **Security is first-class.** Define authentication and authorization at both global and operation levels. Use OAuth2, JWT Bearer, or API Key as appropriate.
7. **Versioning from day one.** Include a version prefix in the base URL (`/api/v1/`) and define a deprecation policy.
8. **Schema reuse via components.** All reusable schemas, parameters, responses, and security schemes must be defined in `components/` and referenced by `$ref`, not duplicated inline.
9. **Request and response examples.** Every operation must include at least one worked example for the success case and one for each major error case.
10. **OpenAPI validity check.** Before presenting the YAML block, verify that the produced OpenAPI document is structurally valid: `openapi` version field is present, every `$ref` resolves, and all required fields for paths and schemas are present.

## OpenAPI Document Structure

Every OpenAPI specification produced by this skill must follow this top-level structure:

```yaml
openapi: 3.1.0          # Always use 3.1.x (latest stable)
info:
  title:                # Short descriptive title
  version:             # Semantic version of the API spec
  description:         # Purpose, audience, and links
  contact:             # Owner team or support contact
  license:             # SPDX identifier
servers:               # Base URLs (dev, staging, prod)
  - url: https://...
    description: ...
paths:                  # All endpoints grouped by resource
  /resource:
    get:
      operationId: ...
      parameters: ...
      responses: ...
    post:
      ...
components:
  schemas:             # Reusable data models
  parameters:         # Reusable parameter definitions
  responses:           # Reusable response schemas
  securitySchemes:     # Authentication definitions
  links:              # HATEOAS-style resource relations
  callbacks:          # Webhook/callback definitions
security:               # Global security requirement
tags:                   # Groupings for documentation
```

## HTTP Status Code Standards

Use these codes consistently:

| Code | Meaning | When to Use |
| --- | --- | --- |
| `200` | OK | Successful read, update, or delete with body |
| `201` | Created | Successful resource creation; include `Location` header |
| `204` | No Content | Successful deletion or action with no response body |
| `400` | Bad Request | Malformed request syntax, missing required fields |
| `401` | Unauthorized | Missing or invalid authentication credentials |
| `403` | Forbidden | Authenticated but lacks required permissions |
| `404` | Not Found | Resource does not exist at the specified path |
| `409` | Conflict | State conflict (duplicate resource, optimistic lock failure) |
| `422` | Unprocessable Entity | Business rule violation or validation failure |
| `429` | Too Many Requests | Rate limit exceeded; include `Retry-After` header |
| `500` | Internal Server Error | Unexpected server failure; never expose internals |
| `503` | Service Unavailable | Temporary unavailability with retry guidance |

## Standard Error Schema (RFC 7807 / Problem Details)

Every error response must conform to RFC 7807:

```yaml
Error:
  type: string          # URI identifying the error type
  title: string         # Short human-readable error title
  status: integer       # HTTP status code (e.g. 422)
  detail: string       # Human-readable explanation
  instance: string      # Request path that generated the error
  errors:              # Optional: array of field-level errors
    - field: string
      message: string
      code: string
```

```yaml
ValidationError:
  type: string
  title: string
  status: integer
  detail: string
  instance: string
  errors:
    - field: string           # dot notation: "address.street"
      message: string         # Human-readable: "must not be blank"
      code: string            # Machine-readable: "required"
```

## Pagination Standards

### Cursor-Based (preferred for large datasets)

Use when: the dataset is large, grows frequently, or requires stable pagination across insertions/deletions.

```yaml
/pets:
  get:
    parameters:
      - name: cursor
        in: query
        description: Opaque cursor pointing to a page bookmark
        schema:
          type: string
      - name: limit
        in: query
        description: Number of items to return (1–100)
        schema:
          type: integer
          minimum: 1
          maximum: 100
          default: 20
    responses:
      '200':
        description: A paginated list of pets
        content:
          application/json:
            schema:
              type: object
              properties:
                data:
                  type: array
                  items:
                    $ref: '#/components/schemas/Pet'
                pagination:
                  type: object
                  properties:
                    next_cursor:
                      type: string
                      nullable: true
                      description: Cursor for next page; null if no more results
                    has_more:
                      type: boolean
                      description: Whether additional pages exist
                    limit:
                      type: integer
```

### Offset-Based (acceptable for small, static datasets)

Use when: total count is needed for UI page numbers, the dataset is small, or random page access is required.

```yaml
/pets:
  get:
    parameters:
      - name: offset
        in: query
        description: Number of items to skip
        schema:
          type: integer
          minimum: 0
          default: 0
      - name: limit
        in: query
        schema:
          type: integer
          minimum: 1
          maximum: 100
          default: 20
    responses:
      '200':
        description: A paginated list of pets
        content:
          application/json:
            schema:
              type: object
              properties:
                data:
                  type: array
                  items:
                    $ref: '#/components/schemas/Pet'
                pagination:
                  type: object
                  properties:
                    total:
                      type: integer
                      description: Total number of items matching the query
                    offset:
                      type: integer
                    limit:
                      type: integer
```

## Idempotency Standards

For POST endpoints that create resources:

```yaml
/payments:
  post:
    operationId: createPayment
    security:
      - BearerAuth: []
    parameters:
      - name: Idempotency-Key
        in: header
        description: Unique key to prevent duplicate charges
        required: true
        schema:
          type: string
          example: "pay_abc123_unique_key"
    responses:
      '201':
        headers:
          Location:
            description: URL of the newly created payment
            schema:
              type: string
              format: uri
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Payment'
            example:
              id: "pay_xyz789"
              amount: 5000
              currency: USD
              status: "succeeded"
      '409':
        description: Duplicate Idempotency-Key — original payment returned
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Error'
```

For PUT (idempotent replace) and DELETE (idempotent remove):

- PUT must accept the full resource representation; partial updates use PATCH.
- DELETE on a non-existent resource returns `200` with a confirmation or `204` with no body (idempotent deletion).

## Security Scheme Definitions

```yaml
components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: JWT bearer token issued by the authorization server

    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key
      description: API key issued per application

    OAuth2:
      type: oauth2
      description: OAuth 2.0 authorization code flow
      flows:
        authorizationCode:
          authorizationUrl: https://example.com/oauth/authorize
          tokenUrl: https://example.com/oauth/token
          scopes:
            read: Read access to resources
            write: Write access to resources
            admin: Administrative access
```

Apply security globally or per operation:

```yaml
security:
  - BearerAuth: []      # Global: all operations require authentication

paths:
  /public:
    get:
      security: []       # Override: this endpoint is public
```

## Schema Design Patterns

### Minimal Schema with Reuse

```yaml
components:
  schemas:
    Error:
      type: object
      required:
        - type
        - title
        - status
      properties:
        type:
          type: string
          description: URI-reference identifying the error condition
        title:
          type: string
          description: Short human-readable summary
        status:
          type: integer
          description: HTTP status code
        detail:
          type: string
          description: Detailed explanation
        instance:
          type: string
          description: Request path that produced the error
        errors:
          type: array
          items:
            type: object
            properties:
              field:
                type: string
              message:
                type: string
              code:
                type: string

    User:
      type: object
      required:
        - id
        - email
      properties:
        id:
          type: string
          format: uuid
          description: Unique identifier
        email:
          type: string
          format: email
        name:
          type: string
          maxLength: 255
        created_at:
          type: string
          format: date-time
          readOnly: true

    UsersList:
      type: object
      properties:
        data:
          type: array
          items:
            $ref: '#/components/schemas/User'
        pagination:
          $ref: '#/components/schemas/Pagination'
```

### Polymorphic Schemas (oneOf / discriminator)

```yaml
components:
  schemas:
    Payment:
      type: object
      required:
        - id
        - amount
        - status
      properties:
        id:
          type: string
        amount:
          type: integer
          description: Amount in smallest currency unit
        currency:
          type: string
          pattern: '^[A-Z]{3}$'
        status:
          type: string
          enum: [pending, succeeded, failed]
        refunded_at:
          type: string
          format: date-time
          nullable: true

    CardPayment:
      allOf:
        - $ref: '#/components/schemas/Payment'
        - type: object
          required:
            - card_last_four
          properties:
            card_last_four:
              type: string
              minLength: 4
              maxLength: 4
            card_brand:
              type: string
              enum: [visa, mastercard, amex]

    BankTransfer:
      allOf:
        - $ref: '#/components/schemas/Payment'
        - type: object
          required:
            - bank_account_id
          properties:
            bank_account_id:
              type: string

    PaymentResponse:
      oneOf:
        - $ref: '#/components/schemas/CardPayment'
        - $ref: '#/components/schemas/BankTransfer'
      discriminator:
        propertyName: status
        mapping:
          pending: '#/components/schemas/Payment'
          succeeded: '#/components/schemas/CardPayment'
          failed: '#/components/schemas/Payment'
```

### allOf for Composition

```yaml
components:
  schemas:
    Timestamps:
      type: object
      required:
        - created_at
      properties:
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time

    UserWithTimestamps:
      allOf:
        - $ref: '#/components/schemas/User'
        - $ref: '#/components/schemas/Timestamps'
```

## Versioning Strategy

Prefer URL path versioning for clarity and gateway compatibility:

```yaml
servers:
  - url: https://api.example.com/api/v1
    description: Current stable version
  - url: https://api.example.com/api/v2
    description: Next version (in beta)
```

Define a sunset/deprecation policy per endpoint:

```yaml
paths:
  /users/{id}/orders:
    get:
      summary: Get all orders for a user (deprecated)
      deprecated: true
      headers:
        Sunset:
          description: Removal date for this endpoint
          schema:
            type: string
            format: date-time
        Link:
          description: Migration guide
          schema:
            type: string
            example: '<https://api.example.com/docs/v2/migrate>; rel="deprecation"; type="text/html"'
```

## Rate Limiting Documentation

Document rate limits per endpoint:

```yaml
paths:
  /users:
    get:
      summary: List users
      operationId: listUsers
      parameters:
        - $ref: '#/components/parameters/limit'
        - $ref: '#/components/parameters/offset'
      responses:
        '200':
          headers:
            X-RateLimit-Limit:
              description: Maximum requests per minute
              schema:
                type: integer
                example: 100
            X-RateLimit-Remaining:
              description: Remaining requests in the current window
              schema:
                type: integer
                example: 95
            X-RateLimit-Reset:
              description: Unix timestamp when the rate limit resets
              schema:
                type: integer
        '429':
          description: Rate limit exceeded
          headers:
            Retry-After:
              description: Seconds to wait before retrying
              schema:
                type: integer
                example: 30
```

## Execution Workflow

### Phase 1: Intake and Scope Definition

1. Identify the API's purpose, target consumers, and authentication model.
2. Extract resources, operations, and domain rules from the input (requirements, spec document, domain model, or architecture artifact).
3. Determine whether the user needs a full API spec or specific endpoints only.
4. Identify which endpoints require pagination, idempotency, and webhooks.
5. List assumptions, missing information, and design choices that need clarification.

### Phase 2: Resource and Endpoint Modeling

1. Identify all resources and sub-resources.
2. Map each resource to CRUD operations using correct HTTP methods.
3. Design resource paths using plural nouns and nested relations only when the relation is truly intrinsic.
4. Define which endpoints are public, authenticated, or require specific scopes.
5. Mark idempotent operations clearly.

### Phase 3: Schema Design

1. Define data models for all request bodies and response payloads.
2. Extract shared schemas into `components/schemas/` with `$ref` reuse.
3. Apply strong typing: string (with format), integer, number, boolean, array, object.
4. Use `required` arrays to declare mandatory fields.
5. Add `readOnly: true` for fields that are returned but never accepted as input.
6. Apply pattern constraints, min/max length, minimum/maximum values where applicable.
7. Design polymorphic schemas using `oneOf`/`anyOf` with discriminators.

### Phase 4: Response and Error Definition

1. Define the success response schema per operation.
2. Define error response schemas for all applicable HTTP status codes.
3. Use the standard `Error` and `ValidationError` schemas from `components/schemas/`.
4. Include response headers where relevant (Location, RateLimit, Pagination-Cursor).

### Phase 5: OpenAPI YAML Generation

1. Assemble the complete OpenAPI document following the standard structure.
2. Verify every `$ref` resolves to a defined component.
3. Ensure every operation has `operationId` that is unique within the spec.
4. Add examples for all major request and response payloads.
5. Apply `tags` to group endpoints by resource for documentation clarity.
6. Include server entries for all environments (development, staging, production).

### Phase 6: Quality Verification

1. Check that `openapi` field is set to a valid version string.
2. Verify that every path parameter appears in the operation's parameter list with `in: path`.
3. Verify that every required parameter is marked `required: true`.
4. Verify that every `content` object has a media type key (e.g., `application/json`).
5. Confirm all security schemes referenced in `security` are defined in `components/securitySchemes`.

## Required Output Structure

Use this two-part format for every response:

### Part 1: Human-Readable API Summary

```markdown
# API Contract: <API Name>

## 1. API Overview
- **Purpose:** <What problem this API solves>
- **Base URL:** `/api/v1/`
- **Auth:** <Auth type> — <Bearer JWT / OAuth2 / API Key>
- **Version:** `1.0.0` — <Deprecation policy if any>

## 2. Resources
| Resource | Description | Path |
| --- | --- | --- |

## 3. Endpoint Index
| Method | Path | Description | Auth | Idempotent |
| --- | --- | --- | --- | --- |
| GET | /resource | List | Yes | Yes |
| POST | /resource | Create | Yes | No |

## 4. Global Rules
- Pagination: <cursor / offset> with default limit
- Rate limit: <N> req/min per API key
- Error format: RFC 7807 Problem Details
- Versioning: URL path (/api/v1/, /api/v2/)
```

### Part 2: Per-Endpoint Detail

```markdown
### `GET /resource/{id}`
**Description:** Retrieve a specific resource by its identifier.

**Parameters:**
| Name | Location | Type | Required | Description |
| --- | --- | --- | --- | --- |

**Responses:**
- `200 OK` — Returns the requested resource
- `404 Not Found` — Resource does not exist
- `401 Unauthorized` — Missing or invalid token

**Example response (200):**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Sample Resource",
  "created_at": "2025-01-15T09:30:00Z"
}
```
```

### Part 3: OpenAPI YAML Block

```yaml
openapi: 3.1.0
info:
  title: <API Name>
  version: 1.0.0
  description: |
    <API purpose and usage notes.>
  contact:
    name: <Team>
    url: https://...
  license:
    name: Apache-2.0
servers:
  - url: https://api.example.com/api/v1
    description: Production
paths:
  ...
components:
  schemas:
  securitySchemes:
security:
  - BearerAuth: []
```

## Quality Checklist

Before presenting the result, verify:

- [ ] All HTTP methods are used semantically correctly (GET is safe and idempotent, DELETE is idempotent, etc.).
- [ ] Every schema field has a declared type, and required fields are explicitly listed.
- [ ] Every list endpoint includes pagination parameters and a pagination response wrapper.
- [ ] Every mutation endpoint (POST/PUT/PATCH/DELETE) has a defined error response for each applicable status code.
- [ ] The error schema follows RFC 7807 / Problem Details format.
- [ ] Authentication is declared globally and overridden only where it differs per operation.
- [ ] All `$ref` values resolve to a defined component.
- [ ] Every operation has a unique `operationId`.
- [ ] Examples are provided for all major request and response payloads.
- [ ] The spec is written in English.
- [ ] No internal implementation details (database table names, internal service names) appear in paths or schema field names.

## Present Results to User

Lead with the Human-Readable API Summary so the user can immediately understand the API shape. Present the endpoint index as a table for quick scanning. Present the OpenAPI YAML block after the human-readable sections — this is the machine-readable deliverable that can be copied directly into tools. Highlight any design decisions that required tradeoffs (e.g., cursor vs. offset pagination, OAuth2 vs. API Key, versioning approach).

## Troubleshooting

- **User provides a vague requirement:** Create a baseline API with the most common REST patterns and flag explicit decisions as open questions.
- **Conflicting HTTP semantics:** If the user requests a non-REST pattern (e.g., `GET /deleteUser`), explain why REST prohibits it and propose the RESTful equivalent.
- **Polymorphic schemas too complex:** Use `oneOf` without discriminator for fewer than 3 variants; add discriminator only when runtime type detection is needed.
- **Too many endpoints:** The API scope may be too broad — suggest grouping related resources and delivering a phased spec.
- **User wants JSON Schema instead of OpenAPI:** Clarify that OpenAPI is the standard for API contracts and can embed JSON Schema; produce OpenAPI but note that the schemas can be extracted as standalone JSON Schema.
