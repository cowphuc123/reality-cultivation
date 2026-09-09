---
aliases:
  - V2.14 bản đồ vùng đầu tiên
tags:
  - trien-khai
  - ban-do
  - dia-ly
  - gui
---

# K5.21 — V2.14 bản đồ vùng đầu tiên

## Mục tiêu

V2.10 đã có tọa độ hai chiều nhưng chỉ tuyến vận tải dùng nó. V2.14 biến tọa độ thành một bản đồ thế giới có thể đọc: vùng có biên thật, địa điểm có tâm và bán kính thật, còn người, phòng và vật được suy ra đang thuộc địa điểm nào từ vị trí hiện tại.

Đây là bước nền trực tiếp cho U013: tạo thế giới, mô phỏng tiền sử, chọn một nơi trên bản đồ rồi sinh nhân vật. V2.14 chưa làm toàn bộ luồng đó; nó tạo cấu trúc địa lý đầu tiên để các bước sau có chỗ bám.

## Mô hình vùng và địa điểm

`WorldRegion` là hình chữ nhật theo milimét, gồm góc nhỏ nhất, chiều rộng và chiều cao. Cả điểm đúng trên biên đều thuộc vùng; vượt biên một milimét thì không.

`WorldSite` gồm:

- vùng mà nó thuộc về;
- tên và loại địa điểm;
- tâm là `WorldPoint` hai chiều;
- bán kính ảnh hưởng.

Tâm địa điểm phải nằm trong vùng, kích thước vùng và bán kính phải dương. Địa điểm có thể chồng lấn; khi một vị trí nằm trong nhiều địa điểm, nơi có tâm gần hơn được chọn, rồi dùng ID để phá hòa nhằm giữ tính tái lập.

## Không lưu nhãn địa điểm trùng lặp

Người, vật và phòng không có thêm trường `siteId`. Cổng truy vấn tính địa điểm từ tọa độ mỗi lần đọc:

- người dùng `PersonState.point`;
- vật dùng `positionMm` và trục Y mới `positionYMm`;
- phòng dùng mốc hai chiều đã có từ V2.10.

Cách này tránh tình trạng tọa độ nói người đã đi nhưng nhãn địa điểm vẫn mắc ở nơi cũ. Người đứng trong vùng nhưng ngoài mọi bán kính được đếm riêng thay vì bị ép vào địa điểm gần nhất.

## Fixture An Khê

Thung lũng thử rộng 13 × 3,5 km, gồm năm địa điểm:

| Địa điểm | Loại | Tọa độ tâm |
| --- | --- | --- |
| Hộ ven suối | Khu cư trú | (0,012; 0) km |
| Khúc lội suối | Sông suối | (4,012; 0) km |
| Đồng ngoài | Đồng ruộng | (4,012; 3) km |
| Chân đèo | Đèo | (8,012; 0) km |
| Chợ An Khê | Chợ | (12,012; 0) km |

Các tâm này khớp với điểm mốc của tuyến An Khê đã có, nên bản đồ và vận tải đang nói về cùng một không gian.

## Giao diện

Trang **Hồ sơ** có thêm phần **Bản đồ vùng**. Trên điện thoại và máy tính, phần này hiện:

- số vùng, số địa điểm và số người ngoài mọi địa điểm;
- dãy thẻ tên địa điểm để quét nhanh;
- thẻ mở rộng của từng nơi với loại, tọa độ, bán kính, người, phòng và vật đang ở đó.

Nhật ký có câu tiếng Việt cho `region_created` và `site_created`. Giao diện vẫn là text game: vị trí được trình bày bằng chữ, số và thẻ, không cần bản đồ hình ảnh.

## Kiểm chứng

- Biên vùng và bán kính đúng tới một milimét.
- Trục Y đưa đúng người và vật vào Đồng ngoài thay vì Khúc lội suối có cùng X.
- Người giữa đường được ghi là ngoài mọi địa điểm.
- Tâm địa điểm ngoài vùng bị từ chối.
- Lưu/nạp giữ nguyên bản đồ và trục Y của vật phẩm.
- Runner V2.14 đạt hash `1d70b51a89d4b142`.
- Catalog `game/artifacts/conditions/v2_14_region_map.json` có 22 điều kiện.
- `dart analyze`, `flutter analyze`, 19/19 runner và 16/16 widget test đạt.
- Toàn bộ 18 hash V0–V2.13 giữ nguyên vì các trường bản đồ và trục Y của vật đều tùy chọn, không xuất hiện trong save cũ.

## Giới hạn và bước tiếp theo

Năm địa điểm hiện là fixture viết sẵn, chưa sinh từ seed, địa hình hay lịch sử. Bản đồ chưa có ô đất, độ cao, khí hậu, mùa, tài nguyên tự nhiên, biên giới chính trị hoặc tầm nhìn theo kiến thức nhân vật. Người chơi chưa chọn nơi sinh; UI đang cho xem toàn bộ dữ liệu kỹ thuật của vùng thử.

Bước tiếp theo đề xuất là V2.15 sinh vùng và địa điểm xác định từ seed, hoặc nối chuyển động vào các mốc vào/rời địa điểm. Để tiến thẳng tới U013, ưu tiên worldgen xác định theo seed rồi mới dựng màn chọn nơi sinh.

## Liên kết

- Bản trước: [[K5_20_V2_13_GANH_VIEC_KHI_NGHI_BENH]]
- Vị trí hai chiều: [[K5_17_V2_10_HAI_CHIEU_VA_NGA_RE]]
- Khởi tạo và nhập thế: [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- Địa lý sâu (thiết kế): [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
