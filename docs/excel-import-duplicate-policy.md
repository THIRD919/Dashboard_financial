# Excel Import Duplicate Policy

- **Repeated file:** SHA-256 lookup warns and shows the previous date/status/user. It does not automatically block a legitimate reviewed retry.
- **NEW:** no current submitted/approved/locked ledger record at the same business grain; eligible to import.
- **EXACT_DUPLICATE:** same grain and amount; displayed and skipped.
- **CONFLICT:** same grain with a different amount; blocks confirmation.

There is no overwrite option. Phase 4C does not invent adjustment authority. Existing submitted or approved history remains immutable; future adjustment/reversal decisions belong to the governed financial lifecycle.
