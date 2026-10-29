begin;
create table app.financial_categories (id uuid primary key default gen_random_uuid(),code text not null unique check(code~'^[A-Z][A-Z0-9_]*$'),name_th text not null,name_en text not null,parent_id uuid references app.financial_categories(id),active boolean not null default true,metadata jsonb not null default '{}'::jsonb);
create table app.financial_metrics (
 id uuid primary key default gen_random_uuid(),code text not null unique check(code~'^[A-Z][A-Z0-9_]*$'),name_th text not null,name_en text not null,
 behavior app.metric_behavior not null,aggregation_method app.aggregation_method not null,is_monetary boolean not null default true,
 unit_code text not null check(unit_code in('THB','PERCENT','RATIO','COUNT')),formula_code text,active boolean not null default true,metadata jsonb not null default '{}'::jsonb,
 check((behavior='FLOW' and aggregation_method='SUM') or behavior<>'FLOW'),
 check((behavior='SNAPSHOT' and aggregation_method='LATEST') or behavior<>'SNAPSHOT'),
 check((behavior='DERIVED_RATIO' and aggregation_method='DERIVED') or behavior<>'DERIVED_RATIO')
);
create table app.kpi_definitions (
 id uuid primary key default gen_random_uuid(),code text not null,version integer not null check(version>0),name_th text not null,name_en text not null,
 classification text not null check(classification in('CONFIRMED_FROM_EXCEL','DERIVED_BUT_REPRODUCIBLE','PROPOSED_FOR_WEB','FACULTY_CONFIRMATION_REQUIRED')),
 calculation_handler text not null,configuration jsonb not null default '{}'::jsonb,effective_from date not null,effective_to date,active boolean not null default false,
 approved_by uuid references app.profiles(id),approved_at timestamptz,unique(code,version),check(effective_to is null or effective_to>=effective_from)
);
create table app.kpi_thresholds (id uuid primary key default gen_random_uuid(),kpi_definition_id uuid not null references app.kpi_definitions(id) on delete cascade,status_code text not null,min_value numeric(30,10),max_value numeric(30,10),label_th text not null,label_en text not null,display_order integer not null,active boolean not null default false,approved_by uuid references app.profiles(id),approved_at timestamptz,unique(kpi_definition_id,status_code),check(max_value is null or min_value is null or max_value>=min_value));
create table app.system_settings (key text primary key,value jsonb not null,description text,is_secret boolean not null default false,updated_by uuid references app.profiles(id),updated_at timestamptz not null default now(),check(not is_secret));
commit;
