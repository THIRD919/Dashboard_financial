begin;
create table app.profiles (
 id uuid primary key default gen_random_uuid(), auth_user_id uuid unique, email text,
 display_name text, preferred_language app.language_code not null default 'th', is_active boolean not null default true,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table app.roles (id uuid primary key default gen_random_uuid(),code text not null unique check(code~'^[A-Z][A-Z0-9_]*$'),name_th text not null,name_en text not null,description text,is_system boolean not null default true,active boolean not null default true);
create table app.permissions (id uuid primary key default gen_random_uuid(),code text not null unique check(code~'^[a-z][a-z0-9_.]*$'),description text not null);
create table app.role_permissions (role_id uuid not null references app.roles(id) on delete cascade,permission_id uuid not null references app.permissions(id) on delete cascade,primary key(role_id,permission_id));
create table app.user_roles (profile_id uuid not null references app.profiles(id) on delete cascade,role_id uuid not null references app.roles(id),granted_by uuid references app.profiles(id),granted_at timestamptz not null default now(),expires_at timestamptz,primary key(profile_id,role_id));
commit;
