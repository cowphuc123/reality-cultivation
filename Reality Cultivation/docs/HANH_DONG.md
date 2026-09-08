---
aliases: [Hành động và mục tiêu]
tags: [thiet-ke, nen-tang]
status: de-xuat
updated: 2026-09-05
---

# Hành động và mục tiêu — đặc tả 0.1

Liên quan: [[THOI_GIAN|Thời gian thế giới]] · [[MASTER_PLAN|Kế hoạch tổng thể]] · [[DECISIONS|Quyết định]].

> Trạng thái: đề xuất thiết kế, chưa lập trình. Yêu cầu đã có: người chơi giao công việc và mục tiêu cho nhân vật. Chi tiết tự động hóa dưới đây chưa được người dùng chốt.

## 1. Phân biệt ý muốn với hành động thực

“Trở thành luyện đan sư” là mục tiêu. “Mỗi chiều học dược lý” là lịch công việc. “Đọc bản thảo đang cầm” là hành động. “Không vay nợ” là giới hạn áp dụng cho các kế hoạch.

Không cho mục tiêu trừ tiền rồi cộng kinh nghiệm ngay. Nhân vật phải thực hiện từng bước có điều kiện, thời gian và hậu quả.

## 2. Hồ sơ mục tiêu

| Trường | Nội dung |
| --- | --- |
| Chủ thể, người giao | Ai thực hiện, mục tiêu từ người chơi hay nhu cầu bản thân |
| Kết quả mong muốn | Điều kiện kiểm tra được hoặc cột mốc cho khát vọng dài hạn |
| Ưu tiên | Mức quan trọng do người chơi đặt |
| Hạn chót | Có thể không có; quá hạn xử lý rõ ràng |
| Ngân sách | Tiền, vật liệu, thời gian tối đa được dùng |
| Giới hạn | Vùng được đi, rủi ro, tài sản không được bán, hành vi bị cấm |
| Nguồn hiểu biết | Vì sao nhân vật biết mục tiêu hoặc cách thực hiện |
| Kế hoạch hiện tại | Các bước và phụ thuộc giữa chúng |
| Tiến độ và trở ngại | Đã đạt gì, còn thiếu gì, đang chờ gì |
| Quy tắc kết thúc | Hoàn thành, duy trì, hết hạn hoặc bị hủy |

“Giữ đủ lương thực bảy ngày” là mục tiêu duy trì, có thể hoạt động trở lại khi lượng dự trữ xuống thấp. “Mua một thanh kiếm” kết thúc khi nhận đúng vật phẩm; không tự mua thêm mỗi lần kiếm rời túi.

## 3. Giới hạn bắt buộc và sở thích

Giới hạn bắt buộc loại phương án vi phạm: không bán gia bảo, không vay nợ, không dùng thuốc chưa biết, không chi quá ngân sách. Sở thích dùng để xếp hạng phương án hợp lệ: rẻ hơn, an toàn hơn, gần hơn.

Chính sách khẩn cấp cũng phải được khai báo: có cho dùng khoản tiền dự trữ để cứu mạng không? Đề xuất mặc định tự tìm cách cứu mình trong quyền hạn hiện có; nếu chỉ còn cách vượt giới hạn, báo khi có thể và không tự coi đó là quyền đã được giao.

Rủi ro là ước lượng theo kiến thức của nhân vật, không phải xác suất tuyệt đối được hệ thống tiết lộ. “Không chấp nhận nguy hiểm cao” không bảo đảm không gặp nguy hiểm bị che giấu.

## 4. Từ mục tiêu thành kế hoạch

Quy trình đề xuất:

1. Xác định khoảng cách giữa tình trạng đã biết và kết quả mong muốn.
2. Tìm cách đã học hoặc đã quan sát phù hợp với khoảng cách đó.
3. Chia thành các bước phụ thuộc: có nguyên liệu → có dụng cụ → đến nơi → thực hiện.
4. Ước lượng thời gian, chi phí, rủi ro và khả năng thành công.
5. Loại phương án vi phạm giới hạn; chọn phương án có ích nhất còn lại.
6. Chỉ cam kết bước gần nhất, đánh giá lại khi tình hình thay đổi.

Nhân vật không biết nơi mua thuốc thì có thể hỏi người quen hoặc tìm ở khu chợ đã biết. Không truy cập danh sách mọi cửa hàng trong thế giới để chọn nơi rẻ nhất.

Mục tiêu quá rộng dùng cột mốc gần: muốn gia nhập môn phái → tìm hiểu điều kiện tuyển → kiểm tra bản thân → chuẩn bị. Không lập trước hàng nghìn bước cho vài chục năm.

## 5. Hợp đồng của một hành động

Dữ liệu thử DL04 tại [[CONG_VIEC_THU]] cụ thể hóa hồ sơ, thao tác, giữ tiến độ, chọn việc và lịch có điều kiện. Các trọng số/thời lượng vẫn là đề xuất chưa chạy.

Mỗi loại hành động cần mô tả điều kiện bắt đầu, điều kiện duy trì, dữ liệu thời lượng/khối lượng việc, bộ phận cơ thể và công cụ cần dùng, chi phí, hiệu ứng theo tiến độ, kết quả, cách gián đoạn và thông tin nhân vật nhận được.

Mỗi lần thực hiện có danh tính riêng, chủ thể, mục tiêu liên quan, đích, thời điểm, tiến độ, vật tư đã dùng, tài nguyên đang giữ, phiên bản và lý do đổi trạng thái.

| Trạng thái | Ý nghĩa |
| --- | --- |
| Chờ điều kiện | Chưa đủ điều kiện; có nguyên nhân và mốc/sự kiện đánh giá lại |
| Sẵn sàng | Có thể bắt đầu nhưng chưa chiếm tài nguyên |
| Đang làm | Đang chiếm năng lực và tạo tiến độ |
| Đang dừng | Đang kết thúc thao tác hoặc xử lý hậu quả ngắt |
| Tạm hoãn | Có thể tiếp tục từ tiến độ được giữ |
| Hoàn tất | Kết quả đã áp dụng đúng một lần |
| Thất bại | Không đạt kết quả, ghi hậu quả và lý do |
| Đã hủy | Không tiếp tục; vật tư/tiến độ xử lý theo quy tắc hành động |

Trạng thái kết thúc không được chạy lại chỉ vì tải game hoặc mở nhật ký.

## 6. Tiến độ và tài nguyên

Phân công và giao dịch qua hệ theo [[LIEN_KET_HE_THONG]], mục 2–4. Hành động giữ tiến độ/chiếm năng lực, yêu cầu hệ quản lý nguồn chuyển lượng; không tự trừ vật tư hoặc linh lực lần nữa sau khi giao dịch đã hoàn tất.

Đề xuất đo công việc theo khối lượng cần làm, không chỉ một thời gian cố định. Tiến độ tăng bằng tốc độ làm việc nhân thời lượng; tốc độ có thể đổi theo mệt mỏi, thương tích, công cụ, kỹ năng và môi trường.

Một số quá trình như chờ nước nguội có tiến triển tự nhiên. Nhân vật chỉ bận ở bước cần thao tác hoặc theo dõi, không bị khóa suốt thời gian chờ nếu quy trình cho phép rời đi.

Tiền và vật tư có ba tình trạng khác nhau: dự kiến cần, đã giữ để dùng, đã tiêu hao. Dự kiến không đồng nghĩa sở hữu; giữ chỗ không đồng nghĩa tiêu hao. Chỉ giữ những gì chủ thể có quyền giữ.

Giao dịch phải kiểm tra lại tồn kho, giá và quyền sở hữu tại lúc thực hiện. Hai người mua món cuối không thể cùng nhận. Quyền giữ chỗ là thỏa thuận có hạn, không phải khóa vô hình đồ trong cửa hàng chỉ vì nhân vật đã lập kế hoạch.

## 7. Làm nhiều việc cùng lúc

Năng lực và quan hệ với thương tích được mô tả trong [[CO_THE|Cơ thể, thương tích và sinh lý]]. Hành động dùng chức năng được cung cấp; không áp thêm hình phạt trùng cho cùng một tổn thương.

Đề xuất dùng năng lực đang bị chiếm: di chuyển, tay trái/tay phải, chú ý, phát âm, vận công. Tên và mức năng lực sẽ liên kết đặc tả cơ thể.

- Có thể đi đường và trò chuyện khi sức khỏe, đường sá cho phép.
- Không vừa đọc kỹ một bản thảo vừa chiến đấu hiệu quả như bình thường.
- Hai tay đang băng bó không đồng thời rèn kiếm.
- Quá trình thụ động như lành vết thương tiếp tục khi ngủ hoặc lao động, với tốc độ chịu ảnh hưởng điều kiện.
- Công pháp yêu cầu tập trung phải định nghĩa làm gì được cùng lúc và hậu quả mất tập trung.

Không mặc định mọi việc đều độc quyền toàn cơ thể hoặc mọi thứ đều được chạy song song miễn phí.

## 8. Ngắt việc và tiếp tục

| Loại | Khi ngắt |
| --- | --- |
| Có thể dừng ngay | Dừng di chuyển tại vị trí đã tới; không hoàn lại quãng đường |
| Có điểm dừng thuận lợi | Cất dụng cụ hoặc kết thúc một thao tác trước khi chuyển việc |
| Cần dừng có quy trình | Thu công, xử lý lò; mất thời gian và có thể có rủi ro |
| Buộc ngắt do mất năng lực | Bất tỉnh, bị đánh văng; áp hậu quả theo trạng thái thực |

Một tình huống khẩn cấp có thể khiến bỏ qua bước dừng an toàn nhưng phải trả hậu quả. Không khóa nhân vật trong luyện đan cho tới chết chỉ vì thao tác ghi “không thể ngắt”.

Vật liệu đã đốt không hoàn lại; bán thành phẩm có thể giữ, hỏng hoặc xuống chất lượng. Hủy mục tiêu không xóa hậu quả đã xảy ra.

## 9. Chọn việc tiếp theo

Đề xuất thứ tự đánh giá: mất năng lực/khẩn cấp → cam kết có thời điểm quan trọng → nhu cầu cần xử lý → mục tiêu chủ động → việc dự phòng. Đây không phải thứ tự tuyệt đối: mức nguy cấp và chính sách người chơi quyết định một cuộc hẹn có nhường cho bữa ăn hay không.

Trong các phương án hợp lệ, cân nhắc mức khẩn, ưu tiên mục tiêu, ích lợi dự kiến, thời gian, chi phí, rủi ro và công chuyển việc. Chưa chốt trọng số số học trước khi có tình huống kiểm chứng.

Giữ một mức cam kết với việc đang làm để tránh đổi qua đổi lại chỉ vì chênh lệch nhỏ. Đánh giá lại khi có thay đổi liên quan, tới mốc định kỳ hoặc hoàn thành bước; không lập lại toàn bộ kế hoạch mỗi mili giây.

Ví dụ: đang ăn và chỉ đói nhẹ hơn trước không phải lý do lập tức bỏ bữa để quay lại luyện công, rồi lại đói và quay về ăn.

## 10. Lịch sinh hoạt và nghĩa vụ

Lịch có khung giờ, tần suất, thời lượng mong muốn và độ linh hoạt. “Học vào buổi chiều” khác “có mặt lúc 14:00 dự khảo hạch”.

Tính cả thời gian di chuyển và chuẩn bị. Nếu bị thương khiến đến trễ, nhân vật có thể báo tin, đổi lịch hoặc chấp nhận hậu quả nếu có quyền và phương tiện. Không tự dịch chuyển tới cuộc hẹn.

Nhu cầu ăn/ngủ được điều chỉnh theo trạng thái sinh lý thật. Tu sĩ đạt năng lực không cần ăn như người thường thì hệ lịch không tiếp tục ép ba bữa chỉ vì mẫu mặc định.

## 11. Kế hoạch bị kẹt

Các lý do chuẩn: thiếu kiến thức, thiếu tiền, thiếu vật tư, không có quyền, không đủ năng lực cơ thể, đường bị chặn, đối tác vắng mặt, chờ sự kiện, giới hạn mâu thuẫn, hết hạn.

Mỗi lý do phải chỉ rõ điều gì có thể giải quyết và điều gì nhân vật biết. Chờ đối tác thì nghe sự kiện đối tác trở lại hoặc kiểm tra có khoảng cách; không lặp thất bại hàng nghìn lần.

Có phương án dự phòng như nghỉ, chăm sóc bản thân, làm việc an toàn đã được giao. Nếu không có thì chờ và báo. Không tự nhận việc nguy hiểm, tiêu hết tiền hoặc trộm cắp chỉ để luôn “bận”.

## 12. NPC và quyền tự chủ

NPC sử dụng cùng hành động và quy tắc thời gian; khác ở nơi sinh mục tiêu: nhu cầu, gia đình, nghề nghiệp, tính cách, ký ức và tổ chức. Động cơ NPC sẽ có đặc tả riêng.

Đã có bản đề xuất [[NPC|Đời sống và quyết định NPC]]: mục tiêu phải có nguồn, lựa chọn chỉ dùng hiểu biết của chủ thể và cam kết chỉ hình thành khi các bên chấp nhận.

Người chơi không đặt lịch cho NPC độc lập bằng cách thêm họ vào kế hoạch. Thuê người hoặc nhờ giúp cần sự đồng ý và điều kiện; họ vẫn có thể không đủ khả năng, thất hẹn hoặc thay đổi ý định với nguyên nhân được mô phỏng.

Đề xuất nhân vật người chơi tuân thủ mục tiêu đã giao trong khả năng và hiểu biết. Việc tính cách/tâm lý có được quyền từ chối mệnh lệnh hay không cần chốt sau; chưa mặc định nhân vật sẽ chống lệnh vì “chân thật”.

## 13. Giao diện giao việc

Bản đầu đề xuất biểu mẫu rõ ràng: chọn mục tiêu, đối tượng, ưu tiên, ngân sách, giới hạn, cách xử lý khi kẹt. Nhập ngôn ngữ tự nhiên có thể thêm sau; nếu có phải chuyển thành bản diễn giải cho người chơi nhìn thấy, không âm thầm suy ra quyền tiêu tiền hoặc chấp nhận rủi ro.

Ví dụ thẻ công việc:

> **Mục tiêu:** dự trữ đủ thức ăn cho 7 ngày.  
> **Đang làm:** đi tới quầy gạo đã biết.  
> **Lý do:** còn khoảng 2 ngày thức ăn; quầy đang trong giờ mở cửa theo thông tin lần trước.  
> **Giới hạn:** tối đa 20 đồng, giữ lại 10 đồng dự phòng.  
> **Bất định:** giá hiện tại chưa xác nhận.  
> **Nếu không mua được:** quay về, tiếp tục việc đã giao và báo trở ngại.

Mỗi hành động cho xem nguyên nhân lựa chọn, dự kiến hoàn tất, chi phí đã dùng và lý do phương án khác bị loại. Thông tin giao diện không vượt kiến thức nhân vật; thông tin toàn tri chỉ thuộc công cụ kiểm tra dành cho phát triển.

## 14. Tình huống kiểm chứng

| Tình huống | Kết quả mong muốn |
| --- | --- |
| Thiếu tiền và cấm vay/bán gia bảo | Báo không đủ tiền, không vi phạm giới hạn |
| Quầy gạo đã hết hàng | Không cộng gạo; tìm phương án đã biết hoặc báo kẹt |
| Hai người lấy một công cụ chung | Một người có quyền dùng trước, người kia chờ hoặc đổi cách |
| Bị thương giữa đường | Tính lại khả năng và đoạn đường còn lại |
| Bất tỉnh khi luyện công | Buộc ngắt, xử lý hậu quả, không tiếp tục cộng tiến độ chủ động |
| Hủy chế tác giữa chừng | Không hoàn lại vật tư đã tiêu; xử lý bán thành phẩm |
| Lưu tải trước lúc hoàn tất | Chỉ tạo kết quả một lần |
| Mục tiêu cần kiến thức chưa có | Tìm hiểu bằng hành động hợp lệ, không dùng dữ liệu toàn tri |
| Lệnh mới khi đang dừng lò | Ghi nhận lệnh, xử lý chuyển việc theo quy tắc ngắt |
| Chờ NPC nhiều ngày | Không gây vòng lặp; có thời hạn hoặc mốc đánh giá lại |

## 15. Phạm vi kiểm chứng và phần mở rộng

Đề xuất trước hết đặc tả đủ các hành động đi lại, ăn, ngủ, mua hàng, làm công, đọc, luyện công cơ bản và băng bó để kiểm chứng chuỗi liên kết. Đây là danh sách kiểm chứng, không phải toàn bộ nội dung cuối cùng.

Chưa chốt công thức năng suất, tâm lý chống lệnh, phân công nhóm, thuê đệ tử dài hạn và thương lượng hợp đồng. Các phần này sẽ mở rộng trên cùng hồ sơ mục tiêu và hành động.
