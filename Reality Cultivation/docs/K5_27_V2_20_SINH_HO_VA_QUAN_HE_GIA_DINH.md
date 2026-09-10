---
title: K5.27 — V2.20 sinh hộ và quan hệ gia đình
aliases:
  - V2.20 gia đình theo seed
tags:
  - reality-cultivation
  - k5
  - world-entry
  - family
  - vertical-slice
---

# K5.27 — V2.20 sinh hộ và quan hệ gia đình

## Mục tiêu lát cắt

V2.19 có ba hoàn cảnh sinh thật nhưng H02 và H03 còn được viết tay trong client. V2.20 đưa việc tạo hai hộ này vào lõi mô phỏng. Bộ sinh nhận bản đồ và lịch sử đã sinh, dùng seed cùng fingerprint lịch sử để quyết định tên hộ, phòng, người chăm, tuổi, tay nghề, bốn lượng tài nguyên và vai trò đối với P00.

Đây là bước đầu của nguồn gốc gia đình. Nó chưa phải bộ sinh toàn bộ dân số hoặc phả hệ nhiều thế hệ.

## Bộ sinh xác định

`BirthHouseholdGenerator` không dùng `Random()` của nền tảng. Stream số nguyên an toàn trên Dart VM và Flutter web được dẫn xuất từ:

- root seed;
- fingerprint lịch sử;
- mã địa điểm;
- dân số cohort, giao thương và áp lực tài nguyên cuối tiền sử.

Cùng đầu vào tạo cùng `GeneratedBirthHouseholds.fingerprint`; seed khác tạo dấu vết khác. Bộ sinh từ chối ghép một lịch sử không thuộc bản đồ được cung cấp.

V2.20 sinh hai kế hoạch tại `SITE-FIELD` và `SITE-MARKET`. Mã H02/H03 và N05/N06 còn là slot template để giữ liên kết ổn định. Tên, tuổi, vai trò, tay nghề, tên nhà/phòng và nguồn lực đã chuyển khỏi fixture client.

## Vật chất hóa trước khi người chơi tồn tại

`Simulation.materializeBirthHouseholds` chuyển mỗi kế hoạch thành các sự kiện hiện có:

- một phòng có tọa độ thật trong địa điểm;
- một NPC người chăm có tuổi, cơ thể và kỹ năng;
- sổ kho thức ăn, nước, củi, sữa cùng quyền sử dụng;
- khăn quấn là vật riêng ngoài sổ nguồn lực;
- hộ chứa provenance bằng fingerprint của lượt sinh gia đình.

Các sự kiện chạy trước ba epoch tiền sử hoàn tất và trước `world_entry_opened`. Hậu quả lịch sử V2.18 vì vậy vẫn đổi lượng kho thật của hai hộ mới. P00 chưa tồn tại khi người chơi xem lựa chọn.

## Quan hệ và nguồn gốc

Mỗi hộ khai báo vai trò người chăm là `mother`, `father` hoặc `guardian` cùng một câu tóm tắt nguồn gốc. Validator nơi sinh đưa hai dữ liệu này vào `BirthSiteCandidate`; giao diện hiện chúng trước khi người chơi quyết định.

Khi P00 sinh:

- P00 lưu quan hệ tới NPC là mẹ, cha hoặc người giám hộ;
- NPC lưu quan hệ ngược là con hoặc con nuôi;
- `WorldEntryState` giữ vai trò và tóm tắt nguồn gốc của nhánh đã chọn;
- hồ sơ nhân vật trên giao diện đọc quan hệ từ trạng thái thật.

Các trường mới đều tùy chọn và chỉ được ghi khi có dữ liệu. Save cũ không có quan hệ vẫn tải được; runner V2.19 giữ hash `491d7f5e50d4d551`.

## Kết quả seed mặc định

Với seed `20260907`, fingerprint gia đình là `9555c85967aed7fa`:

| Nơi | Hộ | Người chăm | Vai trò | Kỹ năng | Sữa trước hậu quả lịch sử |
| --- | --- | --- | --- | ---: | ---: |
| Đồng ngoài | Hộ canh ruộng | Phạm Kính | người giám hộ | 610 | 4.695 ml |
| Chợ An Khê | Hộ quán trọ chợ | Hoàng Ngọc Lan | mẹ ruột | 767 | 9.542 ml |

Tên và số liệu là fixture kỹ thuật được sinh để kiểm chứng kiến trúc, chưa phải cân bằng hay văn hóa tên gọi đã được người dùng duyệt.

## Kiểm chứng

- Runner mới: `tool/verify_v2_20_seeded_birth_families.dart`.
- Hash chờ chọn của runner V2.20: `4dc1efdae4d7e0b3`.
- Catalog V2.20: 16 điều kiện; tổng catalog chạy được: 491.
- Tổng kiểm tra: 25/25 runner và 18/18 widget test.
- 24 runner cũ đạt; hash V2.19 giữ nguyên.

## Giới hạn và bước tiếp

- H01 còn là hộ nội dung viết tay; chỉ metadata mẹ và nguồn gốc được bổ sung.
- Mỗi H02/H03 mới có một người lớn. Chưa có bạn đời, anh chị em, họ hàng, sinh–tử nhiều thế hệ hoặc ký ức chung.
- Quan hệ hiện là nhãn hai chiều có provenance từ lần nhập thế; chưa có mức thân thiết, nghĩa vụ, xung đột, bí mật huyết thống hoặc nhận thức sai.
- Số hộ sinh vẫn là hai slot template, chưa chọn ngẫu nhiên từ toàn bộ cohort ước tính của vùng.

Bước kế tiếp phù hợp là V2.21: sinh một hộ nhiều thành viên và quan hệ giữa họ trước P00, rồi cho lịch sinh hoạt và nguồn lực của từng thành viên ảnh hưởng trực tiếp tới việc chăm trẻ.

## Liên kết

- [[K5_26_V2_19_NHIEU_HO_VA_HOAN_CANH_SINH]]
- [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- [[STATE]]
- [[DECISIONS]]
