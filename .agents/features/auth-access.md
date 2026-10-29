# Feature: Authentication and Access

Login/logout pages and actions are under `app/[locale]/login`, with access helpers in `lib/auth`. Authorization combines capabilities/permissions with faculty or unit scope; database RLS reinforces the same boundary.

Demo auth is explicitly TEST_ONLY and disabled in production conditions. The source contains readiness for a provider boundary, but the concrete external SSO integration and production identity configuration are not found.

Tests: `tests/auth-access.test.mjs`, `tests/data-entry-access.test.mjs`, `tests/security-hardening.test.mjs`.

