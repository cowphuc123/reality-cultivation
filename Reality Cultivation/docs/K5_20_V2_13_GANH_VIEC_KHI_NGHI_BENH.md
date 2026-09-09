---
aliases:
  - V2.13 gánh việc khi nghỉ bệnh
tags:
  - trien-khai
  - npc
  - lich
  - ho-gia-dinh
---

# K5.20 — V2.13 gánh việc khi nghỉ bệnh

## Mục tiêu

V2.12 cho người ốm nghỉ thật nhưng ca cố định của họ chỉ bị lùi, xếp lại hoặc mất hẳn. V2.13 khép thêm một mắt xích: sau ba lần lùi vì bệnh, hộ thử chuyển ca cố định cho một thành viên khác thay vì mặc nhiên mất toàn bộ công việc.

Đây là chuyển **một cam kết đã có trong lịch**, khác với V2.4–V2.6 vốn chỉ chào việc mới sinh từ nhu cầu kho.

## Điều kiện để nhận thay

Một thành viên chỉ được xét khi đồng thời:

- cùng hộ và không phải người đang bệnh;
- là người lớn, có lịch hoạt động;
- đang khỏe, không bị nghĩa vụ khác giữ chân;
- có quyền dùng vật phẩm kho mà ca sẽ bổ sung;
- đạt tay nghề tối thiểu 200 ở nghề ca yêu cầu;
- còn một khoảng giờ trống đủ dài trong ngày;
- tự chấp nhận mức ưu tiên của ca theo mệt, đói, khát và tâm trạng hiện tại.

Ứng viên được xét theo tay nghề từ cao xuống thấp, rồi theo ID để kết quả luôn tái lập. Người giỏi nhất vẫn có thể từ chối; hệ thống sẽ chào người tiếp theo.

## Ca mới giữ lại những gì

Khối `COVER-...` giữ nguyên hoạt động, thời lượng, phòng, mức ưu tiên, tính chặn lịch, nhu cầu, nguồn lực đích, sản lượng và nghề yêu cầu. Nó chỉ sống trong ngày chuyển ca. Khi hoàn tất, sản lượng đi vào đúng vật phẩm kho thật và người nhận chịu mệt, ghi giờ, lên tay nghề như mọi ca khác.

Người bệnh ghi một `ScheduleConflict` nói rõ ca đã chuyển cho ai. Nhật ký thế giới có ba mốc mới:

- `routine_block_reassigned`;
- `work_substitution_refused`;
- `routine_block_reassignment_failed`.

Nếu không ai hợp lệ, hệ thống ghi thất bại rồi quay về cách xử lý V2.12: thử xếp lại cho chính người giữ ca, sau đó mới bỏ.

## Fixture kiểm chứng

N01 làm quá sức trong ngày đầu và đổ bệnh. Sáng hôm sau, ca gom củi 3 giờ bị lùi ba lần:

- N02 có nghề 900 nhưng quá mệt nên từ chối ca ưu tiên 70;
- N04 chỉ có nghề 100 nên bị loại;
- N03 có nghề 700, khỏe, có quyền với kho củi và còn giờ trống nên nhận;
- ca chạy từ 08:30, giao đủ 1.200 đơn vị củi vào kho.

Mọi số, ngưỡng và lịch trong fixture vẫn là dữ liệu kỹ thuật chưa được người dùng duyệt làm cân bằng.

## Trạng thái máy và tương thích

- `RoutineBlock.requiredSkill` là trường lưu tùy chọn.
- `HouseholdState.workSubstitution` chỉ bật bởi `enable_v2_13`.
- Tắt cờ giữ nguyên hành vi V2.12.
- Lưu giữa lúc ca gánh thay đang chạy rồi nạp lại cho cùng kết quả.
- 17 runner V0–V2.12 giữ nguyên toàn bộ hash.

Runner V2.13 đạt ngày 3 với hash `edf67b2b36cda0eb`. Catalog `game/artifacts/conditions/v2_13_work_substitution.json` có 20 điều kiện.

## Giao diện

Nhật ký có nhãn và câu tiếng Việt cho chuyển ca, từ chối và chuyển thất bại. Trang Hộ thêm ô **Ca được gánh thay**, tính từ lịch sử thật. Fixture giao diện thêm một ca ngắn của N03 để người chơi quan sát được việc một thành viên nhận thay trên cả màn hình điện thoại và máy tính.

`dart analyze`, `flutter analyze`, 18/18 runner và 16/16 widget test đều đạt.

## Giới hạn và bước tiếp theo

V2.13 chỉ chuyển nguyên ca, chưa chia ca cho nhiều người, chưa giảm khối lượng, chưa thương lượng đổi công hoặc trả ơn. Ca chỉ chuyển trong ngày hiện tại và chưa tạo nghĩa vụ bù lại vào hôm sau. Hoạt động không khai nghề vẫn có thể được người lớn khỏe mạnh nhận; dữ liệu thật về sau cần khai nghề cho các việc chuyên môn.

Bước tiếp theo phù hợp là làm việc nhẹ/nửa buổi khi đang hồi bệnh, hoặc bắt đầu bản đồ vùng để vị trí hai chiều tham gia đời sống hằng ngày.

## Liên kết

- Bản trước: [[K5_19_V2_12_NGHI_BENH]]
- Kỹ năng và quyền từ chối: [[K5_12_V2_5_KY_NANG_NGHE_VA_QUYEN_TU_CHOI]]
- Nhịp sống NPC: [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]]
- Kế hoạch tổng: [[MASTER_PLAN]]
