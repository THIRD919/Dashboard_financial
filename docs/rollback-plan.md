# Rollback Plan

- Application-only failure: retain prior immutable artifact/config, shift traffic back, preserve database and audit evidence.
- Authentication failure: disable new traffic, restore prior auth configuration/redirects, do not bypass authorization.
- Dashboard regression: restore prior app artifact; official ledger remains unchanged.
- Pre-transactional migration failure: roll back transaction and investigate.
- Committed additive migration: prefer forward-fix. Never remove columns/tables or rewrite official financial/audit history without a separately tested recovery plan.
- Financial workflow regression: stop mutations, retain read-only access if safe, reconcile records/events/locks, restore isolated backup only with governance approval.

