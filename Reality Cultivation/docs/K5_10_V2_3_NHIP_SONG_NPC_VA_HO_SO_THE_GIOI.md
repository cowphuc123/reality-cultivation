---
aliases:
  - V2.3 nhịp sống NPC và hồ sơ thế giới
tags:
  - trien-khai
  - npc
  - giao-dien
  - lich
---

# K5.10 — V2.3 nhịp sống NPC, xung đột lịch và hồ sơ thế giới

## Kết quả có thể chơi

Mỗi NPC người lớn nay có một chuỗi khối việc trong ngày: giờ bắt đầu, thời lượng, phòng phải có mặt và mức ưu tiên. Khi khối bắt đầu, người đó thật sự di chuyển tới phòng và hoạt động hiện tại đổi theo. Khối lặp lại mỗi ngày cho tới hết tháng đầu.

Vì các cam kết này chiếm giờ thật, chúng va nhau. Trong fixture, N02 vừa là người nấu ăn của hộ vừa phải gánh nước ở suối xa từ 11:30 đến 12:40. Bữa trưa 12:00 không thể diễn ra: hệ thống lùi bữa 30 phút mỗi lần, tối đa ba lần, và bữa được nấu lúc 13:00 với ghi nhận muộn đúng 3.600 giây sau hai lần lùi. Bữa tối vẫn giữ đúng 18:00 vì chuỗi bữa neo theo giờ kế hoạch chứ không theo giờ thực tế bị lùi.

Chiều ngược lại cũng đúng: khi P00 khóc hoặc phát bệnh, người chăm sóc bị cắt ngang giữa khối việc. Số giây rời việc được ghi thành một xung đột có tên việc bị bỏ dở, nguyên nhân chen vào và thời gian mất. Khi N01 nghỉ vì sốt ở ngày 3, khối may vá đang dở của N01 cũng được ghi là mất giờ.

Trang **Hồ sơ** nay mở hồ sơ độc lập cho mọi người và mọi vật đã tồn tại, không chỉ thành viên hộ: N04 là người vận chuyển sống ngoài hộ nhưng vẫn có tuyến đi riêng, và khăn quấn `I-CLOTH-01` nằm ngoài sổ nguồn lực nhưng vẫn có chủ sở hữu cùng danh sách người được phép dùng.

## Trạng thái máy mới

- `RoutineBlock`: id, hoạt động, giờ bắt đầu trong ngày, thời lượng, phòng, ưu tiên và cờ `blocking`.
- `RoutineState`: các khối, khối đang chạy, điều đang cắt ngang, số khối xong, số lần lùi, số khối mất hẳn, tổng giây mất, tổng số xung đột và 24 xung đột gần nhất còn giữ chi tiết.
- `ScheduleConflict`: giờ xảy ra, việc theo kế hoạch, việc chen vào, cách giải quyết (`preempted`, `deferred`, `dropped`) và số giây mất.
- `PersonState.routine`: nhịp sống gắn vào từng người; người không có nhịp sống giữ nguyên hành vi cũ.
- `WorldDirectoryView`, `PersonProfileView`, `ItemProfileView`, `RoutineSummaryView`: cổng truy vấn mở hồ sơ mọi người và mọi vật, kèm cờ trong/ngoài hộ và trong/ngoài sổ kho.

Sự kiện mới: `routine_block_started`, `routine_block_ended`, `routine_block_deferred`, `routine_block_dropped`, `household_meal_deferred`.

## Giao diện

Trang Hồ sơ có hai danh bạ: người và vật. Mỗi thẻ mở ra tuổi, vị trí, việc đang làm, tình trạng chăm sóc, bệnh nếu có, bảng giờ nhịp sống và tóm tắt xung đột lịch gồm lần gần nhất. Trang Hộ thêm ô đo **Xung đột lịch** và hiển thị nhịp sống trong từng thẻ thành viên. Nhật ký có thêm bộ lọc **Nhịp sống** và câu tiếng Việt cho các mốc mới. Bố cục đã kiểm tra ở 390 px không tràn.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.3 đạt tới ngày 4; lưu lúc 12:10 khi bữa trưa đang bị lùi rồi chạy tiếp cho cùng hash. Hash ban đầu là `8df759ae2a42eca0`; từ V2.4 đổi thành `ade0b8a4300276c9` sau khi sửa lỗi nuốt khối, xem [[K5_11_V2_4_NHU_CAU_SINH_VIEC_VA_UU_TIEN]]. Mọi điều kiện V2.3 vẫn đạt.
- Sáu runner V0–V2.2 giữ nguyên hash: `5629ba88282991c6`, `69988c4593598846`, `5d418dc95af7118d`, `985a29eb4aaa240b`, `3d83fc8e0cc7b77f`, `d0b87de633a4765a`.
- Catalog `game/artifacts/conditions/v2_3_routine_directory.json` có 23 điều kiện tự động.
- 8/8 widget test đạt, gồm hai bài mới cho danh bạ ở kích thước điện thoại và cho bữa trưa bị lùi.
- Web release đã đóng gói lại để `MO_GAME.bat` mở đúng V2.3.

## Giới hạn và bước tiếp theo

Nhịp sống hiện là bảng giờ cố định do fixture đặt sẵn, không phải kế hoạch do NPC tự lập từ nhu cầu và mục tiêu. NPC chưa thương lượng ai nhận việc, chưa đổi thứ tự theo ưu tiên, chưa mệt mỏi vì làm bù và chưa nhớ rằng hôm qua mình đã mất giờ. Ưu tiên `priority` đã có trong dữ liệu nhưng chưa được dùng để phân xử; hiện chỉ cờ `blocking` và trạng thái bị cắt ngang quyết định kết quả. Số lần lùi tối đa, bước lùi 30 phút và các giờ trong bảng đều là fixture kỹ thuật, chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho NPC tự sinh khối việc từ nhu cầu của hộ thay vì bảng giờ cứng, dùng `priority` để phân xử khi hai cam kết va nhau, và mở rộng vận chuyển thành tuyến thật có vị trí trung gian.

## Liên kết

- Bản trước: [[K5_9_V2_2_VAN_CHUYEN_BENH_SINH_LY_NGUOI_THAY]]
- GUI: [[K5_7_GUI_TEXT_GAME_DA_NEN_TANG]]
- NPC tự trị: [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]
- Nguồn quyết định: [[NGUON_QUYET_DINH_K1]]
- Kế hoạch tổng: [[MASTER_PLAN]]
