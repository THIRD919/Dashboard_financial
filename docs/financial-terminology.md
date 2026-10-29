# Financial Terminology

Translations are proposals unless the workbook itself supplies the English label. Ambiguous or institution-specific terms are marked **FACULTY CONFIRMATION REQUIRED**. Earlier `REQUIRES CONFIRMATION` labels below have the same meaning.

| Thai term | English term | Source label | Technical/database name | Definition / formula | Notes |
|---|---|---|---|---|---|
| ปีงบประมาณ | Fiscal year | FiscalYear / Fiscal Year | `fiscal_year_code` | Workbook values 68, 69 | Full BE year, Gregorian mapping and fiscal start/end dates are absent. **REQUIRES CONFIRMATION**. |
| ไตรมาส | Quarter | Quarter | `fiscal_quarter_code` | Q1–Q4 | Month mapping absent. **REQUIRES CONFIRMATION**. |
| หน่วยงาน | Organizational unit | Unit / Sub-unit (A) | `organizational_unit_id` | Reporting entity | Preserve source aliases; official English names needed. |
| ทั้งหมด | All units / Faculty aggregate | ทั้งหมด | `ALL` selector; not a stored unit | Aggregate scope | Avoid double-counting aggregate and unit facts. |
| รายรับ | Revenue | Revenue (B), Revenue Q2 | `actual_revenue_amount` | Actual recognized/collected revenue | Recognition basis is not documented. **REQUIRES CONFIRMATION**. |
| รายจ่าย | Expense / Expenditure | Expenses (C), Expenses Q2 | `actual_expense_amount` | Actual expense/expenditure | Accrual vs cash/disbursement basis is unclear. **REQUIRES CONFIRMATION**. |
| ผลการดำเนินงาน | Operating Result | Net Profit (D), Operating Result | `operating_result_amount` | Revenue − expense | Prefer neutral term over “profit” for Faculty reporting. **REQUIRES CONFIRMATION**. |
| กำไรสุทธิ | Net Profit | Net Profit (D) | `net_profit_amount` | Source uses this label for revenue − expense | May not be accounting net profit; do not use without approval. **REQUIRES CONFIRMATION**. |
| อัตราผลการดำเนินงาน | Operating Margin | Operating Margin | `operating_margin_rate` | (Revenue − expense) / revenue | Proposed Thai label. **REQUIRES CONFIRMATION**. |
| อัตราส่วนรายจ่ายต่อรายรับ | Expense-to-Revenue Ratio | Expense-to-Revenue Ratio | `expense_revenue_rate` | Expense / revenue | — |
| ประมาณการรายรับ | Budgeted Revenue | Budgeted Revenue | `budgeted_revenue_amount` | Planned/approved revenue | “Budget” vs “estimate” status is unclear. **REQUIRES CONFIRMATION**. |
| รายรับจริง | Actual Revenue | Revenue Actual / Revenue Q2 | `actual_revenue_amount` | Actual Q2 revenue | Total and unit-sum values differ. |
| ร้อยละผลสำเร็จของรายรับ | Revenue Achievement | Revenue Achievement / Percentage(%) | `revenue_achievement_rate` | actual revenue / budgeted revenue | Proposed Thai label. **REQUIRES CONFIRMATION**. |
| ประมาณการรายจ่าย | Budgeted Expense | Budgeted Expenses | `budgeted_expense_amount` | Planned/approved expense | Faculty-total sheet is mislabeled Revenue. |
| รายจ่ายจริง | Actual Expense | Expense Actual / Expenses Q2 | `actual_expense_amount` | Actual Q2 expense | Total and unit-sum values differ. |
| ร้อยละการใช้จ่ายงบประมาณ | Expense Utilization | Expense Utilization / Percentage(%) | `expense_utilization_rate` | actual expense / budgeted expense | Whether lower/higher is favorable depends on elapsed period. **REQUIRES CONFIRMATION**. |
| ส่วนต่างรายรับ | Revenue Variance | Revenue variance | `revenue_variance_amount` | actual − budget | Workbook uses unit-sum basis in Financial_Analysis. |
| งบรายจ่ายคงเหลือ | Remaining Expense Budget | Expense variance / Within plan | `remaining_expense_budget_amount` | budget − actual | Workbook label “Expense variance” is directionally ambiguous. **REQUIRES CONFIRMATION**. |
| สินทรัพย์หมุนเวียน | Current Assets | Current Assets | `current_assets_amount` | Balance-sheet amount | — |
| สินทรัพย์ไม่หมุนเวียน | Non-current Assets | Non-Current Assets | `noncurrent_assets_amount` | Balance-sheet amount | Stored but unused in KPI calculations. |
| หนี้สิน | Liabilities | Liabilities | `liabilities_amount` | Total/unspecified liabilities | Current/non-current classification absent. **REQUIRES CONFIRMATION**. |
| สภาพคล่องทางการเงิน | Financial Liquidity | Financial Liquidity | `financial_liquidity_ratio` | current assets / liabilities | Required bilingual KPI name. Formula CONFIRMED FROM EXCEL. Do not rename to Current Ratio; liability classification is FACULTY CONFIRMATION REQUIRED. |
| อัตราส่วนรายรับต่อรายจ่าย | Revenue-to-Expense Ratio | Current_Ratio (E), proportion (unit operating sheets) | `revenue_expense_ratio` | revenue / expense | Source label “Current_Ratio” is incorrect/misleading; this is not balance-sheet liquidity. |
| งบประมาณแผ่นดิน | Government Budget | Government Budget | `government_budget_amount` | Government appropriation/budget | Exact appropriation category/basis **REQUIRES CONFIRMATION**. |
| การเบิกจ่ายงบประมาณแผ่นดิน | Government Budget Expenditure | Government Actual | `government_expenditure_amount` | Actual spend/disbursement | Proposed translation. **REQUIRES CONFIRMATION**. |
| ร้อยละการเบิกจ่ายงบประมาณแผ่นดิน | Government Budget Utilization | Government Budget Utilization | `government_budget_utilization_rate` | expenditure / government budget | — |
| งบประมาณคงเหลือ | Remaining Budget | not explicit | `remaining_budget_amount` | budget − actual | Derived, not stored; select budget type and aggregation basis. |
| ครุภัณฑ์ | Equipment | Equipments | `EQUIPMENT` category | Government budget category | Correct English singular/collective label: Equipment. |
| สิ่งก่อสร้าง | Construction | Construction | `CONSTRUCTION` category | Government budget category | — |
| ดี | Good | ดี | `GOOD` | Status from placeholder threshold | Localize display; store stable code. |
| เฝ้าระวัง | Watch / Warning | เฝ้าระวัง | `WATCH` | Status from placeholder threshold | Preferred English wording **REQUIRES CONFIRMATION**. |
| วิกฤต | Critical | วิกฤต | `CRITICAL` | Status from placeholder threshold | — |

## Phase 1.1 terminology clarifications

| Item | Clarified treatment |
|---|---|
| Fiscal year 68/69 | Preserve as source codes. Full BE years, Gregorian mapping and fiscal dates are FACULTY CONFIRMATION REQUIRED. |
| Q1/Q2/Q3/Q4 | Preserve unchanged. The workbook proves order but not Thai-fiscal, calendar-year or other month mapping; FACULTY CONFIRMATION REQUIRED. |
| สภาพคล่องทางการเงิน / Financial Liquidity | Approved working bilingual pair for migration analysis. Exact formula is Current Assets / Liabilities. Do not use Current Ratio. |
| Current_Ratio in operating source sheets | Mislabel for Revenue / Expense. Preserve only as a source alias; proposed semantic name is Revenue-to-Expense Ratio. |
| Net Profit | Source label for Revenue − Expense. Official Thai/English institutional terminology is FACULTY CONFIRMATION REQUIRED; use neutral Operating Result meanwhile. |
| Budget / ประมาณการ | Workbook does not establish whether amounts are annual approved budgets, quarterly budgets or cumulative/YTD targets. FACULTY CONFIRMATION REQUIRED. |
| Actual / จริง | Workbook does not establish accrual, cash, collected or disbursed basis. FACULTY CONFIRMATION REQUIRED. |
| Good / Watch / Critical statuses | Technical status codes may be retained, but threshold meanings are FACULTY CONFIRMATION REQUIRED because Config labels them placeholders. |
