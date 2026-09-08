---
aliases:
  - V2.4 nhu cầu sinh việc và ưu tiên
tags:
  - trien-khai
  - npc
  - lich
  - kinh-te
---

# K5.11 — V2.4 nhu cầu của hộ sinh việc, ưu tiên phân xử xung đột

## Kết quả có thể chơi

Đến V2.3, ai làm gì trong ngày là do bảng giờ viết sẵn. Từ V2.4, hộ **tự nhìn tồn kho thật rồi giao việc**.

Mỗi sáng 05:00, hộ tính số ngày còn dùng được cho từng kho: lấy số lượng thật chia cho nhịp tiêu thụ thật (lương thực 1.500 g/ngày, nước 6.000 ml/ngày, củi 900 g/ngày từ ba bữa ăn). Kho nào còn dưới 12 ngày thì thành một nhu cầu, và càng cạn thì mức gấp càng cao. Mức gấp trở thành **ưu tiên** của khối việc sinh ra từ nhu cầu đó.

Trong fixture: củi còn 5 ngày (ưu tiên 69), nước còn 8 ngày (ưu tiên 56), lương thực còn 10 ngày (ưu tiên 48). Hộ giao củi cho N02, nước cho N01, lương thực cho N03 — chia theo **quyền dùng kho** và **giờ trống**, không dồn hết vào một người. Nếu không ai đủ quyền, hộ ghi rõ là thiếu người thay vì tự bịa ra người làm.

## Ưu tiên thật sự phân xử

Trường `priority` có từ V2.3 nhưng chưa được dùng. Nay nó quyết định hai chỗ:

- **Lúc xếp lịch**: việc gấp được phép đặt đè lên khối cố định có ưu tiên thấp hơn. Việc kiếm lương thực (ưu tiên 48) được xếp chồng lên khối sửa mái (ưu tiên 25).
- **Lúc chạy**: khi hai khối cùng đòi một người, khối ưu tiên cao hơn **giành chỗ** (`outranked`) và số giờ mất được ghi lại; khối ưu tiên thấp hơn **lùi giờ** (`deferred`) tối đa ba lần rồi mới mất hẳn. Trong fixture, sửa mái bị kiếm lương thực giành chỗ lúc 06:00, còn may vá phải lùi hai lần rồi vào việc lúc 07:30 sau khi N01 gánh nước xong.

## Vòng nhân quả khép kín

Đây là điểm chính của lát cắt này:

> Trẻ phát bệnh ngày 3 → N01 nghỉ vì sốt → N02 được điều đi chăm thay → N02 đang giữa khối *kiếm lương thực* → mất 612 giây → sản lượng giao về kho chỉ còn **2.898 g thay vì 3.000 g** → hôm sau số ngày dự trữ thấp hơn → nhu cầu gấp hơn → ưu tiên cao hơn.

Không đoạn nào trong chuỗi này được viết sẵn. Sản lượng chia theo đúng số giây thật sự làm được; bị cắt sạch giờ thì ghi `routine_work_lost` và không thu được gì.

## Lỗi đã sửa: khối việc bị nuốt

Ở V2.3, khi khối B kế tiếp bắt đầu đúng lúc khối A kết thúc, sự kiện bắt đầu (pha `intent`) chạy trước sự kiện kết thúc (pha `completion`) trong cùng một giây. Khối B ghi đè `activeBlockId`, rồi sự kiện kết thúc của A thấy id đã khác nên bỏ qua — **khối A biến mất khỏi sổ, không được tính là xong và giờ mất của nó cũng biến mất**. Trong lượt chạy V2.3, N01 chỉ được ghi 7 khối trên 12.

Nay khi một khối bắt đầu mà còn khối khác đang chạy, hệ thống xử lý rõ ràng thay vì ghi đè: khối cũ đã hết giờ thì đóng bình thường, chưa hết giờ thì so ưu tiên để quyết định giành chỗ hay lùi giờ. Sau khi sửa, N01 được ghi 11 khối.

**Vì vậy hash của runner V2.3 đổi từ `8df759ae2a42eca0` sang `ade0b8a4300276c9`.** Đây là hệ quả của việc sửa lỗi, không phải hồi quy: toàn bộ điều kiện V2.3 vẫn đạt, số xung đột và số giây mất không đổi, chỉ số khối được tính đúng lên. Sáu runner V0–V2.2 giữ nguyên hash vì chúng không dùng nhịp sống.

## Trạng thái máy mới

- `HouseholdNeed`: kho, nhịp tiêu thụ, số ngày dự trữ, mức gấp và ưu tiên suy ra.
- `RoutineBlock` thêm `needKind`, `outputResource`, `outputAmount`, `planDay`; khối có `planDay` là khối do kế hoạch sinh và chỉ sống trong ngày đó.
- `RoutineState` thêm `activePlannedEndSeconds`, `activeLostSeconds`, `outrankedBlocks` và `withGeneratedBlocks`.
- `ScheduleConflict` thêm cách giải quyết `outranked`.
- `QueryPort`: `HouseholdView.needs` và `HouseholdView.plannedWork`.

Sự kiện mới: `household_planning`, `household_plan_made`, `household_need_unstaffed`, `household_need_unscheduled`, `routine_block_outranked`, `routine_work_delivered`, `routine_work_lost`.

## Giao diện

Trang Hộ có khu vực **Nhu cầu & kế hoạch hôm nay**: từng kho còn mấy ngày dùng, kho nào cần bổ sung và ở mức ưu tiên nào, kèm danh sách việc đã giao với lý do ("vì thiếu củi"). Ô đo **Xung đột lịch** đọc thẳng từ hộ. Nhật ký thêm câu tiếng Việt cho bảy loại mốc mới, và bộ lọc **Nhịp sống** gộp cả các mốc lập kế hoạch.

## Kiểm chứng đã chạy

- `dart analyze` và `flutter analyze`: sạch.
- Runner V2.4 đạt tới ngày 4; lưu lúc 08:00 khi một khối do kế hoạch sinh đang chạy rồi chạy tiếp cho cùng hash `5b36f570a39e4bde`.
- Bảy runner V0–V2.2 giữ nguyên hash. V2.3 đạt lại ở hash đã sửa `ade0b8a4300276c9`.
- Catalog `game/artifacts/conditions/v2_4_need_driven_plan.json` có 23 điều kiện tự động.
- 8/8 widget test đạt, gồm bài mới cho khu vực nhu cầu/kế hoạch và lần giành chỗ theo ưu tiên.
- Web release đã đóng gói lại.

## Giới hạn và bước tiếp theo

Kế hoạch vẫn là của **hộ**, chưa phải của từng người: NPC chưa tự đặt mục tiêu riêng, chưa thương lượng ai nhận việc, chưa từ chối vì mệt hay vì thích việc khác. Chọn người mới cân theo quyền và giờ trống, **chưa có mô hình kỹ năng nghề** — nên người nấu ăn có thể bị giao đi kiếm củi nếu họ rảnh hơn. Khối bị lùi quá ba lần vẫn mất hẳn trong ngày thay vì được xếp lại vào giờ trống còn lại; đó là chỗ cần bộ lập lịch lại (replanning) chứ không phải sửa vặt.

Ngưỡng 12 ngày, nhịp tiêu thụ, thời lượng và sản lượng từng loại việc, bước lùi 30 phút và trần ba lần đều là fixture kỹ thuật, chưa phải cân bằng đã chốt.

Bước tiếp theo đề xuất: cho từng NPC có mục tiêu riêng và quyền từ chối/nhận việc dựa trên trạng thái bản thân, thêm kỹ năng nghề vào việc chọn người, rồi xếp lại việc bị lùi thay vì bỏ.

## Liên kết

- Bản trước: [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]]
- NPC tự trị (thiết kế sâu): [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]
- Kinh tế và lao động: [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]
- Kế hoạch tổng: [[MASTER_PLAN]]
