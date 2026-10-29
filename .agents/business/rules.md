# Business Rules Evidenced in Code

## Scope and data completeness

- FACULTY data has no unit; UNIT data requires a unit.
- Annual completeness expects explicit child period labels; missing data is not treated as zero.
- Annual state is FULL YEAR only when all expected periods are present; otherwise PARTIAL YEAR/YTD.
- Faculty and unit aggregation remain isolated; unit views do not fall back to faculty records.

## Financial calculations

- Operating Result = Revenue − Expense.
- Operating Margin = Operating Result / Revenue; zero denominator is unavailable.
- Liquidity uses the latest valid Current Assets/Liabilities snapshot.
- Revenue Achievement and Expense Utilization require a safe budget scope.
- `UNKNOWN` budget scope blocks unsafe annual budget KPIs; `PERIOD` sums values; `ANNUAL` requires one consistent repeated value.
- Reconciliation can be MATCHED, WITHIN_TOLERANCE or REVIEW_REQUIRED.

## Governance

- Financial records are append-oriented; adjustments/reversals do not overwrite the original.
- Blank import amounts are preserved as no data and skipped from import.
- Exact duplicates are skipped with warning; conflicting existing amounts are errors and cannot overwrite.

Evidence: `lib/financial/**`, `lib/reconciliation/service.ts`, `lib/data-entry/validation.ts`, `lib/import/service.ts`, `docs/annual-reporting-rules.md`, `database/schema.sql`.

