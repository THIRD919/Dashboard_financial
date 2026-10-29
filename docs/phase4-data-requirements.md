# Phase 4 Data Requirements from Annual Reporting

> Phase 4A status: implemented in ordered PostgreSQL migrations and server-side services. Phase 4B may build Data Entry only against the contract in `docs/phase4b-data-entry-contract.md`.

The production design must support:

- Stable reporting-year records, explicit parent/child reporting-period relationships and configurable ordering without assumed months.
- Period labels preserved from source alongside an eventually approved calendar mapping.
- Unit and Faculty scope as separate authoritative record dimensions.
- Metric aggregation type: FLOW, SNAPSHOT or DERIVED_RATIO.
- Balance-sheet components for Financial Liquidity, not only a stored ratio.
- Budget scope enum: ANNUAL, PERIOD, UNKNOWN; validation for repeated annual budgets and conflicting values.
- Data-presence state separate from numeric value so zero cannot mean missing.
- Completeness requirements and derived FULL_YEAR / PARTIAL_YTD state.
- Source period for every snapshot selected into an annual view.
- Versioned aggregation rules and auditable calculation provenance.
- Unique constraints preventing duplicate Unit/Faculty/period/metric records.
- Reconciliation between Faculty totals and unit sums without forcing equality.
- Import staging capable of reporting missing periods, duplicate records and scope conflicts before promotion.

No production schema or database connection was created in Phase 3.2.
