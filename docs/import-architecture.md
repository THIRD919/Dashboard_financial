# Excel Import Architecture

## Pipeline

```mermaid
flowchart LR
  U["Upload"] --> B["Import Batch"] --> S["Isolated staging"] --> V["Validate"] --> P["Preview"] --> C["Authorized confirmation"] --> T["Single DB transaction"] --> R["Reconciliation"] --> A["Audit"]
```

## Steps

1. **Upload:** authenticated user with `import.create`; allowlisted `.xlsx`; random storage key; retain original name as metadata; calculate SHA-256 and size; malware/zip-bomb scan; never execute macros or external links.
2. **Batch:** create `import_batches` with uploader, hash, template version and `UPLOADED` status. Object is private and short-retention.
3. **Parse/stage:** server-side parser reads values/formulas only as needed; each row/cell range becomes `import_staging_records.raw_payload` plus typed parsed candidates. No authoritative insert.
4. **Validate:** template/version, required columns, source aliases, periods, units, metric/category codes, NUMERIC parsing, scope/unit consistency, duplicate fingerprint, totals, zero denominators and locked-period checks.
5. **Issues:** errors block confirmation; warnings require acknowledgment. `import_issues` stores bilingual codes/messages and evidence.
6. **Preview:** show counts, mappings, transformations, new/changed/duplicate rows, faculty-vs-unit reconciliation forecast and validation summary. Preview obeys unit access.
7. **Confirm:** separate `import.approve` capability; revalidate in the transaction to prevent stale-preview races.
8. **Commit:** create versioned BASE/ADJUSTMENT entries and `import_commits`; set batch CONFIRMED; all-or-nothing transaction for the selected confirmation set.
9. **Post-commit:** calculate reconciliation snapshots, write audit events and queue safe cache invalidation.

## Duplicate detection

- File duplicate: SHA-256, size and uploader/source context. The hash is indexed for detection but intentionally not unique, so an authorized retry or later reprocessing is not blocked by a premature constraint.
- Row duplicate: canonical fingerprint of scope, source period label, unit alias, metric, category, amount and source cell.
- Ledger duplicate: current BASE natural-grain index.
- Same grain/different amount is not silently updated; preview as conflict requiring correction/version or adjustment path.

## Failure and rollback

- Parser/validation failure leaves staging and issues; no financial record exists.
- Confirmation transaction failure rolls back every ledger mapping and status change.
- After successful confirmation, “rollback” creates a controlled rollback batch/reversal entries linked to the original; it does not delete approved history.
- Retrying is idempotent through batch state, fingerprints and `import_commits` uniqueness.

## Traceability

Every committed record retains `source_type=EXCEL_IMPORT`, batch ID, worksheet/cell reference, original file hash and staging-to-ledger mapping. The current Q2/69 discrepancies may later be imported as separate faculty/unit facts and reconciliation results, never as balancing adjustments.
