# KPI Dictionary

All values below reproduce stored workbook results for Q2/69 and `ทั้งหมด` unless stated otherwise. Currency is THB. “Thai name” is proposed where the source is English and is marked for confirmation. Phase 1.1 business-rule classifications are authoritative for migration planning; “confirmed” means the Excel calculation is confirmed, not that every accounting interpretation or policy threshold is approved.

| Code | Thai name | English name | Definition / formula | Numerator | Denominator | Unit | Source / Excel reference | Dimensions | Notes |
|---|---|---|---|---|---|---|---|---|---|
| FIN-LIQ | สภาพคล่องทางการเงิน | Financial Liquidity | Current assets / liabilities | 97,630,000 | 276,820,000 | ratio : 1 | งบดุล B2,D2,F2 → Data_Clean K6 → Dashboard_Data B9 → Dashboard A9 | quarter, faculty | Q2/69 = 0.352684 (0.35:1). **Not Current Ratio**: the source does not establish that liabilities are current liabilities. |
| REV-ACT | รายรับรวม **REQUIRES CONFIRMATION** | Total Revenue | Sum/selected actual revenue | 73,281,544 | — | THB | รายรับรายจ่ายกำไร B2 → Data_Clean K3 → Dashboard_Data B4 → Dashboard C9 | quarter, unit/faculty | Faculty total differs from unit sum by 468. |
| EXP-ACT | รายจ่ายรวม **REQUIRES CONFIRMATION** | Total Expense | Sum/selected actual expense | 57,694,327 | — | THB | รายรับรายจ่ายกำไร C2 → Data_Clean K4 → Dashboard_Data B5 → Dashboard E9 | quarter, unit/faculty | Faculty total differs from unit sum by 1. |
| OP-RESULT | ผลการดำเนินงาน / กำไร(ขาดทุน) **REQUIRES CONFIRMATION** | Operating Result | Revenue − expense | 73,281,544 | 57,694,327 | THB | Dashboard_Data B6; source รายรับรายจ่ายกำไร D2 | quarter, unit/faculty | Q2/69 = 15,587,217. Prefer neutral “Operating Result” until accounting terminology is approved. |
| OP-MARGIN | อัตราผลการดำเนินงาน **REQUIRES CONFIRMATION** | Operating Margin | Operating result / revenue | 15,587,217 | 73,281,544 | % | Dashboard_Data B7 → Dashboard I9 | quarter, unit/faculty | 21.2703%. Guard zero revenue. |
| EXP-REV | อัตราส่วนรายจ่ายต่อรายรับ **REQUIRES CONFIRMATION** | Expense-to-Revenue Ratio | Expense / revenue | 57,694,327 | 73,281,544 | % | Dashboard_Data B8; Financial_Analysis F8 | quarter, unit/faculty | 78.7297%; complements operating margin when result = revenue − expense. |
| REV-BUD | ประมาณการรายรับ | Budgeted Revenue | Approved/planned revenue | — | — | THB | ประมาณการรายรับกับรายรับจริง_รว B2 or unit sheet B2:B12 | Q2/69, faculty/unit | Faculty total 171,825,100; unit sum 171,677,900. |
| REV-ACH | ร้อยละผลสำเร็จของรายรับ **REQUIRES CONFIRMATION** | Revenue Achievement | Actual revenue / budgeted revenue | 73,281,076 (unit sum) | 171,677,900 (unit sum) | % | Dashboard_Data B10:B12 → Dashboard K9 | Q2/69, faculty/unit | Dashboard = 42.6852%; direct faculty-total source ratio = 42.6489%. Critical definition mismatch. |
| EXP-BUD | ประมาณการรายจ่าย | Budgeted Expense | Approved/planned expense | — | — | THB | ประมาณการรายจ่ายกับรายจ่ายจริงร B2 or unit sheet B2:B12 | Q2/69, faculty/unit | Faculty total 165,565,500; unit sum 165,295,300. |
| EXP-UTIL | ร้อยละการใช้จ่ายงบประมาณ **REQUIRES CONFIRMATION** | Expense Utilization | Actual expense / expense budget | 57,694,326 (unit sum) | 165,295,300 (unit sum) | % | Dashboard_Data B13:B15; status Dashboard F7 | Q2/69, faculty/unit | Dashboard helper = 34.9038%; direct faculty ratio = 34.8468%. Lower is labeled “ดี” against placeholder 85%, but elapsed-time logic is absent. |
| REV-VAR | ส่วนต่างรายรับจากประมาณการ **REQUIRES CONFIRMATION** | Revenue Variance | Actual − budget | 73,281,544 | 171,825,100 | THB | Financial_Analysis I5 uses Dashboard_Data B11−B10 (unit sums) | Q2/69, faculty | Workbook value −98,396,824; faculty-total sources imply −98,543,556. Definition must be standardized. |
| EXP-VAR | ส่วนต่างรายจ่ายจากประมาณการ **REQUIRES CONFIRMATION** | Expense Variance / Remaining Expense Budget | Budget − actual | 165,565,500 | 57,694,327 | THB | Financial_Analysis I6 uses Dashboard_Data B13−B14 (unit sums) | Q2/69, faculty | Workbook value 107,600,974; faculty-total sources imply 107,871,173. Positive labeled “Within plan.” |
| GOV-BUD | งบประมาณแผ่นดิน | Government Budget | Budget appropriation | — | — | THB | งบประมาณแผ่นดิน B2; Dashboard I31 | Q2/69, faculty | 207,098,179; category totals reconcile. |
| GOV-ACT | การเบิกจ่ายงบประมาณแผ่นดิน **REQUIRES CONFIRMATION** | Government Budget Expenditure | Actual expenditure | — | — | THB | งบประมาณแผ่นดิน C2; Dashboard I32 | Q2/69, faculty | 89,248,624. |
| GOV-UTIL | ร้อยละการเบิกจ่ายงบประมาณแผ่นดิน **REQUIRES CONFIRMATION** | Government Budget Utilization | Government actual / government budget | 89,248,624 | 207,098,179 | % | Dashboard_Data B16; Dashboard I33 | Q2/69, faculty | 43.0948%. Status uses the generic expense-utilization placeholder and treats ≤85% as “ดี”; policy requires confirmation. |
| GOV-REMAIN | งบประมาณแผ่นดินคงเหลือ **REQUIRES CONFIRMATION** | Remaining Government Budget | Budget − actual | 207,098,179 | 89,248,624 | THB | Derivable; not stored/displayed | Q2/69, faculty | 117,849,555. Proposed KPI only. |
| REV-GROWTH | อัตราการเติบโตของรายรับ **REQUIRES CONFIRMATION** | Revenue Growth | (current − comparison) / comparison | — | — | % | Not implemented | proposed quarter/faculty | Four quarters exist. Confirm QoQ vs YoY; YoY cannot be calculated from available history. |
| EXP-GROWTH | อัตราการเติบโตของรายจ่าย **REQUIRES CONFIRMATION** | Expense Growth | (current − comparison) / comparison | — | — | % | Not implemented | proposed quarter/faculty | Same limitation. |
| RESULT-GROWTH | อัตราการเปลี่ยนแปลงผลการดำเนินงาน **REQUIRES CONFIRMATION** | Operating Result Growth | (current − comparison) / comparison | — | — | % | Not implemented | proposed quarter/faculty | Percentage growth is unstable when prior result is zero/negative; use absolute change or defined sign-aware rule. |

## Status KPIs and thresholds

Config B8:B11 explicitly labels these values as management placeholders:

- Liquidity: `<0.40` วิกฤต; `0.40–<0.50` เฝ้าระวัง; `≥0.50` ดี.
- Revenue achievement: `≥0.90` ดี; otherwise เฝ้าระวัง.
- Expense utilization: `≤0.85` ดี; otherwise เฝ้าระวัง.
- Government utilization reuses the expense utilization threshold.

None is an approved Faculty policy in the workbook. A web system must version thresholds by effective date and define whether expenditure progress should be compared with elapsed fiscal time.

## Phase 1.1 business-rule classification

| KPI Code | Definition status | Basis for classification | Remaining decision |
|---|---|---|---|
| FIN-LIQ | CONFIRMED FROM EXCEL | `งบดุล!F2:F5` calculates Current Assets / Liabilities and feeds the dashboard. | Confirm accounting scope of Liabilities; keep the bilingual Financial Liquidity name. |
| REV-ACT | CONFIRMED FROM EXCEL | Faculty quarterly revenue is stored in `รายรับรายจ่ายกำไร!B2:B5`. | Decide authority when faculty total differs from unit sum. |
| EXP-ACT | CONFIRMED FROM EXCEL | Faculty quarterly expense is stored in `รายรับรายจ่ายกำไร!C2:C5`. | Same. |
| OP-RESULT | CONFIRMED FROM EXCEL | Source D and Dashboard_Data B6 calculate Revenue − Expense. | Approve official “result/profit/surplus” terminology. |
| OP-MARGIN | CONFIRMED FROM EXCEL | Dashboard_Data B7 calculates Operating Result / Revenue. | Define zero-revenue presentation. |
| EXP-REV | CONFIRMED FROM EXCEL | Dashboard_Data B8 calculates Expense / Revenue. | Approve bilingual display term. |
| REV-BUD | CONFIRMED FROM EXCEL | Faculty and unit budget amounts exist in separate source tables. | Confirm budget period/basis and authoritative aggregation. |
| REV-ACH | FACULTY CONFIRMATION REQUIRED | Excel dashboard reproducibly uses unit-sum Actual / unit-sum Budget, while faculty-total sources produce a different ratio. | Select aggregation basis and period meaning. |
| EXP-BUD | CONFIRMED FROM EXCEL | Faculty and unit expense budgets exist; the faculty sheet headers are mislabeled Revenue. | Confirm budget period/basis and authoritative aggregation. |
| EXP-UTIL | FACULTY CONFIRMATION REQUIRED | Excel dashboard reproducibly uses unit sums; total-sheet ratio differs and status direction is governed by a placeholder. | Select basis, target curve and favorable direction. |
| REV-VAR | FACULTY CONFIRMATION REQUIRED | Formula is reproducible, but it uses disputed unit-sum inputs. | Approve aggregation basis and variance sign convention. |
| EXP-VAR | FACULTY CONFIRMATION REQUIRED | Formula is reproducible as Budget − Actual, but label and input basis are ambiguous. | Approve name, direction and aggregation basis. |
| GOV-BUD | CONFIRMED FROM EXCEL | Government budget value is explicitly stored. | Confirm accounting/appropriation description. |
| GOV-ACT | CONFIRMED FROM EXCEL | Government expenditure value is explicitly stored. | Confirm official bilingual term. |
| GOV-UTIL | CONFIRMED FROM EXCEL | Dashboard_Data B16 calculates Government Actual / Government Budget. | Status threshold remains unapproved. |
| GOV-REMAIN | DERIVED BUT REPRODUCIBLE | Budget − Actual = 117,849,555, but no governed Excel KPI displays it. | Approve it as a web KPI if desired. |
| REV-GROWTH | PROPOSED FOR WEB | No Excel KPI or formula exists. | Define QoQ/YoY/YTD basis and obtain sufficient history. |
| EXP-GROWTH | PROPOSED FOR WEB | No Excel KPI or formula exists. | Same. |
| RESULT-GROWTH | PROPOSED FOR WEB | No Excel KPI or formula exists. | Define sign-aware behavior for zero/negative comparisons. |

Status formulas for liquidity, revenue achievement, expense utilization and government utilization are **FACULTY CONFIRMATION REQUIRED** because `Config!B8:B11` explicitly identifies their thresholds as placeholders.

## Validation cross-checks

| KPI | Independent calculation | Stored/dashboard value | Result |
|---|---:|---:|---|
| Liquidity | 97,630,000 / 276,820,000 | 0.3526840546 | Match |
| Operating result | 73,281,544 − 57,694,327 | 15,587,217 | Match |
| Operating margin | 15,587,217 / 73,281,544 | 21.270317% | Match |
| Expense/revenue | 57,694,327 / 73,281,544 | 78.729683% | Match |
| Government utilization | 89,248,624 / 207,098,179 | 43.094838% | Match |
| Revenue achievement | unit sums: 73,281,076 / 171,677,900 | 42.685212% | Matches dashboard helper; does not match faculty-total source (42.648917%) |
| Expense utilization | unit sums: 57,694,326 / 165,295,300 | 34.903791% | Matches dashboard helper; does not match faculty-total source (34.846829%) |
