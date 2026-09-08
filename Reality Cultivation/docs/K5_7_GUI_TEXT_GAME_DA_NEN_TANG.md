---
aliases:
  - GUI text game đa nền tảng
tags:
  - trien-khai
  - giao-dien
  - mobile
  - desktop
---

# K5.7 — GUI text game đa nền tảng

## Mục tiêu

Theo yêu cầu ngày 2026-09-08, giao diện được ưu tiên hoàn thiện trước khi tiếp tục V2.1. Giao diện vẫn là text game: chữ, số liệu, nút và biểu tượng chỉ tổ chức thông tin; không thêm bản đồ hay cảnh 3D giả vào phần mô phỏng.

## Ngôn ngữ thị giác

- Nền xanh đen, bề mặt xanh rêu tối và điểm nhấn vàng đất tạo cảm giác cổ, tĩnh và dễ đọc lâu.
- Thông tin quan trọng dùng chữ cùng màu/trạng thái; không bắt người chơi phân biệt chỉ bằng màu.
- Thẻ bo vừa, viền nhẹ, khoảng cách chạm rộng; không phụ thuộc hover, nhấp phải hoặc kéo chính xác.
- Dữ liệu mô phỏng chưa tồn tại được ghi “Chưa mở trong bản hiện tại”, không tạo số hoặc tính năng giả.

Màu sắc và cách đặt tên khu vực là lựa chọn triển khai có thể đổi; người dùng mới xác nhận ưu tiên làm GUI đẹp và đầy đủ trước.

## Năm khu vực hoạt động

| Khu vực | Nội dung hiện có |
| --- | --- |
| Hiện tại | Ngày/giờ, trạng thái P00, tiến trình ngày, hành động hợp tuổi, cảnh báo chăm sóc, kho tóm tắt và diễn biến gần |
| Nhân vật | Nhu cầu, giác quan, gắn bó, cơ thể, dạ dày, nhiệt, bài tiết, khả năng bú/nuốt và tổng tích lũy |
| Hộ | Bốn thành viên, bốn kho, số bữa, thiếu hụt, từ chối quyền và thời gian chăm sóc làm gián đoạn lao động |
| Nhật ký | Timeline có giờ, loại sự kiện, mô tả tiếng Việt và bộ lọc Tất cả/Chăm sóc/Hộ gia đình/Thế giới |
| Hồ sơ | Lưu, tải, trạng thái bản lưu, semantic hash, revision, số người/fact và danh sách hệ chưa mở |

Nút Chạy/Dừng luôn nằm ở thanh trên. Trạng thái hiện hành cũng nằm ở thanh bên máy tính để không mất dấu khi đổi trang.

## Bố cục thích nghi

### Điện thoại dưới 760 px

- Một trang nội dung tại một thời điểm.
- Thanh điều hướng năm mục cố định ở đáy, phù hợp thao tác ngón cái.
- Phần Hiện tại đặt hành động ở gần đầu; nội dung dài cuộn dọc, các bộ lọc nhật ký cuộn ngang trong phạm vi riêng.
- Đã kiểm tra trực quan tại 390×844: không tràn ngang; chuyển được từ hành động sang cơ thể, hộ và lưu/tải.

### Máy tính từ 760 px

- Thanh điều hướng dọc bên trái; mở nhãn ở màn hình đủ rộng.
- Vùng giữa giới hạn độ rộng dòng để đoạn text không kéo quá dài.
- Từ 1.080 px có cột phải luôn chiếu trạng thái thế giới, P00 và H01.
- Đã kiểm tra tự động ở 800×600 và trực quan/tự động ở 1.280×800.

## Tính trung thực của thông tin

GUI chỉ đọc qua `WorldView`, `PersonView` và `HouseholdView`; hành động đi qua `CommandPort`. Timeline lấy `WorldFact` thật rồi diễn đạt lại bằng tiếng Việt. Việc đổi màu, lọc hoặc rút gọn câu không đổi canonical state và không làm lộ dữ liệu chưa có trong view.

Các hệ bệnh lý, bản đồ, tu luyện và tổ chức được liệt kê trong Hồ sơ với trạng thái chưa mở. Chúng chưa có nút giả có thể bấm hoặc số tiến độ bịa.

## Kiểm chứng

- `flutter analyze`: sạch.
- 4/4 widget test đạt, bao phủ 390×844, 800×600 và 1.280×800.
- Lưu/tải thủ công cùng lifecycle restore vẫn đạt sau khi thay toàn bộ điều hướng.
- Bộ lọc Hộ chỉ giữ fact hộ và loại fact Person khỏi danh sách.
- Catalog `game/artifacts/conditions/ui_shell_v1.json` có 12 điều kiện tự động.
- Web release biên dịch thành công.

## Giới hạn còn lại

Đây là shell đầy đủ cho các hệ đã được mô phỏng đến V2.0. Khi hệ mới xuất hiện, chúng cần trang/view thật tương ứng. Chưa có tùy chọn cỡ chữ do người chơi lưu lại, tìm kiếm toàn cục, phím tắt tùy chỉnh, tooltip giải thích thuật ngữ, chi tiết từng vật/NPC, hệ thông báo theo mức ưu tiên hoặc kiểm thử bằng trình đọc màn hình trên thiết bị thật.

Bước sau GUI là quay lại V2.1: bệnh nhẹ, nguồn sản xuất/tiếp tế, vị trí theo phòng và đổi lịch NPC.

## Liên kết

- Đặc tả gốc: [[GIAO_DIEN]]
- Lát cắt dữ liệu hiện tại: [[K5_6_V2_0_HO_GIA_DINH_TAI_NGUYEN_QUYEN_LICH]]
- Kiến trúc đa nền tảng: [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]

## Mở bản thử nghiệm

Nhấp đúp `MO_GAME.bat` tại thư mục gốc. Xem [[HUONG_DAN_MO_BAN_TEST]] để biết cách điều khiển, lưu và nạp hồ sơ.
