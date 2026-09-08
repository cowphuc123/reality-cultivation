---
title: "K4.9 — Kiểm toán tích hợp K4, phạm vi bản đầu và chuẩn bị lập trình"
aliases: ["Đóng gói K4", "Đặc tả bản game đầu tiên"]
tags: [reality-cultivation, ke-hoach, k4, kiem-toan]
status: de-xuat
updated: 2026-09-06
---

# K4.9 — Kiểm toán tích hợp K4, phạm vi bản đầu và chuẩn bị lập trình

> [!summary]
> Tài liệu này đóng gói K4.1–K4.8, nối yêu cầu tạo thế giới–tiền sử–điều khiển từ sơ sinh với các hệ mô phỏng và định vertical slice đầu tiên. Đây là kiểm toán thiết kế, không phải bằng chứng game đã chạy. Không thêm điều kiện mới: tổng vẫn là 1.860 điều kiện thuộc 41 họ, tất cả chưa được mã hóa/chạy.

## 1. Kết luận

Nền thiết kế đã đủ rộng để chuyển sang triển khai khi người dùng yêu cầu. Viết thêm các đại đặc tả trước code sẽ cho lợi ích giảm dần; chi tiết tiếp theo nên được phát hiện bằng prototype, fixture, profiler và chơi thử.

K4 đạt mức **khép trên giấy**, chưa đạt mức **có artifact**, **chạy được** hoặc **đã chứng minh**.

## 2. Yêu cầu người dùng đã xác nhận

| ID | Yêu cầu |
|---|---|
| U001 | game text tu tiên chân thật và cực kỳ chi tiết |
| U002 | 5 giây ngoài đời bằng 1 ngày game |
| U003 | người chơi giao việc/mục tiêu cho nhân vật |
| U004 | NPC có đời sống và câu chuyện riêng |
| U005 | cơ thể và thương tích theo bộ phận |
| U006 | rất nhiều vật phẩm/công pháp có công dụng khác |
| U007 | tham vọng vượt Dwarf Fortress/CDDA về chiều sâu |
| U008 | lập kế hoạch chi tiết trước |
| U009–U010 | lưu hồ sơ trong Obsidian |
| U011 | chơi trên điện thoại và máy tính |
| U012 | không có cốt truyện chính cố định |
| U013 | tạo thế giới và chạy tiền sử hàng trăm–hàng vạn năm trước người chơi |
| U014 | người chơi điều khiển ngay từ lúc sơ sinh |

Các đề xuất phạm vi/công nghệ không tự trở thành yêu cầu đã duyệt.

## 3. Kiểm kê K4

| Chặng | Tài liệu | Dòng | Điều kiện |
|---|---|---:|---:|
| K4.1 | [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]] | 921 | 84 VL |
| K4.2 | [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]] | 1.070 | 96 CT |
| K4.3 | [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]] | 1.116 | 96 VP |
| K4.4 | [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]] | 1.031 | 96 MT |
| K4.5 | [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]] | 1.090 | 96 CP |
| K4.6 | [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]] | 1.132 | 96 NP |
| K4.7 | [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]] | 988 | 96 XH |
| K4.8 | [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]] | 948 | 96 CX |
| **Tổng K4** | **8 tài liệu** | **8.296** | **756** |

Tổng toàn hồ sơ là 1.860 điều kiện thuộc 41 họ.

## 4. Chuỗi chủ quản

```text
Command/Goal
→ Agent belief/plan
→ Scheduler
→ rights/reservations/transaction
→ domain process
→ World Fact
→ signal/observation/message
→ belief/memory/relation
→ View/Story
```

Không được đi tắt từ UI hoặc văn kể sang World State.

## 5. Single writer

Simulation Runtime là nơi duy nhất commit canonical state. UI, generator, AI ngôn ngữ, Story View và validator chỉ gửi request/artifact hoặc đọc snapshot.

Quy tắc này phải được chứng minh bằng kiến trúc mã nguồn.

## 6. Definition–Instance–View

Mọi miền giữ content definition, instance có identity/history và projection theo quyền biết. Không sửa Definition để biểu diễn một món đồ hỏng hoặc niềm tin sai.

View không được dùng làm save canonical.

## 7. Fact–Belief

World Fact tách Belief của từng Person. NPC, người chơi và tổ chức chỉ biết qua signal/evidence/message hợp lệ.

Điều này áp dụng cả giá, cảnh giới, bệnh, thủ phạm và lịch sử.

## 8. Bảo toàn

Vật, năng lượng, quyền, nghĩa vụ và identity có source/sink/transfer. “Phần thưởng”, “chi phí”, “damage” và “sản lượng” không được tạo delta ngoài domain.

Audit ledger là gate bắt buộc.

## 9. Thời gian

5 giây/ngày là tốc độ hiển thị; core dùng game time đủ nhỏ cho sinh lý, giao dịch và chiến đấu. Event/process xử tới breakpoint, không quét mọi thứ mỗi frame.

Pause dừng toàn world tại boundary hợp lệ.

## 10. Các trục phân tầng

| Trục | Ý nghĩa |
|---|---|
| M0–M4 | dữ liệu đã materialize tới đâu |
| R0–R4 | cách giải thời gian chung |
| P0–P4 | độ phân giải hiện tượng |
| B0–B5 | cơ thể |
| IR0–IR5 | vật phẩm |
| ER0–ER5 | môi trường |
| CR0–CR5 | tu luyện |
| AR0–AR5 | tác nhân |
| SE0–SE5 | kinh tế/xã hội |
| BR0–BR5 | chiến đấu |

Các trục phối hợp qua ResolutionPlan; không trộn thành một “level of detail”.

## 11. Promotion

Nâng chi tiết trước tương tác, không giải thô rồi dựng ngược câu chuyện. Promotion mở capsule deterministically, reconcile ledger và validate trước publish.

Query chỉ xem không tự nâng nếu View hiện có đủ.

## 12. Demotion

Chỉ hạ tại safe boundary khi action, reservation, transfer, dialogue và effect cần thiết đã khép. Capsule giữ invariant và next wakeup.

Round-trip oracle phải tồn tại cho từng miền.

## 13. Worldgen đã xác nhận

Luồng chính nằm tại [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]:

1. chọn config/seed;
2. sinh vật chất–địa lý–sinh thái–linh khí;
3. sinh dân cư/văn hóa;
4. chạy lịch sử hàng trăm–hàng vạn năm;
5. tạo snapshot hiện tại;
6. người chơi chọn nơi;
7. nhân vật sinh ra;
8. bắt đầu điều khiển từ sơ sinh.

Không có nhân vật chính trong tiền sử.

## 14. Lịch sử tiền game

Epoch xa dùng aggregate/capsule nhưng giữ stock, lineage, institution và anchor. Cửa sổ gần tăng chi tiết để snapshot có Person, household, quyền và nghĩa vụ thật.

Không lưu từng phút của mọi sinh vật suốt hàng vạn năm.

## 15. Không có cốt truyện chính

Content cung cấp quy luật, grammar, văn hóa và event có điều kiện. Outcome đến từ state/Agent/RNG hợp lệ. Story View chỉ nhóm Fact đã xảy ra.

Không giữ chỗ lời tiên tri hoặc kẻ thù cho người chơi.

## 16. Chọn nơi sinh

Bản đồ chỉ hiện kiến thức khởi đầu phù hợp; điểm chọn phải có BirthFeasibility. Chọn điểm không sửa tài nguyên, gia đình hoặc lịch sử để chiều người chơi.

Nhân vật nhận lineage, body, household, ngôn ngữ và hoàn cảnh từ snapshot.

## 17. Chơi từ sơ sinh

U014 yêu cầu điều khiển ngay từ lúc sinh. Giao diện dùng khả năng theo tuổi:

- chú ý và hướng giác quan;
- khóc/phát tín hiệu nhu cầu;
- ngủ/thức;
- cố cử động, với, bám;
- nhận giọng/mùi/người chăm sóc;
- bắt chước và học;
- về sau bò, đi, nói, tự đặt mục tiêu phức tạp.

Không cung cấp Command người lớn trước khi body/cognition/knowledge cho phép.

## 18. Agency sơ sinh

Người chơi điều khiển ý định của nhân vật, không điều khiển cha mẹ. Muốn được cho ăn hoặc tránh nguy hiểm phải phát signal; caregiver nhận/hiểu và quyết định theo Agent riêng.

Đây là nguồn gameplay quan hệ đầu tiên.

## 19. Tốc độ tuổi thơ

5 giây/ngày làm một năm khoảng 30 phút 25 giây ngoài đời. Không tự bỏ qua tuổi thơ; người chơi có thể dùng tốc độ chung, pause và mục tiêu dài hạn.

Tùy chọn tăng tốc riêng chưa được xác nhận.

## 20. Vòng đời bản đầu đề xuất

Bản đầu nên có nội dung có ý nghĩa từ sinh tới ít nhất 20 tuổi game, tương đương khoảng 10 giờ 8 phút chạy không dừng. Chơi thực tế dài hơn vì pause/đọc/quyết định.

Đây là mục tiêu đề xuất, chưa được người dùng chốt.

## 21. Độ bền thế giới đề xuất

World/save nên qua workload 100 năm sau nhập thế và tiền sử cấu hình tới 10.000 năm ở mức phân tầng. Không đặt hard ending theo ngày.

Đạt workload không đồng nghĩa có nội dung tay độc nhất cho mọi năm.

## 22. Tu luyện bản đầu đề xuất

Nhân vật khởi đầu không có knowledge tu luyện miễn phí. Nội dung đầu nên cho:

- phát hiện/được dạy cách cảm nhận;
- học một trong ba Technique khác cơ chế;
- luyện và chịu giới hạn lịch sống;
- chuẩn bị một lần chuyển cấu trúc;
- đạt mốc chức năng đầu nếu thành công.

Tên cảnh giới chính thức vẫn chưa chốt.

## 23. Trần cảnh giới đề xuất

Trần bản đầu là **mốc cấu trúc đầu tiên sau Phàm nhân**, tạm gọi “Khai Mạch sơ thành” trong thảo luận. Đây chỉ là label tạm; canonical state là topology/capacity/mastery thật.

Không tự tuyên bố Luyện Khí/Trúc Cơ cho tới khi cosmology được chốt.

## 24. Cái chết

Nhân vật có thể chết ở mọi tuổi nếu body state dẫn tới. Thế giới không reset. Bản đầu tối thiểu phải cho xem hậu quả và tiếp tục chạy ở chế độ quan sát.

Chọn hậu duệ/Person khác vẫn là câu hỏi mở.

## 25. Phạm vi bản đầu đã đổi

Đề xuất “một làng/20–30 NPC” trước đây chỉ còn là **vùng active đầu tiên**, không phải toàn thế giới. Worldgen cần macro map/vùng summarized rộng hơn để đáp ứng U013.

Phạm vi render và nội dung chi tiết vẫn tập trung quanh nơi sinh.

## 26. World preset đề xuất

| Preset | Tiền sử | Mục đích |
|---|---:|---|
| Nhỏ | 300 năm | phát triển/điện thoại yếu |
| Chuẩn | 3.000 năm | trải nghiệm mặc định |
| Thái cổ | 10.000 năm | máy mạnh/chạy lâu |

Seed/config giống nhau phải cho cùng hash trên nền tảng được hỗ trợ. Con số chưa được người dùng duyệt.

## 27. Kích thước đề xuất

Bản đầu dùng nhiều macro region nhưng chỉ materialize sâu một cụm sinh. Vùng khác giữ geography/ecology/population/institution ledgers và anchors.

Không tuyên bố toàn bản đồ có chi tiết M4.

## 28. Dân số đề xuất

Workload mục tiêu gồm 100.000 Person M2+ dài hạn, nhưng vertical slice đầu có thể bắt đầu 100–1.000 Person và một vùng active 20–50 người.

Không đếm cohort thay Person trong benchmark 100.000.

## 29. Nội dung vật chất ban đầu

Registry tối thiểu cần nước, thức ăn, nhiên liệu, vải/gỗ/đá/kim loại, công cụ, chỗ ở, thuốc cơ bản, chất thải và linh nguồn.

Mỗi content entry phải có công dụng/process, không chỉ tên.

## 30. Cơ thể ban đầu

Ưu tiên body người từ sơ sinh đến trưởng thành: growth, nhu cầu, ngủ, nhiệt, nhiễm, thương tích, đau, chức năng và chăm sóc.

Các loài tu tiên khác mở sau khi human fixture ổn.

## 31. Household ban đầu

Birth cần ít nhất caregiver, nơi ở, nguồn ăn, quan hệ và lịch. Household có thể nghèo, bất ổn hoặc thiếu người nhưng phải nhất quán.

Không bảo đảm tuổi thơ an toàn.

## 32. NPC ban đầu

Mỗi NPC active dùng PersonAgent thật. Người xa dùng AR/R thích hợp nhưng giữ identity, household, nghề, quyền và lịch sử.

Không dùng hội thoại giả để che thiếu Agent.

## 33. Kinh tế ban đầu

Ít nhất một chuỗi thức ăn, nước, nhiên liệu, chăm sóc, thuốc, công cụ và vận chuyển phải khép. Giá/offer dựa hàng và belief thật.

Tiền không bắt buộc cho mọi giao dịch.

## 34. Tổ chức ban đầu

Cần household, một tổ chức sản xuất/dịch vụ, một cơ sở truyền dạy và một institution địa phương. Role/authority/record phải hoạt động.

Không cần quốc gia hoàn chỉnh ở M4.

## 35. Xung đột ban đầu

Cần nguy hiểm môi trường, tranh tài/ẩu đả nhỏ, phục kích hoặc săn, rút lui, cứu chữa, dấu vết và hậu quả. Chiến tranh lớn chỉ ở summary/anchor.

Không lấy combat làm vòng chơi duy nhất.

## 36. Giao diện text

Năm không gian chính:

1. hiện tại và đồng hồ;
2. mục tiêu/công việc;
3. cơ thể/nhu cầu;
4. người/quan hệ/tin;
5. nơi/vật/tổ chức/lịch sử.

Mobile dùng drill-down; desktop có multi-pane.

## 37. Command chung

CommandEnvelope dùng semantic type, actor, intent, target theo belief, constraints và expected revision. UI hai nền tảng gửi cùng Command.

Không để nút UI sửa state trực tiếp.

## 38. Tự dừng

Pause trigger tối thiểu: signal nguy hiểm, nhu cầu nguy cấp, action bị chặn, lời đề nghị cần quyết định, sinh/chết, biến cố gia đình, đột phá và xung đột.

Preset cụ thể thuộc TN còn mở.

## 39. Lưu tải

Autosave tại safe boundary, manual save request và crash recovery cần portable format/version. Worldgen có checkpoint riêng để tiếp tục sau khi ứng dụng bị đóng.

Điện thoại có thể bị hệ điều hành ngắt bất kỳ lúc nào.

## 40. Đa nền tảng

P0 kỹ thuật đề xuất: Windows + Android, cùng core/save. iOS/macOS/Linux là P1 nếu stack hỗ trợ.

U011 chỉ xác nhận điện thoại và máy tính, chưa chốt hệ điều hành phát hành.

## 41. Offline

Đề xuất bản đầu chỉ mô phỏng khi game mở. Đóng game không tự trôi hàng nghìn năm. Worldgen background chỉ tiếp tục khi process thực sự chạy và checkpoint.

Chính sách offline vẫn chưa được chốt.

## 42. AI ngôn ngữ

Không nằm trên critical path. Template/grammar có thể diễn đạt DialoguePayload và StoryView. Nếu thêm LLM, output phải bị kiểm tra và không tạo Fact.

Game phải chơi offline không cần dịch vụ AI.

## 43. Không cần đồ họa

Mô hình không gian được trình bày bằng text, danh sách, bảng và ký hiệu. Visual map đơn giản có thể là text-grid, không yêu cầu asset đồ họa.

Accessibility và cỡ chữ là yêu cầu UI thực tế.

## 44. Kiến trúc chưa chốt

K3.2 chỉ shortlist Rust/Tauri, Dart/Flutter và Kotlin/Compose Multiplatform. Chưa candidate nào chạy spike.

Không được bắt đầu production code bằng cách coi shortlist là ADR.

## 45. Prototype chọn stack

Mỗi candidate phải chạy cùng:

- đồng hồ/event deterministic;
- save/load giữa process;
- 100–1.000 Person wakeup;
- worldgen checkpoint;
- text UI Android/Windows;
- parity hash;
- lifecycle suspend/resume.

Qua disqualifier rồi mới chấm.

## 46. Artifact bootstrap

Trước feature cần repository layout, schema registry, typed IDs/units, Condition catalog, fixture loader, deterministic RNG, Event/Fact envelope và evidence runner.

Markdown vẫn là nguồn giải thích; artifact máy mới là input runtime.

## 47. Không mã hóa 1.860 test cùng lúc

Điều kiện được nhập catalog dần theo dependency. Mỗi vertical slice chọn subset bắt buộc và giữ các điều kiện khác NOT_RUN.

Không báo coverage bằng cách coi văn bản là test.

## 48. Vertical slice V0 — skeleton

Core clock, command, event, fact, state hash, save/load, CLI/text shell và một Person bất động.

Mục tiêu: một ngày trôi deterministic.

## 49. V1 — sơ sinh

BirthEvent, body sơ sinh, ngủ/đói/khóc, caregiver perception/decision, bú/chăm sóc và growth một tháng.

Đây là slice đầu tiên có trải nghiệm đúng U014.

## 50. V2 — một hộ sống

Household ba–năm người, nước/thức ăn/nhiên liệu, lịch, vật, quyền dùng, bệnh nhẹ và một tháng.

Không dùng income tự sinh.

## 51. V3 — làng nhỏ

20–50 Person, nhiều hộ, nghề, exchange, message, relationship và tự duy trì 30 ngày.

Tái dùng fixture An Khê sau migration.

## 52. V4 — tuổi thơ

Growth nhiều năm, ngôn ngữ, vận động, học, chơi, attachment, nguy hiểm và memory compaction.

Không time-skip vô điều kiện.

## 53. V5 — worldgen nhỏ

Sinh macro geography, một valley, resources, ecology, settlement và 300 năm lịch sử summary + recent window.

Cho chọn nơi sinh và tái hiện seed.

## 54. V6 — sinh kế

Production, crafting, service, labor, local market, shipment và shock thiếu hàng.

Ledger không âm/nhân đôi.

## 55. V7 — tu luyện

Knowledge source, ba Technique, PracticeSession, body adaptation, linh resource và một breakthrough mốc chức năng.

Không dùng XP/cảnh giới thay state.

## 56. V8 — xung đột

Perception, policy, movement, contact, item/body injury, retreat, rescue và evidence.

Không cần chiến tranh lớn.

## 57. V9 — tổ chức

Role/authority, tông môn nhỏ, kho, lớp học, proposal/decision và dispute.

Tổ chức chỉ biết qua người.

## 58. V10 — lịch sử dài

Epoch 3.000/10.000 năm, anchor, compaction, institution/technique lineage và snapshot validator.

Đo thời gian/dung lượng trên thiết bị.

## 59. V11 — vòng chơi đầu

Từ tạo world → chọn nơi → sinh → lớn lên → học nghề/tu luyện → gặp khủng hoảng/xung đột → hậu quả → save/load.

Đây là alpha nội bộ đầu tiên.

## 60. V12 — parity

Cùng fixture/save/command chạy Android và Windows cho cùng semantic hash, kể cả suspend/resume.

Khác layout được phép.

## 61. Thứ tự dependency

```text
V0 → V1 → V2 → V3
        ↘ V4
V0 → V5 → V10
V3 → V6 → V9
V2 + V4 → V7
V3 → V8
tất cả → V11 → V12
```

Không đợi V10 mới cho chơi các slice nhỏ.

## 62. Definition of playable

Một build được gọi là chơi được khi người dùng có thể tạo/load world, đặt mục tiêu, quan sát thời gian, nhận phản hồi có nguyên nhân và lưu lại mà không sửa file tay.

Log chạy không đồng nghĩa gameplay.

## 63. Definition of alpha đầu

Alpha đạt khi V11 hoàn tất một chuỗi tối thiểu và không vi phạm gate vật/identity/knowledge/save. Nội dung có thể ít nhưng mọi thứ tuyên bố hỗ trợ phải thật.

Không gọi alpha nếu worldgen chỉ là ảnh nền.

## 64. Content budget đề xuất

Alpha đầu:

- 1 body species sâu;
- 20–50 Person active;
- 100+ Person vùng gần;
- 30–50 material/item definitions hữu dụng;
- 10–20 process/craft chains;
- 3 công pháp khác cơ chế;
- 1 mốc breakthrough;
- 3–5 organization forms;
- 1–3 culture variants;
- 1 valley active và nhiều macro regions.

Đây là điểm bắt đầu, không phải trần tham vọng.

## 65. Performance budget

Ngân sách cụ thể phải đo trên DeviceProfile thật. Mục tiêu định tính: UI phản hồi tức thì, simulation giữ 5 giây/ngày, save không gây mất tiến trình và điện thoại không quá nhiệt trong phiên thường.

Không chốt số giả trước benchmark.

## 66. Worldgen budget

UI phải báo ước lượng, phase, progress, checkpoint và dung lượng. Preset lớn được phép lâu nhưng không treo vô hạn.

Cancel giữ/loại staging theo lựa chọn rõ.

## 67. Save budget

Đo snapshot, journal, indices, memories, histories và content fingerprints riêng. Compaction chỉ chạy khi round-trip/invariant đạt.

Không xóa lịch sử neo để đạt dung lượng.

## 68. Reliability

Fault injection tại commit, save, migration, worldgen checkpoint, suspend, low-storage và corrupted chunk. Bản cũ giữ tới khi bản mới xác minh.

Recovery không âm thầm reset world.

## 69. Determinism

Mỗi run có content/config/build/world lineage, seed streams và command log. Hash so canonical semantic state, không so cache/layout.

Ngày máy và locale không đổi outcome.

## 70. Evidence

Mỗi gate cần RunSpec, log, hashes, metrics, failure artifacts và device profile. PASS phải dẫn tới evidence còn đọc được.

“Đã đối chiếu trên giấy” giữ trạng thái riêng.

## 71. Gate K4I01 — hồ sơ

Đạt trên giấy: tám tài liệu K4 có boundary, fixture, condition và bước triển khai.

Không chứng minh implementation.

## 72. Gate K4I02 — chuỗi nhân quả

Đạt trên giấy: vật chất → cơ thể/vật/môi trường → tu luyện/NPC/xã hội/chiến đấu nối qua owner.

Cần integration test máy.

## 73. Gate K4I03 — worldgen

Đạt trên giấy: seed, epoch, anchor, snapshot, chọn nơi và BirthEvent đã có thiết kế.

Chưa có generator.

## 74. Gate K4I04 — sơ sinh

Đạt trên giấy: U014, agency theo phát triển và caregiver độc lập rõ.

Chưa có body/Agent/UI chạy.

## 75. Gate K4I05 — không cốt truyện cố định

Đạt trên giấy: Story View read-only và no protagonist prehistory.

Cần hash test bật/tắt narrative.

## 76. Gate K4I06 — đa nền tảng

Đạt trên giấy: cùng core/command/save semantic.

Chưa có Android/Windows build.

## 77. Gate K4I07 — artifact

Chưa đạt: thiếu schema registry, catalog, fixtures máy, IR và content packages.

Đây là gate đầu của triển khai.

## 78. Gate K4I08 — stack

Chưa đạt: chưa chạy prototype hoặc ADR.

Không tự chọn bằng tài liệu.

## 79. Gate K4I09 — V0

Chưa đạt: chưa có clock/event/state/save executable.

Đây là mốc code đầu tiên.

## 80. Gate K4I10 — V1 sơ sinh

Chưa đạt: chưa chơi được một tháng sơ sinh.

Phải có caregiver thật.

## 81. Gate K4I11 — worldgen nhỏ

Chưa đạt: chưa sinh/giải 300 năm hoặc chọn nơi.

Seed parity chưa có.

## 82. Gate K4I12 — economy

Chưa đạt: chưa chạy chuỗi sống 30 ngày không âm/nhân vật.

Fixture An Khê còn Markdown.

## 83. Gate K4I13 — cultivation

Chưa đạt: chưa chạy ba pháp/đột phá.

Tên cảnh giới vẫn mở.

## 84. Gate K4I14 — combat

Chưa đạt: chưa có contact→injury→aftermath.

Geometry chưa chọn.

## 85. Gate K4I15 — long history

Chưa đạt: chưa benchmark 3.000/10.000 năm.

Không được hứa thời gian tải.

## 86. Gate K4I16 — alpha

Chưa đạt: V11/V12 chưa tồn tại.

Chỉ đạt sau gameplay và evidence thật.

## 87. Ma trận readiness

| Lĩnh vực | Thiết kế | Artifact | Code | Evidence |
|---|---|---|---|---|
| thời gian/state | có | chưa | chưa | chưa |
| worldgen/history | có | chưa | chưa | chưa |
| infancy/body | có | chưa | chưa | chưa |
| NPC/household | có | chưa | chưa | chưa |
| economy/society | có | chưa | chưa | chưa |
| cultivation | có | chưa | chưa | chưa |
| combat | có | chưa | chưa | chưa |
| save/platform | có | chưa | chưa | chưa |

Không dùng cột thiết kế để suy cột sau.

## 88. Những quyết định có thể trì hoãn

Tên cảnh giới dài hạn, cosmology hoàn chỉnh, mọi loài, quốc gia, multiplayer, cloud sync, LLM, chiến tranh M4 toàn cầu và hàng triệu vật phẩm không chặn V0–V3.

Schema phải cho phép mở rộng mà không giả đã hỗ trợ.

## 89. Những quyết định phải có sớm

- stack sau spike;
- typed IDs/units;
- time representation;
- RNG streams;
- canonical numeric rules;
- save envelope/version;
- event phase/order;
- P0 OS targets;
- geometry tối thiểu;
- content/schema tooling.

Chúng cần ADR/evidence trong triển khai.

## 90. Vấn đề trải nghiệm còn mở

TN01–TN08 vẫn chưa được người dùng xác nhận, gồm pause/offline, quyền tự chủ, thông tin, chết/kế thừa và giới hạn bản đầu.

U012–U014 có ưu tiên hơn các preset cũ.

## 91. Vấn đề thế giới còn mở

Cosmology, kích thước bản đồ, tuổi mặc định, số nền văn hóa, lịch sử được tiết lộ, khả năng seed không sống được và mức chi tiết 10.000 năm.

WorldConfig phải ghi rõ thay vì giấu mặc định.

## 92. Vấn đề sơ sinh còn mở

Mức chọn cha mẹ/xuất thân, chăm sóc thất bại, UI trước ngôn ngữ, mục tiêu dài hạn, mức tự động hóa việc thường và cách tiếp tục sau chết.

Không vì khó mà tự time-skip.

## 93. Vấn đề tu luyện còn mở

Tên/số cảnh giới, bản chất linh khí/hồn, tuổi thọ, linh căn, thiên kiếp, hồi sinh và trần bản đầu.

Mốc chức năng có thể triển khai trước tên văn hóa.

## 94. Vấn đề xã hội còn mở

Tiền, quyền đất/linh mạch, chính quyền, luật, gia đình, thừa kế, giai cấp, nô lệ và hình phạt.

Fixture đầu có thể chọn một culture package hẹp.

## 95. Vấn đề chiến đấu còn mở

Geometry, tốc độ chậm, projectile/fire depth, bay, bắt giữ, trẻ em và mức mô tả bạo lực.

V8 chỉ nhận capability đã khai.

## 96. Rủi ro lớn nhất

| Rủi ro | Cách xử |
|---|---|
| cố xây toàn game cùng lúc | vertical slices |
| tài liệu không ánh xạ code | schema/catalog SourceRef |
| worldgen quá lâu | preset/checkpoint/epoch |
| sơ sinh thiếu tương tác | caregiver + development |
| NPC tốn CPU | wakeup/AR/capsule |
| save phình | anchor/compaction/partition |
| đa nền tảng lệch logic | shared core/parity |
| chiều sâu giả | state/ledger/provenance |

## 97. Tiêu chí bắt đầu lập trình

Đã đạt:

- người dùng yêu cầu kế hoạch trước và hồ sơ đã đủ nền;
- các domain/boundary/fixtures/conditions đã có;
- vertical slice order đã rõ.

Chưa cần giải hết mọi câu hỏi để bắt đầu V0. Việc bắt đầu vẫn cần người dùng yêu cầu chuyển sang triển khai theo AGENTS.md.

## 98. Công việc đầu tiên khi triển khai

1. kiểm tra/khởi tạo quản lý phiên bản;
2. chạy spike ba stack trên cùng scenario;
3. viết ADR chọn stack;
4. dựng schema registry/typed primitive;
5. mã hóa V0;
6. chạy deterministic save/load evidence;
7. mở V1 sơ sinh.

Không bắt đầu bằng UI đẹp hoặc content hàng nghìn món.

## 99. Definition of done K4

K4 được coi là **hoàn thành về kế hoạch** khi:

- tám tài liệu hệ thống và bản kiểm toán tồn tại;
- liên kết/condition inventory khớp;
- yêu cầu worldgen/sơ sinh được đưa vào slice;
- trạng thái chưa code được ghi đúng;
- bước triển khai đầu tiên rõ.

Nó không có nghĩa game hoàn thành.

## 100. Những điều không được tuyên bố

- Không nói 1.860 điều kiện là test tự động.
- Không nói K4 gate implementation đã đạt.
- Không nói đã chọn stack.
- Không nói đã tạo thế giới hoặc mô phỏng 10.000 năm.
- Không nói đã chơi từ sơ sinh.
- Không nói đã đạt Android/Windows parity.
- Không nói alpha đã tồn tại.

## 101. Trạng thái cổng

K4I01–K4I06 đạt trên giấy. K4I07–K4I16 chưa đạt vì thiếu artifact, mã nguồn, lượt chạy, benchmark và evidence.

Không thêm condition family mới trong K4.9.

## 102. Bước tiếp theo

Giai đoạn lập kế hoạch nền đã đủ để chuyển sang triển khai. Khi người dùng yêu cầu làm game, bắt đầu K5.1 bằng prototype chọn stack và V0 skeleton; sau đó V1 phải đưa người chơi vào BirthEvent và cho điều khiển tháng đầu sơ sinh.

Nếu người dùng tiếp tục yêu cầu thiết kế thay vì code, chỉ mở tài liệu mới cho một câu hỏi còn mở có ảnh hưởng trực tiếp đến slice sắp triển khai.
