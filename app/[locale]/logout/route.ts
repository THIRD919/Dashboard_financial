import {NextResponse} from 'next/server';import {getAuthProvider} from '@/lib/auth/provider';
export async function GET(request:Request,{params}:{params:Promise<{locale:string}>}){const {locale}=await params;await getAuthProvider().signOut();return NextResponse.redirect(new URL(`/${locale}/login`,request.url))}
