---
aliases:
  - V2.10 hai chiều và ngã rẽ
tags:
  - trien-khai
  - moi-truong
  - kinh-te
---

# K5.17 — V2.10 vị trí hai chiều và tuyến có ngã rẽ

## Vì sao làm bây giờ

Suốt từ V0, mọi thứ trong game nằm trên **một trục**: vị trí là một con số mm duy nhất. Điều đó vừa đủ cho ba gian nhà và một tuyến đường thẳng, nhưng chặn hai thứ đã được người dùng xác nhận:

- **U013**: người chơi chọn vị trí **trên bản đồ** rồi nhân vật sinh ra ở đó.
- **K4.4**: địa lý, lưu vực, khí hậu — không thứ nào biểu diễn được trên một trục.

Refactor này càng để lâu càng đắt, vì mỗi lát cắt lại thêm chỗ dùng vị trí. Nên làm bây giờ.

## Thêm trục mà không phá 14 hash cũ

Điểm khó: 14 bộ chạy kiểm chứng đều dựa vào khoảng cách, và đó là tín hiệu phát hiện hồi quy duy nhất của dự án. Đổi mô hình vị trí thì mọi hash đổi theo — mất sạch tín hiệu.

Cách làm: trục thứ hai là **tùy chọn**, mặc định 0. Khoảng cách dùng công thức hai chiều bằng số nguyên:

```
khoảng cách = isqrt(dx² + dy²)      khi dy ≠ 0
khoảng cách = |dx|                  khi dy = 0   (đường tắt, tính chính xác)
```

Với số chính phương thì `isqrt(dx²) = |dx|` đúng tuyệt đối, nên **mọi thế giới một chiều cho kết quả y như trước**. Kết quả: `dart analyze` sạch và **cả 14 hash giữ nguyên** sau khi đổi mô hình vị trí. Đây là điều kiện V210-GEO-005 trong catalog.

Ba nơi lưu vị trí đều nhận trục y tùy chọn: người, mốc phòng, điểm mốc tuyến đường.

## Ngã rẽ thật, và người chở tự chọn

Hai chiều chỉ có nghĩa khi có cái gì lệch khỏi trục. Tuyến trong fixture có **hai lối** từ chợ về sân hộ:

| Lối | Quãng đường | Địa hình | Thời gian |
| --- | --- | --- | --- |
| Qua đèo | 12.000 m | đường núi (40%) | **11,4 giờ** |
| Vòng qua đồng ngoài | 15.620 m | lội suối rồi đường bằng | **7,9 giờ** |

Điểm "Đồng ngoài" lệch trục 5 km, nên đường vòng **dài hơn 30% về mét nhưng nhanh hơn 30% về giờ**. Người chở tự chọn bằng thuật toán Dijkstra trên **thời gian đi**, không phải trên quãng đường — và chọn đúng đường vòng.

### Sức lực đổi cả lựa chọn, không chỉ tốc độ

Mỗi chặng có thể đòi sức lực tối thiểu. Khúc lội suối đòi 600/1000:

- **Người khỏe** (sức 1000): qua suối được → đi đường vòng, 7,9 giờ.
- **Người gầy** (44 kg trên chuẩn 52 → sức 486): không qua nổi suối → **buộc phải leo đèo**.
- **Người kiệt sức** (40 kg → sức 230): không qua nổi cả đèo lẫn suối → ghi `supply_route_impassable`, **chuyến hàng không khởi hành**.

Ở V2.9, sức lực chỉ làm người ta đi *chậm hơn* trên cùng một con đường. Nay nó đổi **con đường họ đi được** — và ở mức tệ nhất là đi hay không đi.

## Lỗi đã sửa: người khai là gầy vẫn khỏe như thường

Dựng fixture V2.10 thì lộ ra: hàm đọc payload cơ thể từ V2.7 **bỏ qua `healthy_mass_g` nếu không kèm `energy_reserve_kj`**. Nghĩa là khai một người 44 kg trên chuẩn 52 kg mà không khai dự trữ thì hệ thống lấy 44 kg làm luôn chuẩn khỏe mạnh → sức lực 1000, không gầy chút nào.

V2.9 tình cờ không trúng lỗi này vì biến thể người yếu của nó khai cả hai trường. Nay hai trường được đọc độc lập.

Sửa lỗi này **không làm đổi hash nào** — các fixture cũ hoặc không dùng `healthy_mass_g`, hoặc đã dùng kèm dự trữ.

## Trạng thái máy mới

- `WorldPoint`, `integerSquareRoot` trong `geometry.dart`: vị trí hai chiều và khoảng cách bằng số nguyên.
- `PersonState.positionYMm`, `RoomState.anchorPositionYMm`, `RouteWaypoint.positionYMm`: đều tùy chọn, mặc định 0.
- `RouteLeg.minCapabilityPerMille`: sức lực tối thiểu để qua chặng.
- `TradeRoute`: `originId`/`destinationId`, `legsFrom`, `legBetween`, `hasFork`, `fastestPath`, `pathSeconds`, `pathDistanceMm`.
- `SupplyJourneyState.pathWaypointIds`: đường người chở đã chọn.
- `SupplyJourneyView`: `pathNames`, `chosenAmongForks`, `pathDistanceMm`.

Sự kiện mới: `supply_route_impassable`.

## Giao diện

Thẻ chuyến hàng hiện **lộ trình đã chọn** dưới dạng tên các điểm mốc nối bằng mũi tên, và nói rõ "Đã chọn lối" khi tuyến có ngã rẽ — vì lúc đó đường đi là một quyết định thật, không phải con đường duy nhất. Tiến độ tính theo chiều dài đường đã chọn chứ không phải toàn bộ tuyến. Nhật ký thêm mốc tuyến không qua nổi.

Thế giới khởi tạo của client nay cũng có ngã rẽ: từ chân đèo có thể vòng qua đồng ngoài. Người chở khỏe chọn đường vòng, nên **không leo đèo nữa** — phần trễ còn lại đến từ 39 kg hàng trên lưng chứ không từ địa hình.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.10 đạt tới ngày 8; lưu lúc người chở còn giữa đường rồi chạy tiếp cho cùng hash `2a87b934f03e0f29`.
- **Mười ba runner V0–V2.8 giữ nguyên hash** qua cả hai bước: thêm trục thứ hai, và thêm đồ thị tuyến đường.
- **Hash V2.9 đổi `a89dc7db61e7173d` → `a4830eb8844ec469`** vì chuyến hàng nay lưu thêm đường đã chọn. V2.9 là fixture tuyến duy nhất nên cũng là fixture duy nhất chịu ảnh hưởng; toàn bộ điều kiện của nó vẫn đạt.
- Catalog `game/artifacts/conditions/v2_10_two_axes_and_fork.json` có 23 điều kiện.
- 14/14 widget test đạt. Bài test tuyến của V2.9 đã chỉnh lại: nó từng đòi `delayReason == 'duong_nui'`, nhưng nay người chở khỏe tránh được đèo nên lý do trễ là tải hàng.
- Web release **chưa** đóng gói lại và **chưa** đẩy lên GitHub, theo cách làm mới.

## Giới hạn và bước tiếp theo

Hai chiều đã có nhưng **chưa ai dùng ngoài tuyến vận tải**: ba gian nhà vẫn nằm trên trục, chưa có bản đồ, chưa có vùng, chưa có worldgen. `WorldPoint` là nền để làm những thứ đó, chứ chưa phải chúng.

Đường đi vẫn là đồ thị viết sẵn trong fixture, không phải sinh ra từ địa hình. Chọn đường tính theo giờ với **giả định địa hình không đổi** — chưa có mưa làm đường lầy, chưa có mùa, chưa có đêm. Người chở chỉ chọn một lần lúc khởi hành, không đổi ý giữa đường khi gặp sự cố.

Các hệ số ba mức địa hình 100/40/60 phần trăm, yêu cầu sức 300 cho đèo và 600 cho suối đều là fixture kỹ thuật, chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho người lớn ốm được như trẻ sơ sinh, hoặc bắt đầu bản đồ vùng để `WorldPoint` có chỗ dùng thật.

## Liên kết

- Bản trước: [[K5_16_V2_9_TUYEN_VAN_TAI_THAT]]
- Cơ thể người lớn: [[K5_14_V2_7_CO_THE_NGUOI_LON]]
- Luồng khởi tạo thế giới (U013): [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- Địa lý và khí hậu (thiết kế): [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
