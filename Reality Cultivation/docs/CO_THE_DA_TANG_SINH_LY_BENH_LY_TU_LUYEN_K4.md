---
title: "K4.2 — Cơ thể đa tầng, sinh lý, bệnh lý và tu luyện hóa cơ thể"
aliases:
  - "Cơ thể đa tầng K4"
  - "Sinh lý và bệnh lý K4"
tags:
  - reality-cultivation
  - ke-hoach
  - k4
  - co-the
status: de-xuat
updated: 2026-09-06
---

# K4.2 — Cơ thể đa tầng, sinh lý, bệnh lý và tu luyện hóa cơ thể

> [!summary]
> Tài liệu này mở rộng [[CO_THE]] và [[CO_THE_THU]] trên nền [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. Cơ thể được mô hình hóa từ vùng–cơ quan–mô–compartment–mạng vận chuyển, có nội môi, bệnh lý, thương tích, điều trị, hồi phục và biến đổi tu luyện. Đây là thiết kế game chưa triển khai, không phải mô hình y khoa đã được xác minh.

## 1. Mục tiêu

Một cơ thể phải có khả năng tạo ra chuỗi hậu quả như sau mà không cần thanh HP:

```text
vết cắt → mô/mạch bị hở → mất máu cục bộ và toàn thân
→ tưới máu giảm → cơ quan thiếu cung → ý thức/chức năng đổi
→ đông máu/chăm sóc → cầm hoặc tiếp tục chảy
→ viêm, sửa chữa, sẹo, di chứng
```

Tu luyện cũng đi qua chuỗi thật:

```text
nguồn linh → hấp thu → tuyến vận hành → tải mô/cấu trúc
→ thích nghi hoặc tổn thương → thay đổi năng lực → lịch sử cơ thể bền vững
```

## 2. Phạm vi

K4.2 định:

- blueprint giải phẫu và biến thể cá thể;
- topology cơ quan, mô, mạch, thần kinh và kinh mạch;
- compartment, dòng máu/khí/dinh dưỡng/chất thải/tín hiệu;
- nội môi và các vòng điều hòa;
- thương tích, bệnh, độc, nhiễm và suy cơ quan;
- đau, cảm giác, ý thức, ngủ, mệt và khả năng;
- điều trị, chăm sóc, hồi phục, sẹo và tái tạo;
- tuổi, phát triển, sinh sản, lão hóa và tử vong;
- tu luyện hóa cơ thể, đột phá và dị biến;
- mức chi tiết, lưu tải, UI text và điều kiện kiểm chứng.

Thông số cụ thể phải được hiệu chỉnh sau; không tự coi mô hình là chẩn đoán y khoa ngoài đời.

## 3. Ranh giới chủ quản

| Miền | Sở hữu |
|---|---|
| K4.1 | vật chất, lượng, trường, transfer, phản ứng, nhiệt, áp lực |
| K4.2 | đáp ứng sống, điều hòa, tổn thương sinh học, bệnh lý, chức năng |
| hành động | ý định, thao tác, tiến độ và điều kiện thực hiện |
| nhận thức | signal, observation, belief, memory và quyết định |
| vật phẩm | dụng cụ, thuốc, cấu trúc vật và quyền sử dụng |
| tu luyện | kiến thức, công pháp, mục tiêu, bình cảnh và lựa chọn |

K4.2 không tự di chuyển vật chất; nó yêu cầu transfer qua K4.1 và diễn giải hậu quả sinh học từ state đã commit.

## 4. Không có thanh HP canonical

Các đại lượng tóm tắt như “nguy kịch”, “khả năng vận động 40%” hoặc “mức đau cao” là View dẫn xuất. Sự thật nằm ở:

- cấu trúc còn/mất;
- trạng thái mô;
- lượng và dòng trong compartment;
- quá trình bệnh/tổn thương;
- khả năng điều hòa;
- chức năng thực tế.

Không vừa trừ HP vừa áp thương tích cho cùng tác động.

## 5. Phân cấp cơ thể

```text
Organism
  BodyRegion
    Organ / Limb / StructuralUnit
      Substructure
        TissueLayer
          LocalCompartment / FunctionalUnit
```

Không cần tạo từng tế bào làm entity. Những đơn vị vi mô có thể là cohort hoặc density field; cá thể hóa khi có lý do gameplay như ký sinh vật, tế bào dị biến hoặc linh thể đặc biệt.

## 6. AnatomyDefinition và BodyInstance

`AnatomyDefinition` mô tả blueprint loài/kiểu cơ thể. `BodyInstance` lưu giải phẫu thật của cá thể: tuổi, kích thước, biến thể, phần thiếu/thừa, sẹo, cấy ghép, tổn thương và lịch sử biến đổi.

Hai NPC cùng loài không bắt buộc có kích thước, vị trí mạch, sức chịu hoặc kinh mạch giống hệt. Biến thể phải có seed/provenance và không được bốc lại khi tải.

## 7. Danh tính phần cơ thể

Mỗi phần quan trọng có `body_part_id` bền vững. Cắt bỏ không xóa record: nó chuyển thành vật thể sinh học có provenance từ chủ thể, vị trí và trạng thái riêng.

Ghép lại hoặc cấy ghép tạo quan hệ nguồn–đích; không đổi ID để giả rằng chưa từng bị tách. Quyền pháp lý, ký ức và nhận dạng thuộc domain tương ứng.

## 8. Hình học và topology

Cơ thể dùng graph và vùng tương đối:

- `contains`;
- `attached_to`;
- `articulates_with`;
- `supplies`;
- `drains`;
- `innervates`;
- `protects`;
- `spiritual_connects`;
- `adjacent_to`.

Không cần mesh đầy đủ. Contact từ K4.1 ánh xạ vào vùng/lớp bằng coverage, hướng, độ sâu và posture.

## 9. Đối xứng và bên cơ thể

Trái/phải là quan hệ giải phẫu, không chỉ tên chuỗi. Chức năng có thể yêu cầu một bên, hai bên hoặc dự phòng chéo. Vết thương tay trái không tự giảm chân phải.

Các loài không đối xứng hoặc tu luyện làm đổi cấu trúc có thể dùng topology khác mà không sửa engine.

## 10. Mô và lớp

`TissueDefinition` khai vai trò cơ học, tưới máu, dẫn truyền, trao đổi, khả năng sửa chữa, nhạy đau, đáp ứng miễn dịch và coupling linh. `TissueState` lưu integrity, perfusion, oxygenation, hydration, temperature, contamination, inflammation và biến đổi cấu trúc cần thiết.

Không ép mọi mô dùng cùng các trường. Xương, thần kinh, da, cơ và kinh mạch có state/capability khác nhau.

## 11. Compartment

Compartment là kho có biên: máu tuần hoàn, dịch kẽ, lòng ruột, phế nang, bàng quang, kho linh lực hoặc vùng mô cục bộ. Nó có volume/capacity, composition, pressure/potential và các interface.

Chất chỉ đổi compartment qua transfer. Ăn không đưa dinh dưỡng thẳng vào máu; uống không lập tức sửa mất nước toàn thân.

## 12. Mạng vận chuyển

`TransportNetwork` gồm node, edge, pump, valve, resistance, capacity và leak. Các mạng:

- tuần hoàn;
- hô hấp/đường khí;
- tiêu hóa;
- bạch huyết;
- thần kinh/tín hiệu;
- bài tiết;
- kinh mạch/linh lực.

Cùng hình thức graph nhưng quantity và luật khác; không cho linh lực chảy như máu nếu Definition không khai coupling đó.

## 13. OrganDefinition

Cơ quan là cấu trúc có subparts, inputs, outputs, perfusion, control signals, functional modes, reserve và failure modes. `OrganState` chủ yếu là cache/projection từ mô và flow, cộng state điều khiển riêng nếu cần.

Mất một phần cơ quan có hậu quả theo phần chức năng còn lại; không mặc định cơ quan hoạt động 100% cho tới khi HP về 0.

## 14. Hệ cơ quan

System grouping hỗ trợ giải thích và query: tuần hoàn, hô hấp, tiêu hóa, chuyển hóa, tiết niệu, thần kinh, nội tiết, miễn dịch, cơ–xương, da và sinh sản. Nó không là lớp damage thứ hai.

Một hậu quả có thể lan qua nhiều hệ bằng flow và controller; trace giữ nguyên nguyên nhân gốc.

## 15. Nội môi

`HomeostaticVariable` có set range thay vì một điểm tuyệt đối, sensor, controller, effector, delay, reserve và failure response. Ví dụ nhiệt, thể tích dịch, khí, năng lượng khả dụng và cân bằng chất.

Controller có giới hạn và chi phí. Cơ thể không tự đưa mọi biến về bình thường miễn phí giữa hai lần quan sát.

## 16. Dự trữ và bù trừ

Cơ thể có reserve về tim phổi, trao đổi, năng lượng, dịch và điều hòa. Bù trừ che triệu chứng một thời gian nhưng tiêu reserve và có thể tạo chi phí.

“Trông vẫn ổn” không đồng nghĩa state bình thường. Khi reserve cạn, chức năng có thể tụt nhanh dù tổn thương gốc không vừa tăng.

## 17. Chuyển hóa và ngân sách năng lượng

Tách:

- năng lượng hóa học trong chất mang;
- tốc độ chuyển hóa;
- năng lượng khả dụng cục bộ;
- dự trữ ngắn/dài hạn;
- nhiệt và chất thải;
- linh năng nếu có coupling.

Hoạt động, sửa chữa, miễn dịch, giữ nhiệt và tu luyện cạnh tranh ngân sách. Mệt không là một loại nhiên liệu duy nhất.

## 18. Tuần hoàn

Tim/pump tạo chênh áp; mạch phân phối theo resistance và integrity; mô nhận flow theo topology. State tối thiểu gồm lượng máu, khả năng vận chuyển, áp lực hiệu dụng, cung lượng, phân bố và leak.

Không dùng “mất X% máu = chết” độc lập. Hậu quả phụ thuộc tốc độ mất, bù dịch, co mạch, tư thế, tim, hô hấp và nhu cầu mô.

## 19. Máu và thành phần vận chuyển

Máu là hỗn hợp có carrier cells/proteins, plasma, khí, chất dinh dưỡng, chất thải, thuốc, độc và tín hiệu. Ở resolution thấp có composition vector; khi cần có subpopulation.

Truyền máu phải xét lượng, tương thích theo luật thế giới, chất lượng, nhiệt, nhiễm và tốc độ. Không cộng một “đơn vị máu” trừu tượng vào HP.

## 20. Tưới máu và thiếu cung

Mỗi mô có demand và delivery. `SupplyDeficit` tích lũy theo thời gian, loại chất và khả năng chịu. Khôi phục flow không tự xóa toàn bộ hậu quả; reperfusion hoặc damage thứ phát có thể tồn tại nếu model hỗ trợ.

Resolution thấp giữ dose/time-above-threshold và các organ anchors, tránh quên thiếu máu ngắn nhưng nghiêm trọng.

## 21. Chảy máu

Vết hở tạo leak edge từ mạch/compartment ra mô, bề mặt hoặc môi trường. Rate phụ thuộc áp lực, kích thước, loại mạch, co rút, clot và vị trí.

Máu đã ra có MatterParcel/vị trí; băng chỉ hấp thu hoặc ép, không xóa. Chảy trong kín khác chảy ngoài vì khó thấy và tạo áp lực lên cấu trúc.

## 22. Đông máu

Đông máu là process có nguyên liệu, surface, flow, nhiệt, thuốc/chất cản và thời gian. Clot có integrity, attachment và nguy cơ bật lại.

Băng ép đổi rate vật lý; thuốc đổi process sinh học. Hai tác động có thể phối hợp nhưng không đặt cờ `bleeding=false` miễn phí.

## 23. Hô hấp

Đường khí, thông khí, trao đổi và vận chuyển là các bước riêng. Tắc đường khí, giảm chuyển động lồng ngực, tổn thương bề mặt trao đổi và máu mang khí kém tạo hậu quả khác nhau.

Nhịp thở là output controller có giới hạn. Không tăng nhịp vô hạn để bù mọi thiếu hụt.

## 24. Trao đổi khí

Khí đi môi trường → đường khí → compartment trao đổi → máu → mô và ngược lại. Gradient, area, permeability, flow và carrier quyết định rate.

Phòng kín, khói, độ cao hoặc thuật thay khí tác động từ môi trường thật. Người chưa cảm nhận được không tự biết thành phần khí.

## 25. Dinh dưỡng và tiêu hóa

Thức ăn là parcel vào lòng tiêu hóa, rồi được xử lý cơ học/hóa học, hấp thu, chuyển hóa, dự trữ hoặc thải. Khối lượng và thành phần được bảo toàn qua K4.1.

Cảm giác no, đói và năng lượng khả dụng có độ trễ, không chỉ phụ thuộc dạ dày rỗng hoặc một thanh calories.

## 26. Gan và chuyển hóa chất

Đề xuất một organ-process layer cho biến đổi, lưu trữ, khử/hoạt hóa chất và tạo sản phẩm. Capacity hữu hạn; nhiều substrate có thể cạnh tranh.

Thuốc hoặc độc không biến mất theo half-life toàn thân nếu đường vào, phân bố và cơ quan xử lý đang hỏng. Model cụ thể cần nguồn/calibration sau.

## 27. Thận, dịch và bài tiết

Lọc, tái hấp thu, bài tiết và điều hòa volume/composition là các process. Nước vào không lập tức thành nước tiểu; mất chức năng tạo tích lũy theo thời gian.

Vật thải có đích và vị trí. Không xóa chất khỏi organism mà không tạo BoundaryFlow ra môi trường hoặc sink có LawRef.

## 28. Nhiệt và điều nhiệt

K4.1 giải nhiệt truyền; K4.2 giải sinh nhiệt, tưới máu da, mồ hôi, run và thay đổi hành vi. Controller dùng reserve nước/năng lượng và có giới hạn.

Nhiệt cục bộ gây tổn thương mô; thân nhiệt trung tâm ảnh hưởng enzyme/controller/chức năng theo model. Không tính bỏng hai lần qua “nóng” và injury độc lập.

## 29. Nội tiết và tín hiệu hóa học

Hormone/signal có nguồn, carrier, receptor, delay, decay và feedback. Không cần mô phỏng từng phân tử; dùng concentration/pulse theo compartment.

Stress, tăng trưởng, sinh sản, chuyển hóa và tu luyện có thể dùng signal network. “Buff” dài hạn phải trỏ tới signal, structure hoặc learned control thật.

## 30. Hệ thần kinh

Tách:

- central processing structures;
- peripheral paths;
- sensory afferents;
- motor efferents;
- autonomic control;
- local reflex arcs.

Đứt đường dẫn tạo mất/biến đổi chức năng theo topology. Không giảm trí tuệ chỉ vì mọi damage đầu cùng một nhãn.

## 31. Cảm giác

Receptor biến kích thích cục bộ thành neural signal; signal đi qua path rồi mới tạo Observation/Experience. Mất receptor, đường dẫn hoặc xử lý trung tâm tạo kiểu thiếu nhận biết khác nhau.

Linh giác dùng channel riêng nhưng vẫn cần sensor, đường truyền, attention và interpretation.

## 32. Điều khiển vận động

Hành động cần command, đường thần kinh, cơ có supply, khớp/cấu trúc và feedback. `MotorCapability` suy ra theo chuỗi yếu cần thiết, phối hợp và tư thế.

Sức cơ còn không bảo đảm thao tác tinh nếu mất cảm giác hoặc điều khiển. Một chi bị đau vẫn có thể dùng nếu policy cho phép và cấu trúc còn đủ.

## 33. Ý thức

`ConsciousnessState` là projection từ arousal network, supply, nhiệt, độc/chất, giấc ngủ, tổn thương và linh hồn nếu thế giới xác nhận. Nó có nhiều mức và chất lượng, không chỉ bật/tắt.

Mất ý thức chặn quyết định/hành động cần chủ ý từ đúng mốc; process tự động hoặc vật đã phóng có thể tiếp tục.

## 34. Chú ý và nhận thức bị suy giảm

Đau, thiếu ngủ, thiếu cung, sợ hãi, độc, quá tải linh và nhiều tác vụ cạnh tranh capacity chú ý. Tác động lên cognition qua signal/appraisal, không sửa Belief tùy tiện.

Một nhân vật có thể không nhận ra sự suy giảm của chính mình; self-assessment cũng là observation có sai số.

## 35. Ngủ và nhịp sinh học

Ngủ có drive, cơ hội, môi trường, pha rút gọn, gián đoạn và chất lượng. Nhịp sinh học có phase và entrainment; không reset lúc 00:00.

Thiếu ngủ tạo debt, đổi attention/recovery/metabolism theo thời gian. Ngủ bù có giới hạn và không tự chữa mọi thương tích.

## 36. Mệt và gắng sức

Tách mệt ngoại biên, mệt trung tâm, thiếu nhiên liệu, nhiệt, đau, thiếu cung và động lực. `ExertionState` tích lũy theo muscle groups/system demand và phục hồi theo điều kiện.

View có thể gộp thành “mệt”, nhưng resolver hành động dùng nguyên nhân thực để biết nghỉ, ăn, thở hoặc điều trị có hiệu quả gì.

## 37. Đau

Đau gồm nguồn kích thích/tổn thương, receptor/path, modulation, attention, memory và appraisal. Giảm đau có thể giảm Experience/ảnh hưởng chú ý nhưng không phục hồi mô.

Mất cảm giác đau không làm vết thương nhẹ đi; nó có thể khiến nhân vật tiếp tục tải và gây hại thêm.

## 38. Da và hàng rào

Da có lớp, coverage, barrier, sensation, thermal/water exchange và repair. Vết hở đổi permeability, contamination access, fluid loss và pain signal.

Quần áo/giáp là lớp ngoài từ vật phẩm; không trở thành da. Contact resolver đi qua từng lớp theo topology.

## 39. Cơ, gân, dây chằng và khớp

Cơ tạo lực từ activation, cấu trúc, supply và fatigue. Gân truyền lực; dây chằng/bao khớp giữ ổn định; khớp giới hạn motion.

Tổn thương mỗi phần tạo hậu quả khác. “Chân bị thương” là View; đi được bao xa phải suy từ toàn chuỗi.

## 40. Xương và tải cấu trúc

Xương có geometry rút gọn, material state, continuity, load path và remodeling. Gãy có vị trí, kiểu, displacement, stability và damage mô kèm.

Nẹp đổi ràng buộc/load, không hàn xương tức thì. Cố dùng phần gãy có thể tăng displacement và secondary injury.

## 41. Thương tích sơ cấp

`InjuryProcess` bắt đầu từ interaction đã commit và tạo tissue deltas theo cơ chế:

- cắt/rách;
- đâm/xuyên;
- cùn/nghiền;
- kéo/xoắn;
- nhiệt/lạnh;
- điện/bức xạ;
- hóa chất/độc;
- linh lực/trường.

Nhãn cơ chế không thay cho vị trí, độ sâu, diện tích, năng lượng và cấu trúc bị ảnh hưởng.

## 42. Đường thương tổn

Một tác động xuyên tạo `InjuryPath` qua các lớp. Mỗi đoạn ghi tissue, transfer, cavity/compartment mở, foreign matter và exit nếu có.

Giáp hoặc xương đổi phần còn lại; không dùng cùng năng lượng đầy đủ cho mọi lớp. Vết vào/ra liên kết một cause chain.

## 43. Tổn thương thứ phát

Sau sơ cấp có thể có:

- chảy máu;
- phù/áp lực;
- thiếu cung;
- viêm;
- nhiễm;
- độc;
- mất nhiệt/dịch;
- tổn thương do tải tiếp;
- bất ổn linh.

Mỗi thứ là process có điều kiện, không phải hậu quả kịch bản tự động cho mọi vết thương.

## 44. Sưng, phù và áp lực kín

Fluid transfer vào compartment kín tăng volume/pressure, chèn flow hoặc thần kinh theo compliance. Quan sát ngoài có thể không thấy severity thật.

Giảm sưng không tự sửa mô gốc; mở compartment là procedure có tổn thương và rủi ro riêng.

## 45. Nhiễm bẩn và dị vật

Vết thương lưu carrier, lượng, vị trí, kích thước và chất của dị vật/tác nhân. Rửa, gắp và cắt lọc chuyển vật thật; không đặt cleanliness = 100 bằng một thao tác chung.

Dị vật có thể làm cản sửa chữa, mang tác nhân hoặc gây phản ứng. Không phải mọi hạt đều được cá thể hóa; aggregate theo loại/vùng khi đủ.

## 46. Tác nhân gây bệnh

`PathogenDefinition` có reservoir, đường truyền, điều kiện sống, replication/decay, tissue tropism, damage/evasion và signal signature. `InfectionProcess` gắn với strain/version và host.

Không dùng một xác suất nhiễm duy nhất ngay khi bị thương. Exposure, barrier, dose, môi trường, host response và thời gian quyết định progression.

## 47. Miễn dịch và viêm

Đề xuất mô hình nhiều tầng: barrier, innate response, adaptive memory nếu loài hỗ trợ, inflammation và repair coordination. Response dùng energy/material và có thể gây collateral damage.

“Miễn dịch mạnh” không là miễn nhiễm toàn diện. Memory gắn antigen/strain và có suy giảm/biến đổi theo rule.

## 48. Sốt và đáp ứng toàn thân

Sốt là thay đổi set range điều nhiệt do signal, không chỉ nhiệt từ ngoài. Inflammation toàn thân ảnh hưởng circulation, metabolism, cognition và reserve.

Thuốc hạ sốt đổi controller/signal; không diệt tác nhân nếu không có cơ chế. Hạ nhiệt ngoài đổi heat transfer, có lợi/hại theo state.

## 49. Bệnh không lây

`PathologyDefinition` dùng trigger, susceptibility, state machine/process, affected structures, feedback, signs, complications và resolution. Bao gồm thoái hóa, rối loạn chuyển hóa, tự miễn, u/dị sinh hoặc bệnh linh nếu nội dung cần.

Bệnh có thể tồn tại trước khi có triệu chứng và tiến triển khác nhau theo cá thể. Không sinh ngẫu nhiên chỉ để tạo drama mà thiếu provenance.

## 50. Độc và dược động học

Chất đi qua absorption, distribution, transformation và elimination. Effect phụ thuộc concentration/time tại target, receptor/coupling và host state.

Liều dùng là lượng thật. Nhiều liều chồng theo lượng còn lại; save/load không reset. Thuốc và độc có thể cùng substance, khác liều/đường vào/bối cảnh.

## 51. Tương tác thuốc

Interaction có thể xảy ra ở hấp thu, carrier, enzyme/process, receptor hoặc bài tiết. Không cần bảng cặp O(n²) cho mọi thuốc nếu dùng tag/mechanism graph.

Tác dụng và tác dụng phụ đều qua cùng rule; “thuốc quý” không miễn hậu quả trừ khi Definition thực sự khác.

## 52. Triệu chứng và dấu hiệu

State thật sinh `ClinicalSignal`: đau, ho, màu, mùi, nhiệt, mạch, hành vi, xét nghiệm hoặc linh cảm. Symptom là trải nghiệm chủ quan; sign là observation của người khác/công cụ.

Không gắn tên bệnh thẳng vào UI nếu nhân vật chưa suy luận/chẩn đoán. Hai bệnh có thể cho dấu hiệu giống nhau.

## 53. Chẩn đoán

Chẩn đoán là Inference dựa trên history, observations, test reliability và kiến thức người khám. Nó tạo Belief với confidence/differential, không sửa PathologyState.

Khám, xét nghiệm, bắt mạch hoặc linh thức là hành động có thời gian, dụng cụ, quyền, rủi ro và giới hạn phát hiện.

## 54. Điều trị như kế hoạch hành động

`TreatmentPlan` gồm mục tiêu, indication belief, prerequisites, steps, operator capability, materials, timing, monitoring, stop rules và contingencies. Thực hiện tạo procedure processes và transfers thật.

Chọn sai do chẩn đoán sai vẫn có hậu quả hợp quy luật; engine không bí mật sửa kết quả cho đúng bệnh.

## 55. Sơ cứu

Ưu tiên theo mối đe dọa và khả năng biết được: an toàn hiện trường, đường khí, hô hấp, tuần hoàn/chảy máu, bảo vệ cấu trúc và vận chuyển. Đây là workflow gameplay đề xuất, không phải hướng dẫn y tế ngoài đời.

Băng, ép, nẹp, giữ ấm và tư thế đổi state/process cụ thể; hiệu quả phụ thuộc thao tác, vật và thời gian.

## 56. Phẫu thuật và thủ thuật

Procedure có approach path, exposure, thao tác mô, hemostasis, contamination control, repair/closure và aftercare. Mỗi bước có thể thất bại, ngắt hoặc tạo tổn thương mới.

Không cần mô phỏng mọi động tác tay trong bản đầu; nhưng vật tư, cấu trúc đích, thời gian và outcome phải có trace.

## 57. Thuốc, dược liệu và luyện đan

Vật phẩm mang composition/potency/stability/contamination. Bào chế đổi khả năng giải phóng và đường dùng. Người dùng thuốc cần dose, route, interval và adherence.

Đan dược tu tiên có thể chứa spiritual coupling nhưng vẫn đi qua carrier, target và LawRef. Không tự chữa mọi mô bằng phẩm cấp.

## 58. Truyền dịch, truyền máu và cấp nguồn

Transfer vào compartment cần access, compatibility, rate, sterility và monitoring. Tốc độ quá nhanh/chậm có hậu quả theo controller và capacity.

Linh lực truyền giữa người cũng cần interface, affinity, route, quyền và nguy cơ; không chỉ trừ người A cộng người B.

## 59. Hồi phục mô

Repair có pha rút gọn: cầm/ổn định, viêm/dọn, tăng sinh, tái cấu trúc. Mỗi pha cần supply, structure, nhiệt, nghỉ, signal và kiểm soát tác nhân.

Process tiến theo breakpoint. Thiếu điều kiện có thể chậm/dừng/chuyển outcome; phần đã sửa không mất chỉ vì một ngày ăn thiếu.

## 60. Sẹo, dính và di chứng

Sửa chữa không luôn trả về blueprint. Scar/fibrosis đổi mechanical, transport, sensation hoặc spiritual conductance. Dính tạo edge/ràng buộc mới.

Di chứng có thể thích nghi bằng học và thay đổi hành động. Không cộng thêm phạt chung nếu capability đã suy từ cấu trúc mới.

## 61. Tái tạo

Khả năng tái tạo khai theo tissue/loài/cảnh giới và cần material, energy, pattern source, control, thời gian và error risk. Tái tạo phần mất không xóa record amputated; tạo structure mới có provenance.

Tái tạo tu tiên phải định giới hạn identity và thần kinh/ký ức. Không tự mọc lại mọi thứ vì có linh lực.

## 62. Phục hồi chức năng

Rehabilitation là chuỗi hoạt động tạo remodeling, motor learning, tolerance và compensation. Nó có tải tối ưu; quá ít không kích thích, quá nhiều có thể tái thương.

NPC cần thời gian, động lực, người hướng dẫn và dụng cụ. Không tự hồi toàn bộ kỹ năng sau khi cấu trúc lành.

## 63. Chăm sóc dài hạn

Người bệnh vẫn có ăn, uống, vệ sinh, ngủ, đau, giao tiếp, tài sản và quan hệ. Chăm sóc tạo công việc, lịch, vật tư và burden cho hộ/tổ chức.

Thiếu người chăm có nguyên nhân xã hội thật; không dùng một cờ “đang điều trị” để cung cấp mọi thứ tự động.

## 64. Tuổi và phát triển

`DevelopmentState` điều khiển kích thước, cấu trúc, reserve, hormone, kỹ năng vận động và khả năng sinh sản theo loài/cá thể. Tuổi thời gian không trực tiếp đặt tất cả giá trị.

Trẻ em là Person có identity, quan hệ và nhu cầu riêng; không là cohort nếu đã materialize M2+.

## 65. Lão hóa

Lão hóa gồm tích lũy damage, giảm repair/reserve, remodeling, bệnh và thay đổi điều hòa. Tốc độ phụ thuộc lịch sử, môi trường, di truyền hư cấu và tu luyện.

Không trừ một tỷ lệ đều mỗi năm. Tuổi thọ là distribution/outcome từ state và law, không bộ đếm chết cứng trừ khi loài có quy luật đó.

## 66. Sinh sản và thai kỳ

Thiết kế dài hạn cần conception rule, phát triển, trao đổi mẹ–thai, nguy cơ, sinh, hậu sản và identity mới. Nội dung phải xử lý ở mức phù hợp, tránh mô tả không cần thiết trong UI.

Vật chất/năng lượng của thai đến từ transfer thật; Person identity được tạo theo lifecycle/provenance, không tự xuất hiện khi sinh.

## 67. Di truyền và biến thể

`HeritableProfile` có traits/alleles hoặc rule pack tùy độ sâu, mutation provenance và expression theo development/environment. Không cần sao chép genome thật nếu gameplay không dùng.

Đặc tính tu luyện có thể di truyền chỉ khi luật thế giới khai cơ chế. Quan hệ huyết thống không tự cấp ký ức, công pháp hoặc quyền.

## 68. Tử vong

Death determination dựa trên failure không còn phục hồi của các chức năng thiết yếu theo luật loài/cảnh giới. Tách:

- collapse có thể cứu;
- mất ý thức;
- ngừng chức năng tạm;
- chết được xác nhận;
- hủy cấu trúc/identity theo quy luật đặc biệt.

Ngưỡng và khả năng hồi sinh chưa chốt. Không đổi alive=false chỉ vì HP bằng 0.

## 69. Thi thể và phân hủy

Sau chết, BodyInstance chuyển lifecycle nhưng vật chất, cấu trúc, bệnh, độc, đồ gắn và vị trí vẫn tồn tại. Autolysis, decay, scavenging và bảo quản là processes.

Ký ức/xã hội không bị xóa; tin chết truyền qua observation/message. Nghi lễ và quyền xử lý thuộc văn hóa/thể chế.

## 70. Linh hồn, thần thức và identity

Nếu thế giới có hồn/thần thức, phải tách Person identity, mind state, spiritual structure và body host. Các quan hệ trú, tách, tổn thương, đo lường và chết cần LawRef.

K4.2 chưa xác nhận hồn có thật. Không dùng nó để vá save/load, hồi sinh hoặc ký ức mà thiếu quyết định thiết kế.

## 71. Kinh mạch trong giải phẫu

Kinh mạch là network gắn với vùng/mô, có node/edge, conductance, capacity, integrity, affinity và coupling sinh lý. Nó có thể đi gần mạch/thần kinh nhưng không mặc định trùng.

Tổn thương cơ học có thể ảnh hưởng nếu giao nhau thật; tổn thương linh không tự gây mất máu nếu không có coupling.

## 72. Đan điền và kho linh

Đan điền là structure/compartment đặc biệt với capacity, pressure/potential, stability, composition và control. Dung lượng tăng cần remodeling hoặc biến đổi rule, không chỉ tăng số tối đa.

Vỡ/rò tạo BoundaryFlow tới mô, kinh mạch hoặc môi trường và hậu quả theo coupling. Không đặt P về 0 rồi gọi là đã xử lý.

## 73. Thích nghi tu luyện

Adaptation cần stimulus dose, recovery, material/energy, control quality và history. Các hướng:

- tăng conductance/capacity;
- gia cố mô;
- đổi receptor/coupling;
- tăng reserve/controller;
- tạo cấu trúc mới;
- học điều khiển thần kinh/linh.

Luyện quá mức có thể vượt repair và tạo pathology; luyện ít không tích lũy vô hạn.

## 74. Luyện thể

Luyện thể tác động cơ, xương, mô liên kết, da, cơ quan, chuyển hóa và/hoặc linh cấu trúc tùy công pháp. Mỗi thay đổi cần stimulus và resource ledger.

“Thân thể mạnh gấp đôi” phải phân rã thành capability nào tăng, tải nào chịu được và chi phí nào đổi. Không làm mọi mô cùng mạnh.

## 75. Luyện khí và cơ thể

Luyện khí không tách khỏi cơ thể: hấp thu, lọc, chứa, vận hành và phát đều dùng structures/controller. Hiệu suất tăng có thể làm giảm nhiệt/tạp/tải nhưng cần adaptation/knowledge.

Kho linh đầy không đồng nghĩa mô đủ chịu một thuật có công suất cao.

## 76. Đột phá

`BreakthroughProcess` có preparation, reservation, commitment, transformation, stabilization, verification và recovery. State cần giữ:

- cấu trúc mục tiêu và hiện tại;
- resource/catalyst;
- route/control;
- stress/instability;
- transformed fraction;
- repair demand;
- complications;
- RNG cursor nếu có biến thiên.

Save/load giữa pha không bốc lại outcome.

## 77. Thất bại đột phá

Thất bại không chỉ hai trạng thái chết/sống. Outcome phát sinh từ phần biến đổi và mất ổn định: dừng an toàn, thoái lui, sẹo kinh mạch, rò, biến chất, tổn thương cơ quan, lệch cấu trúc hoặc chết.

Hậu quả giữ provenance và có thể điều trị/thích nghi nếu luật cho phép. Không tự thêm “tẩu hỏa” ngẫu nhiên ngoài state.

## 78. Dị biến và tái cấu trúc

Cultivation transformation có thể đổi AnatomyDefinition overlay của cá thể: cơ quan mới, lớp mô, network mới, giác quan hoặc pha vật chất. Overlay có version, compatibility và migration.

Biến đổi phải xử lý đồ mặc, kích thước, nhu cầu, sinh sản, nhận dạng, y thuật và capability; không chỉ thêm bonus.

## 79. Xung đột công pháp

Hai công pháp có thể xung đột ở route, composition, controller, remodeling target, nhịp hoặc LawRef. Conflict được suy từ graph/rules thay vì danh sách cặp vô hạn.

Kiêm tu cần kế hoạch phân vùng, chuyển hóa hoặc cấu trúc trung gian. Biết hai bản bí kíp không tự làm chúng tương thích.

## 80. Cảnh giới như trạng thái dẫn xuất

Cảnh giới là classification từ structure, capacities, learned control và achievement evidence. Nó hữu ích cho văn hóa/tri thức nhưng không thay thế state cơ thể.

Hai người cùng cảnh giới có giải phẫu, di chứng, reserve và công pháp khác nhau. Nhãn xã hội có thể sai hoặc bị che giấu.

## 81. Body resolution B0–B5

| Mức | Biểu diễn | Dùng cho |
|---|---|---|
| B0 | contact/tissue/path chi tiết | thương tích, thủ thuật, đột phá cục bộ |
| B1 | organ substructure/network | cơ quan trọng yếu, kinh mạch |
| B2 | organ/compartment | sinh lý cá thể đang hoạt động |
| B3 | system/reserve/pathology summary | NPC xa nhưng có identity |
| B4 | daily health trajectory | Person ít liên quan |
| B5 | cohort health rates | dân số chưa cá thể hóa M1 |

B0–B5 là độ phân giải cơ thể, độc lập với M, R và P. Person M2+ không bị biến thành cohort B5.

## 82. Nâng và hạ B

Hạ B giữ organ anchors, injury/pathology, implants, scars, reproductive/development state, medicine/toxin amounts, critical extrema, next breakpoint và error debt. Nâng B phân bổ bằng history/constraints/seed, không tạo cơ thể hoàn hảo.

Một thương tích đã được quan sát không được đổi vị trí/loại khi nâng resolution. Aggregate disease burden không được gán tùy tiện cho một Person đã tồn tại.

## 83. Body capsule cho NPC xa

Capsule tối thiểu:

```text
anatomy/version + development/age
+ organ reserves + active injuries/pathologies
+ medication/toxin + spiritual structures
+ scars/implants + reproductive state
+ next health breakpoints + error bounds
```

Daily solver có thể tính theo hazard/trajectory, nhưng outcome cá thể phải commit vào PersonCore và story provenance.

## 84. Scheduler sinh lý

Không tick mọi biến mỗi giây. Process lập breakpoint tại:

- cạn reserve;
- vượt dose/deficit;
- clot hình thành/bật;
- thuốc đạt/qua ngưỡng;
- pathogen đổi pha;
- ngủ/thức;
- repair chuyển pha;
- controller bão hòa;
- đột phá đổi pha;
- observation/intervention.

Event mới cắt tích phân tại đúng mốc.

## 85. Đồng thời và giao dịch

Tác động cùng mốc giải trên pre-state rồi commit transfer/tissue delta. Sau commit mới chạy derived physiology và trigger. Điều trị hoàn tất đúng mốc không hồi tố chặn thương tích cùng batch nếu quy ước pha không cho.

Hai thủ thuật không cùng tiêu băng/thuốc/máu hoặc cùng sửa một cấu trúc bằng trạng thái cũ.

## 86. Khả năng chức năng

`FunctionProjection` khai task demands và dependency graph. Nhóm chính:

- giữ tư thế/di chuyển;
- lực và thao tác tinh;
- hô hấp/gắng sức;
- nhìn/nghe/cảm giác;
- nói/nuốt/ăn;
- chú ý/ý thức;
- chịu môi trường;
- vận hành linh lực.

Kết quả có capacity, sustainability, pain/risk và confidence; không chỉ phần trăm.

## 87. Giao với hành động và công việc

Planner hỏi capability cho action profile cụ thể. Một người có thể đi chậm nhưng không chạy, nâng nhẹ nhưng không vung búa, nói nhưng không nuốt an toàn.

Thay đổi giữa việc tạo wakeup/replan. Tiến độ trước mốc giữ; không hồi tố hoặc tiếp tục bằng capacity cũ.

## 88. Giao với tâm lý và NPC

Body phát signal về đau, đói, khó thở, chóng mặt, khoái cảm, mệt và linh cảm. Tâm lý/appraisal quyết định ý nghĩa và hành vi; body không tự đặt Goal ngoài reflex/autonomic contract.

NPC có thể che giấu, hiểu sai, chịu đựng hoặc tìm giúp đỡ theo tính cách/tri thức. Bệnh không ép cùng một hành vi cho mọi người.

## 89. Giao với chiến đấu

K4.1 giao InjuryPath/transfer; K4.2 commit tissue/pathology/function. Combat nhận capability và signals để replan. Cái chết, bất tỉnh, làm rơi vật hoặc ngã xảy ra từ đúng mốc điều kiện.

Một đòn không nhận “damage bonus” riêng rồi lại tăng tissue transfer trừ khi hai kênh khác nhau được ledger rõ.

## 90. Giao với sinh kế và xã hội

Sức khỏe ảnh hưởng năng suất, lịch, chi phí, chăm sóc, phụ thuộc và quan hệ. Chấn thương/bệnh có privacy; tổ chức chỉ biết qua chứng kiến, báo cáo hoặc kiểm tra.

Nghỉ bệnh, trách nhiệm chữa, bồi thường và kỳ thị là luật xã hội, không thuộc pathology truth.

## 91. UI text nhiều tầng

| Tầng | Nội dung |
|---|---|
| nhanh | nguy cơ và việc cần quyết định theo hiểu biết |
| chức năng | việc nào bị hạn chế và vì sao gần nhất |
| cơ thể | vùng/cơ quan/dòng/process đã biết |
| lịch sử | diễn tiến, can thiệp và nguồn quan sát |
| chuyên môn | differential, phép đo và uncertainty nếu nhân vật hiểu |

Điện thoại ưu tiên thẻ ngắn có mở rộng; desktop có bảng so sánh nhưng không lộ state ngoài tri thức.

## 92. Lưu, tải và replay

Save giữ anatomy/version, part IDs, compartments/composition, networks, tissue states, active processes, controllers/reserves, injuries/pathologies, treatment plans, development, spiritual overlays, RNG cursors và cause anchors.

Derived capability/UI cache không canonical. Tải giữa chảy máu, thuốc, ngủ, hồi phục hoặc đột phá không lặp transfer/phase transition.

## 93. Hiệu năng đa nền tảng

Chiến lược:

- materialize field chỉ nơi cần;
- body graph bất biến chia sẻ theo Definition;
- state sparse theo khác biệt cá thể;
- event/breakpoint thay polling;
- cache capability theo revision;
- B0–B5 thích nghi;
- batch trajectory cho Person xa nhưng giữ outcome riêng;
- chỉ pin cơ thể có interaction/hazard/process quan trọng.

Điện thoại và máy tính phải cùng semantic fingerprint; máy chậm được giảm độ mượt View hoặc chậm wall-clock.

## 94. Artifact dữ liệu

Các loại cần schema:

- AnatomyDefinition;
- Tissue/Organ/SystemDefinition;
- BodyInstance/BodyPart;
- Compartment/TransportNetwork;
- HomeostaticController;
- Injury/Pathology/PathogenDefinition;
- Drug/Treatment/ProcedureDefinition;
- Development/Aging/ReproductionDefinition;
- SpiritualAnatomy/CultivationTransformation;
- BodyResolutionModel;
- FunctionProfile;
- fixture và oracle.

Mọi Definition có version, SourceRef, validity range và migration policy.

## 95. Bất biến

1. Phần cơ thể có identity/vị trí duy nhất.
2. Vật chất/dược/độc/máu qua transfer được bảo toàn.
3. Không compartment âm hoặc quá capacity ngoài failure rule.
4. Network leak/occlusion ảnh hưởng flow từ đúng mốc.
5. Injury không đồng thời là HP damage thứ hai.
6. Status không tick trùng process.
7. Function là dẫn xuất có dependency revision.
8. Observation không chứa chẩn đoán toàn tri.
9. Điều trị dùng vật/thời gian/quyền thật.
10. Hạ/nâng B giữ pathology, scar và critical anchor.
11. Save/load giữ process/RNG/transfer exactly-once.
12. Mobile/desktop giữ outcome logic.
13. Person M2+ không mất body history khi ra xa.
14. Tu luyện không tạo vật/năng lượng ngoài CouplingRule/LawRef.

## 96. Các lỗi phải chống

- băng bó làm biến mất máu đã mất;
- uống thuốc lặp bằng tải game;
- ghép/tách bộ phận reset injury;
- đổi B xóa bệnh hoặc sẹo;
- ngủ qua ngày hồi mọi reserve;
- giảm đau chữa cấu trúc;
- ăn lập tức thành năng lượng toàn thân;
- cơ quan hỏng nhưng cache chức năng chưa đổi;
- hai treatment dùng cùng vật tư;
- đột phá reset bằng thoát game;
- nâng cảnh giới chữa mọi bệnh không có rule;
- người chết vùng xa sống lại khi materialize;
- cohort disease gán lại cho NPC đã có lịch sử;
- cùng tác động bị tính ở K4.1, combat và body ba lần.

## 97. Fixture K4.2 đề xuất

| Fixture | Nội dung | Mục tiêu |
|---|---|---|
| K4B-F01 | chi đơn giản da–cơ–xương–mạch–thần kinh | topology/function |
| K4B-F02 | vết cắt một mạch | leak/clot/băng |
| K4B-F03 | chảy máu kín | pressure/hidden sign |
| K4B-F04 | đường khí tắc một phần | ventilation/controller |
| K4B-F05 | mất nước khi lao động nóng | homeostasis/reserve |
| K4B-F06 | thuốc ba liều | distribution/stack/elimination |
| K4B-F07 | vết bẩn và nhiễm | exposure–infection–immune |
| K4B-F08 | gãy xương có nẹp | structure/repair/rehab |
| K4B-F09 | thiếu ngủ ba ngày | sleep debt/cognition |
| K4B-F10 | người già có reserve thấp | variation/compensation |
| K4B-F11 | TL-A qua kinh mạch mẫu | spiritual flow/body coupling |
| K4B-F12 | TM-01 bị ngắt | breakthrough persistence |
| K4B-F13 | cùng người ở B0–B4 | resolution parity |
| K4B-F14 | save giữa điều trị | exactly-once/replay |

Đây là fixture trên giấy, chưa có artifact máy.

## 98. Điều kiện CT01–CT96

### 98.1. Giải phẫu và identity

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT01 | tạo hai cá thể cùng blueprint | part IDs và biến thể riêng, ổn định qua tải |
| CT02 | tay trái bị thương | không tự áp lên tay phải/chân |
| CT03 | cắt bỏ một phần | phần tách thành vật có provenance |
| CT04 | ghép lại | giữ lịch sử nguồn–đích, không reset state |
| CT05 | cấu trúc thừa/thiếu bẩm sinh | topology cá thể hợp lệ |
| CT06 | contact ngoài coverage | không xuyên vào vùng sai |
| CT07 | vật đi qua InjuryPath | transfer giảm qua từng lớp |
| CT08 | field unknown ở tissue | không hiểu thành 0/khỏe mạnh |

### 98.2. Compartment, flow và nội môi

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT09 | uống nước | đi qua tiêu hóa/hấp thu, không vào máu tức thì |
| CT10 | leak mạch | lượng máu giảm và parcel ngoài tăng |
| CT11 | flow bị tắc | delivery downstream đổi từ đúng mốc |
| CT12 | hai mô tranh supply | phân bổ theo rule, không nhân dòng |
| CT13 | controller còn reserve | bù trừ có chi phí và giới hạn |
| CT14 | reserve cạn | chức năng đổi ở breakpoint |
| CT15 | fluid ra khỏi cơ thể | có BoundaryFlow/đích thật |
| CT16 | save giữa flow | không chuyển lặp hoặc mất lượng |

### 98.3. Tuần hoàn và hô hấp

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT17 | mất máu chậm và nhanh cùng lượng | trajectory/hậu quả có thể khác |
| CT18 | băng ép vết chảy | rate đổi, máu mất không quay lại |
| CT19 | clot hình thành | dùng process/nguyên liệu và có integrity |
| CT20 | clot bật | leak trở lại từ state hiện hành |
| CT21 | chảy máu kín | khó quan sát, pressure có thể tăng |
| CT22 | tắc đường khí | ventilation giảm dù máu ban đầu đủ |
| CT23 | phòng thiếu khí | chuỗi môi trường→phổi→máu→mô đúng |
| CT24 | phục hồi flow | không tự xóa supply deficit/damage đã tích lũy |

### 98.4. Chuyển hóa, nhiệt và bài tiết

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT25 | ăn bữa lớn | no/absorption/energy có độ trễ |
| CT26 | lao động khi đói | dùng reserve và đổi capability theo state |
| CT27 | cơ quan xử lý chất suy | clearance đổi theo capacity thật |
| CT28 | mất chức năng bài tiết | chất tích lũy qua thời gian |
| CT29 | nóng môi trường | heat transfer và controller nối đúng |
| CT30 | đổ mồ hôi | mất nước/chất và tốn reserve |
| CT31 | sốt | set range đổi, không đồng nhất với nung nóng ngoài |
| CT32 | ngủ qua mốc ngày | không reset chuyển hóa/nhiệt/reserve |

### 98.5. Thần kinh, ý thức và chức năng

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT33 | đứt nerve vận động | cơ còn nhưng command không tới |
| CT34 | mất cảm giác | không nhận signal dù mô vẫn tổn thương |
| CT35 | giảm đau | pain/attention đổi, integrity không đổi |
| CT36 | mất ý thức giữa hành động | action chủ ý ngắt từ đúng mốc |
| CT37 | vật đã phóng trước bất tỉnh | tiếp tục theo Definition |
| CT38 | thiếu ngủ | attention/reaction đổi theo debt |
| CT39 | cùng injury, hai appraisal | hành vi khác nhưng body truth giống |
| CT40 | mở UI cơ thể | không đổi state/RNG |

### 98.6. Thương tích và bệnh lý

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT41 | đòn cùn qua giáp | K4.1 transfer rồi K4.2 tissue delta một lần |
| CT42 | vết xuyên nhiều lớp | một InjuryPath và cause chain |
| CT43 | phù trong khoang kín | pressure chèn đúng cấu trúc |
| CT44 | rửa vết bẩn | tác nhân chuyển sang carrier/đích |
| CT45 | exposure nhỏ bị barrier chặn | không tự thành infection |
| CT46 | pathogen sinh sản | cần tissue/resource/condition |
| CT47 | immune response | tiêu resource và có collateral effect nếu rule |
| CT48 | bệnh chưa triệu chứng | pathology tồn tại, NPC chưa tự biết |

### 98.7. Thuốc, chẩn đoán và điều trị

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT49 | ba liều thuốc | lượng còn chồng theo time/course |
| CT50 | tải lại trước tác dụng | không nhận liều/tác dụng lần hai |
| CT51 | hai chất cạnh tranh xử lý | rate theo mechanism/capacity |
| CT52 | test âm tính giả | Belief có thể sai, pathology không đổi |
| CT53 | người thiếu kiến thức khám | không nhận chẩn đoán toàn tri |
| CT54 | điều trị sai bệnh | hậu quả theo procedure/drug thật |
| CT55 | hai người dùng cùng băng | transaction chỉ cấp cho một allocation |
| CT56 | thủ thuật bị ngắt | giữ bước/tổn thương/vật đã dùng |

### 98.8. Hồi phục và di chứng

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT57 | repair đủ điều kiện | chuyển pha đúng thời gian/resource |
| CT58 | thiếu supply nửa ngày | chậm/dừng, không xóa tiến độ cũ tùy rule |
| CT59 | nhiễm trong repair | outcome/process đổi có cause |
| CT60 | nẹp xương | stability đổi, không liền tức thì |
| CT61 | tháo nẹp sớm | load path và nguy cơ đổi |
| CT62 | sẹo hình thành | cấu trúc/capability mới bền vững |
| CT63 | phục hồi chức năng | motor learning/tolerance tăng theo hoạt động |
| CT64 | tái tạo phần mất | cần vật/năng lượng/pattern và provenance |

### 98.9. Tuổi, sinh sản và tử vong

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT65 | cá thể lớn lên | anatomy overlay/state đổi theo development |
| CT66 | hai người cùng tuổi | reserve không bắt buộc giống nhau |
| CT67 | lão hóa vùng xa | trajectory ghi vào Person, không reset khi gần |
| CT68 | thai phát triển | vật/năng lượng từ transfer thật |
| CT69 | sinh Person mới | identity/provenance tạo đúng lifecycle |
| CT70 | trait di truyền | theo rule, không sao chép toàn bộ cha/mẹ |
| CT71 | collapse còn cứu được | không gắn chết quá sớm |
| CT72 | chết xác nhận | body chuyển lifecycle, vật chất còn tồn tại |

### 98.10. Tu luyện hóa cơ thể

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT73 | hấp thu linh lực | nguồn giảm, compartment tăng đúng coupling |
| CT74 | kinh mạch tắc | route/capability đổi theo topology |
| CT75 | đan điền rò | linh lượng có đích và hậu quả |
| CT76 | luyện quá capacity | overload thành process, không xóa phần dư |
| CT77 | stimulus có hồi phục | adaptation dùng resource/history |
| CT78 | luyện thể một vùng | không tăng mọi mô toàn thân |
| CT79 | hai công pháp xung đột route | phát hiện qua graph/rule |
| CT80 | cảnh giới giống, cơ thể khác | capability/outcome vẫn khác |
| CT81 | TM-01 hoàn tất | structure/resource ledger khớp |
| CT82 | TM-01 ngắt sau cam kết | giữ transformed fraction/instability |
| CT83 | save giữa đột phá | RNG/process không bốc lại |
| CT84 | dị biến thêm cơ quan | anatomy, đồ, nhu cầu và function cập nhật |

### 98.11. Phân tầng và NPC xa

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT85 | B0 và B3 cùng vết thương | outcome trong error contract |
| CT86 | hạ B khi đang chảy máu | giữ leak/next breakpoint |
| CT87 | hạ B có hotspot bệnh | giữ pathology anchor |
| CT88 | nâng B NPC đã có sẹo | không tạo cơ thể nguyên vẹn |
| CT89 | đổi B lặp lại | không drift reserve/lượng/damage |
| CT90 | Person M2+ ra xa | body history và identity giữ |
| CT91 | cohort có dịch bệnh | không gán hồi tố tùy tiện cho Person cũ |
| CT92 | NPC chết vùng xa | commit death/story/property consequences |

### 98.12. Lưu tải, parity và tích hợp

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| CT93 | save giữa clot/repair/drug | tiếp tục đúng phase và lượng |
| CT94 | crash giữa treatment transaction | recovery không nhân vật tư/transfer |
| CT95 | import mobile sang desktop | anatomy/process/fingerprint giữ |
| CT96 | 30 ngày NPC sinh hoạt và bệnh | event budget đạt mà không đổi semantic outcome |

CT01–CT96 đều là điều kiện thiết kế chưa mã hóa và chưa chạy. Tổng hồ sơ tăng từ 1.188 lên 1.284 điều kiện thuộc 35 họ.

## 99. Cổng K4.2

| Cổng | Đạt khi | Hiện tại |
|---|---|---|
| K4B01 | hierarchy/topology/identity rõ | đạt trên giấy |
| K4B02 | compartment/flow/homeostasis rõ | đạt trên giấy |
| K4B03 | injury–pathology–function không tính trùng | đạt trên giấy |
| K4B04 | điều trị và hồi phục dùng resource/process | đạt trên giấy |
| K4B05 | spiritual anatomy/cultivation boundary rõ | đạt trên giấy |
| K4B06 | B0–B5 và NPC xa rõ | đạt trên giấy |
| K4B07 | schema/artifact máy tồn tại | chưa |
| K4B08 | K4B-F01–F14 mã hóa | chưa |
| K4B09 | CT01–CT96 chạy có evidence | chưa |
| K4B10 | thông số y sinh/tu luyện được hiệu chỉnh | chưa |

## 100. Vấn đề mở

1. Độ sâu giải phẫu mặc định cho người và sinh vật khác?
2. Cơ quan nào thiết yếu ở chặng đầu?
3. Mô hình máu/khí/dịch cần bao nhiêu thành phần?
4. Có mô phỏng nhóm máu và tương thích chi tiết không?
5. Tác nhân bệnh cần tiến hóa/đột biến tới đâu?
6. Mức phức tạp thuốc và tương tác?
7. Thai kỳ/sinh sản hiển thị ở mức nào?
8. Quy tắc xác nhận chết, cứu sống và hồi sinh?
9. Linh hồn có tồn tại độc lập cơ thể không?
10. Kinh mạch là cấu trúc sinh học, linh cấu trúc hay hybrid?
11. Tu luyện tăng tuổi thọ bằng repair, chậm lão hóa hay đổi LawRef?
12. Cảnh giới có tiêu chuẩn khách quan hay phân loại xã hội?
13. Mức tái tạo chi/cơ quan tối đa?
14. Đau và nội dung y sinh cần tùy chọn giảm chi tiết nào?
15. Nguồn khoa học và chuyên gia nào dùng khi hiệu chỉnh?
16. K4.3 ưu tiên vật liệu–vật phẩm–chế tác hay sinh thái sâu?

Các mục này chưa được tự quyết định.

## 101. Rủi ro và kiểm soát

| Rủi ro | Hậu quả | Kiểm soát đề xuất |
|---|---|---|
| từng tế bào thành entity | không thể chạy | cohort/field/compartment |
| một HP ẩn dưới tên khác | mất chiều sâu | tissue–flow–process–function chain |
| tính trùng hậu quả | chết quá nhanh/sai | ownership và cause chain |
| giả y khoa | gây hiểu lầm | provenance, calibration, ghi rõ hư cấu |
| bệnh tạo drama tùy tiện | NPC thiếu lịch sử thật | exposure/susceptibility/provenance |
| cơ thể xa được reset | câu chuyện đứt | BodyCapsule và anchors |
| tu luyện chữa miễn phí | phá sinh tồn | resource/coupling/repair law |
| quá tải mobile | không đạt nhịp | B0–B5, breakpoint, sparse state |
| UI quá ghê hoặc quá dày | khó tiếp cận | projection/tùy chọn mức mô tả |
| lưu giữa process sai | exploit | exactly-once phase/RNG/transfer |

## 102. Trình tự hiện thực hóa khi được yêu cầu

1. AnatomyDefinition/BodyInstance/part identity.
2. Compartment/transport/homeostasis kernel.
3. F01–F05: chi, chảy máu, hô hấp, nhiệt/dịch.
4. InjuryPath, clot, function projection.
5. Drug/pathogen/pathology processes.
6. Treatment/repair/scar/rehabilitation.
7. Development/aging/death lifecycle.
8. Spiritual anatomy và TM-01.
9. B0–B5, BodyCapsule và vùng xa.
10. save/replay/mobile-desktop parity.
11. mã hóa CT01–CT96 và chạy evidence.

Đây là thứ tự tương lai, chưa phải triển khai đã hoàn thành.

## 103. Những điều không được tuyên bố

- Không nói đã mô phỏng cơ thể hoặc y học chính xác.
- Không nói đã chốt mức bạo lực, đau hoặc chi tiết hiển thị.
- Không nói linh hồn, kinh mạch hay cảnh giới đã được xác nhận.
- Không nói thuốc, bệnh hoặc thủ thuật có thể dùng ngoài đời.
- Không nói B0–B5 đã đạt parity.
- Không nói CT01–CT96 đã mã hóa/chạy.
- Không nói 1.284 điều kiện là test tự động.
- Không nói game đã chạy trên điện thoại/máy tính.

## 104. Giá trị K4.2 cung cấp thật

- cơ thể có topology và lịch sử riêng tới từng cá thể;
- nội môi từ compartment, flow, controller và reserve;
- thương tích lan thành hậu quả thứ phát mà không cần HP;
- bệnh, độc, thuốc, chẩn đoán và điều trị có nguồn nhân quả;
- hồi phục để lại sẹo, di chứng và nhu cầu chăm sóc;
- tu luyện làm thay đổi cấu trúc thật thay vì cộng chỉ số;
- B0–B5 giữ NPC xa nhẹ nhưng không xóa câu chuyện;
- 14 fixture và 96 điều kiện có thể mã hóa sau.

## 105. Bước tiếp theo

K4.3 đã định vật phẩm/chế tác; K4.4 nay đã định môi trường tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
