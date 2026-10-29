# Monitoring Architecture

Monitor availability (`/api/health`), database readiness, authentication/authorization failures, 5xx errors, import and approval failures, locked-write attempts, migrations, backup jobs and restore-test age. The endpoint exposes only `status`, `readiness` and application version.

Logs should be structured with timestamp, event, request ID, actor profile ID, action/route and result. Never log passwords, tokens, service keys, workbook bytes or full financial payloads. Use an approved university platform or Sentry-compatible adapter later; no paid external dependency is added in Phase 5C. Define alert ownership/severity and retain security events according to the approved audit policy.

