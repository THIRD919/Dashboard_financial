# AI Rules

- ใช้ source code และ SQL migration เป็นหลักฐานอ้างอิงหลัก
- ตรวจสอบไฟล์ต้นทางก่อนเสนอการแก้ไขทุกครั้ง
- ห้ามเดา business rule, schema, API contract หรือ production behavior
- หากไม่มีหลักฐาน ให้เขียนว่า `ไม่พบข้อมูล`
- ห้ามแก้ไข source code จากการอ่าน Knowledge Base เพียงอย่างเดียว
- ถือ `database/migrations/*.sql` เป็นลำดับการเปลี่ยน schema และ `database/schema.sql` เป็นภาพรวม schema
- แยก prototype/demo behavior ออกจาก production behavior เสมอ
- ใช้เอกสารย่อยตาม `02_MANIFEST.md` เพื่อโหลดเฉพาะบริบทที่เกี่ยวข้อง
- เมื่อเอกสารขัดกับ source code ให้ยึด source code และบันทึกความขัดแย้งไว้ใน `CHANGELOG.md`

