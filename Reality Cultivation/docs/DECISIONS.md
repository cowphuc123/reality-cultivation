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

## Câu hỏi mở cần giải quyết theo thứ tự phù hợp

Ngày 2026-09-08: hoàn thành V2.3 tại [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]] theo bước tiếp đã ghi. Bảng giờ của N01–N04, cờ `blocking`, bước lùi 30 phút, trần ba lần lùi và giới hạn giữ 24 xung đột gần nhất đều là fixture kỹ thuật do trợ lý đặt để xung đột lịch có thể kiểm chứng; chưa được người dùng duyệt làm cân bằng hoặc mô hình lao động. Trường `priority` đã có trong dữ liệu nhưng chưa được dùng để phân xử, nên không được coi là quy tắc ưu tiên đã chốt. Nhịp sống hiện là bảng giờ cố định, không phải kế hoạch NPC tự lập; điều này không giảm tham vọng NPC tự trị của U004 và K4.6. Việc mở hồ sơ toàn thế giới đáp ứng U015 ở phạm vi dữ liệu đã mô phỏng, không tạo số liệu cho hệ chưa có. TN01–TN08 và ADR công nghệ vẫn mở.

Ngày 2026-09-08: triển khai [[K5_8_V2_1_BENH_NHE_TIEP_TE_KHONG_GIAN_DOI_LICH]] theo bước tiếp đã ghi trong hồ sơ. Loại bệnh, ngày/giờ khởi phát, mức 420, 100 ml nước, bước hồi phục sáu giờ, lượng củi và tiếp tế đều là fixture kỹ thuật do trợ lý đặt để kiểm chứng chuỗi nhân quả; chưa được người dùng duyệt làm cân bằng hay mô hình y khoa. Việc người dùng yêu cầu tiếp tục cho phép triển khai lát cắt kế tiếp, không tự chốt TN01–TN08 hoặc ADR công nghệ.

Ngày 2026-09-08: hoàn thành [[K5_7_GUI_TEXT_GAME_DA_NEN_TANG]] theo U015. Năm khu vực, breakpoint 760/1.080 px, màu rêu–vàng, biểu tượng và cách sắp xếp là lựa chọn triển khai có thể sửa, không phải gu thẩm mỹ cuối đã được người dùng duyệt. “Đầy đủ” trong lượt này nghĩa là mọi chức năng thật đến V2.0 đều có nơi truy cập trên điện thoại và máy tính; các hệ chưa mô phỏng chỉ ghi trạng thái chưa mở.

Ngày 2026-09-07: [[K5_5_V1_2_CO_THE_SINH_LY_SO_SINH]] thêm cơ thể sơ sinh và tick sinh lý theo giờ để khép V1 tối thiểu. Các trạng thái vật chất, công thức đói/khát/nhiệt, 3.400 g, dạ dày 22 ml/kg, dịch 300 kJ/100 ml và 92 ml nước/100 ml, hao phí, ngưỡng ngủ, tăng 22/4 g cùng dải kiểm tra đều là fixture kỹ thuật do trợ lý đặt; chưa được người dùng duyệt, không mô tả y khoa và có thể thay khi cân bằng. Việc V1 đạt chức năng tối thiểu chỉ cho phép chuyển sang V2, không giảm tham vọng mô phỏng cơ thể sâu của U005.

Ngày 2026-09-07: [[K5_4_V1_1_CHUOI_CHAM_SOC_NHAN_QUA]] thay phản ứng chăm sóc tức thì của K5.3 bằng chuỗi nhân quả có tín hiệu, ngưỡng nghe, công việc bị ngắt, thời gian di chuyển, thao tác và vật phẩm bị tiêu hao/hao mòn. Đây là triển khai prototype theo U014 và nguyên tắc NPC tự trị; trục vị trí một chiều, cường độ 900, suy hao `/10`, ngưỡng 300, tốc độ 1.000 mm/s, thao tác 60 giây và hai vật mẫu đều là fixture chưa được người dùng chốt. Không suy các con số này thành vật lý, sinh lý hoặc cân bằng chính thức.

Ngày 2026-09-07: [[K5_3_V1_THANG_DAU_SO_SINH]] đã triển khai prototype V1 cho ngày 0–30 bằng working stack S2. Khả năng điều khiển từ sơ sinh của U014 nay có bằng chứng chạy: mục tiêu tự do của người lớn bị chặn, ý định mở theo tuổi, nhu cầu sinh tiếng khóc, Person người chăm sóc phản ứng và save/load giữ kết quả. Các hệ số nhu cầu, ngưỡng khóc, ngày mở vươn tay và đường phát triển giác quan là fixture do trợ lý đặt để kiểm chứng, chưa được người dùng duyệt và không phải tuyên bố y khoa; phản ứng tức thì ban đầu đã được K5.4 thay thế.

Ngày 2026-09-07: [[K5_2_SPIKE_DOI_CHUNG_VA_ADR_CONG_NGHE]] đặt ADR-K3-STACK-001 ở trạng thái PROPOSED: dùng Dart core + Flutter làm working stack có thể đảo ngược cho V1. Đây là quyết định kỹ thuật tạm thời để tiếp tục triển khai, không phải lựa chọn công nghệ đã được người dùng xác nhận và không phải ADR ACCEPTED. Shared SPIKE-V0-01 cho S2 Dart và S0 JavaScript cùng hash `5629ba88282991c6` qua 500 lượt; full SPIKE-W0-01, S1/S3, Android/Windows native, isolate, sustained memory và accessibility vẫn thiếu.

Ngày 2026-09-07: phần chức năng V0 đã có lưu/tải UI, autosave khi xuống nền, restore lúc mở và adapter `shared_preferences` 2.5.5. Bốn widget test xác nhận bố cục mobile/desktop, round-trip save A→B→A và lifecycle save/restore; web release có plugin biên dịch thành công. `shared_preferences` chỉ là storage prototype cho save nhỏ, không thay quyết định storage dài hạn K2.5/K3.5. Chưa kiểm chứng thiết bị native, chưa chọn Flutter làm stack cuối và chưa chốt chính sách autosave/offline của người dùng.

Ngày 2026-09-06: K5.1 được mở rộng với clock 5 giây/ngày, pause/backlog, CommandPort/QueryPort, catalog 11 điều kiện và shell Flutter thích nghi. Test điện thoại 390×844, máy tính 1280×800, analyze và build web release đều đạt. Android/Windows source đã tạo nhưng máy thiếu Android SDK và Visual Studio C++ để đóng gói native. Kết quả này làm S2 Dart/Flutter khả thi hơn nhưng chưa phải quyết định stack của người dùng; vẫn cần ADR và bằng chứng đối chứng.

Ngày 2026-09-06: người dùng tiếp tục sau khi K4.9 hoàn tất, vì vậy K5.1 đã bắt đầu tại [[K5_1_PROTOTYPE_LOI_V0]]. Prototype lõi Dart chạy được với time/event/command/birth/save-load/replay và hash kiểm chứng 5629ba88282991c6. Đây là bằng chứng triển khai, không phải xác nhận Dart/Flutter là stack cuối, không chốt phạm vi bản đầu và không đổi trạng thái 1.860 điều kiện thiết kế cũ. Tại thời điểm đầu Flutter launcher bị khóa; sau đó đã chạy được với biến bỏ qua khóa. Rust/Cargo không có; các spike đối chứng và ADR còn mở.

Ngày 2026-09-06: hoàn thành [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]] cho K4.9. Gói K4.1–K4.8 có 8 tài liệu, 8.296 dòng và 756 điều kiện; tổng toàn hồ sơ giữ 1.860 thuộc 41 họ. Chuỗi worldgen–tiền sử–chọn nơi–BirthEvent–điều khiển sơ sinh đã được đưa vào 12 vertical slice. Đề xuất bản đầu tập trung một vùng active nhưng có macro world rộng, nội dung từ sinh tới ít nhất 20 tuổi game và một mốc tu luyện chức năng đầu; các giới hạn này chưa được người dùng xác nhận. K4I01–K4I06 đạt trên giấy, K4I07–K4I16 chưa đạt. Bước triển khai đề xuất là prototype stack → ADR → artifact bootstrap → V0 → V1 sơ sinh; chưa tự bắt đầu code.

Ngày 2026-09-06: thêm [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]] cho K4.8. Combat ở trong thời gian/không gian chung; target dựa perception, reaction là Action, impact đi qua vật/hiện tượng/body một lần và không có HP canonical. Vũ khí–giáp–projectile, thuật pháp–counter, nhóm–mệnh lệnh, phục kích–ẩn nấp–truy đuổi, đầu hàng–bắt giữ, scene–evidence–investigation–law và BR0–BR5 đều là đề xuất chưa triển khai. Geometry, tốc độ chiến đấu, độ sâu projectile/fire, võ kỹ/thuật khởi đầu, bay, tù nhân, mức hiển thị bạo lực và quy mô battle chưa chốt. CX01–CX96 chưa chạy, nâng tổng từ 1.764 lên 1.860 thuộc 41 họ. K4.9 được đề xuất tiếp theo để kiểm toán K4 và chốt bản game đầu tiên; TN01–TN08 vẫn mở.

Ngày 2026-09-06: người dùng xác nhận U014: sau khi chọn nơi trên bản đồ, nhân vật được sinh ra và người chơi điều khiển ngay từ sơ sinh. Tuổi thơ không được tự động tóm lược bỏ qua. Khả năng ra lệnh phải phụ thuộc phát triển cơ thể, giác quan, ngôn ngữ, vận động, người chăm sóc và kiến thức; người chơi vẫn có thể đặt ý định phù hợp độ tuổi. Cơ chế kế thừa sau chết vẫn mở.

Ngày 2026-09-06: người dùng xác nhận luồng worldgen tại [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]. Game không chạy theo cốt truyện chính cố định. World genesis tạo nền, mô phỏng tiền sử hàng trăm–hàng vạn năm không có nhân vật chính, công bố snapshot hiện tại, rồi người chơi chọn vị trí và nhân vật mới sinh/nhập thế. Seed và ngẫu nhiên chỉ giải bất định trong quy luật; câu chuyện là View từ lịch sử thật. Tuổi thế giới mặc định, kích thước, ngân sách tạo, tuổi bắt đầu điều khiển, mức chọn xuất thân và kế thừa sau chết vẫn mở.

Ngày 2026-09-06: thêm [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]] cho K4.7. Kinh tế dùng vật, công, quyền, claim và thông tin thật; giá là điều khoản địa phương, tổ chức hành động qua người/role/procedure và không có tri thức toàn cục. Household, production/service, labor, market, money/credit/logistics, land/resource rights, Organization/Charter/Authority, tông môn–gia tộc–chính quyền, law/evidence/ruling/enforcement, status/power/faction và SE0–SE5 đều là đề xuất chưa triển khai. Tiền tệ, quyền đất/linh mạch, hình thức chính quyền, luật, hình phạt, giai cấp và thừa kế chưa chốt. XH01–XH96 chưa chạy, nâng tổng từ 1.668 lên 1.764 thuộc 40 họ. K4.8 được đề xuất tiếp theo cho chiến đấu và hậu quả xung đột; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]] cho K4.6. PersonAgent chỉ quyết định qua Fact–Evidence–Belief–Command; cơ thể, vật, quyền và outcome vẫn thuộc domain thật. Drive/Value/GoalGraph/PlanPortfolio, attention, memory, affect, SelfModel, quan hệ đa chiều, household, giao tiếp–thương lượng–hợp tác–xung đột, nghề–học–tu luyện, vòng đời và StoryCandidate read-only đều là đề xuất chưa triển khai. AR0–AR5 giữ từng Person ở vùng xa và không cho story layer can thiệp kết quả. Mô hình trait/value, độ sâu planner, gia đình, chủ đề nhạy cảm, ngôn ngữ sinh và ngân sách 100.000 NPC chưa chốt. NP01–NP96 chưa chạy, nâng tổng từ 1.572 lên 1.668 thuộc 39 họ. K4.7 được đề xuất tiếp theo cho kinh tế, tổ chức và xã hội sâu; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]] cho K4.5. Công pháp là TechniqueDefinition có ProgramIR, tuyến cơ thể, nhịp, chuyển hóa, phản hồi và hậu quả; tri thức/niềm tin về công pháp tách khỏi định nghĩa thật và MasteryState của từng người. Linh căn dùng SpiritualInterfaceProfile thay vì một phẩm cấp tuyệt đối; cảnh giới là chuẩn phân loại từ trạng thái thật, không phải level/XP canonical. Học–dạy–sao chép–dịch–phục dựng–cải biên, bình cảnh–đột phá, kỹ năng–thuật pháp–khắc chế, truyền thừa/tông môn và CR0–CR5 đều là đề xuất chưa triển khai. Cosmology, tên cảnh giới, bản chất hồn, luật thề và giới hạn thần thông chưa chốt. CP01–CP96 chưa chạy, nâng tổng từ 1.476 lên 1.572 thuộc 38 họ. K4.6 được đề xuất tiếp theo cho NPC tự trị, nhu cầu, kế hoạch, quan hệ, ký ức và câu chuyện phát sinh sâu; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]] cho K4.4. Không gian theo hierarchy/topology và lưu vực; thời tiết chỉ sinh lười trước khi ảnh hưởng, sau đó trở thành canonical. Nước–trầm tích–đất–dinh dưỡng, Species–Population–FoodWeb, disturbance/succession, linh mạch/linh sinh quyển, khai thác/ô nhiễm và ER0–ER5 đều là đề xuất chưa triển khai. Cosmology, khí hậu An Khê, danh mục loài, chu trình linh khí, tần suất thiên tai và quyền tài nguyên chưa chốt. MT01–MT96 chưa chạy, nâng tổng từ 1.380 lên 1.476 thuộc 37 họ. K4.5 được đề xuất tiếp theo cho công pháp, cảnh giới, linh căn, kỹ năng, thuật pháp và truyền thừa sâu; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]] cho K4.3. Vật phẩm tách Definition–DesignBlueprint–ItemInstance–View; công dụng suy từ vật liệu, geometry, part/joint/mechanism, tình trạng, actor và tác vụ. Quality, Condition, Grade và Claim không đồng nhất. CraftPlan tạo Workpiece qua từng operation, giữ input/output/waste, deviation và lịch sử; IR0–IR5 giảm tải nhưng item có identity không trở lại lot vô danh. Material set, chuẩn kích thước, phẩm cấp, mức tự do chế tác và luật pháp khí chưa chốt. VP01–VP96 chưa chạy, nâng tổng từ 1.284 lên 1.380 thuộc 36 họ. K4.4 được đề xuất tiếp theo cho địa lý, khí hậu, thủy văn, đất, sinh thái và linh sinh quyển; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]] cho K4.2. Cơ thể không có HP canonical; sự thật nằm ở anatomy/topology, tissue, compartment, flow, controller, reserve, injury/pathology và function dẫn xuất. AnatomyDefinition/BodyInstance, chảy máu/đông máu, nội môi, bệnh–độc–thuốc–điều trị, hồi phục/sẹo, phát triển–lão hóa–tử vong, spiritual anatomy và B0–B5 đều là đề xuất chưa triển khai. Bản chất hồn, độ sâu y sinh, quy tắc chết/hồi sinh và giới hạn tái tạo chưa chốt. CT01–CT96 chưa chạy, nâng tổng từ 1.188 lên 1.284 thuộc 35 họ. K4.3 được đề xuất tiếp theo cho vật liệu, vật phẩm, cấu trúc, công dụng và chế tác sâu; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]] cho K4.1. Entity–State–Field–Process, Quantity/Unit/Dimension, MatterParcel/Composition/Structure, conservation/energy ledger, PhenomenonProcess, BoundaryFlow, CouplingRule/LawRef và P0–P4 là đề xuất nền chưa triển khai. Linh khí không mặc định là thanh mana: bản chất, loại, luật bảo toàn/sinh-diệt, thuộc tính và khả năng đo vẫn chưa chốt. P0–P4 là độ phân giải hiện tượng, tách M0–M4 và R0–R4. VL01–VL84 chưa chạy, nâng tổng từ 1.104 lên 1.188 thuộc 34 họ. K4.2 được đề xuất tiếp theo cho cơ thể đa tầng, sinh lý, bệnh lý và tu luyện hóa cơ thể; TN01–TN08 vẫn mở.

Ngày 2026-09-06: hoàn thành [[KIEM_TOAN_DONG_GOI_K3]] cho K3.7. Gói K3.1–K3.6 có 6 tài liệu, 4.917 dòng và 420 điều kiện; cộng 684 trước K3 thành 1.104 thuộc 33 họ, tất cả vẫn chưa chạy. Chuỗi kiến trúc từ hợp đồng K2 qua module, ứng viên công nghệ, nội dung sinh, phân tầng, lưu trữ và artifact khép trên giấy. K3X01–K3X15 đạt trên giấy; K3X16–K3X24 chưa đạt do thiếu schema/catalog máy, codegen, runner, evidence, parity/save run, benchmark và ADR chọn stack. Không thêm điều kiện mới hoặc tự xác nhận TN01–TN08. K4.1 được đề xuất tiếp theo cho vật chất, năng lượng, trường và hiện tượng nền.

Ngày 2026-09-06: thêm [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]] cho K3.6. Vault là nguồn giải thích/quyết định cho người; artifact máy phải có SourceRef/semantic anchor dẫn ngược. ArtifactEnvelope, Schema Registry, version/compatibility, IR/codegen, content/fixture/policy/generator/migration/workload, ConditionSpec, EvidenceBundle và build graph đều là đề xuất chưa triển khai. Condition có automation_state tách result_state: ENCODED/IMPLEMENTED không đồng nghĩa RUN/PASS. Catalog hóa phải giữ NOT_RUN và lịch sử revision. AM01–AM80 chưa chạy, nâng tổng từ 1.024 lên 1.104 thuộc 33 họ. K3.7 nay đã kiểm toán/đóng gói sáu tài liệu tại [[KIEM_TOAN_DONG_GOI_K3]]; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]] cho K3.5. Canonical World State, Portable Save Image và Derived Index/Cache/View phải tách; live storage layout không là save format công khai. Single writer, read snapshot, cross-shard commit, revision vector, frontier/flow/anchor shards, capability-aware query và index lifecycle đều là contract trung lập engine. Bốn họ F append-file, R relational, K key-value/LSM và H hybrid chỉ là ứng viên cần cùng spike; chưa chọn database, file format, codec, compression hoặc encryption. LU01–LU76 chưa chạy, nâng tổng từ 948 lên 1.024 thuộc 32 họ. K3.6 nay đã định artifact/schema/catalog tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]] cho K3.4. M0–M4 biểu thị mức dữ liệu tồn tại; R0–R4 biểu thị cách giải thời gian và hai trục không được trộn. Person đã đạt M2 không được trở về cohort M1; R4 giữ từng PersonCore/id và chỉ batch cách tính rồi phân delta/provenance riêng. Cohort chỉ đại diện dân số chưa cá thể hóa. Promotion phải xảy ra trước tương tác; demotion phải qua boundary/invariant/retention gate. W4 chỉ được đếm 100.000 Person M2+ thật, không cộng cohort. PT01–PT72 chưa chạy, nâng tổng từ 876 lên 948 thuộc 31 họ. K3.5 nay đã định lưu trữ và truy vấn tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]] cho K3.3. “Vô hạn” được hiểu là không gian nội dung/thế giới có thể mở rộng theo seed và quy tắc, không phải vô hạn record đã lưu. Một entity chỉ được nói là cá thể tồn tại sau khi materialize; từ đó identity, provenance, lịch sử, quyền và hậu quả phải bền vững. Vùng LATENT/SUMMARIZED dùng seed, macro ledger và anchor; promotion không được bịa theo nhu cầu người chơi. Definition/Blueprint/Instance/View, content package, generator, taxonomy đa miền, base/delta/tombstone, DSL/pipeline/oracle đều là đề xuất chưa triển khai. ND01–ND68 chưa chạy, nâng tổng từ 808 lên 876 thuộc 30 họ. K3.4 nay đã định mô phỏng phân tầng tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]] cho K3.2 sau khi kiểm tra tài liệu chính thức cùng ngày. S1 Rust/Tauri 2, S2 Dart/Flutter và S3 Kotlin/Compose Multiplatform là shortlist prototype ngang hàng; S4 .NET MAUI là dự phòng, PWA là đối chứng. Đây chưa phải quyết định stack. Mỗi ứng viên phải chạy cùng fixture/scenario/fault/metric, qua disqualifier về parity, lifecycle, save, Command/View và core độc lập trước khi chấm ADR. P0 Android+Windows và P1 iOS/macOS/Linux là đề xuất phạm vi kiểm chứng, chưa phải phạm vi phát hành đã duyệt. CN01–CN64 chưa chạy, nâng tổng từ 744 lên 808 thuộc 29 họ. K3.3 nay đã định kiến trúc dữ liệu nội dung/sinh thế giới tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]] cho K3.1. Kiến trúc đề xuất dùng một single-writer Simulation Runtime, dependency hướng vào core, tách World Model/Scheduler/Transaction/Cognition/Domain/View/Save/Validation/Observability/Platform và chỉ giao tiếp qua các port có kiểu. Mobile và desktop dùng cùng semantic projection, command, save format và core logic; shell chỉ phụ trách lifecycle/input/render/storage adapter. Concurrency, R0–R4 và sync đều phải giữ determinism. KT01–KT60 chưa chạy, nâng tổng từ 684 lên 744 thuộc 28 họ. Chưa chọn ngôn ngữ/framework/database/UI toolkit/cloud hoặc topology vật lý cuối cùng. K3.2 nay đã lập shortlist, spike/evidence và ADR nháp tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]; TN01–TN08 vẫn mở.

Ngày 2026-09-06: hoàn thành [[KIEM_TOAN_DONG_GOI_K2]] cho K2.8. Gói K2.1–K2.7 có 7 tài liệu, 4.822 dòng và 308 điều kiện; cộng 376 trước K2 thành 684 thuộc 27 họ, tất cả chưa chạy. Chuỗi hợp đồng schema–scheduler–transaction–cognition–save–oracle–performance khép trên giấy. K2G01–K2G14 đạt/đạt trên giấy; K2G15–K2G20 chưa đạt do thiếu schema/catalog máy, runner/oracle/evidence, save/parity run và benchmark. Không thêm điều kiện mới hoặc tự chọn TN/công nghệ. K3.1 nay đã bổ sung kiến trúc đa nền tảng và ranh giới module; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[NGAN_SACH_HIEU_NANG_QUY_MO_K2]] cho K2.7. Metric/Workload/DeviceProfile, W0–W4, ngân sách W1 mobile/desktop, slicing/latency, memory/save/storage/energy/thermal, event/cognition/perception/body/economy costs, R0–R4/ErrorBudget, CapacityEnvelope, backpressure/overload, benchmark/evidence/regression và HN01–HN56 đều là đề xuất kỹ thuật chưa duyệt/chạy. Không tự chốt thiết bị tối thiểu, capacity phát hành hoặc công nghệ. W1 là mục tiêu ban đầu; W2–W4 cần bằng chứng riêng. Máy chậm không được đổi logic. Tổng tăng từ 628 lên 684. K2.8 nay đã kiểm toán/đóng gói K2.1–K2.7; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[KE_HOACH_VALIDATOR_ORACLE_K2]] cho K2.6. Inventory 25 họ/576 điều kiện, ConditionSpec, FixtureSpec, RunSpec/Fingerprint, ResultStatus, Validator/Oracle/Monitor/Gate, oracle theo miền, metamorphic/replay/parity, determinism/fault/shrink, EvidenceBundle/FailureArtifact, coverage/dependency, V0–V5 và VO01–VO52 đều là đề xuất kỹ thuật chưa duyệt/chạy. Không tự chốt framework, CI, thiết bị chuẩn, ngưỡng hiệu năng hoặc policy TN. NOT_RUN/BLOCKED/UNSUPPORTED không là PASS; BT/K1G là gate không đếm lặp. Tổng tăng từ 576 lên 628. K2.7 nay đã bổ sung hiệu năng/quy mô/đo tải; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[HOP_DONG_LUU_TAI_MIGRATION_PHUC_HOI_K2]] cho K2.5. World lineage/branch/generation, SaveSlotManifest, SaveBoundaryToken, SnapshotImage, Journal/Checkpoint, công bố hai pha, lifecycle/crash recovery, OfflinePolicy, LoadPipeline, Compatibility/MigrationGraph, corruption/repair, technical rollback, retention/compaction, import/sync conflict và LP01–LP48 đều là đề xuất kỹ thuật chưa duyệt/chạy. Không tự chốt định dạng, hash, mã hóa, autosave, cloud sync, OFFLINE_STOP/CATCHUP hoặc quyền tải lại. Bản cũ phải còn nguyên cho tới khi bản mới được xác minh; hai nhánh thiết bị không auto-merge. Tổng tăng từ 528 lên 576. K2.6 nay đã bổ sung validator/oracle và kế hoạch chạy điều kiện; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[HOP_DONG_NHAN_THUC_QUYET_DINH_TAC_NHAN_K2]] cho K2.4. Proposition có phạm vi, PerceivableSignal/ObservationCandidate, Attention, Message/Comprehension, Evidence/lineage, BeliefRevision, Memory/Inference, GoalGraph, Appraisal, DecisionFrame/Option, wakeup, Dialogue, AgentState, P00 policy, R0–R4 và NT01–NT44 đều là đề xuất kỹ thuật chưa duyệt/chạy. Không tự chốt công thức confidence/điểm, mô hình quên/chú ý, quyền chống lệnh, thần thức hay AI ngôn ngữ. NPC không được đọc Fact bí mật; độ chi tiết tính toán không được phụ thuộc sức thiết bị. Tổng tăng từ 484 lên 528. K2.5 nay đã bổ sung lưu/tải, migration và phục hồi; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]] cho K2.3. Ba lớp khả thi vật lý–cho phép vận hành–hợp lệ chuẩn tắc, AssetRef, OwnershipInterest, Claim, RightGrant, Contract/Obligation, TransactionPlan, Reservation, ConflictPolicy, split/merge, conservation/source/sink, ledger và GV01–GV40 đều là đề xuất kỹ thuật chưa duyệt/chạy. Không tự chốt luật sở hữu, tiền tệ, thuế, giá hay thị trường. Hành vi trái quyền vẫn có thể xảy ra vật lý nếu không bị chặn, nhưng không tự đổi title và chỉ bị biết qua bằng chứng. Tổng tăng từ 444 lên 484. K2.4 nay đã bổ sung nhận thức/quyết định/NPC; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]] cho K2.2. SchedulerState, EventBatch, wave, recurrence, ProcessInstance/tích phân nguyên, tám pha, ConflictSet, stale event, pause/overload, R0–R4, offline policy và LS01–LS36 đều là đề xuất kỹ thuật chưa duyệt/chạy. Không chọn heap, số luồng, worker hay ngưỡng hiệu năng. Event cùng mốc không phân thắng theo id; sự kiện chen vào pha đã đóng bị từ chối; máy chậm không được bỏ luật. Tổng tăng từ 408 lên 444. K2.3 nay đã bổ sung giao dịch, quyền và bảo toàn vật chất; TN01/TN02 vẫn mở.

Ngày 2026-09-06: thêm [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]] cho K2.1. Kiểu số nguyên/đơn vị, id có miền, RecordEnvelope, quy tắc unknown/null, các hợp đồng record, transaction nguyên tử, tám pha, overlay, RNG, migration, canonical state hash và HD01–HD32 đều là đề xuất kỹ thuật chưa duyệt/chạy; chưa chọn JSON, binary, cơ sở dữ liệu, ngôn ngữ hay thuật toán hash. K2.2 nay đã bổ sung hợp đồng scheduler; TN01–TN08 vẫn mở.

Ngày 2026-09-06: hoàn thành kiểm toán tài liệu [[KIEM_TOAN_DONG_GOI_K1]] cho K1.12. Gói K1.1–K1.11 có 238 điều kiện, cộng 138 điều kiện nền thành 376; K1G01–K1G08 đạt hoặc đạt trên giấy, còn K1G09–K1G12 chưa có dữ liệu máy/bộ chạy/bằng chứng. Thứ tự phụ thuộc, sổ không gian tên, ranh giới base–overlay và ma trận độ sẵn sàng là đề xuất kỹ thuật, chưa chốt công nghệ. K2.1 nay đã lập hợp đồng dữ liệu chung; TN01–TN08 vẫn mở.

Ngày 2026-09-06: thêm [[DAU_VET_QUYET_DINH_HOI_THOAI_K1]] cho K1.11. DialogueIntent/UtteranceSignal/DialogueAct, DecisionTrace, công thức điểm, tám dấu vết DT-H01/DT-O04/DT-O03-A/DT-O03-B/DT-DUNG/DT-O06/DT-PHUC-HUE/DT-P00 và DV01–DV28 đều là fixture đề xuất chưa duyệt/chạy. Câu mẫu chỉ diễn đạt payload có cấu trúc, không tự tạo Fact, quyền, giao dịch, cam kết hoặc kết quả vật chất. Chỉ DT-H01 xác nhận khoản C01 đã có trong lịch cơ sở; các dấu vết còn lại là overlay/biến thể, không viết sẵn tương lai. Ba chính sách P00 vẫn mở. K1.12 nay đã kiểm toán và đóng gói K1.1–K1.11.

Ngày 2026-09-06: thêm [[TAM_LY_21_NGUOI_K1]] cho K1.10. Tám trục CA/PE/OR/CO/AU/SE/NO/EX, 13 Value, Affect/Pressure, số khởi tạo NPC, thời gian bán giảm, giới hạn đổi Trait 90 ngày, TL-X01–TL-X08 và TL01–TL26 đều là fixture đề xuất chưa duyệt/chạy, không phải chẩn đoán ngoài đời. Trait/Value P00 giữ U; PLAYER-DIRECT chỉ là chính sách tương thích fixture, chưa chốt trải nghiệm. K1.11 đã bổ sung dấu vết quyết định/hội thoại và K1.12 đã kiểm toán gói K1.

Ngày 2026-09-06: thêm [[NANG_LUC_NGON_NGU_TRI_THUC_K1]] cho K1.9. LANG-AK, SCRIPT-AK, sáu LEX, thang H/S/R/W/C/A, mức từng người, KnowledgeUnit, MARK:P00-INIT, NN-X01–NN-X06 và NL01–NL24 là fixture đề xuất chưa duyệt/chạy. P00 của INIT-A được đặt H/S2, R/W0 theo bằng chứng hiện có; đây không phải giới hạn cho mọi nhân vật người chơi. Không thêm ngoại ngữ khi chưa có nguồn. K1.10 nay đã bổ sung tâm lý đề xuất; quyền tự chủ P00 vẫn mở.

Ngày 2026-09-06: thêm [[SO_THE_CHE_30_NGAY_K1]] cho K1.8. V34–V36, khung tin D01, HIST:AK-RECORDS, thời lượng ghi/đọc, sổ cơ sở, TC-X01–TC-X08 và ST01–ST24 là fixture đề xuất chưa duyệt/chạy. Danh mục thử tăng từ 33 lên 36 loại; không đổi tiền, thức ăn, công pháp hoặc kết quả 30 ngày cũ. ENTRY-TXN không tự chuyển vật và thông báo công khai không tự tạo tri thức. K1.9 nay đã xác định năng lực/ngôn ngữ đề xuất trước khi kiểm toán sổ.

Ngày 2026-09-06: thêm [[VAN_HOA_THE_CHE_AN_KHE_K1]] cho K1.7. Tuổi trưởng thành 18, mốc cư trú 90 ngày, tập quán một bạn đời, thứ tự Claim thừa kế, hội đồng ba người, hạn tạm dừng 24 giờ, quyền O03/O04 và VH01–VH22 đều là tham số fixture đề xuất, chưa duyệt/chạy và không phải luật chung mọi vùng. Quan hệ không tự cấp quyền tài sản/cơ thể; PublicNotice không tự làm mọi NPC biết. K1.8 nay đã vật chất hóa sổ/kênh tin; các khả năng ngôn ngữ vẫn còn mở cho K1.9.

Ngày 2026-09-06: thêm [[HO_SO_NPC_AN_KHE_K1]] cho K1.6. Quan hệ hộ/họ hàng, HIST, LongGoal, xung đột và SEC01–SEC19 là dữ liệu khởi tạo đề xuất, chưa duyệt/chạy. Chúng giải thích kỹ năng/lịch ngày 1 nhưng không thêm tài sản, thương tích, công pháp hoặc tương lai bắt buộc. K1.7 nay đã bổ sung văn hóa/thể chế đề xuất; chưa coi quan hệ fixture là luật chung thế giới.

Ngày 2026-09-06: thêm [[DOI_SONG_TU_SINH_K1]] cho K1.5. Vòng đời, hộ, quan hệ, sinh sản, già/bệnh/chết, thừa kế, EventClock, R0–R4, sổ dân số và xử lý quá tải là kiến trúc đề xuất chưa duyệt/chạy. Mọi NPC ở R4 vẫn có Person riêng. Các quy tắc văn hóa, tuổi thọ và quy mô thiết bị chưa được tự chốt; yêu cầu điện thoại/máy tính chỉ buộc cùng kết quả logic. K1.6 nay đã có hồ sơ đầu kỳ nhưng chưa chạy.

Ngày 2026-09-06: thêm [[NHANH_XUNG_DOT_K1]] cho K1.4. Tám nhánh X01–X08, cách thay người, thời gian trễ, kết sổ thay thế và NX01–NX18 là fixture đề xuất, chưa duyệt hoặc chạy. Nhánh X02 chỉ cho N17 thay N05 khi có bằng chứng kỹ năng; X08 giữ thất bại nếu không có người thay. Đây không phải cam kết NPC luôn tối ưu hoặc thế giới luôn tự cứu. Tại thời điểm ghi mục này K1.5 còn mở; nay đã có kiến trúc đời sống dài hạn nhưng chưa chạy.

Ngày 2026-09-06: thêm [[SO_SU_KIEN_30_NGAY_K1]] cho K1.3. Sổ theo phút và bảng cuối ngày là đối chiếu thủ công của nhánh cơ sở, chưa phải kết quả mô phỏng. Nó sửa hai mâu thuẫn: P00 ngày 2 chỉ cần lấy 1.500 ml và N05 phải đi D01↔D02 để nhận suất trước. Các mốc, nhánh không biến cố và SS01–SS16 vẫn là đề xuất chưa duyệt/chạy. Tại thời điểm ghi mục này K1.4 còn mở; nay đã có tám nhánh đề xuất nhưng chưa chạy.

Ngày 2026-09-06: thêm [[NGUON_QUYET_DINH_K1]] cho K1.2. Các hồ sơ Observation/Message/Belief/Memory/Inference/DecisionFrame, hạn dùng niềm tin, nguồn lịch của 20 NPC và chuỗi nhận thức P00 là kiến trúc fixture đề xuất, chưa được duyệt hoặc chạy. Chính sách P00 ưu tiên lệnh sau sinh tồn/cam kết chỉ dùng để FX-A-30D tái hiện được; quyền tâm lý chống lệnh vẫn mở. Tại thời điểm ghi mục này K1.3 còn mở; nay đã có sổ thủ công nhưng chưa chạy.

Ngày 2026-09-06: thêm [[LICH_21_NGUOI_K1]] cho K1.1. Lịch 24 giờ, phân công, giờ ăn/uống, các ngoại lệ và LC01–LC18 là fixture do trợ lý đề xuất, chưa được người dùng duyệt hoặc chạy. Lịch mua của P00 chuyển từ ngày lẻ 7–29 sang chiều ngày chẵn 6–28 để sáu suất đầu kỳ nối liên tục với 24 suất mua; đây là sửa mâu thuẫn dữ liệu, không chốt chính sách ăn dài hạn. Tại thời điểm ghi mục này K1.2 còn mở; nay đã có đề xuất nhưng chưa chạy.

Ngày 2026-09-06: kiểm toán lần hai trong [[KIEM_TOAN_TICH_HOP]] sửa ba lỗi tài liệu và xác nhận sáu việc K0 không phải mở lại. Việc gọi N01 trong A-BOOT, xử lý B-CARE bị hủy và gộp dịch theo tuyến là sửa nhất quán fixture, không phải quyết định trải nghiệm của người dùng. Tại thời điểm kiểm toán, FX-A-30D còn chờ K1.1; phần này nay đã được bổ sung nhưng chưa chạy.

Ngày 2026-09-06: thêm [[CHAM_SOC_K0]] cho K0.6. Hạn băng 24 giờ, năm V05 trong B-LOCAL, ba đích dịch, ngưỡng chức năng và lịch hồi phục W-E là hệ số fixture do trợ lý đề xuất; chưa được người dùng duyệt, chưa chạy và không phải hướng dẫn y khoa.

Ngày 2026-09-05: người dùng xác nhận yêu cầu chạy trên điện thoại và máy tính (U011). Giao diện phải thích nghi màn hình hẹp/rộng và hỗ trợ chạm lẫn bàn phím; đây là yêu cầu. Công nghệ đóng gói, cấu hình máy tối thiểu và đồng bộ bản lưu giữa thiết bị chưa được chốt.

Ngày 2026-09-05: thêm [[DU_LIEU_LIEN_KET_K0]] cho K0.2–K0.5. V33, vị trí 2.000 V01, lịch A-BOOT/giao nhận/nước và hai fixture C là đề xuất kiểm chứng chưa được duyệt hoặc chạy. Không coi lịch fixture là quy luật kinh tế chung.

Ngày 2026-09-05: thêm [[LUOC_DO_TRANG_THAI]] cho K0.1. Đơn vị nguyên, mã có miền, tám pha, giao dịch nguyên tử, cấu trúc save/RNG/fixture và 16 DS là đề xuất kiến trúc dữ liệu, chưa phải lựa chọn công nghệ hoặc triển khai. Tài liệu đề xuất tiếp tục giữ V01 là tiền vật chất để giải quyết K0.2; chưa nâng đề xuất này thành quyết định của người dùng.

Ngày 2026-09-05: [[KIEM_TOAN_TICH_HOP]] xác định sáu gói có 88 tình huống dự kiến nhưng chưa tình huống nào chạy. Chuỗi C chưa đủ tái hiện; tiền vật chất, A-BOOT, thời điểm giao nhận và diễn biến chăm sóc là các thiếu hụt K0. Cách phân nhóm K0/K1/K2 là đề xuất thứ tự làm việc, không cắt mục tiêu dài hạn hoặc xác nhận phạm vi bản đầu.

Ngày 2026-09-05: thêm [[CHIEN_DAU_THU]] cho DL06. Hình học, thời lượng, sai số, stress, sức chặn, W-E01/E02 và Xung Đẩy Thử là thông số gameplay hư cấu chưa được duyệt. INIT-E là tình huống riêng có đồ mượn/thỏa thuận khởi tạo, không ép giao chiến vào INIT-A. Xung Đẩy Thử không phải năng lực đã cấp cho P00 hoặc công pháp chính thức.

Ngày 2026-09-05: thêm [[TU_LUYEN_THU]] cho DL05. Kho P/B, các tuyến, hiệu suất ba công pháp và chuyển mốc TM-01 là thông số gameplay hư cấu chưa được duyệt. M1 chỉ là mốc chức năng kiểm chứng, không chốt tên cảnh giới. Một bài J05 chưa đủ cho P00 tự luyện; quyền tự chuyển mốc vẫn phụ thuộc lựa chọn trải nghiệm còn mở.

Ngày 2026-09-05: thêm [[CONG_VIEC_THU]] cho DL04. Quy tắc nhận việc, điểm ưu tiên, chống đổi việc liên tục, thời lượng thao tác và lịch A-DAY là đề xuất. Lịch A-DAY đòi hỏi đã có kiến thức/hợp đồng, không thay INIT-A; chưa xác nhận tính khả thi tự chủ của 21 người. TN01–TN08 vẫn mở.

Ngày 2026-09-05: thêm [[CO_THE_THU]] cho DL03. Công thức chức năng, mệt/ngủ/nhu cầu và W-B01 là hệ số gameplay hư cấu chưa được duyệt. B-LOCAL có khởi tạo riêng về địa điểm, vật tư và quyền chăm sóc; không coi đó là diễn biến NPC tự tạo. Chưa có mô hình y khoa hoặc mô phỏng cơ thể hoàn chỉnh.

Ngày 2026-09-05: thêm [[VAT_THE_THU]] cho DL02. Khối lượng/kích thước, sức chứa, tải và tốc độ thử, thành phần cây hư cấu J01 là đề xuất. Bổ sung 100 kg thân/vỏ khởi tạo ngoài 300 kg phần ăn đã ghi; không đổi lượng thức ăn/tiền ban đầu. Không coi số liệu này là thông số hiện thực hoặc lựa chọn đã được người dùng duyệt.

Ngày 2026-09-05: thêm [[SINH_KE]] cho DL01. Quyền ăn ở, cam kết hiện vật 30 ngày, giá buôn, lịch tiếp tế và nhánh tám J01 là đề xuất kiểm tra; chưa được người dùng chốt. Đối chiếu số học không chứng minh NPC tự duy trì sinh kế hoặc lịch đã khả thi. TN01–TN08 giữ nguyên trạng thái mở.

Ngày 2026-09-05: tổng hợp tám lựa chọn TN01–TN08 trong [[LUA_CHON_TRAI_NGHIEM]], ưu tiên phản hồi về dừng, mô phỏng khi đóng và quyền tự chủ nhân vật. Đề xuất bản thử cho lưu/tải thủ công cũng chưa được xác nhận. Không coi yêu cầu tiếp tục là đồng ý cấu hình hoặc yêu cầu lập trình.

Ngày 2026-09-05: thêm [[GIAO_DIEN]]. Bố cục, biểu mẫu, dừng khi chỉnh mục tiêu, phản hồi lệnh và bàn phím là đề xuất; chưa có UI chạy được hoặc xác nhận của người dùng về chế độ thời gian.

Ngày 2026-09-05: thêm [[DU_LIEU_KHOI_DAU]]. Tên An Khê, danh tính/vai trò, lượng kho, đơn vị, giá, thời lượng và nguồn đều là giả định kiểm chứng do trợ lý đề xuất; không phải cân bằng cuối hoặc thông số hiện thực được chứng minh.

Ngày 2026-09-05: bổ sung [[LIEN_KET_HE_THONG]] và [[BAN_CHOI_THU]]. Quy tắc pha cùng mốc, phân công dữ liệu, thực thi quyền theo thông tin và phạm vi chơi thử vẫn là đề xuất. Bảng lựa chọn trước triển khai nằm ở BAN_CHOI_THU mục 12; chưa có lựa chọn nào được tự nâng thành xác nhận.

Ngày 2026-09-05: bổ sung [[CHIEN_DAU]]. Pha hành động, phản ứng, truy đuổi và đầu hàng là đề xuất; chưa chốt hình học, công thức tiếp xúc, tốc độ chậm, độ sâu bắt giữ hay chiến tranh lớn.

Ngày 2026-09-05: bổ sung [[KINH_TE_TO_CHUC]]. Giao dịch, giá địa phương, nợ, quyền hạn và tổ chức là đề xuất; chưa chốt tiền tệ, luật, thể chế, thừa kế, điểm cống hiến hoặc thông số cân bằng.

Ngày 2026-09-05: bổ sung [[MOI_TRUONG]]. Không gian, nguồn nước, quần thể, linh địa và thung lũng mẫu là đề xuất; chưa chốt hình học bản đồ, lịch mùa, danh mục loài, công thức dòng chảy hoặc mức xấp xỉ vùng xa.

Ngày 2026-09-05: bổ sung [[TU_LUYEN]]. Ba công pháp mẫu, khung mốc chức năng, chuyển hóa, bình cảnh và đột phá đều là đề xuất; chưa chốt tên/số cảnh giới, linh căn, đơn vị năng lượng, thời lượng tiến bộ, tuổi thọ hoặc giới hạn thần thông.

Ngày 2026-09-05: bổ sung [[VAT_PHAM]] theo yêu cầu tiếp tục. Quy tắc lô, chất lượng nhiều chiều, bảo toàn, quy trình chế tác và truy vết là đề xuất; chưa chốt danh mục vật liệu, đơn vị, phẩm cấp hiển thị hoặc cơ chế trữ vật.

Ngày 2026-09-05: bổ sung [[NPC]] theo yêu cầu tiếp tục. Tính cách, cảm xúc, quan hệ có hướng, truyền tin, ký ức và cam kết là thiết kế đề xuất; chưa chốt chuẩn văn hóa, thang tính cách hoặc quyền tự chủ của nhân vật người chơi.

Ngày 2026-09-05: bổ sung [[CO_THE]] theo yêu cầu tiếp tục kế hoạch. Cấu trúc giải phẫu theo chặng, độ khắc nghiệt của di chứng, tái tạo và quan hệ sinh lý–linh lực vẫn là đề xuất/chưa chốt; chưa có công thức hoặc thông số y khoa được kiểm chứng.

Ngày 2026-09-05: đã triển khai thiết kế đề xuất trong [[THOI_GIAN]] và [[HANH_DONG]]. Đây là bước bắt đầu lập kế hoạch chi tiết theo yêu cầu tiếp tục của người dùng; không phải xác nhận các đề xuất. Bổ sung vấn đề mở: nhân vật người chơi có thể từ chối lệnh vì tâm lý/tính cách hay chỉ vì giới hạn năng lực và hiểu biết?

1. Tốc độ 5 giây/ngày có được thay đổi, tạm dừng và tự dừng không?
2. Thế giới có tiến triển lúc đóng game không; nếu có, xử lý rủi ro thế nào?
3. Giới hạn điều khiển trực tiếp so với giao mục tiêu?
4. Hệ cảnh giới, bản chất linh khí, kinh mạch và quy luật đột phá?
5. Mức giải phẫu và độ chi tiết sinh lý cần có ở từng chặng?
6. Quy mô NPC và thế giới mục tiêu, cấu hình máy dùng để kiểm chứng hiệu năng?
7. Cái chết, tải lại, kế thừa và mức độ khắc nghiệt?
8. Chốt công nghệ sau khi đặc tả nền đủ rõ.

## Cách cập nhật

Ngày 2026-09-07: triển khai [[K5_6_V2_0_HO_GIA_DINH_TAI_NGUYEN_QUYEN_LICH]] theo lộ trình đã đề xuất. Hộ bốn người, mức kho, suất bữa, quyền dùng và lịch 07:00/12:00/18:00 là fixture kỹ thuật để kiểm chứng bảo toàn và cạnh tranh lao động; chưa được coi là cân bằng, văn hóa hộ hoặc quyết định trải nghiệm cuối của người dùng. Không suy ra rằng mọi hộ trong game có bốn người hay dùng cùng khẩu phần.

Khi người dùng xác nhận hoặc thay đổi một lựa chọn, ghi ngày, nội dung và lý do nếu có; cập nhật MASTER_PLAN.md tương ứng. Không xóa dấu vết quyết định cũ quan trọng: đánh dấu được thay thế và liên kết quyết định mới.

Ngày 2026-09-08: K5.9/V2.2 triển khai chuyến tiếp tế có người chở, giờ dự kiến/thật, nhánh trễ; bệnh tác động trực tiếp lên sinh lý theo giờ; và chọn người chăm sóc thay thế khi N01 vắng mặt. Đây là hướng triển khai nối tiếp yêu cầu mô phỏng sâu. N04, độ trễ 6 giờ, ngưỡng kỹ năng 400, kỹ năng N01/N02, hệ số bệnh và lượng hàng đều là fixture prototype, chưa phải quyết định cân bằng được người dùng chốt.
