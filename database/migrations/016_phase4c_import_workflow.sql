begin;

alter table app.import_batches drop constraint if exists import_batches_file_sha256_template_version_key;

create table app.import_profiles (
  id uuid primary key default gen_random_uuid(),
  code text not null,
  version integer not null default 1,
  name_th text not null,
  name_en text not null,
  description text,
  mapping_config jsonb not null default '{}'::jsonb,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique(code,version)
);

alter table app.import_batches add column if not exists import_profile_id uuid references app.import_profiles(id);
alter table app.import_batches add column if not exists record_count integer not null default 0;
alter table app.import_batches add column if not exists valid_count integer not null default 0;
alter table app.import_batches add column if not exists warning_count integer not null default 0;
alter table app.import_batches add column if not exists error_count integer not null default 0;
alter table app.import_batches add column if not exists duplicate_count integer not null default 0;
alter table app.import_batches add column if not exists conflict_count integer not null default 0;
alter table app.import_staging_records add column if not exists mapping_status text not null default 'PENDING';
alter table app.import_staging_records add column if not exists duplicate_status text not null default 'NEW';
alter table app.import_staging_records add column if not exists existing_record_id uuid references app.financial_records(id);

create index if not exists import_batches_hash_lookup on app.import_batches(file_sha256,uploaded_at desc);
create index if not exists import_staging_batch_status on app.import_staging_records(import_batch_id,validation_status);

commit;
