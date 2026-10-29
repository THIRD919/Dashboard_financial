import {notFound,redirect} from "next/navigation";
import {PlaceholderPage} from "@/components/placeholder-page";
import {tFor} from "@/lib/i18n";
import {AccessDeniedError,requireAccess} from '@/lib/auth/access';
import type {Locale} from "@/lib/types";
export const dynamic='force-dynamic';
export default async function Page({params}:{params:Promise<{locale:string;section:string}>}){const {locale,section}=await params;if(!['th','en'].includes(locale))notFound();const t=tFor(locale as Locale),titles:Record<string,string>={'financial-analysis':t.analysis,'unit-performance':t.units},capabilities:Record<string,string>={'financial-analysis':'financial.view','unit-performance':'financial.view'};if(!titles[section])notFound();try{await requireAccess(capabilities[section])}catch(error){redirect(`/${locale}/${error instanceof AccessDeniedError&&error.status===401?'login':'forbidden'}`)}return <PlaceholderPage locale={locale as Locale} title={titles[section]}/>}
