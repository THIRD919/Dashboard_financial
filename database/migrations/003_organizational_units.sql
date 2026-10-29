begin;
create table app.organizational_units (
 id uuid primary key default gen_random_uuid(), code text not null unique check(code~'^[A-Z][A-Z0-9-]*$'),
 name_th text not null,name_en text,parent_id uuid references app.organizational_units(id),active boolean not null default true,
 display_order integer not null check(display_order>0),metadata jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now(),updated_at timestamptz not null default now()
);
create table app.organizational_unit_aliases (id uuid primary key default gen_random_uuid(),unit_id uuid not null references app.organizational_units(id) on delete cascade,source_system text not null,source_name text not null,unique(source_system,source_name));
create table app.user_unit_access (
 id uuid primary key default gen_random_uuid(),profile_id uuid not null references app.profiles(id) on delete cascade,
 reporting_scope app.reporting_scope not null,unit_id uuid references app.organizational_units(id),can_read boolean not null default true,can_write boolean not null default false,
 granted_by uuid references app.profiles(id),granted_at timestamptz not null default now(),expires_at timestamptz,
 check((reporting_scope='FACULTY' and unit_id is null) or (reporting_scope='UNIT' and unit_id is not null))
);
create unique index user_unit_access_grain on app.user_unit_access(profile_id,reporting_scope,coalesce(unit_id,'00000000-0000-0000-0000-000000000000'::uuid));
commit;
