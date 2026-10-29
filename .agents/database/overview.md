# Database Overview

## Engine and lifecycle

Schema uses PostgreSQL features, the `app` schema, UUIDs, JSONB, enums, triggers, indexes, views and row-level security. Local execution uses PGlite and sorted migrations `001`–`025`; seeds are selected by test/demo/production mode.

## Core entities

Profiles/roles/permissions/unit access; organizational units; reporting periods; financial metrics/categories; financial records; import batches/staging/issues/commits; reconciliation rules/results; KPI definitions/thresholds; system settings; audit logs.

## Financial record model

Records are append-oriented versions grouped by `record_group_id`. Current versions are protected by partial unique indexes. BASE, ADJUSTMENT and REVERSAL are distinct entry types. Amounts use `numeric(20,2)` and default currency is THB.

## Security

RLS policies use `app.has_permission()` and `app.can_access_scope()`. Scope is FACULTY or UNIT, with unit constraints. Audit logs are separately protected by `audit.view`. Authoritative approve/lock/import operations are intended for trusted server/database functions; broad client update access is not granted in the schema comments.

## Missing operational facts

Production host, credentials, backup destination, migration runner outside local scripts, and actual hosted Supabase project: ไม่พบข้อมูลใน source ที่ตรวจสอบ.

Evidence: `database/schema.sql`, `database/migrations/*.sql`, `database/seeds/*.sql`, `lib/database/**`, `scripts/check-database-migrations.mjs`.

