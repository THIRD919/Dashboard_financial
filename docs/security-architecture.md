# Security Architecture

## Controls

| Area | Design |
|---|---|
| Authentication | Supabase Auth for prototype; provider adapter; secure cookie sessions; inactive-profile check; MFA recommended for approvers/admins. |
| Authorization | Capability-based RBAC plus explicit faculty/unit grants, workflow state and separation of duties. |
| Database | RLS on financial/import/reconciliation/audit data; least-privilege roles; guarded approve/import functions; encrypted transport/backups. |
| Server | Zod-equivalent schema validation, transaction boundaries, capability/unit checks, request IDs and safe error responses. |
| Secrets | Environment/secret manager only; service-role key server-only; rotation and environment separation. |
| Uploads | Private bucket, extension/MIME/signature checks, size/row limits, malware and zip-bomb scanning, no macro execution, neutralized formulas/external links, retention policy. |
| Sessions | Short-lived access token, secure refresh handling, revocation on deactivation/privilege change, CSRF protection for cookie mutations. |
| Abuse | Rate limits for login, upload, import validation, export and admin mutations; per-user quotas and concurrency controls. |
| Audit | Immutable financial/security events with actor, request, IP/user agent where lawful, before/after values and import lineage. |
| Privacy | Confidential by default; minimize exports/log payloads; do not log uploaded file contents or secrets. |

## RLS principles by role

- VIEWER: SELECT only where `financial.view` and unit grant intersect.
- EXECUTIVE: faculty-wide read only with explicit FACULTY grant; approval only if capability separately assigned.
- DATA_ENTRY: read/create/update eligible DRAFT/REJECTED rows for granted writable units; no peer units/faculty totals by default.
- ADMIN: master/access management through explicit capabilities; no implicit bypass of financial row scope.

Supabase service role bypasses RLS and must never be exposed to the browser. Trusted server operations using it must repeat authorization and set actor metadata; prefer user-scoped clients/guarded database functions when practical.

## Audit and deletion

Financial records use soft deletion only before/at controlled stages and append-only corrections after approval. Audit logs should be append-only for application roles, retained under Faculty/university policy, access-controlled, and protected from self-modification by audited users.

## Threat-oriented checks

- IDOR: never trust unit/profile IDs from the client; authorize target rows.
- Privilege escalation: permission and unit-grant changes require `roles.manage/users.manage`, audit and session refresh/revocation.
- Spreadsheet injection: treat cell formulas/text as untrusted; never render raw HTML or export executable formula text without escaping.
- Race/double approval: use row locks/expected status in transactional transitions.
- Duplicate import: hashes, idempotency and natural-grain constraints.
- Data exfiltration: permission-aware exports, limits, watermark/audit where required.

