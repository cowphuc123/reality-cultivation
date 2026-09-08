---
aliases: [Lựa chọn trải nghiệm cần chốt]
tags: [thiet-ke, quyet-dinh]
status: cho-phan-hoi
updated: 2026-09-05
---

# Lựa chọn trải nghiệm cần chốt — 0.1

Liên quan: [[DECISIONS]] · [[BAN_CHOI_THU]] · [[GIAO_DIEN]] · [[DU_LIEU_KHOI_DAU]].

> Bản này gom lựa chọn để người dùng phản hồi. Chưa có lựa chọn mới nào được xác nhận. Đồng ý một cấu hình không đồng nghĩa đã yêu cầu lập trình hoặc duyệt mọi công thức trong các đặc tả.

## 1. Những điều đã rõ

Game text tu tiên, ưu tiên chiều sâu; 5 giây ngoài đời bằng 1 ngày game; người chơi giao việc/mục tiêu; NPC có đời sống riêng; cơ thể, vật phẩm và công pháp chi tiết. Lập kế hoạch trước và lưu hồ sơ trong vault Obsidian.

Những điểm này không cần hỏi lại. Mục tiêu dài hạn vẫn giữ nguyên; phạm vi thử dưới đây chỉ là bước kiểm chứng.

## 2. Cấu hình trải nghiệm mình đề xuất

| Mã | Lựa chọn đề xuất | Ý nghĩa và đánh đổi |
| --- | --- | --- |
| TN01 | Cho tạm dừng; tự dừng khi sửa mục tiêu hoặc nhận biết nguy cấp | Có thời gian đọc/quyết định ở tốc độ rất nhanh; nhịp thế giới có thể bị ngắt |
| TN02 | Đóng game thì thế giới dừng trong bản đầu | Không cần xử lý nhiều năm hậu quả khi vắng mặt; chưa có trải nghiệm thế giới chạy lúc đóng |
| TN03 | Nhân vật người chơi theo mục tiêu trong khả năng và hiểu biết | Có thể mắc sai lầm vì thiếu thông tin; tính cách chưa tự phủ quyết lệnh. NPC độc lập vẫn tự quyết |
| TN04 | Chỉ thấy thông tin nhân vật biết | Khám phá/giám định có giá trị; không xem bảng toàn tri để tối ưu |
| TN05 | Hậu quả thương tích và chết giữ thật; bản thử cho lưu/tải thủ công | Có thể học từ thất bại; chế độ một đời hoặc kế thừa chưa làm ở bản đầu |
| TN06 | Tự lo sinh hoạt trong ngân sách; hợp đồng chỉ tự nhận khi có quy tắc giới hạn rõ; đột phá mặc định cần lệnh riêng | Giảm bấm việc lặp nhưng giữ quyền kiểm soát cam kết lớn |
| TN07 | Bản thử ở An Khê: 20 NPC, 11 địa điểm, 36 loại vật; ba công pháp mẫu và một chuyển mốc | Kiểm chứng chuỗi sâu trước; chưa có đại thế giới, nhiều thế hệ hoặc hàng nghìn loại ngay |
| TN08 | Bắt đầu là người thường; hệ cảnh giới chính thức thiết kế riêng trước nội dung tu luyện dài hạn | Có trải nghiệm đi từ sinh kế tới nhập môn; chưa coi các mốc kỹ thuật thử là toàn bộ vũ trụ tu tiên |

Tên An Khê và các tên mẫu có thể đổi mà không ảnh hưởng cơ chế. TN05 là đề xuất mới cụ thể hóa mục chết/lưu còn mở, chưa được ghi là đã chốt.

## 3. Các phương án khác có thể chọn

**Thời gian chạy ngay cả khi đóng:** cần quy tắc mô phỏng vắng mặt, tự động hóa đủ mạnh, giới hạn thời gian bù và cách đối mặt cái chết khi người chơi không hiện diện. Không thể chỉ cộng số ngày rồi bỏ qua tương tác.

**Nhân vật người chơi có ý chí chống lệnh:** cần xác định phạm vi từ chối, báo hiệu và cách người chơi tác động lâu dài. Khác với bất lực vì cơ thể hoặc không biết làm; không nên đưa vào âm thầm.

**Một đời không tải lại:** làm sai lầm nặng hơn; cần chính sách sao lưu kỹ thuật để lỗi phần mềm không bị coi là hậu quả gameplay. Cơ chế kế thừa/dòng họ là lựa chọn riêng, không tự có cùng chế độ này.

**Xem toàn tri:** thuận tiện quan sát mô phỏng nhưng giảm giá trị thông tin, bí mật và lời đồn. Công cụ phát triển toàn tri vẫn có thể tồn tại độc lập với lựa chọn chơi.

Người dùng có thể chọn khác ở từng mã, không cần chọn toàn bộ một gói. Trước mắt ưu tiên phản hồi TN01–TN03 vì chúng ảnh hưởng vòng điều khiển và lưu trạng thái.

## 4. Chi tiết không cần duyệt từng mục lúc này

Mã dữ liệu, tên file, quy tắc chống ghi trùng, kiểm tra tổng lượng, cách lưu nguồn và công cụ tìm lỗi là lựa chọn triển khai/kiểm chứng có thể tiếp tục đề xuất. Chúng không được tự thay đổi trải nghiệm đã chọn.

Ngôn ngữ lập trình, thư viện và cấu trúc lưu trữ vẫn chưa chọn. Khi tới đó cần đề xuất theo hiệu năng, khả năng mở rộng và cách chạy trên máy, không biến việc chọn công nghệ thành yêu cầu người dùng phải biết kỹ thuật.

## 5. Tham số cần hoàn thiện tiếp, có thứ tự

| Gói | Việc phải cụ thể | Điều kiện kiểm tra |
| --- | --- | --- |
| DL01 — Sinh kế | Ai có quyền nhận suất từ kho nào; lịch thu nhập/chi; nguồn khi hết tiền | Không có người được nuôi bằng nguồn ẩn; 500 suất đầu và sản lượng được đối chiếu |
| DL02 — Vật thể | Khối lượng/kích thước 36 mẫu, cấu tạo, tải và phần dư | Tách/lắp/chuyển không tạo vật hoặc khối lượng |
| DL03 — Cơ thể | Bộ phận thử, chức năng, hệ số mệt, tác động thử và hồi phục | Chuỗi B có đầu vào/kết quả đủ định lượng |
| DL04 — Công việc/NPC | Điều kiện, tiến độ, ưu tiên, mốc đánh giá lại và quyền nhận việc | Một ngày có lịch khả thi, việc kẹt có lý do |
| DL05 — Tu luyện | Kho cá thể, tuyến, hiệu suất theo mẫu và chuyển mốc thử | Nguồn vào/ra khép kín, không nhân năng lượng |
| DL06 — Chiến đấu | Vị trí, thời lượng pha và quy tắc tiếp xúc mẫu | Chuỗi E tái hiện, phòng thủ cùng mốc xử lý đúng quy ước |

Thứ tự này ưu tiên làm cộng đồng sống được trước khi mở rộng chiến đấu và thần thông. Mỗi con số là giả định có mục đích, cần điều chỉnh khi có dữ liệu mô phỏng.

## 6. Khi nào chuyển sang lập trình?

Tiến độ: K1/K2/K3 đã được kiểm toán; K4.1–K4.9 đã định và đóng gói nền mô phỏng tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Toàn bộ 1.860 điều kiện thuộc 41 họ vẫn chưa chạy; chưa có registry/catalog/code/evidence, parity/save run, benchmark hoặc ADR chọn stack. Khi người dùng yêu cầu triển khai, bắt đầu prototype và V0. TN01–TN08 vẫn chưa được xác nhận.

Chỉ chuyển khi người dùng yêu cầu triển khai. Trước đó cần biết lựa chọn trải nghiệm áp dụng, phạm vi chặng đầu, các gói dữ liệu đủ cho chặng và tiêu chí đánh giá.

Không cần định lượng toàn thế giới trước dòng mã đầu tiên, nhưng cũng không coi các chương thiết kế dài là đã đủ chạy. Có thể triển khai theo chặng sau khi được yêu cầu; phần chưa có phải hiển thị là chưa hỗ trợ, không giả lập bằng lời kể rồi báo đã hoàn thành.

## 7. Cách ghi phản hồi

Người dùng có thể trả lời theo mã hoặc sửa trực tiếp nội dung. Khi nhận phản hồi rõ, cập nhật DECISIONS với ngày/nội dung và các đặc tả liên quan. “Tiếp” đơn thuần vẫn là tiếp tục kế hoạch, không tự xác nhận TN01–TN08.

Nếu chưa có phản hồi, tiếp tục gói kế hoạch hiện tại theo STATE như một phương án đề xuất; giữ những phần phụ thuộc lựa chọn ở trạng thái chưa chốt. Không hỏi lại điều đã được xác nhận và không yêu cầu duyệt lại toàn bộ hồ sơ.



