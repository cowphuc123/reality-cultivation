---
aliases:
  - V2.11 bệnh của người lớn
tags:
  - trien-khai
  - co-the
  - npc
---

# K5.18 — V2.11 bệnh của người lớn

## Kết quả có thể chơi

Từ V2.1, chỉ trẻ sơ sinh ốm được. Người lớn có cơ thể (V2.7), có nước (V2.8), sụt cân và kiệt sức được — nhưng không bao giờ đổ bệnh. V2.11 đóng chỗ đó.

### Bệnh đến từ trạng thái cơ thể, không từ hẹn giờ

Đây là điểm đáng nói nhất. Bệnh của trẻ sơ sinh ở V2.1 khởi phát theo **một cái hẹn giờ trong fixture**: ngày 3 lúc 09:00. Bệnh người lớn thì không — nó đến khi cơ thể vượt giới hạn:

| Nguyên nhân | Điều kiện | Mức nặng |
| --- | --- | --- |
| **Mất nước** | đủ nước ≤ 700/1000 | 300 + phần thiếu, tối đa 800 |
| **Kiệt sức** | mệt ≥ 900/1000 | 250 + phần vượt, tối đa 600 |

Mốc khởi phát ghi lại **chính con số đã gây ra bệnh**, nên truy được:

```
adult_illness_onset [N03] cause=mat_nuoc severity=347 hydration=653 fatigue=1000
adult_illness_onset [N01] cause=kiet_suc severity=322 hydration=1000 fatigue=972
```

Hai ca này khác nhau hoàn toàn về nguồn gốc: N03 không có quyền lấy nước khỏi kho nên khát dần; N01 làm gần mười tiếng mỗi ngày nên mệt dồn. Không đoạn nào viết sẵn.

**Vì sao dùng ngưỡng xác định thay vì xác suất:** dự án lưu `seed` nhưng chưa có bộ sinh số ngẫu nhiên nào tiêu thụ nó. Bịa ra một phép ngẫu nhiên tại đây sẽ phá tính tái lập mà cả 16 bộ chạy đang dựa vào. Ngưỡng xác định là cách trung thực nhất cho bản này; xác suất theo seed thuộc về K2.1 và nên làm cùng bộ RNG chung.

### Bệnh có ba hậu quả thật

1. **Kéo sức làm việc xuống**: bệnh nặng 1000 lấy đi một nửa sức. Đây là chỗ đo sạch nhất — N01 ốm vì kiệt sức nhưng cơ thể còn nguyên 1000 sức về cân nặng và nước, nên **phần hụt của sản lượng chỉ có thể đến từ bệnh**.
2. **Đốt thêm năng lượng và nước**: bệnh nặng 500 đốt thêm đúng 500 kJ và mất thêm 500 ml mỗi ngày, ngay trong nhịp ngày của cơ thể.
3. **Khó nhận việc hơn**: mức bệnh chia mười cộng thẳng vào ngưỡng nhận việc của V2.6.

Vì sức làm việc chảy vào tốc độ đi đường (V2.9) và chọn tuyến (V2.10), một người chở đang ốm sẽ đi chậm hơn và có thể bị chặn khỏi những chặng đòi sức.

### Chăm bệnh đi qua đúng các cửa đã có

Người chăm phải **khác người bệnh**, **không đang ốm**, và **có quyền lấy nước** khỏi kho hộ; chọn theo kỹ năng chăm sóc cao trước. Chăm một lượt tiêu 400 ml nước thật và hạ mức bệnh; nước đó cũng bù lại phần cơ thể đang thiếu.

Nếu không ai đủ điều kiện — ví dụ cả nhà đều mất quyền dùng kho nước — hộ ghi `adult_illness_unattended` và bệnh **không tự khỏi**.

Diễn tiến và lui bệnh dùng lại nguyên cơ chế `illness_progress` đã có từ V2.1, không viết lại.

## Một vòng lặp đáng chú ý đã lộ ra

Lượt chạy cho thấy N01 ốm vì kiệt sức ở ngày 5, được chăm, rồi **ốm lại ở ngày 7 và ngày 9**. Nguyên nhân: chăm bệnh hạ mức bệnh nhưng không hạ mức mệt, và **ốm không làm người ta nghỉ việc** — khối "may vá" trong bảng giờ vẫn chạy đúng giờ.

Đây là hành vi thật của mô hình hiện tại, không phải lỗi: bệnh nâng ngưỡng nhận **việc mới** từ kế hoạch, nhưng không hủy cam kết cũ. Nó cũng là một vòng kiệt sức khá giống thật. Nhưng nó chỉ ra mắt xích còn thiếu rõ nhất: **người ốm phải được nghỉ** — nay đã làm ở [[K5_19_V2_12_NGHI_BENH]].

## Trạng thái máy mới

- `HouseholdState.adultIllness`: cờ bật theo dõi, đọc từ `enable_v2_11`.
- `AdultBodyState.advanceDay` nhận `illnessSeverity` để cộng tiêu hao.
- `Simulation._activeIllness`, `_effectiveCapability`: sức lực thật sau khi trừ bệnh, dùng chung cho người chở, sản lượng kế hoạch và ngưỡng nhận việc.
- Bệnh người lớn đánh id `ILL-<người>-<số>`, mỗi người tối đa một ca đang hoạt động.

Sự kiện mới: `adult_illness_onset`, `adult_illness_detected`, `adult_illness_care_completed`, `adult_illness_care_failed`, `adult_illness_unattended`.

## Giao diện

Nhật ký thêm năm mốc bệnh người lớn bằng tiếng Việt, nói rõ nguyên nhân ("đổ bệnh vì mất nước") kèm cả ba con số cơ thể. Hồ sơ hiện tên bệnh dịch sang tiếng Việt: *Kiệt nước*, *Kiệt sức vì làm quá*. Nhóm lọc **Chăm sóc** gồm cả bệnh người lớn.

Thế giới khởi tạo của client nay bỏ quyền lấy nước của N03, nên trong lượt chơi thật sẽ thấy anh ta khát dần rồi đổ bệnh — và N01 kiệt sức vì làm quá.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.11 đạt tới ngày 10; lưu lúc người lớn đang ốm rồi chạy tiếp cho cùng hash. Hash ban đầu là `e81de5a0e3d29c55`; từ V2.12 đổi thành `beabb8f20438f377` khi người ốm được nghỉ, xem [[K5_19_V2_12_NGHI_BENH]]. Mọi điều kiện V2.11 vẫn đạt.
- **Mười lăm runner V0–V2.10 giữ nguyên hash** nhờ cờ `enable_v2_11`.
- Catalog `game/artifacts/conditions/v2_11_adult_illness.json` có 21 điều kiện.
- 15/15 widget test đạt.
- Web release **chưa** đóng gói lại và **chưa** đẩy lên GitHub, theo cách làm mới.

## Giới hạn và bước tiếp theo

**Ốm không làm người ta nghỉ** — như mô tả ở trên, đây là chỗ hở lớn nhất và nên là việc tiếp theo.

Bệnh chưa lây: hai người cạnh nhau, một người ốm, người kia không sao. Chưa có thuốc, chưa có thầy thuốc, chưa có kỹ năng chữa (kỹ năng chăm sóc hiện chỉ dùng để chọn người, không ảnh hưởng kết quả). Chưa có thương tích, chưa có già đi, chưa có chết — ốm nặng đến đâu cũng chỉ giảm sức làm việc.

Chỉ có hai loại bệnh, đều từ hai nguyên nhân đã cài. Chưa có bệnh theo mùa, theo nước bẩn, hay theo tiếp xúc.

Ngưỡng 700 cho nước và 900 cho mệt, sàn mức nặng 300/250, trần 800/600, 400 ml mỗi lượt chăm và tỉ lệ "mức bệnh chia hai lấy đi sức" đều là fixture kỹ thuật — **không phải mô hình y khoa** và chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho người ốm được nghỉ việc thật (hủy hoặc lùi khối trong bảng giờ), rồi tới lây bệnh hoặc thuốc.

## Liên kết

- Bản trước: [[K5_17_V2_10_HAI_CHIEU_VA_NGA_RE]]
- Bệnh của trẻ sơ sinh: [[K5_8_V2_1_BENH_NHE_TIEP_TE_KHONG_GIAN_DOI_LICH]]
- Cơ thể người lớn: [[K5_14_V2_7_CO_THE_NGUOI_LON]]
- Nước và cơn khát: [[K5_15_V2_8_NUOC_VA_CON_KHAT]]
- Cơ thể sâu (thiết kế): [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
