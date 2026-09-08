---
aliases: [Kịch bản chơi thử thống nhất]
tags: [thiet-ke, choi-thu, kiem-chung]
status: de-xuat
updated: 2026-09-05
---

# Kịch bản chơi thử thống nhất — 0.1

Liên quan: [[LIEN_KET_HE_THONG]] · [[MASTER_PLAN]] · [[STATE]] · [[DECISIONS]].

> Đây là đặc tả đề xuất cho một bản kiểm chứng tương lai, chưa có game chạy được. Quy mô nhỏ giúp kiểm tra chiều sâu, không thay mục tiêu thế giới lớn của người dùng.

## 1. Điều bản chơi thử phải chứng minh

Người chơi giao một mục tiêu có giới hạn; nhân vật tự sống, kiếm nguồn và tu luyện. Khi điều kiện đổi, kế hoạch đổi có lý do. NPC làm điều tương tự với động cơ riêng. Hậu quả phải đi qua ít nhất vài hệ, không chỉ có đoạn kể.

Không yêu cầu mọi người đều thành công hoặc mỗi lượt chơi gặp đủ biến cố. Cần một chế độ kiểm chứng riêng để tạo đầu vào cố định, phân biệt với diễn biến tự nhiên khi chơi.

## 2. Phạm vi đề xuất

Danh mục khởi đầu và thông số thử: [[DU_LIEU_KHOI_DAU]]. Đây là hồ sơ Markdown, chưa có đủ mọi tham số để chạy.

Giữ quy mô tham khảo MASTER_PLAN: một làng, vùng ngoài làng, cơ sở tu luyện nhỏ; khoảng 20–30 NPC và 30–50 loại vật phẩm. Đây chưa là danh sách nội dung hoàn tất hay số lượng đã được duyệt.

Các vai trò cần có trong nhóm: người làm nông, người hái thuốc, người chữa trị, người sửa dụng cụ, người buôn/vận chuyển, người dạy và quản lý kho. Một NPC có thể giữ nhiều vai trò khi lịch cho phép; không tạo nhân lực vô hình để lấp việc thiếu.

Địa điểm cần liên kết: nơi ở/chợ, y quán, ruộng/bãi thuốc, xưởng, tuyến qua cầu có đường vòng, nơi luyện có nguồn hữu hạn. Kho và tài sản ban đầu phải có nguồn khởi tạo ghi rõ.

Ba công pháp mẫu dùng TU_LUYEN; một mốc chuyển cấu trúc để kiểm chứng đột phá. Không rút ngắn mọi đời tu luyện thành 30 ngày chỉ để kịch bản kết thúc.

## 3. Các chế độ kiểm chứng

Cấu trúc fixture, ảnh lưu, overlay và assertion đề xuất được chuẩn hóa ở [[LUOC_DO_TRANG_THAI]]. Danh mục A–E hiện mới là thiết kế, chưa có tệp dữ liệu máy.

| Chế độ | Mục đích | Nguồn biến cố |
| --- | --- | --- |
| Chơi thường | Đánh giá giao việc và đời sống tự vận hành | Mô phỏng từ trạng thái/nguồn và ngẫu nhiên đã lưu |
| Tình huống cố định | Kiểm tra một điểm giao nhau | Đầu vào được ghi rõ như hỏng cầu tại mốc t |
| Quan sát cộng đồng | Xem NPC sống không cần người chơi kích hoạt | Cùng thế giới, không can thiệp bằng mục tiêu người chơi |
| Tái hiện | Tìm lỗi/đối chiếu kết quả | Bản lưu + phiên bản + lệnh/sự kiện kiểm chứng |

Biến cố chèn khi kiểm chứng không được trình bày là câu chuyện tự sinh trong đánh giá. Công cụ kiểm chứng có thể nhìn dữ liệu thật; người chơi thường không có quyền đó.

## 4. Mục tiêu người chơi mẫu

“Trong 30 ngày, duy trì thức ăn và nơi ở, kiếm nguồn học công pháp cơ bản, luyện khi đủ điều kiện. Giữ phần tiền dự phòng đã đặt, không bán vật kỷ niệm, không tự đột phá. Ưu tiên rút lui khi có nguy hiểm vượt giới hạn.”

30 ngày là khoảng quan sát, không hạn bắt buộc mọi tiến bộ phải hoàn tất. Giá, lượng dự phòng và thời lượng học cần bộ dữ liệu kế tiếp. Trước nhận mục tiêu, giao diện diễn giải các giới hạn và cho thấy những điều chưa có cách thực hiện.

## 5. Chuỗi A — Sinh kế và học công pháp

1. Nhân vật dùng hiểu biết ban đầu tìm việc đã biết hoặc hỏi người quen.
2. Công việc tiêu thời gian/công cụ và tạo sản phẩm/dịch vụ thực.
3. Nhận tiền theo giao nhận/hợp đồng, mua nguồn sống trong kho có thật.
4. Tìm cơ hội học qua người/văn bản biết được, đáp ứng điều kiện.
5. Học tạo kiến thức, phiên luyện tạo tiến triển đúng hướng, nguồn giảm tương ứng.

Đối chiếu trước/sau: vị trí, tiền hai phía, vật tư, thời gian, hiểu biết, linh lực và nghĩa vụ. Nếu không đủ tiền hoặc không tìm được người dạy, kết quả hợp lệ là trở ngại giải thích được, không cấp công pháp miễn phí để ép hoàn thành.

## 6. Chuỗi B — Thương tích làm đổi đời sống

Đầu vào định lượng đề xuất tại [[CO_THE_THU]]: W-B01, nhánh B-LOCAL có người/vật chăm sóc tại chỗ và B-REMOTE phải tìm hỗ trợ. Chưa chạy hai nhánh; không dùng lịch chăm sóc tại chỗ cho nhân vật đang ở xa.

Đầu vào kiểm chứng: tại một mốc xác định trong công việc, tạo tác động đã khai báo lên tay trái. Đây là đầu vào thử, chưa phải xác suất tai nạn tự nhiên.

Mong đợi: cơ thể đổi chức năng → hành động kiểm tra tiếp tục/đổi tay/dừng → tiêu vật tư chăm sóc nếu được phép → lịch làm/học đổi → thu nhập và thời gian mục tiêu đổi. Thương tích không mất khi giao việc mới hoặc tải game.

So một lượt không có tác động với lượt có tác động, giữ các đầu vào khác tới mốc chèn. Sau mốc, hành vi có thể phân nhánh tự nhiên; không yêu cầu toàn bộ tương lai vẫn giống nhau.

## 7. Chuỗi C — Đường hỏng và nghĩa vụ

Đầu vào kiểm chứng: cầu hỏng trong lúc chuyến hàng đang đi. Hàng ở vị trí thật; người vận chuyển chọn chờ/đường vòng theo hiểu biết. Bên nhận chưa biết lý do ngay.

Mong đợi: thời gian giao thay đổi → tồn kho giảm theo sử dụng → thông tin chậm có thể gây hiểu lầm → khi tin tới, người nhận đánh giá lại. Nghĩa vụ chỉ đổi khi thỏa thuận/quy tắc cho phép; không xóa nợ hay tạo hàng thay thế.

Kiểm tra riêng hai nhánh có/không có người đưa tin. Điều cần khác là nhận thức và phản ứng từ lúc nhận tin, không phải sự thật hàng đang ở đâu.

## 8. Chuỗi D — Nguồn tu luyện hữu hạn

DL05 tại [[TU_LUYEN_THU]] cụ thể hóa INIT-D, hai nhánh phân chia nguồn, linh thạch và bản lưu chuyển mốc TM-01. Các kết quả mới là phép tính trên giấy, chưa phải bằng chứng mô phỏng.

Đầu vào: hai chủ thể dùng chung nguồn với lượng/luồng bổ sung đã định. Mong đợi tổng rút không vượt nguồn; cơ thể giới hạn tiếp nhận; nơi luyện và vật cấp nguồn giữ số dư thống nhất.

Cho một người đổi lịch hoặc rời đi bằng hành động hợp lệ. Người còn lại chỉ biết thay đổi nguồn qua khả năng nhận biết; không tự biết toàn bộ lượng linh lực của đối phương.

Đột phá kiểm tra bằng bản lưu gần mốc có nguồn gốc rõ, không bắt mỗi lần chạy lại trải qua nhiều năm. Bản lưu kiểm chứng có thể khởi tạo trạng thái gần mốc nhưng phải ghi là khởi tạo, không giả đã luyện thật.

## 9. Chuỗi E — Xung đột và hậu quả

DL06 tại [[CHIEN_DAU_THU]] định lượng E-GUARD/E-SAME/E-DODGE, tác động đồng thời, rút lui và E-LINH. INIT-E là khởi tạo kiểm chứng riêng; chưa có bằng chứng từ game chạy.

Đầu vào kiểm chứng: một cuộc gặp có chủ thể, vị trí, mục tiêu và chính sách rõ. Có thể dùng hành vi chặn đường đã cấu hình; không cam kết lượt chơi thường luôn sinh cuộc gặp đó.

Theo dõi giao tiếp, nhận biết, pha hành động, thương tích/nguồn và rút lui/đầu hàng. Sau xung đột tiếp tục lịch thế giới: chăm sóc, đồ còn lại, giao hàng, tiền công và ký ức. Không reset khi đóng thẻ chiến đấu.

Có trường hợp hai tác động cùng mốc, thế đỡ hoàn tất sớm hơn/cùng mốc, nguồn cuối bị hai thuật tranh và mất dấu qua điểm nối. Dùng LIEN_KET_HE_THONG để xác định kết quả mong đợi.

## 10. Giao diện tối thiểu để đánh giá

- Trang hiện tại: việc đang làm, tình trạng, thông báo quan trọng, nút dừng theo lựa chọn sẽ chốt.
- Mục tiêu/lịch: ưu tiên, giới hạn, tiến độ, lý do kẹt và bước dự phòng.
- Người/vật/địa điểm: phần đã biết và nguồn thông tin.
- Nhật ký: biến cố, nguyên nhân có thể biết, liên kết tới đối tượng.
- Lưu/tải: thời điểm, phiên bản và mô tả bản lưu.

Chưa chọn bố cục hoặc công nghệ. Không dùng bảng toàn tri để bù việc chưa có hệ nhận thức rồi coi là giao diện chơi cuối cùng.

## 11. Điều kiện đánh giá đạt

Trạng thái kiểm toán trước triển khai của từng BT nằm ở [[KIEM_TOAN_TICH_HOP]]. Không BT nào đã đạt; các nhãn “đủ mô tả” hoặc “khép kín trên giấy” không phải kết quả kiểm thử.

| ID | Điều kiện | Bằng chứng cần có khi triển khai |
| --- | --- | --- |
| BT01 | Một nguồn dữ liệu | Đối chiếu mọi chuyển vật/tiền/năng lượng trong chuỗi, không lượng âm/nhân đôi |
| BT02 | Hậu quả liên hệ | Chuỗi B thể hiện thay đổi cơ thể → việc → nguồn sống |
| BT03 | Nhận thức đúng giới hạn | Chuỗi C thay đổi phản ứng từ thời điểm nhận tin, không sớm hơn |
| BT04 | Mục tiêu có giới hạn | Không tự bán vật cấm/dùng dự phòng/đột phá khi chưa được giao quyền |
| BT05 | NPC tự vận hành | Có nguồn mục tiêu, công việc và nghĩa vụ dù không có người chơi can thiệp |
| BT06 | Nguồn tu luyện | Chuỗi D khép kín lượng vào/ra và lưu lượng |
| BT07 | Kết thúc xung đột | Chuỗi E giữ thương tích, đồ, hợp đồng và ký ức |
| BT08 | Tái hiện | Lưu tại hành trình, chế tác, luyện và chiến đấu; tiếp tục cho cùng kết quả với cùng đầu vào |
| BT09 | Nhịp giao diện độc lập | Thay số lần vẽ/mở trang không đổi kết quả mô phỏng |
| BT10 | Hiệu năng đo được | Ghi cấu hình, số chủ thể, tốc độ đạt được và độ trễ dừng; không bỏ sự kiện để đạt 5 giây/ngày |
| BT11 | Trở ngại giải thích được | Mỗi việc không tiến có lý do/mốc đánh giá lại, không lặp vô hạn |
| BT12 | Cộng đồng có nguồn sống | Chạy nền không dùng nguồn cứu ẩn; báo các thiếu hụt thay vì che chúng |

Hiện tất cả điều kiện ở trạng thái chưa chạy. Chưa có số đo hiệu năng, mức cân bằng đạt hoặc kết quả kiểm thử tự động.

## 12. Những quyết định trước khi lập trình

| Chủ đề | Phương án đề xuất để viết bản kiểm chứng | Trạng thái |
| --- | --- | --- |
| Thời gian | 5 giây/ngày mặc định; cho dừng và tự dừng khi nhận biết nguy cấp | Tốc độ đã yêu cầu; dừng chưa chốt |
| Đóng game | Không tiến khi đóng ở bản đầu | Chưa chốt |
| Điều khiển | Mục tiêu có cấu trúc; nhân vật theo lệnh trong khả năng/hiểu biết | Chưa chốt giới hạn tự chủ |
| Không gian | Mạng đường và vị trí cục bộ đơn giản, chưa bay | Chưa chốt phạm vi |
| Quy mô | Phạm vi nhỏ nêu ở mục 2, một mức mô phỏng | Chưa chốt |
| Tu luyện | Ba mẫu, một chuyển mốc chức năng; chưa đặt hệ tầng dài hạn | Chưa chốt |
| Chết/lưu lại | Giữ hậu quả trong thế giới; chính sách tải lại/kế thừa cần chọn | Chưa chốt |
| Dữ liệu | Danh mục cụ thể, đơn vị và thông số hư cấu có thể kiểm chứng | Chưa viết đầy đủ |
| Công nghệ | Chọn sau khi yêu cầu lưu trữ, hiệu năng và giao diện đủ rõ | Chưa chọn |

Các câu hỏi này được ghi để thảo luận trước triển khai, không chặn việc tiếp tục viết kế hoạch. Người dùng nói “tiếp” không có nghĩa đã duyệt mọi phương án.

## 13. Việc kế tiếp có thể làm ngay

Viết hồ sơ dữ liệu khởi đầu cho bản kiểm chứng: danh mục người/vai trò, địa điểm/đường, vật tư, công việc, nguồn năng lượng và các đơn vị tạm. Mỗi con số đánh dấu mục đích kiểm chứng/cân bằng, không gọi là thông số chân thật đã được chứng minh.

Sau đó thiết kế luồng giao diện bằng chữ, đối chiếu bảng quyết định và chỉ chuyển sang lập trình khi người dùng yêu cầu. Không mở thêm các hệ lớn không cần cho chuỗi đầu chỉ để làm tài liệu dài hơn.
