# Future Import Template Guide

Use `templates/Vet_CMU_Financial_Import_Template.xlsx`. The `Financial Data` sheet uses one authoritative fact per row:

`Reporting Scope | Reporting Period | Unit Code | Metric | Budget Scope | Amount | Category Code | Notes | Source Reference | TEST_ONLY`

Enter quarter facts at the most granular available scope. Do not enter annual totals when they can be derived. Do not enter derived KPIs. Use the Codebook sheet for stable codes. Leave `Budget Scope` blank for non-budget metrics; use `UNKNOWN` only for a budget whose source does not establish annual versus period scope.

The workbook includes bilingual instructions, input highlighting, dropdown validation and explicit two-decimal money formatting.
