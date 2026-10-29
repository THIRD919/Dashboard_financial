# ADR-001: Modular Monolith

- Status: Accepted for prototype architecture
- Decision: Build one Next.js application with explicit domain modules and one PostgreSQL database.
- Rationale: Current scale and team do not justify distributed services; transactions across import, ledger, reconciliation and audit are safer in one boundary.
- Consequences: Enforce module interfaces and dependency direction. Extract services only after measured scaling or organizational need.

