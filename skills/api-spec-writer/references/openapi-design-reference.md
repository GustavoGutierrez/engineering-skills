# API Design Reference

Detailed reusable patterns referenced by `SKILL.md`.

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
