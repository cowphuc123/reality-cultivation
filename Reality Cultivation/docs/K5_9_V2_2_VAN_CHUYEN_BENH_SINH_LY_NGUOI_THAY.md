---
aliases:
  - V2.2 vận chuyển, bệnh sinh lý và người thay
tags:
  - trien-khai
  - van-chuyen
  - benh-ly
  - npc
---

# K5.9 — V2.2 vận chuyển, bệnh sinh lý và người chăm sóc thay thế

## Kết quả có thể chơi

V2.2 thay lần tiếp tế tức thời bằng một chuyến đi có danh tính, người vận chuyển, hàng mang theo, giờ khởi hành, giờ dự kiến và giờ đến thật. Chuyến đầu rời đi ngày 4 lúc 18:00, dự kiến mất 12 giờ nhưng bị trễ 6 giờ. Kho của hộ không nhận hàng ở giờ dự kiến; chỉ khi N04 tới sân vào ngày 5 lúc 12:00 thì hàng mới được nhập. Chuyến sau chứng minh nhánh đến đúng giờ.

Trong đợt bệnh mẫu, N01 đột ngột không sẵn sàng. Hệ thống tìm người trong cùng hộ có kỹ năng chăm sóc và quyền dùng vật tư; N02 nhận việc, trực tiếp phát hiện bệnh và chăm P00. Lần thay người được lưu trong sổ hộ và hiện trên giao diện.

## Bệnh nối vào cơ thể

Mức bệnh hoạt động đi vào bước sinh lý mỗi giờ của P00: tăng tiêu hao năng lượng, tăng mất nước, tăng áp lực ngủ do gián đoạn và kéo thân nhiệt về mức sốt của episode. Đến ngày 4 trong fixture, bệnh đã gây thêm 84 kJ tiêu hao, 17 ml mất nước và 218 phút gián đoạn ngủ. Đây là hệ số prototype để chứng minh đường nhân quả, chưa phải mô hình y sinh hoặc cân bằng cuối.

## Trạng thái máy mới

- `SupplyJourneyState`: ID chuyến, hộ nhận, người vận chuyển, hàng, chặng, giờ dự kiến/thật, độ trễ và nguyên nhân.
- `CaregiverAgentState.available`, `careSkill`: khả năng nhận việc và ngưỡng kỹ năng.
- `HouseholdState.caregiverSubstitutions`: số lần dùng người thay.
- `IllnessState.physiologyCoupled`: cờ tương thích để save V2.1 giữ đúng hành vi cũ.
- `InfantBodyState`: ba tổng tích lũy cho năng lượng, nước và giấc ngủ bị bệnh tác động.

## Giao diện

Trang Nhân vật hiển thị hậu quả sinh lý tích lũy của bệnh. Trang Hộ hiển thị số lần thay người và hai chuyến gần nhất, gồm người vận chuyển, chặng, trạng thái, giờ đến và độ trễ. Nhật ký có các mốc người chăm sóc vắng mặt, người thay nhận việc, chuyến khởi hành, bị trễ và tới nơi.

## Kiểm chứng đã chạy

- `dart analyze`: sạch.
- Runner V2.2 đạt đến ngày 11; lưu ngày 5 lúc 08:00 khi chuyến đang trễ rồi chạy tiếp cho cùng hash `d0b87de633a4765a`.
- Phương trình kho lương thực, nước và củi cân bằng theo bữa ăn, chăm bệnh, sản xuất và số chuyến đã tới.
- Sáu runner V0–V2.1 đạt với hash cũ không đổi.
- Catalog `game/artifacts/conditions/v2_2_transport_substitution.json` có 22 điều kiện tự động.
- `flutter analyze`: sạch; 6/6 widget test đạt, gồm bố cục điện thoại, máy tính, tác động bệnh và chuyến hàng trễ.
- Web release đã đóng gói lại để `MO_GAME.bat` mở đúng V2.2.

## Giới hạn và bước tiếp theo

Đường đi hiện có hai chặng định trước và sự cố trễ theo fixture; chưa có địa hình, thời tiết, tải trọng, cướp đường hoặc quyết định đổi tuyến. Người thay được chọn theo tính sẵn sàng và kỹ năng, chưa có kế hoạch cá nhân, quan hệ, mệt mỏi hay thương lượng trách nhiệm đầy đủ.

V2.3 nên mở hồ sơ chi tiết từng NPC và vật phẩm từ GUI, đồng thời cho nhịp sống NPC tạo hoạt động và mâu thuẫn lịch có thể quan sát. Sau đó mở rộng vận chuyển thành tuyến thật với vị trí trung gian, tải trọng và sự cố phát sinh từ trạng thái thế giới.

## Liên kết

- Bản trước: [[K5_8_V2_1_BENH_NHE_TIEP_TE_KHONG_GIAN_DOI_LICH]]
- GUI: [[K5_7_GUI_TEXT_GAME_DA_NEN_TANG]]
- Cơ thể sâu: [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
