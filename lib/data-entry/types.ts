export type EntryStatus='DRAFT'|'SUBMITTED';export type EntryScope='FACULTY'|'UNIT';export type BudgetScope='ANNUAL'|'PERIOD'|'UNKNOWN';
export type PeriodicEntryInput={demoProfileId:string;reportingScope:EntryScope;periodCode:string;unitCode?:string;actualRevenue?:string;budgetRevenue?:string;actualExpense?:string;budgetExpense?:string;currentAssets?:string;liabilities?:string;budgetScope?:BudgetScope;notes?:string;sourceReference:string;status:EntryStatus};
export type EntryResult={ok:boolean;code?:string;message?:string;recordIds?:string[];duplicateIds?:string[]};
