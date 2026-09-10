---
title: K5.26 — V2.19 nhiều hộ và hoàn cảnh sinh
aliases:
  - V2.19 nhiều nơi sinh
tags:
  - reality-cultivation
  - k5
  - world-entry
  - household
  - vertical-slice
---

# K5.26 — V2.19 nhiều hộ và hoàn cảnh sinh

## Mục tiêu lát cắt

V2.16–V2.18 đã có vòng đời nhập thế và hậu quả lịch sử, nhưng chỉ `SITE-HOME` có một hộ đủ điều kiện. V2.19 vật chất hóa thêm hộ giữ đồng tại `SITE-FIELD` và hộ quán trọ tại `SITE-MARKET`. Người chơi nay có ba nguồn gốc sinh khác nhau trước khi P00 tồn tại.

Ba lựa chọn dùng cùng một validator. Một địa điểm chỉ mở khi thực sự có phòng thuộc hộ, người chăm đang sẵn sàng, sữa còn lượng dương và quyền dùng sữa hợp lệ. Loại địa điểm `field` hoặc `market` không tự cấm sinh nếu trong đó đã có một hộ và phòng thật.

## Ba hoàn cảnh seed mặc định

Các lượng dưới đây đã nhận hậu quả lịch sử V2.18.

| Nơi | Hộ / người chăm | Kỹ năng chăm | Sữa | Lương thực | Nước | Củi | Cảnh báo đầu kỳ |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| Hộ ven suối | H01 / N01 | 700 | 10.000 ml | 16.695 g | 47.568 ml | 4.248 g | Không |
| Đồng ngoài | H02 / Lâm Thị Sương (N05) | 560 | 4.200 ml | 28.938 g | 14.865 ml | 2.265 g | sữa, nước, củi, kinh nghiệm chăm |
| Chợ An Khê | H03 / Trần Bách (N06) | 860 | 7.500 ml | 10.017 g | 35.676 ml | 6.608 g | lương thực |

`SITE-RIVER` và `SITE-PASS` vẫn bị khóa vì không có hộ/phòng ở đó.

## Rủi ro được suy ra

`BirthSiteCandidate` không chỉ trả về cờ khả thi. Với nơi đã mở, nó mang tên hộ, phòng, người chăm, kỹ năng chăm và lượng của bốn kho sau lịch sử. Cảnh báo được suy ra tại thời điểm truy vấn:

- sữa dưới 5.000 ml → dự trữ sữa mỏng;
- lương thực dưới 12.000 g → lương thực dự trữ thấp;
- nước dưới 20.000 ml → nguồn nước dự trữ thấp;
- củi dưới 3.000 g → thiếu nhiên liệu dự phòng;
- kỹ năng chăm dưới 600/1.000 → người chăm ít kinh nghiệm.

Các ngưỡng này là fixture kỹ thuật, chưa phải cân bằng được người dùng duyệt. Chúng không được lưu như nhãn; thay đổi vật phẩm hoặc người chăm rồi truy vấn lại sẽ cho cảnh báo mới.

## Nhánh sinh thật

Runner tạo ba bản thế giới độc lập rồi lần lượt chọn `SITE-HOME`, `SITE-FIELD` và `SITE-MARKET`. Mỗi nhánh phải:

- ghi đúng `selected_site_id`, hộ, phòng và người chăm trong `WorldEntryState`;
- tạo P00 tại đúng tọa độ/phòng;
- gán P00 vào đúng hộ và thêm vào danh sách thành viên;
- tạo semantic hash khác hai nhánh còn lại.

Save/load ở trạng thái chưa chọn vẫn dựng lại đúng ba nơi khả thi. Sau khi sinh, client lấy `worldEntry.householdId` để trang **Hộ gia đình** hiện đúng hộ đã chọn, thay vì luôn mở H01.

## Giao diện

Mỗi thẻ nơi sinh hiện:

- tên địa điểm và loại địa điểm;
- tên hộ, phòng, người chăm và kỹ năng;
- lượng sữa, thức ăn, nước và củi;
- chip cảnh báo rủi ro hoặc xác nhận không có cảnh báo;
- nút sinh chỉ bật khi validator cho phép.

Giao diện responsive đã được kiểm tra cả chiều rộng điện thoại 390 px và máy tính 1.000 px.

## Kiểm chứng

- Runner: `tool/verify_v2_19_multiple_birth_households.dart`.
- Hash lúc chờ lựa chọn: `491d7f5e50d4d551`.
- Catalog V2.19: 18 điều kiện; tổng catalog chạy được: 475.
- Tổng kiểm tra: 24/24 runner và 18/18 widget test.
- 23 hash V0–V2.18 giữ nguyên.

## Giới hạn và bước tiếp

- H02/H03 hiện là fixture client, chưa được sinh tự động từ 36 hộ cohort của lịch sử.
- Hai hộ mới mới có một người lớn; chưa có cha mẹ, huyết thống, quan hệ, ký ức hoặc câu chuyện gia đình.
- Rủi ro mới được trình bày trước sinh; chúng chưa tạo biến cố riêng sau sinh ngoài các hệ tiêu thụ vật chất chung.
- H02/H03 chưa có lịch nghề, sản xuất và tuyến tiếp tế riêng sâu như H01.

V2.20 nên đưa việc tạo hộ sinh vào bộ sinh xác định theo seed/lịch sử, đồng thời sinh quan hệ cha mẹ–người chăm và nguồn gốc gia đình tối thiểu. Như vậy lựa chọn nơi sinh sẽ bắt đầu tạo câu chuyện đời sống thay vì chỉ chọn bộ tài nguyên.

## Liên kết

- [[K5_25_V2_18_HAU_QUA_LICH_SU_VAO_SNAPSHOT]]
- [[K5_23_V2_16_CHON_NOI_SINH_SAU_KHI_TAO_THE_GIOI]]
- [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- [[STATE]]
- [[DECISIONS]]
