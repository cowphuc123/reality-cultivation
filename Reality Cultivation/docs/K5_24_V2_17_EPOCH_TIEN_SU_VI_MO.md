---
aliases:
  - V2.17 epoch tiền sử vĩ mô
tags:
  - trien-khai
  - worldgen
  - lich-su
  - epoch
---

# K5.24 — V2.17 epoch tiền sử vĩ mô

## Mục tiêu

V2.16 đã buộc thế giới tồn tại trước P00 nhưng snapshot vẫn không có tuổi. V2.17 thêm lịch sử tiền game chạy thật theo seed: chọn tuổi vài trăm, vài nghìn hoặc vài vạn năm; truyền trạng thái vùng qua nhiều epoch; giữ các biến cố neo; rồi mới cho phép mở chọn nơi sinh.

Đây là lát cắt tối thiểu đầu tiên của phần tiền sử trong U013. Nó dùng cohort và số liệu vùng, không giả vờ rằng mọi cá thể của hàng nghìn năm đã được xử lý theo từng ngày.

## Tuổi lịch sử từ seed

`WorldHistoryGenerator` nhận root seed và fingerprint của bản đồ V2.15. Seed chọn một trong ba dải fixture:

- 300–1.000 năm;
- 1.000–9.999 năm;
- 10.000–30.000 năm.

Các seed kiểm chứng 1, 20 và 8 lần lượt đi vào ba dải trên. Seed mặc định `20260907` sinh **741 năm** lịch sử được ghi nhận. Các dải này là fixture kỹ thuật, chưa phải lựa chọn tuổi thế giới chính thức được người dùng duyệt.

Stream Park–Miller chỉ dùng số nguyên trong miền chính xác của Dart VM và JavaScript. Cùng seed, fingerprint bản đồ và phiên bản `v2.17.0` cho cùng tuổi, epoch, tác động và fingerprint lịch sử.

## Ba epoch và 192 bước vĩ mô

Lịch sử chia thành ba khoảng liên tục từ năm xa nhất tới hiện tại:

1. **Định cư sơ kỳ**;
2. **Mở đất và lập chợ**;
3. **Cận thế**.

Mỗi epoch chạy 64 bước vĩ mô, tổng cộng 192 bước. Mỗi bước truyền năm đại lượng sang bước sau:

- dân số ước tính;
- số hộ ước tính;
- đất canh tác tính theo đơn vị fixture “mẫu”;
- tầm giao thương 0–1.000;
- áp lực tài nguyên 0–1.000.

Tăng/giảm dân số, mở đất, giao thương và áp lực được tính ở từng bước. Các biến cố neo áp thêm delta có dấu vào đúng bước của mình. Kết quả seed mặc định tại hiện tại là 183 người ước tính, 36 hộ, 77 mẫu canh tác, giao thương 812/1.000 và áp lực tài nguyên 214/1.000.

Đây là cohort vùng. Chỉ bốn NPC trước sinh (và P00 sau sinh) đang có `PersonState` chi tiết. Hệ thống không tuyên bố đã materialize 183 hồ sơ người.

## Sáu biến cố neo

Seed mặc định giữ sáu mốc giải thích các phần của snapshot hiện tại:

| Năm trước hiện tại | Biến cố | Chủ thể | Tác động nổi bật |
| ---: | --- | --- | --- |
| 662 | Lập nơi ở bền vững ven suối | `SITE-HOME` | +34 dân, +5 đất |
| 550 | Khai khẩn đồng ngoài | `SITE-FIELD` | +18 đất, giảm áp lực 21 |
| 352 | Lũ lớn đổi bãi bồi | `SITE-RIVER` | −7 dân, −5 đất, +138 áp lực |
| 235 | Chợ thành điểm trao đổi thường kỳ | `SITE-MARKET` | +26 dân, +219 giao thương |
| 111 | Duy trì lối qua chân đèo | `SITE-PASS` | +163 giao thương |
| 38 | Hình thành tuyến chợ hiện nay | `RT-ANKHE` | +20 dân, +165 giao thương |

Mỗi anchor có ID, loại, chủ thể, năm, lời tóm tắt và bốn delta số. Anchor được lưu trong save thay vì chỉ viết thành đoạn văn giao diện.

Loại và nội dung sáu anchor vẫn là template An Khê; seed hiện quyết định tuổi, thời điểm và độ lớn tác động. Chưa có nhánh tổ chức, chiến tranh, công pháp, di cư, sinh tử hoặc khả năng một địa điểm bị xóa khỏi hiện tại.

## Công bố qua hàng đợi sự kiện

`Simulation.simulatePrehistory` kiểm tra trước khi ghi sự kiện:

- root seed trùng mô phỏng;
- fingerprint lịch sử trỏ đúng bản đồ đã xếp tạo;
- biên epoch liên tục;
- anchor nằm trong epoch và không trùng ID;
- chủ thể của anchor còn tồn tại trong vùng, địa điểm hoặc tuyến hiện tại;
- fingerprint kế hoạch tính lại chính xác;
- lịch sử chưa từng được chạy.

Sau đó hàng đợi xử lý `world_history_started`, ba lần `historical_epoch_simulated`, rồi `world_history_completed`. Trong toàn bộ chuỗi, P00 và `WorldEntryState` không được tồn tại. Nếu sự kiện mở nhập thế được xếp trước lúc lịch sử hoàn tất, nó bị từ chối.

Worldgen V2.15 vẫn hoàn tất trước lịch sử. Các NPC hiện tại được materialize như lớp chi tiết gần của snapshot, không bị cho sống 741 năm vì dự án chưa có sinh–lão–tử và phả hệ.

## Giao diện

Màn chọn nơi sinh và trang **Hồ sơ** sau khi sinh đều có thẻ lịch sử:

- tuổi tiền sử và tiến độ epoch;
- chip tên cùng biên năm của ba epoch;
- năm đại lượng vùng hiện tại;
- sáu biến cố neo, chủ thể và tác động;
- fingerprint lịch sử.

Giao diện nói rõ số dân vùng là cohort vĩ mô và cho biết số `Person` đã có hồ sơ chi tiết, tránh khiến 183 người ước tính bị hiểu nhầm thành 183 NPC hoàn chỉnh.

## Kiểm chứng

- Runner V2.17 đạt hash `4854adc4af68e1ce`.
- Seed mặc định: 741 năm, ba epoch, 192 bước, sáu anchor, fingerprint `582235ed607d383c`.
- Catalog `game/artifacts/conditions/v2_17_world_history.json` có 22 điều kiện.
- 22/22 runner V0–V2.17 đạt; toàn bộ 21 hash V0–V2.16 giữ nguyên.
- 18/18 widget test đạt; lịch sử hiện trước sinh, còn xem được sau sinh và còn trong save.
- `dart analyze` và `flutter analyze` đạt.

## Giới hạn và bước tiếp theo

Các chỉ số lịch sử hiện đã có quan hệ nhân quả nội bộ nhưng chưa làm thay đổi tồn kho, quyền, dân cư chi tiết hoặc khả năng sống của snapshot hiện tại. Sáu loại anchor được đảm bảo xuất hiện để giải thích fixture, nên đây chưa phải lịch sử phát sinh tự do. Chưa có lưu/tạm dừng giữa lúc chạy vì 192 bước hiện hoàn tất đồng bộ rất nhanh; thanh tiến độ chỉ đọc kết quả đã công bố.

Bước tiếp theo đề xuất là V2.18 cho ít nhất một hậu quả lịch sử chảy vào snapshot chơi: lũ và áp lực tài nguyên phải đổi nguồn lực hiện tại, còn giao thương phải đổi dự trữ hoặc khả năng tiếp tế, với validator bảo đảm vẫn còn ít nhất một nơi sinh được. Sau đó mới mở rộng cohort thành nhiều hộ và nhiều hoàn cảnh sinh.

## Liên kết

- Bản trước: [[K5_23_V2_16_CHON_NOI_SINH_SAU_KHI_TAO_THE_GIOI]]
- Thiết kế tiền game: [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]
- Kế hoạch tổng: [[MASTER_PLAN]]
