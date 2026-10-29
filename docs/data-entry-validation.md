# Data Entry Validation Rules

| Rule | Treatment |
|---|---|
| Empty monetary input | Stored as no record (`null`), not zero |
| Zero | Valid and stored as `0.00` |
| Numeric format | Digits, optional commas, and at most two decimal places |
| Negative values | Rejected for Phase 4B base entry |
| Non-finite/text values | Rejected |
| At least one amount | Required |
| Source reference | Required |
| Period | Must be active, non-annual, and unlocked |
| Unit | Required for Unit scope and constrained to a writable grant |
| Faculty scope | Requires a Faculty-level writable grant |
| Budget scope | `ANNUAL`, `PERIOD`, or `UNKNOWN`; budget fields require a valid value |
| Duplicate grain | Scope + period + unit/null + metric + base category; rejected, never overwritten |
| Submitted state | Read-only at both service and database-trigger layers |

The server is authoritative. Browser controls and formatting improve usability but do not replace server or database validation.
