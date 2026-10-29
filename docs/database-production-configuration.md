# Database Production Configuration

Use PostgreSQL/Supabase with `pgcrypto`, TLS-required pooled application connections, a migration owner distinct from runtime roles, least-privilege authenticated/runtime access, and a server-only service account only for operations that genuinely require it. Apply numbered migrations in lexical order, then production structural seeds only. Never run demo reset/seed against production.

Required controls: RLS enabled and validated with user claims; constraints/triggers preserved; workflow/audit append-only enforcement; indexed period/Unit/scope/metric/status/time queues; encrypted backups; monitoring; connection and statement limits. Test clean migration, upgrade clone, rollback/forward-fix and restore before every production release.

