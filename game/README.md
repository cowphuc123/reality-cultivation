# Reality Cultivation — lõi mô phỏng đến V2.17

Lõi mô phỏng xác định dùng chung cho giao diện điện thoại và máy tính.

Đã có:

- đồng hồ nguyên với quy ước 5 giây thật bằng 1 ngày game;
- hàng đợi sự kiện có thứ tự ổn định;
- lệnh giao mục tiêu có mã chống thực thi lặp;
- sự kiện sinh nhân vật ở thời điểm sơ sinh;
- lưu/tải JSON có phiên bản;
- dấu vân tay trạng thái để kiểm tra tái lập.
- clock runner quy đổi đúng 5 giây thật thành 1 ngày game, có pause và backlog;
- cổng lệnh/truy vấn chung để giao diện điện thoại và máy tính không sửa trực tiếp trạng thái;
- schema save và catalog tám điều kiện V0 máy đọc được.
- tháng đầu sơ sinh với nhu cầu, giác quan, cơ thể và chăm sóc có chuỗi nhân quả;
- hộ gia đình có kho hữu hạn, quyền sử dụng, bữa ăn và sổ lao động;
- không gian theo phòng, bệnh nhẹ có diễn tiến, sản xuất và tiếp tế vật chất.
- nhịp sống NPC, nhu cầu sinh việc, kỹ năng, quyền từ chối và xung đột lịch;
- cơ thể người lớn, đói, khát, bệnh và nghỉ bệnh có hậu quả vật chất;
- tuyến vận tải hai chiều có ngã rẽ và lựa chọn theo sức lực;
- chuyển ca cố định của người nghỉ bệnh cho thành viên đủ điều kiện.
- vùng, địa điểm và phép quy người/phòng/vật theo tọa độ hai chiều.
- sinh hình học vùng và địa điểm xác định từ seed, có fingerprint và provenance.
- thế giới và NPC tồn tại trước P00; nơi sinh được kiểm tra từ hộ, phòng, người chăm, sữa và quyền dùng thật.
- tiền sử 300–30.000 năm theo seed chạy bằng epoch/cohort, lưu biến cố neo và hoàn tất trước nhập thế.

Chạy bằng Dart SDK:

```powershell
dart pub get --offline
dart analyze
dart run tool/verify_v0.dart
dart run tool/verify_v1_infancy.dart
dart run tool/verify_v1_care_chain.dart
dart run tool/verify_v1_body.dart
dart run tool/verify_v2_household.dart
dart run tool/verify_v2_1_household_health.dart
dart run tool/verify_v2_13_work_substitution.dart
dart run tool/verify_v2_14_region_map.dart
dart run tool/verify_v2_15_seeded_world_generation.dart
dart run tool/verify_v2_16_world_entry.dart
dart run tool/verify_v2_17_world_history.dart
```

Giao diện Flutter nằm trong `../client`; bản chơi thử mở bằng `../MO_GAME.bat`.
