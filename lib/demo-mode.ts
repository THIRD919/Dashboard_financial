export function isDemoAuthEnabled() {
  return process.env.NODE_ENV !== "production" && process.env.APP_ENV !== "production" && process.env.ENABLE_DEMO_AUTH === "true";
}

export function requireDemoAuth() {
  if (!isDemoAuthEnabled()) throw new Error("DEMO_AUTH_DISABLED");
}

export function testOnlySource(source: string) {
  const clean = source.trim();
  return clean.startsWith("TEST_ONLY") ? clean : `TEST_ONLY_${clean}`;
}
