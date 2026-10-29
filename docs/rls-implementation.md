# RLS Implementation

Migrations 011 and 018 enable RLS for financial records, reconciliations, audit, identity/access tables, Units, and import staging. Policies call `app.has_permission` and `app.can_access_scope`; active status is required. Draft create/update/delete use dedicated capabilities and Unit/scope checks. Import staging is limited to import reviewers; administration tables require management capabilities.

Service-role credentials stay in protected server code. Server checks remain mandatory when an elevated connection bypasses RLS. `npm run test:auth` validates functions and a crafted Office→NOVEL write denial. Hosted Supabase must repeat JWT-backed policy tests before deployment.
