# Financial Aggregation Implementation

- FLOW/SUM: Revenue and Expense aggregate across valid authoritative child periods.
- DERIVED: Operating Result = Revenue − Expense; Operating Margin = Result / Revenue.
- SNAPSHOT/LATEST: Current Assets and Liabilities select the latest valid period; Financial Liquidity derives from that same snapshot context.
- Ratios return unavailable for zero denominators.
- Growth handlers require a comparable authoritative value and remain PROPOSED_FOR_WEB.
- UNIT requests require a Unit code and never fall back to FACULTY.

Database views provide annual flows and latest snapshots. TypeScript services provide exact-cent calculations and typed KPI states. UNKNOWN budgets return `UNSAFE/BUDGET_SCOPE_UNKNOWN`; they are never aggregated.
