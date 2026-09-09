---
aliases:
  - Làm tiếp dự án trên điện thoại
tags:
  - quy-trinh
  - github
  - dien-thoai
---

# Làm tiếp dự án trên điện thoại rồi quay lại PC

## Cách nên dùng: Remote vào chính PC

Trong ChatGPT trên PC, mở **Settings → Connections → Control this PC** và ghép điện thoại bằng mã QR. Trên điện thoại mở **Remote**, chọn đúng máy và tiếp tục đúng task Reality Cultivation.

Cách này dùng trực tiếp thư mục `D:\Reality Cultivation`, repository, vault Obsidian, công cụ và quyền đang có trên PC. Máy PC phải mở ứng dụng ChatGPT, còn thức, có mạng và đăng nhập cùng tài khoản/workspace.

Khi vào từ điện thoại, có thể nhắn:

> Tiếp tục dự án Reality Cultivation trong task hiện tại. Đọc AGENTS.md và Reality Cultivation/docs/STATE.md trước, hoàn tất lát cắt đang dở, chạy kiểm thử, cập nhật hồ sơ Obsidian, rồi commit và push khi toàn bộ kiểm tra đạt. Không đẩy trạng thái đang dở hoặc đang lỗi.

## Nếu tạo một task riêng chỉ dựa vào GitHub

GitHub chỉ chứa những gì đã commit và push. File đang sửa dở, commit chỉ có trên PC, thiết lập cục bộ và trạng thái hội thoại sẽ không tự xuất hiện trong task mới.

Trước khi đổi máy:

1. Hoàn tất một lát cắt hoặc ghi rõ trạng thái dở trong `STATE.md`/`CHUYEN_GIAO.md`.
2. Chạy toàn bộ kiểm thử cần thiết.
3. Commit và push lên một nhánh rõ ràng sau khi lát cắt hoàn tất và kiểm tra đạt.
4. Ghi tên nhánh và commit mới nhất.

Trong task mới trên điện thoại:

1. Chọn đúng repository `cowphuc123/reality-cultivation` và đúng nhánh.
2. Yêu cầu đọc `AGENTS.md`, `Reality Cultivation/docs/STATE.md`, `DECISIONS.md`, `MASTER_PLAN.md` và tài liệu K5 mới nhất.
3. Chỉ bắt đầu sửa sau khi xác nhận commit đầu nhánh đúng với mốc đã ghi.
4. Làm trên một nhánh riêng; chạy kiểm thử; commit và push.

Khi quay lại PC:

1. Bảo đảm cây làm việc PC sạch hoặc đã cất phần sửa dở.
2. Kéo nhánh từ GitHub về, xem thay đổi và kết quả kiểm thử.
3. Gộp nhánh sau khi kiểm tra; không để hai thiết bị cùng sửa một nhánh chưa đồng bộ.

Chỉ kết nối ứng dụng GitHub với ChatGPT chưa đủ để bảo đảm ghi mã lên repository. Task đó còn phải có môi trường viết mã và quyền tạo commit/push hoặc pull request.

## Nguồn chính thức

Tài liệu OpenAI về Remote: https://learn.chatgpt.com/docs/remote-connections
