---
title: Công việc đang hoạt động
aliases:
  - Active work
  - Lượt làm hiện tại
tags:
  - huong-dan
  - chuyen-giao
---

# Công việc đang hoạt động

Cập nhật: 2026-09-19.

## Trạng thái lượt

| Trường | Giá trị |
| --- | --- |
| Chủ lượt | Codex — phát hành V4/V5/V6 |
| Trạng thái | V4, V5 và V6 đã đóng cổng, đã push GitHub và triển khai web thành công |
| Nhánh ổn định | `master` |
| Commit game ổn định | `f05040e` — Release V4-V6 simulation milestones |
| Nhánh bàn giao | Không có |
| Lát cắt phát hành gần nhất | [[K5_30_V4_V5_V6_DONG_CONG_PHAT_HANH]] |
| Việc tiếp theo | Khóa danh sách cổng hữu hạn V7 trước lát cắt tu luyện đầu tiên |
| Chặng hiện tại | V4–V6 đã hoàn thành; V7 là chặng chức năng kế tiếp |

## Kết quả kiểm chứng tại mốc ổn định

- `dart analyze`: đạt.
- 36/36 runner V0–V6: đạt.
- Runner V3: 50 NPC, 12 hộ, 291 cuộc đổi hàng, 2.333 bằng chứng, 172 quan hệ xuyên hộ, 207 yêu cầu tài nguyên, 0 ngày cứu hộ vô căn cứ.
- V4 sáu năm: chạy liền, save/load năm 3 và replay cùng hash `afefc3dd5537605a`.
- V5 worldgen: 741 năm; chạy liền, save/load và replay cùng hash `4e03e202361d0363`.
- V6 sinh kế 30 ngày: chạy liền, save/load ngày 15 và replay cùng hash `b8fea49e313fe8ab`.
- `flutter analyze`: đạt.
- 22/22 widget test: đạt, gồm V4–V6 ở điện thoại và máy tính.
- 592/592 điều kiện trong 29 catalog triển khai hợp lệ, không trùng mã.
- Flutter web release build: đạt.
- Web: https://cowphuc123.github.io/reality-cultivation/

## Phạm vi đã khóa

- V3 kết thúc tại [[K5_29_V3_LANG_NHO_TU_VAN_HANH_30_NGAY]]. Không tạo `V3.0-dev.21`.
- Danh tiếng gián tiếp, hội thoại sâu và các mở rộng xã hội khác là backlog, không phải lỗi còn thiếu của V3.
- V4, V5 và V6 kết thúc tại [[K5_30_V4_V5_V6_DONG_CONG_PHAT_HANH]]; không mở thêm hậu tố `dev` cho ba chặng đã đóng.
- Trước khi bắt đầu V7, đọc [[LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC]] và khóa danh sách hữu hạn từ cổng tu luyện; mọi đề xuất ngoài cổng đưa vào backlog.

## Lịch sử mã trước lượt phát hành K5.30

Các ghi chú dưới đây mô tả trạng thái lúc từng lát cắt vừa được viết. Toàn bộ mã và bằng chứng này đã được kiểm chứng tại [[K5_30_V4_V5_V6_DONG_CONG_PHAT_HANH]]; các câu “chưa chạy” chỉ là dấu thời gian lịch sử, không phải trạng thái hiện tại.

- `V6.0-dev.1`: thêm `ProductionRecipe`, đầu vào bắt buộc và `ProductionBatchState`. Khi bắt đầu, nguyên liệu bị trừ khỏi item nguồn và được giữ trong workpiece của mẻ; cùng lượng không thể bị mẻ sau dùng lại.
- Người làm phải thuộc đúng hộ/phòng, có quyền dùng nguyên liệu/công cụ và nhận cam kết thời gian hữu hạn. Mẻ hoàn tất mới tạo/cộng đầu ra, tính chất lượng từ nguyên liệu/công cụ, làm mòn công cụ và ghi production của hộ.
- Nếu người làm rời chỗ, cam kết mất, công cụ không còn hoặc ledger đầu ra bị đổi sai loại, mẻ chuyển `blocked`; nguyên liệu vẫn nằm trong hồ sơ workpiece thay vì biến mất. Toàn bộ mẻ/công thức/nguyên liệu đi qua save/load và semantic hash.
- Danh sách đóng V6 đã khóa thành chín cổng và sáu bước. Lát cắt này chưa chạy, chưa có fixture/GUI nên chưa tuyên bố đạt cổng 1.
- `V6.0-dev.2`: client tạo 3 kg gỗ thô, 800 g sợi thực vật và một rìu tay có quyền dùng tại sân H01; N03 bắt đầu mẻ hai giờ dùng 1,2 kg gỗ + 250 g sợi để đóng một khung gùi. Nguyên liệu còn trong kho giảm ngay, đầu ra chỉ xuất hiện khi sự kiện hoàn tất.
- GUI hộ có bảng mẻ/workpiece riêng: người làm, trạng thái, thời gian còn lại, từng lot nguyên liệu và chất lượng, công cụ/hao mòn, đầu ra chưa có/đã vào kho, cùng nguyên nhân blocked. Kho hộ nay liệt kê mọi vật do hộ sở hữu thay vì chỉ bốn resource item sinh tồn.
- Nhật ký có nhãn/nội dung riêng cho mẻ bắt đầu, hoàn tất và bị chặn. Mã widget hiện có đã thêm điểm tìm ở 390×844 và 1280×800 nhưng chưa chạy; chưa chứng nhận cổng 1.
- Đã viết `game/tool/verify_v6_production_workpiece.dart` nhưng chưa chạy. Runner tạo hai thợ, hai rìu và kho vật liệu thật; kiểm tra mẻ sau không dùng chung rìu, không tiêu lại nguyên liệu đã vào workpiece và một yêu cầu bị từ chối không giữ thời gian hay đổi kho.
- Ba đường chạy qua cùng mốc giữa mẻ: chạy liền, save/load và replay. Mã bằng chứng yêu cầu cùng snapshot cuối, đúng một khung gùi chất lượng 737/1000, rìu giảm 850→825, kho nguyên liệu giảm đúng lượng, người làm được trả thời gian và nhận quyền dùng đầu ra. Chưa có hash vì runner chưa chạy.
- Không tăng số `dev` vì lượt này chỉ dựng bằng chứng cho `V6.0-dev.1`–`dev.2`. Không thêm chiều sâu sản xuất trước khi kiểm chứng; phần code tiếp theo thuộc cổng dịch vụ.
- `V6.0-dev.3`: thêm định nghĩa dịch vụ và cuộc hẹn có mốc bắt đầu/kết thúc, người cung cấp, người nhận, địa điểm, vật tư đã giữ, trạng thái cùng claim kết quả. Tất cả đi qua save/load và semantic hash.
- Khi đặt hẹn, khoảng thời gian được đối chiếu với lịch dịch vụ của cả hai người; lịch trùng bị từ chối trước khi đổi vật. Một cam kết cá nhân mới cũng không được lấn qua cuộc hẹn đã đặt. Vật tư tùy chọn bị rút khỏi kho vào hồ sơ cuộc hẹn ngay khi chốt để không bị tiêu hai lần.
- Đến giờ, cả hai phải có mặt và cùng nhận một cam kết thời gian; thiếu một bên làm hẹn `blocked`. Chỉ khi hai cam kết còn nguyên tới cuối buổi mới tạo `ServiceResultClaim` có mã dịch vụ, hai người và thời điểm kiểm tra được.
- Lõi dịch vụ chưa nối fixture/client, chưa có GUI hoặc runner và chưa chạy kiểm chứng. Lát cắt code kế tiếp chỉ nối một dịch vụ đại diện cùng bằng chứng chống overbook; chưa mở lao động hay chợ.
- `V6.0-dev.4`: client thêm lô 500 g ngũ cốc riêng và đặt cuộc hẹn N02 hướng dẫn N01 nấu cháo từ giờ thứ 3 đến giờ thứ 4; 100 g được giữ trong hồ sơ hẹn, không trừ vào kho sinh tồn. GUI hộ hiện trạng thái, hai người, giờ, vật tư, claim hoặc nguyên nhân bị chặn trên cả bố cục điện thoại và máy tính.
- Đã viết `game/tool/verify_v6_service_appointment.dart` nhưng chưa chạy. Runner yêu cầu trùng lịch ở phía cung cấp hoặc nhận đều bị từ chối trước khi rút vật; một mẻ sản xuất kéo qua giờ hẹn cũng không được bắt đầu. Chạy liền, save/load giữa buổi và replay phải cùng snapshot cuối với đúng claim và lịch hai người đã trả.
- Không thêm chiều sâu dịch vụ trước khi kiểm chứng. Phần code kế tiếp thuộc cổng 3 về lời mời lao động và nghĩa vụ trả công; chưa mở chợ.
- `V6.0-dev.5`: thêm lời mời lao động tự chứa công việc, kỹ năng tối thiểu, ưu tiên, người thuê/người làm, hai hộ, nơi, lịch và quyền lợi hiện vật. Người nhận cân nhắc bằng kỹ năng, trạng thái cá nhân và lịch đã giữ; kết quả chấp nhận hoặc từ chối cùng lý do đi qua save/load/hash.
- Lời mời đã nhận giữ lịch và chặn dịch vụ hoặc cam kết khác lấn giờ. Khi làm thật xong mới sinh `LaborCompensationClaim`; công việc hoàn thành được giữ độc lập với trạng thái thanh toán.
- Thanh toán chuyển lượng vật thật từ item của hộ thuê sang item thuộc hộ người làm và cấp quyền dùng cho người làm. Thiếu lượng, sai loại, sai quyền hoặc sai nơi chỉ ghi lần thanh toán thất bại; claim vẫn `outstanding`, không xóa công đã làm.
- Lõi lao động chưa nối fixture/client, GUI hoặc runner. Lát cắt code kế tiếp chỉ nối một lời mời được nhận, một lời mời bị từ chối và bằng chứng khoản nợ không biến mất; chưa mở chợ.
- Theo yêu cầu tách kiến trúc trước khi làm tiếp, `simulation.dart` không còn chứa lớp snapshot hoặc toàn bộ quy trình V6. `simulation_state.dart` sở hữu thời gian, sự kiện, người, fact, `WorldState`, lệnh và save/load; `simulation_livelihood.dart` sở hữu API/handler sản xuất, dịch vụ và lao động bằng extension cùng library.
- `Simulation` vẫn là API điều phối công khai, các runner/client không phải đổi cách gọi. Đây là bước tách nguyên khối, không đổi schema save, semantic hash hay luật mô phỏng. `simulation.dart` giảm từ khoảng 10.717 xuống 8.876 dòng; các hệ cũ sẽ được tách dần khi chạm tới thay vì viết lại một lần.
- `V6.0-dev.6`: client có một lời mời N03 nhận để phân loại vật liệu tại sân H01 và một lời mời làm thêm bị từ chối vì trạng thái cá nhân. Lời mời tương lai không còn bắt hai bên phải đứng sẵn tại nơi làm lúc tạo; sự hiện diện vẫn được kiểm tra khi ca thật bắt đầu.
- GUI hộ trên điện thoại/máy tính hiện công việc, người thuê/người làm, kỹ năng, ưu tiên, lịch, quyền lợi đã hứa, lý do quyết định và claim chưa/đã thanh toán. Nhật ký nhận đủ nhãn tạo lời mời, nhận/từ chối, bắt đầu, hoàn tất, bị chặn và thanh toán.
- Đã viết `game/tool/verify_v6_labor_obligation.dart` nhưng chưa chạy. Runner kiểm tra nhận/từ chối, cam kết giữa ca, save/load/replay, công hoàn tất sinh khoản nợ, thanh toán thiếu giữ nguyên công và claim, thanh toán đủ chuyển đúng vật sang hộ người làm.
- Phần chức năng và mã bằng chứng cổng 3 đã có. Chưa chạy analyzer, runner hay widget test; chưa chứng nhận cổng. Bước code kế tiếp thuộc cổng 4 về chợ địa phương.
- `V6.0-dev.7`: thêm `MarketOfferState`, `MarketOrderState` và `MarketEscrowLot`. Khi đăng bán, lượng hàng thật rời item nguồn vào escrow của offer; khi đặt đơn, phần hàng được tách sang order và vật thanh toán thật cũng rời kho người mua.
- Giá trao đổi theo lot nguyên vẹn; lượng lẻ, quá số hàng còn lại, thiếu vật thanh toán, sai quyền, sai địa điểm hoặc sai hộ đều không tạo đơn. Vì offer/order giữ lượng riêng, cùng một lượng không thể tiếp tục bị sản xuất, tiêu dùng hoặc bán cho đơn thứ hai.
- Offer lưu danh sách người thực sự thấy nó tại địa điểm đăng. Người mua phải có trong danh sách biết offer và còn hiện diện tại chợ khi đặt đơn; settlement cũng yêu cầu hai bên tại chỗ.
- Settlement chỉ đổi chủ hai escrow sang item tương thích của hai hộ và cấp quyền dùng cho đúng người. Target sai giữ đơn ở trạng thái `reserved` thay vì làm mất hàng hoặc thanh toán. Offer/order đi qua save/load và semantic hash.
- Lõi chợ chưa nối fixture/client, GUI hoặc runner và chưa chạy kiểm chứng. Lát cắt code kế tiếp chỉ nối giao dịch đại diện cùng bằng chứng bảo toàn; chưa mở vận tải.
- `V6.0-dev.8`: client thêm hộ đổi dược thảo và một giao dịch tại gian bếp: H01 đưa 200 g ngũ cốc vào offer theo lot 100 g đổi 50 g dược thảo; người mua đã thấy offer đặt một lot và settlement đổi chủ hai vật thật.
- GUI hộ hiện lượng đầu/còn lại, chất lượng, tỷ lệ đổi, người đã biết offer, người mua, hàng và vật thanh toán từng được giữ, trạng thái order cùng hai item đích sau đổi chủ. Nhật ký nhận đủ ba mốc đăng offer, reserve order và settlement.
- Đã viết `game/tool/verify_v6_market_escrow.dart` nhưng chưa chạy. Runner kiểm tra người chưa biết không đặt được, order vượt lượng không trừ thêm vật, hàng đã vào offer không thể đăng lại, target sai giữ nguyên snapshot, target đúng đổi chủ/quyền và tổng hai loại vật được bảo toàn.
- Runner dựng chạy liền, save/load sau reserve và replay để yêu cầu cùng snapshot cuối. Widget test điện thoại/máy tính đã có điểm tìm bảng chợ nhưng chưa chạy.
- Phần chức năng và mã bằng chứng cổng 4 đã có; chưa được chứng nhận. Không thêm chiều sâu chợ trước lượt kiểm chứng, bước code kế tiếp thuộc cổng 5 về vận tải.
- `V6.0-dev.9`: thêm `MarketShipmentState` cho hàng mua đã settlement nhưng phải đi tiếp. Dispatch yêu cầu đúng order, item mua, chủ/quyền, người chở, phòng đầu/cuối và hai waypoint khớp tọa độ của một `TradeRoute` thật.
- Tuyến nhanh nhất được chọn theo sức người chở, tải và địa hình. Thời gian thực cộng từ từng leg; giờ dự kiến dùng đường bằng để ghi độ trễ. Địa hình chậm tạo hao chất lượng xác định, chưa phải cân bằng đã duyệt.
- Khi khởi hành, toàn bộ lượng hàng của order rời item nguồn vào cargo in-transit, người chở nhận cam kết tới mốc đến và không còn ở trong phòng. Vì vật không còn trong kho, production/dịch vụ khác không thể dùng ngầm khi hàng đang đi.
- Khi tới, đúng cam kết và ledger đích mới tạo/cộng item ở phòng đích, cấp quyền rồi trả lịch người chở. Mất cam kết, phòng đích hoặc ledger bị đổi sai làm chuyến `failed`; cargo đã hao vẫn ở hồ sơ chuyến thay vì được bù hoặc biến mất.
- `market_shipments` đi qua save/load và semantic hash. Lõi chưa nối fixture/client, GUI hoặc runner và chưa chạy kiểm chứng; bước code kế tiếp hoàn thiện bằng chứng cổng 5, chưa mở cú sốc thiếu hàng.
- `V6.0-dev.10`: client cho M01 mang 100 g ngũ cốc vừa mua từ gian bếp H01 về kho hộ đổi dược thảo tại chợ trên `RT-ANKHE-MARKET-RETURN`. Hàng rời item nguồn ngay lúc xuất phát; người chở nằm ngoài phòng và bị giữ lịch, còn shipment hiện đường đi, thời gian dự kiến/thực tế, độ trễ, cargo cùng hao chất lượng.
- GUI bảng chợ và nhật ký hiện đủ ba trạng thái đang vận chuyển/đã giao/thất bại, tuyến, quãng đường, kho đích và lý do lỗi. Widget test điện thoại/máy tính đã thêm điểm tìm cho chuyến đại diện nhưng chưa chạy.
- Đã viết `game/tool/verify_v6_market_transport.dart` nhưng chưa chạy. Runner yêu cầu chạy liền/save-load/replay hội tụ; giữa đường không kho nào dùng được cargo để sản xuất; tới nơi bảo toàn lượng và ghi hao; ledger đích sai giữ hàng trong shipment thất bại thay vì bù ẩn.
- Phần chức năng và mã bằng chứng cổng 5 đã có nhưng chưa được chứng nhận. Lát cắt code tiếp theo chỉ phục vụ cổng 6 về cú sốc thiếu hàng nhiều hộ.
- `V6.0-dev.11`: thêm `SupplyShockState` cho cú sốc kéo dài tối thiểu hai ngày và làm mất khả dụng các lô vật thật của ít nhất hai hộ. Mỗi hộ khai báo bị ảnh hưởng phải có lượng bị rút khỏi item của chính họ; lô gián đoạn giữ mã vật, chủ, lượng, đơn vị, chất lượng và nguyên nhân trong save/hash.
- Audit mỗi ngày ghi riêng lượng cùng loại còn trong item và lượng đang in-transit của từng hộ. Hàng trên đường không được tính là tồn kho dùng ngay; khi hết hạn cú sốc chuyển `resolved` và giữ toàn bộ chuỗi ảnh chụp hữu hạn.
- Phản ứng chỉ được ghi nếu có `ProductionBatchState`, `ServiceAppointmentState` hoặc `MarketOrderState` thật thuộc đúng hộ và nằm trong thời gian cú sốc. Nhãn phản ứng không thể tự tạo bằng chứng hoặc tài nguyên.
- Lõi cổng 6 chưa nối fixture/client, GUI hoặc runner và chưa chạy. Lát cắt kế tiếp chỉ hoàn thiện một cú sốc đại diện khiến hai hộ có hai phản ứng thật.
- `V6.0-dev.12`: client mở cú sốc mưa kéo dài năm ngày, làm mất khả dụng 150 g ngũ cốc H01 và 250 g của hộ đổi dược thảo. Sau cú sốc, H01 bắt đầu mẻ hong 600 g củ thành 450 g lương thực thay thế; hộ đổi dược thảo đặt đơn mua ngũ cốc để bù kho. Hai phản ứng được nối vào batch/order thật.
- GUI hộ có bảng thiếu hàng: nguyên nhân, thời hạn, các hộ, từng lô bị gián đoạn, đối chiếu kho so với cargo đang đi và phản ứng có bằng chứng. Nhật ký có nhãn/nội dung cho bắt đầu, phản ứng, audit ngày và kết thúc; widget test điện thoại/máy tính đã thêm điểm tìm nhưng chưa chạy.
- Đã viết `game/tool/verify_v6_supply_shock.dart` nhưng chưa chạy. Runner kéo dài năm ngày, yêu cầu phản ứng giả không đổi snapshot, H01 sản xuất thực phẩm củ, H02 đổi dược thảo lấy thực phẩm thay thế, hai hộ có audit mỗi ngày, không kho âm/nguồn cứu ẩn và ledger ngũ cốc–thực phẩm–dược thảo bảo toàn theo biến đổi đã khai báo.
- Chạy liền, save/load ngày 2 và replay được yêu cầu hội tụ cùng snapshot ngày 5. Phần chức năng và mã bằng chứng cổng 6 đã có nhưng chưa được chứng nhận; bước code kế tiếp chỉ tổng hợp kịch bản 30 ngày cổng 7.
- `V6.0-dev.13`: thêm `game/tool/verify_v6_livelihood_30_days.dart`, ghép các hệ hiện có vào một fixture hai hộ chạy 30 ngày. Kịch bản có mẻ khung gùi, mẻ thực phẩm củ, dịch vụ xuyên hộ, ca lao động và trả công, offer/order/settlement, shipment trên tuyến thật cùng cú sốc năm ngày.
- Runner đối chiếu nguồn–process–đích: gỗ/sợi nằm trong workpiece và khung gùi ở kho; vật tư dịch vụ nằm trong appointment và claim đã sinh; công hoàn tất có claim được trả; thực phẩm thay thế cùng dược thảo bảo toàn qua offer/order/shipment; ngũ cốc hoạt động + vật tư dịch vụ + lô gián đoạn bằng đúng lượng đầu.
- Ở ngày 15 và 30 không còn mẻ, dịch vụ, claim, shipment hoặc audit V6 mắc kẹt; mọi item không âm. Chạy liền, save/load ngày 15 và replay được yêu cầu cùng semantic hash ngày 30. Runner chưa chạy nên chưa có hash/chứng nhận.
- Đối chiếu chín cổng V6: mã chức năng và bằng chứng cho cổng 1–8 đã có; cổng 9 là thủ tục kiểm chứng/phát hành theo yêu cầu người dùng. Không tạo thêm `dev` hoặc chiều sâu V6 trước khi chạy bằng chứng và sửa đúng lỗi phát hiện.

- `V5.0-dev.1`: mở chế độ địa hình mới riêng cho client; đường sinh cũ mặc định giữ `v2.15.0` để các fixture cũ không tự đổi nếu chưa bật V5.
- Seed nay sinh độ cao đáy/vành thung lũng, lượng mưa năm và dải khí hậu. Năm địa điểm nhận loại địa hình cùng độ cao nằm trong thung lũng; tất cả tham gia fingerprint và đi qua sự kiện/save-load.
- GUI chọn nơi sinh hiện địa hình/độ cao từng nơi; bản đồ hiện khí hậu, lượng mưa, đáy/vành và địa hình từng địa điểm.
- Danh sách hữu hạn V5 đã khóa thành tám cổng và sáu bước trong roadmap. Bước code tiếp theo là tài nguyên hữu hạn, không mở thêm loại nội dung ngoài cổng.
- `V5.0-dev.2`: sông có nước mặt, đồng có đất màu, vùng đèo có rừng gỗ cùng đá/quặng. Mỗi nguồn lưu lượng hiện tại/sức chứa, đơn vị, chất lượng, khả năng tiếp cận, lượng phục hồi năm và nguồn hình thành.
- Nguồn tự nhiên tham gia seed/fingerprint, đi qua sự kiện tạo địa điểm và save/load. Dữ liệu từ chối mã trùng, lượng âm/vượt sức chứa hoặc chỉ số ngoài 0–1000; lớp nguồn có phép trừ hữu hạn và phục hồi không vượt sức chứa để lát cắt sau nối hành động thật.
- GUI chọn nơi sinh liệt kê loại nguồn tại từng địa điểm; bản đồ hiện lượng, sức chứa, chất lượng, khả năng tiếp cận và khả năng tái tạo. Các lượng hiện tại là fixture kỹ thuật, chưa phải cân bằng đã duyệt.
- `V5.0-dev.3`: khai thác đi qua sự kiện transfer, kiểm tra người thực hiện còn ở đúng địa điểm, trừ lượng nguồn rồi tạo/cộng đúng lượng vào vật phẩm tại cùng nơi. Hai yêu cầu tranh cùng lượng không làm kho âm; yêu cầu tới sau thất bại thành fact có nguyên nhân.
- Nguồn tái tạo được lên lịch mỗi 365 ngày game, phục hồi riêng theo đúng đơn vị và không vượt sức chứa; khoáng vật có phục hồi bằng 0. Mỗi nguồn phục hồi tạo fact riêng, không cộng sai các đơn vị khác nhau.
- `V5.0-dev.4`: seed tạo sậy ven sông, cỏ/thỏ đồng và thông/mang vùng đèo. Mỗi quần thể lưu số cá thể, sức chứa, sức khỏe, tăng trưởng/tử vong năm, nguồn bắt buộc và thức ăn nếu có.
- Nhịp sinh thái chạy mỗi 365 ngày sau phục hồi tài nguyên. Hỗ trợ lấy từ tỷ lệ nguồn thật và quần thể thức ăn; thiếu nước/đất/gỗ hoặc thức ăn làm giảm sinh sản, tăng tử vong và kéo sức khỏe xuống thay vì tự hồi đầy.
- GUI nơi sinh và bản đồ hiện tên loài, số lượng/sức chứa, sức khỏe cùng phụ thuộc nguồn/thức ăn. Các loài và hệ số hiện tại là fixture kỹ thuật, chưa phải mô hình sinh thái được duyệt.
- `V5.0-dev.5`: bộ sinh hộ V5 không còn gắn cứng hai hộ mới vào đồng và chợ. Mỗi nơi ngoài lòng sông được chấm 0–1000 từ địa hình, tiếp cận nước/đất/gỗ, sức khỏe sinh thái, canh tác, giao thương và áp lực tài nguyên cuối tiền sử; hai nơi khả thi có điểm cao nhất ngoài khu nhà đã có mới nhận hộ H02/H03.
- Toàn bộ điểm, sáu thành phần giải thích, fingerprint lịch sử, trạng thái khả thi và việc được chọn đi qua sự kiện `settlement_assessed`, `WorldSite`, save/load và semantic hash. Màn chọn nơi sinh cùng bản đồ hiện điểm và lý do, còn điều kiện sinh cuối cùng vẫn kiểm tra phòng, người chăm, sữa và quyền sử dụng thật.
- Đường worldgen cũ giữ cách đặt hộ đồng/chợ và fingerprint cũ; nhánh đặt theo môi trường chỉ bật khi dùng hồ sơ V5. Hệ số/chốt 450 là fixture kỹ thuật chưa duyệt, và mã widget test mới chỉ được bổ sung điểm tìm, chưa chạy.
- `V5.0-dev.6`: khi tiền sử hoàn tất, legacy V5 đổi lượng hiện tại của nước/đất/gỗ/khoáng trong sức chứa, rồi đổi số lượng/sức khỏe quần thể theo tỷ lệ nguồn và thức ăn sau lịch sử. Mỗi thay đổi giữ mã nơi/đối tượng, lượng trước/sau và hệ số hỗ trợ trong save.
- Điểm khu dân cư nhận thêm dư âm giao thương, áp lực tài nguyên và lũ nhưng không tự xóa hộ đã được lịch sử hình thành. Validator nơi sinh chạy trên snapshot sau legacy, nên nếu kho hộ/hậu quả cuối cùng không còn nơi sinh thì thế giới bị từ chối trước khi P00 xuất hiện.
- Lịch sử dài vẫn chỉ giữ ba tóm tắt epoch, 192 bước vĩ mô và sáu mốc neo hữu hạn; `recentAnchors` tạo cửa sổ bốn mốc gần nhất cho GUI. Không lưu từng năm/từng cư dân tiền sử. Công thức môi trường `v5.0-dev.6` chỉ bật cho worldgen V5 để giữ đường V2 cũ.
- Đã viết `game/tool/verify_v5_small_worldgen.dart` làm bằng chứng hữu hạn cho cổng 6: cùng seed tái hiện cùng world/history/hộ, seed khác phải đổi kết quả; chạy liền, save/load trước khi hoàn tất tiền sử và replay phải hội tụ về cùng snapshot sau một lệnh chọn nơi sinh.
- Runner còn kiểm tra ít nhất 300 năm tiền sử, kho nén hữu hạn, ledger hậu quả thật lên nguồn/sinh thái/khu dân cư, hai nơi sinh gắn với hộ thật và P00 chỉ xuất hiện sau lựa chọn hợp lệ. Chưa chạy nên chưa có hash và chưa chứng nhận cổng.
- Mã widget hiện có kiểm tra màn nhập thế V5 ở 390×844 rồi chuyển sang bố cục rộng 1000×800, với địa hình, nguồn, sinh thái, điểm khu dân cư, lịch sử và lý do chọn nơi. Đây vẫn là bằng chứng cổng 7 chưa chạy.
- Không tăng số `dev` vì lượt này chỉ dựng bằng chứng cho chức năng đã có. Phần mã hữu hạn V5 đã dừng tại đây; cổng 6–8 vẫn chờ lượt kiểm chứng do người dùng yêu cầu.

- Thêm `ChildhoodState`: an toàn kế thừa từ gắn bó/kỳ vọng người chăm; vận động lớn/tinh, hiểu/tạo lời và bốn loại kinh nghiệm đi qua save/load.
- Client bật mốc `childhood_started` cho P00 ở ngày 31. Sau đó một sự kiện mỗi ngày cập nhật trưởng thành tới sáu năm, không nhảy tuổi và không làm đổi fixture cũ nếu chưa bật.
- Người chơi có thể quan sát, thử phát âm, tập với/giữ vật và chơi vận động khi trạng thái thật mở hoạt động; GUI ưu tiên bảng tuổi thơ sau ngày 31.
- `V4.0-dev.3`: tập với/giữ vật chiếm 15 phút, chơi vận động chiếm 30 phút; cam kết khóa hoạt động chồng lấn. Bắt đầu và kết thúc đều kiểm tra phòng/vật thật, năng lực quyết định kết quả, vật hao mòn và trạng thái lưu tổng lần thành công/thất bại.
- Một `child_play_object` có vị trí, chủ hộ, phòng, số lượng và độ bền được chuẩn bị khi bật đường V4; nó đi qua cùng hệ vật phẩm/save hiện có.
- GUI hiện hoạt động đang chạy, thời gian còn lại, kết quả gần nhất, phòng/vật đã dùng và tổng lần thành công/thất bại.
- `V4.0-dev.4`: quan sát và phát âm đều chiếm 5 phút. Quan sát cần vật thật ở gần; phát âm cần NPC rảnh trong cùng phòng và giữ thời gian của cả trẻ lẫn người đáp lời.
- Thành công mới tạo `BeliefState` riêng cho trẻ. Bằng chứng giữ khái niệm/tóm tắt, hoạt động học, người hoặc vật nguồn, cách tiếp nhận, thời điểm và độ tin cậy; học thất bại chỉ tăng kinh nghiệm và ghi nguyên nhân.
- GUI hiện tổng lượt học, thành công/thất bại và tối đa bốn điều đã học gần nhất cùng nguồn của từng điều.
- `V4.0-dev.5`: trẻ xếp hạng người để đáp lời hoặc cứu giúp bằng an toàn/dễ đoán đã học, quan hệ một chiều, vai trò gia đình và kỹ năng chăm; điểm lựa chọn hiện trên GUI.
- Mất thăng bằng khi chơi là nguy hiểm hữu hạn đầu tiên. Năng lực quyết định trẻ nhận ra sớm hay ngã/khóc; người chăm được chọn theo gắn bó, giữ thời gian và tới trấn an. Được đáp ứng hoặc bỏ mặc đổi cảm giác an toàn và quan hệ hai chiều.
- Trạng thái lưu số sự cố, số lần nhận ra trước khi chịu hại, số lần được người chăm giải quyết cùng toàn bộ sự cố gần nhất: mức nặng, phản ứng, người tìm đến, kết quả và thay đổi tâm lý.
- `V4.0-dev.6`: mỗi hoạt động và sự cố tạo một lần nhớ có thời điểm, kết quả, độ quan trọng và mã nguồn. Tối đa 64 ký ức gần được giữ chi tiết; ký ức cũ thành tóm tắt theo tháng, sự kiện từ 700 điểm thành tối đa 32 ký ức nổi bật, và tối đa 84 giai đoạn tóm tắt.
- Ảnh hưởng nguy hiểm còn chờ xử lý không bị nén. Tri thức đã học vẫn giữ nguồn chính xác trong `BeliefState`; khi phần chi tiết thường bị bỏ, bản tóm tắt vẫn giữ đếm loại/kết quả/nguy hiểm cùng tối đa tám mã nguồn.
- GUI hiện ký ức gần, ký ức nổi bật, tóm tắt và tổng lượng đã nén. Save/load giữ cả bốn lớp dữ liệu.
- `V4.0-dev.7`: cơ thể tuổi thơ nối từ cân nặng, mức đói và mất nước thật ở cuối tháng sơ sinh. Mỗi ngày trẻ lấy khẩu phần thức ăn/nước có thật từ kho hộ; thiếu kho cho khẩu phần thiếu thay vì sinh tài nguyên.
- Cơ thể lưu cân nặng thật/mốc khỏe, dinh dưỡng, đủ nước, lượng ăn/uống tích lũy, tăng cân gần nhất và số ngày tăng trưởng đủ/bị hạn chế. Save/load giữ toàn bộ trạng thái.
- Tốc độ trưởng thành nền tích lũy theo ngày tương đương được cơ thể hỗ trợ, nên chỉ tăng tuổi không còn tự cấp cùng lượng năng lực khi suy dinh dưỡng hoặc thiếu nước. Tình trạng cơ thể cũng giảm hiệu quả quan sát, phát âm, vận động, chơi và nhận biết nguy hiểm.
- GUI hiện cơ thể, khẩu phần, mức hỗ trợ và ngày trưởng thành tương đương; nhật ký giữ nguồn khẩu phần cùng lượng kho đã tiêu.
- Đối chiếu mã với tám cổng V4: phần chức năng của cổng 1–7 đã có; cổng 7 còn cần bằng chứng chạy, cổng 8 là thủ tục phát hành chỉ chạy khi người dùng yêu cầu. Không mở thêm lát cắt tính năng V4 trước bằng chứng.
- Đã viết `game/tool/verify_v4_childhood_six_years.dart` nhưng chưa chạy. Runner dựng cùng một chuỗi lệnh ba lần: chạy liền, save/load ở năm thứ ba và replay; kiểm tra sáu năm liên tục, cơ thể có ngày đủ/thiếu, bốn hoạt động, gắn bó, nguy hiểm được trấn an, nguồn tri thức, giới hạn ký ức và trạng thái cuối xác định.
- Runner dùng kho và các đợt tiếp tế fixture có nguồn vật phẩm thật; các con số này chỉ phục vụ đóng cổng V4, không phải cân bằng đã duyệt. Không tăng số `dev` vì không thêm tính năng.
- Đã viết thêm hai widget test V4 ở 390×844 và 1280×800. Fixture giao diện có đủ bốn lệnh tuổi thơ cùng bảng giai đoạn, cơ thể, kinh nghiệm/kết quả hoạt động, xu hướng tìm người chăm, nguy hiểm và ký ức gần/nổi bật/tóm tắt; đây là mã bằng chứng chưa chạy, không cộng vào mốc ổn định 20/20.
- Kiểm tra cú pháp hẹp: `dart analyze` game đạt từ lượt trước. Lệnh Dart formatter cho file widget test mới không hoàn tất trong sandbox và đã được dừng; analyzer client cũng chưa nạp được các gói Flutter đã cache, nên mã test mới chưa được ghi là đạt. Chưa chạy runner, widget test, catalog, build web, commit/push hoặc triển khai.

## Cách nhận lượt

1. Đồng bộ `master` từ GitHub và kiểm tra working tree sạch.
2. Đọc [[STATE]], [[DECISIONS]], [[MASTER_PLAN]] và hồ sơ K5 gần nhất.
3. Nếu người dùng yêu cầu V4, đối chiếu mã hiện có với cổng V4 trước khi chọn lát cắt; không tự mở rộng phạm vi.
4. Ghi chủ lượt, mục tiêu, nhánh và việc đang dở vào file này nếu công việc kéo dài qua phiên.

## Cách kết thúc lượt

- Khi chỉ được yêu cầu viết mã: ghi đúng phần chưa kiểm chứng; không push `master`.
- Khi người dùng yêu cầu kiểm chứng/GitHub: chạy đầy đủ analyzer, runner, widget test, catalog và web build; hoàn thiện hồ sơ rồi commit/push `master`.
- Nếu sắp hết giới hạn khi còn dở: cập nhật file này, commit `WIP:` lên `handoff/<tên-lát-cắt>` và push nhánh; không đưa WIP vào `master`.

## Liên kết

- [[STATE]]
- [[DECISIONS]]
- [[MASTER_PLAN]]
- [[CHANGELOG]]
- [[CHUYEN_GIAO]]
- [[LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC]]
