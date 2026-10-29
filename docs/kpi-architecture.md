# KPI Architecture

## Central service

All KPI requests call `lib/kpi` on the server. React/Recharts receive typed results such as `{code, value, unit, status, definitionVersion, period, scope, sourceRefs}` and never implement financial formulas.

`kpi_definitions` versions bilingual names/descriptions, kind, unit, direction, handler and non-executable JSON configuration. Calculation code is reviewed/tested TypeScript or a reviewed SQL view/function identified by `calculation_handler`; do not execute arbitrary formulas stored in the database.

## Calculation placement

| KPI | Kind | Authoritative scope | Calculation layer |
|---|---|---|---|
| Total Revenue / Expense | SOURCE | FACULTY for executive; UNIT for unit view | Indexed database aggregate/view over authoritative records |
| Current Assets / Liabilities | SOURCE | FACULTY | Database aggregate/view |
| สภาพคล่องทางการเงิน / Financial Liquidity | DERIVED | FACULTY | KPI service or reviewed SQL view: Current Assets / Liabilities |
| Operating Result | DERIVED | requested explicit scope | Database view: Revenue − Expense |
| Operating Margin | DERIVED | requested explicit scope | KPI service/view with null zero-denominator rule |
| Expense-to-Revenue | DERIVED | requested explicit scope | KPI service/view |
| Revenue Achievement | DERIVED | FACULTY for executive using faculty budget/actual; UNIT for unit performance | KPI service; never substitute unit sum for faculty total |
| Expense Utilization | DERIVED | same | KPI service |
| Government Utilization | DERIVED | FACULTY/category | KPI service/view |
| Revenue/Expense/Result Growth | DERIVED; PROPOSED FOR WEB | same explicit scope across comparison periods | KPI service after comparison rule approval |
| Good/Watch/Critical | CONFIGURED | follows KPI | Effective-dated approved threshold evaluation |

## Source selection

The service requires `reporting_scope`; it cannot silently fall back between scopes. Faculty executive queries use FACULTY records where available. Unit views require a unit ID and authorization. Missing data returns `not_available` with diagnostic metadata, not zero.

## Definition/version rules

- Effective dates and version are mandatory; only approved/active definitions may label executive outputs.
- Financial Liquidity retains exact bilingual names and formula trace.
- Thresholds are separate rows and inactive until approved. Existing Excel placeholders are not production policy.
- Growth definitions must specify prior period selection, QoQ/YoY/YTD basis, zero/negative denominator behavior and missing-comparison behavior.
- Materialized views are optional only when volume warrants them; refresh after approved transactions and include freshness metadata. Begin with deterministic queries/services.

## Testing

Golden tests use the Phase 1 verified calculations, scope-conflict tests, zero denominators, negative operating results, missing comparison periods, rounding and definition-version boundaries. Monetary arithmetic remains decimal end-to-end.

