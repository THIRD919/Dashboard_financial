# Feature: Manual Data Entry

Pages/actions: `app/[locale]/data-entry/page.tsx`, `app/[locale]/data-entry/actions.ts`; UI: `components/data-entry-page.tsx`; domain: `lib/data-entry/**`.

Validation covers scope/unit consistency, required period and source reference, allowed DRAFT/SUBMITTED status, decimal money normalization, at least one amount, and required budget scope when budget fields are provided. Persistence maps form fields to active financial metrics and writes financial records through the service.

Tests: `tests/data-entry.test.mjs`, `tests/data-entry-access.test.mjs`, `tests/calculation-trace.test.mjs`.

