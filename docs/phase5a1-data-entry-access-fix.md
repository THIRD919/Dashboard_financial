# Phase 5A.1 DATA_ENTRY Access Fix

## Root cause

Migration 017 attempted to assign the Phase 5A role matrix before fresh-demo seeds created the roles. Consequently a clean `demo:auth` database left DATA_ENTRY with the legacy capabilities `financial.create`, `financial.submit`, `financial.update`, `financial.view`, and `import.create`. It lacked `dashboard.view`, `financial.update_draft`, and `financial.delete_draft`. ADMIN masked the ordering defect because the legacy seed granted it every permission.

Migration 019 repairs upgraded databases and seed 007 applies the exact matrix after role creation on clean databases. DATA_ENTRY now has exactly: `dashboard.view`, `financial.view`, `financial.create`, `financial.update`, `financial.update_draft`, `financial.submit`, and `financial.delete_draft`. It does not receive import, Admin, Executive, all-Unit, or Faculty permissions.

## Routing and dashboard behavior

Post-login and access-denied navigation share `getAuthorizedLandingPage`. Users with dashboard capability and a readable grant land on Dashboard; users without any authorized scope see the dedicated bilingual no-authorized-Units page. Forbidden includes both an authorized-home link and Sign Out, eliminating the Dashboard/Forbidden loop.

Unit-only Dashboard data is filtered before rendering, initializes to the first authorized Unit, and omits the Faculty option. Office therefore starts at VET-OFFICE, shows 0/4 and No Data when empty, and never falls back to Faculty facts.

## Browser route trace

Clean `npm run demo:auth`, same browser:

1. Admin login → `/en/dashboard` → logout.
2. Office login → `/th/dashboard`; header `ระดับหน่วยงาน / สำนักงาน คณะสัตวแพทยศาสตร์`; selector contains Office only; navigation contains Dashboard, Financial Analysis, Unit Performance, and Data Entry.
3. `/th/data-entry` allowed and Office-only.
4. `/th/admin` denied → `/th/forbidden`; authorized-home returns `/th/dashboard` without a loop.
5. `/th/import` denied → `/th/forbidden`.
6. Office logout → Executive login → `/th/dashboard`; Executive navigation recalculated to the three read-only sections.

Automated `test:data-entry-access` verifies the exact capability list, Office-only grant, Office write success, NOVEL/Faculty write denial, Unit-default source contract, and safe landing helper.
