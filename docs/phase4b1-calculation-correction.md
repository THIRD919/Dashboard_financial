# Phase 4B.1 Calculation Correction

## Root cause

The formulas and centralized financial engine were correct. The failed result `-600,000 / -600%` proves that the engine received partial Actual Revenue of `100,000` with Actual Expense `700,000`.

Two conditions allowed this:

1. Monetary controls depended on a render-timed React state snapshot. A visible input could be ahead of that snapshot during rapid/IME-style entry, so preview could receive a partial value.
2. `npm run demo` allowed Next.js to silently choose port 3001 when a stale project server occupied port 3000. The stakeholder guide still opened port 3000, so the tested client could be the stale process with an older in-memory database and client state.

No database, budget fixture, or DatabaseDataProvider value is used by the unsaved preview. Budget fixture rows were inspected and remain separate `BUDGETED_*` metrics.

## Correction

- The form-to-domain adapter now assigns Revenue Budget, Revenue Actual, Expense Budget, and Expense Actual explicitly.
- Monetary controls synchronize on both change and direct input events.
- Preview calculation is client-local over the current form snapshot while still calling the centralized KPI engine; it no longer waits for a Server Action round trip.
- Budget blanks normalize to `null`, not zero or fixture values.
- Thai labels now explicitly include their parent metric, such as `รายรับ — ผลจริง`.
- The demo command pins port 3000 and fails visibly if it is occupied instead of silently starting another port.
- The trace regression covers mapping, parsing formats, blank/zero semantics, positive/negative/break-even cases, zero-revenue NA, Thai rendering, and the approved formulas.

## Verified trace

`1,000,000.00`, `700,000.00`, `500,000.00`, and `250,000.00`, with both budgets blank, produce `300,000.00 บาท`, `30.0%`, and `2.00 เท่า`. Draft save, refresh, reopen, submission, read-only status, and the Office Unit database dashboard were retested in a clean browser session.
