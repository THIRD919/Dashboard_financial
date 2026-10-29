begin;
insert into app.permissions(code,description) values
('financial.review','Start financial review'),('financial.review_approve','Approve reviewer stage'),('financial.return_for_correction','Return submission before final approval'),('financial.final_approve','Final approve reviewed financial data'),('financial.final_reject','Return reviewed data'),('financial.request_correction','Request correction of official data'),('financial.adjustment_create','Create governed adjustment or reversal'),('financial.adjustment_review','Review governed corrections'),('financial.reversal_authorize','Authorize reversal'),('tasks.view','View assigned workflow tasks') on conflict(code) do update set description=excluded.description;
insert into app.roles(code,name_th,name_en,description,is_system,active) values
('REVIEWER','ผู้ตรวจสอบ','Reviewer','Supervisor or Faculty Secretary reviewer',true,true),('FINAL_APPROVER','ผู้อนุมัติขั้นสุดท้าย','Final Approver','Vice Dean final financial authority',true,true) on conflict(code) do update set name_th=excluded.name_th,name_en=excluded.name_en,description=excluded.description,active=true;
insert into app.role_permissions(role_id,permission_id) select r.id,p.id from app.roles r join app.permissions p on
(r.code='DATA_ENTRY' and p.code in('tasks.view','financial.adjustment_create')) or
(r.code='REVIEWER' and p.code in('dashboard.view','financial.view','financial.review','financial.review_approve','financial.return_for_correction','reconciliation.view','reconciliation.review','tasks.view')) or
(r.code='FINAL_APPROVER' and p.code in('dashboard.view','financial.view','financial.final_approve','financial.final_reject','financial.request_correction','financial.adjustment_review','financial.reversal_authorize','period.lock','reconciliation.view','tasks.view')) or
(r.code='EXECUTIVE' and p.code='tasks.view') or (r.code='ADMIN' and p.code='tasks.view') on conflict do nothing;
commit;
