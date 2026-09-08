---
title: "K4.3 — Vật liệu, vật phẩm, cấu trúc, công dụng và chế tác sâu"
aliases:
  - "Vật phẩm và chế tác K4"
  - "Vật liệu tổ hợp K4"
tags:
  - reality-cultivation
  - ke-hoach
  - k4
  - vat-pham
status: de-xuat
updated: 2026-09-06
---

# K4.3 — Vật liệu, vật phẩm, cấu trúc, công dụng và chế tác sâu

> [!summary]
> Tài liệu này mở rộng [[VAT_PHAM]] và [[VAT_THE_THU]] trên nền [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]] cùng [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. Vật phẩm là cấu trúc vật chất có bộ phận, hình học, mối nối, cơ cấu, sai số, khuyết tật và lịch sử; công dụng được suy ra theo người dùng và hoàn cảnh. Đây là thiết kế chưa triển khai.

## 1. Mục tiêu

Sinh hàng nghìn đến hàng vạn vật phẩm khác nhau mà không viết tay hàng nghìn dòng chỉ số:

```text
vật liệu + hình học + vi cấu trúc + bộ phận + mối nối
+ quy trình chế tạo + sai số + lịch sử sử dụng + tình trạng
+ cơ thể/kỹ năng người dùng + môi trường + tác vụ
= công dụng thực tế và câu chuyện riêng của vật
```

Một vật có giá trị vì nó làm được việc, ai biết dùng, ai sở hữu, đã trải qua điều gì và người ta biết gì về nó; không chỉ vì nhãn phẩm cấp.

## 2. Phạm vi

K4.3 định:

- họ vật liệu và thuộc tính theo trạng thái;
- hình học chữ hóa, bề mặt, dung sai và khối lượng;
- assembly graph, mối nối, cơ cấu và interface;
- capability/affordance theo ngữ cảnh;
- chất lượng đa chiều, khuyết tật và kiểm định;
- kế hoạch chế tạo, công đoạn, công cụ, trạm và kỹ năng;
- khai thác, tinh luyện, gia công, lắp ráp, hoàn thiện;
- hao mòn, hỏng, bảo trì, sửa, tháo, tái dùng và tái chế;
- vũ khí, giáp, y cụ, công cụ, máy và pháp khí;
- sinh nội dung tổ hợp, vật độc nhất và lịch sử;
- mức phân giải, lưu tải, UI và kiểm chứng.

## 3. Ranh giới chủ quản

| Miền | Sở hữu |
|---|---|
| K4.1 | parcel, quantity, nhiệt, lực, phản ứng, field và transfer |
| K4.2 | khả năng cơ thể, thương tích và đáp ứng sống |
| K4.3 | identity vật, cấu trúc, thiết kế, công dụng và process chế tác |
| hành động | ý định, lịch, thao tác và phân bổ chú ý |
| giao dịch | quyền, giữ chỗ, sở hữu và bảo toàn commit |
| nhận thức | quan sát, nhận diện, kiến thức và đánh giá |
| kinh tế | giá, nhu cầu, trao đổi, nợ và tổ chức sản xuất |

K4.3 không tự sửa state vật chất ngoài transaction/process của K4.1.

## 4. Bốn tầng dữ liệu

| Tầng | Ý nghĩa |
|---|---|
| Definition | vật liệu, bộ phận, interface, operation và rule tái sử dụng |
| DesignBlueprint | cấu trúc dự kiến và yêu cầu chức năng |
| ItemInstance | vật thật đã được chế tạo, có sai số và lịch sử |
| View | tên gọi, phẩm cấp, công dụng và mô tả theo người quan sát |

Blueprint tốt không bảo đảm sản phẩm tốt. View “kiếm thượng phẩm” không thay thế cấu trúc thật.

## 5. Item identity

Vật cá thể có `item_id` bền vững khi:

- độc nhất hoặc có lịch sử riêng;
- có bộ phận/cấu trúc cần theo dõi;
- đang thuộc quyền/nghĩa vụ;
- có hỏng, sửa, khắc dấu hoặc quan hệ xã hội;
- là anchor của quá trình/câu chuyện.

Vật đồng nhất có thể ở lot, nhưng tách khỏi lot tạo identity và provenance riêng.

## 6. MatterParcel, Part và Item

`MatterParcel` là lượng vật chất. `PartInstance` là parcel/assembly có vai trò cấu trúc. `ItemInstance` là ranh giới công dụng và identity do thiết kế/xã hội nhận biết.

Một cục sắt có thể là parcel; rèn thành lưỡi tạo Part; lắp cán và chuôi thành kiếm tạo Item. Nung chảy kiếm có thể kết thúc identity chức năng nhưng provenance vật chất vẫn còn.

## 7. Vòng đời vật phẩm

```text
nguồn vật liệu → tinh luyện → bán thành phẩm → part
→ assembly → kiểm định → sử dụng → hao mòn/hỏng
→ bảo trì/sửa/độ lại → tháo dỡ → tái dùng/tái chế/phế thải
```

Mỗi bước có input/output, process, người/trạm, thời gian, chất thải và cause chain.

## 8. Phân loại không phải công dụng

Taxonomy giúp tìm kiếm: vũ khí, bình, áo, thuốc, công cụ. Công dụng thật đến từ capability. Một chai vỡ có thể vẫn làm vật sắc; một búa nhỏ có thể chặn cửa.

Không giới hạn hành động chỉ theo category nếu cấu trúc/interface cho phép. Hành động ngoài thiết kế có thể kém hiệu quả hoặc nguy hiểm nhưng vẫn hợp lý.

## 9. MaterialDefinition

Mỗi vật liệu dùng module của K4.1:

```text
composition + phase + microstructure + property models
+ environmental responses + process windows
+ spiritual coupling + observation signatures
+ source/provenance + validity ranges
```

Không lưu một bộ chỉ số cố định áp cho mọi nhiệt độ, hướng và lịch sử xử lý.

## 10. Họ vật liệu

Họ đề xuất:

- kim loại/hợp kim;
- khoáng/đá/gốm/thủy tinh;
- gỗ/thực vật;
- da/xương/sừng và vật liệu sinh học;
- sợi/vải/dây;
- giấy/mực/chất ghi;
- polymer/nhựa/dầu/sáp tự nhiên;
- thực phẩm/dược liệu;
- composite/layered;
- linh tài và vật liệu biến đổi.

Họ chỉ cung cấp schema/rule template, không khóa thế giới vào vật liệu Trái Đất.

## 11. Thành phần và tạp chất

CompositionVector giữ thành phần chính, phụ và tạp. Tạp chất có thể đổi thuộc tính, phản ứng, màu, mùi hoặc linh coupling. Không gộp lot làm tạp chất biến mất.

Tinh luyện chuyển thành phần theo yield và tạo slag/waste/byproduct. “Độ tinh khiết” là View từ composition và phép đo.

## 12. Vi cấu trúc

Grain, fiber, pore, layer, inclusion, phase fraction, orientation và residual stress được giữ ở mức đủ cho gameplay. Process như rèn, tôi, sấy, ép, dệt và luyện linh đổi vi cấu trúc.

Cùng thành phần nhưng xử lý khác có capability và failure mode khác.

## 13. Dị hướng

Vật liệu có thể khác theo hướng: gỗ dọc/ngang thớ, vải dọc/ngang sợi, composite theo lớp, linh tài theo mạch. `PropertyModel` nhận orientation so với tải/flow.

Xoay part hoặc cắt sai hướng có hậu quả; không dùng một hardness/strength cho mọi hướng.

## 14. Thuộc tính theo miền trạng thái

Property curve phụ thuộc nhiệt, độ ẩm, phase, strain rate, age, contamination và spiritual state. Ngoài validity range phải dùng fallback có cảnh báo hoặc không cho phép tính.

Không kéo dài tuyến tính vô hạn chỉ vì thiếu dữ liệu.

## 15. Vật liệu sống

Gỗ tươi, da, thảo dược, nấm và mô sống giữ nước, chuyển hóa/decay và cấu trúc sinh học cần thiết. Sau thu hoạch, lifecycle đổi nhưng process không biến mất.

Vật liệu có ý thức hoặc linh thể riêng cần Person/Agent contract, không bị coi như vật vô tri chỉ vì nằm trong Item.

## 16. Linh tài

Linh tài có carrier, affinity, conductance, capacity, memory/hysteresis, purity, stability và coupling. “Cấp cao” là classification; khả năng thật phụ thuộc trạng thái và thiết kế.

Một linh tài mạnh nhưng bất ổn có thể không phù hợp dụng cụ tinh vi hoặc người dùng yếu.

## 17. Nguồn gốc vật liệu

Provenance ghi mỏ/vùng/sinh vật, thời gian, lô, người khai thác, process và biến đổi. Nguồn có thể ảnh hưởng vi cấu trúc, tạp chất, danh tiếng, quyền và ý nghĩa văn hóa.

Không sinh provenance giả sau khi vật đã trở nên quan trọng.

## 18. GeometryDefinition

Text game dùng primitive và quan hệ:

- chiều dài/rộng/dày;
- profile/section;
- volume/surface;
- curve/edge/point;
- cavity/hole/channel;
- layer/shell;
- relative transform;
- contact/grip/coverage zones.

Không cần mesh hiển thị, nhưng phải đủ cho chứa, tiếp xúc, tải và lắp ghép.

## 19. Khối lượng và phân bố

Khối lượng suy từ volume, composition và porosity; center of mass/inertia có thể xấp xỉ theo part graph. Gắn thêm part đổi cân bằng thật.

Không lưu khối lượng tổng độc lập rồi quên cập nhật khi cắt, đổ đầy hoặc tháo bộ phận.

## 20. Bề mặt

SurfaceState gồm roughness, coating, contamination, wetness, temperature, wear và spiritual inscription nếu có. Bề mặt quyết định ma sát, kết dính, phản ứng, quan sát và tiếp xúc.

Đánh bóng đổi bề mặt chứ không tự tăng mọi thuộc tính của vật.

## 21. Cạnh, mũi và vùng làm việc

Tool zone có hình học, material, edge radius, angle, surface state và support structure. Độ sắc là capability dẫn xuất theo tác vụ/vật đích.

Một lưỡi sắc nhưng mềm có thể cắt tốt ban đầu rồi biến dạng; một cạnh cứng có thể mẻ.

## 22. Dung sai

Mỗi dimension/fit có nominal, tolerance, measured deviation và uncertainty. Dung sai quan trọng cho lắp ghép, kín, ma sát, rung, chính xác và interchangeability.

Không dùng quality chung để quyết định mọi chi tiết vừa khít.

## 23. AssemblyGraph

Node là part/subassembly; edge là joint/interface. Graph giữ orientation, constraints, load/flow paths, accessibility và assembly order.

Tháo part cập nhật graph và tạo vật thật. Không cho vật tiếp tục capability cần part đã tháo qua cache cũ.

## 24. Mối nối

Joint types: fit, fastener, knot, stitch, adhesive, weld/braze, rivet, hinge, bearing, organic bond, spiritual bond. Joint có geometry, strength/stiffness, seal, conductance, wear và disassembly rule.

Một mối nối có thể truyền lực tốt nhưng cách linh hoặc ngược lại.

## 25. Chốt và vật tư nối

Đinh, dây, chỉ, keo, chốt, bulông hoặc linh phù là Item/Parcel thật, có số lượng và tình trạng. Lắp dùng chúng; tháo có thể thu lại, hỏng hoặc mất.

Không sửa miễn phí bằng operation “repair” thiếu đầu vào.

## 26. MechanismGraph

Mechanism gồm links, joints, constraints, actuators, springs, gears/pulleys, valves, triggers hoặc logic linh. Nó chuyển motion/force/flow/signal theo state.

Jam, backlash, misalignment và breakage phát sinh từ geometry/joint/contamination, không chỉ một thanh durability.

## 27. Interface và port

Port types:

- grip/handle;
- support/mount;
- mechanical drive;
- fluid/gas;
- thermal;
- electrical/signal;
- storage/container;
- spiritual flow/control;
- information/notation.

Compatibility cần geometry, standard, state và quyền, không chỉ tag cùng tên.

## 28. Container

Container có cavity, opening, closure, permeability, pressure/temperature range, cleanliness và allowed contents theo capability. Contents giữ vị trí/parcel riêng.

Rò, vỡ, tràn, bay hơi và nhiễm chéo giải qua K4.1. Gộp stack container không gộp contents sai.

## 29. Vật mềm

Dây, vải, túi, lưới và cuộn dùng length/area, topology, fold state, tension paths và damage segments. Không cần mô phỏng từng sợi, trừ điểm hỏng/hoa văn quan trọng.

Buộc nút tạo joint; cắt tạo part mới và bảo toàn length/mass trong sai số.

## 30. Vật chứa thông tin

Sách, thẻ, bản khắc, thư và ngọc giản tách vật mang khỏi InformationArtifact. Hư vật mang có thể làm mất/biến dạng phần thông tin theo coverage/error model.

Sở hữu sách không tự cấp kiến thức. Đọc cần nhận biết, ngôn ngữ, thời gian và khả năng.

## 31. Vật sống và vật cộng sinh

Vật sống có thể vừa là BodyInstance vừa tham gia Assembly/Ownership relation, ví dụ cây ghép, cổ trùng hoặc pháp khí cộng sinh. Lifecycle sinh học không bị Item system ghi đè.

Quyền sử dụng không đồng nghĩa quyền tuyệt đối với một sinh thể có agency.

## 32. FunctionDefinition

Function định mục tiêu và phép đo, không cấp bonus:

```text
task profile + required interfaces + input conditions
+ transfer/mechanism chain + output metrics
+ hazards + failure criteria + observation channels
```

Ví dụ “cắt” đo penetration/separation, thời gian, lực người dùng, hao mòn và chất lượng bề mặt.

## 33. Affordance

Affordance là hành động khả thi được suy từ vật, actor, môi trường, tri thức và mục tiêu. Nó có thể ngoài công dụng thiết kế.

Danh sách lệnh chỉ hiển thị affordance nhân vật nghĩ tới; engine vẫn kiểm tra điều kiện thật khi thực hiện.

## 34. Actor–item fit

Grip size, mass distribution, force, reach, handedness, posture, sensory feedback và spiritual compatibility nối K4.2. Vật tốt với người này có thể khó dùng với người khác.

Không cộng `weapon_damage` mà bỏ qua cơ thể, kỹ năng và cách cầm.

## 35. Capability projection

Capability có output range, efficiency, precision, sustainable rate, setup, failure risk và dependencies. Cache gắn revision của part/material/state/actor context.

Đổi lưỡi, cán, nhiệt, người dùng hoặc vật đích làm cache invalidated đúng phạm vi.

## 36. Chất lượng đa chiều

QualityVector đề xuất:

- conforming geometry;
- material suitability;
- microstructure;
- joint integrity;
- surface/finish;
- precision;
- reliability;
- efficiency;
- spiritual stability;
- aesthetic/cultural workmanship.

Không gộp thành một số canonical. Phẩm cấp hiển thị là View theo chuẩn/người đánh giá.

## 37. Tình trạng hiện tại

Quality lúc sinh khác Condition hiện tại. Vật chế tạo tốt có thể mòn; vật thô có thể còn nguyên. Condition gồm damage, wear, contamination, charge, alignment, lubrication và active process.

Giá trị/công dụng suy từ cả hai nhưng lịch sử không bị xóa.

## 38. Khuyết tật

Defect có vị trí, loại, kích thước/range, orientation, nguồn process và detectability. Khuyết tật ẩn chỉ trở thành Belief khi được quan sát/kiểm định.

Một defect có thể vô hại ở tác vụ này nhưng nghiêm trọng ở tải khác.

## 39. Biến thiên chế tạo

Operation sinh deviation dựa trên material state, tool/station, setup, operator control, environment và RNG stream. Không tung một quality roll duy nhất cuối recipe.

Sai lệch từng bước truyền sang bước sau và có thể được sửa, bù hoặc làm hỏng.

## 40. Đo lường và kiểm định

Measurement có instrument, calibration, range, resolution, access, method, operator và uncertainty. Kết quả tạo Observation/Record.

Đo không làm state thật chính xác hơn. Dụng cụ lệch tạo niềm tin sai có provenance.

## 41. Tiêu chuẩn và phẩm cấp

StandardDefinition quy định metric, phương pháp đo, ngưỡng, sampling và authority. Hai tổ chức có thể xếp cùng vật khác phẩm.

Nhãn giả, kiểm định cũ và thay đổi sau kiểm định tạo chênh lệch giữa claim và state.

## 42. CraftPlan

CraftPlan là DAG công đoạn với inputs, outputs, prerequisites, tolerances, alternatives, checkpoints và rollback/salvage paths.

Recipe không biến vật liệu thành kết quả ngay khi đủ danh sách. Mỗi operation là hành động/process có thời gian và trạng thái dở dang.

## 43. Workpiece

Bán thành phẩm giữ identity, geometry, material state, datum, setup marks, defects và completed operations. Hủy việc không trả nguyên liệu về ban đầu.

Workpiece có thể chuyển người/trạm, bị hỏng, mất, bán hoặc dùng tạm.

## 44. Reservation và transaction

Trước operation, giữ chỗ vật, tool time, workstation, người, năng lượng và không gian. Commit theo phần thực sự dùng; phần còn có vị trí thật.

Hai việc không cùng dùng một lò, khuôn, phôi hoặc linh thạch ở cùng interval nếu capacity không đủ.

## 45. ToolDefinition

Công cụ cung cấp interface/capability, không phải tag bắt buộc. Operation nêu demand: lực, nhiệt, độ chính xác, hình học tiếp cận, kẹp giữ, đo hoặc linh control.

Công cụ thay thế hợp lệ nếu đáp demand; hiệu suất, sai số và rủi ro được tính từ capability thực.

## 46. Workstation

Trạm có mounting, workspace, power/heat/ventilation, stability, cleanliness, safety và concurrent capacity. Môi trường ảnh hưởng process.

Một lò đang nóng hoặc bàn đang gá phôi có state; không reset giữa các job.

## 47. Jig, khuôn và datum

Jig/fixture giữ workpiece và thiết lập reference. Khuôn có geometry, wear và thermal state; sản phẩm kế thừa sai lệch của khuôn.

Dùng template tốt tăng repeatability nhưng không tự tăng material quality.

## 48. Kiến thức chế tác

KnowledgeUnit chứa operation, material range, dấu hiệu, lỗi thường gặp, safety và kiểm tra. Biết Design không đồng nghĩa biết từng operation.

NPC chỉ chọn process/alternative đã biết hoặc suy luận được; không truy cập recipe toàn cục.

## 49. Kỹ năng và kiểm soát

Skill ảnh hưởng setup, nhận biết feedback, correction, tốc độ và sai số điều khiển. Cơ thể K4.2 giới hạn force, precision, endurance và senses.

Kỹ năng không vi phạm giới hạn vật liệu/trạm. Người giỏi có thể nhận ra phôi hỏng sớm và dừng để giảm lãng phí.

## 50. Tri thức ngầm và truyền nghề

Một số kỹ năng cần demonstration, practice feedback và material familiarity. Văn bản chỉ truyền phần mã hóa được. Sai lệch truyền qua thế hệ có lịch sử.

Xưởng/phái có process variants và bí quyết riêng, tạo đa dạng thật thay vì skin.

## 51. Thiết lập công đoạn

Setup gồm làm sạch, căn chỉnh, gá, làm nóng, chọn reference, chuẩn bị tool và kiểm tra an toàn. Setup có thời gian và có thể giữ qua batch.

Bỏ setup tăng rủi ro/variance theo cơ chế, không phải hình phạt tùy ý.

## 52. Dung sai tích lũy

Tolerance stack tính qua chuỗi dimensions/joints. Một part riêng đạt chuẩn vẫn có thể làm assembly lệch do tổ hợp.

Plan có strategy đo/chỉnh ở checkpoint. Không cộng quality trung bình để che một interface không lắp được.

## 53. Batch và lot sản xuất

Batch chia setup và process conditions nhưng mỗi output có thể nhận deviation riêng. Lot giữ composition/process provenance chung và distribution chất lượng.

Khi một vật tách ra dùng/sửa/kiểm định, nó nhận ItemInstance riêng. Không dùng lot để xóa defect cá thể đã biết.

## 54. Khai thác

Khai thác chuyển material từ deposit/organism/environment thành parcel, tạo thay đổi địa hình/sinh thái, waste và quyền. Yield phụ thuộc phân bố, công cụ, kỹ năng và chọn lọc.

Nguồn không vô hạn nếu không có regeneration/LawRef.

## 55. Tinh luyện

Crush, wash, sort, smelt, distill, extract hoặc spiritual purification là process nhiều bước. Mỗi bước chuyển composition/phase và tạo byproduct.

Tinh luyện không chỉ tăng purity; có thể mất nguyên tố quý, đổi vi cấu trúc hoặc tạo độc hại.

## 56. Đúc

Đúc gồm chuẩn bị khuôn, nấu, rót, đông, tháo và hoàn thiện. Flow/thermal history tạo shrinkage, porosity, inclusion và residual stress.

Khuôn, gating và tốc độ không bị rút thành một quality roll.

## 57. Rèn và gia công biến dạng

Rèn đổi geometry và microstructure theo nhiệt, strain, hướng và số chu kỳ. Tool contact tạo shape, scale/waste và defect risk.

Đập nhiều lần không tự tăng chất lượng vô hạn; ngoài process window có thể nứt hoặc thô hạt.

## 58. Nhiệt luyện

Heating, soaking, cooling path và atmosphere quyết định phase/microstructure. Workpiece giữ thermal history đủ cho outcome.

Tôi lại có thể đổi hoặc tăng khuyết tật; không reset vật về trạng thái pristine.

## 59. Cắt, khoan, mài và tiện

Material removal tạo geometry mới, chips/dust, heat, tool wear và surface state. Feed/speed/force là operation params theo capability.

Phần bị cắt vẫn là vật chất; thu hồi được tùy kích thước/nhiễm.

## 60. Gỗ và vật liệu thực vật

Chọn thớ, độ ẩm, seasoning, cut, joinery, coating và môi trường quyết định warp, crack, rot và strength. Sấy là process trao đổi nhiệt/ẩm có thời gian.

Không coi mọi “gỗ” cùng tính chất hoặc khô ngay sau chặt.

## 61. Gốm và thủy tinh

Phối liệu, nước, tạo hình, sấy, nung, atmosphere và cooling tạo phase/porosity/stress. Một vết nứt sấy có thể tồn tại ẩn tới khi nung/dùng.

Men là layer có composition/joint, không chỉ màu.

## 62. Dệt, da và vật mềm

Fiber quality, twist, yarn, weave/knit, density, direction, seam và finish tạo properties. Da có vùng, hướng, thuộc và độ ẩm.

Vết rách lan theo topology; vá tạo patch/joint có lịch sử và khả năng riêng.

## 63. Giấy, mực và ghi chép

Giấy có fiber, sizing, thickness, moisture và degradation. Mực có carrier/pigment/binder và phản ứng bề mặt. Chữ là information marks với coverage/legibility.

Sao chép có lỗi theo người/công cụ; bản chép không tự là cùng InformationArtifact content hoàn hảo.

## 64. Thực phẩm và dược liệu

Thu hoạch, cắt, nấu, sấy, lên men, trộn và bảo quản đổi composition, pathogen/toxin, texture, stability và bioavailability. K4.2 xử lý cơ thể sau khi dùng.

Recipe món không sinh dinh dưỡng; ledger dựa trên nguyên liệu/yield.

## 65. Luyện dược và luyện đan

Plan có extraction, purification, reaction, phase, carrier, dose partition và spiritual coupling. Nhiệt/nhịp/thứ tự có thể tạo sản phẩm khác hoặc impurity.

“Thành đan” không tự gom mọi đầu vào thành viên hoàn hảo. Bã, hơi, thất thoát và sai liều có đích.

## 66. Lắp ráp

Assembly operation cần part đúng interface, orientation, access và sequence. Một số part lắp sai vẫn khớp nhưng tạo failure tiềm ẩn.

Tháo ngược sequence có thể cần phá joint. Không cho teleport part vào assembly kín.

## 67. Hoàn thiện

Mài, đánh bóng, phủ, nhuộm, khắc và trang trí đổi surface/information/aesthetic. Coating có thickness, coverage, adhesion và wear.

Trang trí có thể ảnh hưởng xã hội/giá nhưng không tự tăng cơ học hoặc linh tính.

## 68. Phù văn và inscription

Inscription là geometry/information trên surface hoặc volume, có vật mang, continuity, precision, orientation và semantic definition. Nó nối spiritual circuit/coupling khi điều kiện đủ.

Sai một nét không nhất thiết “thất bại” nhị phân; có thể lệch topology, hiệu suất, tín hiệu hoặc nguy cơ.

## 69. Nạp và hiệu chỉnh linh

Pháp khí cần charge/conditioning, resonance alignment, controller binding và test. Năng lượng nạp là reservoir thật; tuning đổi coupling/state.

Đổi chủ không tự tương hợp. Liên kết chủ nhân phải có rule, quyền và cơ chế gỡ.

## 70. Kiểm tra trong quá trình

Checkpoint đo dimension, temperature, composition, defect hoặc resonance. Kết quả có uncertainty và có thể kích hoạt rework/scrap/continue decision.

Không cho crafter biết defect ẩn nếu không có sensor/knowledge phù hợp.

## 71. Ngắt và tiếp tục chế tác

Operation dở giữ workpiece, setup, nhiệt, phản ứng, tool contact, materials consumed và next breakpoint. Ngắt có thể sạch, tạo deviation hoặc làm hỏng tùy phase.

Save/load không hoàn bước hoặc hoàn nguyên input.

## 72. Rework

Rework là CraftPlan mới trên state hiện tại, có thể sửa một deviation nhưng làm mất vật, đổi dimension hoặc thêm stress. Mỗi lần để lại provenance.

Không lặp repair/rework vô hạn để tăng quality miễn phí.

## 73. Phế phẩm và sản phẩm phụ

Chips, slag, ash, offcuts, wastewater, fumes và linh tán là outputs có composition, hazard, vị trí và khả năng tái dùng. Disposal là hành động/transaction.

Không xóa waste để giản hóa kinh tế/sinh thái nếu nó có ảnh hưởng.

## 74. Bảo trì

MaintenancePlan gồm inspection, cleaning, lubrication, adjustment, sharpening, replacement và test. Nó tiêu vật/time và phục hồi đúng state có thể phục hồi.

Lau sạch không sửa nứt; mài sắc làm mất vật liệu; thay part tạo provenance mới.

## 75. Hao mòn

Wear tích lũy tại contact zones theo tải, trượt, surface, contamination và lubrication. Có thể dùng wear budget ở resolution thấp rồi materialize defect khi cần.

Hao mòn thay geometry/interface và tạo debris; không chỉ giảm durability tổng.

## 76. Mỏi

Fatigue phụ thuộc chu kỳ tải, biên độ, mean stress, defect và môi trường. Lịch sử tải được tóm lược bằng spectrum/damage state có bound.

Vật có thể hỏng dưới tải nhỏ sau nhiều chu kỳ; sửa bề mặt không tự xóa damage sâu.

## 77. Ăn mòn và phân hủy

Surface reaction, moisture, temperature, chemistry, organism và spiritual field tạo corrosion/rot. Coating làm chậm theo coverage/integrity.

Vật cất kho vẫn có process; vùng xa dùng breakpoint/daily balance.

## 78. Bẩn và nhiễm chéo

Contaminant là parcel/surface state. Dùng chung công cụ/container có thể chuyển chất, bệnh, mùi hoặc linh dấu.

Cleaning có medium, contact, removal efficiency và waste destination; không đặt sạch tuyệt đối.

## 79. FailureMode

Failure mode nối trigger/state với topology change và consequences: fracture, buckle, leak, jam, dull, delaminate, short, runaway, resonance loss hoặc spiritual backlash.

Không mọi hỏng đều phá toàn Item. Partial failure làm mất một số capability nhưng giữ phần khác.

## 80. Hỏng dây chuyền

Part failure đổi load/flow path, có thể quá tải part khác. Resolver dùng pre-state và propagation theo mốc, giữ cause chain.

Machine/pháp khí phức tạp không nổ toàn bộ chỉ vì một component về 0; outcome theo topology và fail-safe.

## 81. Sửa chữa

Repair target là defect/joint/part/state cụ thể. Plan gồm access, removal, replacement/fill/join, alignment, finish và verification.

Sửa có thể khôi phục function nhưng không provenance, vật liệu đã mất hoặc fatigue sâu nếu không xử lý.

## 82. Tháo dỡ và salvage

Disassembly tạo parts/parcels với damage và contamination hiện tại. Yield phụ thuộc joint, access, tool và kỹ năng.

Vật thu hồi giữ nguồn cũ; không biến thành nguyên liệu tinh khiết mặc định.

## 83. Tái dùng và tái chế

Reuse giữ part/function; remanufacture phục hồi theo standard; recycling phá cấu trúc thành material feedstock. Mỗi đường có chi phí/yield và loss.

Không có nút recycle chuyển toàn bộ mass thành nguyên liệu mới cùng chất lượng.

## 84. Chuẩn hóa và tương thích

Standard định interface, dimensions, tolerances, material grade, test và marking. Interchangeability là kết quả đo/fit, không chỉ cùng blueprint.

Chuẩn địa phương tạo mạng sản xuất và trade-offs; vật cổ/ngoại lai có thể cần adapter.

## 85. Module và nâng cấp

Item modular có slots/ports với geometry, load, flow và control compatibility. Gắn module đổi mass, balance, energy demand và failure modes.

Nâng cấp không tự cộng bonus; capability được tính lại qua toàn graph.

## 86. Quyền, sở hữu và custody

Item/part/lot liên kết OwnershipInterest, custody, claim và obligation của K2.3. Tháo vật thuê không tự chuyển quyền part. Chế tác theo hợp đồng phải xác định quyền input, output, phế và bí quyết.

Vật bị trộm vẫn có state/provenance; tính bất hợp pháp không cản tương tác vật lý.

## 87. Lịch sử và tính xác thực

ItemHistory ghi creation, makers, owners/custodians, repairs, failures, inspections, notable uses và claims. Không lưu mọi lần chạm; giữ anchor có giá trị nhân quả/xã hội.

Authenticity là inference từ mark, provenance, witness và test; forgery có thể tạo belief sai nhưng không sửa history thật.

## 88. Giá trị kinh tế

Không có giá intrinsic duy nhất. Giá phụ thuộc capability được tin, condition, rarity, provenance, compatibility, demand, law, seller/buyer và thông tin.

Chất lượng ẩn tạo adverse selection; inspection, warranty và reputation có vai trò thật.

## 89. Quan sát vật phẩm

Item phát signals: hình, màu, mùi, âm, nhiệt, rung, feel, tool marks, linh resonance. Sensor/skill biến thành Observation.

Tên chính xác, vật liệu và công dụng không tự hiện khi nhân vật chưa biết. UI phân biệt “thấy”, “đo”, “suy đoán” và “được kể”.

## 90. Nhận diện và học dùng

Knowledge liên kết Design family, operation, hazard, maintenance và use technique. Thử nghiệm có thể học nhưng tiêu thời gian/vật và có rủi ro.

Một NPC có thể biết dùng mà không biết chế tạo, biết sửa mà không biết luyện vật liệu, hoặc tin sai về đồ giả.

## 91. Vũ khí

Weapon capability đến từ geometry, mass distribution, edge/point, stiffness, grip, condition, actor và target. K4.1 giải contact/transfer; K4.2 giải tissue injury.

Không lưu damage cơ sở như sự thật duy nhất. Cùng kiếm tạo outcome khác theo đòn, vùng trúng, giáp và người dùng.

## 92. Giáp và phòng hộ

Armor là layered coverage/assembly gắn body regions, có fit, mobility, gaps, closures, heat/moisture và load. Mỗi layer đổi transfer và có damage.

Giáp thân không bảo vệ tay; giáp nặng không chỉ giảm tốc bằng một hệ số mà thay body/action demands.

## 93. Công cụ và dụng cụ đo

Tool có working interface, precision, capacity, calibration và wear. Measurement tool thêm range/resolution/uncertainty.

Công cụ hỏng có thể vẫn dùng thô; calibration sai tạo output lệch có hệ thống.

## 94. Y cụ và vật chăm sóc

Băng, nẹp, kim, dao, bình, thuốc và thiết bị linh nối procedure K4.2. Sterility, fit, absorbency, sharpness, dose và contamination là state thật.

Một “bộ cứu thương” là container/assembly, không kho vô hạn hành động chữa.

## 95. Máy, xe và công trình

Machine/vehicle/building component dùng cùng Assembly/Mechanism/Network nhưng partition theo kích thước. Công trình có foundation, load paths, rooms và utilities; xe có mobility/power/control.

Không cần một hệ vật phẩm khác, nhưng ownership, storage và resolution có policy riêng.

## 96. Pháp khí

Pháp khí thêm spiritual materials, circuits/inscriptions, reservoir, controller, bindings và CouplingRules. Công dụng vẫn qua FunctionDefinition/PhenomenonProcess.

Phẩm cấp không bảo đảm tương thích. Hỏng vật lý có thể cắt circuit; quá tải linh có thể đổi vật liệu/cấu trúc.

## 97. Trận bàn và vật neo

Một Item có thể là controller/anchor của FormationGraph. Di chuyển, xoay, che, hỏng hoặc cạn nguồn đổi topology trường.

Không copy aura vào nhân vật rồi quên vật nguồn; effect giữ source/process link.

## 98. Vật tiêu hao

Consumable là parcel/part bị chuyển hóa khi dùng: thức ăn, nhiên liệu, đạn, giấy, thuốc, bùa. “Số lần dùng” chỉ là View nếu lượng/geometry thực quyết định.

Dùng một phần tạo remainder có state và vị trí; không biến mất toàn stack.

## 99. Design grammar

Generator ghép:

```text
purpose → function requirements → architecture pattern
→ part/interface graph → material/process candidates
→ feasibility/tolerance checks → cost/history/style
```

Không ghép adjective ngẫu nhiên. Mọi thiết kế sinh phải chế tạo và dùng được theo luật hiện có.

## 100. Không gian thiết kế tổ hợp

Đa dạng đến từ lựa chọn có tương tác: vật liệu, section, length, layer, joint, mechanism, finish, inscription và process route. Constraint solver loại tổ hợp vô lý.

Generator đo novelty theo cấu trúc/function/history, tránh tạo 10.000 vật chỉ khác 1% chỉ số.

## 101. Phong cách văn hóa

Culture/organization cung cấp preferred materials, motifs, standards, process knowledge, taboos và resource constraints. Style có dấu vết hình học/chế tác nhận biết được.

Không gắn skin văn hóa tách khỏi cách làm, công dụng và chuỗi cung ứng.

## 102. Đổi mới và phát minh

NPC có thể nhận vấn đề, kết hợp knowledge, tạo prototype, đo, thất bại, sửa Design và truyền lại. Innovation tạo Design lineage/version.

Không mở khóa recipe toàn thế giới khi một người phát minh; thông tin phải lan qua kênh xã hội.

## 103. Vật độc nhất và bảo vật

Unique item xuất hiện từ vật liệu/biến cố/creator/history hiếm hoặc authored anchor. Nó tuân cùng cấu trúc, trừ LawRef rõ.

Danh tiếng có thể vượt công dụng thật; phá hủy bảo vật vẫn để lại vật chất, lịch sử và hậu quả xã hội.

## 104. Item resolution IR0–IR5

| Mức | Biểu diễn |
|---|---|
| IR0 | surface/contact/defect/operation chi tiết |
| IR1 | part/joint/mechanism đầy đủ |
| IR2 | assembly + critical states |
| IR3 | capability/condition + anchored parts |
| IR4 | lot/distribution + exceptions |
| IR5 | regional material/product balance |

IR là độ phân giải vật phẩm, tách M, R, P và B. Item có identity không bị biến thành lot vô danh khi ra xa.

## 105. Nâng và hạ IR

Hạ IR giữ identity, total composition, dimensions critical, unique parts, defects đã biết/quan trọng, active process, ownership, history anchors và error debt. Nâng IR dùng blueprint/history/seed/constraints.

Không nâng resolution để bốc lại defect hoặc tạo part thuận lợi cho nhu cầu hiện tại.

## 106. Lot và aggregate

Lot chỉ gộp vật đủ tương đương theo equivalence profile của truy vấn/process. Profile cho bán hàng khác profile cho luyện đan hoặc lắp máy.

Tách lot phân bổ distribution bằng seed và history. Item đã cá thể hóa hoặc có claim riêng không gộp ngược.

## 107. Scheduler và hiệu năng

Không tick mọi vật. Wakeup ở:

- operation breakpoint;
- nhiệt/ẩm/ăn mòn vượt ngưỡng;
- maintenance due;
- reservoir cạn;
- joint/defect đạt failure threshold;
- movement/boundary flow;
- inspection/use;
- promotion IR.

Batch lot/process vùng xa nhưng commit outputs/claims quan trọng riêng.

## 108. Lưu, tải và replay

Save giữ Definition/Design versions, item/part IDs, Assembly/Mechanism graphs, parcels/composition, geometry deviations, joints, surfaces, defects, active processes, history anchors, ownership refs, lot distributions, IR/error debt và RNG cursors.

Derived capability/grade/UI cache dựng lại. Save giữa operation không nhân input/output hoặc hoàn step.

## 109. UI text trên điện thoại và máy tính

Projection:

- nhận diện ngắn;
- tình trạng và nguy cơ;
- công dụng theo tác vụ hiện tại;
- cấu tạo/bộ phận;
- chất lượng/kiểm định và độ chắc chắn;
- lịch sử/quyền;
- thao tác khả thi;
- debug canonical riêng.

Điện thoại dùng thẻ và drill-down; desktop thêm bảng so sánh. Cả hai không lộ state ngoài tri thức.

## 110. Artifact cần có

- Material/Property/ProcessDefinition;
- Geometry/Part/Joint/InterfaceDefinition;
- DesignBlueprint/DesignLineage;
- Item/Part/Lot/Workpiece state;
- Function/Capability/TaskProfile;
- CraftPlan/Operation/Station/Tool/Jig;
- Standard/Inspection/Measurement;
- Defect/Failure/Maintenance/Repair;
- Generator grammar/constraints;
- IR model, fixture và oracle.

Mọi artifact có version, SourceRef, validity và migration.

## 111. Bất biến

1. Tổng vật chất/linh lượng qua chế tác khớp input/output/waste.
2. Part và Item có vị trí/chủ quản duy nhất.
3. Assembly không tham chiếu part đã tháo/phá.
4. Joint/interface tương thích trước commit.
5. Capability dẫn xuất từ state/context có revision.
6. Quality khác Condition và Claim.
7. Defect ẩn không tự thành kiến thức.
8. Operation dở không hoàn/ngược khi tải.
9. Tool/station/input không bị dùng quá capacity.
10. Repair không sinh vật hoặc xóa provenance.
11. Lot không nuốt exception/identity/claim.
12. Hạ/nâng IR giữ tổng, anchor và error bound.
13. Pháp khí tuân reservoir/coupling/LawRef.
14. Mobile/desktop giữ semantic fingerprint.

## 112. Lỗi và exploit phải chống

- gộp lot để xóa hỏng/tạp;
- tách stack để nạp lại charge/freshness;
- tháo/lắp để reset wear;
- sửa chữa sinh vật liệu;
- hủy craft lấy lại toàn input sau khi đã dùng;
- load để reroll quality/defect;
- đổi IR để mất vật độc nhất;
- dùng cùng tool/trạm ở hai việc;
- mài sắc vô hạn không mất material;
- tái chế 100% không waste;
- phẩm cấp thay thế capability thật;
- phù văn tạo năng lượng không LawRef;
- item xa không hỏng dù môi trường tác động;
- cache công dụng còn dùng part đã gãy.

## 113. Fixture K4.3 đề xuất

| Fixture | Nội dung | Mục tiêu |
|---|---|---|
| K4I-F01 | parcel kim loại tách/gộp/tinh luyện | bảo toàn/provenance |
| K4I-F02 | dao gồm lưỡi–cán–chốt | assembly/capability |
| K4I-F03 | ba lưỡi cùng Design khác process | quality variation |
| K4I-F04 | bình có closure và lỗ | container/flow |
| K4I-F05 | khuôn mòn qua batch | inherited deviation |
| K4I-F06 | phôi rèn–tôi–mài | microstructure/history |
| K4I-F07 | vải nhiều lớp bị rách/vá | soft topology/repair |
| K4I-F08 | thuốc ba bước và bã | reaction/dose/waste |
| K4I-F09 | máy tay quay có joint kẹt | mechanism/failure |
| K4I-F10 | giáp phủ không đều | body coverage/transfer |
| K4I-F11 | y cụ bị nhiễm | item–body–pathogen |
| K4I-F12 | pháp khí có mạch khắc lỗi | spiritual circuit |
| K4I-F13 | lot 100 vật có 2 exception | aggregate/identity |
| K4I-F14 | craft bị ngắt và save | exactly-once |
| K4I-F15 | cùng fixture mobile/desktop | semantic parity |

Chưa fixture nào được mã hóa hoặc chạy.

## 114. Điều kiện VP01–VP96

### 114.1. Identity, vật chất và hình học

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP01 | tách parcel nguyên liệu | bảo toàn composition và provenance |
| VP02 | vật rời lot thành cá thể | có item_id ổn định |
| VP03 | tháo part khỏi Item | part có vị trí, Item mất dependency đúng |
| VP04 | nung chảy Item | identity chức năng kết thúc, vật chất còn |
| VP05 | cắt vật mềm | length/mass và topology khớp |
| VP06 | đổ đầy container | mass/center/capacity cập nhật |
| VP07 | geometry unknown | không hiểu thành kích thước 0 |
| VP08 | tải lại vật sinh theo seed | biến thể/part IDs không đổi |

### 114.2. Vật liệu và chất lượng

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP09 | cùng composition khác heat history | property/capability có thể khác |
| VP10 | gỗ xoay thớ | strength theo orientation |
| VP11 | gộp lot có tạp chất | tạp không biến mất |
| VP12 | property ngoài validity range | fallback/failure rõ |
| VP13 | defect ẩn chưa đo | NPC không tự biết |
| VP14 | hai tiêu chuẩn phẩm cấp | cùng vật có thể xếp khác có nguồn |
| VP15 | vật mòn nhưng chế tạo tốt | Quality và Condition không bị gộp |
| VP16 | kiểm định sai calibration | Observation/Claim sai, state thật giữ |

### 114.3. Assembly, joint và mechanism

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP17 | thiếu chốt lắp dao | joint không tự tồn tại |
| VP18 | part đúng loại sai tolerance | fit/capability phản ánh deviation |
| VP19 | tháo joint phá hủy | vật tư nối hỏng có output |
| VP20 | cơ cấu mất một link | topology và capability cập nhật |
| VP21 | joint kẹt vì bẩn | mechanism đổi theo surface state |
| VP22 | lắp module nặng | mass/balance/load path tính lại |
| VP23 | cache sau tháo part | invalidated theo revision |
| VP24 | hỏng một part không critical | giữ capability không phụ thuộc |

### 114.4. Công dụng và người dùng

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP25 | cùng dao, hai người khác cơ thể | performance có thể khác |
| VP26 | dùng búa chặn cửa | affordance ngoài category hợp lệ |
| VP27 | lưỡi sắc cắt vật mềm/cứng | outcome theo target/context |
| VP28 | cán quá lớn | grip/precision bị giới hạn thật |
| VP29 | vật nóng được cầm | heat transfer nối cơ thể |
| VP30 | nhân vật chưa biết cơ cấu | UI không lộ thao tác bí mật |
| VP31 | vật có công dụng nhưng thiếu nguồn | action không chạy miễn phí |
| VP32 | mở View nhiều lần | state/RNG không đổi |

### 114.5. CraftPlan và tài nguyên

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP33 | bắt đầu craft đủ input | tạo Workpiece, không ra thành phẩm ngay |
| VP34 | hai job giữ cùng phôi | chỉ reservation hợp lệ commit |
| VP35 | hai job dùng một lò | capacity/time được phân xử |
| VP36 | hủy sau material removal | phoi và phôi hiện tại giữ |
| VP37 | đổi người giữa công đoạn | state dở giữ, capability mới được kiểm |
| VP38 | thiếu tool chính xác | dùng thay thế nếu đáp demand, có trade-off |
| VP39 | bỏ setup | deviation/risk theo rule |
| VP40 | save giữa operation | không hoàn hoặc tiêu input lần hai |

### 114.6. Các quy trình sản xuất

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP41 | tinh luyện quặng | metal/byproduct/waste balance khớp |
| VP42 | đúc khuôn mòn | output kế thừa deviation của khuôn |
| VP43 | rèn ngoài nhiệt phù hợp | defect/microstructure có hậu quả |
| VP44 | tôi rồi tải lại | thermal path/outcome không đổi |
| VP45 | mài cạnh | sắc hơn nhưng mất material/tool wear |
| VP46 | sấy gỗ quá nhanh | moisture gradient/warp risk giữ |
| VP47 | nung gốm có nứt ẩn | defect tồn tại qua process |
| VP48 | dệt sai hướng sợi | property theo topology thật |
| VP49 | sao chép sách | lỗi thông tin có provenance |
| VP50 | nấu/luyện dược | composition, dose, bã và nhiệt khớp |
| VP51 | lắp sai orientation | có thể lắp nhưng failure/capability khác |
| VP52 | phủ bề mặt thiếu coverage | protection chỉ ở vùng thật |

### 114.7. Hao mòn, hỏng và sửa

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP53 | dùng dao nhiều lần | wear ở edge và debris tích lũy |
| VP54 | mỏi dưới tải lặp | lịch sử chu kỳ ảnh hưởng failure |
| VP55 | coating trầy | corrosion protection đổi cục bộ |
| VP56 | kho ẩm vùng xa | decay tiếp tục theo breakpoint |
| VP57 | lau bẩn | contaminant chuyển vào vật lau/nước |
| VP58 | giảm durability View | không tạo damage thứ hai |
| VP59 | repair joint | tiêu vật tư và giữ provenance |
| VP60 | rework nhiều lần | dimension/material không reset |
| VP61 | thay part | part cũ/part mới và quyền rõ |
| VP62 | partial failure | chỉ capability liên quan mất |
| VP63 | hỏng dây chuyền | propagation theo topology/cause |
| VP64 | maintenance quá hạn | không tự hỏng nếu chưa có process/threshold |

### 114.8. Tái dùng, lot và kinh tế

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP65 | tháo đồ cũ | yield theo joint/tool, không 100% mặc định |
| VP66 | tái chế hợp kim bẩn | composition mới giữ tạp/loss |
| VP67 | lot có hai vật hỏng | exception không bị average mất |
| VP68 | tách lot rồi gộp lại | defect đã biết không biến mất |
| VP69 | vật thuê bị tháo | ownership part/output theo contract |
| VP70 | đồ trộm được dùng | vật lý hoạt động, pháp lý vẫn bất hợp lệ |
| VP71 | hàng giả có dấu đẹp | belief/value có thể sai, state/history thật giữ |
| VP72 | kiểm định sau khi bán | thông tin mới đổi quyết định, không hồi tố giá cũ |

### 114.9. Vũ khí, giáp và y cụ

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP73 | cùng kiếm đòn khác nhau | contact/transfer khác, không damage cố định |
| VP74 | edge mẻ giữa trận | capability đổi từ đúng mốc |
| VP75 | giáp hở bàn tay | không bảo vệ vùng ngoài coverage |
| VP76 | giáp ướt/nóng | body/environment effects nối thật |
| VP77 | băng đã thấm | capacity/contamination ảnh hưởng chăm sóc |
| VP78 | kim bẩn | transfer pathogen theo contact |
| VP79 | bộ cứu thương thiếu món | không cung cấp action vô hạn |
| VP80 | nẹp sai kích thước | stabilization/capability theo fit |

### 114.10. Pháp khí và thông tin

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP81 | phù văn đứt một nét | circuit/topology/capability đổi |
| VP82 | pháp khí cạn reservoir | effect dừng theo process |
| VP83 | người dùng không tương hợp | coupling/efficiency/risk khác |
| VP84 | vật nguồn bị di chuyển | trường/trận pháp cập nhật |
| VP85 | đổi chủ có binding | không tự gỡ quyền/coupling |
| VP86 | nạp quá capacity | overflow có đích/hậu quả |
| VP87 | ngọc giản hỏng vật mang | information bị ảnh hưởng theo coverage |
| VP88 | sở hữu bí kíp | không tự tăng knowledge/skill |

### 114.11. Sinh nội dung và độ phân giải

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VP89 | generator tạo Design | qua feasibility/interface/process checks |
| VP90 | 1.000 biến thể | khác biệt có ý nghĩa, không chỉ tên/1% stat |
| VP91 | vật độc nhất sinh từ lịch sử | provenance ổn định, không bốc lại |
| VP92 | hạ IR có defect nguy hiểm | giữ defect/hazard anchor |
| VP93 | nâng IR vật đã biết | không đổi part/defect quan sát trước |
| VP94 | đổi IR lặp lại | total/capability critical không drift |
| VP95 | Item xa có identity | không bị gộp vào lot vô danh |
| VP96 | cùng save mobile/desktop | graph/process/fingerprint semantic giống |

VP01–VP96 đều là điều kiện thiết kế chưa mã hóa và chưa chạy. Tổng hồ sơ tăng từ 1.284 lên 1.380 điều kiện thuộc 36 họ.

## 115. Cổng K4.3

| Cổng | Đạt khi | Hiện tại |
|---|---|---|
| K4I01 | Definition–Design–Instance–View rõ | đạt trên giấy |
| K4I02 | material/geometry/assembly contract rõ | đạt trên giấy |
| K4I03 | capability theo actor/context rõ | đạt trên giấy |
| K4I04 | CraftPlan/Workpiece/resource chain rõ | đạt trên giấy |
| K4I05 | wear–repair–reuse giữ bảo toàn | đạt trên giấy |
| K4I06 | pháp khí dùng field/coupling/LawRef | đạt trên giấy |
| K4I07 | schema/material/process registry tồn tại | chưa |
| K4I08 | K4I-F01–F15 mã hóa | chưa |
| K4I09 | VP01–VP96 chạy có evidence | chưa |
| K4I10 | generator chứng minh đa dạng hữu ích | chưa |

## 116. Vấn đề mở

1. Hệ đơn vị và hình học tối thiểu cho chặng đầu?
2. Những họ vật liệu thường nào xuất hiện ở An Khê?
3. Linh tài khác vật liệu thường ở coupling hay có LawRef riêng?
4. Cần mô phỏng phase/microstructure sâu tới đâu cho mỗi nghề?
5. Những chuẩn kích thước nào đã tồn tại trong văn hóa?
6. Vật nào luôn cá thể hóa, vật nào được ở lot?
7. Mức tự do dùng vật ngoài công dụng thiết kế?
8. Công thức kỹ năng–sai số–feedback?
9. Mức tự động hóa xưởng và máy móc theo thời đại?
10. NPC có thể tự phát minh thiết kế mới tới đâu?
11. Phẩm cấp pháp khí là chuẩn khách quan hay xã hội?
12. Binding pháp khí tác động quyền hay chỉ coupling?
13. Mức phá hủy công trình và máy lớn?
14. Bao nhiêu lịch sử item được giữ lâu dài?
15. Chi tiết chế tác nào hiện trên điện thoại mặc định?
16. K4.4 ưu tiên môi trường–sinh thái hay công pháp–cảnh giới?

Chưa mục nào được tự chốt.

## 117. Rủi ro

| Rủi ro | Hậu quả | Kiểm soát đề xuất |
|---|---|---|
| mọi vật có graph quá sâu | vượt hiệu năng | IR0–IR5 và lot |
| item chỉ là stat block | mất chiều sâu | material–geometry–process–context |
| generator tạo rác | số lượng giả | feasibility/novelty/usefulness gates |
| công thức nghề quá chi li | khó chơi | kế hoạch mục tiêu và projection tầng |
| quality roll cuối | lịch sử công đoạn vô nghĩa | deviation truyền từng operation |
| sửa/tái chế sinh vật | phá kinh tế | ledger input/output/waste |
| phẩm cấp thay sự thật | mất tính khám phá | Standard/View tách state |
| pháp khí phá luật | exploit vô hạn | reservoir/circuit/coupling/LawRef |
| vật xa không lão hóa | lịch sử sai | scheduled breakpoint/aggregate |
| UI điện thoại quá tải | khó thao tác | thẻ, drill-down, saved comparisons |

## 118. Trình tự hiện thực hóa khi được yêu cầu

1. Material/Geometry/Part/Joint/Item schemas.
2. AssemblyGraph và capability projection.
3. F01–F04: parcel, dao, biến thể, container.
4. CraftPlan/Workpiece/Operation/Reservation.
5. tool/station/tolerance/measurement.
6. process vật liệu F05–F08.
7. wear/failure/maintenance/repair/salvage.
8. mechanism, armor, y cụ và pháp khí.
9. lot/IR0–IR5/save/replay.
10. design generator và 1.000 biến thể audit.
11. mã hóa VP01–VP96 và chạy evidence đa nền tảng.

Đây là thứ tự triển khai tương lai, chưa phải việc đã làm.

## 119. Những điều không được tuyên bố

- Không nói đã tạo thư viện hàng nghìn vật phẩm.
- Không nói material database hoặc generator đã tồn tại.
- Không nói quy trình chế tác chính xác lịch sử/khoa học.
- Không nói đã chốt phẩm cấp, vật liệu hoặc pháp khí.
- Không nói IR0–IR5 đã đạt parity.
- Không nói VP01–VP96 đã mã hóa/chạy.
- Không nói 1.380 điều kiện là test tự động.
- Không nói game đã chạy trên điện thoại/máy tính.

## 120. Giá trị K4.3 cung cấp thật

- vật phẩm có cấu trúc, sai số và lịch sử cá thể;
- công dụng suy từ vật–người–tác vụ–môi trường;
- chất lượng, tình trạng, phẩm cấp và lời quảng cáo được tách;
- chế tác là chuỗi process có workpiece và chất thải;
- hỏng, sửa và tái chế giữ bảo toàn/provenance;
- pháp khí dùng cùng nền field/coupling;
- grammar để sinh đa dạng có ý nghĩa;
- 15 fixture và 96 điều kiện có thể mã hóa sau.

## 121. Bước tiếp theo

K4.4 nay đã được cụ thể hóa tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
