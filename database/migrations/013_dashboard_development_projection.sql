begin;
create view app.dashboard_financial_amounts as
select r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency,sum(r.amount)::numeric(20,2) amount,
case when bool_and(r.status in('APPROVED','LOCKED')) then 'AUTHORITATIVE' else 'SUBMITTED_PREVIEW' end data_state
from app.financial_records r where r.is_current and r.status in('SUBMITTED','APPROVED','LOCKED')
group by r.reporting_scope,r.reporting_period_id,r.unit_id,r.metric_id,r.category_id,r.currency;
commit;
