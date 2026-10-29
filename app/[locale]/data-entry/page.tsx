import {notFound,redirect} from "next/navigation";
import {DataEntryPage} from "@/components/data-entry-page";
import type {Locale} from "@/lib/types";
import {AccessDeniedError,requireAccess} from "@/lib/auth/access";
import {loadEntryContext} from "./actions";
export const dynamic="force-dynamic";
export default async function Page({params}:{params:Promise<{locale:string}>}){
 const {locale}=await params;if(!["th","en"].includes(locale))notFound();
 try{await requireAccess('financial.create')}catch(error){redirect(`/${locale}/${error instanceof AccessDeniedError&&error.status===401?'login':'forbidden'}`)}
 try{return <DataEntryPage locale={locale as Locale} initial={await loadEntryContext()}/>}
 catch(error){console.error("Data Entry unavailable",error);redirect(`/${locale}/forbidden`)}
}
