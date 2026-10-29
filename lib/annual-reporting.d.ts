import type {BudgetScope} from "./types";
export type AnnualRecord={periodLabel:string;revenue:number;expense:number;currentAssets?:number;liabilities?:number;revenueBudget?:number;expenseBudget?:number};
export function dataCompleteness(records:AnnualRecord[],expectedPeriodLabels:string[]):{available:string[];missing:string[];count:number;expected:number;isFullYear:boolean};
export function aggregateBudget(records:AnnualRecord[],key:"revenueBudget"|"expenseBudget",budgetScope:BudgetScope):{value:number|null;blocked:boolean};
export function aggregateAnnual(records:AnnualRecord[],options:{expectedPeriodLabels:string[];budgetScope?:BudgetScope}):{revenue:number;expense:number;operatingResult:number;operatingMargin:number|null;financialLiquidity:number|null;liquiditySourcePeriod:string|null;revenueBudget:number|null;expenseBudget:number|null;revenueAchievement:number|null;expenseUtilization:number|null;budgetAggregationBlocked:boolean;completeness:ReturnType<typeof dataCompleteness>};
