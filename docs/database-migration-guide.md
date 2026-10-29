# Database Migration Guide

Migrations are immutable after shared use. Add a new numbered file; never rewrite a deployed migration. Apply in lexical order inside a clean database and fail fast. Configuration seeds use stable codes and `ON CONFLICT` for safe repetition.

Order: extensions/types → profiles/RBAC → Units → reporting hierarchy → financial/KPI masters → financial ledger → aggregation → reconciliation → imports → audit → RLS. Seeds follow all migrations.

Before promotion: run clean migration tests, inspect NUMERIC types, verify constraints/views/functions, run service regressions, back up the target, and record migration checksum/time/operator. Rollback should use a reviewed compensating migration; never delete approved financial history.
