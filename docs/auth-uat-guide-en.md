# Authentication UAT Guide

Run `npm run demo:auth`, then open `http://localhost:3000/en/login`. All TEST_ONLY accounts use `VetCmu-Test-Only-2569`: `admin.test@local`, `executive.test@local`, `office.dataentry.test@local`, `novel.dataentry.test@local`, and `viewer.test@local`.

Verify Admin can manage users/audit; Office can write only VET-OFFICE; NOVEL only NOVEL; Executive can read but cannot enter/import/administer; Viewer is read-only. Never use these credentials or Demo Auth in production.

Expected Office landing: `/th/dashboard` (Thai preference), Unit scope, Office selected as the only Unit, 0/4 and No Data when empty, and no redirect loop from Access Denied.
