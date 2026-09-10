# Chỉ dẫn cho Claude — Reality Cultivation

Claude và Codex dùng cùng kho Git và vault Obsidian làm nguồn sự thật chung.

1. Đọc `AGENTS.md` ở gốc và tuân theo toàn bộ quy tắc dự án.
2. Đọc `Reality Cultivation/docs/ACTIVE_WORK.md` để biết nhánh, commit và chủ lượt hiện tại.
3. Đọc `Reality Cultivation/docs/STATE.md`, `DECISIONS.md`, `MASTER_PLAN.md` và tài liệu K5 mới nhất trước khi sửa hệ thống.
4. Không dựa vào lịch sử chat của riêng Claude để ghi đè tài liệu hoặc mã hiện tại.
5. Trước khi làm, chạy `git status`, kiểm tra nhánh và lấy thay đổi mới nhất từ GitHub.
6. Không làm đồng thời cùng lát cắt với trợ lý khác. Chỉ tiếp tục khi `ACTIVE_WORK.md` giao lượt cho Claude hoặc người dùng yêu cầu rõ.
7. Khi lát cắt hoàn chỉnh và kiểm tra đạt, cập nhật hồ sơ, commit và push theo `AGENTS.md`.
8. Nếu sắp hết giới hạn khi việc còn dở, làm theo mục “Bàn giao giữa chừng” trong `CHUYEN_GIAO.md`: ghi trạng thái thật, commit WIP lên nhánh `handoff/...`, push nhánh đó; không đưa WIP vào `master`.

Tra cứu đầy đủ tại `Reality Cultivation/docs/CHUYEN_GIAO.md`.
