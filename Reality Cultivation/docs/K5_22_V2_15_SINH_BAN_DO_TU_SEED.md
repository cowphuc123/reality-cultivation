---
aliases:
  - V2.15 sinh bản đồ từ seed
tags:
  - trien-khai
  - worldgen
  - seed
  - gui
---

# K5.22 — V2.15 sinh bản đồ từ seed

## Mục tiêu

V2.14 vật chất hóa vùng và địa điểm nhưng toàn bộ hình học vẫn được viết thẳng trong fixture. V2.15 thêm bước worldgen chạy thật đầu tiên: seed quyết định kích thước vùng, tọa độ và bán kính địa điểm trước khi các thực thể khác được tạo.

Đây mới là lát cắt hình học của U013. Nó chưa mô phỏng tiền sử, chưa tạo địa hình hoặc dân cư, và người chơi vẫn được sinh tự động trong hộ thử sau khi bản đồ hình thành.

## Bộ sinh xác định

`WorldGenerator.generate` nhận ba đầu vào có ý nghĩa:

- root seed trong khoảng 1–2.147.483.646;
- cấu hình nội dung `first_region_ankhe_v1`;
- phiên bản thuật toán `v2.15.0`.

Cùng ba đầu vào này sinh cùng vùng, cùng năm địa điểm và cùng dấu vân tay. Seed khác làm thay đổi hình học. Miền seed 31-bit dương giúp điện thoại, máy tính và web dùng chung một miền số nguyên chính xác.

Bộ sinh dùng stream Park–Miller 31-bit tự viết thay vì `Random()`. Phép nhân lớn nhất vẫn nằm dưới giới hạn số nguyên chính xác của JavaScript. Kích thước vùng và từng địa điểm có stream dẫn xuất bằng nhãn riêng, nên về sau thêm một miền sinh mới không nhất thiết làm xô lệch tất cả miền cũ.

## Kết quả seed mặc định

Seed `20260907` tạo:

- vùng Thung lũng An Khê rộng 13.618.519 mm và cao 4.195.124 mm;
- năm vai trò: hộ ven suối, khúc lội suối, đồng ngoài, chân đèo và chợ;
- dấu vân tay worldgen `247ad223a40016d6`.

Tên và năm vai trò vẫn thuộc gói nội dung thử. Seed hiện chỉ sinh kích thước, vị trí và bán kính. Mọi hình tròn địa điểm đều nằm trọn trong biên vùng.

## Công bố qua mô phỏng

Kết quả không được ghi thẳng vào `WorldState`. `Simulation.materializeWorld` đưa lần lượt vùng và địa điểm qua hàng đợi sự kiện, rồi mới xử lý `world_genesis_completed`.

Mốc hoàn tất kiểm tra:

- root seed trùng với seed của mô phỏng;
- số vùng và địa điểm đã vật chất hóa khớp kế hoạch;
- dấu vân tay tính lại từ bản đồ khớp dấu vân tay được công bố;
- thế giới chưa từng công bố worldgen trước đó.

Sai seed bị từ chối trước khi ghi một phần vào hàng đợi. Dấu vân tay giả bị từ chối. Provenance gồm seed, phiên bản, config, số lượng và fingerprint được lưu/nạp cùng thế giới.

## Fixture client bám bản đồ sinh ra

Phòng, bốn người trong hộ, năm kho vật và điểm sân được đặt tương đối quanh tâm `SITE-HOME`. Người vận chuyển bắt đầu tại tâm `SITE-MARKET`. Năm waypoint của tuyến chợ lấy trực tiếp tọa độ các địa điểm vừa sinh.

Nhờ vậy sau khi thay seed, con người và tuyến đường không còn mắc ở tọa độ của bản đồ cũ. Trên seed mặc định, cả năm người đều thuộc một địa điểm thật.

## Giao diện điện thoại và máy tính

Hộp **Tạo thế giới mới** có ô nhập seed. Seed ngoài miền hỗ trợ không đóng hộp thoại và hiện lỗi. Sau khi tạo, game lưu ngay bản mới.

Trang **Bản đồ vùng** hiện:

- seed gốc;
- phiên bản bộ sinh;
- dấu vân tay worldgen;
- kích thước và tọa độ thực tế vừa sinh.

Dùng lại seed cũ tái tạo cùng bản đồ. Nhập seed khác tạo bản đồ khác và lưu provenance vào save.

## Kiểm chứng

- Runner V2.15 đạt world hash `5595e41dd7f499bc`.
- Seed mặc định đạt fingerprint `247ad223a40016d6`.
- Catalog `game/artifacts/conditions/v2_15_seeded_world_generation.json` có 28 điều kiện.
- `dart analyze` và `flutter analyze` đạt.
- 20/20 runner đạt; toàn bộ 19 hash V0–V2.14 giữ nguyên.
- 17/17 widget test đạt, gồm nhập seed mới và từ chối seed 0.
- Save/load giữ nguyên hash và provenance worldgen.

## Giới hạn và bước tiếp theo

Worldgen hiện chỉ có một vùng và năm template địa điểm. Chưa có ô đất, độ cao, sông theo thủy văn, khí hậu, đất, sinh thái, linh khí, tài nguyên, đường sinh từ địa hình, dân số, văn hóa, tổ chức hoặc lịch sử. Chưa đo parity của fingerprint trên bản PWA shared fixture.

Luồng client vẫn tạo người chơi ngay sau bản đồ. Bước tiếp theo hợp lý là tách tạo thế giới khỏi sinh nhân vật: cho xem tiến độ các giai đoạn, xem bản đồ đã tạo, chọn địa điểm sinh hợp lệ rồi mới tạo `P00`. Mô phỏng tiền sử sẽ được thêm theo các epoch sau khi vòng đời tạo–công bố–chọn nơi đã rõ.

## Liên kết

- Bản trước: [[K5_21_V2_14_BAN_DO_VUNG_DAU_TIEN]]
- Khởi tạo và nhập thế: [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- Kiến trúc sinh thế giới: [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]
- Kế hoạch tổng: [[MASTER_PLAN]]
