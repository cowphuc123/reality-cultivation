---
aliases:
  - V1 tháng đầu sơ sinh
tags:
  - trien-khai
  - v1
  - so-sinh
status: implemented-prototype
updated: 2026-09-07
---

# K5.3 — V1 tháng đầu sơ sinh

## Mục tiêu lát cắt

Chứng minh yêu cầu U014 bằng một vòng chơi từ đúng thời điểm sinh, trong đó người chơi không thể giao mục tiêu của người trưởng thành. Trạng thái và lựa chọn phải thay đổi theo tuổi, nhu cầu phải tạo tín hiệu có nguyên nhân, người chăm sóc phải là một Person tồn tại trong thế giới, và lưu/tải không đổi diễn biến.

Đây là prototype gameplay V1. Các hệ số là số nguyên phục vụ kiểm chứng kiến trúc, chưa phải mô hình y khoa hoặc cân bằng đã được người dùng duyệt.

## Phần đã triển khai

- `PersonState` có thể mang `InfantState`; trường này được bỏ khỏi JSON đối với hồ sơ V0 cũ nên shared fixture V0 và hash `5629ba88282991c6` không đổi.
- `InfantNeeds` theo dõi đói, khát, áp lực ngủ và khó chịu vì nhiệt trên thang thử 0–1.000. Căng thẳng hiện lấy thành phần cao nhất để giải thích trực tiếp.
- `InfantSenses` theo dõi tầm nhìn gần, khả năng tập trung thị giác, nghe, ngửi và xúc giác. Các giá trị thay đổi từng ngày đến ngày 30.
- `InfantIntentCommand` giới hạn lựa chọn theo tuổi. Ngày 0 có chú ý đến giọng nói, khóc gọi chăm sóc và ngủ; vươn tay mở từ ngày 14.
- Mục tiêu tự do bằng văn bản bị từ chối khi nhân vật còn ở trạng thái sơ sinh.
- Sự kiện `infant_daily_tick` cập nhật nhu cầu một lần mỗi ngày trong lát cắt. Khi căng thẳng đạt ngưỡng thử 500, trẻ khóc và phát sinh fact `infant_cry`.
- Bản K5.3 ban đầu cho Person người chăm sóc phản ứng trực tiếp. [[K5_4_V1_1_CHUOI_CHAM_SOC_NHAN_QUA]] đã thay cơ chế này bằng tín hiệu, nhận biết, di chuyển và dùng vật phẩm; lần chăm sóc không thành được ghi theo episode.
- Shell Flutter khởi tạo một người chăm sóc và P00 đúng lúc sinh. Giao diện hẹp/rộng hiển thị nhu cầu, trạng thái thức/ngủ/khóc, chăm sóc, gắn bó, tầm nhìn và các nút ý định hợp tuổi.

## Hệ số fixture hiện tại

| Thành phần | Khởi tạo | Mỗi ngày | Sau chăm sóc |
| --- | ---: | ---: | ---: |
| Đói | 100 | +220 | −520 |
| Khát | 100 | +180 | −460 |
| Áp lực ngủ khi thức | 180 | +190 | −280 |
| Khó chịu vì nhiệt | 80 | +25 | −180 |
| Gắn bó | 100 | 0 | +25 |

Mọi giá trị trong bảng bị chặn ở 0–1.000. Các phép cộng theo ngày chỉ là độ phân giải đầu tiên; V2 cần chuyển nhu cầu sang quá trình dưới ngày để phản ánh chăm sóc, giấc ngủ và môi trường theo thời điểm.

## Bằng chứng chạy

Runner `game/tool/verify_v1_infancy.dart` đã đạt các điểm sau:

1. P00 bắt đầu ở tuổi 0 ngày và có trạng thái sơ sinh.
2. Mục tiêu “Tu luyện công pháp” bị từ chối ở ngày 0.
3. Chú ý đến giọng người chăm sóc được nhận; vươn tay bị từ chối ở ngày 0 và mở ở ngày 14 trở đi.
4. Trong 10 ngày có cả tiếng khóc lẫn phản ứng chăm sóc.
5. Khi bỏ Person người chăm sóc khỏi fixture, không có lần chăm sóc giả và số episode thiếu chăm sóc tăng.
6. Sau K5.5, lưu ở ngày 10, khôi phục rồi chạy đến ngày 30 cho cùng semantic hash `a6639c12675fafe7` với lượt chạy liên tục.
7. Sau K5.5, đến ngày 30 có 112 episode chăm sóc trong fixture sinh lý theo giờ.

Bốn widget test Flutter đều đạt: thao tác trên màn hình điện thoại, cùng chức năng trên desktop, lưu/tải ý định A→B→A và autosave/restore theo lifecycle. Dart/Flutter analyze sạch và web release biên dịch thành công.

## Giới hạn còn công khai

- Cập nhật nhu cầu mới ở mức một lần/ngày; chưa có bú/ăn, lượng dịch, bài tiết, chu kỳ ngủ hoặc trao đổi nhiệt liên tục.
- K5.4 đã thêm nhận biết tiếng khóc, khoảng cách, việc bị ngắt, di chuyển và thất bại cơ bản; tính cách, quan hệ, giấc ngủ và planner đầy đủ vẫn chưa có.
- Gắn bó mới là một chỉ số thử một chiều; chưa dùng mô hình quan hệ đa chiều trong K4.6.
- Phát triển giác quan là đường tăng đơn giản để chứng minh mở khóa theo tuổi, không phải số liệu sinh học.
- Chưa có cơ thể giải phẫu, bệnh, thương tích lúc sinh, vật phẩm chăm sóc, hộ gia đình, ngôn ngữ học được hoặc môi trường phòng ở.
- `InfantState` là trường cộng thêm trong save schema 1 để giữ tương thích prototype. Trước khi có save phát hành thật phải định migration và schema chính thức.

## Bước kế tiếp đề xuất

V1.1 nên thay phản ứng chăm sóc tức thì bằng chuỗi nhân quả có thể quan sát: trẻ phát tín hiệu → âm thanh truyền trong không gian → người chăm sóc có hoặc không nhận biết → đổi kế hoạch → di chuyển đến trẻ → dùng vật/chăm sóc → nhu cầu và quan hệ thay đổi. Chuỗi này nối trực tiếp hệ sơ sinh với nhận thức NPC, hành động, không gian và vật phẩm mà vẫn giữ phạm vi nhỏ.

Sau V1.1, mở rộng shared fixture để Dart và PWA cùng chạy một nhánh sơ sinh tối thiểu; nếu mô hình tiếp tục lớn, đo isolate và workload trước khi nâng ADR công nghệ.
