# Disaster Recovery

Proposed objectives: RPO ≤24h, RTO ≤4h — **FACULTY APPROVAL REQUIRED**.

| Scenario | Response |
|---|---|
| Database corruption/deletion | stop writes, preserve evidence, select verified backup/PITR, restore isolated, reconcile, authorize cutover |
| Failed deployment | route traffic to prior app release; forward-fix schema if irreversible |
| Credential compromise | revoke/rotate, terminate sessions, review security/audit events, notify governance owner |
| Supabase outage | status communication, prevent unsafe local writes, restore when provider returns or invoke approved DR target |
| Storage loss | restore encrypted private objects and verify hashes |
| Incorrect migration | stop migration, restore pre-migration clone or forward-fix; never down-migrate posted ledger history casually |
| Unauthorized modification | preserve audit evidence, lock access, quantify impact, issue governed correction/reversal |

