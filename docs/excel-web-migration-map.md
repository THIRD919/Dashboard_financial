# Excel-to-Web Migration Map

This is a design mapping only. No database or application was created.

## Proposed entities

| Excel source | Web entity | Proposed table | Proposed fields | Transformation required | Validation required |
|---|---|---|---|---|---|
| Unit names across three `_ย่อย/แย` sheets | Organizational Unit | `organizational_units` | `unit_code`, `name_th`, `name_en`, `active_from`, `active_to` | Load exact source value as alias; assign stable code; add approved bilingual name | Unique code; approved aliases; no silent merges |
| Source unit spelling | Unit Alias | `organizational_unit_aliases` | `unit_id`, `source_system`, `source_name`, `normalized_name` | Trim/canonicalize spacing only in normalized field | Alias must map to one approved unit |
| FY 68/69, Q1–Q4 | Reporting Period | `reporting_periods` | `fiscal_year_be`, `fiscal_year_short`, `fiscal_year_ce`, `quarter`, `start_date`, `end_date`, `sort_key` | Expand year and create dates only after policy confirmation | Non-overlap; quarter/month mapping; unique period |
| Config refresh date | Data Load | `data_loads` | `source_file`, `file_hash`, `as_of_date`, `loaded_at`, `status` | Preserve file hash and lineage | Hash uniqueness/version policy; date not future/invalid |
| รายรับรายจ่ายกำไร | Operating financial fact | `financial_facts` | `period_id`, `unit_id`, `metric_code`, `actual_amount`, `source_ref`, `load_id` | Unpivot revenue/expense/result; normally recompute result | Revenue − expense tie-out; THB; aggregate scope |
| รายรับรายจ่ายกำไร_ย่อย | Unit operating fact | `financial_facts` | same | Unpivot 11 rows × metrics | Unit coverage; aggregate-vs-unit reconciliation |
| Revenue budget sheets | Budget fact | `financial_facts` or `budget_facts` | `period_id`, `unit_id`, `metric_code`, `budget_amount`, `actual_amount` | Correct source labels; distinguish faculty total from unit sum | Zero-budget handling; total reconciliation |
| Expense budget sheets | Budget fact | same | same | Correct erroneous Revenue headers | Same plus sign/definition checks |
| งบดุล | Balance snapshot | `balance_sheet_snapshots` | `period_id`, `unit_id`, `current_assets`, `noncurrent_assets`, `liabilities` | Parse numeric amount; drop formatted ratio text as source display only | Assets/liabilities nonnegative; denominator policy |
| งบประมาณแผ่นดิน | Government budget fact | `government_budget_facts` | `period_id`, `category_code`, `budget_amount`, `actual_amount` | Add `TOTAL` category row or derive it, not both in sums | Detail must reconcile to total |
| งบแผ่นดินแยกหมวด | Government budget category | `government_budget_facts` / `budget_categories` | category code/name TH/EN | Translate Equipment/Construction | Category totals reconcile exactly |
| Config B8:B11 | KPI policy/version | `kpi_threshold_versions` | `kpi_code`, `effective_from`, `warning_threshold`, `good_threshold`, `approved_by`, `status` | Do not migrate placeholders as approved policy | Approval required; effective dates; audit trail |
| Dashboard_Data formulas | KPI definition | `kpi_definitions` | `kpi_code`, bilingual name, formula expression/version, units, grain | Implement server-side governed formulas | Unit tests against Excel cross-check set |
| Dashboard selections | Filter state | UI/query parameters | `fiscal_year`, `quarter`, `unit_code` | Use stable IDs/codes | Valid allowed values; permission-aware choices |
| README/Data_Audit | Data catalog | `data_dictionary` / documentation | lineage, owner, refresh rule, classification | Replace stale static ranges with generated metadata | Owner/approval/date required |

## Recommended fact grain

One fact should represent one `reporting_period × organizational_unit × metric × scenario/fund/category × data_load`. Faculty aggregates should either be derived from units or stored with an explicit `aggregation_scope='FACULTY_REPORTED_TOTAL'`; never mix aggregate and unit facts in the same SUM without scope filtering.

Suggested metric codes: `REVENUE_ACTUAL`, `EXPENSE_ACTUAL`, `OPERATING_RESULT`, `REVENUE_BUDGET`, `EXPENSE_BUDGET`, `CURRENT_ASSETS`, `NONCURRENT_ASSETS`, `LIABILITIES`, `GOV_BUDGET`, `GOV_EXPENDITURE`.

## Transformation and control priorities

1. Obtain approved fiscal calendar, unit master and accounting definitions.
2. Choose authoritative faculty totals vs unit aggregation and record reconciling adjustments.
3. Load raw values unchanged into a staging layer with workbook/sheet/cell lineage.
4. Normalize into typed facts; do not migrate formatted strings such as `0.35 : 1` as numeric truth.
5. Compute KPIs from versioned definitions and thresholds.
6. Run reconciliation controls before publishing: source total, unit sum, detail-to-total, result formula, ratios and duplicate grain.
7. Publish bilingual semantic labels separately from stable technical codes.

## Validation acceptance examples

- Q2/69 liquidity must reproduce 0.3526840546 from current assets and liabilities.
- Q2/69 operating result must equal 15,587,217 from faculty totals.
- Government categories must total 207,098,179 budget and 89,248,624 actual.
- A load must fail or quarantine when faculty totals and unit sums differ without an approved reconciliation record.
- Division by zero returns `null/not applicable` plus a reason, not an indistinguishable 0%, unless Faculty policy explicitly defines zero.

