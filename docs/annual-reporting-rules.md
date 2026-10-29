# Annual Reporting Rules

## Hierarchy and completeness

`Reporting Year → explicit child Reporting Period labels`. Existing Excel labels remain authoritative; no month or Thai fiscal-year mapping is inferred. Prototype completeness expects Q1–Q4 labels within a selected source year and counts only records with valid Revenue and Expense. Zero is valid; absence is not zero.

Annual states are FULL YEAR (4/4) or PARTIAL YEAR / YTD (fewer than 4). Partial sums are labelled as accumulated from available data, never as a completed annual total.

## Metric aggregation

| Metric | Annual rule |
|---|---|
| Revenue | Sum valid child-period actual Revenue |
| Expense | Sum valid child-period actual Expense |
| Operating Result | Annual Revenue − Annual Expense |
| Operating Margin | Annual Operating Result / Annual Revenue; never average period margins |
| Revenue Achievement | Annual actual Revenue / safely resolved annual budget |
| Expense Utilization | Annual actual Expense / safely resolved annual budget |
| Financial Liquidity | Latest valid Current Assets / Liabilities snapshot in the year, with source period |

Faculty and Unit aggregation are isolated. Unit Annual View never falls back to Faculty records.

## Budget safety

Budget metadata supports `ANNUAL`, `PERIOD`, or `UNKNOWN`.

- PERIOD: sum period budgets.
- ANNUAL: use one consistent repeated annual value; do not multiply it by the number of periods. Conflicting repeated values block aggregation.
- UNKNOWN: block annual budget, achievement and utilization calculations.

The workbook pairs a single Budgeted Revenue/Expense value with Q2 actuals but does not conclusively label the budget as annual or period-specific. Faculty, Unit and Government budget scope is therefore `UNKNOWN — FACULTY CONFIRMATION REQUIRED`. Quarterly comparisons remain valid; annual aggregation is blocked.

Government annual Budget, Actual, Remaining and Utilization become available only after scope is confirmed and period records can be aggregated safely.
