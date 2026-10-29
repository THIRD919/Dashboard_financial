begin;
alter table app.profiles add column if not exists name_th text;
alter table app.profiles add column if not exists name_en text;
alter table app.profiles add column if not exists job_title text;
alter table app.profiles add column if not exists phone text;
alter table app.profiles add column if not exists account_status text not null default 'ACTIVE' check(account_status in('ACTIVE','INACTIVE','SUSPENDED'));
alter table app.profiles add column if not exists last_login_at timestamptz;
alter table app.profiles add column if not exists last_activity_at timestamptz;

insert into app.permissions(code,description) values
('dashboard.view','View dashboards'),('financial.update_draft','Update financial drafts'),('financial.delete_draft','Delete financial drafts'),('import.upload','Upload Excel imports'),('import.review','Review staged imports'),('import.confirm','Confirm imports'),('reconciliation.view','View reconciliations'),('users.view','View users'),('users.manage','Manage users'),('roles.view','View roles and permissions'),('roles.manage','Manage roles and permissions'),('units.view','View organizational units'),('units.manage','Manage organizational units'),('kpi.view','View KPI configuration'),('kpi.manage','Manage KPI configuration'),('system.view','View system settings'),('system.manage','Manage system settings'),('faculty_scope.read','Read Faculty scope'),('faculty_scope.write','Write Faculty scope'),('financial.reject','Reject financial records'),('period.lock','Lock reporting periods'),('period.unlock','Unlock reporting periods'),('financial.reverse','Reverse financial records') on conflict(code) do nothing;

insert into app.role_permissions(role_id,permission_id)
select r.id,p.id from app.roles r join app.permissions p on
(r.code='VIEWER' and p.code in('dashboard.view','financial.view')) or
(r.code='EXECUTIVE' and p.code in('dashboard.view','financial.view','reconciliation.view')) or
(r.code='DATA_ENTRY' and p.code in('dashboard.view','financial.view','financial.create','financial.update','financial.update_draft','financial.submit','financial.delete_draft')) or
(r.code='ADMIN' and p.code in('dashboard.view','financial.view','financial.create','financial.update','financial.update_draft','financial.submit','financial.delete_draft','import.upload','import.review','import.confirm','reconciliation.view','reconciliation.review','users.view','users.manage','roles.view','roles.manage','units.view','units.manage','kpi.view','kpi.manage','audit.view','system.view','system.manage','faculty_scope.read','faculty_scope.write'))
on conflict do nothing;

create or replace function app.has_permission(required_permission text) returns boolean language sql stable security definer set search_path=app,public as $$select exists(select 1 from app.profiles pr join app.user_roles ur on ur.profile_id=pr.id join app.roles r on r.id=ur.role_id and r.active join app.role_permissions rp on rp.role_id=r.id join app.permissions p on p.id=rp.permission_id where pr.id=app.current_profile_id() and pr.account_status='ACTIVE' and pr.is_active and p.code=required_permission and (ur.expires_at is null or ur.expires_at>now()))$$;
commit;
