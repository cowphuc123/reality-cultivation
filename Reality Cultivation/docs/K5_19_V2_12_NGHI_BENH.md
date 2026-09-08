---
aliases:
  - V2.12 nghỉ bệnh
tags:
  - trien-khai
  - npc
  - lich
  - co-the
---

# K5.19 — V2.12 người ốm được nghỉ thật

## Vì sao làm cái này

V2.11 cho người lớn ốm được, và lộ ra ngay một vòng lặp hỏng: N01 ốm vì kiệt sức ngày 5, được chăm, rồi **ốm lại ngày 7 và ngày 9**. Nguyên nhân là bệnh nâng ngưỡng nhận *việc mới* nhưng không hủy cam kết cũ — khối "may vá" trong bảng giờ vẫn chạy đúng giờ, nên người ta vừa được chăm xong lại đi làm mười tiếng.

Tôi ghi đó là chỗ hở lớn nhất. V2.12 đóng nó.

## Nghỉ tới khi khỏi, không theo một con số tuỳ ý

Cách làm không cần cơ chế mới: **ốm trở thành một nghĩa vụ chen chỗ**, đi qua đúng máy móc lùi–xếp lại–bỏ đã có từ V2.5. Khối việc của người đang ốm bị lùi 30 phút mỗi lần, tối đa ba lần, rồi bỏ hẳn trong ngày nếu không còn giờ trống.

Lần đầu tôi lấy **mức nặng** làm ngưỡng nghỉ (≥ 300) và nó hỏng ngay: một lượt chăm hạ mức nặng từ 322 xuống 202 **trong bốn mươi phút**, tụt dưới ngưỡng, nên hôm sau người ta lại đi làm và ốm lại — đúng cái vòng lặp cần phá. Luật đúng là **nghỉ cho tới khi khỏi hẳn**. Lượt chạy xác nhận: vẫn còn nghỉ ở mức nặng **55/1000**, tức là gần khỏi mà chưa khỏi.

## Nghỉ có tác dụng, và có giá

| | V2.11 (không nghỉ) | V2.12 (có nghỉ) |
| --- | --- | --- |
| Mệt mỏi cuối kỳ của N01 | **1000** — kịch trần vĩnh viễn | **500** |
| Khoảng cách giữa hai lần ốm | 2 ngày | 5 ngày |

Cái giá cũng là số thật: N01 mất **223.773 giây công** (hơn 62 giờ) và **bỏ hẳn 6 khối việc** trong mười ngày. Kỳ nghỉ được ghi thành xung đột lịch có tên việc bị bỏ, nên đọc được ai mất gì.

## Điều lượt chạy nói ra mà tôi không đặt trước

**Nghỉ không cứu được một lịch vốn không bền.** N01 làm 10,3 giờ mỗi ngày: mỗi ngày cộng 516 điểm mệt, một đêm chỉ hồi 250. Nghỉ giãn vòng ốm từ 2 ngày lên 5 ngày nhưng không dứt được, vì cân bằng của lịch đó nằm ở phía "luôn kiệt sức". Mô hình đang báo đúng rằng **lịch làm việc là vấn đề, không phải bệnh**.

Kèm theo một kết quả trái trực giác đáng ghi: cuối kỳ N01 (làm 10,3 giờ) mệt **500**, còn N02 (làm 6 giờ) mệt **871**. Người làm quá sức nghỉ nhiều đến mức lại đỡ mệt hơn người làm vừa phải nhưng không bao giờ được nghỉ. Đây là hành vi thật của mô hình hiện tại, không phải điều tôi cân bằng cho đẹp.

**Nghỉ bệnh còn làm chậm việc mất nước.** Trong thế giới client, N03 không có quyền lấy nước. Ở V2.11 anh ta mất nước tới mức đổ bệnh vào **ngày 3**; ở V2.12 là **ngày 8** — vì nghỉ bệnh làm anh ta thôi cày mười hai tiếng, nên mất nước theo mức nền thay vì mức lao động. Chuỗi đi qua bốn hệ: bệnh → nghỉ → không lao động → mất nước chậm.

## Một đoạn code chết đã bị bỏ

Tôi từng viết thêm phần "đang làm dở mà đổ bệnh thì dừng ngay". Bài test lộ ra nó **không bao giờ với tay được**: bệnh khởi phát ở mốc chốt ngày 22:00, khi mọi khối việc trong ngày đã xong. Tệ hơn, cái mốc nghỉ nó đặt còn bị vòng chăm trẻ xoá mất, vì `resume` dùng chung cho mọi kiểu cắt ngang.

Đã bỏ đoạn đó. Việc chặn nghỉ do `_competingObligation` lo, và nó chặn từ khối đầu tiên của hôm sau — đúng như thực tế mô hình.

## Trạng thái máy mới

- `_competingObligation` nay trả về `nghỉ vì ốm (mức/1000)` khi người đó còn bệnh hoạt động, nên toàn bộ máy móc lùi–xếp lại–bỏ của V2.5 áp dụng luôn cho nghỉ bệnh.
- `illness_rest_ended`: mốc kết thúc kỳ nghỉ khi bệnh lui hẳn.

Không thêm trạng thái lưu mới nào — đây là lát cắt dùng lại máy móc cũ, không dựng thêm.

## Giao diện

Nhật ký nay đọc "phải lùi may vá vì **đang nghỉ bệnh**" và "mất hẳn may vá hôm nay vì **phải nghỉ bệnh**" thay vì in ra chuỗi lý do thô. Thêm mốc **Khỏi bệnh, đi làm lại**. Hồ sơ người lớn đang ốm nói rõ: *"Đang nghỉ bệnh, chưa nhận việc cho tới khi khỏi."*

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.12 đạt tới ngày 10; lưu giữa kỳ nghỉ bệnh rồi chạy tiếp cho cùng hash `f57b6f0fb06205bb`.
- **Mười lăm runner V0–V2.10 giữ nguyên hash.**
- **Hash V2.11 đổi `e81de5a0e3d29c55` → `beabb8f20438f377`** vì người ốm nay được nghỉ; toàn bộ điều kiện V2.11 vẫn đạt.
- Catalog `game/artifacts/conditions/v2_12_illness_rest.json` có 19 điều kiện.
- 16/16 widget test đạt. Bài test V2.11 phải nới mốc từ ngày 6 lên ngày 10 vì nghỉ bệnh đẩy lùi ngày mất nước.
- Web release **chưa** đóng gói lại và **chưa** đẩy lên GitHub, theo cách làm mới.

## Giới hạn và bước tiếp theo

Nghỉ hiện là **tất cả hoặc không có gì**: ốm thì không làm gì cả, khỏi thì làm đủ. Chưa có làm nhẹ, chưa có làm nửa buổi, chưa có ai gánh việc thay theo nghĩa vụ (kế hoạch có thể chào việc cho người khác, nhưng khối cố định của người ốm thì chỉ mất chứ không chuyển sang ai).

Khối bị bỏ vì nghỉ bệnh không được làm bù ngày sau — nó mất hẳn. Người ốm cũng không tự sửa lịch của mình cho nhẹ hơn, vì bảng giờ vẫn là dữ liệu cố định chứ chưa phải thứ NPC tự thương lượng.

Ngưỡng "nghỉ tới khi khỏi", bước lùi 30 phút và trần ba lần lùi đều là fixture kỹ thuật kế thừa từ V2.5, chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho người khác gánh việc của người đang nghỉ (chuyển khối cố định, không chỉ chào việc mới), hoặc bắt đầu bản đồ vùng để `WorldPoint` có chỗ dùng thật.

## Liên kết

- Bản trước: [[K5_18_V2_11_BENH_CUA_NGUOI_LON]]
- Máy móc lùi và xếp lại việc: [[K5_12_V2_5_KY_NANG_NGHE_VA_QUYEN_TU_CHOI]]
- Nước và cơn khát: [[K5_15_V2_8_NUOC_VA_CON_KHAT]]
- Cơ thể sâu (thiết kế): [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
