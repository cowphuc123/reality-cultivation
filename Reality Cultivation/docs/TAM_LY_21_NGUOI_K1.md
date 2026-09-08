---
title: Tính cách, giá trị, cảm xúc và sức ép — K1.10
aliases:
  - K1.10
  - Tâm lý 21 người
tags:
  - reality-cultivation
  - thiet-ke
  - npc
  - tam-ly
status: de-xuat
updated: 2026-09-06
---

# Tính cách, giá trị, cảm xúc và sức ép — K1.10

Tài liệu này nối [[NPC]], [[HO_SO_NPC_AN_KHE_K1]], [[NGUON_QUYET_DINH_K1]] và [[NANG_LUC_NGON_NGU_TRI_THUC_K1]]. Nó cung cấp trạng thái tâm lý đề xuất cho P00/N01–N20 ở ngày 1, 06:00 và cách trạng thái đó đổi khi có sự kiện.

Đây là fixture gameplay chưa được người dùng duyệt hoặc chạy, không phải chẩn đoán tâm lý ngoài đời. Các con số chỉ dùng để kiểm tra mô phỏng. P00 được giữ mở vì quyền tự chủ của nhân vật người chơi chưa chốt; hệ không tự đặt tính cách rồi chống lệnh người chơi.

## 1. Bốn tầng không được trộn

| Tầng | Ví dụ | Nhịp thay đổi |
|---|---|---|
| `Disposition` — xu hướng | thường kiểm tra trước khi mạo hiểm | chậm, đổi qua nhiều trải nghiệm |
| `ValueCommitment` — giá trị | muốn giữ lời với hợp đồng đã nhận | có thứ tự theo hoàn cảnh, đổi qua lựa chọn/hậu quả |
| `AffectState` — cảm xúc | lo về bánh V23 sau quan sát gần nhất | phút–ngày hoặc lâu hơn nếu đánh giá chưa giải quyết |
| `PressureLoad` — tải sức ép | thiếu ngủ + gần hạn + xung đột xã hội | liên tục theo cơ thể, lịch, tri thức và sự kiện |

Mục tiêu, Belief, quan hệ, cơ thể và quyền vẫn là hồ sơ riêng. “Lo 4.000” không tự tạo mục tiêu; “coi trọng gia đình” không tự cho quyền quyết định thay người thân; “dễ biểu lộ” không có nghĩa nói thật mọi bí mật.

## 2. Tám trục xu hướng

Thang 0–4 mô tả xu hướng trong điều kiện trung tính. Mức 2 là vừa, không phải chuẩn tốt nhất.

| Mã | 0 | 4 |
|---|---|---|
| `CA` — thận trọng | chấp nhận bất định/rủi ro dễ hơn | cần bằng chứng/an toàn trước khi tiến |
| `PE` — bền chí | đổi hướng sớm khi lợi ích giảm | giữ việc/mục tiêu qua trở ngại |
| `OR` — quy củ | linh hoạt, ít cần cấu trúc | ưa thứ tự, kiểm tra và hồ sơ |
| `CO` — hướng chăm sóc | ít tự ưu tiên nhu cầu người khác | chú ý mạnh tới an nguy/phụ thuộc |
| `AU` — nhu cầu tự chủ | thoải mái để nhóm định hướng | muốn tự chọn cách, giờ và mục tiêu |
| `SE` — nhạy đánh giá xã hội | ít bị danh tiếng/so sánh tác động | để ý mạnh tới nhìn nhận của người liên quan |
| `NO` — tìm cái mới | thích cách quen/ổn định | chủ động khám phá/thử phương án mới |
| `EX` — biểu lộ | giữ phản ứng trong lòng | dễ bộc lộ cảm xúc/ý kiến ra ngoài |

Các trục không là đạo đức. CO thấp không đồng nghĩa độc ác; người đó có thể giữ nghĩa vụ rất mạnh. CA cao không đồng nghĩa hèn; họ có thể chấp nhận nguy hiểm khi giá trị khác vượt lên.

## 3. Ma trận xu hướng ngày 1

P00 dùng `U` vì người dùng chưa chọn tính cách. NPC có số theo hồ sơ K1.6; đây là giả thuyết khởi tạo để kiểm thử, không là kết quả người dùng xác nhận.

| ID | CA | PE | OR | CO | AU | SE | NO | EX |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| P00 | U | U | U | U | U | U | U | U |
| N01 Lâm | 3 | 3 | 2 | 3 | 2 | 3 | 2 | 2 |
| N02 Mai | 4 | 4 | 4 | 4 | 3 | 2 | 1 | 2 |
| N03 An | 3 | 4 | 4 | 4 | 3 | 2 | 2 | 2 |
| N04 Liên | 3 | 3 | 3 | 4 | 3 | 4 | 2 | 2 |
| N05 Bình | 3 | 4 | 3 | 2 | 3 | 3 | 2 | 2 |
| N06 Hòa | 3 | 4 | 4 | 2 | 4 | 3 | 3 | 3 |
| N07 Mộc | 3 | 4 | 4 | 3 | 3 | 2 | 2 | 2 |
| N08 Thu | 2 | 3 | 3 | 3 | 4 | 3 | 3 | 2 |
| N09 Sơn | 3 | 4 | 3 | 4 | 2 | 2 | 1 | 2 |
| N10 Cúc | 4 | 4 | 4 | 4 | 3 | 2 | 1 | 2 |
| N11 Đạt | 2 | 4 | 2 | 3 | 4 | 4 | 3 | 2 |
| N12 Nga | 4 | 4 | 4 | 3 | 3 | 3 | 1 | 2 |
| N13 Vân | 4 | 4 | 4 | 3 | 3 | 3 | 2 | 2 |
| N14 Kha | 3 | 4 | 3 | 2 | 3 | 4 | 2 | 1 |
| N15 Tùng | 2 | 4 | 2 | 2 | 4 | 4 | 4 | 3 |
| N16 Yến | 4 | 4 | 4 | 3 | 3 | 3 | 1 | 2 |
| N17 Dũng | 3 | 4 | 3 | 4 | 4 | 2 | 2 | 2 |
| N18 Tâm | 4 | 4 | 4 | 3 | 3 | 3 | 1 | 2 |
| N19 Phúc | 4 | 4 | 4 | 4 | 3 | 3 | 1 | 2 |
| N20 Huệ | 2 | 3 | 2 | 4 | 4 | 3 | 4 | 3 |

Không cộng tám số thành “điểm tính cách”. Mỗi phép đánh giá chỉ dùng trục liên quan và phải ghi tình huống/Belief kích hoạt.

## 4. Tập giá trị dùng trong fixture

| Mã | Nội dung |
|---|---|
| VAL-SAFETY | giữ an toàn thân thể, tuyến, nguồn hoặc người phụ thuộc |
| VAL-CARE | giảm tổn hại và đáp ứng chăm sóc có căn cứ |
| VAL-DUTY | hoàn thành vai trò/nghĩa vụ đã nhận |
| VAL-HONOR | hành xử nhất quán với lời đã nhận và hình ảnh bản thân coi trọng |
| VAL-ORDER | sổ đúng, nguồn đúng, quy trình có thể kiểm tra |
| VAL-AUTONOMY | tự chọn hướng sống/cách làm trong quyền của mình |
| VAL-MASTERY | làm giỏi và hiểu sâu nghề/kỹ năng |
| VAL-SECURITY | duy trì dự trữ, nơi ở và khả năng sống tiếp |
| VAL-PROSPERITY | tăng nguồn/vốn và khả năng mở rộng sinh kế |
| VAL-BELONGING | giữ vị trí trong hộ/nhóm và được thừa nhận là thành viên |
| VAL-FAIRNESS | phân việc/nguồn theo tiêu chí người đó cho là hợp lý |
| VAL-CURIOSITY | tìm hiểu điều chưa biết và thử giả thuyết |
| VAL-LEGACY | truyền nghề, giữ giống, để lại tổ chức/tri thức bền |

Giá trị có `scope`, `weight`, `source`, `exceptions` và `last_revision`. Một người có thể coi trọng an toàn tuyến nhưng sẵn sàng chịu rủi ro để cứu người. “Công bằng” là cách người đó hiểu từ nguồn văn hóa, không phải phép đo khách quan duy nhất.

## 5. Giá trị ưu tiên và ranh giới ban đầu

Thứ tự ba mã chỉ là ưu tiên thường thấy khi đều liên quan; mức khẩn/sự kiện có thể đổi thứ tự. “Ranh giới” là điều người đó hiện không muốn vượt, chưa phải khóa vật lý hoặc luật.

| ID | Ba giá trị nổi bật | Ranh giới/điều kiện nguồn |
|---|---|---|
| P00 | do người dùng/mục tiêu đã giao xác định | chưa cho tâm lý bí mật quyền phủ quyết lệnh |
| N01 | HONOR, SECURITY, SAFETY | không cố hái khi chức năng cơ thể không đủ |
| N02 | SECURITY, CARE, ORDER | không chi shared commitment làm hộ mất dự trữ an toàn |
| N03 | CARE, MASTERY, DUTY | không nhận ca vượt khả năng kho/chuyên môn mà không nói rõ |
| N04 | MASTERY, CARE, HONOR | không giả biết ca chưa được công nhận |
| N05 | DUTY, HONOR, SAFETY | không kéo xe đã tin là không an toàn chỉ để đúng giờ |
| N06 | PROSPERITY, ORDER, AUTONOMY | không làm cạn vốn đã cần cho hợp đồng giữ chỗ nếu biết hậu quả |
| N07 | MASTERY, LEGACY, ORDER | không nghiệm thu sản phẩm mà ông tin chưa đạt |
| N08 | MASTERY, AUTONOMY, HONOR | muốn được giao việc thật nhưng không tự nhận quyền bán/chi |
| N09 | DUTY, CARE, SECURITY | ưu tiên lô chín và nguồn sống H02 trước việc ngoài không cấp bách |
| N10 | SECURITY, LEGACY, CARE | không bán phần cô tin cần làm giống/dự phòng nếu chưa có phương án |
| N11 | AUTONOMY, MASTERY, BELONGING | muốn học nhưng không muốn bị coi là bỏ cam kết H02 |
| N12 | ORDER, FAIRNESS, DUTY | không cấp/thu tiền khi chưa đối chiếu quyền và lượng |
| N13 | SAFETY, MASTERY, LEGACY | không cấp quyền luyện mà cô tin chưa đủ bước an toàn |
| N14 | MASTERY, HONOR, BELONGING | không muốn bị xem là tụt lại; vẫn cần quyền trước tăng tải |
| N15 | CURIOSITY, MASTERY, AUTONOMY | muốn thử nghiệm hợp lệ, không coi im lặng là phê duyệt |
| N16 | ORDER, SAFETY, DUTY | không cấp nguồn thiếu Reservation/ghi nhận |
| N17 | DUTY, CARE, HONOR | có thể bỏ ưu tiên công việc để cứu người khi nguy hiểm được tin là thật |
| N18 | SAFETY, DUTY, ORDER | không bỏ qua dấu hiệu kết cấu chưa giải thích |
| N19 | SECURITY, CARE, ORDER | bảo vệ kho/phòng nhưng không có quyền cấm Huệ rời đi |
| N20 | AUTONOMY, MASTERY, CARE | không muốn tiếp tục chỉ làm người chuyển lời; cố giữ nội dung nguồn rõ |

Các ranh giới là Belief/Policy của NPC và có thể bị vi phạm trong stress, ép buộc hoặc thay đổi giá trị; nếu vậy phải có DecisionFrame và hậu quả tự đánh giá, không tự khóa hành động.

## 6. AffectState hướng vào đối tượng

Một cảm xúc không chỉ là thanh cộng dồn. Hồ sơ gồm:

| Trường | Ý nghĩa |
|---|---|
| `emotion_type` | lo/sợ, giận, buồn, tội lỗi, xấu hổ, hy vọng, nhẹ nhõm, hài lòng, biết ơn… |
| `about` | người, vật, mục tiêu, sự kiện hoặc khả năng được đánh giá |
| `appraisal_source` | Belief/Observation/Memory nào làm phát sinh |
| `intensity_bp` | 0–10.000 điểm nguyên của fixture |
| `certainty` | người đó chắc nguyên nhân/đối tượng tới đâu |
| `action_tendency` | xu hướng chú ý/tiếp cận/tránh/sửa chữa; không phải Action bắt buộc |
| `display` | đã biểu lộ cho ai, bằng tín hiệu nào |
| `updated_at` | mốc cập nhật và sự kiện đã áp |

Hai cảm xúc trái chiều có thể cùng tồn tại: Phúc vừa tự hào Huệ muốn học vừa lo cô đi xa; An vừa biết ơn H01 hợp tác vừa muốn đóng C01 đúng sổ. Không nén thành một con số vui/buồn.

## 7. Đánh giá sự kiện tạo cảm xúc

Khi một người nhận Fact/Belief liên quan, họ đánh giá:

1. có liên quan mục tiêu/giá trị nào;
2. kết quả thuận hay nghịch và mức ảnh hưởng họ **tin**;
3. đã xảy ra hay chỉ có khả năng;
4. ai/cái gì có trách nhiệm theo hiểu biết của họ;
5. họ có khả năng kiểm soát/sửa chữa nào đã biết;
6. có vi phạm kỳ vọng văn hóa/cá nhân không;
7. độ mới và chắc của thông tin.

Ví dụ đề xuất:

- nguy cơ chưa chắc + VAL-SAFETY liên quan → lo/sợ, không phải biết nguy cơ thật;
- cản trở có người bị quy trách nhiệm → có thể giận;
- tin mình gây hậu quả trái giá trị → tội lỗi;
- tin người quan trọng đánh giá xấu bản thân → xấu hổ;
- kết quả tốt còn bất định nhưng có đường đạt → hy vọng;
- nguy cơ tin là đã qua → nhẹ nhõm.

Appraisal sai vẫn tạo cảm xúc thật đối với người đó. Bằng chứng mới có thể đổi đối tượng/cường độ nhưng không xóa FactEvent rằng họ đã từng phản ứng.

## 8. PressureLoad — tải sức ép

`PressureLoad` dùng 0–10.000 bp và sáu thành phần, không phải bệnh hay “thanh điên”:

| Thành phần | Nguồn |
|---|---|
| `body` | đói, khát, đau, mệt, suy chức năng từ Body |
| `time` | hạn gần, trễ, nhiều cam kết cạnh nhau |
| `cognitive` | nhiều điều chưa rõ, tính/ghi/quan sát kéo dài |
| `social` | đánh giá, xung đột, sợ mất vị trí/niềm tin |
| `moral` | hai giá trị/ nghĩa vụ va nhau, tin đã làm trái giá trị |
| `uncertainty` | hậu quả quan trọng nhưng thiếu tin/bằng chứng |

Tổng hiển thị phát triển là hàm có trần, không cộng thẳng vô hạn. Các dải thử:

| Tải | Hiệu ứng có thể kiểm chứng |
|---:|---|
| 0–2.499 | nền; không sửa năng lực |
| 2.500–4.999 | tăng ưu tiên tín hiệu liên quan, giảm kiên nhẫn với việc phụ |
| 5.000–7.499 | thu hẹp số phương án được cân nhắc, tăng nhu cầu nghỉ/hỏi hỗ trợ/kiểm soát |
| 7.500–10.000 | nguy cơ bỏ bước hoặc phản ứng mạnh nếu Skill/Disposition/Support không bù; vẫn không bắt buộc một lỗi cụ thể |

Tải không trừ “IQ”. Mọi thay đổi chú ý, thời gian, sai số hoặc lựa chọn cần đi qua Action/Capability/DecisionFrame đã khai báo. Người OR cao có thể kiểm lại nhiều hơn dưới stress và chậm hơn, thay vì luôn phạm lỗi.

## 9. Trạng thái cảm xúc/sức ép ngày 1

Các mức dưới đây có nguồn từ SEC/LongGoal/HIST, không tạo hành động tương lai. `Load` là tổng khởi tạo trước nhu cầu sinh lý trong ngày.

| ID | Load | AffectState nổi bật (cường độ) | Nguồn/đối tượng |
|---|---:|---|---|
| P00 | U | do người dùng/chính sách P00 xác định | chỉ Body, mục tiêu và Belief khách quan đã có |
| N01 | 3.800 | lo C01 3.600; hy vọng sửa mái 2.400 | MED-DEBT, H01-ROOF |
| N02 | 4.100 | lo dự trữ/mái 4.200; hy vọng phối hợp được với Lâm 3.000 | SEC02, C01 |
| N03 | 2.600 | lo khả năng phục vụ O01 3.200; biết ơn H01 hợp tác 2.200 | vai trò O01, SEC03 |
| N04 | 3.000 | lo bị đánh giá sai 3.400; hy vọng được giao ca 2.800 | APPRENTICE, SEC04 |
| N05 | 3.300 | lo V23 4.000; hy vọng giữ chuyến 3.200 | SEC05, MARKET-PACT |
| N06 | 2.900 | lo vốn 3.200; hy vọng dòng vốn ổn định 3.000 | SEC06, vai trò O04 |
| N07 | 2.400 | hy vọng truyền nghề 3.000; lo việc nặng tương lai 2.400 | SEC07, vai trò O02 |
| N08 | 2.600 | háo hức học 3.200; sốt ruột vì quyền hẹp 2.500 | SEC08, học việc |
| N09 | 2.300 | hy vọng thu đúng vụ 3.000; hài lòng về phối hợp nhóm 2.600 | FIELD-REFORM |
| N10 | 3.300 | lo nguồn giống 4.000; gắn bó H02 3.200 | SEC09 |
| N11 | 3.200 | lo bị coi thiếu trung thành 4.100; hy vọng học 3.600 | SEC10, LITERACY |
| N12 | 2.700 | lo vì chú cũ 3.300; hy vọng đối chiếu rõ 3.400 | SEC11 |
| N13 | 3.600 | tội lỗi về sự cố 4.200; hy vọng dạy an toàn 4.000 | SEC12, O03-INCIDENT |
| N14 | 3.700 | lo tụt sau 4.300; hy vọng ổn định 3.500 | SEC13 |
| N15 | 3.500 | sợ bị gắn sự cố 3.900; tò mò Liệt Mạch 4.400 | SEC14 |
| N16 | 3.000 | lo khoảng trống quyền 3.400; an tâm khi sổ kho khớp 3.600 | SEC15, O03-INCIDENT |
| N17 | 2.200 | hy vọng giữ cam kết 3.000; lo người khác gặp nguy 3.400 | SEC16, MARKET-PACT |
| N18 | 4.000 | lo tiếng rung 4.500; hy vọng kiểm rõ nguyên nhân 4.200 | SEC17 |
| N19 | 3.600 | lo Huệ đi xa 4.300; hài lòng khi O05 ổn định 3.800 | SEC18 |
| N20 | 3.400 | hy vọng học xa 4.200; lo nghĩa vụ O05 3.200 | SEC19 |

Các cảm xúc trong bảng không thay Relationship, Goal hoặc Value nguồn. Cường độ khác loại không được cộng để tìm “cảm xúc thắng”.

## 10. Điều hòa và cách ứng phó ưu tiên

`CopingPreference` chỉ làm một phương án dễ được nghĩ tới nếu người đó biết/có thể làm.

| ID | Phương án thường xét sớm | Điểm dễ lệch khi tải cao |
|---|---|---|
| P00 | do người dùng/chính sách nhân vật chọn | chưa cho hệ tự dựng phản ứng chống lệnh |
| N01 | hành động thực tế, tìm việc/nguồn | né nói về nợ vì ngại đánh giá |
| N02 | kiểm dự trữ, lập thứ tự chi | giữ nguồn quá chặt khi chưa đủ tin |
| N03 | phân loại cấp bách, hỏi triệu chứng/nguồn | ôm trách nhiệm chuyên môn lâu |
| N04 | hỏi An, chuẩn bị/kiểm lại | trì hoãn báo thành quả vì sợ sai |
| N05 | kiểm xe/tuyến, đổi lịch có lý do | cố tự giải quyết trước khi báo Hòa |
| N06 | tính vốn, thương lượng và kiểm soát thông tin | ưu tiên dòng tiền quá mức nhu cầu bảo trì xa |
| N07 | làm chậm, kiểm chất lượng, hướng dẫn | ít nói nhu cầu giảm việc nặng |
| N08 | luyện lại, xin thêm thao tác | xin mở rộng trước khi chứng cứ đủ |
| N09 | trực tiếp làm/phân công ruộng | ít dành thời gian giải thích xung đột sổ |
| N10 | giữ dự phòng, rà kế hoạch mùa | phản đối bán sớm từ Belief thiếu cập nhật |
| N11 | làm chăm hơn, tự tìm cách học | không hỏi rõ vì sợ bị coi thiếu trung thành |
| N12 | đối chiếu sổ/vật, hỏi người liên quan | kiểm lặp làm chậm cấp kho |
| N13 | siết bước an toàn, tự rà trách nhiệm | tự trách quá mức phần không do mình |
| N14 | luyện lặp, giữ phản ứng kín | so sánh ngầm làm tăng tải mà thầy không biết |
| N15 | viết đề xuất, thử giả thuyết hợp lệ | tranh luận mạnh khi thấy bị gắn sự cố |
| N16 | dừng cấp, ghi và kiểm mốc | giữ thủ tục khi tình huống cần hỏi quyết định mới |
| N17 | bảo vệ người, đổi ưu tiên rõ | nhận chi phí cá nhân trước khi tìm hỗ trợ |
| N18 | kiểm dấu, cảnh báo và ghi | tập trung cầu làm hẹp chú ý nhu cầu khác |
| N19 | kiểm kho/phòng, tìm cách giữ người gần | nói vòng thay vì hỏi thẳng mong muốn Huệ |
| N20 | tìm tin/cơ hội, nói với bạn tin cậy | trì hoãn nói Phúc vì sợ mất tự chủ |

Ứng phó có thể tốt trong một tình huống và gây phí trong tình huống khác. Hệ không gắn nhãn “lành mạnh/xấu” toàn cục.

## 11. Cảm xúc giảm, kéo dài và được gợi lại

Mỗi AffectState có `recovery_rule`. Thời gian bán giảm mặc định sau khi nguyên nhân **được người đó tin là đã kết thúc**:

| Loại | Bán giảm fixture |
|---|---:|
| ngạc nhiên | 30 phút |
| bực tức tình huống | 3 giờ |
| sợ cấp thời sau khi an toàn | 4 giờ |
| lo chưa giải quyết | 12 giờ, nhưng được duy trì nếu nguy cơ còn được tin là thật |
| xấu hổ/tội lỗi | 48 giờ; appraisal trách nhiệm chưa sửa có thể tái kích hoạt |
| nhẹ nhõm/hài lòng | 8 giờ |
| hy vọng theo mục tiêu | 24 giờ; cập nhật ở mốc tiến triển/thất bại |

Đây là tham số gameplay, không tuyên bố về con người thật. Hệ số cá nhân từ PE/SE/EX và Memory chỉ được áp một lần. HIST:O03-INCIDENT không khiến cảm xúc năm năm trước còn nguyên bằng bán giảm; SEC12 tồn tại vì Vân vẫn giữ appraisal “mình có phần trách nhiệm” và nó được gợi lại khi xử quyền O03.

Ngủ/nghỉ không xóa cảm xúc như hồi mana. Chúng giảm `body/time/cognitive load` theo điều kiện cơ thể; nội dung chưa giải quyết có thể còn.

## 12. Từ tâm lý vào DecisionFrame

Quy trình:

1. lấy Fact/Belief người đó biết;
2. đánh thức Goal/Need/Commitment liên quan;
3. tạo Appraisal và cập nhật Affect/Pressure đúng một lần theo event id;
4. sinh phương án đã biết, có quyền và có thể làm;
5. đánh giá hậu quả chủ quan theo giá trị, quan hệ, rủi ro, chi phí, cảm xúc và cam kết;
6. loại giới hạn bắt buộc; áp công chuyển việc/hysteresis;
7. chọn, ghi lý do và mốc đánh giá lại;
8. sau kết quả, so kỳ vọng với thật để học và đổi tâm lý.

Điểm phương án dùng số nguyên có nguồn:

`Score = GoalFit + ValueFit + RelationshipFit + ExpectedBenefit − ExpectedHarm − ResourceCost − SwitchCost + AffectAttention`

- Disposition điều chỉnh cách ước lượng/tìm phương án, không cộng một “điểm tính cách” thẳng vào mọi lựa chọn.
- AffectAttention thay độ nổi bật/phương án được xét; nó không biến lo thành hành động chạy trốn bắt buộc.
- Hai phương án gần nhau giữ việc đang làm nếu chưa vượt ngưỡng đổi; RNG chỉ dùng ở hòa thật sau các tiêu chí và phải lưu draw.
- Lý do giao diện dựa trên thành phần người đó có thể tự nhận/biểu lộ, không lộ SEC.

## 13. P00 và quyền tự chủ của người chơi

Ba chính sách vẫn mở, không tự chốt trong K1.10:

| Chính sách | Hệ quả |
|---|---|
| `PLAYER-DIRECT` | lệnh/giới hạn người chơi quyết định; cảm xúc chỉ thông báo và ảnh hưởng trải nghiệm, không phủ quyết |
| `PLAYER-CHARACTER` | người chơi chọn tính cách/giá trị; nhân vật có thể đề nghị đổi/dừng theo chính sách đã thấy |
| `HYBRID-CONSENT` | người chơi đặt mục tiêu, nhân vật tự xử lý trong ranh giới và xin quyết định khi xung đột lớn |

INIT-A hiện dùng hành vi tương thích `PLAYER-DIRECT`: P00 tuân mục tiêu mẫu sau nhu cầu sống/cam kết đã ghi, không có xu hướng bí mật. Điều này chỉ để fixture tái hiện, không nâng thành quyết định trải nghiệm của người dùng.

NPC độc lập luôn giữ DecisionFrame của mình. Người chơi giao việc cho họ qua đề nghị/hợp đồng, không sửa Value/Affect trực tiếp.

## 14. Biểu lộ, che giấu và quan sát xã hội

Nội tâm không tự truyền. `EX` ảnh hưởng xác suất/cường độ tín hiệu khi người đó không chủ động che, nhưng người khác chỉ nhận:

- lời đã nói;
- nét mặt/tư thế/giọng mà giác quan và mô hình cơ thể hỗ trợ;
- hành động như kiểm lại, tránh gặp, tăng tốc, im lặng;
- lời kể từ nguồn khác.

Người quan sát suy luận Affect với độ chắc, không đọc `intensity_bp`. EX thấp có thể vẫn nói thẳng do VAL-HONOR/DUTY; EX cao có thể che bí mật do quyền/quan hệ. “N14 im lặng” không chứng minh cô không lo; “Tùng tranh luận” không chứng minh anh thù Vân.

Mỗi display có người nhận/phạm vi. Debug xem nội tâm; giao diện P00 chỉ hiện tín hiệu và suy luận của P00.

## 15. Tâm lý, quan hệ và danh tiếng

Một sự kiện có thể cập nhật riêng:

- cảm xúc ngắn hạn về người/sự kiện;
- trust theo lĩnh vực nếu kết quả cung cấp bằng chứng;
- ValueCommitment nếu người đó tự đánh giá lựa chọn;
- Memory nổi bật;
- danh tiếng chỉ sau truyền tin.

Không trừ quan hệ chỉ vì giận, hoặc tăng thiện cảm chỉ vì được lợi. N06 có thể bực Bình làm trễ nhưng tăng tin cậy an toàn nếu tin Bình đã dừng một xe nguy hiểm đúng lúc. N13 có thể từ chối đề xuất của Tùng mà vẫn tôn trọng khả năng nghiên cứu.

## 16. Thay đổi tính cách dài hạn

Disposition chỉ đổi khi có `AdaptationEvidence`:

- nhiều sự kiện cùng loại trong thời gian dài;
- kết quả khác rõ kỳ vọng;
- người đó nhận ra mẫu và cập nhật cách làm;
- thay đổi vai trò, cơ thể hoặc môi trường kéo dài;
- học một chiến lược điều hòa mới và thực hành.

Một lần thành công không biến CA1 thành CA4. Đề xuất giới hạn thay đổi tối đa 1 điểm/trục trong 90 ngày fixture và cần ít nhất ba Episode độc lập có cùng hướng; đây là chống dao động, chưa là quy luật tâm lý ngoài đời. Sự kiện cực lớn có thể đề nghị ngoại lệ nhưng phải ghi nguồn, không dùng để tạo bi kịch ngẫu nhiên.

Giá trị có thể đổi nhanh hơn khi người đó chủ động cam kết sau biến cố, nhưng không xóa lịch sử lựa chọn cũ. R0–R4 đều giữ từng Disposition/Value/Affect quan trọng; vùng xa không cộng “hạnh phúc dân số” rồi phân ngược cho cá nhân.

## 17. Áp vào các xung đột hiện có

### TL-X01 — H01: trả C01 hay giữ tiền cho mái

Lâm nghiêng HONOR; Mai nghiêng SECURITY/ORDER. Cả hai biết nợ và quỹ, nhưng Mai biết SEC02 còn Lâm chưa biết. Trước shared commitment, họ cần trao đổi dự toán; nếu Mai chưa nói, DecisionFrame của Lâm không được dùng con số bí mật. Nhánh cơ sở vẫn trả đúng ngày 10; overlay có biến cố nguồn mới mới được đổi kết quả.

### TL-X02 — V23: đúng hẹn hay dừng kiểm xe

Bình CA3 + DUTY/HONOR/SAFETY. Khi chỉ có lo SEC05, anh có thể kiểm hoặc báo; khi có Evidence xe không an toàn, SAFETY có thể vượt hạn chuyến. Hòa đánh giá vốn/doanh thu, Dũng đánh giá tuyến. Không dùng “Bình đáng tin” để buộc anh luôn đi hoặc luôn dừng.

### TL-X03 — O03: quyền duyệt thay

Yến OR4/CA4 muốn lấp khoảng quyền; Vân CA4 mang tự trách SEC12; Tùng NO4/AU4 muốn linh hoạt. Cùng Proposal có thể tạo hy vọng ở Yến, lo ở Vân, sốt ruột ở Tùng. OrgRule vẫn quyết định quyền; cảm xúc không tự sửa REC-O03-RIGHTS.

### TL-X04 — Kha và Tùng nhận cùng một lời từ chối

Kha SE4/EX1 có thể giữ lo trong lòng và luyện lại; Tùng SE4/EX3 có thể hỏi lý do/viết đề xuất. Hai người không dùng chung phản ứng dù cùng KnowledgeUnit. Nếu lý do rõ và công bằng, trust có thể giữ; nếu họ tin bị gắn sự cố cũ, appraisal khác.

### TL-X05 — Dũng gặp người nguy hiểm trong ca gác

VAL-CARE/SEC16 có thể làm Dũng muốn cứu; DUTY giữ ca gác và hợp đồng cũng có thật. Anh cần đánh giá mức nguy hiểm, khả năng gọi thay và thời gian. Cứu người không tự xóa vi phạm ca; ở lại gác cũng không chứng minh thiếu CO.

### TL-X06 — Tâm và tiếng rung

SEC17 tạo lo 4.500 nhưng chưa là cầu hỏng. OR/CA cao ưu tiên InspectionEvent và báo có điều kiện; stress không cho phép đóng cầu bằng dữ liệu toàn tri. Nếu kiểm không thấy lỗi, lo có thể giảm hoặc chuyển thành bất định tùy Evidence.

### TL-X07 — Phúc và Huệ

Phúc CARE/SECURITY lo mất người thân/lịch O05; Huệ AUTONOMY/CURIOSITY muốn học. Phúc chỉ có thể hỏi, đề nghị hoặc đổi hợp đồng trong quyền; lo không cấp quyền cấm. Huệ che ý định làm Phúc thiếu thông tin, nhưng không tự là phản bội.

### TL-X08 — P00 nhận lệnh có rủi ro

Với PLAYER-DIRECT, hệ hiện cảnh báo từ Body/Belief/ràng buộc và thực hiện trong quyền, không bốc một Trait để từ chối. Với hai chính sách khác, chỉ tính tâm lý sau khi người dùng đã thấy/chọn hồ sơ P00. Cùng fixture không trộn ba chính sách.

## 18. Quá tải, sai sót và phục hồi

PressureLoad cao có thể:

- làm ít phương án được gọi lại từ trí nhớ;
- kéo dài/giảm thời gian kiểm tùy OR và hạn;
- tăng trọng số nguy cơ hoặc đánh giá xã hội đang nổi bật;
- tăng khả năng chọn coping quen;
- tạo nhu cầu nghỉ, hỏi giúp, hoãn hoặc rời tình huống.

Lỗi cụ thể chỉ xảy ra nếu có cơ chế: bỏ một bước quan sát, đọc thiếu tín hiệu, dùng Belief cũ, tính nhầm trong giới hạn C, hoặc thao tác cơ thể sai. Không có phép “stress > 7.500 thì làm điều ngu ngốc ngẫu nhiên”.

Phục hồi cần thời gian và điều kiện thật: ngủ, ăn/uống, nguy cơ kết thúc, hoàn cam kết, nhận tin rõ, được hỗ trợ, hoặc giải quyết xung đột giá trị. Một cuộc nói chuyện chỉ giảm phần Load mà nội dung thực sự tác động.

## 19. StoryArc và lời kể

Affect/Value tạo góc nhìn cho Episode nhưng không tạo cốt truyện. Cùng sự kiện “C01 được trả” có thể được:

- Lâm nhớ như giữ được danh dự;
- Mai nhớ như một lần dự trữ giảm nhưng nghĩa vụ đóng;
- An nhớ như sổ y quán được giải quyết;
- người không biết không có StoryArcView về nó.

Tóm lược có thể dùng nhãn “áp lực nợ”, “học cách tin”, “xung đột tự chủ”, nhưng nhãn không được phát lại cảm xúc hay cập nhật quan hệ lần hai khi tải save.

## 20. Giao diện đa nền tảng

Giao diện NPC cho P00 chỉ hiện:

- hành vi/tín hiệu P00 đã quan sát;
- lời người đó tự nói;
- suy luận của P00 kèm độ chắc;
- quan hệ và cam kết P00 biết.

Không hiện Trait/Value/Load thật của NPC. Công cụ phát triển có thể mở chuỗi `Belief → Appraisal → Affect → phương án → Score → Action` và nguồn mỗi số.

Điện thoại dùng từng thẻ “điều biết / điều đoán / hành động thấy”; máy tính có thể đặt cạnh dòng thời gian. Hai giao diện không đổi Attention, DecisionFrame hoặc RNG chỉ vì số mục đang hiển thị.

## 21. Bất biến

1. Không có điểm thiện–ác, tỉnh táo hay hạnh phúc tổng hợp thay cho trạng thái cụ thể.
2. Trait không tự tạo Action, quyền, tri thức hoặc FactEvent.
3. Affect luôn có đối tượng/nguồn; không tăng lại khi tải save.
4. Pressure không gây lỗi nếu thiếu cơ chế Action/Capability tương ứng.
5. Nội tâm không truyền cho người khác nếu thiếu display/Message/Observation.
6. Quan hệ, danh tiếng, cảm xúc và nghĩa vụ không sao chép lẫn nhau.
7. P00 không có tính cách bí mật chống lệnh trong fixture hiện tại.
8. NPC không đổi giá trị vì người chơi chọn câu thoại “thuyết phục” mà thiếu lý do/bằng chứng.
9. Disposition dài hạn không dao động theo từng việc nhỏ.
10. Cùng save/RNG/lệnh và chính sách P00 phải cho cùng diễn biến tâm lý trên điện thoại/máy tính.

## 22. Điều kiện kiểm thử TL01–TL26

1. TL01 — Ma trận có đúng P00/N01–N20; P00 giữ U và NPC có tám trục.
2. TL02 — Không hệ nào cộng tám trục thành điểm tính cách chung.
3. TL03 — CO thấp không bị diễn giải tự động thành hành vi xấu hoặc từ chối cứu.
4. TL04 — CA cao vẫn có thể nhận rủi ro khi Value/Goal khác có căn cứ vượt lên.
5. TL05 — Một Fact chỉ cập nhật Affect một lần theo event id, kể cả lưu/tải.
6. TL06 — Affect có `about/source`; không có lo/giận vô chủ làm lệnh hành động.
7. TL07 — Belief sai có thể tạo cảm xúc thật nhưng không sửa sự thật thế giới.
8. TL08 — Hai cảm xúc trái chiều cùng tồn tại, không ép lấy loại cường độ cao nhất.
9. TL09 — SEC không lộ qua giao diện chỉ vì tạo Affect nội bộ.
10. TL10 — EX thấp không làm người quan sát biết cường độ thật; EX cao không tự tiết lộ bí mật.
11. TL11 — PressureLoad tách sáu nguồn và không trừ trí tuệ/năng lực chung.
12. TL12 — Tải cao chỉ gây sai sót qua bước cụ thể bị bỏ/hiểu/tính/thao tác sai.
13. TL13 — N12 OR4 dưới áp lực có thể kiểm lâu hơn thay vì bắt buộc sai sổ.
14. TL14 — Lâm không dùng SEC02 trong DecisionFrame trước khi Mai truyền đạt.
15. TL15 — Trả C01 cập nhật Lâm/Mai/An khác nhau theo giá trị và tri thức.
16. TL16 — Bình dừng xe theo Evidence không bị coi là thất hứa tự động.
17. TL17 — Cảm xúc ba người O03 không sửa RoleRight nếu thiếu quyết định thể chế.
18. TL18 — Kha/Tùng nhận cùng Message có thể sinh Appraisal/coping khác có nguồn.
19. TL19 — Dũng cân nhắc cứu người và ca gác; không có kết quả cốt truyện bắt buộc.
20. TL20 — Tiếng rung tăng chú ý của Tâm nhưng không tự tạo cầu hỏng/đóng tuyến.
21. TL21 — Lo của Phúc không cấp quyền cấm Huệ; tự chủ của Huệ không xóa nghĩa vụ O05.
22. TL22 — PLAYER-DIRECT không dùng Trait bí mật phủ quyết lệnh P00.
23. TL23 — Thay chính sách P00 cần cấu hình/fixture version rõ, không trộn save.
24. TL24 — Disposition không đổi quá giới hạn 90 ngày nếu thiếu AdaptationEvidence.
25. TL25 — StoryArcView không phát lại Affect hoặc quan hệ khi tải/tóm lược.
26. TL26 — Cùng save/RNG/lệnh/chính sách cho kết quả giống nhau trên điện thoại và máy tính.

Toàn bộ TL chưa chạy. Cộng 26 TL với 322 điều kiện trước đó cho **348 điều kiện thiết kế chưa chạy bằng mô phỏng**.

## 23. Giới hạn và bước kế tiếp

K1.10 chưa mô hình hóa bệnh lý tâm thần, sang chấn lâm sàng, nghiện, phát triển tâm lý trẻ em, hormone, ảnh hưởng công pháp lên tâm trí, thần thức/ảo thuật, giấc mơ hoặc khác biệt loài. Không nên thêm các phần đó bằng vài thanh chỉ số đơn giản.

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
