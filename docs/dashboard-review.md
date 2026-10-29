# Dashboard Review

> Phase 3 update: the proposed web information hierarchy below is now represented in the local prototype. See `docs/phase3-prototype.md`. This document retains the Phase 1 workbook review as design provenance.

## Current design

The Dashboard is a single A1:N41 executive view with a dark-purple CMU-style header, cream/pale-purple section bands, gold KPI-card borders and Thai status colors. It contains:

- Header: “Financial Monitoring Dashboard” and bilingual Faculty subtitle.
- Selection/as-of line: FY, quarter, unit and refresh date.
- Control/status strip: Fiscal Year, Quarter, Unit, Liquidity status, Revenue achievement, Expense utilization. Selections are edited on Config, not through dashboard slicers.
- Six KPI cards: Financial Liquidity, Total Revenue, Total Expense, Operating Result, Operating Margin, Budget Achievement.
- Quarterly line chart: revenue, expense and operating result for Q3/68–Q2/69.
- Budget-vs-actual bar chart: revenue and expense.
- Unit table: unit revenue, expense, result and revenue/expense ratio.
- Government panel: government budget, actual, utilization, liquidity and note.
- No gauge, navigation menu, PivotTable, slicer or drill-through exists. Four charts exist workbook-wide: two on Dashboard, one on Financial_Analysis and one below the nominal used range on Unit_Performance.

## Disposition

| Element | Decision | Rationale / web treatment |
|---|---|---|
| Bilingual title, Faculty identity, as-of date | KEEP | Essential context; make Thai default and provide language toggle. |
| FY / quarter / unit filters | IMPROVE | Put real controls on the page; show unavailable metric/filter combinations; use approved fiscal calendar. |
| KPI cards | KEEP + IMPROVE | Preserve hierarchy; show THB scale, formula tooltip, comparison period, data status and authoritative aggregation basis. |
| Liquidity label/status | REDESIGN | Show formula components and call it Financial Liquidity until definition approved; distinguish ratio from current ratio. |
| Revenue/expense/result trend | KEEP | Useful executive signal; improve labeling, hover details, negative-result emphasis and optional prior comparison. |
| Budget vs actual chart | REDESIGN | Use bullet/progress or variance view with achieved %, remaining amount and elapsed-period context. |
| Unit performance table | IMPROVE | Search/sort, bilingual names, conditional flags and drill-down; replace misleading ratio header. |
| Government budget panel | KEEP + IMPROVE | Add remaining budget and Equipment/Construction detail; use approved utilization status logic. |
| Status colors | IMPROVE | Keep semantic colors but add text/icon; meet accessibility contrast and never rely on color alone. |
| Config-sheet workflow | REMOVE from user experience | Replace with governed filters/settings and role-based administration later; thresholds require approval/versioning. |
| Cell-by-cell merged layout | REMOVE | Rebuild as responsive semantic cards, charts and tables. |
| Financial_Analysis and Unit_Performance duplicate views | CONSOLIDATE | Use one consistent analysis experience with drill-through rather than separate spreadsheet-like pages. |

## Visual issues observed

- The layout is wide and dense, with the unit table competing with the government panel; responsive stacking is required.
- KPI cards show values without units in the card titles and no budget/prior-period context.
- “Budget Achievement” only represents revenue achievement, an ambiguous label.
- Unit margin can display extreme negative percentages (e.g., below −1,000%) when revenue is tiny; a loss amount plus contextual ratio is clearer.
- Source chart series are correct, but an independent non-Excel renderer shows empty charts/`#NAME?` because it cannot evaluate all workbook formulas. Web charts must be fed by validated data, not spreadsheet calculation compatibility.
- There is no navigation, data freshness health indicator, explanation of provisional/approved data, export policy or user-specific authorization cue.

## Proposed information hierarchy

1. Context bar: fiscal period, unit scope, as-of/refresh, data quality/approval state.
2. Executive KPIs: revenue, expense, operating result/margin, liquidity, revenue achievement, expense/government utilization.
3. Trend and variance: quarterly series plus budget variance/remaining amounts.
4. Exceptions: critical/watch statuses and unreconciled totals.
5. Unit performance: sortable table and drill-down.
6. Government budget category detail.

The web dashboard should show reconciliation warnings until C1/C2 in the data-quality report are resolved.
