# Backup Policy

Recommended, not yet provider-enabled: encrypted automated PostgreSQL backup daily; retain 7 daily, 4 weekly and 12 monthly copies; maintain provider/off-site redundancy. Include profiles/configuration, audit/workflow, import metadata and private workbook objects if retention is approved. Verify checksum and job result; restore-test quarterly and before material migrations.

Uploaded originals are not currently retained; only hash, filename, size, uploader, timestamp and staging provenance are retained. If Faculty requires originals, use private storage with scoped retrieval, encryption and an approved retention schedule—never public URLs.

RPO ≤24 hours and RTO ≤4 hours are proposals: **FACULTY APPROVAL REQUIRED**. PITR is **plan-dependent and not enabled** until a hosting plan is selected.

