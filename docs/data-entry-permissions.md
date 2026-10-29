# Data Entry Permissions

Phase 4B uses seeded development profiles, roles, permissions, and unit-access grants. These demonstrate authorization behavior; they are not production authentication.

| Context | Read/write scope |
|---|---|
| Faculty Office | Its assigned Office unit only |
| NOVEL | NOVEL unit only |
| Executive | Faculty read context; no data-entry write permission |
| Administrator | Faculty-wide write context, including unit data |

Every write checks an active profile, the `financial.create` permission, grant expiry, scope, unit, period activity, and period lock. Draft update/delete/submission repeats the record-specific authorization check. Database RLS policies provide a further PostgreSQL enforcement layer when requests establish `app.current_profile_id`.

Do not expose the development context selector in production. Replace it with an authenticated identity whose profile ID is set server-side and never accepted from browser form data.
