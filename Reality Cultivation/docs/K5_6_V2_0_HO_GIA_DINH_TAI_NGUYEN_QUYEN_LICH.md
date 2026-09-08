---
aliases:
  - V2.0 hộ gia đình sống
tags:
  - trien-khai
  - v2
  - ho-gia-dinh
  - tai-nguyen
---

# K5.6 — V2.0 hộ gia đình, tài nguyên, quyền và lịch

## 1. Kết quả của lát cắt

V2.0 đưa một hộ bốn người vào cùng thế giới với P00:

| ID | Vai trò trong fixture |
| --- | --- |
| N01 | Người chăm sóc; có thể bỏ dở công việc để đáp lại tiếng khóc |
| N02 | Người nấu ăn; được cấp quyền dùng kho bữa ăn |
| N03 | Người kiếm củi; là thành viên nhưng không tự có quyền mở mọi kho |
| P00 | Trẻ sơ sinh do người chơi điều khiển |

Hộ `H01 — Hộ ven suối` có danh sách thành viên, vật phẩm tài nguyên, quyền theo cặp người–vật, lịch lao động và sổ kết quả. Đây là trạng thái canonical được lưu trong save, không phải con số chỉ dựng ở giao diện.

## 2. Kho vật chất

Fixture 30 ngày bắt đầu với:

| Vật | Lượng đầu | Đơn vị | Người có quyền dùng trong lát cắt |
| --- | ---: | --- | --- |
| Lương thực | 50.000 | g | N02 |
| Nước sạch | 200.000 | ml | N01, N02 |
| Củi | 40.000 | g | N02 |
| Dịch dinh dưỡng trẻ | 10.000 | ml | N01 |
| Khăn quấn | 1 vật, tình trạng 1.000 | vật | N01 |

Không có `income` hoặc tiếp tế tự sinh. Lượng còn lại chỉ đổi qua sự kiện tiêu dùng thật. Các mức kho và suất ăn là hệ số fixture để kiểm tra hệ thống, chưa phải cân bằng cuối được người dùng duyệt.

## 3. Bữa ăn nguyên tử

Hộ lên lịch ba bữa lúc 07:00, 12:00 và 18:00 mỗi ngày. Một bữa của fixture cần đồng thời 500 g lương thực, 2.000 ml nước và 300 g củi.

Trước khi đổi trạng thái, sự kiện kiểm tra:

1. người thực hiện có quyền dùng cả ba vật;
2. cả ba vật tồn tại và còn đủ lượng;
3. chỉ khi mọi kiểm tra đạt mới trừ đồng thời cả ba kho.

Nếu thiếu 1 g củi, thức ăn và nước không bị trừ trước. Nếu N03 thử nấu mà chưa được cấp quyền, cả ba kho giữ nguyên và hộ tăng bộ đếm lần bị từ chối. Nhờ vậy quyền vận hành và bảo toàn vật chất đều tạo hậu quả có thể kiểm tra.

## 4. Chăm sóc cạnh tranh với lao động

`CaregiverAgentState` lưu thời điểm N01 thực sự ngắt việc. Khi chuỗi nghe tiếng khóc → di chuyển → thao tác kết thúc hoặc thất bại, mô phỏng tính số giây đã mất và ghi vào H01.

Lúc 22:00, hộ chốt sổ lao động trong ngày:

`công hoàn tất = công dự kiến − thời gian chăm sóc đã ghi trong ngày`

Chuỗi gọi chăm sóc chủ động đầu tiên ghi đúng 65 giây, từ lúc nghe ở giây 1 đến lúc chăm xong ở giây 66. Các lần chăm do sinh lý phát sinh tiếp tục cộng vào cùng sổ; không bị thay bằng câu mô tả chung rằng NPC “bận”.

## 5. Lưu tải và giao diện

Save schema 1 được mở rộng bằng các trường tùy chọn cho household, đơn vị vật phẩm, chủ sở hữu, liên kết hộ của Person và thời điểm gián đoạn. Save V0 không có các trường này nên hash V0 vẫn giữ nguyên.

`QueryPort` chiếu `HouseholdView` chỉ đọc. Giao diện Flutter trên màn hình hẹp và rộng hiển thị thành viên, bốn kho, số bữa, thiếu hụt, từ chối quyền và thời gian N01 bỏ việc chăm trẻ. Lịch sử có nhãn tiếng Việt cho các sự kiện hộ.

## 6. Bằng chứng chạy

Runner `game/tool/verify_v2_household.dart` kiểm tra bữa thành công, từ chối quyền, thiếu nhiên liệu nguyên tử, bảo toàn 30 ngày, lưu/tải ngày 10 và cạnh tranh chăm sóc–lao động.

Kết quả lượt chuẩn:

- 90/90 bữa hoàn tất trong 30 ngày;
- tiêu 45.000 g lương thực, 180.000 ml nước và 27.000 g củi;
- còn 5.000 g lương thực, 20.000 ml nước và 13.000 g củi;
- chạy liền và lưu ngày 10 rồi tải lại có cùng hash `985a29eb4aaa240b`;
- lát cắt có chăm sóc đến 22:00 có hash `a7745f9e47dd8600`;
- V0 tiếp tục giữ hash `5629ba88282991c6`;
- Dart analyze sạch; các runner V0, V1, V1.1, V1.2 và V2.0 đều đạt;
- Flutter analyze sạch và 4/4 widget test đạt.

Catalog `game/artifacts/conditions/v2_household.json` có 14 điều kiện tự động riêng cho V2.0.

## 7. Giới hạn trung thực

V2.0 chưa có nguồn sản xuất hoặc chuyến tiếp tế, nên chỉ chứng minh hộ tiêu tài nguyên hữu hạn đúng quy tắc. N02 và N03 có vai trò nhưng chưa có planner tự chọn việc; bữa ăn hiện là lịch định sẵn. Chưa mô phỏng phòng, bếp, vật chứa, chất lượng món, khẩu phần từng người, bệnh nhẹ hoặc tranh chấp quyền có phản ứng xã hội.

Lát cắt tiếp theo đề xuất là V2.1: bệnh nhẹ có nguyên nhân và diễn tiến, công việc tạo/đưa tài nguyên từ nguồn thật, vị trí theo phòng và quyết định đổi lịch khi người chăm sóc hoặc người nấu bị bệnh.

## 8. Liên kết

- Trước: [[K5_5_V1_2_CO_THE_SINH_LY_SO_SINH]]
- Nền quyền/giao dịch: [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]]
- Nền NPC/hộ: [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]
- Phạm vi vertical slice: [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]
