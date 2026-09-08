---
aliases: [Dữ liệu khởi đầu thung lũng]
tags: [thiet-ke, du-lieu, choi-thu]
status: de-xuat
updated: 2026-09-05
---

# Dữ liệu khởi đầu — thung lũng An Khê, bản 0.1

Liên quan: [[BAN_CHOI_THU]] · [[LIEN_KET_HE_THONG]] · [[MASTER_PLAN]] · [[DECISIONS]].

> Tên, dân số, lượng và giá bên dưới là bộ dữ liệu hư cấu đề xuất để kiểm chứng. Không phải cân bằng cuối, thông số sinh học thật hoặc thế giới đã được tạo trong game. Đây là danh mục bằng Markdown, chưa là dữ liệu máy có thể chạy.

## 1. Mốc và quy ước

Mốc đầu: ngày 1, 06:00; quan sát 30 ngày. Ngày thử có 24 giờ, chưa chốt lịch năm. Tốc độ mặc định theo yêu cầu: 5 giây/ngày.

| Đại lượng | Đơn vị tạm | Quy tắc |
| --- | --- | --- |
| Thời gian | Giây game; lưu có thể dùng mili giây | Thời lượng phải ghi đơn vị |
| Khoảng cách | Mét | Đường hai chiều có chiều dài một lượt |
| Tiền | Đồng thử, số nguyên | Là tiền vật chất theo lô, không thêm ví sao chép |
| Vật rời | Cái/tờ/viên | Không chia nhỏ nếu mẫu không cho phép |
| Nguyên liệu | Gam; nước tính mililít | Quy đổi khi chuyển hệ phải khai báo |
| Thức ăn thử | Suất khô 500 g | Định mức kiểm chứng, không là khẩu phần thực tế |
| Linh khí | Đơn vị L | Đơn vị hư cấu, không quy ra năng lượng thực |
| Năng suất | Lượng trên giờ thao tác hữu ích | Chưa gồm đi lại, nghỉ hoặc lấy dụng cụ |

Mọi nguồn ban đầu mang nhãn INIT-01. Bổ sung ngoài vùng chỉ được dùng khi có hồ sơ nhập rõ; dữ liệu này không mặc định nguồn nhập vô hạn.

## 2. Địa điểm và đường nối

| Mã | Tên | Chức năng ban đầu |
| --- | --- | --- |
| D01 | Sân chợ An Khê | Giao dịch và đầu mối đường |
| D02 | Khu nhà ở | Các phòng riêng, nơi ngủ và kho hộ |
| D03 | Y quán của An | Kho thuốc, ca khám |
| D04 | Xưởng Mộc | Cắt vải, sửa dụng cụ |
| D05 | Ruộng chung | Nguồn sinh khối lương thực theo lô |
| D06 | Bãi thuốc đông | Cây thuốc theo giai đoạn |
| D07 | Bến cầu tây | Điểm đổi tuyến, kho hàng chờ |
| D08 | Cầu qua suối | Địa điểm tuyến có thể bị chặn |
| D09 | Trạm học Thanh Lưu | Người dạy, kho tổ chức |
| D10 | Hang Tĩnh Lưu | Nguồn linh khí hữu hạn |
| D11 | Bờ suối | Lấy nước, không tự chứa nước đã lấy trong bình |

Đường hai chiều: D01–D02 200 m; D01–D03 150 m; D01–D04 180 m; D01–D05 800 m; D01–D07 600 m; D07–D08 100 m; D08–D06 500 m; D01–D09 300 m; D09–D10 1.200 m; D01–D11 250 m. Đường vòng D07–D06 dài 2.000 m, không đi qua D08.

Tốc độ tham chiếu cho thử hành trình: 1 m/giây khi không tải và không suy giảm. Đây là hệ số game tạm. D07 tới D06 qua cầu mất 600 giây; đi vòng mất 2.000 giây trước các điều chỉnh. Cầu hỏng không xóa người/hàng đang ở D07 hoặc trên tuyến.

## 3. Hai mươi NPC và nhân vật người chơi

Tuổi dưới đây chỉ dùng tạo quan hệ hợp lý; tất cả là người trưởng thành. Tên người chơi là tên tạm, có thể đổi. Mỗi người có một mã, không sinh người mới khi đổi nghề.

| Mã | Tên, tuổi | Vai trò và nơi bắt đầu | Mục tiêu riêng ban đầu |
| --- | --- | --- | --- |
| P00 | Khách lữ hành, 22 | Người chơi, D02 | Kiếm sống, tìm cơ hội học |
| N01 | Lâm, 31 | Hái thuốc, D02 | Tích tiền sửa mái nhà cùng Mai |
| N02 | Mai, 29 | Làm vải, D02 | Hoàn đơn băng, giữ dự trữ hộ |
| N03 | An, 47 | Thầy thuốc, D03 | Giữ kho phục vụ và thu nợ đúng hẹn |
| N04 | Liên, 24 | Học việc y quán, D03 | Học khám, không nhận ca vượt khả năng |
| N05 | Bình, 34 | Vận chuyển, D07 | Giao hàng, dành tiền thay bánh xe |
| N06 | Hòa, 30 | Buôn hàng, D01 | Bán tồn, giữ vốn mua lô tiếp |
| N07 | Mộc, 52 | Thợ xưởng, D04 | Sửa dụng cụ, dạy Thu |
| N08 | Thu, 21 | Học việc xưởng, D04 | Hoàn thao tác cắt và lắp cán |
| N09 | Sơn, 39 | Trồng trọt, D05 | Thu hoạch đúng lô đã chín |
| N10 | Cúc, 37 | Trồng trọt, D05 | Giữ nguồn giống cho kỳ sau |
| N11 | Đạt, 26 | Lao động ruộng, D05 | Nhận công, tiết kiệm học phí |
| N12 | Nga, 28 | Phụ trách kho ruộng, D05 | Cân lượng, tránh cấp trùng |
| N13 | Vân, 43 | Người dạy, D09 | Dạy đúng lịch và duy trì nguồn học |
| N14 | Kha, 25 | Người học, D09 | Ổn định Tĩnh Lưu, tránh tăng tải sớm |
| N15 | Tùng, 27 | Người học, D09 | Nghiên cứu Liệt Mạch, kiếm nguồn hỗ trợ |
| N16 | Yến, 36 | Giữ kho trạm học, D09 | Cấp theo quyền và ghi nhận đủ |
| N17 | Dũng, 33 | Hộ tống, D07 | Nhận việc vừa sức, giữ cam kết |
| N18 | Tâm, 45 | Trông cầu, D08 | Kiểm tra đường, tìm vật tư khi hỏng |
| N19 | Phúc, 41 | Bếp và phòng trọ, D02 | Duy trì thực phẩm và phòng sạch |
| N20 | Huệ, 23 | Đưa tin/làm vườn, D01 | Giao tin khi nhận việc, học chăm cây |

Lịch sử, quan hệ có hướng, tri thức, mục tiêu dài hạn và thông tin riêng tư của N01–N20 được đề xuất tại [[HO_SO_NPC_AN_KHE_K1]]. Quy tắc công nhận hộ, cư trú, học việc, quyền tổ chức và tranh chấp nằm tại [[VAN_HOA_THE_CHE_AN_KHE_K1]]. Các tài liệu đó không thêm tài sản hay khóa tương lai của họ.

Quan hệ đầu: N01–N02 là vợ chồng; N09–N10 là vợ chồng; N07 dạy N08; N03 dạy N04; N13 dạy N14/N15. Những quan hệ còn lại chỉ quen biết qua nghề hoặc chưa biết; không tự đặt thiện cảm đối xứng.

Các nhóm tài sản: H01=N01/N02; H02=N09/N10/N11/N12 hợp tác ruộng; O01=y quán; O02=xưởng; O03=trạm học; O04=quầy Hòa; O05=bếp/phòng trọ; O06=quỹ đường. Nhóm hợp tác ruộng không đồng nghĩa cả bốn cùng gia đình.

## 4. Khác biệt và hiểu biết ban đầu

N01 thận trọng với thương tích nhưng coi trọng việc trả nợ; N02 ưu tiên nguồn sống ổn định; N03 giúp người trong khả năng kho; N05 coi trọng đúng hẹn; N06 cần vốn quay vòng; N14 kiên trì và N15 thích thử nghiệm. K1.10 đã cụ thể hóa thành đề xuất tại [[TAM_LY_21_NGUOI_K1]] mà không biến chúng thành kịch bản.

P00 biết D01/D02, đường giữa hai nơi, công dụng thức ăn/nước và cách hỏi việc; chưa biết vị trí D10 hoặc công pháp. Người địa phương biết tuyến phục vụ nghề của mình, không tự biết mọi kho hoặc kỹ năng khác. Ma trận nghe/nói/đọc/viết/tính và thuật ngữ ngày 1 nằm tại [[NANG_LUC_NGON_NGU_TRI_THUC_K1]].

N13 biết ba mẫu TU_LUYEN ở mức truyền dạy cơ bản. N14 biết Tĩnh Lưu; N15 biết Liệt Mạch, chưa mặc định đủ khả năng dùng an toàn. Các trường hợp đột phá dùng trạng thái thử riêng.

Mọi người khởi đầu không có thương tích hoạt động; Chuỗi B dùng biến cố chèn riêng. Cơ thể khỏe mặc định vẫn cần ngủ/ăn/nước theo các hệ số thử ở mục 9.

## 5. Danh mục 36 loại vật phẩm

Danh mục định nghĩa loại và công dụng, không đồng nghĩa tất cả đều đã có vật thể ở mốc đầu. Vật không nằm trong tồn kho bên dưới có lượng khởi đầu bằng 0.

| Mã | Loại | Đơn vị | Công dụng trong bản thử |
| --- | --- | --- | --- |
| V01 | Đồng thử | Đồng | Thanh toán |
| V02 | Suất lương khô | Suất 500 g | Nguồn sống thử |
| V03 | Nước chứa | ml | Uống, dùng trong quy trình |
| V04 | Vải nguyên | g | Làm băng/miếng vá |
| V05 | Băng vải sạch | Cái 100 g | Vật chăm sóc trong CO_THE |
| V06 | Băng đã dùng | Cái | Giữ trạng thái sau tháo |
| V07 | Dao hái | Cái | Thu hoạch/cắt vật mềm |
| V08 | Lưỡi dao rời | Cái | Lắp/sửa dụng cụ |
| V09 | Cán gỗ | Cái | Thay cán |
| V10 | Gỗ phôi | g | Tạo bộ phận/sửa công trình |
| V11 | Phế gỗ | g | Phụ phẩm, nhiên liệu nếu có quy trình |
| V12 | Bình nước | Cái | Chứa tối đa 2.000 ml trong mẫu thử |
| V13 | Túi vải | Cái | Chứa đồ, tải thử 10 kg |
| V14 | Thanh diệp tươi | Phần 100 g | Nguyên liệu dịch vụ hư cấu |
| V15 | Thanh diệp khô | Phần | Sản phẩm quá trình bảo quản chưa định lượng |
| V16 | Gói hỗ trợ hồi phục | Gói | Hiệu ứng thử cần mô hình cơ thể, không liều thực |
| V17 | Đá mài | Cái | Bảo dưỡng cạnh dụng cụ |
| V18 | Kim khâu | Cái | Gia công vải |
| V19 | Chỉ | g | May/sửa |
| V20 | Áo vải | Cái | Trang phục |
| V21 | Giày vải | Đôi | Trang bị chân |
| V22 | Cuốc | Cái | Việc ruộng |
| V23 | Xe kéo | Cái | Vận chuyển, tải thử 100 kg |
| V24 | Bánh xe | Cái | Bộ phận sửa xe |
| V25 | Dây buộc | m | Giữ kiện, gia công |
| V26 | Tờ ghi công pháp | Tờ | Mang tri thức |
| V27 | Linh thạch thử | Viên | Giữ lượng L có thể rút |
| V28 | Đệm ngồi | Cái | Dụng cụ phiên luyện |
| V29 | Kiếm gỗ tập | Cái | Tình huống luyện/tiếp xúc thử |
| V30 | Tấm phòng hộ thử | Cái | Kiểm tra che phủ/tác động |
| V31 | Mảnh vật liệu hỏng | g | Đích phụ phẩm |
| V32 | Dấu kỷ niệm | Cái | Vật P00 cấm bán |
| V33 | Hộp tiền gỗ | Cái | Chứa V01 vật lý; không phải số dư thứ hai |
| V34 | Tờ ghi việc | Tờ | Mang thông báo, biên nhận hoặc mục ghi rời |
| V35 | Sổ đóng gáy | Cuốn | Giữ các mục có trang/thứ tự và lịch sử sửa |
| V36 | Bộ viết | Bộ | Bút, mực và hộp; ghi làm chuyển mực thật |

Mẫu V07 có bộ phận lưỡi và cán. Các V08/V09 nằm trong V07 không đồng thời được tính là hàng rời trong kho. V23 cũng không cấp thêm V24 rời nếu bánh đang thuộc xe.

## 6. Tiền khởi đầu: tổng 2.000 đồng

P00: 40; H01: 160; H02: 240; O01: 300; O02: 180; O03: 400; O04: 400; O05: 200; O06: 80. Vị trí và vật chứa vật lý của toàn bộ tiền được chỉ rõ tại [[DU_LIEU_LIEN_KET_K0]]. Các số này là tổng hợp quyền sở hữu, không phải tiền sổ tồn tại song song. Cá nhân còn lại không có ví riêng ngoài quyền nhận công hoặc khoản được nhóm giao.

Các nhóm phải ghi ai có quyền chi: H01 hai người; H02 N12 trong hạn kế hoạch; O01 N03; O02 N07; O03 N16 tối đa 20 đồng/giao dịch thường, N13 duyệt phần lớn hơn; O04 N06; O05 N19; O06 N18 tối đa 20 đồng, phần còn lại cần quyết định thể chế chưa chốt.

Khoản nợ C01: H01 nợ O01 12 đồng, đến ngày 10 lúc 18:00, không lãi trong tình huống này. Đây là nghĩa vụ khởi tạo, không cộng 12 tiền mặt vào bất kỳ ví nào. P00 giữ 10/40 đồng làm dự phòng theo mục tiêu mẫu.

## 7. Tồn kho đầu và quyền dùng

| Chủ | Nơi | Tồn kho ngoài tiền |
| --- | --- | --- |
| P00 | D02, mang trên người | 6 V02; 1 V12 chứa 2.000 ml V03; 1 V13; 1 V20; 1 V21; 1 V32 |
| H01 | D02 | 40 V02; 4.000 g V04; 2 V07; 2 V12 rỗng; 1 V18; 200 g V19 |
| H02 | D05 | 120 V02; 4 V22; 4 V12 rỗng; 1 V35; 1 V36 |
| O01 | D03 | 30 V02; 20 V05; 20 phần V14; 2 V12 rỗng; 5 V34; 1 V35; 1 V36 |
| O02 | D04 | 40 V02; 20.000 g V10; 4 V08 rời; 6 V09 rời; 2 V17; 1 V18; 500 g V19 |
| O03 | D09 | 80 V02; 3 V26 (mỗi mẫu một bản); 4 V27 mỗi viên 50 L; 3 V28; 2 V29; 1 V30; 4 V34; 1 V35; 1 V36 |
| O03 | D01 | 1 V34-O03-01 đã viết ở khe 1 khung tin; N06 giữ vị trí, không sở hữu hay tự sửa |
| O04 | D01 | 100 V02; 4 V12 rỗng; 4 V13; 2 V07; 1 V23; 20 m V25; 5 V34; 1 V35; 1 V36 |
| O05 | D02 | 84 V02; 8 V12 rỗng; 3 V34; 1 V35; 1 V36 |
| O06 | D08 | 2 V34 ngoài tiền |
| AK-COMMON | D01 | 10 V34; 1 V35-AK-PUB; 1 V36-AK; khung F-D01-NOTICE-RACK cố định 8.000 g; N06 giữ vật nhưng không sở hữu |
| AK-COMMON | D08 | 1 V35-O06; 1 V36-O06; N18 giữ vật nhưng không sở hữu |

Tổng V02: 500 suất. Mỗi nhóm H01–O06 có một V33 tại nơi ghi trong [[DU_LIEU_LIEN_KET_K0]]; tám hộp này chứa đúng tiền của nhóm và không cộng thêm V01. K1.8 thêm đúng 30 V34, 7 V35 và 7 V36, tổng 3.100 g, với id/vị trí tại [[SO_THE_CHE_30_NGAY_K1]]. Mỗi N01–N20 còn có đúng 1 V20, 1 V21 cá nhân đang đeo; không có phần thức ăn cá nhân cộng thêm ngoài bảng. Không mặc định mọi người có túi/bình riêng; dùng bình chung qua hành động và lịch.

Những vật nhiều khả năng cần kích thước/khối lượng chưa được ghi ở đây phải có bảng mẫu trước khi mô phỏng tải đầy đủ; không tự cho khối lượng 0. Nơi làm/nhà là địa điểm ban đầu, chưa được coi là bộ công trình đã mô phỏng vật liệu chi tiết.

## 8. Nguồn môi trường có lượng cụ thể

Nước D11: kho thử 200.000 ml lúc đầu, giới hạn kho tiếp cận 300.000 ml, đầu vào ngoài phạm vi 100.000 ml/ngày phân bố đều. Phần vượt kho đi ra đích hạ lưu đã khai báo. Khả năng vận chuyển/lấy nước vẫn giới hạn sử dụng; đây chưa là thủy văn toàn lưu vực.

D05 có lô cây lương thực khởi tạo đủ 600 suất thu được, gồm 20 lô con × 30 suất, một lô bắt đầu sẵn và các lô sau đạt mốc thu theo ngày 2–20 trong điều kiện thử không đổi. Đây là sinh khối ban đầu theo giai đoạn, không nguồn sinh vô hạn; khối lượng phần ăn được 300.000 g, phần cây khác chưa định lượng. Chưa có vụ mới sau 20 lô nếu chưa triển khai sinh trưởng/giống.

D06 có 80 phần V14 có thể thu ban đầu; lô cây tương ứng giảm khi thu. Chưa thêm tái sinh trong bài thử bảo toàn này. Không mặc định cả nguồn thuộc người thu; đề xuất cho phép thu công cộng trong tập thử, chưa chốt luật thế giới.

D10: 120 L lúc đầu; khả năng chứa 240 L; nguồn bổ sung ngoài phạm vi 12 L/ngày phân bố đều. Chưa có cây/thú hút nguồn này trong bài thử D; khi thêm phải đăng ký chung sổ nguồn.

## 9. Ngân sách duy trì và giới hạn của phép tính

Định mức thử đơn giản: mỗi người dùng 1 V02 và 2.000 ml nước/ngày; cần 8 giờ ngủ, tối đa 6 giờ thao tác lao động thường/ngày trước điều chỉnh mệt. Đây là hệ số thiết kế tạm, không kết luận về nhu cầu con người thực.

21 người × 30 ngày cần 630 suất và 1.260.000 ml nước. Kho 500 suất chỉ đủ khoảng 23,81 ngày nếu chia đều, không hỏng và không sản xuất. Nguồn ruộng có khả năng thêm 600 suất nếu được thu đúng; không có lao động thì không tính vào kho ăn được. Nước đầu vào 30 ngày cộng kho đầu là 3.200.000 ml trước tràn/hao khác.

Đủ lượng toàn vùng chưa chứng minh mọi người được ăn/uống: quyền tiếp cận, tiền, di chuyển, chia nguồn và lịch phải được kiểm tra bằng mô phỏng. Những tổng này chỉ phát hiện thiếu nguồn hiển nhiên.

Đề xuất O05 cấp bữa ở mức định giá cho người có thu nhập; chủ nhóm có thể phân phối phần nhóm cho thành viên trong phạm vi góp công. Chưa có trợ cấp mặc định cho người hết tiền; trường hợp đó phải lộ trong kết quả để điều chỉnh dữ liệu hoặc cơ chế hợp lệ.

## 10. Công việc và đề nghị đầu

| Mã | Bên giao | Công việc | Điều kiện, thời lượng và thanh toán thử |
| --- | --- | --- | --- |
| J01 | H02 | Thu một lô ruộng | 30 suất có thật; 6 giờ hữu ích với cuốc; 8 đồng khi giao đủ |
| J02 | H01 | Cắt băng | 1.000 g V04 → 10 V05 × 100 g; 2 giờ với dụng cụ cắt; 4 đồng khi nghiệm thu |
| J03 | O01 | Giao thanh diệp | Tối đa 10 phần/lần, mua 2 đồng/phần; thời gian đi/thu riêng |
| J04 | O02 | Thay cán dao | 1 V09 + dao có cán hỏng; 1 giờ; giá dịch vụ 3 đồng, cán cũ trở thành phần hỏng có lượng theo mẫu |
| J05 | O03 | Bài học nhập môn | N13 và học viên cùng 2 giờ tại D09; phí 12 đồng; mở kiến thức cơ bản, không tăng cấu trúc ngay |
| J06 | O01 | Đưa tin | Tới người nhận xác định, giao thông điệp; 2 đồng khi có bằng chứng nhận |
| J07 | O04 | Chuyển kiện | Vật/hành trình định rõ khi nhận; 6 đồng/lượt, tối đa một lượt cam kết mỗi ngày ban đầu |

Đây là đề nghị hoặc mẫu công việc, không tự là hợp đồng với P00. Nhiều ứng viên phải phân xử, người giao có thể ngừng đề nghị khi thiếu vốn/nhu cầu. H02 không được tạo vô hạn J01 sau khi hết lô.

Lịch N13: tối đa một buổi 2 giờ/ngày, phần còn dành công việc khác. Các nghề khác ưu tiên nguồn sống và việc đã nhận, không khóa cả ngày lao động cộng thêm thời gian vô hạn cho học/tu luyện.

## 11. Giá chào tham chiếu

V02: 2 đồng/suất tại O04 hoặc O05; phòng trọ P00 tại O05: 1 đồng/ngày; bài học 12 đồng; V14 tươi: O01 đang chào mua 2 đồng/phần, tối đa 10; băng V05: 1 đồng/cái nếu chủ kho chấp nhận bán. Đây là giá chào ban đầu, không giá bắt buộc mọi NPC mãi dùng.

Với J01, thu 8 đồng trừ 2 tiền ăn và 1 tiền phòng còn 5 đồng/ngày trước các chi phí khác. Chỉ đúng khi thực sự nhận/hoàn việc; không dùng để bảo đảm người chơi luôn có lời hoặc đủ 12 đồng học sau một số ngày cố định.

## 12. Thông số năng lượng cho bài thử riêng

Đặc tả DL05 ở [[TU_LUYEN_THU]] kế thừa phép thử này: Tĩnh Lưu dùng hiệu suất 80%, INIT-D chọn N13/N14; đồng thời bổ sung kho cá thể, Liệt Mạch, Hồi Hoàn, V27 và TM-01. TM-01 là trạng thái gần mốc riêng, không sửa INIT-A hoặc khẳng định đã luyện qua lịch sử thật.

Phép thử chuyển nguồn đơn giản, chưa áp thành thông số đầy đủ cho ba công pháp: người đã đủ điều kiện yêu cầu 6 L/giờ trong 1 giờ; chuyển 80% vào linh lực, 20% thất thoát có hồ sơ. Mỗi người nhận 4,8 L khi nguồn đủ.

Tình huống cạn: đặt kho D10 thành 6 L, tắt bổ sung trong đúng bài thử, hai người yêu cầu đồng thời 6 L trong giờ đó. Đề xuất chia đều lưu lượng khi quyền/khả năng bằng nhau: mỗi người rút 3 L, nhận 2,4 L, tổng thất thoát 1,2 L. Phân chia lưu lượng khác tranh một vật độc quyền; phải ghi rõ loại nguồn.

Kho 6 L là biến thể INIT-D, không sửa lén 120 L của bài chơi thường. Hiệu suất thực của công pháp, sức chứa cá thể và ngưỡng đột phá còn cần bảng riêng; không cho P00 chưa học tham gia phép thử này bằng năng lực tự sinh.

## 13. Biến thể thử và nguồn bằng chứng

- INIT-A: dữ liệu nền trên, không ép biến cố; đánh giá sinh kế/học.
- INIT-B: bản sao trạng thái có hành động dùng tay trái, chèn tác động đã định; mô hình tác động định lượng còn thiếu.
- INIT-C: chọn chuyến hàng đã cam kết, chèn hỏng cầu ở mốc xác định khi hàng chưa qua cầu; bản với/không với người đưa tin.
- INIT-D: nguồn 6 L, hai chủ thể đã được khởi tạo đủ điều kiện; tính bảo toàn mục 12.
- INIT-E: chủ thể/pha giao chiến định rõ từ CHIEN_DAU; thông số tiếp xúc và chức năng còn thiếu.
- Bổ sung: [[CHIEN_DAU_THU]] đã cụ thể hóa INIT-E bằng N17/P00, đồ O03 cho mượn và không gian E-01. Đây là biến thể thử riêng; dòng trên phản ánh trạng thái trước DL06, không còn là khoảng trống về thông số cơ sở nhưng vẫn chưa được chạy.

Mỗi lượt cần ghi phiên bản bộ dữ liệu, trạng thái ngẫu nhiên, thay đổi so INIT-A và lệnh. Bài thử B/E chưa thể chạy chỉ bằng tài liệu này. Chưa tạo file save hoặc tuyên bố các NPC đã được mô phỏng.

## 14. Việc đã cụ thể và việc còn thiếu

Bổ sung DL03 tại [[CO_THE_THU]]: chức năng/mệt/nhu cầu và trạng thái sinh lý khởi tạo riêng; vết thương W-B01 chỉ trong biến thể thử, không áp cho INIT-A khỏe mạnh. Còn thiếu mô hình cơ quan sâu và toàn bộ tham số sinh lý.

Bổ sung DL02 tại [[VAT_THE_THU]] và K0 tại [[DU_LIEU_LIEN_KET_K0]]: khối lượng/kích thước 33 mẫu nền, tải, cấu tạo và vị trí tiền vật chất. K1.8 bổ sung V34–V36 thành 36 mẫu. Nguồn ruộng mục 8 được cụ thể hóa thành 300 kg phần ăn + 100 kg thân/vỏ; 20 kg/lô chín. Số mẫu không đồng nghĩa mọi quy trình đã có thời lượng/công cụ. Các đoạn nêu thiếu kích thước/phần cây khác phía trên phản ánh bản nền trước bổ sung này.

Bổ sung DL01 tại [[SINH_KE]]: quyền ăn/ở từng người, lịch tiếp tế, ngân sách, cho mượn bình và giới hạn quy trình J01. Dùng cùng dữ liệu nền ở đây; chưa phải kiểm chứng mô phỏng. Chính sách phân phối đã có đề xuất, tính khả thi còn cần DL02–DL04.

Đã có 20 NPC + P00, 11 địa điểm, 11 tuyến, 36 loại vật phẩm, quyền chi và tồn kho ban đầu, 7 mẫu việc, một khoản nợ cùng các phép tính nguồn cơ bản.

Còn thiếu trước triển khai: mẫu cơ thể/chức năng và hệ số thương tích; khối lượng/kích thước mọi vật; các quy trình chưa định lượng; chính sách phân phối thức ăn cho từng người; mẫu ý định NPC đủ trường; chuyển cấu trúc khi đột phá; tham số chiến đấu; lược đồ dữ liệu máy và kiểm tra tham chiếu tự động.

Không gọi bộ này là dữ liệu hoàn chỉnh có thể chạy. Bước tiếp theo đề xuất: luồng giao diện text để người dùng xem và chỉnh mục tiêu, đọc nguyên nhân, quản lý giới hạn; sau đó chốt lựa chọn trải nghiệm và hoàn thiện dữ liệu thiếu trước lập trình.
