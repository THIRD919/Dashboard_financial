# Phase 1 Executive Summary

## Conclusion

The workbook is a 17-sheet, formula-linked executive financial model built from ten original source sheets, a normalized helper fact table, KPI/chart helpers, configuration, documentation and three presentation/analysis sheets. It covers quarterly faculty operating and liquidity data from Q3/68 to Q2/69, plus Q2/69 unit budgets/actuals and government budget data. Phase 1 analyzed it read-only; no workbook, database, application or deployment was created.

## 1. Data available

- Quarterly faculty revenue, expense and operating result.
- Quarterly current assets, non-current assets, liabilities and financial liquidity.
- Q2/69 revenue, expense and result for 11 organizational units.
- Q2/69 revenue and expense budget-versus-actual at faculty and unit levels.
- Q2/69 government budget/expenditure, with Equipment and Construction detail.
- Formula-driven helper facts, dashboard KPIs, thresholds and analytical views.

## 2. How the model works

Ten source sheets feed `Data_Clean`, which unpivots values into 95 metric facts. `Dashboard_Data` filters/sums those facts using Config selections and supplies Dashboard cards. Trend and some budget-chart blocks link directly to source sheets. `Financial_Analysis` and `Unit_Performance` provide additional formulas and charts.

## 3. Major KPIs

Implemented: Financial Liquidity, Total Revenue, Total Expense, Operating Result, Operating Margin, Expense-to-Revenue Ratio, Revenue Achievement, Expense Utilization, revenue/expense variances, Government Budget Utilization, unit margin and performance extrema. Remaining budget is derivable but not presented as a governed KPI. Revenue, expense and operating-result growth are not implemented.

For the selected Q2/69 faculty view, stored results include revenue 73,281,544; expense 57,694,327; operating result 15,587,217; operating margin 21.2703%; liquidity 0.352684:1; and government utilization 43.0948%.

## 4. Financial Liquidity definition

The actual workbook formula is:

`Current Assets / Liabilities`

Q2/69: `97,630,000 / 276,820,000 = 0.3526840546`, displayed as approximately `0.35 : 1`.

The liabilities field is not identified as current liabilities. Therefore the KPI must remain “Financial Liquidity” and must **not** be translated or modeled as Current Ratio until the Faculty confirms the denominator and accounting definition.

## 5. Organizational units

There are 11 source units plus the aggregate selector `ทั้งหมด`. Names align across unit source sheets, but several require approved English names and normalized aliases: Faculty Office; NOVEL; Mae On Animal Hospital; Large Animal and Livestock Hospital; Elephant and Wildlife Health Center; Veterinary Diagnostic/Innovation Center; Feline Medicine Center of Excellence; Pet CMU; Asia-Pacific Veterinary Public Health/Food Safety Center; PODD; and Sribuaban Animal Hospital Office. These English names are working translations only.

## 6. Reporting periods

Operating/liquidity series: Q3/68, Q4/68, Q1/69, Q2/69. All unit and budget data is a Q2/69 snapshot. No monthly data exists. The workbook does not define the full Buddhist Era year, Gregorian year conversion, fiscal year start date or quarter-to-month mapping; those require confirmation before migration.

## 7. What to retain

Retain the executive KPI hierarchy, period/unit context, revenue-expense-result trend, budget-vs-actual comparison, unit performance, government budget overview, bilingual intent, status concept and visible refresh date.

## 8. What to improve for the web

Use responsive semantic components rather than merged cells; make filters interactive and permission-aware; provide formula/definition tooltips; show units, remaining budget, variance and elapsed-period context; consolidate duplicate analytical views; add accessible status icons/text; add reconciliation and approval states; and separate stable technical codes from Thai/English display labels.

## 9. Major data-quality problems

The critical issue is non-reconciliation between faculty totals and unit sums:

| Measure | Faculty total | Unit sum | Difference |
|---|---:|---:|---:|
| Revenue actual | 73,281,544 | 73,281,076 | 468 |
| Revenue budget | 171,825,100 | 171,677,900 | 147,200 |
| Expense actual | 57,694,327 | 57,694,326 | 1 |
| Expense budget | 165,565,500 | 165,295,300 | 270,200 |

The dashboard then mixes bases: headline actuals use faculty totals, while achievement/utilization use unit sums. Other important issues are undefined fiscal mapping, ambiguous liquidity denominator, incorrect `Current_Ratio` and expense-sheet labels, unapproved status thresholds, zero-as-error handling, incomplete unit-filter coverage, fixed formula ranges and spreadsheet-engine portability.

## 10. Recommended migration approach

Create a source-preserving staging/import specification first; approve master data and KPI definitions; establish reporting-period and organizational-unit masters; select an authoritative aggregation policy with reconciliation adjustments; transform to typed facts with cell/file lineage; compute KPIs from versioned definitions; and publish only after automated tie-out, duplicate-grain, denominator and threshold checks pass.

## 11. Issues requiring Faculty confirmation

1. Does FY 69 mean BE 2569, and which months belong to Q1–Q4?
2. Are revenue/expense values accrual, cash, billed, collected or disbursed amounts?
3. Which source is authoritative when faculty totals differ from unit sums, and what explains each delta?
4. Does `Liabilities` mean total or current liabilities? What is the official definition/name of สภาพคล่องทางการเงิน?
5. Should `Net Profit` be called profit/loss, surplus/deficit or operating result?
6. Are budget figures approved budgets, estimates, annual budgets, or Q2 cumulative targets?
7. Are Q2 actuals quarterly-only or year-to-date?
8. What are the approved bilingual unit and financial terms?
9. What thresholds and favorable-direction rules should drive statuses, including elapsed-time expectations?
10. Should zero-denominator KPIs display 0%, N/A or another status?
11. Which growth comparison is required: QoQ, YoY or YTD vs prior YTD?
12. What information may be public versus internal/confidential, and who may view each unit?

## 12. Recommended Phase 2 priorities

1. Faculty validation workshop for the 12 questions above.
2. Sign off fiscal calendar, unit master, terminology/KPI dictionary and aggregation policy.
3. Define a source-to-staging import contract and automated reconciliation rules.
4. Produce a logical data model and data-security/role matrix—without production deployment until separately approved.
5. Create an acceptance test pack using the verified Q2/69 calculations and explicit discrepancy cases.

## Phase 1 validation status

Independent arithmetic matches the stored dashboard values for liquidity, operating result, operating margin, expense-to-revenue and government utilization. Revenue achievement and expense utilization reproduce the dashboard only when unit sums are used; they do not match the faculty-total source ratios. No guess was made to resolve that discrepancy.

**PHASE 1 COMPLETE — awaiting explicit approval before Phase 2.**

