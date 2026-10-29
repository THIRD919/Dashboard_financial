begin;

create or replace function app.protect_submitted_financial_record()
returns trigger
language plpgsql
as $$
begin
  if old.status = 'SUBMITTED' then
    raise exception 'submitted financial records are read-only';
  end if;

  if tg_op = 'DELETE' then
    return old;
  end if;

  return new;
end
$$;

commit;
