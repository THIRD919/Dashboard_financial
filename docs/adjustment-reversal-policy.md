# Adjustment and Reversal Policy

Approved history is never overwritten.

- **Adjustment:** a signed delta referencing the original record and an open correction request. Example: expense `+20,000` changes the authoritative total from `700,000` to `720,000` while the original remains `700,000`.
- **Reversal:** an exact negative offset referencing the original through both `adjusts_record_id` and `reverses_record_id`. Example: `100,000` is corrected by `-100,000`, net `0`.

The request identifies its reason, requester, original Data Entry assignee, original record, type, and completion status. Corrections must match the original period, scope, Unit, metric, and category.

