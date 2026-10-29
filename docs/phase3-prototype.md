# Phase 3 — Web Dashboard Prototype

## Outcome

The approved architecture is represented by a local Next.js prototype with Thai as the default language and an English route. The implementation is intentionally read-only and uses actual cached values from the approved Excel workbook.

## Data provenance

- Authoritative input: `Vet_CMU_Interactive_Financial_Dashboard.xlsx`.
- Extraction: `scripts/extract-excel-prototype-data.py` reads OOXML cached values using Python's standard library.
- Generated artifact: `data/prototype-financial-data.json`.
- Traceability: workbook filename, SHA-256, extraction method and data refresh date are stored in the artifact and shown in the dashboard footer.
- The extraction validates period labels and unit-name alignment before writing output. It never writes to the workbook.

Quarter labels are displayed exactly as found in Excel. The prototype does not infer or remap them to calendar or Thai fiscal quarters.

## Implemented interactions

- Reporting-period selector for Q3/68 through Q2/69.
- Source-year display derived from the selected label, without implying a fiscal convention.
- Faculty total plus all 11 organizational units.
- Thai/English switch that retains the current section.
- Unit metric switch for operating result, revenue and expense.
- Responsive desktop sidebar and compact mobile/tablet navigation.

Unit-level and budget/government source data exist only for Q2/69. Other combinations show an explicit empty state and are not fabricated.

## KPI and reconciliation treatment

- Financial Liquidity retains the approved bilingual name and is displayed as Current Assets / Liabilities.
- Operating Margin is derived reproducibly as Operating Result / Revenue.
- Revenue Achievement is shown only where a source budget exists.
- No traffic-light assessment is shown because thresholds remain unapproved.
- Faculty KPIs use faculty totals; unit KPIs use unit records.
- The reconciliation panel preserves the Q2/69 differences: Revenue 468, Expense 1 and Operating Result 467 baht. No source is adjusted to force agreement.

## Routes

- `/th/dashboard`, `/en/dashboard`: working dashboard.
- `/{locale}/financial-analysis`, `/unit-performance`, `/data-entry`, `/admin`: clearly marked Phase 4/5 placeholders.

## Phase 3 limitations

- Static local data snapshot; no production database or APIs.
- No authentication, RBAC, write operations, workflow or audit events.
- English organizational-unit translations remain provisional.
- Growth KPI cards are not shown because the workbook does not define them as current KPIs.
- Screenshot capture was not practical in the Codex in-app browser because local URL navigation was blocked by its URL security policy. TypeScript and optimized production-build validation were completed instead.
