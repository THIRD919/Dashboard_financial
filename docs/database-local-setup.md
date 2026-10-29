# Local Database Setup

## Embedded validation (no services required)

```bash
npm install
npm run test:database
```

This creates an ephemeral local PostgreSQL-compatible database, runs all migrations/seeds, executes integration tests, and discards it. TEST_ONLY facts never enter application data.

## PostgreSQL 15+

Create a local database and set `DATABASE_URL` from `.env.example`. Apply every file in `database/migrations` in filename order, then `database/seeds`. Use a migration runner that stops on the first error and records applied filenames. Never use production credentials in `.env` or commit secrets.

## Optional local Supabase

Install the Supabase CLI separately, run `supabase init` and `supabase start`, then apply the same ordered PostgreSQL migrations to the local connection. RLS is included, but Phase 4A does not configure hosted projects or production keys.
