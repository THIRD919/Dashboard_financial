# Phase 4B Data Entry Contract

## Required fields

Reporting scope, reporting period, Unit for UNIT scope, metric, amount, currency, source type/reference, record status, and actor. Budget metrics additionally require explicit budget scope; UNKNOWN is allowed but annual KPI use is blocked.

## Optional fields

Category, notes and source cell/row lineage. Adjustment/reversal fields are optional only for BASE; corrections require original record, unique adjustment reference and reason.

## Validation and duplicates

- Decimal money with at most two places; never floating-point persistence.
- FACULTY has no Unit; UNIT requires an authorized active Unit.
- Active, unlocked period for ordinary BASE entry.
- One current BASE per period/scope/unit/metric/category.
- Source record keys and adjustment references are unique.
- Missing is absence, not a zero row; zero remains a valid entered value.
- Budget scope may not be inferred.

## Workflow

Statuses: DRAFT → SUBMITTED → APPROVED → optionally LOCKED; REJECTED returns for correction. Approved history is immutable. Corrections use separately submitted/approved ADJUSTMENT or REVERSAL. Phase 4B must check capability, Unit write grant, period lock and separation-of-duties policy before mutation, and append an audit event for every workflow action.
