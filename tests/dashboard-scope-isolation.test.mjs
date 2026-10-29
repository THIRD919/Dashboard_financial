import assert from 'node:assert/strict';
import {PGlite} from '@electric-sql/pglite';
import {pgcrypto} from '@electric-sql/pglite/contrib/pgcrypto';
import {migrate} from '../scripts/check-database-migrations.mjs';
import {savePeriodicEntry} from '../lib/data-entry/service.ts';
import {DatabaseDataProvider} from '../lib/data/providers.ts';

const db=new PGlite({extensions:{pgcrypto}});
await migrate(db,{demo:true});
const before=await db.query('select count(*)::int n from app.financial_records');
assert.equal(before.rows[0].n,0,'clean demo must contain no financial facts');
const emptyDashboard=await new DatabaseDataProvider(db,true).getDashboardData();
assert.equal(emptyDashboard.unitOptions.length,11);
assert.equal(emptyDashboard.unitOptions.some(unit=>unit.code==='VET-OFFICE'&&unit.nameTh==='สำนักงาน คณะสัตวแพทยศาสตร์'),true);
assert.equal(emptyDashboard.units.length,0,'dropdown membership must not require financial facts');

const saved=await savePeriodicEntry(db,{demoProfileId:'10000000-0000-0000-0000-000000000001',reportingScope:'UNIT',unitCode:'VET-OFFICE',periodCode:'Q2-69',sourceReference:'TEST_ONLY_UAT_OFFICE_Q2_69',actualRevenue:'1000000.00',actualExpense:'700000.00',currentAssets:'500000.00',liabilities:'250000.00',status:'SUBMITTED'});
assert.equal(saved.ok,true);
assert.equal(saved.recordIds.length,4);

const grain=await db.query(`select r.reporting_scope,u.code unit_code,rp.period_code,m.code metric_code,count(*)::int records,sum(r.amount)::text amount from app.financial_records r left join app.organizational_units u on u.id=r.unit_id join app.reporting_periods rp on rp.id=r.reporting_period_id join app.financial_metrics m on m.id=r.metric_id group by r.reporting_scope,u.code,rp.period_code,m.code order by m.code`);
assert.deepEqual(grain.rows,[
 {reporting_scope:'UNIT',unit_code:'VET-OFFICE',period_code:'Q2-69',metric_code:'CURRENT_ASSETS',records:1,amount:'500000.00'},
 {reporting_scope:'UNIT',unit_code:'VET-OFFICE',period_code:'Q2-69',metric_code:'EXPENSE',records:1,amount:'700000.00'},
 {reporting_scope:'UNIT',unit_code:'VET-OFFICE',period_code:'Q2-69',metric_code:'LIABILITIES',records:1,amount:'250000.00'},
 {reporting_scope:'UNIT',unit_code:'VET-OFFICE',period_code:'Q2-69',metric_code:'REVENUE',records:1,amount:'1000000.00'}
]);
const faculty=await db.query("select count(*)::int n from app.financial_records where reporting_scope='FACULTY'");
assert.equal(faculty.rows[0].n,0);

const dashboard=await new DatabaseDataProvider(db,true).getDashboardData();
assert.deepEqual(dashboard.unitOptions,emptyDashboard.unitOptions,'financial submission must not change dropdown membership');
assert.equal(dashboard.periods.find(p=>p.label==='Q2/69').facultyAvailable,false);
assert.deepEqual(dashboard.units.map(u=>({code:u.code,period:u.periodLabel,revenue:u.revenue,expense:u.expense,result:u.operatingResult,assets:u.currentAssets,liabilities:u.liabilities,liquidity:u.financialLiquidity})),[
 {code:'VET-OFFICE',period:'Q2/69',revenue:1000000,expense:700000,result:300000,assets:500000,liabilities:250000,liquidity:2}
]);
console.log('Dashboard scope-isolation test passed: one Office Q2/69 batch, exact 1,000,000 / 700,000 / 300,000 / 2.00x, no Faculty facts, no duplication.');
await db.close();
