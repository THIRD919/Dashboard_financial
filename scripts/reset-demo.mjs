import {mkdir,rm} from "node:fs/promises";
import path from "node:path";
import {fileURLToPath} from "node:url";
import {PGlite} from "@electric-sql/pglite";
import {pgcrypto} from "@electric-sql/pglite/contrib/pgcrypto";
import {migrate} from "./check-database-migrations.mjs";
import {assertNonProductionDestructive} from "../lib/security/environment.ts";

assertNonProductionDestructive('demo reset');

const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),"..");
const localDatabase=path.join(root,"database/.local/pglite");
if(!localDatabase.startsWith(path.join(root,"database/.local/")))throw new Error("Unsafe demo reset target");
await rm(localDatabase,{recursive:true,force:true});
await mkdir(path.dirname(localDatabase),{recursive:true});
const db=new PGlite(localDatabase,{extensions:{pgcrypto}});
await migrate(db,{demo:true});
await db.close();
console.log("Local TEST_ONLY demo database reset and prepared.");
