---
aliases:
  - Tu luyện thử An Khê
  - DL05
tags:
  - thiet-ke
  - tu-luyen
status: de-xuat
---

# Tu luyện, linh lực và chuyển mốc thử — DL05

Ngày: 2026-09-05. Bổ sung [[TU_LUYEN]], [[CO_THE_THU]], [[VAT_THE_THU]], [[MOI_TRUONG]] và [[CONG_VIEC_THU]]. Tên, tuyến, lượng và ngưỡng dưới đây là đề xuất gameplay hư cấu để kiểm chứng bảo toàn; chưa phải hệ cảnh giới được chốt hoặc mô phỏng đã chạy.

## 1. Năm loại trạng thái không được gộp

| Trạng thái | Chủ quản | Ý nghĩa |
| --- | --- | --- |
| Linh khí D10 | Môi trường | Nguồn ngoài có lượng, sức chứa và dòng bổ sung |
| Năng lượng V27 | Vật phẩm | 50 L mỗi viên, chỉ giảm khi một cơ chế rút thật hoạt động |
| Linh lực cá thể P | Tu luyện | Lượng đã chuyển hóa đang chứa trong cơ thể |
| Năng lượng gắn cấu trúc B | Cơ thể/tu luyện | Phần đã trở thành trạng thái cấu trúc, không còn là P có thể tiêu ngay |
| Kiến thức/thích nghi | NPC và tu luyện | Khả năng hiểu, điều khiển và chịu tải; không phải năng lượng |

Mọi chuyển đổi dùng cùng đơn vị hư cấu L. Sổ giao dịch ghi nguồn, lượng rút, phần thành P/B/công dụng, phần trả lại và phần thất thoát. “Tiến thêm một bước” không tự sinh L; học lý thuyết không nạp P.

## 2. Mẫu cá thể trước chuyển mốc

Mẫu M0 có dung lượng P tối đa 12 L, lưu lượng tiếp nhận liên tục 6 L/giờ, lưu lượng xung tối đa 4 L/xung, và không tự tái tạo P. P khởi đầu bằng 0 trong INIT-A nếu cá thể không được khai báo khác. Kho cá thể không dùng số âm; phần nhận vượt dung lượng không được cộng rồi xóa im lặng.

Ba biến độc lập trong [0;1]: K là hiểu đúng phiên bản công pháp, C là điều khiển tuyến, A là thích nghi chịu tải của tuyến liên quan. Chúng có nguồn học/luyện và lịch sử riêng. Một người có K cao vẫn có thể thiếu C; P đầy không làm A tăng miễn phí.

Mạng thử gồm năm nút: cửa tiếp nhận N0, bộ lọc N1, trục dẫn N2, kho chứa N3 và đường phát/hoàn N4. Mỗi cạnh có mức nguyên vẹn I, ban đầu 1. Lưu lượng khả dụng bằng giới hạn yếu nhất trên đúng tuyến nhân C và I; không lấy trung bình để che một đoạn hỏng.

N13 biết ba mẫu ở K = 0,9; C/A cụ thể chỉ được khai báo trong từng tình huống. N14 khởi tạo biết Tĩnh Lưu; N15 biết Liệt Mạch theo [[DU_LIEU_KHOI_DAU]]. Biết tên không tự đạt ngưỡng thực hành. P00 sau một J05 hợp lệ chỉ nhận hồ sơ kiến thức do bài học quy định; bài học cơ bản đề xuất tăng K Tĩnh Lưu từ 0 lên 0,35, vẫn dưới ngưỡng tự luyện 0,6.

## 3. Một phiên Tĩnh Lưu Dưỡng Nguyên — TL-A

Điều kiện bắt đầu: K ≥ 0,6; C ≥ 0,5; A tuyến N0→N1→N2→N3 ≥ 0,4; tập trung ≥ 0,7; P còn chỗ; chủ thể ở D10 hoặc nối với nguồn hợp lệ; có quyền dùng nguồn. Tay không phải nút bắt buộc, nên W-B01 không tự cắt tuyến; đau vẫn có thể hạ tập trung qua DL03.

Pha chuẩn: chuẩn bị 10 phút; tiếp nhận liên tục 60 phút; thu công 10 phút. Trong pha tiếp nhận, yêu cầu tối đa 6 L/giờ nhưng bị giới hạn bởi nguồn, phần trống của P và tuyến. Mỗi lượng thật rút được chuyển 80% thành P, 20% thành thất thoát tại D10. Không rút phần chắc chắn không chứa được.

Một phiên đủ nguồn, P đầu 0: D10 −6 L; P +4,8 L; thất thoát +1,2 L. Nếu P đầu 10 L, chỉ cần rút 2,5 L để tạo 2 L P và 0,5 L thất thoát; không hút đủ 6 L rồi vứt 2,8 L vì kho đầy.

Chu kỳ thu công mỗi 10 phút của pha tiếp nhận giữ phần P đã tạo. Ngắt ở ranh chu kỳ dừng sạch trong 10 phút; buộc ngắt giữa chu kỳ giữ lượng đã chuyển, tạo sai lệch điều khiển D = lượng đã rút trong chu kỳ × (1 − C). D là tải cần ổn định, không tự trở thành P. Hậu quả cơ thể theo ngưỡng D chưa định ngoài tình huống thử, nên không được kể thành “tẩu hỏa” tùy ý.

Mỗi phiên có ít nhất 3 L thật đi qua đúng tuyến và thu công hợp lệ tạo 0,01 kinh nghiệm điều khiển cùng 0,005 thích nghi, chặn C/A ở 1. K không tự tăng từ việc lặp sai. Một ngày tối đa một lần nhận tăng A từ TL-A; luyện thêm vẫn có thể chuyển năng lượng nhưng không cày thích nghi vô hạn.

## 4. Một phiên Liệt Mạch Hành Công — LM-B

Liệt Mạch dùng tuyến N0→N2→N3, bỏ qua bộ lọc N1. Điều kiện: K ≥ 0,75; C ≥ 0,7; A tuyến ≥ 0,7; tập trung ≥ 0,85; P ≤ 3,6 L để còn chỗ; không có tải sai lệch D đang hoạt động.

Pha chuẩn: chuẩn bị 15 phút; ba xung, mỗi xung rút tối đa 4 L trong hai phút và có tám phút ổn định sau xung; thu công 15 phút. Tổng phiên 60 phút, tổng yêu cầu tối đa 12 L. Mỗi xung chuyển 70% thành P, 20% thành tải rèn R trên tuyến, 10% thất thoát. Sau tám phút ổn định, 75% R của xung trở thành B thích nghi, 25% tản thành thất thoát; R chưa ổn định vẫn gây tải thật.

Với nhánh ba xung đủ lượng, đặt C = 1 và I yếu nhất = 1: nguồn −12 L; P +8,4 L; B +1,8 L; thất thoát 1,8 L. Tổng 12 = 8,4 + 1,8 + 1,8. Nếu C/I thấp hơn, lượng rút và mọi đầu ra giảm theo lượng thật. B là số năng lượng gắn cấu trúc tích lũy trong tình huống, không phải điểm A; thay đổi A chỉ xảy ra khi kết thúc phiên an toàn.

Nếu một xung thật vượt min(4 L, 4 L × C × I yếu nhất), phần vượt khả năng không được rút trong thao tác đúng. Một văn bản sai hoặc người cố ép có thể yêu cầu vượt, nhưng cần tình huống riêng chuyển phần quá tải vào tổn thương tuyến. Bộ DL05 chỉ kiểm chứng: mất tập trung trước khi R ổn định khiến toàn bộ R còn lại thành tải sai lệch D, không cộng vào B/P lần nữa.

Phiên đủ ba xung, không còn R/D, thu công hợp lệ: C +0,015 và A +0,015, tối đa một lần/ngày. Liệt Mạch tạo B và thích nghi nhanh hơn Tĩnh Lưu, đổi lại đòi nguồn dày, C/A cao và điểm ngắt nguy hiểm hơn. Người mới không dùng nó chỉ vì có nhiều linh khí.

## 5. Một lần Hồi Hoàn Dẫn Lực — HH-C

Hồi Hoàn không phải cách hút nguồn môi trường. Nó gắn vào một ứng dụng đã biết qua tuyến N3→N4→đích→N4→N3. Điều kiện: K ≥ 0,7; C ≥ 0,75; ứng dụng có năng lượng hồi lưu được khai báo; P đủ trả đầu vào; tập trung ≥ 0,8.

Mẫu thử lấy 4 L từ P. 2,4 L tạo công dụng ở đích, 0,8 L quay lại P, 0,8 L thất thoát. Sổ nhìn theo giao dịch: P −4 rồi P +0,8; mức giảm ròng 3,2 L. Phần 2,4 L đã tạo công dụng không còn để thu lại; 0,8 L thất thoát cũng không được gọi lại ở vòng sau.

Nếu lặp từ P = 12 L và mỗi vòng cần đủ 4 L, ba vòng hợp lệ để lại 2,4 L: 12 → 8,8 → 5,6 → 2,4. Vòng thứ tư không bắt đầu. Công dụng tích lũy 7,2 L, thất thoát 2,4 L và P còn 2,4 L; tổng vẫn 12 L.

Hồi Hoàn tăng C +0,005 sau một lần hoàn chỉnh có ít nhất 0,5 L thật quay về, tối đa hai lần/ngày. Nó không tăng dung lượng hoặc A tuyến tiếp nhận. Một ứng dụng không khai báo phần hồi lưu nhận 0 L, dù người dùng biết tên công pháp.

## 6. Chia nguồn ở INIT-D

INIT-D khởi tạo N13 và N14 với K = 0,9, C = 1, A = 0,8, mọi cạnh cần thiết I = 1 và P = 0; cả hai bắt đầu pha tiếp nhận lúc 09:00. D10 được thay bằng biến thể 6 L, dòng bổ sung tắt đúng bài thử. Hai người cùng có khả năng/yêu cầu 6 L trong giờ đó và có quyền ngang nhau. C = 1 là điều kiện của phép đối chiếu đủ lưu lượng, không phải thông số thường trực của hai NPC trong INIT-A.

Tại mỗi khoảng phân bổ, nguồn chia theo tỷ lệ yêu cầu hợp lệ; ở đây mỗi người nhận 3 L. Mỗi người tạo P +2,4 L và thất thoát 0,6 L. Tổng: D10 6 → 0; P hai người 4,8 L; thất thoát 1,2 L. Nguồn cạn đánh thức hai hành động, nhưng mỗi người chỉ biết dấu hiệu do khả năng cảm nhận của mình; không tự biết P của người kia.

Nếu N14 rời sau nửa giờ bằng thu công hợp lệ, phải tích phân nửa giờ đầu trước: mỗi người rút 1,5 L. Nửa giờ sau N13 có thể rút phần 3 L còn lại nếu còn chỗ và hành động tiếp tục. Kết quả: N13 rút 4,5 L → P 3,6; N14 rút 1,5 L → P 1,2; thất thoát chung 1,2. Rời đi không làm lượng chưa dùng của N14 biến mất hoặc tự chuyển thành của N13 trước mốc rời.

## 7. Linh thạch V27

Một V27 giữ 50 L và nặng 200 g cả khi cạn theo [[VAT_THE_THU]]. Để cấp cho công pháp, viên phải có quyền sử dụng, ở cùng thiết bị/người và dùng một thao tác nối nguồn năm phút. Mẫu nối giới hạn 4 L/giờ liên tục; vì thế một viên không cấp đủ TL-A ở 6 L/giờ hoặc các xung LM-B nếu không có bộ nối khác.

TL-A dùng một V27 qua nối mẫu trong một giờ rút tối đa 4 L → P +3,2 L, thất thoát 0,8 L, viên còn 46 L. Không đồng thời trừ D10. Hai công pháp không được cùng giữ toàn bộ lưu lượng một viên; phân bổ dùng cùng quy tắc nguồn chung.

Kho O03 có bốn viên, nhưng N14/N15 không tự có quyền dùng. N16 cấp theo quyền và mục đích; việc trả lại viên cạn không hoàn 50 L. Phá viên để rút nhanh chưa có quy trình, nên chưa phải phương án hợp lệ.

## 8. Học, lịch và quyền tự luyện

J05 hai giờ gồm 60 phút nguyên lý, 40 phút diễn tập không hút nguồn và 20 phút hỏi/đánh giá. Khi hoàn tất, học viên nhận tối đa +0,35 K cho đúng phiên bản được dạy; C +0,05 nếu thực hiện đủ diễn tập và người dạy quan sát. K/C chặn ở 1. Không tạo P, A hoặc B.

Mỗi phiên luyện là một hành động có vị trí, chú ý và lịch. TL-A chiếm chú ý 80 khi tiếp nhận; LM-B 100 trong xung và 80 khi ổn định; HH-C 100 trong thao tác. Không vừa học, ngủ, làm J01 hoặc vận hành công pháp khác. Đi D09→D10 dài 1.200 m mỗi chiều; thời gian đi và tải theo DL02/DL03, không nằm miễn phí trong giờ luyện.

N14 đề xuất ưu tiên TL-A khi nguồn sống, lịch học và quyền D10 đều ổn. N15 muốn LM-B nhưng thiếu điều kiện nào thì chuyển sang hỏi, diễn tập khô hoặc chuẩn bị; mục tiêu thử nghiệm không cho phép ép tuyến. P00 sau một bài J05 vẫn chưa tự luyện; cần học/diễn tập thêm hoặc một truyền thừa khác thật sự nâng đủ điều kiện.

Quyền tự bắt đầu chuyển mốc phụ thuộc lựa chọn trải nghiệm chưa chốt. Trong dữ liệu thử, không nhân vật nào tự chuyển mốc chỉ vì thanh điều kiện đầy; hành động phải được khởi tạo rõ trong bản kiểm chứng.

## 9. Chuyển mốc M0→M1 trong bản lưu TM-01

TM-01 là trạng thái kiểm chứng được khai báo gần mốc, không phải kết quả 30 ngày INIT-A. Chủ thể N14 có P = 10 L, B = 8 L đã tích lũy từ lịch sử giả lập được đánh dấu khởi tạo, K/C/A Tĩnh Lưu lần lượt 0,9/0,85/0,85; mọi cạnh tuyến cần thiết I = 1; F < 40, E/W dương. D10 có ít nhất 8 L được giữ cho quá trình và quyền đã duyệt.

Kết quả M1 đề xuất: dung lượng P tăng 12→20 L, lưu lượng liên tục 6→8 L/giờ và mở khả năng duy trì một lớp linh lực mỏng trong khi thực hiện việc nhẹ. Đây là mốc chức năng thử, chưa mang tên cảnh giới chính thức và không trao tuổi thọ/thần thông khác.

| Pha | Thời gian | Chuyển lượng và điểm cam kết |
| --- | ---: | --- |
| Đánh giá/chuẩn bị | 60 phút | Chưa tiêu; giữ 8 L D10 và nơi; có thể hủy sạch |
| Khởi động | 30 phút | P 10→8; 2 L chuyển vào cấu trúc đang đổi; cuối pha là điểm cam kết |
| Chuyển cấu trúc | 60 phút | D10 −8 L; P 8→4; tổng 12 L này thành 6 L B mới và 6 L thất thoát |
| Ổn định | 60 phút | 8 L B cũ + 8 L B mới được khóa thành cấu trúc M1; P còn 4 L |
| Hậu kiểm | 30 phút | Không chuyển lượng; xác nhận khả năng theo phép kiểm tra biết được |

Đối chiếu toàn quá trình: đầu vào P 6 L + D10 8 L + B cũ 8 L = cấu trúc M1 giữ 16 L + thất thoát 6 L. P ban đầu 10 còn 4 nên chỉ 6 L P là đầu vào. Tổng 22 = 16 + 6. “Khóa B” đổi trạng thái sử dụng, không tạo thêm năng lượng.

Nếu bị ngắt trước điểm cam kết, trả giữ chỗ D10 và P đã chuyển trong pha khởi động quay về P trừ 0,2 L thất thoát thao tác; quy tắc hoàn lại này là cơ chế của pha, không quay ngược thời gian. Sau điểm cam kết, không tự hoàn nguyên. Ngắt giữa chuyển cấu trúc cần tính lượng đã chuyển tới mốc; phần đã thành B mới giữ, phần đang tải trở thành D và phải ổn định bằng tình huống riêng. Không bốc “thành công/thất bại” lại khi tải game.

Nhánh chuẩn chỉ đạt M1 khi hoàn tất ổn định, các điều kiện duy trì không mất và không có biến cố chèn. Một trạng thái gần mốc không bảo đảm thành công trong chơi thường; người hỗ trợ, nguồn và thế giới vẫn có thể thay đổi.

## 10. Tổn thương và tương thích

W-B01 nằm ở bàn tay, không thuộc tuyến TL-A/LM-B trong mẫu; nó ảnh hưởng công pháp qua đau/tập trung nếu có. Không áp cả phạt tay lẫn phạt tuyến cho cùng vết thương. Tổn thương N2 mới trực tiếp giảm lưu lượng của cả TL-A và LM-B; HH-C chỉ chịu nếu đường N3/N4 liên quan bị ảnh hưởng.

Năng lượng do TL-A tạo có chuẩn thành phần “tĩnh đã lọc”. LM-B bỏ N1 nên tạo thành phần “thô xung”; trong DL05, hai thành phần cùng nằm trong P nhưng không tự đồng nhất. TM-01 chỉ dùng phần tĩnh đã lọc. HH-C hoàn lại đúng thành phần đầu vào; không biến thô thành tĩnh miễn phí.

Kiêm tu cần quy trình xử lý thành phần và tải tuyến. Chưa có quy tắc đó nên N15 biết Liệt Mạch không tự dùng Tĩnh Lưu, N14 không tự dùng Hồi Hoàn, và P00 không phối hợp cả ba từ tên trên tờ giấy.

## 11. Tình huống kiểm chứng khi triển khai

| Mã | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| LT01 | TL-A đủ nguồn, P = 0 | Nguồn −6; P +4,8; thất thoát 1,2 |
| LT02 | TL-A khi P = 10 | Chỉ rút 2,5; P đạt 12; thất thoát 0,5 |
| LT03 | INIT-D hai người | Tổng rút 6, tổng P 4,8, thất thoát 1,2 |
| LT04 | Một người rời sau 30 phút | P N13/N14 là 3,6/1,2; nguồn về 0 |
| LT05 | LM-B ba xung | 12 = 8,4 P + 1,8 B + 1,8 thất thoát |
| LT06 | Ngắt trước ổn định xung | R còn chuyển D, không cộng lần hai vào B |
| LT07 | HH-C ba vòng từ P = 12 | P còn 2,4; công dụng 7,2; thất thoát 2,4 |
| LT08 | HH-C với ứng dụng không hồi lưu | Không tạo năng lượng hoàn lại |
| LT09 | TL-A dùng V27 một giờ | Viên 50→46; P +3,2; thất thoát 0,8 |
| LT10 | P00 chỉ học một J05 | K tối đa 0,35; không tự đủ điều kiện luyện |
| LT11 | W-B01 không chạm tuyến | Không giảm lưu lượng trực tiếp; tập trung có thể đổi qua đau |
| LT12 | N2 bị hỏng | TL-A và LM-B giảm theo điểm yếu; HH-C chỉ đổi nếu tuyến phụ thuộc |
| LT13 | TM-01 hoàn tất | P còn 4; cấu trúc giữ 16; thất thoát 6; mở đúng khả năng M1 |
| LT14 | Ngắt TM-01 sau cam kết | Giữ lượng đã chuyển và D; không reset về M0 nguyên vẹn |
| LT15 | Hai việc giữ cùng V27 | Chỉ một phân bổ hợp lệ; không mỗi việc rút 4 L/giờ |
| LT16 | Lưu/tải giữa chu kỳ | Không rút, tăng K/C/A/B hoặc hoàn pha lần hai |

Đã đối chiếu số học các nhánh trên giấy. Chưa chạy LT, chưa có công thức tổn thương kinh mạch, độ tinh khiết nhiều thành phần, tuổi thọ, linh căn, hiệu ứng chiến đấu hoặc hệ cảnh giới dài hạn.

## 12. Bước tiếp theo

DL06 đã được cụ thể tại [[CHIEN_DAU_THU]], gồm E-LINH dùng đúng sổ HH-C. Ứng dụng này chỉ là dữ liệu kiểm chứng, không mở thuật cho INIT-A. Bước mới nhất theo STATE là rà soát chéo sáu gói.

DL06 sẽ định lượng vị trí, pha, tiếp xúc, phòng hộ và tác động cho chuỗi E; có thể dùng P và HH-C làm nguồn tiêu hao nhưng không tự phát minh thuật chiến đấu ngoài hồ sơ. Sau DL06 cần rà soát lại sáu gói dữ liệu, các lựa chọn TN và phần còn thiếu trước khi người dùng quyết định chuyển sang triển khai.
