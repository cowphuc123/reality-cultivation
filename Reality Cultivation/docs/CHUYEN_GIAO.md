---
aliases:
  - Chuyển giao
  - Bàn giao cho trợ lý khác
  - Phối hợp Codex Claude
tags:
  - huong-dan
  - muc-luc
  - chuyen-giao
---

# Chuyển giao dự án giữa Codex và Claude

Cập nhật: 2026-09-10. Tài liệu này là quy trình chung để Codex và Claude thay phiên làm Reality Cultivation qua GitHub mà không phụ thuộc lịch sử trò chuyện riêng.

## Nguyên tắc

Codex và Claude không chia sẻ trực tiếp bộ nhớ cuộc trò chuyện hoặc suy nghĩ nội bộ. Nguồn sự thật chung là:

1. mã và lịch sử commit trong Git;
2. vault Obsidian `Reality Cultivation/`;
3. [[ACTIVE_WORK]] cho đúng lượt đang làm;
4. kiểm tra tự động và semantic hash cho trạng thái chạy thật.

Không dùng một câu trả lời cũ của trợ lý để ghi đè file hiện tại. Không coi đề xuất của một trợ lý là quyết định của người dùng nếu nó chưa nằm trong bảng U của [[DECISIONS]].

## Thứ tự đọc khi nhận lượt

1. `AGENTS.md` ở gốc dự án.
2. `CLAUDE.md` nếu người nhận là Claude.
3. [[ACTIVE_WORK]] — chủ lượt, nhánh, commit, việc dở và bước tiếp.
4. [[STATE]] — phiên bản thật hiện tại.
5. [[DECISIONS]] — yêu cầu đã xác nhận và đề xuất chưa duyệt.
6. [[MASTER_PLAN]] trước khi thiết kế hoặc thay đổi hệ thống.
7. Tài liệu K5 mới nhất; hiện tại là [[K5_27_V2_20_SINH_HO_VA_QUAN_HE_GIA_DINH]].
8. [[CHANGELOG]] khi cần tra nguyên nhân thay đổi cũ.

Sau đó kiểm tra nhánh, commit và working tree. Nếu thông tin trong `ACTIVE_WORK.md` không khớp Git, dừng sửa mã và xác minh trạng thái thật trước.

## Trạng thái ổn định hiện tại

| Mục | Giá trị |
| --- | --- |
| Phiên bản | V2.20 |
| Commit game | `ae3d740` |
| Nhánh | `master` |
| Runner | 25/25 đạt |
| Widget test | 18/18 đạt |
| Catalog triển khai | 491 điều kiện |
| Hash V2.20 chờ chọn | `4dc1efdae4d7e0b3` |
| Hash V2.19 phải giữ | `491d7f5e50d4d551` |
| Web | https://cowphuc123.github.io/reality-cultivation/ |

Mã chạy được nằm trong `game/` và GUI Flutter trong `client/`. 1.860 điều kiện K0–K4 là thiết kế trên giấy, không được cộng vào 491 điều kiện triển khai.

## Nhận và khóa một lượt làm

Một lát cắt chỉ có một trợ lý làm chính tại một thời điểm.

Khi nhận lượt:

1. đồng bộ nhánh được ghi trong [[ACTIVE_WORK]];
2. bảo đảm không có thay đổi không rõ nguồn;
3. cập nhật `ACTIVE_WORK.md` với chủ lượt, mục tiêu, nhánh và commit bắt đầu;
4. commit cập nhật nhận lượt nếu công việc sẽ kéo dài hoặc chuyển thiết bị;
5. làm đúng lát cắt đã ghi.

Codex và Claude có thể rà soát lẫn nhau trên commit đã hoàn tất, nhưng không đồng thời sửa cùng file/cùng lát cắt. Nếu thật sự cần hai hướng song song, dùng hai nhánh riêng và ghi rõ phạm vi file của từng nhánh.

## Hoàn tất một lát cắt

Mỗi lát cắt triển khai vẫn gồm năm phần:

1. lõi `game/lib/src/`;
2. runner `game/tool/verify_*.dart`;
3. catalog `game/artifacts/conditions/*.json`;
4. GUI và widget test trong `client/`;
5. tài liệu K5 cùng STATE, DECISIONS, CHANGELOG và README liên quan.

Chạy kiểm tra phù hợp trong lúc phát triển. Trước khi kết thúc lát cắt, chạy phân tích tĩnh, toàn bộ runner, toàn bộ widget test và build web nếu client thay đổi. Cập nhật [[ACTIVE_WORK]] về trạng thái sẵn sàng, sau đó commit và push `master`. GitHub Actions tự triển khai web.

## Bàn giao giữa chừng khi sắp hết giới hạn

Không cố hoàn thành vội và không đẩy mã lỗi lên `master`.

1. Dừng ở điểm mã có thể đọc được.
2. Chạy những kiểm tra liên quan có thể chạy; ghi rõ kết quả thật, kể cả lỗi.
3. Cập nhật [[ACTIVE_WORK]] với:
   - mục tiêu lát cắt;
   - việc đã làm;
   - việc chưa làm;
   - file đã sửa;
   - lỗi hoặc giả định đang mở;
   - test đã chạy và kết quả;
   - lệnh/bước tiếp theo chính xác.
4. Tạo hoặc dùng nhánh `handoff/<tên-lát-cắt>`.
5. Commit với tiêu đề `WIP: <mô tả trạng thái thật>` và push nhánh bàn giao.
6. Gửi cho người dùng tên nhánh cùng hash commit.

Trợ lý nhận lượt phải checkout/pull đúng nhánh bàn giao, đọc diff và chạy lại kiểm tra liên quan trước khi sửa tiếp. Khi hoàn tất, cập nhật hồ sơ, đưa thay đổi đã kiểm tra vào `master`, push, rồi xóa trạng thái WIP khỏi [[ACTIVE_WORK]].

## Giữ hash và tương thích cũ

- Tính năng mới ưu tiên trường tùy chọn, cờ bật hoặc đường dữ liệu mới để thế giới cũ giữ hành vi.
- Sau thay đổi lõi, chạy toàn bộ runner và so các hash đã công bố.
- Hash cũ chỉ được đổi khi sửa lỗi thật, mở rộng mô hình có chủ đích hoặc lưu thêm trạng thái cần thiết.
- Khi đổi hash, ghi lý do trong tài liệu K5 liên quan, STATE, DECISIONS, CHANGELOG và catalog.
- Sau mỗi `_replace()` trong lõi, đọc lại dữ liệu từ `_state`; không ghi lại một `PersonState` cũ sau thay đổi xen giữa.

## Prompt chuyển lượt

Có thể gửi nguyên văn cho trợ lý tiếp theo:

> Tiếp tục Reality Cultivation. Đọc AGENTS.md hoặc CLAUDE.md, sau đó đọc Reality Cultivation/docs/ACTIVE_WORK.md, STATE.md và DECISIONS.md. Kiểm tra nhánh, commit và working tree trước khi sửa. Tiếp tục đúng phần đang dở; không thiết kế lại từ đầu và không ghi đè chỉnh sửa hiện tại bằng ký ức cuộc trò chuyện.

Nếu không có việc dở, thêm:

> Nhận lát cắt tiếp theo từ mục “Bước tiếp theo đề xuất” trong STATE.md, cập nhật ACTIVE_WORK.md trước khi sửa mã.

## Giới hạn hiện tại

- GitHub chỉ truyền được file đã commit/push; thay đổi chưa commit trên PC không xuất hiện cho trợ lý ở nơi khác.
- Một kết nối GitHub chỉ đọc không thể tự push; trợ lý cần môi trường có quyền ghi repository để tiếp tục trọn quy trình.
- Không dùng MCP Obsidian bắt buộc: vault là các file Markdown trong Git, cả hai trợ lý chỉ cần đọc/ghi file.
- Không có đồng bộ khóa thời gian thực. `ACTIVE_WORK.md` là khóa phối hợp do hai trợ lý tuân thủ.

## Liên kết

- [[ACTIVE_WORK]]
- [[STATE]]
- [[DECISIONS]]
- [[MASTER_PLAN]]
- [[CHANGELOG]]
- [[HUONG_DAN_LAM_TIEP_TREN_DIEN_THOAI]]
