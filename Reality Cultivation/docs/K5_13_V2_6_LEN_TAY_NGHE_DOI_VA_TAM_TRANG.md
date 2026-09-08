---
aliases:
  - V2.6 lên tay nghề, đói và tâm trạng
tags:
  - trien-khai
  - npc
  - co-the
---

# K5.13 — V2.6 tay nghề lên tay, đói và tâm trạng

## Kết quả có thể chơi

V2.5 cho NPC có tay nghề và quyền từ chối, nhưng tay nghề là con số đứng yên và mệt mỏi là lý do duy nhất để nói không. V2.6 khép hai chỗ hở đó.

### Làm nhiều thì khá lên

Làm xong một khối việc thì tay nghề tương ứng lên, theo số giây **thật sự làm được** — bị cắt ngang mất giờ thì lên ít hơn. Người mới lên nhanh, người đã giỏi lên chậm: trọn tám giờ cho **45 điểm ở mức 100** nhưng chỉ **5 điểm ở mức 900**, và kịch trần 1000 thì dừng.

Vòng lặp khép lại: tay nghề lên → sản lượng dự kiến hôm sau cao hơn → kho đầy nhanh hơn → nhu cầu bớt gấp. Trong fixture, người làm công đi kiếm củi bốn giờ ngày đầu lên từ 850 lên 853, và kế hoạch hôm sau đã đặt sản lượng cao hơn.

### Đói và tâm trạng cùng quyết định

Ngưỡng nhận việc nay do **ba trục** hợp thành, mỗi trục quy về cùng một thang:

```
ngưỡng = mệt/10  +  đói/20  +  (1000 − tâm trạng)/25
```

Mệt nặng nhất, đói bằng nửa mệt, bực nhẹ hơn nữa. Người khỏe, no và không bực thì ngưỡng bằng 0 và nhận mọi việc.

Cả ba đều là số thật, đổi vì việc thật:

| Trục | Lên khi | Xuống khi |
| --- | --- | --- |
| Mệt | làm việc (trọn tám giờ +400) | ngủ một đêm (−250) |
| Đói | mỗi bữa trôi qua (+220) | ăn được bữa (−400) |
| Tâm trạng *(xuống là xấu)* | ngủ (+50), làm trọn khối (+20) | hụt bữa (−60), bị cắt ngang (theo phần giờ mất) |

Hồ sơ còn chỉ ra **nguyên nhân chính** đang cản người đó: mệt, đói, hay bực.

### Cảnh đói có thật

Fixture có một biến thể để kiểm chứng chuỗi hỏng: kho lương thực chỉ đủ hai bữa, và **cả nhà không ai đủ nghề kiếm lương thực**. Kết quả sau hai ngày, không đoạn nào viết sẵn:

> Nhu cầu lương thực ghi *thiếu người* mỗi sáng → kho không đầy lại → bữa hụt liên tiếp → đói lên **880**, tâm trạng xuống **830** → ngưỡng nhận việc lên **138** → càng khó giao được việc.

Điều đáng nói: ở biến thể bình thường, hệ thống **tự cứu được** — nhu cầu lương thực gấp lên ưu tiên 90, người có nghề nhận ngay và kho đầy lại trước khi ai kịp đói. Cảnh đói chỉ xảy ra khi thiếu đúng thứ không thay thế được là tay nghề.

## Lỗi đã sửa: mệt mỏi và tay nghề bị ghi đè mất

Khi một khối kết thúc đúng lúc khối kế tiếp bắt đầu, hàm xử lý khối mới dùng lại **bản chụp người từ trước khi đóng khối cũ**. Mệt mỏi và tay nghề vừa được cập nhật trong lúc đóng khối bị ghi đè mất sạch.

Đây là cùng họ lỗi với lần sửa ở V2.4 (khối bị nuốt): đọc trạng thái một lần rồi ghi lại sau khi đã có thay đổi xen giữa. Nay đọc lại người sau bước đóng khối.

**Vì vậy hash runner V2.5 đổi từ `9d3521d32a5b66b6` sang `29bf49642c71fb18`.** V2.5 là fixture duy nhất có hồ sơ sức lực nên cũng là fixture duy nhất chịu ảnh hưởng; toàn bộ điều kiện V2.5 vẫn đạt. Chín runner V0–V2.4 giữ nguyên hash.

## Trạng thái máy mới

- `PersonSkills.gainFrom` / `improve`: quy tắc lên tay nghề giảm dần.
- `PersonAgenda` thêm `hunger`, `mood`, `atMeal`, `afterWork`, `mainStrain`; `acceptanceFloor` nay hợp cả ba trục; `rest` hồi cả mệt lẫn tâm trạng.
- `HouseholdState.wellbeing`: cờ bật theo dõi, đọc từ `enable_v2_6` lúc tạo hộ. Hộ chưa bật thì cả ba trục và việc lên tay nghề đều đứng yên — nên chín thế giới cũ không đổi hành vi.

Sự kiện mới: `skill_improved`.

## Giao diện

Hồ sơ riêng hiện đủ mệt, đói, tâm trạng, ngưỡng nhận việc và nguyên nhân chính. Nhật ký thêm mốc **Lên tay nghề** với số điểm và mức mới; bộ lọc **Nhịp sống** nay gồm cả lên tay nghề và từ chối việc.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.6 đạt tới ngày 4; lưu lúc ngày 1 khi trong nhà đã có người đói rồi chạy tiếp cho cùng hash `b9f0b0d8269b8653`.
- Chín runner V0–V2.4 giữ nguyên hash; V2.5 đạt lại ở hash đã sửa.
- Catalog `game/artifacts/conditions/v2_6_growth_hunger_mood.json` có 22 điều kiện.
- 10/10 widget test đạt, gồm bài mới cho việc lên tay nghề.
- Web release đã đóng gói lại.

## Giới hạn và bước tiếp theo

Đói hiện chỉ đổi ở mốc bữa ăn chứ không trôi liên tục theo giờ, và mọi người lớn trong hộ ăn như nhau — chưa có khẩu phần riêng, chưa nối vào cơ thể như đã làm cho trẻ sơ sinh ở V1.2. Đói cũng chưa gây hậu quả thể chất: chỉ làm khó nhận việc, chưa sụt cân hay yếu đi.

Tâm trạng vẫn chỉ có ba nguồn (hụt bữa, việc bị cắt, ngủ). Chưa có quan hệ giữa người với người, chưa ai nhớ ai đã từ chối việc gì, và từ chối vẫn không có hậu quả xã hội.

Các hệ số +220/−400 cho đói, +400/−250 cho mệt, ±20/−60 cho tâm trạng, chia 10/20/25 cho ngưỡng và mẫu số 576.000 cho lên tay nghề đều là fixture kỹ thuật, chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: nối đói vào cơ thể người lớn cho có hậu quả thể chất thật, rồi mở tuyến vận tải thật có vị trí trung gian.

## Liên kết

- Bản trước: [[K5_12_V2_5_KY_NANG_NGHE_VA_QUYEN_TU_CHOI]]
- Cơ thể sơ sinh đã nối sinh lý: [[K5_5_V1_2_CO_THE_SINH_LY_SO_SINH]]
- Cơ thể sâu (thiết kế): [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]
- NPC tự trị (thiết kế): [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
