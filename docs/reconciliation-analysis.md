# Faculty Total vs Unit Reconciliation Analysis

## Scope

The workbook contains faculty-level quarterly operating data for Q3/68–Q2/69, but unit-level operating data only for Q2/69. Therefore **Q2/69 is the only reporting period in which faculty and unit datasets overlap**. No unit comparison can be performed for Q3/68, Q4/68 or Q1/69 without additional source data.

The analysis is read-only. Neither dataset was modified or adjusted.

## Reconciliation table

Difference is defined as `Faculty Total − Unit Sum`. Difference % is `Difference / Faculty Total`; it is not a materiality assessment.

| Reporting Period | Metric | Faculty Total (THB) | Unit Sum (THB) | Difference (THB) | Difference % | Possible Source/Explanation | Status |
|---|---|---:|---:|---:|---:|---|---|
| Q2/69 | Revenue | 73,281,544 | 73,281,076 | 468 | 0.000639% | Workbook provides no reconciliation or adjustment line. Central faculty transactions, an excluded unit, scope/timing differences or an accounting adjustment are possible in principle, but none is evidenced. | FACULTY CONFIRMATION REQUIRED |
| Q2/69 | Expense | 57,694,327 | 57,694,326 | 1 | 0.0000017% | Workbook provides no reconciliation or adjustment line. The one-baht difference may be rounding or source-entry variance, but the amounts are stored as whole THB and no rounding formula explains it. | FACULTY CONFIRMATION REQUIRED |
| Q2/69 | Operating Result | 15,587,217 | 15,586,750 | 467 | 0.002996% | Exactly follows the other differences: `468 revenue difference − 1 expense difference = 467`. It is not an independent formula error. Root cause remains undocumented. | FACULTY CONFIRMATION REQUIRED |

## Excel evidence

### Faculty-level values

- Revenue: `รายรับรายจ่ายกำไร!B2` = 73,281,544.
- Expense: `รายรับรายจ่ายกำไร!C2` = 57,694,327.
- Operating Result: `รายรับรายจ่ายกำไร!D2` = `B2-C2` = 15,587,217.
- Period: `รายรับรายจ่ายกำไร!A2` = `Q2/69`.

### Unit-level values

- Unit names and operating values: `รายรับรายจ่ายกำไร_ย่อย!A2:D12`.
- The sheet itself does not contain an explicit period column. Its assignment to Q2/69 is supported by:
  - `Data_Clean!A19:B95`, where formula-linked unit facts are hard-coded to FY 69 / Q2;
  - `Unit_Performance!A1`, titled `Unit Performance — Q2/69`;
  - `Dashboard!A29`, titled `Performance by Unit — Q2/69`;
  - matching unit actuals in the budget sheets whose headers explicitly state `Revenue Q2` and `Expenses Q2`.
- Unit Revenue Sum: `SUM(รายรับรายจ่ายกำไร_ย่อย!B2:B12)` = 73,281,076.
- Unit Expense Sum: `SUM(รายรับรายจ่ายกำไร_ย่อย!C2:C12)` = 57,694,326.
- Unit Operating Result Sum: `SUM(รายรับรายจ่ายกำไร_ย่อย!D2:D12)` = 15,586,750.

Every non-zero unit operating result is formula-derived as Revenue − Expense; zero-activity rows are hard-coded zero. The unit operating-result sum also equals unit revenue sum minus unit expense sum, so the 467 difference is fully explained arithmetically by the revenue and expense gaps.

## Cause investigation

| Candidate cause | Evidence found | Conclusion |
|---|---|---|
| Central faculty transactions | No explicit central adjustment or unallocated row exists. `สำนักงาน คณะสัตวแพทยศาสตร์` is already one of the 11 units, but that does not prove all central transactions are included. | Possible but unsupported — FACULTY CONFIRMATION REQUIRED |
| Units excluded from unit reporting | The same 11 unit names appear across operating, revenue-budget and expense-budget unit sheets. No 12th source unit is identifiable. The faculty totals could still include an unlisted scope. | No direct evidence — FACULTY CONFIRMATION REQUIRED |
| Accounting adjustments | No adjustment account, journal, plug or reconciliation line exists. | No evidence — FACULTY CONFIRMATION REQUIRED |
| Different reporting scopes | Faculty totals and unit sheets are separate datasets, and the unit operating sheet has no native period/scope fields. | Plausible structural risk; scope definition required |
| Timing differences | All overlapping references are labeled/assigned Q2/69, but no transaction dates or extraction timestamps exist. | Cannot test — FACULTY CONFIRMATION REQUIRED |
| Formula errors | Faculty result and unit results reproduce exactly. Gaps arise from different hard-coded source amounts, not the subtraction formulas. | Not the cause of the three operating differences |
| Missing unit data | Two units report zero actuals; one has zero budgets and one has non-zero budgets. Zero may be valid or missing, but the workbook does not distinguish them. | FACULTY CONFIRMATION REQUIRED |
| Duplicated data | No duplicate unit name or duplicated metric row is present in the unit source table. | No evidence of duplication |

## Budget reconciliation that affects KPIs

Although not part of the three requested operating metrics, budget reconciliation determines the dashboard achievement/utilization rates:

| Measure | Faculty Total (THB) | Unit Sum (THB) | Difference: Faculty − Units (THB) |
|---|---:|---:|---:|
| Revenue Budget | 171,825,100 (`ประมาณการรายรับกับรายรับจริง_รว!B2`) | 171,677,900 | 147,200 |
| Revenue Actual | 73,281,544 (`..._รว!C2`) | 73,281,076 | 468 |
| Expense Budget | 165,565,500 (`ประมาณการรายจ่ายกับรายจ่ายจริงร!B2`) | 165,295,300 | 270,200 |
| Expense Actual | 57,694,327 (`...จริงร!C2`) | 57,694,326 | 1 |

`Dashboard_Data!B10:B15` sums the unit-level Data_Clean facts, so Dashboard Revenue Achievement and Expense Utilization use unit sums. The Dashboard budget-vs-actual chart, however, links to faculty total sheets. This is a confirmed mixed-basis design and must not be carried into Phase 2 without a Faculty decision.

## Phase 2 control recommendation

Preserve both values with explicit scope codes such as `FACULTY_REPORTED_TOTAL` and `SUM_OF_REPORTED_UNITS`. Do not auto-balance. Require either an approved reconciliation adjustment with source/owner/date or a documented rule selecting the authoritative scope for each KPI.

