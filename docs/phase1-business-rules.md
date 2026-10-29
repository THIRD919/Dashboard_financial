# Phase 1.1 — Business-Rule Clarification

## 1. Fiscal year and quarter mapping

### Evidence from the workbook

- `รายรับรายจ่ายกำไร!A2:A5` and `งบดุล!A2:A5` contain only `Q2/69`, `Q1/69`, `Q4/68`, `Q3/68`.
- `Config!D4:D5` lists fiscal years `68`, `69`; `Config!E4:E7` lists `Q1`–`Q4`.
- `Data_Clean!A:B` separates the abbreviated year and quarter, but `Month` is blank and `MonthNo` is 0 for every record.
- `Dashboard_Data!D4:D7` orders the trend Q3/68, Q4/68, Q1/69, Q2/69. This proves sequence across a year boundary but not the months belonging to each quarter.
- The workbook contains no dates for period start/end, no month names, no fiscal-calendar table, and no formula mapping a quarter to months.
- `Config!B7` stores refresh date 2026-07-13, while selected period is Q2/69. A refresh date is not proof of the quarter convention or whether the data is quarterly versus cumulative.

### Determination

The workbook treats `68/69` as fiscal-year codes and orders Q4/68 before Q1/69, but it cannot conclusively distinguish Thai fiscal-year quarters (Oct–Sep), calendar-year quarters (Jan–Dec), or another internal reporting convention. The two-digit years are consistent with abbreviated Buddhist Era years, but no full BE or Gregorian mapping is stored.

**FACULTY CONFIRMATION REQUIRED.** Existing labels must remain unchanged until the Faculty supplies the official period calendar, start/end dates, and whether Q2 values are quarter-only or cumulative/YTD.

## 2. สภาพคล่องทางการเงิน / Financial Liquidity

The exact Excel rule is confirmed:

`Current Assets / Liabilities`

For each source row in `งบดุล`:

| Period | Numerator | Numerator cell/value | Denominator | Denominator cell/value | Formula/result cell | Result |
|---|---|---:|---|---:|---|---:|
| Q2/69 | Current Assets | B2 = 97,630,000 | Liabilities | D2 = 276,820,000 | F2 = B2/D2 | 0.3526840546 |
| Q1/69 | Current Assets | B3 = 109,300,000 | Liabilities | D3 = 258,040,000 | F3, shared formula pattern B3/D3 | 0.4235777399 |
| Q4/68 | Current Assets | B4 = 133,880,000 | Liabilities | D4 = 268,960,000 | F4, shared formula pattern B4/D4 | 0.4977691850 |
| Q3/68 | Current Assets | B5 = 91,620,000 | Liabilities | D5 = 260,360,000 | F5, shared formula pattern B5/D5 | 0.3518973729 |

The display-text column E contains rounded strings such as `0.35 : 1`; numeric column F is the calculation source. `Data_Clean!K6/K10/K14/K18` links the numeric results, `Dashboard_Data!B9` selects by FY/quarter, and `Dashboard!A9` displays the KPI.

Non-Current Assets (`งบดุล!C2:C5`) do not feed the KPI. The workbook does not label liabilities as current liabilities and contains no maturity classification. Continue using:

- Thai: **สภาพคล่องทางการเงิน**
- English: **Financial Liquidity**

Do not rename it Current Ratio. The formula is **CONFIRMED FROM EXCEL**; the accounting interpretation of the denominator remains **FACULTY CONFIRMATION REQUIRED**.

## 3. Organizational unit master proposal

All units are active in the current workbook because every name is present in all three unit-level source tables; “active” therefore means present in the workbook, not institutionally verified. No parent-child relationship among the 11 units is encoded. The proposed parent for each is the Faculty, inferred from workbook scope and **not** a detected unit hierarchy.

| unit_code | name_th | name_en | source_name | active | parent_unit | notes |
|---|---|---|---|---|---|---|
| VET-OFFICE | สำนักงาน คณะสัตวแพทยศาสตร์ | Faculty of Veterinary Medicine Office — FACULTY CONFIRMATION REQUIRED | สำนักงาน คณะสัตวแพทยศาสตร์ | true | Faculty of Veterinary Medicine (proposed) | Confirm official spacing, English name and whether it represents central administration. |
| NOVEL | ศูนย์การเรียนรู้และส่งเสริมสุขภาพสัตว์ภาคเหนือ (NOVEL) | Northern Animal Health Learning and Promotion Center (NOVEL) — FACULTY CONFIRMATION REQUIRED | ศูนย์การเรียนรู้และส่งเสริมสุขภาพสัตว์ภาคเหนือ(NOVEL) | true | Faculty (proposed) | Preserve source alias without inserted space. Confirm NOVEL official expansion. |
| MAE-ON-AH | โรงพยาบาลสัตว์แม่ออน | Mae On Animal Hospital — FACULTY CONFIRMATION REQUIRED | (โรงพยาบาลสัตว์แม่ออน) | true | Faculty (proposed) | Source contains surrounding parentheses. |
| LARGE-ANIMAL-HOSP | โรงพยาบาลสัตว์ใหญ่และปศุสัตว์ | Large Animal and Livestock Hospital — FACULTY CONFIRMATION REQUIRED | โรงพยาบาลสัตว์ใหญ่และปศุสัตว์ | true | Faculty (proposed) | Official English name required. |
| ELEPHANT-WILDLIFE | ศูนย์สุขภาพช้างและสัตว์ป่า | Elephant and Wildlife Health Center — FACULTY CONFIRMATION REQUIRED | ศูนย์สุขภาพช้างและสัตว์ป่า | true | Faculty (proposed) | Official English name required. |
| VET-DIAG-INNOV | ศูนย์ชันเวชศาสตร์ชันสูตรและนวัตกรรมด้านสุขภาพสัตว์ | Veterinary Diagnostic and Animal Health Innovation Center — FACULTY CONFIRMATION REQUIRED | ศูนย์ชันเวชศาสตร์ชันสูตรและนวัตกรรมด้านสุขภาพสัตว์ | true | Faculty (proposed) | Official English name required. |
| FELINE-COE | ศูนย์ความเป็นเลิศด้านเวชศาสตร์แมว | Center of Excellence in Feline Medicine — FACULTY CONFIRMATION REQUIRED | ศูนย์ความเป็นเลิศด้านเวชศาสตร์แมว | true | Faculty (proposed) | All operating and budget values are zero; confirm active/reporting status. |
| PET-CMU | Pet CMU (กลุ่มงานบ่มเพาะวิสาหกิจทางสัตวแพทย์) | Pet CMU (Veterinary Enterprise Incubation Group) — FACULTY CONFIRMATION REQUIRED | Pet CMU (กลุ่มงานบ่มเพาะวิสาหกิจทางสัตวแพทย์) | true | Faculty (proposed) | Mixed-language brand; retain Pet CMU. |
| AP-VPH-FS | ศูนย์สัตวแพทย์สาธารณสุขและอาหารปลอดภัยเอเชียแปซิฟิก | Asia-Pacific Veterinary Public Health and Food Safety Center — FACULTY CONFIRMATION REQUIRED | ศูนย์สัตวแพทย์สาธารณสุขและอาหารปลอดภัยเอเชียแปซิฟิก | true | Faculty (proposed) | Official English name required. |
| PODD | ศูนย์เฝ้าระวังสุขภาพหนึ่งเดียว PODD | One Health Surveillance Center (PODD) — FACULTY CONFIRMATION REQUIRED | ศูนย์เฝ้าระวังสุขภาพหนึ่งเดียว PODD | true | Faculty (proposed) | Confirm whether PODD is a unit, program or platform. |
| SRIBUABAN-AHO | สำนักงานโรงพยาบาลสัตว์ (ศรีบัวบาน) | Sribuaban Animal Hospital Office — FACULTY CONFIRMATION REQUIRED | สำนักงานโรงพยาบาลสัตว์(ศรีบัวบาน) | true | Faculty (proposed) | Non-zero budgets but zero actuals; confirm active/reporting status and official romanization. |

`ทั้งหมด` is an aggregate/filter value, not one of the 11 organizational units.

## 4. KPI business-rule status

| KPI | Status | Excel evidence | Clarification |
|---|---|---|---|
| Financial Liquidity | CONFIRMED FROM EXCEL | งบดุล F2:F5 = Current Assets / Liabilities; Dashboard_Data B9 | Formula confirmed; liability classification requires Faculty confirmation. |
| Total Revenue | CONFIRMED FROM EXCEL | รายรับรายจ่ายกำไร B2:B5; Dashboard_Data B4 | Aggregate-vs-unit authority unresolved. |
| Total Expense | CONFIRMED FROM EXCEL | รายรับรายจ่ายกำไร C2:C5; Dashboard_Data B5 | Aggregate-vs-unit authority unresolved. |
| Operating Result | CONFIRMED FROM EXCEL | Revenue − Expense in source D and Dashboard_Data B6 | Official “profit/surplus/result” terminology requires confirmation. |
| Operating Margin | CONFIRMED FROM EXCEL | Dashboard_Data B7 = B6/B4 | Zero-revenue display policy still required. |
| Expense-to-Revenue Ratio | CONFIRMED FROM EXCEL | Dashboard_Data B8 = B5/B4 | Separate from misleading source `Current_Ratio` label. |
| Revenue Achievement | FACULTY CONFIRMATION REQUIRED | Dashboard_Data B12 = unit-sum actual / unit-sum budget; total source has another reproducible ratio | Decide unit-sum versus faculty-total basis and whether budget is annual/YTD/quarterly. |
| Expense Utilization | FACULTY CONFIRMATION REQUIRED | Dashboard_Data B15 = unit-sum actual / unit-sum budget | Decide aggregation basis and favorable/elapsed-period rule. |
| Revenue Variance | FACULTY CONFIRMATION REQUIRED | Financial_Analysis I5 = actual − budget using unit sums | Direction is reproducible, but aggregation basis is disputed. |
| Expense Variance / Remaining Budget | FACULTY CONFIRMATION REQUIRED | Financial_Analysis I6 = budget − actual using unit sums | Confirm name, direction and aggregation basis. |
| Government Budget Utilization | CONFIRMED FROM EXCEL | Dashboard_Data B16 and Dashboard I33 = 89,248,624 / 207,098,179 | Status threshold is an unapproved placeholder and requires confirmation. |
| Remaining Government Budget | DERIVED BUT REPRODUCIBLE | 207,098,179 − 89,248,624 = 117,849,555 | Not currently displayed as a governed KPI. |
| Revenue Growth | PROPOSED FOR WEB | No Excel KPI/formula | Define QoQ/YoY/YTD comparison; current history cannot support YoY. |
| Expense Growth | PROPOSED FOR WEB | No Excel KPI/formula | Same. |
| Operating Result Growth | PROPOSED FOR WEB | No Excel KPI/formula | Define sign-aware behavior for zero/negative prior results. |
| Liquidity/achievement/utilization statuses | FACULTY CONFIRMATION REQUIRED | Dashboard status formulas use Config B8:B11 | Thresholds are explicitly labeled placeholders. |

## 5. Decision table

| Business Rule | Current Interpretation | Evidence | Confidence | Faculty Decision Required? | Recommended Phase 2 Treatment |
|---|---|---|---|---|---|
| Fiscal year code | 68/69 are workbook fiscal-year codes, likely abbreviated BE but not proven | Config D4:D5; Data_Clean A; quarterly labels | Low for calendar mapping | Yes | Preserve source code; create dates only after approved fiscal calendar. |
| Quarter mapping | Q3/68 → Q4/68 → Q1/69 → Q2/69 sequence; months unknown | Dashboard_Data D4:D7; no month/date map | High for order, low for month mapping | Yes | Keep labels unchanged; require period master with approved start/end dates. |
| Q2 unit scope | Unit data is treated as Q2/69 | Data_Clean A19:B95; Dashboard A29; Unit_Performance A1; budget headers | Medium-high | Yes | Record source scope explicitly; confirm quarter-only vs cumulative/YTD. |
| Financial Liquidity formula | Current Assets / Liabilities | งบดุล B:D:F; formula trace to Dashboard | High | No for formula; yes for accounting meaning | Implement exact formula and bilingual name; do not call Current Ratio. |
| Liability denominator | Source says only Liabilities | งบดุล D1 | Low | Yes | Add approved liability classification/definition. |
| Faculty vs unit operating totals | Both are valid source datasets but do not reconcile | Q2/69 reconciliation table | High | Yes | Preserve both scopes; no forced balancing; require adjustment/authority rule. |
| Operating Result | Revenue − Expense | Source D formulas; Dashboard_Data B6 | High | Terminology only | Implement formula; approve Thai/English accounting label. |
| Operating Margin | Operating Result / Revenue | Dashboard_Data B7 | High | Zero case only | Implement with null/N/A rule for zero denominator. |
| Revenue Achievement | Unit-sum actual / unit-sum budget on current dashboard | Dashboard_Data B10:B12 | High for Excel behavior | Yes | Do not implement until authoritative aggregation and budget period are approved. |
| Expense Utilization | Unit-sum actual / unit-sum budget | Dashboard_Data B13:B15 | High for Excel behavior | Yes | Approve aggregation, period basis, target curve and favorable direction. |
| Government Utilization | Government actual / government budget | งบประมาณแผ่นดิน B2:C2; Dashboard_Data B16 | High | Threshold/status only | Implement numeric KPI; withhold status until threshold policy approved. |
| Growth KPIs | Not present | No source formulas or labels | High | Yes | Treat as proposed; define comparison basis and edge cases before development. |
| Organizational hierarchy | All 11 units appear under Faculty scope; no hierarchy encoded | Unit source tables and workbook title | Low | Yes | Create provisional unit master/aliases; do not finalize English names or parents. |
| Status thresholds | Config placeholders drive executive labels | Config B8:B11 and Dashboard formulas | High | Yes | Exclude from approved production rules until versioned and signed off. |

**STOP: Phase 1.1 clarification analysis only. No Phase 2 implementation is authorized.**

