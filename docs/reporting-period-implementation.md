# Reporting Period Implementation

`reporting_years` is the stable year dimension. `reporting_periods` supports MONTH, QUARTER, YEAR and CUSTOM, optional parent, dates, source/display labels, ordering, active/locked state and metadata. A cycle-prevention trigger protects the hierarchy.

Seeds preserve Q3/68, Q4/68, Q1/69 and Q2/69 as source labels. Other Q1–Q4 nodes are expected-period configuration only and explicitly marked NOT_AVAILABLE; no dates or month mapping are inferred. YEAR parents expect four configurable child periods.

Period locks reject new BASE facts. Adjustments/reversals remain possible as explicit controlled corrections for later authorization workflows.
