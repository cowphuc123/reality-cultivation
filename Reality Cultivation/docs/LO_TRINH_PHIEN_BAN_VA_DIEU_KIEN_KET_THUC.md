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

Cập nhật: 2026-09-10.

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
| V4 | Tuổi thơ | lớn lên nhiều năm không time-skip bắt buộc; vận động, ngôn ngữ, học, chơi, gắn bó, nguy hiểm và nén ký ức | Có một phần nền viết sớm, chưa bắt đầu chính thức |
| V5 | Worldgen nhỏ | sinh địa lý vĩ mô, một vùng, tài nguyên, sinh thái, khu dân cư và 300 năm lịch sử; chọn nơi sinh; cùng seed tái hiện được | Có nhiều phần nền viết sớm, chưa đạt đủ cổng |
| V6 | Sinh kế | sản xuất, chế tác, dịch vụ, lao động, chợ địa phương, vận chuyển và cú sốc thiếu hàng; ledger bảo toàn | Chưa bắt đầu chính thức |
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

Các mục này chỉ được lấy ra khi một phiên bản tương lai thật sự cần hoặc người dùng yêu cầu trực tiếp.

## Kỷ luật thay đổi phạm vi

Nếu một bước đề xuất không phục vụ trực tiếp cổng của phiên bản đang làm, ghi nó vào backlog của phiên bản đúng. Chỉ đổi mục đích hoặc cổng kết thúc khi người dùng xác nhận và cập nhật [[DECISIONS]].

## Liên kết

- [[MASTER_PLAN]]
- [[STATE]]
- [[DECISIONS]]
- [[ACTIVE_WORK]]
- [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]
