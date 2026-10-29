# Prototype and Database Providers

`DashboardDataProvider` isolates the dashboard from storage.

- `PrototypeDataProvider`: active Phase 4A default; returns the unchanged local Excel-derived JSON.
- `DatabaseDataProvider`: queries approved/locked Faculty, Unit, budget and Government records and maps them to the dashboard contract.

The database provider calculates derived result/liquidity at the service boundary, includes historical Unit records through `unitPeriods`, and throws `DATABASE_PROVIDER_INCOMPLETE` when a required source value is absent. It never substitutes Faculty values or turns missing data into zero. Provider selection is not enabled for production in Phase 4A.
