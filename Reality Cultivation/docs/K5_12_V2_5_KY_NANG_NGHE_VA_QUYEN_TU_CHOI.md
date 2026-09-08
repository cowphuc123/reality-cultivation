---
aliases:
  - V2.5 kỹ năng nghề và quyền từ chối
tags:
  - trien-khai
  - npc
  - lich
---

# K5.12 — V2.5 kỹ năng nghề, quyền từ chối việc và xếp lại lịch

## Kết quả có thể chơi

V2.4 đã cho hộ tự nhìn kho rồi giao việc, nhưng người được giao luôn im lặng làm theo, và ai làm cũng như nhau. V2.5 sửa cả hai điều đó: **người có nghề mới được giao, và người có quyền nói không.**

### Nghề chọn người

Mỗi người có bảng tay nghề theo mã việc (thang 0–1000). Khi hộ chào một việc, người phải vừa **có quyền dùng kho** vừa **đủ tay nghề tối thiểu** (200) mới lọt vào danh sách; danh sách xếp theo tay nghề cao trước, rồi tới người còn rảnh hơn.

Điều này chữa đúng cái dở của V2.4: người nấu ăn tay nghề kiếm củi 150 nay bị loại khỏi việc kiếm củi dù vẫn giữ nguyên quyền dùng kho củi. Việc về tay người làm công có tay nghề 850.

Tay nghề cũng quyết định sản lượng: tay nghề 0 vẫn làm được 60% mức gốc, tay nghề 1000 làm đủ 100%. Người làm công tay nghề 850 nhận việc kiếm củi mức gốc 2.400 g thì sản lượng dự kiến là **2.256 g**.

### Quyền từ chối

Mỗi người có một hồ sơ sức lực: mức mệt 0–1000, và **ngưỡng nhận việc bằng mức mệt chia mười**. Người mệt 600 chỉ nhận việc từ ưu tiên 60 trở lên.

Trong fixture, người làm công bắt đầu ngày trong tình trạng đã kiệt sức:

| Việc được chào | Ưu tiên | Ngưỡng của N03 | Kết quả |
| --- | --- | --- | --- |
| Kiếm củi | 69 | 60 | **Nhận** — đủ gấp |
| Kiếm lương thực | 48 | 60 | **Từ chối** — chưa đủ gấp |

Việc bị từ chối không biến mất: hộ chào tiếp cho người sau trong danh sách, và người nấu ăn (tay nghề 400, không mệt) nhận. Cả lần nhận lẫn lần từ chối đều vào hồ sơ riêng, kèm lý do đọc được: *"mệt 550/1000, chỉ nhận việc từ mức 55"*.

Nếu **mọi người đều từ chối**, hộ ghi nhu cầu đó là thiếu người và không giao cho ai — không có cơ chế ép làm.

Mệt mỏi là số thật, không phải nhãn: làm trọn tám giờ cộng 400 điểm, ngủ một đêm hồi 250 điểm. Nên người làm nhiều ngày liền sẽ dần chỉ còn nhận việc gấp, rồi tự giãn ra khi được nghỉ.

### Việc bị lùi được xếp lại

V2.4 lùi một khối tối đa ba lần rồi bỏ hẳn. Nay khi hết lượt lùi, hệ thống tìm giờ trống còn lại trong ngày và **xếp lại** khối đó vào đấy. Bản xếp lại là một khối riêng chỉ sống trong ngày hôm ấy, nên bảng giờ gốc không bị sửa, và nó chỉ được xếp lại một lần để không lặp vô hạn. Trong fixture, khối quét sân bị việc gánh nước chèn mất chỗ đã được dời sang buổi chiều thay vì mất trắng.

## Trạng thái máy mới

- `PersonSkills`: mức tay nghề theo mã việc và hàm quy đổi sản lượng.
- `PersonAgenda`: mức mệt, mức hồi sau một đêm, số lần nhận/từ chối, lý do từ chối gần nhất, và ngưỡng nhận việc suy ra.
- `PersonState.skills` / `PersonState.agenda`: cả hai đều không bắt buộc — người không có thì giữ nguyên hành vi cũ (nhận mọi việc, sản lượng gốc).
- `HouseholdView.refusedOffers`, `PersonProfileView.skills/agenda` trên cổng truy vấn.

Sự kiện mới: `work_offer_refused`, `routine_block_rescheduled`.

## Giao diện

Hồ sơ từng người nay hiện tay nghề theo nghề, mức mệt, ngưỡng nhận việc, số lần nhận/từ chối và lý do từ chối gần nhất. Trang Hộ thêm ô đo **Từ chối việc**. Nhật ký có câu tiếng Việt cho hai mốc mới.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.5 đạt tới ngày 4; lưu lúc 09:00 sau khi đã có lần từ chối rồi chạy tiếp cho cùng hash. Hash ban đầu là `9d3521d32a5b66b6`; từ V2.6 đổi thành `29bf49642c71fb18` sau khi sửa lỗi ghi đè mất mệt mỏi, xem [[K5_13_V2_6_LEN_TAY_NGHE_DOI_VA_TAM_TRANG]]. Mọi điều kiện V2.5 vẫn đạt.
- **Chín runner V0–V2.4 giữ nguyên hash** — mọi tính năng mới đều gắn với trường dữ liệu mới nên thế giới cũ không đổi hành vi.
- Catalog `game/artifacts/conditions/v2_5_skills_and_refusal.json` có 22 điều kiện.
- 9/9 widget test đạt, gồm bài mới cho việc chọn người theo nghề và lần từ chối.
- Web release đã đóng gói lại.

## Giới hạn và bước tiếp theo

Mệt mỏi hiện là trục duy nhất khiến người ta từ chối. Chưa có: đói, đau, tâm trạng, quan hệ (nể ai thì nhận, ghét ai thì thôi), hay mục tiêu cá nhân dài hạn kiểu "để dành tiền học nghề". Từ chối cũng chưa có hậu quả xã hội — không ai giận, không ai nhớ.

Tay nghề hiện là con số cố định, **chưa lên theo số lần làm**. Đó là mắt xích còn thiếu rõ nhất: làm nhiều thì phải giỏi hơn.

Ngưỡng nhận việc bằng mức mệt chia mười, tay nghề tối thiểu 200, dải sản lượng 60–100%, mức hồi 250 mỗi đêm và mức tăng 400 cho tám giờ đều là fixture kỹ thuật, chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho tay nghề tăng theo số giờ đã làm, thêm đói và tâm trạng vào quyết định nhận việc, rồi mở tuyến vận tải thật có vị trí trung gian.

## Liên kết

- Bản trước: [[K5_11_V2_4_NHU_CAU_SINH_VIEC_VA_UU_TIEN]]
- NPC tự trị (thiết kế sâu): [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]
- Năng lực và truyền tri thức: [[NANG_LUC_NGON_NGU_TRI_THUC_K1]]
- Kế hoạch tổng: [[MASTER_PLAN]]
