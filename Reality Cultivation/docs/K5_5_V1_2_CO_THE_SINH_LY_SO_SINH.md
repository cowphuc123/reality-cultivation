---
aliases:
  - V1.2 cơ thể sinh lý sơ sinh
tags:
  - trien-khai
  - v1
  - co-the
  - sinh-ly
status: implemented-prototype
updated: 2026-09-07
---

# K5.5 — V1.2 cơ thể và sinh lý sơ sinh

## Mục tiêu

Thay việc cộng/trừ trực tiếp bốn thanh nhu cầu bằng một trạng thái cơ thể tối thiểu chạy dưới ngày. Đói, khát, buồn ngủ và khó chịu vì nhiệt nay được suy ra từ dự trữ năng lượng, nước, áp lực ngủ và thân nhiệt. Chăm sóc đưa vật chất qua khả năng bú–nuốt và dạ dày trước khi tạo tác dụng.

Đây là mô hình gameplay kiểm chứng kiến trúc, không phải mô phỏng y khoa hoặc hướng dẫn chăm sóc trẻ.

## Trạng thái cơ thể

`InfantBodyState` hiện lưu bằng số nguyên:

| Trường | Đơn vị | Khởi tạo fixture |
| --- | --- | ---: |
| Khối lượng | g | 3.400 |
| Nước cơ thể | ml | 2.475 |
| Dự trữ năng lượng | kJ | 900 |
| Dịch trong dạ dày | ml | 0 |
| Thân nhiệt | milli-°C | 37.000 |
| Áp lực ngủ | 0–1.000 | 180 |
| Dịch bàng quang | ml | 0 |
| Chất thải tiêu hóa | g | 0 |
| Cách nhiệt | 0–1.000 | 250 |
| Chức năng bú/nuốt | 0–1.000 | 800/850 |

Cơ thể còn tích lũy tổng ml đã ăn, phút đã ngủ, ml nước tiểu và g phân để kiểm toán dài hạn.

## Nhịp sinh lý theo giờ

BirthEvent tạo `infant_physiology_tick` mỗi 3.600 giây game đến hết ngày 30. Một giờ khi thức tiêu 25 kJ và mất 3 ml nước vô hình; khi ngủ tiêu 18 kJ và mất 2 ml. Nước tiểu rời cơ thể theo episode riêng và bị trừ khỏi nước cơ thể.

Mỗi tick:

1. dạ dày chuyển tối đa 15 ml sang quá trình hấp thu;
2. trao đổi chất dùng năng lượng và nước;
3. áp lực ngủ thay đổi;
4. điều nhiệt tiến về cân bằng giữa môi trường, cách nhiệt, sinh nhiệt và điểm điều hòa;
5. dịch/chất thải tích trong bàng quang và đường tiêu hóa;
6. đủ ngưỡng thì phát sinh bài tiết có lượng;
7. suy lại nhu cầu từ cơ thể;
8. nếu căng thẳng vượt ngưỡng, phát tiếng khóc qua chuỗi K5.4.

Các tick diễn ra bên trong một ngày dù đồng hồ ngoài đời vẫn giữ 5 giây bằng 1 ngày game.

## Ăn, bú và nuốt

Vật `I-FEED-01` nay lưu lượng theo ml cùng năng lượng và nước trên 100 ml. Fixture dùng 300 kJ và 92 ml nước trên 100 ml; đây là con số thử, không mô tả loại sữa thực tế.

Lượng nhận là giá trị nhỏ nhất của:

- lượng được đưa ra;
- phần trống của dạ dày;
- giới hạn từ chức năng bú/nuốt.

Ở lúc sinh, đưa 60 ml chỉ nhận được 48 ml do chức năng bú 800/1.000. Dạ dày nhận 144 kJ, 44 ml nước và đúng 48 ml dịch; item chỉ mất 48 ml. Mỗi giờ, tối đa 15 ml dịch rời dạ dày và phần năng lượng/nước tương ứng mới vào dự trữ cơ thể. Phần không nhận không tự biến mất.

Dung tích dạ dày fixture là `khối lượng g × 22 / 1.000`, chặn trong 60–120 ml. Trẻ 3.400 g có dung tích 74 ml.

## Thức và ngủ

Khi thức, áp lực ngủ tăng 80 mỗi giờ; khi ngủ giảm 30. Trẻ tự ngủ ở 700 và thức lại ở 180. Nếu được dỗ khi áp lực từ 500 trở lên, trẻ chuyển sang ngủ; lúc đang ngủ, áp lực ngủ không được tính thành đau khổ để gọi chăm sóc liên tục.

Fixture 30 ngày hiện tích lũy 26.400 phút ngủ, trung bình khoảng 14 giờ 40 phút mỗi ngày. Validator chỉ cho dải 12–18 giờ/ngày để phát hiện mô hình chạy lệch; dải này vẫn là cân bằng thử.

## Nhiệt và bài tiết

Thân nhiệt dùng nhiệt độ phòng từ BirthEvent, mức cách nhiệt và điều hòa tiến về 37.000 milli-°C. Khăn quấn tăng cách nhiệt và giảm một phần áp lực ngủ. Fixture ngày 30 kết thúc ở 36.986 milli-°C, không chạm biên 34–40 °C.

Dịch rời dạ dày đóng góp vào bàng quang và chất thải tiêu hóa. Khi đạt ngưỡng, hệ tạo `infant_elimination` với ml/g cụ thể và cập nhật tổng tích lũy. Chưa có tã, vệ sinh da hoặc người chăm sóc nhận biết bài tiết.

## Tăng trưởng

Mỗi ngày, nếu dự trữ năng lượng ít nhất 520 kJ và mức thiếu nước dưới ngưỡng 500, fixture tăng 22 g và dùng 44 kJ. Nếu không đủ điều kiện, chỉ tăng 4 g và dùng 8 kJ. Đây là hai nhánh kiểm chứng phụ thuộc trạng thái; chưa phải đường tăng trưởng sinh học.

Trong lượt 30 ngày, khối lượng tăng từ 3.400 g lên 4.042 g: 29 ngày đạt nhánh tăng 22 g và một ngày chỉ đạt nhánh 4 g vì trạng thái dự trữ ở đúng mốc tăng trưởng không đủ. Kết quả vì vậy xuất phát từ trạng thái thay vì bị ép theo đường tăng cố định.

## Bằng chứng chạy

`game/tool/verify_v1_body.dart` kiểm tra độc lập:

- trạng thái lúc sinh và dung tích dạ dày;
- tiêu năng lượng/nước một giờ;
- giới hạn bú–nuốt và bảo toàn ml;
- năng lượng/nước theo lượng thật nhận;
- chu kỳ ngủ trong 48 giờ;
- nước tiểu và phân phát sinh từ chuỗi ăn–tiêu hóa;
- tăng trưởng đủ/thiếu nguồn lực khác nhau;
- ổn định nhiệt;
- bảo toàn `10.000 ml ban đầu − lượng còn = tổng ml cơ thể nhận`;
- lưu ở giờ 12 rồi tiếp tục cho cùng kết quả.

Lượt tháng đầu không có lệnh phụ đạt hash `5d418dc95af7118d`: 4.042 g, 5.254 ml đã nhận, 26.400 phút ngủ và 112 episode chăm sóc. Runner có lệnh người chơi đạt hash `a6639c12675fafe7`. Runner chuỗi 66 giây đạt `69988c4593598846`. V0 vẫn đạt `5629ba88282991c6`.

Catalog `game/artifacts/conditions/v1_infancy.json` hiện có 31 ID duy nhất. Dart/Flutter analyze sạch; 4/4 widget test đạt; web release biên dịch thành công.

## Giao diện

Màn hình mobile và desktop hiển thị khối lượng, nước cơ thể, năng lượng, dạ dày/dung tích, thân nhiệt, bàng quang, chất thải, chức năng bú–nuốt và các tổng ăn/ngủ/bài tiết. Các thanh nhu cầu cũ vẫn tồn tại như View dẫn xuất để người chơi đọc nhanh.

## Giới hạn còn công khai

- Cơ thể mới là kho và quá trình toàn thân; chưa có bộ phận, mô, tuần hoàn, hô hấp, thận, gan, thần kinh hoặc tổn thương.
- Hấp thu hiện dùng một tốc độ rời dạ dày tối đa 15 ml/giờ và chia năng lượng/nước theo tỷ lệ đồng đều; chưa có tiêu hóa thành phần hoặc tốc độ hấp thu riêng cho từng chất.
- Không có thành phần dinh dưỡng, thiếu chất, miễn dịch, nhiễm, bệnh, trớ/sặc hoặc nguy cơ bú–nuốt thất bại.
- Tăng trưởng chỉ thay khối lượng và hai chức năng; chưa thay hình học, cơ quan, vận động hay nhận thức.
- Môi trường chỉ có một nhiệt độ cố định; chưa có quần áo thật trên body, độ ẩm, gió, bề mặt nằm hoặc phòng.
- 112 episode chăm sóc/tháng là kết quả của fixture, chưa phải lịch chăm sóc được cân bằng cho trải nghiệm.

## Trạng thái vertical slice V1

V1 tối thiểu nay đã có BirthEvent, cơ thể sơ sinh, đói/ngủ/khóc, nhận thức và quyết định chăm sóc cơ bản, bú/chăm sóc, tăng trưởng một tháng, điều khiển theo tuổi, lưu/tải và UI đa kích thước. Điều này đóng mục tiêu chức năng tối thiểu của V1; không có nghĩa mô phỏng sơ sinh đã sâu hoặc chân thật hoàn chỉnh.

## Bước tiếp theo đề xuất

Bắt đầu V2 — một hộ sống: tạo hộ 3–5 Person, nơi ở có phòng và tuyến đi, kho nước/thức ăn/nhiên liệu hữu hạn, quyền dùng vật, lịch công việc và chăm sóc cạnh tranh. V2 phải chứng minh tài nguyên không tự sinh, người chăm sóc có thể bận vì nhu cầu thật của hộ và P00 chịu hậu quả từ sinh kế gia đình.
