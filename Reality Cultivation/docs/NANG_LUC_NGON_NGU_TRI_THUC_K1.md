---
title: Năng lực, ngôn ngữ và truyền tri thức — K1.9
aliases:
  - K1.9
  - Ma trận năng lực 21 người
tags:
  - reality-cultivation
  - thiet-ke
  - npc
  - tri-thuc
status: de-xuat
updated: 2026-09-06
---

# Năng lực, ngôn ngữ và truyền tri thức — K1.9

Tài liệu này nối [[HO_SO_NPC_AN_KHE_K1]], [[NGUON_QUYET_DINH_K1]] và [[SO_THE_CHE_30_NGAY_K1]]. Nó xác định P00/N01–N20 có thể nghe, nói, đọc, viết, tính toán, xác nhận hồ sơ và truyền kỹ năng tới đâu tại ngày 1, 06:00.

Đây là fixture đề xuất chưa được người dùng duyệt hoặc chạy. Mức năng lực mô tả **những việc đã có bằng chứng**, không phải trí thông minh, giá trị con người hay trần học tập. Thiếu bằng chứng được ghi là `U — chưa xác định`, không âm thầm nâng lên mức thuận tiện.

## 1. Những điều phải tách riêng

- biết nói một ngôn ngữ không đồng nghĩa biết đọc hệ chữ của nó;
- đọc được từ không đồng nghĩa hiểu thuật ngữ nghề;
- chép đúng ký tự không đồng nghĩa hiểu nội dung;
- tính tiền chợ không đồng nghĩa cân sổ phức tạp;
- làm được không đồng nghĩa giải thích được;
- giải thích được không đồng nghĩa có quyền chứng nhận người học;
- nghe một lời kể không đồng nghĩa học được kỹ năng trong lời kể;
- nhớ kết luận không đồng nghĩa nhớ quy trình hay nguồn bằng chứng.

Body cung cấp khả năng nghe, nhìn, phát âm, giữ bút và tập trung tại thời điểm hành động. SkillProfile chỉ cung cấp năng lực đã học. Một người R3 đang không nhìn rõ vì thương tích vẫn không đọc được; một người R0 có mắt khỏe cũng không tự hiểu chữ.

## 2. Ngôn ngữ, hệ chữ và nhóm thuật ngữ của fixture

| Mã | Loại | Phạm vi |
|---|---|---|
| LANG-AK | ngôn ngữ nói | tiếng sinh hoạt chung tại An Khê; có giọng địa phương nhưng cùng khả năng hiểu cơ sở |
| SCRIPT-AK | hệ chữ | chữ dùng trên V26, V34, V35; đọc/viết phải học riêng |
| LEX-TRADE | thuật ngữ chợ/sổ | giá, lượng, nợ, hạn, chủ/giữ, nhập/xuất |
| LEX-FARM | thuật ngữ ruộng | lô, chín, giống, thu, định suất, kho ruộng |
| LEX-MED | thuật ngữ y quán | bộ phận, triệu chứng, vệ sinh, thao tác, giới hạn ca |
| LEX-CRAFT | thuật ngữ xưởng | bộ phận, vật liệu, kích thước, mối lắp, sai hỏng |
| LEX-CULT | thuật ngữ tu luyện | tuyến vận hành, L, nhịp, bình cảnh, dừng phiên |
| LEX-ROAD | thuật ngữ đường/vận chuyển | tuyến, bờ, tải, giao nhận, dấu kết cấu, đường vòng |

`LEX-*` không phải ngôn ngữ bí mật. Người biết LANG-AK có thể nghe âm nhưng hiểu sai nghĩa chuyên môn. Một từ có nghĩa thường và nghĩa nghề phải lưu Sense cụ thể trong Message/KnowledgeUnit.

Không thêm ngoại ngữ vào INIT-A vì lịch hiện tại chưa cần và lịch sử chưa đủ để xác định ai dùng ngôn ngữ nào ngoài vùng. N03/N05/N13 từng đi ngoài An Khê không tự nhận ngoại ngữ chỉ từ chi tiết đó.

## 3. Thang nghe và nói LANG-AK

| Mức | Nghe `H` | Nói `S` |
|---:|---|---|
| 0 | không nhận ra lời có nghĩa | không tạo được thông điệp có cấu trúc |
| 1 | hiểu từ/câu rất quen khi nói chậm | đáp từ/câu mẫu, khó diễn đạt điều kiện mới |
| 2 | hiểu sinh hoạt và chỉ dẫn ngắn; dễ hụt thành ngữ/chuỗi điều kiện | trao đổi việc thường, hỏi lại, mô tả ngắn |
| 3 | hiểu hội thoại tự nhiên, điều kiện/hàm ý quen | diễn đạt rõ việc, lý do và điều kiện trong đời sống |
| 4 | hiểu sắc thái khó, lời mơ hồ và tranh luận dài | giảng giải/thương lượng công khai có cấu trúc; vẫn cần LEX chuyên môn |

Mức 4 không phát hiện nói dối và không đọc suy nghĩ. Tiếng ồn, khoảng cách, tốc độ nói, mệt, đau, cảm xúc và khả năng nghe/nói của Body điều chỉnh từng Action.

## 4. Thang đọc và viết SCRIPT-AK

| Mức | Đọc `R` | Viết `W` |
|---:|---|---|
| 0 | không giải mã được chữ; có thể nhận hình/dấu quen | không viết chữ; có thể tạo dấu cá nhân đã học |
| 1 | nhận tên, số, nhãn và câu mẫu quen | viết tên, số, nhãn hoặc chép mẫu ngắn |
| 2 | hiểu thông báo/hợp đồng thường nếu từ vựng quen | ghi mục ngắn, biên nhận và điều khoản mẫu |
| 3 | đọc văn bản dài, đối chiếu mục và phát hiện nhiều lỗi thường | soạn/sửa sổ nhiều điều khoản có chỉ mục |
| 4 | đọc/soạn văn bản chuyên sâu trong **một miền đã học** | diễn đạt chính xác khái niệm khó trong miền; không phổ quát mọi lĩnh vực |

R/W luôn đi cùng `script_id`, miền từ vựng, độ quen kiểu chữ và điều kiện vật lý. Người R2 đọc chữ viết vội có thể chậm hoặc sai. Chép bằng W2 giữ hình thức nhưng KnowledgeUnit về ý nghĩa chỉ tăng nếu người đó hiểu và được phản hồi.

## 5. Thang tính toán và đối chiếu

| Mức `C` | Khả năng có thể kiểm chứng |
|---:|---|
| 0 | chưa có bằng chứng đếm/số lượng có cấu trúc |
| 1 | đếm vật nhỏ, nhận số/giá quen, cộng trừ đơn giản có vật hỗ trợ |
| 2 | tính tiền/lượng thường, đối chiếu một giao dịch và phần còn |
| 3 | giữ sổ nhiều dòng, tỷ lệ đơn giản, phát hiện lệch và giải thích phép tính |
| 4 | mô hình hóa nhiều biến/ước lượng sai số trong miền chuyên môn đã học |

C không tự cho kiến thức về đơn vị. Người C3 chưa học L vẫn không tính linh lực; người C1 có thể đếm 12 đồng thật nếu đủ thời gian dù không viết được số.

## 6. Xác nhận danh tính trên hồ sơ

| Mức `A` | Cách xác nhận |
|---:|---|
| 0 | chỉ đồng ý miệng; cần nguồn nhân chứng nếu hồ sơ yêu cầu |
| 1 | dấu cá nhân hoặc viết tên ngắn đã được đối tác biết; vẫn cần đọc lại nội dung |
| 2 | chữ ký ổn định và có thể đối chiếu các nét quen |
| 3 | xác nhận hồ sơ tổ chức, kiểm tư cách bên ký và ghi cách sửa/hủy |

Chữ ký chứng minh một hành vi xác nhận theo Evidence, không chứng minh nội dung đúng hay người ký có thẩm quyền. Dấu bị sao chép vẫn là vết vật lý; phát hiện giả cần mẫu, quan sát và kỹ năng riêng chưa đủ trong K1.9.

## 7. Ma trận năng lực chung lúc ngày 1, 06:00

`H/S/R/W/C/A` dùng các thang trên. Tất cả hiểu và nói LANG-AK ở mức ghi; không ai tự biết ngoại ngữ.

| ID | H | S | R | W | C | A | Căn cứ chính |
|---|---:|---:|---:|---:|---:|---:|---|
| P00 | 2 | 2 | 0 | 0 | 1 | 1 | FX-A-BOOT cần hội thoại/giao tiền; không có nguồn biết chữ |
| N01 Lâm | 3 | 3 | 1 | 1 | 1 | 1 | nghề hái, tuyến giao O01, H01; không giữ sổ |
| N02 Mai | 3 | 3 | 2 | 2 | 2 | 2 | quản kho H01, nhớ C01, nghề vải |
| N03 An | 4 | 4 | 4 | 3 | 3 | 3 | HIST:N03-TRAIN, quản O01, dạy Liên, giữ nợ |
| N04 Liên | 3 | 3 | 2 | 2 | 2 | 2 | học việc O01, nhãn/vệ sinh/hồ sơ ca được giao |
| N05 Bình | 3 | 3 | 2 | 2 | 2 | 2 | giao nhận, chứng từ, nhiều tuyến |
| N06 Hòa | 4 | 4 | 3 | 3 | 3 | 3 | giữ quầy, giá, vốn và sổ O04 |
| N07 Mộc | 3 | 3 | 2 | 2 | 2 | 2 | quản xưởng, kích thước/công việc, dạy Thu |
| N08 Thu | 3 | 3 | 1 | 1 | 1 | 1 | học việc xưởng, chưa giữ quyền bán/chi |
| N09 Sơn | 3 | 3 | 1 | 1 | 2 | 1 | theo lô/sản lượng; N12 giữ sổ |
| N10 Cúc | 3 | 3 | 2 | 2 | 2 | 2 | giống/dự trữ và kế hoạch mùa |
| N11 Đạt | 3 | 3 | 1 | 1 | 1 | 1 | HIST:N11-LITERACY chỉ giúp đọc hợp đồng cơ sở |
| N12 Nga | 4 | 4 | 3 | 3 | 3 | 3 | cân lượng, quyền kho, hợp đồng và sổ H02 |
| N13 Vân | 4 | 4 | 4 | 3 | 3 | 3 | người dạy O03, chương trình và duyệt quyền |
| N14 Kha | 3 | 3 | 2 | 2 | 2 | 2 | học Tĩnh Lưu và đọc phần V26 được dạy |
| N15 Tùng | 3 | 3 | 2 | 2 | 2 | 2 | học Liệt Mạch, ghi đề xuất/nghiên cứu giới hạn |
| N16 Yến | 4 | 4 | 4 | 3 | 3 | 3 | giữ kho/sổ O03, kiểm nguồn và chứng từ |
| N17 Dũng | 3 | 3 | 1 | 1 | 1 | 1 | hợp đồng hộ tống, báo tuyến ngắn |
| N18 Tâm | 3 | 3 | 2 | 2 | 3 | 2 | sổ O06, dấu kết cấu, dự toán/kiểm tuyến trong phạm vi |
| N19 Phúc | 3 | 3 | 2 | 2 | 3 | 2 | phòng, bữa, kho và 30 khoản thu |
| N20 Huệ | 3 | 3 | 2 | 1 | 2 | 1 | đưa tin, phân biệt lời gốc/suy đoán, nhãn người nhận |

Mức P00 là trạng thái nhân vật mẫu của INIT-A, không phải hạn chế bắt buộc cho mọi nhân vật do người chơi tạo sau này. Nếu người dùng chọn xuất thân khác, fixture phải tạo bộ năng lực và lịch sử nguồn khác rồi tăng phiên bản.

## 8. Mức thuật ngữ chuyên môn

Thang `K0–K3`: K0 chưa có; K1 nhận từ/câu cơ sở; K2 dùng trong công việc giới hạn; K3 giải thích/đánh giá trong miền đã học. K3 không tự trao quyền tổ chức.

| ID | TRADE | FARM | MED | CRAFT | CULT | ROAD |
|---|---:|---:|---:|---:|---:|---:|
| P00 | K1 | K1 | K0 | K0 | K0 | K1 |
| N01 | K1 | K1 | K2 | K1 | K0 | K2 |
| N02 | K2 | K1 | K1 | K2 | K0 | K1 |
| N03 | K2 | K0 | K3 | K0 | K1 | K1 |
| N04 | K1 | K0 | K2 | K0 | K0 | K1 |
| N05 | K2 | K1 | K1 | K1 | K0 | K3 |
| N06 | K3 | K1 | K0 | K1 | K1 | K2 |
| N07 | K2 | K0 | K0 | K3 | K0 | K2 |
| N08 | K1 | K0 | K0 | K2 | K0 | K1 |
| N09 | K1 | K3 | K0 | K1 | K0 | K2 |
| N10 | K2 | K3 | K0 | K1 | K0 | K1 |
| N11 | K1 | K2 | K0 | K0 | K0 | K1 |
| N12 | K3 | K3 | K0 | K0 | K0 | K2 |
| N13 | K2 | K0 | K1 | K0 | K3 | K1 |
| N14 | K1 | K0 | K0 | K0 | K2 | K1 |
| N15 | K1 | K0 | K0 | K0 | K2 | K1 |
| N16 | K3 | K0 | K0 | K0 | K3 | K1 |
| N17 | K2 | K0 | K1 | K1 | K0 | K3 |
| N18 | K2 | K0 | K1 | K2 | K0 | K3 |
| N19 | K3 | K1 | K0 | K1 | K0 | K1 |
| N20 | K2 | K2 | K0 | K0 | K0 | K2 |

P00 có K1 TRADE/FARM/ROAD nhờ kiến thức khởi đầu “cách hỏi việc”, tiền/suất và đường D01–D02; P00 chưa biết J01/D05/D11 trước FX-A-BOOT. Mức miền không tiết lộ địa điểm, người hay giá chưa được biết.

## 9. Hồ sơ nguồn và giới hạn từng người

### P00

- Giao tiếp LANG-AK đủ hỏi, nhận chỉ dẫn ngắn và thương lượng việc thường; thành ngữ/phán quyết dài cần hỏi lại.
- Không đọc/viết SCRIPT-AK ngày 1. P00 dùng `MARK:P00-INIT` sau khi tự chọn dấu đơn giản và nghe đọc lại toàn văn; dấu không chứa tri thức chữ.
- Có thể đếm tiền/vật nhỏ bằng thao tác trực tiếp, chưa tự cân sổ nhiều dòng.

### N01 Lâm và N02 Mai

- Lâm nhận nhãn, số quen và ghi dấu/tên ngắn; kiến thức cây chủ yếu từ truyền miệng, quan sát và thực hành HIST:N01-TRAIN.
- Mai đọc/ghi hợp đồng thường, đo/cộng lượng vải và quản mốc C01. Cô không hiểu chẩn đoán chỉ vì làm băng.
- Mai có thể giải thích quy trình vải K2; chưa có quyền chứng nhận học việc ngoài H01.

### N03 An và N04 Liên

- An R4 trong LEX-MED: đọc tài liệu y đã học, ghi ca và so sánh dấu hiệu; R4 không áp cho công pháp hoặc kết cấu cầu.
- An có năng lực dạy MED K3 và quyền đánh giá Liên theo O01.
- Liên đọc nhãn/hồ sơ ca thường, ghi quan sát cấu trúc; cô có thể chỉ thao tác vệ sinh đã được giao nhưng không chứng nhận chẩn đoán.

### N05 Bình và N06 Hòa

- Bình đọc chứng từ/tuyến, ghi lượng giao và hiểu thuật ngữ đường K3; không tự cân toàn bộ vốn O04.
- Hòa đọc/soạn sổ thương mại, tính nhiều dòng thường và thương lượng LANG-AK S4.
- Hòa có thể dạy thao tác quầy cơ sở theo nhiệm vụ nhưng quyền xác nhận thành viên O04 vẫn theo thể chế.

### N07 Mộc và N08 Thu

- Mộc R/W2, C2 nhưng K3 CRAFT: bản vẽ/đo lường quen có thể chứa ít chữ và nhiều dấu kỹ thuật. Ông dạy, phản hồi và đánh giá quy trình xưởng đã khai báo.
- Thu nhận nhãn, số đo và chép mẫu ngắn; K2 CRAFT đến từ thực hành. Cô chưa giải thích được mọi nguyên nhân sai hỏng.

### N09 Sơn, N10 Cúc, N11 Đạt và N12 Nga

- Sơn giỏi thực hành lô/đánh giá chín K3 nhưng chỉ đọc/ghi nhãn cơ sở; theo dõi số lượng C2 bằng vật/dấu lô.
- Cúc đọc/ghi kế hoạch ngắn, tính dự trữ và giải thích chọn giống K3 trong phần đã học.
- Đạt chỉ R/W1 từ HIST:N11-LITERACY; anh nhận điều khoản quen nhưng hợp đồng dài vẫn cần người đọc/giải thích.
- Nga giữ sổ H02 R/W/C3, giải thích giao dịch và phát hiện lệch; quyền kho không làm cô thành người dạy nghề ruộng K3.

### N13 Vân, N14 Kha, N15 Tùng và N16 Yến

- Vân R4 trong LEX-CULT, có năng lực và quyền dạy/đánh giá ba mẫu đã khai báo; không tự biết mọi công pháp thế giới.
- Kha/Tùng R2 chung, K2 CULT. Họ đọc phần V26 đã được giải thích, không tự hiểu đoạn ngoài KnowledgeUnit hoặc tự dạy người mới.
- Tùng có thể viết Proposal kỹ thuật giới hạn; văn bản không tự cấp quyền thử nghiệm.
- Yến R4 trong sổ/LEX-CULT vận hành, C3; có thể giải thích quy tắc kho nhưng không dạy cấu trúc tu luyện hoặc chứng nhận chuyển mức.

### N17 Dũng và N18 Tâm

- Dũng dùng dấu/tên ngắn, hiểu báo tuyến và điều kiện hộ tống; hợp đồng phức tạp cần được đọc lại.
- Tâm đọc/ghi sổ đường, tính vật tư/dự toán C3 và dùng K3 ROAD cho quy trình kiểm cầu đã học.
- Dũng/Tâm có thể hướng dẫn an toàn tuyến trong phạm vi kinh nghiệm; chỉ Tâm có quyền ghi kiểm tra O06 ngày 1.

### N19 Phúc và N20 Huệ

- Phúc đọc/ghi phòng, kho, thu chi thường; C3 đến từ nhiều khoản lặp và đối chiếu dự trữ.
- Huệ đọc thông báo thường R2, ghi tên/đích/câu ngắn W1 và tính tiền/lượng giao C2.
- Huệ có năng lực chuyển Message có cấu trúc, chưa có quyền sửa nội dung người giao. Lỗi Y-1 là nguồn cho thói quen tách trích dẫn khỏi suy đoán.

## 10. KnowledgeUnit — đơn vị tri thức có thể truyền

| Trường | Ý nghĩa |
|---|---|
| `content_id/version` | mệnh đề, quy trình hoặc khái niệm cụ thể; phiên bản nội dung |
| `domain/lexicon` | miền và thuật ngữ cần hiểu |
| `propositions` | các ý nhỏ có thể đúng/sai/điều kiện |
| `prerequisites` | kiến thức, giác quan, kỹ năng hoặc trải nghiệm cần trước |
| `modality` | lời nói, chữ, hình/dấu, quan sát thao tác, thực hành có phản hồi |
| `source_chain` | người/vật/sự kiện mà người học nhận từ đó |
| `comprehension` | phần người học tin mình hiểu và phần còn mơ hồ |
| `procedural_level` | nghe biết, nhận ra, làm có giám sát, làm giới hạn, dạy |
| `confidence` | độ chắc của Belief, không phải độ đúng khách quan |
| `last_used/reviewed` | mốc dùng/ôn gần nhất cho quên và cập nhật |

“J05 diễn ra ngày 9 lúc 13:00” là KnowledgeUnit mệnh đề. “Thực hiện Tĩnh Lưu” là một cụm quy trình gồm nhận biết, nhịp, dừng, phản hồi cơ thể và giới hạn nguồn; nghe tên không cấp cụm đó.

## 11. Pipeline giao tiếp

> ý định người nói → chọn nội dung mình biết → mã hóa LANG/SCRIPT + LEX → tín hiệu vật lý → người nhận cảm nhận → giải mã → hiểu/hiểu sai → Belief/Memory → phản hồi

Mỗi Message lưu:

- nội dung người nói định truyền và nội dung tín hiệu thực tế;
- ngôn ngữ, thuật ngữ, tốc độ/âm lượng hoặc kiểu chữ;
- môi trường và phần tín hiệu người nhận cảm nhận;
- nghĩa người nhận giải mã, phần không hiểu, suy luận thêm;
- nguồn mà người nhận tin là ai;
- có hỏi lại/đọc lại/xác nhận hay không.

Không dùng một phép “truyền tri thức” trực tiếp giữa hai id. Nếu người nghe không hiểu từ `Reservation`, họ có thể nhớ âm, hỏi nghĩa, đoán sai hoặc bỏ qua; hệ không tự chọn nghĩa đúng vì backend biết.

## 12. Sai lệch và kiểm tra hiểu

Nguồn sai lệch gồm:

- không nghe/nhìn đủ tín hiệu;
- thiếu từ vựng hoặc một từ nhiều nghĩa;
- câu điều kiện dài vượt mức H/R;
- người nói tóm thiếu, nhầm hoặc cố ý nói sai;
- người nhận gắn lời kể với sai người/vật/thời điểm;
- ký ức mất chi tiết sau thời gian;
- chép từ bản sai hoặc đọc nét chữ không quen.

`teach-back` là hành động người nhận diễn đạt lại điều mình hiểu. Người truyền so sánh với ý định và sửa từng khác biệt họ nhận ra. Teach-back giảm lỗi có thể quan sát, không bảo đảm kiến thức nguồn đúng.

Với hợp đồng có tiền/quyền, fixture yêu cầu đọc/giải thích lại ít nhất: bên, đầu ra, số lượng, hạn, giá, điều kiện nghiệm thu và cách hủy. Một dấu xác nhận trước khi hoàn tất các bước này không hợp lệ nếu bên xác nhận không tự đọc được.

## 13. Đọc, ghi và tính là hành động có tiến độ

Thời lượng cơ sở ở [[SO_THE_CHE_30_NGAY_K1]] áp cho người R/W2 với văn bản quen. Hệ số đề xuất:

| Điều kiện | Hệ số thời gian / hệ quả |
|---|---|
| R1 đọc mẫu quen | ×2; văn bản ngoài mẫu trả `unresolved_text` |
| R2 đọc thường | ×1 |
| R3 đọc/đối chiếu thường | ×0,8, tối thiểu thời gian lật/nhìn thật |
| W1 chép mẫu | ×2; không tự soạn điều khoản mới |
| W2 ghi mục thường | ×1 |
| W3 ghi/soát sổ | ×0,8, vẫn tiêu mực/vận động |
| thiếu LEX một mức | hiểu phần chữ chung; thuật ngữ giữ `unknown_sense` |
| C1 phép tính C2 | có thể dùng đếm vật từng món, tốn thêm thời gian; không tự cho kết quả |

Mệt, đau, ánh sáng, tay bận hoặc gián đoạn tác động tiến độ và lỗi. Giao diện mở văn bản không hoàn tất Action đọc nếu P00 chưa thực sự dành thời gian/điều kiện trong thế giới.

## 14. Tính toán, đơn vị và sai số

Phép tính có hồ sơ `CalculationAttempt`: đầu vào người tính biết, đơn vị họ dùng, phương pháp, vật hỗ trợ, kết quả chủ quan và kết quả kiểm chứng nếu có.

- C1 đếm 12 V01 bằng cách chuyển từng đồng; nhầm có thể xảy ra khi bị gián đoạn.
- C2 tính 8 V01 × 8 việc hoặc 2 V02 × 12 lần nếu biết đủ các dòng.
- C3 đối chiếu sổ O04/H02, phân biệt tiền giữ chỗ và đã chuyển.
- Không ai trong fixture được cấp C4; những mô hình nhiều biến dài hạn còn cần công cụ và học tập.

Máy game dùng số nguyên chính xác cho bảo toàn nhưng NPC chỉ hành động theo kết quả họ tính/nhận. Debug có thể so chủ quan với thật; giao diện chơi không tự hiện đáp án nếu P00 chưa biết.

## 15. Khả năng dạy và quyền chứng nhận

| Người | Có thể dạy | Có quyền đánh giá/chứng nhận trong fixture | Không tự dạy |
|---|---|---|---|
| N03 | MED tới phần quy trình O01 đã học | Liên trong phạm vi O01 | mọi bệnh/công pháp |
| N07 | CRAFT cho dụng cụ/mối ghép đã có mẫu | Thu trong O02 | mọi vật liệu/kết cấu |
| N09/N10 | FARM qua trình diễn/thực hành | việc ruộng H02, không cấp danh hiệu toàn vùng | sổ/thương mại chuyên sâu |
| N12 | TRADE/FARM về kho, lượng, giao việc | quyền thao tác kho H02 | chọn giống/chẩn đoán cây K3 |
| N13 | CULT cho ba mẫu đã khai báo | nhận học, chuyển mức O03 | mọi công pháp/cảnh giới |
| N16 | sổ, an toàn cấp nguồn, LEX-CULT vận hành | quyền kho/ghi O03 | kỹ thuật tu luyện/cấp tiến bộ |
| N18 | ROAD về kiểm tuyến/cầu trong quy trình | nhiệm vụ O06 được giao | mọi kỹ thuật xây dựng |
| N19 | sổ phòng/kho/bữa thường | thao tác O05 được giao | kế toán tổ chức phức tạp |
| người còn lại | chỉ dẫn hẹp đúng việc đã làm | không có quyền chứng nhận mặc định | kỹ năng ngoài nguồn |

Dạy cần KnowledgeUnit, thời gian, cơ hội, ví dụ/vật, quan sát người học và phản hồi. Một bài giảng chỉ truyền mệnh đề; kỹ năng tay/người/cơ thể cần PracticeEvent.

## 16. Học, củng cố và quên

Mỗi lần học tạo `LearningAttempt`:

1. kiểm điều kiện giác quan/ngôn ngữ/tiền đề;
2. người học chú ý trong thời gian thật;
3. nhận nội dung qua một hoặc nhiều modality;
4. thực hành/teach-back nếu nội dung yêu cầu;
5. người dạy đưa phản hồi họ có khả năng thấy;
6. cập nhật đúng phần KnowledgeUnit, độ chắc và lỗi còn lại.

Không dùng XP chung để mở mọi năng lực. R/W/C tăng qua các KnowledgeUnit và bài thực hành tương ứng. Quên giảm khả năng truy xuất/độ chính xác dựa trên thời gian, lần dùng và độ nổi bật; không xóa FactEvent nguồn hoặc kỹ năng cơ thể một cách tức thời.

Người dạy có thể truyền sai. Người học giỏi có thể phát hiện mâu thuẫn qua nguồn khác. Hệ giữ phiên bản nội dung và chuỗi nguồn để sửa không hồi tố ký ức cũ.

## 17. Áp lại sổ K1.8

| Sự kiện | Cách hợp lệ sau K1.9 |
|---|---|
| REC-P00-ROOM | N19 W2 ghi; P00 nghe đọc lại H2 và dùng MARK:P00-INIT A1 |
| J01 ngày 1–8 | N12 W3 ghi/giải thích S4; P00 H2 hỏi lại và dùng dấu; thời gian năm phút giữ nguyên |
| tiền trọ | P00/N19 đếm vật; N19 C3/W2 ghi; P00 không cần đọc sổ để tiền chuyển |
| N06 kể J05 ngày 6 | N06 S4/LEX-CULT K1 truyền giờ/nơi/phí; P00 H2 nhận mệnh đề, chưa học công pháp |
| P00 thấy NOTICE-J05 | P00 R0 chỉ nhận tờ có dấu/chữ, không biết nội dung nếu chưa được đọc cho |
| J05 ngày 9 | Vân S4/K3 giải thích; P00 teach-back phần điều kiện; Yến W3/C3 ghi quyền và phí |
| C01 ngày 10 | Mai/An R/W2+ và C2/3 tự đối chiếu; An viết nháp phần cố định khi Mai đang đi, sau giao dịch mới ghi sổ và hai bên xác nhận A2/A3 |
| O04 | Hòa R/W/C3 ghi; Bình R/W/C2 đối chiếu chứng từ chuyến; Dũng cần đọc lại điều kiện dài |
| O06 | Tâm R/W2, C3 ghi đề nghị; người hội đồng chỉ hiểu miền mình biết hoặc phải hỏi chuyên gia |

Điều kiện ST07 nay có kết quả rõ: P00 không đọc được NOTICE-J05 ở INIT-A. Overlay TC-X01 chỉ chạy qua nhánh có người đọc cho; Message phải lưu người đọc và lời thực tế.

## 18. Các nhánh lỗi ngôn ngữ

### NN-X01 — bỏ sót điều kiện nghiệm thu J01

N12 giải thích quá nhanh làm P00 chỉ hiểu “thu lô, nhận 8 đồng” nhưng không hiểu đủ 30 suất trước 16:30. Teach-back phát hiện thiếu trước xác nhận thì N12 sửa; không phát hiện thì Contract chưa đạt điều kiện đồng thuận đầy đủ và cần làm rõ, không âm thầm phạt P00.

### NN-X02 — từ “giữ” có hai nghĩa

Một Message nói N05 “giữ 20 V01” có thể bị hiểu là sở hữu. Bản có LEX-TRADE giải thích `custody` giúp tách chủ khỏi người mang; bản thiếu thuật ngữ tạo Belief sai nhưng không đổi Ownership.

### NN-X03 — Huệ trộn suy đoán vào tin

So sánh ba nội dung: lời nguồn, Message Huệ định nói và tín hiệu thật. Nếu Huệ thêm dự báo chưa có nguồn, người nhận lưu dự báo là lời Huệ; không gắn nó cho N18 hoặc biến thành thời điểm thật.

### NN-X04 — đọc nhầm số trên tờ cũ

Một nét bị ướt làm `9` có thể bị đọc thành số khác. Observation giữ hình nhìn thấy; R3 có thể phát hiện bất thường/đối chiếu IDX-J05, R1 có thể nhận mẫu sai. RNG chỉ chọn lỗi trong tập hình dạng/tình trạng cho phép, không bịa nội dung ngoài vết.

### NN-X05 — Kha đọc đoạn Liệt Mạch ngoài phần đã học

Kha R2 nhìn được chữ và K2 CULT, nhưng KnowledgeUnit/tiền đề thuộc Tùng. Kha có thể nhận từ riêng lẻ và biết mình không hiểu; không tự học kỹ thuật hay nhận năng lực dùng an toàn.

### NN-X06 — người giữ sổ tính đúng từ dữ liệu sai

Nga C3 cộng đúng các dòng nhưng một dòng đầu vào bị chép sai. CalculationAttempt là đúng theo đầu vào chủ quan; kho thật vẫn lệch. Đối chiếu vật/Transaction mới tìm nguồn sai, không giảm “trí thông minh” chung.

## 19. Giao diện và công cụ giải thích

Với mỗi câu/tờ/sổ, giao diện P00 có thể hiện:

- **đã nghe/đã thấy**, **đã hiểu**, **chưa rõ từ**, **đang suy đoán**;
- người/vật nguồn và thời điểm;
- nút hành động “hỏi lại”, “nhờ đọc”, “đối chiếu”, “đánh dấu để học” nếu khả dụng;
- bản tóm lược chỉ từ phần P00 đã hiểu.

Không hiện các con số H/S/R/W/C/A trực tiếp trong chế độ chơi nếu P00 chưa tự đánh giá. Có thể dùng mô tả: “Bạn nhận ra đây là chữ nhưng không đọc được”, “Bạn hiểu phần giá, còn điều kiện hủy có từ lạ”. Công cụ phát triển được xem toàn bộ pipeline để tìm lỗi.

Điện thoại chia nội dung dài thành các ý nhưng phải giữ cấu trúc điều kiện và nguồn; máy tính có thể đặt nguyên văn và phần hiểu cạnh nhau. Việc bấm mở/thu gọn không làm NPC đọc nhanh hơn hoặc tự nhận KnowledgeUnit.

## 20. Bất biến

1. Không suy năng lực đọc từ khả năng nói.
2. Không suy hiểu chuyên môn từ nhận mặt chữ.
3. Không truyền kỹ năng quy trình chỉ bằng một mệnh đề.
4. Không dùng quyền tổ chức thay năng lực, hoặc năng lực thay quyền.
5. Không cho người nhận biết nội dung tín hiệu họ không cảm nhận/giải mã.
6. Không sửa Ownership/FactEvent theo Belief sai ngôn ngữ.
7. Không dùng sổ đúng để xóa giao dịch thật, hoặc sổ sai để tạo giao dịch.
8. Không biến sao chép nhiều lần cùng nguồn thành bằng chứng độc lập.
9. Không cho giao diện/LLM thêm tri thức ngoài KnowledgeUnit đã cấu trúc.
10. Cùng trạng thái, tín hiệu và RNG phải cho cùng kết quả hiểu trên điện thoại/máy tính.

## 21. Điều kiện kiểm thử NL01–NL24

1. NL01 — P00 nói/nghe LANG-AK mức 2 nhưng R/W0; hội thoại không tự mở chữ.
2. NL02 — P00 thấy NOTICE-J05 chỉ biết có vật mang chữ nếu không ai đọc cho.
3. NL03 — Người đọc cho tạo Message riêng, giữ nguyên người nói và phần thực tế đã đọc.
4. NL04 — R2 thiếu LEX giữ thuật ngữ `unknown_sense`, không chọn nghĩa backend biết.
5. NL05 — R4 của An trong MED không cho An hiểu đoạn CULT chuyên sâu.
6. NL06 — Kha đọc chữ Liệt Mạch ngoài phần học không tự nhận kỹ thuật.
7. NL07 — P00 dùng dấu sau teach-back; dấu không chứng minh P00 tự đọc hợp đồng.
8. NL08 — J01 thiếu hiểu đầu ra/hạn không thành hợp đồng đầy đủ cho tới khi làm rõ.
9. NL09 — Tám cửa sổ xác nhận J01 vẫn khớp lịch sau giải thích/ghi/dấu.
10. NL10 — “N05 giữ tiền” không đổi Ownership khi người nghe hiểu sai.
11. NL11 — Một Message của Huệ tách lời nguồn, lời Huệ và suy đoán người nhận.
12. NL12 — Lời đồn sao chép giữ cùng source_chain, không tăng thành nhiều nguồn độc lập.
13. NL13 — C1 có thể đếm 12 V01 bằng vật/thời gian, không tự cân sổ C3.
14. NL14 — CalculationAttempt đúng theo dòng sai không sửa kho thật.
15. NL15 — Sổ O04 do Hòa ghi không cấp Hòa kiến thức MED/CRAFT.
16. NL16 — Yến giải thích quyền kho nhưng không thể dạy kỹ thuật tu luyện của Vân.
17. NL17 — PracticeEvent mới tăng kỹ năng thao tác; nghe tên công việc không tăng.
18. NL18 — Teach-back sửa phần hiểu sai quan sát được nhưng không chứng minh nguồn đúng.
19. NL19 — Mực, thời gian và Action đọc/ghi vẫn được tiêu theo hệ số năng lực.
20. NL20 — Body mất điều kiện nhìn/cầm làm Action thất bại dù SkillProfile đủ.
21. NL21 — Nội dung bị ướt chỉ gây các cách đọc phù hợp vết vật lý, không bịa ngẫu nhiên.
22. NL22 — Lưu/tải giữ nội dung tín hiệu, phần hiểu, phần mơ hồ, nguồn và tiến độ học.
23. NL23 — LLM diễn đạt không được thêm mệnh đề, quyền, kỹ năng hoặc nguồn.
24. NL24 — Cùng save/RNG/lệnh cho kết quả ngôn ngữ giống nhau trên điện thoại và máy tính.

Toàn bộ NL chưa chạy. Cộng 24 NL với 298 điều kiện trước đó cho **322 điều kiện thiết kế chưa chạy bằng mô phỏng**.

## 22. Giới hạn và bước kế tiếp

K1.9 chưa thiết kế ngoại ngữ, phương ngữ sâu, ngôn ngữ ký hiệu, chữ nổi, phép truyền âm thần thức, mã hóa công pháp, giả chữ/giám định, bệnh lý ngôn ngữ hoặc công cụ tính toán ngoài vật đếm. Các phần này cần cơ thể, văn hóa và cơ chế tu luyện cụ thể trước khi thêm.

K1/K2 đã được đóng gói tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]]; K3.1 nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
