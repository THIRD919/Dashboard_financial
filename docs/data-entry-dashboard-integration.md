# Data Entry to Dashboard Integration

The entry service writes one normalized `financial_records` row per metric. The dashboard never calculates from form payloads.

Two database projections preserve state semantics:

- `app.authoritative_financial_amounts`: `APPROVED` and `LOCKED` records only.
- `app.dashboard_financial_amounts`: `SUBMITTED`, `APPROVED`, and `LOCKED` records, with `data_state` identifying `SUBMITTED_PREVIEW` versus `AUTHORITATIVE`.

`DASHBOARD_DATA_PROVIDER=prototype` remains the default. `database` enables the local development provider and includes submitted previews so newly submitted records can update compatible dashboard aggregates. It does not silently promote them to approved data.

Annual and YTD results use the existing centralized aggregation service. The Phase 4B end-to-end test submits Q1–Q4 Unit records and verifies full-year Revenue, Expense, Operating Result, and completeness through the dashboard projection.

The complete executive dashboard still expects its faculty, budget, government-budget, and unit-ranking datasets. Database mode should therefore be enabled only after the required local dataset has been populated.
