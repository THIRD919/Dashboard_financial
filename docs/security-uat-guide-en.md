# Phase 5C Security UAT Guide

Run the local demo; verify Admin cannot final-approve, Office Data Entry is Office-only, Reviewer cannot enter Final Approval, and Vice Dean can explicitly approve and lock. Confirm locked data rejects ordinary edit/delete/import and the dashboard is official-only. Run `npm run backup:test`, `npm run test:security`, `npm run test:production-bootstrap`, and `pnpm build`. The backup output must show PASS/PASS and exact restored values. A production build with Demo Auth enabled must refuse startup. Never use production or confidential data.

