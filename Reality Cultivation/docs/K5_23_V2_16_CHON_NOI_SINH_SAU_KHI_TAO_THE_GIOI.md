---
aliases:
  - V2.16 chọn nơi sinh sau khi tạo thế giới
tags:
  - trien-khai
  - worldgen
  - nhap-the
  - gui
---

# K5.23 — V2.16 chọn nơi sinh sau khi tạo thế giới

## Mục tiêu

V2.15 sinh bản đồ rồi tạo P00 ngay trong cùng fixture. V2.16 tách hai thời điểm này: thế giới, địa điểm, NPC, phòng và kho vật chất phải tồn tại trước; người chơi xem các nơi có thể sinh, chọn một nơi hợp lệ, rồi sự kiện sinh mới tạo P00.

Đây là lát cắt chạy được đầu tiên của U013 và U014. Nó chưa mô phỏng hàng trăm–hàng vạn năm tiền sử, nhưng đã thiết lập đúng ranh giới để các epoch tiền sử được chèn vào trước lúc nhập thế mà không phải đổi lại vòng đời nhân vật.

## Trạng thái nhập thế

`WorldEntryState` được lưu trong thế giới với hai trạng thái:

- `awaitingBirthSite`: bản đồ và đời sống nền đã công bố, P00 chưa tồn tại;
- `born`: nơi sinh, hộ, phòng và người chăm đã chốt; P00 đã ra đời.

Save giữ `player_person_id`, tên, địa điểm, hộ, phòng và người chăm. Save cũ không có `world_entry` vẫn nạp được, nên các runner cũ không đổi hash.

## Nơi sinh là kết quả của thế giới thật

Mỗi `WorldSite` đều được đánh giá, nhưng không có cờ “mở khóa” viết sẵn. Một nơi chỉ hợp lệ khi cùng lúc có:

1. loại địa điểm là khu cư trú;
2. một phòng thật của một hộ nằm trong bán kính địa điểm;
3. một NPC thuộc hộ, có năng lực chăm trẻ, đang sẵn sàng và có mặt tại địa điểm;
4. nguồn `infant_feed` còn số lượng dương;
5. NPC ấy có quyền dùng đúng vật phẩm đó.

Ứng viên được chọn xác định: phòng gần tâm địa điểm trước, nếu bằng nhau theo ID; người chăm có kỹ năng cao hơn trước, nếu bằng nhau theo ID. Trong fixture hiện tại chỉ `SITE-HOME` hợp lệ. Bốn nơi còn lại vẫn hiện và nói rõ vì sao bị khóa.

Nếu toàn thế giới không có nơi nào khả thi, sự kiện mở nhập thế bị từ chối. Hệ thống không tự sinh thêm sữa, chuyển NPC hay sửa hộ để chiều theo lựa chọn của người chơi.

## Chuỗi sự kiện sinh

Client gọi `openWorldEntry` sau khi đã xếp mọi sự kiện nền ở giây 0. Thứ tự thật là:

`world_genesis_completed` → phòng/NPC/vật/hộ tồn tại → `world_entry_opened` → lệnh `ChooseBirthSiteCommand` → `birth_site_selected` → `birth`.

Nhận lệnh chọn nơi chưa tạo người ngay. Chỉ khi hàng đợi xử lý sự kiện thì P00 mới được tạo ở tọa độ phòng, nối với hộ và người chăm. P00 cũng chỉ được thêm vào `memberIds` của hộ ở thời điểm sinh; trước đó hộ không chứa một thành viên “ma”. Lệnh dùng ID chống thực thi lặp như các lệnh mô phỏng khác.

Trong lúc chờ chọn, đồng hồ không chạy. Sau khi sinh, client lưu ngay rồi mới cho clock runner hoạt động.

## Sửa lỗi tọa độ phòng

Sự kiện `room_created` đã nhận `anchor_position_y_mm` từ V2.14 nhưng hàm áp dụng chỉ lưu trục X, khiến phòng client nằm ở Y=0 dù bản đồ hiển thị tọa độ hai chiều. V2.16 sửa nguồn dữ liệu này. Đây là lý do kiểm tra nơi sinh ban đầu phát hiện không có phòng thật tại `SITE-HOME`.

Các fixture runner cũ không dựa vào trục Y của phòng nên toàn bộ hash V0–V2.15 vẫn giữ nguyên.

## Giao diện điện thoại và máy tính

Lần tạo thế giới mới mặc định mở một màn riêng trước giao diện chơi. Màn này có:

- seed, fingerprint, số vùng, số địa điểm và số cư dân nền đã tạo;
- thanh xác nhận các giai đoạn tạo hiện tại đã hoàn tất;
- thẻ cho toàn bộ địa điểm, có loại, tọa độ, dân số, số phòng và lý do khả dụng;
- nút **Sinh tại đây** chỉ bật ở nơi đạt điều kiện;
- nút tạo lại bằng seed khác.

Bố cục một cột trên điện thoại và hai cột khi đủ rộng. Điều hướng, nút chạy thời gian và hồ sơ P00 chưa xuất hiện trước khi sinh. Sau khi chọn `SITE-HOME`, giao diện chơi hiện bình thường trên cả hai kích thước.

## Kiểm chứng

- Runner V2.16 đạt hash `de0313eb51f483ba`.
- Catalog `game/artifacts/conditions/v2_16_world_entry.json` có 18 điều kiện.
- 21/21 runner V0–V2.16 đạt; toàn bộ 20 hash V0–V2.15 giữ nguyên.
- 18/18 widget test đạt, gồm màn điện thoại 390 px, nơi hợp lệ/nơi khóa, chuyển sang chơi và lưu ngay sau sinh.
- `dart analyze` và `flutter analyze` đạt.
- Save/load giữ nguyên hash và nguồn gốc nhập thế.

## Giới hạn và bước tiếp theo

Màn “tiến độ” hiện phản ánh các giai đoạn đồng bộ đã hoàn tất, chưa phải tiến độ chạy nền theo thời gian thật. Thế giới nền mới có bốn NPC và một hộ fixture; chưa có sinh dân số, phả hệ, lịch sử hoặc epoch tiền game. Chưa có nhiều hộ hợp lệ để lựa chọn tạo khác biệt lâu dài.

Bước tiếp theo đề xuất là V2.17 thêm epoch tiền sử tối thiểu, có số năm do seed quyết định và các mốc lịch sử được lưu, nhưng vẫn phải giữ người chơi chưa tồn tại cho tới sau toàn bộ tiền sử. Sau đó mới mở rộng nhiều điểm sinh khả thi với gia đình và hoàn cảnh khác nhau.

## Liên kết

- Bản trước: [[K5_22_V2_15_SINH_BAN_DO_TU_SEED]]
- Khởi tạo và nhập thế: [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- Kế hoạch tổng: [[MASTER_PLAN]]
