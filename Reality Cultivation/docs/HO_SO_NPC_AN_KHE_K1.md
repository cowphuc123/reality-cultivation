---
aliases:
  - Hồ sơ NPC An Khê K1.6
  - Lịch sử N01–N20
tags:
  - reality-cultivation
  - ke-hoach
  - npc
  - an-khe
status: de-xuat
updated: 2026-09-06
---

# Hồ sơ lịch sử và quan hệ N01–N20 — K1.6

Tài liệu này mở rộng danh sách người trong [[DU_LIEU_KHOI_DAU]] bằng lịch sử trước ngày 1, quan hệ có hướng, tri thức, mục tiêu dài hạn và thông tin riêng tư. Nó dùng cấu trúc của [[DOI_SONG_TU_SINH_K1]] và [[NGUON_QUYET_DINH_K1]].

Đây là **trạng thái khởi tạo đề xuất**, không phải tương lai được viết sẵn. Không hồ sơ nào buộc người đó phải kết bạn, phản bội, cưới, chết hay giúp P00. Các quan hệ gia đình/văn hóa còn cần K1.7 xác định quy tắc chung.

## 1. Quy ước lịch sử

- Ngày 1 của INIT-A là mốc Y0-D001; `Y-1` là năm ngay trước mốc đó.
- Sự kiện lịch sử có mã `HIST:...`; chúng là dữ kiện khởi tạo có chủ đích, chưa phải kết quả một mô phỏng quá khứ đã chạy.
- Mỗi kỹ năng, tuyến đã biết, quan hệ và niềm tin quan trọng phải trỏ ít nhất một HIST hoặc vai trò hiện hành.
- Không thêm V01, V02, vật dụng, thương tích hay công pháp ngoài kho hiện có. Tài sản cũ đã tiêu/hỏng chỉ được nhắc nếu không còn được cộng vào trạng thái ngày 1.
- “Riêng tư” là điều nhân vật không chủ động công khai; “bí mật” cần danh sách người biết. Công cụ kiểm chứng biết, NPC/P00 thì không tự biết.
- Tên, tuổi và nghề giữ nguyên dữ liệu nền.

## 2. Hộ, cơ sở và quan hệ pháp lý ban đầu

| Nhóm | Thành viên | Quan hệ khởi tạo đề xuất |
|---|---|---|
| H01 | N01 Lâm, N02 Mai | Bạn đời được hộ công nhận; cùng quyền chi H01 theo giới hạn đã có |
| H02 | N09 Sơn, N10 Cúc, N11 Đạt, N12 Nga | Sơn–Cúc là bạn đời; Nga là em Sơn; Đạt là lao động thành viên, không phải người thân |
| O01 | N03 An, N04 Liên | Thầy thuốc và học việc; không mặc định quan hệ huyết thống |
| O02 | N07 Mộc, N08 Thu | Chủ xưởng/người dạy và học việc có cam kết |
| O03 | N13 Vân, N14 Kha, N15 Tùng, N16 Yến | Vân–Yến là chị em; Kha/Tùng là người học, có quyền khác nhau theo hồ sơ O03 |
| O04 | N05 Bình, N06 Hòa, N17 Dũng | Nhóm kinh doanh: vận chuyển, quầy, hộ tống; tài sản O04 không phải tài sản cá nhân bằng nhau |
| O05 | N19 Phúc, N20 Huệ | Phúc là cậu của Huệ; Huệ làm vườn/chuyển tin đổi ăn ở |
| O06 | N18 Tâm | Một người giữ trạm; quan hệ cung ứng với O05 là hợp đồng, không phải thành viên O05 |

Những quan hệ này chỉ áp trong fixture An Khê. Hình thức hôn phối, quyền hộ, nhận học việc và họ hàng chưa được nâng thành luật chung thế giới.

## 3. Mạng sự kiện lịch sử chung

| Mã | Thời điểm | Dữ kiện khởi tạo và dấu vết còn lại |
|---|---|---|
| HIST:AK-FLOOD | Y-12, mùa mưa | Lũ làm hỏng đường cũ gần D08. Tâm, Mộc và An cùng tham gia ứng phó; nguồn tạo tin cậy nghề giữa họ. Không thêm thương tích hiện tại. |
| HIST:H01-ROOF | Y-3 đến nay | Mái khu H01 xuống cấp dần; Lâm/Mai đã dành công nhưng chưa tạo quỹ tiền riêng ngoài V33-H01. Mục tiêu sửa mái có nguồn. |
| HIST:MED-DEBT | Y-1 | O01 cung cấp một đợt chăm sóc cho H01 theo trả chậm; còn đúng nghĩa vụ C01 12 V01 ngày 1. Không còn vật thuốc nào từ sự kiện để cộng kho. |
| HIST:MARKET-PACT | Y-4 | Hòa, Bình và Dũng lập cách phối hợp O04: Hòa giữ vốn/quầy, Bình vận chuyển, Dũng bảo vệ. Quyền cụ thể nằm ở Role/Right hiện hành. |
| HIST:CART-WEAR | Y-1 đến nay | Bình và Mộc nhiều lần sửa V23; lần kiểm gần nhất cho thấy xe vẫn dùng được nhưng nên thay bánh khi có nguồn. Đây là nguồn kỹ năng N17 kéo xe nếu overlay X02 bật hồ sơ học cùng Bình. |
| HIST:FIELD-REFORM | Y-6 | Sơn/Cúc cùng tổ chức lại các lô D05; Nga học cân/kho, Đạt vào nhóm sau đó. Nguồn cho tuyến, nghề và trách nhiệm H02. |
| HIST:O03-INCIDENT | Y-5 | Một phiên luyện dùng nguồn quá gấp bị dừng trước thương tích nặng. Vân/Yến biết đầy đủ; Kha/Tùng chỉ biết bản tóm lược được chia sẻ. Nguồn cho chính sách kho thận trọng. |
| HIST:CLINIC-SUPPLY | Y-2 | An thiếu vật tư trong một đợt bận; Mai giao vải, Lâm tìm V14, Bình vận chuyển. Tạo quan hệ nghề nhưng không còn hợp đồng/tài sản treo. |
| HIST:BRIDGE-TOOLS | Y-2 | Tâm nhờ Mộc sửa một dụng cụ kiểm cầu; Dũng hộ tống một chuyến vật liệu. Tâm biết năng lực họ theo đúng lĩnh vực. |
| HIST:APPRENTICE-MEET | Y-1 | Liên, Thu và Huệ gặp nhau nhiều lần tại D01 khi chuyển vật tư/tin. Họ quen biết, chưa mặc định thân thiết ngang nhau. |
| HIST:WORK-NOTES | Y-1 | Đạt và Huệ bắt đầu trao đổi các tin việc công khai khi gặp tại D01/D05. Hai bên chỉ biết nội dung đã nói, không truy cập lịch/mục tiêu bí mật của nhau. |
| HIST:KIN-CUC-KHA | Trước Y0 | Hộ hai bên giữ phả hệ cho thấy Cúc và Kha có quan hệ họ hàng xa theo nhánh mẹ. Quan hệ này được hai bên biết nhưng không tạo quyền tài sản hay quyền vào O03. |
| HIST:STUDY-NOTICE | Trước ngày 1 | O03 gửi thông báo buổi nhập môn qua Yến tới quầy Hòa; đây là nguồn mà Hòa kể P00 ngày 6. |
| HIST:ROOM-P00 | Trước INIT-A | Phúc và P00 thống nhất phòng, giá 1 V01/ngày và giờ thu; chỉ Phúc/P00 biết toàn văn, Huệ biết có khách nhưng không tự biết mọi điều khoản. |

## 4. N01 — Lâm, 31 tuổi

**Vai trò và nguồn kỹ năng.** Lâm lớn lên ở vùng ven thung lũng, học nhận dạng một số cây thông dụng từ một người hái thuốc đã rời vùng (`HIST:N01-TRAIN`, Y-15→Y-9). Anh chỉ biết các loài/quy trình đã học, không có tri thức toàn bộ dược liệu. Các chuyến H01 và O01 tạo tri thức D02–D11–D06–D03.

**Lịch sử gần.** Lâm và Mai lập H01 tại D02 ở Y-4. Mái xuống cấp từ HIST:H01-ROOF. Sau khoản chăm sóc HIST:MED-DEBT, Lâm coi việc trả đúng C01 là vấn đề danh dự dù An chưa gây áp lực công khai.

**Quan hệ có hướng.** Tin Mai trong quản lý kho; biết ơn An về chăm sóc nhưng hơi ngại gặp khi nợ chưa trả; tin Bình giao vật tư đúng hẹn; đánh giá N20 Huệ là người chỉ đường hữu ích tại D01.

**Tri thức đầu kỳ.** Biết nguồn công cộng D11, vùng thu V14 D06, tuyến phục vụ nghề, H01/O01 và vai trò cơ bản của N20; không biết kho/tiền O03 hoặc nội dung công pháp.

**Mục tiêu.** Trả C01 đúng hạn; góp nguồn sửa mái; giữ việc hái không vượt khả năng cơ thể. Nếu chân/tay giảm chức năng, ưu tiên tìm việc gần thay vì cố hoàn thành hình tượng “người hái thuốc”.

**Riêng tư.** Trong lần đi D06 gần nhất, Lâm thấy một khoảnh cây có hình thái lạ nhưng chưa xác định có ích. Chỉ Lâm biết Observation này; chưa tồn tại vật phẩm dược liệu mới hoặc giá trị chắc chắn.

## 5. N02 — Mai, 29 tuổi

**Vai trò và nguồn kỹ năng.** Mai học dệt/cắt vải trong hộ cũ từ Y-13, chuyển tới D02 ở Y-4. HIST:CLINIC-SUPPLY tạo kinh nghiệm làm băng nhưng không cấp kỹ thuật y khoa.

**Lịch sử gần.** Mai cùng Lâm quản H01; cô nhận phần cân kho và trả nghĩa vụ vì Lâm thường đi xa. Cô là người lưu mốc C01 và biết chính xác 12 V01 phải trả.

**Quan hệ có hướng.** Gắn bó với Lâm nhưng tin khả năng ước lượng chi phí của anh thấp hơn khả năng tìm cây; tin An về chăm sóc; tôn trọng tay nghề Mộc; có thiện cảm nghề với Liên vì Liên từng giải thích cách đóng gói băng.

**Tri thức đầu kỳ.** Biết D02/D01/D03, cách phát suất H01, tồn kho/quyền H01, nghĩa vụ C01 và quy trình vải đã học. Không biết vị trí hiện tại của người ở xa nếu chưa nhận tin.

**Mục tiêu.** Hoàn đơn vải có nguồn, giữ dự trữ hộ, thanh toán C01 và chỉ sửa mái khi quỹ còn an toàn.

**Riêng tư.** Mai đã ước lượng mái cần nhiều công hơn Lâm đang dự tính. Đây là Belief từ quan sát, chưa phải giá hợp đồng; cô chưa nói để tránh làm Lâm bỏ mục tiêu trước khi có báo giá thật.

## 6. N03 — An, 47 tuổi

**Vai trò và nguồn kỹ năng.** An học nghề qua hai cơ sở ngoài An Khê (`HIST:N03-TRAIN`, Y-29→Y-20), sống tại D03 từ Y-18. Kỹ năng chỉ gồm quy trình đã khai báo trong O01; không tự biết mọi bệnh.

**Lịch sử gần.** HIST:AK-FLOOD tạo kinh nghiệm xử lý nhiều người và tin cậy Tâm. HIST:MED-DEBT tạo C01 với H01. An nhận Liên làm học việc ở Y-3 sau nhiều tháng quan sát công việc phụ trợ.

**Quan hệ có hướng.** Tin Liên ở thao tác đã giao nhưng chưa tin chẩn đoán độc lập; tin Lâm về nhận dạng V14 thường; tin Bình giao đúng chứng từ; tôn trọng Vân nhưng không đồng ý dùng nguồn tu luyện cho nhu cầu không cấp bách khi y quán thiếu vật tư.

**Tri thức đầu kỳ.** Biết D03/D01/D02, nguồn V14 D06 qua báo cáo cũ, người cung ứng đã giao dịch và nghĩa vụ C01. Không biết chính xác kho từng hộ.

**Mục tiêu.** Duy trì khả năng phục vụ O01, dạy Liên không vượt bước, thu C01 đúng hồ sơ nhưng có thể thương lượng nếu H01 có biến cố thật.

**Riêng tư.** An sẵn lòng gia hạn C01 một lần nếu H01 chủ động báo khó khăn, nhưng đây là ý định có điều kiện chưa thành đề nghị hay quyền của H01.

## 7. N04 — Liên, 24 tuổi

**Vai trò và nguồn kỹ năng.** Liên từng phụ chăm người nhà ngoài vùng; An chỉ công nhận phần quan sát triệu chứng, vệ sinh và thao tác phụ đã kiểm tra. Cô đi D03–D01–D11 theo nhiệm vụ nước và vật tư.

**Lịch sử gần.** Vào học việc Y-3 (`HIST:N04-APPRENTICE`). Một lần ở Y-1, Liên nhận ca khó rồi gọi An trước khi can thiệp; kết quả này củng cố thói quen không vượt quyền, không phải bằng chứng cô đã biết cách xử lý ca đó.

**Quan hệ có hướng.** Kính trọng An nhưng sợ làm chậm y quán; thân thiện với Thu; tin Huệ chuyển lời thường chính xác; dè dặt với lời khuyên tu luyện của Tùng do thiếu chuyên môn.

**Tri thức đầu kỳ.** Biết lịch O01, các tuyến sinh hoạt, kỹ năng phụ trợ được giao và nguồn vật tư công khai. Không biết bí mật O03 hoặc chẩn đoán sâu của bệnh nhân ngoài quyền.

**Mục tiêu.** Hoàn thành kỹ năng khám nền, chứng minh có thể nhận một số ca đơn giản có giám sát, giữ thời gian nghỉ để không tăng lỗi.

**Riêng tư.** Liên ghi lại một lỗi chép nhãn đã tự phát hiện và sửa trước khi vật được dùng. Chỉ Liên biết chi tiết; không có vật sai nhãn ở INIT-A. Cô lo An sẽ đánh giá thấp mình nếu kể.

## 8. N05 — Bình, 34 tuổi

**Vai trò và nguồn kỹ năng.** Bình theo các đoàn hàng từ Y-16, biết tuyến D01–D05–D07–D08–D06 và đường vòng của fixture C qua hành trình thật. Anh đồng lập quy trình O04 ở HIST:MARKET-PACT.

**Lịch sử gần.** V23 đã nhiều lần được Bình/Mộc sửa trong HIST:CART-WEAR. Bình dành ưu tiên ngân sách cho bánh mới, nhưng không sở hữu quỹ O04 và không thể tự chi.

**Quan hệ có hướng.** Tin Hòa ở thanh toán nhưng cho rằng Hòa trì hoãn bảo trì; tin Dũng khi hộ tống; tin Mộc về sửa xe; xem N12 là đối tác kiểm đếm chặt nhưng công bằng.

**Tri thức đầu kỳ.** Biết tuyến nghề, lịch/điều kiện các đơn mình nhận, tải xe đã học và một số điểm nghỉ. Không biết nội dung kiện nếu bị niêm và hợp đồng không cho xem.

**Mục tiêu.** Hoàn các đơn, thuyết phục O04 thay bánh trước hỏng, không nhận chuyến trùng giờ và giữ danh tiếng đúng hẹn.

**Riêng tư.** Bình đã nghe tiếng lệch nhỏ ở bánh dưới tải nặng. Observation này chưa đủ kết luận hỏng; anh đã nói “nên kiểm” với Hòa nhưng chưa nói mức lo của mình. Mộc chưa kiểm lần mới nhất.

## 9. N06 — Hòa, 30 tuổi

**Vai trò và nguồn kỹ năng.** Hòa học buôn tại chợ vùng lân cận Y-14→Y-8, mở quầy An Khê cùng Bình/Dũng ở Y-4. Kỹ năng gồm định giá/kiểm hàng quen thuộc, không tự giám định mọi vật liệu.

**Lịch sử gần.** Hòa thiết lập nguyên tắc giữ vốn nhập lô; từng suýt hết tiền mặt sau một lô bán chậm ở Y-2, nhưng khoản đó đã kết thúc và không tạo nợ ngày 1.

**Quan hệ có hướng.** Tin Bình giao hàng nhưng thấy anh quá thận trọng với V23; tin Dũng về an ninh; tôn trọng Nga/N12 ở kiểm lượng; coi Phúc là khách buôn đáng tin nhưng biết O05 có dự trữ mỏng.

**Tri thức đầu kỳ.** Biết quầy, giá chào, kho/quyền O04, tuyến thị trường và thông báo HIST:STUDY-NOTICE. Không biết N13 hiện diện ngày 9 nếu chưa có cập nhật.

**Mục tiêu.** Bán hàng mà vẫn đủ vốn/lượng cho đơn đã nhận, duy trì lịch quầy và kiểm V23 khi có bằng chứng mới.

**Riêng tư.** Hòa đặt một ngưỡng vốn nội bộ cao hơn mức Bình mong muốn. Chỉ Hòa biết con số mục tiêu; nó không phải Reservation pháp lý cho tới khi tạo quyết định giữ vốn.

## 10. N07 — Mộc, 52 tuổi

**Vai trò và nguồn kỹ năng.** Mộc làm xưởng từ thời trẻ, chuyển D04 ở Y-21. Ông biết sửa các dụng cụ/mối ghép đã có mẫu; không tự chế vật thiếu quy trình. HIST:AK-FLOOD và HIST:BRIDGE-TOOLS tạo hiểu biết hạn chế về dụng cụ cầu.

**Lịch sử gần.** Nhận Thu làm học việc Y-2. Ông từng dạy quá nhanh một học việc cũ rồi phải làm lại sản phẩm; ký ức đó khiến ông chia thao tác nhỏ và kiểm từng bước.

**Quan hệ có hướng.** Tin Thu ở cắt/chuẩn bị, chưa giao toàn bộ lắp cán; tin Bình mô tả triệu chứng xe nhưng chỉ kết luận sau khi xem; tôn trọng Tâm về kết cấu cầu; không thích Hòa trì hoãn quyết định bảo trì.

**Tri thức đầu kỳ.** Biết D04/D01/D07/D08, vật liệu xưởng, quyền O02 và khách nghề. Không biết tài chính bí mật O04.

**Mục tiêu.** Giữ chất lượng sửa, dạy Thu tới một mốc thao tác độc lập, tránh nhận việc khi thiếu vật liệu thật.

**Riêng tư.** Mộc muốn giảm dần việc nặng trong vài năm tới, nhưng Body ngày 1 chưa có thương tích/bệnh được thêm. Đây là LongGoal do tuổi và sở thích, không phải chẩn đoán.

## 11. N08 — Thu, 21 tuổi

**Vai trò và nguồn kỹ năng.** Thu vào xưởng Y-2; đã được Mộc xác nhận thao tác đo, cắt và chuẩn bị, đang học lắp cán. Cô biết tuyến lấy nước và đường D04–D01.

**Lịch sử gần.** HIST:APPRENTICE-MEET tạo quen biết với Liên/Huệ. Một sản phẩm chuẩn bị tốt ở Y-1 làm Mộc giao thêm trách nhiệm, nhưng chưa trao quyền bán/chi kho.

**Quan hệ có hướng.** Tin Mộc về nghề nhưng đôi lúc thấy tiến độ dạy chậm; thân với Liên hơn Huệ do cùng hoàn cảnh học việc; dè chừng Bình khi anh thúc sửa gấp mà không có lịch.

**Tri thức đầu kỳ.** Biết phần xưởng được giao, vật thật mình được dùng, các tuyến sinh hoạt. Không biết giá vốn, quyền chi N07 hoặc bí mật kỹ thuật chưa dạy.

**Mục tiêu.** Hoàn thao tác lắp cán độc lập, tích lịch sử sản phẩm đạt và sau đó thương lượng phạm vi trách nhiệm mới.

**Riêng tư.** Thu đang cân nhắc học thêm sửa bình nước vì thấy nhu cầu thường xuyên; chưa hỏi Mộc, nên chưa có Goal học chính thức hoặc kỹ năng.

## 12. N09 — Sơn, 39 tuổi

**Vai trò và nguồn kỹ năng.** Sơn làm ruộng từ Y-23; HIST:FIELD-REFORM là nguồn cho lô D05 và cách theo dõi chín. Anh chịu trách nhiệm lao động/sản lượng, không giữ quyền kho một mình.

**Lịch sử gần.** Sơn và Cúc lập hộ ở D05 từ Y-11. Nga gia nhập quản kho ở Y-5 sau khi học cân; Đạt vào nhóm lao động Y-2 theo hợp đồng thành viên.

**Quan hệ có hướng.** Tin Cúc về giống/đất; tin Nga về số kho nhưng đôi khi muốn lấy dụng cụ nhanh hơn quy trình; đánh giá Đạt khỏe và chăm nhưng dễ bị cơ hội học kéo khỏi mùa bận; chưa biết năng lực P00 trước thử J01.

**Tri thức đầu kỳ.** Biết D05, lô/chặng ruộng, D01/D11 và các thành viên H02. Không biết đường xa ngoài nhu cầu nghề.

**Mục tiêu.** Thu đúng lô chín, không để cơ hội thuê làm mất vụ, chuẩn bị nền cho chu kỳ sau khi mô hình giống được bổ sung.

**Riêng tư.** Sơn đã thấy một đoạn rãnh thoát chậm sau mưa. Đây là Observation cần kiểm, chưa phải sự kiện mất mùa hay hỏng công trình.

## 13. N10 — Cúc, 37 tuổi

**Vai trò và nguồn kỹ năng.** Cúc học chọn/giữ giống và chăm đất trong hộ gốc; cùng Sơn thực hiện HIST:FIELD-REFORM. Mô hình vụ mới chưa đủ nên kỹ năng này không tự sinh cây trong fixture 30 ngày.

**Lịch sử gần.** Cúc từng phản đối bán hết phần dự phòng ở Y-3; lần đó nhóm giữ đủ qua một đợt giao trễ. Ký ức tạo khuynh hướng thận trọng, không cấp quyền phủ quyết vô hạn.

**Quan hệ có hướng.** Gắn bó với Sơn nhưng tin dự báo kho của Nga hơn ước lượng miệng; đối xử tốt với Đạt song không hứa tài trợ học; quý Kha vì liên hệ họ hàng xa theo nhánh mẹ, nhưng không có nghĩa vụ tài sản.

**Tri thức đầu kỳ.** Biết nguồn/nhu cầu H02, quy trình giống đã học, tuyến nước/chợ. Không biết kho O04 ngoài các giao dịch đã báo.

**Mục tiêu.** Giữ nguồn giống, tránh bán vượt phần rảnh và truyền kỹ năng quan sát đất cho người đủ kiên nhẫn.

**Riêng tư.** Cúc lo kế hoạch bán buôn không để đủ biên mất mát, nhưng chưa có dữ liệu hao hụt để chứng minh. Đây là Belief thúc đẩy kiểm kê.

## 14. N11 — Đạt, 26 tuổi

**Vai trò và nguồn kỹ năng.** Đạt từng làm thuê nhiều nơi gần An Khê, vào H02 Y-2. Anh biết lao động ruộng cơ bản và các tuyến D05–D01–D02, chưa có quyền kho.

**Lịch sử gần.** Một người biết chữ tại chợ từng giúp Đạt đọc hợp đồng (`HIST:N11-LITERACY`, Y-3). Đạt muốn học tiếp và coi J05 là một bước có thể tìm hiểu, chưa biết nội dung công pháp.

**Quan hệ có hướng.** Tôn trọng Sơn về nghề, tin Nga trả công đúng sổ, thấy Cúc quá thận trọng nhưng vẫn nghe khi nói về dự trữ; bạn trao đổi tin việc với Huệ. Có thể cạnh tranh P00 mà không thù địch sẵn.

**Tri thức đầu kỳ.** Biết việc/đường địa phương đã từng làm, giá công gần đây qua trải nghiệm và rằng O03 có bài học qua thông báo công khai; không biết điều kiện sâu.

**Mục tiêu.** Nhận công hợp lịch, dành tiền học và tăng khả năng đọc hợp đồng; không nhận hai việc trùng để đạt mục tiêu bằng gian lận sổ.

**Riêng tư.** Đạt sợ bị coi là thiếu trung thành nếu rời việc ruộng để học. Chỉ Đạt biết mức lo; Sơn/Cúc chỉ quan sát được việc anh hỏi về học.

## 15. N12 — Nga, 28 tuổi

**Vai trò và nguồn kỹ năng.** Nga là em Sơn, học cân/ghi kho từ Y-8 và giữ vai trò H02 từ Y-5. Cô biết quyền trả J01, phát V02 và giao bán buôn theo chính sách hiện tại.

**Lịch sử gần.** Một lần Y-2 có hai phiếu đòi cùng lô nhưng được phát hiện trước giao; không mất vật. Ký ức này tạo quy trình Reservation và chống cấp trùng.

**Quan hệ có hướng.** Tin Sơn/Cúc về ruộng nhưng yêu cầu chứng từ lượng; tin Đạt ở công việc đã nghiệm thu; đánh giá Hòa rõ tiền nhưng hay mặc cả; với P00 bắt đầu trung tính và cập nhật sau từng J01.

**Tri thức đầu kỳ.** Biết đầy đủ kho/quyền H02, lô chín đã ghi, hợp đồng bán buôn và tuyến D05–D01/D11. Không biết tiền túi cá nhân người khác.

**Mục tiêu.** Không cấp trùng, giữ đủ ngân sách/lương thực đã cam kết, tạo đề nghị việc chỉ khi có lô và tiền giữ thật.

**Riêng tư.** Nga giữ một ghi chú cũ khiến cô nghi đã từng lệch một suất, nhưng kiểm kê hiện tại khớp 120 V02. Belief nghi ngờ không tạo vật thiếu hoặc sửa tổng kho.

## 16. N13 — Vân, 43 tuổi

**Vai trò và nguồn kỹ năng.** Vân học và dạy các phần O03 công nhận; nội dung cụ thể chỉ gồm công pháp/quy trình đã có trong [[TU_LUYEN_THU]]. Cô quản quyền lớn cùng Yến, không trực tiếp giữ mọi vật.

**Lịch sử gần.** HIST:O03-INCIDENT khiến Vân giảm tốc độ cấp quyền và yêu cầu buổi nhập môn trước tự luyện. Cô gửi HIST:STUDY-NOTICE để dùng một phần lịch dạy, không hứa nhận mọi người.

**Quan hệ có hướng.** Tin Yến về kho/quy trình; đánh giá Kha ổn định nhưng quá dè dặt, Tùng sáng ý nhưng dễ tăng tải; tôn trọng An trong y thuật nhưng không đồng ý mọi ưu tiên nguồn của An.

**Tri thức đầu kỳ.** Biết O03, người học, quyền/nguồn tu luyện và các tuyến phục vụ. Không biết suy nghĩ riêng hoặc sức khỏe sâu của người chưa khám.

**Mục tiêu.** Dạy đúng giới hạn, giữ nguồn học, tìm bằng chứng về phương pháp ổn định thay vì chạy theo số học tăng nhanh.

**Riêng tư.** Vân tự cho rằng mình có phần trách nhiệm trong HIST:O03-INCIDENT vì đã đồng ý lịch quá dày. Yến biết sự kiện nhưng không biết Vân tự đánh giá nặng tới mức nào.

## 17. N14 — Kha, 25 tuổi

**Vai trò và nguồn kỹ năng.** Kha vào O03 Y-4 sau một vòng kiểm tra; biết Tĩnh Lưu trong phạm vi DL05. Quan hệ họ hàng xa với Cúc là nguồn ban đầu dẫn Kha tới thông tin O03, không phải quyền nhập học.

**Lịch sử gần.** Kha từng dừng một phiên khi cảm thấy dấu hiệu quá tải, được Vân đánh giá tốt về tự kiểm. Anh chia việc nước O03 để đổi quyền ở/học theo cam kết hiện tại.

**Quan hệ có hướng.** Tin Vân về an toàn, tin Yến về kho nhưng thấy thủ tục chậm; cạnh tranh nhẹ với Tùng về cách học, không mặc định thù địch; biết ơn Cúc vì chỉ đường.

**Tri thức đầu kỳ.** Biết D09/D10/D01/D11, Tĩnh Lưu đã học, quyền của bản thân và phần công khai về hai người học khác. Không biết kho bí mật hay toàn bộ công pháp Vân.

**Mục tiêu.** Ổn định Tĩnh Lưu, tăng hiểu biết cơ thể trước khi tăng tải và giữ quyền học bằng việc hoàn thành nghĩa vụ.

**Riêng tư.** Kha lo sự thận trọng khiến mình tụt sau Tùng. Đây là cảm xúc/so sánh riêng, không tự tăng mức liều lĩnh nếu chưa có Trigger.

## 18. N15 — Tùng, 27 tuổi

**Vai trò và nguồn kỹ năng.** Tùng vào O03 Y-3, được học phần nhập môn Liệt Mạch và kỹ năng quan sát nguồn theo quyền. Không được tự lấy V27 hay mở kho.

**Lịch sử gần.** Tùng từng đề xuất một biến thể vận hành, bị Vân yêu cầu kiểm chứng trên giấy trước. Không có lần vận công bí mật hoặc sản phẩm mới trong INIT-A.

**Quan hệ có hướng.** Kính trọng Vân nhưng thấy chính sách quá bảo thủ; tin Yến giữ sổ chính xác; coi Kha là người kiểm soát tốt nhưng thiếu tham vọng; hay hỏi Liên về cơ thể dù Liên không có quyền dạy y thuật sâu.

**Tri thức đầu kỳ.** Biết tuyến O03, phần Liệt Mạch đã học, quy tắc xin nguồn và thông tin công khai. Không biết chẩn đoán người khác hoặc kết quả thử chưa diễn ra.

**Mục tiêu.** Tìm nguồn/giờ hỗ trợ hợp lệ để kiểm chứng Liệt Mạch, chứng minh phương án mà không lách quyền.

**Riêng tư.** Tùng sợ đề xuất bị gắn với HIST:O03-INCIDENT dù anh không tham gia sự kiện. Chỉ Tùng biết cách anh diễn giải điều đó.

## 19. N16 — Yến, 36 tuổi

**Vai trò và nguồn kỹ năng.** Yến là em Vân, quản kho/trạm từ Y-9. Cô biết sổ V26–V30, quyền chi thường tối đa 20 V01 và khi nào cần Vân duyệt.

**Lịch sử gần.** Trong HIST:O03-INCIDENT, Yến phát hiện tốc độ rút nguồn lệch kế hoạch và báo dừng. Sự kiện tạo thói quen kiểm mốc, không cho cô quyền đoán mọi nguy hiểm.

**Quan hệ có hướng.** Tin Vân về nội dung dạy nhưng sẵn sàng phản đối lịch nguồn; tin Kha tuân quy trình hơn Tùng; giao dịch nghề với Hòa/N03 nhưng không chia sẻ kho nội bộ.

**Tri thức đầu kỳ.** Biết toàn bộ lượng/quyền O03 được giao, lịch N13 đã chấp nhận và tuyến cấp nước. Không tự biết kho/ý định tổ chức khác.

**Mục tiêu.** Bảo toàn nguồn, ghi cấp phát đủ, tránh chia nhỏ giao dịch để lách duyệt và duy trì bằng chứng cho mọi bài học.

**Riêng tư.** Yến nghĩ O03 nên có người duyệt thay khi Vân vắng, nhưng chưa đề nghị chính thức vì chưa rõ thể chế. Đây là LongGoal tổ chức chưa thành chính sách.

## 20. N17 — Dũng, 33 tuổi

**Vai trò và nguồn kỹ năng.** Dũng từng làm hộ tống tuyến ngắn, tham gia O04 ở HIST:MARKET-PACT. Anh biết D01–D07–D08 và các tuyến đã hộ tống; hồ sơ kéo V23 chỉ bật trong overlay có HIST:CART-WEAR phù hợp.

**Lịch sử gần.** HIST:BRIDGE-TOOLS tạo lần phối hợp với Tâm. Một chuyến Y-1 anh từ chối nhận thêm đơn trùng giờ; Hòa ban đầu khó chịu nhưng hợp đồng đầu không bị bỏ.

**Quan hệ có hướng.** Tin Bình đánh giá đường, tin Hòa trả theo thỏa thuận nhưng không thích lịch ghép quá sát; tôn trọng Tâm; cảnh giác với người lạ cho tới khi có hành vi, không mặc định thù P00.

**Tri thức đầu kỳ.** Biết tuyến gác/hộ tống, quy trình kiểm hàng được giao và vai trò O04. Không biết nội dung hàng kín hay mục tiêu riêng của khách.

**Mục tiêu.** Giữ cam kết trong sức mình, từ chối việc trùng, tích bằng chứng để thương lượng lịch có khoảng dự phòng.

**Riêng tư.** Dũng sẵn sàng rời ca gác để cứu người nếu trực tiếp nhận biết nguy hiểm, dù tin rằng Hòa sẽ không hài lòng. Đây là ưu tiên cá nhân, không phải quyền bỏ gác không hậu quả.

## 21. N18 — Tâm, 45 tuổi

**Vai trò và nguồn kỹ năng.** Tâm trông cầu từ Y-14, học kiểm các dấu hiệu/kết cấu thuộc quy trình trạm. HIST:AK-FLOOD và HIST:BRIDGE-TOOLS giải thích quan hệ với An/Mộc/Dũng.

**Lịch sử gần.** Tâm từng bỏ điểm gác để lấy nước vì không có người thay; từ đó ghi rõ khoảng vắng. Ông có quyền chi tới 20 V01 của O06 nhưng không tự quyết nghĩa vụ lớn.

**Quan hệ có hướng.** Tin Mộc về dụng cụ, Dũng về hộ tống, An về chăm sóc; thấy Hòa ưu tiên hàng hơn bảo trì; tin Phúc/N20 giao đủ theo lịch nhưng chỉ xác nhận khi hàng tới.

**Tri thức đầu kỳ.** Biết D08/D07/D06/D11, trạng thái quan sát gần nhất của cầu, lịch O05→O06 và quy trình đóng cầu. Không biết hàng đã rời D02 từ xa.

**Mục tiêu.** Duy trì kiểm cầu, có vật tư khi dấu hiệu thật xuất hiện và tìm phương án giảm khoảng trống lúc lấy nước.

**Riêng tư.** Tâm đã nghe một tiếng rung nhỏ trong gió mạnh nhưng kiểm thường chưa tìm thấy hỏng. Chỉ Tâm biết Observation; nó không phải cầu hỏng của FX-C và không cho phép đóng cầu vô hạn.

## 22. N19 — Phúc, 41 tuổi

**Vai trò và nguồn kỹ năng.** Phúc quản bếp/phòng ở D02 từ Y-10, học bảo quản/cấp suất theo các loại hiện có. Anh là cậu Huệ và nhận Huệ vào O05 từ Y-3.

**Lịch sử gần.** Một đợt giao trễ Y-2 khiến Phúc chuyển sang theo dõi lượng đã cam kết riêng với lượng rảnh. HIST:ROOM-P00 tạo hợp đồng phòng với P00.

**Quan hệ có hướng.** Tin Huệ ở chuyển tin nhưng kiểm lại tiền/hàng; tin Hòa về giá chào, dè dặt với việc lấy kho O05 bán ngoài kế hoạch; tôn trọng Tâm vì báo thiếu sớm.

**Tri thức đầu kỳ.** Biết kho/quyền O05, lịch O06, khách phòng và tuyến D02–D01/D08 qua báo cáo. Không biết P00 có bao nhiêu tiền ngoài khoản P00 xuất trình/đã nói.

**Mục tiêu.** Giữ phòng sạch, cấp đúng cam kết, không bán phần đã dành cho O06 và giúp Huệ học quản lý mà không giao quyền quá sớm.

**Riêng tư.** Phúc chưa chắc muốn Huệ đi xa học nghề vì sợ thiếu người, nhưng chưa cấm hay nói rõ. Đây là xung đột tình cảm/nghĩa vụ, không phải Contract giữ Huệ.

## 23. N20 — Huệ, 23 tuổi

**Vai trò và nguồn kỹ năng.** Huệ lớn lên cùng họ hàng ở ngoài vùng, tới ở với Phúc Y-3. Cô học chăm cây cơ bản, tuyến D02–D01–D07–D08 và chuyển thông điệp nguyên văn.

**Lịch sử gần.** HIST:APPRENTICE-MEET tạo quen biết Liên/Thu. Một lần Y-1 cô tự thêm suy đoán vào tin và bị người nhận hiểu sai; không còn nghĩa vụ vật chất, nhưng ký ức khiến cô phân biệt điều thấy với điều được kể.

**Quan hệ có hướng.** Biết ơn Phúc nhưng thấy mình ít quyền quyết; thích trao đổi việc với Đạt; tin Liên cẩn thận, thấy Thu dễ nói chuyện; tôn trọng Tâm nhưng không thích chờ kiểm hàng lâu.

**Tri thức đầu kỳ.** Biết các tuyến chuyển tin/giao O06, vị trí nghề công khai tại D01 và cách tìm N12/D05. Không biết chi tiết kho, thư kín hoặc sự thật ngoài nội dung được giao.

**Mục tiêu.** Học chăm cây đủ để nhận việc riêng, xây uy tín đưa tin chính xác và trong tương lai cân nhắc đi học nếu có nguồn sống/lịch hợp lệ.

**Riêng tư.** Huệ đang tìm thông tin về nơi học trồng cây tốt hơn nhưng chưa quyết định rời O05. Đạt biết cô “muốn học thêm”, không biết ý định đi xa.

## 24. Cạnh quan hệ quan trọng ngày 1

Các giá trị không dùng một điểm thiện cảm. Bảng chỉ ghi chiều và lĩnh vực nổi bật; mức số cụ thể chưa chốt.

| Từ → tới | Loại/miền | Nguồn | Điều người kia có biết? |
|---|---|---|---|
| Lâm→Mai | gắn bó; tin quản kho | H01-ROOF, đời sống chung | Mai biết qua hành vi/lời nói, không biết mọi lo nghĩ |
| Mai→Lâm | gắn bó; dè dặt ước lượng chi | H01-ROOF | Lâm chưa biết đầy đủ dự toán của Mai |
| H01→An | biết ơn + nghĩa vụ C01 | MED-DEBT | An biết nghĩa vụ; không đọc cảm xúc chính xác |
| An→Liên | trách nhiệm dạy; tin kỹ năng hẹp | N04-APPRENTICE | Liên biết phạm vi được giao |
| Liên→An | kính trọng + lo bị đánh giá | N04-APPRENTICE | An quan sát sự dè dặt, không biết lỗi nhãn đã sửa |
| Bình→Hòa | tin thanh toán; bất mãn bảo trì | MARKET-PACT, CART-WEAR | Hòa biết đề nghị kiểm xe, không biết mức lo đầy đủ |
| Hòa→Bình | tin giao hàng; cho là quá thận trọng | MARKET-PACT | Bình nhận ra thái độ qua quyết định trì hoãn |
| Bình↔Dũng | tin cậy tuyến/hộ tống | MARKET-PACT | Hai bên biết qua lịch sử chung |
| Mộc→Thu | trách nhiệm dạy; tin thao tác phần | lịch học việc | Thu biết quyền hiện tại |
| Thu→Mộc | kính trọng + nôn nóng | lịch học việc | Mộc biết Thu muốn thêm việc, chưa biết ý định sửa bình |
| Sơn↔Cúc | gắn bó; tin nghề khác miền | FIELD-REFORM | Cùng biết qua hợp tác lâu dài |
| Sơn→Nga | tin kho; khó chịu thủ tục nhẹ | FIELD-REFORM | Nga biết các lần thúc lấy nhanh |
| Nga→Sơn | tin ruộng; giữ ranh quyền kho | FIELD-REFORM | Sơn biết qua quy trình |
| H02→Đạt | tin lao động theo bằng chứng | hợp đồng thành viên | Đạt biết quyền/nghĩa vụ, không biết mọi đánh giá |
| Đạt→Huệ | bạn trao đổi tin việc | HIST:WORK-NOTES | Huệ biết phạm vi chuyện đã trao đổi |
| Vân→Yến | tin kho; chấp nhận phản biện | O03-INCIDENT | Yến biết quyền báo dừng |
| Yến→Vân | tin dạy; lo thiếu người duyệt thay | O03-INCIDENT | Vân chưa nhận đề nghị chính thức |
| Kha→Tùng | cạnh tranh nhẹ + tôn trọng năng lực | học chung O03 | Tùng nhận biết cạnh tranh qua hành vi |
| Tùng→Kha | xem là quá dè dặt | học chung O03 | Kha không biết toàn bộ đánh giá |
| Tâm→Mộc | tin sửa dụng cụ | BRIDGE-TOOLS | Mộc biết qua việc cũ |
| Tâm→Dũng | tin hộ tống | BRIDGE-TOOLS | Dũng biết qua việc cũ |
| Phúc→Huệ | gắn bó; trách nhiệm; lo mất người | quan hệ họ hàng/O05 | Huệ biết sự bảo hộ, chưa biết nỗi lo đi xa |
| Huệ→Phúc | biết ơn + muốn tự chủ hơn | quan hệ họ hàng/O05 | Phúc thấy Huệ hỏi việc, chưa biết kế hoạch |
| An↔Vân | tôn trọng chuyên môn; bất đồng phân bổ nguồn | các lần trao đổi nghề | Biết có bất đồng, không mặc định thù địch |

## 25. Ai biết thông tin riêng tư nào

| Mã kín | Nội dung | Người biết ngày 1 | Không được tự biết |
|---|---|---|---|
| SEC01 | Khoảnh cây lạ chưa xác định | Lâm | Mai, An, P00 và toàn bộ người khác |
| SEC02 | Dự toán mái cao hơn | Mai | Lâm chỉ biết mục tiêu sửa, chưa biết ước lượng mới |
| SEC03 | Ý định gia hạn C01 có điều kiện | An | H01 chưa có quyền dựa vào ý định này |
| SEC04 | Lỗi nhãn Liên đã tự sửa | Liên | An và bệnh nhân; không có vật sai còn tồn tại |
| SEC05 | Mức lo của Bình về bánh V23 | Bình; Hòa chỉ biết yêu cầu kiểm | Mộc chưa biết lần quan sát mới |
| SEC06 | Ngưỡng vốn mục tiêu riêng | Hòa | Bình/Dũng/P00 |
| SEC07 | Ý định giảm việc nặng dài hạn | Mộc | Thu và khách |
| SEC08 | Thu muốn hỏi học sửa bình | Thu | Mộc/Liên |
| SEC09 | Lo dự trữ của Cúc | Cúc; Sơn biết cô thận trọng chung | Hòa/Nga không biết mức lo mới |
| SEC10 | Đạt sợ bị coi thiếu trung thành | Đạt | H02/Huệ |
| SEC11 | Ghi chú cũ làm Nga nghi lệch kho | Nga | Kho thực vẫn khớp; không ai khác tự biết nghi ngờ |
| SEC12 | Tự trách của Vân về sự cố cũ | Vân | Yến biết sự kiện, không biết mức tự trách |
| SEC13 | Nỗi lo tụt sau Tùng | Kha | Tùng/Vân |
| SEC14 | Nỗi sợ bị gắn với sự cố | Tùng | Vân/Kha/Yến |
| SEC15 | Ý định có người duyệt thay | Yến | Vân cho tới khi Yến đề nghị |
| SEC16 | Ưu tiên cứu người hơn ca gác | Dũng | O04/Tâm chỉ suy ra từ hành vi cũ, chưa biết điều kiện hiện tại |
| SEC17 | Tiếng rung chưa giải thích | Tâm | Mộc/O04/P00 |
| SEC18 | Phúc ngại Huệ đi xa | Phúc | Huệ |
| SEC19 | Huệ cân nhắc đi học xa | Huệ; Đạt chỉ biết muốn học thêm | Phúc và người khác |

Không có “cờ bí mật” tự rò. Tiết lộ cần nói, bị nghe, đọc hồ sơ có quyền, quan sát hành động hoặc suy luận hẹp; người nghe có thể vẫn không tin.

## 26. Mục tiêu dài hạn và điểm có thể va nhau

| Người | LongGoal | Va chạm có thể xảy ra, chưa phải sự kiện chắc chắn |
|---|---|---|
| N01 | Sửa mái, giữ nghề | trả C01 và chi sửa mái cạnh tranh quỹ |
| N02 | dự trữ hộ, nghề vải | nhận đơn ngoài có thể lấn việc hộ |
| N03 | duy trì y quán, dạy Liên | ca khẩn cạnh tranh đào tạo/thu nợ |
| N04 | được giao ca đơn giản | tự tin cạnh tranh nỗi sợ sai |
| N05 | thay bánh V23 | vốn nhập hàng cạnh tranh bảo trì |
| N06 | giữ vốn/quầy | đóng quầy/kiểm xe làm mất bán hàng |
| N07 | truyền nghề, giảm việc nặng | chất lượng hiện tại cạnh tranh tốc độ dạy |
| N08 | độc lập thao tác | muốn mở rộng trước khi được xác nhận |
| N09 | thu đúng vụ | thuê ngoài cạnh tranh lao động hộ |
| N10 | giữ giống/dự phòng | bán buôn cạnh tranh an toàn mùa sau |
| N11 | kiếm công và học | giờ học cạnh tranh mùa bận |
| N12 | kho không sai | tốc độ phục vụ cạnh tranh kiểm soát |
| N13 | dạy ổn định | số học viên cạnh tranh nguồn/thời gian |
| N14 | ổn định Tĩnh Lưu | so sánh Tùng có thể tăng rủi ro |
| N15 | thử Liệt Mạch hợp lệ | mong tiến nhanh cạnh tranh chính sách |
| N16 | bảo toàn/ghi nguồn | nghiên cứu cần linh hoạt cạnh tranh thủ tục |
| N17 | lịch có dự phòng | đơn khẩn cạnh tranh ca gác |
| N18 | giảm khoảng trống cầu | nước/nghỉ cạnh tranh hiện diện |
| N19 | giữ kho/phòng | mong giữ Huệ cạnh tranh tự chủ của Huệ |
| N20 | học chăm cây/đưa tin | đi học xa cạnh tranh nghĩa vụ O05 |

Hệ thống chỉ biến một va chạm thành DecisionFrame khi có Trigger và chủ thể biết đủ. Bảng không được dùng như lịch biến cố tương lai.

## 27. Điều kiện kiểm thử HS01–HS20

Các điều kiện sau **chưa chạy**:

1. HS01 — Mọi kỹ năng/tuyến/quyền quan trọng của N01–N20 có HIST/Role nguồn.
2. HS02 — Hồ sơ không thêm tiền, vật, thương tích hoặc công pháp ngoài INIT-A.
3. HS03 — Quan hệ gia đình/học việc không tự gộp tài sản cá nhân/tổ chức.
4. HS04 — C01 cùng trỏ HIST:MED-DEBT nhưng chỉ có một nghĩa vụ khách quan.
5. HS05 — N01 kể SEC01 mới tạo Message; người khác không biết cây lạ trước đó.
6. HS06 — Ý định gia hạn của An không tự đổi hạn C01 hay thành quyền H01.
7. HS07 — Lỗi nhãn cũ của Liên không tạo vật sai nhãn ngày 1.
8. HS08 — Lo bánh xe của Bình là Belief; V23 vẫn dùng theo tình trạng vật thật.
9. HS09 — N17 chỉ kéo V23 trong X02 nếu hồ sơ kỹ năng overlay tồn tại.
10. HS10 — N11 cạnh tranh P00 không tự tạo thù địch hoặc thiên vị người chơi.
11. HS11 — N12 nghi lệch cũ không sửa kho 120 V02 đang kiểm kê khớp.
12. HS12 — Kha/Tùng biết bản tóm lược sự cố, không tự biết toàn bộ ký ức Vân/Yến.
13. HS13 — SEC12/13/14 không tự biến thành hành động liều lĩnh nếu thiếu Trigger.
14. HS14 — Tiếng rung SEC17 không phải cầu hỏng FX-C và không tự đóng D08–D07.
15. HS15 — Phúc không thể dùng lo riêng như Contract cấm Huệ rời O05.
16. HS16 — Huệ truyền tin giữ ranh giữa điều thấy, điều nghe và suy đoán.
17. HS17 — Quan hệ A→B/B→A giữ riêng qua lưu/tải và sự kiện mới.
18. HS18 — Tiết lộ một bí mật chỉ cập nhật người thật sự nhận thông tin.
19. HS19 — Mục tiêu dài hạn không chạy như lịch sự kiện khi thiếu Trigger/nguồn.
20. HS20 — Tương lai khác nhau vẫn giữ lịch sử đầu kỳ bất biến và cùng id N01–N20.

## 28. Việc kế tiếp

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
