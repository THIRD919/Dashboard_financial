# RLS Security Review

Application clients must set `app.current_profile_id` from a verified server identity. Service-role access bypasses RLS and therefore repeats authorization in trusted services.

| Table group | SELECT | INSERT | UPDATE | DELETE / scope |
|---|---|---|---|---|
| financial_records | `financial.view` + Unit/Faculty scope | create/submit + write scope | draft capability + write scope | draft only |
| profiles | self or `users.view` | admin manage | admin manage | admin manage |
| roles/permissions/mappings | authenticated read | role admin | role admin | role admin |
| user_unit_access | self/admin | users admin | users admin | users admin |
| units | financial/unit readers | units admin | units admin | units admin |
| import batches/staging/issues | import reviewer | trusted import workflow | trusted import workflow | none in UI |
| period_scope_locks | financial readers | period.lock + scope | none | none |
| correction_requests | requester, assignee, or scoped reviewer | final approver + scope | trusted workflow | none |
| workflow_events | financial permission + record scope | trusted workflow | trigger denied | trigger denied |
| notifications | recipient only | trusted workflow | no ordinary policy | no ordinary policy |
| audit_logs/security_events | audit permission | trusted server | trigger denied | trigger denied |

No blanket `authenticated=true` financial policy is used. Production acceptance must test these policies using real Supabase user claims, not the owner/service role.

