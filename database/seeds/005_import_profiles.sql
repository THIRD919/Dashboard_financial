begin;
insert into app.import_profiles(code,version,name_th,name_en,description,mapping_config) values
('VET_CMU_FINANCIAL_WORKBOOK_V1',1,'สมุดงานการเงินคณะสัตวแพทยศาสตร์ รุ่น 1','VET CMU Financial Workbook v1','Profile for the Phase 1–3 dashboard workbook','{"kind":"VET_CMU_FIXED_CELLS","quarter_mapping":"CONFIGURED_LABELS_ONLY"}'),
('GENERIC_PERIODIC_FINANCIAL_TEMPLATE_V1',1,'แม่แบบข้อมูลการเงินรายงวด รุ่น 1','Generic Periodic Financial Template v1','Preferred long-format template for future imports','{"kind":"GENERIC_LONG_FORMAT","sheet":"Financial Data","header_row":1}')
on conflict(code,version) do update set name_th=excluded.name_th,name_en=excluded.name_en,description=excluded.description,mapping_config=excluded.mapping_config,active=true;
commit;
