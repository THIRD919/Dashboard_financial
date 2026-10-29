begin;
alter table app.financial_records add column if not exists reviewed_by uuid references app.profiles(id);
alter table app.financial_records add column if not exists reviewed_at timestamptz;
alter table app.financial_records add column if not exists review_decision text;
alter table app.financial_records add column if not exists review_comment text;
alter table app.financial_records add column if not exists final_approved_by uuid references app.profiles(id);
alter table app.financial_records add column if not exists final_approved_at timestamptz;
alter table app.financial_records add column if not exists final_approval_comment text;
alter table app.financial_records add column if not exists import_batch_id uuid references app.import_batches(id);

create table app.period_scope_locks(
 id uuid primary key default gen_random_uuid(),reporting_period_id uuid not null references app.reporting_periods(id),reporting_scope app.reporting_scope not null,unit_id uuid references app.organizational_units(id),status text not null default 'LOCKED' check(status='LOCKED'),locked_by uuid not null references app.profiles(id),locked_at timestamptz not null default now(),comment text,
 check((reporting_scope='FACULTY' and unit_id is null) or (reporting_scope='UNIT' and unit_id is not null)),unique(reporting_period_id,reporting_scope,unit_id)
);
create unique index period_scope_locks_grain on app.period_scope_locks(reporting_period_id,reporting_scope,coalesce(unit_id,'00000000-0000-0000-0000-000000000000'::uuid));

create table app.correction_requests(
 id uuid primary key default gen_random_uuid(),original_record_id uuid not null references app.financial_records(id),requested_by uuid not null references app.profiles(id),assigned_to uuid not null references app.profiles(id),correction_type text not null check(correction_type in('ADJUSTMENT','REVERSAL','TO_BE_DETERMINED')),reason text not null check(length(trim(reason))>0),status text not null default 'OPEN' check(status in('OPEN','IN_PROGRESS','COMPLETED','CANCELLED')),created_at timestamptz not null default now(),completed_at timestamptz
);
alter table app.financial_records add column if not exists correction_request_id uuid references app.correction_requests(id);
alter table app.financial_records add column if not exists reverses_record_id uuid references app.financial_records(id);

create table app.workflow_events(
 id bigint generated always as identity primary key,entry_batch_id uuid,record_id uuid references app.financial_records(id),actor_profile_id uuid not null references app.profiles(id),event_code text not null,from_status text,to_status text,comment text,metadata jsonb not null default '{}'::jsonb,occurred_at timestamptz not null default now()
);
create index workflow_events_batch_idx on app.workflow_events(entry_batch_id,occurred_at);
create table app.notifications(
 id uuid primary key default gen_random_uuid(),recipient_profile_id uuid not null references app.profiles(id),event_code text not null,title_th text not null,title_en text not null,message_th text,message_en text,entity_type text not null,entity_id text,read_at timestamptz,created_at timestamptz not null default now()
);
create index notifications_recipient_idx on app.notifications(recipient_profile_id,read_at,created_at desc);

drop trigger if exists protect_submitted_financial_record_update on app.financial_records;
drop trigger if exists protect_submitted_financial_record_delete on app.financial_records;
drop trigger if exists protect_financial_history_update on app.financial_records;
drop trigger if exists protect_financial_history_delete on app.financial_records;
drop trigger if exists validate_financial_adjustment on app.financial_records;

create or replace function app.is_scope_locked(target_period uuid,target_scope app.reporting_scope,target_unit uuid) returns boolean language sql stable security definer set search_path=app,public as $$select exists(select 1 from app.period_scope_locks l where l.reporting_period_id=target_period and l.reporting_scope=target_scope and l.unit_id is not distinct from target_unit and l.status='LOCKED')$$;
create or replace function app.validate_financial_governance_insert() returns trigger language plpgsql as $$
declare original app.financial_records%rowtype; request app.correction_requests%rowtype;
begin
 if app.is_scope_locked(new.reporting_period_id,new.reporting_scope,new.unit_id) and new.entry_type='BASE' then raise exception 'scope period is locked'; end if;
 if new.entry_type in('ADJUSTMENT','REVERSAL') then
  select * into original from app.financial_records where id=new.adjusts_record_id;
  select * into request from app.correction_requests where id=new.correction_request_id and status in('OPEN','IN_PROGRESS');
  if original.id is null or original.status not in('FINAL_APPROVED','LOCKED','APPROVED') then raise exception 'correction must reference final-approved history'; end if;
  if request.id is null or request.original_record_id<>original.id then raise exception 'valid correction request required'; end if;
  if new.created_by<>request.assigned_to then raise exception 'correction request assignee required'; end if;
  if original.reporting_scope<>new.reporting_scope or original.reporting_period_id<>new.reporting_period_id or original.unit_id is distinct from new.unit_id or original.metric_id<>new.metric_id or original.category_id is distinct from new.category_id then raise exception 'correction grain mismatch'; end if;
  if new.entry_type='REVERSAL' and (new.reverses_record_id is distinct from original.id or new.amount<>-original.amount) then raise exception 'reversal must exactly offset original'; end if;
 end if;return new;
end$$;
create trigger validate_financial_governance_insert before insert on app.financial_records for each row execute function app.validate_financial_governance_insert();

create or replace function app.protect_financial_governance_update() returns trigger language plpgsql as $$
begin
 if old.status in('APPROVED','FINAL_APPROVED','LOCKED','REVERSED','SUPERSEDED') then raise exception 'official financial history is immutable'; end if;
 if old.status not in('DRAFT','ADJUSTMENT_DRAFT','RETURNED_FOR_CORRECTION') and (new.amount<>old.amount or new.reporting_scope<>old.reporting_scope or new.reporting_period_id<>old.reporting_period_id or new.unit_id is distinct from old.unit_id or new.metric_id<>old.metric_id or new.category_id is distinct from old.category_id or new.entry_type<>old.entry_type) then raise exception 'submitted financial facts are immutable'; end if;
 return new;
end$$;
create trigger protect_financial_governance_update before update on app.financial_records for each row execute function app.protect_financial_governance_update();
create or replace function app.protect_financial_governance_delete() returns trigger language plpgsql as $$begin if old.status not in('DRAFT','ADJUSTMENT_DRAFT') then raise exception 'only drafts may be deleted';end if;return old;end$$;
create trigger protect_financial_governance_delete before delete on app.financial_records for each row execute function app.protect_financial_governance_delete();

create or replace function app.validate_workflow_transition() returns trigger language plpgsql as $$begin
 if new.status=old.status then return new;end if;
 if not ((old.status='DRAFT' and new.status='SUBMITTED') or (old.status='SUBMITTED' and new.status in('UNDER_REVIEW','RETURNED_FOR_CORRECTION')) or (old.status='UNDER_REVIEW' and new.status in('REVIEW_APPROVED','RETURNED_FOR_CORRECTION')) or (old.status='REVIEW_APPROVED' and new.status in('FINAL_APPROVED','RETURNED_FOR_CORRECTION')) or (old.status='FINAL_APPROVED' and new.status='LOCKED') or (old.status='LOCKED' and new.status='CORRECTION_REQUESTED') or (old.status='CORRECTION_REQUESTED' and new.status='LOCKED') or (old.status='RETURNED_FOR_CORRECTION' and new.status='SUBMITTED') or (old.status='ADJUSTMENT_DRAFT' and new.status='ADJUSTMENT_SUBMITTED') or (old.status='ADJUSTMENT_SUBMITTED' and new.status in('UNDER_REVIEW','RETURNED_FOR_CORRECTION')) or (old.status='LOCKED' and new.status='SUPERSEDED')) then raise exception 'invalid workflow transition: % to %',old.status,new.status;end if;
 return new;end$$;
create trigger validate_financial_workflow_transition before update of status on app.financial_records for each row execute function app.validate_workflow_transition();

drop view if exists app.flow_annual_amounts;
drop view if exists app.latest_snapshot_amounts;
drop view if exists app.dashboard_financial_amounts;
drop view if exists app.authoritative_financial_amounts;
create view app.authoritative_financial_amounts as select r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency,sum(r.amount)::numeric(20,2) amount from app.financial_records r where r.is_current and r.status in('APPROVED','LOCKED') group by r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency;
create view app.dashboard_financial_amounts as select r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency,sum(r.amount)::numeric(20,2) amount,case when bool_and(r.status in('APPROVED','LOCKED')) then 'OFFICIAL' else 'PENDING_PREVIEW' end data_state from app.financial_records r where r.is_current and r.status in('SUBMITTED','UNDER_REVIEW','REVIEW_APPROVED','FINAL_APPROVED','APPROVED','LOCKED','ADJUSTMENT_SUBMITTED') group by r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency;
create view app.flow_annual_amounts as select rp.reporting_year_id,a.reporting_scope,a.unit_id,a.metric_id,a.category_id,a.currency,sum(a.amount)::numeric(20,2) amount,count(distinct rp.id)::integer available_period_count from app.authoritative_financial_amounts a join app.reporting_periods rp on rp.id=a.reporting_period_id join app.financial_metrics m on m.id=a.metric_id where m.behavior='FLOW' group by rp.reporting_year_id,a.reporting_scope,a.unit_id,a.metric_id,a.category_id,a.currency;
create view app.latest_snapshot_amounts as select distinct on(rp.reporting_year_id,a.reporting_scope,coalesce(a.unit_id,'00000000-0000-0000-0000-000000000000'::uuid),a.metric_id,coalesce(a.category_id,'00000000-0000-0000-0000-000000000000'::uuid)) rp.reporting_year_id,a.reporting_scope,a.unit_id,a.metric_id,a.category_id,a.amount,a.currency,a.reporting_period_id,rp.period_code source_period_code from app.authoritative_financial_amounts a join app.reporting_periods rp on rp.id=a.reporting_period_id join app.financial_metrics m on m.id=a.metric_id where m.behavior='SNAPSHOT' order by rp.reporting_year_id,a.reporting_scope,coalesce(a.unit_id,'00000000-0000-0000-0000-000000000000'::uuid),a.metric_id,coalesce(a.category_id,'00000000-0000-0000-0000-000000000000'::uuid),rp.display_order desc;
commit;
