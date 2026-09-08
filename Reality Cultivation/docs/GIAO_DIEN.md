---
aliases: [Giao diện text và luồng chơi]
tags: [thiet-ke, giao-dien, trai-nghiem]
status: de-xuat
updated: 2026-09-05
---

# Giao diện text và luồng chơi — 0.1

Liên quan: [[MASTER_PLAN]] · [[HANH_DONG]] · [[THOI_GIAN]] · [[BAN_CHOI_THU]] · [[DU_LIEU_KHOI_DAU]] · [[DECISIONS]].

> Đặc tả đề xuất bằng chữ, chưa là giao diện hoạt động. Những màn hình mẫu minh họa cách trình bày, không phải kết quả game đã chạy. Tạm dừng và các quyền tự động dưới đây vẫn cần chốt với người dùng.

Yêu cầu đã xác nhận: trò chơi phải dùng được trên điện thoại và máy tính. Các bố cục, thao tác và kiểm chứng trong tài liệu này phải bao phủ cả hai loại thiết bị; công nghệ triển khai vẫn để mở.

## 1. Nguyên tắc trải nghiệm

Người chơi cần trả lời nhanh: nhân vật đang làm gì, vì sao làm, có vấn đề gì và có thể thay đổi gì. Chi tiết cơ thể, vật phẩm và xã hội mở theo nhu cầu, không tràn ra cùng lúc.

Không có đồ họa không đồng nghĩa chỉ một ô lệnh khó nhớ. Đề xuất chữ, bảng ngắn, nút và liên kết đối tượng; điều khiển được bằng bàn phím. Ngôn ngữ tự nhiên là phần mở rộng, không phụ thuộc để chơi được.

Điện thoại ưu tiên thao tác chạm, một tay và nội dung một cột; máy tính hỗ trợ bàn phím và nhiều vùng cùng lúc. Hai chế độ dùng cùng mô phỏng và không được cho lợi thế thông tin khác nhau.

## 2. Cấu trúc trang

Thanh cố định: thời gian game, trạng thái chạy/dừng, tốc độ, nơi hiện tại và cảnh báo cần chú ý. Sáu khu vực: Hiện tại; Mục tiêu và lịch; Nhân vật; Xung quanh; Nhật ký; Lưu và thiết lập.

Trang Hiện tại là mặc định. Chi tiết mở trong vùng bên cạnh trên màn hình rộng hoặc trang con có nút quay lại trên màn hình hẹp. Giữ vị trí đọc khi quay lại; không tự cuộn người chơi xuống cuối nhật ký.

Tìm kiếm chỉ tìm thông tin đã biết hoặc thuộc quyền truy cập. Không liệt kê toàn bộ tên vật/NPC/công pháp bí mật thông qua gợi ý tìm kiếm.

## 3. Màn hình đầu của dữ liệu mẫu

```text
Ngày 1, 06:00 · Khu nhà ở · ĐANG DỪNG
Tốc độ khi chạy: 5 giây/ngày                 [Tiếp tục]

Khách lữ hành
Đang nghỉ; chưa có mục tiêu chủ động.
Chưa ghi nhận triệu chứng bất thường.
Tiền mang: 40 đồng · Lương khô: 6 suất

[Giao mục tiêu] [Xem hành lý] [Xem nơi này]

Bạn biết sân chợ và đường từ khu nhà ở tới đó.
Chưa biết nơi học công pháp.
```

Đề xuất lần tạo thế giới đầu dừng để người chơi đọc và giao việc, chưa trừ thời gian trong lúc thiết lập. 40 đồng/6 suất lấy từ DU_LIEU_KHOI_DAU; không hiển thị tổng 2.000 đồng toàn vùng hoặc nguồn hang chưa biết.

“Chưa ghi nhận triệu chứng” khác xác nhận mọi bộ phận hoàn hảo. Trang Nhân vật chỉ thể hiện mức biết được.

## 4. Giao mục tiêu

Luồng: chọn loại → chọn kết quả → ưu tiên và giới hạn → xem diễn giải → áp dụng.

Ví dụ loại mục tiêu: duy trì sinh hoạt, kiếm thu nhập, tìm người dạy, học phần đã biết, luyện công đã học, chăm sóc tình trạng đã nhận biết. Có thể thêm mục tiêu tìm hiểu khi chưa biết cách thực hiện; không cần biết tên người dạy bí mật để yêu cầu tìm người dạy.

Biểu mẫu mẫu:

```text
Mục tiêu: Tìm cơ hội học công pháp cơ bản
Ưu tiên: Sau sinh hoạt thiết yếu
Hạn theo dõi: 30 ngày
Giữ ít nhất: 10 đồng dự phòng
Không được bán: Dấu kỷ niệm
Không tự đột phá
Khi chưa có cách: hỏi người đã gặp; làm việc kiếm sống đã cho phép

[Áp dụng mục tiêu] [Lưu nháp] [Hủy nháp]
```

Trước áp dụng hiển thị diễn giải gọn ngay trong cùng màn hình; không thêm nhiều hộp xác nhận cho mỗi thao tác thường. Áp dụng là gửi lệnh, không bảo đảm mục tiêu có thể hoàn thành.

## 5. Quyền tự động phải rõ

Đề xuất nhóm quyền: chi tiền; bán vật; đi xa; nhận hợp đồng; dùng vật tư hỗ trợ; đột phá; hành vi khi gặp nguy hiểm. Mỗi quyền có giới hạn và phạm vi mục tiêu/chính sách chung.

Mặc định an toàn trong mẫu: không tự vay, không bán vật cấm, không tự đột phá. Đây là cấu hình đề xuất, không coi là người dùng đã chọn. Không ẩn những quyền này dưới một nút chung “tối ưu nhân vật”.

Giới hạn xung đột phải hiển thị: ngân sách 20 đồng nhưng giữ 30 trong số 40 thì tối đa chi hiện tại là 10, không âm thầm dùng 20. Cho sửa tại đúng trường liên quan.

## 6. Thời gian trong lúc đọc và sửa

Đề xuất mở trang xem không tự dừng; trạng thái chạy luôn nhìn thấy. Khi bắt đầu chỉnh mục tiêu, tự dừng để tránh nhiều ngày trôi trong biểu mẫu và ghi rõ lý do dừng. Đóng biểu mẫu không tự chạy lại; người chơi chọn Tiếp tục.

Nếu người chơi chọn tiếp tục chạy trong lúc có bản nháp, bản nháp không điều khiển nhân vật. Khi áp dụng, kiểm tra theo trạng thái mới và báo trường không còn hợp lệ. Không ghi đè thế giới bằng ảnh trạng thái lúc mở biểu mẫu.

Không cộng thời gian bị dừng thành một khoản chờ chạy bù. Lệnh đi vào ranh giới cập nhật an toàn của THOI_GIAN; giao diện không sửa trực tiếp vật phẩm/cơ thể.

## 7. Phản hồi lệnh

Phân biệt: bản nháp; đã gửi; đã tiếp nhận; chờ chuyển việc; đang thực hiện; bị từ chối. Lệnh có mã để gửi lại do lỗi hiển thị không tạo hai mục tiêu/hai giao dịch.

Ví dụ: “Đã nhận mục tiêu mới. Nhân vật đang thu công trước khi chuyển việc.” Không ghi “đã dừng luyện” khi pha thu công chưa xong.

Từ chối có nguyên nhân có thể biết, giữ lại phần biểu mẫu để sửa. Nếu nguyên nhân thật là bí mật, chỉ báo kết quả quan sát hợp lệ, không tiết lộ dữ liệu nội bộ qua thông báo lỗi.

## 8. Theo dõi và giải thích hành vi

Thẻ mục tiêu có kết quả mong muốn, ưu tiên, trạng thái, bước hiện tại, điều kiện còn thiếu, nguồn đã dùng và lần đánh giá tiếp theo.

Ví dụ ở thời điểm tương lai hư cấu:

```text
Tìm cơ hội học công pháp · ĐANG TÌM HIỂU
Đang đi tới sân chợ để hỏi người địa phương.
Lý do: chưa biết nơi dạy; sân chợ là nơi đã biết có thể gặp người.
Tiền có thể dùng hiện tại: 30 đồng, trước các khoản đã cam kết khác.
[Xem kế hoạch] [Sửa giới hạn] [Tạm hoãn mục tiêu]
```

Kế hoạch là dự kiến theo hiểu biết, không tiết lộ đường dẫn tối ưu toàn thế giới. Khi tương lai chưa chắc, dùng khoảng/điều kiện thay thời gian hoàn tất giả chính xác.

## 9. Việc bị kẹt

Phân biệt chờ bình thường với không có phương án. Chờ cửa mở có mốc; thiếu kiến thức có hướng tìm hiểu; mọi phương án vi phạm giới hạn thì nêu giới hạn nào.

Đưa lựa chọn tương ứng: tiếp tục chờ, đổi mục tiêu, sửa ngân sách, tìm thông tin, tạm hoãn. Không mặc định đề xuất vay nợ hoặc bán gia bảo vì dễ giải quyết nhất.

Gộp thông báo cùng nguyên nhân, chỉ nhắc lại khi thay đổi đáng kể hoặc đến mốc đã chọn. Nhật ký vẫn giữ thời lượng kẹt để người chơi hiểu mục tiêu không tiến.

## 10. Cơ thể, hành lý và thông tin chi tiết

Trang Nhân vật ưu tiên triệu chứng/khả năng ảnh hưởng việc, rồi mở tới bộ phận và lịch chăm sóc. Cây bộ phận mặc định thu gọn phần không có thông tin đáng chú ý; vẫn có thể duyệt tất cả vùng đã mô hình hóa.

Hành lý tách đang mang, đồ ở nơi khác đã biết, đồ giữ hộ và đồ đã cam kết. Nút dùng đồ ở xa phải dẫn tới kế hoạch lấy đồ, không sử dụng ngay. Tổng tải chưa có dữ liệu đủ thì hiển thị chưa tính, không mặc định 0 kg.

Mỗi thông tin có thể mở nguồn và thời điểm: tự thấy, người khác kể, kết quả kiểm tra hoặc suy đoán. Không hiện phần trăm mô hỏng, chất lượng ẩn hoặc ví của NPC chỉ vì có trang chi tiết.

## 11. Nơi chốn, NPC và giao tiếp

Trang Xung quanh chỉ liệt kê những gì nhận biết tại nơi hiện tại. “Lần cuối gặp ở…” không được trình bày như vị trí trực tiếp. Địa điểm đã biết có thể có thông tin đường cũ và nút lên kế hoạch đi/khảo sát.

Tương tác gồm hỏi, đề nghị, mua/bán, nhận việc hoặc nhờ giúp theo điều kiện. Gửi đề nghị không đồng nghĩa đối tác nhận. Giao dịch có màn hình điều kiện/giá hiện tại và một nút chấp nhận rõ; thay giá trước tiếp nhận cần báo lại, không tự trả mức cao hơn.

Mua giao sau hiển thị nghĩa vụ giao, không cộng ngay vào hành lý. Quan hệ thể hiện trải nghiệm đã biết và đánh giá của nhân vật; không công khai số thiện cảm bí mật của người khác.

## 12. Tự dừng khi nguy hiểm

Đề xuất thẻ nổi bật nhưng không phủ kín mọi thông tin: lý do dừng, điều đã xảy ra, tình trạng hiện tại, chính sách đang áp dụng và lựa chọn tiếp theo.

```text
ĐÃ TỰ DỪNG — nhận biết bị tấn công
Thương tích vừa xảy ra đã được ghi nhận.
Chưa biết còn đối thủ khác hay không.
Chính sách: ưu tiên thoát thân, không dùng nguồn dự phòng.
[Giữ chính sách và tiếp tục] [Sửa chính sách] [Xem tình trạng]
```

Không hiển thị “đầu hàng thành công” khi mới gửi lời đề nghị. Nếu bất tỉnh, các lựa chọn tác động chủ động bị vô hiệu với lý do; chỉ có thể chỉnh chính sách tương lai hoặc xem thông tin được phép.

## 13. Nhật ký và thông báo

Ba mức: cần quyết định; biến đổi đáng chú ý; sinh hoạt gộp. Nhu cầu đọc tăng theo điều người chơi quan tâm, không theo mỗi lần cập nhật mô phỏng.

Mỗi mục ghi thời điểm sự việc và thời điểm biết tin nếu khác; đối tượng liên quan; nội dung biết được; liên kết xem thêm. Bộ lọc theo mục tiêu/người/vật không tạo tri thức mới.

Đọc không cuộn cưỡng bức khi có tin mới; hiện số tin mới và nút tới mới nhất. Không phát thông báo mọi ngày chỉ để báo nhân vật tiếp tục làm việc bình thường.

## 14. Lưu, tải và kết thúc đời nhân vật

Trang lưu ghi thời điểm game, tên mô tả, phiên bản và trạng thái lưu đang xử lý/đã xong/thất bại. Không báo thành công trước khi bản lưu được xác nhận. Lưu tự động không được ghi đè bản thủ công duy nhất nếu chưa có chính sách đó.

Tải thay thế diễn biến chưa lưu cần một xác nhận rõ và cho lưu hiện tại nếu có thể. Tải không tương thích phải báo lý do, không âm thầm tạo thế giới mới.

Khi nhân vật chết, hiển thị điều đã biết, lịch sử có nguồn và lựa chọn được chế độ cho phép. Chưa chốt tải lại/kế thừa nên không dựng nút hồi sinh miễn phí như tính năng mặc định.

## 15. Bàn phím và khả năng đọc

Đề xuất dùng Tab/Shift+Tab chuyển điều khiển, Enter kích hoạt, Escape đóng vùng phụ hoặc hỏi xử lý nháp chưa lưu. Không bắt dùng chuột hoặc nhớ câu lệnh để làm việc thường.

Phím tắt dừng phải được chốt và không kích hoạt khi đang nhập văn bản; không tự dùng Space toàn cục gây dừng mỗi lần gõ dấu cách. Giữ tiêu điểm sau cập nhật, nhãn trạng thái có chữ thay vì chỉ màu.

Cho đổi cỡ chữ/độ rộng dòng; bảng dài có cách xem dạng danh sách trên màn hình hẹp. Thông báo mới không liên tục đọc lại toàn màn hình với công cụ hỗ trợ đọc.

Trên màn hình cảm ứng, mục bấm phải đủ tách biệt; thao tác thường không đòi rê chuột, nhấp phải, giữ lâu hoặc kéo chính xác. Nội dung không phụ thuộc vào trạng thái hover. Bàn phím ảo mở không được che trường đang sửa, nút áp dụng hoặc cảnh báo thời gian vẫn chạy.

Khi điện thoại bị hệ điều hành đưa xuống nền, giao diện phải lưu hoặc đánh dấu rõ trạng thái đang lưu trước khi mất phiên. Cách thế giới tiến triển trong lúc ứng dụng đóng vẫn phụ thuộc TN02. Đồng bộ bản lưu giữa điện thoại và máy tính là câu hỏi riêng, chưa được xác nhận.

## 16. Bản đồ luồng chính

```text
Mở bản lưu/tạo thế giới
        ↓
Hiện tại → Giao mục tiêu → Diễn giải + giới hạn → Áp dụng
    ↑                                            ↓
    └──── Theo dõi ← Tiếp nhận / chờ chuyển / từ chối
              ├─ Chờ bình thường → tiếp tục theo lịch
              ├─ Kẹt → xem lý do → sửa hoặc giữ phương án
              └─ Nguy hiểm nhận biết → tự dừng → chọn chính sách
```

Các mũi tên là luồng giao diện, không yêu cầu mô phỏng bỏ qua thời gian/điều kiện giữa bước.

## 17. Kiểm chứng trải nghiệm khi có giao diện

| ID | Tình huống | Điều cần đạt |
| --- | --- | --- |
| UI01 | Mở đầu INIT-A | Chỉ thông tin P00 biết; không lộ hang/công pháp |
| UI02 | Giao mục tiêu mẫu | Nhìn rõ 10 đồng dự phòng và cấm bán kỷ niệm trước áp dụng |
| UI03 | Sửa khi đang chạy | Dừng có lý do theo mặc định đề xuất; không chạy bù |
| UI04 | Đổi ý khi đang thu công | Báo chờ chuyển, không giả đã thực hiện |
| UI05 | Gửi lệnh lặp | Không tạo hai mục tiêu/giao dịch |
| UI06 | Việc kẹt lâu | Một lý do rõ, mốc đánh giá lại, không tràn thông báo |
| UI07 | Xem đồ ở kho xa | Không dùng tức thì; có kế hoạch lấy |
| UI08 | Mở tìm kiếm | Không gợi ý đối tượng bí mật |
| UI09 | Đang đọc nhật ký | Giữ vị trí/tiêu điểm khi tin tới |
| UI10 | Tự dừng sau bất ngờ | Không xóa hậu quả hoặc lộ đối thủ chưa phát hiện |
| UI11 | Giá đổi trước mua | Không chi vượt mức đã chấp nhận |
| UI12 | Lưu lỗi/tải sai phiên bản | Thông báo trung thực, không mất bản lưu cũ âm thầm |
| UI13 | Chỉ bàn phím | Thực hiện được luồng giao mục tiêu và xử lý kẹt |
| UI14 | Bất tỉnh/chết | Không còn điều khiển hành động không thể thực hiện |
| UI15 | Điện thoại màn hình hẹp | Hoàn tất giao mục tiêu, xem kẹt và lưu mà không cuộn ngang toàn trang |
| UI16 | Chạm, không chuột | Không có chức năng thiết yếu chỉ dùng hover/nhấp phải/kéo chính xác |
| UI17 | Máy tính chỉ bàn phím | Giữ luồng, tiêu điểm và phím tắt đúng khi mô phỏng cập nhật |
| UI18 | Ứng dụng điện thoại bị treo/đóng nền | Trạng thái lưu và thời gian thế giới tuân chính sách đã chốt, không âm thầm chạy bù |

Chưa chạy kiểm chứng giao diện; tài liệu này mới là luồng và mẫu chữ. Cần đánh giá trên giao diện hoạt động sau khi người dùng yêu cầu triển khai.

## 18. Những lựa chọn còn cần chốt

Mặc định tự dừng khi sửa mục tiêu, tự dừng nguy hiểm, khả năng chạy khi đóng, quyền tự nhận hợp đồng và hậu quả chết đều ảnh hưởng trải nghiệm. Các đề xuất ở đây không biến thành xác nhận của người dùng.

Bước kế hoạch tiếp theo: gom lựa chọn quan trọng thành một bản đề xuất dễ duyệt, phân biệt quyết định trải nghiệm với chi tiết kỹ thuật có thể tiếp tục thiết kế; hoàn thiện các tham số còn thiếu cho kịch bản kiểm chứng. Không tự chuyển sang lập trình.
