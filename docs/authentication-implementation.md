# Authentication Implementation

`AuthProvider` isolates application identity from Supabase. `SupabaseAuthProvider` uses email/password and secure server-managed cookies through `@supabase/ssr`; passwords and tokens never enter application tables or browser localStorage. Profiles link by `auth_user_id`. Session resolution always rechecks `is_active` and `account_status=ACTIVE`.

`DemoAuthProvider` is available only outside production with `ENABLE_DEMO_AUTH=true`. It uses a signed, HTTP-only, same-site, eight-hour TEST_ONLY cookie. Production must supply Supabase URL/anon key, keep the service-role key server-only, and provision the first Admin by an authorized migration or secure operator process.

Forgot-password uses Supabase's reset flow when configured. Invitation uses Supabase Admin invitation in production; local UAT creates only a TEST_ONLY profile and never displays or emails a plaintext password.
