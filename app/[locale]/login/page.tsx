import {notFound,redirect} from 'next/navigation';
import {getAccessContext} from '@/lib/auth/access';
import {LoginPage} from '@/components/login-page';
import type {Locale} from '@/lib/types';
export default async function Page({params}:{params:Promise<{locale:string}>}){const {locale}=await params;if(!['th','en'].includes(locale))notFound();if(await getAccessContext())redirect(`/${locale}/dashboard`);return <LoginPage locale={locale as Locale}/>}
