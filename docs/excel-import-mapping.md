# Excel Import Mapping

## Profiles

- `VET_CMU_FINANCIAL_WORKBOOK_V1`: fixed cells and sheets documented during Phase 1–3.
- `GENERIC_PERIODIC_FINANCIAL_TEMPLATE_V1`: long-format `Financial Data` sheet.

Mappings use stable codes. Thai source Unit names from the original workbook map only by exact normalized whitespace or existing stable Unit code. Fuzzy matching and automatic master creation are prohibited.

Period labels such as `Q2/69` map to the configured `Q2-69` record. No month, Gregorian date or fiscal-quarter convention is inferred. Derived metrics (`OPERATING_RESULT`, `OPERATING_MARGIN`, `FINANCIAL_LIQUIDITY`) are not imported as independent authoritative facts; the centralized KPI engine derives them from components.

Budget scope is `ANNUAL`, `PERIOD`, or `UNKNOWN`. The original workbook remains `UNKNOWN` where its scope is not conclusive.
