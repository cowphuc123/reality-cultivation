---
aliases:
  - Sổ sự kiện 30 ngày K1.3
  - FX-A-30D event ledger
tags:
  - reality-cultivation
  - ke-hoach
  - fixture-k1
  - so-su-kien
status: doi-chieu-tren-giay
updated: 2026-09-06
---

# Sổ sự kiện FX-A-30D — K1.3

Tài liệu này mở rộng [[LICH_21_NGUOI_K1]] bằng các mẫu sự kiện lặp, ngoại lệ từng ngày, sổ V02, nước, V01 và dấu vết nhận thức từ [[NGUON_QUYET_DINH_K1]]. Mục tiêu là có một bản đối chiếu đủ chính xác để sau này chuyển thành fixture máy mà không phải đoán lại lịch.

Đây vẫn là phép tính và kiểm toán thủ công. “Khớp sổ” không có nghĩa game hoặc bộ mô phỏng đã chạy.

## 1. Biên của fixture

- Base: INIT-A lúc 06:00 ngày 1.
- Cửa sổ: 06:00 ngày 1 đến 22:00 ngày 30.
- Nhánh cơ sở: P00 nhận và hoàn tất tám J01; không có thương tích, hỏng đường, mất đồ, đổi giá, vắng người hoặc đối thủ giành việc.
- FX-C-MSG/NOMSG là overlay riêng của ngày 6, không đồng thời nằm trong kết quả cơ sở bên dưới.
- Mỗi ngày tiêu thụ 21 V02, 42.000 ml nước và dành cửa sổ ngủ 22:00–06:00.
- Mọi sự kiện lặp được mở rộng thành sự kiện riêng theo ngày khi tạo fixture máy; tài liệu dùng mẫu để tránh chép 30 lần cùng một nội dung.

## 2. Mã và thứ tự

Mã sự kiện dạng `A30-Ddd-HHmmss-actor-kind`; ví dụ `A30-D006-170500-P00-buy-food`. Sự kiện có mili giây dùng thêm ba chữ số. Khóa chống lặp lấy từ fixture, ngày, chủ thể, loại và nghĩa vụ nguồn; không lấy văn bản hiển thị làm khóa.

Tại cùng mốc, dùng tám pha của [[LUOC_DO_TRANG_THAI]]:

1. cập nhật chuyển động;
2. hết hiệu lực;
3. kiểm tra quyền/giữ chỗ;
4. chụp trạng thái và nhận đầu vào;
5. cam kết giao dịch;
6. hoàn tất hành động;
7. tạo quan sát;
8. đánh giá mục tiêu/lập bước mới.

Sổ ngày ghi giờ kết thúc của giao dịch. Đi bộ là Action có khoảng, không phải hai lần dịch chuyển ở giờ rời/đến.

## 3. Các mẫu sự kiện lặp mỗi ngày

### 3.1 Nước của N01–N20

| Mẫu | Khoảng | Kết quả nếu đủ người/bình/quyền |
|---|---|---|
| W-O04 | 06:00–06:16:22.500 | N06+N17 đem 6.000 ml D11→O04 |
| W-O01 | 06:00–06:19:40 | N04 đem 4.000 ml về O01 |
| W-O02 | 06:00–06:20:47.500 | N08 đem 4.000 ml về O02 |
| W-H01 | 06:04–06:25:32.500 | N01 đem 4.000 ml về H01 |
| W-O05 | 06:00–06:34:40 | N19 hoàn tất hai lượt, đem 4.000 ml về O05 |
| W-O06 | 06:00–06:34 | N18 đem 2.000 ml về O06; D10 không có người gác trong khoảng này |
| W-O03 | 06:12–06:41:57.500 | N14+N15 đem 8.000 ml về O03 |
| W-H02 | 06:15–07:03:42.500 | N09+N10 đem 8.000 ml về H02 |

Tám mẫu trên rút đúng 40.000 ml/ngày. Nước P00:

- ngày 1 rút 500 ml tại 06:49:22.500–06:50:12.500;
- ngày 2 rút 1.500 ml tại 06:09:22.500–06:11:12.500;
- ngày 3–8 rút 2.000 ml tại 06:09:22.500–06:11:42.500;
- ngày 9–30 rút 2.000 ml trong chuyến 06:00–06:21:05.

Vì P00 có sẵn 2.000 ml, tổng lấy từ D11 là 40.500 ml ngày 1, 41.500 ml ngày 2 và 42.000 ml/ngày từ ngày 3. Tổng 30 ngày D11 mất **1.258.000 ml** do lấy; cộng 2.000 ml đầu kỳ của P00 thành đúng **1.260.000 ml** được 21 người uống. Dòng vào và nước tràn của D11 là sổ nguồn riêng, không được dùng để cộng lại lượng đã lấy.

### 3.2 Phát V02 và bữa ăn

| Nguồn | Giờ phát/ăn sáng | Định suất ngày |
|---|---|---:|
| O04 | 06:20–06:40 | 3 |
| O01 | 06:25–06:45 | 2 |
| O02 | 06:25–06:45 | 2 |
| H01 | 06:30–06:50 | 2 |
| O05 | 06:40–07:00 | 2 |
| O03 | 06:45–07:05 | 4 |
| H02 | 07:10–07:30 | 4 |
| O06 | 07:25–07:45 | 1 |
| P00 | Theo lịch cá nhân | 1 |

Tổng là 21 V02/ngày. Mỗi định suất chia 250 g sáng và 250 g tối; bữa trưa không trừ V02. Với N05 nhận trước, sự kiện 17:33:20–17:38:20 ngày hôm trước đổi vị trí vật thật sang N05 nhưng đánh dấu `allocation_for_day`; ngày kế không phát lần hai.

Các mốc uống sau sáng: 12:00, cùng bữa tối 18:00 và 21:30. P00 trong ca J01 uống ở 11:00 và 16:05 thay cho 12:00 và 21:30, nhưng tổng vẫn 2.000 ml/ngày.

### 3.3 Công việc, sinh hoạt và ngủ

- 08:00: RoutinePlan của mỗi NPC/P00 tái kiểm vị trí, chức năng, quyền và ngoại lệ ngày.
- 11:00/12:00/13:00/16:00/17:00: kết thúc hoặc bắt đầu các khối đã ghi tại K1.1; không tự sinh sản phẩm nếu thiếu quy trình.
- 18:00–18:20: bữa tối; 21:30–21:35: lần uống cuối nếu chưa đủ.
- 22:00: bắt đầu ngủ; 06:00 hôm sau: hoàn tất tám giờ và tạo Trigger ngày mới.
- Sự kiện nhu cầu cơ thể được tích phân giữa các mốc; các hàng trên chỉ là điểm hành động, không phải cơ thể đóng băng giữa hai hàng.

## 4. Chuỗi P00 ngày 1–10

### 4.1 Ngày 1

| Khoảng/mốc | Sự kiện chính | Dấu vết |
|---|---|---|
| 06:00–06:30 | Ăn/uống/chuẩn bị | Trừ 250 g và 500 ml từ đồ thật |
| 06:30–06:35 | Hỏi N01 | Observation lời nói → Belief về N20/D11 |
| 06:35–07:12:05 | Hỏi N20, đi D11 rồi D05 | Message → Belief; hành trình tạo tri thức tuyến |
| 07:12:05–07:42:05 | N12 kiểm lô, thử kỹ năng, hai bên nhận C-A-J01-01 | Giữ lô 1, V22, 8 V01 |
| 08:00–16:30 | Sáu giờ J01 và nghiệm thu | +30 V02 H02; +8 V01 P00; đóng hợp đồng 1 |
| 16:30–16:40 | N12 đề nghị lô 2, P00 nhận | Giữ lô 2/V22/8 V01 |
| 16:46:40–16:51:40 | Hỏi N06 về V02 | Message → giá/giờ quầy; về D02 16:55:50 |
| 21:00–21:05 | Trả trọ | P00 −1, O05 +1 |

### 4.2 Ngày 2–8

- Ngày 2 dùng 500 ml còn lại từ ngày 1 và chỉ lấy thêm 1.500 ml. Ngày 3–8 bắt đầu với bình rỗng.
- 08:00–16:30 mỗi ngày hoàn tất đúng một lô J01; H02 nhận 30 V02, P00 nhận 8 V01.
- Sau ngày 2–7, đề nghị và hợp đồng cho ngày kế được tạo riêng. Sau ngày 8 không có lô thứ chín.
- Ngày 6 và 8, giao dịch P00 mua hai V02 cam kết lúc 17:05; mỗi lần P00 −4, O04 +4.
- Trong giao tiếp của lần mua ngày 6, N06 chuyển thông tin có nguồn về N13/O03; chưa tạo bài học hay quyền tu luyện.
- Mỗi ngày 21:05, giao dịch trọ cam kết đúng một lần.

### 4.3 Ngày 9–10

| Ngày/giờ | Sự kiện | Kết quả |
|---|---|---|
| 9, 12:30–12:40:25 | P00 đi D02→D09 qua D01 | Tri thức tuyến được xác nhận bằng hành trình |
| 9, 12:55 | N13 đồng ý; P00 trả O03 | P00 −12, O03 +12; tạo buổi J05 |
| 9, 13:00–15:00 | J05 | Mở kiến thức nhập môn hẹp; không tự tăng cấu trúc/cấp quyền vận công |
| 9, 15:00–15:10:25 | Về D02 | Vị trí đổi liên tục |
| 10, 17:30–17:46:40 | N02 tới O01, thanh toán C01, trở về | 17:40:50 H01 −12, O01 +12; nghĩa vụ hoàn tất |
| 10, 17:00–17:05 | P00 mua hai V02 | P00 −4, O04 +4 |

Các ngày 10–30, hành vi tìm cơ hội/đọc/giao tiếp chưa có đầu ra định lượng. Sổ vẫn ghi thời gian và DecisionFrame, không tạo đồng, vật, kỹ năng hoặc mối quan hệ vô hạn.

## 5. Ngoại lệ từng ngày

Các sự kiện ăn, nước, trọ và ngủ lặp mỗi ngày không chép lại trong bảng này.

| Ngày | Ngoại lệ ngoài mẫu ngày |
|---:|---|
| 1 | O05→O06: giao 5 V02/10 V01 lúc 07:13:20; J01-01 hoàn tất 16:30; P00 hỏi N06. |
| 2 | J01-02 hoàn tất; nước P00 chỉ lấy 1.500 ml. |
| 3 | J01-03; 17:30 N05 sang D02 nhận trước suất ngày 4, về D01 17:41:40. |
| 4 | 07:01:40 H02→O04 30 V02/30 V01; nhập quầy xong 07:33:53.334; J01-04. |
| 5 | J01-05. |
| 6 | O05→O06 lúc 07:20; J01-06; P00 mua 2 V02 và hỏi về N13, giao dịch 17:05. Overlay C nếu dùng phải thay lịch N05/N20 và tách kết quả khỏi nhánh cơ sở. |
| 7 | J01-07. |
| 8 | J01-08; P00 nhận công làm tiền tạm đạt 93; 3 đồng ở V13; mua 2 V02 lúc 17:05; N05 nhận trước suất ngày 9. |
| 9 | 07:01:40 H02→O04 30; P00 trả 12 và học J05; không mua V02. |
| 10 | P00 mua 2 V02; C01 cam kết lúc 17:40:50. |
| 11 | O05→O06 lúc 07:20. |
| 12 | P00 mua 2 V02. |
| 13 | O04→O01 30 V02/60 V01 lúc 07:54:10; 17:30 N05 nhận trước suất ngày 14. |
| 14 | 07:01:40 H02→O04 30; P00 mua 2 V02. |
| 15 | Không có giao dịch ngoài mẫu ngày. |
| 16 | O05→O06 lúc 07:20; P00 mua 2 V02. |
| 17 | 17:30 N05 nhận trước suất ngày 18. |
| 18 | O04→H01 lúc 06:50:33.334; →O02 lúc 07:25; →O03 lúc 08:03:20, mỗi lô 20 V02/40 V01; P00 mua 2; 17:30 N05 nhận trước suất ngày 19. |
| 19 | 07:01:40 H02→O04 30. |
| 20 | P00 mua 2 V02. |
| 21 | O05→O06 lúc 07:20. |
| 22 | P00 mua 2 V02. |
| 23 | O04→O03 20 V02/40 V01 lúc 08:03:20; 17:30 N05 nhận trước suất ngày 24. |
| 24 | 07:01:40 H02→O04 10 V02/10 V01; O04→O05 6 V02/12 V01 lúc 08:13:20; P00 mua 2. |
| 25 | Không có giao dịch ngoài mẫu ngày. |
| 26 | O05→O06 lúc 07:20; P00 mua 2 V02. |
| 27 | Không có giao dịch ngoài mẫu ngày. |
| 28 | P00 mua 2 V02 lần cuối. |
| 29 | Không có giao dịch ngoài mẫu ngày. |
| 30 | Các kho trách nhiệm ngoài H02 về 0 sau định suất; kết sổ lúc 21:35, P00 còn 14 V01. |

## 6. Sổ V02 cuối mỗi ngày

Bảng ghi V02 chưa tiêu thụ quy về **nguồn chịu trách nhiệm cấp**, gồm cả suất đã chuyển vị trí cho N05 nhưng dành cho ngày kế. Nó không thay Position của từng vật. Sự kiện vật lý vẫn ghi riêng người giữ và vật chứa.

| Ngày | P00 | H01 | H02 | O01 | O02 | O03 | O04 | O05 | O06 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 5 | 38 | 146 | 28 | 38 | 76 | 97 | 77 | 4 |
| 2 | 4 | 36 | 172 | 26 | 36 | 72 | 94 | 75 | 3 |
| 3 | 3 | 34 | 198 | 24 | 34 | 68 | 91 | 73 | 2 |
| 4 | 2 | 32 | 194 | 22 | 32 | 64 | 118 | 71 | 1 |
| 5 | 1 | 30 | 220 | 20 | 30 | 60 | 115 | 69 | 0 |
| 6 | 2 | 28 | 246 | 18 | 28 | 56 | 110 | 62 | 4 |
| 7 | 1 | 26 | 272 | 16 | 26 | 52 | 107 | 60 | 3 |
| 8 | 2 | 24 | 298 | 14 | 24 | 48 | 102 | 58 | 2 |
| 9 | 1 | 22 | 264 | 12 | 22 | 44 | 129 | 56 | 1 |
| 10 | 2 | 20 | 260 | 10 | 20 | 40 | 124 | 54 | 0 |
| 11 | 1 | 18 | 256 | 8 | 18 | 36 | 121 | 47 | 4 |
| 12 | 2 | 16 | 252 | 6 | 16 | 32 | 116 | 45 | 3 |
| 13 | 1 | 14 | 248 | 34 | 14 | 28 | 83 | 43 | 2 |
| 14 | 2 | 12 | 214 | 32 | 12 | 24 | 108 | 41 | 1 |
| 15 | 1 | 10 | 210 | 30 | 10 | 20 | 105 | 39 | 0 |
| 16 | 2 | 8 | 206 | 28 | 8 | 16 | 100 | 32 | 4 |
| 17 | 1 | 6 | 202 | 26 | 6 | 12 | 97 | 30 | 3 |
| 18 | 2 | 24 | 198 | 24 | 24 | 28 | 32 | 28 | 2 |
| 19 | 1 | 22 | 164 | 22 | 22 | 24 | 59 | 26 | 1 |
| 20 | 2 | 20 | 160 | 20 | 20 | 20 | 54 | 24 | 0 |
| 21 | 1 | 18 | 156 | 18 | 18 | 16 | 51 | 17 | 4 |
| 22 | 2 | 16 | 152 | 16 | 16 | 12 | 46 | 15 | 3 |
| 23 | 1 | 14 | 148 | 14 | 14 | 28 | 23 | 13 | 2 |
| 24 | 2 | 12 | 134 | 12 | 12 | 24 | 22 | 17 | 1 |
| 25 | 1 | 10 | 130 | 10 | 10 | 20 | 19 | 15 | 0 |
| 26 | 2 | 8 | 126 | 8 | 8 | 16 | 14 | 8 | 4 |
| 27 | 1 | 6 | 122 | 6 | 6 | 12 | 11 | 6 | 3 |
| 28 | 2 | 4 | 118 | 4 | 4 | 8 | 6 | 4 | 2 |
| 29 | 1 | 2 | 114 | 2 | 2 | 4 | 3 | 2 | 1 |
| 30 | 0 | 0 | 110 | 0 | 0 | 0 | 0 | 0 | 0 |

Đối chiếu: 500 đầu + 240 từ tám J01 − 630 tiêu thụ = **110 V02**, đúng số cuối H02. Không hàng nào âm trong nhánh cơ sở. Các kho về 0 ngày 30 cho thấy lịch không có dự phòng, không chứng minh sinh kế lâu dài bền vững.

## 7. Sổ tiền

### 7.1 P00 cuối mỗi ngày

| Ngày | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| V01 | 47 | 54 | 61 | 68 | 75 | 78 | 85 | 88 | 75 | 70 |

| Ngày | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| V01 | 69 | 64 | 63 | 58 | 57 | 52 | 51 | 46 | 45 | 40 |

| Ngày | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| V01 | 39 | 34 | 33 | 28 | 27 | 22 | 21 | 16 | 15 | 14 |

Ngày 8 lúc 16:30 có 93 đồng trước khi mua; sức chứa hai túi áo sau V32 là 90 đồng, nên ba đồng ở V13. Sau giao dịch 17:05 còn 89 và có thể sắp lại. Không đồng nào bị biến mất vì vượt túi.

### 7.2 Kết sổ toàn vùng

| Chủ/quỹ | Đầu | Cuối |
|---|---:|---:|
| P00 | 40 | 14 |
| H01 | 160 | 108 |
| H02 | 240 | 306 |
| O01 | 300 | 252 |
| O02 | 180 | 140 |
| O03 | 400 | 332 |
| O04 | 400 | 550 |
| O05 | 200 | 278 |
| O06 | 80 | 20 |
| **Tổng** | **2.000** | **2.000** |

Dòng P00: 40 + 64 công − 48 thức ăn − 30 trọ − 12 học = 14. Các giao dịch lương thực, C01 và J01 giải thích toàn bộ thay đổi còn lại; “số dư” không phải bản sao của đồng V01 vật lý.

## 8. Sổ nhận thức và quyết định bắt buộc

| Mốc | Chủ thể | Hồ sơ phải xuất hiện |
|---|---|---|
| D1 06:35 | P00 | Observation/Message N01, Belief về N20/D11, DecisionFrame hỏi N20 |
| D1 06:44:10 | P00 | Message N20; Belief D05/D11/N12 ở mức được kể |
| D1 07:12:05 | P00 | Tri thức tuyến từ hành trình; Observation N12/lô |
| D1 07:42:05 | P00,N12 | hai DecisionFrame chấp nhận; Contract/Reservation J01-01 |
| D1–D7 16:30 | P00,N12 | đề nghị lô kế, chấp nhận riêng; không tạo lô 9 |
| D1 16:51:40 | P00 | Belief giá/giờ N06 có hạn dùng, nguồn lời nói |
| D5 cuối ngày | P00 | Inference thiếu V02 sau ngày 6; kế hoạch mua ngày 6 |
| D6 17:05 | P00 | Belief N13/O03 từ Message N06, trỏ thông báo O03 làm nguồn gốc |
| D9 12:55 | P00,N13 | kiểm hiện diện/quyền/tiền, DecisionFrame hai bên, Transaction J05 |
| D10–D30 | P00 | các lượt tìm việc có kết quả quan sát; không có đầu ra nghề giả |

RoutinePlan của NPC tạo DecisionFrame gọn khi ngày mới hoặc ngoại lệ tới hạn. Nếu mọi đầu vào không đổi, có thể trỏ lại lý do thói quen thay vì sao chép toàn bộ lịch sử; Action của ngày vẫn là hồ sơ mới.

## 9. Kết quả đối chiếu LC/QD trên giấy

| Nhóm | Kết quả hiện tại |
|---|---|
| LC01–LC15 | Lịch và sổ có đủ dữ liệu để khớp thủ công sau khi sửa nước ngày 2 và giờ nhận suất N05. Chưa có bộ chạy để chứng minh tự động. |
| LC16–LC18 | Cần snapshot/bộ xử lý và nhánh trì hoãn; chưa thể xác nhận bằng tài liệu. |
| QD01–QD15 | Sổ đã chỉ ra nguồn bắt buộc và điểm không được truyền tri thức; chưa có bộ quyết định để thử phủ định. |
| QD16–QD20 | Cần thực thi seed, tải lại, chống gửi lặp và DecisionFrame bất biến. |

Hai sửa lỗi K1.3 phát hiện:

1. P00 không có bình rỗng đầu ngày 2; còn 500 ml từ ngày 1 và chỉ lấy thêm 1.500 ml.
2. N05 ở D01 nên việc nhận trước suất H01 cần hành trình D01↔D02 lúc 17:30, không thể ghi “nhận tối hôm trước” mà không có vị trí.

## 10. Điều kiện kiểm thử SS01–SS16

Các điều kiện mới đã định nghĩa nhưng **chưa chạy bằng mô phỏng**:

1. SS01 — Mở rộng mẫu tạo đúng một bộ sự kiện/ngày, mã và khóa chống lặp duy nhất.
2. SS02 — Ngày 1/2/3 P00 lần lượt lấy 500/1.500/2.000 ml; tổng tiêu thụ vẫn 2.000 ml/ngày.
3. SS03 — D11 bị lấy đúng 1.258.000 ml trong 30 ngày, chưa tính dòng vào/tràn.
4. SS04 — Tổng định suất V02 là 630; nhận trước của N05 không phát lần hai.
5. SS05 — Tám J01 tạo đúng 240 V02 và 64 V01 công.
6. SS06 — Cuối ngày 30 chỉ H02 còn 110 V02; mọi nguồn khác bằng 0, không nguồn nào từng âm.
7. SS07 — O06 nhận hàng trước bữa sáng sáu ngày giao và về 0 đúng cuối chu kỳ năm ngày.
8. SS08 — Mọi lô nhập/sale O04 có Position người giữ trên đường dù quyền sở hữu đã đổi.
9. SS09 — Sáu hành trình nhận suất trước của N05 không trùng lịch nền và giữ đúng vật thật.
10. SS10 — Ngày 18 ba đơn N05 nối tiếp, không có hai Position hoặc Action chính trùng nhau.
11. SS11 — P00 đạt 93 đồng ngày 8; đúng ba đồng ở V13, rồi còn 89 sau mua.
12. SS12 — Kết sổ V01 từng quỹ khớp bảng và tổng luôn bằng 2.000.
13. SS13 — Mỗi hợp đồng J01 hình thành sau đề nghị riêng; không có Reservation lô 9.
14. SS14 — Overlay C ngày 6 thay các Action liên quan và không làm bẩn sổ kết quả nhánh cơ sở.
15. SS15 — Lưu ở giữa chuyến/giao dịch giữ tiến độ, Position, người giữ, khóa chống lặp và nguồn nhận thức.
16. SS16 — Trì hoãn một giao hàng qua giờ phát suất làm bảng ngày phân nhánh thay đổi thay vì tự bù về số cơ sở.

## 11. Việc kế tiếp

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
