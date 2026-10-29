begin;
update app.profiles set email=case id
 when '10000000-0000-0000-0000-000000000001' then 'office.dataentry.test@local'
 when '10000000-0000-0000-0000-000000000002' then 'novel.dataentry.test@local'
 when '10000000-0000-0000-0000-000000000003' then 'executive.test@local'
 when '10000000-0000-0000-0000-000000000004' then 'admin.test@local' end,
 name_th=display_name,name_en=display_name,account_status='ACTIVE',is_active=true
where id in('10000000-0000-0000-0000-000000000001','10000000-0000-0000-0000-000000000002','10000000-0000-0000-0000-000000000003','10000000-0000-0000-0000-000000000004');
insert into app.profiles(id,email,display_name,name_th,name_en,preferred_language,is_active,account_status) values('10000000-0000-0000-0000-000000000005','viewer.test@local','Demo Viewer','ผู้ดูข้อมูลทดสอบ','Demo Viewer','th',true,'ACTIVE') on conflict(id) do update set email=excluded.email,account_status='ACTIVE',is_active=true;
insert into app.user_roles(profile_id,role_id) select '10000000-0000-0000-0000-000000000005'::uuid,id from app.roles where code='VIEWER' on conflict do nothing;
insert into app.user_unit_access(profile_id,reporting_scope,unit_id,can_read,can_write) values('10000000-0000-0000-0000-000000000005','FACULTY',null,true,false) on conflict do nothing;
commit;
