begin;
create table app.financial_records (
 id uuid primary key default gen_random_uuid(),record_group_id uuid not null default gen_random_uuid(),version_no integer not null default 1 check(version_no>0),is_current boolean not null default true,
 reporting_scope app.reporting_scope not null,reporting_period_id uuid not null references app.reporting_periods(id),unit_id uuid references app.organizational_units(id),metric_id uuid not null references app.financial_metrics(id),category_id uuid references app.financial_categories(id),
 entry_type app.entry_type not null default 'BASE',amount numeric(20,2) not null,currency char(3) not null default 'THB',budget_scope app.budget_scope,
 source_type app.source_type not null,source_reference text,source_record_key text,notes text,status app.record_status not null default 'DRAFT',
 adjusts_record_id uuid references app.financial_records(id),adjustment_reference text,adjustment_reason text,
 created_by uuid references app.profiles(id),created_at timestamptz not null default now(),updated_by uuid references app.profiles(id),updated_at timestamptz not null default now(),submitted_by uuid references app.profiles(id),submitted_at timestamptz,approved_by uuid references app.profiles(id),approved_at timestamptz,
 check((reporting_scope='FACULTY' and unit_id is null) or (reporting_scope='UNIT' and unit_id is not null)),
 check((entry_type='BASE' and adjusts_record_id is null) or (entry_type in('ADJUSTMENT','REVERSAL') and adjusts_record_id is not null and adjustment_reference is not null and adjustment_reason is not null)),
 check(entry_type<>'REVERSAL' or amount<=0),unique(record_group_id,version_no)
);
create unique index financial_records_one_current on app.financial_records(record_group_id) where is_current;
create unique index financial_records_base_grain on app.financial_records(reporting_scope,reporting_period_id,coalesce(unit_id,'00000000-0000-0000-0000-000000000000'::uuid),metric_id,coalesce(category_id,'00000000-0000-0000-0000-000000000000'::uuid)) where entry_type='BASE' and is_current;
create unique index financial_records_adjustment_ref on app.financial_records(adjustment_reference) where entry_type in('ADJUSTMENT','REVERSAL');
create unique index financial_records_source_key on app.financial_records(source_type,source_record_key) where source_record_key is not null and is_current;
create index financial_records_query_idx on app.financial_records(reporting_period_id,reporting_scope,unit_id,metric_id,status) where is_current;
create or replace function app.validate_adjustment() returns trigger language plpgsql as $$
declare original app.financial_records%rowtype; period_locked boolean;
begin
 select is_locked into period_locked from app.reporting_periods where id=new.reporting_period_id;
 if period_locked and new.entry_type='BASE' then raise exception 'period is locked'; end if;
 if new.entry_type in('ADJUSTMENT','REVERSAL') then
  select * into original from app.financial_records where id=new.adjusts_record_id;
  if original.id is null or original.status not in('APPROVED','LOCKED') then raise exception 'adjustment must reference approved history'; end if;
  if (original.reporting_scope,original.reporting_period_id,coalesce(original.unit_id,'00000000-0000-0000-0000-000000000000'::uuid),original.metric_id,coalesce(original.category_id,'00000000-0000-0000-0000-000000000000'::uuid))<>(new.reporting_scope,new.reporting_period_id,coalesce(new.unit_id,'00000000-0000-0000-0000-000000000000'::uuid),new.metric_id,coalesce(new.category_id,'00000000-0000-0000-0000-000000000000'::uuid)) then raise exception 'adjustment grain mismatch'; end if;
 end if; return new;
end $$;
create trigger validate_financial_adjustment before insert on app.financial_records for each row execute function app.validate_adjustment();
create or replace function app.protect_approved_financial_history() returns trigger language plpgsql as $$ begin if old.status in('APPROVED','LOCKED') then raise exception 'approved financial history is append-only'; end if;return new;end $$;
create trigger protect_financial_history before update or delete on app.financial_records for each row execute function app.protect_approved_financial_history();
create view app.authoritative_financial_amounts as
 select r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency,sum(r.amount)::numeric(20,2) amount
 from app.financial_records r where r.is_current and r.status in('APPROVED','LOCKED')
 group by r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency;
commit;
