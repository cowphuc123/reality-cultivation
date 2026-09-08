---
aliases:
  - Nhánh xung đột K1.4
  - Ma trận thất bại FX-A-30D
tags:
  - reality-cultivation
  - ke-hoach
  - fixture-k1
  - nhanh-that-bai
status: de-xuat
updated: 2026-09-06
---

# Ma trận xung đột và nhánh thất bại — K1.4

Tài liệu này tạo các overlay thất bại cho [[SO_SU_KIEN_30_NGAY_K1]]. Mỗi nhánh chỉ sửa một nhóm đầu vào có nhãn, giữ nguyên phần còn lại của base để có thể chỉ ra chính xác hậu quả đến từ đâu. Nguồn nhận thức tuân [[NGUON_QUYET_DINH_K1]]; cơ thể, vật phẩm và giao dịch vẫn dùng cùng trạng thái thật.

Các nhánh là phép thử đề xuất, chưa được chạy. Một nhánh “được phép phục hồi” không có nghĩa NPC luôn chọn đúng cách phục hồi.

## 1. Quy tắc dựng nhánh

Mỗi overlay phải khai báo:

1. snapshot/base và phiên bản mong đợi;
2. FactEvent hoặc thay đổi khởi tạo tối thiểu;
3. ai có cơ hội quan sát, vào giờ nào;
4. Belief/Message nào có thể hình thành;
5. DecisionFrame nào được đánh thức;
6. Action/Reservation/Contract nào bị thay, hoãn hoặc hủy;
7. lượng, vị trí, quyền và tiền thực sự đổi;
8. điểm nhập lại base nếu có;
9. kết quả hợp lệ thay thế và điều kiện bất biến;
10. phần chưa hỗ trợ phải dừng rõ, không kể bù.

Không sửa trực tiếp “NPC biết tin”, “NPC buồn” hay “hàng tới muộn”. Phải có sự kiện vật lý/giao tiếp và chuỗi hậu quả tạo ra các trạng thái đó.

## 2. Ma trận tổng quan

| Mã | Biến cố | Phần base bị tác động | Kết quả chính |
|---|---|---|---|
| X01 | N12 vắng lúc nghiệm thu ngày 3 | J01-03, hợp đồng lô 4, tiền P00 | Hàng được đặt chờ; công trả sáng ngày 4; lịch nhập lại base |
| X02 | N05 bị thương trước ba đơn ngày 18 | Ba giao hàng, ca gác N17 | Có thể đổi N17 giao muộn; D07 bỏ gác tạm thời |
| X03 | Chuyến O05→O06 ngày 21 trễ 40 phút | Bữa sáng N18, lịch N20 | N18 ăn muộn; kho không âm; cơ thể và niềm tin ghi độ trễ |
| X04 | Quầy N06 đóng bất ngờ chiều ngày 6 | Lần mua đầu của P00 | P00 kiểm tra lại lúc 19:00; không được lấy hàng từ O05 đã cam kết hết |
| X05 | N11 thắng tranh lô J01-04 | Thu nhập P00, kế hoạch J05 | Sản lượng không đổi; P00 bỏ J05 để giữ dự phòng; tiền đổi chủ khác |
| X06 | P00 làm rơi bình trên đường ngày 11 | Lịch nước ngày 12 | Tìm vật thật, lấy nước muộn; không sinh bình thay thế |
| X07 | Tin về lịch N13 đã cũ | J05 ngày 9, niềm tin P00 | Không học/không trả tiền; P00 cập nhật độ tin theo lĩnh vực |
| X08 | Không tìm được người thay N05 ngày 18 | Kho H01/O02/O03 | Thiếu định suất xuất hiện ngày 21 nếu không có giao dịch cứu |

X02 và X08 cùng bắt đầu từ một loại biến cố nhưng khác precondition về người thay. Chúng kiểm tra hai kết quả hợp lệ, không dùng lựa chọn của tác giả để ép NPC luôn cứu được lịch.

## 3. X01 — N12 vắng lúc nghiệm thu ngày 3

### 3.1 Đầu vào

- 16:20 ngày 3, N12 nhận một Message trực tiếp về việc hộ khẩn và rời D05 lúc 16:22.
- P00 không nghe nội dung; chỉ quan sát N12 rời đi.
- Contract J01-03 vẫn yêu cầu nghiệm thu 16:30; 8 V01 còn được giữ trong V33-H02.

### 3.2 Diễn biến

| Mốc | Sự kiện và tri thức |
|---|---|
| 16:25 | P00 đưa 30 V02 vào khu nghiệm thu; sản phẩm có Position thật và thuộc lô J01-03. |
| 16:30 | Không có người đủ quyền nghiệm thu. Action trả công bị từ chối, không trừ 8 V01. |
| 16:30–16:35 | N09 nói chỉ biết N12 có việc gấp, không biết giờ về. P00 hình thành Belief “nghiệm thu chờ”, không tin “bị quỵt” như sự thật. |
| 16:35 | DecisionFrame chọn để hàng trong khu giữ, về trước khi tối; đặt lần kiểm lại 07:30 ngày 4. |
| 07:30–07:40 ngày 4 | N12 đã phát bữa xong, kiểm đúng lô, cam kết trả 8 V01 và đóng J01-03. |
| 07:40–07:50 | N12 đề nghị; P00 nhận J01-04, lấy V22 và vẫn bắt đầu lúc 08:00. |

### 3.3 Kết quả

- Cuối ngày 3 P00 có 53 V01 thay vì 61; sau trả bù và công ngày 4, cuối ngày 4 trở lại 68.
- 30 V02 ngày 3 tồn tại từ lúc chế biến xong nhưng ở trạng thái chờ nghiệm thu; không cộng lần hai sáng ngày 4.
- Không có lô 4 trước khi hai bên nhận lúc 07:50 ngày 4.
- Xung đột này nhập lại base từ 08:00 ngày 4.

## 4. X02 — N05 bị thương, N17 nhận thay ba đơn ngày 18

### 4.1 Đầu vào và điều kiện thay người

- 06:25 ngày 18, N05 trượt khi chuẩn bị V23 tại D01; FactEvent gây giảm chức năng chân đủ để cấm kéo xe trong buổi sáng. Đây là thương tích gameplay, không phải hướng dẫn y khoa.
- N06 và N17 ở D01 có cơ hội thấy; các nơi nhận chưa biết.
- Overlay phải có bằng chứng lịch sử rằng N17 từng kéo V23 an toàn và biết các tuyến giao. Nếu thiếu bằng chứng này, nhánh phải chuyển sang X08.

### 4.2 Quyết định và lịch thay

N06 ưu tiên ba hợp đồng gần hạn, hỏi N17 nhận thay. N17 chấp nhận sau khi biết D07 sẽ bỏ gác; đây là hậu quả thật, không tiếp tục gác từ xa.

| Đơn | Mốc base | Mốc X02 |
|---|---|---|
| O04→H01 | Cam kết 06:50:33.334 | 07:05:33.334 |
| O04→O02 | Cam kết 07:25 | 07:40 |
| O04→O03 | Cam kết 08:03:20 | 08:18:20 |

N17 về D01 khoảng 08:24:35, đi D07 và tới khoảng 08:34:35. D07 không có người gác 08:00–08:34:35. Nếu sự kiện khác cần người gác trong khoảng này, nó phải thấy vị trí thật.

### 4.3 Tri thức và kết quả

- H01/O02/O03 chỉ biết chậm khi N17 tới hoặc Message khác đến trước; họ không đọc thương tích N05 từ xa.
- Các nhóm đã phát bữa sáng trước khi hàng tới nhưng còn lần lượt 4/4/8 suất, nên không thiếu bữa ngày 18.
- Số V02/V01 cuối ngày giống base; người thực hiện, giờ giao, lịch gác và trạng thái N05 khác.
- Không tự trả phí vận chuyển J07 ngoài hợp đồng lương thực đã khai báo.

## 5. X03 — chuyến O05→O06 ngày 21 trễ

### 5.1 Đầu vào

06:58 ngày 21, khóa dây V13 cần buộc lại; N20 quan sát được và mất 40 phút. Hàng vẫn ở D02, O05 vẫn là chủ; N18 chưa biết nguyên nhân.

### 5.2 Diễn biến

- 07:20: mốc dự kiến qua đi nhưng không giao dịch.
- 07:25: O06 có 0 V02. N18 quan sát N20 chưa tới, không phát/ăn suất giả và tạo DecisionFrame chờ tại D08.
- 07:55: N20 tới D08; 07:55–08:00 N18 kiểm và trả 10 V01; năm V02 đổi chủ lúc 08:00.
- 08:00–08:05: N18 ăn muộn 250 g, giữ nửa còn lại cho tối. Trạng thái đói/nhịp hấp thu đổi theo 40 phút thật.
- N20 về và nộp tiền O05 muộn tương ứng; khối việc D01 bắt đầu sau khi tới nơi, không được tính đủ giờ cũ.

### 5.3 Kết quả

Kho O06 không âm: cuối ngày vẫn còn bốn suất. Bữa ăn trễ là hậu quả cơ thể, không phải thiếu một suất. Nếu N18 rời D08 đi tìm hàng trước khi N20 tới, hai người có thể lỡ nhau; đó là nhánh con khác cần Position thật.

## 6. X04 — quầy O04 đóng trong cửa sổ mua ngày 6

### 6.1 Đầu vào

16:45 ngày 6, N06 phải khóa quầy vì sự cố kho phụ. N06 đặt thông báo nhìn thấy tại cửa: “tạm đóng, xét mở lại 19:00”. P00 chỉ biết khi tới D01 lúc 16:46:40.

### 6.2 Phản ứng hợp lệ

- 17:00: không có giao dịch; P00 không mất 4 V01 và O04 không mất hai V02.
- P00 đọc thông báo, về D02, hỏi N19. N19 có thể cho biết O05 bán cùng giá nhưng toàn bộ V02 hiện đã cam kết cho N19/N20/O06; quyền mua không tự xuất hiện.
- P00 giữ mục tiêu mua, quay D01 lúc 18:55. Nếu N06 mở lại, kiểm hàng/giá/quyền và cam kết giao dịch 19:05.
- P00 về D02 khoảng 19:09:10 và vẫn trả trọ lúc 21:00.

Nếu N06 không mở lại, P00 hết V02 sau bữa tối ngày 6. Ngày 7 phải ghi thiếu bữa, hỏi/đàm phán hoặc đổi lịch; không được âm thầm nhận hai suất theo bảng base.

### 6.3 Kết quả nhánh mở lại

Số dư cuối ngày giống base, nhưng Belief “quầy mở 17:00” bị hạ độ tin cho lần sau; lịch cũ trở thành dự đoán cần kiểm tra. P00 nhận thông tin N13 lúc giao tiếp 19:00 thay vì 17:00.

## 7. X05 — N11 thắng tranh J01-04

### 7.1 Đầu vào và phân xử

- Việc bảo dưỡng của N11 kết thúc ngày 3. Lúc 16:30, N11 và P00 cùng xin lô 4 sau khi đề nghị được công bố tại D05.
- N12 biết cả hai có lịch ngày 4 và năng lực hợp lệ. P00 đã hoàn tất ba lô; N11 có lịch sử nghề. Chính sách hòa dùng lượt luân phiên đã lưu và chọn N11.
- P00 nhận phản hồi từ chối tại chỗ; không có Reservation/Contract lô 4 cho P00.

### 7.2 Hậu quả

- N11 làm lô 4 ngày 4, H02 vẫn nhận 30 V02 và trả 8 V01 cho N11.
- P00 dùng ngày 4 tìm cơ hội và có thể nhận lô 5 lúc 16:30; sau đó làm ngày 5–8. Tổng sản lượng vẫn 240, nhưng P00 chỉ nhận bảy khoản công.
- Dự báo tiền sau ngày 8 cho thấy nếu vẫn học J05, P00 kết thúc với 6 V01, vi phạm dự phòng 10. P00 hoãn J05 trước khi đi D09.

### 7.3 Kết sổ khác base

- P00 cuối ngày 30: 40 + 56 − 48 − 30 = **18 V01**.
- N11 giữ 8 V01; O03 không nhận 12 học phí nên cuối kỳ 320 thay vì 332.
- H02 vẫn chi tổng 64 V01 và cuối kỳ vẫn 306; V02 cuối kỳ vẫn 110.
- Tổng tiền vẫn 2.000 khi thêm hàng cá nhân N11 vào sổ. Không gán 8 đồng của N11 cho hộ nào nếu chưa có sự kiện nộp quỹ.

## 8. X06 — P00 làm rơi V12 và tìm lại ngày 12

### 8.1 Đầu vào

Ngày 11, overlay đặt P00 rời D01 lúc 16:05 để về D02. Lúc 16:07:05, quai giữ lỏng làm V12 rỗng rơi ở trung điểm tuyến D01–D02; P00 tiếp tục và tới D02 lúc 16:09:10. P00 không nghe/nhìn thấy do điều kiện chú ý của overlay; vật có Position trên tuyến, không dịch về kho thất lạc.

### 8.2 Tìm kiếm

| Mốc | Diễn biến |
|---|---|
| 06:00 ngày 12 | P00 tìm bình trong V13, quan sát nó không có ở vị trí mong đợi. Đây không phải tri thức về nơi bình đang nằm. |
| 06:00–06:03 | Kiểm phòng/đồ; thất bại. Memory lần cuối mang bình trên tuyến khiến P00 chọn đi ngược đường. |
| 06:03–06:06:20 | Đi chậm 100 m và quan sát tuyến; thấy/nhận diện V12 lúc 06:06:20. |
| 06:06:20–06:09:40 | Mang bình về D02 để khép tìm kiếm; kiểm bình còn dùng được. |
| 06:09:40–06:30:45 | Thực hiện chuyến lấy 2.000 ml trễ 9 phút 40 giây. |

P00 ăn sáng 06:30:45–06:50:45. Khối tìm cơ hội 08:00 vẫn có thể bắt đầu đúng giờ. Nếu bình hỏng, nhánh không được dùng lịch này; phải tìm quyền mượn/mua và chấp nhận thiếu nước hoặc đổi việc.

## 9. X07 — lời giới thiệu về N13 đã cũ

### 9.1 Đầu vào

Thông báo O03 mà N06 đọc là thật khi phát hành, nhưng N13 rời D09 sáng ngày 9 vì nghĩa vụ khác. N06 chưa nhận bản cập nhật, nên lời ngày 6 là nhầm do tin cũ, không phải nói dối.

### 9.2 Diễn biến và nhận thức

- P00 vẫn tới D09 lúc 12:40:25 dựa trên Belief hợp lý.
- 12:45, N16 trực tiếp báo N13 vắng và buổi học không diễn ra. P00 nhận bằng chứng mới, hủy kế hoạch thanh toán trước 12:55.
- Không trừ 12 V01, không tạo Contract J05, không cấp kiến thức nhập môn.
- P00 có thể giảm độ tin đối với **lịch học do N06 kể**, nhưng không tự kết luận N06 lừa dối hoặc mất tin cậy ở mọi lĩnh vực.

### 9.3 Kết sổ

Nếu không đặt lại buổi khác, P00 cuối kỳ có 26 V01; O03 cuối kỳ có 320. V02 và các quỹ khác giống base; tổng vẫn 2.000.

## 10. X08 — N05 bị thương và không có người thay

X08 dùng cùng FactEvent 06:25 ngày 18 như X02 nhưng bỏ bằng chứng kỹ năng của N17 và không có người khác đủ quyền/năng lực được biết.

### 10.1 Điều không xảy ra

- O04 vẫn giữ 60 V02 và không nhận 120 V01 từ H01/O02/O03.
- H01/O02/O03 không biết chắc lý do cho tới khi Message hoặc người tới báo.
- Sổ không được ghi hàng “đang tới” như hàng đã nhận.

### 10.2 Mốc cạn nếu không cứu

| Nguồn | Sau bữa sáng ngày 18 | Cuối ngày 20 | Bữa đầu thiếu |
|---|---:|---:|---|
| H01 | 4 | 0 | Ngày 21, thiếu 2 suất |
| O02 | 4 | 0 | Ngày 21, thiếu 2 suất |
| O03 | 8 | 0 | Ngày 21, thiếu 4 suất |

O03 vẫn có đơn 20 suất dự kiến ngày 23, nhưng nó không chữa ngược bữa ngày 21–22. Các bên có thể tìm vận chuyển khác, mua trực tiếp, vay hoặc chia khẩu phần nếu có thông tin/quyền; mỗi lựa chọn phải tạo giao dịch và lịch mới.

Nếu hoàn toàn không cứu trước ngày 23, thiếu tối thiểu 16 định suất trong ngày 21–22: H01 4, O02 4, O03 8. Nếu không cứu tới hết ngày 30, tổng thiếu là 60 định suất: H01 20, O02 20 và O03 20 sau khi đã tính lô O03 ngày 23. Không trừ kho xuống âm; tạo nghĩa vụ cấp suất thất bại và hậu quả cơ thể cho từng người.

## 11. Tranh chấp đồng thời và quy tắc ghép nhánh

Không mặc định hai overlay độc lập có thể cộng thẳng. Trước khi ghép phải kiểm:

- có sửa cùng Person/Action/Contract/Position không;
- kết quả nhánh trước có còn thỏa precondition nhánh sau không;
- cùng một khoản tiền/hàng có bị giữ hai lần không;
- tri thức cần cho phương án phục hồi đã thật sự đến chưa;
- lịch thay người có tạo lỗ hổng ở trách nhiệm khác không.

Ví dụ X02 + X03 không trực tiếp xung đột người nhưng N17 bỏ gác ngày 18 có thể thay kỳ vọng an ninh của N18 về sau nếu tin được truyền. X04 + X05 làm tài chính P00 căng hơn nhưng quầy mở lại vẫn cho mua; X05 + X07 đều loại J05 nhưng không được cộng hai lần 12 đồng tiết kiệm.

## 12. Ma trận bất biến

| Bất biến | X01 | X02 | X03 | X04 | X05 | X06 | X07 | X08 |
|---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| Một Position thật | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Không kho âm | ✓ | ✓ | ✓ | Nhánh không mở lại phải phân nhánh thiếu | ✓ | ✓ | ✓ | Dừng cấp ở 0 |
| Tổng V01 = 2.000 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Không tri thức từ xa | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Giao dịch nguyên tử | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | Không có giao dịch ba đơn |
| Lịch base bị thay có dấu vết | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Có thể tái hiện cùng seed/lệnh | Cần bộ chạy | Cần bộ chạy | Cần bộ chạy | Cần bộ chạy | Cần bộ chạy | Cần bộ chạy | Cần bộ chạy | Cần bộ chạy |

Dấu ✓ nghĩa là thiết kế nhánh giữ điều kiện trên giấy, chưa phải kết quả kiểm thử chạy.

## 13. Điều kiện kiểm thử NX01–NX18

Các điều kiện dưới đây **chưa chạy**:

1. NX01 — X01 không trả công lúc N12 vắng và không mất Reservation 8 V01.
2. NX02 — Nghiệm thu trễ X01 không tạo thêm 30 V02 hoặc trả 8 V01 hai lần.
3. NX03 — X01 nhập lại lịch lúc 08:00 ngày 4 mà không dùng lô chưa nhận.
4. NX04 — X02 chỉ chọn N17 khi có bằng chứng kỹ năng/tuyến hợp lệ.
5. NX05 — X02 đặt N17 ở đúng một nơi và để D07 thật sự không người gác.
6. NX06 — Người nhận X02 chỉ biết thương tích N05 sau nguồn tin hợp lệ.
7. NX07 — X03 giữ kho O06 ở 0 tới 08:00 và không phát suất lúc 07:25.
8. NX08 — X03 làm đổi mốc đói/hấp thu và giờ làm N20, không chỉ đổi dòng nhật ký.
9. NX09 — X04 không trừ tiền/hàng lúc quầy đóng; lần 19:05 là giao dịch mới hợp lệ.
10. NX10 — Nếu X04 không mở lại, ngày 7 phân nhánh thiếu ăn, không dùng bảng base.
11. NX11 — X05 khóa lô 4 cho một người, sản xuất vẫn 30 và P00 không nhận 8 V01.
12. NX12 — X05 hoãn J05 từ dự báo tiền; kết sổ gồm 8 V01 thật trong tay N11.
13. NX13 — X06 giữ V12 trên tuyến trước khi được tìm, không sinh bản thay thế trong túi.
14. NX14 — Thất lạc/hồi phục V12 tạo Observation/Belief đúng thứ tự và làm trễ lịch nước.
15. NX15 — X07 không biến tin cũ thành lời nói dối và không hạ tin cậy mọi lĩnh vực.
16. NX16 — X07 không thu học phí/cấp kiến thức khi N13 không đồng ý hoặc không hiện diện.
17. NX17 — X08 dừng cấp V02 ở 0, ghi từng nghĩa vụ thất bại và hậu quả từng người.
18. NX18 — Ghép hai nhánh kiểm tra lại precondition, không cộng lặp cùng khoản tiết kiệm/tổn thất.

## 14. Việc kế tiếp

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
