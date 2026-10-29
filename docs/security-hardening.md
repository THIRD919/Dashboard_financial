# Security Hardening

- Authentication: Supabase SSR is the production path; identity is revalidated against active application profiles on every access-context load. Demo Auth requires non-production `NODE_ENV` and `APP_ENV`.
- Authorization: every mutation Server Action requires a capability; services repeat capability, scope, state, and separation-of-duties checks. Object IDs never grant authority.
- Sessions: Supabase owns secure refresh cookies. Demo cookies are HttpOnly/SameSite=Lax and development-only. Proposed production timeout: 8-hour absolute, 30-minute privileged inactivity; provider configuration required.
- CSRF: mutations use Next.js Server Actions and same-origin cookies. Deployment must enforce approved origins at the reverse proxy; no permissive CORS is configured.
- XSS: React escaping is used; no `dangerouslySetInnerHTML`. Comments/reasons are rendered as text.
- SQL injection: database inputs are parameterized. Dynamic UI filters operate in application memory or use fixed SQL.
- Headers: CSP, frame denial, nosniff, referrer, permissions, HSTS in production. CSP retains `unsafe-inline` for styles/scripts required by the current Next.js runtime; remove after nonce-based deployment validation.
- Rate limiting: conservative in-process guards cover login and import. Production requires shared gateway/provider rate limiting because serverless instances do not share memory.
- Privacy: profiles store institutional identifier/email, display names, language, status, roles and Unit grants only. Access is limited to self/admin; retention follows employment and audit policy.
- HTTPS: mandatory outside localhost.

