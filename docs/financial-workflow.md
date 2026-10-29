# Financial Approval Workflow

`DRAFT → SUBMITTED → UNDER_REVIEW → REVIEW_APPROVED → FINAL_APPROVED → LOCKED`

- Data Entry owns preparation and submission.
- REVIEWER starts review and either approves or returns with a required reason.
- FINAL_APPROVER either approves/returns, then explicitly confirms the irreversible lock action.
- Only `LOCKED` (and legacy `APPROVED`) records feed the authoritative dashboard view.
- A returned base submission follows `RETURNED_FOR_CORRECTION → SUBMITTED`.
- A correction follows `ADJUSTMENT_DRAFT → ADJUSTMENT_SUBMITTED → UNDER_REVIEW → REVIEW_APPROVED → FINAL_APPROVED → LOCKED`.

The service and database both reject self-review, self-approval, final approval by ADMIN, approval by an importer, and out-of-scope review.

