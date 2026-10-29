import {notFound,redirect} from "next/navigation";
import {ExecutiveDashboard} from "@/components/executive-dashboard";
import {getDefaultDashboardDataProvider} from "@/lib/data/providers";
import {AccessDeniedError,requireAccess} from "@/lib/auth/access";
import type {Locale} from "@/lib/types";
export const dynamic='force-dynamic';
export default async function DashboardPage({params}:{params:Promise<{locale:string}>}){
 const {locale}=await params;if(!['th','en'].includes(locale))notFound();
 let access;try{access=await requireAccess('dashboard.view')}catch(error){redirect(`/${locale}/${error instanceof AccessDeniedError&&error.status===401?'login':'forbidden'}`)}
 const provider=await getDefaultDashboardDataProvider(),data=await provider.getDashboardData(),faculty=access.grants.some(g=>g.scope==='FACULTY'&&g.canRead),codes=new Set(access.grants.filter(g=>g.scope==='UNIT'&&g.canRead).map(g=>g.unitCode));
 if(!faculty&&codes.size===0)redirect(`/${locale}/no-authorized-units`);
 if(!faculty){data.periods=data.periods.map(p=>({...p,facultyAvailable:false}));data.units=data.units.filter(u=>codes.has(u.code));data.unitPeriods=data.unitPeriods?.filter(u=>codes.has(u.code));data.unitOptions=data.unitOptions?.filter(u=>codes.has(u.code));data.facultyBudget.available=false}
 return <ExecutiveDashboard locale={locale as Locale} data={data} allowFaculty={faculty} initialUnitCode={faculty?'ALL':String([...codes][0])}/>;
}
