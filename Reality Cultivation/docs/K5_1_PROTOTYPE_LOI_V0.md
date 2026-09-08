---
aliases:
  - K5.1 — Prototype lõi V0
  - Prototype V0
status: v0-chuc-nang-hoan-tat
updated: 2026-09-07
---

# K5.1 — Prototype lõi mô phỏng V0

## 1. Mục đích

K5.1 bắt đầu biến các hợp đồng thiết kế thành bằng chứng chạy được. Prototype này kiểm tra phần lõi dùng chung cho điện thoại và máy tính trước khi đầu tư vào giao diện hoặc nội dung lớn.

Đây chưa phải quyết định chọn stack cuối cùng và chưa phải bản game chơi hoàn chỉnh.

## 2. Môi trường thực tế

- Dart SDK 3.10.7 chạy được trực tiếp.
- Flutter 3.38.7 chạy được khi đặt `FLUTTER_ALREADY_LOCKED=true` để bỏ qua khóa công cụ cũ; đã dựng shell Flutter.
- Rust/Cargo không có trong môi trường.
- Node.js/npm, Java và .NET SDK 6 có mặt, nhưng chưa chạy cùng bộ scenario để so sánh.
- Máy chưa có Android SDK và Visual Studio với workload C++, nên chưa thể đóng gói APK hoặc `.exe`.
- Flutter Web và Chrome sẵn sàng; bản web release đã biên dịch thành công.
- Kho Git cục bộ đã được khởi tạo tại gốc dự án; chưa tạo commit đầu tiên.

Vì chưa có phép so sánh công bằng giữa các ứng viên K3.2, Dart/Flutter chỉ là ứng viên đang được thử, chưa được ghi thành quyết định công nghệ.

## 3. Artifact đã tạo

Mã nằm tại thư mục `game/` ở gốc dự án:

- `lib/src/simulation.dart`: trạng thái thế giới, thời gian, hàng đợi sự kiện, lệnh, lưu/tải và dấu vân tay.
- `lib/src/clock.dart`: quy đổi thời gian thật, pause/resume, backlog và adapter timer thật.
- `lib/src/ports.dart`: `CommandPort`, `QueryPort` cùng các view chỉ đọc cho giao diện.
- `lib/reality_cultivation.dart`: cổng xuất API lõi.
- `bin/reality_cultivation.dart`: luồng text nhỏ sinh P00, giao mục tiêu phù hợp sơ sinh và chạy đến ngày 1.
- `tool/verify_v0.dart`: bộ kiểm chứng độc lập, không cần gói ngoài.
- `pubspec.yaml`, `analysis_options.yaml`: cấu hình Dart tối thiểu và kiểm tra kiểu nghiêm ngặt.
- `artifacts/schemas/` và `artifacts/conditions/v0.json`: bootstrap schema cùng catalog 14 điều kiện V0.
- `../client/`: shell Flutter có đích Android, Windows và Web; cùng mã UI thích nghi cho màn hình hẹp/rộng.

## 4. Hợp đồng V0 đã hiện thực

### 4.1. Thời gian

- Thời gian canonical là số giây game nguyên.
- Một ngày game bằng 86.400 giây game.
- Hằng số nhịp giao diện là 5.000 ms thật cho một ngày game.
- `advanceTo` không cho đồng hồ đi lùi.

`SimulationClock` đã nối phép quy đổi vào lõi; `RealTimeSimulationRunner` đo thời gian thật theo nhịp ngắn. Pause không tiêu thụ thời gian ngoài đời. Nếu thiết bị bận, backlog được giữ và xử lý giới hạn theo từng pump để tránh khóa giao diện. Shell Flutter dùng runner này và tự tạm dừng khi ứng dụng rời foreground.

### 4.2. Cổng giao diện và shell thích nghi

- `CommandPort` trả trạng thái accepted/duplicate/rejected thay vì để UI sửa state.
- `QueryPort` trả `WorldView`, `PersonView` và lịch sử fact chỉ đọc.
- Màn hình dưới 720 px dùng một cột cuộn; màn hình rộng dùng hai vùng.
- Cả hai bố cục có trạng thái ngày/tuổi/mục tiêu, lệnh giao mục tiêu, pause/resume và lịch sử.
- Web manifest cho phép chạy kiểu ứng dụng độc lập với orientation linh hoạt.

### 4.3. Thứ tự sự kiện

Sự kiện được xếp theo ba khóa ổn định:

1. thời điểm đến hạn;
2. thứ tự pha;
3. số thứ tự chèn.

Các pha V0 dùng mã thứ tự 20/30/50/60/70/80 cho ý định, di chuyển, chuyển giao, hoàn tất, quan sát và ghi sổ. Bộ kiểm chứng đã xác nhận chuyển giao pha 50 xảy ra trước quan sát pha 70 ở cùng giây.

### 4.4. Lệnh và mục tiêu

- `SetGoalCommand` thay mục tiêu hoạt động của một `PersonState` đã tồn tại.
- Mỗi lệnh có ID; ID đã nhận sẽ không được thực thi lần hai.
- Việc giao mục tiêu sinh một `WorldFact` có thời điểm và chủ thể.

V0 chưa có planner NPC, kiểm tra khả năng theo tuổi hoặc chuyển ý định thành chuỗi hành động. Mục tiêu trong bản minh họa chỉ là “Quan sát giọng nói của người chăm sóc”.

### 4.5. Sơ sinh

Sự kiện `birth` tạo P00 tại thời điểm 0. Sau khi sinh, người chơi có thể giao mục tiêu ngay. Điều này tạo đường triển khai tối thiểu cho U014 nhưng chưa mô phỏng cơ thể, giác quan, người chăm sóc hoặc tháng đầu đời.

### 4.6. Lưu, tải và tái lập

- Save là JSON có `schema_version: 1`.
- Save giữ seed, thời gian, revision, người, hàng đợi sự kiện, fact và ID lệnh đã nhận.
- Dấu vân tay semantic dùng JSON canonical cùng FNV-1a 64 bit để so trạng thái.
- Lưu ở giữa lịch, tải lại rồi chạy tiếp một ngày cho cùng dấu vân tay với lượt không tải.
- Cùng seed và cùng chuỗi lệnh cho cùng dấu vân tay.

FNV-1a hiện là checksum tái lập nhỏ, chưa phải hàm chống giả mạo hoặc thiết kế save dài hạn.

### 4.7. Persistence và lifecycle của shell

- Giao diện có nút lưu và tải bản gần nhất; cả hai dùng nguyên JSON save schema 1 của lõi.
- Adapter production dùng `shared_preferences` 2.5.5 và lưu dưới key có phiên bản `reality_cultivation.save.v1`.
- Khi ứng dụng chuyển sang inactive/paused/hidden/detached, runner dừng trước rồi snapshot được ghi bất đồng bộ.
- Khi mở ứng dụng, save hợp lệ được tải trước khi runner bắt đầu.
- Nếu không có save hoặc save hỏng, phiên mới vẫn còn và UI báo nguyên nhân; không áp dụng trạng thái dở dang.
- Test dùng `MemorySaveRepository`, không giả vờ rằng plugin native đã được kiểm chứng trên thiết bị thật.

Đây là persistence phù hợp cho save V0 rất nhỏ. Thế giới lớn phải chuyển sang thiết kế phân vùng/checkpoint/journal của K2.5 và K3.5.

## 5. Bằng chứng chạy ngày 2026-09-06

| Kiểm tra | Kết quả |
| --- | --- |
| `dart analyze` | Không có lỗi |
| Sinh P00 tại giây 0 | Đạt |
| Chống lệnh trùng ID | Đạt |
| Thứ tự pha cùng thời điểm | Đạt |
| JSON save có phiên bản | Đạt |
| Lưu/tải rồi chạy tiếp | Đạt |
| Replay cùng seed và lệnh | Đạt |
| Dấu vân tay lượt kiểm chứng | `5629ba88282991c6` |
| Luồng text đến ngày 1 | Chạy được; hash `75b67e4d35e43973` |
| Clock 5.000 ms/ngày, pause và backlog | Đạt |
| Command/Query port | Đạt |
| Catalog/schema máy đọc được | 14 điều kiện; validator đạt |
| Flutter analyze | Không có lỗi |
| UI điện thoại 390×844 | Đạt; giao được mục tiêu |
| UI máy tính 1280×800 | Đạt; cùng thao tác thiết yếu |
| Flutter Web release | Đạt; tạo `client/build/web` |
| Lưu A, đổi sang B, tải lại A | Đạt qua UI test |
| Pause lifecycle, mở phiên mới, tự khôi phục | Đạt qua repository test |
| Adapter `shared_preferences` trong web release | Biên dịch đạt |
| Android APK | Chưa chạy; thiếu Android SDK |
| Windows executable | Chưa chạy; thiếu Visual Studio C++ |

Các kết quả trên chỉ bao phủ điều kiện riêng của prototype V0. Chúng không biến 1.860 điều kiện thiết kế cũ thành đã chạy.

## 6. Trạng thái cổng K4I

- K4I07 có bootstrap schema và catalog 14 điều kiện máy đọc được: **đạt trong phạm vi V0**, registry toàn dự án chưa hoàn thành.
- K4I08 chưa đạt vì chưa chọn stack bằng ADR sau phép so sánh chung.
- K4I09 có V0 chạy được cho time/event/command/query/save, persistence UI và shell Flutter responsive: **đạt trong phạm vi web prototype**; lifecycle trên thiết bị thật và gói native chưa được kiểm chứng.
- K4I10–K4I16 chưa đạt.

## 7. Giới hạn phải giữ rõ

- Đã có shell text Flutter cho màn hình điện thoại/máy tính và bản web release; chưa có gói Android/Windows native trên máy hiện tại.
- Autosave/restore đã được kiểm thử bằng repository trong bộ nhớ và adapter web đã biên dịch; chưa chạy crash recovery hoặc lifecycle trên thiết bị thật.
- Chưa có world generator và mô phỏng tiền sử.
- Chưa có cơ thể, nhu cầu, người chăm sóc, NPC tự trị, vật phẩm, kinh tế, tu luyện hoặc chiến đấu chạy được.
- Chưa đo hiệu năng và chưa chứng minh chạy hàng trăm hay hàng vạn năm.
- Chưa chọn stack chính thức.

## 8. Bước tiếp theo

1. Chạy ít nhất một spike đối chứng hoặc ghi rõ vì sao không khả thi, rồi lập ADR công nghệ bằng evidence.
2. Nếu tiếp tục Flutter, cài toolchain Android/Windows ở giai đoạn đóng gói native; bản web dùng để kiểm chứng sớm.
3. Bắt đầu V1: tháng đầu sơ sinh, giác quan–nhu cầu–người chăm sóc và ý định theo năng lực phát triển.
4. Trước khi save lớn, thay key-value prototype bằng storage phân vùng/checkpoint theo K2.5/K3.5.

## 9. Liên kết

- [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]
- [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]
- [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]
- [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- [[STATE]]
