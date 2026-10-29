begin;
insert into app.financial_categories(code,name_th,name_en,metadata) values ('GENERAL','ทั่วไป','General','{}'),('GOVERNMENT_BUDGET','งบประมาณแผ่นดิน','Government Budget','{}'),('EQUIPMENT','ครุภัณฑ์','Equipment','{}'),('CONSTRUCTION','สิ่งก่อสร้าง','Construction','{}') on conflict(code) do nothing;
insert into app.kpi_definitions(code,version,name_th,name_en,classification,calculation_handler,configuration,effective_from,active) values
('FINANCIAL_LIQUIDITY',1,'สภาพคล่องทางการเงิน','Financial Liquidity','DERIVED_BUT_REPRODUCIBLE','financialLiquidity','{"aggregation":"LATEST"}','2026-01-01',true),
('REVENUE',1,'รายรับรวม','Total Revenue','CONFIRMED_FROM_EXCEL','sourceAmount','{"aggregation":"SUM"}','2026-01-01',true),
('EXPENSE',1,'รายจ่ายรวม','Total Expense','CONFIRMED_FROM_EXCEL','sourceAmount','{"aggregation":"SUM"}','2026-01-01',true),
('OPERATING_RESULT',1,'ผลการดำเนินงานสุทธิ','Operating Result','DERIVED_BUT_REPRODUCIBLE','operatingResult','{}','2026-01-01',true),
('OPERATING_MARGIN',1,'อัตราผลการดำเนินงานต่อรายรับ','Operating Margin','DERIVED_BUT_REPRODUCIBLE','operatingMargin','{}','2026-01-01',true),
('REVENUE_ACHIEVEMENT',1,'รายรับเทียบเป้าหมาย','Revenue Achievement','DERIVED_BUT_REPRODUCIBLE','revenueAchievement','{"budget_scope_required":true}','2026-01-01',true),
('EXPENSE_UTILIZATION',1,'รายจ่ายเทียบงบประมาณ','Expense Utilization','DERIVED_BUT_REPRODUCIBLE','expenseUtilization','{"budget_scope_required":true}','2026-01-01',true),
('REVENUE_GROWTH',1,'การเติบโตของรายรับ','Revenue Growth','PROPOSED_FOR_WEB','growth','{"comparison_required":true}','2026-01-01',false),
('EXPENSE_GROWTH',1,'การเติบโตของรายจ่าย','Expense Growth','PROPOSED_FOR_WEB','growth','{"comparison_required":true}','2026-01-01',false),
('OPERATING_RESULT_GROWTH',1,'การเติบโตของผลการดำเนินงาน','Operating Result Growth','PROPOSED_FOR_WEB','growth','{"comparison_required":true}','2026-01-01',false) on conflict(code,version) do nothing;
commit;
