begin;
delete from app.role_permissions rp using app.roles r where rp.role_id=r.id and r.code in('VIEWER','EXECUTIVE','DATA_ENTRY','ADMIN');
insert into app.role_permissions(role_id,permission_id)
select r.id,p.id from app.roles r join app.permissions p on
(r.code='VIEWER' and p.code in('dashboard.view','financial.view')) or
(r.code='EXECUTIVE' and p.code in('dashboard.view','financial.view','reconciliation.view')) or
(r.code='DATA_ENTRY' and p.code in('dashboard.view','financial.view','financial.create','financial.update','financial.update_draft','financial.submit','financial.delete_draft')) or
(r.code='ADMIN' and p.code in('dashboard.view','financial.view','financial.create','financial.update','financial.update_draft','financial.submit','financial.delete_draft','import.upload','import.review','import.confirm','reconciliation.view','reconciliation.review','users.view','users.manage','roles.view','roles.manage','units.view','units.manage','kpi.view','kpi.manage','audit.view','system.view','system.manage','faculty_scope.read','faculty_scope.write'));
commit;
