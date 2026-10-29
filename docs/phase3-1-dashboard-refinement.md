# Phase 3.1 — Executive Dashboard Refinement

## UI and terminology changes

- Reframed the page as “ภาพรวมสถานะทางการเงิน / Executive Financial Overview”.
- Updated Thai navigation and filter terminology to natural management language, including “ปีรายงาน”.
- Added a dominant Faculty/Unit scope header with reporting period and refresh timestamp.
- Removed prominent developer and governance language. Quarter-mapping and threshold notes are now concise information tooltips.
- Updated KPI terminology to รายรับรวม, รายจ่ายรวม, ผลการดำเนินงานสุทธิ, อัตราผลการดำเนินงานต่อรายรับ and รายรับเทียบเป้าหมาย.

## Scope behavior

Faculty View uses authoritative faculty records. Unit View uses only the selected unit's Q2/69 record. Faculty-only liquidity, trend and government-budget values are never presented as unit values. Unsupported combinations show an empty state. The complete mapping is in `docs/dashboard-scope-map.md`.

## Information-design refinements

- KPI cards emphasize values, scope-appropriate context and reproducible previous-period comparisons.
- Budget bars were replaced on the Executive page by achievement/utilization progress, exact actual/budget values and remaining amounts.
- Trend tooltips now report revenue, expense, operating result and reproducible operating margin.
- Executive highlights are deterministic: result and margin, liquidity movement, revenue achievement, and count of negative-result units.
- Government budget is a compact table with budget, used, remaining, utilization and progress.
- Reconciliation is a compact control summary with expandable details. The underlying Revenue, Expense and Operating Result comparisons remain available.
- Unit-chart label width, scrolling, exact-amount tooltip and negative-value coloring were improved.

## Responsive behavior

The scope indicator remains above all content. KPI cards wrap from six columns to three and two; chart pairs stack below wide laptop layouts; long unit labels use a horizontally scrollable chart surface; compact tables retain horizontal scrolling on narrow screens.

## Financial regression

`npm run test:financial` verifies every Faculty KPI series, Financial Liquidity, faculty budgets, government totals and categories, every financial value for all 11 units, and reconciliation differences. Phase 3.1 result: Revenue 468 baht, Expense 1 baht and Operating Result 467 baht, unchanged.

No source data, financial formula, KPI definition or Excel-derived value was changed.

## Remaining Faculty decisions

- Formal quarter/fiscal-year mapping.
- Approved Financial Liquidity and other KPI assessment thresholds.
- Confirmation of provisional English organizational-unit translations.
- Explanation and disposition of the three reconciliation differences.
