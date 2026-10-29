begin;
create view app.flow_annual_amounts as
 select rp.reporting_year_id,a.reporting_scope,a.unit_id,a.metric_id,a.category_id,a.currency,sum(a.amount)::numeric(20,2) amount,count(distinct rp.id)::integer available_period_count
 from app.authoritative_financial_amounts a join app.reporting_periods rp on rp.id=a.reporting_period_id join app.financial_metrics m on m.id=a.metric_id
 where m.behavior='FLOW' group by rp.reporting_year_id,a.reporting_scope,a.unit_id,a.metric_id,a.category_id,a.currency;
create view app.latest_snapshot_amounts as
 select distinct on(rp.reporting_year_id,a.reporting_scope,coalesce(a.unit_id,'00000000-0000-0000-0000-000000000000'::uuid),a.metric_id,coalesce(a.category_id,'00000000-0000-0000-0000-000000000000'::uuid))
 rp.reporting_year_id,a.reporting_scope,a.unit_id,a.metric_id,a.category_id,a.amount,a.currency,a.reporting_period_id,rp.period_code source_period_code
 from app.authoritative_financial_amounts a join app.reporting_periods rp on rp.id=a.reporting_period_id join app.financial_metrics m on m.id=a.metric_id
 where m.behavior='SNAPSHOT' order by rp.reporting_year_id,a.reporting_scope,coalesce(a.unit_id,'00000000-0000-0000-0000-000000000000'::uuid),a.metric_id,coalesce(a.category_id,'00000000-0000-0000-0000-000000000000'::uuid),rp.display_order desc;
create or replace function app.safe_ratio(numerator numeric,denominator numeric) returns numeric language sql immutable as $$select case when denominator is null or denominator=0 then null else numerator/denominator end$$;
create or replace function app.period_completeness(target_year uuid,target_scope app.reporting_scope,target_unit uuid default null)
returns table(available_period_count integer,expected_period_count integer,missing_periods jsonb,completion_ratio numeric,year_status app.year_status) language sql stable as $$
with expected as (select id,period_code from app.reporting_periods where reporting_year_id=target_year and period_type in('MONTH','QUARTER','CUSTOM') and active),available as (select distinct reporting_period_id from app.authoritative_financial_amounts where reporting_scope=target_scope and unit_id is not distinct from target_unit and reporting_period_id in(select id from expected)),counts as(select (select count(*) from available)::int a,(select count(*) from expected)::int e)
select a,e,coalesce((select jsonb_agg(period_code order by period_code) from expected where id not in(select reporting_period_id from available)),'[]'::jsonb),app.safe_ratio(a,e),case when e>0 and a=e then 'FULL_YEAR'::app.year_status else 'PARTIAL_YEAR'::app.year_status end from counts$$;
commit;
