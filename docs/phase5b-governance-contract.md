# Phase 5B Governance Contract

Phase 5B builds on authenticated profile IDs, capabilities, Unit/Faculty grants, immutable audit, and DRAFT/SUBMITTED records. Submission requires `financial.submit`; approval/rejection will require dedicated capabilities; locking/unlocking requires `period.lock`/`period.unlock`; adjustments/reversals require `financial.adjust`/`financial.reverse`.

Decisions required: eligible APPROVER scope, self-approval, importer/approver separation, lock/unlock authority, rejection reasons, correction evidence, and terminal states. Recommended: submitter ≠ approver, importer ≠ approver, Admin ≠ automatic approver, explicit scope grants, mandatory reasons, append-only decision audit, and no mutation of approved facts. Phase 5A does not assign or expose these capabilities.
