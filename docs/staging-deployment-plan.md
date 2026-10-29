# Staging Deployment Checklist

1. Approve hosting and placeholder hostname.
2. Create isolated staging database, auth tenant, private storage and secret set.
3. Set `APP_ENV=staging`; keep `ENABLE_DEMO_AUTH=false` unless an explicitly isolated staging UAT exception is approved.
4. Apply migrations in filename order and run production structural bootstrap only.
5. Provision separate UAT identities/grants; load anonymized/synthetic data only.
6. Deploy over HTTPS and verify headers, `/api/health`, no `/api/dev/dashboard-context`, safe errors and no browser secrets.
7. Run security, authorization, financial and bilingual/responsive UAT.
8. Configure monitoring, backup and retention; perform and record a real staging restore test.
9. Obtain stakeholder and IT acceptance before Phase 6 production work.

