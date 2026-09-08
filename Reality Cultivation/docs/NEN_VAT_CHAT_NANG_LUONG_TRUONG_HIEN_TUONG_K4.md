---
title: "K4.1 — Nền vật chất, năng lượng, trường và hiện tượng"
aliases:
  - "Nền hiện tượng K4"
  - "Vật chất và linh lực K4"
tags:
  - reality-cultivation
  - ke-hoach
  - k4
  - mo-phong
status: de-xuat
updated: 2026-09-06
---

# K4.1 — Nền vật chất, năng lượng, trường và hiện tượng

> [!summary]
> Tài liệu này đề xuất ngôn ngữ nhân quả chung cho vật chất thường, năng lượng, trường và linh lực. Nó nối [[VAT_PHAM]], [[CO_THE]], [[MOI_TRUONG]], [[CHIEN_DAU]] và [[TU_LUYEN]] với các hợp đồng K2–K3. Đây là thiết kế chưa triển khai; các đại lượng, hệ số và quy luật tu tiên chưa được người dùng duyệt.

## 1. Mục tiêu

Mọi hậu quả phải đi qua một chuỗi có thể giải thích:

```text
nguồn → truyền qua môi trường/cấu trúc → tương tác → biến đổi trạng thái
      → hậu quả chức năng → quan sát → nhận thức → quyết định
```

Một thanh kiếm nóng làm bỏng vì nhiệt truyền vào mô. Một thuật hộ thể chặn đòn vì trường của nó đổi đường truyền hoặc hấp thu tác động và tiêu nguồn. Một linh địa giúp tu luyện vì có nguồn, gradient, đường thu nhận và giới hạn dung nạp. Không hệ nào được bỏ qua chuỗi này chỉ bằng nhãn “mạnh hơn”.

## 2. Phạm vi K4.1

Bao gồm:

- vật chất, chất, hỗn hợp, pha và cấu trúc;
- đại lượng, đơn vị, miền hợp lệ và độ chính xác;
- năng lượng thường và linh năng;
- trường, dòng, gradient và tương tác;
- cơ học, nhiệt, chất lưu, khuếch tán, phản ứng và tín hiệu;
- hiện tượng thường–linh giao nhau;
- cách phân giải từ cục bộ chi tiết tới vùng xa;
- hợp đồng dữ liệu, tác vụ, lưu tải và kiểm chứng.

Không nhằm mô phỏng mọi phương trình vật lý ngoài đời. Mục tiêu là nhất quán nhân quả, mở rộng được và đủ sâu để không phải dùng ngoại lệ tùy tiện cho từng hệ gameplay.

## 3. Nguyên tắc nền

1. Trạng thái thật chỉ có một chủ quản theo [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]].
2. Đại lượng có đơn vị và miền; không cộng các loại không tương thích.
3. Biến đổi phải khai nguồn, đích, tổn hao và phần dư.
4. Không tính cùng một tác động hai lần ở nhiều hệ.
5. Trạng thái liên tục có thể xấp xỉ, nhưng bất biến và hậu quả quan trọng phải giữ.
6. Chi tiết được mở rộng theo nhu cầu; kết quả cũ không bị viết lại khi vùng được materialize.
7. Nhân vật chỉ biết qua phép đo và quan sát, không đọc trực tiếp trạng thái thật.
8. Mobile và desktop dùng cùng quy luật, seed và quy ước làm tròn.

## 4. Bốn lớp mô hình

| Lớp | Câu hỏi | Ví dụ |
|---|---|---|
| thực thể | cái gì tồn tại | lô sắt, mô cơ, khối khí, linh thạch |
| trạng thái | hiện tại nó thế nào | nhiệt độ, ứng suất, nồng độ, điện tích, linh dung |
| quan hệ/trường | nó nối và ảnh hưởng gì | tiếp xúc, liên kết, gradient nhiệt, linh trường |
| quá trình | trạng thái đổi bằng cách nào | dẫn nhiệt, cháy, nứt, khuếch tán, hấp thu linh khí |

Hiện tượng là kết quả của trạng thái và quá trình, không phải cờ tự do tồn tại ngoài vật mang hoặc vùng không gian.

## 5. Đại lượng cơ sở và dẫn xuất

Đề xuất registry đại lượng gồm `QuantityKind`, dimension, đơn vị chuẩn, miền, độ phân giải, quy tắc làm tròn và cách cộng gộp.

Nhóm cơ sở tối thiểu: thời gian, độ dài, khối lượng, lượng chất, nhiệt độ, điện tích thường và lượng linh năng theo từng loại được xác nhận sau. Diện tích, thể tích, vận tốc, gia tốc, lực, áp suất, mật độ, công suất, nồng độ và thông lượng là đại lượng dẫn xuất.

Không dùng một số `power` chung cho độ cứng, nhiệt, sức công phá và cảnh giới.

## 6. Biểu diễn số

Giá trị canonical ưu tiên số nguyên đã định scale hoặc số hữu tỉ giới hạn. Mỗi quantity khai:

- `canonical_unit`;
- `storage_scale`;
- `valid_min/max`;
- `rounding_mode`;
- `overflow_policy`;
- `uncertainty` nếu là phép đo;
- `resolution_floor` theo R0–R4.

Số thực nền tảng chỉ được dùng nếu prototype chứng minh replay đa nền tảng ổn định hoặc kết quả được lượng tử hóa tại boundary đã định.

## 7. Không gian và miền hỗ trợ

Mỗi trạng thái vật lý gắn với một trong các miền:

- điểm/nút;
- đoạn/tuyến;
- bề mặt;
- thể tích;
- cấu trúc liên kết;
- vùng tổng hợp.

Một trường phải ghi domain và support. “Nhiệt độ căn phòng” là tóm lược vùng; khi cần biết gần lò nóng bao nhiêu, vùng được chia ô hoặc nút mà không giả toàn phòng đồng nhất.

## 8. Ranh giới hệ và môi trường

Mọi phép bảo toàn cần `SystemBoundary`: vật gì/vùng nào được tính, khoảng thời gian nào và dòng nào đi qua biên. Hệ hở có trao đổi; không được báo vi phạm bảo toàn chỉ vì bỏ sót dòng vào/ra.

Boundary có thể là túi, cơ thể, căn phòng, lưu vực, trận pháp hoặc vùng mô phỏng. Biên di động phải giữ lịch sử chuyển phần thuộc hệ.

## 9. Parcel, component và structure

`MatterParcel` đại diện một lượng vật chất truy vết được. `Component` là phần có vai trò trong vật thể. `StructureGraph` mô tả liên kết và hình học chức năng.

Tách/gộp parcel bảo toàn thành phần và provenance. Tháo một cán kiếm không xóa vật chất; làm gãy lưỡi đổi cấu trúc, khả năng và tạo mảnh có vị trí thật.

## 10. Chất, hỗn hợp và thành phần

`SubstanceDefinition` mô tả loại chất; `CompositionVector` mô tả tỷ phần hoặc lượng thành phần trong parcel. Hỗn hợp không cần sinh Definition mới cho mọi tỷ lệ.

Thuộc tính hỗn hợp được suy ra bởi rule có miền áp dụng. Không lấy trung bình tuyến tính cho mọi thuộc tính; hợp kim, dược dịch và mô sống có rule riêng nhưng dùng cùng giao diện.

## 11. Pha vật chất

Pha tối thiểu: rắn, lỏng, khí, plasma nếu nội dung cần, mô sống và pha linh hóa. “Mô sống” không thay thế thành phần hóa học; nó thêm tổ chức, trao đổi và chức năng.

Pha có điều kiện ổn định, chuyển pha, ẩn nhiệt hoặc chi phí linh năng tương ứng. Pha linh hóa phải định phần vật chất còn lại, khả năng tương tác và cách trở về.

## 12. Vi cấu trúc và chất lượng

Thuộc tính không chỉ đến từ thành phần mà còn từ:

- hạt, thớ, lỗ rỗng, lớp;
- hướng cấu trúc;
- khuyết tật;
- xử lý nhiệt/cơ/linh;
- tuổi và lịch sử tải;
- tạp chất và độ ẩm.

Hai thanh kiếm cùng khối lượng và thành phần vẫn có thể khác độ bền vì lịch sử chế tác. Chất lượng là vector dẫn xuất, không một bậc phẩm duy nhất.

## 13. Trạng thái vật chất cục bộ

`MaterialState` có thể chứa nhiệt độ, pha, mật độ, độ ẩm, ứng suất dư, damage tensor rút gọn, mức ăn mòn, điện tích, hoạt tính và trạng thái linh hóa. Chỉ trường cần cho loại vật và resolution hiện tại mới được materialize.

Giá trị không có không đồng nghĩa bằng 0. Schema dùng unknown/not-applicable/default có nghĩa rõ.

## 14. Trường

`FieldInstance` gồm:

```text
field_id, field_kind, source_refs, domain_ref,
representation, resolution, boundary_conditions,
value_state, update_rule_ref, active_interval, provenance
```

Trường có thể vô hướng, vector hoặc mạng. Nhiệt, áp suất, âm, ánh sáng và linh trường dùng chung lifecycle nhưng có luật lan truyền khác nhau.

## 15. Nguồn, hố và điều kiện biên

Nguồn tạo hoặc bơm đại lượng theo quy luật; hố lấy đi; reservoir trao đổi hữu hạn. Mỗi nguồn/hố khai capacity, rate, điều kiện, sản phẩm phụ và provenance.

Điều kiện biên gồm kín, mở, cố định, thông lượng, phản xạ, hấp thu, tuần hoàn hoặc quy tắc nội dung. Không cho trường tự xuất hiện ở biên không khai báo.

## 16. Năng lượng ledger

Mỗi quá trình có `EnergyTransfer` theo kênh: cơ, nhiệt, hóa, điện, bức xạ, sinh học và linh. Ledger không bắt mọi năng lượng biến thành gameplay chi tiết, nhưng tổng phải giải thích được trong sai số cho phép.

Năng lượng “tiêu hao” thường chuyển sang nhiệt, biến dạng, sản phẩm phụ, trường tản hoặc hố được thế giới cho phép. Không xóa bằng chữ “mất”.

## 17. Bảo toàn và ngoại lệ có khai báo

Vật chất thường bảo toàn qua biến đổi, trừ Source/Sink thế giới đã định. Linh năng có thể có quy luật riêng nhưng phải chọn một trong:

- bảo toàn toàn cục;
- trao đổi với nền/ngoại giới;
- sinh/diệt theo điều kiện;
- chuyển giữa loại với tỷ lệ và phần dư.

Mỗi ngoại lệ có `LawRef`; công pháp không tự tạo ngoại lệ cục bộ chỉ vì hiếm.

## 18. Cơ học chuyển động

K4.1 lưu vị trí, vận tốc cần thiết, khối lượng hiệu dụng, ràng buộc và impulse/tải. Không cần tích phân mọi rung động. Các mốc va chạm quan trọng dùng giải chi tiết; chuyển động bình thường dùng segment có thể cắt tại sự kiện.

Di chuyển của nhân vật vẫn do [[HANH_DONG]] quản kế hoạch; nền hiện tượng chỉ xác định khả thi và hậu quả vật lý.

## 19. Tiếp xúc và truyền tải

`ContactPatch` ghi hai bề mặt, diện tích hiệu dụng, pháp tuyến/hướng, thời gian tiếp xúc, trượt, lớp xen giữa và confidence của hình học. Đây là đầu vào cho lực, ma sát, nhiệt và truyền chất.

Không dùng một lần “hit” để vừa xuyên giáp, làm nóng, đẩy ngã và gây thương tích mà không phân bổ tác động.

## 20. Ứng suất, biến dạng và hỏng

Vật thể có ngưỡng đàn hồi, biến dạng dẻo, nứt, tách lớp, mỏi và phá hủy tùy material model. Damage giữ vị trí/cấu trúc và lịch sử tải quan trọng.

Giảm độ bền vì damage được suy ra một lần. Không vừa giảm durability tổng vừa giảm cấu trúc lần nữa cho cùng vết nứt.

## 21. Ma sát, mài mòn và bôi trơn

Ma sát phụ thuộc cặp bề mặt, lực ép, trạng thái bề mặt, chất xen và vận tốc tương đối. Nó tạo nhiệt và mài mòn. Bôi trơn đổi tiếp xúc nhưng chất bôi trơn cũng bị di chuyển, bẩn và cạn.

Ở resolution thấp, tích lũy wear budget; khi vượt mốc hoặc vật được quan sát gần, phân bổ thành khuyết tật có provenance.

## 22. Nhiệt

Tách nhiệt độ, nhiệt dung, năng lượng nhiệt và tốc độ truyền. Quá trình gồm dẫn, đối lưu, bức xạ và nguồn nội. Một vật nhỏ nóng không chứa cùng năng lượng với vật lớn cùng nhiệt độ.

Cơ thể nhận hậu quả qua nhiệt cục bộ, thời gian phơi nhiễm và chức năng mô; không trừ một thanh “lạnh/nóng” toàn thân rồi đồng thời gây tổn thương riêng trùng lặp.

## 23. Chất lưu

Chất lỏng và khí có volume, density, pressure, composition và flow network. Mức chi tiết đề xuất:

- R0/R1: dòng theo container/tuyến;
- R2: compartment và rate;
- R3: nút/cạnh cục bộ;
- R4: cân bằng vùng theo kỳ.

Không cần CFD toàn thế giới. Nước vẫn bảo toàn qua chứa, rò, bay hơi, uống và thải.

## 24. Áp suất và dòng

Dòng phát sinh từ chênh lệch thế/áp suất cùng conductance và ràng buộc. Van, lỗ, mạch máu, kinh mạch và đường ống có thể dùng chung mẫu network-flow, nhưng quantity và luật riêng.

Tắc nghẽn đổi conductance; vỡ tạo edge mới ra môi trường. Không chuyển ngay toàn bộ reservoir qua một mốc nếu rate hữu hạn.

## 25. Khí, độ ẩm và thông khí

Không gian kín có thành phần khí, nhiệt, độ ẩm, thể tích hiệu dụng và trao đổi. Cháy, hô hấp, độc khí và nấm mốc dùng chung ledger thành phần.

Vùng xa có thể giữ daily balance; phòng kín gần người chơi cần mốc thay đổi và cảnh báo qua quan sát thực, không qua thông tin toàn tri.

## 26. Chuyển pha

`PhaseTransitionRule` khai điều kiện, hysteresis nếu có, năng lượng, tốc độ, nucleation/seed khi cần và thay đổi thể tích/cấu trúc. Đông, tan, sôi, ngưng tụ, thăng hoa và linh hóa không chỉ đổi nhãn.

Chuyển pha dang dở là process có tiến độ và phân đoạn vật chất, có thể bị ngắt/lưu/tải.

## 27. Khuếch tán, hòa tan và thẩm thấu

Trao đổi chất giữa compartment dựa trên diện tích, gradient, permeability, nhiệt và thời gian. Mức thấp dùng transfer budget; mức cao dùng cạnh cụ thể.

Dược chất không lập tức đồng đều trong cả cơ thể hoặc bình. Rửa vết thương chuyển chất bẩn sang nước/băng, không xóa khỏi thế giới.

## 28. Phản ứng

`ReactionRule` định reactant theo lượng, điều kiện, catalyst/inhibitor, rate law rút gọn, sản phẩm, năng lượng và phần không phản ứng. Resolver chọn tập phản ứng khả thi theo resource reservation để tránh tiêu cùng chất hai lần.

Phản ứng có thể cạnh tranh; thứ tự mã không được quyết định kết quả. Quy tắc phân bổ phải có policy và trace.

## 29. Cháy và nổ

Cháy cần nhiên liệu, chất oxy hóa hoặc nguồn tương đương, điều kiện bắt đầu, nhiệt và đường truyền. Nó tạo sản phẩm, nhiệt, ánh sáng và có thể áp suất.

Nổ là giải phóng nhanh theo thời gian/không gian; không phải bán kính gây sát thương cố định. Resolution thấp vẫn phải giữ tổng vật chất, năng lượng và các đối tượng quan trọng bị ảnh hưởng.

## 30. Ăn mòn, phân hủy và lão hóa vật liệu

Các process chậm tích lũy theo môi trường, thành phần, bề mặt và lịch sử bảo quản. Không quét từng vật mỗi tick; scheduler đặt mốc khi trạng thái quan sát được hoặc khả năng thay đổi.

Compaction được phép tóm lược lịch sử process nhưng giữ trạng thái, nguồn và mốc quan trọng.

## 31. Ánh sáng và thị giác

Nguồn sáng, truyền, che khuất, phản xạ/tán xạ rút gọn và độ nhạy người quan sát tạo Signal. Không dựng ảnh pixel; dùng visibility graph/attenuation đủ để biết ai có thể thấy gì và với độ chắc chắn nào.

Linh quang vẫn phải khai spectrum/channel mà giác quan hoặc công cụ nào nhận được.

## 32. Âm thanh và rung

Sự kiện tạo tín hiệu với cường độ, phổ/nhãn, vị trí và thời lượng. Môi trường truyền, suy giảm, chặn hoặc phản xạ rút gọn. Observation chứa ước lượng, không truyền source entity id trực tiếp.

Rung cơ học có thể gây hỏng hoặc được cảm nhận bởi kỹ năng/giác quan phù hợp.

## 33. Điện, từ và hiện tượng hiếm

Chỉ materialize khi nội dung dùng. Điện tích, điện thế, dòng và conductance dùng network hoặc local interaction. Từ trường và bức xạ có FieldKind riêng.

Các hiện tượng hiếm không được gắn hard-code vào chiến đấu; chúng đăng ký quantity, source, interaction và observation adapters.

## 34. Tác nhân sinh học, độc và bệnh

K4.1 chỉ định carrier/transport/exposure: lượng tác nhân, vị trí, môi trường, đường vào và decay. [[CO_THE]] quản đáp ứng sinh lý, tổn thương và miễn dịch.

Một liều không vừa bị trừ ở môi trường vừa giữ nguyên để gây phơi nhiễm vô hạn. Tác nhân sống sinh sản cần nguồn và điều kiện.

## 35. Nền linh tính của thế giới

Đề xuất xem linh tính là miền quy luật bổ sung, không là phép miễn mọi luật. Tối thiểu cần:

- `SpiritualQuantityKind`;
- reservoir/carrier;
- field và gradient;
- affinity/coupling;
- conversion rule;
- leakage/decay hoặc quy tắc giữ;
- measurement channel;
- LawRef cho ngoại lệ.

Bản chất cuối của linh khí, số loại và nguồn vũ trụ thuộc TN04, chưa chốt.

## 36. Linh khí, linh năng và linh chất

Ba khái niệm không mặc định đồng nhất:

- linh khí: carrier hoặc môi trường truyền;
- linh năng: đại lượng có thể trao đổi/chuyển hóa;
- linh chất: vật chất có thành phần/cấu trúc linh đặc biệt.

Nội dung có thể định nghĩa khác, nhưng phải ánh xạ rõ để tránh cùng một từ lúc là vật, lúc là năng lượng, lúc là trường.

## 37. Thuộc tính và tương hợp

“Hỏa”, “thủy” hoặc thuộc tính khác là tập interaction tags/rules, không tự là bảng khắc chế toàn cục. Tương hợp giữa nguồn, vật mang, kinh mạch, môi trường và kỹ thuật tạo coupling coefficient có điều kiện.

Một công pháp hợp không có nghĩa mọi thuật cùng nhãn đều tốt; cấu trúc, tốc độ, tạp chất và trạng thái cơ thể vẫn ảnh hưởng.

## 38. Linh trường

`SpiritualField` có source, domain, intensity, direction/topology nếu cần, spectrum/affinity, coherence, turbulence, boundary và update rule. Linh mạch là cấu trúc dẫn/nguồn dài hạn; linh địa là vùng suy ra từ nhiều trường và vật mang.

Không lưu một bậc “linh địa cấp 3” làm sự thật duy nhất. Bậc hiển thị là View từ các đại lượng và tri thức quan sát.

## 39. Hấp thu và dung nạp

Hấp thu là flow qua interface có rate, selectivity, resistance và capacity. Nguồn ngoài giảm tương ứng hoặc có luật replenishment. Cơ thể nhận lượng vào compartment thật.

Dung nạp giới hạn bởi cấu trúc và trạng thái. Phần vượt có thể bị từ chối, rò, chuyển hóa, gây nhiệt, tổn thương hoặc hiện tượng khác theo công pháp; không tự biến mất.

## 40. Kinh mạch, đan điền và cấu trúc dẫn linh

Các cấu trúc này được mô hình hóa bằng graph có node/edge, capacity, conductance, integrity, affinity, pressure/potential và state cục bộ. [[CO_THE]] quản quan hệ giải phẫu; K4.1 quản flow và tương tác.

Tắc, rách hoặc tái cấu trúc đổi mạng từ mốc xảy ra. Một nhãn thương tổn không vừa giảm toàn bộ công suất vừa áp lại trên từng edge nếu cùng nguồn.

## 41. Công pháp như chương trình biến đổi

`TechniqueDefinition` biên dịch thành:

```text
preconditions → route plan → reservations → staged transfers
→ transformations → emissions/byproducts → observations → recovery
```

Khác biệt công pháp đến từ topology, quantity, nhịp, feedback, catalyst, tương hợp, giới hạn, sản phẩm phụ và cách thích nghi; không chỉ hệ số hiệu suất.

## 42. Thuật pháp và hiệu ứng

Thuật tạo `PhenomenonProcess`, trường, vật phóng hoặc thay đổi cấu trúc hợp lệ. Mỗi hiệu ứng có nguồn, chi phí đã reserve, đường truyền, target theo nhận thức, thời gian, cách chặn và điều kiện kết thúc.

“Duy trì” cần liên kết tới source/controller. “Đã phóng” có thể độc lập nếu Definition cho phép. Save/load giữ đúng distinction.

## 43. Trận pháp và cấu trúc cộng hưởng

Trận pháp là graph vật mang–điểm neo–đường nối–controller, với điều kiện hình học, cấp nguồn và coherence. Hỏng một nút làm resolver tính lại topology; không mặc định toàn hệ tắt hoặc vẫn đủ công suất.

Vùng ảnh hưởng là kết quả của trường, không là vòng tròn miễn phí. Trận pháp xa được tóm lược nhưng anchor và các đối tượng quan trọng vẫn giữ.

## 44. Pháp khí và vật liệu linh

Pháp khí kết hợp StructureGraph thường với spiritual components, inscriptions và process bindings. Nó có mòn, nứt, nhiễm, rò và lịch sử sử dụng.

Sửa chữa cần thay vật chất/cấu trúc và hiệu chỉnh linh. Gộp hai pháp khí không tự cộng phẩm cấp hay xóa provenance.

## 45. Tương tác thường–linh

Mỗi cầu nối là `CouplingRule`, ví dụ linh năng thành nhiệt, trường gia cường đổi ứng suất, linh thức tạo signal hoặc thuật chuyển pha. Rule khai hiệu suất, giới hạn, phản lực/phần dư và điều kiện.

Không cho linh lực tác động vật chất nếu không có coupling. Không buộc mọi hiện tượng linh đều bảo toàn theo cùng luật vật lý thường nếu thế giới đã khai LawRef khác.

## 46. Chuỗi nhân quả chuẩn

Mỗi thay đổi quan trọng mang `CauseChainRef`:

1. intent/condition;
2. reservation;
3. source transfer;
4. propagation;
5. interaction;
6. state delta;
7. derived capability;
8. signal/observation;
9. downstream decision.

Trace có thể tóm lược nhưng phải lần ngược được tới nguồn, nhất là chết người, phá vật, đột phá và mất tài sản.

## 47. Thứ tự giải cùng mốc

Đề xuất mở rộng tám pha K2:

1. chốt input và trạng thái trước mốc;
2. đánh giá điều kiện/reservation;
3. tạo transfer/interaction intents;
4. giải xung đột nguồn và topology;
5. giải truyền/tương tác trên pre-state;
6. commit delta vật chất–năng lượng–trường nguyên tử;
7. suy ra chức năng/tín hiệu/trigger;
8. lập lịch tiếp và xuất View.

Không để update nhiệt trước hay damage trước chỉ vì thứ tự vòng lặp.

## 48. Quá trình liên tục và mốc rời rạc

`PhenomenonProcess` lưu state, rate model, next breakpoint và error estimate. Resolver có thể nhảy thẳng tới:

- ngưỡng pha;
- cạn nguồn;
- đạt liều;
- gãy/tắc;
- giao cắt miền;
- lúc quan sát;
- mốc phụ thuộc khác.

Không cập nhật mỗi giây game nếu không có thay đổi cần biết.

## 49. Step thích nghi

Bước thời gian chọn theo sai số và sự kiện gần nhất. Nếu gradient/tốc độ đổi nhanh, chia nhỏ; nếu ổn định, tích phân dài hơn. Bước phải deterministic từ state/config, không phụ thuộc tốc độ máy.

Khi phát hiện vượt ngưỡng trong một bước, resolver tìm hoặc chặn về mốc ngưỡng theo quy tắc, không cho hậu quả trễ cả ngày.

## 50. Không gian thích nghi

Chia miền khi:

- gradient vượt ngưỡng;
- có vật/Person quan trọng;
- tương tác chạm biên;
- người chơi có thể quan sát;
- error budget không đạt.

Gộp lại chỉ khi bảo toàn tổng, anchor, cực trị nguy hiểm và provenance cần thiết. Không lấy trung bình làm mất một túi độc nhỏ nhưng chí mạng.

## 51. Mức phân giải hiện tượng P0–P4

| Mức | Biểu diễn | Dùng cho |
|---|---|---|
| P0 | interaction/contact chi tiết | đòn đánh, mạch, chế tác tinh |
| P1 | compartment/network | cơ thể, phòng, lò, trận pháp |
| P2 | vùng/parcel aggregate | nhà, ruộng, kho, tiểu khu |
| P3 | flux giữa vùng | làng–thung lũng–tuyến |
| P4 | balance/seasonal envelope | vùng xa và lịch sử dài |

P0–P4 là độ phân giải hiện tượng, độc lập với M0–M4 tồn tại và R0–R4 giải tác nhân.

## 52. Hợp đồng nâng/hạ độ phân giải

Nâng P cần phân bổ aggregate thành state chi tiết bằng seed, anchor, history và constraint. Kết quả không được tối ưu để thuận lợi cho người chơi. Hạ P giữ:

- tổng quantity;
- cực trị hoặc hazard quan trọng;
- object/person anchors;
- process chưa kết thúc;
- boundary debt;
- uncertainty/error bound;
- provenance cần replay.

## 53. Aggregate và moment

Một vùng không chỉ giữ trung bình. Tùy hiện tượng có thể giữ total, min/max, variance, histogram bins, hotspots và correlation anchors. Ví dụ nhiệt độ trung bình an toàn không được che một đám cháy.

Model definition khai statistic nào đủ cho promotion/reconciliation; không dùng một aggregate chung cho mọi trường.

## 54. Error budget

Mỗi phép xấp xỉ sinh `ApproximationDebt` gồm quantity, bound, domain, thời gian và cách trả nợ. Nợ cộng qua bước nhưng có trần; vượt trần buộc tăng resolution hoặc tạo mốc giải chính xác.

Sai số không được làm đổi bất biến rời rạc như sống/chết, sở hữu, identity, số vật độc nhất hoặc kết quả đã quan sát.

## 55. Ngẫu nhiên và bất định

Ngẫu nhiên mô phỏng biến thiên thật của thế giới dùng RNG stream có domain/seed. Bất định tri thức là distribution/range trong Belief, không làm state thật ngẫu nhiên lại mỗi lần xem.

Sampling ở resolution thấp phải giữ aggregate constraints và được cố định khi đã ảnh hưởng lịch sử.

## 56. Đo lường và nhận thức

Sensor/giác quan biến state/field thành Signal qua range, sensitivity, noise, saturation, occlusion và calibration. Observation ghi kết quả đã đo, thời gian và confidence.

Người chơi thấy “ấm bất thường” nếu nhân vật cảm được; giao diện debug mới được xem giá trị canonical. Linh căn/linh thức cũng là sensor có kênh và giới hạn.

## 57. BoundaryFlow xuyên vùng

Vật, nhiệt, khí, nước, chất ô nhiễm và linh năng qua biên tạo `BoundaryFlow` với interval, quantity vector, source/destination, carrier, provenance và reconciliation status.

Hai shard không tự tính cùng một dòng. Chủ quản commit cấp flow id; phía nhận áp đúng một lần theo [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]].

## 58. Sinh thế giới và trạng thái ban đầu

Generator tạo địa chất, khí hậu, thủy hệ, sinh thái và linh mạch theo thứ tự constraint, sau đó chạy equilibration/prehistory có ngân sách. Initial state phải có:

- nguồn/hố;
- inventory và field balance;
- vùng bất ổn được ghi;
- anchor độc nhất;
- provenance seed/rule/version;
- error envelope vùng chưa materialize.

Không sinh một linh địa chỉ khi người chơi cần tìm nó.

## 59. MaterialDefinition

Mỗi vật liệu định nghĩa theo module:

```text
identity + composition + phase models + structure models
+ mechanical + thermal + transport + chemical
+ spiritual coupling + hazards + observation signatures
+ validity ranges + source references + version
```

Thuộc tính không áp dụng có trạng thái rõ. Content package có thể kế thừa template nhưng artifact biên dịch phải giải được nguồn giá trị.

## 60. PhenomenonDefinition

Một hiện tượng có:

- input quantities và domain;
- preconditions;
- state/rate/update rule;
- breakpoints;
- outputs/byproducts;
- coupling;
- resolution models P0–P4;
- conservation/error oracle;
- observation emissions;
- save/migration contract.

Đây là Definition; lần cháy cụ thể là ProcessInstance.

## 61. ProcessInstance

Process giữ `process_id`, participants, domain, state, reservations, accumulated transfers, next_event, model version, RNG cursor và cause chain. Process dừng khi điều kiện kết thúc thật; không xóa chỉ vì không còn trên màn hình.

Nếu model version đổi, migration hoặc pin bản cũ phải rõ. Không tiếp tục nửa process bằng rule mới âm thầm.

## 62. DerivedCapability

Khả năng cắt, chứa, cách nhiệt, dẫn linh, vận động hay cảm nhận đều là projection từ cấu trúc/trạng thái và actor context. Cache có revision dependencies.

Khi vật nứt hoặc tay mất chức năng, cache invalidated theo dependency. Không lưu đồng thời một chỉ số độc lập rồi để lệch với nguồn.

## 63. Status và hiệu ứng kéo dài

Status chỉ là index/view hoặc handle tới ProcessInstance, không là nguồn hậu quả thứ hai. “Đang cháy” trỏ tới combustion process; “nhiễm độc” trỏ tới lượng tác nhân và đáp ứng cơ thể.

Nếu cần snapshot gameplay, nó ghi source revision và không được tự tick song song với process gốc.

## 64. Giao với cơ thể

K4.1 sở hữu transfer vào mô và state vật lý cục bộ; [[CO_THE]] sở hữu tổn thương sinh học, điều hòa và chức năng. Boundary contract gồm:

```text
exposure/contact → absorbed quantity → tissue-state delta
→ injury/physiology resolver → function change
```

Chảy máu là flow vật chất qua mạch bị hở; đau là tín hiệu sinh lý; giảm khả năng là projection. Ba thứ liên quan nhưng không cộng trừ thay nhau.

## 65. Giao với vật phẩm và chế tác

[[VAT_PHAM]] sở hữu identity, cấu trúc công dụng, quyền và recipe intent. K4.1 giải nhiệt, lực, phản ứng, phase và thay đổi cấu trúc. Recipe định điều kiện/mục tiêu, không tự đảm bảo kết quả.

Tay nghề ảnh hưởng lựa chọn, điều khiển và sai số thao tác; không biến nguyên liệu kém thành sản phẩm tốt mà không có cơ chế vật chất.

## 66. Giao với môi trường và sinh thái

[[MOI_TRUONG]] sở hữu địa hình, quần thể và hệ sinh thái; K4.1 cung cấp water/heat/gas/nutrient/spiritual flows. Sinh vật tiêu thụ và thải qua transaction vật chất.

Vùng xa dùng balance theo mùa nhưng drought, ô nhiễm, cháy hoặc linh biến quan trọng phải tạo anchor/process và truyền hậu quả qua BoundaryFlow.

## 67. Giao với chiến đấu

[[CHIEN_DAU]] sở hữu intent, phase, reaction và target theo nhận thức. K4.1 giải contact, impulse, nhiệt, field và transfer; [[CO_THE]] giải thương tích.

Một đòn có nhiều kênh phải phân bổ ledger. Giáp thay đường truyền theo lớp/cấu trúc. Nhãn cảnh giới không tự giảm sát thương nếu không có capability/coupling.

## 68. Giao với tu luyện

[[TU_LUYEN]] sở hữu kiến thức, route, tiến trình học, bình cảnh và lựa chọn. K4.1 giải flow, capacity, transformation, field và hậu quả cấu trúc.

Đột phá là process nhiều pha có reservation, instability, threshold, feedback và outcome; không là lần tung xác độc lập khỏi chuẩn bị/cơ thể/môi trường.

## 69. Giao với kinh tế và tổ chức

Chất lượng quan sát được khác chất lượng thật; kiểm định là hành động đo. Thị trường định giá theo belief, nguồn gốc, nhu cầu và luật, không đọc trực tiếp MaterialState.

Ô nhiễm, khai thác nguồn, trận pháp vùng và tai nạn tạo quyền, nghĩa vụ, bồi thường và tranh chấp qua [[KINH_TE_TO_CHUC]].

## 70. Giao với NPC và hành động

NPC lập kế hoạch từ capability đã biết, hazard đã quan sát và mô hình tinh thần. Resolver vật lý xác nhận khả thi tại mốc thực hiện. Thất bại tạo Observation/Memory thay vì cho NPC tự biết hệ số ẩn.

NPC vùng xa dùng cùng outcome semantics ở resolution thấp; khi trở lại gần, lịch sử vật chất và thương tích quan trọng vẫn phải khớp.

## 71. Giao diện text

Mỗi hiện tượng cung cấp ba projection:

- ngắn: trạng thái/hazard cần hành động;
- giải thích: nguồn → đường truyền → hậu quả chính;
- chuyên sâu: đại lượng nhân vật đo/biết cùng độ chắc chắn.

Ví dụ: “Lưỡi kiếm đã đỏ nóng; nhiệt đang truyền vào chuôi. Vải quấn làm chậm nhưng không chặn hoàn toàn.” Không cần hiển thị mọi số để mô phỏng bên dưới vẫn sâu.

## 72. Lưu, tải và replay

Portable save giữ Definition refs/version, parcel/structure state, active fields/processes, boundary flows, aggregate moments, approximation debt, RNG cursor và cause anchors. Derived caches được dựng lại.

Snapshot giữa chuyển pha, phản ứng hoặc đột phá phải tiếp tục đúng lượng và mốc. Kill/reload không được nhân đôi transfer hay chạy lại sampling.

## 73. Hiệu năng điện thoại và máy tính

Core semantic giống nhau. Khác biệt được phép ở ngân sách wall-clock, cache, worker, batch và mức View, không ở kết quả logic. Cơ chế chính:

- event/breakpoint thay polling;
- graph/network cục bộ;
- adaptive P0–P4;
- active-set cho field/process;
- vectorized/batch vùng xa;
- precomputed material rule tables có version;
- cache dẫn xuất theo revision;
- backpressure tăng độ trễ ngoài đời hoặc hạ resolution trong error budget.

Không bỏ bảo toàn, NPC hoặc hậu quả để đạt 5 giây/ngày.

## 74. Authoring và mở rộng nội dung

Người viết nội dung khai Definition bằng artifact có schema. Compiler kiểm:

- dimension/unit;
- reference/version;
- reaction balance;
- source/sink/LawRef;
- P0–P4 coverage;
- observation channel;
- migration policy;
- condition links.

Mod không được gọi thẳng storage hoặc sửa canonical state ngoài transaction.

## 75. Invariant bắt buộc

1. Tổng vật chất trong boundary khớp flow/source/sink.
2. Energy ledger khớp trong error budget và LawRef.
3. Không quantity âm ngoài miền cho phép.
4. Một transfer chỉ commit một lần.
5. Một parcel ở một vị trí/cấu trúc chủ quản.
6. Process dùng đúng model version.
7. Hạ/nâng P giữ aggregate và anchor.
8. Error debt không vượt trần âm thầm.
9. Observation không mang dữ liệu state ngoài sensor.
10. Save/replay giữ fingerprint.
11. Mobile/desktop giữ semantic result.
12. Status không tick trùng process gốc.

## 76. Chống khai thác và lỗi thiết kế

- tách/gộp để reset nhiệt, độc, wear hoặc provenance;
- chuyển container để nhân đôi flow;
- spam pause/load để bốc lại phản ứng;
- đổi resolution để xóa hotspot;
- dùng hai process tiêu cùng reservoir;
- vòng chuyển hóa sinh năng lượng vô hạn;
- gộp hỗn hợp làm sạch tạp chất;
- tháo/lắp để sửa miễn phí;
- vùng xa bỏ qua tai nạn rồi vùng gần hoàn hảo;
- status và process cùng gây hậu quả;
- làm tròn lặp tạo vật/năng lượng;
- pháp thuật dùng LawRef rộng hơn phạm vi.

Mỗi đường phải có oracle hoặc audit trace.

## 77. Xử lý lỗi và dữ liệu không hợp lệ

Schema lỗi chặn build. State runtime ngoài miền tạo FailureArtifact, không tự clamp nếu clamp làm mất bảo toàn. Process thiếu Definition/version làm save không tương thích hoặc vào chế độ sửa có báo cáo, không đoán rule.

Khi overflow/capacity quá tải, scheduler dừng an toàn hoặc giảm resolution trong hợp đồng. Không tiếp tục với quantity NaN/không xác định.

## 78. Calibration

Thông số thường có thể dựa trên nguồn tham khảo sau này; thông số tu tiên là luật hư cấu cần cân bằng nội bộ. Mỗi giá trị ghi:

- provenance/source;
- confidence;
- validity range;
- calibration fixture;
- gameplay exposure;
- version và lý do đổi.

Không coi độ nhiều chữ là độ chính xác khoa học.

## 79. Fixture nền đề xuất

| Fixture | Nội dung | Mục đích |
|---|---|---|
| K4-F01 | hai parcel trong container kín | bảo toàn/tách/gộp |
| K4-F02 | vật nóng–lạnh tiếp xúc | truyền nhiệt và step |
| K4-F03 | bình nước có lỗ | flow/cạn nguồn |
| K4-F04 | thanh nhiều lớp chịu tải | contact/damage |
| K4-F05 | phòng kín có lửa | khí–nhiệt–cháy |
| K4-F06 | dung dịch và màng | khuếch tán |
| K4-F07 | linh thạch–kinh mạch mẫu | hấp thu/dung nạp |
| K4-F08 | trường qua hai vùng/shard | boundary reconciliation |
| K4-F09 | cùng cảnh ở P0–P4 | parity/error bound |
| K4-F10 | save giữa phản ứng | exactly-once/replay |
| K4-F11 | đòn qua giáp vào mô | combat–item–body chain |
| K4-F12 | vùng xa cháy rồi materialize | aggregate/hotspot/history |

Đây mới là đặc tả fixture, chưa có dữ liệu máy.

## 80. Tình huống kiểm chứng VL01–VL84

### 80.1. Đại lượng, vật chất và cấu trúc

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VL01 | cộng đại lượng khác dimension | bị từ chối khi build/runtime boundary |
| VL02 | đổi đơn vị rồi lưu/tải | canonical value không đổi |
| VL03 | làm tròn qua 10.000 lần tách/gộp | phần dư được giữ, không sinh/mất lượng |
| VL04 | overflow quantity | lỗi có bằng chứng, không wrap âm |
| VL05 | field không có domain | artifact không hợp lệ |
| VL06 | hệ hở nhận vật qua biên | conservation tính đúng BoundaryFlow |
| VL07 | tách hỗn hợp | tổng từng thành phần và provenance giữ |
| VL08 | gộp parcel khác nhiệt | energy quyết định trạng thái mới, không trung bình sai |
| VL09 | tháo component | vật chất, vị trí và liên kết mới đầy đủ |
| VL10 | gãy vật nhiều lớp | damage theo lớp, không trừ durability trùng |
| VL11 | cùng thành phần khác vi cấu trúc | capability có thể khác có nguồn |
| VL12 | trường unknown | không bị hiểu thành giá trị 0 |

### 80.2. Truyền, phản ứng và quá trình

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VL13 | hai vật trao đổi nhiệt trong hệ kín | tổng năng lượng trong sai số |
| VL14 | vật nhỏ/vật lớn cùng nhiệt độ | nhiệt lượng không bị coi bằng nhau |
| VL15 | nguồn nhiệt cạn | process dừng đúng mốc |
| VL16 | bình rò qua lỗ hữu hạn | không chuyển hết tức thời |
| VL17 | van đóng giữa flow | delta trước mốc giữ, sau mốc dừng |
| VL18 | khí trong phòng kín bị tiêu | thành phần và pressure state cùng cập nhật |
| VL19 | chuyển pha dang dở rồi ngắt | giữ fraction và energy đã trao đổi |
| VL20 | hòa tan chưa cân bằng | nồng độ cục bộ không bị đồng nhất tức thì |
| VL21 | hai phản ứng tranh reactant | reservation ngăn tiêu hai lần |
| VL22 | catalyst | đổi rate, không tự bị tiêu nếu rule không nói |
| VL23 | cháy thiếu chất oxy hóa | suy yếu/tắt theo rule, không cháy vô hạn |
| VL24 | nổ gần vật cản | đường truyền quyết định tác động, không chỉ bán kính |
| VL25 | ăn mòn vùng xa | tích lũy theo lịch sử môi trường |
| VL26 | process mất người quan sát | vẫn tồn tại theo scheduler |
| VL27 | breakpoint trong bước dài | giải tại ngưỡng, không trễ tới cuối ngày |
| VL28 | hai transfer cùng mốc | resolve từ pre-state và commit nguyên tử |

### 80.3. Tín hiệu và tri thức

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VL29 | ánh sáng bị vật che | người sau vật không nhận observation trực tiếp |
| VL30 | âm qua hai phòng | suy giảm và ước lượng, không lộ source id |
| VL31 | sensor bão hòa | observation giới hạn/confidence thấp |
| VL32 | dụng cụ lệch calibration | belief sai có provenance |
| VL33 | linh thức không có channel phù hợp | không thấy loại trường đó |
| VL34 | mở UI nhiều lần | state thật/RNG không đổi |
| VL35 | hai NPC ở vị trí khác | nhận tín hiệu khác nhau hợp lý |
| VL36 | field thật đổi nhưng chưa có tín hiệu | NPC chưa tự biết |

### 80.4. Linh lực và tu luyện

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VL37 | hấp thu từ reservoir hữu hạn | nguồn ngoài giảm tương ứng |
| VL38 | vượt capacity kinh mạch | flow bị giới hạn và phần dư có đích |
| VL39 | edge kinh mạch tắc | topology/rate đổi từ đúng mốc |
| VL40 | công pháp bị ngắt giữa tuyến | giữ transfer và hậu quả đã xảy ra |
| VL41 | hai thuật dùng lượng linh lực cuối | chỉ allocation hợp lệ commit |
| VL42 | thuật chuyển linh thành nhiệt | hai ledger nối bằng CouplingRule |
| VL43 | thuộc tính cùng nhãn nhưng cấu trúc khác | không tự cho hiệu quả giống nhau |
| VL44 | linh trường có hotspot | aggregate giữ hotspot khi hạ P |
| VL45 | trận pháp mất một neo | topology được tính lại có trace |
| VL46 | pháp khí nứt | dẫn linh/capability đổi từ state cấu trúc |
| VL47 | hiệu ứng đã phóng, người phát bất tỉnh | tiếp tục nếu Definition độc lập |
| VL48 | hiệu ứng cần duy trì, mất controller | kết thúc theo rule |
| VL49 | LawRef tạo vật | source/sink và phạm vi ngoại lệ rõ |
| VL50 | vòng chuyển hóa linh–nhiệt–linh | không sinh vô hạn ngoài luật |
| VL51 | save giữa đột phá | tải lại không reset instability/RNG |
| VL52 | cùng fixture mobile/desktop | fingerprint semantic giống nhau |

### 80.5. Liên hệ domain

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VL53 | kiếm nóng chạm tay | heat transfer rồi tissue response, không damage kép |
| VL54 | đòn qua hai lớp giáp | phân bổ impulse/energy theo cấu trúc |
| VL55 | giáp hỏng giữa nhóm tác động | quy ước cùng mốc nhất quán |
| VL56 | chảy máu | matter flow giảm compartment thật |
| VL57 | rửa độc khỏi vết thương | độc chuyển carrier/vị trí, không bị xóa |
| VL58 | uống dược | parcel giảm, cơ thể nhận thành phần theo thời gian |
| VL59 | rèn sai nhiệt | vi cấu trúc và chất lượng có hậu quả |
| VL60 | tay nghề cao với nguyên liệu lỗi | không bỏ qua constraint vật liệu |
| VL61 | lửa trong kho | vật, khí, nhiệt và quyền/tổn thất cùng nối |
| VL62 | ô nhiễm theo sông | BoundaryFlow truyền qua vùng đúng một lần |
| VL63 | hạn hán vùng xa | water balance ảnh hưởng mùa vụ khi materialize |
| VL64 | NPC không nhận ra khí độc | quyết định theo observation thiếu, state vẫn gây hại |
| VL65 | kiểm định pháp khí | thị trường biết theo phép đo, không đọc state thật |
| VL66 | vật độc nhất bị nóng chảy | identity/provenance chuyển thành outputs có rule |
| VL67 | thuật vùng trúng đồng đội | coupling/phạm vi áp theo state thật |
| VL68 | kết thúc chiến đấu | nhiệt, độc, process và nguồn không reset |

### 80.6. Phân tầng, lưu tải và độ bền

| ID | Tình huống | Kết quả bắt buộc |
|---|---|---|
| VL69 | P0 và P2 cùng fixture | chênh trong error bound đã khai |
| VL70 | hạ P có cực trị nguy hiểm | giữ hazard anchor |
| VL71 | nâng P một vùng chưa quan sát | seed/constraint quyết định, không nhu cầu người chơi |
| VL72 | đổi P nhiều lần | total và identity không drift |
| VL73 | approximation debt vượt trần | buộc refine/breakpoint, không bỏ qua |
| VL74 | flow qua shard retry | exactly-once theo flow id |
| VL75 | crash giữa source và destination | recovery không mất/nhân flow |
| VL76 | save giữa chuyển pha | phase fraction và energy giữ |
| VL77 | Definition mới khi process cũ đang chạy | migrate/pin/fail rõ, không trộn rule |
| VL78 | cache capability cũ | invalidated theo revision phụ thuộc |
| VL79 | status và process cùng tồn tại | chỉ process gây delta |
| VL80 | compaction process dài | trạng thái và cause anchor còn tái hiện được |
| VL81 | W1 chạy 30 ngày | không polling từng parcel vô ích |
| VL82 | máy chậm quá ngân sách | backpressure không đổi semantic outcome |
| VL83 | app mobile xuống nền giữa commit | boundary save an toàn |
| VL84 | import save sang desktop | quantity/version/fingerprint tương thích |

VL01–VL84 đều là điều kiện thiết kế chưa mã hóa và chưa chạy. Tổng hồ sơ tăng từ 1.104 lên 1.188 điều kiện thuộc 34 họ.

## 81. Cổng K4.1

| Cổng | Đạt khi | Hiện tại |
|---|---|---|
| K4P01 | ontology phân biệt entity/state/field/process | đạt trên giấy |
| K4P02 | quantity/unit/conservation contract rõ | đạt trên giấy |
| K4P03 | vật chất thường và linh có CouplingRule | đạt trên giấy |
| K4P04 | P0–P4 tách M0–M4 và R0–R4 | đạt trên giấy |
| K4P05 | boundary với năm domain chính rõ | đạt trên giấy |
| K4P06 | save/replay/mobile-desktop contract rõ | đạt trên giấy |
| K4P07 | machine schema/registry tồn tại | chưa |
| K4P08 | K4-F01–F12 mã hóa | chưa |
| K4P09 | VL01–VL84 chạy có evidence | chưa |
| K4P10 | thông số và luật linh được duyệt/calibrate | chưa |

## 82. Vấn đề mở

1. Vật lý thường bám thực tế tới mức nào ở từng P?
2. Dimension cơ sở nào cần canonical ngay từ đầu?
3. Linh năng bảo toàn, trao đổi với nền hay có sinh/diệt?
4. Có bao nhiêu loại linh khí và quan hệ chuyển hóa?
5. Không gian liên tục, graph, ô hay hybrid ở P0/P1?
6. Geometry va chạm tối thiểu cho text game?
7. Ngưỡng nào buộc giữ hotspot khi aggregate?
8. Sinh học dùng chung chất hóa học tới mức nào?
9. Ánh sáng/âm thanh cần phổ chi tiết tới đâu?
10. Điện, từ, bức xạ có vào chặng đầu không?
11. Pháp thuật có thể vi phạm luật nào và ai định LawRef?
12. Đơn vị linh năng hiển thị cho người chơi hay chỉ nội bộ?
13. Người thường đo được linh trường bằng công cụ nào?
14. Mức sai số parity chấp nhận cho các P?
15. Thông số nào cần nguồn khoa học, thông số nào thuần hư cấu?
16. K4.2 ưu tiên cơ thể–sinh lý hay vật liệu–chế tác sâu?

Các câu này chưa được tự chốt. K4.1 cung cấp chỗ gắn quyết định mà không buộc dừng việc lập kế hoạch.

## 83. Rủi ro

| Rủi ro | Hậu quả | Kiểm soát đề xuất |
|---|---|---|
| mô phỏng quá chi tiết | không đạt 5 giây/ngày | breakpoint, P0–P4, active set |
| quá đơn giản | hệ thống trở thành nhãn | chain nguồn–truyền–tương tác–hậu quả |
| linh lực là ngoại lệ vô hạn | mất nhất quán | quantity/field/coupling/LawRef |
| sai số tích lũy | thế giới trôi | residual và ApproximationDebt |
| aggregate xóa tai họa | lịch sử giả | extrema/hotspot/anchor |
| domain tính trùng | hậu quả nhân đôi | ownership boundary và ProcessInstance |
| dữ liệu vật liệu khổng lồ | authoring không kiểm soát | module/template/compiler/validity range |
| số thực khác nền tảng | replay lệch | integer scale hoặc quantized boundary |
| “chân thật” giả khoa học | thông số khó tin | provenance/confidence/calibration |
| UI ngập số | khó chơi trên điện thoại | projection ba tầng |

## 84. Trình tự hiện thực hóa khi được yêu cầu

1. Quantity/Unit/Dimension Registry.
2. Parcel/Composition/Container và conservation ledger.
3. Process/Transfer/BoundaryFlow kernel.
4. F01–F03: tách/gộp, nhiệt, rò.
5. Structure/contact/damage với F04.
6. Reaction/phase/gas với F05–F06.
7. Spiritual quantity/field/coupling với F07.
8. P0–P4 và shard reconciliation với F08–F09/F12.
9. save/replay với F10.
10. domain chain chiến đấu–vật–cơ thể với F11.
11. mã hóa VL01–VL84 và chạy evidence trên candidate stack.

Đây là thứ tự triển khai tương lai, không phải công việc đã thực hiện.

## 85. Những điều không được tuyên bố

- Không nói đã mô phỏng vật lý, hóa học hoặc linh lực.
- Không nói các thông số là chính xác khoa học.
- Không nói đã chốt bản chất linh khí/cảnh giới.
- Không nói P0–P4 đã đạt parity.
- Không nói VL01–VL84 đã mã hóa hay chạy.
- Không nói hệ thống chạy được trên điện thoại/máy tính.
- Không nói 1.188 điều kiện là 1.188 test tự động.
- Không nói schema/material database đã tồn tại.

## 86. Giá trị K4.1 cung cấp thật

- một ontology chung thay cho các thanh chỉ số rời rạc;
- ranh giới chủ quản giữa hiện tượng và năm domain lớn;
- mô hình linh lực có nguồn, trường, flow, capacity và hậu quả;
- chuỗi nhân quả có thể giải thích bằng text;
- P0–P4 giữ tham vọng chi tiết nhưng phù hợp mobile/desktop;
- hợp đồng artifact/save/replay để triển khai sau;
- 12 fixture và 84 điều kiện kiểm chứng có thể mã hóa.

## 87. Bước tiếp theo

K4.2–K4.3 đã định cơ thể và vật phẩm; K4.4 nay đã định môi trường tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
