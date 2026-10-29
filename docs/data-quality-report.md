# Data Quality Report

## Audit result

The workbook is structurally intact: all 17 sheets are visible; there are no broken external links, stored `#REF!`, `#DIV/0!`, `#VALUE!`, `#NAME?`, `#N/A` or `#NUM!` cell values, and the four chart sources resolve to workbook ranges. Important financial formulas independently reproduce their stored outputs.

However, the model has significant semantic and portability risks. Severity reflects impact on a database/web migration, not whether Excel can currently open the file.

## Critical

| ID | Finding | Evidence / impact | Required action |
|---|---|---|---|
| C1 | Faculty totals do not reconcile to unit sums | Revenue: actual total 73,281,544 vs units 73,281,076 (Δ468); budget total 171,825,100 vs units 171,677,900 (Δ147,200). Expense: actual total 57,694,327 vs units 57,694,326 (Δ1); budget total 165,565,500 vs units 165,295,300 (Δ270,200). | Identify omitted/adjustment lines or source error; approve authoritative total and reconciliation method. |
| C2 | Dashboard mixes aggregation bases | Headline revenue/expense use faculty totals, while revenue achievement and expense utilization use unit sums. Displayed ratios therefore do not use the displayed headline actuals/budgets. | Use an explicit aggregation scope and one governed basis per KPI; show reconciliation adjustment if needed. |
| C3 | Fiscal period semantics are not defined | Only 68/69 and Q1–Q4 are stored; no full BE/CE year, month mapping or dates. Wrong time mapping would corrupt migration. | Faculty must approve fiscal calendar before schema/data transformation. |

## Important

| ID | Finding | Evidence / impact | Required action |
|---|---|---|---|
| I1 | “Financial Liquidity” denominator is unspecified liabilities | Formula is current assets / liabilities, not demonstrated current liabilities. Calling it Current Ratio would be materially misleading. | Confirm liability scope and official KPI definition/name. |
| I2 | Misleading `Current_Ratio` label in operating sheets | It is revenue / expense, unrelated to balance-sheet current ratio. | Rename to revenue-to-expense ratio; preserve old label as lineage. |
| I3 | Faculty expense sheet has revenue headers | `Budgeted Revenue`, `Revenue Q2` contain expense values. | Correct in source process/schema mapping after approval. |
| I4 | Formula portability issue | Structured references and several Thai-sheet references display `#NAME?` in the independent renderer, while OOXML cached values are valid. Excel compatibility may be fine, but non-Excel/web engines cannot be assumed equivalent. | Replace spreadsheet formulas with tested application/business logic; retain cross-check fixtures. |
| I5 | Zero denominators are converted to 0 | Zero-budget/zero-revenue units use hard-coded zero or IFERROR(...,0), conflating “not applicable/undefined” with true 0%. | Store null plus reason; define display policy. |
| I6 | Placeholder thresholds drive executive status | Config explicitly says liquidity 40%/50%, revenue 90%, expense 85% are placeholders; yet Dashboard shows ดี/เฝ้าระวัง/วิกฤต. | Do not treat statuses as approved policy; version and approve thresholds. |
| I7 | Expense/government utilization status ignores elapsed time | Lower utilization is always “ดี” at ≤85%, regardless of reporting point. Under-spending can be adverse late in the year. | Define target curves, tolerance bands and favorable direction by period. |
| I8 | `Data_Audit` is stale | It says Dashboard was B2:D4 and blank; actual Dashboard is A1:N41 with 108 formulas and two charts. | Generate metadata automatically or update through controlled documentation process. |
| I9 | Unit filter is incomplete | Config B6 has no validation; KPI SUMIFS includes unit, but budget/liquidity/government facts exist only for `ทั้งหมด` or limited grains. Selecting a unit can produce partial/zero KPIs. | Define metric availability by grain and disable/label unsupported combinations. |
| I10 | Growth KPIs cannot support YoY | Only Q3/68–Q2/69 exists. | Obtain prior-year comparable history or define QoQ explicitly. |
| I11 | Fixed formula ranges | SUMIFS uses rows 3:1000; manual extension process can omit later data. | Use database queries or dynamic governed tables. |
| I12 | No audit owner/approval/version fields | Workbook has refresh date but no data owner, preparer, approver, accounting basis or source-system ID. | Add load, ownership and approval metadata. |

## Minor

| ID | Finding | Evidence / impact | Recommendation |
|---|---|---|---|
| M1 | Name formatting inconsistencies | Extra/missing spaces, leading parentheses, mixed Thai/English. | Use alias table and approved display names. |
| M2 | `Equipments` is nonstandard English | Government category label. | Use `Equipment`; retain source label. |
| M3 | Newest-first source order differs from chart order | Sources Q2→Q3; helpers Q3→Q2. | Use explicit numeric period sort key. |
| M4 | Month fields are misleading | Month blank; MonthNo = 0 across all Data_Clean facts. | Use nullable month fields; omit if grain is quarterly. |
| M5 | No freeze panes on long helper tables | Data_Clean has 97 rows. | Add sticky headers in web UI; no source change needed. |
| M6 | Merged cells and wide dashboard layout | 20 dashboard merges; difficult responsive migration. | Rebuild as semantic responsive components, not cell replication. |
| M7 | Exact unit names are repeated manually across sheets | They currently align, but future drift is likely. | Central unit master and foreign keys. |

## Missing values, duplicates and data types

- Missing values are structural in Data_Clean: all Month fields blank; Budget/Actual helper columns are zero while Amount carries the fact. This is a design choice but creates confusing redundant fields.
- No duplicate business-grain record was found within the current Data_Clean metric structure; aggregate and unit facts are both present and must not be treated as duplicates or summed together.
- Two units have zero operating activity; one also has zero budgets, while สำนักงานโรงพยาบาลสัตว์(ศรีบัวบาน) has non-zero budgets and zero actuals. These are valid candidates for confirmation, not automatic missing-data corrections.
- Source financial values are numeric, not numbers stored as text. Display ratios such as `0.35 : 1` are text duplicates of numeric proportions.
- Source formula cells often use shared-formula encoding; the first cell holds the formula pattern and subsequent cells store cached numeric results. This is normal OOXML behavior.

## Formula/error conclusion

There is no stored error token in the actual OOXML. The rendered `#NAME?` output is reproducible in the independent analysis engine and indicates cross-engine incompatibility, especially for structured references and Thai sheet names. It should be classified as a migration/portability problem, not proof that the last-saved Excel workbook displayed errors in Microsoft Excel. Validation of the original workbook in desktop Excel is recommended before Phase 2 sign-off.

