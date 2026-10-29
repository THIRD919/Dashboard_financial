begin;
create table app.audit_logs (id bigint generated always as identity primary key,occurred_at timestamptz not null default now(),actor_profile_id uuid references app.profiles(id),action app.audit_action not null,entity_type text not null,entity_id text,unit_id uuid references app.organizational_units(id),reporting_period_id uuid references app.reporting_periods(id),old_values jsonb,new_values jsonb,source_type app.source_type,request_id text,metadata jsonb not null default '{}'::jsonb);
create index audit_logs_entity_idx on app.audit_logs(entity_type,entity_id,occurred_at desc);
create or replace function app.audit_logs_append_only() returns trigger language plpgsql as $$begin raise exception 'audit logs are append-only';end$$;
create trigger audit_logs_no_update before update or delete on app.audit_logs for each row execute function app.audit_logs_append_only();
commit;
