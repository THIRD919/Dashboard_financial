# Excel Import Validation

The importer reuses `normalizeMoney`, configured reporting periods, active master records, ledger natural grain, record status rules, budget-scope rules, reconciliation and audit services.

| Severity | Examples | Confirmation |
|---|---|---|
| ERROR | Unknown Unit/period/metric/category, invalid money, locked period, scope conflict, existing different amount | Blocked |
| WARNING | UNKNOWN budget scope, exact duplicate, repeated file hash, provisional mapping | Allowed after review |
| INFO | Blank cell preserved as No Data | Allowed |

Files must be non-empty `.xlsx` files no larger than 10 MiB and parse as OOXML. Macros are neither executed nor imported. Formula cached results may be read as source values; formulas are never executed by the application.

Blank and zero are distinct: blank becomes no staged amount and is not committed; `0` becomes `0.00`. Money is limited by the existing `NUMERIC(20,2)` normalization rule.
