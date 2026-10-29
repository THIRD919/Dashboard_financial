# ADR-006: Staging Before Import

- Status: Accepted
- Decision: Every Excel upload passes through batch, isolated staging, validation, preview and authorized transactional confirmation.
- Rationale: Direct spreadsheet-to-ledger writes risk invalid mappings, duplicates, malicious files and unaudited changes.
- Consequences: Staging may be discarded before commit; confirmed changes need lineage and controlled reversal, not deletion.

