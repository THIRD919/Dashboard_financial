-- Vet CMU Financial Management & Executive Dashboard
-- Phase 2 design draft retained for reference only.
-- Phase 4A executable source of truth: database/migrations/*.sql in filename order.
-- No production database was connected and no confidential data is included.

begin;

create extension if not exists pgcrypto;
create schema if not exists app;

create type app.language_code as enum ('th', 'en');
create type app.reporting_scope as enum ('FACULTY', 'UNIT');
create type app.record_status as enum ('DRAFT', 'SUBMITTED', 'APPROVED', 'REJECTED', 'LOCKED');
create type app.entry_type as enum ('BASE', 'ADJUSTMENT', 'REVERSAL');
create type app.source_type as enum ('WEB_ENTRY', 'EXCEL_IMPORT', 'SYSTEM_DERIVED', 'MIGRATION');
create type app.import_status as enum ('UPLOADED', 'VALIDATING', 'INVALID', 'READY', 'CONFIRMING', 'CONFIRMED', 'FAILED', 'ROLLED_BACK');
create type app.issue_severity as enum ('ERROR', 'WARNING');
create type app.reconciliation_status as enum ('MATCHED', 'WITHIN_TOLERANCE', 'REVIEW_REQUIRED', 'RESOLVED');
create type app.kpi_kind as enum ('SOURCE', 'DERIVED', 'CONFIGURED');
create type app.kpi_unit as enum ('THB', 'PERCENT', 'RATIO', 'COUNT');
create type app.kpi_direction as enum ('HIGHER_IS_BETTER', 'LOWER_IS_BETTER', 'NEUTRAL', 'CONFIGURABLE');
create type app.audit_action as enum ('CREATE', 'UPDATE', 'DELETE', 'SUBMIT', 'APPROVE', 'REJECT', 'LOCK', 'UNLOCK', 'IMPORT', 'ROLLBACK', 'PERMISSION_CHANGE', 'THRESHOLD_CHANGE');

create table app.profiles (
  id uuid primary key default gen_random_uuid(),
  auth_user_id uuid not null unique,
  email text,
  display_name text,
  preferred_language app.language_code not null default 'th',
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table app.roles (
  id uuid primary key default gen_random_uuid(),
  code text not null unique check (code ~ '^[A-Z][A-Z0-9_]*$'),
  name_th text not null,
  name_en text not null,
  description text,
  is_system boolean not null default false,
  active boolean not null default true
);

create table app.permissions (
  id uuid primary key default gen_random_uuid(),
  code text not null unique check (code ~ '^[a-z][a-z0-9_.]*$'),
  description text not null
);

create table app.role_permissions (
  role_id uuid not null references app.roles(id) on delete cascade,
  permission_id uuid not null references app.permissions(id) on delete cascade,
  primary key (role_id, permission_id)
);

create table app.user_roles (
  profile_id uuid not null references app.profiles(id) on delete cascade,
  role_id uuid not null references app.roles(id) on delete restrict,
  granted_by uuid references app.profiles(id),
  granted_at timestamptz not null default now(),
  expires_at timestamptz,
  primary key (profile_id, role_id)
);

create table app.organizational_units (
  id uuid primary key default gen_random_uuid(),
  code text not null unique check (code ~ '^[A-Z][A-Z0-9-]*$'),
  name_th text not null,
  name_en text,
  parent_unit_id uuid references app.organizational_units(id) on delete restrict,
  active boolean not null default true,
  active_from date,
  active_to date,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (active_to is null or active_from is null or active_to >= active_from)
);

create table app.organizational_unit_aliases (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references app.organizational_units(id) on delete cascade,
  source_system text not null,
  source_name text not null,
  normalized_name text,
  unique (source_system, source_name)
);

create table app.user_unit_access (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references app.profiles(id) on delete cascade,
  access_scope app.reporting_scope not null,
  unit_id uuid references app.organizational_units(id) on delete cascade,
  can_read boolean not null default true,
  can_write boolean not null default false,
  granted_by uuid references app.profiles(id),
  granted_at timestamptz not null default now(),
  expires_at timestamptz,
  check ((access_scope = 'FACULTY' and unit_id is null) or (access_scope = 'UNIT' and unit_id is not null)),
  unique nulls not distinct (profile_id, access_scope, unit_id)
);

create table app.reporting_periods (
  id uuid primary key default gen_random_uuid(),
  parent_period_id uuid references app.reporting_periods(id) on delete restrict,
  code text not null unique,
  period_type text not null check (period_type in ('FISCAL_YEAR','QUARTER','MONTH','CUSTOM')),
  fiscal_year_label text not null,
  quarter_label text,
  month_number smallint check (month_number between 1 and 12),
  name_th text not null,
  name_en text,
  start_date date,
  end_date date,
  display_order integer not null,
  active boolean not null default true,
  is_locked boolean not null default false,
  locked_at timestamptz,
  locked_by uuid references app.profiles(id),
  source_label text,
  check (end_date is null or start_date is null or end_date >= start_date)
);

create table app.financial_categories (
  id uuid primary key default gen_random_uuid(),
  code text not null unique check (code ~ '^[A-Z][A-Z0-9_]*$'),
  name_th text not null,
  name_en text,
  parent_category_id uuid references app.financial_categories(id) on delete restrict,
  active boolean not null default true
);

create table app.financial_metrics (
  id uuid primary key default gen_random_uuid(),
  code text not null unique check (code ~ '^[A-Z][A-Z0-9_]*$'),
  name_th text not null,
  name_en text not null,
  description_th text,
  description_en text,
  value_unit app.kpi_unit not null,
  metric_group text not null,
  is_monetary boolean not null default true,
  active boolean not null default true
);

create table app.import_batches (
  id uuid primary key default gen_random_uuid(),
  original_filename text not null,
  storage_object_key text not null,
  file_sha256 text not null check (file_sha256 ~ '^[0-9a-f]{64}$'),
  file_size_bytes bigint not null check (file_size_bytes > 0),
  template_version text,
  status app.import_status not null default 'UPLOADED',
  uploaded_by uuid not null references app.profiles(id),
  uploaded_at timestamptz not null default now(),
  validation_summary jsonb not null default '{}'::jsonb,
  confirmed_by uuid references app.profiles(id),
  confirmed_at timestamptz,
  failure_reason text,
  rollback_of_batch_id uuid references app.import_batches(id)
);

create index import_batches_hash_idx on app.import_batches(file_sha256, uploaded_at desc);

create table app.import_staging_records (
  id uuid primary key default gen_random_uuid(),
  import_batch_id uuid not null references app.import_batches(id) on delete cascade,
  row_number integer not null check (row_number > 0),
  worksheet_name text,
  source_cell_range text,
  raw_payload jsonb not null,
  parsed_scope app.reporting_scope,
  parsed_period_code text,
  parsed_unit_code text,
  parsed_metric_code text,
  parsed_category_code text,
  parsed_amount numeric(20,2),
  normalized_payload jsonb,
  validation_status text not null default 'PENDING' check (validation_status in ('PENDING','VALID','WARNING','ERROR')),
  duplicate_fingerprint text,
  created_at timestamptz not null default now(),
  unique (import_batch_id, row_number, worksheet_name, source_cell_range)
);

create table app.import_issues (
  id uuid primary key default gen_random_uuid(),
  import_batch_id uuid not null references app.import_batches(id) on delete cascade,
  staging_record_id uuid references app.import_staging_records(id) on delete cascade,
  severity app.issue_severity not null,
  code text not null,
  field_name text,
  message_th text not null,
  message_en text not null,
  details jsonb not null default '{}'::jsonb,
  resolved_at timestamptz,
  resolved_by uuid references app.profiles(id),
  resolution_note text
);

-- Append-only business entries. record_group_id identifies versions of the same entry.
-- BASE entries represent source values. ADJUSTMENT/REVERSAL entries are additional,
-- independently approved amounts and never overwrite the original numbers.
create table app.financial_records (
  id uuid primary key default gen_random_uuid(),
  record_group_id uuid not null default gen_random_uuid(),
  version_no integer not null default 1 check (version_no > 0),
  is_current boolean not null default true,
  reporting_scope app.reporting_scope not null,
  reporting_period_id uuid not null references app.reporting_periods(id) on delete restrict,
  unit_id uuid references app.organizational_units(id) on delete restrict,
  metric_id uuid not null references app.financial_metrics(id) on delete restrict,
  category_id uuid references app.financial_categories(id) on delete restrict,
  entry_type app.entry_type not null default 'BASE',
  amount numeric(20,2) not null,
  currency_code char(3) not null default 'THB',
  adjustment_reference text,
  adjusts_record_id uuid references app.financial_records(id) on delete restrict,
  source_type app.source_type not null,
  source_reference text,
  import_batch_id uuid references app.import_batches(id) on delete restrict,
  notes text,
  status app.record_status not null default 'DRAFT',
  rejection_reason text,
  submitted_by uuid references app.profiles(id),
  submitted_at timestamptz,
  approved_by uuid references app.profiles(id),
  approved_at timestamptz,
  created_by uuid not null references app.profiles(id),
  created_at timestamptz not null default now(),
  updated_by uuid references app.profiles(id),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  deleted_by uuid references app.profiles(id),
  delete_reason text,
  check ((reporting_scope = 'FACULTY' and unit_id is null) or (reporting_scope = 'UNIT' and unit_id is not null)),
  check ((entry_type = 'BASE' and adjusts_record_id is null) or entry_type in ('ADJUSTMENT','REVERSAL')),
  unique (record_group_id, version_no)
);

create unique index financial_records_one_current_version
  on app.financial_records(record_group_id) where is_current and deleted_at is null;

create unique index financial_records_one_current_base_grain
  on app.financial_records (
    reporting_scope, reporting_period_id, coalesce(unit_id, '00000000-0000-0000-0000-000000000000'::uuid),
    metric_id, coalesce(category_id, '00000000-0000-0000-0000-000000000000'::uuid)
  ) where entry_type = 'BASE' and is_current and deleted_at is null;

create unique index financial_records_adjustment_reference
  on app.financial_records(adjustment_reference)
  where entry_type in ('ADJUSTMENT','REVERSAL') and adjustment_reference is not null and is_current and deleted_at is null;

create index financial_records_query_idx
  on app.financial_records(reporting_period_id, reporting_scope, unit_id, metric_id, status)
  where is_current and deleted_at is null;

create table app.import_commits (
  id uuid primary key default gen_random_uuid(),
  import_batch_id uuid not null references app.import_batches(id) on delete restrict,
  staging_record_id uuid not null references app.import_staging_records(id) on delete restrict,
  financial_record_id uuid not null references app.financial_records(id) on delete restrict,
  committed_at timestamptz not null default now(),
  unique (import_batch_id, staging_record_id, financial_record_id)
);

create table app.reconciliation_rules (
  id uuid primary key default gen_random_uuid(),
  metric_id uuid not null references app.financial_metrics(id) on delete restrict,
  absolute_tolerance numeric(20,2),
  percentage_tolerance numeric(12,8),
  effective_from date not null,
  effective_to date,
  active boolean not null default false,
  approved_by uuid references app.profiles(id),
  approved_at timestamptz,
  notes text,
  check (absolute_tolerance is null or absolute_tolerance >= 0),
  check (percentage_tolerance is null or percentage_tolerance >= 0),
  check (effective_to is null or effective_to >= effective_from)
);

create table app.reconciliations (
  id uuid primary key default gen_random_uuid(),
  reporting_period_id uuid not null references app.reporting_periods(id) on delete restrict,
  metric_id uuid not null references app.financial_metrics(id) on delete restrict,
  faculty_total numeric(20,2) not null,
  unit_sum numeric(20,2) not null,
  difference numeric(20,2) not null,
  difference_percentage numeric(12,8),
  absolute_tolerance numeric(20,2),
  percentage_tolerance numeric(12,8),
  status app.reconciliation_status not null,
  explanation text,
  resolution_note text,
  reviewed_by uuid references app.profiles(id),
  reviewed_at timestamptz,
  calculated_at timestamptz not null default now(),
  calculation_version text not null,
  source_import_batch_id uuid references app.import_batches(id),
  unique (reporting_period_id, metric_id, calculation_version)
);

create table app.kpi_definitions (
  id uuid primary key default gen_random_uuid(),
  code text not null check (code ~ '^[A-Z][A-Z0-9_]*$'),
  name_th text not null,
  name_en text not null,
  description_th text,
  description_en text,
  kind app.kpi_kind not null,
  unit app.kpi_unit not null,
  direction app.kpi_direction not null default 'NEUTRAL',
  calculation_method text not null,
  calculation_handler text not null,
  configuration jsonb not null default '{}'::jsonb,
  version integer not null check (version > 0),
  effective_from date not null,
  effective_to date,
  active boolean not null default false,
  approved_by uuid references app.profiles(id),
  approved_at timestamptz,
  check (effective_to is null or effective_to >= effective_from),
  unique (code, version)
);

create table app.kpi_thresholds (
  id uuid primary key default gen_random_uuid(),
  kpi_definition_id uuid not null references app.kpi_definitions(id) on delete cascade,
  status_code text not null,
  min_value numeric(20,8),
  max_value numeric(20,8),
  label_th text not null,
  label_en text not null,
  display_order integer not null,
  active boolean not null default false,
  approved_by uuid references app.profiles(id),
  approved_at timestamptz,
  check (max_value is null or min_value is null or max_value >= min_value),
  unique (kpi_definition_id, status_code)
);

create table app.system_settings (
  key text primary key,
  value jsonb not null,
  description text,
  is_secret boolean not null default false,
  updated_by uuid references app.profiles(id),
  updated_at timestamptz not null default now(),
  check (not is_secret) -- secrets belong in a secret manager, never this table
);

create table app.audit_logs (
  id bigint generated always as identity primary key,
  occurred_at timestamptz not null default now(),
  actor_profile_id uuid references app.profiles(id),
  action app.audit_action not null,
  entity_type text not null,
  entity_id text,
  unit_id uuid references app.organizational_units(id),
  reporting_period_id uuid references app.reporting_periods(id),
  old_values jsonb,
  new_values jsonb,
  source_type app.source_type,
  import_batch_id uuid references app.import_batches(id),
  request_id text,
  ip_address inet,
  user_agent text,
  metadata jsonb not null default '{}'::jsonb
);

create index audit_logs_entity_idx on app.audit_logs(entity_type, entity_id, occurred_at desc);
create index audit_logs_actor_idx on app.audit_logs(actor_profile_id, occurred_at desc);

-- Supabase adapter boundary. Replace this function when migrating auth providers.
create or replace function app.current_profile_id() returns uuid
language sql stable security definer set search_path = app, public
as $$ select id from app.profiles where auth_user_id = auth.uid() and is_active limit 1 $$;

create or replace function app.has_permission(required_permission text) returns boolean
language sql stable security definer set search_path = app, public
as $$
  select exists (
    select 1 from app.user_roles ur
    join app.roles r on r.id = ur.role_id and r.active
    join app.role_permissions rp on rp.role_id = r.id
    join app.permissions p on p.id = rp.permission_id
    where ur.profile_id = app.current_profile_id()
      and p.code = required_permission
      and (ur.expires_at is null or ur.expires_at > now())
  )
$$;

create or replace function app.can_access_scope(scope app.reporting_scope, target_unit_id uuid, require_write boolean default false)
returns boolean language sql stable security definer set search_path = app, public
as $$
  select exists (
    select 1 from app.user_unit_access ua
    where ua.profile_id = app.current_profile_id()
      and (ua.expires_at is null or ua.expires_at > now())
      and ua.can_read
      and (not require_write or ua.can_write)
      and ((scope = 'FACULTY' and ua.access_scope = 'FACULTY')
        or (scope = 'UNIT' and (ua.access_scope = 'FACULTY' or (ua.access_scope = 'UNIT' and ua.unit_id = target_unit_id))))
  )
$$;

alter table app.financial_records enable row level security;
alter table app.import_batches enable row level security;
alter table app.import_staging_records enable row level security;
alter table app.import_issues enable row level security;
alter table app.reconciliations enable row level security;
alter table app.audit_logs enable row level security;

create policy financial_records_read on app.financial_records for select
  using (app.has_permission('financial.view') and app.can_access_scope(reporting_scope, unit_id, false));

create policy financial_records_create on app.financial_records for insert
  with check (app.has_permission('financial.create') and app.can_access_scope(reporting_scope, unit_id, true)
    and created_by = app.current_profile_id() and status = 'DRAFT');

create policy financial_records_update on app.financial_records for update
  using (app.has_permission('financial.update') and app.can_access_scope(reporting_scope, unit_id, true)
    and status in ('DRAFT','REJECTED'))
  with check (app.has_permission('financial.update') and app.can_access_scope(reporting_scope, unit_id, true)
    and status in ('DRAFT','REJECTED'));

create policy import_batches_owner_read on app.import_batches for select
  using (app.has_permission('import.create') and uploaded_by = app.current_profile_id()
    or app.has_permission('import.approve'));

create policy import_staging_read on app.import_staging_records for select
  using (exists (select 1 from app.import_batches b where b.id = import_batch_id
    and ((b.uploaded_by = app.current_profile_id() and app.has_permission('import.create')) or app.has_permission('import.approve'))));

create policy import_issues_read on app.import_issues for select
  using (exists (select 1 from app.import_batches b where b.id = import_batch_id
    and ((b.uploaded_by = app.current_profile_id() and app.has_permission('import.create')) or app.has_permission('import.approve'))));

create policy reconciliations_read on app.reconciliations for select
  using (app.has_permission('financial.view') and app.can_access_scope('FACULTY', null, false));

create policy audit_logs_read on app.audit_logs for select using (app.has_permission('audit.view'));

-- Authoritative approve/lock/import operations are intentionally performed only
-- through security-definer database functions or trusted server code added in a
-- later implementation phase; no broad client UPDATE policy is granted here.

commit;
