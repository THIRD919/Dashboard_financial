import {PGlite} from "@electric-sql/pglite";import {pgcrypto} from "@electric-sql/pglite/contrib/pgcrypto";import {migrate} from "@/scripts/check-database-migrations.mjs";
type LocalGlobal=typeof globalThis&{__vetCmuLocalDb?:Promise<PGlite>};
export function getLocalDatabase(){const shared=globalThis as LocalGlobal;if(!shared.__vetCmuLocalDb)shared.__vetCmuLocalDb=(async()=>{const db=new PGlite('database/.local/pglite',{extensions:{pgcrypto}});await migrate(db);return db})();return shared.__vetCmuLocalDb}
