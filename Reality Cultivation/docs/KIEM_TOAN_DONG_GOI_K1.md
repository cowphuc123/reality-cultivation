---
title: Kiểm toán và đóng gói K1.1–K1.11 — K1.12
aliases:
  - K1.12
  - Gói đặc tả K1
tags:
  - reality-cultivation
  - thiet-ke
  - kiem-toan
  - fixture-k1
status: de-xuat
updated: 2026-09-06
---

# Kiểm toán và đóng gói K1.1–K1.11 — K1.12

Tài liệu này là điểm vào duy nhất cho gói K1. Nó kiểm toán [[LICH_21_NGUOI_K1]], [[NGUON_QUYET_DINH_K1]], [[SO_SU_KIEN_30_NGAY_K1]], [[NHANH_XUNG_DOT_K1]], [[DOI_SONG_TU_SINH_K1]], [[HO_SO_NPC_AN_KHE_K1]], [[VAN_HOA_THE_CHE_AN_KHE_K1]], [[SO_THE_CHE_30_NGAY_K1]], [[NANG_LUC_NGON_NGU_TRI_THUC_K1]], [[TAM_LY_21_NGUOI_K1]] và [[DAU_VET_QUYET_DINH_HOI_THOAI_K1]] trên nền K0.

Đây là kiểm toán tài liệu, không phải kết quả từ game. “Đạt trên giấy” nghĩa là các bảng hiện có không tự mâu thuẫn trong phạm vi đã ghi; nó không chứng minh bộ xử lý, lưu/tải, hiệu năng hoặc hành vi NPC đã hoạt động.

## 1. Kết luận kiểm toán

Gói K1 **đạt có điều kiện trên giấy** và có thể chuyển sang bước thiết kế hợp đồng dữ liệu máy. Nó đã có một lát cắt 30 ngày với người, lịch, nguồn sống, giao dịch, tri thức, quyền, tâm lý, hội thoại và tám nhóm nhánh thất bại có dấu vết.

Gói này chưa phải đặc tả có thể đưa thẳng cho máy chạy vì còn thiếu:

- kiểu dữ liệu chuẩn cho từng trường, giá trị mặc định và quy tắc `null/unknown/not-applicable`;
- thứ tự nạp, khóa ngoại và phép kiểm tự động ở cấp file máy;
- hàm cập nhật trạng thái và bộ chạy sự kiện;
- quyết định trải nghiệm TN01–TN08;
- ngưỡng hiệu năng, định dạng save và cơ chế đồng bộ giữa thiết bị;
- các hệ sâu đã công bố là ngoài lát cắt, như sinh lý nhiều năm và cảnh giới dài hạn.

Không phát hiện lỗi làm K1 phải mở lại từ đầu. Hai lỗi điều hướng/lịch đã được sửa trong quá trình rà: liên kết `DU_LIEU_LIEN_K0` được đổi về đúng [[DU_LIEU_LIEN_KET_K0]], và hội thoại O04 ngày 12 được dời từ 16:30 sang 17:15 để không đè lịch chính của N05/N06.

## 2. Bản kê gói K1

| Chặng | Tài liệu | Vai trò chủ quản | Đầu ra chính | Điều kiện |
|---|---|---|---|---:|
| K1.1 | [[LICH_21_NGUOI_K1]] | lịch cơ sở | 24 giờ của 21 người, nhịp 30 ngày | LC01–LC18: 18 |
| K1.2 | [[NGUON_QUYET_DINH_K1]] | nhận thức/quyết định | Fact, Observation, Message, Belief, Memory, Goal, DecisionFrame | QD01–QD20: 20 |
| K1.3 | [[SO_SU_KIEN_30_NGAY_K1]] | sổ thời gian | sự kiện theo phút, V01/V02/nước và mốc nhận thức | SS01–SS16: 16 |
| K1.4 | [[NHANH_XUNG_DOT_K1]] | nhánh thất bại | X01–X08 và phép nhập lại base | NX01–NX18: 18 |
| K1.5 | [[DOI_SONG_TU_SINH_K1]] | thời gian dài | vòng đời, việc tự sinh, mức R0–R4, StoryArc dẫn xuất | DT01–DT22: 22 |
| K1.6 | [[HO_SO_NPC_AN_KHE_K1]] | con người cụ thể | HIST, quan hệ, LongGoal, SEC01–SEC19 | HS01–HS20: 20 |
| K1.7 | [[VAN_HOA_THE_CHE_AN_KHE_K1]] | xã hội/quyền | cư trú, hộ, học việc, thừa kế, danh dự, tranh chấp | VH01–VH22: 22 |
| K1.8 | [[SO_THE_CHE_30_NGAY_K1]] | hồ sơ vật lý | V34–V36, sổ giao dịch, thông báo và TC-X01–TC-X08 | ST01–ST24: 24 |
| K1.9 | [[NANG_LUC_NGON_NGU_TRI_THUC_K1]] | năng lực truyền tin | H/S/R/W/C/A, KnowledgeUnit, NN-X01–NN-X06 | NL01–NL24: 24 |
| K1.10 | [[TAM_LY_21_NGUOI_K1]] | trạng thái tâm lý | Trait, Value, Affect, Pressure, TL-X01–TL-X08 | TL01–TL26: 26 |
| K1.11 | [[DAU_VET_QUYET_DINH_HOI_THOAI_K1]] | lựa chọn/hội thoại | DecisionTrace, DialogueTurn và tám dấu vết | DV01–DV28: 28 |
| **Tổng K1** | 11 tài liệu |  |  | **238** |

Nền K0 có 88 điều kiện DL, 16 DS, 16 LK và 18 CS, tổng 138. Vì vậy toàn bộ sổ hiện tại có **138 + 238 = 376 điều kiện**. Không có điều kiện mới được thêm trong K1.12; các cổng kiểm toán ở tài liệu này chỉ phân loại độ sẵn sàng.

## 3. Thứ tự phụ thuộc chuẩn

Không nên đọc số K1 như thứ tự ghi đè dữ liệu. Thứ tự phụ thuộc đề xuất là:

1. Nạp quy ước, kiểu id và đơn vị từ [[LUOC_DO_TRANG_THAI]].
2. Nạp bản kê INIT-A từ [[DU_LIEU_KHOI_DAU]], [[DU_LIEU_LIEN_KET_K0]] và [[CHAM_SOC_K0]].
3. Nạp Person, lịch sử, quan hệ, quyền, năng lực, xu hướng và giá trị.
4. Nạp lịch cơ sở K1.1 và các hợp đồng/nghĩa vụ đang hoạt động.
5. Nạp sổ sự kiện cơ sở K1.3; K1.8 chỉ bổ sung vật mang hồ sơ và dòng tham chiếu.
6. Chọn đúng một overlay hoặc một tổ hợp đã kiểm precondition; không sửa trực tiếp base.
7. Dựng Observation/Message/Belief rồi mới đánh thức DecisionFrame.
8. Chạy lựa chọn, DialogueTurn, Action và Transaction theo thứ tự pha.
9. Ghi hậu quả thật; StoryArc và văn bản giao diện chỉ đọc kết quả.
10. Chạy điều kiện kiểm chứng, sau đó mới tạo snapshot/save.

Nếu một tài liệu về sau mô tả lại cùng dữ liệu, tài liệu chủ quản trong bảng mục 2 thắng. Tài liệu sau chỉ được mở rộng bằng tham chiếu hoặc overlay có phiên bản.

## 4. Sổ không gian tên

| Miền | Khoảng đang dùng | Số lượng/ghi chú |
|---|---|---|
| Nhân vật | P00, N01–N20 | 21 người; một danh tính/người |
| Địa điểm | D01–D11 | 11 địa điểm |
| Tuyến | 10 cạnh thường + D07–D06 đường vòng | 11 tuyến hai chiều |
| Loại vật | V01–V36 | liên tục, không thiếu mã |
| Công việc | J01–J07 | bảy mẫu việc |
| Hộ/hợp tác | H01–H02 | H02 là nhóm ruộng, không mặc định là gia đình |
| Tổ chức/quỹ | O01–O06 | quyền chi có chủ thể và hạn |
| Tài sản chung | AK-COMMON | không biến người đang giữ thành chủ sở hữu |
| Nghĩa vụ | C01 và hợp đồng J | C01 là khoản nợ, không phải vật tiền mới |
| Thông tin riêng | SEC01–SEC19 | có tập người biết khởi tạo |
| Nhánh 30 ngày | X01–X08 | overlay K1.4 |
| Nhánh thể chế | TC-X01–TC-X08 | không đồng nhất với X01–X08 |
| Nhánh ngôn ngữ | NN-X01–NN-X06 | lỗi truyền/hiểu, không sửa Fact |
| Nhánh tâm lý | TL-X01–TL-X08 | đánh thức tình huống, không khóa kết quả |
| Dấu vết | DT-H01…DT-P00 | có dấu gạch, phân biệt DT01–DT22 là điều kiện đời sống |

Mã máy tương lai phải kèm `entity_kind` hoặc dùng kiểu khóa riêng. Không được suy loại chỉ từ ký tự đầu: `H01` là hộ, còn H trong bảng H/S/R/W/C/A là mức nghe; `DT01` là điều kiện, còn `DT-H01` là dấu vết.

## 5. Kiểm toán tài liệu và liên kết

Kết quả kiểm tra vault tại mốc K1.12:

- 11/11 tài liệu K1 tồn tại và có liên kết từ gói này;
- mọi liên kết wiki thực dùng đều phân giải theo đường dẫn hoặc tên file;
- danh sách trang chủ có đủ K1.1–K1.12;
- không có dấu xung đột biên tập;
- 28 mã DV là duy nhất trong danh sách K1.11;
- các dòng “bước tiếp theo” đang được chuyển về K2.1 sau khi K1.12 hoàn tất;
- ví dụ `[[tên ghi chú]]` trong hướng dẫn Obsidian là cú pháp minh họa, không phải liên kết dữ liệu.

Kiểm tra này không xác nhận nội dung văn xuôi bằng trình biên dịch; K2.1 cần biến những tham chiếu quan trọng thành khóa ngoại có thể kiểm tự động.

## 6. Kiểm toán dân số, địa điểm, vật và việc

| Hạng mục | Nguồn chủ quản | Kết quả |
|---|---|---|
| Dân số fixture | [[DU_LIEU_KHOI_DAU]] | P00 + 20 NPC = 21; lịch và ma trận K1 đều dùng cùng tập |
| Địa điểm | [[DU_LIEU_KHOI_DAU]] | D01–D11 liên tục |
| Tuyến | [[DU_LIEU_KHOI_DAU]] | 11 tuyến; cầu D08 và đường vòng là hai khả năng thật |
| Vật phẩm | [[DU_LIEU_KHOI_DAU]] | V01–V36 liên tục; V34–V36 được K1.8 vật chất hóa |
| Việc | [[DU_LIEU_KHOI_DAU]] | J01–J07; việc chưa định lượng không được sinh đầu ra |
| Tiền | [[DU_LIEU_LIEN_KET_K0]] | P00 và tám nhóm/quỹ sở hữu tổng 2.000 V01 |
| Hộp tiền | [[DU_LIEU_LIEN_KET_K0]] | tám V33 cho H01/H02/O01–O06; P00 giữ 40 V01 trực tiếp |

Không có bằng chứng về NPC thứ 22, địa điểm D12, vật V37 hoặc việc J08 trong base. Nếu văn bản kể tới thực thể mới, nó phải là đề xuất ngoài fixture cho tới khi có bản ghi khởi tạo.

## 7. Kiểm toán thời gian và vị trí

Lịch cơ sở giữ ba quy tắc: một người có một Position, tối đa một Action chính, và overlay phải thay lịch cũ có nhãn. Các mốc đã đối chiếu quan trọng:

- N05 nhận trước định suất bằng hành trình thật, không xuất hiện đồng thời tại D01 và D02;
- A-BOOT dùng N01 sau khi N19 được phát hiện còn ở lịch lấy nước;
- X02 đặt N17 rời ca gác thật và tạo khoảng D07 không người;
- X06 giữ V12 trên tuyến cho tới khi P00 tìm thấy;
- DT-O04 diễn ra 17:15–17:35 ngày 12 sau lịch chính của N05/N06;
- H01 trao đổi 18:30 ngày 9 và chỉ lập kế hoạch trả C01 ngày 10;
- các lượt nói có duration/focus, không diễn ra ngoài thời gian.

Đạt trên giấy cho base và các overlay được mô tả riêng. Chưa đạt cho mọi tổ hợp overlay: hệ thống tương lai phải phát hiện xung đột Position/Action/Reservation thay vì tự cộng nhánh.

## 8. Kiểm toán vật chất và sổ lượng

| Đại lượng | Đầu vào/kết quả đã đối chiếu | Trạng thái |
|---|---|---|
| V01 | tổng đầu và cuối 2.000 | khép kín trên giấy cho base và X01–X08 |
| V02 | 500 đầu + 240 từ tám J01; 630 tiêu; 110 cuối | khép kín base |
| Nước uống | 2.000 ml P00 đầu + 1.258.000 ml lấy D11 = 1.260.000 ml | khép kín nhu cầu 21 người/30 ngày |
| V34–V36 | thêm 30 tờ, 7 sổ, 7 bộ viết = 3.100 g | khép tồn kho ban đầu K1.8 |
| Dịch chuỗi B | 100.000 mg chia các đích, 88.000 mg trên đường được gộp | khép trong fixture B |
| Linh lực | các fixture D có sổ riêng | khép phép thử; chưa có nguồn gốc chơi thường của INIT-D |

Dòng sổ không sở hữu tiền/vật. Transaction mới đổi quyền sở hữu/vị trí; ENTRY-TXN chỉ trỏ Transaction. Nghĩa vụ C01 không cộng thêm 12 đồng, Reservation không tạo bản sao tiền, và bánh đang lắp trong V23 không đồng thời là V24 rời.

Phần chưa khép cho mô phỏng dài hạn: tiêu hóa/bài tiết/khối lượng cơ thể, mùa vụ sau 20 lô, hao mòn rộng, tái sinh sinh thái và nhiều chu trình chế tác. Các phần này không được ngầm dùng trong lát cắt K1.

## 9. Kiểm toán sự thật, tri thức và quyền

Chuỗi hợp lệ là `FactEvent → tín hiệu/Observation → Message → Belief/Memory/Inference → DecisionFrame`. Các kiểm tra xuyên K1 cho thấy:

- tin công khai chỉ là vật nhìn thấy; chưa đọc thì chưa biết;
- lời kể lại giữ source chain, không nhân thành nguồn độc lập;
- Belief sai có thể tạo cảm xúc thật nhưng không sửa Fact;
- Skill biết cách làm không tự cấp RoleRight;
- quyền được công nhận không thực thi từ xa nếu người gác/công cụ không biết;
- quan hệ gia đình, thầy trò hoặc thiện cảm không tự cấp quyền tài sản/cơ thể;
- dòng sổ không chứng minh giao dịch nếu thiếu Transaction;
- P00 không được biết thông tin debug chỉ vì giao diện mở.

K1.2, K1.7, K1.9, K1.10 và K1.11 dùng cùng ranh giới này. K2.1 cần chuẩn hóa `unknown`, `false`, `withheld`, `not_observed` và `not_applicable`; không được ép chúng về cùng một giá trị rỗng.

## 10. Kiểm toán NPC, tâm lý và hội thoại

Hồ sơ 20 NPC có lịch sử, mục tiêu dài hạn, quan hệ và thông tin riêng làm nguồn cho khác biệt hành vi. Tính cách và cảm xúc không trực tiếp viết Action; chúng đi qua Appraisal, phương án khả dụng, hard filter và DecisionFrame.

Tám dấu vết K1.11 phủ các giao điểm chính:

| Dấu vết | Giao điểm được kiểm |
|---|---|
| DT-H01 | nghĩa vụ, bí mật, tiền và lo mái nhà |
| DT-O04 | bảo trì V23, đúng hẹn và quyền chi |
| DT-O03-A | ý định riêng, quyền duyệt và chấp thuận có hạn |
| DT-O03-B | cùng tín hiệu, hai appraisal/cách ứng phó |
| DT-DUNG | chăm sóc, kỹ năng hẹp, vị trí và ca gác |
| DT-O06 | bằng chứng cầu, hội đồng và chi vượt hạn |
| DT-PHUC-HUE | tiết lộ riêng tư, chăm sóc và tự chủ |
| DT-P00 | lệnh rủi ro dưới ba chính sách điều khiển |

Payload có cấu trúc là dữ liệu; câu mẫu chỉ diễn đạt. Im lặng không thành đồng ý, lời nói không tự thành hợp đồng, và mô hình ngôn ngữ không được thêm mệnh đề. Đây là ranh giới bắt buộc khi triển khai hội thoại sinh động về sau.

## 11. Kiểm toán base và overlay

`FX-A-30D/base` là một lịch sử riêng. X, TC-X, NN-X, TL-X và các DecisionTrace là lớp thử; chúng không cùng lúc trở thành thế giới chính thức.

Quy tắc ghép:

1. Khóa base/version trước khi áp.
2. Kiểm precondition trên trạng thái vừa nhận, không trên base cũ.
3. Liệt kê bản ghi bị thay: Action, Event, Contract, Position, Transaction, Message hoặc Right.
4. Hủy/thay bản ghi cũ bằng nguyên nhân, không xóa dấu vết.
5. Tính lại lịch, kho, tri thức và DecisionFrame từ mốc đầu tiên bị ảnh hưởng.
6. Không cộng hai lần cùng khoản tiết kiệm, tổn thất hay Message.
7. Chỉ nhập lại base khi toàn bộ precondition của mốc nhập còn đúng.

K1.4 đã nêu nguyên tắc này; K2.1 phải biến nó thành cấu trúc `overlay_id`, `base_version`, `preconditions`, `replacements`, `additions`, `invalidations` và `rejoin_guard`.

## 12. Điện thoại, máy tính và nhịp 5 giây/ngày

Yêu cầu đã xác nhận là game chơi được trên điện thoại và máy tính. K1 đã giữ các bất biến logic cần thiết:

- đồng hồ mô phỏng tách khỏi tốc độ vẽ giao diện;
- cùng save, seed, lệnh, policy và phiên bản phải cho cùng kết quả logic;
- mở bảng, cuộn log hoặc đổi bố cục không tiêu RNG;
- ứng dụng xuống nền phải lưu ở ranh giới an toàn, không bỏ sự kiện;
- quá tải phải dừng/báo, không âm thầm giảm luật;
- văn bản dài có bản tóm lược nhưng tóm lược không phát lại hậu quả.

Chưa chốt công nghệ đóng gói, đồng bộ save giữa thiết bị, cấu hình máy tối thiểu hoặc thế giới có chạy khi ứng dụng đóng. Đây là lựa chọn mở, không phải lỗi dữ liệu K1.

## 13. Sổ 376 điều kiện

| Lớp | Nhóm | Số |
|---|---|---:|
| DL | SK 12 + VT 14 + CB 14 + CV 16 + LT 16 + GT 16 | 88 |
| K0 | DS 16 + LK 16 + CS 18 | 50 |
| K1 vận hành 30 ngày | LC 18 + QD 20 + SS 16 + NX 18 | 72 |
| K1 đời sống/xã hội | DT 22 + HS 20 + VH 22 | 64 |
| K1 hồ sơ/năng lực/tâm lý/hội thoại | ST 24 + NL 24 + TL 26 + DV 28 | 102 |
| **Tổng** |  | **376** |

Trạng thái của cả 376 là **đã định nghĩa, chưa chạy bằng mô phỏng**. Những phép cộng và rà văn bản thủ công không đổi trạng thái đó thành “đã kiểm thử”. Khi có bộ chạy, mỗi điều kiện cần `test_id`, fixture/version, input, oracle, actual result, trạng thái và bằng chứng chạy.

## 14. Ma trận độ sẵn sàng chuyển thành dữ liệu máy

| Miền | Mức hiện tại | Việc K2.1 phải làm |
|---|---|---|
| ID, đơn vị, vị trí | đủ để chuẩn hóa | kiểu id, enum đơn vị, khóa ngoại, invariant |
| Person/Place/ItemType | đủ phần lõi fixture | schema trường bắt buộc/tùy chọn, version |
| Tồn kho và tiền | đủ cho INIT-A/base | lot, container, ownership, transaction schema |
| Lịch 21 người | đủ để mã hóa fixture | interval/action/resource conflict validator |
| Sổ 30 ngày | đủ để mã hóa oracle | event schema, recurrence, idempotency key |
| Observation/Belief | đủ mô hình khái niệm | provenance graph và trạng thái biết |
| Right/Contract/Record | đủ mô hình khái niệm | scope, authority, expiry, evidence, enforcement |
| Skill/Language | đủ fixture ngày 1 | domain enum, level, source, practice update |
| Trait/Affect/Pressure | đủ fixture ngày 1 | fixed-point scale, decay/update contract |
| Decision/Dialogue | đủ tám fixture mẫu | option/filter/score/payload/result schema |
| Overlay | đủ quy tắc văn xuôi | patch contract và conflict detection |
| Đời sống nhiều năm | mới là thiết kế | để K2 sâu hơn; không đưa vào lát cắt chạy đầu |
| Tu luyện/cơ thể/chiến đấu sâu | fixture hẹp | giữ giới hạn công khai; bổ sung theo từng gói |

“Đủ để chuẩn hóa” không có nghĩa mọi nội dung thế giới đã đầy đủ. Nó chỉ nói dữ liệu hiện tại có thể được chuyển sang dạng máy mà không cần bịa thêm kết quả fixture.

## 15. Các vấn đề còn mở có ranh giới

| Mã | Vấn đề | Ảnh hưởng | Xử lý đúng |
|---|---|---|---|
| OPEN-K1-01 | TN01–TN08 chưa được người dùng chốt | vòng điều khiển, chết/lưu, phạm vi | giữ policy/version; không suy từ “tiếp” |
| OPEN-K1-02 | chưa có schema máy chính thức | chưa thể kiểm khóa ngoại/tự chạy | K2.1 lập từ điển dữ liệu và hợp đồng |
| OPEN-K1-03 | chưa có bộ chạy sự kiện | 376 điều kiện chưa thực thi | chỉ đổi trạng thái sau bằng chứng chạy |
| OPEN-K1-04 | chưa có chuẩn hiệu năng | chưa chứng minh nhịp 5 giây/ngày | xác định máy và ngân sách đo trước benchmark |
| OPEN-K1-05 | định dạng save/migration chưa chốt | chưa chứng minh lưu/tải dài hạn | version mọi bản ghi và snapshot |
| OPEN-K1-06 | đồng bộ điện thoại–máy tính chưa chốt | không biết cơ chế chuyển save | tách parity logic khỏi dịch vụ đồng bộ |
| OPEN-K1-07 | FX-E-BOTH thiếu kết quả số hợp nhất | nhánh chiến đấu đó chưa là oracle đầy đủ | hoàn thiện khi chọn lát cắt chiến đấu tương ứng |
| OPEN-K1-08 | E-LINH thiếu ngưỡng dịch chuyển | không được kể hiệu ứng đẩy | giữ chỉ hiệu ứng đã định lượng |
| OPEN-K1-09 | INIT-D chưa có nguồn gốc chơi thường | không dùng làm trạng thái tự sinh | thiết kế chuỗi đạt trạng thái ở K2 tu luyện |
| OPEN-K1-10 | sinh lý và sinh thái nhiều năm chưa khép | không chạy nhiều thế hệ chính xác | mở rộng sau khi lõi bảo toàn chạy được |
| OPEN-K1-11 | tổ hợp overlay chưa được liệt kê hết | có thể tranh cùng bản ghi | validator phải từ chối hoặc yêu cầu giải xung đột |
| OPEN-K1-12 | công thức tâm lý là fixture | chưa chứng minh hành vi tự nhiên dài hạn | hiệu chỉnh bằng quan sát, không coi là tâm lý phổ quát |

Các vấn đề trên không bị xóa khỏi tầm nhìn. Chúng được giữ ngoài lời hứa của lát cắt K1 để tránh hệ thống kể rằng mình mô phỏng thứ chưa có.

## 16. Cấu trúc gói bàn giao đề xuất

Khi chuyển sang dữ liệu máy, một bản build fixture nên có các lớp logic sau, bất kể công nghệ cuối cùng:

```text
manifest
  ├─ schema_version + ruleset_version + fixture_version
  ├─ registries: people, places, routes, item_types, work_types
  ├─ initial_state: bodies, positions, lots, ownership, rights, records
  ├─ minds: observations, beliefs, memories, goals, skills, traits
  ├─ base_schedule + recurring_events
  ├─ contracts + obligations + reservations
  ├─ overlays: X / TC-X / NN-X / TL-X / dialogue traces
  ├─ expected_ledgers + expected_events
  └─ tests: 376 conditions with evidence slots
```

Đây là cấu trúc logic, chưa phải quyết định chọn một file lớn, nhiều file, cơ sở dữ liệu hay ngôn ngữ lập trình.

## 17. Cổng kiểm toán K1G01–K1G12

Các cổng này không cộng vào 376 điều kiện mô phỏng:

| Cổng | Tiêu chí | Trạng thái K1.12 |
|---|---|---|
| K1G01 | đủ 11 tài liệu và trang gói | Đạt |
| K1G02 | liên kết wiki thực phân giải | Đạt |
| K1G03 | registry điều kiện cộng đúng 376 | Đạt |
| K1G04 | P/N/D/V/J liên tục và đúng số lượng | Đạt |
| K1G05 | V01/V02/nước base bảo toàn trên giấy | Đạt trên giấy |
| K1G06 | lịch/vị trí base và dấu vết đã nêu không trùng | Đạt trên giấy |
| K1G07 | Fact/Belief/Right/Record không bị trộn trong đặc tả | Đạt trên giấy |
| K1G08 | base và overlay có ranh giới | Đạt nguyên tắc; thiếu patch schema |
| K1G09 | dữ liệu máy có kiểu/khóa ngoại/validator | Chưa đạt |
| K1G10 | 376 điều kiện được bộ chạy thực thi | Chưa chạy |
| K1G11 | lưu/tải và parity điện thoại–máy tính có bằng chứng | Chưa chạy |
| K1G12 | đạt ngân sách hiệu năng 5 giây/ngày | Chưa có ngưỡng |

K1 kết thúc ở K1G01–K1G08. K1G09 là cổng đầu của K2.1; K1G10–K1G12 thuộc triển khai và kiểm chứng sau khi người dùng yêu cầu viết game.

## 18. Những gì không được tuyên bố sau K1

- Không nói NPC đã sống tự chủ; mới có lịch, nguồn quyết định và fixture.
- Không nói 376 kiểm thử đã đạt; chúng chưa được chạy.
- Không nói game đã hỗ trợ điện thoại/máy tính; mới có yêu cầu và bất biến thiết kế.
- Không nói mọi vật phẩm/công pháp/thương tích đã được mô phỏng; chỉ có lát cắt mẫu.
- Không lấy tên, con số hoặc chính sách fixture làm luật vĩnh viễn của toàn thế giới.
- Không coi “tiếp” là duyệt TN01–TN08 hoặc là lệnh bắt đầu lập trình.

## 19. Bước tiếp theo đề xuất

K2.1–K2.7 đã lập hợp đồng nền, kiểm chứng và ngân sách; kết quả tại [[KIEM_TOAN_DONG_GOI_K2]]. K3.1 đã định kiến trúc tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
