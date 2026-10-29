# Executive Dashboard Scope Map

This map prevents silent substitution between Faculty and Unit values. “Context dependent” means the component uses exactly the active selector scope; it does not combine scopes.

| Component | Scope | Faculty View | Unit View |
|---|---|---|---|
| Scope and reporting header | Context dependent | Faculty badge and Faculty Overview | Unit badge and selected unit name |
| Financial Liquidity KPI | Faculty scope | Faculty balance-sheet values | Professional unavailable state |
| Total Revenue KPI | Context dependent | Faculty authoritative revenue | Selected unit revenue for Q2/69 |
| Total Expense KPI | Context dependent | Faculty authoritative expense | Selected unit expense for Q2/69 |
| Operating Result KPI | Context dependent | Faculty authoritative result | Selected unit result for Q2/69 |
| Operating Margin KPI | Context dependent | Faculty result / faculty revenue | Unit result / unit revenue |
| Revenue Achievement KPI | Context dependent | Faculty actual / faculty budget | Unit actual / unit budget |
| Financial trend | Faculty scope | Faculty quarterly series | Unavailable; never substitutes Faculty data |
| Budget progress | Context dependent | Faculty actual and budget | Selected unit actual and budget |
| Unit performance ranking | Unit dataset scope | All 11 unit records for Q2/69 | Still an explicitly labelled Faculty unit-comparison panel |
| Executive highlights | Context dependent | Faculty statements plus unit exception count | Selected-unit statements only |
| Financial Liquidity history | Faculty scope | Faculty quarterly series | Panel hidden |
| Government budget | Faculty scope | Faculty Q2/69 government values | Unavailable |
| Reconciliation summary/detail | Faculty control scope | Faculty total vs all-unit sum | Shown as a separately labelled Faculty control panel |

Unit source data exists only for Q2/69. Selecting another period with a unit produces an empty state rather than a Faculty fallback.
