---
aliases: [Liên kết và rà soát hệ thống]
tags: [thiet-ke, kien-truc, ra-soat]
status: de-xuat
updated: 2026-09-05
---

# Liên kết và rà soát hệ thống — 0.1

Liên quan: [[MASTER_PLAN]] · [[BAN_CHOI_THU]] · [[DECISIONS]].

> Rà soát thiết kế trên các điểm giao nhau của chín đặc tả. Chưa là kiểm chứng phần mềm, rà soát mọi công thức hoặc xác nhận của người dùng. Các phân công và quy tắc mới vẫn là đề xuất.

## 1. Kết quả rà soát

Chín hệ thống có cùng định hướng: thời gian chung, tài nguyên có nguồn, nhận thức có giới hạn và hậu quả bền vững. Các khoảng trống đáng chú ý nằm ở quyền cập nhật dữ liệu và thứ tự thay đổi tại một thời điểm, không phải thiếu thêm danh sách nội dung.

| ID | Điểm giao nhau và nguồn | Vấn đề | Cách xử lý đề xuất |
| --- | --- | --- | --- |
| LK01 | THOI_GIAN mục 6; CHIEN_DAU mục 12; CO_THE mục 13 | Phòng thủ/chữa trị hoàn tất cùng mốc tác động chưa có thứ tự đầy đủ | Dùng quy tắc pha ở mục 3; hiệu ứng mới không hồi tố hoặc bảo vệ chính nhóm tác động cùng mốc |
| LK02 | CO_THE mục 15; TU_LUYEN mục 4; VAT_PHAM mục 19; MOI_TRUONG mục 13 | Cấu trúc chứa, lượng chứa và quy trình chuyển dễ có nhiều bên ghi | Chia trách nhiệm theo bảng mục 2; chuyển liên hệ là một giao dịch |
| LK03 | NPC mục 8, 14; KINH_TE_TO_CHUC mục 4 | Ký ức lời hứa và hợp đồng khách quan có thể bị lưu trùng | Một sổ cam kết; NPC giữ nhận thức/thái độ và tham chiếu |
| LK04 | VAT_PHAM mục 10; KINH_TE_TO_CHUC mục 13 | Kiểm tra quyền có thể làm lộ tin thu hồi quyền ở xa | Phân biệt quyền được công nhận, bằng chứng người thi hành biết và kiểm soát vật lý |
| LK05 | MOI_TRUONG mục 2; CHIEN_DAU mục 4; HANH_DONG mục 10 | Hành trình theo mạng và vị trí cục bộ có thể dịch chuyển chủ thể khi đổi cách tính | Một hồ sơ vị trí; chuyển biểu diễn có quy tắc bảo toàn tiến độ |
| LK06 | NPC mục 10; MOI_TRUONG mục 16 | Chống lặp nguồn tin có thể vô tình dùng thông tin bí mật để giúp NPC suy luận | Lưu nguồn nội bộ để tránh áp dụng trùng, chỉ cho người suy luận dùng nguồn họ biết |
| LK07 | THOI_GIAN mục 9; MOI_TRUONG mục 18; các tiêu chí tái hiện | Tái hiện chính xác dễ bị hiểu nhầm là mọi mức xấp xỉ cho cùng kết quả | Cùng phiên bản/mức mô phỏng phải tái hiện; so mức khác cần sai số riêng |
| LK08 | THOI_GIAN mục 3; TU_LUYEN mục 13, 21 | Đồng hồ dài hạn thiếu quy tắc tràn số và chuyển đơn vị | Đơn vị thời gian rõ, kiểm tra miền số khi chọn công nghệ, không mặc định mọi kiểu số đều đủ |

Các mục này được làm rõ ở mức văn bản, chưa chứng minh đã hết lỗi hoặc đủ điều kiện lập trình toàn bộ game.

## 2. Một nguồn dữ liệu cho mỗi trạng thái

| Dữ liệu | Nơi quản lý chính | Các hệ khác làm gì |
| --- | --- | --- |
| Đồng hồ, thứ tự sự kiện, trạng thái ngẫu nhiên | THOI_GIAN | Đặt lịch, gửi yêu cầu, không tự tăng đồng hồ riêng |
| Vị trí chủ thể và liên kết không gian | MOI_TRUONG | Hành động yêu cầu di chuyển; chiến đấu yêu cầu thay đổi cục bộ |
| Mục tiêu đang thực thi, pha, tiến độ, chiếm năng lực | HANH_DONG | NPC/người chơi sinh ý định; hệ chuyên môn định nghĩa hiệu ứng |
| Bộ phận, thương tích, chức năng, cấu trúc kinh mạch | CO_THE | Tu luyện yêu cầu biến đổi; chiến đấu gửi tác động |
| Hiểu biết, ký ức, quan hệ, cảm xúc | NPC | Nhận quan sát có nguồn, không nhận toàn bộ trạng thái bí mật |
| Vật thể/lô, thành phần, vị trí chứa, tình trạng | VAT_PHAM | Các hệ gửi yêu cầu chuyển/tiêu/biến đổi |
| Lượng linh lực trong cá thể, tiến trình công pháp | TU_LUYEN | Đọc giới hạn cấu trúc từ cơ thể; không tự sửa mô |
| Nước, quần thể, nguồn linh khí môi trường | MOI_TRUONG | Khai thác/hấp thu chuyển lượng qua giao dịch |
| Lượng năng lượng còn trong vật cấp nguồn | VAT_PHAM | TU_LUYEN rút qua giao dịch, không giữ số dư sao chép |
| Chủ sở hữu được công nhận, quyền, hợp đồng/nợ | KINH_TE_TO_CHUC | Vật phẩm tham chiếu quyền; NPC giữ hiểu biết về quyền |
| Tiền vật chất | VAT_PHAM | Kinh tế ghi giao dịch và tổng hợp số dư từ lượng thật |
| Nghĩa vụ tiền/quyền thanh toán không phải tiền mặt | KINH_TE_TO_CHUC | Không tự coi nghĩa vụ là tiền có thể chi |
| Quy tắc tiếp xúc, phòng hộ và tác động giao chiến | CHIEN_DAU | Tính yêu cầu hiệu ứng; kết quả ghi ở cơ thể/vật phẩm |

“Quản lý” là trách nhiệm logic, chưa quyết định cách chia file mã nguồn hay cơ sở dữ liệu. Hiệu suất có thể dùng dữ liệu tính sẵn nhưng phải có nguồn, phiên bản và cách làm mới; không thành bản thật thứ hai.

Giữ chỗ năng lực thuộc hành động, giữ chỗ lượng vật thuộc vật phẩm, ngân sách thuộc kinh tế. Mã giao dịch liên kết chúng để hủy hoặc thực hiện nhất quán.

## 3. Thứ tự một mốc thời gian

K0.1 tại [[LUOC_DO_TRANG_THAI]] chuyển quy ước này thành tám pha đánh số 10–80 và cấu trúc sự kiện/giao dịch đề xuất. Đây chưa phải bộ xử lý đã triển khai.

Quy tắc đề xuất cho mốc t:

1. Tính quá trình đã tồn tại tới t, dừng ở ngưỡng sớm hơn nếu phát hiện. Không để nguồn âm trong đoạn.
2. Xác định hiệu ứng cũ còn hiệu lực tại t. Khoảng hiệu lực đề xuất là [bắt đầu, kết thúc): hết hạn đúng t thì không còn hiệu lực tại t.
3. Kiểm tra phiên bản/điều kiện, phân xử nguồn còn cần và chuẩn bị nhóm tác động đã cam kết hợp lệ. Phần dự trữ đã giữ không bị trừ lần nữa.
4. Giải quyết các tác động tức thời cùng nhóm trên trạng thái trước nhóm; tổng hợp thay đổi, giới hạn mô/nguồn dùng chung. Không áp thứ tự mã nhân vật như ưu thế chiến đấu.
5. Kiểm tra lại điều kiện và kích hoạt các trạng thái duy trì vừa hoàn tất ở t. Chúng có tác dụng cho đoạn sau t, không bảo vệ nhóm vừa giải quyết. Vị trí đã mất hoặc nguồn đã hỏng khiến kích hoạt có thể thất bại theo hành động.
6. Tính lại chức năng, ngắt việc mất điều kiện, tạo quan sát, tiếp nhận quyết định/lệnh mới và lên lịch tiếp. Dừng/lưu chỉ sau nhóm thay đổi nhất quán.

Ví dụ: thế đỡ hoàn tất đúng t không đỡ đòn cùng nhóm t; hoàn tất sớm hơn một đơn vị thời gian và còn hiệu lực thì có thể. Băng hoàn tất ở t không hoàn lại mất máu trước t. Đây là quy ước phân xử game, không tuyên bố quy luật tự nhiên.

Đòn hồi phục tức thời, nếu được thêm sau, là một loại tác động có quy tắc riêng; không được tự xếp thành trạng thái duy trì để lách thứ tự. Sự kiện con ở cùng t giữ quan hệ nhân quả và chạy ở nhóm sau với giới hạn vòng lặp; không chèn ngược vào nhóm đã xong.

## 4. Giao dịch qua nhiều hệ

Mỗi chuyển đổi có mã, chủ thể, thời điểm, nguồn/đích, lượng/đơn vị, phiên bản điều kiện, thay đổi dự kiến và trạng thái đã áp dụng. Kiểm tra đủ điều kiện rồi ghi tất cả thay đổi liên quan hoặc không ghi phần nào của giao dịch đó.

Ví dụ dùng một phần thuốc: trừ phần vật phẩm → ghi nguồn tác động vào cơ thể → cập nhật phần còn và lịch hiệu ứng, cùng một giao dịch. Không trừ ở hành động rồi lại trừ ở cơ thể. Tác dụng kéo dài về sau là quá trình riêng đã được tạo, không áp toàn bộ tương lai ngay lúc uống.

Ví dụ hấp thu: trừ nguồn môi trường/vật → cộng lượng đã chuyển hóa vào kho cá thể và phần thất thoát được khai báo. Giới hạn chứa do CO_THE cung cấp. Hành động chỉ nhận kết quả để cập nhật tiến độ.

Nếu hành động dài đã có các giao dịch hoàn tất ở mốc trước, hủy hành động chỉ dừng phần tương lai; không hoàn tác lịch sử thật. Đây khác việc một giao dịch tại mốc hiện tại bị từ chối vì điều kiện không đủ.

## 5. Quyền và thông tin

Quyền được công nhận là trạng thái theo thể chế. Người giữ kho thực thi dựa trên lệnh/bằng chứng đã nhận và kiểm soát vật lý. Nếu chưa biết quyền đã bị thu hồi, họ có thể giao đồ theo bằng chứng cũ; hệ ghi giao đồ thật và khả năng tranh chấp, không chặn bằng một thông báo tiết lộ tin bí mật.

Một khóa/trận pháp kiểm tra quyền tức thời chỉ được làm vậy khi có cơ chế nhận/cập nhật quyền thật, với chi phí và giới hạn. Không mặc định tồn tại hệ xác thực toàn thế giới.

Kiểm tra quyền trong đặc tả hành động/vật phẩm cần được hiểu theo cách thực thi đã khai báo: giao dịch chính thức kiểm tra căn cứ, còn hành động trái phép vẫn có thể xảy ra qua phương thức khác. Cấm người chơi tự động tiêu vật dự phòng là giới hạn điều khiển đã giao, không cùng loại với luật xã hội.

## 6. Vị trí và nhận thức

Vị trí đang đi trên tuyến gồm tuyến, hướng và tiến độ; trong địa điểm gồm địa điểm và tọa độ cục bộ. Chuyển qua điểm nối giữ vị trí tương đương và không trả thêm/hoàn lại quãng đường đã đi. Chỉ một biểu diễn thật đang hoạt động, bản đồ chữ là phép chiếu.

Sự kiện thế giới tạo quan sát qua khả năng cảm nhận hoặc kênh liên lạc. Sổ nội bộ có thể biết người gây ra, nhưng bản quan sát có thể chỉ có “người che mặt”. Quyết định chỉ nhận bản quan sát phù hợp.

Chống áp dụng lặp dùng mã sự kiện nội bộ; suy luận độ tin cậy chỉ dùng bằng chứng nguồn NPC biết. NPC có thể bị lừa bởi nhiều bản kể, nhưng cùng một thông điệp không được giao vô hạn như các sự kiện mới miễn phí.

## 7. Tái hiện và mức xấp xỉ

Cùng bản lưu, phiên bản quy tắc/dữ liệu, mức mô phỏng và chuỗi lệnh gắn thời điểm phải tái hiện kết quả. Đổi tốc độ vẽ giao diện không đổi diễn biến.

Thay mức mô phỏng hoặc cách xấp xỉ có thể đổi kết quả. Trước áp dụng cần ngưỡng sai số lượng/quần thể và những điều không được sai như mã người, cam kết, vị trí vật đang giao. Bản kiểm chứng đầu đề xuất chưa dùng vùng xa tổng hợp.

Lưu có phiên bản lược đồ, dấu mốc ổn định và các hồ sơ nguồn đang được tham chiếu. Kiểu số cho mili giây, lượng vật và năng lượng phải có miền đủ cho thời gian mục tiêu; cần kiểm tra tràn/độ chính xác khi chốt công nghệ, không chọn theo tên kiểu dữ liệu.

## 8. Những phần chưa đủ để lập trình toàn bộ game

Rà soát mới nhất: [[KIEM_TOAN_TICH_HOP]] tổng hợp DL01–DL06, phát hiện các mắt xích còn thiếu và xếp K0/K1/K2. Bảng này không thay bằng chứng từ mô phỏng.

- Chưa có danh mục dữ liệu kiểm chứng với đơn vị và thông số đầy đủ.
- Chưa chốt các lựa chọn trải nghiệm: dừng, đóng game, quyền tự động, hậu quả chết.
- Chưa chốt công thức tiến trình, giải phẫu theo chặng, hình học hoặc hệ cảnh giới.
- Chưa có giao diện chơi hoàn chỉnh, công cụ giải thích lỗi hay kiểm chứng hiệu năng.
- Chưa rà soát định lượng mọi tương tác; bản này chỉ giải quyết các điểm giao nhau đã nhận diện.

Đề xuất tiếp tục bằng [[BAN_CHOI_THU|kịch bản tích hợp]], rồi đặc tả dữ liệu khởi đầu và giao diện. Không cần phát minh thêm hàng trăm tính năng trước khi những chuỗi hiện có đủ cụ thể để kiểm chứng.
