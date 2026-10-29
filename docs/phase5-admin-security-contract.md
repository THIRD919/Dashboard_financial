# Phase 5 Admin and Security Contract

Phase 5 must replace demo authorization with production identity and explicit permissions.

| Capability | Recommended permission/role |
|---|---|
| Upload workbook | `import.create`; authorized finance staff within granted scope |
| Confirm import | Separate `import.approve`; Admin/import controller, not implied by upload |
| Resolve mapping | Master-data steward with audited configuration permission |
| Review reconciliation | `reconciliation.review`; Executive/controller |
| View import history | Scope-aware `import.view` plus confidential-data policy |
| Configure tolerances | Restricted policy administrator; Faculty-approved effective version |
| Approve imported records | `financial.approve`; preferably not the uploader |
| Manage profiles | `admin.manage_import_profiles`; versioned and audited |

Phase 5 must add server-enforced row/scope authorization, SSO/session controls, CSRF/rate limits, malware scanning, encrypted private storage/retention, approval segregation, audit review, profile version publication, and production-safe error handling. It must preserve the Phase 4C staging-first and no-overwrite guarantees.
