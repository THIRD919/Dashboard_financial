import assert from 'node:assert/strict';
import {formToPeriodicEntry} from '../lib/data-entry/form-adapter.ts';
import {displayMoney,displayRatio} from '../lib/data-entry/presentation.ts';
import {derivedPreview} from '../lib/data-entry/service.ts';
import {normalizeMoney,validatePeriodicEntry} from '../lib/data-entry/validation.ts';

const context={demoProfileId:'10000000-0000-0000-0000-000000000001',reportingScope:'UNIT',unitCode:'VET-OFFICE',periodCode:'Q2-69',budgetScope:'UNKNOWN',status:'DRAFT'};
const form={budgetRevenue:'',actualRevenue:'1,000,000.00',budgetExpense:'',actualExpense:'700,000.00',currentAssets:'500,000.00',liabilities:'250,000.00',notes:'',sourceReference:'TEST_ONLY_CALCULATION_TRACE'};
const mapped=formToPeriodicEntry(form,context);
assert.equal(mapped.actualRevenue,'1,000,000.00');
assert.equal(mapped.actualExpense,'700,000.00');
assert.equal(mapped.budgetRevenue,'');
assert.equal(mapped.budgetExpense,'');
const preview=derivedPreview(mapped);
assert.equal(preview.validation.values.actualRevenue,'1000000.00');
assert.equal(preview.validation.values.actualExpense,'700000.00');
assert.equal(preview.validation.values.budgetRevenue,null);
assert.equal(preview.validation.values.budgetExpense,null);
assert.equal(preview.operatingResult.value,'300000.00');
assert.equal(preview.operatingMargin.value,'0.3');
assert.equal(preview.financialLiquidity.value,'2');
assert.equal(displayMoney(preview.operatingResult.value,'th'),'300,000.00 บาท');
assert.equal(displayRatio(preview.financialLiquidity.value,'th'),'2.00 เท่า');

for(const value of ['1000000','1,000,000','1000000.00','1,000,000.00'])assert.equal(normalizeMoney(value),'1000000.00');
for(const value of ['700000','700,000','700000.00','700,000.00'])assert.equal(normalizeMoney(value),'700000.00');
for(const field of ['actualRevenue','actualExpense','budgetRevenue','budgetExpense']){
  assert.equal(normalizeMoney(''),null,`${field} blank`);
  assert.equal(normalizeMoney('0'),'0.00',`${field} zero`);
}

const scenario=(revenue,expense)=>derivedPreview(formToPeriodicEntry({...form,actualRevenue:revenue,actualExpense:expense},context));
assert.equal(scenario('1000000','1200000').operatingResult.value,'-200000.00');
assert.equal(scenario('1000000','1200000').operatingMargin.value,'-0.2');
assert.equal(scenario('1000000','1000000').operatingResult.value,'0.00');
assert.equal(scenario('1000000','1000000').operatingMargin.value,'0');
assert.equal(scenario('0','100000').operatingResult.value,'-100000.00');
assert.equal(scenario('0','100000').operatingMargin.value,null);
assert.equal(scenario('0','100000').operatingMargin.status,'NOT_AVAILABLE');
assert.equal(scenario('','700000').operatingResult.value,null);
assert.equal(scenario('','700000').operatingMargin.value,null);
assert.equal(validatePeriodicEntry({...mapped,actualRevenue:'',actualExpense:'700000'}).values.actualRevenue,null);

console.log('Calculation trace passed: Thai Actual bindings -> normalization -> centralized engine -> rendered values, including formatted inputs, blanks, zero, negative, break-even, and zero-revenue NA.');
