# Secrets Management

Commit only `.env.example` placeholders. `.env` and `.env.local` are ignored. `SUPABASE_SERVICE_ROLE_KEY`, database credentials, SSO client secret and signing keys are server secret-manager values; none may use `NEXT_PUBLIC_` or appear in logs/errors/browser payloads.

Use separate secrets per development, staging and production. Rotate after staff departure, suspected disclosure and at least annually (frequency requires IT confirmation). Production startup refuses public-prefixed sensitive variables, Demo Auth/password/session secret, and prototype data.

Repository scanning found no embedded real secret. The online npm advisory request was not executed because registry transmission was not authorized; run it in the approved CI environment before go-live.

