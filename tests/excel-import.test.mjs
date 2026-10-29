import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import ExcelJS from 'exceljs';
import {PGlite} from '@electric-sql/pglite';
import {pgcrypto} from '@electric-sql/pglite/contrib/pgcrypto';
import {migrate} from '../scripts/check-database-migrations.mjs';
import {confirmImport,importHistory,stageWorkbook} from '../lib/import/service.ts';
import {DatabaseDataProvider} from '../lib/data/providers.ts';

const makeDb=async()=>{const db=new PGlite({extensions:{pgcrypto}});await migrate(db,{demo:true});return db};
const uatPath=new URL('../templates/TEST_ONLY_Vet_CMU_Office_Q2_69.xlsx',import.meta.url),uat=new Uint8Array(await readFile(uatPath));
const db=await makeDb();
const preview=await stageWorkbook(db,{fileName:'TEST_ONLY_Vet_CMU_Office_Q2_69.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:uat});
assert.deepEqual(preview.counts,{records:4,valid:4,warnings:0,errors:0,duplicates:0,conflicts:0});assert.equal(preview.canConfirm,true);assert.deepEqual(preview.financialSummary,[{scope:'UNIT',period:'Q2/69',unit:'VET-OFFICE',revenue:'1000000.00',expense:'700000.00',operatingResult:'300000.00'}]);
assert.equal((await db.query('select count(*)::int n from app.financial_records')).rows[0].n,0,'staging must never be visible as authoritative data');
const confirmed=await confirmImport(db,{batchId:preview.batchId});assert.deepEqual(confirmed,{ok:true,imported:4});
const dashboard=await new DatabaseDataProvider(db,true).getDashboardData(),office=dashboard.units.find(x=>x.code==='VET-OFFICE');assert.deepEqual({revenue:office.revenue,expense:office.expense,result:office.operatingResult,liquidity:office.financialLiquidity},{revenue:1000000,expense:700000,result:300000,liquidity:2});
const duplicate=await stageWorkbook(db,{fileName:'TEST_ONLY_repeat.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:uat});assert.equal(duplicate.duplicateFile,true);assert.equal(duplicate.counts.duplicates,4);assert.equal(duplicate.counts.valid,0);assert.equal((await confirmImport(db,{batchId:duplicate.batchId})).imported,0);

async function altered(changes){const wb=new ExcelJS.Workbook();await wb.xlsx.load(Buffer.from(uat));const sheet=wb.getWorksheet('Financial Data');for(const [cell,value] of Object.entries(changes))sheet.getCell(cell).value=value;return new Uint8Array(await wb.xlsx.writeBuffer())}
const conflict=await stageWorkbook(db,{fileName:'TEST_ONLY_conflict.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:await altered({F2:1100000})});assert.equal(conflict.counts.conflicts,1);assert.equal(conflict.canConfirm,false);
const invalid=await stageWorkbook(await makeDb(),{fileName:'TEST_ONLY_invalid.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:await altered({C2:'UNKNOWN-UNIT',B3:'Q9/99',D4:'UNKNOWN_METRIC',F5:'not money'})});assert.ok(invalid.counts.errors>=4);assert.equal(invalid.canConfirm,false);
const blankZero=await stageWorkbook(await makeDb(),{fileName:'TEST_ONLY_blank_zero.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:await altered({F2:null,F3:0})});assert.equal(blankZero.rows.find(r=>r.sourceCell==='F2').amountNormalized,null);assert.equal(blankZero.rows.find(r=>r.sourceCell==='F3').amountNormalized,'0.00');
await assert.rejects(()=>stageWorkbook(db,{fileName:'bad.csv',mimeType:'text/csv',bytes:new Uint8Array([1])}),/UNSUPPORTED_FORMAT/);await assert.rejects(()=>stageWorkbook(db,{fileName:'bad.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:new Uint8Array([1,2,3])}),/(INVALID_XLSX_SIGNATURE|CORRUPTED_WORKBOOK)/);

const rollbackDb=await makeDb(),rollbackPreview=await stageWorkbook(rollbackDb,{fileName:'TEST_ONLY_rollback.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:uat}),rollback=await confirmImport(rollbackDb,{batchId:rollbackPreview.batchId,failAfter:2});assert.equal(rollback.ok,false);assert.equal((await rollbackDb.query('select count(*)::int n from app.financial_records')).rows[0].n,0);assert.equal((await rollbackDb.query('select count(*)::int n from app.import_commits')).rows[0].n,0);

const originalDb=await makeDb(),originalBytes=new Uint8Array(await readFile(new URL('../Vet_CMU_Interactive_Financial_Dashboard.xlsx',import.meta.url))),original=await stageWorkbook(originalDb,{fileName:'Vet_CMU_Interactive_Financial_Dashboard.xlsx',mimeType:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',bytes:originalBytes,profileCode:'VET_CMU_FINANCIAL_WORKBOOK_V1'});assert.equal(original.counts.errors,0);const recon=Object.fromEntries(original.reconciliation.filter(x=>x.period==='Q2/69').map(x=>[x.metric,x.difference]));assert.deepEqual(recon,{REVENUE:'468.00',EXPENSE:'1.00',OPERATING_RESULT:'467.00'});const q2Faculty=original.financialSummary.find(x=>x.scope==='FACULTY'&&x.period==='Q2/69');assert.deepEqual({revenue:q2Faculty.revenue,expense:q2Faculty.expense,result:q2Faculty.operatingResult},{revenue:'73281544.00',expense:'57694327.00',result:'15587217.00'});const gov=original.rows.filter(r=>r.sourceSheet==='งบแผ่นดินแยกหมวด');assert.equal(gov.reduce((s,r)=>s+(r.metricCode==='BUDGETED_EXPENSE'?Number(r.amountNormalized):0),0),207098179);assert.equal(gov.reduce((s,r)=>s+(r.metricCode==='EXPENSE'?Number(r.amountNormalized):0),0),89248624);
const history=await importHistory(db);assert.ok(history.length>=3);const auditEvents=await db.query(`select metadata->>'event' event from app.audit_logs where entity_type in('import_batch','financial_record')`);for(const event of ['UPLOAD','VALIDATE','CONFIRM_IMPORT','IMPORT'])assert.ok(auditEvents.rows.some(x=>x.event===event));
const ui=await readFile(new URL('../components/import-page.tsx',import.meta.url),'utf8');for(const phrase of ['นำเข้าข้อมูลการเงินจาก Excel','Import Financial Data from Excel','การกระทบยอด','Reconciliation','ยืนยันการนำเข้าข้อมูล','Confirm Import'])assert.ok(ui.includes(phrase));
console.log('Excel import tests passed: upload security, profiles, staging isolation, mapping, validation, blank/zero, duplicates/conflicts, reconciliation 468/1/467, transactional commit/rollback, audit/history, dashboard integration, and bilingual UI.');
await db.close();await rollbackDb.close();await originalDb.close();
