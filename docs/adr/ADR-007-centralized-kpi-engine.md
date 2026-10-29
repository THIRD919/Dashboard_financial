# ADR-007: Centralized KPI Engine

- Status: Accepted
- Decision: Deterministic server-side KPI services/reviewed SQL calculate values from authoritative records; UI components only present results.
- Rationale: Scattered React formulas would diverge, weaken auditability and mix translation with finance.
- Consequences: Definitions/thresholds are versioned; arbitrary database-stored code is prohibited; golden tests cover Excel baselines.

