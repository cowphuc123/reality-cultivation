---
aliases: [Thời gian thế giới]
tags: [thiet-ke, nen-tang]
status: de-xuat
updated: 2026-09-05
---

# Thời gian thế giới — đặc tả 0.1

Liên quan: [[MASTER_PLAN|Kế hoạch tổng thể]] · [[HANH_DONG|Hành động và mục tiêu]] · [[DECISIONS|Quyết định]].

> Trạng thái: bản thiết kế đề xuất. Người dùng đã yêu cầu mô phỏng liên tục với 5 giây ngoài đời bằng 1 ngày game. Các quy tắc còn lại chưa được xác nhận.

## 1. Thời gian phải tạo ra điều gì?

Thời gian làm cây lớn, cơ thể già đi, thương tích biến đổi, hàng hóa được vận chuyển và quan hệ phát triển. Nhân vật luyện công ba ngày thì những người khác cũng sống qua ba ngày đó. Không có một đồng hồ riêng cho người chơi và một đồng hồ đứng yên cho thế giới.

Người chơi quyết định lịch sống, ưu tiên và mức rủi ro. Không cần bấm ăn, ngủ, luyện công mỗi ngày.

## 2. Quy đổi và hệ quả gameplay

| Khoảng trong game | Ngoài đời ở tốc độ mặc định |
| --- | --- |
| 1 phút | Khoảng 0,00347 giây |
| 1 giờ | Khoảng 0,2083 giây |
| 1 ngày | 5 giây |
| 30 ngày | 2 phút 30 giây |
| 360 ngày | 30 phút |

Dòng cuối chỉ là quy đổi 360 ngày, chưa chốt năm có 360 ngày. Một trận đánh kéo dài một phút game sẽ quá nhanh để người chơi phản ứng trực tiếp. Vì vậy điều khiển bằng chính sách và khả năng dừng cần được thiết kế ngay từ đầu.

## 3. Đồng hồ mô phỏng và lịch hiển thị

Đề xuất dùng số nguyên đếm mili giây game từ mốc khởi đầu. Độ phân giải này không có nghĩa phải cập nhật mọi người mỗi mili giây; chỉ xử lý khi có việc cần thay đổi.

Lịch hiển thị được chuyển từ đồng hồ: giờ, ngày, tháng, năm, mùa. Tạm dùng ngày 24 giờ để đặc tả; độ dài tháng/năm, tên lịch, thời tiết và mùa của thế giới chưa chốt. Dữ liệu lịch phải thay được mà không đổi tuổi thực hay thời lượng hành động đã lưu.

Thời gian mô phỏng chỉ tăng. Chỉnh ngày giờ máy tính không làm thế giới nhảy tuổi. Tạm dừng đóng băng thời gian game, không tăng đói, tuổi, tiền thuê hay tiến độ.

## 4. Sự kiện và quá trình kéo dài

Sự kiện là một thay đổi tại thời điểm xác định: tới nơi, hoàn tất băng bó, cửa hàng mở, hàng được giao.

Quá trình là thay đổi theo thời lượng: đi đường, mất nước, chảy máu, hấp thu linh khí. Nó có trạng thái đã tính tới thời điểm nào, tốc độ biến đổi và mốc cần kiểm tra tiếp theo.

Mỗi quá trình phải cung cấp:

| Thành phần | Ý nghĩa |
| --- | --- |
| Chủ thể và nguồn | Ai/cái gì đang thay đổi, nguyên nhân nào tạo ra |
| Mốc cập nhật cuối | Tránh tính trùng thời lượng |
| Quy tắc tiến triển | Cách trạng thái thay đổi trong khoảng thời gian |
| Ngưỡng quan trọng tiếp theo | Ví dụ mất khả năng đứng, đủ tiến độ chế tác |
| Điều kiện làm đổi tốc độ | Bị thương, đổi công cụ, trời mưa, được điều trị |
| Phiên bản | Nhận ra dự báo cũ đã hết hiệu lực |

Khi điều kiện đổi, tính đoạn cũ tới thời điểm thay đổi rồi mới áp dụng tốc độ mới. Không áp tốc độ mới ngược cho cả ngày.

## 5. Vòng xử lý

1. Nhận lệnh người chơi tại ranh giới xử lý an toàn; ghi nhận thời điểm game tiếp nhận.
2. Tìm mốc sự kiện hoặc ngưỡng sớm nhất cần giải quyết trong khoảng muốn chạy.
3. Tiến triển các quá trình liên quan tới mốc đó; không vượt qua ngưỡng nguy cấp chưa xử lý.
4. Giải quyết sự kiện, tạo hậu quả và thông báo cho các hệ thống bị ảnh hưởng.
5. Cập nhật lịch xử lý tiếp theo, đánh giá điều kiện tự dừng.
6. Tiếp tục tới thời điểm mục tiêu nếu chưa dừng.

Màn hình có thể cập nhật ít lần hơn mô phỏng. Nhật ký gộp công việc lặp lại, giữ riêng biến cố quan trọng.

## 6. Sự kiện cùng thời điểm

Thứ tự tám pha và hồ sơ ScheduledEvent/FactEvent cụ thể hóa tại [[LUOC_DO_TRANG_THAI]], mục 7–9. Quy tắc mới vẫn là đề xuất chưa chạy.

Quy tắc pha liên hệ được bổ sung trong [[LIEN_KET_HE_THONG]], mục 3: tính đoạn cũ; giải quyết nhóm tác động; sau đó kích hoạt trạng thái duy trì mới và quyết định tiếp. Hiệu ứng hết hạn đúng mốc không còn hiệu lực; hiệu ứng mới hoàn tất không bảo vệ nhóm tác động cùng mốc. Đây vẫn là đề xuất thiết kế.

Không để thứ tự tên nhân vật hoặc thứ tự đọc file quyết định ai luôn thắng.

- Những hành động được coi là đồng thời đọc cùng trạng thái trước tác động. Hai đòn đã tới thời điểm trúng có thể cùng gây thương tích.
- Sau khi tổng hợp hậu quả mới tính bất tỉnh, chết, ngắt công việc và quyết định mới.
- Tài nguyên độc quyền như một món hàng cuối phải qua phân xử riêng: quyền đã được cam kết hợp lệ, thứ tự đến; trường hợp thực sự hòa dùng ngẫu nhiên được lưu để tái hiện.
- Một sự kiện do sự kiện khác sinh ra giữ quan hệ nguyên nhân, không được quay ngược thời gian.
- Giới hạn chuỗi sự kiện không tiêu hao thời gian để ngăn vòng lặp vô hạn; báo lỗi mô phỏng thay vì làm treo ứng dụng.

Quy tắc cụ thể cho chữa trị và sát thương cùng mốc cần được đối chiếu trong đặc tả cơ thể. Đề xuất chỉ hiệu lực điều trị đã hoàn tất trước khoảng tổn thương mới ảnh hưởng khoảng đó, không hồi tố.

Đã bổ sung quy tắc đề xuất trong [[CO_THE|đặc tả cơ thể]], mục 13: tính quá trình cũ tới mốc trước; can thiệp có hiệu lực từ mốc hoàn tất sau khi kiểm tra vị trí và điều kiện còn hợp lệ; không hoàn lại tổn hại của khoảng trước đó.

## 7. Dừng và tốc độ

Đề xuất có ba trạng thái: đang chạy ở tốc độ mặc định; tạm dừng bởi người chơi; tự dừng vì tình huống cần chú ý. Chưa chốt thêm tốc độ nhanh/chậm.

| Tình huống | Hành vi mặc định đề xuất |
| --- | --- |
| Hoàn tất công việc thường ngày | Gộp nhật ký, tiếp tục |
| Thiếu nguyên liệu nhưng có phương án trong giới hạn | Tự điều chỉnh và ghi lý do |
| Không còn phương án hợp lệ | Báo một lần; làm việc dự phòng |
| Nhận biết bị tấn công hoặc thương tích nguy cấp | Dừng và hiển thị lựa chọn |
| Cần cam kết vượt ngân sách/rủi ro được giao | Chờ lệnh, không tự vượt giới hạn |
| Chuẩn bị bước đột phá có rủi ro lớn | Dừng trước bước cam kết |

Tự dừng dựa trên điều nhân vật nhận biết, không tiết lộ kẻ phục kích chưa bị phát hiện. Dừng sau một đòn bất ngờ không xóa thương tích đã xảy ra. Khi tiếp tục, quy tắc chiến đấu đã đặt sẽ điều khiển nhân vật.

Một cảnh báo đã được xử lý không dừng lặp lại ngay nếu không có thay đổi mới. Khi bất tỉnh, người chơi chỉ sửa kế hoạch tương lai; không điều khiển cơ thể đang mất ý thức.

## 8. Khi máy không chạy kịp

Tốc độ 5 giây/ngày là mục tiêu khi đủ hiệu năng. Nếu quá tải, giảm tốc độ thời gian thực đạt được và hiển thị rõ; không bỏ qua thương tích hoặc tự cấp kết quả để đuổi kịp đồng hồ ngoài đời.

Không xử lý một khối dài tới mức nút dừng không phản hồi. Mục tiêu kỹ thuật tạm: tiếp nhận thao tác dừng trong khoảng 100 ms trên cấu hình kiểm chứng sẽ chọn sau; đây chưa phải số đo đã đạt.

Tính trực tiếp mốc tiếp theo thay vì quét mọi NPC theo từng giây. Chia đợt công việc để giao diện còn phản hồi, nhưng giữ thứ tự thời gian nhất quán.

## 9. Vùng xa và mức mô phỏng

Nguyên tắc dài hạn: chỉ giản lược khi không bỏ mất hậu quả quan trọng. Người có giao hẹn, truy đuổi, thương tích nguy hiểm hoặc tài nguyên đang tranh chấp phải giữ lịch sự kiện phù hợp dù ở xa.

Không tạo lịch sử giả khi người chơi đến. Những giao dịch hoặc cái chết đã được mô phỏng phải giữ nguyên. Trước tương tác xuyên vùng, đưa các chủ thể liên quan tới cùng mốc thời gian.

Bản kiểm chứng đầu nên dùng một mức chi tiết trong vùng nhỏ. Chỉ bổ sung mô phỏng tổng hợp sau khi có dữ liệu hiệu năng; không mặc định việc tổng hợp sẽ giống hệt mô phỏng chi tiết. Cần xác định sai số chấp nhận được cho tài nguyên và dân số trước khi áp dụng.

## 10. Lưu, tải và đóng game

Bản đầu đề xuất đóng game thì ngừng thế giới. Khi tải, trở lại đúng thời điểm lưu, không cộng khoảng vắng mặt.

Bản lưu cần chứa đồng hồ, trạng thái chủ thể, công việc đang làm, tiến độ quá trình, lệnh đã tiếp nhận, đặt chỗ tài nguyên, sự kiện chờ, trạng thái bộ sinh ngẫu nhiên và phiên bản quy tắc/dữ liệu.

Lưu tại ranh giới mà một nhóm thay đổi đã hoàn tất; không lưu cảnh tiền đã trừ nhưng đồ chưa giao. Lưu định kỳ chỉ là dự phòng, không thay thiết kế nhất quán.

Tái hiện cùng kết quả yêu cầu cùng bản lưu, cùng chuỗi lệnh được gắn thời điểm và cùng phiên bản mô phỏng. Đổi quy tắc game có thể cần chuyển đổi bản lưu.

## 11. Ví dụ xuyên hệ thống

06:00: nhân vật bắt đầu hành trình tới ruộng, dự kiến 30 phút.

06:10: bị thương chân; chặng đã đi được giữ nguyên. Hệ cơ thể cập nhật năng lực di chuyển, hành trình tính lại đoạn còn lại, hủy mốc tới nơi cũ.

06:12: nhân vật nhận biết nguy cơ và chọn quay về theo chính sách. Thời gian và đường đi trở về vẫn phải trả đủ.

06:30: mốc đến ruộng cũ xuất hiện trong hàng đợi nhưng bị bỏ qua vì phiên bản hành trình đã đổi. Không được dịch chuyển nhân vật tới ruộng.

Những giờ phút trên là tình huống kiểm chứng hư cấu, không phải công thức thương tích.

## 12. Tiêu chí kiểm chứng khi triển khai

- Chạy đủ 5 giây ngoài đời khi không dừng/quá tải tiến đúng 1 ngày game, trong sai số điều phối đã công bố.
- Tạm dừng 10 phút ngoài đời không làm thay đổi thế giới.
- Chạy một khoảng theo nhiều đợt giao diện khác nhau cho cùng kết quả với cùng chuỗi lệnh.
- Tải giữa hành trình giữ vị trí, tiến độ, đích và kết quả tiếp theo.
- Thay tốc độ di chuyển không để sự kiện đến nơi cũ còn hiệu lực.
- Tổn thương nguy cấp giữa ngày được xử lý trước khi cho nhân vật hoàn tất công việc cuối ngày.
- Đánh đồng thời không ưu tiên ngầm nhân vật có mã nhỏ hơn.
- Máy chậm không làm mất sự kiện; lệnh dừng vẫn được tiếp nhận.

## 13. Còn cần chốt

Cho phép dừng/tự dừng; có tốc độ khác không; có chạy khi đóng game không; cấu trúc lịch; quy tắc điều khiển chiến đấu chi tiết. Các đề xuất này không thay đổi yêu cầu 5 giây bằng 1 ngày ở tốc độ mặc định.
