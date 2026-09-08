---
aliases:
  - V2.1 bệnh nhẹ và đời sống hộ
tags:
  - trien-khai
  - benh-ly
  - ho-gia-dinh
  - khong-gian
---

# K5.8 — V2.1 bệnh nhẹ, tiếp tế, không gian và đổi lịch

## Kết quả có thể chơi

V2.1 nối bốn phần từng còn thiếu thành một chuỗi nhân quả thật. Hộ ven suối có gian ngủ, gian bếp và sân/kho củi. Ngày 3 lúc 09:00, P00 phát một đợt nhiễm đường hô hấp nhẹ với chảy mũi, ho nhẹ, sốt nhẹ, mức bệnh và thân nhiệt riêng.

Bệnh không được biết ngay khi khởi phát. Sau một độ trễ quan sát, N01 phát hiện dấu hiệu, tạm dừng công việc đang làm, di chuyển tới gian ngủ và chăm trẻ trong mười phút. Chăm sóc chỉ thành công khi có 100 ml nước sạch và N01 có quyền dùng đúng vật đó. Nước bị trừ khỏi kho, thời gian gián đoạn đi vào sổ lao động, mức bệnh giảm rồi tiếp tục hồi phục theo bước sáu giờ cho tới khi lui.

## Nguồn vật chất

- N03 hoàn thành một lượt kiếm 1.200 g củi vào 18:00 mỗi ngày từ ngày 1.
- Hộ nhận tiếp tế mỗi năm ngày: 7.500 g lương thực, 30.000 ml nước sạch và 1.500 ml dịch dinh dưỡng.
- Mỗi nguồn sinh vật chất có sự kiện riêng; bữa ăn và chăm sóc vẫn tiêu vật phẩm thật.
- Các con số là fixture kỹ thuật để kiểm chứng dòng vật chất, chưa phải cân bằng cuối.

## Trạng thái máy mới

- `RoomState`: danh tính phòng, tên, hộ sở hữu và tọa độ neo.
- `PersonState.roomId`, `CareItemState.roomId`: vị trí có nghĩa đối với người chơi ngoài tọa độ số.
- `IllnessState`: người bệnh, loại bệnh, thời điểm khởi phát, giai đoạn, mức nặng, thân nhiệt, triệu chứng, phát hiện và số phút chăm sóc.
- `HouseholdState`: tổng chuyến tiếp tế và lượt sản xuất.

Các trường mới chỉ được ghi vào JSON khi thực sự tồn tại. Bản lưu cũ không có phòng hoặc bệnh vẫn nạp được; năm hash kiểm chứng V0–V2.0 không đổi.

## Giao diện

Trang Nhân vật chiếu phòng hiện tại, loại bệnh, giai đoạn, mức bệnh, thân nhiệt, triệu chứng và thời gian chăm sóc. Trang Hiện tại ưu tiên cảnh báo bệnh đang hoạt động. Trang Hộ có số chuyến tiếp tế và lượt sản xuất. Nhật ký diễn đạt các sự kiện bệnh, đổi lịch, di chuyển, chăm sóc, hồi phục, tiếp tế và sản xuất bằng tiếng Việt.

Trang Hồ sơ có thêm **Tạo thế giới mới** với hộp xác nhận. Nút này thay bản lưu cũ bằng thế giới V2.1 ngày 0, cần thiết khi trình duyệt từng tự khôi phục một save từ bản thử trước.

## Kiểm chứng đã chạy

- `dart analyze`: sạch.
- Runner V2.1 đạt toàn chuỗi và lưu/tải giữa lúc bệnh; hash ngày 10: `3d83fc8e0cc7b77f`.
- Năm runner V0, V1 và V2.0 đều đạt với hash cũ không đổi.
- `flutter analyze`: sạch; 5/5 widget test thích nghi đạt, gồm trạng thái bệnh thật ở ngày 4.
- Web release đã đóng gói lại để `MO_GAME.bat` mở đúng V2.1.
- Catalog `game/artifacts/conditions/v2_1_household_health.json` có 18 điều kiện tự động.

## Shared fixture

Nhánh V1 chăm sóc ổn định đã được mô tả bằng artifact máy tại `spikes/shared-spec/fixture/v1_care_chain_01.json`. Hiện nó mang trạng thái sẵn sàng cho bộ chạy khác, chưa tuyên bố parity đa stack vì PWA đối chứng chưa hỗ trợ chuỗi V1.

## Giới hạn

Đây là một bệnh nhẹ xác định trước để kiểm chứng kiến trúc. Chưa có lây truyền, miễn dịch, chẩn đoán sai, thuốc, nhiều bệnh đồng thời, bộ phận cơ thể bị ảnh hưởng, nguồn tiếp tế có người vận chuyển hoặc quyết định sản xuất đầy đủ của NPC. Tham số bệnh, lịch và lượng hàng vẫn là đề xuất triển khai.

## Bước tiếp theo đề xuất

V2.2 nên thêm nguồn tiếp tế có hành trình và nguy cơ trễ, bệnh tác động trực tiếp lên ngủ/ăn/thân nhiệt của `InfantBodyState`, cùng phương án thay người nếu N01 không thể chăm. Sau đó mở rộng GUI để xem hồ sơ từng NPC và từng vật phẩm.

## Liên kết

- GUI: [[K5_7_GUI_TEXT_GAME_DA_NEN_TANG]]
- Hộ V2.0: [[K5_6_V2_0_HO_GIA_DINH_TAI_NGUYEN_QUYEN_LICH]]
- Cơ thể sâu: [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
