---
aliases:
  - Công việc và lịch An Khê
  - DL04
tags:
  - thiet-ke
  - npc
status: de-xuat
---

# Công việc, lịch và quyết định NPC — DL04

Ngày: 2026-09-05. Bổ sung [[HANH_DONG]], [[NPC]], [[SINH_KE]], [[VAT_THE_THU]] và [[CO_THE_THU]]. Đây là đề xuất để kiểm chứng, chưa phải hành vi đã chạy hoặc cấu hình được người dùng xác nhận.

## 1. Hồ sơ một việc cụ thể

Mỗi lần thực hiện lưu: mã việc, phiên bản, người làm, người giao, mục tiêu nguồn, kiến thức dùng để lập kế hoạch, địa điểm/đối tượng, điều kiện bắt đầu và duy trì, tài nguyên chiếm, lượng việc chuẩn, tiến độ từng bước, vật tư đã chuyển, sản phẩm dở, hợp đồng, thời hạn, lý do kẹt, sự kiện đánh giá lại và mã hoàn tất chống ghi lặp.

Mẫu J01 là cách làm chung; J01-lô-03 là đề nghị cụ thể; hợp đồng nhận lô-03 là nghĩa vụ; hành động đào của người nhận là hoạt động. Bốn thứ không dùng chung một cờ hoàn thành. Hủy mục tiêu không xóa nghĩa vụ đã nhận hoặc sản phẩm đã có.

Đề nghị không tự khóa người ứng tuyển, cuốc hay lô ruộng. Chỉ khi hai bên chấp nhận mới giữ tài nguyên thuộc quyền người giao; việc giữ có hạn, phạm vi và cách giải phóng. Bên giữ kho không được biết quyết định từ xa nếu chưa có thông tin theo [[LIEN_KET_HE_THONG]].

## 2. Nhận việc và cạnh tranh

Người tìm việc chỉ xét lời chào đã nghe/đọc. Hỏi tại chợ có thể biết ai đang tuyển, không tự tải mọi việc trong thế giới. Người giao xét nhu cầu, vốn khả dụng, năng lực được chứng minh, lịch hứa và mức tin cậy theo điều họ biết; không đọc chỉ số ẩn của ứng viên.

Đề xuất quy tắc H02 cho lô thử: một người phụ trách mỗi lô; hạn nhận trước 08:00, hạn giao 18:00 cùng ngày, công tám đồng khi nhận đủ 30 suất. Giữ tám đồng từ ngân sách H02 khi ký, không chuyển vào ví người làm. Chủ có thể gia hạn qua thỏa thuận; không tự làm lô hỏng vì quá giờ nếu chưa có cơ chế suy thoái.

Nếu nhiều đề nghị chấp nhận tới cùng mốc: xử lý cùng một đợt, ưu tiên người có lịch khả thi được bên giao biết; hòa thì dùng lượt luân phiên đã lưu giữa ứng viên hợp lệ. Không ưu tiên P00 hoặc mã NPC thấp mãi mãi. Kết quả chỉ khóa lô một lần; người không nhận được biết bị từ chối qua phản hồi tại chỗ hoặc tin đến sau.

Lịch tám J01 của DL01 là một nhánh có thể xảy ra khi P00 thực sự được chọn. N11 cũng muốn tiền học, nên có thể cạnh tranh; ăn ở từ H02 không đồng nghĩa đã được trả tiền riêng cho J01. Không trả cả tiền lương giả định và tiền công cùng việc.

## 3. Chọn bước kế tiếp

Áp giới hạn vật lý và giới hạn được giao trước khi chấm điểm. Phương án không biết cách làm được chuyển thành hỏi/học nếu biết nơi hỏi, không đánh giá như chắc chắn làm được. Dự báo giá, thời gian và rủi ro dùng niềm tin có nguồn; thực thi vẫn kiểm tra trạng thái thật tại mốc hành động.

Trong bản thử, phân mức ưu tiên theo thứ tự: mất khả năng/nguy cơ đã nhận biết → nguồn sống sắp thiếu trước cơ hội bổ sung tiếp theo → cam kết gần hạn → mục tiêu nghề/gia đình/học → việc tùy chọn. Đây là chính sách đề xuất của nhóm thử; không luật đạo đức bắt buộc mọi NPC thế giới.

Trong cùng mức dùng điểm Q = 4U + 3V + 2C − 3R − T − K. Mỗi thành phần nguyên 0–5: U là khẩn theo thời gian còn lại; V là mức hợp mục tiêu riêng; C là đóng góp cam kết; R là rủi ro ước lượng; T là chiếm thời gian; K là chi phí chuyển việc. Đây là công cụ xếp phương án, không chỉ số tính cách tổng hợp.

Để dữ liệu có thể tái hiện: U = 5 nếu còn ≤ 1 giờ, 4 nếu ≤ 3 giờ, 3 nếu ≤ 6 giờ, 2 nếu ≤ 12 giờ, 1 nếu ≤ 24 giờ, 0 nếu không có hạn gần. T = min(5, số giờ dự kiến làm tròn lên); K = 0 nếu tiếp tục bước cũ, 2 nếu phải cất/đổi dụng cụ, 4 nếu phải bỏ một tiến trình không thu hồi. V/C/R phải được ghi cụ thể theo phương án và nguồn đánh giá, không được bốc tùy ý mỗi lần nhìn.

Giữ việc cũ nếu phương án mới cùng mức không hơn ít nhất năm điểm; mức ưu tiên cao hơn hoặc mất điều kiện vượt quy tắc này. Điểm hòa giữ việc hiện tại, nếu chưa có việc thì dùng lượt lựa chọn đã lưu. Không đổi việc mỗi khi đói tăng một chút. Không chấm điểm để vượt lệnh cấm bán kỷ niệm hoặc chi quá giới hạn của P00.

Ví dụ N11 xét cùng mức: nhận J01 có U=2,V=5,C=0,R=1,T=5,K=0 nên Q=15; học chưa có người dạy không phải phương án hợp lệ. N14 có thể chấm V cao cho luyện ổn định; N15 chấm cao cho tìm hiểu thử nghiệm, nhưng chưa có dữ liệu DL05 thì chỉ hỏi/đọc, không tự chạy vận công chưa định lượng.

## 4. Khi nào đánh giá lại

Đánh giá tại hoàn tất bước, tin liên quan tới nơi, nhận/từ chối hợp đồng, hết giữ chỗ, mất công cụ/quyền tại nơi kiểm soát, cơ thể đổi khả năng, hoặc mốc dự báo thiếu nhu cầu. Gom nhiều thay đổi cùng mốc thành một lần sau pha hậu quả; không lập lại kế hoạch trước khi trạng thái cùng mốc được xử lý xong.

Nếu đang chờ mà không có sự kiện biết trước, lần hỏi lại đầu sau 30 phút game; thất bại cùng nguyên nhân tăng lên 60 rồi tối đa 120 phút. Tin mới liên quan cho phép xét sớm. Không dùng lịch hỏi lại để biết tức thì thầy thuốc vừa quay về ở nơi khác; nhân vật phải tới/nhận tin mới xác nhận được.

Mỗi bước thất bại ghi điều kiện thiếu, thông tin nhân vật biết, phương án thay thế và lần xét tiếp. Tối đa ba lần dựng phương án thay thế trong một lượt quyết định; nếu vẫn kẹt, chuyển chờ/nghỉ hợp lệ. Đây là giới hạn tính toán mỗi lượt, không xóa mục tiêu sau ba thất bại cả đời.

## 5. Tài nguyên đồng thời và thao tác nhỏ

Một nhân vật có một vị trí, hai tay, một hoạt động di chuyển và một ngân sách chú ý. Đề xuất chú ý chuẩn 100: đi tuyến quen 40, trò chuyện đơn giản 30, đọc/học 80, thủ công 80, việc nặng 80. Tổng ≤ 100 và tay/vị trí tương thích mới chạy cùng lúc. Ngủ loại trừ việc chủ động. Hai hoạt động chạy cùng nhau không được cộng chồng tốc độ mệt nếu đã thuộc một hoạt động chủ đạo DL03.

| Thao tác thử | Thời gian game | Điều kiện và ghi nhận |
| --- | --- | --- |
| Mở hoặc đóng túi | 10 giây/lần | Một tay khả dụng, túi tại chỗ |
| Lấy/cất một món đã tiếp cận | 10 giây | Miệng túi mở, chỗ chứa hợp lệ; vật bị che cần lấy vật che trước |
| Rót/lấy nước | 1.000 ml/phút + 20 giây mở/đóng bình mỗi lần | Giới hạn bình/nguồn, một người thao tác một bình mỗi lúc |
| Uống 500 ml | 2 phút | Bình trong tầm, chuyển nước khi thao tác hoàn tất rồi chờ hấp thu DL03 |
| Ăn 250 g V02 | 10 phút | Tách suất thành lượng thật; hoàn tất chuyển vào tiêu hóa |
| Hỏi/đáp hoặc đề nghị đơn giản | 5 phút | Hai bên có thể giao tiếp; có thể từ chối, chưa phải ký mọi đề nghị |
| Kiểm đếm/giao nhận lô | 5 phút/lô | Hai bên hoặc người được ủy quyền hiện diện |
| Bốc/dỡ lô hàng ≤ 15 kg | 10 phút mỗi đầu | Chia món theo sức mang, không nhấc cả 15 kg một tay |
| Cất dụng cụ và dừng an toàn | 1 phút | Chỉ khi còn điều khiển; ngắt cưỡng bức có trạng thái rơi/đặt riêng |

Đây là thời lượng chuẩn khi khỏe và vật đã sắp xếp phù hợp; thao tác dùng chức năng nào thì giảm tốc theo DL03 một lần. Thao tác rót có tiến độ lượng; bị ngắt giữ lượng đã rót. Ăn/uống bị ngắt trước mốc hoàn tất trong mẫu này giữ phần chưa tiêu ở vật đang cầm, không vừa hoàn toàn bộ vật vừa cộng nhu cầu.

## 6. Tiến độ J01 và J02

J01 có ba tiểu lô theo DL02, mỗi tiểu lô hai giờ hữu ích. Tiến độ hữu ích tăng bằng H × min(G hai tay) nhân thời gian làm. Xong từng tiểu lô xuất mười suất và phụ phẩm tương ứng; phần ruộng còn lại không bị trừ sớm. Việc hoàn thành sản xuất, chuyển kho và nghiệm thu là ba mốc khác nhau.

J02 được cụ thể thành mười đơn vị băng, mỗi đơn vị 12 phút hữu ích. Khi bắt đầu một đơn vị, 100 g vải chuyển từ lô vào bán thành phẩm có chủ H01; hoàn tất mới thành V05. Một giờ hữu ích tạo năm băng, còn 500 g chưa xử lý. Bị ngắt giữa một đơn vị giữ 100 g trong bán thành phẩm cùng tiến độ, không trả lại vải nguyên rồi giữ cả băng.

B-LOCAL lúc 09:00 là đúng ranh sau năm đơn vị. Năm băng có thật nhưng bốn đồng chưa trả vì hợp đồng cần đủ mười. Băng chăm sóc vẫn lấy từ O01 như DL03, không tự lấy sản phẩm H01. Các thao tác mở/lấy vật trước 08:00 thuộc khởi tạo tình huống, không nhét thêm vào một giờ hữu ích cố định.

Nếu đổi người làm: bên có quyền giao việc phải đồng ý, người mới nhận bán thành phẩm và tiến độ; trả công theo thỏa thuận mới. Không mặc định chia đôi bốn đồng vì hai người cùng chạm vào vải. Nếu chưa thỏa thuận thì tiền giữ chỗ vẫn gắn hợp đồng cũ, sản phẩm không biến mất.

## 7. Một ngày P00 có thể đối chiếu

Biến thể A-DAY là ngày làm việc sau khi P00 đã hỏi và biết D05/D11, học cách dùng cuốc thử, được nhận J01 và có quyền lấy cuốc. Những điều này không có sẵn trong INIT-A ban đầu chỉ biết D01/D02. Không dùng A-DAY để tuyên bố người mới lập tức tìm được mọi việc.

Chuỗi tạo đúng các điều kiện này từ 06:00 đến 08:00 được viết tại [[DU_LIEU_LIEN_KET_K0]] mục 3 dưới mã FX-A-BOOT. Nó vẫn là fixture đề xuất, chưa phải kết quả hành vi tự chủ đã chạy.

| Giờ | Việc và địa điểm | Điều kiện kiểm tra |
| --- | --- | --- |
| 06:00–06:30 | Ăn 250 g, uống 500 ml, lấy đồ tại D02 | Bao gồm thao tác, nước trong bình có thật |
| 06:30–07:00 | Tới D11 qua D01 | 450 m; dự trù cả giao tiếp/chờ ngắn |
| 07:00–07:15 | Bổ sung bình tới đầy | Chỉ lấy phần thiếu, không cộng trọn 2 lít vào bình còn nước |
| 07:15–07:45 | Tới D05 qua D01 | 1.050 m; 0,8 m/s mất 21 phút 52,5 giây khi tải/H phù hợp |
| 07:45–08:00 | Nhận cuốc, đến vị trí làm | Tiểu khu thử dự trù 5 phút di chuyển, còn thời gian chuẩn bị |
| 08:00–11:00 | J01 ba giờ hữu ích | Chỉ đạt ba giờ nếu chức năng/tốc độ bằng chuẩn |
| 11:00–13:00 | Cất cuốc, uống 500 ml, nghỉ | Đã chừa thao tác trước khi quay lại |
| 13:00–16:00 | J01 ba giờ hữu ích còn lại | Không tự rút ngắn khi còn thiếu tiến độ |
| 16:00–16:30 | Uống 500 ml, chuyển sản phẩm kho và nghiệm thu | Cùng D05: 5 phút chuyển nội bộ + 10 phút bốc/chia + 5 phút nhận, thao tác khác trong phần dư |
| 16:30–17:00 | Về D02 qua D01 | 1.000 m; 0,8 m/s mất 20 phút 50 giây |
| 17:00–18:00 | Nghỉ, giao tiếp hoặc xử lý mục tiêu gần | Không tự cộng sản phẩm nghề trong giờ này |
| 18:00–18:30 | Ăn 250 g, uống 500 ml | Tổng ngày 500 g thức ăn, 2.000 ml nước |
| 18:30–22:00 | Sinh hoạt nhẹ, nghỉ, chuẩn bị ngày tới | Việc chưa có mẫu thì không tạo đầu ra; không thêm lao động nặng để lấp kín |
| 22:00–06:00 | Ngủ | Tám giờ, không đồng thời trực/giao dịch |

Ăn hoàn tất khoảng 06:10/18:10 thì hấp thu 08:10/20:10. Khởi đầu E=1; trước hấp thu đầu còn khoảng 0,91; trong lịch lặp, hai phần cách 12 giờ giữ E dương nếu không bỏ bữa. Uống bốn lần có trì hoãn 10 phút vẫn cần W ban đầu; lịch này không để kho nhu cầu bằng 0 trong ngày mẫu. Việc lấy nước sáng không đồng nghĩa lượng uống tăng thêm.

Tải thay đổi sau ăn/uống/nhận cuốc; 0,8 m/s là dự trù cho các chặng trên khi tổng đồ ≤ 10 kg, không khóa vận tốc bất chấp tải thật. Khung 24 giờ gồm 8 giờ ngủ + 6 giờ sản xuất + 10 giờ sinh hoạt/di chuyển/nghỉ; không chứng minh mọi ngày hoặc mọi NPC đều có lịch này.

## 8. Vai trò và lịch của 20 NPC

DL05 tại [[TU_LUYEN_THU]] đã định lượng các phiên luyện. Thời gian đi D09–D10 và phiên luyện phải chiếm lịch thật; N14/N15 chỉ vận công khi đủ điều kiện, nguồn và quyền.

Các cửa sổ dưới là thời gian dự kiến có thể tìm gặp, không khiến nhân vật dịch chuyển hoặc bỏ nhu cầu. Mỗi người cần lịch nước/ăn theo nhóm DL01; khi rời vị trí, cửa sổ dịch vụ phải phản ánh vắng mặt. Quyền trong nhóm không cho tự động điều khiển mọi thành viên.

| Người | Khung công việc đề xuất | Khi có xung đột |
| --- | --- | --- |
| N01 | Sáng tìm nguồn/thu thuốc đã biết; chiều giao hoặc hỏi việc nhẹ | Thương tích làm hoãn chuyến; không tạo thuốc nếu thiếu quy trình thu |
| N02 | 08–11, 13–16 làm vải nếu có đơn, còn lại quản lý H01 | Nhu cầu hộ và hạn giao quyết định thuê/ngừng nhận |
| N03 | D03 nhận hẹn 08–11, 13–16 | Chăm sóc khẩn đã nhận có thể làm trễ hẹn, cần báo |
| N04 | Trực tiếp nhận và học theo lịch N03 | Không tự nhận kỹ thuật vượt kiến thức |
| N05 | Chuyến tiếp tế đã nhận, chuẩn bị trước hạn giao DL01 | Đang kéo xe không nhận thêm chuyến trùng giờ |
| N06 | Quầy D01 08–11, 13–17, có khoảng nghỉ | Mua lô cần vốn và người nhận, không phục vụ khi đi xa |
| N07 | Xưởng 08–11, 13–16 | Hỏng công cụ/thiếu khách có thể chuyển dạy N08 |
| N08 | Học/làm phần đã biết tại xưởng | Không tự xuất cán khi quy trình tạo cán chưa hoàn thiện |
| N09 | Theo lô ruộng đã chín, tối đa sáu giờ hữu ích | Có thể tự thu thay vì tuyển, làm mất cơ hội J01 của ứng viên |
| N10 | Nguồn sống nhóm, quan sát/giữ giống đã có | Chưa có mô hình vụ mới thì không sinh cây bằng nhãn nghề |
| N11 | Tìm việc có tiền, cạnh tranh J01, học khi có lịch | Không nhận hai hợp đồng đòi cùng thời gian |
| N12 | Cấp cuốc trước 08:00, nhận lô 16–18 tại D05 | Cần bố trí người thay có quyền nếu đi lấy nước |
| N13 | Một buổi dạy hai giờ/ngày tại D09 khi nhận hẹn | Không vừa dạy P00 riêng vừa dạy nhóm riêng đủ hiệu suất |
| N14 | Học/đọc, nước và mục tiêu luyện ổn định | Chưa đủ tham số DL05 thì hoãn vận công thực |
| N15 | Học/trao đổi thử nghiệm, chia việc nước | Không có quyền dùng kho chỉ vì muốn thử công pháp |
| N16 | Cấp kho D09 trước/sau giờ học | Đơn lớn chờ N13 duyệt, không tự chia nhỏ lách quyền |
| N17 | Hộ tống theo chuyến hoặc giữ hàng đã nhận | Không vẫn bảo vệ kho khi đang ở đường xa |
| N18 | Trực cầu sau chuyến lấy nước sáng, các khoảng kiểm tra | Ghi thời gian vắng; không có người gác vô hình |
| N19 | Cấp suất/phòng sáng và chiều tại D02 | Dịch vụ ngoài giờ cần gặp và được chấp nhận |
| N20 | Hai chuyến nước O05 buổi sáng, đưa tin khi còn lịch | Tin giữ hành trình, không truyền tức thì tới cả làng |

DL01 phân nhóm quyền ăn; bảng này phân trách nhiệm, chưa đủ để chứng minh lịch 21 người không xung đột. Cần lượt quan sát cộng đồng sau triển khai, đặc biệt việc nước của người giữ kho và những ngày nhiều người cùng cần thầy thuốc.

## 9. Tìm chăm sóc ở xa và thay đổi thu nhập

B-REMOTE phải khởi tạo riêng việc P00 biết đường từ D06 về D03 và biết có y quán; nếu không biết thì lựa chọn đầu là tìm người hỏi trong tầm, không dùng bản đồ toàn tri. Nhánh có đường đã biết, cầu thông: D06–D08–D07–D01–D03 dài 1.350 m. Với tốc độ 0,8 m/s không đổi, đi 28 phút 7,5 giây; chưa tính dừng việc, hỏi/đợi/nhận chăm sóc.

Nguồn dịch thử 100 g ở tốc độ 2 g/phút cạn sau 50 phút nếu không can thiệp; đây chỉ là kết quả nguồn thử, không kết luận chết hoặc an toàn. FX-B-REMOTE chuẩn tại [[CHAM_SOC_K0]] tới D03 09:28:07.500 và hoàn tất B-CARE 09:45 sau bước kiểm tra; nhánh N03 bận/từ chối vẫn là biến thể khác. Không lấy kết quả B-LOCAL 09:10 cho nhánh xa.

P00 báo H01 không làm tiếp J02 khi có kênh liên lạc; H01 chỉ biết lý do từ lúc nhận tin/quan sát. H01 có thể chờ, gia hạn hoặc thuê người hoàn phần còn lại theo thỏa thuận. Kho vẫn có năm băng hoàn tất ở B-LOCAL; P00 chưa có bốn đồng. Mất thu nhập có thể hoãn buổi học, tìm việc phù hợp hoặc thương lượng, không tự cấp tiền cứu.

## 10. Kiểm chứng khi có mô phỏng

| Mã | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| CV01 | Hai ứng viên nhận cùng lô | Một hợp đồng giữ lô, không trả công hai lần |
| CV02 | J02 sau 60 phút hữu ích | Năm băng, 500 g vải còn, chưa trả bốn đồng |
| CV03 | Ngắt giữa băng thứ sáu | Giữ bán thành phẩm/tiến độ, không hoàn vải trùng |
| CV04 | G đổi giữa J01 | Tính phần cũ trước mốc, cập nhật điều kiện/phần mới |
| CV05 | Người thay tiếp việc | Cùng sản phẩm dở, hợp đồng/thanh toán phải có quyền |
| CV06 | Người chơi chưa biết ruộng | Không chạy lịch A-DAY ngay từ INIT-A |
| CV07 | N03 bận, P00 ở xa | Có đi/chờ/đề nghị thật; không chăm sóc từ xa |
| CV08 | Điểm phương án hơn hai | Giữ việc cũ nếu cùng mức và còn điều kiện |
| CV09 | Chờ cùng nguyên nhân | Giãn lần hỏi, tin mới hợp lệ có thể đánh thức sớm |
| CV10 | Vừa ngủ vừa bán hàng | Không cùng diễn ra với một người |
| CV11 | Lấy nước bình chưa rỗng | Chỉ bổ sung phần thiếu, sổ nguồn đúng |
| CV12 | Tiếp tế đã mua chưa vận chuyển | Hàng vẫn ở nơi thật, không vào kho người nhận từ xa |
| CV13 | N12 đi lấy nước | Cấp/nhận kho cần chờ hoặc người có quyền thay |
| CV14 | Lưu tại mốc nghiệm thu | Tiền/vật/tiến độ áp một lần, lượt lựa chọn được giữ |
| CV15 | Không có người chơi | NPC vẫn tạo mục tiêu và tranh việc từ nhu cầu riêng |
| CV16 | Ngày nhiều yêu cầu trùng | Báo thiếu người/thời gian, không dịch chuyển hoặc thêm giờ |

Đã đối chiếu số học ví dụ và các phụ thuộc ở mức tài liệu. Chưa chạy lịch 24 giờ, 30 ngày hoặc các tình huống CV bằng game. Mẫu công việc chưa đủ cho mọi nghề, cơ chế giá/tâm lý vẫn cần cân bằng. Bước tiếp theo DL05: kho linh lực cá thể, tuyến và hiệu suất ba công pháp, điều kiện phiên luyện và chuyển mốc thử.
