begin;
create table app.reconciliation_rules (id uuid primary key default gen_random_uuid(),metric_id uuid not null references app.financial_metrics(id),absolute_tolerance numeric(20,2),percentage_tolerance numeric(20,10),effective_from date not null,effective_to date,active boolean not null default false,approved_by uuid references app.profiles(id),approved_at timestamptz,notes text,check(absolute_tolerance is null or absolute_tolerance>=0),check(percentage_tolerance is null or percentage_tolerance>=0),check(effective_to is null or effective_to>=effective_from));
create table app.reconciliations (
 id uuid primary key default gen_random_uuid(),reporting_period_id uuid not null references app.reporting_periods(id),metric_id uuid not null references app.financial_metrics(id),
 faculty_total numeric(20,2) not null,unit_sum numeric(20,2) not null,difference numeric(20,2) not null,difference_percent numeric(20,10),
 tolerance numeric(20,2),percentage_tolerance numeric(20,10),status app.reconciliation_status not null,review_note text,reviewed_by uuid references app.profiles(id),reviewed_at timestamptz,
 calculation_version text not null,calculated_at timestamptz not null default now(),unique(reporting_period_id,metric_id,calculation_version)
);
create or replace function app.calculate_reconciliation(target_period uuid,target_metric uuid,absolute_tolerance numeric default null,percentage_tolerance numeric default null)
returns table(faculty_total numeric,unit_sum numeric,difference numeric,difference_percent numeric,status app.reconciliation_status) language sql stable as $$
with totals as(select coalesce(sum(amount) filter(where reporting_scope='FACULTY'),0)::numeric f,coalesce(sum(amount) filter(where reporting_scope='UNIT'),0)::numeric u from app.authoritative_financial_amounts where reporting_period_id=target_period and metric_id=target_metric),calc as(select f,u,f-u d,app.safe_ratio(f-u,f) dp from totals)
select f,u,d,dp,case when d=0 then 'MATCHED'::app.reconciliation_status when (absolute_tolerance is not null and abs(d)<=absolute_tolerance) or (percentage_tolerance is not null and abs(dp)<=percentage_tolerance) then 'WITHIN_TOLERANCE'::app.reconciliation_status else 'REVIEW_REQUIRED'::app.reconciliation_status end from calc$$;
commit;
