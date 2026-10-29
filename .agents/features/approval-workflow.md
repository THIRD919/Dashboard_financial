# Feature: Approval Workflow

Documented/source states include `DRAFT → SUBMITTED → UNDER_REVIEW → REVIEW_APPROVED → FINAL_APPROVED → LOCKED`; correction paths use returned/adjustment states. Data entry prepares/submits, reviewer reviews/returns, and final approver approves/locks. Self-review/self-approval, ADMIN final approval, importer approval and out-of-scope review are rejected according to service/docs evidence.

Implementation anchors: `lib/workflow/submission.ts`, `lib/workflow/correction.ts`, `lib/workflow/service.ts`, `app/[locale]/review/actions.ts`, `app/[locale]/approval/actions.ts`, migrations `012`, `021`–`025`.

Exact UI transition availability per role should be checked in current actions and tests; no inferred transition should be added from labels alone.

