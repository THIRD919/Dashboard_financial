begin;

drop trigger if exists protect_submitted_financial_record on app.financial_records;
drop trigger if exists protect_financial_history on app.financial_records;

create or replace function app.protect_approved_financial_history_update()
returns trigger
language plpgsql
as $$
begin
  if old.status in ('APPROVED', 'LOCKED') then
    raise exception 'approved financial history is append-only';
  end if;
  return new;
end
$$;

create or replace function app.protect_approved_financial_history_delete()
returns trigger
language plpgsql
as $$
begin
  if old.status in ('APPROVED', 'LOCKED') then
    raise exception 'approved financial history is append-only';
  end if;
  return old;
end
$$;

create or replace function app.protect_submitted_financial_record_update()
returns trigger
language plpgsql
as $$
begin
  if old.status = 'SUBMITTED' then
    raise exception 'submitted financial records are read-only';
  end if;
  return new;
end
$$;

create or replace function app.protect_submitted_financial_record_delete()
returns trigger
language plpgsql
as $$
begin
  if old.status = 'SUBMITTED' then
    raise exception 'submitted financial records are read-only';
  end if;
  return old;
end
$$;

create trigger protect_submitted_financial_record_update
before update on app.financial_records
for each row execute function app.protect_submitted_financial_record_update();

create trigger protect_submitted_financial_record_delete
before delete on app.financial_records
for each row execute function app.protect_submitted_financial_record_delete();

create trigger protect_financial_history_update
before update on app.financial_records
for each row execute function app.protect_approved_financial_history_update();

create trigger protect_financial_history_delete
before delete on app.financial_records
for each row execute function app.protect_approved_financial_history_delete();

commit;
