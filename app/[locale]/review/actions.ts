"use server";
import {revalidatePath} from 'next/cache';import {requireAccess} from '@/lib/auth/access';import {getLocalDatabase} from '@/lib/database/local-pglite';import {approveReview,returnSubmission,startReview} from '@/lib/workflow/service';
const v=(f:FormData,k:string)=>String(f.get(k)??'');
export async function startReviewAction(locale:string,f:FormData){const a=await requireAccess('financial.review');await startReview(await getLocalDatabase(),{actorProfileId:a.identity.profileId,recordId:v(f,'recordId')});revalidatePath(`/${locale}/review`)}
export async function approveReviewAction(locale:string,f:FormData){const a=await requireAccess('financial.review_approve');await approveReview(await getLocalDatabase(),{actorProfileId:a.identity.profileId,recordId:v(f,'recordId'),comment:v(f,'comment')});revalidatePath(`/${locale}/review`)}
export async function returnReviewAction(locale:string,f:FormData){const a=await requireAccess('financial.return_for_correction');await returnSubmission(await getLocalDatabase(),{actorProfileId:a.identity.profileId,recordId:v(f,'recordId'),reason:v(f,'reason'),stage:'REVIEW'});revalidatePath(`/${locale}/review`)}
