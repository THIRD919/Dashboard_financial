begin;
insert into app.profiles(id,display_name,preferred_language,is_active) values
('10000000-0000-0000-0000-000000000001','Demo Data Entry — Office Unit','th',true),
('10000000-0000-0000-0000-000000000002','Demo Data Entry — NOVEL','th',true),
('10000000-0000-0000-0000-000000000003','Demo Executive','th',true),
('10000000-0000-0000-0000-000000000004','Demo Admin','en',true) on conflict(id) do nothing;
insert into app.user_roles(profile_id,role_id) select p.id,r.id from app.profiles p join app.roles r on (p.id='10000000-0000-0000-0000-000000000001' and r.code='DATA_ENTRY') or (p.id='10000000-0000-0000-0000-000000000002' and r.code='DATA_ENTRY') or (p.id='10000000-0000-0000-0000-000000000003' and r.code='EXECUTIVE') or (p.id='10000000-0000-0000-0000-000000000004' and r.code='ADMIN') on conflict do nothing;
insert into app.user_unit_access(profile_id,reporting_scope,unit_id,can_read,can_write)
select '10000000-0000-0000-0000-000000000001'::uuid, 'UNIT'::app.reporting_scope,id,true,true from app.organizational_units where code='VET-OFFICE'
union all select '10000000-0000-0000-0000-000000000002'::uuid,'UNIT'::app.reporting_scope,id,true,true from app.organizational_units where code='NOVEL'
union all select '10000000-0000-0000-0000-000000000003'::uuid,'FACULTY'::app.reporting_scope,null::uuid,true,false
union all select '10000000-0000-0000-0000-000000000004'::uuid,'FACULTY'::app.reporting_scope,null::uuid,true,true
on conflict do nothing;
commit;
