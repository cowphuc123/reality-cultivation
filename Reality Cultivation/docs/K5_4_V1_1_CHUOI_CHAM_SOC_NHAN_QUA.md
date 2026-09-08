---
aliases:
  - V1.1 chuỗi chăm sóc nhân quả
tags:
  - trien-khai
  - v1
  - so-sinh
  - npc
status: implemented-prototype
updated: 2026-09-07
---

# K5.4 — V1.1 chuỗi chăm sóc nhân quả

## Mục tiêu

Thay liên kết trực tiếp “trẻ khóc → nhu cầu được giảm” của V1 bằng một chuỗi sự kiện có thể thất bại ở từng mắt xích:

> trẻ phát tín hiệu → âm thanh truyền từ nơi phát → người chăm sóc nghe hoặc không nghe → tạm ngắt công việc → di chuyển → đến chỗ trẻ → tìm và dùng vật phẩm → nhu cầu thay đổi → trở lại công việc.

Người chơi chỉ điều khiển ý định của P00. Hành động của người chăm sóc thuộc trạng thái và giới hạn của NPC đó.

## Trạng thái mới

### Person và tác nhân chăm sóc

`PersonState` có vị trí một chiều tính bằng milimét trong fixture nhỏ. Người chăm sóc có:

- ngưỡng nghe;
- tốc độ di chuyển;
- công việc hiện tại;
- công việc bị tạm ngắt để có thể trở lại sau chăm sóc.

Đây là lát cắt của kiến trúc tác nhân, chưa phải hệ không gian hoặc planner tổng quát.

### Vật phẩm tồn tại

`WorldState.items` giữ từng `CareItemState` theo ID, loại, vị trí, số lượng và tình trạng:

- `I-FEED-01`: dịch dinh dưỡng dùng cho trẻ; sau K5.5 lưu theo ml và chỉ trừ lượng cơ thể thực nhận;
- `I-CLOTH-01`: khăn quấn; mỗi lần dùng giảm 5/1.000 tình trạng.

Hai vật này không phải danh mục cân bằng chính thức. Chúng chứng minh chăm sóc không tạo lợi ích khi không có vật chất tương ứng.

### Episode chăm sóc

`careResponsePending` ngăn một tiếng khóc đang được xử lý sinh nhiều chuỗi chăm sóc trùng nhau. `unmetCareEpisodes` đếm lần gọi chăm sóc kết thúc mà nhu cầu không được đáp ứng; tên cũ `unmetCareDays` được đọc khi tải để giữ tương thích với snapshot prototype trước.

## Thời gian và công thức fixture

- Cường độ tiếng khóc tại nguồn: 900 đơn vị thử.
- Suy hao: `khoảng cách mm / 10`.
- NPC nghe khi cường độ cảm nhận không thấp hơn ngưỡng nghe.
- Thời gian âm thanh: khoảng cách chia 340.000 mm/s, chặn trong 1–60 giây game.
- Thời gian đi: làm tròn lên `khoảng cách / tốc độ NPC`.
- Thao tác chăm sóc sau khi đến nơi: 60 giây game.

Trong fixture chính, P00 ở vị trí 0 mm, N01 ở 5.000 mm, ngưỡng nghe 300 và tốc độ 1.000 mm/s. Vì vậy tiếng được nhận ở giây 1, N01 đến ở giây 6 và hoàn tất chăm sóc ở giây 66.

Các con số chỉ dùng để kiểm tra thứ tự, lưu/tải và nhánh thất bại. Hệ không gian sau này phải thay trục một chiều bằng location graph/geometry, vật cản và môi trường âm thanh.

## Kết quả có thể xảy ra

| Kết quả | Điều kiện | Fact |
| --- | --- | --- |
| Nghe và chăm sóc | nghe, đi được, có ít nhất một vật dụng | `cry_heard`, `caregiver_arrived`, `caregiver_care` |
| Không nghe | cường độ cảm nhận dưới ngưỡng | `cry_not_heard` |
| Không thể tới | tốc độ di chuyển bằng 0 hoặc tác nhân đổi trạng thái | `caregiver_cannot_reach` |
| Thiếu vật dụng | đã đến nhưng không có phần ăn hoặc khăn dùng được | `care_failed_missing_supply` |
| Không có tác nhân/vị trí | thiếu Person, capability hoặc vị trí | `care_response_impossible` |

Có một trong hai vật dụng vẫn tạo chăm sóc một phần. Sau K5.5, dịch dinh dưỡng đi qua bú–nuốt/dạ dày để đổi năng lượng và nước; khăn đổi cách nhiệt và hỗ trợ ngủ. Nhu cầu được suy lại từ cơ thể.

## Bằng chứng chạy

`game/tool/verify_v1_care_chain.dart` đã xác nhận:

1. khóc không tăng ngay số lần chăm sóc;
2. người chăm sóc nghe rồi đổi từ `prepare_meal` sang `respond_to_infant`;
3. vị trí chỉ đổi khi sự kiện di chuyển hoàn tất;
4. đến nơi vẫn phải chờ 60 giây thao tác;
5. hoàn tất làm dịch dinh dưỡng giảm từ 120 xuống 72 ml do trẻ chỉ nhận 48 ml, và khăn từ 1.000 xuống 995;
6. NPC trở lại công việc cũ;
7. sau K5.5, lưu ở giây 1 giữa chuỗi rồi chạy đến giây 66 cho cùng hash `69988c4593598846`;
8. ba nhánh quá xa, không di chuyển được và thiếu vật dụng cho ba loại thất bại khác nhau.

Sau K5.5, runner tháng đầu có lệnh đạt hash `a6639c12675fafe7`, 112 episode chăm sóc; V0 vẫn giữ hash `5629ba88282991c6`. Catalog máy `game/artifacts/conditions/v1_infancy.json` chứa 31 điều kiện V1. Dart và Flutter analyze sạch; 4/4 widget test đạt.

## Giao diện

Màn hình sơ sinh nay chiếu thêm:

- khoảng cách tới người chăm sóc;
- công việc hiện tại của người chăm sóc;
- số ml dịch dinh dưỡng còn lại;
- tình trạng khăn;
- dấu hiệu một phản ứng chăm sóc đang chờ;
- nhãn tiếng Việt cho các fact nghe, đến nơi, hoàn tất và thất bại.

Giao diện chỉ đọc qua `QueryPort`; không tự sửa Person, vật phẩm hoặc kết quả chăm sóc.

## Giới hạn còn lại của V1

- Nhu cầu vẫn cập nhật một lần mỗi ngày, chưa phải quá trình dưới ngày.
- “Phần ăn cho trẻ” chưa có nguồn, thành phần, nhiệt độ, khả năng tiêu hóa hoặc tác động cơ thể.
- Chưa có giải phẫu sơ sinh, bú/nuốt/hô hấp, bài tiết, khối lượng cơ thể, bệnh hoặc thương tích.
- NPC mới có phản ứng cố định khi nghe; chưa cân nhắc quan hệ, niềm tin, mệt, nguy hiểm, nghĩa vụ cạnh tranh hoặc nhờ người khác.
- Không gian một chiều chưa có phòng, cửa, vật cản, đường đi hoặc độ ồn nền.
- Item mới có công dụng chăm sóc hẹp, chưa qua ownership, custody, reservation và transaction đầy đủ.

## Bước tiếp theo đề xuất

Tiếp tục V1.2 để hoàn thành phần “body sơ sinh, ngủ/đói/bú và growth một tháng” của vertical slice V1. Trước hết chuyển nhu cầu sang các quá trình dưới ngày và thêm một cơ thể sơ sinh tối thiểu gồm khối lượng, năng lượng, nước, nhiệt, thức/ngủ, khả năng bú–nuốt và chất thải. Chăm sóc phải tác động qua lượng vật chất ăn vào và chức năng cơ thể, thay vì trừ trực tiếp bốn thanh nhu cầu.
