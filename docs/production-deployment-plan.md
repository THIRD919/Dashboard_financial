# Phase 6 Production Deployment Plan — Not Executed

After explicit approval only: confirm go-live decisions; provision approved infrastructure; configure SSO/auth, secrets, HTTPS/DNS and private storage; validate pre-deployment backup; apply verified migrations and structural bootstrap; securely create first Admin and approved Reviewer/Final Approver assignments; activate monitoring/backups; run health/security/financial smoke tests; obtain UAT/go-live decision; monitor; invoke rollback/forward-fix if required.

Hosting candidates:

| Option | Strength | Trade-off |
|---|---|---|
| University-managed | governance/SSO/network control | greater internal operations burden |
| Managed Next.js + Supabase | rapid operations, managed auth/backups | vendor/data-governance and recurring cost review |
| Containerized university/private cloud | portability/control | platform engineering and patching burden |

Final selection is **BLOCKS GO-LIVE — Faculty/University IT approval required**.

