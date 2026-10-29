import { getAuthProvider, type AuthIdentity } from "./provider";
import { getLocalDatabase } from "../database/local-pglite";
export class AccessDeniedError extends Error {
  status: number;
  constructor(code = "FORBIDDEN", status = 403) {
    super(code);
    this.status = status;
  }
}
export type AccessContext = {
  identity: AuthIdentity;
  profile: {
    id: string;
    email: string;
    displayName: string;
    preferredLanguage: "th" | "en";
    status: string;
  };
  roles: string[];
  capabilities: string[];
  grants: Array<{
    scope: "FACULTY" | "UNIT";
    unitCode: string | null;
    canRead: boolean;
    canWrite: boolean;
  }>;
};
export async function getAccessContext(): Promise<AccessContext | null> {
  const identity = await getAuthProvider().getIdentity();
  if (!identity) return null;
  const db = await getLocalDatabase(),
    profile = (
      await db.query<any>(
        `select id,email,display_name "displayName",preferred_language "preferredLanguage",account_status status from app.profiles where id=$1 and is_active and account_status='ACTIVE'`,
        [identity.profileId],
      )
    ).rows[0];
  if (!profile) return null;
  const roles = await db.query<{ code: string }>(
      `select r.code from app.user_roles ur join app.roles r on r.id=ur.role_id and r.active where ur.profile_id=$1 and (ur.expires_at is null or ur.expires_at>now())`,
      [identity.profileId],
    ),
    caps = await db.query<{ code: string }>(
      `select distinct p.code from app.user_roles ur join app.roles r on r.id=ur.role_id and r.active join app.role_permissions rp on rp.role_id=r.id join app.permissions p on p.id=rp.permission_id where ur.profile_id=$1 and (ur.expires_at is null or ur.expires_at>now())`,
      [identity.profileId],
    ),
    grants = await db.query<any>(
      `select ua.reporting_scope::text scope,u.code "unitCode",ua.can_read "canRead",ua.can_write "canWrite" from app.user_unit_access ua left join app.organizational_units u on u.id=ua.unit_id where ua.profile_id=$1 and (ua.expires_at is null or ua.expires_at>now())`,
      [identity.profileId],
    );
  return {
    identity,
    profile,
    roles: roles.rows.map((x) => x.code),
    capabilities: caps.rows.map((x) => x.code),
    grants: grants.rows,
  };
}
export async function requireAccess(
  capability: string,
  target?: { scope: "FACULTY" | "UNIT"; unitCode?: string; write?: boolean },
) {
  const context = await getAccessContext();
  if (!context) throw new AccessDeniedError("UNAUTHENTICATED", 401);
  if (!context.capabilities.includes(capability)) throw new AccessDeniedError();
  if (target) {
    const grant = context.grants.some(
      (g) =>
        (target.write ? g.canWrite : g.canRead) &&
        ((target.scope === "FACULTY" && g.scope === "FACULTY") ||
          (target.scope === "UNIT" &&
            (g.scope === "FACULTY" ||
              (g.scope === "UNIT" && g.unitCode === target.unitCode)))),
    );
    if (!grant) throw new AccessDeniedError("UNIT_FORBIDDEN");
  }
  return context;
}
export function hasCapability(context: AccessContext, capability: string) {
  return context.capabilities.includes(capability);
}
export function canAccessTarget(
  context: AccessContext,
  target: { scope: "FACULTY" | "UNIT"; unitCode?: string; write?: boolean },
) {
  return context.grants.some(
    (g) =>
      (target.write ? g.canWrite : g.canRead) &&
      ((target.scope === "FACULTY" && g.scope === "FACULTY") ||
        (target.scope === "UNIT" &&
          (g.scope === "FACULTY" ||
            (g.scope === "UNIT" && g.unitCode === target.unitCode)))),
  );
}
export function getAuthorizedLandingPage(
  context: AccessContext | null,
  locale: "th" | "en",
) {
  if (!context) return `/${locale}/login`;
  const readable = context.grants.some((g) => g.canRead),
    writable = context.grants.some((g) => g.canWrite);
  if (context.capabilities.includes("dashboard.view") && readable)
    return `/${locale}/dashboard`;
  if (context.capabilities.includes("financial.create") && writable)
    return `/${locale}/data-entry`;
  return `/${locale}/no-authorized-units`;
}
