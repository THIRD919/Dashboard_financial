import {kpiEngine} from "../financial/kpi-engine.ts";
import {validatePeriodicEntry} from "./validation.ts";
import type {PeriodicEntryInput} from "./types.ts";

export function derivedPreview(input:PeriodicEntryInput){
  const validation=validatePeriodicEntry(input),v=validation.values;
  if(!validation.valid)return{validation,operatingResult:null,operatingMargin:null,financialLiquidity:null,revenueAchievement:null};
  return{
    validation,
    operatingResult:kpiEngine.operatingResult(v.actualRevenue,v.actualExpense),
    operatingMargin:kpiEngine.operatingMargin(v.actualRevenue,v.actualExpense),
    financialLiquidity:kpiEngine.financialLiquidity(v.currentAssets,v.liabilities,input.periodCode),
    revenueAchievement:kpiEngine.achievement('REVENUE_ACHIEVEMENT',v.actualRevenue,v.budgetRevenue,input.budgetScope??'UNKNOWN')
  };
}
