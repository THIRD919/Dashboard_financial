import {NextResponse} from 'next/server';
import {getAccessContext} from '@/lib/auth/access';
export const dynamic='force-dynamic';
export async function GET(){const context=await getAccessContext();return context?NextResponse.json({capabilities:context.capabilities}):NextResponse.json({capabilities:[]},{status:401})}
