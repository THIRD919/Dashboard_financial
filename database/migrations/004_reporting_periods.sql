begin;
create table app.reporting_years (
 id uuid primary key default gen_random_uuid(),code text not null unique,display_label text not null,
 start_date date,end_date date,display_order integer not null,active boolean not null default true,metadata jsonb not null default '{}'::jsonb,
 check(end_date is null or start_date is null or end_date>=start_date)
);
create table app.reporting_periods (
 id uuid primary key default gen_random_uuid(),reporting_year_id uuid not null references app.reporting_years(id),
 parent_period_id uuid references app.reporting_periods(id),period_code text not null unique,period_type app.period_type not null,
 source_label text,display_label_th text not null,display_label_en text not null,start_date date,end_date date,
 display_order integer not null,expected_child_count integer check(expected_child_count is null or expected_child_count>0),
 active boolean not null default true,is_locked boolean not null default false,locked_at timestamptz,locked_by uuid references app.profiles(id),metadata jsonb not null default '{}'::jsonb,
 check(end_date is null or start_date is null or end_date>=start_date),check(parent_period_id is null or parent_period_id<>id)
);
create index reporting_periods_hierarchy_idx on app.reporting_periods(reporting_year_id,parent_period_id,display_order);
create or replace function app.prevent_reporting_period_cycle() returns trigger language plpgsql as $$
declare found_cycle boolean;
begin
 if new.parent_period_id is null then return new; end if;
 with recursive ancestors(id,parent_period_id) as (select id,parent_period_id from app.reporting_periods where id=new.parent_period_id union all select p.id,p.parent_period_id from app.reporting_periods p join ancestors a on p.id=a.parent_period_id)
 select exists(select 1 from ancestors where id=new.id) into found_cycle;
 if found_cycle then raise exception 'reporting period hierarchy cycle'; end if; return new;
end $$;
create trigger reporting_period_no_cycle before insert or update of parent_period_id on app.reporting_periods for each row execute function app.prevent_reporting_period_cycle();
commit;
