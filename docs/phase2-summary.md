# Phase 2 Executive Summary

## Architecture

A portable Next.js/TypeScript modular monolith with Tailwind CSS and future Recharts presentation. Supabase provides prototype Auth/PostgreSQL/storage interfaces, isolated behind adapters so university-managed identity, PostgreSQL and object storage can replace them.

## Database design

The normalized PostgreSQL draft uses bilingual master data and a unified, versioned `financial_records` ledger. Monetary values are `NUMERIC(20,2)`. Reporting periods are configurable and preserve source labels. Faculty and unit scopes are mutually explicit. Adjustments/reversals are append-only; approved history is not overwritten.

## Authentication and authorization

Supabase Auth maps to application profiles. Authorization requires capability-based RBAC, explicit faculty/unit access and valid workflow state. Server checks and PostgreSQL RLS enforce rules; frontend visibility is not security.

## Permission model

Baseline roles are VIEWER, EXECUTIVE, DATA_ENTRY and ADMIN. Roles grant capabilities, never automatic unit scope. Faculty/unit read/write grants modify every financial capability. Approval, import, lock, reconciliation review and master-data management are separate capabilities.

## Financial data lifecycle

DRAFT → SUBMITTED → APPROVED/REJECTED → LOCKED supports preparation, separation of duties and close. Only approved/locked records are authoritative. Post-lock corrections use approved adjustments or reversals.

## Import model

Excel passes through private upload, batch, staging, validation, bilingual issues, permission-aware preview, authorized confirmation, one database transaction, reconciliation and audit. It never writes directly to authoritative tables.

## Reconciliation model

Faculty totals and unit sums are stored independently. Reconciliation snapshots store both, difference, percentage, applied configurable tolerance, status and review evidence. No tolerance or balancing entry is hard-coded. Phase 1.1 discrepancies remain acceptance fixtures and are never silently corrected.

## KPI model

Versioned definitions and thresholds drive a centralized server KPI service. Faculty executive KPIs use authoritative FACULTY budget/actual records; unit achievement uses UNIT records. Financial Liquidity remains สภาพคล่องทางการเงิน / Financial Liquidity = Current Assets ÷ Liabilities. Growth KPIs are derived proposals and do not rewrite source facts.

## Security and bilingual design

Controls include secure sessions, least privilege, RLS, server validation, private/scanned uploads, rate limits, secret management, audit trails and soft-delete/append-only financial history. Thai is default, English is supported through locale routes/messages and bilingual master fields; numbers are stored once.

## Unresolved decisions before implementation

1. Approved fiscal calendar and quarter/month/date mapping; quarter-only vs cumulative/YTD.
2. Official unit English names/hierarchy and active status.
3. Accounting basis/terminology for revenue, expense, liabilities and Operating Result.
4. Authoritative explanations/handling for faculty-vs-unit differences.
5. Budget period/basis and zero-denominator behavior.
6. Approved KPI and reconciliation thresholds/tolerances.
7. Growth comparison rules.
8. Approver separation, period reopening and retention policies.
9. University SSO/infrastructure and information-classification requirements.

## Deliverables and review

Created the architecture, database, authentication/authorization, permission, lifecycle, import, reconciliation, KPI, security, i18n and project-structure documents; a migration-ready SQL draft; and ADR-001 through ADR-009.

Review checklist: no deployment or external upload occurred; no real data was seeded; bilingual fields/routes are designed; scopes remain separate; calendar is configurable; monetary fields are decimal; reconciliation/import staging/KPI centralization/audit/locking/unit access/RLS are included; and the Supabase boundary is replaceable.

## Phase 2 review checklist

| # | Check | Result |
|---:|---|---|
| 1 | No production deployment | PASS |
| 2 | No real financial data uploaded externally | PASS |
| 3 | Thai/English is architectural | PASS — locale routes/messages, profile preference and bilingual masters |
| 4 | Faculty and Unit scopes separate | PASS — enforced scope/unit constraint and query rule |
| 5 | Quarter mapping configurable | PASS — typed hierarchical periods with nullable approved dates/source labels |
| 6 | Financial Liquidity correctly named | PASS |
| 7 | Monetary values use NUMERIC/DECIMAL | PASS — `NUMERIC(20,2)` |
| 8 | Reconciliation first-class | PASS — rules, snapshots, review workflow |
| 9 | Permissions enforced beyond frontend | PASS — server checks plus RLS |
| 10 | Unit-based access supported | PASS |
| 11 | Import uses staging | PASS |
| 12 | KPI formulas centralized | PASS |
| 13 | Auditability designed | PASS |
| 14 | Approval and locking extensible | PASS |
| 15 | Supabase migration portability | PASS — provider/current-user/storage adapters |

**PHASE 2 COMPLETE — awaiting explicit approval before Phase 3.**
