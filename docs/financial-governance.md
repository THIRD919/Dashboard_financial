# Financial Governance Controls

| Control | Enforcement |
|---|---|
| Two-level approval | REVIEWER then FINAL_APPROVER capabilities |
| Administrative separation | ADMIN receives no final-approval capability |
| Self-approval prevention | actor, creator/importer, reviewer, and final approver checks |
| Unit scope | `user_unit_access` plus server checks |
| Official-data boundary | authoritative view includes locked records only (plus legacy approved history) |
| Immutable history | update/delete database triggers |
| Scoped lock | unique period + Faculty/Unit lock record |
| Corrections | correction request plus referenced adjustment/reversal |
| Traceability | workflow events, audit logs, timestamps, comments, notifications |

The local Demo Auth accounts are UAT fixtures only, not a production authentication mechanism.

