# Nhật ký dự án

## 2026-09-08 — K5.12: V2.5 kỹ năng nghề, quyền từ chối và xếp lại lịch

- Thêm `PersonSkills`: mỗi người có tay nghề theo mã việc (0–1000). Phải vừa có quyền dùng kho vừa đủ nghề tối thiểu 200 mới được giao; xếp theo nghề cao trước rồi tới người rảnh hơn.
- Chữa cái dở của V2.4: người nấu ăn tay nghề kiếm củi 150 nay bị loại khỏi việc kiếm củi dù vẫn giữ quyền dùng kho. Việc về tay người làm công nghề 850.
- Sản lượng theo tay nghề: nghề 0 làm được 60% mức gốc, nghề 1000 làm đủ 100%. Nghề 850 cho 2.256 g thay vì 2.400 g.
- Thêm `PersonAgenda`: mức mệt 0–1000, ngưỡng nhận việc bằng mệt chia mười. Người mệt 600 nhận việc ưu tiên 69 nhưng từ chối việc ưu tiên 48; việc bị từ chối được chào tiếp cho người sau chứ không bỏ lửng.
- Mệt là số thật: trọn tám giờ cộng 400, ngủ một đêm hồi 250. Cả nhà kiệt sức thì hộ ghi thiếu người, không ép ai làm.
- Việc bị lùi hết ba lượt nay được **xếp lại** vào giờ trống còn lại trong ngày thay vì bỏ hẳn; bản xếp lại là khối riêng của ngày nên bảng giờ gốc không đổi và không lặp vô hạn.
- Runner V2.5 đạt ngày 4 hash `9d3521d32a5b66b6`; lưu sau lần từ chối tái hiện đúng. Catalog 22 điều kiện.
- **Chín runner V0–V2.4 giữ nguyên hash** — mọi tính năng mới gắn với trường dữ liệu mới nên thế giới cũ không đổi hành vi.
- GUI: hồ sơ riêng hiện tay nghề, mức mệt, ngưỡng nhận việc và lý do từ chối; trang Hộ thêm ô đo Từ chối việc; 9/9 widget test đạt; web release đã đóng gói lại.
- Thêm [[K5_12_V2_5_KY_NANG_NGHE_VA_QUYEN_TU_CHOI]].

## 2026-09-08 — K5.11: V2.4 nhu cầu sinh việc và ưu tiên phân xử

- Hộ tự tính số ngày dự trữ từ tồn kho thật rồi sinh nhu cầu; mức gấp thành ưu tiên của khối việc. Củi 5 ngày (ưu tiên 69), nước 8 ngày (56), lương thực 10 ngày (48).
- Kế hoạch mỗi sáng 05:00 giao việc theo quyền dùng kho và giờ trống, chia cho ba người thay vì dồn một người; không ai đủ quyền thì ghi `household_need_unstaffed` chứ không bịa.
- `priority` nay thật sự phân xử: việc gấp được xếp đè lên khối ưu tiên thấp hơn và giành chỗ khi chạy (`outranked`); khối yếu hơn lùi giờ tối đa ba lần.
- Làm xong thì hàng vào kho thật; bị cắt ngang thì sản lượng chia theo số giây thật sự làm. Ngày 3 N02 bị điều đi chăm trẻ bệnh giữa khối kiếm lương thực, mất 612 giây nên chỉ giao 2.898/3.000 g.
- **Sửa lỗi nuốt khối**: khối kế tiếp bắt đầu cùng giây khối trước kết thúc thì ghi đè `activeBlockId`, làm khối trước biến mất khỏi sổ. N01 ở V2.3 chỉ được ghi 7/12 khối. Nay đã xử lý rõ ràng; N01 được ghi 11 khối.
- Vì lỗi trên, hash runner V2.3 đổi `8df759ae2a42eca0` → `ade0b8a4300276c9`. Mọi điều kiện V2.3 vẫn đạt; bảy runner V0–V2.2 giữ nguyên hash.
- Runner V2.4 đạt ngày 4 hash `5b36f570a39e4bde`; lưu giữa lúc kế hoạch đang chạy tái hiện đúng. Catalog 23 điều kiện.
- GUI thêm khu vực Nhu cầu & kế hoạch hôm nay trên trang Hộ, bảy nhãn sự kiện tiếng Việt mới; 8/8 widget test đạt; web release đã đóng gói lại.
- Thêm [[K5_11_V2_4_NHU_CAU_SINH_VIEC_VA_UU_TIEN]].

## 2026-09-08 — Rút gọn STATE.md và DECISIONS.md

- STATE.md: thay danh sách tường thuật 30+ mục bằng một bảng bản K5 (V0–V2.3) kèm hash, cộng tóm tắt một dòng cho K0–K4 (1.860 điều kiện/41 họ). 186 dòng → 51 dòng.
- DECISIONS.md: gộp ~40 mục nhật ký theo từng tài liệu K thành một quy tắc chung ("mọi con số kỹ thuật ngoài bảng U là fixture chưa duyệt") cộng mục Diễn biến gần nhất. 200 dòng → 68 dòng.
- Không mất thông tin: lịch sử chi tiết từng lượt việc đã có sẵn trong CHANGELOG.md (mục này) và trong phần mở đầu mỗi tài liệu K; hai file trên giờ chỉ trỏ tới đó thay vì lặp lại.

## 2026-09-08 — K5.10: V2.3 nhịp sống NPC, xung đột lịch và hồ sơ thế giới

- Thêm `RoutineBlock`/`RoutineState`/`ScheduleConflict`: mỗi NPC người lớn có bảng giờ trong ngày, di chuyển thật tới phòng của khối việc và lặp lại hằng ngày.
- Bữa ăn của hộ nay phải chờ khi người nấu đang ở khối chặn: lùi 30 phút mỗi lần, tối đa ba lần; bữa trưa hoàn tất muộn 3.600 giây sau hai lần lùi mà không kéo trôi bữa tối.
- Tiếng khóc, đợt bệnh và những lần nghỉ vì sốt đều cắt ngang khối việc đang chạy và ghi lại số giây công đã mất.
- Mở `QueryPort.directory()` với `PersonProfileView`/`ItemProfileView`: hồ sơ độc lập cho mọi người và mọi vật, kể cả N04 ngoài hộ và khăn quấn ngoài sổ kho.
- Trang Hồ sơ dựng lại thành hai danh bạ người/vật; trang Hộ thêm ô đo xung đột lịch và nhịp sống trong thẻ thành viên; nhật ký thêm bộ lọc Nhịp sống.
- Runner V2.3 đạt ngày 4 với hash `8df759ae2a42eca0`; lưu giữa lúc bữa đang bị lùi tái hiện đúng. Sáu runner V0–V2.2 giữ nguyên hash.
- `dart analyze` và `flutter analyze` sạch; 8/8 widget test đạt; catalog 23 điều kiện; web release đã đóng gói lại.
- Thêm [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]].

## 2026-09-08 — bắt đầu V2.3: hồ sơ NPC và vật phẩm

- Mở rộng cổng truy vấn hộ bằng hồ sơ thành viên và vật phẩm có ID, phòng, hoạt động, tính sẵn sàng, kỹ năng, số lượng, đơn vị và tình trạng.
- Trang Hộ có các thẻ mở rộng để xem dữ liệu thật của từng người và từng kho trên điện thoại/máy tính.
- Dart/Flutter analyze sạch; 6/6 widget test đạt.

## 2026-09-08 — K5.9: V2.2 vận chuyển, bệnh sinh lý và người thay

- Thay tiếp tế tức thời bằng `SupplyJourneyState` có người vận chuyển, hàng, chặng, giờ dự kiến/thật và nguyên nhân trễ; chuyến đầu trễ sáu giờ và hàng chỉ nhập kho khi tới thật.
- Thêm tính sẵn sàng/kỹ năng người chăm sóc. Khi N01 vắng mặt, N02 có đủ kỹ năng và quyền thay thế, phát hiện bệnh và chăm P00; hộ ghi số lần thay người.
- Nối mức bệnh vào tick cơ thể theo giờ: tiêu hao thêm năng lượng, mất nước, gián đoạn ngủ và tác động thân nhiệt; đến ngày 4 ghi 84 kJ, 17 ml và 218 phút.
- Runner V2.2 lưu giữa chuyến trễ rồi tái hiện đúng đến ngày 11 với hash `d0b87de633a4765a`; sáu runner cũ V0–V2.1 giữ nguyên hash.
- GUI chiếu tác động bệnh, người thay và hành trình tiếp tế; sửa hai hàng hẹp để không tràn trên điện thoại. Flutter analyze sạch, 6/6 test đạt và web release đã đóng gói.
- Thêm catalog 22 điều kiện và [[K5_9_V2_2_VAN_CHUYEN_BENH_SINH_LY_NGUOI_THAY]].
- Phát hành bản V2.2 lên Sites ở chế độ riêng tư tại `https://reality-cultivation-game.ready-tide-7469.chatgpt.site`; mã nguồn Site và cấu hình phát hành nằm trong `client/`.

## 2026-09-08 — K5.8: V2.1 bệnh nhẹ và đời sống hộ

- Thêm ba phòng có danh tính; người và vật lưu phòng hiện tại cùng tọa độ.
- Thêm bệnh hô hấp nhẹ có khởi phát, triệu chứng, mức nặng, thân nhiệt, phát hiện, chăm sóc và hồi phục theo bước sáu giờ.
- N01 phải đổi lịch, đi tới gian ngủ và dùng 100 ml nước sạch có quyền; thời gian chăm bệnh được ghi vào sổ lao động.
- Thêm sản xuất 1.200 g củi/ngày của N03 và tiếp tế ba kho mỗi năm ngày; mọi thay đổi đi qua vật phẩm thật và có fact.
- Runner V2.1 đạt hash ngày 10 `3d83fc8e0cc7b77f`; save/load giữa lúc bệnh cùng hash. Năm runner cũ giữ nguyên kết quả.
- GUI chiếu phòng, bệnh, tiếp tế, sản xuất và nhật ký tiếng Việt; Flutter analyze sạch, 5/5 test đạt gồm trạng thái bệnh thật ngày 4, web release đã đóng gói lại.
- Thêm nút **Tạo thế giới mới** có xác nhận để thay save cũ bằng lịch V2.1; cập nhật hướng dẫn mở bản test và mốc bệnh mẫu khoảng 17 giây sau khi chạy.
- Thêm [[K5_8_V2_1_BENH_NHE_TIEP_TE_KHONG_GIAN_DOI_LICH]], catalog 18 điều kiện và shared fixture V1 ở trạng thái chờ parity PWA. Tiếp theo V2.2.

## 2026-09-08 — K5.7: làm lại GUI text game

- Thay bố cục một trang dài bằng năm khu vực Hiện tại, Nhân vật, Hộ, Nhật ký và Hồ sơ; giữ Chạy/Dừng luôn ở thanh trên.
- Điện thoại dùng thanh điều hướng dưới; máy tính dùng navigation rail, vùng nội dung giới hạn độ dài dòng và cột tình trạng thế giới ở màn hình rộng.
- Thêm theme xanh rêu–vàng đất, overview P00, cảnh báo chăm sóc, kho tóm tắt, thẻ thành viên/tài nguyên/lao động, timeline có giờ và bốn bộ lọc.
- Diễn đạt các fact phổ biến bằng tiếng Việt; những hệ chưa triển khai được ghi rõ chưa mở, không tạo tính năng hoặc số liệu giả.
- Flutter analyze sạch; 4/4 widget test đạt cho 390×844, 800×600 và 1.280×800, gồm điều hướng, lọc nhật ký, lưu/tải và lifecycle restore. Thêm catalog 12 điều kiện GUI.
- Thêm [[K5_7_GUI_TEXT_GAME_DA_NEN_TANG]]. Tiếp theo quay lại V2.1.

## 2026-09-07 — K5.6: V2.0 hộ gia đình, tài nguyên, quyền và lịch

- Thêm `HouseholdState` cho H01 gồm N01, N02, N03 và P00; thêm liên kết hộ/chủ sở hữu, đơn vị vật phẩm và quyền dùng theo cặp người–vật vào save schema 1.
- Lập lịch ba bữa/ngày. Mỗi bữa kiểm tra quyền và đủ lương thực/nước/củi trước khi trừ đồng thời; nhánh thiếu hoặc trái quyền không làm hao kho.
- Ghi số giây N01 ngắt lao động để chăm trẻ và chốt công thực hiện lúc 22:00. Chuỗi đầu ghi đúng 65 giây; các lần tự phát tiếp tục cộng thật.
- Runner V2.0 chạy 30 ngày hoàn tất 90 bữa, còn 5.000 g thức ăn, 20.000 ml nước, 13.000 g củi; save ngày 10 tiếp tục đúng với hash `985a29eb4aaa240b`.
- Thêm catalog 14 điều kiện V2 và bảng hộ trên giao diện điện thoại/máy tính. Dart analyze và mọi runner V0–V2.0 đạt; Flutter analyze cùng 4/4 widget test đạt.
- Thêm [[K5_6_V2_0_HO_GIA_DINH_TAI_NGUYEN_QUYEN_LICH]]. Bước tiếp theo là V2.1 bệnh nhẹ, nguồn sản xuất/tiếp tế, phòng trong nhà và đổi lịch NPC.

## 2026-09-07 — K5.5: V1.2 cơ thể và sinh lý sơ sinh

- Thêm `InfantBodyState`: khối lượng, nước, năng lượng, dạ dày, thân nhiệt, áp lực ngủ, bàng quang, chất thải, cách nhiệt, chức năng bú/nuốt và tổng tích lũy.
- Thêm tick sinh lý mỗi giờ game. Nhu cầu được suy từ cơ thể; ăn bị giới hạn bởi dạ dày và chức năng, item mất đúng ml thực nhận.
- Thêm chu kỳ thức/ngủ, điều nhiệt, nước tiểu/phân có lượng và tăng trưởng phụ thuộc dự trữ/nước. Lượt 30 ngày đạt 4.042 g, 5.254 ml ăn, 26.400 phút ngủ và 112 episode chăm sóc.
- Runner V1.2 đạt hash `5d418dc95af7118d`; V1 có lệnh đạt `a6639c12675fafe7`; chuỗi ngắn đạt `69988c4593598846`; V0 giữ hash cũ.
- Catalog V1 tăng từ 19 lên 31 điều kiện duy nhất. Dart/Flutter analyze sạch, 4/4 widget test đạt và web release biên dịch thành công.
- Thêm [[K5_5_V1_2_CO_THE_SINH_LY_SO_SINH]]. V1 tối thiểu đạt chức năng; bước tiếp theo là V2 một hộ sống.

## 2026-09-07 — K5.4: V1.1 chuỗi chăm sóc nhân quả

- Thay chăm sóc tức thì bằng chuỗi tiếng khóc–nghe–ngắt việc–di chuyển–dùng vật–chăm sóc; mỗi mốc có thời gian và fact riêng.
- Thêm vị trí fixture, capability nghe/di chuyển/công việc cho người chăm sóc và item có ID, số lượng, tình trạng. Cho ăn trừ một phần; dùng khăn gây hao mòn 5/1.000.
- Thêm nhánh không nghe, không di chuyển được, thiếu vật và thiếu tác nhân/vị trí; không nhánh nào tự tạo chăm sóc thành công.
- Runner V1.1 đạt cả lưu giữa chuỗi với hash `dad2dfe46c0477a9`; runner tháng đầu đạt hash `9ffdc923123ab154`; V0 giữ hash cũ.
- Thêm catalog máy 19 điều kiện V1/V1.1. Dart/Flutter analyze sạch và 4/4 widget test đạt; giao diện chiếu khoảng cách, công việc NPC, vật tư và phản ứng đang chờ.
- Thêm [[K5_4_V1_1_CHUOI_CHAM_SOC_NHAN_QUA]]. Bước tiếp theo là V1.2 cơ thể và sinh lý sơ sinh dưới ngày.

## 2026-09-07 — K5.3: V1 tháng đầu sơ sinh

- Thêm `InfantState`, nhu cầu, giác quan, ý định theo tuổi, tiếng khóc, phản ứng chăm sóc và Person người chăm sóc vào lõi Dart.
- Giữ tương thích V0 bằng cách chỉ ghi trường infancy khi có; runner V0 vẫn đạt hash `5629ba88282991c6`.
- Runner V1 xác nhận mục tiêu người lớn bị từ chối, vươn tay mở theo tuổi, thiếu chăm sóc không sinh phản ứng giả và save ngày 10 tiếp tục đến ngày 30 cho cùng hash `5eb38d52de2d40fb`.
- Giao diện Flutter mobile/desktop hiển thị nhu cầu và nút ý định phù hợp; Dart/Flutter analyze sạch, 4/4 widget test đạt và web release biên dịch thành công.
- Thêm [[K5_3_V1_THANG_DAU_SO_SINH]]. Hệ số hiện là fixture gameplay theo ngày, chưa phải sinh lý đã hiệu chỉnh; V1.1 sẽ nối tín hiệu–nhận thức–di chuyển–chăm sóc thành chuỗi nhân quả.

## 2026-09-07 — K5.2: shared spike, PWA đối chứng và ADR tạm thời

- Tạo `spikes/shared-spec` với fixture, expected state và tám điều kiện SPV; khóa SHA-256 của hai đầu vào.
- Thêm runner Dart và PWA/Node không dependency. Cả S2 và S0 chạy 500 lượt, cùng fact trace và semantic hash `5629ba88282991c6`; 7/8 SPV đạt.
- Ghi evidence JSON riêng và bảng so sánh. Microbenchmark chỉ là JIT diagnostic, không dùng xếp hạng release.
- Dựng PWA text responsive có goal, pause, local save/load, manifest và service worker tối thiểu; static/core test đạt.
- Thêm [[K5_2_SPIKE_DOI_CHUNG_VA_ADR_CONG_NGHE]]: S2 là working stack PROPOSED cho V1; ADR chưa ACCEPTED vì thiếu S1/S3, native parity, isolate, W1 và sustained run.

## 2026-09-07 — K5.1: lưu/tải UI và phục hồi lifecycle V0

- Thêm `SaveRepository`, adapter `SharedPreferencesAsync` và kho trong bộ nhớ cho test; save giữ nguyên JSON schema 1 từ lõi.
- Thêm nút lưu/tải, trạng thái bản lưu, tự lưu sau khi runner dừng lúc ứng dụng xuống nền và tự khôi phục trước khi mô phỏng chạy lại.
- Sửa ID lệnh sau restore để tránh trùng; chặn timer khởi động sau khi widget đã dispose; dòng trạng thái lưu dùng đúng ngày của snapshot.
- Widget test tăng từ 2 lên 4: round-trip mục tiêu A→B→A và lifecycle pause→mở phiên mới đều đạt. Sửa cột desktop thành vùng cuộn sau khi test phát hiện overflow 120 px ở 800×600.
- Catalog V0 tăng từ 11 lên 14 điều kiện; Dart/Flutter analyze sạch, hash `5629ba88282991c6`, web release có persistence biên dịch thành công.
- Chưa kiểm chứng Android/Windows native vì thiếu toolchain; key-value storage này không phải thiết kế save thế giới lớn.

## 2026-09-06 — K5.1: clock, cổng giao diện và shell Flutter đa kích thước

- Thêm `SimulationClock` và `RealTimeSimulationRunner`: 5.000 ms thật/ngày game, pause không ăn thời gian, backlog không bị bỏ và có giới hạn ngày mỗi pump.
- Thêm `CommandPort`, `QueryPort`, `WorldView` và `PersonView`; giao diện không sửa trực tiếp WorldState.
- Thêm hai schema cùng catalog 11 điều kiện V0 ở lượt này; ngày 2026-09-07 catalog được nâng lên 14. Validator lõi, analyze và deterministic hash `5629ba88282991c6` đều đạt.
- Dựng shell Flutter cho Android, Windows và Web. Test 390×844 giao mục tiêu được; test 1280×800 có cùng thao tác thiết yếu; web release biên dịch thành công.
- Không tạo được APK vì thiếu Android SDK và không tạo được EXE vì thiếu Visual Studio C++. Flutter/Dart vẫn là ứng viên, chưa thành ADR chọn stack.

## 2026-09-06 — K5.1: prototype lõi mô phỏng V0

- Thêm [[K5_1_PROTOTYPE_LOI_V0]] và package Dart `game/`: thời gian nguyên, hàng đợi sự kiện có thứ tự pha, BirthEvent, SetGoalCommand chống lặp, save JSON có phiên bản và semantic hash.
- `dart analyze` không có lỗi; bộ kiểm chứng birth, idempotency, thứ tự cùng mốc, save/load continuation và deterministic replay đạt với hash `5629ba88282991c6`.
- Luồng text tạo P00 từ sơ sinh, giao mục tiêu phù hợp tuổi và chạy đến ngày 1; hash minh họa `75b67e4d35e43973`.
- Khởi tạo kho Git cục bộ. Chưa commit, chưa có UI, worldgen, tiền sử hoặc V1 cơ thể sơ sinh.
- Dart/Flutter vẫn chỉ là ứng viên: Dart SDK chạy được nhưng Flutter launcher bị kẹt; chưa đủ bằng chứng so sánh để viết ADR chọn stack.

## 2026-09-06 — K4.9: kiểm toán tích hợp, phạm vi bản đầu và chuẩn bị lập trình

- Thêm [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]], kiểm kê 8 tài liệu K4 với 8.296 dòng và 756 điều kiện; tổng toàn hồ sơ giữ 1.860 thuộc 41 họ.
- Đối chiếu single writer, owner/boundary, Fact–Belief, bảo toàn, 10 trục phân giải, promotion/demotion, worldgen–tiền sử và điều khiển từ sơ sinh.
- Định phạm vi đề xuất, 12 vertical slice V0–V12, definition of playable/alpha, content/performance/save/worldgen budget và thứ tự phụ thuộc.
- K4I01–K4I06 đạt trên giấy; K4I07–K4I16 chưa có artifact, stack, code, benchmark hoặc evidence. Kế hoạch nền đủ để chuyển sang prototype/V0 khi người dùng yêu cầu.

## 2026-09-06 — K4.8: chiến đấu, xung đột, truy đuổi, ẩn nấp, điều tra và hậu quả sâu

- Thêm [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]], định conflict lifecycle, CombatPolicy/Action, không gian chung, perception/reaction và phase–commit–effect–recovery.
- Nối movement/contact/impact với vũ khí, giáp, projectile, body không HP; định thuật pháp, sustain, counter, trận pháp và pháp khí theo interface.
- Cụ thể hóa nhóm/mệnh lệnh, phục kích, ẩn nấp, truy đuổi, đầu hàng, bắt giữ, cứu hộ, hiện trường, chứng cứ, nhân chứng, điều tra và hậu quả dài hạn.
- Thêm BR0–BR5, 16 fixture cùng 96 CX chưa chạy; nâng tổng từ 1.764 lên 1.860 thuộc 41 họ. K4.9 sau đó đã kiểm toán tích hợp và đóng gói kế hoạch nền.

## 2026-09-06 — Xác nhận điều khiển từ sơ sinh

- Thêm U014: nhân vật người chơi được điều khiển ngay từ lúc sơ sinh, không bỏ qua tuổi thơ.
- Cập nhật luồng nhập thế: ý định và hành động khả dụng phụ thuộc phát triển cơ thể, giác quan, ngôn ngữ, nhận thức, kiến thức và người chăm sóc.

## 2026-09-06 — Xác nhận worldgen, tiền sử dài và nhập thế

- Ghi yêu cầu U012–U013: game không có cốt truyện chính cố định; thế giới tồn tại trước nhân vật người chơi.
- Thêm [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]] với pipeline sinh thế giới, epoch hàng trăm–hàng vạn năm, anchor lịch sử, snapshot hiện tại, bản đồ chọn nơi và tạo nhân vật sau tiền sử.
- Làm rõ ngẫu nhiên có seed/rule/provenance; câu chuyện chỉ là cách nhìn lịch sử thật. Tuổi bắt đầu, kích thước và ngân sách tạo thế giới vẫn mở.

## 2026-09-06 — K4.7: kinh tế, tổ chức, xã hội, quyền lực và luật pháp sâu

- Thêm [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]], nối household, chăm sóc, lao động, production/service, kho, offer/order, giá địa phương, tiền, tín dụng, vận tải, đất và tài nguyên chung.
- Định Organization/Charter/Membership/Role/Authority, delegation, proposal–vote–policy, record, chi nhánh, tông môn, gia tộc, thương hội và chính quyền mà không tạo ý chí tổ chức toàn tri.
- Tách conduct–suspicion–accusation–evidence–ruling–remedy–enforcement; định địa vị, danh tiếng, quyền lực, tham nhũng, phe phái, kế nhiệm, ngoại giao và khủng hoảng.
- Thêm SE0–SE5, 16 fixture cùng 96 XH chưa chạy; nâng tổng từ 1.668 lên 1.764 thuộc 40 họ. K4.8 sau đó đã bổ sung chiến đấu, xung đột và hậu quả sâu.

## 2026-09-06 — K4.6: NPC tự trị, nhu cầu, kế hoạch, quan hệ, ký ức và câu chuyện phát sinh sâu

- Thêm [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]], định PersonAgent và ranh giới Fact–Belief–Command để NPC không đọc hoặc sửa World State toàn tri.
- Cụ thể hóa Drive/Value/Aspiration/Role, GoalGraph, PlanPortfolio, commitment, routine, habit, contingency, replanning và chống vòng lặp thất bại.
- Nối attention–perception–belief, episodic/semantic/procedural/prospective memory, affect–mood–stress–coping, personality, SelfModel và identity narrative.
- Định quan hệ có hướng đa chiều, household/kinship, giao tiếp, thuyết phục, đàm phán, JointPlan, xung đột, sinh kế, học, tu luyện, vòng đời, di cư, chết và di sản.
- StoryCandidate/Story View chỉ đọc event thật; thêm AR0–AR5, 16 fixture cùng 96 NP chưa chạy, nâng tổng từ 1.572 lên 1.668 thuộc 39 họ. K4.7 sau đó đã bổ sung kinh tế, tổ chức và xã hội sâu.

## 2026-09-06 — K4.5: công pháp, cảnh giới, linh căn, kỹ năng, thuật pháp và truyền thừa sâu

- Thêm [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]], định TechniqueDefinition/ProgramIR, pha vận hành, tuyến cơ thể, waveform, điều khiển–phản hồi, phụ phẩm, gián đoạn và PracticeSession.
- Tách Knowledge/Belief/Mastery; định học–dạy–quan sát–thực hành, ngộ, quên, hiểu sai, lineage/version, bản thực hiện cá nhân, sao chép–dịch–phục dựng–cải biên và generator có ràng buộc.
- Định SpiritualInterfaceProfile cho linh căn, compatibility theo người–pháp–môi trường, khí và kho/lọc/công suất; nối bình cảnh, chuẩn bị–cam kết–ổn định đột phá, sai lệch, tụt cảnh giới và tuổi thọ.
- Tách trạng thái thật khỏi RealmStandard/danh xưng xã hội; nối kỹ năng, võ học, thuật pháp, mục tiêu theo nhận thức, duy trì, chồng, khắc chế, giải thuật, thần thức, nghề tu tiên và truyền thừa/tông môn.
- Thêm CR0–CR5, 16 fixture cùng 96 CP chưa chạy; nâng tổng từ 1.476 lên 1.572 thuộc 38 họ. K4.6 sau đó đã bổ sung NPC tự trị, nhu cầu, kế hoạch, quan hệ, ký ức và câu chuyện phát sinh.

## 2026-09-06 — K4.4: địa lý, khí hậu, thủy văn, đất, sinh thái và linh sinh quyển

- Thêm [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]] với hierarchy không gian, topology, địa chất/địa mạo, deposit, hang ngầm và lịch sử cảnh quan.
- Cụ thể hóa climate–season–weather canonical, storm/gió/mưa/vi khí hậu, chu trình nước, lưu vực–sông–hồ–aquifer, chất lượng nước, lũ và trầm tích.
- Định SoilProfile, nước/dinh dưỡng/chất hữu cơ/xói mòn; Species–Habitat–Population, thực vật/động vật, cạnh tranh–cộng sinh–ký sinh, food web, diễn thế và regime shift.
- Nối cháy–hạn–bão–lở, linh mạch–linh trường–linh loài–dị cảnh, nông nghiệp–khai thác–chất thải–ô nhiễm–phục hồi, quyền tài nguyên và MapKnowledge.
- Thêm ER0–ER5, 16 fixture cùng 96 MT chưa chạy; nâng tổng từ 1.380 lên 1.476 thuộc 37 họ. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.

## 2026-09-06 — K4.3: vật liệu, vật phẩm, cấu trúc, công dụng và chế tác sâu

- Thêm [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]], tách Material/Definition, DesignBlueprint, ItemInstance và View; định composition, vi cấu trúc, geometry, surface, dung sai và provenance.
- Cụ thể hóa Part–Joint–Interface–Assembly–Mechanism, capability theo actor/task, QualityVector tách Condition/Grade/Claim và kiểm định có uncertainty.
- Định CraftPlan/Workpiece, reservation, tool/station/jig, kỹ năng, batch và các process khai thác–tinh luyện–đúc–rèn–nhiệt luyện–gia công–gỗ–gốm–dệt–dược–lắp ráp–phù văn.
- Nối hao mòn, mỏi, ăn mòn, nhiễm, failure, bảo trì, sửa, tháo, tái dùng, tái chế, vũ khí, giáp, y cụ, máy và pháp khí; thêm design grammar cùng IR0–IR5.
- Thêm 15 fixture cùng 96 VP chưa chạy, nâng tổng từ 1.284 lên 1.380 thuộc 36 họ. K4.4 sau đó đã bổ sung địa lý, khí hậu, thủy văn, đất, sinh thái và linh sinh quyển.

## 2026-09-06 — K4.2: cơ thể đa tầng, sinh lý, bệnh lý và tu luyện hóa cơ thể

- Thêm [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]] với AnatomyDefinition/BodyInstance, part identity, topology vùng–cơ quan–mô–compartment và các mạng vận chuyển.
- Cụ thể hóa nội môi, reserve, chuyển hóa, tuần hoàn, máu, hô hấp, dinh dưỡng, bài tiết, điều nhiệt, thần kinh, ý thức, ngủ, mệt và đau mà không dùng HP canonical.
- Định InjuryPath, chảy máu/đông máu, tổn thương thứ phát, nhiễm–miễn dịch–bệnh–độc–thuốc, chẩn đoán, điều trị, sửa chữa, sẹo, tái tạo và phục hồi chức năng.
- Nối phát triển, lão hóa, sinh sản, tử vong, thi thể, kinh mạch, đan điền, luyện thể, đột phá và dị biến; thêm B0–B5 cho cơ thể NPC xa.
- Thêm 14 fixture cùng 96 CT chưa chạy, nâng tổng từ 1.188 lên 1.284 thuộc 35 họ. K4.3 sau đó đã bổ sung vật liệu, vật phẩm, cấu trúc, công dụng và chế tác sâu.

## 2026-09-06 — K4.1: vật chất, năng lượng, trường và hiện tượng nền

- Thêm [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]] với ontology Entity–State–Field–Process, registry đại lượng/đơn vị, parcel–composition–phase–structure và ranh giới hệ.
- Cụ thể hóa bảo toàn/energy ledger, cơ học, tiếp xúc/hỏng, nhiệt, chất lưu, khí, chuyển pha, khuếch tán, phản ứng, cháy, tín hiệu và các process liên tục theo breakpoint.
- Đưa linh khí, linh năng, linh trường, kinh mạch, công pháp, thuật, trận pháp và pháp khí vào flow/field/coupling/LawRef thay vì thanh chỉ số tách rời.
- Tách độ phân giải hiện tượng P0–P4 khỏi M0–M4 và R0–R4; định ApproximationDebt, BoundaryFlow, save/replay, mobile/desktop và boundary với năm domain lớn.
- Thêm 12 fixture cùng 84 VL chưa chạy, nâng tổng từ 1.104 lên 1.188 thuộc 34 họ. K4.2 sau đó đã bổ sung cơ thể đa tầng, sinh lý, bệnh lý và tu luyện hóa cơ thể.

## 2026-09-06 — K3.7: kiểm toán và đóng gói K3.1–K3.6

- Thêm [[KIEM_TOAN_DONG_GOI_K3]], kiểm kê 6 tài liệu K3 với 4.917 dòng và 420 điều kiện; tổng toàn hồ sơ giữ 1.104 thuộc 33 họ, tất cả chưa chạy.
- Rà chuỗi phụ thuộc K2–module–công nghệ–nội dung–phân tầng–lưu trữ–artifact, chủ quản dữ liệu, single writer, portability điện thoại/máy tính, identity NPC, promotion/demotion, partition/query và compatibility/evidence.
- Lập 12 invariant xuyên K3, 24 vấn đề mở, ma trận sẵn sàng, thứ tự quyết định kỹ thuật và backlog prototype PRT-0 cùng V0–V10.
- K3X01–K3X15 đạt trên giấy; K3X16–K3X24 chưa có artifact máy, mã nguồn, lượt chạy hoặc bằng chứng. Không thêm điều kiện mới. K4.1 sau đó đã bổ sung nền vật chất, năng lượng, trường và hiện tượng.

## 2026-09-06 — K3.6: artifact máy, schema registry và condition catalog

- Thêm [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]] với ArtifactEnvelope/URI/SourceRef, registry/version/compatibility, primitive-unit-ID và neutral IR/codegen đa target.
- Định artifact content/fixture/overlay/policy/generator/migration/workload, ConditionSpec, automation_state tách result_state và quy trình ánh xạ Markdown bằng semantic anchor.
- Cụ thể hóa RunSpec/Oracle/Evidence/Gate, build/validation/reproducibility/capability/impact workflow, repository topology và bootstrap catalog theo batch.
- Thêm 80 AM chưa chạy, nâng tổng từ 1.024 lên 1.104 thuộc 33 họ. K3.7 sau đó đã kiểm toán và đóng gói K3.1–K3.6.

## 2026-09-06 — K3.5: lưu trữ, phân vùng, chỉ mục và truy vấn

- Thêm [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]], tách canonical state, live store, portable save và derived index/cache/view; định 12 access pattern chuẩn.
- Cụ thể hóa logical stores, record/commit/snapshot, transaction xuyên shard, revision vector, partitions cho Person/asset/journal/frontier/flow/anchor và save full/incremental.
- Định lazy load/prefetch/eviction, indices theo ID/không gian/thời gian/quyền/xã hội/nhận thức, QuerySpec/cost/freshness, mobile durability, corruption, compaction, GC, migration, backup và sync.
- Thêm 76 LU chưa chạy, nâng tổng từ 948 lên 1.024 thuộc 32 họ. K3.6 sau đó đã bổ sung artifact máy, schema registry và condition catalog.

## 2026-09-06 — K3.4: mô phỏng phân tầng và vòng đời thực thể quy mô lớn

- Thêm [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]], tách M0–M4 materialization khỏi R0–R4 resolution; Person M2+ không bao giờ bị gộp trở lại cohort.
- Định PersonCore/cold capsule, ResolutionPlan/error budget, interaction horizon, promotion/demotion/pin/frontier, batch R4 và cohort-to-Person allocation.
- Cụ thể hóa sinh/tử/hộ/tài sản/nghĩa vụ/cơ thể/bệnh/tu luyện/chiến đấu/quan hệ, message/di cư/BoundaryFlow, retention/compaction, save partition, overload và W0–W4.
- Thêm 72 PT chưa chạy, nâng tổng từ 876 lên 948 thuộc 31 họ. K3.5 sau đó đã bổ sung lưu trữ, phân vùng, chỉ mục và truy vấn.

## 2026-09-06 — K3.3: dữ liệu nội dung và sinh thế giới có kiểm soát

- Thêm [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]] với Definition/Blueprint/Instance/View, ContentPackage, id/version, identity permanence, provenance graph và seed tree độc lập thứ tự khám phá.
- Định generator có constraint/budget/backtrack, uniqueness/diversity; taxonomy tổ hợp cho vật liệu, vật phẩm, công pháp, cơ thể, NPC, xã hội, địa lý, sinh thái và linh khí.
- Cụ thể hóa lịch sử tiền game, anchor, LATENT/SUMMARIZED/MATERIALIZED, boundary seam, persistent delta/tombstone, authored/procedural content, DSL compile pipeline và generator oracle.
- Thêm 68 ND chưa chạy, nâng tổng từ 808 lên 876 thuộc 30 họ. K3.4 sau đó đã bổ sung mô phỏng phân tầng và vòng đời thực thể ở quy mô lớn.

## 2026-09-06 — K3.2: ma trận công nghệ và kế hoạch prototype

- Thêm [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]] dựa trên tài liệu chính thức hiện hành của Tauri, Flutter, Kotlin/Compose Multiplatform và .NET MAUI.
- Shortlist ngang hàng S1 Rust/Tauri 2, S2 Dart/Flutter, S3 Kotlin/Compose; giữ .NET MAUI dự phòng và PWA làm đối chứng. Chưa chọn stack.
- Định fixture W0, sáu scenario Command/Day/Save/Portability/UI/Sustained, fingerprint, disqualifier, score, tie-break, stop condition, lộ trình prototype và ADR template.
- Thêm 64 CN chưa chạy, nâng tổng từ 744 lên 808 thuộc 29 họ. K3.3 sau đó đã bổ sung kiến trúc dữ liệu nội dung và sinh thế giới có kiểm soát.

## 2026-09-06 — K3.1: kiến trúc đa nền tảng và ranh giới module

- Thêm [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]] với single-writer Simulation Runtime, dependency graph hướng vào core, module owner và các ranh giới process/thread/time/storage.
- Định Command/Event/Query/View/Save/Validation/Observability/Platform ports; lifecycle an toàn khi mobile xuống nền hoặc desktop đóng; save portable và semantic UI dùng chung.
- Cụ thể hóa concurrency, R0–R4, sync extension, error handling, versioning, content/mod boundary, tiêu chí so công nghệ, spike chung và 10 cổng K3G.
- Thêm 60 KT chưa chạy, nâng tổng từ 684 lên 744 thuộc 28 họ. Chưa chọn stack hoặc lập trình. K3.2 sau đó đã lập ma trận công nghệ và kế hoạch prototype quyết định stack.

## 2026-09-06 — K2.8: kiểm toán và đóng gói K2.1–K2.7

- Thêm [[KIEM_TOAN_DONG_GOI_K2]], kiểm kê 7 tài liệu K2 với 4.822 dòng và 308 điều kiện; tổng toàn hồ sơ giữ 684 thuộc 27 họ, tất cả chưa chạy.
- Rà dependency, chuỗi Command–Decision–Transaction–Fact–Observation–Save–Oracle, chủ quản dữ liệu, tám pha, bảo toàn, nhận thức, replay, R0–R4, mobile/desktop và TN01–TN08.
- Lập ma trận sẵn sàng, 20 vấn đề mở, 10 rủi ro kiến trúc, 20 cổng K2G, ràng buộc/module logic và gói bàn giao đề xuất.
- K2G01–K2G14 đạt hoặc đạt trên giấy; K2G15–K2G20 chưa có bằng chứng triển khai. Không thêm test. K3.1 sau đó đã bổ sung kiến trúc triển khai đa nền tảng và ranh giới module.

## 2026-09-06 — K2.7: ngân sách hiệu năng, quy mô và đo tải

- Thêm [[NGAN_SACH_HIEU_NANG_QUY_MO_K2]] với metric chuẩn, Workload/Device/Calibration profile, bậc W0–W4 và ngân sách W1 đề xuất cho điện thoại/máy tính.
- Cụ thể hóa p50/p95/p99, 5 giây/ngày, WorkSlice, command/pause/UI latency, memory, save/storage, pin, nhiệt, sustained run và cost theo event/cognition/perception/vật/cơ thể/xã hội.
- Định R0–R4/ErrorBudget, promotion/demotion, CapacityEnvelope, backpressure/OverloadState, causal storm, cache/partition, benchmark suite, evidence và regression.
- Thêm 56 HN chưa chạy, nâng tổng lên 684. K2.8 sau đó đã kiểm toán và đóng gói K2.1–K2.7; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K2.6: validator, oracle và kế hoạch chạy điều kiện

- Thêm [[KE_HOACH_VALIDATOR_ORACLE_K2]], kiểm kê 576 điều kiện trước K2.6 thành 25 họ và giữ toàn bộ ở trạng thái chưa chạy.
- Định Condition/Fixture/Run/Oracle spec, fingerprint, ResultStatus, validator/monitor/gate và oracle cho transition, scenario, conservation, scheduler, nhận thức, giao dịch, save/migration.
- Bổ sung metamorphic/replay/parity, determinism, negative/fault, generator/shrink, EvidenceBundle/FailureArtifact, golden, coverage/dependency, tầng V0–V5 và ánh xạ BT/K1G.
- Thêm 52 VO chưa chạy, nâng tổng lên 628. Tiếp K2.7: hiệu năng, quy mô và chiến lược đo tải; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K2.5: lưu tải, migration và phục hồi thế giới

- Thêm [[HOP_DONG_LUU_TAI_MIGRATION_PHUC_HOI_K2]] với World lineage/branch/generation, SaveSlotManifest, SaveBoundaryToken, SnapshotImage, JournalSegment, Checkpoint và quy trình công bố thế hệ mới mà không ghi đè bản hợp lệ cũ.
- Cụ thể hóa crash giữa tám pha, Transaction/Reservation, Action/Process, queue/recurrence, Command/RNG, Observation/Dialogue/Decision và hai OfflinePolicy còn mở.
- Định LoadPipeline, CompatibilityManifest, MigrationGraph theo miền, corruption detection, repair chỉ từ bằng chứng, rollback kỹ thuật, retention/compaction, export/import và divergence nhiều thiết bị.
- Thêm 48 LP chưa chạy, nâng tổng lên 576. Tiếp K2.6: validator, oracle và kế hoạch chạy điều kiện; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K2.4: nhận thức, quyết định và tác nhân NPC

- Thêm [[HOP_DONG_NHAN_THUC_QUYET_DINH_TAC_NHAN_K2]] với đường ống Signal–Observation–Message–Belief–Memory–Inference–Appraisal–Goal–Decision–Action và ranh giới chống tri thức toàn tri.
- Cụ thể hóa nhận diện mơ hồ, Attention, Comprehension, Evidence/lineage, belief mâu thuẫn, freshness, quên/tóm lược, KnowledgeUnit, GoalGraph, sinh/đánh giá phương án và học từ kết quả được nhận thức.
- Nối DecisionWakeup chống polling, Dialogue có thời gian, bí mật/lời dối, quan hệ chủ quan, ba policy P00, R0–R4, ngân sách nhận thức, save/load và ViewProjection đa nền tảng.
- Thêm 44 NT chưa chạy, nâng tổng lên 528. Tiếp K2.5: lưu/tải, migration và phục hồi thế giới; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K2.3: giao dịch, quyền và bảo toàn vật chất

- Thêm [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]] và tách khả thi vật lý, cơ chế cho phép tại chỗ với tính hợp lệ chuẩn tắc để luật không trở thành khóa toàn tri.
- Định AssetRef, title/custody/possession/Position, Claim, RightGrant, Offer/Contract/Obligation, TransactionPlan, validation, Reservation và ConflictPolicy.
- Cụ thể hóa commit nguyên tử, mutation registry, lot split/merge, container/component, ConservationEquation, Source/Sink, transformation, V01, nước/linh lực, dịch vụ, giao hàng, nợ, ledger, trộm và save/migration.
- Thêm 40 GV chưa chạy, nâng tổng lên 484. Tiếp K2.4: nhận thức, quyết định và tác nhân NPC; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K2.2: hợp đồng bộ lập lịch và xử lý sự kiện

- Thêm [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]] với SchedulerState, EventQueueEntry, batch cùng mốc, wave nhân quả và vòng đời event có lý do kết thúc.
- Định recurrence neo anchor/index, ngoại lệ occurrence, materialization vừa đủ, trigger subscription và ProcessInstance tích phân số nguyên không vượt boundary.
- Cụ thể hóa tám pha 10–80, ConflictSet, stale/invalidation, Action/movement, Observation/Command, tạm dừng, điều phối 5 giây/ngày, quá tải, R0–R4, lưu/tải và hai offline policy còn mở.
- Thêm 36 LS chưa chạy, nâng tổng lên 444. Tiếp K2.3: giao dịch, quyền và bảo toàn vật chất; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K2.1: từ điển dữ liệu máy và hợp đồng trạng thái

- Thêm [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]] với kiểu trung lập công nghệ, đơn vị nguyên, id có miền, RecordEnvelope và cách tách không biết/không có/không áp dụng.
- Định hợp đồng trường cho World/Snapshot, người/nhóm, vị trí, vật/lot, ownership/custody, transaction, quyền/cam kết, lịch/hành động, event, nhận thức, kỹ năng, cơ thể/tu luyện, tâm lý, quyết định và hội thoại.
- Bổ sung quy tắc overlay, RNG, Command/ViewProjection, validation, migration, canonical serialization, state hash và tóm lược lịch sử; chưa chọn định dạng, ngôn ngữ hoặc cơ sở dữ liệu.
- Thêm 32 HD chưa chạy, nâng tổng lên 408. Tiếp K2.2: hợp đồng bộ lập lịch và xử lý sự kiện; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.12: kiểm toán và đóng gói K1

- Thêm [[KIEM_TOAN_DONG_GOI_K1]] làm điểm vào cho K1.1–K1.11, kèm bản kê chủ quản, thứ tự phụ thuộc, sổ không gian tên và cấu trúc gói bàn giao.
- Đối chiếu 238 điều kiện K1 với 138 điều kiện nền, xác nhận tổng 376; giữ toàn bộ ở trạng thái chưa chạy bằng mô phỏng.
- Rà dân số, địa điểm, tuyến, V01–V36, J01–J07, lịch–vị trí, V01/V02/nước, quyền–tri thức, hội thoại và ranh giới base–overlay; ghi 12 vấn đề mở có phạm vi.
- Lập K1G01–K1G12: tám cổng đầu đạt/đạt trên giấy, bốn cổng dữ liệu máy–bộ chạy–parity–hiệu năng chưa đạt. Tiếp K2.1: từ điển dữ liệu máy và hợp đồng trạng thái; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.11: dấu vết quyết định và hội thoại

- Thêm [[DAU_VET_QUYET_DINH_HOI_THOAI_K1]] với DialogueIntent, UtteranceSignal, DialogueAct, DecisionTrace và công thức chấm phương án có nguồn giải thích.
- Dựng tám dấu vết cho trả C01, báo lo bánh V23, quyền duyệt O03, phản ứng của hai học việc, lựa chọn chăm sóc của Dũng, nghi kho O06, Phúc–Huệ và lệnh rủi ro cho P00.
- Tách payload có cấu trúc khỏi câu mẫu; hội thoại chỉ đổi trạng thái qua Message/Commitment/Goal/Transaction/RightChange hợp lệ và không dùng LLM để bịa sự thật hay quyền.
- Sửa liên kết tên cũ trong bảng tồn kho khởi đầu để trỏ đúng [[DU_LIEU_LIEN_KET_K0]].
- Thêm 28 DV chưa chạy, nâng tổng lên 376. Tiếp K1.12: kiểm toán và đóng gói K1.1–K1.11; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.10: tính cách, giá trị, cảm xúc và sức ép

- Thêm [[TAM_LY_21_NGUOI_K1]] với bốn tầng Disposition/Value/Affect/Pressure, tám trục xu hướng và 13 giá trị không gộp thành thiện–ác.
- Gán ma trận xu hướng, giá trị, trạng thái cảm xúc/sức ép và cách ứng phó cho N01–N20 theo HIST/SEC/LongGoal; P00 giữ U để không tự chốt tâm lý nhân vật người chơi.
- Định appraisal, cường độ/giảm cảm xúc, sáu nguồn PressureLoad, cách nối DecisionFrame, biểu lộ, quan hệ, thích nghi dài hạn và ba chính sách tự chủ P00 còn mở.
- Thêm tám nhánh TL-X01–TL-X08 và 26 TL chưa chạy, nâng tổng lên 348. Tiếp K1.11: dấu vết quyết định/hội thoại 30 ngày; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.9: năng lực, ngôn ngữ và truyền tri thức

- Thêm [[NANG_LUC_NGON_NGU_TRI_THUC_K1]] với LANG-AK, SCRIPT-AK, sáu LEX nghề và thang nghe/nói/đọc/viết/tính/xác nhận tách biệt.
- Gán ma trận H/S/R/W/C/A và thuật ngữ cho P00/N01–N20 theo lịch sử/vai trò; P00 INIT-A có thể hội thoại cơ sở nhưng chưa đọc/viết.
- Định KnowledgeUnit, pipeline tín hiệu→giải mã→hiểu, teach-back, CalculationAttempt, quyền dạy/chứng nhận và sáu nhánh sai lệch NN-X01–NN-X06.
- Nối lại sổ K1.8 để J01 dùng giải thích miệng+dấu P00, J05 không tự truyền công pháp và tờ công khai không tự được đọc. Thêm 24 NL chưa chạy, nâng tổng lên 322. Tiếp K1.10: tính cách/giá trị/cảm xúc/sức ép; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.8: sổ thể chế 30 ngày

- Thêm [[SO_THE_CHE_30_NGAY_K1]] và vật chất hóa kênh hồ sơ bằng 30 V34, 7 V35, 7 V36 cùng khung tin cố định D01; danh mục fixture tăng từ 33 lên 36 loại.
- Gắn sổ thật vào tám hợp đồng J01, 30 lần trả trọ, các giao dịch O04, buổi J05 và đóng C01; dòng sổ chỉ trỏ Transaction, không nhân đôi vật/tiền.
- Tách TC-X01–TC-X08 cho tin quá hạn, quyền duyệt O03, bảo trì xe, nghi kho, quỹ O06, can thiệp tờ tin, ghi sổ trễ và mất biên nhận; không ép các nhánh vào lịch cơ sở.
- Sửa lỗi ký hiệu bình nước V33 thành V12 trong lịch P00. Thêm 24 ST chưa chạy, nâng tổng lên 298. Tiếp K1.9: năng lực/ngôn ngữ/truyền tri thức; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.7: văn hóa và thể chế An Khê

- Thêm [[VAN_HOA_THE_CHE_AN_KHE_K1]] với lớp tập quán, cam kết, quy tắc tổ chức, phán quyết và trạng thái thực thi; mỗi quyền có phạm vi, nguồn và tập người biết.
- Cụ thể hóa hộ/cư trú, tuổi trưởng thành và hôn phối, bốn mức học việc, chăm sóc, thừa kế/kế nhiệm, danh dự theo lĩnh vực và quy trình tranh chấp năm bậc.
- Phân quyền O03 cho Vân/Yến/Kha/Tùng và O04 cho Hòa/Bình/Dũng; SEC15 của Yến vẫn là ý định riêng, không tự thành chính sách.
- Định ba kênh tin công khai nhưng ghi rõ vật mang chữ chưa vào INIT-A; thêm 22 VH chưa chạy, nâng tổng lên 274. Tiếp K1.8: sổ thể chế 30 ngày; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.6: lịch sử và quan hệ của 20 NPC

- Thêm [[HO_SO_NPC_AN_KHE_K1]] với 14 sự kiện lịch sử chung và hồ sơ N01–N20: nguồn kỹ năng, lịch sử gần, quan hệ, tri thức, mục tiêu và điều riêng tư.
- Dựng mạng quan hệ có hướng giữa hộ, y quán, xưởng, ruộng, O03, thương hộ, trạm cầu và người đưa tin; nối C01, V23 và thông báo J05 với nguồn quá khứ.
- Lập SEC01–SEC19 kèm người biết để bí mật không thành tri thức toàn làng; không thêm tài sản/công pháp/thương tích vào INIT-A hoặc khóa tương lai.
- Thêm 20 HS chưa chạy, nâng tổng lên 252. Tiếp K1.7: văn hóa và thể chế An Khê; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.5: đời sống NPC tự sinh dài hạn

- Thêm [[DOI_SONG_TU_SINH_K1]] với vòng đời cá nhân, hộ, công việc phát sinh từ thiếu hụt, thay nghề, quan hệ, gia đình, già/bệnh/chết, kế nhiệm, di cư và tu luyện dài hạn.
- Tách FactEvent, Episode và StoryArcView để câu chuyện là kết quả của đời sống, không phải bộ điều khiển tạo kịch tính.
- Định năm mức R0–R4, quy tắc nâng/hạ trước biến cố, giải khoảng xa, EventClock và vật chất hóa chi tiết không sửa quá khứ.
- Gắn yêu cầu điện thoại/máy tính với cùng kết quả logic và dừng an toàn khi quá tải; thêm 22 DT chưa chạy, nâng tổng lên 232. Tiếp K1.6: lịch sử N01–N20; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.4: xung đột và nhánh thất bại

- Thêm [[NHANH_XUNG_DOT_K1]] với tám overlay: N12 vắng, N05 bị thương có/không người thay, chuyến O06 trễ, quầy đóng, tranh J01, mất bình và tin lịch N13 đã cũ.
- Mỗi nhánh ghi FactEvent đầu vào, đường truyền tri thức, DecisionFrame bị đánh thức, lịch thay, điểm nhập lại và kết sổ nguồn.
- Cụ thể hóa các hậu quả: D07 bỏ gác khi N17 giao thay, P00 hoãn J05 nếu mất một J01, không thu học phí khi N13 vắng và thiếu 60 định suất nếu ba đơn ngày 18 không được cứu tới cuối kỳ.
- Thêm 18 NX chưa chạy, nâng tổng lên 210. Bước tiếp theo K1.5 là đời sống NPC tự sinh dài hạn; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.3: sổ sự kiện 30 ngày

- Thêm [[SO_SU_KIEN_30_NGAY_K1]] với mẫu sự kiện theo phút, chuỗi P00, ngoại lệ từng ngày, sổ V02, nước, tiền và nhận thức.
- Đối chiếu thủ công được 630 V02 tiêu thụ, 110 còn ở H02, 1.260.000 ml nước uống và tổng 2.000 V01; không tuyên bố đã chạy mô phỏng.
- Phát hiện và sửa hai mắt xích: P00 còn 500 ml đầu ngày 2 nên chỉ lấy 1.500 ml; N05 phải đi D01↔D02 để nhận suất trước trong sáu ngày giao sớm.
- Thêm 16 SS chưa chạy, nâng tổng lên 192. Bước tiếp theo K1.4 là ma trận xung đột và nhánh thất bại; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K1.2: nguồn nhận thức và quyết định

- Thêm [[NGUON_QUYET_DINH_K1]] để tách sự thật, quan sát, lời kể, niềm tin, ký ức, suy luận, mục tiêu và quyết định có dấu vết.
- Gắn nguồn cho RoutinePlan của N01–N20, chuỗi P00 tìm việc/mua thức ăn/tìm người dạy và hai nhánh tin cầu; bổ sung mốc P00 hỏi N06 vào lịch K1.1.
- Định DecisionFrame, lượt đánh giá pha 70–80, cách xử lý tin cũ/mâu thuẫn, tóm lược ký ức và 20 QD chưa chạy.
- Tổng số điều kiện thiết kế chưa chạy là 176. Bước tiếp theo K1.3: sổ sự kiện theo phút cho FX-A-30D; chưa lập trình hoặc chốt quyền chống lệnh.

## 2026-09-06 — K1.1: lịch cơ sở 21 người

- Thêm [[LICH_21_NGUOI_K1]] với lịch P00 và N01–N20, nhu cầu hằng ngày, ngoại lệ vận chuyển, các giao dịch bắt buộc và FX-A-30D.
- Sửa mâu thuẫn lương thực P00: mua hai V02 vào chiều ngày chẵn 6–28, thay lịch ngày lẻ 7–29 vốn để trống bữa sáng ngày 7; tổng tiền và hàng không đổi.
- Ghi cách xử lý ba đồng vượt túi P00 ngày 8 và suất phát trước cho N05 trong ngày giao sớm; thêm 18 LC chưa chạy.
- K1.1 đã khép kín trên giấy. Bước tiếp theo K1.2 là nguồn quyết định và sổ sự kiện phát lại; vẫn chưa lập trình hay chốt TN.

## 2026-09-06 — Kiểm toán lần hai sau K0

- Rà lại 15 fixture A–E; phân biệt fixture khép kín trên giấy, fixture còn phụ thuộc K1 và giới hạn cố ý chưa hỗ trợ.
- Sửa A-BOOT dùng N01 thay N19 vì N19 chưa về từ chuyến nước; làm rõ B-CARE bị hủy sau tiếp xúc vẫn để lại V06; gộp 88 g dịch B-REMOTE thành năm hồ sơ vị trí/tuyến.
- Tăng điều kiện CS từ 16 lên 18. Tổng 88 DL + 16 DS + 16 LK + 18 CS = 138 điều kiện logic, tất cả chưa chạy.
- K0 không phải mở lại. FX-A-30D chuyển sang K1.1 để định lịch ăn, thanh toán và hoạt động của 21 người; chưa lập trình hoặc chốt TN.

## 2026-09-06 — K0.6: vòng đời băng, dịch và hồi phục

- Thêm [[CHAM_SOC_K0]] với hồ sơ V05/V06, hạn chăm sóc 24 giờ, ba hành động B-CARE/B-CHANGE/B-REMOVE và vị trí băng đã tháo.
- Khép sổ 100 g dịch W-B01 theo cơ thể/môi trường/V06; thêm ngưỡng chức năng giới hạn và lịch riêng cho B-LOCAL/B-REMOTE.
- Bổ sung hồi phục W-E01 sau 48 giờ và W-E02 sau 96/120 giờ đủ điều kiện; thêm 16 CS chưa chạy.
- Cập nhật tài liệu nguồn, lược đồ, kiểm toán và trạng thái. Sáu việc K0 đã khép kín trên giấy; bước tiếp theo là kiểm toán lại A–E, chưa lập trình hoặc chốt các hệ số.

## 2026-09-05 — K0.2–K0.5 và yêu cầu điện thoại/máy tính

- Ghi nhận U011: trò chơi phải dùng được trên điện thoại và máy tính; cập nhật kế hoạch giao diện thích nghi, chạm/bàn phím, hiệu năng và phục hồi khi ứng dụng xuống nền. Công nghệ và đồng bộ giữa thiết bị còn mở.
- Thêm [[DU_LIEU_LIEN_KET_K0]]: V33 và vị trí 2.000 V01, FX-A-BOOT, lịch giao thức ăn/nước có giờ-người-vật chứa, FX-C-MSG/NOMSG và 16 điều kiện LK.
- Cập nhật dữ liệu hiện hành từ 32 lên 33 mẫu vật phẩm, liên kết các tài liệu nguồn và trạng thái fixture. Tất cả vẫn là đề xuất trên giấy, chưa chạy; bước tiếp theo K0.6.

## 2026-09-05 — K0.1: lược đồ trạng thái và fixture

- Viết LUOC_DO_TRANG_THAI.md với đầu tệp thế giới, đơn vị số nguyên, mã có miền và kho hồ sơ chủ quản.
- Định một vị trí thật, sự kiện dự kiến/sự kiện đã xảy ra, tám pha cùng mốc, giao dịch nguyên tử, RNG độc lập và yêu cầu ảnh lưu.
- Chuẩn hóa cấu trúc fixture, lập danh mục 15 fixture A–E và 16 điều kiện DS; tất cả vẫn chưa chạy hoặc thành dữ liệu máy.
- Cập nhật hồ sơ; bước tiếp theo K0.2–K0.5, chưa chọn công nghệ, lập trình hoặc chốt TN.

## 2026-09-05 — Kiểm toán tích hợp DL01–DL06

- Viết KIEM_TOAN_TICH_HOP.md, đối chiếu chuỗi A–E, mười sổ nguồn, 12 điều kiện BT và 88 tình huống DL; tất cả vẫn chưa chạy.
- Xác định chuỗi C chưa đủ tái hiện; A/B thiếu mắt xích; D/E khép kín số học hoặc nhánh cơ sở nhưng chưa kiểm chứng.
- Phát hiện tiền V01 chưa có vị trí/vật chứa, lịch giao nhận thiếu giờ/người, băng chưa có vòng đời và save/hiệu năng chưa có lược đồ/ngưỡng.
- Sửa rõ C/I cho INIT-D/LM-B và vùng che V20/hao mòn một tiếp xúc trong INIT-E. Bước tiếp theo K0.1, chưa lập trình hay chốt TN.

## 2026-09-05 — DL06: tiếp xúc và hậu quả giao chiến

- Viết CHIEN_DAU_THU.md với không gian INIT-E, vị trí liên tục, nhận biết, pha hành động, quỹ đạo, phòng hộ và thương tích cùn mẫu.
- Đối chiếu E-GUARD/E-SAME/E-DODGE và hai tác động cùng mốc; tách hao mòn vật phẩm khỏi lượng tác động tới cơ thể.
- Thêm E-LINH nối Hồi Hoàn với một ứng dụng thử có P khép kín; không cấp thuật này cho nhân vật trong INIT-A.
- Thêm 16 tình huống GT chưa chạy; sáu gói DL đã có đề xuất. Tiếp theo rà soát chéo trước triển khai, vẫn chưa lập trình hoặc chốt TN.

## 2026-09-05 — DL05: linh lực và ba công pháp thử

- Viết TU_LUYEN_THU.md với kho linh lực cá thể, mạng năm nút và ba cơ chế Tĩnh Lưu/Liệt Mạch/Hồi Hoàn khác nhau thực chất.
- Khép kín phép chia nguồn INIT-D, nguồn linh thạch V27, học J05 và lịch phiên luyện; P00 chưa đủ điều kiện vận công sau một bài học.
- Định nghĩa bản lưu gần mốc TM-01 và chuyển M0→M1 bằng các pha cùng sổ năng lượng; không đặt tên cảnh giới hoặc ép đột phá trong 30 ngày.
- Thêm 16 tình huống LT chưa chạy; cập nhật hồ sơ, tiếp DL06. Chưa lập trình hoặc chốt TN.

## 2026-09-05 — DL04: công việc và lịch NPC

- Viết CONG_VIEC_THU.md: hồ sơ việc, nhận việc có cạnh tranh, đánh giá ưu tiên, lịch kiểm tra lại, tài nguyên đồng thời và thao tác giao nhận.
- Cụ thể hóa J02 thành mười băng có tiến độ riêng; nối phần dở của B-LOCAL với hợp đồng và chăm sóc, đối chiếu đường B-REMOTE.
- Viết lịch A-DAY 24 giờ và trách nhiệm 20 NPC, phân biệt rõ lịch có điều kiện với khởi đầu chưa biết đường/chưa nhận việc.
- Thêm 16 tình huống CV chưa chạy; cập nhật hồ sơ, tiếp DL05. Chưa lập trình hoặc tự chốt trải nghiệm.

## 2026-09-05 — DL03: chức năng cơ thể và thương tích thử

- Viết CO_THE_THU.md: cấu trúc mẫu, chức năng tay/chân, tải, mệt/ngủ/nhu cầu và quy trình W-B01; 14 tình huống CB chưa chạy.
- Cụ thể hóa B-LOCAL/B-REMOTE, phân biệt can thiệp thử với sự kiện tự sinh; kiểm tra lượng dịch, lực giữ và các mốc liền vết trên giấy.
- Nối lại DL01–DL02: mệt giảm tốc độ, thương tích đổi điều kiện việc, ngân sách tám J01 không còn là kết quả bắt buộc.
- Giữ rõ phần chưa hỗ trợ: cơ quan sâu, nhiễm/độc/nhiệt, khối lượng sinh học toàn thân. Tiếp DL04, chưa lập trình hoặc chốt trải nghiệm.

## 2026-09-05 — DL02: vật thể và bảo toàn vật liệu

- Viết VAT_THE_THU.md: bảng 32 mẫu, quy tắc đóng gói/tải/tay, cấu tạo, sửa cán và các phép chuyển vật liệu; thêm 14 tình huống VT chưa chạy.
- Bổ sung thân/vỏ ruộng 100 kg ở khởi tạo; tám J01 đối chiếu thành 120 kg thức ăn + 40 kg phụ phẩm, giữ ngân sách DL01.
- Đối chiếu đồ P00 7,25 kg, tải hàng xe 16,1 kg và cách chia người mang nước. Chưa chứng minh lịch/sinh lý hoạt động bằng mô phỏng.
- Cập nhật liên kết và trạng thái; tiếp DL03, vẫn lập kế hoạch và chưa chốt TN.

## 2026-09-05 — DL01: sinh kế và phân phối

- Viết SINH_KE.md với quyền ăn/ở cho toàn bộ 21 người, cam kết hiện vật, lịch tiếp tế, tiền, nước và lịch lao động đề xuất.
- Đối chiếu nhánh tám J01: 500 + 240 − 630 = 110 suất còn; tiền toàn vùng giữ 2.000 đồng, P00 còn 14 đồng sau ăn/trọ/một bài học.
- Nêu giới hạn: chưa có tải đầy đủ, hao hụt chế biến, sinh lý và lịch tự chủ; 12 tình huống SK chưa được chạy bằng game.
- Cập nhật mục lục, dữ liệu nền, lựa chọn, trạng thái và quyết định; bước tiếp theo DL02. Không chốt TN hoặc bắt đầu lập trình.

## 2026-09-05 — Tổng hợp lựa chọn trải nghiệm

- Viết LUA_CHON_TRAI_NGHIEM.md với tám lựa chọn, phương án khác và đánh đổi, không tự đánh dấu đã chốt.
- Chia phần dữ liệu còn thiếu thành sáu gói DL01–DL06, ưu tiên sinh kế để cộng đồng có nguồn sống thật.
- Cập nhật mục lục/trạng thái; chưa chuyển sang lập trình.

## 2026-09-05 — Giao diện text và luồng chơi

- Viết GIAO_DIEN.md với 18 mục, mẫu màn hình và 14 tình huống kiểm chứng khi triển khai.
- Làm rõ bản nháp/lệnh/hiệu lực, dữ liệu cũ khi thế giới chạy, thông tin có giới hạn và dừng trong lúc chỉnh mục tiêu theo cấu hình đề xuất.
- Cập nhật mục lục, kế hoạch và tiến độ; chưa tạo UI hoạt động hoặc kiểm thử trải nghiệm thực.

## 2026-09-05 — Dữ liệu khởi đầu đề xuất

- Viết DU_LIEU_KHOI_DAU.md với danh mục người/địa điểm/vật, nguồn khởi tạo, sổ tiền và công việc có bên trả.
- Tách dữ liệu nền khỏi biến thể thử, ghi phép tính lương thực/nước/linh khí và các trường còn thiếu.
- Chưa tạo dữ liệu game có thể chạy hoặc mô phỏng cân bằng; bước tiếp theo là luồng giao diện text.

## 2026-09-05 — Rà soát liên hệ và kịch bản tích hợp

- Ghi tám điểm cần làm rõ tại giao điểm các hệ trong LIEN_KET_HE_THONG.md, phân công nguồn dữ liệu và quy tắc cập nhật/giao dịch.
- Bổ sung vào chín đặc tả những liên kết/quy tắc tương ứng, đặc biệt hiệu ứng hoàn tất cùng mốc và quyền được công nhận so với hiểu biết người giữ kho.
- Viết BAN_CHOI_THU.md với năm chuỗi tích hợp, 12 điều kiện đánh giá và lựa chọn cần chốt; phân biệt đầu vào kiểm chứng với diễn biến tự nhiên.
- Đây là rà soát văn bản, chưa kiểm chứng toàn bộ tương tác hoặc chạy mô phỏng. Bước tiếp theo là dữ liệu khởi đầu và giao diện text.

## 2026-09-05 — Chiến đấu và hậu quả xung đột

- Viết CHIEN_DAU.md với 24 mục: chính sách, pha hành động, vị trí, nhận biết, phòng hộ, công pháp, truy đuổi, đầu hàng và hậu quả.
- Nối tác động đồng thời, thương tích, vật rơi, nguồn năng lượng và hợp đồng hộ tống với các hệ hiện có.
- Thêm 20 tình huống kiểm chứng; chưa lập trình hoặc xác nhận cân bằng chiến đấu.
- Cập nhật mục lục và trạng thái. Bước tiếp theo là rà soát liên hệ giữa chín hệ và đặc tả chơi thử thống nhất.

## 2026-09-05 — Kinh tế và tổ chức

- Viết KINH_TE_TO_CHUC.md với 26 mục về sinh kế, sản xuất, giao dịch, giá, nợ, hậu cần, quyền hạn và các loại tổ chức.
- Làm rõ tài sản thật so với quyền chi/nghĩa vụ, thông tin thị trường có độ trễ, thực thi luật có hành động và phần thưởng có nguồn.
- Thêm chuỗi thiếu dược liệu và 20 tình huống kiểm chứng; chưa mô phỏng hoặc xác nhận cân bằng kinh tế.
- Cập nhật mục lục và tiến độ; bước tiếp theo là chiến đấu và hậu quả xung đột.

## 2026-09-05 — Môi trường, địa lý, sinh thái và linh khí

- Viết MOI_TRUONG.md với 23 mục về không gian, di chuyển, thời tiết, nước/đất, cây, động vật, khai thác, linh địa và chuyển mức chi tiết.
- Làm rõ nguồn hữu hạn, phục hồi có điều kiện, bảo toàn chuyển giao xuyên vùng và tri thức bản đồ có giới hạn.
- Thêm thung lũng mẫu cùng 18 tình huống kiểm chứng; chưa tạo bản đồ hay chạy mô phỏng sinh thái.
- Cập nhật mục lục và tiến độ; bước tiếp theo là kinh tế và tổ chức.

## 2026-09-05 — Tu luyện, công pháp và đột phá

- Viết TU_LUYEN.md với 25 mục: nguồn năng lượng, cấu trúc vận hành, tư chất, kiến thức/thực hành, nền tảng, bình cảnh và chuyển cảnh giới.
- Định nghĩa đột phá nhiều pha, hậu quả theo trạng thái, kiêm tu/chuyển pháp và ba công pháp mẫu có đánh đổi riêng.
- Thêm 20 tình huống kiểm chứng; chưa định lượng, lập trình hoặc chứng minh cân bằng. Tên công pháp mẫu và hệ cảnh giới chưa được chốt.
- Cập nhật mục lục và tiến độ; bước tiếp theo là môi trường, địa lý, sinh thái và linh khí.

## 2026-09-05 — Vật phẩm, vật liệu và chế tác

- Viết VAT_PHAM.md với 24 mục: danh tính/cấu tạo, vật liệu, chất lượng, công dụng, lô, vị trí, quyền sở hữu, biến đổi, bảo quản và chế tác.
- Làm rõ tránh nhân đôi vật tư, xóa khuyết tật khi gộp lô, sửa miễn phí và sinh vật chất qua tháo/chế lại.
- Thêm hai chuỗi mẫu và 18 tình huống kiểm chứng; chưa tạo thư viện hàng nghìn vật phẩm hoặc chạy mô phỏng.
- Cập nhật trang chủ, kế hoạch và trạng thái; bước tiếp theo là tu luyện/công pháp/đột phá.

## 2026-09-05 — Đời sống và quyết định NPC

- Viết NPC.md với 22 mục về nguồn mục tiêu, tính cách, cảm xúc, hiểu biết, ký ức, quan hệ, lời đồn, giao tiếp và cam kết.
- Làm rõ danh tính thật so với nhận diện, nợ không phụ thuộc việc nhớ, tránh cộng lại ảnh hưởng ký ức và tránh khuếch đại lời đồn vô hạn.
- Thêm câu chuyện mẫu có nhiều kết quả và 18 tình huống kiểm chứng khi triển khai; không tạo NPC hoặc game chạy được ở bước này.
- Cập nhật trang chủ, kế hoạch và trạng thái. Bước tiếp theo là vật phẩm/vật liệu/chế tác, sau đó tu luyện chi tiết.

## 2026-09-05 — Đặc tả cơ thể và thương tích

- Viết CO_THE.md với 21 mục: cấu trúc và mạng phụ thuộc, mô, thương tích, chức năng, sinh lý, nhận biết, điều trị và sinh lý tu tiên.
- Làm rõ tránh tính trùng tổn thương, điều trị cùng mốc sát thương, gián đoạn do bất tỉnh và lưu tiến trình hồi phục.
- Bổ sung 15 tình huống kiểm chứng cho giai đoạn triển khai; chưa chạy mô phỏng hoặc xác nhận độ chính xác sinh học.
- Cập nhật liên kết trang chủ, kế hoạch, thời gian và hành động; bước tiếp theo là đời sống và quyết định NPC.
- Các cơ chế mới vẫn được đánh dấu đề xuất, không tự chuyển thành quyết định của người dùng.

## 2026-09-05 — Bắt đầu đặc tả nền

- Viết THOI_GIAN.md: quy đổi tốc độ, đồng hồ, quá trình liên tục, sự kiện đồng thời, ngắt, vùng xa và lưu tải.
- Viết HANH_DONG.md: mục tiêu, giới hạn, lập kế hoạch, tài nguyên, tiến độ, việc đồng thời, ngắt và giải thích hành vi.
- Bổ sung tình huống và tiêu chí để kiểm chứng khi triển khai; chưa chạy kiểm thử mô phỏng vì chưa có mã game.
- Liên kết từ trang chủ và kế hoạch tổng thể; cập nhật bước tiếp theo sang cơ thể rồi động cơ NPC.
- Mọi quy tắc mới được đánh dấu là đề xuất; chưa chốt công nghệ hay bắt đầu lập trình.

## 2026-09-05 — Đưa hồ sơ vào vault Obsidian thực tế

- Phát hiện người dùng đã tạo vault tại thư mục con `Reality Cultivation/`, có cấu hình `.obsidian`; tài liệu trước đó nằm ngoài vault.
- Chuyển bốn tài liệu trong docs và trang README vào vault, không tạo bản sao nội dung.
- Cập nhật AGENTS.md ở gốc, bổ sung chỉ dẫn trong vault, trang hướng dẫn và metadata điều hướng.
- Giữ nguyên cấu hình Obsidian, Welcome.md và ghi chú create a link.md của người dùng.
- Gốc dự án giữ README dẫn đến vault; hồ sơ chính nằm trong vault từ đây.

## 2026-09-05 — Khởi tạo hồ sơ

- Người dùng nêu tầm nhìn game text tu tiên mô phỏng sâu và yêu cầu lập kế hoạch trước.
- Trợ lý đề xuất kế hoạch 0.1 với 19 nhóm nội dung.
- Theo yêu cầu lưu lâu dài, tạo README.md, AGENTS.md và các tài liệu trong docs.
- Lưu kế hoạch dưới dạng biên tập theo chủ đề; giữ phân biệt yêu cầu người dùng và giả định của trợ lý.
- Chưa lập trình game hoặc chốt công nghệ.



- Thêm bộ mở bản thử nghiệm `MO_GAME.bat` và tài liệu [[HUONG_DAN_MO_BAN_TEST]] để chạy GUI web cục bộ không cần nhập lệnh.
