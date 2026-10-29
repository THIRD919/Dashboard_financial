# Permission Matrix

This is the proposed Version 1 role baseline. A checkmark is not sufficient by itself: financial access also requires a matching `user_unit_access` grant and compatible workflow state.

| Capability | VIEWER | EXECUTIVE | DATA_ENTRY | ADMIN |
|---|:---:|:---:|:---:|:---:|
| `dashboard.view` | ✓ | ✓ | optional | ✓ |
| `financial.view` | ✓ | ✓ | ✓ | ✓ |
| `financial.create` | — | — | ✓ | optional |
| `financial.update` | — | — | ✓ | optional |
| `financial.delete` (soft-delete draft/request correction) | — | — | limited | optional |
| `financial.submit` | — | — | ✓ | optional |
| `financial.approve` | — | ✓ if designated approver | — | optional |
| `financial.lock` | — | designated executive | — | optional |
| `import.create` | — | — | ✓ if assigned | ✓ |
| `import.approve` | — | designated executive | — | ✓ |
| `reconciliation.view` | optional | ✓ | own units | ✓ |
| `reconciliation.review` | — | ✓ if assigned | — | ✓ |
| `users.view` | — | — | — | ✓ |
| `users.manage` | — | — | — | ✓ |
| `roles.manage` | — | — | — | ✓ |
| `units.manage` | — | — | — | ✓ |
| `calendar.manage` | — | — | — | ✓ |
| `kpi.manage` | — | — | — | ✓ |
| `audit.view` | — | designated executive/auditor | — | ✓ |
| `system.manage` | — | — | — | ✓ |

## Unit-access modifier

- `FACULTY + can_read`: may read faculty totals and all unit rows when capability permits.
- `FACULTY + can_write`: highly privileged; may write faculty-scope records and, only if policy says so, unit rows.
- `UNIT + unit_id + can_read`: may read that unit's records only; it does not reveal faculty totals or peers.
- `UNIT + unit_id + can_write`: may create/edit eligible records for that unit only.
- No unit grant means no financial row access even if the role has `financial.view`.
- A role never expands unit scope implicitly. Provisioning EXECUTIVE or ADMIN must create explicit grants.

Suggested capability additions beyond the prompt are `financial.submit`, `financial.lock`, `reconciliation.view`, `reconciliation.review`, and `calendar.manage`; they prevent overloading broader permissions.

