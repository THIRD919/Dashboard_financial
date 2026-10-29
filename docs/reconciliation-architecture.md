# Reconciliation Architecture

Reconciliation is a governed result, not a side-effect of dashboard code.

## Calculation

For each approved reporting period and relevant metric:

- Faculty Total = authoritative current approved/locked `FACULTY` entries.
- Unit Sum = authoritative current approved/locked `UNIT` entries summed across active/in-scope units.
- Difference = Faculty Total − Unit Sum.
- Difference % = Difference / Faculty Total; if faculty total is zero, store null and an explicit reason.
- Tolerance comes from an effective-dated, approved `reconciliation_rules` row. No rule means any non-zero difference is `REVIEW_REQUIRED`, not an implied zero tolerance policy.

Status precedence:

1. exact zero → `MATCHED`;
2. within an approved absolute and/or percentage rule → `WITHIN_TOLERANCE`;
3. otherwise → `REVIEW_REQUIRED`;
4. authorized reviewer with explanation/resolution → `RESOLVED` while original figures remain.

## Stored snapshot

`reconciliations` stores period, metric, both totals, difference, percentage, tolerances actually applied, status, calculation version, batch lineage, explanation/resolution, reviewer and time. Storing the snapshot makes later rule/data changes auditable; recalculation creates a new calculation version rather than erasing prior evidence.

## Triggers

Run after a successful import, approval, adjustment/reversal, and period-close review. For interactive previews, calculate provisionally without writing authoritative reconciliation state.

## Access

Executives/authorized reviewers with faculty access see all reconciliations. Unit users may see their own contribution and a generic “reconciliation pending” state, but not other units or faculty totals unless granted. Resolution needs `reconciliation.review` and must write an audit event.

## Phase 1.1 traceability fixture

The test/acceptance pack must retain Q2/69 expected differences without seeding confidential values into external systems: Revenue 468, Expense 1, Operating Result 467. The approved migration, if authorized later, will preserve faculty and unit records independently and generate these reconciliation results. No automatic adjustment is permitted.

