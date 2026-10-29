# Authentication and Authorization

## Authentication

Supabase Auth supplies identity, password/session protections and signed JWTs for the prototype. `profiles.auth_user_id` maps the provider identity to an application profile and preferred language. The domain never uses email as authorization identity.

Provider-specific code is isolated behind an auth adapter so university SSO can later replace Supabase Auth. Sessions use secure, HTTP-only cookies through the supported server client; session refresh and logout occur server-side. Inactive profiles are denied even if an identity token is valid.

## Authorization model

Authorization is the intersection of:

`authenticated profile ∩ capability ∩ reporting-scope/unit grant ∩ record workflow state`

- Roles bundle capabilities but code checks capability strings such as `financial.update`, not role names.
- Users may hold multiple roles with optional expiry.
- `user_unit_access` grants faculty-wide or named-unit read/write access independently of role.
- A DATA_ENTRY user with `financial.update` and NOVEL write access can edit eligible NOVEL drafts only.
- An EXECUTIVE needs `financial.view` plus faculty-wide read access to see faculty totals/all units.
- ADMIN is not a database bypass. It receives explicit capabilities and scope grants.

## Enforcement layers

1. Route middleware verifies locale and authenticated session, not business authorization.
2. Server action/route handler validates request schema and checks capability, unit/scope and workflow.
3. Domain service enforces invariants in a transaction.
4. PostgreSQL RLS repeats row access rules.
5. Audit event records allowed sensitive actions; denied security events go to operational security logging.

Frontend visibility is usability only and never the control boundary.

## Approval separation

Recommended default: a user must not approve their own submission. `financial.approve` or `import.approve` is separate from create/update. If staffing requires self-approval, it must be an explicit, audited policy setting—not an implied ADMIN behavior.

## RLS concept

- SELECT financial records: require `financial.view` and matching faculty/unit access.
- INSERT draft: require `financial.create`, write grant for target scope/unit and `created_by=current_profile`.
- UPDATE: require `financial.update`, matching write grant, and DRAFT/REJECTED state.
- APPROVE/LOCK/IMPORT: no broad client policy; use guarded server/database functions that recheck capability and separation of duties.
- Master/admin tables: only dedicated manage capabilities; public/authenticated read only where required.
- Service-role key remains server-side and is never sent to the browser.

