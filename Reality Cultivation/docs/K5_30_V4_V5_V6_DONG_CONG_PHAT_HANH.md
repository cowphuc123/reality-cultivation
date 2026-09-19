---
title: K5.30 — Đóng cổng V4, V5 và V6
aliases:
  - Phát hành V4 V5 V6
tags:
  - k5
  - phat-hanh
  - v4
  - v5
  - v6
---

# K5.30 — Đóng cổng V4, V5 và V6

Ngày kiểm chứng: 2026-09-19.

Lượt phát hành này đóng ba chặng đã có mã và bằng chứng hữu hạn. Không thêm hệ thống ngoài cổng trong lúc kiểm chứng; các thay đổi mã chỉ sửa lỗi mà runner hoặc widget test làm lộ ra.

## Kết quả V4 — tuổi thơ

- P00 chạy liên tục qua 2.190 ngày, đạt giai đoạn tuổi thơ giữa mà không dùng lệnh nhảy tuổi.
- Cơ thể nhận thức ăn và nước từ kho thật; có cả ngày tăng trưởng đủ và bị hạn chế. Khối lượng cuối là 15.614 g, tương đương trưởng thành 2.099 ngày.
- Bốn trục hoạt động, gắn bó sau sơ sinh, nguy hiểm và nguồn tri thức đều có bằng chứng.
- Ký ức gần giữ tối đa 64 mục; lần chạy đã nén 91 ký ức nhưng vẫn giữ mốc nguy hiểm cùng nguồn N01.
- Chạy liền, save/load ở năm thứ ba và replay cùng kết thúc ở hash `afefc3dd5537605a`.

## Kết quả V5 — worldgen nhỏ

- Seed `20260907` tái hiện cùng bản đồ, lịch sử và hộ; seed khác đổi fingerprint.
- Tiền sử chạy 741 năm qua 3 epoch, 192 bước vĩ mô, giữ 6 mốc neo và cửa sổ 4 mốc gần.
- Hậu quả lịch sử đổi 4 nguồn tự nhiên, 5 quần thể sinh thái và 4 điểm khu dân cư bằng ledger trước/sau hữu hạn.
- P00 chỉ xuất hiện sau khi chọn nơi sinh hợp lệ; fixture chọn `SITE-MARKET`.
- Chạy liền, save/load trước khi tiền sử hoàn tất và replay cùng kết thúc ở hash `4e03e202361d0363`.

## Kết quả V6 — sinh kế

- Các runner riêng đạt cho sản xuất/workpiece, dịch vụ, lao động/trả công, chợ/escrow, vận chuyển và cú sốc thiếu hàng.
- Runner tổng hợp hai hộ chạy 30 ngày; gỗ, sợi, ngũ cốc, củ, lương thực thay thế, dược thảo, vật tư dịch vụ và tiền công đều đối chiếu được từ nguồn qua process tới đích.
- Ở ngày 15 và 30 không còn mẻ, cuộc hẹn, claim, shipment, order hoặc audit mắc kẹt; mọi kho không âm.
- Chạy liền, save/load ngày 15 và replay cùng kết thúc ở hash `b8fea49e313fe8ab`.

## Lỗi đã sửa trong lúc đóng cổng

1. Bữa ăn của hộ có thể dereference lịch rỗng khi người thực hiện bị một nghĩa vụ khác giữ thời gian.
2. Hộ không khai đủ ba kho ăn/uống/nhiên liệu có thể làm mô phỏng dừng thay vì ghi thiếu nguồn.
3. Settlement chợ có thể tạo item khi chủ mới chưa có tọa độ hợp lệ.
4. Nén ký ức coi `null` như một ảnh hưởng đang hoạt động và không giới hạn ký ức thường; đồng thời việc nén theo mã không an toàn khi hoạt động lặp mã.
5. Legacy V5 phụ thuộc thứ tự duyệt địa điểm, khiến save/load đổi thứ tự và đổi snapshot.
6. Fact quyết toán lao động ghi thứ tự map trực tiếp, khiến hash khác sau save/load dù số liệu giống nhau.
7. Bốn kỳ vọng widget test cũ giả định nhãn chỉ xuất hiện một lần hoặc ghim fingerprint/công thức V2.

## Cổng phát hành

- `dart analyze`: đạt, không có lỗi.
- 36/36 runner V0–V6: đạt.
- `flutter analyze`: đạt, không có lỗi.
- 22/22 widget test: đạt, gồm bố cục điện thoại và máy tính cho V4–V6.
- 29 catalog, 592 điều kiện triển khai: hợp lệ và không trùng mã.
- Flutter web release với base path `/reality-cultivation/`: build đạt.

Catalog mới: `v4_childhood_six_years.json`, `v5_small_worldgen.json`, `v6_livelihood_30_days.json`. Bộ kiểm tra chung nằm tại `game/tool/verify_catalogs.dart`.

## Bước kế tiếp

V4, V5 và V6 đã đóng. Chặng chức năng tiếp theo theo lộ trình là V7 — tu luyện. Trước lát cắt V7 đầu tiên phải khóa danh sách cổng hữu hạn của V7; không dùng ý tưởng ngoài cổng để kéo dài phiên bản.

## Liên kết

- [[STATE]]
- [[ACTIVE_WORK]]
- [[LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC]]
- [[CHANGELOG]]
