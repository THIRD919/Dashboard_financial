# คู่มือทดสอบความปลอดภัย Phase 5C

1. รัน `npm run demo:auth` และเข้าสู่ระบบเป็น Admin
2. ตรวจว่า Admin จัดการผู้ใช้ได้ แต่ไม่มีสิทธิ์อนุมัติขั้นสุดท้ายโดยอัตโนมัติ
3. เข้าด้วย Office Data Entry และตรวจว่าเห็น/บันทึกได้เฉพาะ VET-OFFICE
4. เข้าด้วย Reviewer ตรวจว่าตรวจได้ตามขอบเขต แต่เข้า Final Approval ไม่ได้
5. เข้าด้วย Vice Dean ตรวจสรุป กด Final Approve และยืนยัน Lock
6. ตรวจว่าข้อมูลปิดงวดแก้/ลบ/นำเข้าปกติไม่ได้ และ Dashboard แสดงข้อมูลทางการ
7. รัน `npm run backup:test` ต้องเห็น `backup: PASS`, `restore: PASS`, expense 720000, result 280000, margin 28.0%, liquidity 2.00x และ reversalNet 0
8. รัน `NODE_ENV=production APP_ENV=production ENABLE_DEMO_AUTH=true pnpm build` ต้องล้มเหลวด้วยข้อความปฏิเสธ Demo Auth
9. รัน `pnpm test:security`, `pnpm test:production-bootstrap` และ `pnpm build`

ห้ามใช้ข้อมูลจริงหรือฐาน production ในการทดสอบนี้

