# Workflow State Machine

| State | Thai | Allowed next state |
|---|---|---|
| DRAFT | ฉบับร่าง | SUBMITTED |
| SUBMITTED | ส่งตรวจแล้ว | UNDER_REVIEW, RETURNED_FOR_CORRECTION |
| UNDER_REVIEW | อยู่ระหว่างการตรวจสอบ | REVIEW_APPROVED, RETURNED_FOR_CORRECTION |
| REVIEW_APPROVED | ผ่านการตรวจสอบ | FINAL_APPROVED, RETURNED_FOR_CORRECTION |
| FINAL_APPROVED | อนุมัติขั้นสุดท้ายแล้ว | LOCKED |
| LOCKED | ปิดงวดแล้ว | CORRECTION_REQUESTED or SUPERSEDED where governed |
| CORRECTION_REQUESTED | ขอแก้ไขข้อมูล | LOCKED (original remains official) |
| RETURNED_FOR_CORRECTION | ส่งกลับเพื่อแก้ไข | SUBMITTED |
| ADJUSTMENT_DRAFT | ร่างรายการปรับปรุง | ADJUSTMENT_SUBMITTED |
| ADJUSTMENT_SUBMITTED | ส่งรายการปรับปรุงแล้ว | UNDER_REVIEW, RETURNED_FOR_CORRECTION |

Transitions outside this table are rejected by a database trigger.

