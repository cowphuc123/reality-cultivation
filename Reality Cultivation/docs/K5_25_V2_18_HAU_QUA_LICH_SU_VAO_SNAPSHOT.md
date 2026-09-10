---
title: K5.25 — V2.18 hậu quả lịch sử vào snapshot
aliases:
  - V2.18 di sản lịch sử
tags:
  - reality-cultivation
  - k5
  - world-history
  - vertical-slice
---

# K5.25 — V2.18 hậu quả lịch sử vào snapshot

## Mục tiêu lát cắt

V2.17 đã tạo được lịch sử nhưng trạng thái chơi hiện tại vẫn dùng nguyên tồn kho fixture. V2.18 nối hai phía: đất canh tác, giao thương, áp lực tài nguyên và trận lũ trong tiền sử nay để lại hậu quả số lên vật phẩm và các chuyến tiếp tế mà người chơi thật sự gặp sau khi sinh.

Hậu quả chỉ được áp dụng sau `world_history_completed` và trước `world_entry_opened`. P00 vẫn không tồn tại trong khoảng này.

## Trạng thái mới

`HistoricalLegacyState` được lưu trong `historical_legacy` của save, gồm:

- fingerprint của lịch sử nguồn;
- phiên bản công thức `v2.18.0`;
- hệ số dự trữ lương thực, nước, củi và sữa trẻ nhỏ;
- hệ số sản lượng mỗi chuyến tiếp tế;
- mức thiệt hại lũ tích lũy;
- danh sách từng vật phẩm với lượng trước, lượng sau, hộ, loại tài nguyên và hệ số đã dùng.

Mọi thay đổi vì vậy có thể lần ngược về lịch sử và vật phẩm cụ thể, thay vì chỉ hiện một dòng kể chuyện.

## Phép chiếu từ lịch sử sang hiện tại

Các công thức hiện là **fixture kỹ thuật chưa được người dùng duyệt làm cân bằng cuối**. Tất cả dùng số nguyên phần nghìn và chặn trong khoảng 500–1.400 để tái lập giống nhau trên Dart VM và web.

| Hậu quả | Nguồn lịch sử |
| --- | --- |
| Lương thực | đất canh tác + giao thương − áp lực tài nguyên |
| Nước | giao thương − áp lực tài nguyên − thiệt hại lũ |
| Củi | giao thương − áp lực khai thác |
| Sữa trẻ nhỏ | giao thương − áp lực tài nguyên |
| Mỗi chuyến tiếp tế | giao thương − áp lực tài nguyên |

Với seed mặc định `20260907`, lịch sử 741 năm tạo kết quả:

| Kho / dòng hàng | Hệ số | Trước | Sau |
| --- | ---: | ---: | ---: |
| Lương thực | 1.113/1.000 | 15.000 g | 16.695 g |
| Nước sạch | 991/1.000 | 48.000 ml | 47.568 ml |
| Củi | 944/1.000 | 4.500 g | 4.248 g |
| Sữa trẻ nhỏ | 1.000/1.000 | 10.000 ml | 10.000 ml |
| Tiếp tế | 1.103/1.000 | 7.500 g / 30.000 ml / 1.500 ml | 8.272 g / 33.090 ml / 1.654 ml |

Thiệt hại lũ được giữ ở 138/1.000. Lương thực tăng nhờ đất đã khai khẩn và mạng trao đổi; nước và củi giảm nhẹ do dấu lũ và áp lực khai thác; tuyến chợ làm mỗi chuyến hàng lớn hơn.

## Rào an toàn nhập thế

Hệ thống dựng toàn bộ tồn kho hậu quả trong một bản tạm, rồi chạy lại cùng validator nơi sinh của V2.16 trên bản tạm đó. Chỉ khi còn ít nhất một nơi có phòng, người chăm, sữa và quyền dùng hợp lệ thì thay đổi mới được ghi vào `WorldState`.

Runner còn tìm một seed làm hệ số sữa nhỏ hơn 1.000 và đặt kho cuối chỉ có một đơn vị. Phép nhân làm kho về 0, validator từ chối snapshot trước khi ghi di sản. Điều này chứng minh điều kiện an toàn không phải cờ đặt sẵn cho seed mặc định.

## Giao diện

Màn chọn nơi sinh và trang Hồ sơ có khối **Hậu quả còn lại trong đời sống hiện tại**. Khối này hiện:

- hệ số của bốn loại dự trữ và tiếp tế;
- lượng trước → sau của từng vật phẩm;
- thiệt hại lũ và phiên bản công thức.

Nhật ký có mốc `historical_legacy_applied` nằm giữa hoàn tất tiền sử và mở nhập thế.

## Tương thích và kiểm chứng

- `simulatePrehistory(..., applyLegacy: false)` vẫn là mặc định, nên runner và hash V2.17 không đổi.
- Client mới bật `applyLegacy: true`.
- Save cũ không có `historical_legacy` vẫn nạp như trước.
- Runner V2.18: `tool/verify_v2_18_historical_legacy.dart`.
- Hash snapshot trước chuyến giao thử: `e777dfadd87c172a`.
- Catalog V2.18: 16 điều kiện; tổng catalog chạy được: 457.
- Tổng kiểm tra: 23/23 runner và 18/18 widget test.

## Chưa làm và bước tiếp

- Vẫn chỉ có một hộ vật chất hóa và một nơi sinh khả thi.
- Lịch sử chưa sinh hoặc xóa hẳn địa điểm, hộ, nghề, quyền sở hữu hay quan hệ.
- Công thức mới chiếu đại lượng vùng vào bốn kho fixture; chưa có đất, thủy văn và tài nguyên theo ô bản đồ.
- Chuyến tiếp tế đổi lượng nhưng chưa đổi tần suất, hàng hóa, giá hoặc khả năng tuyến bị đứt.

V2.19 nên sinh thêm ít nhất hai hộ và nhiều hoàn cảnh sinh từ snapshot lịch sử. Mỗi nơi phải khác nhau ở nguồn lực, người chăm, vị trí và rủi ro; validator tiếp tục quyết định nơi nào thật sự khả thi.

## Liên kết

- [[K5_24_V2_17_EPOCH_TIEN_SU_VI_MO]]
- [[K5_23_V2_16_CHON_NOI_SINH_SAU_KHI_TAO_THE_GIOI]]
- [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- [[STATE]]
- [[DECISIONS]]
