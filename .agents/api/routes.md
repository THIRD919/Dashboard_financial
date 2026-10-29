# API and Server Actions

## Route handlers found

| Method | Path | Behavior |
|---|---|---|
| GET | `/api/health` | Queries local DB; returns readiness and package version, or 503 |
| GET | `/api/session-access` | Returns capability list from access context; 401 without context |
| GET | `/api/dev/dashboard-context` | Development + demo-auth only; returns active units and provider context, otherwise 404 |

## Page action surface

Server actions are present in locale pages for login, data entry, import, review, approval and admin. Exact input/output contracts are defined in the corresponding `actions.ts` files; there is no generated OpenAPI or API schema found.

## Conventions observed

- Route handlers use NextResponse/Response JSON responses.
- Health and session-access are dynamic and health disables caching.
- Domain operations are delegated to services rather than implemented in route handlers.
- Public production API authentication details beyond `getAccessContext()` are not found.

Evidence: `app/api/**/route.ts`, `app/[locale]/**/actions.ts`, `lib/auth/access.ts`.

