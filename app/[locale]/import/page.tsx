import {notFound,redirect} from 'next/navigation';
import {ImportPage} from '@/components/import-page';
import {importHistoryAction} from './actions';
import {AccessDeniedError,requireAccess} from '@/lib/auth/access';
import type {Locale} from '@/lib/types';
export const dynamic='force-dynamic';
export default async function Page({params}:{params:Promise<{locale:string}>}){const {locale}=await params;if(!['th','en'].includes(locale))notFound();try{await requireAccess('import.upload')}catch(error){redirect(`/${locale}/${error instanceof AccessDeniedError&&error.status===401?'login':'forbidden'}`)}return <ImportPage locale={locale as Locale} enabled initialHistory={await importHistoryAction()}/>}
