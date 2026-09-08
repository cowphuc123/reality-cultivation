---
title: Dấu vết quyết định và hội thoại 30 ngày — K1.11
aliases:
  - K1.11
  - Dấu vết quyết định An Khê
tags:
  - reality-cultivation
  - thiet-ke
  - fixture
  - quyet-dinh
  - hoi-thoai
status: de-xuat
updated: 2026-09-06
---

# Dấu vết quyết định và hội thoại 30 ngày — K1.11

Tài liệu này nối [[NGUON_QUYET_DINH_K1]], [[SO_THE_CHE_30_NGAY_K1]], [[NANG_LUC_NGON_NGU_TRI_THUC_K1]] và [[TAM_LY_21_NGUOI_K1]]. Nó biến tám xung đột TL-X thành dấu vết có thể kiểm tra: sự thật → nhận thức → niềm tin → đánh giá → phương án → hội thoại → quyết định → hậu quả.

Đây là fixture đề xuất chưa chạy hoặc được người dùng duyệt. Ngoài dấu vết H01 xác minh khoản trả C01 đã có trong lịch cơ sở, mọi kết quả chọn dưới đây chỉ thuộc một biến thể có đầu vào ghi rõ. Chúng không trở thành tương lai chính thức của NPC.

## 1. Ba lớp của một cuộc hội thoại

| Lớp | Dữ liệu | Quyền tạo thay đổi |
|---|---|---|
| `DialogueIntent` | người nói muốn hỏi/báo/đề nghị/từ chối gì | chỉ tạo kế hoạch nói |
| `UtteranceSignal` | âm thanh/chữ thực tế, ngôn ngữ, người có thể cảm nhận | tạo Observation nếu được nghe/đọc |
| `DialogueAct` | nghĩa người nhận giải mã: INFORM, ASK, PROPOSE… | có thể tạo Message/Belief; chỉ ACCEPT/COMMIT hợp lệ mới tạo cam kết |

Văn bản hiển thị là cách diễn đạt của `DialogueAct`, không phải nguồn sự thật mới. Một mô hình ngôn ngữ có thể chọn câu tự nhiên nhưng không được thêm giá, thời hạn, cảm xúc, lời hứa, bí mật hoặc quyền ngoài payload có cấu trúc.

## 2. Hồ sơ DecisionTrace

| Trường | Ý nghĩa |
|---|---|
| `trace_id/base/version` | id, snapshot/overlay và phiên bản dữ liệu |
| `wakeup_event` | Event/Observation/Message hoặc hạn làm cần đánh giá |
| `actor_state_refs` | Body, vị trí, lịch, Skill, Right, Belief, Goal, Value, Affect, Load |
| `known_options` | phương án người đó thật sự nghĩ tới và nguồn biết cách làm |
| `hard_filter` | lý do phương án không có quyền/không thể/vi phạm giới hạn bắt buộc |
| `appraisal` | liên quan, thuận/nghịch, trách nhiệm, kiểm soát, chắc chắn |
| `score_parts` | Goal, Value, Relation, Benefit, Harm, Cost, Switch, Affect |
| `selected` | phương án được chọn, tie-break/draw nếu có |
| `commitment` | Action/Message/Contract/Reservation được tạo |
| `expected_recheck` | mốc hoặc sự kiện đánh giá lại |
| `result_refs` | hậu quả thật và sai khác với kỳ vọng |
| `explanation_private/public` | lý do nội bộ và phần người đó đã nói/biểu lộ |

Trace là hồ sơ giải thích, không phải bộ nhớ riêng của NPC. NPC chỉ nhớ phần đã trải nghiệm; người chơi chỉ thấy phần P00 có nguồn biết.

## 3. Thang điểm fixture

Mỗi thành phần dùng số nguyên `−5.000…+5.000`; tổng có thể vượt khoảng đó nhưng chỉ dùng so phương án trong cùng một DecisionFrame.

| Thành phần | Dương khi | Âm khi |
|---|---|---|
| `G` GoalFit | tiến gần mục tiêu đang hoạt động | làm lùi/đe dọa mục tiêu |
| `V` ValueFit | phù hợp giá trị liên quan | đi ngược giá trị/ranh giới |
| `R` RelationshipFit | giữ/cải thiện quan hệ chủ thể coi trọng | làm hại quan hệ theo Belief |
| `B` ExpectedBenefit | lợi ích khác được dự báo | không dùng số âm; để ở H/C |
| `H` ExpectedHarm | ghi số dương rồi bị trừ | 0 nếu chưa dự báo hại |
| `C` ResourceCost | tiền, thời gian, sức, cơ hội; ghi dương rồi bị trừ | 0 nếu không đáng kể |
| `S` SwitchCost | bỏ việc/cam kết đang làm; ghi dương rồi bị trừ | 0 nếu ở điểm chuyển hợp lệ |
| `A` AffectAttention | cảm xúc làm phương án nổi bật/ít hấp dẫn | có thể dương hoặc âm |

`Total = G + V + R + B − H − C − S + A`.

Điểm dùng Belief chủ quan, không đọc tương lai thật. Hard filter chạy trước điểm. Các số dưới đây là fixture để kiểm tra cơ chế, không phải công thức tâm lý phổ quát. Chênh dưới 200 dùng hysteresis giữ cam kết cũ; vẫn hòa thì dùng thứ tự ưu tiên đã biết, cuối cùng mới dùng RNG có log.

## 4. DialogueTurn và trạng thái cuộc nói chuyện

| Trường | Nội dung |
|---|---|
| `speaker/recipients` | ai phát, ai có chủ đích nhận |
| `act_type` | GREET, INFORM, ASK, PROPOSE, CLARIFY, CONFIRM, ACCEPT, REFUSE, WARN, COMMIT, END |
| `payload` | mệnh đề/điều khoản cấu trúc và mức chắc người nói |
| `source_claimed` | người nói nói nguồn là gì; có thể không đầy đủ/sai |
| `privacy_scope` | công khai, nhóm, riêng một người |
| `language/lexicon` | LANG-AK và LEX cần dùng |
| `duration/focus` | thời gian và năng lực giao tiếp bị chiếm |
| `signal/result` | lời thực tế, phần người nhận nghe/hiểu, Message tạo ra |
| `commitment_effect` | none/proposal/accepted contract/right/message task |

Trạng thái: `planned → speaking → awaiting_response → clarify/accepted/refused/interrupted → ended`. Im lặng không tự thành ACCEPT. Bị ngắt giữ lượt dang dở và phần tín hiệu đã phát; tiếp tục cần người còn ở phạm vi giao tiếp.

## 5. Cách ghi lời thoại mẫu

Mỗi lượt dưới đây có hai dòng:

- **Payload:** nội dung có thẩm quyền, dùng để mô phỏng.
- **Câu mẫu:** một cách diễn đạt tiếng Việt cho người thiết kế đọc; bản game sẽ thể hiện LANG-AK theo phong cách nhân vật.

Câu mẫu không được parse ngược để tạo trạng thái. Nếu câu văn và payload lệch, payload thắng trong fixture và lỗi diễn đạt phải được ghi để sửa.

## 6. DT-H01 — trả C01 và nỗi lo mái nhà

### 6.1 Snapshot và lịch

- Base: ngày 9, 18:30 tại D02, thay 20 phút sinh hoạt tùy ý của N01/N02; không đụng ăn, ngủ hoặc hành trình.
- Wakeup: C01 còn dưới 24 giờ; N02 biết SEC02, N01 chỉ biết mục tiêu mái chung.
- Sự thật: H01 có 160 V01 ban đầu trừ/ cộng các giao dịch đã có; C01 là 12 V01 đến ngày 10. Không có báo giá mái thật hoặc vật liệu mái trong kho.

### 6.2 DecisionTrace trước hội thoại

| Người/phương án | G | V | R | B | H | C | S | A | Total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Lâm: trả đúng hạn | 3.800 | 3.600 | 1.600 | 800 | 500 | 1.200 | 0 | 700 | 8.800 |
| Lâm: xin gia hạn | 1.800 | 800 | 600 | 1.500 | 1.200 | 200 | 0 | −400 | 2.900 |
| Mai: trả đúng hạn trước khi sửa mái | 3.200 | 2.800 | 1.800 | 600 | 1.100 | 1.200 | 0 | 100 | 6.200 |
| Mai: hỏi giá mái rồi mới quyết | 2.200 | 2.900 | 400 | 1.000 | 1.000 | 300 | 300 | 600 | 5.500 |

Lâm chưa có phương án “chi tiền sửa mái ngay” vì không biết giá/người bán/vật liệu. Mai có thể nói SEC02; trước Message đó Lâm không dùng Belief riêng của cô.

### 6.3 DialogueTurn

1. N02 `INFORM`, riêng N01, 90 giây. **Payload:** “Tôi ước lượng mái cần nhiều công hơn anh đang tính; đây là ước lượng của tôi, chưa phải báo giá.” **Câu mẫu:** “Em nghĩ mái tốn công hơn mình dự tính, nhưng chưa có giá thật.”
2. N01 `CLARIFY`, 45 giây. **Payload:** hỏi liệu trả 12 V01 có làm hộ thiếu bữa/nguồn đã giữ không. **Câu mẫu:** “Trả khoản y quán ngày mai thì phần ăn và việc đã nhận có hụt không?”
3. N02 `INFORM`, 60 giây. **Payload:** theo sổ hiện biết, không có Reservation khiến 12 V01 không thể trả; mái chưa có hợp đồng. **Câu mẫu:** “Khoản nợ đã có hạn; mái mới chỉ là dự tính.”
4. N01 `PROPOSE`, 45 giây. **Payload:** trả C01 đúng lịch, sau đó xin Mộc kiểm/báo nhu cầu thật. **Câu mẫu:** “Mình trả An trước, rồi nhờ Mộc xem mái để biết cần gì.”
5. N02 `ACCEPT`, 30 giây. **Payload:** đồng ý giao N02 mang 12 V01 ngày 10; chưa cam kết chi mái. **Câu mẫu:** “Được, em mang tiền; phần mái để sau khi có số thật.”

### 6.4 Kết quả fixture

Tạo kế hoạch C01 vốn đã có, Message SEC02 chỉ tới N01, và Goal mới “tìm kiểm tra mái” ở trạng thái chưa xếp lịch. Không tạo giá, hợp đồng hoặc vật liệu mái. Affect: lo của Lâm về C01 giảm sau khi kế hoạch chắc hơn nhưng chưa về 0 trước Transaction; lo mái của Mai còn.

## 7. DT-O04 — Bình báo lo bánh V23

### 7.1 Snapshot

- Overlay ngày 12, 17:15–17:35 tại D01; N05/N06 đã kết thúc lịch chính, N17 chỉ tham gia nếu đã về và không có cam kết trùng.
- Wakeup: N05 chọn truyền SEC05 sau lần quan sát mới. V23 vẫn `usable-but-watch`; chưa có Evidence cấm kéo, V24 rời hoặc báo giá.

### 7.2 Phương án của Bình

| Phương án | G | V | R | B | H | C | S | A | Total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| báo Hòa và đề nghị kiểm | 2.800 | 3.600 | 1.200 | 1.800 | 300 | 400 | 0 | 900 | 9.600 |
| giữ kín, tiếp tục lịch | 1.500 | −1.400 | −600 | 800 | 2.600 | 0 | 0 | −800 | −3.100 |
| tự lấy tiền mua bánh | hard filter: N05 không có quyền chi và không biết nguồn V24 |

### 7.3 Hội thoại

1. N05 `INFORM`: **Payload:** đã quan sát bánh có dấu cần kiểm; mức chắc vừa, chưa nói “sắp gãy”. **Câu mẫu:** “Bánh vẫn chạy được, nhưng dấu mòn lần này khiến tôi muốn kiểm trước chuyến tới.”
2. N06 `ASK`: hỏi dấu nào, ảnh hưởng lịch ngày 13 và cần bao lâu; không hỏi giá khi chưa có nguồn.
3. N05 `PROPOSE`: kiểm 20 phút sáng trước xếp hàng; nếu kết quả usable thì đi, nếu không thì đánh thức DecisionFrame mới.
4. Nếu N17 có mặt, N17 `INFORM`: chỉ nêu quan sát tuyến/điều kiện an toàn đã biết; vắng mặt thì không có lượt thay thế từ xa.
5. N06 `ACCEPT` trong biến thể O04-A; `REFUSE` trong O04-B nếu có cam kết trùng được chèn. Hai biến thể không dùng cùng kết quả.

### 7.4 Kết quả

- O04-A tạo InspectionAction, không Reservation tiền/V24.
- O04-B giữ SEC05 đã được chia sẻ và N05 có thể từ chối kéo sau Evidence mới; việc Hòa từ chối kiểm không tự làm xe hỏng.
- DomainReputation chỉ cập nhật sau kết quả, không từ ý định báo.

## 8. DT-O03-A — Yến đề nghị quyền duyệt thay

### 8.1 Hai đầu vào tách biệt

- `O03-NO-TRIGGER`: không có lịch Vân vắng; SEC15 chỉ là ý định. Không mở hội thoại.
- `O03-ABSENCE`: ngày 11, Vân nhận Message có nguồn rằng cô phải rời D09 ngày 13, 12:00–17:00. Đây là overlay, không sửa base.

Cuộc nói chuyện được đặt ngày 11, 18:30–19:00 tại D09, thay một khối hành chính/học tự do; chỉ bắt đầu nếu Vân/Yến có mặt và Kha/Tùng được mời thật.

### 8.2 Phương án của Yến

| Phương án | Total | Căn cứ nổi bật |
|---|---:|---|
| không nói | 1.000 | tránh xung đột nhưng để khoảng quyền |
| đề nghị quyền có hạn | 8.900 | ORDER/SAFETY/DUTY, Message vắng mặt, quyền kho hiện có |
| tự hành xử như đã có quyền | hard filter | REC-O03-RIGHTS không cho phép |

### 8.3 Hội thoại

1. N16 `PROPOSE`: quyền duyệt thay chỉ cho phiên đã có người học, tối đa nguồn/hạn cụ thể, hết 17:00 ngày 13; không nhận học viên/chuyển mức.
2. N13 `CLARIFY`: hỏi tình huống dừng, ngưỡng nguồn, cách ghi và ai được báo.
3. N14/N15 chỉ phát biểu nếu được mời và hiểu payload; im lặng không là đồng ý.
4. N13 chọn một trong ba variant:
   - `A-DEFER`: không có phiên cần duyệt → từ chối tạo quyền thừa;
   - `A-LIMITED`: có phiên đã duyệt + đủ Evidence → cấp Right có hạn;
   - `A-ASK-MORE`: thiếu thông tin → đặt mốc trả lời trước ngày 13.

### 8.4 Dấu vết variant A-LIMITED

| Phương án của Vân | G | V | R | B | H | C | S | A | Total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| cấp hạn hẹp | 3.200 | 3.600 | 1.400 | 1.500 | 900 | 500 | 0 | −200 | 8.100 |
| hủy mọi phiên | 1.800 | 1.500 | −800 | 600 | 300 | 800 | 0 | 400 | 2.400 |
| cấp toàn quyền | 2.000 | −2.800 | 200 | 1.800 | 3.400 | 200 | 0 | −900 | −3.300 |

Tự trách SEC12 tăng chú ý tới nguy cơ nhưng không tự chọn hủy/cấp. Right chỉ có hiệu lực sau ENTRY-RIGHT hợp lệ; Kha/Tùng biết phần được nói, không biết SEC12/SEC15.

## 9. DT-O03-B — Kha và Tùng nhận cùng lời từ chối

### 9.1 Payload chung

Ngày 12, Vân từ chối đề nghị “thêm một giờ tự luyện ngoài lịch” vì chưa có người giám sát và Reservation nguồn. Cùng UtteranceSignal tới N14/N15, cả hai H3/R không liên quan và K2 CULT nên hiểu mệnh đề.

### 9.2 Appraisal khác nhau

| Người | Appraisal | Affect update | Phương án nổi bật |
|---|---|---|---|
| N14 | bất lợi cho tiến bộ; dễ bị so sánh; Vân có lý do an toàn | lo tụt tăng 500, xấu hổ giả định +300 nếu tin Tùng đánh giá | hỏi tiêu chí rồi luyện phần đã duyệt |
| N15 | cản thử nghiệm; lo bị gắn sự cố; lý do có thể giải quyết bằng thiết kế | bực +500, lo danh tiếng +300, tò mò vẫn cao | hỏi điều kiện và viết Proposal |

### 9.3 DialogueTurn

1. N14 `CLARIFY`, giọng kín: hỏi bằng chứng nào cần để được thêm giờ có giám sát. Không nhắc SEC13.
2. N15 `CLARIFY`: hỏi liệu Reservation + người giám sát + giới hạn dừng có đủ để xét lại. Không cáo buộc Vân gắn anh với sự cố trừ khi Belief/Message mới hỗ trợ.
3. N13 `INFORM`: trả lời từng câu theo OrgRule, không dùng một câu “các ngươi chưa đủ” mơ hồ nếu tiêu chí đã biết.
4. N14 `CONFIRM` phần hiểu; N15 có thể `PROPOSE` nộp bản có điều kiện.

Kết quả khác về Goal/Action nhưng không tăng/giảm Skill ngay. Quan sát Tùng lên tiếng không làm Kha biết động cơ riêng của Tùng.

## 10. DT-DUNG — ca nguy cạnh trách nhiệm gác

### 10.1 Overlay

Tách khỏi INIT-A khỏe mạnh: dùng bản sao ngày 12, 10:00 tại D07. P00 có W-B01 đã được tạo bằng fixture cơ thể và nằm trong tầm quan sát N17; không dùng người thứ 22. N17 đang gác, không có người thay ở D07, biết D01 có người nhưng chưa báo.

### 10.2 Hard filter và phương án

| Phương án | Điều kiện | Total của N17 |
|---|---|---:|
| hỗ trợ tối thiểu tại chỗ rồi gọi người | có kỹ năng sơ cứu hẹp/khả năng gọi trong overlay | 9.200 |
| rời D07 đưa P00 tới O01 | P00 không thể tự đi và nguy cơ tin là cao | 7.600; D07 bỏ gác thật |
| chỉ tiếp tục gác | hợp lệ vật lý nhưng Harm dự báo cao | −2.100 |
| chữa sâu | hard filter: N17 không có MED K2/K3 |

N17 không biết trạng thái debug của W-B01; chỉ dùng máu/đau/chức năng anh quan sát được. Nếu overlay thay quan sát thành dấu nhẹ, điểm và phương án có thể đổi.

### 10.3 Hội thoại

- N17 `ASK` P00 có nghe/đáp và muốn trợ giúp không, nếu Body P00 cho phép.
- N17 `WARN/INFORM` người gần nhất về tình trạng quan sát, không tự nói chẩn đoán.
- P00 theo PLAYER-DIRECT nhận lựa chọn đồng ý/từ chối nếu còn năng lực; bất tỉnh dùng quy tắc cấp cứu K1.7.

Chọn giúp trong variant không xóa nghĩa vụ gác. Nó tạo Position/Action thật, Message báo và hậu quả danh tiếng chỉ cho người biết diễn biến.

## 11. DT-O06 — từ tiếng rung tới yêu cầu chi vượt hạn

### 11.1 Hai cổng bằng chứng

1. SEC17 đánh thức InspectionGoal; không đóng cầu.
2. Chỉ biến thể `O06-EVIDENCE` chèn InspectionEvent cho thấy một cấu kiện cần sửa và Estimate 32 V01 có nguồn. Biến thể `O06-NO-FINDING` không tạo Claim chi.

Tâm C3/LEX-ROAD K3 viết V34-O06-01. N20 chỉ mang tờ nếu nhận nhiệm vụ, thời gian và tuyến; cô không tự hiểu toàn bộ kỹ thuật K3.

### 11.2 Trace của Tâm

| Phương án | G | V | R | B | H | C | S | A | Total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| báo và xin hội đồng | 3.800 | 3.700 | 800 | 1.800 | 500 | 500 | 0 | 900 | 10.000 |
| tự chi 32 V01 | hard filter: quyền O06 chỉ tới 20 |
| chỉ giữ kín/tiếp tục | 300 | −2.000 | −600 | 0 | 3.500 | 0 | 0 | −700 | −6.500 |

### 11.3 Hội thoại hội đồng

Mỗi lượt dùng Message đã tới:

1. người điều phối `INFORM`: đọc yêu cầu, nguồn Inspection/Estimate và phần chưa chắc;
2. hội đồng `ASK`: hỏi Tâm về hậu quả trì hoãn, người báo giá về vật/công, người giữ quỹ về lượng;
3. Tâm `CLARIFY`: tách dấu đã thấy khỏi dự báo;
4. mỗi thành viên `CONFIRM` phần hiểu/xung đột lợi ích;
5. Ruling có thể `APPROVE_32`, `REQUEST_MORE`, `APPROVE_LIMITED` hoặc `REFUSE` theo variant.

Không dùng Total của Tâm để quyết định hội đồng. Ruling tạo quyền/Claim, chưa mua vật hay sửa cầu. Người không nhận thông báo vẫn không biết.

## 12. DT-PHUC-HUE — chăm sóc và tự chủ

### 12.1 Cổng tiết lộ

Nếu Huệ chưa quyết định nói SEC19, Phúc chỉ có SEC18 và hành vi thường; không được mở thẳng hội thoại “chuyện đi học xa”. Variant `HUE-DISCLOSE` đặt ngày 20, 19:00–19:20 tại D02 khi cả hai có mặt và thay sinh hoạt tùy ý.

### 12.2 Lượt nói

1. N20 `INFORM`, riêng N19. **Payload:** đang cân nhắc học xa, chưa có đích/lịch/hợp đồng; muốn hỏi khả năng đổi nghĩa vụ O05. **Câu mẫu:** “Cháu mới đang tìm hiểu, chưa quyết đi. Nếu có chỗ học, mình có thể bàn lại việc ở đây không?”
2. N19 `CLARIFY`: hỏi thời điểm, nơi, nguồn ăn/ở và phần việc Huệ đang giữ; không được nói như đã có quyền cấm.
3. N20 `INFORM`: đánh dấu các mục `unknown`, tách ước muốn khỏi kế hoạch.
4. N19 chọn `PROPOSE`: cùng tìm thông tin và chỉ đổi hợp đồng sau khi biết; hoặc `REFUSE_NEGOTIATION`: không đồng ý đổi nghĩa vụ hiện tại nhưng vẫn không cấm di chuyển.
5. N20 `ACCEPT/REFUSE/CLARIFY`; không có nhánh nào tự làm cô rời An Khê.

### 12.3 Appraisal

Phúc có CARE/SECURITY nên `cùng tìm thông tin` được +Relation/+Benefit nhưng −Uncertainty; phản ứng giữ kín có AffectAttention mạnh nhưng Harm quan hệ cao. Huệ AUTONOMY/MASTERY coi việc nói thật giúp tạo phương án, song lo mất tự chủ tăng chi phí xã hội. Kết quả chỉ là Message/Goal tìm hiểu hoặc xung đột chưa giải quyết, chưa là MigrationAction.

## 13. DT-P00 — lệnh rủi ro và ba chính sách

### 13.1 Lệnh thử

Ngày 12, P00 nhận lệnh có cấu trúc: “đi qua D08 tới tuyến đang có Belief nguy hiểm để giao kiện; không chi quá 5 V01; nếu nguy hiểm cao thì dừng và báo.” Fixture phải dùng cùng Body/Belief/Position cho ba policy; không tự khẳng định đường thật nguy hiểm nếu chỉ có tin.

### 13.2 Kết quả theo policy

| Policy | Hành vi hợp lệ |
|---|---|
| PLAYER-DIRECT | hệ phân rã kế hoạch, kiểm điều kiện; gặp đánh giá nguy hiểm cao thì dừng theo giới hạn chính lệnh, không cần Trait |
| PLAYER-CHARACTER | Trait/Value do người chơi đã chọn tạo đề nghị/từ chối theo quy tắc hiển thị; nếu chưa có hồ sơ thì fixture invalid |
| HYBRID-CONSENT | nhân vật làm tới ngưỡng đã giao, tự dừng và tạo yêu cầu quyết định khi xung đột lớn |

INIT-A hiện chỉ chạy PLAYER-DIRECT. P00 H/S2 nên có thể báo ngắn; R/W0 nên không tự đọc tờ đường. Giao diện phải cho người chơi thấy nguồn Belief, mức bất định và điều kiện dừng trước khi bắt đầu.

Không so Score ẩn cho P00 trong PLAYER-DIRECT. NPC giao việc vẫn có quyền từ chối hợp đồng theo DecisionTrace của họ.

## 14. Khi hội thoại không đạt kết quả

Một cuộc nói chuyện có thể kết thúc ở:

- `no_shared_meaning`: có từ/điều kiện chưa hiểu;
- `no_authority`: người nói không thể cam kết điều được hỏi;
- `no_agreement`: hiểu nhau nhưng ưu tiên khác;
- `need_evidence`: thiếu giá, kiểm tra, sổ hoặc nhân chứng;
- `interrupted`: người/vị trí/năng lực thay đổi;
- `deferred`: có mốc đánh giá lại thật;
- `ended_without_commitment`: chỉ trao đổi thông tin.

Không ép chọn ACCEPT/REFUSE để kết thúc giao diện. Việc lặp lại cùng đề nghị không có dữ kiện mới chịu Switch/annoyance cost và không đánh thức DecisionFrame mỗi giây.

## 15. Lời nói dối, tránh né và sửa lời

Ba trạng thái riêng:

| Trạng thái | Điều kiện |
|---|---|
| nhầm | người nói tin payload là đúng |
| nói dối | người nói tin payload sai nhưng chủ động muốn người nghe tin nó |
| giữ kín/né | không truyền phần biết; có thể trả lời không đầy đủ mà không phát biểu sai |

Hệ không suy nói dối chỉ vì Fact khác lời; cần Belief và intent của người nói. Một người sửa lời dùng `CORRECT` trỏ Message cũ. Người nhận chỉ cập nhật nếu nghe bản sửa; ký ức bản cũ không biến mất.

Trong K1.11 không ép NPC nói dối. Các SEC được giữ kín mặc định cho tới khi DecisionFrame tạo ý định tiết lộ phù hợp.

## 16. Tóm lược và chống lặp

Một cuộc nói chuyện dài được tóm thành:

- participants thực sự;
- thời gian/vị trí;
- acts và payload quan trọng;
- phần mỗi người hiểu/không hiểu;
- đề nghị/cam kết/kết quả;
- Message/Belief/Affect/Relationship update id;
- lượt bị bỏ qua chỉ khi không còn nguồn tham chiếu.

Không gộp hai người thành “H01 đã đồng ý” nếu thiếu ACCEPT của từng người có quyền. Không phát lại Affect/Relation khi mở Episode. Mỗi update có `applied_from_event_id`.

## 17. Giao diện hội thoại text

Người chơi thấy:

- lời thực tế P00 nghe/đọc;
- nhãn nguồn như “Hòa nói theo thông báo cũ” nếu P00 biết nguồn;
- phần chưa hiểu: “Bạn chưa rõ thuật ngữ này”;
- lựa chọn hành động: hỏi lại, đề nghị, chấp nhận, từ chối, chờ, rời;
- bản điều khoản cấu trúc trước khi cam kết;
- thời gian dự kiến của lượt và việc đang bị ngắt.

Không hiện Total, Trait, Affect nội bộ của NPC. Sau quyết định, giải thích chỉ dùng lời họ nói/hành vi P00 quan sát. Chế độ phát triển có thể mở bảng điểm và hard filter.

Trên điện thoại, từng lượt là một thẻ nối tiếp; các điều khoản dài mở trang riêng và giữ vị trí. Trên máy tính, lịch sử, điều khoản và vật/sổ có thể đặt cạnh nhau. Cả hai gửi cùng `DialogueAct` cấu trúc, không parse chuỗi nút khác nhau thành kết quả khác.

## 18. Ma trận phủ tám dấu vết

| Trace | Fact/Belief | Skill/Right | Affect/Value | Hội thoại | Hậu quả vật chất |
|---|:---:|:---:|:---:|:---:|---|
| DT-H01 | ✓ | quyền H01/C01 | ✓ | N01↔N02 | 12 V01 chỉ đổi ngày 10 |
| DT-O04 | ✓ | vai trò O04 | ✓ | N05/N06/(N17) | chưa đổi V23/V01 nếu chỉ kiểm |
| DT-O03-A | ✓ | REC-O03-RIGHTS | ✓ | N16/N13/(N14/N15) | ENTRY-RIGHT tùy variant |
| DT-O03-B | ✓ | quyền học | ✓ | N13/N14/N15 | không đổi Skill ngay |
| DT-DUNG | ✓ | MED hẹp, duty gác | ✓ | N17↔P00/người gần | Position/chăm sóc theo variant |
| DT-O06 | ✓ | hạn 20 V01 | ✓ | Tâm/hội đồng | Ruling chưa tự mua/sửa |
| DT-PHUC-HUE | ✓ | nghĩa vụ O05/tự chủ | ✓ | N19↔N20 | chưa có MigrationAction |
| DT-P00 | ✓ | policy P00 | P00 U hoặc đã chọn | UI/Message | chỉ hành động theo policy |

## 19. Điều kiện kiểm thử DV01–DV28

1. DV01 — Mỗi trace trỏ snapshot/overlay/version, không sửa base không nhãn.
2. DV02 — Chỉ phương án người actor biết và có thể nghĩ tới mới vào `known_options`.
3. DV03 — Hard filter chạy trước điểm; điểm cao không vượt quyền/vật lý.
4. DV04 — Score dùng Belief chủ quan, không dùng kết quả tương lai thật.
5. DV05 — Chênh nhỏ giữ hysteresis; RNG chỉ dùng sau hòa và có log.
6. DV06 — DialogueIntent không tự tạo Observation khi chưa có tín hiệu.
7. DV07 — Im lặng/không phản hồi không thành ACCEPT hoặc COMMIT.
8. DV08 — Câu mẫu không thêm dữ liệu ngoài payload cấu trúc.
9. DV09 — H01 chỉ truyền SEC02 cho N01 qua lượt thật, không cho người khác biết.
10. DV10 — DT-H01 tạo kế hoạch trả C01 nhưng không sinh giá/vật liệu mái.
11. DV11 — Bình không được tự chi quỹ hay sinh V24; kiểm xe có thời gian/vị trí.
12. DV12 — N17 vắng khỏi D01 thì không có lượt hội thoại O04 của N17.
13. DV13 — SEC15 không mở hội thoại khi thiếu trigger; intent riêng không sửa quyền.
14. DV14 — O03-A chỉ tạo Right sau ACCEPT/thẩm quyền/ENTRY-RIGHT hợp lệ.
15. DV15 — Kha/Tùng nhận cùng tín hiệu nhưng có Appraisal/Action khác có nguồn.
16. DV16 — Người này không biết động cơ riêng của người kia chỉ từ cùng cuộc họp.
17. DV17 — N17 không dùng trạng thái debug W-B01 hay kỹ năng MED chưa có.
18. DV18 — Rời gác để giúp tạo Position/lỗ hổng thật và không tự xóa nghĩa vụ.
19. DV19 — SEC17 chỉ mở kiểm tra; chi 32 V01 cần Evidence + Ruling + Transaction.
20. DV20 — Hội đồng không dùng Score riêng của Tâm làm kết luận chung.
21. DV21 — Phúc không biết SEC19 trước khi Huệ thực sự nói.
22. DV22 — Hội thoại Phúc–Huệ không tự tạo chuyến đi, nơi học hoặc quyền cấm.
23. DV23 — PLAYER-DIRECT không tính Trait/Value ẩn để P00 chống lệnh.
24. DV24 — Ba policy P00 không được trộn trong cùng fixture/save version.
25. DV25 — Nhầm/nói dối/giữ kín phân biệt bằng Belief + intent, không bằng chênh Fact đơn thuần.
26. DV26 — Tóm lược không gộp đồng thuận nhiều người hoặc phát lại update.
27. DV27 — Lưu/tải giữa lượt giữ tín hiệu đã phát, phần hiểu, trạng thái chờ và Action bị chiếm.
28. DV28 — Cùng save/RNG/lệnh/policy cho cùng trace trên điện thoại và máy tính.

Toàn bộ DV chưa chạy. Cộng 28 DV với 348 điều kiện trước đó cho **376 điều kiện thiết kế chưa chạy bằng mô phỏng**.

## 20. Giới hạn và bước kế tiếp

K1.11 chưa thiết kế nói chuyện nhóm đông, chen lời phức tạp, khoảng cách âm học, biểu cảm cơ thể chi tiết, nói bóng/ẩn dụ văn hóa, thẩm vấn, tuyên truyền, thần thức truyền âm hoặc mô hình sinh câu cuối. Nó mới đóng cấu trúc cần thiết để lời văn không điều khiển thế giới trái phép.

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
