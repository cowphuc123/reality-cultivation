---
aliases:
  - V2.9 tuyến vận tải thật
tags:
  - trien-khai
  - moi-truong
  - kinh-te
---

# K5.16 — V2.9 tuyến vận tải thật có vị trí trung gian

## Kết quả có thể chơi

Từ V2.2, chuyến tiếp tế đã có người chở và giờ đến thật — nhưng "đường đi" chỉ là một nhãn chữ, giờ đến là 12 giờ viết cứng, độ trễ là hằng số 6 giờ trong fixture, và người chở nhảy thẳng từ vị trí này sang vị trí kia. Món này đã nằm trong danh sách chờ từ đó. V2.9 làm thật.

### Đường đi có hình dạng

Một tuyến gồm các **điểm mốc có vị trí thật** nối nhau bằng các **chặng có địa hình**. Tuyến trong fixture dài 12 km:

| Chặng | Từ → đến | Địa hình | Tốc độ còn |
| --- | --- | --- | --- |
| 1 | Chợ An Khê → Chân đèo | đường bằng | 100% |
| 2 | Chân đèo → Khúc lội suối | **đường núi** | 40% |
| 3 | Khúc lội suối → Sân hộ | lội suối | 60% |

Người chở đi từng chặng một, và **vị trí thật đổi theo** khi tới mỗi điểm mốc — không còn nhảy cóc.

### Giờ đến ra từ tốc độ, không phải viết sẵn

Tốc độ mỗi chặng là tích của ba thứ:

```
tốc độ = tốc độ nền × địa hình × hệ số tải × sức lực người chở
```

- **Địa hình**: đường núi còn 40% tốc độ.
- **Tải hàng**: mang 39 kg hàng còn 61% tốc độ (đầy tải 40 kg thì chậm nhất 40%).
- **Sức lực**: lấy thẳng từ cơ thể người chở ở V2.7/V2.8 — người đói hoặc khát đi chậm hơn.

Thời gian đi = quãng đường ÷ tốc độ, làm tròn lên để không ai về sớm hơn thực tế.

### Trễ giờ nay là hệ quả, không phải hằng số

Giờ đến dự kiến tính theo đường bằng, người khỏe, tay không. Chặng nào đi lâu hơn mức đó thì chuyến hàng trễ thêm đúng phần chênh, và **lý do trễ trỏ về chặng tốn giờ nhất** chứ không phải chặng đi gần đây nhất.

Chuyến đầu trong fixture: dự kiến về lúc giây 420.402, về thật lúc 438.676 — **trễ 18.274 giây (khoảng 5 giờ) vì đoạn đường núi**. Con số ấy không nằm ở đâu trong dữ liệu; nó ra từ 4 km đường núi ở 40% tốc độ với 39 kg hàng trên lưng.

### Cơ thể nối vào vận tải

Đây là chỗ các hệ trước gặp nhau. Cho người chở gầy đi (44 kg trên chuẩn 52 kg) và cạn dự trữ năng lượng, cùng tuyến ấy, cùng hàng ấy:

> Chuyến hàng trễ **48.415 giây** thay vì 18.274 — **chậm thêm hơn 8 giờ** chỉ vì người vác hàng yếu.

Không có dòng luật nào nói "người yếu thì hàng về muộn". Nó ra từ `sức lực → tốc độ → thời gian mỗi chặng → giờ đến`.

## Trạng thái máy mới

- `RouteWaypoint`, `RouteLeg`, `TradeRoute`: điểm mốc có vị trí, chặng có địa hình, quãng đường suy từ vị trí hai đầu, và `slowestLeg` để giải thích.
- `CarrierPace`: quy tắc tốc độ và thời gian đi, tách riêng để kiểm chứng được như một quy tắc thuần túy.
- `WorldState.routes`: kho tuyến đường của thế giới.
- `SupplyJourneyState` thêm `routeId`, `legIndex`, `legCount`, `travelledMm`, `worstLegLostSeconds`.
- `SupplyJourneyView` thêm `route`, `progressPerMille`, `currentWaypointName`.

Sự kiện mới: `route_created`, `route_leg_started`, `route_leg_arrived`.

## Giao diện

Thẻ chuyến hàng hiện tên tuyến, đang ở điểm mốc nào, chặng thứ mấy trên tổng số, đã đi bao nhiêu trên bao nhiêu ki lô mét, và nếu trễ thì trễ mấy giờ **vì địa hình nào**. Nhật ký thêm ba mốc tuyến đường bằng tiếng Việt, nằm trong nhóm lọc Hộ gia đình.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.9 đạt tới ngày 8; lưu lúc người chở còn đang giữa đường rồi chạy tiếp cho cùng hash. Hash ban đầu là `a89dc7db61e7173d`; từ V2.10 đổi thành `a4830eb8844ec469` khi chuyến hàng lưu thêm đường đã chọn, xem [[K5_17_V2_10_HAI_CHIEU_VA_NGA_RE]]. Mọi điều kiện V2.9 vẫn đạt.
- **Mười ba runner V0–V2.8 giữ nguyên hash.** Nhánh tuyến thật là đường riêng: thế giới không khai báo `supply_route_id` vẫn chạy đúng nhánh cũ với độ trễ fixture.
- Catalog `game/artifacts/conditions/v2_9_trade_route.json` có 23 điều kiện.
- 13/13 widget test đạt. Bài test cũ của V2.2 đã được chỉnh lại: nó từng kiểm tra "trễ 6 giờ" — con số hằng số nay không còn tồn tại, nên bài test giờ kiểm tra tên tuyến và quãng đã đi.
- Web release **chưa** đóng gói lại và **chưa** đẩy lên GitHub, theo cách làm mới bạn yêu cầu.

## Giới hạn và bước tiếp theo

Tuyến vẫn là **một trục một chiều**: vị trí là một số mm, không phải tọa độ hai chiều, nên chưa có ngã ba, chưa có đường vòng, chưa có chọn tuyến. Địa hình là một hệ số cố định gắn vào chặng — chưa có mưa làm đường lầy, chưa có mùa, chưa có đêm tối làm chậm.

Người chở đi một mạch không nghỉ, không ăn, không uống dọc đường; cơ thể chỉ được tính lúc chốt ngày ở nhà. Chưa có cướp đường, chưa có hỏng hàng, chưa có phương tiện (gánh bộ hay xe kéo đều như nhau), chưa có chi phí hay giá cả ở chợ.

Các hệ số 1.200 mm/s đường bằng, 40 kg sức mang, chậm tối đa 40% khi đầy tải, cùng ba mức địa hình 100/40/60 phần trăm đều là fixture kỹ thuật, chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho người lớn ốm được như trẻ sơ sinh, hoặc mở vị trí thành tọa độ hai chiều để tuyến có ngã rẽ thật.

## Liên kết

- Bản trước: [[K5_15_V2_8_NUOC_VA_CON_KHAT]]
- Chuyến tiếp tế đầu tiên: [[K5_9_V2_2_VAN_CHUYEN_BENH_SINH_LY_NGUOI_THAY]]
- Cơ thể người lớn: [[K5_14_V2_7_CO_THE_NGUOI_LON]]
- Môi trường và địa lý (thiết kế): [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
