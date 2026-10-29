# Phase 5B UAT Guide

Run `npm run demo:auth`, then use password `VetCmu-Test-Only-2569` for these TEST_ONLY users:

- `office.reviewer.test@local` — Office Reviewer
- `secretary.reviewer.test@local` — Faculty Secretary Reviewer
- `vicedean.approver.test@local` — Final Approver

Primary scenario: Data Entry submits Office Q2/69 revenue 1,000,000; expense 700,000; current assets 500,000; liabilities 250,000. Reviewer approves, Vice Dean final-approves and locks. Confirm official result 300,000, margin 30%, liquidity 2.00x. Request expense adjustment +20,000, approve and lock it; confirm expense 720,000, result 280,000, margin 28%. Also reverse a 100,000 locked record with −100,000 and confirm net zero.

Negative tests: submitter cannot review; Reviewer and ADMIN cannot final-approve; unauthorized Unit review fails; locked updates/deletes and ordinary locked-scope entry/import fail.

