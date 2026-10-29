# Backup and Restore Test

Command: `npm run backup:test` (same isolated proof behind `npm run restore:test`). It refuses production and uses a fresh temporary PGlite database.

Test procedure: migrate + demo structural fixtures; create/approve/lock Office Q2/69; approve/lock expense Adjustment +20,000; approve/lock NOVEL Reversal −100,000; close database; copy backup; calculate SHA-256; delete source (simulated loss); restore to a new location; reopen and verify records, profiles, roles, Unit grants, approvals, locks, events, audit, corrections and references; delete temporary material.

Result 2026-08-10: **PASS**. Sample backup checksum `f6a66762d5da70f65e4e0b33dd670cd322e28a535fb528f124af010359f704da` (each run differs). Restored: revenue 1,000,000; expense 720,000; result 280,000; margin 28.0%; liquidity 2.00x; reversal net 0. Backup payload and metadata are temporary and not committed.

