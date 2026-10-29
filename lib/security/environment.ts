export type AppEnvironment='development'|'staging'|'production';

export function appEnvironment(env:NodeJS.ProcessEnv=process.env):AppEnvironment{
 const value=env.APP_ENV??(env.NODE_ENV==='production'?'production':'development');
 if(!['development','staging','production'].includes(value))throw new Error('INVALID_APP_ENV');
 return value as AppEnvironment;
}

export function assertSafeEnvironment(env:NodeJS.ProcessEnv=process.env){
 const target=appEnvironment(env);
 if((target==='production'||env.NODE_ENV==='production')&&env.ENABLE_DEMO_AUTH==='true')throw new Error('SECURITY_REFUSAL: Demo Auth cannot run in production');
 if(target==='production'&&env.DASHBOARD_DATA_PROVIDER==='prototype')throw new Error('SECURITY_REFUSAL: Prototype financial data cannot run in production');
 if(target==='production'&&env.DEMO_AUTH_PASSWORD)throw new Error('SECURITY_REFUSAL: Demo password must not exist in production');
 if(target==='production'&&env.DEMO_SESSION_SECRET)throw new Error('SECURITY_REFUSAL: Demo session secret must not exist in production');
 for(const key of Object.keys(env))if(key.startsWith('NEXT_PUBLIC_')&&/(SERVICE_ROLE|SECRET|PASSWORD|PRIVATE_KEY|DATABASE_URL)/i.test(key))throw new Error(`SECURITY_REFUSAL: sensitive variable has public prefix: ${key}`);
 return target;
}

export function assertNonProductionDestructive(operation:string,env:NodeJS.ProcessEnv=process.env){
 if(appEnvironment(env)==='production'||env.NODE_ENV==='production')throw new Error(`SECURITY_REFUSAL: ${operation} is forbidden in production`);
}

