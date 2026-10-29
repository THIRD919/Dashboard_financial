# Unit Access Model

`user_unit_access` is many-to-many. Capabilities define what a user may do; grants define where. `UNIT + can_read/can_write` targets one Unit. `FACULTY` is explicit and supports Faculty records and all-Units read. An all-Units read grant never implies write. Deactivating a Unit preserves historical records.
