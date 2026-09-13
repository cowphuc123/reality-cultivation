# Chỉ dẫn làm việc — Reality Cultivation

## Đọc bối cảnh trước khi làm việc

Hồ sơ chính nằm trong vault Obsidian `Reality Cultivation/`, không phải thư mục `docs/` ở gốc dự án.

1. Đọc `Reality Cultivation/docs/ACTIVE_WORK.md` để biết chủ lượt, nhánh và việc đang dở.
2. Đọc `Reality Cultivation/docs/STATE.md` để biết giai đoạn hiện tại và việc tiếp theo.
3. Đọc `Reality Cultivation/docs/DECISIONS.md` để phân biệt yêu cầu đã xác nhận với đề xuất.
4. Đọc `Reality Cultivation/docs/MASTER_PLAN.md` trước khi thiết kế hoặc thay đổi hệ thống game.
5. Đọc `Reality Cultivation/docs/LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC.md` trước khi đặt số phiên bản hoặc chọn lát cắt mới.
6. Đọc `Reality Cultivation/docs/CHANGELOG.md` khi cần lịch sử thay đổi.

## Quy tắc dự án

- Trao đổi và viết tài liệu bằng tiếng Việt, diễn đạt dễ hiểu.
- Đây là game text mô phỏng tu tiên sâu: 5 giây ngoài đời bằng 1 ngày game; người chơi giao việc và mục tiêu; NPC có đời sống riêng; cơ thể, thương tích, vật phẩm và công pháp có chiều sâu.
- Kế hoạch chi tiết đã hoàn thành và dự án đang triển khai bằng các vertical slice chạy được. Đọc `STATE.md` để biết phiên bản hiện tại trước khi sửa mã.
- Không tự coi đề xuất của trợ lý là quyết định đã được người dùng duyệt.
- Giữ tham vọng dài hạn; phạm vi nhỏ ban đầu là đề xuất triển khai theo chặng, không phải tự ý cắt mục tiêu.
- Tôn trọng chỉnh sửa trực tiếp của người dùng trong tài liệu. Đọc bản hiện tại trước khi sửa; không ghi đè bằng bản nhớ từ hội thoại.
- Sau mỗi phiên có thay đổi đáng kể, cập nhật trạng thái, quyết định và nhật ký tương ứng. Ghi rõ đã làm, chưa làm, vấn đề mở và bước tiếp theo.
- Không ghi nhận việc chưa thực hiện là đã hoàn thành. Khi có mã nguồn, xác minh trạng thái thực tế trước khi dựa vào ghi chú cũ.
- Giữ file này ngắn; đặt thiết kế chi tiết trong `Reality Cultivation/docs/`. Chỉ tách thêm tài liệu hệ thống khi thực sự cần.
- Dùng vault Obsidian hiện có làm nguồn tài liệu duy nhất; không duy trì bản sao hồ sơ ở gốc dự án. Giữ nguyên cấu hình `.obsidian` và ghi chú riêng của người dùng. Dùng liên kết nội bộ và metadata đơn giản để hỗ trợ tra cứu.
- Chỉ dẫn mới của người dùng có ưu tiên hơn những giả định cũ trong hồ sơ.
- Mỗi phiên bản lớn có mục đích và cổng kết thúc trong `LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC.md`. Không kéo dài một phiên bản sang hệ thuộc chặng khác bằng cách tự tăng số phụ.
- Trước mỗi lát cắt mới, phải chỉ ra nó đóng cổng chưa đạt nào. Nếu phần chức năng của các cổng đã có, chuyển sang dựng bằng chứng và sửa lỗi; không tự thêm chiều sâu. Ý tưởng không bắt buộc đưa vào backlog, không được dùng làm lý do trì hoãn đóng phiên bản.
- Chỉ chạy kiểm chứng phát hành, hoàn thiện catalog/hồ sơ phát hành, commit/push `master` và triển khai web khi người dùng yêu cầu. Có thể kiểm tra cú pháp hoặc kiểm tra hẹp để tiếp tục viết mã, nhưng không được gọi đó là kiểm chứng phiên bản.
- Ngoại lệ chuyển trợ lý: nếu Codex hoặc Claude sắp hết giới hạn khi lát cắt còn dở, cập nhật `Reality Cultivation/docs/ACTIVE_WORK.md`, commit với tiền tố `WIP:` lên nhánh `handoff/<tên-lát-cắt>` và push nhánh đó. Trợ lý tiếp theo phải tiếp tục đúng nhánh; chỉ hợp nhất vào `master` sau khi hoàn tất và kiểm tra đạt.
