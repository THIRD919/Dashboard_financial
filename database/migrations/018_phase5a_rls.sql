begin;
drop policy if exists financial_records_create on app.financial_records;
drop policy if exists financial_records_draft_update on app.financial_records;
drop policy if exists financial_records_delete_draft on app.financial_records;
create policy financial_records_create on app.financial_records for insert with check(
 app.has_permission('financial.create') and app.can_access_scope(reporting_scope,unit_id,true)
 and ((status='DRAFT') or (status='SUBMITTED' and app.has_permission('financial.submit')))
);
create policy financial_records_draft_update on app.financial_records for update using(
 app.has_permission('financial.update_draft') and app.can_access_scope(reporting_scope,unit_id,true) and status='DRAFT'
) with check(status in('DRAFT','SUBMITTED'));
create policy financial_records_delete_draft on app.financial_records for delete using(
 app.has_permission('financial.delete_draft') and app.can_access_scope(reporting_scope,unit_id,true) and status='DRAFT'
);

alter table app.profiles enable row level security;
alter table app.user_roles enable row level security;
alter table app.user_unit_access enable row level security;
alter table app.roles enable row level security;
alter table app.permissions enable row level security;
alter table app.role_permissions enable row level security;
alter table app.organizational_units enable row level security;
alter table app.import_batches enable row level security;
alter table app.import_staging_records enable row level security;
alter table app.import_issues enable row level security;

create policy profiles_self_or_admin_read on app.profiles for select using(id=app.current_profile_id() or app.has_permission('users.view'));
create policy profiles_admin_write on app.profiles for all using(app.has_permission('users.manage')) with check(app.has_permission('users.manage'));
create policy user_roles_admin_read on app.user_roles for select using(profile_id=app.current_profile_id() or app.has_permission('roles.view'));
create policy user_roles_admin_write on app.user_roles for all using(app.has_permission('roles.manage')) with check(app.has_permission('roles.manage'));
create policy unit_access_self_or_admin_read on app.user_unit_access for select using(profile_id=app.current_profile_id() or app.has_permission('users.view'));
create policy unit_access_admin_write on app.user_unit_access for all using(app.has_permission('users.manage')) with check(app.has_permission('users.manage'));
create policy roles_authenticated_read on app.roles for select using(app.current_profile_id() is not null);
create policy permissions_authenticated_read on app.permissions for select using(app.current_profile_id() is not null);
create policy role_permissions_authenticated_read on app.role_permissions for select using(app.current_profile_id() is not null);
create policy units_authorized_read on app.organizational_units for select using(app.has_permission('units.view') or app.has_permission('financial.view'));
create policy units_admin_write on app.organizational_units for all using(app.has_permission('units.manage')) with check(app.has_permission('units.manage'));
create policy import_batches_authorized on app.import_batches for select using(app.has_permission('import.review'));
create policy import_staging_authorized on app.import_staging_records for select using(app.has_permission('import.review'));
create policy import_issues_authorized on app.import_issues for select using(app.has_permission('import.review'));
commit;
