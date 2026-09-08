---
aliases:
  - Lược đồ trạng thái và sự kiện
  - K0.1
tags:
  - thiet-ke
  - du-lieu
  - kien-truc
status: de-xuat
---

# Lược đồ trạng thái, sự kiện và fixture — K0.1

Ngày: 2026-09-05. Nối [[LIEN_KET_HE_THONG]], [[THOI_GIAN]], [[HANH_DONG]], [[BAN_CHOI_THU]] và [[KIEM_TOAN_TICH_HOP]]. Đây là đặc tả khái niệm, chưa chọn ngôn ngữ, cơ sở dữ liệu hoặc định dạng tệp cuối; chưa có dữ liệu máy hay mã nguồn.

## 1. Mục tiêu

Lược đồ phải trả lời được sáu câu hỏi cho mọi thay đổi: cái gì tồn tại, ở đâu, thuộc quyền ai, đang ở trạng thái nào, vì sao thay đổi, và thay đổi đã áp dụng chưa. Cùng một bản lưu, phiên bản nội dung, lệnh và hạt ngẫu nhiên phải cho cùng kết quả.

Thiết kế ưu tiên một nguồn dữ liệu cho mỗi sự thật. Giao diện, NPC và nhật ký đọc hoặc tạo yêu cầu; chúng không giữ bản sao có quyền sửa độc lập. Dữ liệu toàn tri dùng kiểm chứng tách khỏi điều nhân vật biết.

## 2. Đầu tệp thế giới

| Trường | Ý nghĩa |
| --- | --- |
| schema_version | Phiên bản hình dạng dữ liệu |
| content_version | Phiên bản mẫu vật, công pháp, hành động và hệ số |
| world_id | Danh tính thế giới, không đổi khi lưu nhiều lần |
| snapshot_id | Danh tính ảnh trạng thái cụ thể |
| parent_snapshot_id | Nguồn của bản sao/nhánh kiểm chứng nếu có |
| now_ms | Thời điểm game hiện tại bằng mili giây nguyên |
| created_from | INIT-A hoặc fixture/ảnh trạng thái nguồn |
| global_seed | Hạt gốc; không dùng trực tiếp thay mọi luồng ngẫu nhiên |
| pending_event_head | Mốc sự kiện gần nhất để kiểm tra tính nhất quán |
| applied_transaction_set | Mã giao dịch đã áp dụng, chống chạy lại |
| content_manifest | Danh sách mẫu và phiên bản thật sự được bản lưu tham chiếu |

Mốc quy ước: ngày 1 lúc 00:00 có `now_ms = 0`; INIT-A lúc 06:00 có `now_ms = 21.600.000`. Không lưu “ngày 1, sáng” như nguồn thời gian thật; đó là cách hiển thị suy ra.

## 3. Đơn vị cơ sở và số nguyên

| Đại lượng | Đơn vị lưu đề xuất | Ví dụ |
| --- | --- | --- |
| Thời gian | ms | 10 phút = 600.000 ms |
| Khối lượng | mg | 500 g = 500.000 mg |
| Chiều dài/vị trí | mm | D01–D02 = 200.000 mm |
| Nước | ml | Bình đầy = 2.000 ml |
| Tiền V01 | đồng nguyên | 40 đồng = 40 vật V01 nếu giữ mô hình tiền vật chất |
| Linh lực | mLinh, bằng 1/1.000 L | 4,8 L = 4.800 mLinh |
| Tỉ lệ 0–1 | phần nghìn 0–1.000 | c = 0,85 lưu 850 |
| Góc | một phần nghìn độ | 180° = 180.000 |
| Điểm stress | số nguyên | Gói V29 = 60 |

Không dùng số thực làm trạng thái chuẩn. Phần dư của tích phân được giữ trong trường dư theo đơn vị nhỏ hơn hoặc bộ đếm phân số có tử/mẫu nguyên. Hiển thị có thể làm tròn nhưng không ghi giá trị đã làm tròn trở lại trạng thái.

Mọi trường lượng kèm loại đơn vị trong mẫu. Không cộng 2.000 ml nước với 2.000 mLinh chỉ vì cùng là số 2.000. Chuyển đổi chỉ qua quy tắc có mã và phiên bản.

## 4. Mã định danh có miền

Mã đầy đủ dùng dạng `miền:mã`, ví dụ `person:P00`, `location:D01`, `item_type:V12`, `item:I0042`, `lot:L0107`, `contract:C01`, `action:A0031`, `event:E0902`, `transaction:X0044`. Nhờ miền, C01 hợp đồng không xung đột C của điều khiển công pháp hoặc mã mô.

Mã của đối tượng đã tồn tại không được tái sử dụng sau khi đối tượng bị phá hủy/chết. Đổi tên hiển thị không đổi mã. Mẫu nội dung và vật thể cụ thể có mã khác nhau; `item_type:V29` không phải một trong hai thanh kiếm `item:I...`.

Mỗi tham chiếu ghi loại đích mong đợi. Tải thất bại rõ nếu `holder_id` trỏ tới địa điểm hoặc mã không tồn tại; không tự sửa bằng cách tìm tên gần giống.

## 5. Các kho hồ sơ chuẩn

| Kho hồ sơ | Trường cốt lõi | Chủ quản |
| --- | --- | --- |
| Entity | id, loại, mẫu, trạng thái tồn tại, phiên bản | Thế giới |
| Person | entity, tên, tuổi, vai trò, trạng thái quyết định | NPC/người chơi |
| Body | chủ thể, cây bộ phận, mô, F/S/E/W, thương tích | Cơ thể |
| Cultivation | P/B/D/R, K/C/A theo công pháp/tuyến, tiến trình | Tu luyện |
| Location | vùng, địa điểm, cổng nối, hình học cục bộ | Môi trường |
| Position | đúng một dạng vị trí đang hoạt động | Vị trí thế giới |
| Item/Lot | loại, lượng, thành phần, tình trạng, cấu tạo | Vật phẩm |
| Containment | vật chứa, món con, vị trí xếp, trạng thái mở | Vật phẩm |
| ResourcePool | nguồn, lượng, sức chứa, dòng vào/ra | Hệ sở hữu nguồn |
| Right | chủ thể, đối tượng, hành vi được phép, giới hạn, hiệu lực | Kinh tế/tổ chức |
| Claim | tuyên bố sở hữu/thế chấp có nguồn và trạng thái công nhận | Kinh tế/tổ chức |
| Contract | các bên, nghĩa vụ, hạn, điều kiện nghiệm thu/vi phạm | Kinh tế/tổ chức |
| Goal | nguồn mục tiêu, ưu tiên, giới hạn, điều kiện kết thúc | Hành động/NPC |
| Action | chủ thể, pha, tiến độ, chiếm năng lực, điều kiện | Hành động |
| Reservation | nguồn bị giữ, lượng, mục đích, hạn | Hệ giữ tài nguyên |
| Knowledge | chủ thể, nội dung/niềm tin, nguồn, thời điểm, độ tin | NPC/nhận thức |
| Relation | A→B, từng chiều quan hệ, sự kiện nguồn | NPC |
| ScheduledEvent | thời điểm, pha, loại, dữ liệu, điều kiện còn hiệu lực | Thời gian |
| FactEvent | điều đã xảy ra, nguyên nhân, thay đổi và quan sát | Nhật ký thế giới |
| Transaction | tiền/vật/năng lượng/quyền đổi cùng một lần | Điều phối giao dịch |

Hồ sơ chuyên môn giữ trạng thái thật; bản tóm tắt giao diện không nằm trong kho chuẩn. Một giá trị suy ra như G tay trái có thể được lưu đệm với phiên bản đầu vào, nhưng khi đầu vào đổi thì đệm hết hiệu lực; nó không trở thành thanh HP thứ hai.

## 6. Một vị trí thật duy nhất

`Position` là một hợp kiểu, tại một thời điểm chỉ có đúng một nhánh:

- trong địa điểm: `location_id`, x/y/z cục bộ, hướng, tư thế;
- trên tuyến: `edge_id`, hướng đi, quãng đã đi mm, làn/đoàn nếu có;
- được chứa/gắn: `container_id` hoặc `body_slot_id`, vị trí suy từ vật chủ;
- đã rời thế giới khả dụng: lý do như tiêu thụ/chuyển hóa/phá hủy cùng sự kiện nguồn.

Một bình trong túi không đồng thời có tọa độ độc lập ở D02; vị trí suy qua chuỗi chứa. Chuỗi chứa phải là đồ thị không vòng. Người ở trên tuyến không đồng thời ở cả hai đầu; tới cổng mới chuyển cách biểu diễn bằng một giao dịch vị trí.

Đồ rơi trong INIT-E nhận tọa độ từ tay tại mốc rơi. Hàng đã bán nhưng chưa giao có quyền mới và vị trí cũ; không dùng trường sở hữu để giả đã vận chuyển.

## 7. Sự kiện dự kiến và sự kiện đã xảy ra

`ScheduledEvent` là việc cần xét trong tương lai: hoàn tất hành động, nguồn bổ sung, mốc thiếu nước, hết giữ chỗ. Nó có `status = pending/cancelled/consumed`, `due_ms`, pha, điều kiện phiên bản và mã nguyên nhân.

`FactEvent` là hồ sơ bất biến sau khi xử lý: thời điểm, loại, chủ thể/đối tượng, `caused_by`, `correlation_id`, giao dịch đã áp, dữ kiện công cụ kiểm chứng và danh sách quan sát có thể được tạo. Hủy một lịch tương lai tạo sự kiện hủy; không xóa dấu vết nếu đã được đối tượng khác tham chiếu.

Một sự kiện dự kiến bị lỗi phiên bản vì mô/vật đã đổi phải kết thúc `consumed_without_effect` kèm lý do. Nó không âm thầm biến mất và không chữa mô mới bằng lịch hồi phục cũ.

## 8. Thứ tự một mốc thời gian

Mọi sự kiện cùng `due_ms = t` được gom trước khi xử lý. Thứ tự pha chuẩn:

| Pha | Việc xử lý |
| ---: | --- |
| 10 | Tích phân quá trình liên tục trên khoảng trước t; cập nhật vị trí chuyển động tới t |
| 20 | Hết hiệu lực các trạng thái có khoảng `[bắt đầu, t)` |
| 30 | Kiểm tra điều kiện, quyền, giữ chỗ và phân bổ nguồn tranh chấp |
| 40 | Chụp trạng thái đầu nhóm; giải quyết tác động tức thời cùng lúc |
| 50 | Gộp hậu quả của nhóm tác động và cam kết giao dịch hợp lệ |
| 60 | Hoàn tất hành động/quá trình tại t; kích hoạt hiệu ứng duy trì mới |
| 70 | Tính lại chức năng, tạo quan sát/thông báo và sự kiện phát sinh |
| 80 | Đánh giá mục tiêu, nhận lệnh mới và lên lịch bước tiếp |

Vì pha 40 đứng trước 60, thế đỡ hoàn tất đúng t chưa bảo vệ nhóm tác động t; vị trí của một né đang chuyển động vẫn đã được tích phân tới t ở pha 10. Đây là một quy ước thống nhất, không dùng `event_id` để quyết định ai đánh trước.

Trong pha 30, tranh một nguồn dùng chính sách lưu trên nguồn/hợp đồng: quyền ưu tiên, thời điểm cam kết, luân phiên hoặc chia dòng. Nếu chính sách không phân xử được, giao dịch liên quan bị từ chối/chờ; không ưu tiên mã nhỏ hơn.

## 9. Giao dịch nguyên tử và chống áp dụng lặp

Một `Transaction` có:

- `transaction_id` và `idempotency_key` duy nhất;
- trạng thái đề nghị/đã giữ/đã cam kết/bị từ chối/đã đảo bằng giao dịch mới;
- phiên bản mong đợi của mọi bản ghi sẽ sửa;
- điều kiện quyền, vị trí, lượng và năng lực;
- danh sách ghi nợ, ghi có, di chuyển, đổi quyền, đổi tình trạng;
- sự kiện nguyên nhân và kết quả quan sát được.

Tất cả điều kiện đúng thì mọi thay đổi cùng cam kết; một điều kiện sai thì không thay đổi phần nào. Mua hàng không được trừ tiền nhưng quên chuyển quyền; B-CARE không được gắn băng khi kho chưa mất băng; HH-C không được trừ P hai lần.

Đảo một giao dịch đã xảy ra cần giao dịch bù có nguyên nhân, không xóa lịch sử. Tải lại thấy `idempotency_key` đã áp thì trả kết quả cũ, không phát tiền/sản phẩm lần nữa.

## 10. Ngẫu nhiên có thể tái hiện

Mỗi fixture có `global_seed`. Mỗi quá trình ngẫu nhiên tạo luồng riêng từ mã thế giới + miền hệ + đối tượng + sự kiện nguồn; giữ `draw_index`. Kết quả quan trọng như sai lệch quỹ đạo INIT-E được ghi vào FactEvent khi rút.

Không dùng một luồng toàn cục khiến việc thêm tiếng chim làm đổi kết quả đột phá. Không rút số khi chỉ mở bảng, ước lượng giao diện hoặc kiểm tra điều kiện chưa cam kết. Tải lại dùng kết quả đã lưu hoặc cùng luồng/chỉ số, không rút lần nữa.

## 11. Ảnh lưu và chuyển phiên bản

Một ảnh lưu gồm đầu tệp, toàn bộ hồ sơ sống/còn được tham chiếu, hàng đợi sự kiện, giao dịch đang giữ, tập mã đã áp, bộ đếm ngẫu nhiên, và lịch sử tối thiểu mà quyền/niềm tin/hợp đồng còn trỏ tới.

Quy trình tải đề xuất: kiểm tra phiên bản → kiểm tra tham chiếu/đơn vị → áp chuyển đổi dữ liệu đã khai báo → xây lại giá trị suy ra → đối chiếu tổng/điều kiện bất biến → chỉ sau đó cho thời gian chạy. Không tự gắn mẫu nội dung mới vào vật cũ nếu thiếu quy tắc chuyển.

Ảnh lưu giữa pha phải giữ đúng pha, tiến độ và lượng đã chuyển. Snapshot không thay FactEvent; nhật ký có thể được tóm nhưng các nguồn còn được tham chiếu phải sống dưới dạng tối thiểu.

## 12. Cấu trúc fixture chuẩn

| Phần | Nội dung bắt buộc |
| --- | --- |
| Metadata | fixture_id, phiên bản, mục đích, chuỗi A–E, trạng thái hoàn thiện |
| Base | snapshot/INIT nguồn và content_manifest |
| Overlay | chỉ những bản ghi thêm/sửa; không sửa ngầm base |
| Clock/RNG | now_ms, global_seed, các kết quả cố định nếu cần |
| Participants | người/vật/nguồn bắt buộc và vai trò trong test |
| Preconditions | tham chiếu, quyền, vị trí, lượng, trạng thái cơ thể/kiến thức |
| Injected events | biến cố thử có nhãn `synthetic_test_input = true` |
| Commands | lệnh người chơi hoặc chính sách NPC được đưa vào |
| Run window | thời điểm bắt đầu, kết thúc hoặc điều kiện dừng |
| Assertions | sự thật thế giới, điều từng người biết, lượng, vị trí và trạng thái việc |
| Invariants | không âm, không nhân đôi, một vị trí, tổng nguồn, không lộ tri thức |
| Allowed branches | kết quả hợp lệ nếu test nhằm kiểm tra tự chủ thay vì đường đi duy nhất |
| Unsupported guard | hành vi phải báo chưa hỗ trợ, không kể bù |

Fixture kế thừa theo `base + overlay`, không sao chép rồi để hai bản lệch âm thầm. Overlay ghi phiên bản bản ghi cũ mà nó mong đợi; base đổi thì fixture phải kiểm tra lại.

Assertion có hai dạng. Assertion chính xác dùng cho sổ lượng, mốc thời gian và fixture tái hiện. Assertion thuộc tính dùng cho hành vi tự chủ: ví dụ “không dùng tri thức chưa biết” hoặc “chỉ một người nhận món”, không ép NPC chọn đúng câu chuyện tác giả mong muốn nếu nhiều phương án hợp lệ.

## 13. Danh mục fixture A–E

| Fixture đề xuất | Base/overlay | Mục tiêu | Tình trạng hiện tại |
| --- | --- | --- | --- |
| FX-A-BOOT | INIT-A | Từ D02 hỏi đường/tìm việc tới hợp đồng đầu | Khép kín trên giấy tại [[DU_LIEU_LIEN_KET_K0]] |
| FX-A-DAY | Kết quả A-BOOT hoặc overlay đã biết/đã nhận J01 | Kiểm tra ngày 24 giờ, nhu cầu, tiến độ, nghiệm thu | Có mô tả, chưa thành dữ liệu máy |
| FX-A-30D | INIT-A + lịch nguồn/giao nhận | Kiểm tra 630 suất, tiền và 21 người | K1.1–K1.4 có lịch, nguồn, sổ và tám nhánh lỗi; chưa thành dữ liệu máy |
| FX-B-LOCAL | INIT-A + overlay tại D03 | W-B01, J02 dở và B-CARE tại chỗ | Khép kín trên giấy tại [[CHAM_SOC_K0]] |
| FX-B-REMOTE | Overlay P00 tại D06 có tri thức đường/y quán | Tìm chăm sóc theo vị trí/nhận biết | Khép kín trên giấy tại [[CHAM_SOC_K0]] |
| FX-C-MSG | INIT-A + chuyến qua cầu + người đưa tin | Tin tới làm đổi phản ứng đúng lúc | Khép kín trên giấy tại [[DU_LIEU_LIEN_KET_K0]] |
| FX-C-NOMSG | Cùng base/seed với C-MSG, bỏ hành động báo tin | So nhận thức khi sự thật giống nhau | Khép kín trên giấy tại [[DU_LIEU_LIEN_KET_K0]] |
| FX-D-SHARED | INIT-D | Hai người chia 6 L | Khép kín trên giấy |
| FX-D-LEAVE | INIT-D + lệnh N14 rời sau 30 phút | Tích phân/phân bổ lại nguồn | Khép kín trên giấy |
| FX-D-MARK | TM-01 | Chuyển M0→M1 và ngắt sau cam kết | Khép kín trên giấy |
| FX-E-GUARD | INIT-E | Đỡ hoàn tất trước tiếp xúc | Khép kín trên giấy |
| FX-E-SAME | INIT-E, đổi giờ bắt đầu đỡ | Hiệu ứng hoàn tất cùng mốc | Khép kín trên giấy |
| FX-E-DODGE | INIT-E, đổi phản ứng | Vị trí liên tục làm đòn trượt | Khép kín trên giấy |
| FX-E-BOTH | INIT-E, thêm đòn đối ứng | Hai tác động cùng mốc | Đủ mô tả một phần |
| FX-E-LINH | Overlay chủ thể biết ứng dụng, P=4 L | Gói bay và HH-C hoàn/ngắt | Khép kín nguồn, chưa có hiệu ứng đẩy |

Không gọi hàng “khép kín trên giấy” là fixture chạy được cho tới khi có bản ghi theo lược đồ và bộ xử lý thật.

## 14. Điều kiện bất biến cần kiểm tra

| Mã | Điều kiện |
| --- | --- |
| DS01 | Mọi id duy nhất trong miền; mọi tham chiếu đúng loại và tồn tại |
| DS02 | Mỗi thực thể vật lý có đúng một Position hoạt động |
| DS03 | Đồ thị chứa/gắn không có vòng; khối lượng phần chứa không cộng hai lần |
| DS04 | Lượng vật/nước/tiền/P/B/nguồn không âm và không vượt trần nếu không có trạng thái tràn |
| DS05 | Mỗi Transaction áp tối đa một lần; trạng thái kết thúc không phát lại đầu ra |
| DS06 | Tổng chuyển đổi khớp đầu vào/đầu ra/thất thoát theo quy tắc phiên bản |
| DS07 | Quyền hết hạn hoặc chưa được biết không tự biến thành quyền thực thi từ xa |
| DS08 | Contract có các bên tồn tại, nghĩa vụ và điều kiện kết thúc rõ |
| DS09 | Action đang chạy chiếm năng lực/vật thật và có điều kiện duy trì |
| DS10 | ScheduledEvent không tác động bản ghi sai phiên bản mà không báo lý do |
| DS11 | Knowledge không chứa sự thật vượt nguồn quan sát/truyền tin hợp lệ |
| DS12 | Cùng mốc tuân pha; thứ tự id không đổi kết quả nhóm tác động |
| DS13 | RNG không đổi do giao diện hoặc hệ không liên quan |
| DS14 | Snapshot tải lại giữ hàng đợi, pha, phần dư và tập giao dịch đã áp |
| DS15 | Overlay fixture không sửa base ngoài các trường được liệt kê |
| DS16 | Hành vi chưa hỗ trợ dừng có lý do, không tự sinh kết quả bằng lời kể |

DS là tiêu chí cho dữ liệu/kiến trúc tương lai, chưa được chạy.

## 15. Ranh giới giữa trạng thái thật và giao diện

Công cụ kiểm chứng có thể xem mọi bản ghi, tổng nguồn và chuỗi nguyên nhân. Giao diện chơi chỉ nhận `Observation/Knowledge` của P00 và các tóm tắt suy ra từ đó. Mã nội bộ, P của NPC, nội dung hợp đồng bí mật hoặc vị trí chưa biết không được rò qua thông báo “việc tối ưu”.

Một log cho người chơi ghi “nghe tiếng va ở phía đông” nếu đó là quan sát; log kiểm chứng có thể ghi chính xác `event:E...` tại tọa độ. Hai log cùng trỏ một FactEvent nhưng không có cùng nội dung.

## 16. Trạng thái K0

[[DU_LIEU_LIEN_KET_K0]] đã đề xuất tiền V01 vật chất, A-BOOT, chuyến C và lịch giao nhận/nước. [[CHAM_SOC_K0]] đã bổ sung vòng đời chăm sóc K0.6, đích dịch và hồi phục W-E. Sáu việc K0 đã có mô tả trên giấy; toàn bộ vẫn chưa thành lược đồ máy hoặc được chạy.

Định dạng tệp, cơ sở dữ liệu, ngôn ngữ và chiến lược lưu lịch sử chưa được chọn. Trước lập trình cần biến bảng khái niệm thành lược đồ máy có kiểm tra, nhưng chỉ khi người dùng yêu cầu chuyển sang triển khai.

## 17. Bước kế hoạch tiếp theo

K0–K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
