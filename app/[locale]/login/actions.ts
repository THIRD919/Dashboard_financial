"use server";
import {redirect} from 'next/navigation';
import {getAuthProvider} from '@/lib/auth/provider';
import {getAccessContext,getAuthorizedLandingPage} from '@/lib/auth/access';
import {checkRateLimit} from '@/lib/security/rate-limit';
export async function signInAction(locale:string,_state:{error?:string},formData:FormData):Promise<{error?:string}>{
 const email=String(formData.get('email')??'').trim(),password=String(formData.get('password')??'');if(!checkRateLimit(`login:${email.toLowerCase()}`,10,15*60*1000).allowed)return{error:'TOO_MANY_ATTEMPTS'};
 try{await getAuthProvider().signIn(email,password);const context=await getAccessContext();const preferred=context?.profile.preferredLanguage??(locale==='en'?'en':'th');redirect(getAuthorizedLandingPage(context,preferred))}
 catch(error){if(error&&typeof error==='object'&&'digest' in error)throw error;return{error:error instanceof Error?error.message:'LOGIN_FAILED'}}
}
export async function requestPasswordResetAction(locale:string,_state:{message?:string},formData:FormData):Promise<{message?:string}>{const email=String(formData.get('email')??'').trim();if(process.env.NODE_ENV!=='production'&&process.env.ENABLE_DEMO_AUTH==='true')return{message:locale==='th'?'บัญชีทดสอบใช้รหัสผ่านจากคู่มือ UAT':'Demo accounts use the password in the UAT guide.'};const {createClient}=await import('@supabase/supabase-js');const url=process.env.NEXT_PUBLIC_SUPABASE_URL,key=process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;if(!url||!key)return{message:'AUTH_NOT_CONFIGURED'};await createClient(url,key).auth.resetPasswordForEmail(email);return{message:locale==='th'?'หากอีเมลอยู่ในระบบ จะได้รับลิงก์รีเซ็ตรหัสผ่าน':'If the account exists, a reset link will be sent.'}}
