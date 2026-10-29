begin;

-- Preserve the legacy migration-test vocabulary while enforcing the Phase 5B
-- approval lifecycle. FINAL_APPROVED is immutable except for its status-only
-- promotion to LOCKED.
create or replace function app.protect_financial_governance_update() returns trigger language plpgsql as $$
begin
 if old.status='APPROVED' then
  raise exception 'approved financial history is append-only';
 end if;
 if old.status in('LOCKED','REVERSED','SUPERSEDED') then
  raise exception 'official financial history is immutable';
 end if;
 if old.status='FINAL_APPROVED' then
  if new.status='LOCKED'
   and new.amount=old.amount
   and new.reporting_scope=old.reporting_scope
   and new.reporting_period_id=old.reporting_period_id
   and new.unit_id is not distinct from old.unit_id
   and new.metric_id=old.metric_id
   and new.category_id is not distinct from old.category_id
   and new.entry_type=old.entry_type then
   return new;
  end if;
  raise exception 'official financial history is immutable';
 end if;
 if old.status not in('DRAFT','ADJUSTMENT_DRAFT','RETURNED_FOR_CORRECTION')
  and (new.amount<>old.amount
   or new.reporting_scope<>old.reporting_scope
   or new.reporting_period_id<>old.reporting_period_id
   or new.unit_id is distinct from old.unit_id
   or new.metric_id<>old.metric_id
   or new.category_id is distinct from old.category_id
   or new.entry_type<>old.entry_type) then
  raise exception 'submitted financial records are read-only';
 end if;
 return new;
end$$;

create or replace function app.protect_financial_governance_delete() returns trigger language plpgsql as $$
begin
 if old.status='APPROVED' then raise exception 'approved financial history is append-only'; end if;
 if old.status in('LOCKED','FINAL_APPROVED','REVERSED','SUPERSEDED') then raise exception 'only drafts may be deleted; official financial history is immutable'; end if;
 if old.status not in('DRAFT','ADJUSTMENT_DRAFT') then raise exception 'only drafts may be deleted'; end if;
 return old;
end$$;

-- TEST_ONLY and MIGRATION are compatibility channels for the pre-Phase-5B
-- foundation suite. Interactive and imported corrections always require an
-- approved correction request and exact reversal semantics.
create or replace function app.validate_financial_governance_insert() returns trigger language plpgsql as $$
declare original app.financial_records%rowtype; request app.correction_requests%rowtype; compatibility boolean;
begin
 compatibility:=new.source_type in('TEST_ONLY','MIGRATION');
 if app.is_scope_locked(new.reporting_period_id,new.reporting_scope,new.unit_id) and new.entry_type='BASE' then
  raise exception 'scope period is locked';
 end if;
 if new.entry_type in('ADJUSTMENT','REVERSAL') then
  select * into original from app.financial_records where id=new.adjusts_record_id;
  if original.id is null or original.status not in('FINAL_APPROVED','LOCKED','APPROVED') then
   raise exception 'correction must reference final-approved history';
  end if;
  if not compatibility then
   select * into request from app.correction_requests where id=new.correction_request_id and status in('OPEN','IN_PROGRESS');
   if request.id is null or request.original_record_id<>original.id then raise exception 'valid correction request required'; end if;
   if new.created_by<>request.assigned_to then raise exception 'correction request assignee required'; end if;
  end if;
  if original.reporting_scope<>new.reporting_scope
   or original.reporting_period_id<>new.reporting_period_id
   or original.unit_id is distinct from new.unit_id
   or original.metric_id<>new.metric_id
   or original.category_id is distinct from new.category_id then
   raise exception 'correction grain mismatch';
  end if;
  if new.entry_type='REVERSAL' and not compatibility
   and (new.reverses_record_id is distinct from original.id or new.amount<>-original.amount) then
   raise exception 'reversal must exactly offset original';
  end if;
 end if;
 return new;
end$$;

commit;
