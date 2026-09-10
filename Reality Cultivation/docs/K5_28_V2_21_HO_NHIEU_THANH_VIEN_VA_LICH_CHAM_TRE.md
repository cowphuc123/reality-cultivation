---
title: K5.28 — V2.21 hộ nhiều thành viên và lịch chăm trẻ
aliases:
  - V2.21 mạng gia đình
tags:
  - reality-cultivation
  - k5
  - family
  - caregiving
  - vertical-slice
---

# K5.28 — V2.21 hộ nhiều thành viên và lịch chăm trẻ

## Mục tiêu lát cắt

V2.20 mới sinh một người lớn cho mỗi hộ ở đồng và chợ. V2.21 tạo thêm một người lớn trong từng hộ trước khi P00 tồn tại, ghi quan hệ giữa họ, rồi dùng lịch sinh hoạt và quyền dùng tài nguyên để quyết định ai thực sự có thể chăm trẻ.

Đây là mạng gia đình nhỏ có tác động lên mô phỏng. Nó chưa phải phả hệ nhiều thế hệ hay mô hình tình cảm.

## Sinh hộ mở rộng mà không phá bản cũ

`BirthHouseholdGenerator.generate` có chế độ `includeFamilyMembers`. Client mới bật chế độ này; lời gọi cũ mặc định tắt để giữ nguyên dữ liệu và fingerprint V2.20 `9555c85967aed7fa`.

Trong chế độ V2.21, mỗi H02/H03 có:

- người chăm chính đã có từ V2.20;
- một người hỗ trợ mới, có tên, tuổi, kỹ năng chăm sóc và vai trò riêng với P00;
- quan hệ `spouse` hoặc `sibling` hai chiều giữa hai người lớn;
- ca bận buổi sáng của người chính và ca bận buổi chiều của người hỗ trợ;
- quyền dùng bốn nguồn lực của hộ, gồm sữa cho trẻ.

Bộ sinh kiểm tra mã người không trùng, tuổi trưởng thành, dải kỹ năng, vai trò hợp lệ và quyền dùng sữa. Các tên, tuổi, vai trò, ca và ngưỡng là fixture kỹ thuật để kiểm chứng kiến trúc, chưa phải cân bằng hay chuẩn văn hóa đã duyệt.

## Gia đình tồn tại trước nhân vật chính

Cả hai người lớn được vật chất hóa thành `PersonState` trước `world_entry_opened`. `HouseholdState.memberIds` và quan hệ nội bộ đã đầy đủ khi màn chọn nơi sinh xuất hiện. Ứng viên nơi sinh công bố tên, vai trò với trẻ, kỹ năng, hoạt động hiện tại và quyền dùng sữa của từng người lớn.

Khi P00 sinh, em bé ghi quan hệ tới mọi người lớn trong hộ. Mỗi người lớn đồng thời ghi quan hệ ngược là `child` hoặc `ward`. Mạng này được lưu trong save và phục hồi cùng đúng semantic hash.

## Ca chăm trẻ có hậu quả

Hộ V2.21 bật `familyCareScheduling`. Khi trẻ khóc hoặc bệnh cần người chăm, một người chỉ đủ điều kiện nếu:

1. tác nhân chăm sóc đang sẵn sàng;
2. kỹ năng chăm sóc đạt ngưỡng fixture 400;
3. không có khối lịch đang chạy với cờ `blocking`;
4. có quyền dùng vật `infant_feed` của hộ.

Lúc 07:00 trong nhánh H02, N05 đang làm ca sáng nên N07 nhận tiếng khóc, thay ca và dùng tài nguyên của hộ. Lần thay được ghi bằng fact `caregiver_substituted` cùng bộ đếm của hộ. Quy tắc mới chỉ chạy cho hộ bật cờ V2.21; save và runner cũ không đổi hành vi.

## Kết quả seed mặc định

- Fingerprint gia đình mở rộng: `474fb428fc6eb010`.
- Người thay ca trong kịch bản 07:00 tại H02: `N07`.
- Hash cuối runner V2.21: `a3e5fd6ed1915a27`.
- Fingerprint V2.20 giữ nguyên: `9555c85967aed7fa`.
- Hash V2.20 giữ nguyên: `4dc1efdae4d7e0b3`.
- Hash V2.19 giữ nguyên: `491d7f5e50d4d551`.

## Kiểm chứng

- Runner mới: `tool/verify_v2_21_household_family_network.dart`.
- Catalog V2.21: 18 điều kiện; tổng catalog chạy được: 509.
- `dart analyze` và `flutter analyze` không báo lỗi.
- 26 runner và 18 widget test là bộ kiểm tra hoàn chỉnh của lát cắt.

## Giới hạn và bước tiếp

- H01 viết tay vẫn chỉ có một người lớn; bộ sinh mở rộng mới áp dụng H02/H03.
- Mỗi hộ sinh mới chỉ có hai người lớn. Chưa có ông bà, anh chị em của P00, sinh–tử qua nhiều thế hệ hoặc chia hộ.
- Quan hệ chưa có mức thân thiết, niềm tin, nghĩa vụ, ký ức chung, mâu thuẫn hay nhận thức sai.
- Lịch là fixture cố định; người lớn chưa tự thương lượng ca chăm, đổi ca hoặc nhờ người ngoài hộ.
- Quyền tài nguyên mới là điều kiện vào; chưa có hành vi xin phép, chia phần hoặc tranh chấp khi thiếu sữa.

Bước kế tiếp phù hợp là V2.22: thêm nghĩa vụ chăm sóc và ký ức tương tác vào quan hệ gia đình, để việc một người liên tục gánh thay làm đổi mệt mỏi, tình cảm và quyết định nhận việc sau đó.

## Liên kết

- [[K5_27_V2_20_SINH_HO_VA_QUAN_HE_GIA_DINH]]
- [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- [[STATE]]
- [[DECISIONS]]
