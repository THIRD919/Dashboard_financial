# Phase 4B — Web Data Entry & Validation

Phase 4B adds a bilingual periodic financial-entry workflow backed by the Phase 4A PostgreSQL-compatible schema. It does not add Excel import, production authentication, a full administration console, approval workflow, or deployment.

## Delivered

- Thai and English routes at `/th/data-entry` and `/en/data-entry`.
- Development-only user contexts for Faculty Office, NOVEL, Executive, and Administrator.
- Unit- and faculty-scope authorization, active-period checks, and locked-period rejection.
- Normalized records for Revenue, Budgeted Revenue, Expense, Budgeted Expense, Current Assets, and Liabilities.
- Draft save/delete/update services, batch submission, submitted-record immutability, duplicate prevention, and append-only audit events.
- Review-before-submit, existing-record visibility, completeness indicators, and centralized derived KPI previews.
- A development projection that lets submitted entries participate in dashboard calculations without misrepresenting them as approved accounting records.
- Provider selection using `DASHBOARD_DATA_PROVIDER=prototype|database`; prototype remains the safe default.

## Verification

`tests/data-entry.test.mjs` covers validation, zero-versus-missing semantics, precision, permissions, scope isolation, duplicates, draft/submitted behavior, derived KPIs, four-quarter aggregation, deletion, bilingual UI copy, and audit immutability.

## Boundaries

The database mode is local development infrastructure. Production identity, review/approval, hosted PostgreSQL, confidential credentials, public hosting, and Excel import remain outside Phase 4B.
