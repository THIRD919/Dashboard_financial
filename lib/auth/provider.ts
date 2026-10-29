import { cookies } from "next/headers";
import { createHmac, timingSafeEqual } from "node:crypto";
import { createServerClient } from "@supabase/ssr";
import { getLocalDatabase } from "../database/local-pglite";
import { isDemoAuthEnabled } from "../demo-mode";

export type AuthIdentity = {
  authUserId: string | null;
  profileId: string;
  email: string;
  provider: string;
};
export interface AuthProvider {
  signIn(email: string, password: string): Promise<AuthIdentity>;
  signOut(): Promise<void>;
  getIdentity(): Promise<AuthIdentity | null>;
}
const COOKIE = "vet_cmu_session",
  secret = () =>
    process.env.DEMO_SESSION_SECRET ??
    "TEST_ONLY_LOCAL_SESSION_SECRET_NOT_FOR_PRODUCTION",
  sign = (payload: string) =>
    createHmac("sha256", secret()).update(payload).digest("base64url");
const safeEqual = (a: string, b: string) => {
  const aa = Buffer.from(a),
    bb = Buffer.from(b);
  return aa.length === bb.length && timingSafeEqual(aa, bb);
};
async function sessionAudit(
  profileId: string,
  event: "LOGIN" | "LOGOUT",
  provider: string,
) {
  await (
    await getLocalDatabase()
  ).query(
    `insert into app.audit_logs(actor_profile_id,action,entity_type,entity_id,metadata) values($1::uuid,'CONFIG_CHANGE','session',$2,$3::jsonb)`,
    [profileId, profileId, JSON.stringify({ event, provider })],
  );
}

class DemoAuthProvider implements AuthProvider {
  async signIn(email: string, password: string) {
    if (!isDemoAuthEnabled()) throw new Error("DEMO_AUTH_DISABLED");
    const expected = process.env.DEMO_AUTH_PASSWORD ?? "VetCmu-Test-Only-2569";
    if (!safeEqual(sign(password), sign(expected)))
      throw new Error("INVALID_CREDENTIALS");
    const db = await getLocalDatabase(),
      profile = (
        await db.query<{ id: string; email: string }>(
          `select id,email from app.profiles where lower(email)=lower($1) and is_active and account_status='ACTIVE'`,
          [email],
        )
      ).rows[0];
    if (!profile) throw new Error("ACCOUNT_UNAVAILABLE");
    const payload = Buffer.from(
      JSON.stringify({
        profileId: profile.id,
        email: profile.email,
        exp: Date.now() + 8 * 60 * 60 * 1000,
      }),
    ).toString("base64url");
    (await cookies()).set(COOKIE, `${payload}.${sign(payload)}`, {
      httpOnly: true,
      sameSite: "lax",
      secure: false,
      path: "/",
      maxAge: 8 * 60 * 60,
    });
    await db.query(
      `update app.profiles set last_login_at=now(),last_activity_at=now() where id=$1`,
      [profile.id],
    );
    await sessionAudit(profile.id, "LOGIN", "demo");
    return {
      authUserId: null,
      profileId: profile.id,
      email: profile.email,
      provider: "demo",
    };
  }
  async signOut() {
    const identity = await this.getIdentity();
    if (identity) await sessionAudit(identity.profileId, "LOGOUT", "demo");
    (await cookies()).delete(COOKIE);
  }
  async getIdentity() {
    if (!isDemoAuthEnabled()) return null;
    const value = (await cookies()).get(COOKIE)?.value;
    if (!value) return null;
    const [payload, signature] = value.split(".");
    if (!payload || !signature || !safeEqual(sign(payload), signature))
      return null;
    try {
      const data = JSON.parse(Buffer.from(payload, "base64url").toString());
      if (data.exp < Date.now()) return null;
      return {
        authUserId: null,
        profileId: data.profileId,
        email: data.email,
        provider: "demo",
      };
    } catch {
      return null;
    }
  }
}
async function supabase() {
  const store = await cookies(),
    url = process.env.NEXT_PUBLIC_SUPABASE_URL,
    key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !key) throw new Error("SUPABASE_AUTH_NOT_CONFIGURED");
  return createServerClient(url, key, {
    cookies: {
      getAll: () => store.getAll(),
      setAll: (items) => {
        for (const item of items)
          store.set(item.name, item.value, item.options);
      },
    },
  });
}
class SupabaseAuthProvider implements AuthProvider {
  async signIn(email: string, password: string) {
    const client = await supabase(),
      { data, error } = await client.auth.signInWithPassword({
        email,
        password,
      });
    if (error || !data.user) throw new Error("INVALID_CREDENTIALS");
    const db = await getLocalDatabase(),
      profile = (
        await db.query<{ id: string; email: string }>(
          `select id,email from app.profiles where auth_user_id=$1 and is_active and account_status='ACTIVE'`,
          [data.user.id],
        )
      ).rows[0];
    if (!profile) {
      await client.auth.signOut();
      throw new Error("ACCOUNT_UNAVAILABLE");
    }
    await db.query(
      `update app.profiles set last_login_at=now(),last_activity_at=now() where id=$1`,
      [profile.id],
    );
    await sessionAudit(profile.id, "LOGIN", "supabase");
    return {
      authUserId: data.user.id,
      profileId: profile.id,
      email: profile.email,
      provider: "supabase",
    };
  }
  async signOut() {
    const identity = await this.getIdentity();
    if (identity) await sessionAudit(identity.profileId, "LOGOUT", "supabase");
    await (await supabase()).auth.signOut();
  }
  async getIdentity() {
    if (
      !process.env.NEXT_PUBLIC_SUPABASE_URL ||
      !process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY
    )
      return null;
    const client = await supabase(),
      { data } = await client.auth.getUser();
    if (!data.user) return null;
    const db = await getLocalDatabase(),
      profile = (
        await db.query<{ id: string; email: string }>(
          `select id,email from app.profiles where auth_user_id=$1 and is_active and account_status='ACTIVE'`,
          [data.user.id],
        )
      ).rows[0];
    return profile
      ? {
          authUserId: data.user.id,
          profileId: profile.id,
          email: profile.email,
          provider: "supabase",
        }
      : null;
  }
}
export function getAuthProvider(): AuthProvider {
  return isDemoAuthEnabled()
    ? new DemoAuthProvider()
    : new SupabaseAuthProvider();
}
