# Threat Model

Assets: financial facts and budgets, liquidity, identities, approvals, locks, audit history, import provenance, correction/adjustment/reversal chains, organizational grants and configuration.

| Threat | Principal control | Residual action |
|---|---|---|
| Cross-Unit access / IDOR | capability + Unit scope in Server Actions/services/RLS | validate production claims |
| Privilege escalation | explicit role capabilities; ADMIN is not FINAL_APPROVER | quarterly access review |
| Session hijacking/CSRF | Supabase SSR cookies, HTTPS, SameSite, Server Actions | configure provider timeout/MFA |
| XSS/SQL injection | React escaping and parameterized SQL | CSP nonce improvement |
| Malicious Excel/zip abuse | xlsx-only, MIME/signature/size/sheet/row/column/cell/string limits; no macros | gateway body limit/malware scan |
| Approval/lock bypass | database state machine, immutable triggers, stale-state updates | alert on denied events |
| Adjustment abuse | correction request, exact grain, assignee and reversal offset | periodic audit sampling |
| Audit manipulation | append-only triggers and admin read-only policy | provider audit export/WORM storage |
| Credential/service-role exposure | server-only variable naming and repository scan | secret manager/rotation |
| Database loss/backup failure | encrypted daily backup proposal and tested restore procedure | activate provider backups |

