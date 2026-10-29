import type {BudgetScope,EntryScope,EntryStatus,PeriodicEntryInput} from "./types.ts";

export type PeriodicFinancialForm={
  budgetRevenue:string;
  actualRevenue:string;
  budgetExpense:string;
  actualExpense:string;
  currentAssets:string;
  liabilities:string;
  notes:string;
  sourceReference:string;
};

export function formToPeriodicEntry(form:PeriodicFinancialForm,context:{
  demoProfileId:string;
  reportingScope:EntryScope;
  periodCode:string;
  unitCode?:string;
  budgetScope:BudgetScope;
  status:EntryStatus;
}):PeriodicEntryInput{
  return{
    demoProfileId:context.demoProfileId,
    reportingScope:context.reportingScope,
    periodCode:context.periodCode,
    unitCode:context.reportingScope==='UNIT'?context.unitCode:undefined,
    // Explicit assignments prevent Budget/Actual fields from depending on visual order or object spread order.
    budgetRevenue:form.budgetRevenue,
    actualRevenue:form.actualRevenue,
    budgetExpense:form.budgetExpense,
    actualExpense:form.actualExpense,
    currentAssets:form.currentAssets,
    liabilities:form.liabilities,
    notes:form.notes,
    sourceReference:form.sourceReference,
    budgetScope:context.budgetScope,
    status:context.status,
  };
}
