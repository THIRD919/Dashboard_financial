# Task Map

| Task | Read first | Then inspect source |
|---|---|---|
| Add a page | `architecture/overview.md`, `standards/coding.md` | `app/[locale]`, `components`, `lib` |
| Add an API route | `api/routes.md` | `app/api`, relevant service |
| Change schema | `database/overview.md` | `database/migrations`, `database/schema.sql`, database tests |
| Change financial calculation | `business/rules.md`, `features/dashboard.md` | `lib/financial`, annual tests |
| Change data entry | `features/data-entry.md` | `lib/data-entry`, route actions, tests |
| Change import | `features/excel-import.md` | `lib/import`, import tests, templates |
| Change permissions | `features/auth-access.md`, `database/overview.md` | `lib/auth`, RLS migrations, auth tests |
| Change approval | `features/approval-workflow.md` | `lib/workflow`, route actions, workflow tests |

No documented business behavior should be changed based only on screenshots or workbook artifacts.

