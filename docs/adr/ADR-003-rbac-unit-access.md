# ADR-003: RBAC Plus Unit Access

- Status: Accepted
- Decision: Authorization is capability-based RBAC intersected with explicit faculty/unit grants and workflow state.
- Rationale: Roles alone cannot express “DATA_ENTRY for NOVEL only.”
- Consequences: Every financial request needs capability and scope checks; RLS reinforces server checks. ADMIN is not an implicit data bypass.

