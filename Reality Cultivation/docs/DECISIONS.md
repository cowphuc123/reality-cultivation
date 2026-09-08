# Yêu cầu, đề xuất và câu hỏi mở

Cập nhật: 2026-09-08.

## Yêu cầu do người dùng nêu

| ID | Nội dung | Nguồn |
| --- | --- | --- |
| U001 | Game tu tiên chân thật, cực kỳ chi tiết; dùng text, không cần đồ họa | Yêu cầu đầu tiên |
| U002 | Mô phỏng liên tục, 5 giây ngoài đời = 1 ngày trong game | Yêu cầu đầu tiên |
| U003 | Người chơi giao công việc và mục tiêu cho nhân vật | Yêu cầu đầu tiên |
| U004 | NPC tồn tại như người thật và có câu chuyện riêng | Yêu cầu đầu tiên |
| U005 | Cơ thể có các bộ phận và thương tích chi tiết | Yêu cầu đầu tiên |
| U006 | Rất nhiều vật phẩm, công dụng và chất lượng khác nhau; rất nhiều công pháp khác biệt | Yêu cầu đầu tiên |
| U007 | Tham vọng chiều sâu vượt Dwarf Fortress và CDDA | Yêu cầu đầu tiên; đây là mục tiêu, chưa phải kết quả được chứng minh |
| U008 | Viết kế hoạch chi tiết trước | Yêu cầu đầu tiên |
| U009 | Lưu tài liệu trong thư mục để có thể tiếp tục về sau, tương tự cách dùng Obsidian | Yêu cầu lưu hồ sơ |
| U010 | Dùng Obsidian và kiểm tra, tổ chức thư mục theo cách đó | Người dùng xác nhận dùng Obsidian, 2026-09-05 |
| U011 | Game phải chơi được trên cả điện thoại và máy tính | Người dùng bổ sung, 2026-09-05 |
| U012 | Game không có cốt truyện chính cố định; diễn biến sinh từ mô phỏng như Dwarf Fortress | Người dùng xác nhận, 2026-09-06 |
| U013 | Khi tạo bản lưu, game sinh thế giới rồi mô phỏng hàng trăm, hàng nghìn hoặc hàng vạn năm không có nhân vật chính; sau đó người chơi chọn vị trí trên bản đồ và nhân vật mới sinh/nhập thế | Người dùng xác nhận, 2026-09-06 |
| U014 | Người chơi điều khiển nhân vật ngay từ lúc sơ sinh; không tóm lược hoặc bỏ qua tuổi thơ | Người dùng xác nhận, 2026-09-06 |
| U015 | Ưu tiên làm GUI đẹp và đầy đủ trước khi tiếp tục mở rộng mô phỏng | Người dùng yêu cầu, 2026-09-07; tiếp tục 2026-09-08 |

## Đề xuất của trợ lý — chưa được người dùng chốt

- Chơi đơn, chạy cục bộ; giao diện trình duyệt bằng chữ, bảng và nút.
- Cho phép tạm dừng và tự dừng khi gặp nguy hiểm hoặc cần quyết định.
- Chưa mô phỏng lúc đóng game trong bản đầu.
- Nhân vật khởi đầu là người thường; thông tin hiển thị theo kiến thức của nhân vật.
- Dùng mô phỏng theo sự kiện và nhiều mức chi tiết cho vùng xa.
- NPC và người chơi dùng chung các hệ thống nền.
- Bản đầu: một làng, vùng hoang dã, cơ sở tu luyện, 20–30 NPC, 30–50 loại vật phẩm, ba công pháp và một lần đột phá.
- Cơ chế kế thừa sau khi chết thiết kế sau.
- AI ngôn ngữ là tùy chọn cho diễn đạt, không bắt buộc để vận hành thế giới.

Các nguyên tắc và giải pháp khác trong MASTER_PLAN.md cũng là thiết kế đề xuất nếu chưa có mục xác nhận ở trên.

## Quy tắc chung cho mọi con số kỹ thuật

Trừ những gì ghi trong bảng U ở trên, **mọi tên, con số, ngưỡng, công thức** xuất hiện trong các đặc tả K0–K5 (tuổi trưởng thành, hệ số nhu cầu, giờ giấc nhịp sống, ngưỡng bệnh, tốc độ, v.v.) là **fixture kỹ thuật do trợ lý đặt để kiểm chứng chuỗi nhân quả hoặc xung đột lịch — chưa được người dùng duyệt làm cân bằng, mô hình y khoa, hay luật chung của thế giới.**

Lịch sử đầy đủ từng lượt việc — tài liệu nào thêm gì, số điều kiện tăng ra sao — nằm trong [[CHANGELOG]] và trong phần mở đầu của mỗi tài liệu K tương ứng. Không cần chép lại ở đây.

## Diễn biến gần nhất

Ngày 2026-09-09: hoàn thành V2.12 tại [[K5_19_V2_12_NGHI_BENH]]. Nghỉ bệnh là **tất cả hoặc không có gì** — chưa có làm nhẹ, làm nửa buổi, hay chuyển khối cố định sang người khác gánh; khối bị bỏ vì nghỉ thì mất hẳn, không làm bù. NPC cũng không tự sửa lịch của mình cho nhẹ hơn vì bảng giờ vẫn là dữ liệu cố định. Luật nghỉ là "tới khi khỏi hẳn" chứ không theo mức nặng, vì một lượt chăm hạ mức nặng trong bốn mươi phút khiến ngưỡng theo mức nặng vô dụng. Lượt chạy cho một kết quả không đặt trước và cần ghi lại: nghỉ **không cứu được lịch vốn không bền** — người làm 10,3 giờ/ngày vẫn ốm lại, và cuối kỳ còn đỡ mệt hơn người làm 6 giờ vì được nghỉ nhiều hơn. Đã bỏ một đoạn code chết không bao giờ với tay được. Hash V2.11 đổi `e81de5a0e3d29c55` → `beabb8f20438f377`.

Ngày 2026-09-09: hoàn thành V2.11 tại [[K5_18_V2_11_BENH_CUA_NGUOI_LON]]. Bệnh người lớn khởi phát theo **ngưỡng xác định** (nước ≤ 700, mệt ≥ 900) chứ không theo xác suất, vì dự án chưa có bộ sinh số ngẫu nhiên theo seed — bịa ngẫu nhiên tại đây sẽ phá tính tái lập mà 16 bộ chạy đang dựa vào; xác suất theo seed thuộc về K2.1. **Ốm chưa làm người ta nghỉ việc**: bệnh nâng ngưỡng nhận việc mới nhưng không hủy khối đã có trong bảng giờ, nên người kiệt sức được chăm rồi vẫn làm tiếp và ốm lại — hành vi thật của mô hình, và là chỗ hở lớn nhất. Chưa có lây bệnh, thuốc, thầy thuốc, thương tích, già đi hay chết; kỹ năng chăm sóc chỉ dùng để chọn người, không ảnh hưởng kết quả chữa. Ngưỡng 700/900, sàn mức nặng 300/250, trần 800/600, 400 ml mỗi lượt chăm và tỉ lệ "mức bệnh chia hai lấy đi sức" đều là fixture chưa duyệt và **không phải mô hình y khoa**. Mười lăm runner V0–V2.10 giữ nguyên hash.

Ngày 2026-09-09: hoàn thành V2.10 tại [[K5_17_V2_10_HAI_CHIEU_VA_NGA_RE]]. Vị trí nay có hai chiều, làm nền cho U013 (chọn nơi trên bản đồ) và K4.4 (địa lý) — nhưng **chưa ai dùng ngoài tuyến vận tải**, chưa có bản đồ hay vùng. Trục thứ hai để tùy chọn nên 14 hash cũ giữ nguyên; đây là lựa chọn có chủ đích để không mất tín hiệu phát hiện hồi quy. Đồ thị đường đi viết sẵn trong fixture, chưa sinh từ địa hình; chọn đường giả định địa hình không đổi, chưa có mưa/mùa/đêm; người chở chỉ chọn một lần lúc khởi hành. Ba mức địa hình 100/40/60 phần trăm và yêu cầu sức 300/600 cho đèo/suối là fixture chưa duyệt. Đã sửa lỗi từ V2.7 khiến `healthy_mass_g` bị bỏ qua nếu không kèm dự trữ — người khai là gầy vẫn được coi là đủ sức; sửa xong không đổi hash nào. Hash V2.9 đổi `a89dc7db61e7173d` → `a4830eb8844ec469` vì chuyến hàng nay lưu đường đã chọn.

Ngày 2026-09-08: hoàn thành V2.9 tại [[K5_16_V2_9_TUYEN_VAN_TAI_THAT]]. Vị trí vẫn là **một trục một chiều**, nên tuyến chưa có ngã ba, đường vòng hay chọn tuyến; địa hình là hệ số cố định gắn vào chặng, chưa có mưa/mùa/đêm. Người chở đi một mạch không ăn uống dọc đường; chưa có cướp đường, hỏng hàng, phương tiện hay giá cả ở chợ. Các hệ số 1.200 mm/s đường bằng, 40 kg sức mang, chậm tối đa 40% khi đầy tải và ba mức địa hình 100/40/60 phần trăm đều là fixture chưa duyệt. Mười ba runner V0–V2.8 giữ nguyên hash vì nhánh tuyến thật là đường riêng.

Ngày 2026-09-08: người dùng đổi cách làm — từ nay **không commit/push/build web sau mỗi lát cắt**, chỉ đẩy lên GitHub khi được yêu cầu. Lý do là tiết kiệm phần "loay hoay xác nhận đã lên GitHub" chứ không phải bản thân việc đẩy. Việc cập nhật hồ sơ Obsidian và chạy kiểm chứng vẫn làm như cũ sau mỗi lát cắt.

Ngày 2026-09-08: hoàn thành V2.8 tại [[K5_15_V2_8_NUOC_VA_CON_KHAT]]. **Cố ý không làm thân nhiệt người lớn** dù bước tiếp trước có ghi: chưa có mùa, thời tiết hay nhiệt độ môi trường nào để thân nhiệt phản ứng lại, nên làm bây giờ là bịa ra một con số vô nghĩa. Thân nhiệt thuộc về mô hình môi trường K4.4 chứ không phải một trường thêm vào cơ thể. Nước vẫn chỉ đổi mỗi ngày một lần, chưa có nước bẩn hay bệnh do nước. Ngưỡng 90%/80% cho sức theo nước, trần uống 3.500 ml/ngày, 2.500 ml mỗi người trong tính nhu cầu và trọng số khát/15 đều là fixture chưa duyệt. Hash V2.7 đổi `e59171aea8e9867b` → `dc54cde35203486a` vì đó là fixture duy nhất có cơ thể; đây là mở rộng mô hình có chủ đích, không phải sửa lỗi.

Ngày 2026-09-08: hoàn thành V2.7 tại [[K5_14_V2_7_CO_THE_NGUOI_LON]]. Cơ thể người lớn chạy ở **độ phân giải ngày**, không phải từng giờ như trẻ sơ sinh — nên trong ngày không ai đói giữa buổi hay kiệt sức đột ngột. Nước cơ thể được theo dõi nhưng **chưa có hậu quả**; chưa có thân nhiệt, bệnh, thương tích, già đi hay chết của người lớn. Suất ăn chia đều tuyệt đối, chưa ai được ưu tiên hay nhường phần. Các hệ số 1.400 kJ/100 g, nền 5.500 kJ/ngày, 200 kJ/giờ, 30 kJ mỗi gam sụt, 45 kJ mỗi gam lên và dải sức làm việc 70–100% cân nặng đều là fixture — **không phải mô hình dinh dưỡng y khoa**. Mười một runner V0–V2.6 giữ nguyên hash.

Ngày 2026-09-08: hoàn thành V2.6 tại [[K5_13_V2_6_LEN_TAY_NGHE_DOI_VA_TAM_TRANG]]. Đói hiện chỉ đổi ở mốc bữa ăn chứ không trôi liên tục, mọi người lớn ăn như nhau, và **đói chưa gây hậu quả thể chất** — chỉ làm khó nhận việc. Tâm trạng chỉ có ba nguồn (hụt bữa, việc bị cắt, ngủ); chưa có quan hệ giữa người với người và từ chối vẫn không có hậu quả xã hội. Các hệ số ±220/400 cho đói, ±400/250 cho mệt, chia 10/20/25 cho ngưỡng và mẫu số 576.000 cho lên tay nghề đều là fixture chưa duyệt. Đã sửa lỗi ghi đè mất mệt mỏi/tay nghề nên hash runner V2.5 đổi `9d3521d32a5b66b6` → `29bf49642c71fb18`; chín runner V0–V2.4 giữ nguyên vì mọi thứ mới đều nằm sau cờ `enable_v2_6`.

Ngày 2026-09-08: hoàn thành V2.5 tại [[K5_12_V2_5_KY_NANG_NGHE_VA_QUYEN_TU_CHOI]]. NPC nay có tay nghề và quyền từ chối việc, nhưng **mệt mỏi là trục duy nhất** dẫn tới từ chối — chưa có đói, đau, tâm trạng, quan hệ hay mục tiêu cá nhân dài hạn, và từ chối chưa có hậu quả xã hội. Tay nghề là số cố định, chưa lên theo số lần làm. Ngưỡng nhận việc bằng mệt chia mười, nghề tối thiểu 200, dải sản lượng 60–100%, hồi 250 mỗi đêm và tăng 400 cho tám giờ đều là fixture chưa duyệt. Chín runner V0–V2.4 giữ nguyên hash vì mọi tính năng mới đều gắn với trường dữ liệu mới.

Ngày 2026-09-08: hoàn thành V2.4 tại [[K5_11_V2_4_NHU_CAU_SINH_VIEC_VA_UU_TIEN]]. Kế hoạch nay là của **hộ**, chưa phải của từng NPC: chưa có mục tiêu cá nhân, chưa thương lượng, chưa từ chối việc, và chưa có mô hình kỹ năng nghề nên người nấu ăn có thể bị giao đi kiếm củi nếu rảnh hơn. Ngưỡng 12 ngày dự trữ, nhịp tiêu thụ, thời lượng/sản lượng từng loại việc là fixture chưa duyệt. Đã sửa lỗi nuốt khối của V2.3 nên hash runner V2.3 đổi từ `8df759ae2a42eca0` sang `ade0b8a4300276c9`; đây là hệ quả sửa lỗi, mọi điều kiện V2.3 vẫn đạt.

Ngày 2026-09-08: hoàn thành V2.3 tại [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]]. Nhịp sống hiện là bảng giờ cố định, **không phải** kế hoạch NPC tự lập — không giảm tham vọng NPC tự trị của U004/K4.6. Trường `priority` có trong dữ liệu nhưng chưa dùng để phân xử. Việc mở hồ sơ toàn thế giới đáp ứng U015 ở phạm vi dữ liệu đã mô phỏng, không tạo số liệu cho hệ chưa có.

Ngày 2026-09-08: đăng kho công khai `github.com/cowphuc123/reality-cultivation` và bản web tự động tại `cowphuc123.github.io/reality-cultivation` qua GitHub Actions. Đây là hạ tầng lưu trữ/phân phối, không phải quyết định thiết kế.

TN01–TN08 ([[LUA_CHON_TRAI_NGHIEM]]) và ADR công nghệ (S2 Dart/Flutter đang PROPOSED) vẫn mở.

## Câu hỏi mở

1. Tốc độ 5 giây/ngày có được thay đổi, tạm dừng và tự dừng không?
2. Thế giới có tiến triển lúc đóng game không; nếu có, xử lý rủi ro thế nào?
3. Giới hạn điều khiển trực tiếp so với giao mục tiêu?
4. Hệ cảnh giới, bản chất linh khí, kinh mạch và quy luật đột phá?
5. Mức giải phẫu và độ chi tiết sinh lý cần có ở từng chặng?
6. Quy mô NPC và thế giới mục tiêu, cấu hình máy dùng để kiểm chứng hiệu năng?
7. Cái chết, tải lại, kế thừa và mức độ khắc nghiệt?
8. Chốt công nghệ sau khi đặc tả nền đủ rõ.

Tám lựa chọn trải nghiệm TN01–TN08 (dừng, mô phỏng khi đóng, quyền tự chủ nhân vật, v.v.) nằm tại [[LUA_CHON_TRAI_NGHIEM]], vẫn chưa có phản hồi xác nhận.

## Cách cập nhật

Khi người dùng xác nhận hoặc thay đổi một lựa chọn: ghi ngày, nội dung và lý do nếu có vào mục "Diễn biến gần nhất" ở trên; cập nhật bảng U nếu là yêu cầu mới; cập nhật MASTER_PLAN.md tương ứng. Không xóa dấu vết quyết định cũ quan trọng — đánh dấu được thay thế và liên kết quyết định mới. Chi tiết kỹ thuật của từng lượt việc ghi vào CHANGELOG.md, không lặp lại ở đây.
