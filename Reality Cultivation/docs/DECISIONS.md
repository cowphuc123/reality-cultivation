# Yêu cầu, đề xuất và câu hỏi mở

Cập nhật: 2026-09-08.

## Yêu cầu do người dùng nêu

| ID | Nội dung | Nguồn |
| --- | --- | --- |
| U001 | Game tu tiên chân thật, cực kỳ chi tiết; dùng text, không cần đồ họa | Yêu cầu đầu tiên |
| U002 | Mô phỏng liên tục, 5 giây ngoài đời = 1 ngày trong game | Yêu cầu đầu tiên |
| U003 | Người chơi giao công việc và mục tiêu cho nhân vật | Yêu cầu đầu tiên |
| U004 | NPC tồn tại như người thật và có câu chuyện riêng | Yêu cầu đầu tiên |
| U005 | Cơ thể có các bộ phận và thương tích chi tiết | Yêu cầu đầu tiên |
| U006 | Rất nhiều vật phẩm, công dụng và chất lượng khác nhau; rất nhiều công pháp khác biệt | Yêu cầu đầu tiên |
| U007 | Tham vọng chiều sâu vượt Dwarf Fortress và CDDA | Yêu cầu đầu tiên; đây là mục tiêu, chưa phải kết quả được chứng minh |
| U008 | Viết kế hoạch chi tiết trước | Yêu cầu đầu tiên |
| U009 | Lưu tài liệu trong thư mục để có thể tiếp tục về sau, tương tự cách dùng Obsidian | Yêu cầu lưu hồ sơ |
| U010 | Dùng Obsidian và kiểm tra, tổ chức thư mục theo cách đó | Người dùng xác nhận dùng Obsidian, 2026-09-05 |
| U011 | Game phải chơi được trên cả điện thoại và máy tính | Người dùng bổ sung, 2026-09-05 |
| U012 | Game không có cốt truyện chính cố định; diễn biến sinh từ mô phỏng như Dwarf Fortress | Người dùng xác nhận, 2026-09-06 |
| U013 | Khi tạo bản lưu, game sinh thế giới rồi mô phỏng hàng trăm, hàng nghìn hoặc hàng vạn năm không có nhân vật chính; sau đó người chơi chọn vị trí trên bản đồ và nhân vật mới sinh/nhập thế | Người dùng xác nhận, 2026-09-06 |
| U014 | Người chơi điều khiển nhân vật ngay từ lúc sơ sinh; không tóm lược hoặc bỏ qua tuổi thơ | Người dùng xác nhận, 2026-09-06 |
| U015 | Ưu tiên làm GUI đẹp và đầy đủ trước khi tiếp tục mở rộng mô phỏng | Người dùng yêu cầu, 2026-09-07; tiếp tục 2026-09-08 |

## Đề xuất của trợ lý — chưa được người dùng chốt

- Chơi đơn, chạy cục bộ; giao diện trình duyệt bằng chữ, bảng và nút.
- Cho phép tạm dừng và tự dừng khi gặp nguy hiểm hoặc cần quyết định.
- Chưa mô phỏng lúc đóng game trong bản đầu.
- Nhân vật khởi đầu là người thường; thông tin hiển thị theo kiến thức của nhân vật.
- Dùng mô phỏng theo sự kiện và nhiều mức chi tiết cho vùng xa.
- NPC và người chơi dùng chung các hệ thống nền.
- Bản đầu: một làng, vùng hoang dã, cơ sở tu luyện, 20–30 NPC, 30–50 loại vật phẩm, ba công pháp và một lần đột phá.
- Cơ chế kế thừa sau khi chết thiết kế sau.
- AI ngôn ngữ là tùy chọn cho diễn đạt, không bắt buộc để vận hành thế giới.

Các nguyên tắc và giải pháp khác trong MASTER_PLAN.md cũng là thiết kế đề xuất nếu chưa có mục xác nhận ở trên.

## Quy tắc chung cho mọi con số kỹ thuật

Trừ những gì ghi trong bảng U ở trên, **mọi tên, con số, ngưỡng, công thức** xuất hiện trong các đặc tả K0–K5 (tuổi trưởng thành, hệ số nhu cầu, giờ giấc nhịp sống, ngưỡng bệnh, tốc độ, v.v.) là **fixture kỹ thuật do trợ lý đặt để kiểm chứng chuỗi nhân quả hoặc xung đột lịch — chưa được người dùng duyệt làm cân bằng, mô hình y khoa, hay luật chung của thế giới.**

Lịch sử đầy đủ từng lượt việc — tài liệu nào thêm gì, số điều kiện tăng ra sao — nằm trong [[CHANGELOG]] và trong phần mở đầu của mỗi tài liệu K tương ứng. Không cần chép lại ở đây.

## Diễn biến gần nhất

Ngày 2026-09-08: hoàn thành V2.3 tại [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]]. Nhịp sống hiện là bảng giờ cố định, **không phải** kế hoạch NPC tự lập — không giảm tham vọng NPC tự trị của U004/K4.6. Trường `priority` có trong dữ liệu nhưng chưa dùng để phân xử. Việc mở hồ sơ toàn thế giới đáp ứng U015 ở phạm vi dữ liệu đã mô phỏng, không tạo số liệu cho hệ chưa có.

Ngày 2026-09-08: đăng kho công khai `github.com/cowphuc123/reality-cultivation` và bản web tự động tại `cowphuc123.github.io/reality-cultivation` qua GitHub Actions. Đây là hạ tầng lưu trữ/phân phối, không phải quyết định thiết kế.

TN01–TN08 ([[LUA_CHON_TRAI_NGHIEM]]) và ADR công nghệ (S2 Dart/Flutter đang PROPOSED) vẫn mở.

## Câu hỏi mở

1. Tốc độ 5 giây/ngày có được thay đổi, tạm dừng và tự dừng không?
2. Thế giới có tiến triển lúc đóng game không; nếu có, xử lý rủi ro thế nào?
3. Giới hạn điều khiển trực tiếp so với giao mục tiêu?
4. Hệ cảnh giới, bản chất linh khí, kinh mạch và quy luật đột phá?
5. Mức giải phẫu và độ chi tiết sinh lý cần có ở từng chặng?
6. Quy mô NPC và thế giới mục tiêu, cấu hình máy dùng để kiểm chứng hiệu năng?
7. Cái chết, tải lại, kế thừa và mức độ khắc nghiệt?
8. Chốt công nghệ sau khi đặc tả nền đủ rõ.

Tám lựa chọn trải nghiệm TN01–TN08 (dừng, mô phỏng khi đóng, quyền tự chủ nhân vật, v.v.) nằm tại [[LUA_CHON_TRAI_NGHIEM]], vẫn chưa có phản hồi xác nhận.

## Cách cập nhật

Khi người dùng xác nhận hoặc thay đổi một lựa chọn: ghi ngày, nội dung và lý do nếu có vào mục "Diễn biến gần nhất" ở trên; cập nhật bảng U nếu là yêu cầu mới; cập nhật MASTER_PLAN.md tương ứng. Không xóa dấu vết quyết định cũ quan trọng — đánh dấu được thay thế và liên kết quyết định mới. Chi tiết kỹ thuật của từng lượt việc ghi vào CHANGELOG.md, không lặp lại ở đây.
