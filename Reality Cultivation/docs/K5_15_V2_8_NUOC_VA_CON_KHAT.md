---
aliases:
  - V2.8 nước và cơn khát
tags:
  - trien-khai
  - co-the
  - kinh-te
---

# K5.15 — V2.8 nước và cơn khát của người lớn

## Kết quả có thể chơi

V2.7 dựng cơ thể người lớn nhưng để hở một chỗ đã ghi rõ trong hồ sơ: **nước được theo dõi mà không có hậu quả gì**. V2.8 đóng đúng chỗ đó.

### Người ta phải uống, và uống từ kho

Mỗi ngày lúc chốt sổ, người lớn uống nước lấy **từ kho của hộ** — không phải nước trên trời rơi xuống. Việc uống đi qua đúng ba cửa như mọi thứ khác trong game:

- **Quyền**: không có quyền dùng kho nước thì không uống được giọt nào.
- **Tồn kho**: kho cạn thì lấy được ít hơn mức cần, hoặc không lấy được gì.
- **Giới hạn cơ thể**: uống nhiều nhất 3.500 ml mỗi ngày dù thiếu bao nhiêu.

Nước uống bị trừ thật khỏi kho. Vì vậy nhu cầu nước của hộ nay tính cả phần người uống: từ 6.000 ml/ngày (chỉ nấu ăn) lên **13.500 ml/ngày** với ba người lớn — và kế hoạch phản ứng bằng cách xếp việc gánh nước gấp hơn hẳn.

### Khát ăn vào sức làm việc nhanh hơn đói

Sức làm việc nay do **thứ nào thiếu hơn** quyết định, chứ không nhân chồng lên nhau:

```
sức làm việc = min(sức theo cân nặng, sức theo lượng nước)
```

| Trục | Đầy sức | Còn nửa sức | Kiệt |
| --- | --- | --- | --- |
| Cân nặng | 100% | 85% | 70% |
| Lượng nước | 100% | **90%** | **80%** |

Chênh lệch đó là có chủ ý: mất 10% nước cơ thể đã nguy, còn sụt 10% cân thì chưa. Nên trong lượt chạy, người bị chặn quyền dùng kho nước tụt xuống **sức làm việc 0/1000 sau ba ngày**, trong khi người đói sáu ngày ở V2.7 vẫn còn 970/1000.

Cơn khát cũng vào ngưỡng nhận việc, nặng hơn đói:

```
ngưỡng = mệt/10  +  khát/15  +  đói/20  +  (1000 − tâm trạng)/25
```

## Hai lượt chạy đối chiếu

**Bị chặn quyền:** người làm công không có quyền dùng kho nước → uống 0 ml → sau ba ngày đủ nước còn 653/1000, sức làm việc 0/1000, ngưỡng nhận việc 131. Cả nhà vẫn uống bình thường; chỉ mình anh ta khát.

**Kho cạn:** kho chỉ có 9.000 ml và **không ai đủ nghề đi gánh** → kho cạn sạch → nhiều người cùng thiếu nước.

Đáng nói: ở lượt chạy bình thường, hệ thống **tự cứu được** — nhu cầu nước gấp lên nên kế hoạch cử người đi gánh về trước khi ai kịp khát. Giống hệt chuyện lương thực ở V2.6: hỏng chỉ xảy ra khi thiếu đúng thứ không thay thế được, là **quyền** hoặc **tay nghề**.

## Trạng thái máy mới

- `AdultBodyState`: thêm `hydration`, `thirst`, `massCapability`, `waterCapability`, `dehydrated`, `drinkNeedMl`, `drink()` và `totalDrunkMl`. `capability` nay là mức thấp hơn giữa hai trục.
- `PersonAgenda.thirst`: cơn khát do cơ thể quyết định, vào thẳng ngưỡng nhận việc; `mainStrain` nay xét cả bốn trục.
- Nhịp dùng nước của hộ tính động theo số người lớn có cơ thể, nên thế giới không có cơ thể giữ nguyên con số cũ.

Sự kiện mới: `body_drank`, `body_dehydrated`.

## Giao diện

Hồ sơ từng người hiện mức đủ nước, cảnh báo thiếu nước, tổng số nước đã uống, và **thứ đang chặn sức làm việc** là cân nặng hay nước. Bốn trục sức lực (mệt, đói, khát, tâm trạng) hiện đủ. Nhật ký thêm hai mốc mới.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.8 đạt tới ngày 5; lưu lúc ngày 2 khi đã có người thiếu nước rồi chạy tiếp cho cùng hash `469fab7582a4aa34`.
- **Mười runner V0–V2.6 giữ nguyên hash** (đều là thế giới không có cơ thể người lớn).
- **Hash V2.7 đổi `e59171aea8e9867b` → `dc54cde35203486a`.** V2.7 là fixture duy nhất có cơ thể, nên cũng là fixture duy nhất chịu ảnh hưởng khi mô hình cơ thể được hoàn thiện thêm; toàn bộ điều kiện V2.7 vẫn đạt. Đây là mở rộng mô hình có chủ đích, không phải sửa lỗi như hai lần trước.
- Catalog `game/artifacts/conditions/v2_8_water_and_thirst.json` có 22 điều kiện.
- 12/12 widget test đạt.
- Web release đã đóng gói lại.

## Điều cố ý không làm: thân nhiệt

Bước tiếp theo trong hồ sơ có ghi cả thân nhiệt người lớn. **Tôi bỏ phần đó.**

Trẻ sơ sinh có thân nhiệt vì có nhiệt độ môi trường để phản ứng lại. Người lớn thì chưa: chưa có mùa, chưa có thời tiết, chưa có nhiệt độ trong nhà so với ngoài sân. Làm thân nhiệt bây giờ là **bịa ra một con số không phản ứng với gì cả**, đúng loại việc mà [[MASTER_PLAN]] gọi là mô phỏng không tạo khác biệt có ích.

Thân nhiệt nên chờ có mô hình môi trường trước — nó thuộc về [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]] chứ không phải một trường thêm vào cơ thể.

## Giới hạn và bước tiếp theo

Nước vẫn chỉ đổi mỗi ngày một lần: không ai khát giữa buổi làm, và uống là một lần duy nhất lúc chốt sổ chứ không rải trong ngày. Chưa có nước bẩn, chưa có bệnh do nước, chưa có mất nước do sốt (trẻ sơ sinh đã có, người lớn thì chưa vì người lớn chưa ốm được).

Ngưỡng 90%/80% cho sức theo nước, mức uống tối đa 3.500 ml, 2.500 ml mỗi người mỗi ngày trong tính nhu cầu, và trọng số khát/15 đều là fixture kỹ thuật — **không phải mô hình sinh lý y khoa**.

Bước tiếp theo đề xuất: mở tuyến vận tải thật có vị trí trung gian, hoặc cho người lớn ốm được như trẻ sơ sinh.

## Liên kết

- Bản trước: [[K5_14_V2_7_CO_THE_NGUOI_LON]]
- Cơ thể sâu (thiết kế): [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]
- Môi trường và khí hậu (thiết kế): [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
