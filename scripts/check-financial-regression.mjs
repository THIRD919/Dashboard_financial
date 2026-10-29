import assert from "node:assert/strict";
import {readFileSync} from "node:fs";
const data=JSON.parse(readFileSync(new URL("../data/prototype-financial-data.json",import.meta.url),"utf8"));
const expected={
 faculty:{"Q3/68":[90260853,84229576,6031277,0.35189737286833617],"Q4/68":[131408229,127865373,3542856,0.49776918500892325],"Q1/69":[46683658,51712260,-5028602,0.42357773988528913],"Q2/69":[73281544,57694327,15587217,0.3526840546203309]},
 facultyBudget:[171825100,73281544,165565500,57694327],government:[207098179,89248624,119046379,60616531,88051800,28632093],reconciliation:[468,1,467],
 units:[[18542474,14354999,4187475,28518000,29638800],[39787921,31034819,8753102,114900000,110400000],[1762983,1511583,251400,3449600,3200000],[1008535,1002935,5600,2176700,2100000],[1044605,396333,648272,2173300,1426100],[2741058,2740822,236,7074000,6366600],[0,0,0,0,0],[7351957,4155836,3196121,7959800,7163800],[11985,189641,-177656,526500,500000],[1029558,2307358,-1277800,4200000,4000000],[0,0,0,700000,500000]]
};
for(const [label,values] of Object.entries(expected.faculty)){const f=data.periods.find(p=>p.label===label)?.faculty;assert.deepEqual([f.revenue,f.expense,f.operatingResult,f.financialLiquidity],values,`Faculty ${label}`)}
assert.deepEqual([data.facultyBudget.revenueBudget,data.facultyBudget.revenueActual,data.facultyBudget.expenseBudget,data.facultyBudget.expenseActual],expected.facultyBudget,"Faculty budget");
assert.deepEqual([data.governmentBudget.budget,data.governmentBudget.actual,...data.governmentBudget.categories.flatMap(c=>[c.budget,c.actual])],expected.government,"Government budget");
const sums=["revenue","expense","operatingResult"].map(k=>data.units.reduce((s,u)=>s+u[k],0)),q2=data.periods.find(p=>p.label==="Q2/69").faculty;
assert.deepEqual([q2.revenue-sums[0],q2.expense-sums[1],q2.operatingResult-sums[2]],expected.reconciliation,"Reconciliation");
assert.equal(data.units.length,11,"Unit count");
assert.deepEqual(data.units.map(u=>[u.revenue,u.expense,u.operatingResult,u.revenueBudget,u.expenseBudget]),expected.units,"All unit financial values");
console.log("Financial regression passed: faculty KPIs, budgets, government budget, 11 units, and reconciliation 468/1/467 are unchanged.");
