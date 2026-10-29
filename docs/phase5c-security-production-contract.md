# Phase 5C Security and Production Contract

Phase 5B does not authorize production deployment. Before production, Phase 5C must replace Demo Auth with CMU-approved identity/SSO, use a managed PostgreSQL environment, validate RLS with production claims, manage secrets and encryption, add CSRF/session/rate-limit controls, establish backup/restore and retention, centralize tamper-evident audit monitoring, configure notification delivery, perform dependency and penetration testing, define incident response, and complete production accessibility/performance/UAT sign-off.

No TEST_ONLY identity, local password, PGlite file, or compatibility source channel may be enabled in production.

