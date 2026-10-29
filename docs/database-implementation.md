# Database Implementation

## Structure

`database/migrations/001…011` is authoritative. `database/schema.sql` remains the Phase 2 design reference and is not the migration entry point. Safe idempotent seeds live in `database/seeds`.

The `app` schema contains identity/RBAC, organizational master data, reporting hierarchy, metric/category master data, versioned financial records, KPI definitions, reconciliation snapshots/rules, import staging and append-only audit records.

Money uses `NUMERIC(20,2)`. Ratios/tolerances use bounded NUMERIC. No financial money column uses FLOAT/REAL/DOUBLE.

## Financial history

BASE records are unique at period/scope/unit/metric/category grain. Approved/locked rows cannot be updated or deleted. Corrections are separately approved ADJUSTMENT or negative REVERSAL records referencing an approved original with a unique reference and reason. The authoritative view sums current approved/locked entries.

## Scope and security

FACULTY requires no unit; UNIT requires a unit. Equality between Faculty and Unit totals is intentionally not constrained. RLS helpers combine capability and Unit grants. Local identity uses a session setting adapter; a future Supabase adapter can map authenticated identity without spreading provider code through the domain.
