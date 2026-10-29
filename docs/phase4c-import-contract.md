# Phase 4C Import Contract (Forward Contract Only)

Phase 4B does not implement Excel import. A future importer must produce the same normalized write contract used by web entry:

- reporting scope and authorized unit (or Faculty/null unit)
- active reporting period
- metric code mapped to a master metric
- decimal amount in THB with two-place precision
- explicit budget scope where applicable
- source type, source reference, and stable source record key
- notes, record status, actor/import batch, and audit metadata

The importer must stage and validate rows before committing, preserve blank-versus-zero semantics, reject duplicate base grain, avoid overwriting current records, and expose row-level errors. Committed rows must use the same status, audit, locking, adjustment, and dashboard projection rules as web-entered rows. Final column mappings and workbook-specific transformations require Phase 4C analysis and Faculty confirmation where business rules remain unresolved.
