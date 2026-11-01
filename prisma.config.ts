import "dotenv/config";
import { defineConfig, env } from "prisma/config";

// Prisma ORM 7 keeps connection details outside schema.prisma.
// The SQL migrations remain authoritative because they also contain PostgreSQL
// features that Prisma Schema Language cannot represent (RLS, functions, etc.).
export default defineConfig({
  schema: "database/schema.prisma",
  migrations: {
    path: "database/migrations",
  },
  datasource: {
    url: env("DATABASE_URL"),
  },
});
