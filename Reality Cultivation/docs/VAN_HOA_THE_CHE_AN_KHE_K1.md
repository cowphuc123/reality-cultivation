---
title: Văn hóa và thể chế An Khê — K1.7
aliases:
  - K1.7
  - Thể chế An Khê
tags:
  - reality-cultivation
  - thiet-ke
  - xa-hoi
status: de-xuat
updated: 2026-09-06
---

# Văn hóa và thể chế An Khê — K1.7

Tài liệu này nối [[DOI_SONG_TU_SINH_K1]], [[HO_SO_NPC_AN_KHE_K1]], [[KINH_TE_TO_CHUC]] và [[NGUON_QUYET_DINH_K1]]. Nó xác định cách cộng đồng An Khê **đề xuất** công nhận hộ, cư trú, học việc, hôn phối, chăm sóc, thừa kế, danh dự, tranh chấp và tin công khai.

Đây là luật của fixture An Khê, chưa phải luật chung của toàn thế giới và chưa được người dùng duyệt hoặc chạy. Nó không thêm quan hệ, tài sản, thương tích, công pháp hay sự kiện tương lai vào INIT-A. Con số tuổi, thời hạn và thành phần hội đồng bên dưới là tham số thử có thể đổi.

## 1. Sáu nguyên tắc nền

1. **Sự thật, sự công nhận và khả năng thực thi là ba trạng thái khác nhau.** Một thỏa thuận có thể có hiệu lực giữa hai người nhưng người giữ kho chưa biết; một phán quyết được công khai vẫn không tự di chuyển vật hay ép cơ thể ai.
2. **Quyền luôn có phạm vi.** Quyền chi tiền không đồng nghĩa quyền bán công cụ, nhận học viên, đọc bí mật hay ra lệnh cho thành viên.
3. **Không ai biết luật chỉ vì luật tồn tại.** Mỗi người học tập quán qua gia đình, học việc, quan sát, lời giải thích hoặc thông báo thật.
4. **Đồng thuận phải gắn với người và hành vi cụ thể.** Quan hệ gia đình, nghề nghiệp hoặc địa vị không tạo sự đồng thuận vĩnh viễn.
5. **Danh dự là đánh giá có nguồn theo từng lĩnh vực.** “Giữ hẹn giao hàng” không tự biến thành “chẩn đoán giỏi” hay “đáng tin mọi chuyện”.
6. **Mọi hậu quả xã hội phải để lại hồ sơ.** Ai quyết định, dựa trên chứng cứ nào, ai được báo, quyền gì thay đổi và vật/nghĩa vụ nào còn treo đều phải truy được.

## 2. Các lớp quy tắc

| Lớp | Ví dụ | Cách có hiệu lực |
|---|---|---|
| Tập quán `Custom` | ưu tiên báo cho người cùng hộ khi có ca cấp cứu | được học và tạo kỳ vọng; không tự cưỡng chế |
| Cam kết `Pledge/Contract` | phòng P00, nợ C01, học việc | các bên chấp nhận, có phạm vi/thời hạn/bằng chứng |
| Quy tắc tổ chức `OrgRule` | quyền cấp kho O03, quyền định giá O04 | do người có quyền ban hành/sửa theo hiến lệ hiện hành |
| Quyết định vụ việc `Ruling` | hoàn trả vật, tạm dừng quyền kho | người xử có thẩm quyền, chứng cứ và phạm vi cụ thể |
| Trạng thái vật lý | ai giữ chìa, vật ở đâu, ai đứng tại cửa | chỉ thay qua hành động thật |

Khi các lớp xung đột, mô phỏng không chọn lớp “cao nhất” bằng phép màu. Ví dụ, một `Ruling` yêu cầu trả V01 tạo nghĩa vụ và quyền yêu cầu; tiền chỉ đổi chỗ khi người giữ thực hiện, tự nguyện giao, hoặc một cơ chế cưỡng hành hợp lệ thật sự tiếp cận được tiền.

## 3. Hồ sơ xã hội tối thiểu

| Hồ sơ | Trường bắt buộc |
|---|---|
| `CommunityStatus` | person, loại cư trú, từ mốc nào, nguồn công nhận, nơi ở được phép, người biết |
| `HouseholdMembership` | household, person, vai trò, quyền dùng nguồn, nghĩa vụ, bắt đầu/kết thúc |
| `Kinship` | hai người, loại quan hệ, nguồn, phạm vi được biết, có/không có hệ quả pháp tục |
| `UnionRecord` | hai người trưởng thành, đồng thuận từng bên, tài sản/hộ sau kết hợp, người chứng kiến |
| `ResidencePermission` | chủ thể, địa điểm/phần chỗ ở, điều kiện, thời hạn, quyền mời người khác |
| `Apprenticeship` | người dạy, người học, kỹ năng/phạm vi, giờ, nguồn dùng, quyền đánh giá, cách kết thúc |
| `CareDuty` | người cần chăm, người/nhóm nhận nghĩa vụ, loại chăm, thời hạn, nguồn và phương án thay |
| `Claim` | chủ thể đòi quyền, đối tượng, căn cứ, độ ưu tiên chưa phân xử, trạng thái |
| `CaseRecord` | yêu cầu, bên liên quan, chứng cứ, người xử, xung đột lợi ích, kết quả, kháng nghị |
| `PublicNotice` | nội dung nguyên văn, người phát, thẩm quyền, nơi/kênh, lúc đăng/gỡ, người thực sự nhận |
| `DomainReputation` | người đánh giá, đối tượng, lĩnh vực, cơ sở ký ức/thông điệp, độ chắc, thời điểm |

Các hồ sơ này tham chiếu Person, Item, Position, Contract và FactEvent gốc; không sao chép tiền, vật, cơ thể hoặc ký ức thành một “bản xã hội” thứ hai.

## 4. Địa vị trong cộng đồng và cư trú

An Khê dùng bốn trạng thái đề xuất:

| Trạng thái | Điều kiện khởi tạo | Quyền xã hội cơ sở | Không tự có |
|---|---|---|---|
| `guest` — khách | được một cư dân/chủ chỗ nhận vào có hạn | đi lại nơi công cộng, giao dịch, xin việc, yêu cầu hòa giải | quyền kho, quyền biểu quyết, chỗ ở miễn phí |
| `resident` — cư dân | ở hợp lệ đủ 90 ngày và có hai cư dân xác nhận sinh hoạt | dự họp công khai, đề nghị vụ việc, dùng nguồn công cộng theo hạn | quyền tài sản hộ/tổ chức |
| `household_member` | có HouseholdMembership hợp lệ | quyền/nghĩa vụ đúng hồ sơ hộ | sở hữu toàn bộ tài sản hộ, quyền trên cơ thể người khác |
| `org_member` | được tổ chức nhận theo OrgRule | vai trò và quyền đúng nhiệm kỳ | quyền ngoài tổ chức hoặc quyền của vai trò khác |

P00 bắt đầu là `guest` nhờ HIST:ROOM-P00, có quyền cư trú đúng phòng/giờ/điều kiện đã thỏa thuận. Huệ biết có khách nhưng không tự biết giá, thời hạn hoặc quyền vào phòng. Mốc 90 ngày chỉ là tham số fixture; đạt mốc tạo điều kiện xét cư trú, không tự đổi trạng thái nếu không có hồ sơ xác nhận.

`ResidencePermission` tách khỏi quan hệ thân thuộc. Một người có thể là họ hàng nhưng không được tự vào phòng, kho hay mở đồ cá nhân. Người được thuê phòng cũng không tự có quyền mời thêm người ở qua đêm nếu hợp đồng không ghi.

## 5. Hộ và tài sản chung

Một hộ được công nhận khi có ít nhất một thành viên và một hồ sơ nêu mục đích phối hợp, nguồn chung, quyền quyết định và nơi sinh hoạt. Rời hộ không xóa huyết thống, nợ hoặc quyền sở hữu cá nhân.

| Nhóm ngày 1 | Loại được công nhận | Quy tắc đặc thù |
|---|---|---|
| H01 | hộ bạn đời/sinh kế | Lâm và Mai cùng quyền chi trong giới hạn dữ liệu; giao dịch lớn làm mất khả năng trả C01 cần cả hai chấp nhận |
| H02 | hộ sản xuất hỗn hợp | Sơn/Cúc là bạn đời, Nga là người thân, Đạt là thành viên lao động; thành viên không tự có phần bằng nhau trong mọi tài sản |
| O01–O06 | tổ chức/cơ sở, không phải hộ gia đình | quyền theo vai trò; ăn/ở nếu có phải có ResidencePermission hoặc CareDuty riêng |

Quyết định hộ có ba loại:

- `routine`: lấy suất theo lịch, chi nhỏ trong hạn đã giao; người giữ vai trò làm được;
- `shared_commitment`: tạo nợ, bán công cụ sinh kế, nhận thêm thành viên dài hạn; mọi người có quyền bị ảnh hưởng phải được hỏi;
- `emergency`: dùng nguồn để ngăn nguy hiểm gần; được làm trước trong phạm vi cần thiết, sau đó phải báo và kết sổ.

Không dùng “chủ hộ” như quyền toàn diện. Nếu sau này một hộ chọn người đại diện, hồ sơ chỉ trao quyền giao tiếp/ký trong phạm vi đã nêu.

## 6. Tuổi trưởng thành, hôn phối và tách hộ

Trong fixture, tuổi trưởng thành xã hội đề xuất là **18 tuổi tròn theo lịch địa phương**. Tuổi đủ chỉ mở quyền tự cam kết; suy giảm nhận thức tạm thời, ép buộc, thông tin sai trọng yếu hoặc không hiểu nội dung vẫn làm đồng thuận không hợp lệ cho hành vi đó.

Hôn phối được cộng đồng ghi nhận khi:

1. hai người trưởng thành trực tiếp bày tỏ đồng thuận;
2. không có UnionRecord đang hiệu lực với người khác theo tập quán một bạn đời của An Khê;
3. quan hệ huyết thống gần trong phạm vi cha/mẹ, con, anh/chị/em hoặc ông/bà–cháu đã biết không được công nhận;
4. hai bên nêu chọn nhập hộ nào, lập hộ mới hay giữ tài sản/hộ tách;
5. có hai người trưởng thành chứng kiến hoặc một bản ghi được hai bên xác nhận sau đó.

Hôn phối không tự chuyển tài sản cá nhân, nợ cũ, quyền tổ chức, công pháp, bí mật hoặc quyền quyết định y tế. Chấm dứt quan hệ cần ghi nơi ở, tài sản cùng tạo, nghĩa vụ chăm sóc còn lại và thông báo cho những người thực thi quyền liên quan. Không có phạt danh dự tự động chỉ vì một người từ chối kết đôi hoặc chấm dứt quan hệ.

N01–N02 và N09–N10 có UnionRecord khởi tạo theo bảng quan hệ ngày 1 ở [[HO_SO_NPC_AN_KHE_K1]]; thời điểm/người chứng kiến quá khứ chưa đủ dữ liệu nên không được bịa thêm. Quan hệ họ xa N10–N14 không tạo quyền tài sản và không nằm trong nhóm cấm gần nêu trên. Không ghép thêm cặp hoặc sinh con trong INIT-A.

## 7. Học việc và công nhận kỹ năng

Học việc gồm bốn mức tách biệt:

| Mức | Ý nghĩa |
|---|---|
| `observe` | được xem/nghe trong phạm vi cho phép |
| `practice_supervised` | được thao tác khi người giám sát có mặt và có thể can thiệp |
| `perform_limited` | được tự làm đúng danh sách quy trình đã đạt, vẫn phải báo ngoại lệ |
| `teach_or_certify` | được dạy hoặc công nhận người khác; không tự sinh từ làm giỏi |

Tiến bộ cần PracticeEvent thật, kết quả, phản hồi và đánh giá của người có quyền. Số ngày ở cạnh thầy không tự tăng kỹ năng. Người học có quyền từ chối thao tác nguy hiểm, hỏi điều kiện đánh giá, giữ thời gian nghỉ đã cam kết và rời quan hệ theo điều khoản; người dạy có quyền bảo vệ người/vật, dừng thao tác vượt mức và từ chối cấp quyền chưa đủ bằng chứng.

- **O01:** An có quyền giao/đánh giá quy trình y quán. Liên đang ở `practice_supervised` cho phần khám nền và `perform_limited` cho các thao tác phụ đã ghi; không được chẩn đoán sâu hay cấp quyền cho người khác.
- **O02:** Mộc giao và đánh giá quy trình xưởng. Thu chỉ dùng vật/khu vực đã được cấp; quyền bán, chi kho và xác nhận thợ độc lập vẫn thuộc Mộc.
- **O03:** Vân quyết định chương trình, nhận học viên, đánh giá chuyển mức và cho phép kỹ thuật. Yến giữ kho/ghi nguồn, không tự cấp năng lực. Kha/Tùng chỉ có quyền đúng công pháp và mức đã học.

Kết thúc học việc không xóa kỹ năng đã thật sự hình thành. Nó chấm dứt quyền dùng cơ sở, giám sát, đại diện hoặc nhận chứng nhận tương lai nếu không có thỏa thuận khác.

## 8. Chăm sóc và nghĩa vụ tương trợ

Tập quán An Khê tạo kỳ vọng báo nguy và hỗ trợ trong khả năng khi thấy người gặp nguy hiểm gần. Nó không bắt một người thiếu kỹ năng thực hiện điều trị, không cấp quyền lấy mọi vật và không bảo đảm được hoàn tiền.

Thứ tự tìm người chăm đề xuất:

1. ý muốn hiện tại của người cần chăm nếu họ có thể quyết định;
2. CareDuty hoặc hợp đồng đã tồn tại;
3. thành viên hộ tự nguyện và có khả năng;
4. cơ sở chuyên môn chấp nhận;
5. người hỗ trợ khẩn cấp trong phạm vi tối thiểu rồi chuyển giao.

Quan hệ bạn đời, huyết thống hoặc thầy trò tạo lý do kỳ vọng và mục tiêu, không cho phép kiểm soát cơ thể. Chi phí chăm sóc trở thành nợ chỉ khi có thỏa thuận, quy tắc tổ chức công khai hoặc quyết định tranh chấp hợp lệ; “tôi đã giúp” không tự tạo Claim tiền vô hạn.

Nếu người chăm vắng, hệ thống tạo nhu cầu tìm thay với thời gian, kỹ năng và nguồn thật. Không gán tự động cho phụ nữ, người trẻ nhất hoặc người thiện cảm cao nhất. Lao động chăm sóc chiếm lịch và ảnh hưởng mục tiêu như mọi công việc khác.

## 9. Thừa kế tài sản và kế nhiệm vai trò

Khi có cái chết được xác thực, tài sản mang theo và tài sản cá nhân của người chết chuyển sang trạng thái `estate_locked`; vật vẫn ở vị trí thật. Các quyền đã đồng sở hữu không bị biến thành di sản toàn bộ.

Thứ tự Claim thừa kế đề xuất cho An Khê:

1. nghĩa vụ mai táng tối thiểu đã được hộ/cộng đồng chấp nhận;
2. nợ có bằng chứng đến hạn từ tài sản cá nhân của người chết;
3. chỉ định hợp lệ của người chết cho phần còn lại;
4. nếu không có chỉ định: bạn đời được công nhận, rồi con/người được nuôi dưỡng, rồi cha mẹ, rồi anh/chị/em;
5. nếu không có người nhận biết được, cộng đồng giữ hộ chứ không tự sung vào quỹ của bất kỳ tổ chức nào.

Người thừa kế nhận cả Claim quyền và nghĩa vụ trong giới hạn di sản; nợ không tự vượt sang tài sản riêng của họ. Tranh chấp giữ vật khóa nhưng không dịch chuyển vật về “kho tòa”. Vật dễ hỏng có thể được người được chỉ định bảo quản, với sổ lượng trước/sau.

Vai trò tổ chức không được thừa kế theo huyết thống nếu OrgRule không nói rõ:

- O01: Liên chỉ tạm giữ an toàn/mời hỗ trợ trong phạm vi đã đạt; không tự trở thành thầy thuốc trưởng.
- O02: Thu có thể bảo toàn xưởng và hoàn việc đã đủ mức; quyền chủ xưởng cần quyết định kế nhiệm.
- O03: Yến có quyền dừng cấp nguồn và giữ sổ khi Vân vắng; không tự nhận quyền dạy/chuyển mức.
- O04: vai trò quầy, vận chuyển và hộ tống vẫn tách; mất một người không trao toàn bộ quyền cho người còn lại.
- O06: quỹ đường không phải di sản cá nhân của Tâm.

## 10. Danh dự và danh tiếng theo lĩnh vực

Mỗi đánh giá danh tiếng có dạng:

`người đánh giá → người/nhóm được đánh giá → lĩnh vực → giá trị + độ chắc → nguồn → lần cập nhật`

Các lĩnh vực đầu gồm: `giu_hen`, `tay_nghe`, `can_trong`, `cong_bang`, `giu_bi_mat`, `cham_soc`, `quan_ly_nguon`, `an_toan_tuyen`. Không cộng chúng thành một điểm “người tốt”.

Quy tắc cập nhật:

- chứng kiến trực tiếp có thể đổi niềm tin mạnh hơn lời truyền, nhưng người chứng kiến vẫn có thể hiểu sai ý định;
- tin từ người đáng tin chỉ tạo Belief có nguồn, không tạo FactEvent về hành vi bị kể;
- một thất bại có lý do ngoài kiểm soát tác động khác với nuốt lời có lựa chọn;
- việc cũ mờ dần về độ nổi bật, nhưng cam kết chưa giải quyết vẫn còn;
- cải chính chỉ tới người thực sự nhận; không sửa ký ức toàn cộng đồng;
- thành kiến văn hóa có thể tồn tại như Belief của NPC, nhưng máy không coi nó là sự thật về năng lực.

Lâm muốn trả C01 vì danh dự là mục tiêu cá nhân có nguồn, không phải luật buộc H01 hy sinh mọi nhu cầu. Dũng từ chối đơn trùng giờ có thể tăng `giu_hen` với người hiểu nguyên nhân dù làm Hòa khó chịu lúc đầu.

## 11. Quy trình xử tranh chấp

An Khê không có một chính quyền thường trực toàn tri trong fixture. Tranh chấp dân sự dùng năm bậc:

1. **Yêu cầu trực tiếp:** bên có Claim nói rõ điều muốn sửa và căn cứ.
2. **Hòa giải:** một người được hai bên chấp nhận giúp ghi điểm đồng ý/bất đồng; không tự ra lệnh.
3. **Tổ chức xử nội bộ:** chỉ dùng nếu vụ thuộc OrgRule và người xử không có xung đột lợi ích trọng yếu.
4. **Hội đồng vụ việc:** ba cư dân trưởng thành, không là bên tranh chấp, không cùng hộ với một bên và không có Claim trực tiếp; hai bên mỗi bên loại được một ứng viên có lý do.
5. **Ghi bất phục/kháng nghị:** xuất hiện chứng cứ mới, sai thẩm quyền hoặc xung đột lợi ích có thể mở lại; không lặp chỉ vì không thích kết quả.

Chuẩn kết luận là mức phù hợp với hậu quả:

- tranh chấp nhỏ: lời kể nhất quán + một dấu vết/nhân chứng có thể đủ;
- tước quyền kho, nghề hoặc tài sản: cần ít nhất hai nguồn độc lập hoặc một hồ sơ giao dịch xác thực cùng cơ hội trả lời;
- khi chứng cứ không đủ: giữ `unresolved`, không bốc ngẫu nhiên người thắng.

Biện pháp có thể gồm sửa sổ, hoàn vật/tiền có nguồn, làm lại phần việc, chấm dứt hợp đồng, giới hạn quyền tổ chức có thời hạn hoặc thông báo kết luận. Không có giam giữ, đánh phạt, tịch thu toàn bộ hay lưu đày trong K1.7; muốn thêm cần một thể chế cưỡng hành, địa điểm, người và hậu quả cơ thể riêng.

Tình huống nguy hiểm cho phép người có quyền vận hành tạm dừng hành động/kho trong phạm vi cần thiết. Lệnh tạm dừng hết hạn sau 24 giờ nếu không được người có thẩm quyền xác nhận hoặc mở CaseRecord; tham số này ngăn “khẩn cấp” thành tước quyền vô hạn.

## 12. Tin công khai và bí mật

Ba kênh công khai đề xuất:

| Kênh | Phạm vi | Điều kiện một người biết |
|---|---|---|
| thông báo miệng tại D01 | người có mặt, nghe và hiểu | tạo Observation/Message riêng cho từng người |
| thông báo lưu tại điểm công cộng D01 | người tới, có khả năng đọc hoặc được đọc cho | cần thời gian đăng/gỡ và vật mang chữ khi triển khai |
| người đưa tin được giao | người nhận xác định | cần hành trình, nội dung và bằng chứng giao |

`PublicNotice` nghĩa là ai cũng **được phép tiếp cận**, không nghĩa là ai cũng đã biết. Người không biết chữ chỉ nhận nội dung nếu nghe thông báo hoặc có người đọc; họ biết người đọc đã nói gì, chưa chắc biết văn bản nguyên gốc.

Một thông báo hợp lệ phải có người phát, nội dung, phạm vi, lúc hiệu lực và căn cứ thẩm quyền. Người bán có thể công khai giá quầy; họ không thể công khai rằng một người đã bị kết tội nếu chưa có Ruling. Tin đồn giữ người kể, chuỗi truyền và độ biến dạng; không dùng kênh công khai để lộ SEC01–SEC19.

Vật mang chữ, chỗ niêm yết và người trông đã được cụ thể hóa cho fixture tại [[SO_THE_CHE_30_NGAY_K1]] bằng V34–V36 và khung D01. Chúng vẫn là đề xuất chưa chạy; vùng khác không tự dùng cùng vật/thể chế.

## 13. Quyền cụ thể của O03

| Người/vai trò | Có quyền | Không có quyền |
|---|---|---|
| N13 Vân — người dạy/phụ trách | chọn nội dung, nhận/từ chối học viên theo sức chứa, cho phép chuyển mức, duyệt chi trên hạn N16 | đọc suy nghĩ học viên, ép luyện, lấy tài sản cá nhân |
| N16 Yến — giữ kho/ghi nguồn | cấp đúng Reservation, từ chối chứng từ sai, chi thường tối đa 20 V01, dừng cấp nguồn khi thấy sai lệch | tự nhận học viên, dạy công pháp, chứng nhận tiến bộ, chi vượt hạn |
| N14 Kha — học viên | dùng lịch/vật đã cấp, yêu cầu giải thích đánh giá, dừng phiên của chính mình | cấp kho cho người khác, đổi chương trình chung |
| N15 Tùng — học viên | đề xuất thử nghiệm, dùng quyền đã được Vân phê duyệt, từ chối thao tác | tự coi im lặng là đồng ý, dùng V27 ngoài Reservation |

Khi Vân vắng, Yến chỉ được giữ hoạt động đã duyệt và dừng rủi ro; không có quyền duyệt mới thay Vân. Muốn có người duyệt thay cần một đề xuất công khai, phạm vi, thời hạn và Vân chấp nhận hoặc một CaseRecord về mất khả năng kéo dài. SEC15 của Yến vẫn là ý định riêng ngày 1, chưa phải luật.

HIST:O03-INCIDENT là căn cứ cho kiểm mốc nguồn, không là lý do mặc định nghi Tùng hoặc cấm mọi nghiên cứu. Kết quả luyện, kho linh lực và quyền tiếp cận phải nằm trong ba sổ tách biệt.

## 14. Quyền cụ thể của O04

| Người/vai trò | Có quyền | Không có quyền |
|---|---|---|
| N06 Hòa — quầy/vốn | định giá chào, bán tồn được phép, mua trong kế hoạch, giữ V33-O04 | ép Bình nhận chuyến, bỏ qua giới hạn an toàn của Dũng, bán đồ cá nhân thành viên |
| N05 Bình — vận chuyển | nhận giữ hàng theo chuyến, chọn cách đi trong hợp đồng, dừng xe khi hỏng, đề nghị bảo trì | tự chi quỹ, bán hàng, hứa lịch của Dũng |
| N17 Dũng — hộ tống/an toàn | đánh giá tuyến đã biết, từ chối/dừng hộ tống nguy hiểm, bảo vệ kiện trong phạm vi hợp đồng | định giá quầy, lấy kiện làm phí, ra lệnh ngoài tình huống an toàn |

Quyền chi O04 hiện thuộc Hòa, nhưng chi làm mất khả năng hoàn hợp đồng đã giữ chỗ bị chặn ở pha 30. Việc thay bánh V23 cạnh tranh vốn phải qua đề nghị của Bình, báo giá/nguồn thật và quyết định của Hòa; lo lắng SEC05 không tự đặt mua.

Thay đổi vai trò nền, đưa thành viên mới vào quyền tài sản hoặc giải thể O04 cần cả ba người được thông báo và sự chấp nhận của mọi người có Claim bị ảnh hưởng. Quyết định vận hành trong phạm vi vai trò không cần biểu quyết mọi việc nhỏ.

## 15. Các cơ sở còn lại

- **O01:** An quản chuyên môn, kho và nợ; Liên thực hiện phần được giao. Ca khẩn không tự xóa C01, nhưng có thể tạo đề nghị gia hạn thật.
- **O02:** Mộc quản kho/xưởng và đánh giá; Thu không tự bán sản phẩm. Khi Mộc giảm việc nặng, quyền chỉ đổi sau đề nghị và bàn giao.
- **O05:** Phúc quản bếp, phòng và V33-O05. Huệ có quyền ăn/ở và lịch đổi công đã ghi; quan hệ cậu–cháu không làm Huệ thành người thừa kế tức thời hay cho Phúc cấm Huệ đi học.
- **O06:** Tâm chi thường tối đa 20 V01 cho việc đường đã có căn cứ. Chi vượt hạn cần hội đồng vụ việc gồm ba cư dân không hưởng trực tiếp hợp đồng; ít nhất một người có hiểu biết công việc để hỏi, nhưng chuyên môn không tự cho họ lợi ích tài chính. Quỹ O06 thuộc chức năng đường, không thuộc Tâm.

## 16. Áp vào các điểm căng ngày 1

| Điểm căng | Quy tắc áp dụng | Điều chưa được tự xảy ra |
|---|---|---|
| C01 và mái H01 | quyết định shared_commitment, hai người cùng biết nguồn/quỹ | An tự lấy tiền; Lâm tự bán đồ hộ |
| Đạt muốn học | Đạt giữ quyền xin lịch; H02 chỉ viện dẫn cam kết lao động thật | H02 coi học là phản bội; O03 tự nhận Đạt |
| nghi lệch kho SEC11 | Nga cần kiểm sổ/vật rồi mới tạo CaseRecord | nghi ngờ biến thành thiếu kho thật |
| Kha–Tùng cạnh tranh | đánh giá theo PracticeEvent từng người | điểm danh tiếng chung làm Kha liều |
| SEC15 của Yến | chỉ trở thành đề xuất khi Yến truyền đạt | ý định bí mật đổi OrgRule O03 |
| Tâm nghe tiếng rung | Observation kích hoạt kiểm cầu đúng quy trình | cầu tự đóng hoặc O06 tự chi vượt hạn |
| Phúc lo Huệ đi xa | có thể nói, thương lượng việc/ở | quan hệ cậu cho quyền cấm di chuyển |
| Huệ muốn học xa | cần đích, tin, nguồn, lịch và thay nghĩa vụ O05 | game sinh chuyến đi để tạo kịch tính |

## 17. Thứ tự xử lý trong mô phỏng

K1.7 dùng tám pha của [[LUOC_DO_TRANG_THAI]]:

- pha 20 hết hạn ResidencePermission, quyền tạm hoặc thông báo;
- pha 30 kiểm quyền, thẩm quyền, đồng thuận, Reservation và xung đột lợi ích;
- pha 50 cam kết giao dịch cùng thay đổi Claim/Right hợp lệ;
- pha 60 hoàn tất ký, bàn giao, đăng/gỡ thông báo hoặc phiên hòa giải;
- pha 70 tạo Observation/Message, cập nhật DomainReputation theo nguồn;
- pha 80 NPC đánh giá mục tiêu, phản ứng, khiếu nại hoặc đề nghị mới.

Một RoleRight bị thu hồi tại cùng mốc sẽ hết ở pha 20 trước khi giao dịch mới được kiểm ở pha 30. Người giữ kho ở xa chưa nhận tin vẫn có thể hành động theo bằng chứng cũ nếu quyền vật lý cho phép; hệ lưu giao dịch thật và tranh chấp sau đó, không hồi tố xóa vật đã giao.

## 18. Mức mô phỏng xa và giao diện đa nền tảng

Ở R3/R4 có thể gộp các buổi họp hoặc truyền tin ổn định thành Episode, nhưng phải giữ từng người được mời, ai tham dự, quyền biểu quyết/xử, kết quả và Claim còn mở. Không thay một cộng đồng bằng chỉ số “trật tự 72%”.

Điện thoại và máy tính dùng cùng dữ liệu/quyết định. Giao diện điện thoại có thể lần lượt mở **sự thật → quyền → nguồn → người biết**, còn máy tính đặt cạnh nhau; bố cục không được đổi kết quả hội đồng, phạm vi quyền hay thông tin NPC nhận. Mọi nút “đồng ý”, “giao quyền”, “công khai” phải hiện đối tượng, phạm vi và thời hạn trước khi xác nhận.

## 19. Bất biến phải giữ

1. Quan hệ không cấp quyền tài sản/cơ thể nếu thiếu hồ sơ áp dụng.
2. PublicNotice không truyền kiến thức tức thời cho toàn vùng.
3. OrgRule không đổi chỉ vì một thành viên nghĩ nên đổi.
4. Một quyền không được dùng ngoài phạm vi, hạn tiền, thời gian hoặc địa điểm.
5. Phán quyết không tự di chuyển vật, chữa thương hay sửa ký ức.
6. Không có điểm danh tiếng toàn cục hoặc sự thật lấy từ tin đồn.
7. Hôn phối/học việc/chăm sóc đều giữ quyền từ chối trong từng hành vi.
8. Di sản tách tài sản cá nhân, hộ và tổ chức; nợ không nhân đôi.
9. Hội đồng có xung đột lợi ích không được tạo Ruling hợp lệ.
10. Mọi thay đổi xã hội quan trọng có FactEvent, nguồn quyền và tập người thực sự biết.

## 20. Điều kiện kiểm thử VH01–VH22

1. VH01 — P00 là guest theo HIST:ROOM-P00; Huệ không tự biết điều khoản phòng.
2. VH02 — Qua 90 ngày không tự đổi P00 thành resident nếu thiếu xác nhận.
3. VH03 — Người cùng huyết thống không tự có quyền vào kho/phòng.
4. VH04 — Lâm không thể chi shared_commitment H01 một mình khi làm mất khả năng trả C01.
5. VH05 — Đạt là thành viên lao động H02 nhưng không bị biến thành người thân hoặc đồng sở hữu mọi vật.
6. VH06 — Hôn phối không chuyển nợ/tài sản/quyền tổ chức ngoài hồ sơ.
7. VH07 — Từ chối kết đôi không tự tạo phạt danh dự.
8. VH08 — Liên hoàn tất thao tác phụ không tự nhận quyền chẩn đoán/dạy.
9. VH09 — Thu rời học việc vẫn giữ kỹ năng thật nhưng mất quyền xưởng chưa bàn giao.
10. VH10 — CareDuty thất bại tạo nhu cầu tìm thay, không gán người chăm theo giới.
11. VH11 — Giúp khẩn cấp không tự tạo nợ tiền nếu thiếu căn cứ.
12. VH12 — Chết khóa đúng tài sản cá nhân; V33 tổ chức không vào di sản.
13. VH13 — Yến giữ kho khi Vân vắng nhưng không tự duyệt học viên/kỹ thuật mới.
14. VH14 — SEC15 không đổi quyền O03 trước Message/Proposal/Ruling hợp lệ.
15. VH15 — Bình dừng xe vì hỏng không tự có quyền chi V33-O04.
16. VH16 — Tin “Dũng bỏ chuyến” chỉ tạo Belief; hồ sơ hành trình quyết định FactEvent.
17. VH17 — Thông báo tại D01 chỉ tới người có Observation/Message phù hợp.
18. VH18 — Người không biết chữ có thể được đọc cho và lưu đúng người truyền/nội dung.
19. VH19 — Hội đồng có người cùng hộ một bên bị từ chối vì xung đột lợi ích.
20. VH20 — Chứng cứ thiếu giữ vụ unresolved, không dùng RNG chọn bên thắng.
21. VH21 — Ruling hoàn tiền tạo nghĩa vụ; V01 chỉ đổi chỗ qua Transaction thật.
22. VH22 — Cùng save/RNG/lệnh cho kết quả xã hội giống nhau trên điện thoại và máy tính.

Toàn bộ VH là điều kiện thiết kế chưa chạy. Cộng 22 VH với 252 điều kiện trước đó cho **274 điều kiện chưa chạy bằng mô phỏng**.

## 21. Giới hạn và bước kế tiếp

K1.7 chưa thiết kế luật của vùng khác, nhà nước cấp cao, hình phạt bạo lực, thuế, đất đai toàn thung lũng, nghi lễ tang/hôn chi tiết hoặc quyền đặc thù theo cảnh giới tu luyện. Nó cũng chưa vật chất hóa sổ, giấy, chỗ niêm yết và dấu xác thực vào tồn kho.

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
