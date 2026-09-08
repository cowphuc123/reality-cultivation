---
aliases:
  - Nguồn quyết định K1.2
  - Dấu vết quyết định nhân vật
tags:
  - reality-cultivation
  - ke-hoach
  - npc
  - fixture-k1
status: de-xuat
updated: 2026-09-06
---

# Nguồn nhận thức và quyết định — K1.2

Tài liệu này cụ thể hóa [[NPC]], [[HANH_DONG]] và [[CONG_VIEC_THU]] cho lịch [[LICH_21_NGUOI_K1]]. Mục tiêu là trả lời được: nhân vật biết gì, biết từ đâu, đã suy ra điều gì, đang cố đạt điều gì, vì sao chọn bước hiện tại và điều gì sẽ khiến họ đổi ý.

Đây là fixture thiết kế đề xuất. Nó chưa mô phỏng tâm trí con người, chưa được chạy và không chốt quyền chống lệnh của nhân vật người chơi.

## 1. Năm lớp không được trộn

| Lớp | Nội dung | Ai được dùng |
|---|---|---|
| Sự thật thế giới | Vị trí thật, lượng kho, thương tích thật, hợp đồng thật, sự kiện đã xảy ra | Bộ mô phỏng và công cụ kiểm chứng |
| Quan sát | Tín hiệu một người thực sự có cơ hội thấy, nghe, chạm, đọc hoặc kiểm tra | Chỉ người quan sát và người nhận bản ghi hợp lệ |
| Niềm tin | Cách một người hiểu nội dung từ quan sát, lời kể, ký ức hoặc suy luận | Bộ quyết định của chính người đó |
| Ý định | Mục tiêu, nghĩa vụ được nhận thức, thói quen và kế hoạch tương lai | Bộ quyết định của chính người đó |
| Quyết định | Các phương án đã xét, lý do loại, phương án chọn và mốc xét lại | Bộ thực thi; giao diện chỉ thấy phần P00 được phép biết |

Sự thật không tự chảy vào niềm tin. Một kho còn 20 suất không làm người ở nơi khác biết kho còn 20. Một nhân vật tin sai vẫn hành động theo niềm tin đó; khi chạm tới vật thật, hành động được kiểm tra lại bằng trạng thái thật và có thể thất bại.

## 2. Hồ sơ nguồn tối thiểu

### 2.1 Observation — quan sát

Mỗi quan sát lưu: mã, người quan sát, FactEvent nguồn, thời điểm sự việc, thời điểm nhận tín hiệu, kênh giác quan/thao tác kiểm tra, vị trí người quan sát, đối tượng được nhận diện hay mô tả chưa rõ, nội dung được phép lộ, độ rõ 0–1.000 và điều kiện cản trở.

Quan sát chỉ được tạo nếu vị trí, hướng, khoảng cách, trạng thái cơ thể, vật cản và thời lượng chú ý cho phép. Mở giao diện hoặc chạy bộ quyết định không tạo thêm quan sát.

### 2.2 Message — thông điệp

Thông điệp lưu người nói, người nghe, nội dung người nói định truyền, niềm tin nguồn của người nói, mức chắc được diễn đạt, thời điểm, phương tiện và chuỗi chuyển tiếp. Nội dung sai do nhầm lẫn khác với nội dung người nói biết là sai.

Người nghe nhận bằng chứng rằng “người này đã nói X”, rồi mới hình thành niềm tin về X. Mười người kể lại cùng một nguồn không thành mười bằng chứng độc lập.

### 2.3 Belief — niềm tin

Mỗi niềm tin lưu một mệnh đề có cấu trúc, chủ thể nhận thức, khoảng thời gian mà mệnh đề nói tới, trạng thái `tin/không tin/chưa quyết`, độ tin 0–1.000, các bằng chứng ủng hộ/phản bác, mốc được cập nhật và hạn dùng theo loại thông tin.

Độ tin là dữ liệu nội bộ để so sánh bằng chứng, không hiển thị như phần trăm tâm lý chính xác cho người chơi. Hai giả thuyết mâu thuẫn có thể cùng tồn tại; hệ thống không ép một cờ đúng/sai duy nhất trong đầu NPC.

### 2.4 Memory — ký ức

Ký ức trỏ tới quan sát, thông điệp, quyết định hoặc kết quả quan trọng. Nó lưu mức nổi bật, cảm xúc liên quan, lần truy hồi gần nhất và bản tóm lược nếu chi tiết đã được gộp. Cam kết, quyền và nợ khách quan không nằm trong ký ức; quên chúng không xóa hồ sơ thế giới.

### 2.5 Inference — suy luận

Mỗi suy luận có mã quy tắc, các niềm tin đầu vào, kết luận, thời điểm, độ tin bị chặn bởi đầu vào yếu nhất và lý do hết hiệu lực. Không cho phép bộ quyết định truy vấn sự thật bí mật để điền kết luận.

K1 chỉ hỗ trợ các mẫu hẹp:

- đường A nối B và B nối C → có thể lập tuyến A–B–C đã biết;
- lịch lặp đã quan sát/được báo → dự đoán “có khả năng còn đúng” ở lần kế;
- lượng cá nhân đang giữ trừ nhu cầu đã biết → dự báo mốc thiếu của bản thân/nhóm được giao quản;
- hợp đồng đã nhận + hạn → tạo nghĩa vụ cần hành động;
- hành động thất bại vì điều kiện X → biết X thiếu tại thời điểm kiểm tra;
- người đi vào một tuyến → suy ra khu vực có thể đến, không suy ra ý định hoặc đích chính xác.

Suy đoán ý định người khác dừng ở một tầng. K1 không tính chuỗi vô hạn “A nghĩ B nghĩ A…”.

## 3. Độ mới và phạm vi của niềm tin

Mỗi loại thông tin có cách cũ đi khác nhau:

| Loại | Cách xử lý đề xuất trong fixture |
|---|---|
| Địa hình/tuyến đã đi | Không tự hết hạn trong 30 ngày; sự kiện cầu đóng có thể phản bác khả năng đi qua |
| Lịch sinh hoạt đã chia sẻ | Dùng cho lần kế nhưng mang trạng thái dự đoán, phải kiểm tra khi tới nơi |
| Giá và giờ mở quầy | Có hiệu lực dự kiến bảy ngày nếu không có tin mới; giao dịch vẫn kiểm tra giá thật |
| Tồn kho nhìn thấy | Chỉ chắc tại thời điểm kiểm; sau đó là “lần cuối thấy”, không phải lượng hiện tại |
| Vị trí một người | Hết giá trị trực tiếp khi người đó rời tầm quan sát; chỉ giữ “lần cuối gặp” |
| Hợp đồng/quyền của bản thân | Đọc từ hồ sơ khách quan khi chủ thể là một bên; biết thay đổi khi nhận thông báo/quan sát hợp lệ |
| Trạng thái cơ thể bản thân | Cập nhật từ cảm giác và kiểm tra; chẩn đoán sâu vẫn cần kỹ năng/dụng cụ |

Hạn dùng không làm niềm tin biến mất. Nó hạ tư cách từ “có thể hành động trực tiếp” xuống “cần xác nhận” hoặc tăng rủi ro dự kiến.

## 4. Mục tiêu và nguồn sinh mục tiêu

Mọi Goal phải trỏ ít nhất một nguồn:

- nhu cầu cơ thể được cảm nhận;
- trách nhiệm hộ/nghề/tổ chức đã có trong lịch sử;
- Contract/Right mà nhân vật biết mình là một bên;
- lệnh người chơi đã tiếp nhận;
- lời nhờ hoặc đề nghị đã nghe;
- cơ hội được quan sát;
- khát vọng bền của nhân vật;
- kết quả thất bại cần sửa hoặc điều tra.

Goal lưu kết quả mong muốn, ưu tiên, giới hạn, ngân sách, thời hạn, điều kiện hoàn tất/thất bại, nguồn, người đặt, mức tự do lập kế hoạch và mốc đánh giá lại. Một dòng tiểu sử không được tự biến thành mục tiêu đang hoạt động nếu chưa có nguồn kích hoạt.

## 5. Lệnh người chơi đối với P00

Lệnh là một Command có mã chống gửi lặp. Nó được chuyển thành bản diễn giải Goal để người chơi thấy trước: kết quả, ưu tiên, ngân sách, điều bị cấm, điều kiện dừng và mức tự động.

Trong FX-A-30D, overlay dùng chính sách tạm sau:

- P00 tiếp nhận mục tiêu hợp lệ của người chơi ở mức cao nhất sau nguy hiểm nhận biết, nhu cầu sống cấp bách và cam kết đã nhận.
- P00 được tự chọn đường, hỏi người và các thao tác thường nằm trong giới hạn mục tiêu.
- P00 không được bán V32, tiêu phần dự phòng 10 V01, nhận nợ mới, đi vào nơi chưa có quyền hoặc tự đột phá nếu lệnh không cấp rõ giới hạn tương ứng.
- P00 từ chối bước bất khả thi hoặc chưa biết cách, nhưng giữ mục tiêu và có thể chuyển sang tìm hiểu.
- Quy tắc này chỉ làm fixture tái hiện được; TN về tâm lý chống lệnh vẫn mở.

## 6. Một lượt quyết định ở pha 70–80

Sau khi mọi hậu quả cùng mốc đã gộp:

1. Pha 70 tạo các Observation hợp lệ và đưa Message đã đến cho người nhận.
2. Cập nhật Belief, Memory, cảm xúc và quan hệ từ đúng nguồn; chống áp dụng lại bằng mã bằng chứng.
3. Xác định Trigger: hoàn tất bước, nhu cầu vượt mốc, tin mới liên quan, hợp đồng đổi, mất quyền/dụng cụ, kế hoạch tới hạn hoặc lần hỏi lại.
4. Mở DecisionFrame với ảnh tham chiếu các niềm tin, mục tiêu, trạng thái cơ thể tự cảm nhận và cam kết mà chủ thể biết.
5. Sinh phương án từ hành động/kế hoạch đã biết. “Tìm hiểu”, “hỏi”, “chờ”, “nghỉ” và “báo không thể làm” là phương án thật.
6. Loại phương án vi phạm vật lý đã biết, giới hạn người chơi hoặc quyền thực thi. Rủi ro pháp lý/xã hội được đánh giá, không giả thành bất khả thi vật lý.
7. Xếp mức ưu tiên và tính Q theo [[CONG_VIEC_THU]]; ghi từng thành phần dựa trên niềm tin nào.
8. Áp chi phí chuyển việc, cam kết hiện tại và chính sách hòa. Nếu cần ngẫu nhiên, dùng luồng riêng của DecisionFrame và lưu lượt rút.
9. Ghi phương án chọn, lý do, kỳ vọng, tài nguyên cần giữ và mốc xét lại; sau đó mới đề nghị Action/Reservation.
10. Khi hành động hoàn tất/thất bại, so kết quả quan sát với kỳ vọng để cập nhật tri thức.

Một DecisionFrame đã đóng là bất biến. Lần đổi ý tạo frame mới liên kết frame cũ, không viết lại lịch sử để NPC trông có vẻ luôn hợp lý.

## 7. Hồ sơ DecisionFrame

| Trường | Ý nghĩa |
|---|---|
| decision_id, actor_id, at_ms | Danh tính, người quyết định và thời điểm |
| trigger_ids | Điều gì khiến phải xét lại |
| goal_ids | Các mục tiêu được cân nhắc |
| evidence_refs | Phiên bản Belief/Memory/Message đã dùng |
| policy_version | Chính sách ưu tiên, quyền tự động và hệ số |
| candidates | Phương án, tiền điều kiện được tin, dự báo thời gian/chi phí/rủi ro |
| rejected | Phương án bị loại và lý do người đó có thể biết |
| selected | Phương án được chọn cùng Q, mức ưu tiên và quy tắc hòa |
| expectation | Kết quả dự kiến và thời điểm kiểm lại |
| proposed_action_ids | Action/Reservation được tạo; có thể bị bộ thực thi từ chối |
| rng_ref | Luồng/chỉ số/kết quả nếu thật sự cần |
| supersedes | Frame trước bị thay thế, nếu có |

Công cụ phát triển có thể lần theo toàn bộ bảng. Giao diện người chơi chỉ diễn đạt phần P00 biết và không hiện điểm nội bộ của NPC khác.

## 8. Thói quen là kế hoạch có nguồn

RoutinePlan không phải lệnh dịch chuyển hằng ngày. Nó gồm nguồn hình thành, điều kiện kích hoạt, cửa sổ, địa điểm dự kiến, tài nguyên, thứ tự ưu tiên và mốc tái kiểm. Tới mỗi bước, hệ thống vẫn kiểm tra vị trí, cơ thể, quyền và vật thật.

Nguồn kế hoạch nền của An Khê:

| Người | Nguồn cho lịch K1.1 |
|---|---|
| N01 | Trách nhiệm nước H01; kinh nghiệm tuyến D02–D11 và tuyến quan sát D06; mục tiêu giúp hộ. |
| N02 | Vai trò quản H01, quyền phát V02 và cam kết C01; lịch làm tay hình thành từ nghề. |
| N03 | Vai trò y quán O01, quyền phát suất và lịch tiếp nhận đã công bố. |
| N04 | Phân công nước O01, học nghề từ N03 và các cuộc hẹn đã nhận. |
| N05 | Hợp đồng vận chuyển O04, lịch giao cụ thể và tuyến nghề đã biết; ngoại lệ giao hàng vượt lịch nền. |
| N06 | Vai trò quầy O04, phân công nước và quyền bán theo giá chào hiện hành. |
| N07 | Trách nhiệm kho/bữa O02 và nghề rèn tại D04. |
| N08 | Phân công nước O02 và vai trò phụ lò đã chấp nhận. |
| N09 | Phân công nước H02, trách nhiệm ruộng và các lô đã đạt mốc. |
| N10 | Phân công nước H02, trách nhiệm nguồn sống/giống của H02. |
| N11 | Việc ruộng/bảo dưỡng đã nhận; chỉ tìm việc khi không còn nghĩa vụ đã đặt. |
| N12 | Vai trò quản kho H02, quyền phát suất, mở J01, nghiệm thu và trả công. |
| N13 | Vai trò O03, quyền duyệt chi/tiếp cận và lịch nghiên cứu; buổi dạy chỉ tồn tại khi có đề nghị hợp lệ. |
| N14 | Phân công nước O03, mục tiêu học và quyền tu luyện đã biết của bản thân. |
| N15 | Phân công nước O03, mục tiêu học và quyền tu luyện đã biết của bản thân. |
| N16 | Vai trò giữ kho O03, quyền phát suất/nhận học phí trong giới hạn. |
| N17 | Phân công nước O04 và ca gác D07 đã nhận. |
| N18 | Trách nhiệm O06 và ca gác D10; biết rõ lúc mình rời cầu lấy nước thì cầu không được gác. |
| N19 | Trách nhiệm O05: nước, bếp, phòng và thu khoản trọ đã thỏa thuận. |
| N20 | Trách nhiệm hộ H01, hợp đồng giao O05→O06 và chuyển tin khi đã nhận nội dung cụ thể. |

Mỗi nguồn trên cần được khởi tạo bằng lịch sử trước ngày 1 hoặc Contract/Role thật. Nhãn nghề không tự cấp mọi đường đi, kỹ năng, quyền và lịch bí mật.

## 9. Chuỗi nguồn chính xác của P00 trong FX-A-30D

| Mốc | Nguồn nhận thức → mục tiêu → quyết định |
|---|---|
| Trước 06:00 ngày 1 | Ký ức thỏa thuận phòng với N19 tạo nghĩa vụ trả 1 V01 lúc 21:00 mỗi ngày đang ở; biết D01/D02, đồ đang mang và mục tiêu dự phòng 10 V01. |
| 06:30 ngày 1 | Goal người chơi “kiếm thu nhập hợp pháp, giữ sinh hoạt và dự phòng” khiến P00 hỏi N01. Lời N01 tạo niềm tin về N20 và D11, chưa tạo đường đầy đủ. |
| 06:39:10 | P00 hỏi N20 dựa trên tin N01. Lời N20 tạo niềm tin về D11, D05 và khả năng N12 có việc; không bảo đảm được nhận. |
| 06:44:10–07:12:05 | Chính hành trình tạo tri thức tuyến. N12 kiểm lô và thử kỹ năng tạo bằng chứng hiện tại về J01/quyền làm. |
| 07:37:05 | Hai bên chấp nhận C-A-J01-01; Contract tạo nghĩa vụ, giữ V22/lô/8 V01 và Goal hoàn tất lô trước 16:30. |
| 16:30 ngày 1–7 | Sau nghiệm thu, N12 trực tiếp đề nghị lô kế. P00 chỉ biết đề nghị kế sau khi nghe; mỗi hợp đồng được chấp nhận riêng, không giả biết trước tám lô. |
| 16:46:40 ngày 1 | P00 gặp N06 ở D01 và hỏi nơi mua lương thực. N06 báo giá 2 V01/V02, giờ quầy và điều kiện giao; P00 có niềm tin giá/lịch bảy ngày. |
| Cuối ngày 5 | Dự báo từ số V02 đang giữ cho thấy sẽ hết sau ngày 6; tạo kế hoạch mua hai suất chiều ngày 6, trong quyền chi và trên dự phòng. |
| 17:00 ngày 6 | Khi giao dịch mua, P00 hỏi về người dạy tu luyện. N06 dựa trên thông báo tuyển học viên do O03 gửi quầy trước ngày 1 và tuyến N06 từng đi để báo N13/O03, đường D01→D09, buổi trống ngày 9 và giá 12 V01; đây là lời giới thiệu, không cấp công pháp. |
| Ngày 7–8 | P00 tiếp tục J01 vì hợp đồng đã nhận; kế hoạch học ngày 9 chỉ được đặt nếu tiền sau chi phí dự báo vẫn không dưới 10. |
| 12:55 ngày 9 | P00 tới D09 theo tuyến được kể, kiểm tra N13 có mặt/đồng ý và trả tiền. Chỉ lúc thỏa thuận hợp lệ mới hình thành buổi học 13:00–15:00. |
| Ngày 10–30 | Không còn đề nghị J01 thứ chín. Goal thu nhập/tìm cơ hội sinh các lượt hỏi tại D01; thiếu quy trình định lượng khiến các lượt này chưa tạo đầu ra trong fixture. Lịch mua dùng kiểm đếm lương thực và giá/lịch được N06 xác nhận lại khi giao dịch. |

Nếu N01, N20, N06, N12 hoặc N13 không có mặt, P00 không nhận thông tin từ họ. Fixture phải đi sang nhánh chờ, hỏi nguồn khác hoặc kẹt; lịch K1.1 không được tự hoàn thành bằng tri thức toàn tri.

## 10. Chuỗi nguồn của các ngoại lệ hậu cần

- Các lô H02→O04 là hợp đồng đã được N05/N06/N12 biết trước ngày 1. Từng ngày giao tạo Goal theo hạn và thay đoạn lịch nền của N05.
- Đơn ngày 13/18/23/24 chỉ lên lịch sau khi người có quyền của bên mua chấp nhận. Tiền được giao giữ tạo Memory về trách nhiệm nhưng quyền chuyển vẫn do Contract/Right kiểm tra.
- O05→O06: N19, N20 và N18 biết lịch đã thỏa thuận. N18 không biết hàng đã rời D02; chỉ biết hàng đến khi thấy N20 hoặc nhận tin.
- C01: N02 biết nghĩa vụ của H01 từ hồ sơ bên hợp đồng. N03 chỉ biết đã thanh toán khi gặp N02, kiểm tiền và giao dịch hoàn tất.
- Suất N05 nhận trước có nguồn là lịch giao sớm ngày kế; N02 chỉ phát khi thấy Contract còn hiệu lực và chưa phát định suất ấy.

## 11. Tin cầu FX-C-MSG/NOMSG

Chuỗi có tin phải lưu:

1. N18 quan sát cầu hỏng và N05/kiện ở bờ D08.
2. N18 hình thành các niềm tin tương ứng.
3. N18 tạo Message có nội dung giới hạn rồi nói trực tiếp với N20.
4. N20 nhận Message, tạo Goal chuyển tin và mang đúng nội dung trên hành trình thật.
5. N03 chỉ nhận bằng chứng khi N20 tới D03 và truyền đạt.

Nhánh NOMSG bỏ bước 3–5. Cả hai nhánh giữ cùng sự thật về cầu và kiện; tuyệt đối không dùng cờ fixture để sửa trực tiếp Belief của N03.

## 12. Quyết định khi dữ liệu mâu thuẫn hoặc thiếu

- Nếu hai nguồn mâu thuẫn, giữ cả hai niềm tin, đánh giá độ độc lập, độ mới, mức tin theo lĩnh vực và bằng chứng trực tiếp.
- Nếu thiếu giá, đường hoặc quyền, sinh phương án hỏi/kiểm tra; không điền số trung bình bí mật.
- Nếu người cung cấp tin nói “không biết”, đó là kết quả giao tiếp, không phải bằng chứng rằng sự việc không tồn tại.
- Nếu một phương án chỉ thất bại do trạng thái thật mà chủ thể không biết, DecisionFrame vẫn ghi nó hợp lý theo niềm tin; Action ghi thất bại thực tế và tạo quan sát mới.
- Nếu không có phương án hợp lệ sau ba lần dựng thay thế, chọn chờ/nghỉ/báo kẹt và lên mốc xét lại 30→60→120 phút như DL04.

## 13. Tóm lược để thế giới lớn không mất lịch sử

Các ngày thường có thể gộp thành EpisodeSummary theo người, khoảng thời gian, nơi chính, công việc, nhu cầu được đáp ứng, biến động quan hệ và sự kiện ngoại lệ. Không giữ từng lần nhấp ngụm nước như ký ức kể chuyện dài hạn, nhưng sự kiện lượng vẫn tồn tại ở sổ cần thiết cho kiểm toán cho tới khi snapshot đã chốt tổng.

Không được tóm lược bỏ:

- nguồn của niềm tin/cam kết còn sống;
- giao dịch còn tranh chấp;
- sự kiện tạo thương tích, quan hệ hoặc kỹ năng còn ảnh hưởng;
- lần cuối biết vị trí/thời điểm nếu kế hoạch đang dùng;
- DecisionFrame đang chờ kết quả;
- chỉ số RNG và giao dịch chống áp dụng lặp.

## 14. Điều kiện kiểm thử QD01–QD20

Các điều kiện dưới đây đã định nghĩa nhưng **chưa chạy**:

1. QD01 — Không Belief nào xuất hiện nếu thiếu Observation, Message, Memory khởi tạo hoặc Inference hợp lệ.
2. QD02 — Mở giao diện, xem NPC hoặc chạy lại bộ quyết định không tạo tri thức mới.
3. QD03 — P00 không biết D05/D11 trước chuỗi hỏi và hành trình FX-A-BOOT.
4. QD04 — Lời N20 chỉ tạo khả năng có việc; N12 mới xác nhận J01 hiện còn mở.
5. QD05 — P00 không biết trước cả tám đề nghị J01; mỗi đề nghị có sự kiện nguồn riêng.
6. QD06 — Lịch mua ngày 6 sinh từ kiểm đếm lương thực và thông tin N06, không đọc kho O04 từ xa.
7. QD07 — Nếu N06 vắng ngày 1, P00 chưa biết quầy/giá; lịch mua phải đổi hoặc kẹt có lý do.
8. QD08 — Một lời báo về N13 không cấp công pháp, kỹ năng hoặc quyền vào O03.
9. QD09 — Buổi học ngày 9 chỉ hình thành sau khi N13 đồng ý và thanh toán hợp lệ.
10. QD10 — RoutinePlan bị thương/mất quyền/mất vật phải thất bại hoặc tái lập kế hoạch, không ép nhân vật tới mốc lịch.
11. QD11 — NPC không biết tồn kho, vị trí người hoặc cầu hỏng ở xa nếu chưa có nguồn.
12. QD12 — C-MSG và C-NOMSG có cùng sự thật; Belief N03 chỉ khác sau giờ Message tới.
13. QD13 — Tin được kể lại từ cùng gốc không nhân độ chắc như nguồn độc lập.
14. QD14 — Hai niềm tin mâu thuẫn cùng tồn tại và DecisionFrame ghi niềm tin nào được dùng.
15. QD15 — Phương án bị loại ghi lý do theo điều chủ thể biết, không rò bí mật qua thông báo.
16. QD16 — Cùng snapshot/lệnh/seed tạo cùng DecisionFrame và cùng lựa chọn.
17. QD17 — Tải lại không áp bằng chứng, cảm xúc, quan hệ hoặc lệnh người chơi lần hai.
18. QD18 — Tóm lược ký ức giữ mọi nguồn mà mục tiêu, cam kết và niềm tin sống còn tham chiếu.
19. QD19 — Lệnh gửi lặp cùng mã chỉ tạo một Goal; sửa lệnh tạo phiên bản mới có dấu vết.
20. QD20 — DecisionFrame đóng không bị viết lại; đổi ý tạo frame kế tiếp với Trigger thật.

## 15. Việc kế tiếp

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
