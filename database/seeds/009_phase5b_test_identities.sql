begin;
insert into app.profiles(id,email,display_name,name_th,name_en,preferred_language,is_active,account_status) values
('10000000-0000-0000-0000-000000000006','office.reviewer.test@local','Office Reviewer','หัวหน้างานสำนักงาน','Office Reviewer','th',true,'ACTIVE'),
('10000000-0000-0000-0000-000000000007','secretary.reviewer.test@local','Faculty Secretary Reviewer','เลขานุการคณะ','Faculty Secretary Reviewer','th',true,'ACTIVE'),
('10000000-0000-0000-0000-000000000008','vicedean.approver.test@local','Vice Dean Final Approver','รองคณบดี','Vice Dean Final Approver','th',true,'ACTIVE') on conflict(id) do update set email=excluded.email,display_name=excluded.display_name,name_th=excluded.name_th,name_en=excluded.name_en,is_active=true,account_status='ACTIVE';
insert into app.user_roles(profile_id,role_id) select v.profile_id,r.id from (values
('10000000-0000-0000-0000-000000000006'::uuid,'REVIEWER'),('10000000-0000-0000-0000-000000000007'::uuid,'REVIEWER'),('10000000-0000-0000-0000-000000000008'::uuid,'FINAL_APPROVER'))v(profile_id,role_code) join app.roles r on r.code=v.role_code on conflict do nothing;
insert into app.user_unit_access(profile_id,reporting_scope,unit_id,can_read,can_write)
select '10000000-0000-0000-0000-000000000006'::uuid,'UNIT'::app.reporting_scope,id,true,false from app.organizational_units where code='VET-OFFICE'
union all select '10000000-0000-0000-0000-000000000007'::uuid,'FACULTY'::app.reporting_scope,null::uuid,true,false
union all select '10000000-0000-0000-0000-000000000008'::uuid,'FACULTY'::app.reporting_scope,null::uuid,true,false on conflict do nothing;
commit;
