# Feature: Dashboard and KPI

Dashboard pages are under `app/[locale]/dashboard/page.tsx` and render `components/executive-dashboard.tsx`. Data can come from the prototype JSON provider or database provider. KPI calculation is centralized in `lib/financial/kpi-engine.ts`; annual aggregation is in `lib/financial/annual-aggregation-service.ts` and `lib/annual-reporting.mjs`.

The dashboard supports bilingual locale routes and scope/unit selection. Scope isolation is covered by `tests/dashboard-scope-isolation.test.mjs` and related database views/functions.

Exact production data freshness/SLA: ไม่พบข้อมูล.

