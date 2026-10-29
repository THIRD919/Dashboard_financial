# Data Entry User Flow

1. Open the Thai or English Data Entry route.
2. Select a development user context. The server reloads permitted scopes and units.
3. Select reporting scope, year/period, and unit where applicable.
4. Enter one or more base values. Blank means missing data; `0` is a valid reported value.
5. Select the budget scope. `UNKNOWN` is accepted but excluded from annual budget KPI interpretation.
6. Enter a source reference and optional notes.
7. Use **Calculated automatically** to preview Operating Result, Operating Margin, Financial Liquidity, and Revenue Achievement through the shared KPI engine.
8. Save as Draft, Save & Add Another, or open Review Before Submit.
9. Confirming submission writes the normalized records as `SUBMITTED`. Existing draft batches can also be submitted from the records table.
10. Submitted records are read-only. Corrections after submission require a future governed review/adjustment workflow.

Duplicate detection is performed before the transaction and is enforced again by the database grain constraint. Existing records are never overwritten.
