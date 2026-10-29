# ADR-009: Financial Auditability

- Status: Accepted
- Decision: Financial changes are versioned/append-only after approval, ordinary deletion is soft, and material actions create immutable audit events.
- Rationale: Financial traceability is more important than in-place convenience.
- Consequences: Corrections use adjustments/reversals; approvals, locks, imports, permissions and threshold changes retain actor/time/before-after/source context.

