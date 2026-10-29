# Phase 4C Summary

Phase 4C implements a local, bilingual Excel input channel at `/th/import` and `/en/import`. Excel never writes directly to the ledger: every fact is parsed into `import_staging_records`, mapped to configured masters, validated, classified for duplicates/conflicts, summarized, reconciled, reviewed, and only then committed transactionally as `SUBMITTED` records.

## Delivered

- Versioned profiles: `VET_CMU_FINANCIAL_WORKBOOK_V1` and `GENERIC_PERIODIC_FINANCIAL_TEMPLATE_V1`.
- `.xlsx` extension, size, empty/corrupt workbook and SHA-256 checks.
- Source lineage through worksheet, row, column and cell.
- Exact master mapping without fuzzy Unit creation or assumed calendar dates.
- Shared money normalization, budget-scope safety, record grain, KPI and reconciliation services.
- Blank remains unavailable; numeric zero becomes `0.00`.
- `NEW`, `EXACT_DUPLICATE`, and `CONFLICT` handling; no overwrite action.
- Preview, financial summary, 468/1/467 original-workbook reconciliation, confirmation, cancellation, audit and history.
- Transactional all-or-nothing commit with staging retained for diagnostics.
- Future-period template and isolated TEST_ONLY UAT workbook.

## Boundaries

Import is development/local only and uses demo Admin authorization. Production authentication, profile administration, approval workflow, cloud storage and deployment remain outside Phase 4C. Imported facts are submitted previews under the same policy used by Web Data Entry; they are not silently approved.
