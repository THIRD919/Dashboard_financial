# Proposed Project Structure

No application scaffold is created in Phase 2. The recommended Phase 3 structure is:

```text
app/
  [locale]/
    (authenticated)/
      dashboard/
      financial/
      data-entry/
      imports/
      reconciliations/
      admin/
    layout.tsx
  api/
    imports/
components/
  dashboard/
  charts/
  financial/
  forms/
  admin/
lib/
  auth/
    provider/
    authorization/
  database/
    client/
    repositories/
  financial/
  workflow/
  import/
  reconciliation/
  kpi/
  validation/
  audit/
  i18n/
messages/
  th.json
  en.json
database/
  migrations/
  seeds/              # codes/roles only; no confidential facts
  policies/
  schema.sql
docs/
  adr/
tests/
  unit/
  integration/
  database/
  fixtures/           # synthetic/de-identified only
```

## Dependency direction

Routes/components → application/domain services → repositories/database. Domain financial/KPI/reconciliation modules must not import React. Repositories must not decide user permissions; authorization is checked before calls and reinforced by RLS. Cross-module writes use explicit service APIs and one transaction.

Keep route handlers thin, validation schemas adjacent to use cases, and capability codes centralized. Generated database types may live under `lib/database/types` but must not leak provider clients throughout the codebase.

## Testing boundaries

- Unit: decimal calculations, KPI edge cases, period ordering, state transitions, capability decisions.
- Integration: PostgreSQL constraints/RLS, import idempotency/rollback, reconciliation snapshots and audit writes.
- End-to-end later: locale routing, unit isolation, submit/approve separation and safe upload flow.

