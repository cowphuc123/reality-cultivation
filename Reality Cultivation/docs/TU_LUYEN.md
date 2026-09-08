---
aliases: [Tu luyện công pháp và đột phá]
tags: [thiet-ke, tu-luyen, cong-phap]
status: de-xuat
updated: 2026-09-05
---

# Tu luyện, công pháp và đột phá — đặc tả 0.1

Liên quan: [[MASTER_PLAN|Kế hoạch]] · [[CO_THE|Cơ thể]] · [[VAT_PHAM|Vật phẩm]] · [[HANH_DONG|Hành động]] · [[NPC|NPC]] · [[THOI_GIAN|Thời gian]] · [[DECISIONS|Quyết định]].

> Đây là thiết kế hư cấu đề xuất. Người dùng yêu cầu tu tiên sâu và vô số công pháp khác nhau; chưa chốt quy luật năng lượng, hệ cảnh giới, tên gọi hoặc các thông số dưới đây. Tài liệu không phải hướng dẫn luyện tập ngoài đời.

## 1. Trải nghiệm cần tạo ra

Tu luyện là thay đổi cơ thể, năng lực và hiểu biết qua thời gian, có đánh đổi về sinh kế, tài nguyên, quan hệ và rủi ro. Người chơi giao mục tiêu dài hạn, nhân vật thực hiện những bước đã biết và điều chỉnh theo tình trạng thật.

Một người có nhiều linh lực chưa chắc điều khiển tốt; người hiểu công pháp sâu vẫn có thể thiếu tài nguyên; người có cảnh giới cao bị thương vẫn bị giới hạn ở chức năng liên quan. Không có một chỉ số tu vi duy nhất thay tất cả.

Mục tiêu là nhiều con đường có lý do tồn tại. Đường an toàn, chậm và ít tài nguyên có thể hợp với người phải nuôi gia đình; đường hiệu suất cao đòi linh địa hoặc hỗ trợ thường xuyên có thể hợp với người được môn phái bảo trợ.

## 2. Thuật ngữ làm việc

| Khái niệm | Nghĩa đề xuất |
| --- | --- |
| Linh khí | Năng lượng trong môi trường hoặc nguồn bên ngoài, có lượng và tính chất |
| Linh lực | Năng lượng đã được chủ thể tiếp nhận/chuyển hóa và có thể vận dụng |
| Dung lượng | Giới hạn chứa trong cấu trúc hiện có, không phải lượng đang còn |
| Lưu lượng | Lượng có thể truyền qua tuyến trong một khoảng thời gian |
| Độ tinh khiết | Mức thành phần đáp ứng chuẩn của phương pháp đang dùng |
| Khả năng điều khiển | Độ chính xác và tải thao tác có thể duy trì |
| Nền tảng | Hồ sơ cấu trúc, thích nghi, khuyết tật và kinh nghiệm có liên quan |
| Tu vi | Cách tóm tắt tiến triển theo truyền thống, không là nguồn dữ liệu duy nhất |
| Cảnh giới | Mốc năng lực/cấu trúc đã đạt và giữ được theo một hệ phân loại |

Không dùng “tinh khiết” như một điểm tốt tuyệt đối cho mọi công pháp. Một thành phần phù hợp phương pháp này có thể không phù hợp phương pháp khác.

## 3. Nguồn năng lượng và sổ chuyển hóa

Mỗi lần hấp thu có nguồn cụ thể: vùng môi trường, linh thạch, vật phẩm hoặc chủ thể khác qua cơ chế hợp lệ. Nguồn mất lượng tương ứng; phần đi vào cơ thể, phần thất thoát và phần gây tác động môi trường được ghi theo mô hình.

Đề xuất quan hệ kiểm chứng trong đơn vị năng lượng game thống nhất: lượng rút từ nguồn = lượng chuyển thành phần dùng được + phần không dùng được + phần thất thoát đã khai báo. Nếu các dạng dùng đơn vị khác nhau, cần hệ số chuyển đổi rõ trước khi cộng; không dùng công thức này để giả mô phỏng vật lý thực.

Đầu vào bị giới hạn bởi nguồn sẵn có, tốc độ tiếp nhận, tuyến dẫn và khả năng xử lý. Không cộng tiến độ đầy đủ trước rồi mới kiểm tra nguồn đã cạn.

Nhiều người cùng luyện ở một nơi phải chia nguồn theo điều kiện thực; không mỗi người hút toàn bộ lượng có sẵn. Linh địa có cơ chế bổ sung/truyền từ nơi khác, chưa được định nghĩa là nguồn vô hạn. Chi tiết địa lý linh khí sẽ nối đặc tả môi trường.

## 4. Trạng thái người tu luyện

Phân công dữ liệu theo [[LIEN_KET_HE_THONG]], mục 2: cơ thể giữ cấu trúc/giới hạn, tu luyện giữ lượng linh lực cá thể, vật phẩm giữ lượng trong vật cấp nguồn, môi trường giữ nguồn ngoài. Chuyển lượng giữa chúng là một giao dịch nhất quán, không trừ nguồn ở nhiều nơi.

Các nhóm cần lưu: lượng và thành phần linh lực; cấu trúc chứa; mạng dẫn; mức điều khiển; thích nghi từng bộ phận; công pháp đã học và phiên bản; mức hiểu/thực hành; biến đổi lâu dài; tổn thương; hiệu ứng tạm; quá trình đang chạy.

Trạng thái này liên kết bộ phận trong CO_THE, không tạo một bộ kinh mạch trùng độc lập. Kho linh lực và tác động vật phẩm có một nơi chịu trách nhiệm cập nhật để tránh nạp/trừ hai lần.

Tách năng lực nền, trạng thái hiện tại và hiệu ứng hỗ trợ. Dược lực tạm tăng hiệu suất không tự thành tiến bộ vĩnh viễn. Đổi trang bị phải chấm dứt đúng các khả năng phụ thuộc nó.

## 5. Tư chất và giới hạn bẩm sinh

Đề xuất tư chất là tập khác biệt: độ nhạy cảm nhận, khả năng tiếp nhận, hình thái mạng dẫn, độ tương thích, tốc độ học/thích nghi và sức chịu tải. Không gom tất cả vào một điểm thiên tài.

Linh căn, thể chất đặc biệt hoặc huyết mạch nếu dùng phải ánh xạ vào các cơ chế đó. Chưa chốt số hệ, độ hiếm hoặc việc một người không có linh căn có bị loại khỏi mọi con đường hay không.

Khám tư chất tạo kết quả theo công cụ, kiến thức và sai số; không tự công khai toàn bộ tiềm năng cuộc đời. Khó học phương pháp A không có nghĩa kém ở mọi phương pháp.

Thay đổi tư chất phải có quá trình và hậu quả riêng. Không cho người chơi dùng một vật rẻ để xóa mọi khác biệt bẩm sinh nếu chưa có đánh đổi được thiết kế.

## 6. Kinh mạch, đan điền và tuyến vận hành

Công pháp sử dụng một mạng nút/đường dẫn từ cơ thể, với yêu cầu về lưu lượng, sức chịu tải, thứ tự và nhịp điều khiển. Một tuyến có thể bị hạn chế bởi điểm yếu nhất liên quan, không lấy trung bình toàn mạng để bỏ qua đoạn hỏng.

Mạng có trạng thái tắc, mất ổn định hoặc tổn hại theo cơ chế hư cấu được khai báo. Thuật gọi “khai mạch” phải mô tả thay đổi cấu trúc nào, cần gì và rủi ro gì; không chỉ cộng số mạch đã mở.

Đan điền được coi là cấu trúc chứa/chuyển hóa theo thiết kế loài và con đường. Số lượng, vị trí và khả năng thay thế còn mở. Tổn thương ảnh hưởng đúng chức năng được cung cấp, không mặc định trừ toàn bộ tuổi thọ hoặc giết nhân vật.

## 7. Hồ sơ công pháp

| Nhóm | Nội dung phải có |
| --- | --- |
| Danh tính | Mã, tên, nguồn gốc, phiên bản, nhánh truyền thừa |
| Mục đích | Tích lũy, tinh luyện, rèn cấu trúc, điều khiển hoặc ứng dụng |
| Nhập môn | Kiến thức, cơ thể, trạng thái năng lượng và công cụ cần thiết |
| Quy trình | Các pha, tuyến, điều kiện duy trì, điểm kiểm tra |
| Chuyển hóa | Loại nguồn, đầu ra, hiệu suất và phần thải/tổn hao |
| Tiến bộ | Cơ chế học/thích nghi; điều kiện không còn tiến triển |
| Rủi ro | Quá tải, sai lệch, xung đột, tổn hại tích lũy |
| Thu công | Cách dừng, thời gian, chi phí và hậu quả buộc ngắt |
| Phối hợp | Phương pháp/hiệu ứng tương thích và điều kiện |
| Giới hạn | Khả năng đạt được, điểm yếu, con đường chuyển tiếp |
| Nhận biết | Dấu hiệu mà người học có thể quan sát |

Mẫu kiến thức mà nhân vật sở hữu có thể thiếu/sai một phần so với quy trình thật. Hệ thực thi áp tác động của bước thực sự làm, không tự sửa công pháp sai cho nhân vật.

## 8. Phân loại theo cơ chế

Đề xuất phân biệt công pháp nền để xây cấu trúc/tích lũy, bài luyện điều khiển, phương pháp rèn thể, thuật ứng dụng và thủ đoạn hỗ trợ. Một bộ truyền thừa có thể gồm nhiều phần, nhưng sở hữu một phần không tự biết toàn bộ.

Thuật chiến đấu là hành động tiêu thụ năng lực đã có và có thể tạo kinh nghiệm liên quan; không mặc định mỗi lần tung đòn đều nâng dung lượng. Luyện chế và trận pháp sử dụng khả năng tu luyện nhưng còn cần kiến thức nghề riêng.

Tên gọi do văn hóa đặt có thể khác giữa môn phái. Phân loại nội bộ phải dựa trên cơ chế, tránh một nghìn tên nhưng thực tế cùng một phép cộng tu vi.

## 9. Một phiên luyện công

Các pha đề xuất: kiểm tra điều kiện → chuẩn bị nơi/vật tư → vào trạng thái vận hành → tiếp nhận/chuyển hóa → thích nghi hoặc thực hành → thu công → đánh giá kết quả.

Không bắt mọi phương pháp có cùng số pha hoặc cùng thời lượng. Mỗi pha chỉ tiêu nguồn lực khi thật sự dùng; vật tư giữ chỗ chưa tiêu vẫn tồn tại theo VAT_PHAM.

Tiến trình dùng THOI_GIAN. Khi nguồn thay đổi, cơ thể bị thương hoặc có người quấy nhiễu, tính tới mốc rồi cập nhật. Một chu kỳ bị ngắt giữ kết quả đã xảy ra và hậu quả tương ứng, không tự xóa sạch hoặc tự hoàn tất.

Lịch luyện phải nhường cho nhu cầu phù hợp cơ thể hiện tại. Công pháp không thay thế ngủ thì bế quan không miễn thiếu ngủ; đã có cơ chế thay thế thì tiêu đúng nguồn thay thế đó.

## 10. Học, hiểu và thực hành

Biết nội dung, hiểu nguyên lý, thao tác chính xác và cơ thể thích nghi là các tiến triển khác nhau. Đọc một bản công pháp có thể mở bước thực hành nhưng không lập tức tạo cấu trúc mới.

Tập lặp giúp những năng lực có liên quan khi mức thử thách và điều kiện còn tạo học hỏi. Một bài quá dễ có thể duy trì kỹ năng mà không tăng vô hạn. Sai quy trình có thể củng cố thói quen sai nếu chưa có phản hồi phù hợp.

Ngộ tính đề xuất ảnh hưởng khả năng rút ra quan hệ và học từ trải nghiệm, không là vé bốc ngẫu nhiên để nhảy cảnh giới mỗi ngày. “Đốn ngộ” nếu dùng cần trải nghiệm/kiến thức làm nền và tạo hiểu biết cụ thể; vẫn cần cơ thể và nguồn lực để thực hiện.

## 11. Tiến triển và bình cảnh

Theo dõi từng hướng: tích lũy lượng, chuyển thành phần, nâng điều khiển, thay đổi cấu trúc và học kiến thức. Không buộc chúng đầy cùng một thanh.

Bình cảnh có nguyên nhân: cấu trúc chưa chịu tải, hiểu sai bước, thiếu nguồn, điều khiển chưa đạt, tổn thương, công pháp tới giới hạn hoặc xung đột phương pháp. Nhân vật có thể chưa biết nguyên nhân thật.

Lặp cùng điều kiện không bảo đảm vượt qua sau số lần cố định. Có thể cần người chỉ dạy, vật liệu, đổi bài, phục hồi hoặc lựa chọn con đường khác. Chẩn đoán sai có thể tốn công nhưng không được tự thay nguyên nhân thật để khớp lời kể.

## 12. Nền tảng, hiệu quả và đánh đổi dài hạn

Nền tảng là hồ sơ điểm mạnh/yếu thật: độ ổn định, các tuyến phát triển lệch, khả năng điều khiển, khuyết tật, kiến thức còn thiếu. Có thể tóm tắt bằng lời nhưng không dùng một số “căn cơ 100” thay tất cả.

Tăng nhanh có thể tạo tổn hại hoặc giới hạn tương lai nếu cơ chế phương pháp quy định; không phạt mọi cách nhanh chỉ vì muốn cân bằng. Phương pháp tốn nhiều nguồn lực có thể nhanh và ổn định, đổi lại chi phí, độ phụ thuộc hoặc độ khó tiếp cận.

Chữa khuyết tật cần đúng vấn đề. Không mặc định một viên “tẩy tủy” đặt lại mọi thứ về hoàn hảo. Những hậu quả không thể sửa bằng phương tiện hiện có phải được giữ, nhưng cần có cách chơi tiếp với giới hạn đó.

## 13. Cảnh giới theo năng lực và cấu trúc

Đề xuất mỗi mốc có điều kiện cấu trúc, chức năng mới, mức ổn định cần giữ và cách kiểm chứng. Tên cảnh giới là lớp phân loại; không tự trao mọi năng lực chỉ vì nhãn đã đổi.

Khung kiểm chứng tạm gồm ba mốc chức năng, chưa phải hệ cảnh giới chính thức: cảm nhận và vận hành lần đầu; duy trì được chu trình chứa/dẫn ổn định; chuyển sang cấu trúc có năng lực mới rõ ràng. Chưa gán các mốc này vào tên Luyện Khí, Trúc Cơ hoặc số tầng.

Một người mất chức năng do thương tích có thể giữ lịch sử từng đạt mốc nhưng trạng thái hiện tại suy giảm. Phân biệt tạm thời không sử dụng được với cấu trúc đã thoái hóa và cần xây lại.

Không hứa số tầng vô hạn. Hệ cảnh giới dài hạn phải mô tả được thay đổi có ý nghĩa, nhu cầu xã hội và tác động thế giới của từng giai đoạn.

## 14. Đột phá là một quá trình

| Pha | Quy tắc đề xuất |
| --- | --- |
| Đánh giá | Kiểm tra theo kiến thức hiện có, ghi phần chưa biết |
| Chuẩn bị | Nguồn, nơi, thời gian, người hỗ trợ, cách thoát nếu có |
| Khởi động | Bắt đầu tiêu hao và đưa cơ thể vào trạng thái chuyển đổi |
| Chuyển cấu trúc | Tạo thay đổi có tiến độ và điểm không thể hoàn tác hoàn toàn |
| Ổn định | Duy trì cấu trúc mới, xử lý sai lệch còn lại |
| Hậu kiểm | Xác nhận năng lực và di chứng theo khả năng kiểm tra |

Chuẩn bị đủ làm thay đổi khả năng thành công nhưng không tự bảo đảm. Có thể bị gián đoạn bởi thế giới thật; người hộ pháp phải có mặt và hành động, không chỉ cộng một phần trăm bảo vệ.

Tự dừng trước bước cam kết theo đề xuất THOI_GIAN. Nếu đã cho phép tự đột phá, điều kiện tự động phải rõ về rủi ro, nguồn được dùng và phạm vi; không suy ra quyền đó từ mục tiêu chung “trở nên mạnh hơn”.

## 15. Kết quả đột phá và thất bại

Các kết quả có thể gồm hoãn trước cam kết; dừng có tổn hao; chuyển đổi dở dang cần xử lý; đạt mốc nhưng có khuyết tật; thành công ổn định; suy sụp do một quá trình cụ thể.

Thất bại không luôn là chết hoặc mất sạch tu vi. Mức hậu quả phụ thuộc pha, trạng thái và cơ chế. Điểm chuyển đổi không thể đảo ngược phải được định nghĩa trước, không chọn hồi tố sau khi biết kết quả.

Ngẫu nhiên dùng cho biến thiên chưa mô phỏng, với trạng thái được lưu. Chạy lại cùng bản lưu/đầu vào cho cùng kết quả; không bốc lại khi xem tỷ lệ. Khi điều kiện thay đổi thật, kết quả có thể khác theo quá trình.

Ước lượng người chơi thấy dựa trên hiểu biết và phép kiểm tra; có thể là khoảng/nhãn định tính. Chưa có mô hình hiệu chỉnh thì không hiển thị xác suất chính xác giả như 97,3%.

## 16. Ngắt, quá tải và tẩu hỏa

Mất tập trung, vượt lưu lượng chịu tải, nguồn không tương thích hoặc bước sai tạo hậu quả theo tuyến/quá trình bị ảnh hưởng. “Tẩu hỏa nhập ma” là tên xã hội cho một hoặc nhiều tình trạng, không là một hình phạt ngẫu nhiên chung.

Tách tổn thương mạng dẫn, rối loạn điều khiển và phản ứng tâm lý. Không mặc định mọi sai lệch công pháp biến NPC thành kẻ giết người. Nếu ảnh hưởng nhận thức/hành vi, cần cơ chế liên kết rõ với NPC và triệu chứng có thể nhận biết.

Thu công có thể tốn thời gian và nguồn. Bất tỉnh buộc ngắt thao tác chủ động, quá trình còn lại diễn biến theo trạng thái thật. Không khóa nhân vật vĩnh viễn trong một pha vì tác giả quên thiết kế lối kết thúc.

## 17. Kiêm tu và chuyển công pháp

Tương thích xét cấu trúc, thành phần năng lượng, tuyến dùng, nhu cầu điều khiển và biến đổi lâu dài. Hai công pháp cùng nhãn hệ không tự tương thích; khác hệ không tự xung khắc nếu có cơ chế phối hợp.

Chuyển công pháp có thể cần học lại thao tác, xử lý năng lượng cũ, thích nghi cấu trúc và chấp nhận giai đoạn yếu đi. Kỹ năng dùng chung được giữ; không đặt lại toàn bộ đời nhân vật về số 0.

Hiệu ứng chồng lấp có nguồn và quy tắc cộng/thay thế. Không chạy nhiều công pháp chủ động đồng thời vượt khả năng chú ý hoặc dùng cùng lượng linh lực nhiều lần. Khả năng xử lý song song phải được đạt bằng cơ chế rõ ràng.

## 18. Ba công pháp mẫu khác nhau

Thông số kiểm chứng chi tiết nằm ở [[TU_LUYEN_THU]]: Tĩnh Lưu hấp thu ổn định, Liệt Mạch tạo tải cấu trúc theo xung, Hồi Hoàn thu lại một phần năng lượng của ứng dụng hợp lệ. Đây vẫn là đề xuất, chưa thay hệ cảnh giới dài hạn.

Tên và thông số định tính dưới đây chỉ là ví dụ đề xuất cho kiểm chứng, chưa là nội dung được chốt.

| Mẫu | Cơ chế | Điểm mạnh | Giới hạn và rủi ro |
| --- | --- | --- | --- |
| Tĩnh Lưu Dưỡng Nguyên | Tiếp nhận chậm, lọc thành phần, duy trì tuyến ổn định | Ít đòi nguồn đậm đặc; dễ dừng tại mốc chu kỳ | Tích lũy chậm; không tự rèn chịu tải bộc phát |
| Liệt Mạch Hành Công | Nhận theo đợt, truyền lượng lớn qua tuyến chịu tải | Cung cấp năng lực bộc phát khi cơ thể đã thích nghi | Cần tuyến phù hợp, chuẩn bị và hồi phục; quá tải gây hại đúng vùng |
| Hồi Hoàn Dẫn Lực | Thu hồi một phần năng lượng còn lại sau thao tác hợp lệ | Giảm chi phí tiêu hao trong hoạt động phù hợp | Không thu hồi phần đã tiêu tán; yêu cầu điều khiển và có tổn hao chu trình |

Hồi Hoàn không sinh năng lượng vô hạn: mỗi vòng chỉ thu hồi phần còn có thể thu, trừ chi phí và thất thoát. Tĩnh Lưu không luôn tốt nhất chỉ vì an toàn: nó có thể không đáp ứng nhu cầu thời hạn hoặc ứng dụng cụ thể. Liệt Mạch không được biến thành lựa chọn chỉ khác hệ số tốc độ; đường vận hành và khả năng đầu ra phải khác.

Trước triển khai mỗi mẫu cần định nghĩa bước, đầu vào, trạng thái đầu ra và tình huống mà nó có lợi thế so với hai mẫu còn lại.

## 19. Truyền thừa, văn bản và bí mật

Công pháp thực, bản ghi, kiến thức người học và lời thầy giảng là các đối tượng khác nhau. Bản sao có thể thiếu bước; truyền miệng có thể sai; người giỏi thực hành chưa chắc giỏi dạy.

Học từ NPC cần quan hệ, quyền tiếp cận, thời gian và sự đồng ý theo hệ NPC. Bí kíp trong rương không tự tải vào đầu nhân vật. Học được một phiên bản phải giữ nguồn và giới hạn hiểu biết.

Môn phái có thể kiểm soát quyền truyền dạy; hành vi vi phạm cần bị phát hiện qua kênh thông tin trước khi dẫn tới phản ứng. Không cập nhật toàn môn phái ngay khi người chơi đọc trộm ở xa.

## 20. Sáng tạo công pháp và quy mô nội dung

Cải tiến bắt đầu từ giả thuyết dựa trên kiến thức, thử nghiệm trong giới hạn được giao, quan sát kết quả và tạo phiên bản mới. Không chỉ ghép ngẫu nhiên tính từ vào tên công pháp.

Mẫu tạo nội dung phải kiểm tra tuyến hợp lệ, cân đối nguồn, công dụng, điều kiện học, điểm yếu và khả năng dừng. Những tổ hợp vô nghĩa hoặc chỉ khác tên bị loại. Tổ hợp nguy hiểm có thể tồn tại như công pháp sai nếu nguồn gốc và hậu quả được mô phỏng, không được nhầm thành dữ liệu hợp lệ an toàn.

Chưa tạo danh mục hàng nghìn công pháp trong bước này. Nền dữ liệu cần hỗ trợ mở rộng, còn số lượng phải đi cùng tình huống sử dụng và kiểm chứng.

## 21. Tuổi thọ, sinh tồn và thần thông

Tăng tuổi thọ nếu có phải thay đổi quy tắc lão hóa hoặc khả năng duy trì cấu trúc; không chỉ cộng một mốc ngày chết bí mật. Người sống lâu vẫn có thể chết vì nguyên nhân khác mà cơ thể chưa chống được.

Tịch cốc, chống nhiệt, ngự không, thần thức và tái tạo đều cần chức năng, nguồn, thời hạn và điều kiện ngừng. Ví dụ một trạng thái thay thế nhu cầu ăn cần tiêu nguồn tương ứng; khi nguồn cạn, cơ thể chuyển về nhu cầu theo trạng thái thật, không tự có dự trữ đầy.

Thần thức mở một kênh quan sát có tầm/phạm vi/giới hạn, không cho biết mọi thông tin ẩn chỉ vì tên năng lực. Hồi sinh, linh hồn và đoạt xá còn mở, chưa là tính năng mặc định.

## 22. Nối các nghề tu tiên

Luyện đan dùng quy trình và nguyên liệu của VAT_PHAM, tạo sản phẩm có hiệu ứng lên CO_THE. Luyện khí tạo cấu trúc/vật liệu cung cấp năng lực. Trận pháp là bố trí thành phần với nguồn và phạm vi tác động; hỏng nút phải có hậu quả.

Không dùng ba minigame độc lập tự cấp đồ ở cuối. Tiến trình phải qua hành động, thời gian, điều kiện và tài nguyên chung. Chi tiết từng nghề sẽ cần đặc tả sau; bản này chỉ xác định hợp đồng giữa hệ thống.

## 23. Giao diện và giải thích tiến độ

Hiển thị mục tiêu đang theo, pha luyện, kết quả quan sát, trở ngại đã biết, tài nguyên còn lại và hành vi khi có dấu hiệu bất thường. Cho mở sâu từng phương pháp và lịch sử phiên luyện.

Ví dụ:

> **Đang luyện:** Tĩnh Lưu Dưỡng Nguyên, pha ổn định cuối chu kỳ.  
> **Mục tiêu:** duy trì vận hành đều trước khi thử tăng mức tiếp nhận.  
> **Nhận thấy:** dòng vận hành ổn định hơn các phiên trước; tiến độ tích lũy chậm.  
> **Chưa rõ:** nguyên nhân suy giảm hiệu quả ở cuối buổi.  
> **Quy tắc đã giao:** thu công nếu đau tăng; không dùng linh thạch dự phòng; chưa cho phép tự đột phá.

Tóm tắt sau phiên cần giải thích tiến triển từng hướng và nguồn đã dùng. Không gọi một phiên “vô ích” nếu duy trì kỹ năng, phát hiện sai sót hoặc giúp chẩn đoán, nhưng phải phân biệt điều đó với tăng năng lực thật.

## 24. Tình huống kiểm chứng khi triển khai

| ID | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| TL01 | Hai người hút nguồn hữu hạn | Tổng lượng rút không vượt nguồn tại mốc xử lý |
| TL02 | Nguồn cạn giữa chu kỳ | Tiến trình đổi đúng mốc, không cộng đủ đầu ra rồi mới báo thiếu |
| TL03 | Tổn thương một tuyến | Chỉ các cơ chế phụ thuộc chịu ảnh hưởng tương ứng |
| TL04 | Đọc xong bí kíp | Tạo kiến thức phù hợp, không tự hoàn tất thích nghi cơ thể |
| TL05 | Hiệu ứng tăng lực hết hạn | Mất phần tạm, giữ tiến bộ lâu dài có nguồn thật |
| TL06 | Lặp bài đã quá dễ | Không tăng mọi năng lực vô hạn |
| TL07 | Đột phá bị ngắt ở hai pha khác nhau | Hậu quả theo trạng thái/pha, không một kết quả chung |
| TL08 | Bất tỉnh khi vận công | Ngắt điều khiển chủ động, giải quyết quá trình còn lại |
| TL09 | Tải giữa chuyển cấu trúc | Giữ pha, tiêu hao và ngẫu nhiên; không cấp kết quả hai lần |
| TL10 | Chuyển công pháp | Giữ kỹ năng chung, xử lý phần không tương thích có chi phí |
| TL11 | Chạy vòng thu hồi năng lượng | Không sinh năng lượng khi thiếu nguồn bên ngoài |
| TL12 | Đọc bản thiếu bước | Chỉ biết nội dung có thật; hậu quả theo hành động thực hiện |
| TL13 | Người hộ pháp rời chỗ | Không tiếp tục cộng hỗ trợ chưa được thực hiện |
| TL14 | Giới hạn cấm dùng vật dự phòng | Không tự tiêu chúng để hoàn thành mục tiêu chung |
| TL15 | Nhận định bình cảnh sai | Sự thật không đổi theo lời kể; có thể học khi có bằng chứng |
| TL16 | Năng lực thay thế ăn hết nguồn | Chuyển theo cơ thể thật, không reset dự trữ |
| TL17 | Đổi nhịp giao diện | Cùng trạng thái/đầu vào cho cùng kết quả |
| TL18 | NPC và người chơi cùng điều kiện | Cùng cơ chế luyện, không có tăng tu vi miễn phí riêng cho NPC |
| TL19 | Nhãn cảnh giới còn nhưng bị thương | Chức năng hiện tại phản ánh thương tích |
| TL20 | So ba mẫu công pháp | Có tình huống lợi thế riêng và hạn chế đo được cho từng mẫu |

Chưa chạy các kiểm chứng vì chưa có game. Cần dữ liệu định lượng, đơn vị năng lượng, mô hình quá trình và sai số chấp nhận trước khi chứng minh cân bằng hoặc độ ổn định.

## 25. Phạm vi bản kiểm chứng và phần cần chốt

Đề xuất một nguồn môi trường hữu hạn, một loại vật cấp năng lượng, một mạng cơ thể, ba công pháp mẫu, một quá trình chuyển mốc và một cách thu công. Cùng nền đó phải chạy được cho NPC.

Còn mở: tên/số cảnh giới, hệ thuộc tính, linh căn, đơn vị, thời lượng tiến bộ, độ phổ biến người tu luyện, tuổi thọ, mức hậu quả, quyền tự đột phá và giới hạn thần thông. Không coi các ví dụ trong bản này là quyết định thay người dùng.

Bước kế hoạch tiếp theo: môi trường, địa lý, sinh thái và linh khí để nguồn tài nguyên, linh địa, di chuyển và điều kiện tu luyện có nơi tồn tại thực trong thế giới. Sau đó kinh tế/tổ chức và chiến đấu sẽ nối vào nền chung.
