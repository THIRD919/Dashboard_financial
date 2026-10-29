begin;

create index if not exists financial_records_workflow_queue_idx on app.financial_records(status,reporting_scope,unit_id,created_at);
create index if not exists financial_records_period_scope_metric_idx on app.financial_records(reporting_period_id,reporting_scope,unit_id,metric_id) where is_current;
create index if not exists workflow_events_actor_time_idx on app.workflow_events(actor_profile_id,occurred_at desc);
create index if not exists audit_logs_actor_time_idx on app.audit_logs(actor_profile_id,occurred_at desc);
create index if not exists import_batches_status_time_idx on app.import_batches(status,uploaded_at desc);

create or replace function app.append_only_security_history() returns trigger language plpgsql as $$begin raise exception 'security and workflow history is append-only';end$$;
drop trigger if exists workflow_events_no_mutation on app.workflow_events;
create trigger workflow_events_no_mutation before update or delete on app.workflow_events for each row execute function app.append_only_security_history();

create table if not exists app.security_events(
 id bigint generated always as identity primary key,
 occurred_at timestamptz not null default now(),
 actor_profile_id uuid references app.profiles(id),
 event_code text not null,
 route_or_action text,
 result text not null,
 target_scope app.reporting_scope,
 target_unit_id uuid references app.organizational_units(id),
 request_id text,
 metadata jsonb not null default '{}'::jsonb
);
create index if not exists security_events_code_time_idx on app.security_events(event_code,occurred_at desc);
create trigger security_events_no_mutation before update or delete on app.security_events for each row execute function app.append_only_security_history();
alter table app.security_events enable row level security;
create policy security_events_admin_read on app.security_events for select using(app.has_permission('audit.view'));

-- Narrow Phase 5B history reads to the actor's authorized financial scope.
drop policy if exists workflow_events_read on app.workflow_events;
create policy workflow_events_read on app.workflow_events for select using(
 app.has_permission('financial.view') and exists(
  select 1 from app.financial_records r where r.id=workflow_events.record_id and app.can_access_scope(r.reporting_scope,r.unit_id,false)
 )
);
drop policy if exists corrections_read on app.correction_requests;
create policy corrections_read on app.correction_requests for select using(
 requested_by=app.current_profile_id() or assigned_to=app.current_profile_id() or exists(
  select 1 from app.financial_records r where r.id=correction_requests.original_record_id and app.has_permission('financial.review') and app.can_access_scope(r.reporting_scope,r.unit_id,false)
 )
);
drop policy if exists corrections_request on app.correction_requests;
create policy corrections_request on app.correction_requests for insert with check(
 app.has_permission('financial.request_correction') and exists(
  select 1 from app.financial_records r where r.id=original_record_id and app.can_access_scope(r.reporting_scope,r.unit_id,false)
 )
);

commit;
