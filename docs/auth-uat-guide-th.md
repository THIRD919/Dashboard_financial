# คู่มือ UAT ระบบผู้ใช้งาน

1. รัน `npm run demo:auth` และเปิด `http://localhost:3000/th/login`
2. ใช้รหัสผ่าน TEST_ONLY `VetCmu-Test-Only-2569` กับ `admin.test@local`
3. เปิดผู้ดูแลระบบ → ผู้ใช้งาน → กำหนด VET-OFFICE ให้ผู้ใช้ทดสอบ
4. ออกจากระบบ แล้วเข้า `office.dataentry.test@local`; บันทึก Office และตรวจว่าคำขอ NOVEL ถูกปฏิเสธ
5. เข้า `executive.test@local`; ตรวจ Dashboard และตรวจว่า Data Entry, Import, Admin ใช้งานไม่ได้
6. ตรวจ `novel.dataentry.test@local` (NOVEL เท่านั้น) และ `viewer.test@local` (อ่านเท่านั้น)

ผลที่คาดสำหรับ Office: หลังเข้าสู่ระบบต้องอยู่ที่ `/th/dashboard`, หัวข้อแสดง “ระดับหน่วยงาน / สำนักงาน คณะสัตวแพทยศาสตร์”, ตัวเลือกหน่วยงานมี Office เท่านั้น และปุ่มกลับจากหน้าปฏิเสธสิทธิ์ต้องกลับ Dashboard ได้โดยไม่วนซ้ำ
