import { getLocalDatabase } from "@/lib/database/local-pglite";

export async function GET() {
  if (
    process.env.NODE_ENV !== "development" ||
    process.env.ENABLE_DEMO_AUTH !== "true"
  )
    return new Response("Not found", { status: 404 });
  const db = await getLocalDatabase();
  const units = await db.query<{ code: string; nameTh: string }>(
    `select code,name_th "nameTh" from app.organizational_units where active order by display_order,code`,
  );
  const activeUnitCodes = units.rows.map((unit) => unit.code);
  return Response.json({
    dataProvider: process.env.DASHBOARD_DATA_PROVIDER ?? "prototype",
    demoUserRole: "EXECUTIVE_OR_ADMIN",
    activeUnitCount: units.rows.length,
    activeUnits: units.rows,
    authorizedUnitCodes: activeUnitCodes,
    dropdownUnitCodes: ["FACULTY", ...activeUnitCodes],
  });
}
