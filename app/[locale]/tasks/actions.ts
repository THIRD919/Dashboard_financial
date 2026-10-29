"use server";
import {revalidatePath} from 'next/cache';import {requireAccess} from '@/lib/auth/access';import {getLocalDatabase} from '@/lib/database/local-pglite';import {createGovernedCorrection} from '@/lib/workflow/correction';import {submitCorrection} from '@/lib/workflow/submission';
const v=(f:FormData,k:string)=>String(f.get(k)??'');
export async function createCorrectionAction(locale:string,f:FormData){const a=await requireAccess('financial.adjustment_create');await createGovernedCorrection(await getLocalDatabase(),{actorProfileId:a.identity.profileId,requestId:v(f,'requestId'),amount:v(f,'amount'),reason:v(f,'reason')});revalidatePath(`/${locale}/tasks`)}
export async function submitCorrectionAction(locale:string,f:FormData){const a=await requireAccess('financial.submit');await submitCorrection(await getLocalDatabase(),{actorProfileId:a.identity.profileId,recordId:v(f,'recordId')});revalidatePath(`/${locale}/tasks`)}
