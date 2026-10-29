# Vet CMU Financial Dashboard — Phase 5C Staging-Ready Foundation

This repository contains the bilingual Vet CMU financial dashboard and the Phase 5B two-level financial approval, lock, adjustment/reversal, authentication, and access-control foundation. The workbook itself is never modified.

For authenticated stakeholder UAT, run `npm run demo:auth` and open `http://localhost:3000/th/login`. See [Thai instructions](docs/auth-uat-guide-th.md) or [English instructions](docs/auth-uat-guide-en.md). Demo Auth is TEST_ONLY and is disabled in production builds.

## Run locally

Requirements: Node.js 20.9 or newer, npm, and Python 3.

```bash
npm install
npm run extract-data
npm run test:financial
npm run test:annual
npm run test:database
npm run test:data-entry
npm run dev
```

Open `http://localhost:3000` (redirects to Thai) or use:

- `http://localhost:3000/th/dashboard`
- `http://localhost:3000/en/dashboard`
- `http://localhost:3000/th/data-entry`
- `http://localhost:3000/en/data-entry`
- `http://localhost:3000/th/import`
- `http://localhost:3000/en/import`
- `http://localhost:3000/th/login`
- `http://localhost:3000/en/login`
- `http://localhost:3000/th/admin`
- `http://localhost:3000/en/admin`
- `http://localhost:3000/th/review`
- `http://localhost:3000/th/approval`
- `http://localhost:3000/th/tasks`

Production validation:

```bash
npm run typecheck
npm run build
npm start
```

Security and recovery validation:

```bash
pnpm test:security
pnpm test:production-bootstrap
pnpm backup:test
pnpm test:performance
```

Production refuses Demo Auth, demo passwords/session secrets, prototype financial data, public-prefixed secrets, test-user seeding and destructive reset/restore operations. Phase 6 production deployment has not occurred.

`npm run build` refreshes the Excel-derived JSON before building. The data snapshot includes the source workbook SHA-256 hash for traceability.

## Current scope

Implemented: bilingual executive dashboard, granular data entry, staging-first Excel import, role/Unit access control, Reviewer and Vice Dean approval, scoped period locks, official-only dashboard data, correction requests, immutable adjustments/reversals, tasks, notifications, workflow events, and append-only audit logging.

Not implemented: production authentication/CMU SSO, hosted production database, public deployment, Phase 5C hardening, or approved KPI thresholds.

The dashboard still uses the prototype provider by default. Set `DASHBOARD_DATA_PROVIDER=database` only for a populated local development database. See [docs/database-local-setup.md](docs/database-local-setup.md) and [docs/phase4b-summary.md](docs/phase4b-summary.md).

See [docs/phase3-prototype.md](docs/phase3-prototype.md) for design, data and limitation details.

## MANUAL PHASE 4B TEST

Start the complete isolated stakeholder demo with one command:

```bash
cd /Users/ninu/Desktop/Project_codex/Dashboard_financial
npm run demo
```

The demo is pinned to port 3000. If that port is already occupied, stop the older Dashboard terminal and rerun the command; the demo will not silently move to a different port.

Then open:

- Thai Data Entry: `http://localhost:3000/th/data-entry`
- English Data Entry: `http://localhost:3000/en/data-entry`
- Thai Dashboard: `http://localhost:3000/th/dashboard`
- Thai Excel Import: `http://localhost:3000/th/import`
- English Excel Import: `http://localhost:3000/en/import`

For import UAT, upload `templates/TEST_ONLY_Vet_CMU_Office_Q2_69.xlsx`. The future-period workbook is `templates/Vet_CMU_Financial_Import_Template.xlsx`. Both are processed locally; Excel staging is never visible to the Dashboard before confirmation.

Select **เจ้าหน้าที่สำนักงาน**, Unit **สำนักงาน คณะสัตวแพทยศาสตร์**, and **Q2/69**. Use the values in [docs/manual-data-entry-test-th.md](docs/manual-data-entry-test-th.md).

To clear all local manual `TEST_ONLY` records and rebuild only the safe fixtures:

```bash
npm run demo:reset
```

`ENABLE_DEMO_AUTH` is off unless explicitly set and is rejected when `NODE_ENV=production`. This local bypass is not production authentication.
