---
aliases: [Dữ liệu liên kết K0, Tiền vật chất và fixture A C]
tags: [thiet-ke, du-lieu, fixture, k0]
status: de-xuat
updated: 2026-09-05
---

# Dữ liệu liên kết K0.2–K0.5 — tiền, tìm việc, tiếp tế và tin cầu

Liên quan: [[LUOC_DO_TRANG_THAI]] · [[DU_LIEU_KHOI_DAU]] · [[SINH_KE]] · [[VAT_THE_THU]] · [[CONG_VIEC_THU]] · [[KIEM_TOAN_TICH_HOP]].

> Đây là dữ liệu fixture đề xuất để khép các mắt xích K0.2–K0.5 trên giấy. Các mốc, phân công và hợp đồng chưa phải cân bằng cuối, chưa được người dùng duyệt và chưa chạy bằng game.

## 1. Phạm vi và quy ước

Gói này không tạo thêm nguồn thức ăn, nước hoặc tiền. Nó đặt 2.000 V01 vào vị trí vật lý, chỉ rõ cách P00 tìm được việc đầu, gắn lịch cho các chuyển hàng DL01 và viết hai biến thể chuỗi C. Thời điểm ghi đến mili giây khi cần. “Giao xong” chỉ xảy ra sau khi người nhận kiểm đếm và giao dịch nguyên tử đổi quyền sở hữu.

## 2. K0.2 — 2.000 đồng tồn tại ở đâu

Thêm **V33 — hộp tiền gỗ có nắp**: vỏ 800 g, ngoài 30 × 20 × 15 cm, lòng 28 × 18 × 12 cm; chứa tối đa 1.000 V01 hoặc 5.000 g tiền. Hộp không có khóa trong fixture, nhưng mở/lấy vẫn cần hiện diện và quyền. V33 là vật chứa, không phải tài khoản.

| Chủ/quỹ | V01 | Vật chứa và vị trí ngày 1, 06:00 | Quyền mở/chi |
| --- | ---: | --- | --- |
| P00 | 40 | 20 đồng trong mỗi túi áo V20; V32 ở túi trái | P00 |
| H01 | 160 | V33-H01 tại kho hộ D02 | N01 hoặc N02 |
| H02 | 240 | V33-H02 tại kho ruộng D05 | N12 trong kế hoạch |
| O01 | 300 | V33-O01 tại D03 | N03 |
| O02 | 180 | V33-O02 tại D04 | N07 |
| O03 | 400 | V33-O03 tại D09 | N16 đến 20 đồng; lớn hơn cần N13 |
| O04 | 400 | V33-O04 tại quầy D01 | N06 |
| O05 | 200 | V33-O05 tại bếp D02 | N19 |
| O06 | 80 | V33-O06 tại phòng trực D08 | N18 đến 20 đồng |

Túi trái P00 chứa 150 g gồm tiền và V32; túi phải chứa 100 g, đều dưới trần 250 g. Mức O04 dự kiến 550 đồng cuối nhánh DL01 vẫn vừa V33.

“Số dư” là tổng hợp từ V01 đang thuộc quyền tài khoản, kể cả tiền được người có ủy quyền giữ hoặc đã giữ chỗ. Nó không phải bản tiền thứ hai. Khi N05 mang tiền, vị trí đổi ngay nhưng chủ chỉ đổi lúc thanh toán. Mỗi thanh toán cùng lúc kiểm tra quyền, chuyển đúng V01, đổi chủ/người giữ, cập nhật nghĩa vụ và ghi một `Transaction`. Hủy giữa đường không dịch chuyển tiền tức thời về hộp.

## 3. K0.3 — FX-A-BOOT

P00 bắt đầu INIT-A, chỉ biết D01/D02, đường nối và cách hỏi việc.

| Thời điểm | Diễn biến | Thay đổi |
| --- | --- | --- |
| 06:00–06:30 | Ăn 250 g, uống 500 ml, chuẩn bị tại D02 | Không cấp tri thức mới |
| 06:30–06:35 | Hỏi N01, người đã về D02 sau chuyến lấy nước lúc 06:25:32.500 | Biết N20 thường ở D01; biết có bờ suối công cộng |
| 06:35–06:39:10 | Đi D02→D01, 200 m ở 0,8 m/s | Vị trí đổi liên tục |
| 06:39:10–06:44:10 | Hỏi N20 | Biết tuyến D01→D11; biết D05 và N12 có thể xác nhận việc, chưa chắc được nhận |
| 06:44:10–06:49:22.500 | Đi D01→D11 | Học tuyến bằng hành trình thật |
| 06:49:22.500–06:50:12.500 | Bổ sung 500 ml: rót 30 giây, mở/đóng 20 giây | V12 thành 2.000 ml; D11 giảm 500 ml |
| 06:50:12.500–06:55:25 | Trở lại D01 | Không tạo thêm nước |
| 06:55:25–07:12:05 | Đi D01→D05 | Học tuyến bằng hành trình thật |
| 07:12:05–07:17:05 | N12 nghe đề nghị và kiểm tra lô 1 | Xác nhận J01 còn mở |
| 07:17:05–07:37:05 | Chỉ dẫn và thử khô có giám sát | Chứng cứ kỹ năng hẹp cho J01, không thành thạo nghề ruộng |
| 07:37:05–07:42:05 | Chấp nhận hợp đồng | Giữ lô 1, một V22 và 8 V01; cấp quyền làm/nhận cuốc |
| 07:42:05–08:00 | Nhận cuốc, đi nội bộ, chuẩn bị | FX-A-DAY bắt đầu lúc 08:00 |

Trong overlay này N11 đã nhận việc bảo dưỡng rãnh 08:00–12:00 trước 06:00, nên không ứng tuyển J01. Đây là dữ kiện fixture công khai, không phải ưu tiên ẩn; CV01 vẫn kiểm tra cạnh tranh ở overlay khác.

Hợp đồng `C-A-J01-01`: H02/N12 giao P00 lô 1, cần 30 V02 trước 16:30 ngày 1, công 8 V01 khi nghiệm thu. Khối lượng P00 sau bữa và bổ sung nước là 7.000 g; cầm V22 thành 9.000 g và chiếm tay.

Mốc cuối A-DAY: 16:00–16:05 cất cuốc; 16:05–16:10 uống 500 ml; 16:10–16:15 chuyển nội bộ; 16:15–16:25 bốc/chia; 16:25–16:30 N12 nghiệm thu. Lúc 16:30, 8 V01 giữ chỗ chuyển từ V33-H02 sang P00.

## 4. K0.4 — lịch tiếp tế có người và phương tiện

### 4.1 H02 bán O04

Ngày 4/9/14/19 chở 30 V02; ngày 24 chở 10. N05 dùng V23; chuyến 30 dùng hai V13 + 2 m V25, chuyến 10 dùng một V13 + 1 m dây. N06 giao N05 giữ đúng 30 hoặc 10 V01 từ V33-O04.

Mỗi chuyến: rời D01 06:30; tới D05 bằng xe rỗng 06:46:40; kiểm tiền, đổi chủ và chất hàng đến 07:01:40; về D01 với hàng 07:23:53.334; nhập kho xong 07:33:53.334. V02 và V01 đổi chủ tại D05; xe, túi và dây không bán kèm.

### 4.2 O04 giao đơn lớn

| Ngày/đơn | Mốc chính | Tiền |
| --- | --- | --- |
| 13, O01 30 suất | N05 xếp 07:30–07:40; tới D03 07:44:10; kiểm đến 07:54:10; về D01 07:57:17.500 | N03 trả 60 V01 |
| 18, H01 20 suất | Xếp 06:30–06:40; tới D02 06:45:33.334; kiểm đến 06:50:33.334; về 06:54:43.334 | N01/N02 trả 40 |
| 18, O02 20 suất | Xếp 07:05–07:15; tới D04 07:20; kiểm đến 07:25; về 07:28:45 | N07 trả 40 |
| 18, O03 20 suất | Xếp 07:40–07:50; tới D09 07:58:20; kiểm đến 08:03:20; về 08:09:35 | N13 duyệt, trả 40 |
| 23, O03 20 suất | Lịch như đơn O03 ngày 18 | N13 duyệt, trả 40 |
| 24, O05 6 suất | N05 đi bộ với V13; xếp 08:00–08:05; tới D02 08:08:20; kiểm đến 08:13:20; nộp tiền D01 08:21:40 | N19 trả 12 |

Mọi đơn chỉ hoàn tất nếu tồn kho, người và đường còn hợp lệ; fixture không kéo hàng từ kho khác để ép bảng cuối kỳ đúng.

### 4.3 O05→O06 và P00

O04 cho O05 mượn một V13 từ ngày 1 đến sau chuyến ngày 26. N20 mang 5 V02 D02→D08 ngày 1/6/11/16/21/26.

Ngày 1: rời D02 06:53:20; tới D08 07:08:20; N18 kiểm/trả 10 V01 lúc 07:13:20; về D02 07:28:20 và nộp tiền O05 07:33:20. Ngày còn lại: rời 07:00, tới 07:15, nhận tiền xong 07:20, về/nộp tiền 07:40. Riêng ngày 6, N20 ở lại cho fixture C và mang tiền về sau.

P00 mua hai V02 tại quầy N06 trong cửa sổ 17:00–17:05 các ngày chẵn 6–28. Chỉ lúc 17:05, nếu P00 có mặt, còn quyền chi và chỗ mang, 4 V01 và hai V02 mới đổi chủ. Vắng mặt là lỡ mua, không giao từ xa. Mốc này thay lịch ngày lẻ cũ vì sáu suất khởi đầu chỉ đủ hết ngày 6; lịch đầy đủ nằm tại [[LICH_21_NGUOI_K1]].

## 5. Lịch lấy 42.000 ml nước mỗi ngày

D11 có bốn vị trí lấy độc lập, mỗi vị trí 1.000 ml/phút; mở/đóng mỗi bình thêm 20 giây. Bình mượn đổi người giữ, không đổi chủ O05.

| Nhóm | Người/bình | Lịch ngày 1–30 | Lượng |
| --- | --- | --- | ---: |
| O04 | N06, N17; 3 bình | Rời D01 06:00; lấy 06:04:10–06:11:10; về 06:16:22.500 | 6.000 ml |
| O01 | N04; 2 bình | Rời D03 06:00; lấy 06:06:40–06:11:20; về 06:19:40 | 4.000 |
| O02 | N08; 2 bình mượn | Rời D04 06:00; lấy 06:07:10–06:11:50; về 06:20:47.500 | 4.000 |
| H01 | N01; 2 bình | Rời D02 06:04; lấy 06:11:30–06:16:10; về 06:25:32.500 | 4.000 |
| O05 | N19; 1 bình, hai lượt | Rời 06:00; về lượt một 06:17:20; lượt hai 06:34:40 | 4.000 |
| O06 | N18; 1 bình mượn | Rời D08 06:00; lấy 06:15:50–06:18:10; về 06:34 | 2.000 |
| O03 | N14, N15; 4 bình mượn | Rời D09 06:12; lấy 06:21:10–06:30:30; về 06:41:57.500 | 8.000 |
| H02 | N09, N10; 4 bình | Rời D05 06:15; lấy 06:32:30–06:41:50; về 07:03:42.500 | 8.000 |
| P00 | 1 bình riêng | Nhu cầu 2.000 ml/ngày; A-BOOT lấy 500 ml ngày 1, ngày 2 lấy 1.500 ml vì còn 500 ml, từ ngày 3 lấy 2.000 ml | 2.000 |

Tổng nhu cầu là 42.000 ml/ngày. Lượng lấy tại D11 ngày 1/2 lần lượt là 40.500/41.500 ml vì P00 dùng dần 2.000 ml đầu kỳ; từ ngày 3 là 42.000 ml/ngày. Nếu P00 bỏ lịch hoặc nhóm mất người/bình, lượng thật giảm và phải lập kế hoạch khác; bảng không tự sinh nước. Sổ 30 ngày nằm tại [[SO_SU_KIEN_30_NGAY_K1]].

## 6. K0.5 — FX-C-MSG/NOMSG

### 6.1 Trạng thái chung

Ngày 6, O01 mua 10 V14 của N01 giá 20 V01 và thuê O04 giao về D03 trước 09:00, phí 6 V01 khi nhận. N03 giao N05 giữ 20 V01 và một V13 tại D03 lúc 06:30. N05 đi D03→D01→D07→D08→D06, đến 06:52:30. N01 có mặt tại D06 với đúng 10 V14 qua overlay có hành trình trước đó.

Lúc 08:00, N05 trả 20 V01; 10 V14 đổi chủ sang O01 và do N05 giữ. N05 tới D08 lúc 08:08:20. Lúc 08:08:30, biến cố hỏng kết cấu làm N18 đóng D08–D07; không ai trên cầu, hàng vẫn ở D08. Đây là đầu vào tổng hợp, chưa phải mô hình hỏng cầu tự phát.

N05 biết đường vòng. Sau khi giữ hàng và đánh giá, rời D08 08:28:30 theo D08→D06→D07 đường vòng→D01→D03, tổng 3.250 m; tới 09:22:40. N03 kiểm đến 09:27:40, nhận hàng muộn và trả O04 6 V01 qua N05. Hợp đồng thành `completed_late`; fixture không tự phạt hay hủy phí.

### 6.2 Có tin

Sau chuyến thực phẩm ngày 6, N20 ở lại D08 hỗ trợ tin đường. N18 giải thích từ 08:08:30–08:13:30. N20 mang thông điệp có nguồn “N18 thấy cầu hỏng; N05 và kiện ở bờ D08, sẽ đi vòng”, chạy đường vòng 3.250 m và tới D03 09:07:40.

Lúc 09:00 N03 chỉ biết hàng quá hạn. Lúc 09:07:40 N03 biết nguyên nhân có nguồn; sự thật và vị trí hàng không đổi vì tin tới. N03 không biết giờ hàng đến chính xác nếu thông điệp không chứa dự báo ấy.

### 6.3 Không có tin

FX-C-NOMSG dùng cùng base, hạt, cầu hỏng, hành trình N05 và kết quả hàng. Overlay duy nhất bỏ hành động chuyển tin của N20; N20 ở lại D08 và không tạo `Message`. Đây là phép thử kiểm soát truyền tin, không phải hành vi tự chủ mặc định.

N03 giữ niềm tin “quá hạn, chưa rõ nguyên nhân” đến khi N05 tới 09:22:40. Hai nhánh có cùng vị trí, chủ, số lượng, hư hại cầu và giờ hàng đến; chỉ lịch tri thức và hành động dựa trên tri thức được phép khác.

## 7. Điều kiện kiểm chứng

| Mã | Điều phải đúng |
| --- | --- |
| LK01 | Đúng 2.000 V01, mỗi đồng có một vị trí |
| LK02 | Tiền N05 giữ không bị cộng thêm với tiền hộp |
| LK03 | Hủy giữa đường không dịch chuyển tiền về hộp |
| LK04 | P00 không biết D05/D11/N12 trước nguồn hợp lệ |
| LK05 | A-BOOT có nguồn tri thức, kỹ năng hẹp, hợp đồng, cuốc và tiền giữ chỗ |
| LK06 | N11 bận do overlay có hồ sơ, không bởi ưu tiên ẩn |
| LK07 | Chuyến H02→O04 đổi tiền/hàng tại D05; đồ vận chuyển quay về |
| LK08 | Ba đơn ngày 18 không đặt N05 ở hai nơi |
| LK09 | 40 đồng O03 có duyệt N13 |
| LK10 | P00 vắng giờ mua không nhận hàng/mất tiền |
| LK11 | Mỗi ngày người dân thực nhận 42.000 ml; D11 giảm 40.500/41.500 ml ngày 1/2 và 42.000 ml từ ngày 3 |
| LK12 | Mất người/bình làm giảm lượng thật |
| LK13 | Cầu hỏng không xóa, nhân bản hay đưa kiện qua cầu đóng |
| LK14 | Lúc 09:10 hai nhánh C cùng sự thật, khác tri thức N03 |
| LK15 | Hàng, 20 đồng, 6 đồng và hợp đồng C áp đúng một lần |
| LK16 | Lưu/tải giữa chuyến giữ vị trí, người giữ, tin và giao dịch |

Các LK/DS chưa chạy. K0.2–K0.5 chỉ khép kín trên giấy; K0.6 hiện đã được bổ sung tại [[CHAM_SOC_K0]].

## 8. Phần để mở

Giá, giờ và phân công là cấu hình fixture, không phải luật chung. Chưa định phí trễ mặc định, lịch mùa, mô hình hỏng cầu, hiệu năng, công nghệ lưu trữ hoặc hành vi khi ứng dụng đóng. Thay đổi sau phải tăng phiên bản thay vì âm thầm dùng kết quả cũ.
