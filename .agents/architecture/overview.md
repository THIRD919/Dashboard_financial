# Architecture Overview

## Shape

The repository implements a Next.js modular monolith. Routes and components call application/domain services in `lib/`; services use database clients/repositories. Financial, KPI and reconciliation logic is implemented without React dependencies.

## Main flow

`app/[locale]` pages/actions → domain services (`lib/data-entry`, `lib/import`, `lib/workflow`, `lib/reconciliation`, `lib/financial`) → SQL client/repository → PostgreSQL-compatible schema.

`lib/data/providers.ts` provides a prototype JSON path and a database path. `lib/database/local-pglite.ts` is the local adapter. Supabase packages exist, but a concrete hosted provider implementation is not found in the inspected source.

## UI surface

Locale pages exist for dashboard, data entry, import, review, approval, admin, tasks, login, forbidden and no-authorized-units. Shared UI is in `components/`; global styling is in `app/globals.css`.

## Boundaries

- Auth/access: `lib/auth`
- Persistence: `lib/database`, `database/`
- Money/KPI/annual facts: `lib/financial`
- Workflow: `lib/workflow`
- Import: `lib/import`
- Reconciliation: `lib/reconciliation`
- Audit: `lib/audit`

## Evidence

`docs/adr/ADR-001-modular-monolith.md`, `docs/project-structure.md`, `lib/data/providers.ts`, `lib/database/`, `app/`, `components/`

