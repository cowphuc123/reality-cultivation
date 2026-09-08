---
aliases:
  - Cơ thể thử An Khê
  - DL03
tags:
  - thiet-ke
  - co-the
status: de-xuat
---

# Cơ thể thử, chức năng và hồi phục — DL03

Ngày: 2026-09-05; cập nhật K0.6 ngày 2026-09-06. Nối [[CO_THE]], [[VAT_THE_THU]], [[SINH_KE]], [[CHAM_SOC_K0]] và chuỗi B của [[BAN_CHOI_THU]]. Các hệ số dưới đây là quy tắc game hư cấu, không phải số liệu sinh học hay hướng dẫn điều trị thực tế. Đây là đề xuất chưa được chốt; chưa có mô phỏng hoạt động.

## 1. Phạm vi của mẫu

Mẫu H-TEST-01 dành cho người trưởng thành khởi đầu khỏe mạnh trong An Khê. P00 và 20 NPC cùng dùng thông số cơ sở cho bài đối chiếu; tuổi, tính cách và nghề vẫn riêng. Chưa suy ra cơ thể mọi người giống nhau trong thiết kế dài hạn.

Định lượng trước: tổn thương bàn tay, chức năng chân/tay, sức mang, mệt và nhu cầu; không tự áp công thức vết cắt tay cho não, tim hay mọi bệnh. Những cơ quan chưa có quy tắc tác động vẫn được định vị, nhưng tình huống tác động vào chúng chưa được hỗ trợ trong bộ thử này. Không dùng văn bản kể để giả đã mô phỏng đầy đủ.

## 2. Bộ phận và quyền quản lý dữ liệu

| Nhóm | Nút được tách trong mẫu | Trạng thái được tính |
| --- | --- | --- |
| Đầu | Sọ, não, mắt trái/phải, tai trái/phải, mũi, miệng/hàm | Cảm giác/tỉnh táo cơ sở; tác động sâu chưa định lượng |
| Cổ và thân | Cổ, ngực, bụng, chậu, ba vùng cột sống | Liên kết nâng đỡ và điều khiển |
| Cơ quan | Tim, hai phổi, dạ dày, ruột, gan, hai thận | Chức năng nền 1; bệnh/tổn thương riêng chưa mở |
| Mỗi tay | Vai, cánh tay, khuỷu, cẳng tay, cổ tay, bàn tay, năm ngón riêng | Chuỗi cơ học/thần kinh, nắm và thao tác |
| Mỗi chân | Háng, đùi, gối, cẳng chân, cổ chân, bàn chân, năm ngón riêng | Chuỗi chống đỡ, đứng và đi |
| Tu tiên | Đan điền và tham chiếu tuyến kinh mạch | Dành DL05, không tự có năng lực vận công |

Mỗi nút có mã theo cá thể, bên, cha, liên kết và danh sách mô. Nút tổng hợp không sở hữu lại mô của con. Bàn tay trong tình huống B chia mô che phủ và dải gân nắm thành các ô tổn thương có danh tính; tổn thương ở vùng bàn tay không tự nhân lên cả năm ngón.

Chưa có bảng khối lượng từng mô và hình học tiếp xúc toàn thân. Vì vậy tách chi, ghép mô và cân xác chưa là hành động khả dụng dù khung dữ liệu cho phép phát triển chúng. Khối lượng máu/dịch chuyển trong tình huống dưới được ghi riêng, không dùng tổng khối lượng cơ thể còn thiếu để tạo vật chất mới.

## 3. Trạng thái và công thức chức năng

Mỗi vùng mô thử có mức liên tục c trong [0;1], ban đầu 1; đây là chỉ số cấu trúc, không phải phần khối lượng đã mất. Mô rách có thể vẫn nằm tại chỗ. Mô bị mất cần sự kiện vật chất khác và không hồi phục bằng công thức liền vết dưới đây.

Với từng tay, G = min(c gân nắm, c chuỗi khớp chịu lực, c đường điều khiển). Các mắt xích chưa bị tác động bằng 1. Lực giữ thử của tay = 5 kg × G. Khả năng thao tác tinh = min(G, cảm giác tay, thị giác khả dụng). Không cộng lực tay phải vào điều kiện bắt buộc tay trái.

Với từng chân, Z = min(c chuỗi chống đỡ, c khớp, c điều khiển); đi hai chân bình thường dùng Zđi = min(Ztrái, Zphải). Đi khập khiễng, nạng hoặc bò là cách di chuyển khác, chưa tự được cấp bởi việc giảm tốc độ.

Tải đồ tối đa khi đi thường = 15 kg × Zđi × hệ số toàn thân H. Tốc độ đi = tốc độ theo tải ở DL02 × Zđi × H. Tải DL02 được xét theo khối lượng tuyệt đối của đồ đang mang. Tay bị cắt không tự hạ Zđi; cơ thể suy giảm toàn thân có thể ảnh hưởng cả hai qua H có nguyên nhân riêng.

H = min(hệ số mệt, hệ số nhu cầu, giới hạn toàn thân đã khai báo). [[CHAM_SOC_K0]] chỉ thêm giới hạn H khi W-B01 mất ít nhất 80.000 mg; không nhân thêm một lần phạt chung “đang bị thương”. Đau dùng cho tập trung và chọn hành vi, không lại trừ lực nắm trong phép thử này.

## 4. Điều kiện một số việc

| Việc | Điều kiện mẫu | Tốc độ tiến độ |
| --- | --- | --- |
| J01 dùng cuốc hai tay | G mỗi tay ≥ 0,6; Zđi ≥ 0,7; tải hợp lệ | H × min(Gtrái, Gphải), so với giờ hữu ích chuẩn |
| Cầm bình đầy một tay | 2,4 kg ≤ 5 kg × G; tay còn trống | Theo di chuyển, không thêm phạt tay khi đã giữ được |
| Cắt băng J02 | Tay cắt và tay giữ đều có thao tác ≥ 0,7 | H × giá trị thao tác thấp hơn |
| Đọc/học | Tỉnh, nhìn được, tập trung ≥ 0,5 | Theo tập trung, không cần hai tay khỏe nếu tờ được đặt hợp lệ |
| Kéo xe DL02 | G mỗi tay ≥ 0,7; Zđi ≥ 0,8; H ≥ 0,8 | Tốc độ xe DL02 × H × Zđi |

Chức năng giảm làm thay đổi tiến độ từ mốc giảm, không sửa phần đã làm trước đó. Không đạt điều kiện thì dừng việc tương ứng và đánh giá phương án khác. Đổi tay chỉ được phép khi quy trình có cách làm một tay; không tự biến J01 hai tay thành một tay với cùng sản lượng.

## 5. Mệt, nghỉ và ngủ

F là mệt toàn thân [0;100], ban đầu 0. S là áp lực ngủ [0;100], ban đầu 0. Đơn vị thời gian trong các tốc độ sau là giờ game. Tích phân theo khoảng giữa sự kiện, giữ phần lẻ; chạm ngưỡng thì đặt sự kiện tại thời điểm chạm, không chờ sang ngày.

| Hoạt động chủ đạo | Thay đổi F mỗi giờ |
| --- | ---: |
| Lao động nặng J01, kéo xe | +8 |
| Đi mang đồ đến 10 kg | +4 |
| Đi trên 10 kg đến tải cho phép | +6 |
| Thủ công nhẹ | +3 |
| Đọc/học yên tĩnh | 0 |
| Nghỉ yên hoặc ăn ngồi nghỉ | −6 |
| Ngủ | −10 |

Chỉ một tốc độ F chủ đạo trong một khoảng; kéo xe không cộng thêm cả đi bộ và lao động thành +20. Đây là tải mệt tổng hợp, mệt riêng từng cơ còn thiếu.

Hệ số mệt = 1 khi F < 60; 0,8 khi 60 ≤ F < 80; 0,5 khi F ≥ 80. F = 100 ngắt việc gắng sức, vẫn cho nghỉ và sinh lý chạy. Chọn nghỉ chủ động khi F ≥ 60 là chính sách đề xuất, không luật khiến mọi NPC tự động ngoan ngoãn nghỉ.

S tăng +4/giờ thức và giảm −8/giờ ngủ. 16 giờ thức/8 giờ ngủ cân bằng 64 điểm; đây là cách giữ định mức DL01. Hệ số chú ý do ngủ = 1 khi S < 72, 0,75 khi 72 ≤ S < 90, 0,4 khi S ≥ 90. S = 100 yêu cầu kiểm tra mất khả năng duy trì thức trong DL04; chưa suy ra tử vong. Tập trung = min(hệ số chú ý, 1 − 0,5 × đau lớn nhất đã cảm nhận), với đau chuẩn hóa [0;1].

## 6. Ăn uống: nhu cầu khác sổ vật chất

Giữ nhu cầu cơ sở của bài thử là 500 g V02 và 2.000 ml nước mỗi ngày. Dùng kho nhu cầu E tính bằng suất tương đương và W tính bằng ml nước khả dụng, không coi E là khối lượng mô. Khởi đầu E = 1 và W = 2.000 là dự trữ sinh lý khai báo, độc lập sáu suất và bình nước trong túi P00; đây là bổ sung trạng thái cơ thể, không cộng vào kho lương thực 500 suất.

E giảm 1/24 mỗi giờ; W giảm 2.000/24 ml mỗi giờ trong điều kiện thử ôn hòa, kể cả ngủ. Ăn chuyển lượng thật vào hàng chờ tiêu hóa: mỗi phần hoàn tất sau hai giờ cộng lượng tương đương theo 500 g/suất. Uống chuyển nước vào hàng chờ hấp thu: sau 10 phút cộng lượng ml tương ứng. Đây là trì hoãn gameplay cố định, không thời gian sinh học thực. Không ăn/uống được thì không tạo hàng chờ.

Kho nhu cầu có trần E = 2 và W = 4.000. Lượng hấp thu vượt trần chuyển sang hồ sơ dư, không được nhân đôi thành dự trữ. Khối lượng thức ăn/nước sau sử dụng được theo dõi tại cơ thể, chất thải hoặc môi trường; thay đổi E không tự xóa 500 g vật chất. Chưa định lượng tiêu hóa hóa học, trao đổi khí và bài tiết nên chỉ kiểm tra chuyển vật phẩm → cơ thể, chưa tuyên bố khép kín khối lượng sinh học toàn thân.

Hệ số nhu cầu = 1 khi E và W đều > 0. Nếu một kho bằng 0, hệ số = 0,8 và tích lũy riêng thời gian thiếu tương ứng; thiếu liên tục 12 giờ làm hệ số = 0,5. Nạp lại kho dương kết thúc đoạn thiếu tương ứng, giữ lịch sử. Các ngưỡng này nhằm tạo trở ngại để kiểm tra đổi kế hoạch, chưa định quy tắc chết đói/khát hoặc phục hồi bệnh do thiếu kéo dài.

Mệt F có thể hồi khi nghỉ nhưng thiếu thức ăn vẫn giữ hệ số nhu cầu thấp; uống nước không chữa cấu trúc gân. Chưa tăng nhu cầu theo lao động/nhiệt trong bài nền; khi thêm phải tính lại ngân sách DL01, không âm thầm giữ lời khẳng định đủ ăn uống 30 ngày.

## 7. Vết thương cố định W-B01

Đầu vào thử tại tB: vết cắt bàn tay trái, không cắt rời mô, không tổn thương xương hoặc thần kinh. Gân nắm từ 1 xuống 0,4; mô che phủ từ 1 xuống 0,5; đau cảm nhận 0,4; nguồn dịch thử chảy 2 g/phút. Nguồn dịch khởi tạo dành cho phép thử là 100 g đã nằm trong cơ thể; dừng khi cạn, không có nguồn âm. Không gọi 100 g này là toàn bộ lượng máu cơ thể.

Đây là sự kiện kiểm chứng đã xác định hậu quả mô, không phải công thức từ lực dao sang tổn thương; phần tiếp xúc/lực thuộc DL06. Nguồn dịch không tự quyết định mất tỉnh táo hay tử vong. [[CHAM_SOC_K0]] thêm giới hạn tập trung/thao tác/H theo lượng mất để fixture đổi hành vi; sốc và tuần hoàn sâu vẫn chưa được hỗ trợ.

Tại tB, tay trái chỉ giữ 2 kg nên không đủ giữ bình đầy 2,4 kg; tay phải vẫn giữ 5 kg. J01 dừng vì 0,4 < 0,6. Đi với đồ trên lưng vẫn có thể tiếp tục nếu tải/chân/H hợp lệ; đọc có tập trung 0,8 khi không thiếu ngủ. Đây là các kết quả số để so với phiên không có thương tích.

## 8. Can thiệp và liền vết thử

Can thiệp B-CARE là thao tác chăm sóc hư cấu trong bộ thử: người có kỹ năng và quyền dùng một V05 sạch ở cùng nơi, thao tác 10 phút, hai tay của người chăm sóc khả dụng. Không mô tả kỹ thuật điều trị đời thực. Khi hoàn tất, V05 gắn tại tay trái, giữ danh tính; quá trình rỉ dịch W-B01 dừng từ mốc đó. Tháo băng khi vết chưa kín kích hoạt lại 2 g/phút từ phần dịch còn, không hoàn dịch đã mất.

K0.6 cụ thể hóa đích dịch: chín phút đầu B-CARE đưa 18.000 mg vào môi trường; phút cuối đưa 2.000 mg vào đúng V06; nguồn còn 80.000 mg. Băng không hút ngược dịch đã rơi và không cộng cùng lượng ở hai đích.

Mô che phủ chỉ tích lũy liền khi có V06 hợp lệ, E/W dương, F < 60, vùng không gắng sức và không có biến chứng. Gân dùng cùng điều kiện cho tới khi che phủ đạt 1; sau đó có thể tiếp tục không băng nếu các điều kiện còn lại giữ. Mỗi 24 giờ đủ điều kiện, c gân tăng 0,05 và c che phủ tăng 0,1, chặn ở 1; phần giờ dư giữ lại. Vòng đời/thay băng nằm tại [[CHAM_SOC_K0]].

Đau mẫu = 0,4 × (1 − c gân)/0,6 cho riêng W-B01, chặn [0;0,4]. Chăm sóc không lập tức thay c; thuốc giảm đau nếu thêm phải chỉnh cảm nhận riêng, không dùng công thức đảo để suy mô lành. Khi có tái thương, ô mô tăng phiên bản, tiến trình liền phải kiểm tra lại phần còn hợp lệ để sự kiện cũ không chữa phần vừa mất.

Với nhánh giữ điều kiện liên tục: sau bốn ngày đủ điều kiện, c gân = 0,6; sau 12 ngày = 1. Mốc đủ lực không đồng nghĩa đã hoàn thành lịch việc thực tế. Trở lại thao tác tay làm tạm dừng đồng hồ liền; không vừa tính nghỉ toàn thời gian vừa tính sản lượng đủ ngày.

Nhiễm bẩn, nhiễm trùng, gãy xương, độc, nhiệt và sẹo vĩnh viễn vẫn cần quy trình riêng. Nhánh chuẩn ghi rõ không có tác nhân nhiễm được chèn; không suy mọi vết bẩn đều an toàn hoặc chắc chắn nhiễm.

## 9. Chuỗi B có đầu vào và kết quả cụ thể

Bổ sung DL04 ở [[CONG_VIEC_THU]]: J02 sau một giờ hữu ích có năm băng hoàn tất, 500 g vải chưa xử lý, chưa nhận tiền; phần dở và hợp đồng được giữ. B-REMOTE có đường/tri thức/đối tác riêng, không dùng thời điểm chăm sóc của B-LOCAL.

Biến thể B-LOCAL lấy P00 tại D03 trong giờ hữu ích J02, vật tư được chuyển từ H01 và hợp đồng được hai bên chấp nhận trước đó; N03 hiện diện, đã được giao chăm sóc thử, một V05 từ kho O01. Các thay đổi địa điểm/quyền/đề nghị này là khởi tạo kiểm chứng công khai, không ghi rằng NPC đã tự thương lượng trong game.

Chèn W-B01 lúc ngày 1, 09:00, sau một giờ hữu ích J02. Với tiến độ chuẩn hai giờ, việc đang đạt 50%; chưa nghiệm thu, chưa nhận bốn đồng. B-CARE hoàn tất 09:10: 18 g ở môi trường, 2 g trong V06, nguồn còn 80 g; băng chuyển kho → đang đeo đúng một lần. Chức năng nắm vẫn 0,4; J02 cần 0,7 nên chưa tiếp tục được. Lịch năm băng và mốc ngày 2–13 ở [[CHAM_SOC_K0]].

Sau sáu ngày đủ điều kiện liền, c gân đạt 0,7; c che phủ đã đạt 1 ở ngày thứ năm. J02 có thể được xét lại, không tự hoàn nửa việc còn lại. Trong nhánh không chèn W-B01, công việc có thể đủ hai giờ hữu ích nếu mọi điều kiện khác giữ nguyên; sau thời điểm chèn, hai nhánh được phép khác lịch và thu nhập.

Biến thể B-REMOTE tại D06 không có N03/vật tư sẵn cạnh P00. Không cho kết quả chăm sóc 09:10 như B-LOCAL; phải giải quyết tìm người, tuyến, nhận biết và quyền ở DL04. Biến thể cùng mốc: tác động ở 09:10 dùng trạng thái trước hiệu ứng chăm sóc vừa hoàn tất theo [[LIEN_KET_HE_THONG]], sau đó mới kích hoạt hiệu ứng còn hợp lệ. Không băng lại tay đã mất bằng sự kiện cũ.

## 10. Đối chiếu DL01–DL02

Ngày mẫu chỉ xét mệt: bắt đầu F = 0; ba giờ J01 tăng lên 24; hai giờ nghỉ giảm còn 12; ba giờ J01 tăng lên 36. Hai giờ đi mang đồ ≤ 10 kg tăng lên 44; tám giờ ngủ đủ hạ về 0. Sáu giờ hữu ích không bị giảm bởi ngưỡng F trong lịch này. Các giờ còn lại phải được DL04 xếp rõ, không ngầm lấp bằng công việc miễn thời gian.

P00 khỏe với 7,25 kg đồ vẫn đi 0,8 m/s khi H = 1. Nếu F = 70 thì H = 0,8, tải cho phép 12 kg và tốc độ 0,64 m/s. Thương tích W-B01 không tự giảm tốc độ chân, nhưng cấm tay trái cầm bình đầy; chuyển bình vào túi còn chỗ hoặc đổi tay là hành động thật.

Bốn ngày nghỉ tay trước khi đủ ngưỡng J01 có thể làm mất cơ hội nhận lô, dù ngân sách tổng của làng còn đủ. Không giữ bảng P00 tám việc/14 đồng như kết quả bắt buộc sau thương tích. Phải tính lại đơn việc, quyền nghiệm thu và tiền từng nhánh.

## 11. Các trường cần lưu và kiểm chứng

DL06 tại [[CHIEN_DAU_THU]] thêm W-E01/W-E02 là thương tích cùn thử. Quy trình W-B01 không áp cho chúng; lịch hồi phục riêng 48/120 giờ đủ điều kiện nằm tại [[CHAM_SOC_K0]].

Lưu phiên bản mẫu; nút/mô/ô tổn thương; c và phiên bản ô; thương tích/nguồn tác động; dịch còn và đích chuyển; F/S/E/W cùng phần lẻ; hàng chờ tiêu hóa/hấp thu; thời gian thiếu; giờ liền đủ điều kiện; vật chăm sóc; nhận biết và nguồn. Chức năng là giá trị suy ra có phiên bản, không phải một kho HP thứ hai.

| Mã | Kiểm chứng dự kiến | Kết quả cần đạt |
| --- | --- | --- |
| CB01 | W-B01 tay trái | G trái 0,4, G phải 1; không trừ chân vô cớ |
| CB02 | Bình đầy ở tay trái | 2,4 > 2 nên cần đổi cách mang |
| CB03 | B-LOCAL sau 10 phút | 18 g môi trường + 2 g trong V06 + 80 g còn; băng không hồi mô ngay |
| CB04 | Liền bốn ngày đủ điều kiện | G trái 0,6, không làm tròn sớm |
| CB05 | Thiếu điều kiện 12 giờ | Đồng hồ liền tạm dừng, không mất phần tích lũy cũ |
| CB06 | Hủy/tải lại chăm sóc | Không sinh băng hoặc chặn dịch trước mốc hoàn tất |
| CB07 | Mô mất trước sự kiện liền | Không tái sinh bằng lịch cũ |
| CB08 | F vượt 60 giữa việc | Đổi tốc độ từ đúng mốc, không hồi tố tiến độ |
| CB09 | Ăn món đã bị người khác lấy | Không tạo hàng chờ tiêu hóa |
| CB10 | Đổi tần suất giao diện | Không đổi liền vết, lượng dịch hoặc mệt |
| CB11 | NPC và P00 cùng trạng thái | Cùng kết quả chức năng/sinh lý |
| CB12 | B-REMOTE thiếu người chăm | Việc kẹt có nguyên nhân; không dùng kết quả B-LOCAL |
| CB13 | Chăm sóc và tác động cùng mốc | Tuân thứ tự pha, không bảo vệ hồi tố |
| CB14 | Hồi F nhưng còn thiếu E | Nhu cầu tiếp tục hạn chế H |

Đã đối chiếu các phép tính mẫu; chưa chạy các tình huống CB, chưa kiểm chứng sinh lý tổng thể hoặc cân bằng 30 ngày. Bước tiếp: DL04 — điều kiện/tiến độ công việc, lịch và quyết định NPC; ưu tiên giao nhận, phần việc J02 dở dang, tìm chăm sóc và ăn uống đúng thời điểm.
