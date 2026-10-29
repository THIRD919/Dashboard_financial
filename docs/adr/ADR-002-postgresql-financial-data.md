# ADR-002: PostgreSQL Financial Data

- Status: Accepted
- Decision: PostgreSQL is authoritative; money uses `NUMERIC(20,2)` and Excel is import/export/reconciliation only.
- Rationale: Relational constraints, transactions, RLS and decimal arithmetic fit governed financial data.
- Consequences: No floating-point authority and no spreadsheet-as-database path. Provider-specific access remains behind adapters.

