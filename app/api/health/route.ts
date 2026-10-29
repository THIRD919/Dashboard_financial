import {NextResponse} from 'next/server';
import {getLocalDatabase} from '@/lib/database/local-pglite';

export const dynamic='force-dynamic';
export async function GET(){
 try{await (await getLocalDatabase()).query('select 1');return NextResponse.json({status:'ok',readiness:'ready',version:process.env.npm_package_version??'unknown'},{headers:{'Cache-Control':'no-store'}})}
 catch{return NextResponse.json({status:'unavailable',readiness:'not_ready'},{status:503,headers:{'Cache-Control':'no-store'}})}
}
