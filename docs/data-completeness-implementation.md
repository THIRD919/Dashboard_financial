# Data Completeness Implementation

The database distinguishes AVAILABLE, PARTIAL, NOT_AVAILABLE and NOT_APPLICABLE. No missing period creates a zero fact.

`app.period_completeness(year, scope, unit)` returns available and expected counts, missing period codes, completion ratio and FULL_YEAR/PARTIAL_YEAR. Scope and Unit are explicit inputs. A period is available only when authoritative records exist at that exact scope.

Application annual results repeat the same semantics and disclose partial/YTD state. Expected-period configuration is independent of quarter-to-month mapping.
