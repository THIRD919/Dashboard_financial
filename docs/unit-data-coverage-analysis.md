# Unit Data Coverage Analysis

## Office finding

For **สำนักงาน คณะสัตวแพทยศาสตร์** the workbook provides exactly one unit record in `รายรับรายจ่ายกำไร_ย่อย!A2:F2`: Revenue 18,542,474; Expense 14,354,999; Operating Result 4,187,475. Budget/actual pairs are in `ประมาณการรายรับกับรายรับจริง_แย!A2:D2` and `ประมาณการรายจ่ายกับรายจ่ายจริงแ!A2:D2`. Their headers explicitly identify actuals as Q2.

The workbook provides no unit-period column and no additional Office rows for Q3/68, Q4/68 or Q1/69. The extraction therefore assigns this single aligned record to Q2/69 and does not fabricate history.

## Why sections were missing

| Missing behavior | Determined cause | Evidence / disposition |
|---|---|---|
| Unit trend | Missing historical Unit records | Only one unit table/row per unit exists; no period dimension. Phase 3.1 correctly avoided showing the Faculty trend as Unit history. |
| Unit Financial Liquidity | Missing liquidity-by-unit records and reporting scope | Unit source has no Current Assets or Liabilities. `F2 = B2/C2` is Revenue / Expense, despite a misleading ratio-style label; it cannot feed Financial Liquidity. |
| Unit Government Budget | Reporting scope | Government sheets are labelled Faculty total and contain no unit key. |
| Non-Q2 Unit KPI cards | Missing historical records plus prototype filtering | The extractor marks unit data Q2/69 only; the UI intentionally shows No Data for other selected periods. |

This is not a calculation defect or accidental extraction omission. The earlier Unit trend behavior was a deliberate scope safeguard. Phase 3.2 now adds completeness detail and an Annual YTD view: Office shows 1/4 periods for year 69 and sums only that available record.

## Future-data proof

The `TEST_ONLY_COMPLETE_UNIT` fixture supplies four unmistakably synthetic periods only to automated tests. Tests confirm that four valid unit records automatically generate three flow series, annual Revenue/Expense, Operating Result computed as Revenue − Expense, annual Margin, latest-period liquidity, and safe budget handling. No TEST_ONLY value is imported by the application or written to `data/prototype-financial-data.json`.
