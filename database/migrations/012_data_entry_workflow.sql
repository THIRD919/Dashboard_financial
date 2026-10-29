begin;
alter type app.audit_action add value if not exists 'UPDATE_DRAFT';
alter type app.audit_action add value if not exists 'DELETE_DRAFT';
alter table app.financial_records add column entry_batch_id uuid;
create index financial_records_entry_batch_idx on app.financial_records(entry_batch_id);
create or replace function app.protect_submitted_financial_record() returns trigger language plpgsql as $$
begin
 if old.status='SUBMITTED' then raise exception 'submitted financial records are read-only'; end if;
 return new;
end $$;
create trigger protect_submitted_financial_record before update or delete on app.financial_records for each row execute function app.protect_submitted_financial_record();
create policy financial_records_delete_draft on app.financial_records for delete using(app.has_permission('financial.update') and app.can_access_scope(reporting_scope,unit_id,true) and status='DRAFT');
commit;
