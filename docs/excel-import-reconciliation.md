# Excel Import Reconciliation

Before confirmation, staging revenue and expense are summarized by scope, period and Unit. Operating Result is derived as Revenue minus Expense. When both Faculty and Unit rows exist, the existing reconciliation service compares Faculty Total to Unit Sum without forcing a match.

The original workbook Q2/69 regression is:

| Metric | Difference |
|---|---:|
| Revenue | 468.00 |
| Expense | 1.00 |
| Operating Result | 467.00 |

These differences are warnings/context, not balancing entries. No official tolerance is invented. Category-coded government expense rows are summarized separately and never added a second time to general Faculty Expense.
