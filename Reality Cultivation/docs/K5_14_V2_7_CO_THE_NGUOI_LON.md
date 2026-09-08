---
aliases:
  - V2.7 cơ thể người lớn
tags:
  - trien-khai
  - co-the
  - npc
---

# K5.14 — V2.7 cơ thể người lớn: ăn, đốt, sụt cân và yếu đi

## Kết quả có thể chơi

Từ V1.2 trẻ sơ sinh đã có cơ thể chạy từng giờ, nhưng người lớn thì không: đói của họ chỉ là một con số đếm bữa, không có hậu quả thể chất. V2.7 khép chỗ chênh đó.

Người lớn nay có cơ thể thật ở **độ phân giải ngày** — thô hơn trẻ sơ sinh vì trong một ngày ăn ba bữa và làm một buổi thì các số chỉ đổi chậm:

- **Bữa ăn nuôi thật.** Một bữa 500 g lương thực ở mức 1.400 kJ/100 g cho 7.000 kJ, chia đều cho người lớn trong hộ. Năng lượng vào dự trữ, nước vào cơ thể.
- **Ngày trôi thì đốt.** Lúc chốt sổ lao động 22:00, mỗi cơ thể đốt 5.500 kJ nền cộng 200 kJ cho mỗi giờ **thật sự đã lao động** — số giờ này lấy từ các khối việc đã hoàn thành, không phải lịch dự kiến.
- **Hết dự trữ mới ăn vào người.** Thiếu 30 kJ thì sụt 1 g. Dư dả thì đổi ngược lại, nhưng lên cân khó hơn: 45 kJ mới được 1 g.

## Đói nay có hậu quả thể chất

Sụt cân kéo theo **sức làm việc** giảm, theo một quy tắc số chứ không phải nhãn:

| Cân nặng so với lúc khỏe | Sức làm việc |
| --- | --- |
| 100% | 1000/1000 |
| 85% | 500/1000 |
| 70% trở xuống | 0 |

Sức làm việc nhân thẳng vào sản lượng dự kiến. Nên nay có hai thứ khác nhau quyết định một người làm ra bao nhiêu: **tay nghề** (biết làm) và **sức lực** (còn làm nổi). Người giỏi nhưng đói vẫn làm ra ít.

Cơn đói trong hồ sơ cũng không còn là bộ đếm bữa riêng nữa — khi có cơ thể, nó **suy từ dự trữ còn lại**, nên chỉ có một nguồn sự thật.

## Chuỗi đói khép kín

Lượt chạy nhà đói sáu ngày, không đoạn nào viết sẵn:

> Cả nhà không ai đủ nghề kiếm lương thực → kho không đầy lại → bữa hụt liên tiếp → dự trữ vơi dần rồi cạn → **N03 sụt 767 g**, còn 51.233 g → sức làm việc còn **950/1000** → sản lượng dự kiến hôm sau thấp hơn → kho càng khó đầy.

Nhà đủ ăn thì ngược lại: N01 ăn 6.999 kJ và đốt 7.700 kJ trong ngày đầu, dự trữ vơi một ít rồi được bù lại ở những ngày làm ít hơn.

## Trạng thái máy mới

- `AdultBodyState`: khối lượng, khối lượng lúc khỏe, dự trữ năng lượng, nước cơ thể, tổng đã ăn, tổng đã đốt, tổng đã sụt; các hàm `eat`, `advanceDay`, `recover` và hai đại lượng suy ra `capability` / `hunger`.
- `PersonState.body`: cơ thể người lớn, không bắt buộc — người không khai báo thì giữ nguyên hành vi cũ.
- `PersonAgenda.workedSecondsToday`: sổ giờ lao động trong ngày, mở lại mỗi sáng; chỉ ghi cho người có cơ thể để nuôi.
- Payload `adult_body` nhận `mass_g`, `healthy_mass_g` và `energy_reserve_kj` — nhà nghèo có thể bắt đầu với ít mỡ dự phòng.

Sự kiện mới: `body_mass_lost`.

## Giao diện

Hồ sơ từng người lớn hiện cân nặng, phần thiếu so với lúc khỏe, dự trữ năng lượng, sức làm việc và tổng số gam đã sụt vì thiếu ăn. Nhật ký thêm mốc **Sụt cân vì thiếu ăn**, nằm trong nhóm lọc Chăm sóc.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.7 đạt tới ngày 6; lưu lúc ngày 3 khi dự trữ đã vơi rồi chạy tiếp cho cùng hash. Hash ban đầu là `e59171aea8e9867b`; từ V2.8 đổi thành `dc54cde35203486a` khi nước có hậu quả, xem [[K5_15_V2_8_NUOC_VA_CON_KHAT]]. Mọi điều kiện V2.7 vẫn đạt.
- **Mười một runner V0–V2.6 giữ nguyên hash.** Lần này cần một bước cẩn thận: sổ giờ lao động ban đầu ghi cho mọi người có hồ sơ sức lực, làm đổi hash V2.5/V2.6; đã sửa để chỉ ghi khi người đó thật sự có cơ thể cần nuôi.
- Catalog `game/artifacts/conditions/v2_7_adult_body.json` có 22 điều kiện.
- 11/11 widget test đạt, gồm bài mới cho bữa ăn nuôi cơ thể.
- Web release đã đóng gói lại.

## Giới hạn và bước tiếp theo

Cơ thể người lớn chạy theo **ngày**, nên trong ngày không có diễn biến: không ai đói giữa buổi, không ai kiệt sức đột ngột khi đang làm. Nước cơ thể được theo dõi nhưng **chưa có hậu quả** — mất nước chưa gây gì cả. Chưa có thân nhiệt, chưa có bệnh của người lớn (bệnh hiện chỉ có ở trẻ sơ sinh), chưa có thương tích, chưa có già đi hay chết.

Suất ăn chia đều tuyệt đối; chưa ai được ưu tiên, chưa ai nhường phần, chưa có khẩu phần theo cân nặng hay theo việc nặng nhẹ.

Các hệ số 1.400 kJ/100 g, nền 5.500 kJ/ngày, 200 kJ/giờ lao động, 30 kJ mỗi gam sụt và 45 kJ mỗi gam lên, cùng dải sức làm việc 70–100% cân nặng, đều là fixture kỹ thuật — **không phải mô hình dinh dưỡng y khoa** và chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho nước và thân nhiệt của người lớn có hậu quả như năng lượng đã có, hoặc chuyển sang mở tuyến vận tải thật có vị trí trung gian.

## Liên kết

- Bản trước: [[K5_13_V2_6_LEN_TAY_NGHE_DOI_VA_TAM_TRANG]]
- Cơ thể sơ sinh chạy từng giờ: [[K5_5_V1_2_CO_THE_SINH_LY_SO_SINH]]
- Cơ thể sâu (thiết kế): [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
