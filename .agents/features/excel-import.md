# Feature: Excel Import

Pages/actions: `app/[locale]/import/page.tsx`, `app/[locale]/import/actions.ts`; UI: `components/import-page.tsx`; domain: `lib/import/**`.

Flow: upload → parse/profile/map → stage rows → validate → preview issues/reconciliation → confirm into financial records. Staging keeps raw/normalized payloads and validation status. Import confirmation writes records and import commits in a transaction; failures roll back the transaction and mark the batch failed.

Validation includes unknown unit/period/metric/category, locked period, invalid amount, budget scope, duplicate file, exact duplicate and conflicting existing record. Excel templates are in `templates/` and `public/templates/`.

