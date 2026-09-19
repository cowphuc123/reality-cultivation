---
title: Lộ trình phiên bản và điều kiện kết thúc
aliases:
  - Version roadmap
  - Điều kiện kết thúc phiên bản
tags:
  - lo-trinh
  - phien-ban
  - k5
---

# Lộ trình phiên bản và điều kiện kết thúc

Cập nhật: 2026-09-18.

## Quy tắc đánh số

- `V0`, `V1`, `V2`... là **chặng chức năng lớn** đã được lập trong K4. Mỗi chặng có mục đích và cổng kết thúc riêng.
- `Vx.y` là bước triển khai nhỏ nằm trong đúng mục đích của `Vx`. Không dùng số phụ để kéo dài một chặng sang hệ khác.
- Hậu tố `dev` ghi phần nền đã viết sớm nhưng chưa đủ cổng của phiên bản lớn. Nó không có nghĩa phiên bản đã hoàn thành.
- Tính năng làm sớm được giữ lại và phân loại về chặng sở hữu nó; không xóa chỉ vì trước đây đặt sai số.
- Một phiên bản lớn chỉ được tuyên bố hoàn thành khi mọi cổng bắt buộc có bằng chứng chạy. Số lượng tính năng không thay thế cổng kết thúc.
- Kiểm chứng phát hành, commit/push `master` và triển khai web chỉ thực hiện khi người dùng yêu cầu. Kiểm tra cú pháp hẹp được phép để tiếp tục viết mã.

## Trạng thái các phiên bản lớn

| Phiên bản | Mục đích | Cổng kết thúc tối thiểu | Trạng thái |
| --- | --- | --- | --- |
| V0 | Lõi mô phỏng | đồng hồ, lệnh, sự kiện, fact, save/load và tái hiện xác định | Đã hoàn thành |
| V1 | Một tháng sơ sinh | sinh, cơ thể sơ sinh, ngủ/đói/khóc, người chăm, bú/chăm và tăng trưởng 30 ngày | Đã hoàn thành |
| V2 | Một hộ sống | hộ 3–5 người; kho hữu hạn; vật, quyền, lịch, bệnh nhẹ; chạy một tháng; nguồn và chỗ tiêu tài nguyên có dấu vết | Đã hoàn thành về chức năng tại V2.3; V2.4–V2.13 là phần làm sâu/hardening lịch sử |
| V3 | Làng nhỏ tự vận hành | 20–50 NPC chi tiết thuộc nhiều hộ; nghề và trao đổi; thông tin truyền giữa người; quan hệ xuyên hộ; cộng đồng tự duy trì 30 ngày; save/replay xác định | Đã hoàn thành; xem [[K5_29_V3_LANG_NHO_TU_VAN_HANH_30_NGAY]] |
| V4 | Tuổi thơ | lớn lên nhiều năm không time-skip bắt buộc; vận động, ngôn ngữ, học, chơi, gắn bó, nguy hiểm và nén ký ức | Đã hoàn thành; hash `afefc3dd5537605a`, xem [[K5_30_V4_V5_V6_DONG_CONG_PHAT_HANH]] |
| V5 | Worldgen nhỏ | sinh địa lý vĩ mô, một vùng, tài nguyên, sinh thái, khu dân cư và 300 năm lịch sử; chọn nơi sinh; cùng seed tái hiện được | Đã hoàn thành; 741 năm, hash `4e03e202361d0363` |
| V6 | Sinh kế | sản xuất, chế tác, dịch vụ, lao động, chợ địa phương, vận chuyển và cú sốc thiếu hàng; ledger bảo toàn | Đã hoàn thành; runner 30 ngày hash `b8fea49e313fe8ab` |
| V7 | Tu luyện | nguồn tri thức, ít nhất ba công pháp khác cơ chế, luyện tập đổi cơ thể/tài nguyên và một lần đột phá có hậu quả | Chưa bắt đầu |
| V8 | Xung đột | nhận thức, quyết định, di chuyển, tiếp xúc, vật/cơ thể bị thương, rút lui, cứu hộ và chứng cứ | Chưa bắt đầu |
| V9 | Tổ chức | vai trò, quyền lực, tông môn nhỏ, kho, lớp học, đề xuất, quyết định và tranh chấp | Chưa bắt đầu |
| V10 | Lịch sử dài | epoch 3.000–10.000 năm, anchor, nén lịch sử, dòng truyền tổ chức/công pháp và kiểm tra snapshot trên thiết bị | Có phần tiền sử vĩ mô viết sớm, chưa đạt đủ cổng |
| V11 | Vòng chơi alpha | tạo thế giới → chọn nơi → sinh → lớn → học nghề/tu luyện → khủng hoảng → hậu quả → save/load | Chưa bắt đầu |
| V12 | Đồng nhất đa nền tảng | cùng fixture/save/lệnh cho cùng semantic hash trên Android và Windows, kể cả suspend/resume | Chưa bắt đầu |

Các con số 20–50 NPC và thời gian 30 ngày là cổng kỹ thuật từ kế hoạch K4, không phải giới hạn quy mô cuối của trò chơi.

## Phân loại lại phần mã từng mang số V2

| Mã đã viết | Thuộc chặng đúng | Cách ghi từ nay |
| --- | --- | --- |
| V2.0–V2.3 | V2 một hộ sống | Giữ nguyên lịch sử; V2 đóng tại đây |
| V2.4–V2.13 | Làm sâu V2 | Giữ nguyên tên lịch sử, không dùng để kéo dài V2 nữa |
| V2.14–V2.21 | Nền bản đồ, worldgen, tiền sử và hộ sinh | Ghi là nền viết sớm cho V3/V5/V10; không tuyên bố các chặng đó hoàn thành |
| Mã cục bộ từng gọi V2.22–V2.30 | Ký ức, thương lượng, hỗ trợ, mâu thuẫn, lời hứa và danh tiếng gia đình | `V3.0-dev.1` đến `V3.0-dev.9` — nền xã hội trong hộ cho V3 |
| Mã cục bộ từng gọi V2.31 | Trẻ học kỳ vọng với từng người chăm | `V4.0-dev.1` — nền gắn bó làm sớm cho V4 |

Việc đổi nhãn không chứng nhận phần mã cục bộ. Toàn bộ nhóm này vẫn chưa có runner/catalog/tài liệu lát cắt và chưa được kiểm chứng phát hành.

## Chặng vừa hoàn thành: V3 — làng nhỏ

### Bằng chứng đóng cổng

- Seed `20260907` sinh 50 NPC chi tiết thuộc 12 hộ; mỗi người có cơ thể, nghề, kỹ năng, lịch và trạng thái cá nhân.
- Chu kỳ 30 ngày hoàn tất 291 cuộc đổi hàng, tạo 2.333 bằng chứng cá nhân và 172 quan hệ có hướng xuyên hộ; không có ngày cần cứu hộ vô căn cứ.
- Sau hai ngày lắng không còn hàng, yêu cầu hay cam kết thời gian mắc kẹt; không kho nào âm.
- Chạy liền, save/load ở ngày 15 và replay đều cho hash `8b27413973a433d7`.
- GUI V3 đạt widget test ở 390×844 và 1280×800; toàn bộ bằng chứng nằm trong [[K5_29_V3_LANG_NHO_TU_VAN_HANH_30_NGAY]].

### Bảy cổng đã đạt

1. Sinh 20–50 `PersonState` chi tiết thay vì chỉ giữ phần lớn dân số dưới dạng cohort.
2. Sinh nhiều hộ có thành viên, nơi ở, nghề, kho, nhu cầu và nguồn sống khác nhau.
3. Cho lao động, hàng hóa hoặc dịch vụ đi thật giữa các hộ và giữ bảo toàn vật chất.
4. Cho tin nhắn/tri thức truyền qua người; NPC không được biết việc chưa nghe hoặc chưa thấy.
5. Tạo và thay đổi quan hệ giữa người ở các hộ khác nhau.
6. Chạy cộng đồng 30 ngày trong điều kiện bình thường mà không cần script cứu hộ vô căn cứ.
7. Save/load và replay cho cùng kết quả; giao diện điện thoại/máy tính xem được làng, hộ, người, luồng hàng và quan hệ.

### Kết quả triển khai

- Cổng 1–2: runner xác nhận 50 người chi tiết trong 12 hộ có nghề, lịch, nơi ở và kho.
- Cổng 3: đổi hàng hai chiều giữ hàng trong vận chuyển; 291 lượt hoàn tất và không có kho âm hoặc chuyến mắc kẹt.
- Cổng 4: mức tối thiểu của V3 đã có — NPC giữ bằng chứng riêng từ quan sát/lời kể, người ngoài không tự biết và quyết định tìm nguồn dùng kho tri thức cá nhân. Việc nối mọi sự kiện tương lai vào nhận thức là mở rộng, không chặn V3.
- Cổng 5: mức tối thiểu của V3 đã có — quan hệ có hướng sinh từ gặp thật, đổi theo giao dịch/truyền tin/từ chối và ảnh hưởng quyết định sau. Danh tiếng gián tiếp là mở rộng, không chặn V3.
- Cổng 6: đủ 30 ảnh chụp, 0 ngày cứu hộ vô căn cứ; vòng đời yêu cầu và chi phí lịch đều lắng hết ở ngày 32.
- Cổng 7: ba đường chạy cho cùng hash; hai bố cục GUI đều đạt kiểm tra tự động.

### Danh sách hữu hạn để đóng V3

1. Dựng **một runner V3 30 ngày** từ seed cố định, dùng đúng luồng tạo thế giới hiện có.
2. Runner phải chứng minh: có 20–50 NPC chi tiết và nhiều hộ; có trao đổi hoàn tất; không có hàng âm, chuyến quá hạn hoặc yêu cầu/cam kết mắc kẹt; tri thức có nguồn; quan hệ ngoài hộ chỉ xuất hiện sau tiếp xúc; đủ 30 ảnh chụp cộng đồng.
3. Chạy cùng lệnh theo ba đường: chạy liền, save-load giữa kỳ và replay cùng seed; trạng thái cuối phải có cùng semantic hash.
4. Kiểm tra GUI ở kích thước điện thoại và máy tính xem được làng, hộ, người, hàng đang đi, yêu cầu, tri thức và quan hệ.
5. Chỉ sửa những lỗi làm một trong bốn mục trên thất bại. Không thêm hệ thống mới trong lúc đóng cổng.
6. Khi người dùng yêu cầu phát hành: chạy toàn bộ runner/widget/catalog/web build, hoàn thiện hồ sơ lát cắt, commit/push và triển khai web.

Sau khi 1–5 đạt, V3 đủ điều kiện đóng về chức năng. Mục 6 là thủ tục phát hành theo U019, không phải lý do phát sinh thêm tính năng.

### Backlog không chặn V3

- Danh tiếng gián tiếp từ lời kể về giúp đỡ hoặc từ chối.
- Thêm loại quan hệ, hội thoại, tâm lý, nghề, hàng hóa hoặc biến cố xã hội.
- Mở rộng lớp nhận thức sang mọi loại sự kiện trong toàn bộ game.

## Chặng đã hoàn thành: V4 — tuổi thơ

V4 kết thúc bằng một đường chơi liên tục từ sơ sinh qua nhiều năm tuổi thơ. Các ngưỡng tuổi và tốc độ học trong fixture là tham số kỹ thuật để kiểm chứng, không phải giới hạn thiết kế cuối của trò chơi.

### Danh sách hữu hạn để đóng V4

1. Thời gian chạy liên tục từ lúc sinh qua ít nhất sáu năm trong game, không có lệnh nhảy tuổi bắt buộc; mỗi ngày vẫn đi qua hàng đợi mô phỏng.
2. Trạng thái phát triển thật mở và cải thiện năng lực từ tuổi, tình trạng cơ thể, cơ hội cùng hoạt động đã diễn ra; số tuổi một mình không tự cấp mọi kỹ năng.
3. Có chuỗi hoạt động chạy được cho bốn trục: vận động, ngôn ngữ, học qua quan sát/thực hành và chơi. Mỗi hoạt động cần điều kiện, tốn thời gian và để lại thay đổi trạng thái hoặc ký ức.
4. Kinh nghiệm chăm sóc với từng người từ `V4.0-dev.1` tiếp tục ảnh hưởng cảm giác an toàn, lựa chọn tiếp cận và phản ứng của trẻ sau tháng sơ sinh.
5. Có ít nhất một nguy hiểm tuổi thơ đi qua nhận biết → phản ứng của trẻ/người chăm → hậu quả cơ thể hoặc tâm lý; kết quả phụ thuộc năng lực và hoàn cảnh thật.
6. Ký ức ngày thường được nén theo quy tắc hữu hạn khi chạy nhiều năm, nhưng sự kiện quan trọng, nguồn gốc và ảnh hưởng còn hoạt động vẫn truy ra được.
7. Save/load và replay từ cùng seed, cùng lệnh cho cùng trạng thái cuối; GUI điện thoại và máy tính cho xem giai đoạn, năng lực, hoạt động, gắn bó, nguy hiểm và ký ức đã nén.
8. Khi người dùng yêu cầu phát hành: chạy runner nhiều năm, save/load/replay, widget test hai kích thước, catalog và web build; chỉ sửa lỗi làm các cổng trên thất bại rồi mới commit/push và triển khai.

### Thứ tự triển khai đã khóa để tránh lan phạm vi

1. Chuyển liên tục khỏi tháng sơ sinh và tạo trạng thái phát triển lưu được.
2. Vận động và chơi.
3. Ngôn ngữ và học qua người/vật thật.
4. Gắn bó sau sơ sinh và nguy hiểm tuổi thơ.
5. Nén ký ức nhiều năm.
6. Runner đóng cổng, GUI và thủ tục phát hành khi được yêu cầu.

Đóng cổng ngày 2026-09-19: runner sáu năm, save/load năm thứ ba và replay cùng đạt hash `afefc3dd5537605a`; 91 ký ức được nén trong giới hạn hữu hạn và mốc nguy hiểm vẫn giữ nguồn. Hai widget test điện thoại/máy tính đạt. Xem [[K5_30_V4_V5_V6_DONG_CONG_PHAT_HANH]].

Mọi công pháp, tu luyện, kinh tế mới, chiến đấu, tổ chức hoặc mở rộng worldgen đều thuộc phiên bản sau và không được thêm để kéo dài V4.

Các mục này chỉ được lấy ra khi một phiên bản tương lai thật sự cần hoặc người dùng yêu cầu trực tiếp.

## Chặng đã hoàn thành: V5 — worldgen nhỏ

V5 tạo một thung lũng có địa hình, nguồn lực, sinh thái, khu dân cư và lịch sử đủ để trạng thái lúc nhập thế là hậu quả của cùng seed. V4 vẫn chờ kiểm chứng riêng; sơ đồ phụ thuộc K4 cho phép V5 đi trực tiếp từ V0 nên không dùng V5 để tuyên bố V4 đã đạt.

### Danh sách hữu hạn để đóng V5

1. Cùng seed sinh đúng một thung lũng có kích thước, đáy/vành, khí hậu, lượng mưa và các địa điểm mang địa hình/độ cao nhất quán; dữ liệu đi qua save/load và provenance.
2. Có nguồn nước, đất canh tác, gỗ và khoáng vật với lượng, chất lượng, khả năng tiếp cận và nguồn sinh rõ ràng; khai thác không được tạo vật chất ngoài ledger.
3. Có lớp sinh thái tối thiểu cho thực vật và động vật: quần thể chịu sức chứa/tài nguyên, thay đổi theo thời gian và có thể suy giảm thay vì tự hồi đầy vô điều kiện.
4. Ít nhất một khu dân cư và các nơi sinh khả thi được đặt từ địa hình, nguồn lực và lịch sử; không chỉ dùng tên/vị trí template mà bỏ qua trạng thái đã sinh.
5. Chạy ít nhất 300 năm tiền sử trước P00, giữ bản tóm tắt dài hạn cùng cửa sổ sự kiện gần; biến cố để lại hậu quả lên nguồn lực, sinh thái hoặc khu dân cư trong snapshot nhập thế.
6. Người chơi xem được khác biệt hoàn cảnh rồi chọn nơi sinh; cùng seed/cấu hình/lệnh cho cùng bản đồ và trạng thái cuối qua chạy liền, save/load và replay.
7. GUI điện thoại và máy tính xem được địa hình, nguồn lực, sinh thái, khu dân cư, lịch sử và lý do một nơi đủ/không đủ điều kiện sinh.
8. Khi người dùng yêu cầu phát hành: chạy runner worldgen/lịch sử, parity, widget test hai kích thước, catalog và web build; chỉ sửa lỗi cổng rồi mới commit/push và triển khai.

### Thứ tự triển khai đã khóa

1. Địa hình, độ cao, khí hậu và lượng mưa của thung lũng.
2. Nguồn tài nguyên hữu hạn có chất lượng và khả năng tiếp cận.
3. Quần thể sinh thái cùng biến đổi tài nguyên.
4. Khu dân cư/nơi sinh phụ thuộc địa hình và nguồn lực.
5. Lịch sử 300 năm, nén lịch sử và hậu quả lên snapshot.
6. Runner, GUI và thủ tục phát hành khi được yêu cầu.

Đóng cổng ngày 2026-09-19: seed mặc định chạy 741 năm qua ba epoch, 192 bước, sáu mốc neo và bốn mốc gần. Chạy liền, save/load trước khi hoàn tất tiền sử và replay cùng đạt hash `4e03e202361d0363`; giao diện nhập thế điện thoại/máy tính đạt. Xem [[K5_30_V4_V5_V6_DONG_CONG_PHAT_HANH]].

## Chặng đã hoàn thành: V6 — sinh kế

V6 chứng minh một nền kinh tế địa phương hữu hạn bằng dòng vật, công và nghĩa vụ thật. V6 không chốt tiền tệ, tín dụng, thuế, luật hay tổ chức; các hệ đó thuộc quyết định hoặc chặng sau.

### Danh sách hữu hạn để đóng V6

1. Một mẻ sản xuất/chế tác phải rút đúng nguyên liệu vào workpiece, giữ thời gian người làm, cần công cụ/nơi phù hợp và chỉ tạo đầu ra khi process hoàn tất; chất lượng cùng hao mòn có nguồn.
2. Ít nhất một dịch vụ giữ lịch của người cung cấp và người nhận, tiêu đầu vào nếu có, tạo kết quả/claim có thể kiểm tra và không overbook.
3. Lao động có lời mời, điều kiện, chấp nhận hoặc từ chối và nghĩa vụ trả công/quyền lợi sau khi công thật đã làm; thiếu thanh toán không xóa công.
4. Chợ địa phương chỉ đăng lượng hàng có thật; đặt hàng phải reserve trước khi settlement, không bán hoặc tiêu cùng một lượng hai lần, và NPC chỉ dùng offer họ có thể biết/tiếp cận.
5. Hàng giao dịch đi trên tuyến thật và nằm trong trạng thái in-transit; chậm/hỏng/thiếu đầu vào phải làm production hoặc giao hàng đổi kết quả thay vì được bù ẩn.
6. Một cú sốc thiếu hàng kéo dài buộc ít nhất hai hộ đổi sản xuất, dịch vụ, trao đổi hoặc tiêu dùng; không kho âm, không cửa hàng vô hạn và không nguồn cứu vô căn cứ.
7. Kịch bản đại diện chạy ít nhất 30 ngày với nhiều sinh kế, đối chiếu nguồn–process–đích của vật/công; chạy liền, save/load và replay hội tụ cùng snapshot.
8. GUI điện thoại và máy tính xem được mẻ đang làm, nguyên liệu/workpiece, công cụ, lao động, offer/order, hàng đang đi, nghĩa vụ và nguyên nhân thiếu hụt.
9. Khi người dùng yêu cầu phát hành: chạy runner V6, parity, widget test hai kích thước, catalog và web build; chỉ sửa lỗi cổng rồi mới commit/push và triển khai.

### Thứ tự triển khai đã khóa

1. Workpiece sản xuất: nguyên liệu, công cụ, thời gian, chất lượng và đầu ra.
2. Dịch vụ cùng lịch người cung cấp/người nhận.
3. Lời mời lao động, nghĩa vụ và claim trả công.
4. Offer/order/reservation/settlement tại chợ địa phương.
5. Vận tải nối thị trường và cú sốc thiếu hàng nhiều hộ.
6. Runner 30 ngày, GUI và thủ tục phát hành khi được yêu cầu.

Đóng cổng ngày 2026-09-19: sáu runner hệ riêng và runner tổng hợp hai hộ/30 ngày đều đạt. Ledger nguồn–process–đích bảo toàn, không quy trình mắc kẹt hoặc kho âm; chạy liền, save/load ngày 15 và replay cùng đạt hash `b8fea49e313fe8ab`. GUI cùng thủ tục catalog/web đạt. Xem [[K5_30_V4_V5_V6_DONG_CONG_PHAT_HANH]].

## Kỷ luật thay đổi phạm vi

Nếu một bước đề xuất không phục vụ trực tiếp cổng của phiên bản đang làm, ghi nó vào backlog của phiên bản đúng. Chỉ đổi mục đích hoặc cổng kết thúc khi người dùng xác nhận và cập nhật [[DECISIONS]].

## Liên kết

- [[MASTER_PLAN]]
- [[STATE]]
- [[DECISIONS]]
- [[ACTIVE_WORK]]
- [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]
