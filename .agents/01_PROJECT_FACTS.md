# Project Facts

## Identity

- Package: `vet-cmu-financial-dashboard-prototype`
- Version: `0.3.0` (`package.json`)
- Product: bilingual Thai/English financial dashboard for Faculty of Veterinary Medicine, Chiang Mai University
- Runtime requirement documented in README: Node.js 20.9+, npm, Python 3

## Technology stack

- Next.js `16.2.11`, React/React DOM, TypeScript `5.9.3`
- Tailwind CSS `4.3.3` via PostCSS
- PostgreSQL-compatible SQL schema with Supabase SSR/JS dependencies
- PGlite `0.5.4` local database provider with `pgcrypto`
- ExcelJS and JSZip for spreadsheet import/export processing
- Recharts for dashboard charts; lucide-react for icons
- Tests are Node `.mjs` scripts and TypeScript typecheck uses `tsc --noEmit`

## Runtime modes found

- Prototype data provider is the default.
- `DASHBOARD_DATA_PROVIDER=database` selects the local database provider.
- `ENABLE_DEMO_AUTH=true` is guarded to non-production environments.
- Local PGlite uses `database/.local/pglite` and applies migrations/seeds through `scripts/check-database-migrations.mjs`.
- A hosted production database connection/configuration is not found in the inspected application source.

## Primary domains

Authentication/authorization, organizational scope, reporting periods, financial records, KPI calculation, annual aggregation, reconciliation, Excel staging/import, approval workflow, audit logging, bilingual UI.

## Evidence anchors

`package.json`, `README.md`, `app/`, `components/`, `lib/`, `database/`, `tests/`, `docs/`

