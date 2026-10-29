# Phase 1 — Excel Workbook Analysis

## Scope and evidence

Analyzed read-only: `Vet_CMU_Interactive_Financial_Dashboard.xlsx` (75,229 bytes; modified 2026-07-13 19:30:19 +07; SHA-256 `6bec9f446b926fdaea8c19a4ba00aa171f616f6c20aad70885d19934d828b77e`). It is the only Excel workbook in the project directory and therefore the latest/appropriate version. The original file was not changed.

Inspection covered OOXML metadata, stored cell values and formulas, tables, validation, charts, merged/hidden structures, and rendered views of all 17 sheets. The package has 15 Excel Tables, four charts, no PivotTables, slicers, named ranges, external links, queries/connections, macros, or hidden sheets/rows/columns. No stored Excel error token exists, although a non-Excel rendering engine cannot evaluate several structured or Thai-sheet references and displays `#NAME?`; see the data-quality report.

## Workbook architecture

| # | Worksheet | Purpose / classification | Used range | Structure and dependencies |
|---:|---|---|---|---|
| 1 | Dashboard | Executive presentation | A1:N41 | 20 merged regions, 108 formulas, two native charts. Reads Config, Dashboard_Data and รายรับรายจ่ายกำไร_ย่อย. No in-sheet slicers; controls are shown from Config. |
| 2 | งบดุล | Raw/source balance-sheet snapshot | A1:F5 | Table `ตาราง9`; rows are four quarters; columns: quarter, current assets, non-current assets, liabilities, liquidity text, numeric proportion. Four ratio formulas. |
| 3 | รายรับรายจ่ายกำไร | Raw/source quarterly operating data | A1:F5 | Table `ตาราง1`; four newest-first quarters; revenue, expenses, result, revenue/expense text and numeric ratio. Eight formulas. |
| 4 | รายรับรายจ่ายกำไร_ย่อย | Raw/source unit operating data | A1:F12 | Table `ตาราง2`; 11 units, one row per unit, Q2/69 snapshot; revenue, expense, result and revenue/expense ratio. |
| 5 | ประมาณการรายรับกับรายรับจริง_รว | Raw/source faculty revenue budget | A1:D2 | Table `ตาราง3`; one total; structured-reference achievement formula. |
| 6 | ประมาณการรายรับกับรายรับจริง_แย | Raw/source unit revenue budget | A1:D12 | Table `ตาราง4`; 11 units; budget, actual, achievement. |
| 7 | ประมาณการรายจ่ายกับรายจ่ายจริงร | Raw/source faculty expense budget | A1:D2 | Table `ตาราง5`; one total; headers incorrectly say Revenue. |
| 8 | ประมาณการรายจ่ายกับรายจ่ายจริงแ | Raw/source unit expense budget | A1:D12 | Table `ตาราง6`; 11 units; budget, actual, utilization. |
| 9 | งบประมาณแผ่นดิน | Raw/source government budget | A1:D2 | Table `ตาราง7`; budget, expenditure, utilization. |
| 10 | งบแผ่นดินแยกหมวด | Raw/source government budget detail | A1:D3 | Table `ตาราง8`; Equipment and Construction categories. |
| 11 | Data_Audit | Documentation/audit | A1:H12 | Table `tblDataAudit`; static inventory of the ten original sheets. Its Dashboard range/purpose is stale after the dashboard rebuild. |
| 12 | Data_Clean | Clean/helper fact layer | A1:L97 | Table `tblFinancialClean`; 95 formula-linked facts plus headers. Fields: FY, quarter, month, month number, unit, category, subcategory, metric, budget, actual, amount, source. Reads all source sheets. |
| 13 | Dashboard_Data | KPI/chart helper | A1:K16 | Tables `tblKPIHelper` and `tblTrendHelper`; 29 formulas. SUMIFS over Data_Clean and direct source links. |
| 14 | Config | Configuration and filters | A1:F12 | Data validation on B4 (FY list D4:D5) and B5 (quarter list E4:E7); B6 shows unit but has no validation. Thresholds B8:B11 are explicitly placeholders. |
| 15 | README | Documentation | A1:F11 | Table `tblReadme`; explains intended refresh/filter behavior. |
| 16 | Financial_Analysis | Analytical report | A1:J23 | 106 formulas, one line chart; quarterly margins/ratios, budget variance and unit budget table. |
| 17 | Unit_Performance | Unit analysis | A1:H20 (chart extends visually to row 40) | Table `tblUnitPerformance`; 100 formulas, one bar chart; unit results, margin, achievements and extrema. |

Excel Tables on source sheets provide filter buttons even though worksheet-level AutoFilter elements are absent. There are data-validation elements on most source tables and two explicit dropdowns in Config. There are no frozen panes.

## Time dimensions

- Quarterly operating and liquidity data: `Q3/68`, `Q4/68`, `Q1/69`, `Q2/69`. Source sheets store them newest-first; trend helpers deliberately present them oldest-first.
- Unit operating, revenue budget, expense budget, and government-budget data are a single `Q2/69` snapshot.
- No monthly observations exist. `Data_Clean.Month` is blank and `MonthNo` is hard-coded `0` for every fact.
- Fiscal years available in Config are `68` and `69`. The workbook does not explicitly store `2568/2569`, Gregorian equivalents, start/end dates, or a quarter-to-month map.
- The labels are consistent with abbreviated Buddhist Era fiscal years, but that interpretation and the Thai fiscal quarter mapping require Faculty confirmation. Do not generate Gregorian dates until confirmed. If standard Thai government FY is intended, FY 69 would normally span Oct 2025–Sep 2026; this is contextual, not proven by workbook data.
- Refresh date is 2026-07-13 while selection is Q2/69. This does not prove whether Q2 is Jan–Mar or another internal reporting cut.

Dataset periodicity is mixed at workbook level: quarterly for faculty operating/liquidity trends; snapshot-only for unit and budget data; no annual or monthly fact series.

## Organizational dimensions

Codes below are proposed only; names are not silently merged. English names marked **REQUIRES CONFIRMATION** are working translations.

| Proposed code | Source / canonical Thai name | Proposed English name | Source worksheets | Notes |
|---|---|---|---|---|
| ALL | ทั้งหมด | All units | Data_Clean, Config | Faculty aggregate selector, not an operating unit. |
| VET-OFFICE | สำนักงาน คณะสัตวแพทยศาสตร์ | Faculty of Veterinary Medicine Office **REQUIRES CONFIRMATION** | three unit source sheets | Extra space between `สำนักงาน` and `คณะ` should be normalized only after approval. |
| NOVEL | ศูนย์การเรียนรู้และส่งเสริมสุขภาพสัตว์ภาคเหนือ(NOVEL) | Northern Animal Health Learning and Promotion Center (NOVEL) **REQUIRES CONFIRMATION** | same | Missing space before parenthesis. Confirm official English brand/name. |
| MAE-ON-AH | (โรงพยาบาลสัตว์แม่ออน) | Mae On Animal Hospital **REQUIRES CONFIRMATION** | same | Source has unmatched presentation parentheses; preserve alias. |
| LARGE-ANIMAL-HOSP | โรงพยาบาลสัตว์ใหญ่และปศุสัตว์ | Large Animal and Livestock Hospital **REQUIRES CONFIRMATION** | same | — |
| ELEPHANT-WILDLIFE | ศูนย์สุขภาพช้างและสัตว์ป่า | Elephant and Wildlife Health Center **REQUIRES CONFIRMATION** | same | — |
| VET-DIAG-INNOV | ศูนย์ชันเวชศาสตร์ชันสูตรและนวัตกรรมด้านสุขภาพสัตว์ | Veterinary Diagnostic and Animal Health Innovation Center **REQUIRES CONFIRMATION** | same | Official English name needed. |
| FELINE-COE | ศูนย์ความเป็นเลิศด้านเวชศาสตร์แมว | Center of Excellence in Feline Medicine **REQUIRES CONFIRMATION** | same | All current values and budgets are zero. |
| PET-CMU | Pet CMU (กลุ่มงานบ่มเพาะวิสาหกิจทางสัตวแพทย์) | Pet CMU (Veterinary Enterprise Incubation Group) **REQUIRES CONFIRMATION** | same | Mixed-language official brand. |
| AP-VPH-FS | ศูนย์สัตวแพทย์สาธารณสุขและอาหารปลอดภัยเอเชียแปซิฟิก | Asia-Pacific Veterinary Public Health and Food Safety Center **REQUIRES CONFIRMATION** | same | — |
| PODD | ศูนย์เฝ้าระวังสุขภาพหนึ่งเดียว PODD | One Health Surveillance Center (PODD) **REQUIRES CONFIRMATION** | same | Confirm whether PODD is the official unit name or program. |
| SRIBUABAN-AHO | สำนักงานโรงพยาบาลสัตว์(ศรีบัวบาน) | Sribuaban Animal Hospital Office **REQUIRES CONFIRMATION** | same | Missing space before parenthesis; all actuals zero but non-zero budgets. |

All 11 unit names align exactly across the three unit-level source tables. No duplicate spelling within those tables was found. Formatting inconsistencies (spaces/parentheses/mixed language) should be captured as aliases rather than overwritten.

## Financial model and formula flow

The workbook is a small formula-linked FP&A model:

`10 source sheets → Data_Clean normalized facts → Dashboard_Data KPI/helper blocks → Dashboard / Financial_Analysis`

`source unit sheets → Unit_Performance and Dashboard unit table`

Important flows:

- Financial liquidity: `งบดุล!B2 / งบดุล!D2` → `งบดุล!F2` → `Data_Clean!K6` → SUMIFS in `Dashboard_Data!B9` → `Dashboard!A9` and status logic. For Q2/69: 97,630,000 / 276,820,000 = 0.3526840546 (displayed 0.35:1). It is current assets divided by total liabilities. The workbook does **not** document that liabilities are current liabilities, so it must not be called Current Ratio.
- Revenue/expense/result: `รายรับรายจ่ายกำไร` → Data_Clean → SUMIFS in Dashboard_Data B4:B6 → KPI cards. Result = revenue − expense; margin = result / revenue; expense-to-revenue = expense / revenue.
- Revenue achievement: unit revenue budget/actual sheets → Data_Clean rows 22:23 etc. → summed in Dashboard_Data B10:B11 → B12 → dashboard K9 and status.
- Expense utilization: unit expense budget/actual sheets → Data_Clean → Dashboard_Data B13:B15 → status.
- Government utilization: `งบประมาณแผ่นดิน` → Data_Clean K96:K97 → Dashboard_Data B16 and Dashboard I31:I33.
- Trend charts use direct source links through Dashboard_Data D3:G7; budget-vs-actual chart uses faculty-total source cells directly.

Potential migration problems: Excel structured references are calculation-engine dependent; formulas use English metric strings as join keys; fixed SUMIFS ranges end at row 1000; fiscal/quarter values are text or two-digit numbers; the Unit filter cannot safely return faculty totals when a specific unit is selected because the fact model mixes aggregate and unit facts; source sheets mix hard-coded numbers, calculated numbers and display text; and threshold business rules are unapproved placeholders.

## Measures present

| Source label / interpretation | Source | Calculation | Unit | Time / organization |
|---|---|---|---|---|
| Revenue (B) / รายรับ | รายรับรายจ่ายกำไร B2:B5; unit sheet B2:B12 | Hard-coded actual | THB | quarterly faculty; Q2/69 unit |
| Expenses (C) / รายจ่าย | same C columns | Hard-coded actual | THB | same |
| Net Profit (D) / ผลการดำเนินงานสุทธิ | same D columns | Revenue − expense | THB | same; “profit” terminology requires confirmation for a public faculty |
| Current Assets / สินทรัพย์หมุนเวียน | งบดุล B2:B5 | Hard-coded | THB | quarterly faculty |
| Non-Current Assets | งบดุล C2:C5 | Hard-coded; not used in liquidity KPI | THB | quarterly faculty |
| Liabilities | งบดุล D2:D5 | Hard-coded, no current/non-current split | THB | quarterly faculty |
| Financial Liquidity | งบดุล E:F | Current assets / liabilities | ratio : 1 | quarterly faculty |
| Budgeted Revenue / Revenue Q2 | revenue budget sheets | actual / budget | THB and % | Q2/69 faculty and unit |
| Budgeted Expenses / Expenses Q2 | expense budget sheets | actual / budget | THB and % | Q2/69 faculty and unit |
| Government Budget / Expenditure | government sheets | actual / budget | THB and % | Q2/69 faculty; two categories |
| Remaining budget | not stored | budget − actual, derivable only | THB | requires choice of faculty totals vs unit sums |

Revenue/expense/result growth KPIs are not implemented. There are only four sequential quarters, enough for QoQ comparisons but not a same-quarter prior-year growth calculation.

## Security classification

Recommended preliminary classifications:

- Public: approved, published aggregate KPIs only after formal release.
- Internal: workbook structure, terminology, non-sensitive threshold configuration and documentation.
- Confidential (default for this workbook): faculty/unit budgets, actual revenue/expense, assets, liabilities, unit performance, variances and forecasts.
- Restricted: future transaction-level records, bank/cash details, payroll/vendor/personal data, credentials and audit logs. These are not present in this workbook but must be anticipated.

Keep the workbook and derived documents in approved CMU environments; apply least privilege, encryption, audit logging, export controls and row/unit authorization in later phases. No deployment or external disclosure occurred in Phase 1.

