# Environment Strategy

| Environment | Data/Auth | Purpose |
|---|---|---|
| Development | local PGlite, explicit Demo Auth, TEST_ONLY data | engineering/tests |
| Staging | separate non-production PostgreSQL/Supabase, anonymized/test data and identities, distinct secrets/storage | production-like UAT |
| Production | dedicated approved database/auth/storage/secrets; no Demo Auth, test identities or synthetic facts | live Faculty use |

Set `APP_ENV`, `APP_URL`, database/auth/storage values independently. Never copy production credentials into staging. `STAGING_APP_URL` is a placeholder; hostname requires Faculty/University IT confirmation.

