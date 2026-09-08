---
aliases: [Vật phẩm vật liệu và chế tác]
tags: [thiet-ke, vat-pham, che-tac]
status: de-xuat
updated: 2026-09-05
---

# Vật phẩm, vật liệu và chế tác — đặc tả 0.1

Liên quan: [[MASTER_PLAN|Kế hoạch]] · [[HANH_DONG|Hành động]] · [[CO_THE|Cơ thể]] · [[NPC|NPC]] · [[THOI_GIAN|Thời gian]] · [[DECISIONS|Quyết định]].

> Yêu cầu đã có: rất nhiều vật phẩm, công dụng và chất lượng khác nhau. Cơ chế dưới đây là đề xuất, chưa được chốt hoặc triển khai. Các ví dụ là dữ liệu thiết kế hư cấu, không phải hướng dẫn chế tác thực tế.

## 1. Mục tiêu trải nghiệm

Một con dao có thể cắt thức ăn, thu hoạch, gia công hoặc dùng khi tự vệ. Công dụng tùy cấu tạo, vật liệu, tình trạng và người sử dụng. Dùng sai việc có thể chậm, làm hỏng đồ hoặc gây thương tích; không phải mọi vật có cạnh đều làm mọi việc tốt như nhau.

Một thanh kiếm gia truyền giữ lịch sử qua sửa chữa và đổi chủ. Một túi thuốc bị ẩm thay đổi tình trạng thật. Một thỏi quặng có tạp chất ảnh hưởng những sản phẩm làm từ nó. Đồ vật không chỉ là tên và điểm sức mạnh.

## 2. Tách loại, thiết kế và vật thể

| Lớp | Vai trò |
| --- | --- |
| Loại | Phân loại để tìm kiếm, ví dụ dao, bình, áo |
| Thiết kế | Cấu trúc, kích thước, bộ phận, yêu cầu và quy trình chế tạo |
| Vật liệu | Thành phần và đặc tính liên quan tới sử dụng/gia công |
| Vật thể | Một món cụ thể có mã, vị trí, cấu tạo, tình trạng và lịch sử |
| Lô | Lượng vật đồng nhất đủ để quản lý chung theo quy tắc |
| Kiến thức | Những gì từng nhân vật biết hoặc tin về các lớp trên |

Tên hiển thị được tạo từ đặc điểm và hiểu biết, không dùng làm danh tính. Hai món cùng tên không nhất thiết cùng chất lượng. Đổi tên kiếm không tạo kiếm mới.

## 3. Hồ sơ vật thể

Các trường đề xuất: mã bền vững; phiên bản mẫu/thiết kế; bộ phận; vật liệu; lượng/khối lượng/thể tích thích hợp; vị trí; chủ sở hữu và quyền liên quan; tình trạng; hiệu ứng đang hoạt động; nguồn gốc; sự kiện lịch sử quan trọng.

Một món chỉ có một vị trí chứa trực tiếp tại một thời điểm: trong túi, trên giá, gắn trên cơ thể, thuộc bộ phận máy hoặc nằm ở địa điểm. Đang vận chuyển là ở trong người/xe đang di chuyển, không đồng thời còn ở kho nguồn.

Sổ vật phẩm chịu trách nhiệm trạng thái vật thể. Trang kho, túi, cửa hàng và trang bị là các cách xem cùng dữ liệu, không là các bản sao độc lập.

## 4. Cấu tạo nhiều bộ phận

Ví dụ kiếm có lưỡi, chuôi, bộ phận nối và bao; bình có thân và nắp. Mỗi bộ phận có thể có vật liệu, tình trạng và khả năng thay thế riêng.

Thay chuôi không tự sửa lưỡi. Bao có thể tháo rời và có danh tính riêng khi cần. Khối lượng toàn món bằng tổng phần cấu thành và phần chứa, không cộng thêm một lần khối lượng tổng đã tính sẵn.

Quan hệ cấu thành phải không có vòng lặp. Không cho một hộp chứa chính nó hoặc chứa hộp tổ tiên. Bộ phận tách ra chuyển khỏi món gốc đúng một lần; món gốc mất chức năng tương ứng.

Mức tách bộ phận theo tác dụng gameplay. Một nhóm đinh giống nhau có thể quản lý chung; viên ngọc có lời nguyền và lịch sử riêng cần theo dõi riêng.

## 5. Vật liệu và đặc tính

Đề xuất các nhóm thuộc tính: khối lượng riêng, chịu lực, độ cứng/giòn, đàn hồi, hấp thụ hoặc dẫn nhiệt, thấm/hút ẩm, khả năng phân hủy, cháy, phản ứng, và đặc tính linh lực hư cấu.

Không yêu cầu mọi vật liệu có mọi thuộc tính chi tiết ngay. Một thuộc tính được thêm khi có hệ sử dụng nó; ghi rõ đơn vị, miền giá trị, quy tắc tương tác và mức xấp xỉ.

Hỗn hợp có thành phần và cách phân bố khi quan trọng. Thuộc tính hỗn hợp không mặc định là trung bình cộng: có loại cần quy tắc pha trộn riêng. Vật liệu nhiều lớp giữ cấu trúc lớp thay vì biến thành một chất đồng nhất.

Linh tính có thể gồm khả năng chứa/dẫn năng lượng, tương thích và phản ứng với loại linh lực. Tên gọi như hỏa tính phải gắn cơ chế cụ thể; chưa chốt hệ thuộc tính tu tiên tại đây.

## 6. Chất lượng là nhiều chiều

| Chiều | Ví dụ ảnh hưởng |
| --- | --- |
| Đúng thiết kế | Độ khớp, kích thước, cân bằng |
| Vật liệu | Thành phần, tạp chất, khuyết tật |
| Gia công | Độ hoàn thiện, mối nối, lỗi quy trình |
| Tình trạng | Mòn, rỉ, nứt, bẩn, ẩm |
| Chức năng | Sắc, kín, chịu tải, dẫn linh lực |
| Giá trị xã hội | Nguồn gốc, danh tiếng người làm, ý nghĩa cá nhân |

Tách chất lượng chế tạo ban đầu khỏi tình trạng hiện tại. Kiếm chế tạo tốt vẫn có thể cùn; mài giúp cạnh nhưng không biến vật liệu xấu thành vật liệu tốt. Di vật quý với gia đình không nhất thiết mạnh hơn trong chiến đấu.

Nếu dùng phẩm cấp hoặc màu để tóm tắt, phải cho biết tiêu chí/ngữ cảnh. Không có một thứ hạng toàn cục bảo đảm món cao cấp hơn tốt hơn cho mọi việc.

## 7. Công dụng xuất phát từ khả năng

Hành động yêu cầu khả năng như cắt vật liệu mềm, giữ chất lỏng, truyền lực, che mưa, cung cấp nhiệt hoặc dẫn linh lực. Vật phẩm cung cấp khả năng với giới hạn và chi phí sử dụng.

Đề xuất kiểm tra: có đặc tính cần thiết → kích thước và mức hiệu suất phù hợp → tình trạng còn đáp ứng → nhân vật có thể dùng → có quyền tiếp cận → nhân vật biết cách thực hiện.

Một viên đá có thể giữ giấy hoặc làm vật nặng; không cần viết riêng mọi cặp vật–hành động. Tuy nhiên không tự cho một khả năng chưa được mô hình hóa chỉ vì lời mô tả nghe hợp lý.

Thay dụng cụ trong kế hoạch phải so cả thời gian, nguy cơ hỏng và chất lượng đầu ra. Tự động thay nguyên liệu quý hoặc vật kỷ niệm phải tuân thủ giới hạn người chơi đã giao.

## 8. Số lượng, lô, tách và gộp

Vật rời dùng số đếm nguyên; nguyên liệu chia được dùng khối lượng/thể tích với độ chính xác đã khai báo. Không dùng cùng một trường “số lượng” cho cả viên thuốc, nước và quặng mà thiếu đơn vị.

Chỉ gộp lô khi các khác biệt quan trọng được giữ: loại, thành phần, tình trạng, nguồn gốc cần truy vết, quyền sở hữu và ràng buộc. Lô khác tuổi hoặc chất lượng có thể cùng trong một bao nhưng vẫn là các lô con.

Tách lô giữ tổng lượng và nguồn gốc. Ví dụ 10 đơn vị chia 3 và 7 không tạo hao hụt làm tròn. Nếu cần làm tròn, giữ phần dư có chủ thể chịu trách nhiệm thay vì tự làm mất lượng.

Trộn thật là một hành động biến đổi, không là thao tác sắp xếp kho miễn phí. Thành phần bẩn không biến mất khi trộn vào lô sạch. Đặc tính có thể trở thành phân bố hoặc hỗn hợp theo quy tắc; không lấy trung bình rồi xóa khuyết tật nguy hiểm.

Một món có lịch sử riêng được tách khỏi lô khi cần. Tóm lược lô không được xóa tài sản đang được thế chấp hoặc bằng chứng liên quan một nhiệm vụ.

## 9. Vị trí, vật chứa và mang vác

Vật chứa có giới hạn thể tích, tải, kích thước miệng, loại chất chứa được và tình trạng kín/hở phù hợp. Đủ thể tích chưa chắc vừa một thanh dài; bình nứt không giữ nước như bình nguyên.

Cơ thể chịu tổng tải thực và cách phân bố trang bị. Túi ở xa không phải túi đồ có thể dùng tức thì; lấy món dưới đáy có thể cần thao tác mở và tìm. Bản đầu có thể tổng hợp thời gian tìm nhưng phải có quy tắc nhất quán.

Rơi vỡ vật chứa giải phóng hoặc làm hỏng phần chứa theo cơ chế; không xóa tất cả vô điều kiện. Vật chứa lồng nhau không được tính lặp khối lượng phần bên trong.

Túi trữ vật tương lai là cơ chế hư cấu có dung lượng, truy cập, chi phí và điều kiện riêng. Chưa mặc định cho phép cất sinh vật, ngừng thời gian hoặc mang tải vô hạn.

## 10. Sở hữu, giữ hộ và đặt chỗ

Bổ sung phân công theo [[LIEN_KET_HE_THONG]]: vật phẩm giữ danh tính/vị trí chứa và tham chiếu quyền; sổ kinh tế/tổ chức giữ quyền được công nhận. Việc thực thi dựa trên bằng chứng/kênh kiểm soát thật, không mặc định người giữ kho biết mọi thay đổi quyền từ xa.

Tách người sở hữu, người đang giữ, người được phép dùng và quyền hạn chế như thế chấp. Cầm đồ của người khác không tự thành chủ sở hữu. Bỏ trên đất cũng không tự xóa quyền sở hữu.

Đặt chỗ cho công việc có lượng, người giữ quyền, mục đích và hạn. Không khóa tài nguyên của người khác chỉ vì một kế hoạch đang muốn mua. Chấp nhận giao dịch/giữ hộ cần hành động hoặc thỏa thuận hợp lệ.

Khi chủ thể mất quyền, đồ bị phá hủy hoặc lô bị giảm, cập nhật đặt chỗ và báo các việc phụ thuộc. Tranh chấp quyền sở hữu được lưu như tuyên bố có nguồn, không âm thầm biến thành hai món đồ.

Giao dịch hoàn tất phải đổi tiền/quyền sở hữu/vị trí theo hình thức đã thỏa thuận trong một thay đổi nhất quán. Mua để giao sau tạo nghĩa vụ giao hàng; không làm món đồ xuất hiện ngay trong túi.

## 11. Bảo toàn và biến đổi

Mỗi biến đổi ghi đầu vào, đầu ra, phụ phẩm, phần thải ra môi trường và nguồn năng lượng ở mức mô phỏng đã chọn. Không bắt buộc tính hóa học phân tử nhưng phải giải thích nơi lượng vật chất được chuyển tới.

Đầu ra không luôn chỉ là món thành công: còn phế liệu, nước mất vào môi trường hoặc phần hỏng. Không dùng “hao hụt” làm cớ để sinh thêm lượng ở bước sau. Nguồn tài nguyên khởi tạo hoặc phép tạo vật có hồ sơ nguồn riêng.

Một nguyên liệu không vừa bị tiêu hao trong chế tác vừa còn khả dụng trong kho. Thức ăn chuyển sang cơ thể theo CO_THE; hiệu ứng thuốc và phần vật chất được quản lý khác nhau để không cộng công dụng hai lần.

Không tạo vòng sửa–tháo–chế lại sinh lợi vô hạn về vật chất hoặc năng lượng nếu không có nguồn bên ngoài được khai báo. Giá trị kinh tế có thể tăng do lao động/tri thức; khối lượng không tự tăng theo giá.

## 12. Hao mòn, bảo quản và biến chất

Quá trình thay đổi có nguồn: ma sát khi dùng, tải, nhiệt, độ ẩm, thời gian, tác nhân và linh lực. Mòn theo sử dụng khác hỏng theo lưu kho.

Vật chứa và môi trường ảnh hưởng tốc độ thay đổi; chuyển từ kho ẩm sang kho khô tính đoạn cũ trước rồi đổi tốc độ theo THOI_GIAN. Không áp điều kiện mới cho toàn bộ tuổi món đồ.

Vật phẩm có thể giảm khả năng trước khi hỏng hoàn toàn. Mũi dụng cụ cùn làm việc chậm, vết nứt làm tăng nguy cơ hỏng khi chịu tải; không chỉ chờ độ bền về 0 rồi biến mất.

Ngưỡng và mô hình phân hủy là dữ liệu cần chốt. Tải game hoặc gộp lô không đặt lại tuổi, độ tươi hoặc lịch biến chất.

## 13. Kiến thức, giám định và đồ giả

Đặc tính thật khác nhãn và lời người bán. Nhân vật chỉ biết những gì quan sát, đo, thử hoặc học được. Mua vật phẩm ghi “tinh khiết” không tự nhận được thông số thật.

Giám định là hành động cần kỹ năng, công cụ và thời gian, có thể chỉ làm rõ một số thuộc tính. Thử có thể tiêu hao mẫu hoặc gây biến đổi được khai báo. Kết quả có nguồn, thời điểm và độ tin cậy theo NPC.

Đồ giả có cấu trúc thật và biểu hiện đánh lừa; không chỉ một cờ bí mật rồi áp phạt sau khi mua. Bằng chứng về người làm/nguồn gốc có thể thật hoặc giả theo hệ thông tin. Giá không được tự tiết lộ toàn bộ chất lượng ẩn qua một công thức người chơi dễ đọc ngược.

## 14. Kiến thức chế tác và thiết kế

Biết tên món đồ không đồng nghĩa biết làm. Thiết kế gồm điều kiện đầu vào, bước xử lý, cấu tạo đầu ra, công cụ, môi trường và tiêu chí kiểm tra.

Kiến thức nhân vật có thể thiếu một bước, sai thông số hoặc chưa đủ tay nghề. Công thức được học qua thầy, văn bản, quan sát hoặc thử nghiệm có kết quả thật. Đọc sách không tự cấp toàn bộ kỹ năng thao tác.

Một bản công thức là vật mang thông tin; bản sao có thể thiếu nội dung, còn kiến thức đã học nằm ở nhân vật. Mất cuốn sách không tự xóa điều đã nhớ; chưa nhớ đủ thì vẫn cần tra cứu.

## 15. Quy trình chế tác nhiều bước

| Thành phần bước | Nội dung |
| --- | --- |
| Điều kiện bắt đầu | Nguyên liệu, nơi, công cụ, hiểu biết, năng lực |
| Nhu cầu khi chạy | Nhiên liệu, chú ý, thao tác, môi trường |
| Tiến độ | Khối lượng việc hoặc quá trình theo thời gian |
| Mốc biến đổi | Khi nào vật tư trở thành bán thành phẩm/phụ phẩm |
| Giới hạn | Khoảng điều kiện chấp nhận và hậu quả lệch |
| Ngắt/tiếp tục | Phần giữ được, cần xử lý, có thể hỏng |
| Kết quả | Trạng thái vật thể và thông tin quan sát được |

Đầu vào chỉ bị tiêu khi đến bước sử dụng, không trừ tất cả ngay khi thêm vào hàng đợi. Bán thành phẩm có danh tính và vị trí thật khi cần, có thể được chuyển cho người khác làm tiếp nếu họ biết quy trình.

Hệ hành động quản lý người làm; quá trình trong lò/bình có thể tiếp tục khi người rời đi. Thiếu người theo dõi chỉ gây hậu quả khi bước đó yêu cầu theo dõi; không khóa nhân vật ở toàn bộ quy trình một cách vô lý.

## 16. Chất lượng đầu ra và thất bại

Đầu ra phụ thuộc vật liệu thực, dụng cụ, năng lực người làm, điều kiện và lịch sử các bước. Không bốc một phẩm cấp độc lập ở cuối rồi bỏ qua mọi thứ trước đó.

Ngẫu nhiên nếu có đại diện sai số/quá trình chưa tính chi tiết, được lưu và không bốc lại khi mở giao diện. Kỹ năng tác động vào sai số hoặc khả năng kiểm soát đã khai báo, không đồng thời cộng nhiều thưởng trùng cho cùng nguyên nhân.

Thất bại có dạng riêng: sai kích thước, hiệu suất thấp, khuyết tật ẩn, hỏng một phần hoặc mất toàn bộ. Có thể phát hiện và sửa ở mốc kiểm tra; kiểm tra cũng tốn nguồn lực. Một nguyên liệu vượt yêu cầu không tự bù mọi lỗi thao tác.

## 17. Thay thế, thử nghiệm và cải tiến

Thay nguyên liệu cần đáp ứng vai trò và tương tác của bước, không chỉ cùng thẻ “kim loại” hay “thảo dược”. Phương án chưa biết được ghi là thử nghiệm; nhân vật không được chắc chắn trước kết quả ẩn.

Thử nghiệm tạo dữ liệu quan sát, tốn vật tư/thời gian và có rủi ro trong giới hạn cho phép. Kết quả một lần không tự trở thành chân lý cho mọi biến thể. Cải tiến tạo phiên bản thiết kế mới với nguồn học và phạm vi đã thử.

Sinh nhiều mẫu nội dung từ các thành phần tương thích chỉ là công cụ tạo dữ liệu. Mỗi mẫu phải vượt kiểm tra công dụng, nguồn nguyên liệu, quy trình, đánh đổi và tránh trùng cơ chế chỉ khác tên.

## 18. Sửa chữa, tháo dỡ và lịch sử

Sửa chữa nhắm vào vấn đề: làm sạch, chỉnh, thay bộ phận, phục hồi một khả năng. Mỗi thao tác có giới hạn; không đặt lại mọi thuộc tính về mới.

Tháo dỡ chuyển cấu trúc thành các phần thu hồi/phế liệu theo tình trạng và kỹ năng. Không vừa giữ bộ phận trong món gốc vừa xuất ra kho. Hiệu ứng phụ thuộc món đã bị tháo phải ngừng.

Lịch sử giữ người tạo nếu biết trong thế giới, nơi/quy trình nguồn, đổi chủ quan trọng, sửa lớn và sự kiện đặc biệt. Lịch sử thật không đồng nghĩa mọi nhân vật biết nó. Nếu vật bị chia hoặc nấu lại, giữ quan hệ nguồn phù hợp, không gọi mọi sản phẩm mới là cùng một kiếm nguyên vẹn.

## 19. Tài nguyên tu tiên và hiệu ứng

Pháp khí cần bộ phận/cơ chế tạo hiệu ứng, nguồn linh lực, điều kiện kích hoạt, hao tổn và giới hạn. Cầm vào không tự được mọi lợi ích nếu cần nhận chủ, kỹ năng hoặc tương thích.

Đan dược có thành phần thật, độ ổn định, tình trạng và hiệu ứng được khai báo. Tiêu thụ chuyển quyền quản lý tác động sang cơ thể; hiệu ứng không tiếp tục gắn với viên thuốc đã không còn tồn tại.

Linh thạch là tài nguyên có lượng năng lượng và cấu trúc theo quy luật sẽ chốt. Dùng năng lượng phải cập nhật nguồn; không giữ nguyên lượng trong túi rồi cộng đầy linh lực cho nhân vật mỗi lần thao tác.

Khái niệm nhận chủ, phẩm cấp pháp khí, trữ vật, luyện đan và truyền năng lượng sẽ được phát triển trong đặc tả tu luyện. Không tự chốt năng lực siêu nhiên bằng tên vật phẩm.

## 20. Quy mô hàng nghìn loại và hiệu năng

Tách thư viện loại/thiết kế khỏi số vật thể thực sự tồn tại. Có hàng nghìn loại trong dữ liệu không có nghĩa sinh hàng nghìn món ở mọi kho khi tạo thế giới.

Dùng mẫu dùng chung, lô phù hợp và cập nhật theo sự kiện. Vật ổn định trong kho không cần tính mỗi mili giây. Quá trình đang cháy, rò rỉ hoặc liên quan cam kết vẫn phải xử lý đúng mốc dù ở xa.

Lịch sử chỉ giữ sự kiện quan trọng và nguồn còn được tham chiếu. Bản lưu giữ phiên bản mẫu, vị trí, thành phần, tình trạng, quy trình dang dở, quyền và đặt chỗ; thay dữ liệu nội dung cần chuyển đổi có kiểm soát.

Trước tăng số lượng nội dung, mỗi nhóm cần ít nhất một chuỗi nguồn → công dụng → hao mòn/tiêu thụ → xử lý phần còn lại. Không cần mọi thứ hữu ích trong mọi hoàn cảnh, nhưng không nên tạo hàng loạt vật chỉ để làm đầy danh sách.

## 21. Chuỗi mẫu để kiểm chứng

Ví dụ hư cấu: vải nguyên liệu → cắt thành băng → đặt vào túi → dùng chăm sóc thương tích → băng bẩn sau sử dụng → thu hồi hoặc thải bỏ theo điều kiện.

- Cắt chuyển đúng lượng vải và tạo phần dư, không sinh miễn phí băng.
- Dao cùn thay tốc độ/chất lượng cắt qua khả năng dụng cụ.
- Băng trong kho không thể dùng từ xa; phải lấy và mang tới.
- Khi gắn lên cơ thể, vị trí đổi và hiệu ứng có nguồn vật phẩm.
- Khi băng bẩn hoặc bị tháo, cơ thể nhận cập nhật hiệu ứng tương ứng.
- Xử lý băng đã dùng là hành động có chi phí; không tự biến lại thành vải mới.

Chuỗi thứ hai để kiểm chứng cấu tạo: món dụng cụ có lưỡi và cán → cán hỏng → thay cán → dùng tiếp → tháo thu hồi. Danh tính món và lịch sử sửa được giữ; thuộc tính lưỡi không được đặt lại.

## 22. Giao diện

Mặc định hiển thị công dụng đã biết, tình trạng dễ thấy, vị trí/quyền truy cập và trở ngại đối với công việc. Cho mở sâu cấu tạo, nguồn thông tin, lịch sử đã biết và tiến trình chế tác.

Ví dụ:

> **Dao hái thuốc, đang mang bên hông**  
> Cạnh đã cùn; cán vẫn chắc theo lần kiểm tra gần nhất.  
> Dùng được để thu hoạch nhưng dự kiến chậm hơn.  
> Chưa biết tình trạng bên trong mối nối.  
> Thuộc sở hữu của bạn; không nằm trong vật tư được phép bán.

Bảng chế tác hiển thị bước hiện tại, vật tư đã dùng, phần còn cần, dự kiến và lý do kẹt. Không hiển thị kết quả phẩm chất ẩn chính xác trước khi có cách xác định.

## 23. Tiêu chí kiểm chứng khi triển khai

| ID | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| VP01 | Chuyển đồ kho sang túi | Chỉ một vị trí, tổng lượng giữ nguyên |
| VP02 | Tách rồi gộp lô | Không sinh lượng, không đặt lại tuổi hoặc xóa khuyết tật |
| VP03 | Hai việc cần món cuối | Không cùng tiêu hao một món; việc mất điều kiện được báo |
| VP04 | Trộn lô bẩn và sạch | Giữ tác động thành phần, không làm sạch miễn phí |
| VP05 | Túi lồng túi | Không vòng lặp, không tính trùng khối lượng |
| VP06 | Thay cán dụng cụ | Giữ trạng thái lưỡi và lịch sử món |
| VP07 | Hủy chế tác giữa chừng | Giữ bán thành phẩm/phụ phẩm; không hoàn vật tư đã dùng |
| VP08 | Lưu tải lúc hoàn tất | Chỉ xuất kết quả một lần |
| VP09 | Đồ người khác đang giữ hộ | Giữ quyền sở hữu thật, không tự cho phép bán |
| VP10 | Mua giao sau | Tạo cam kết, chưa đưa đồ vào túi ngay |
| VP11 | Bình vỡ | Phần chứa được xử lý theo cơ chế, không nhân đôi/xóa tùy ý |
| VP12 | Chuyển môi trường bảo quản | Đổi tốc độ từ đúng mốc, không hồi tố |
| VP13 | Đồ giả bị giám định | Kiến thức đổi; đặc tính thật không được sinh lại |
| VP14 | Thuốc được tiêu thụ | Hiệu ứng vào cơ thể một lần, viên thuốc không còn dùng được |
| VP15 | Sửa rồi tháo nhiều vòng | Không sinh vật chất/năng lượng khi thiếu nguồn |
| VP16 | Hỏng công cụ giữa bước | Tính lại tiến độ và điều kiện từ mốc hỏng |
| VP17 | Đổi số lần mở giao diện | Không đổi kết quả chế tác hoặc biến chất |
| VP18 | Linh thạch bị dùng hết nguồn | Không tiếp tục cấp năng lượng ngoài cơ chế khai báo |

Chưa chạy kiểm chứng vì chưa có mã game. Trước triển khai cần đơn vị, sai số lượng cho phép, quy tắc từng quá trình và dữ liệu mẫu có thể kiểm tra bảo toàn.

## 24. Phạm vi tiếp theo và câu hỏi mở

Đề xuất kiểm chứng vài chuỗi liên kết trước: băng vải/chăm sóc, thức ăn/lưu kho, dụng cụ/sửa chữa, một vật liệu tu tiên. Danh mục hàng nghìn loại là mục tiêu dài hạn, chưa được tạo ở bước này.

Còn mở: danh mục vật liệu/đơn vị, mức mô phỏng phản ứng, chi tiết vật chứa, phẩm cấp hiển thị, số công đoạn bản đầu, quy tắc trữ vật và mức tự động thay nguyên liệu.

Bước kế hoạch tiếp theo: tu luyện, công pháp và đột phá. Cần nối đường vận công với cơ thể, nguồn năng lượng với vật phẩm/môi trường, quá trình luyện với hành động/thời gian và truyền thừa với kiến thức/NPC.
