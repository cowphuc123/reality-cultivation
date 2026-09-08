---
title: Sổ thể chế 30 ngày An Khê — K1.8
aliases:
  - K1.8
  - Sổ thể chế An Khê
tags:
  - reality-cultivation
  - thiet-ke
  - fixture
  - xa-hoi
status: de-xuat
updated: 2026-09-06
---

# Sổ thể chế 30 ngày An Khê — K1.8

Tài liệu này vật chất hóa phần hồ sơ/kênh tin của [[VAN_HOA_THE_CHE_AN_KHE_K1]] và đặt chúng vào lịch [[SO_SU_KIEN_30_NGAY_K1]]. Nó không phải kết quả game đã chạy. Nhánh cơ sở chỉ ghi lại các hành động đã có trong fixture; các vụ tranh chấp mới được tách thành overlay để NPC vẫn có thể chọn khác khi mô phỏng thật.

Các mã, vật, thời lượng và người giữ dưới đây là đề xuất chưa được người dùng duyệt. Ba loại vật mới nâng danh mục fixture từ V01–V33 lên **V01–V36**; điều này mở rộng bộ đối chiếu nhỏ, không giới hạn tham vọng hàng nghìn loại vật của game.

## 1. Mục tiêu kiểm toán

K1.8 phải trả lời được cho mỗi thay đổi xã hội:

1. hồ sơ nằm trên vật nào và vật đó ở đâu;
2. ai có thể tiếp cận vật, ai có quyền ghi, ai thực sự đã đọc/nghe;
3. hồ sơ đang mô tả FactEvent, Claim, thỏa thuận hay chỉ là lời kể;
4. quyền nào được kiểm ở pha 30 và vật/tiền nào đổi ở pha 50;
5. khi sổ sai, mất, bị sửa hoặc chưa tới nơi thì sự thật còn ở nguồn nào;
6. giao diện của P00 chỉ hiện phần P00 có nguồn biết.

## 2. Ba loại vật và một vị trí cố định mới

| Mã | Vật mẫu | Khối lượng/kích thước | Trạng thái riêng |
|---|---|---|---|
| V34 | Tờ ghi việc trống hoặc đã viết | 10 g; 30 × 20 × 0,05 cm | `blank/written/cancelled/damaged`, nội dung, chữ/xác nhận, mặt còn trống |
| V35 | Sổ đóng gáy 100 tờ | 300 g; 31 × 22 × 2 cm | trang 1–200, trang đã ghi, chỉ mục, vết sửa, tình trạng gáy |
| V36 | Bộ viết hộp nhỏ | 100 g; 15 × 8 × 4 cm | bút 10 g, lọ 20 g mực + hộp/lót 70 g; `ink_remaining_mg` |

V34 không phải V26: V26 mang nội dung công pháp có quyền truy cập riêng; đổi nhãn một tờ V26 thành giấy hành chính sẽ làm mất lịch sử tri thức. V35 có từng trang là Surface thuộc cùng cuốn, không sinh 200 vật rời. V36 dùng 10 mg mực cho mỗi 100 ký tự quy ước; khối lượng vật giảm đúng lượng mực bám sang V34/V35, không cần định loại V37 chỉ cho phần mực rất nhỏ.

Tại D01 thêm `F-D01-NOTICE-RACK`: khung gỗ cố định 120 × 90 × 5 cm, khối lượng 8.000 g, có 12 khe, mỗi khe giữ một V34 bằng nẹp gỗ. Nó là bộ phận công trình đã tồn tại từ HIST:AK-RECORDS, không phải vật mang đi và không cấp thêm V10 rời; tháo dỡ sau này phải tạo đúng các mảnh gỗ theo cấu tạo thực. Chạm/đọc/đăng giấy cần có mặt tại đúng vùng tương tác của khung.

## 3. Tồn kho hồ sơ lúc ngày 1, 06:00

`AK-COMMON` là quyền sở hữu chung trên vật công cộng, không phải NPC, tổ chức ra quyết định hay kho tiền. Người giữ vật chỉ có khả năng tiếp cận vật lý; quyền sửa nội dung vẫn theo nguồn thẩm quyền.

| Vật | Số lượng/chủ | Vị trí/người giữ | Công dụng ngày 1–30 |
|---|---:|---|---|
| V34-AK-01…10 | 10 / AK-COMMON | ngăn tài liệu công cộng D01; N06 giữ | thông báo/hồ sơ công khai |
| V34-O01-01…05 | 5 / O01 | D03; N03 | biên nhận, thông báo y quán |
| V34-O03-01 | 1 / O03 | khe 1 khung D01; N06 chỉ giữ vị trí công cộng | NOTICE-J05 đã đăng |
| V34-O03-02…05 | 4 / O03 | D09; N16 | thông báo và phiếu quyền học còn trống |
| V34-O04-01…05 | 5 / O04 | D01; N06 | báo giá/chuyến hàng |
| V34-O05-01…03 | 3 / O05 | D02; N19 | phòng/ăn ở |
| V34-O06-01…02 | 2 / O06 | D08; N18 | yêu cầu sửa đường |
| V35-AK-PUB | 1 / AK-COMMON | hộc dưới khung D01; N06 giữ | chỉ mục thông báo công cộng |
| V35-H02 | 1 / H02 | kho D05; N12 giữ | thành viên, việc và thanh toán H02 |
| V35-O01 | 1 / O01 | D03; N03 giữ | nợ, chăm sóc và biên nhận |
| V35-O03 | 1 / O03 | D09; N16 giữ | quyền học, lịch, nguồn và thu chi |
| V35-O04 | 1 / O04 | D01; N06 giữ | giá, hàng, vận chuyển và quỹ |
| V35-O05 | 1 / O05 | D02; N19 giữ | phòng, bữa, công đổi ăn ở |
| V35-O06 | 1 / AK-COMMON | D08; N18 giữ | kiểm cầu và quỹ đường |
| V36-AK/H02/O01/O03/O04/O05/O06 | 7 bộ / cùng chủ sổ | cạnh V35 tương ứng; người giữ như trên | ghi đúng sổ/vật của chủ |

Tổng mới: 30 V34 = 300 g; bảy V35 = 2.100 g; bảy V36 = 700 g. Tổng vật chất hồ sơ thêm vào INIT-A là **3.100 g**, chưa tính khung cố định thuộc công trình. Mỗi bộ V36 bắt đầu có 20.000 mg mực; khối lượng bảng đã bao gồm lượng này.

HIST:AK-RECORDS là dữ kiện khởi tạo đề xuất: An Khê đã dùng sổ/tờ việc trước ngày 1. Nó không tạo tiền, công pháp, quyền mới hay chứng minh nội dung bất kỳ đã được ghi; từng nội dung vẫn cần RecordEntry riêng.

## 4. Quyền giữ, ghi, xác nhận và đọc

| Hành vi | Điều kiện |
|---|---|
| giữ/cất | có RoleRight hoặc được người giữ giao vật thật |
| ghi nháp | có vật, bộ viết và khả năng viết; chưa làm nội dung có hiệu lực |
| ghi sổ tổ chức | người giữ sổ hoặc người được ủy quyền, đúng phạm vi vai trò |
| xác nhận | người xác nhận có mặt, được đọc/nghe lại nội dung và chủ động chấp nhận |
| đăng công khai | nội dung có người phát đủ thẩm quyền; người tại khung chỉ thực hiện thao tác gắn |
| đọc | có tầm nhìn, thời gian, ánh sáng, chữ viết/ngôn ngữ phù hợp |
| đọc cho | người đọc tạo Message cho người nghe; người nghe không tự biết văn bản ngoài nội dung được truyền |
| sửa | không xóa ký tự cũ khỏi FactEvent; gạch sửa để lại dấu và một CorrectionEntry mới |

N06 giữ hộc/khung vì quầy ở D01, nhưng chỉ tự phát giá và tin vận hành O04. Thông báo O03 cần nguồn O03; quyết định hội đồng cần CaseRecord/Ruling. N06 có thể phá hoặc giấu vật về mặt vật lý nếu chọn làm vậy, nhưng hành vi đó là FactEvent có hậu quả chứ không biến thành quyền hợp lệ.

## 5. Thời lượng thao tác hồ sơ

Các hệ số fixture:

| Thao tác | Thời lượng |
|---|---:|
| mở/cất V35 hoặc V36 | 20 giây mỗi vật |
| ghi mục ngắn tối đa 200 ký tự | 120 giây + 20 mg mực |
| đọc lại mục ngắn | 60 giây |
| một người ký/xác nhận sau khi hiểu | 30 giây |
| gắn hoặc tháo một V34 khỏi khung | 60 giây |
| đọc một V34 quen ngôn ngữ | 90 giây |
| giải thích miệng nội dung ngắn | tối thiểu 120 giây |
| đối chiếu một giao dịch với vật/tiền | thêm 120 giây ngoài ghi |

Thiếu kỹ năng viết không cấm giao kết miệng. Một người có thể dùng dấu cá nhân hoặc xác nhận trước hai người nghe; sổ phải ghi cách xác nhận, không giả chữ ký. K1.8 không tự cấp khả năng đọc/viết cho P00 hoặc mọi NPC chưa có nguồn.

## 6. Loại mục ghi và quan hệ với sự thật

| Mã loại | Nội dung | Có thể là nguồn của |
|---|---|---|
| `ENTRY-FACT` | người ghi tuyên bố đã quan sát sự kiện | Message/Belief; FactEvent gốc vẫn tách |
| `ENTRY-CONTRACT` | điều khoản, bên, thời hạn, xác nhận | Contract/Reservation nếu đủ điều kiện |
| `ENTRY-TXN` | vật/tiền đã đếm và chuyển | chỉ mục tới Transaction thật |
| `ENTRY-RIGHT` | quyền được trao/thu hồi, phạm vi/hạn | RoleRight sau quyết định hợp lệ |
| `ENTRY-CLAIM` | điều một bên yêu cầu và căn cứ | Claim đang mở, chưa chứng minh bên đó đúng |
| `ENTRY-RULING` | người xử, chứng cứ, kết luận, biện pháp | Ruling trong phạm vi thẩm quyền |
| `ENTRY-NOTICE` | nội dung công khai, người phát, hiệu lực | PublicNotice; không tạo tri thức toàn vùng |
| `ENTRY-CORRECTION` | mục cũ, phần sai, lý do, người sửa | phiên bản mới; giữ lịch sử mục cũ |

Một ENTRY-TXN không tự chuyển V01. Transaction ở pha 50 xảy ra trước; pha 60 ghi chỉ mục. Nếu mất sổ giữa hai pha, giao dịch vẫn đã xảy ra và có FactEvent/Transaction, còn tổ chức phải khôi phục hồ sơ bằng nguồn khác.

## 7. Trạng thái hồ sơ có hiệu lực trước ngày 1

| Mã | Vật/trang | Nội dung đã có | Ai biết lúc 06:00 ngày 1 |
|---|---|---|---|
| REC-P00-ROOM | V35-O05, trang 12 | P00 ở phòng, 1 V01/ngày, giờ trả 21:00, phạm vi chỗ ở | P00 và N19 biết toàn văn; N20 chỉ biết có khách |
| REC-C01 | V35-O01, trang 44 | H01 nợ O01 12 V01, đến ngày 10 18:00, không lãi | N01, N02, N03; N04 không tự biết |
| REC-H02-MEM | V35-H02, trang 31 | vai trò Sơn/Cúc/Nga/Đạt và quyền kho hiện tại | N09–N12 theo phần liên quan; không ai tự biết đánh giá riêng |
| REC-O03-RIGHTS | V35-O03, trang 20 | quyền Vân/Yến/Kha/Tùng đúng K1.7 | N13–N16 theo quyền đã được giải thích |
| REC-O04-PACT | V35-O04, trang 18 | vai trò quầy/vốn, vận chuyển, hộ tống | N05, N06, N17 |
| REC-O06-RIGHT | V35-O06, trang 9 | N18 chi thường tối đa 20 V01 | N18; người khác chỉ biết nếu được báo/đọc |
| NOTICE-J05 | V34-O03-01 ở khe 1 D01 | buổi nhập môn ngày 9, 13:00, phí 12 V01, phải được O03 nhận | N16 biết nguyên văn; N06 biết khi nhận/đăng; N13 biết kế hoạch; người khác cần nguồn |
| IDX-J05 | V35-AK-PUB, trang 7 | khe 1, người phát O03/N16, hiệu lực tới 13:00 ngày 9 | N06 và N16 |

NOTICE-J05 có nguồn HIST:STUDY-NOTICE. Nó được viết tại D09, Yến mang tới D01 và N06 gắn trước INIT-A; chi tiết này cụ thể hóa vật mang tin, không thay việc ngày 6 Hòa kể P00. Tờ vẫn nằm ở khe sau khi hết hiệu lực cho tới khi có người tháo; dòng ngày/giờ trên giấy cho phép người đọc nhận ra tin cũ nếu hiểu nội dung.

## 8. Sổ cơ sở ngày 1–8: J01 và sinh hoạt

Mỗi ngày P00 nhận một J01 dùng cùng quy trình:

| Mốc | Hồ sơ/thao tác | Kết quả |
|---|---|---|
| ngày 1, 07:12:05–07:17:05 | N12 kiểm lô/đề nghị | Observation và đề nghị, chưa có hợp đồng |
| 07:17:05–07:37:05 | thử khô có giám sát | Evidence hẹp cho J01 |
| 07:37:05–07:42:05 | N12 ghi ENTRY-CONTRACT, đọc/giải thích; hai bên xác nhận | C-A-J01-01 và Reservation có hiệu lực |
| 16:25–16:30 | N12 nghiệm thu vật thật | trạng thái hoàn thành đủ/thiếu |
| 16:30–16:35 | nếu đủ: 8 V01 chuyển ở pha 50, ENTRY-TXN ghi sau | giao dịch chỉ một lần |
| 16:35–16:40 ngày 1–7 | đề nghị lô kế và xác nhận nếu P00 chấp nhận | hợp đồng ngày sau; không sinh lô thứ chín |

N12 dùng V35-H02/V36-H02 tại D05. N12 và P00 phải ở vùng ghi sổ trong các mốc xác nhận; thời gian trên thay phần “đề nghị năm phút” đã có, không cộng thêm trùng. Nếu P00 không đọc được, N12 giải thích trong chính cửa sổ năm phút và ghi cách xác nhận; chưa tự chốt P00 biết chữ.

Trang dự kiến: ngày 1 dùng trang 32–33; ngày 2–8 mỗi ngày một trang, tổng tới trang 40. Mỗi hợp đồng và thanh toán trỏ lô, V22, Reservation 8 V01 và Transaction cụ thể. Sổ không chứa tám đồng bản sao.

Tiền trọ 21:00 ngày 1–30 được N19 đối chiếu và ghi một dòng ENTRY-TXN vào V35-O05. Mỗi dòng 120 giây nằm trong cửa sổ 21:00–21:05; 60 giây còn lại dùng cất sổ/trao đổi ngắn. Nếu P00 trả nhưng N19 quên ghi, tiền vẫn đổi chủ và `record_pending` được tạo.

## 9. Sổ O04 và thông tin quầy trong 30 ngày

N06 ghi V35-O04 sau mỗi nhập/bán/chuyển tiền đã có ở [[DU_LIEU_LIEN_KET_K0]]:

- H02→O04 ngày 4/9/14/19: 30 V02 và 30 V01; ngày 24: 10 V02 và 10 V01;
- O04→O01 ngày 13: 30 V02/60 V01;
- ba đơn ngày 18: H01, O02, O03, mỗi đơn 20 V02/40 V01;
- O04→O03 ngày 23: 20 V02/40 V01;
- O04→O05 ngày 24: 6 V02/12 V01;
- P00 mua hai V02 ngày chẵn 6–28, 4 V01/lần.

Thời gian kiểm hàng vốn đã có trong lịch giao; 120 giây ghi sổ nằm trong cửa sổ kiểm 5–10 phút. Với mua của P00 17:00–17:05, 120 giây cuối dùng ghi ENTRY-TXN trước khi đóng giao dịch lúc 17:05. Nếu N06 bị gián đoạn, giao dịch chỉ hoàn tất khi kiểm/chuyển thật; không ép đúng bảng nhờ một dòng sổ.

Giá chào có thể được nói trực tiếp. Muốn đăng công khai, N06 dùng V34-O04 và có quyền với giá O04; tờ giá chỉ cho người quan sát biết, không sửa bảng giá trong đầu mọi NPC.

## 10. Ngày 6–9: từ thông báo tới buổi học

| Thời điểm | Sự kiện | Hồ sơ/tri thức |
|---|---|---|
| ngày 6, 17:00–17:05 | P00 hỏi N06 khi mua V02 | N06 tạo Message tóm lược NOTICE-J05; P00 biết người/nơi/giờ/phí trong lời nói |
| ngày 9, 12:40:25 | P00 tới D09 | hiện diện không tự được nhận học |
| 12:40:25–12:55 | Vân kiểm chỗ, điều kiện và giải thích phạm vi | Proposal; chưa chuyển tiền/quyền |
| 12:55 | P00 chấp nhận; 12 V01 chuyển sang O03 | Transaction J05-FEE |
| 12:55–13:00 | Yến ghi ENTRY-TXN và ENTRY-RIGHT tạm cho buổi | quyền tham dự 13:00–15:00, không phải quyền tự luyện |
| 13:00 | NOTICE-J05 hết hiệu lực ở pha 20 | tờ vật lý vẫn ở khe 1, nội dung trở thành tin cũ |
| 13:00–15:00 | buổi học thật | PracticeEvent/Observation; không tự tăng cấu trúc |
| 15:00–15:05 | Vân kết luận phạm vi đã học; Yến ghi | kỹ năng/tri thức chỉ theo bằng chứng buổi học |

Mốc 12:40:25–12:55 trước đây là thời gian chờ. K1.8 dùng nó cho quy trình nhận học viên nên không gây hai hành động chính. N13 chỉ dạy đúng một buổi. N16 có quyền ghi/cấp theo quyết định của N13, không tự nhận P00.

## 11. Ngày 10: đóng C01 bằng vật và hồ sơ

Lịch C01 được cụ thể:

| Thời điểm | Hành động |
|---|---|
| 17:30–17:31:36 | Trong khi N02 bắt đầu đi, N03 viết trước phần điều khoản cố định của biên nhận V34-O01-01; tờ vẫn là nháp, chưa chứng minh đã trả |
| 17:30–17:35:50 | N02 mang đúng 12 V01 từ H01 đi D02→D03 |
| 17:35:50–17:37:50 | N03/N02 đếm, kiểm REC-C01 |
| 17:37:50 pha 50 | 12 V01 đổi chủ H01→O01; Claim C01 thành `satisfied_pending_record` |
| 17:37:50–17:40:50 | N03 ghi ENTRY-TXN vào V35-O01 trong 96 giây; N03/N02 mỗi người xác nhận biên nhận đã viết sẵn trong 30 giây; 24 giây còn dùng cất/trao tờ |
| 17:40:50 | REC-C01 đóng `satisfied`; V34-O01-01 do N02 giữ |
| 17:40:50–17:46:40 | N02 về D02, mang biên nhận 10 g |

Khoảng “trả trước 17:40:50” của lịch cũ chứa đủ việc đếm/ghi/xác nhận. N02 về đúng giờ đã có. Biên nhận đổi vị trí/chủ sử dụng, không tạo thêm tiền. Ý định gia hạn SEC03 của An không được kích hoạt vì không có báo khó khăn hay trễ hạn trong nhánh cơ sở.

## 12. Ngày 11–30 và bảng kết sổ cơ sở

Không có tranh chấp mới trong nhánh cơ sở. Đây là kết quả đúng: hệ thống không bắt buộc tạo kiện tụng cho đủ nội dung.

| Sổ/vật | Thay đổi đến cuối ngày 30 |
|---|---|
| V35-H02 | tám hợp đồng J01 + tám Transaction; không có J01 thứ chín |
| V35-O01 | C01 đóng đúng 12 V01; biên nhận rời sổ tại H01 |
| V35-O03 | P00 trả 12 V01, quyền buổi học và kết quả giới hạn |
| V35-O04 | mọi lô thức ăn/tiền/P00 mua có chỉ mục Transaction |
| V35-O05 | 30 lần tiền trọ, tổng 30 V01; REC-P00-ROOM vẫn đúng ngày 30 |
| V35-O06 | chỉ có kiểm cầu/lịch quỹ nền; không tự ghi “cầu hỏng” từ SEC17 |
| V35-AK-PUB | NOTICE-J05 hết hiệu lực nhưng còn vật lý ở khe nếu chưa có Action tháo |
| CaseRecord | không vụ mới; `empty` là trạng thái có thể kiểm toán |

P00 mới ở 30 ngày nên chưa đạt mốc 90 ngày và vẫn là guest. Không tạo xét resident sớm. Tổng V01/V02/nước giữ đúng [[SO_SU_KIEN_30_NGAY_K1]]; 3.100 g vật hồ sơ không tham gia các phép tổng nguồn đó.

## 13. Overlay TC-X01 — đọc thông báo J05 đã hết hạn

Thay ngày 10, 08:00–11:00 của P00 bằng một lần xem khe 1 lúc 08:15. Chỉ chạy nhánh nếu P00 có khả năng đọc phù hợp hoặc có người đọc cho.

- P00 nhận Message “buổi ngày 9” cùng trạng thái tin đã quá hạn.
- Tờ không tự tạo lịch ngày 10, không thu 12 V01 và không cấp quyền vào O03.
- Nếu người đọc bỏ phần ngày, P00 có thể hình thành Belief sai có nguồn; O03 chỉ sửa khi P00 hỏi và người O03 biết nội dung P00 đã nhận.
- N06 giữ vật không có nghĩa N06 bảo đảm nội dung còn hiệu lực.

## 14. Overlay TC-X02 — Yến đề nghị quyền duyệt thay

Kích hoạt chỉ khi SEC15 trở thành mục tiêu nói với Vân. Không chọn trước Yến có nói hay Vân có đồng ý.

Các nhánh hợp lệ:

1. Yến chưa nói: không có Proposal/ENTRY-RIGHT.
2. Yến nói, Vân từ chối: ghi nội dung nếu hai bên muốn, quyền không đổi.
3. Vân đồng ý có hạn: ENTRY-RIGHT nêu loại phiên, mức L, thời hạn và quyền dừng; Yến chỉ nhận đúng phạm vi.
4. Vân muốn hỏi Kha/Tùng: tạo lịch họp và Message thật; im lặng không tính đồng ý.

Mọi nhánh giữ REC-O03-RIGHTS cũ tới khi quyết định hoàn tất ở pha 50/60. HIST:O03-INCIDENT là bằng chứng về rủi ro quy trình, không là lá phiếu tự động.

## 15. Overlay TC-X03 — Bình yêu cầu thay bánh V23

Kích hoạt khi Bình truyền SEC05 hoặc một kiểm tra xe tạo Evidence công khai.

- Bình có quyền ghi/đưa đề nghị, không có quyền lấy V01.
- Hòa cần biết tình trạng, giá/nguồn V24 và ảnh hưởng hợp đồng trước quyết định.
- Dũng được hỏi phần an toàn tuyến, không quyết định giá.
- Nếu chưa có V24 rời hay người bán, Ruling “nên thay” không sinh bánh.
- Nếu Hòa từ chối, DomainReputation chỉ đổi theo cách người liên quan hiểu lý do; không trừ điểm trung thành toàn cục.

V35-O04 giữ Proposal, Evidence và quyết định tách dòng. V23 vẫn nguyên trạng usable-but-watch cho tới tác động vật lý thật.

## 16. Overlay TC-X04 — Nga kiểm nghi ngờ lệch kho

SEC11 chỉ là Belief của Nga. Nga có thể:

- tự đối chiếu V35-H02 với vật thật trong quyền kho;
- hỏi Sơn/Cúc/Đạt về dòng có liên quan;
- mở ENTRY-CLAIM nếu tìm thấy chênh lệch;
- ghi Correction nếu chỉ là ghi chú cũ gây hiểu sai.

Nhánh kiểm cơ sở phải kết luận kho vẫn khớp như hồ sơ K1.6. Không tạo người phạm lỗi. Nếu overlay sửa một Transaction thật, CaseRecord cần hai nguồn hoặc hồ sơ giao dịch xác thực; RNG không chọn thủ phạm.

## 17. Overlay TC-X05 — O06 cần chi vượt 20 V01

Kích hoạt bằng InspectionEvent thật, không dùng riêng tiếng rung SEC17. N18 viết V34-O06-01 với vị trí, dấu hiệu, việc cần và ước phí; người đưa tin mang tới D01.

Hội đồng ba người chỉ được chọn sau khi từng ứng viên biết lời mời, có lịch và qua kiểm xung đột lợi ích. Kết quả có thể là:

- chưa đủ chứng cứ, yêu cầu kiểm thêm;
- duyệt một khoản/việc cụ thể;
- từ chối vì quỹ/biện pháp;
- tạm dừng tuyến trong phạm vi nguy hiểm nếu Evidence hỗ trợ.

Ruling không sửa cầu, không mua vật và không làm mọi người biết. N18 chỉ chi sau khi nhận bản có nguồn xác thực; nếu tờ bị trễ, quyền thực thi cũng trễ.

## 18. Overlay TC-X06 — tờ công khai bị che, tháo hoặc sửa

Ba biến thể cùng một seed/trạng thái xã hội:

1. V34 bị tờ khác che: người đứng lệch có thể không quan sát được dù notice còn hiệu lực.
2. người không có quyền tháo tờ: vật đổi vị trí thật; PublicNotice không tự quay lại khung.
3. nội dung bị gạch sửa: vết vật lý tồn tại nhưng không thành CorrectionEntry hợp lệ.

Người phát hiện tạo Observation theo phần nhìn thấy. N06 có thể đăng lại khi có bản/nguồn; không được khôi phục nguyên văn từ trí nhớ toàn tri. V35-AK-PUB giúp biết tờ từng ở khe nào nhưng không chứng minh ai tháo nếu thiếu quan sát.

## 19. Overlay TC-X07 — giao dịch thật nhưng chưa ghi sổ

Chèn gián đoạn sau pha 50 của một lần P00 mua V02 nhưng trước ENTRY-TXN:

- 4 V01 và hai V02 đã đổi chủ đúng một lần;
- V35-O04 chưa có dòng, tạo `record_pending` trỏ Transaction;
- tải lại giữ giao dịch và việc ghi còn treo;
- N06 đối chiếu vật/Transaction rồi ghi bù, không chuyển tiền/hàng lần hai;
- nếu N06 tin sổ hơn vật, Belief sai không sửa trạng thái sở hữu.

Overlay này kiểm ranh giữa “sổ nói” và “đã xảy ra”.

## 20. Overlay TC-X08 — biên nhận C01 thất lạc

Sau ngày 10, cho V34-O01-01 rơi ở một Position xác định trên D03→D02. Việc mất giấy không mở lại nợ đã satisfied.

- N02 chỉ biết đã mất sau khi kiểm vật mang theo.
- N03 còn V35-O01 và Transaction; người khác chưa tự biết.
- nếu có tranh chấp, hội đồng đối chiếu nguồn độc lập; bản ghi sổ không phải tài sản 12 V01.
- tìm lại tờ trả cùng id/vết bẩn/hư hại; không sinh “bản gốc thứ hai”.

## 21. Sổ sự kiện mẫu

| Event | due_ms/pha | Actor | Object | Authority/source | Output |
|---|---|---|---|---|---|
| EV-REC-J01-01 | D1 07:37:05 / 30–60 | N12/P00 | V35-H02 | quyền kho + đồng thuận | Contract + Reservation |
| EV-TXN-J01-01 | D1 16:30 / 50 | N12/P00 | 8 V01 | nghiệm thu C-A-J01-01 | Transaction |
| EV-MSG-J05 | D6 17:00 / 70 | N06→P00 | lời từ NOTICE-J05 | HIST/Observation của N06 | Message/Belief P00 |
| EV-RIGHT-J05 | D9 12:55 / 50–60 | N13/N16/P00 | V35-O03 | nhận học + phí thật | quyền buổi học |
| EV-EXPIRE-J05 | D9 13:00 / 20 | hệ thời gian | PublicNotice | `valid_until` | hết hiệu lực, giấy còn |
| EV-C01-PAY | D10 17:37:50 / 50 | N02/N03 | 12 V01 | REC-C01 | satisfied_pending_record |
| EV-C01-REC | D10 17:37:50–17:40:50 / 60 | N03/N02 | V35-O01, V34-O01-01 | Transaction C01 | satisfied + receipt |

Các mốc nhiều pha dùng một `transaction_group_id`; tải giữa pha giữ tiến độ và chống áp dụng lặp.

## 22. Những gì giao diện được phép hiển thị

P00 có bốn góc nhìn:

| Màn hình | Chỉ hiện |
|---|---|
| Việc/cam kết | hợp đồng P00 đã nghe/chấp nhận, điều khoản và nguồn |
| Tin công khai | tờ P00 đã đọc/được đọc cho; có nhãn còn hạn/có thể đã cũ |
| Quyền | quyền của P00 và quyền người khác đã giải thích/quan sát, kèm độ chắc |
| Tranh chấp | vụ P00 là bên, được mời hoặc đã biết công khai |

Máy tính có thể đặt sổ–vật–dòng thời gian cạnh nhau. Điện thoại mở từng thẻ và quay lại đúng vị trí cuộn; cả hai gửi cùng lệnh có id, phạm vi, đối tượng và thời hạn. Không có nút “xem toàn bộ sổ làng” nếu P00 chưa tiếp cận từng nguồn.

## 23. Điều kiện kiểm thử ST01–ST24

1. ST01 — INIT-A có đúng 30 V34, bảy V35, bảy V36; tổng 3.100 g và một vị trí cho mỗi vật.
2. ST02 — Khung D01 chứa tối đa 12 V34, không là túi vô hạn hay V10 rời.
3. ST03 — Mực chuyển V36→bề mặt theo lượng; ghi không tạo khối lượng.
4. ST04 — N06 giữ khung nhưng không thể hợp thức hóa thông báo O03 do mình tự viết.
5. ST05 — PublicNotice chỉ tạo tri thức cho người quan sát/nghe hợp lệ.
6. ST06 — Người nghe đọc hộ lưu đúng người đọc và nội dung được truyền.
7. ST07 — P00 chưa xác định biết chữ; fixture không tự cấp khả năng để đọc NOTICE-J05.
8. ST08 — Tám J01 tạo đúng tám Contract, Reservation và Transaction; không có lô chín.
9. ST09 — Entry sổ không nhân đôi 8 V01 hoặc 30 V02 của J01.
10. ST10 — 30 lần trả trọ vừa cửa sổ 21:00–21:05 và tổng đúng 30 V01.
11. ST11 — Mọi giao dịch O04 có một Transaction thật và tối đa một ENTRY-TXN chính.
12. ST12 — P00 biết J05 ngày 6 qua Message của N06, không qua tri thức toàn cục.
13. ST13 — Phí J05 chỉ chuyển sau N13 nhận và P00 đồng ý; N16 không tự nhận học viên.
14. ST14 — 13:00 ngày 9 notice hết hiệu lực nhưng V34 không tự biến mất.
15. ST15 — C01 đổi đúng 12 V01, đóng một Claim và tạo một biên nhận cùng id.
16. ST16 — Mất biên nhận không mở lại C01 hay tạo thêm 12 V01.
17. ST17 — Nhánh cơ sở kết thúc không CaseRecord mới; hệ không ép sinh tranh chấp.
18. ST18 — SEC15 chỉ đổi quyền O03 sau Proposal, đồng thuận/thẩm quyền và ENTRY-RIGHT hợp lệ.
19. ST19 — SEC05/SEC11/SEC17 không tự biến thành mua bánh, thiếu kho hoặc cầu hỏng.
20. ST20 — Hội đồng O06 loại ứng viên xung đột lợi ích và không tự sửa cầu sau Ruling.
21. ST21 — Che/tháo/sửa V34 thay Observation nhưng không hồi tố FactEvent nguồn.
22. ST22 — Gián đoạn giữa Transaction và ghi sổ giữ record_pending, không áp giao dịch lần hai.
23. ST23 — Lưu/tải giữa các pha giữ vật, trang, mực, quyền, người biết và event id.
24. ST24 — Cùng save/RNG/lệnh cho kết quả ST giống nhau trên điện thoại và máy tính.

Toàn bộ ST chưa chạy. Cộng 24 ST với 274 điều kiện trước đó cho **298 điều kiện thiết kế chưa chạy bằng mô phỏng**.

## 24. Giới hạn và bước kế tiếp

K1.8 chưa thiết kế độ bền giấy/mực theo ẩm, khóa sổ, giả chữ/giám định chữ, nhiều ngôn ngữ, sao chép hàng loạt, thuế, đất đai hay hệ thống cưỡng hành cấp vùng. Khả năng đọc/viết của 21 người vẫn cần hồ sơ nguồn cụ thể; tài liệu cố ý không bịa đồng loạt.

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
