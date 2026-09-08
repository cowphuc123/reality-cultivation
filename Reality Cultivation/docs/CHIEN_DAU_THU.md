---
aliases:
  - Chiến đấu thử An Khê
  - DL06
tags:
  - thiet-ke
  - chien-dau
status: de-xuat
---

# Vị trí, tiếp xúc và hậu quả giao chiến — DL06

Ngày: 2026-09-05. Bổ sung [[CHIEN_DAU]], [[CO_THE_THU]], [[VAT_THE_THU]], [[CONG_VIEC_THU]] và [[TU_LUYEN_THU]]. Đây là bộ tình huống hư cấu để kiểm chứng hệ thống; không phải cân bằng chiến đấu cuối, kỹ thuật võ thuật ngoài đời hoặc biến cố bắt buộc trong INIT-A.

## 1. INIT-E là trạng thái thử riêng

Khu thử E-01 nằm trong D07, hình chữ nhật 12.000 × 6.000 mm. Trục x chạy tây→đông, trục y nam→bắc. Lối về D01 ở cạnh tây, lối tới D08 ở cạnh đông. Nền phẳng, khô, đủ sáng; không có vật cản trong nhánh cơ sở. Tọa độ cục bộ là vị trí thật, nhãn “gần” hoặc “trong tầm” chỉ là giá trị suy ra.

N17 ở (3.000; 3.000), quay 0° về đông. P00 ở (5.000; 3.000), quay 180° về tây. Mỗi người chiếm hình tròn bán kính 300 mm; hai vùng không được chồng lên nhau khi đứng. Cả hai khỏe, F = 0, đã biết đây là buổi thử và thấy nhau; không dùng cơ chế phục kích.

O03 cho mượn hai V29 kiếm gỗ và một V30 tấm phòng hộ qua giao dịch khởi tạo được ghi rõ. N17 cầm kiếm tay phải. P00 cầm kiếm tay phải, tấm phòng hộ tay trái. Áo V20 của P00 trong biến thể này có tay áo che cẳng tay, để R cùn = 2 có vùng che xác định. Quyền sở hữu vẫn thuộc O03; kết thúc buổi thử không tự trả vật từ xa.

Chính sách hai bên: chỉ đánh bằng V29, dừng sau một tiếp xúc có thương tích, chấp nhận lời dừng nghe rõ, không truy đuổi ra khỏi E-01. Đây là thỏa thuận thử; một kẻ thù thật có thể vi phạm theo động cơ và hậu quả xã hội.

## 2. Vị trí, hướng và vùng cơ thể

Vị trí lưu x/y theo mm nguyên, hướng theo phần nghìn độ và tư thế đứng/quỳ/ngã. Di chuyển có điểm đầu, điểm đích, thời gian bắt đầu và vận tốc; tại mốc sự kiện phải tích phân tới đúng mốc rồi mới xét tiếp xúc. Không dịch chuyển theo ô chỉ vì văn bản nói “áp sát”.

Mẫu đứng chia vùng tiếp xúc để kiểm chứng: đầu bán kính 120 mm; thân hộp 450 × 700 mm; mỗi cánh tay là hai đoạn nối khớp; mỗi chân là hai đoạn và bàn chân. Đây là hình học va chạm đơn giản, không thay danh mục mô của [[CO_THE]]. Đòn nhắm “tay trái” dùng vùng hình học đã ước lượng của tay, không tự chọn đúng gân bí mật.

V29 dài 900 mm; với tay và tư thế thử, tầm quét từ tâm người cầm là 1.600 mm. Tầm không bảo đảm trúng: quỹ đạo phải giao vùng cơ thể hoặc vật chắn đang hoạt động. V07 dao hái có tầm thử 900 mm, nhưng DL06 chưa định lượng thương tích cắt do chiến đấu nên không được dùng trong INIT-E cơ sở.

## 3. Nhận biết và thời gian phản ứng

Quan sát tạo hồ sơ gồm đối tượng nhận dạng được, vị trí ước lượng, hành động nhìn thấy, thời điểm và sai số. P00/N17 trong INIT-E có độ trễ nhận thay đổi 200 ms khi đang chú ý. Độ trễ này không cho biết ý định bí mật; người quan sát chỉ thấy dấu hiệu như bước chân, vai xoay hoặc vũ khí chuyển động.

Sau khi nhận dấu hiệu, hành động phản ứng vẫn cần thời gian riêng. Lệnh người chơi gửi không xóa 200 ms đã trôi qua và không kéo nhân vật khỏi pha cam kết. Nếu TN01 sau này cho tự dừng, giao diện chỉ dừng khi nhân vật nhận biết xung đột; lựa chọn đó hiện chưa chốt.

Mất tầm nhìn giữ vị trí cuối và thời điểm, không theo dõi bằng mã nội bộ. Âm thanh có thể cập nhật hướng ước lượng nhưng chưa có truyền âm/che âm định lượng trong bộ thử này.

## 4. Các hành động cơ sở

| Hành động | Chuẩn bị | Hiệu lực hoặc dịch chuyển | Hồi phục/dừng | Điều kiện chính |
| --- | ---: | ---: | ---: | --- |
| Bước 500 mm | 100 ms | 400 ms liên tục | 100 ms | Hai chân, đích trống |
| Đòn V29 | 600 ms | Quét 200 ms; tiếp xúc ở 150 ms | 800 ms | Một tay G ≥ 0,7, mục tiêu ước lượng |
| Dựng V30 | 400 ms | Duy trì sau khi hoàn tất | 200 ms để hạ | Tay trái G ≥ 0,7, hướng chắn hợp lệ |
| Gạt bằng V29 | 350 ms | Duy trì 300 ms | 500 ms | Tay cầm G ≥ 0,8, thấy đường đòn |
| Né ngang 600 mm | 100 ms | 350 ms liên tục | 400 ms | Hai chân Zđi ≥ 0,8, đích trống |
| Nói “dừng” | 300 ms | Âm thanh phát khi hoàn tất | Không | Phát âm và người nghe có thể nghe |
| Nhặt một món | 600 ms | Chuyển sang tay ở cuối | 400 ms | Tay trống, món trong 800 mm |

Chuẩn bị có thể ngắt; sau mốc vào quét/di chuyển, động lượng hành động đã cam kết và cần quy tắc dừng riêng. Đòn V29 cộng F +1 tại mốc tiếp xúc hoặc hết quét; né cộng F +2 khi hoàn tất; dựng tấm giữ lâu tăng F theo thủ công nhẹ của DL03. Không cộng lại cả lao động nặng và chi phí xung cho cùng một động tác.

Một tay không thể cùng lúc cầm V30 và làm thao tác khác cần tay đó. V30 chưa có dây đeo theo DL02, nên buông tay làm tấm rơi tại tọa độ thật. Bị ngã không tự đứng lại hoặc giữ nguyên hình học tư thế đứng.

## 5. Sai số, quỹ đạo và tiếp xúc

Mỗi đòn lưu vùng nhắm mà người đánh tin là đúng, kỹ năng vũ khí S trong [0;100], tập trung A trong [0;100] và một lần rút ngẫu nhiên đã lưu. Biên sai số mm: E = chặn trong [50;400] của 400 − 3S − 2A. Sai lệch x/y được rút một lần trong [−E;E] khi đòn cam kết; mở giao diện không rút lại.

INIT-E cho N17 S = 70, A = 80 nên E = 50 mm; hạt thử cho sai lệch (20; −10) mm. Quỹ đạo V29 nhắm giữa cẳng tay trái P00. Sau khi tích phân vị trí mọi người/vật tới mốc tiếp xúc, hệ kiểm tra đoạn quét mở rộng theo bề rộng vũ khí với V30 đang chắn, rồi vùng cơ thể. Vật đầu tiên trên đường nhận gói tác động; đòn không xuyên qua tấm rồi lại nhận toàn bộ gói ở cơ thể.

Né thay đổi vị trí liên tục nên dùng vị trí thật tại mốc, không cộng “tỷ lệ né” thứ hai. Gạt chủ động chỉ chặn khi vùng quét hai vũ khí giao nhau trong cửa sổ hiệu lực; nếu có, đổi hướng/tác động theo hồ sơ gạt. Bộ thử chưa có khóa vũ khí, vật lộn hoặc nhiều điểm tiếp xúc trong một quỹ đạo.

## 6. Gói tác động và phòng hộ

V29 tạo gói tác động cùn I = 60 ở tốc độ/tư thế chuẩn. I là đơn vị stress gameplay, không phải joule. Giảm chức năng, mệt hoặc quỹ đạo chỉ thay I nếu quy tắc đòn khai báo; không dùng một hệ số “bị thương” chung sau khi G đã giới hạn hành động.

V30 nguyên vẹn có độ nguyên vẹn D = 1.000 và sức chặn cùn R = 40 khi mặt tấm nằm giữa quỹ đạo và vùng đích. Lượng chặn = min(I, R × D/1.000); lượng truyền = I − lượng chặn. Sau tiếp xúc, D giảm đúng bằng lượng chặn trong mẫu. Mức D là tình trạng vật phẩm, không phải năng lượng còn có thể lấy lại.

V20 áo vải đang đeo có R cùn = 2 trên vùng che. Các lớp xử lý theo thứ tự vật đầu tiên ngoài→trong, mỗi lớp chỉ nhận lượng còn truyền. Tấm không đúng hướng không cung cấp R; tên “phòng hộ” không tạo bảo vệ toàn thân.

Với V30 hoạt động: 60 → tấm chặn 40, D 1.000→960, còn 20; tay áo V20 chặn 2, còn 18 vào cơ thể. Không có tấm: tay áo chặn 2, còn 58. V29 không có hao mòn đo được sau đúng một tiếp xúc trong biến thể này; đây là dữ liệu tình huống, không phải quy tắc kiếm gỗ bất hoại. Tổng gói được phân thành lượng từng lớp chặn và lượng tới mô; không trừ 60 thêm lần nữa ở thanh máu.

## 7. Thương tích cùn W-E01/W-E02

Ánh xạ dưới chỉ dùng cho tác động cùn V29 vào cẳng tay của mẫu H-TEST-01. Không áp cho đầu, cơ quan sâu, đâm/cắt hoặc tu sĩ có cấu trúc khác.

| Lượng tới mô | Kết quả thử tại cẳng tay |
| ---: | --- |
| 0–9 | Không đổi c; đau cảm nhận 0,05 trong 10 phút |
| 10–29 | Mô mềm c −0,05; đau 0,15; G bên đó ×0,95 |
| 30–59 | Mô mềm c −0,15; ổn định cổ tay c −0,15; đau 0,30; G tính lại từ chuỗi |
| 60–89 | Chưa hỗ trợ trong DL06; dừng với lý do thiếu mô hình sâu |

Nhánh có V30 tạo W-E01 với lượng 18: mô mềm c 1→0,95; G trái 0,95; đau 0,15. Nhánh không được tấm che tạo W-E02 với lượng 58: mô mềm và ổn định cổ tay xuống 0,85; G trái 0,85; đau 0,30. Hai hồ sơ có cùng sự kiện nguồn nhưng không cùng tồn tại trong một lượt; chúng là hai biến thể.

Đau không lại nhân G lần hai. [[CHAM_SOC_K0]] định lịch riêng: W-E01 hồi cấu trúc/hết đau sau 48 giờ đủ điều kiện; W-E02 hồi cấu trúc sau 96 giờ và hết đau sau 120 giờ. B-CARE cho vết cắt không chữa vết cùn bằng cùng công thức.

## 8. Dòng thời gian E-GUARD

| Mốc từ 09:00:00 | Sự kiện |
| ---: | --- |
| 0–500 ms | N17 bước 500 mm về đông, tới x = 3.500 |
| 500–1.100 ms | N17 chuẩn bị đòn V29 |
| 700 ms | P00 nhận biết dấu hiệu sau độ trễ 200 ms, bắt đầu dựng V30 |
| 1.100 ms | V30 hoàn tất và trở thành trạng thái chắn duy trì |
| 1.100–1.300 ms | V29 quét; mốc tiếp xúc 1.250 ms |
| 1.250 ms | V30 chắn, tạo W-E01; chính sách dừng được đánh thức |
| 1.300–2.100 ms | N17 ở pha hồi phục; không tự bỏ pha chỉ vì đã có thương tích |

Khoảng cách tâm sau bước là 1.500 mm, nằm trong tầm 1.600 mm. P00 hoàn tất chắn 150 ms trước tiếp xúc nên tấm có hiệu lực. Sau tác động, G trái 0,95 vẫn đủ giữ tấm nhưng chính sách yêu cầu dừng; dừng không xóa hao mòn/tổn thương.

Biến thể E-SAME: P00 bắt đầu dựng lúc 850 ms, hoàn tất đúng 1.250 ms. Theo [[LIEN_KET_HE_THONG]], trạng thái chắn mới chỉ có hiệu lực sau nhóm tác động tại cùng mốc, nên đòn tạo W-E02. Đây là quy ước phân xử game; không phụ thuộc thứ tự mã N17/P00 hoặc thứ tự file.

## 9. Né, hai đòn đồng thời và vật rơi

Biến thể E-DODGE: P00 bắt đầu né lúc 750 ms, hoàn tất dịch chuyển ngang lúc 1.200 ms. Tại 1.250 ms, vùng tay đã rời quỹ đạo; đòn trượt nếu sai số đã lưu không đưa quỹ đạo sang vị trí mới. Không vừa nhận “thưởng né” vừa dịch chuyển hình học lần hai.

Biến thể E-BOTH khởi tạo hai đòn có mốc tiếp xúc cùng 1.250 ms. Cả hai dùng trạng thái trước nhóm tác động; nếu đều hợp lệ, cả hai tạo gói và có thể cùng bị thương. W-E của người thứ nhất không hủy đòn đã đủ điều kiện của họ trong cùng nhóm. Hậu quả, đồ rơi và quyết định mới được áp sau khi giải quyết cả hai.

Nếu tác động khiến tay không còn đủ G giữ món, sự kiện buông đặt món tại vị trí tay sau nhóm tác động. Món không biến vào túi người đánh. Nhặt lại cần hành động 600 ms và có thể bị người khác tranh; cùng một món chỉ chuyển sang một tay.

## 10. Ứng dụng linh lực thử E-LINH

Để nối DL05 mà không trao thuật cho INIT-A, E-LINH dùng chủ thể kiểm chứng riêng đã biết Hồi Hoàn và có P = 4 L. Ứng dụng Xung Đẩy Thử có K riêng, chuẩn bị 800 ms, phát tại 800 ms, bay thẳng 4.000 mm/giây, tầm tối đa 3.000 mm. Nó lấy 4 L P và tạo gói linh lực 24 đơn vị; đây là hệ số thử 10 đơn vị/L công dụng từ 2,4 L của HH-C.

Nếu Hồi Hoàn hoàn chỉnh: 2,4 L tạo gói, 0,8 L trở lại P sau 300 ms và 0,8 L thất thoát; P 4→0→0,8. V30 có R linh lực = 6 trong đúng tình huống này, nên gói 24 còn 18 nếu chắn đúng hướng. Không dùng R cùn 40 cho linh lực.

Nếu chủ thể bị ngắt sau phát nhưng trước hồi hoàn, gói đã bay tiếp; 0,8 L dự kiến hồi chuyển thành thất thoát và P còn 0. Không rút thêm 4 L lúc gói chạm. Mục tiêu né dựa trên dấu hiệu mình nhận được, không đọc tọa độ đích bí mật hoặc biết chắc chủ thể đang dùng HH-C.

Xung Đẩy Thử chỉ tạo dịch chuyển nếu DL06 có vật/nhân vật với ngưỡng chịu đẩy được khai báo; hiện chưa có, nên tình huống chỉ kiểm tra nguồn và phòng hộ, không kể đối tượng bị hất văng. Nó chưa phải công pháp chiến đấu chính thức hay năng lực P00/N14/N15.

## 11. Rút lui, dừng và đầu hàng

Rút lui chọn một lối đã biết, thực hiện di chuyển thật và giữ tải. Tới biên E-01 mới chuyển sang tuyến D07–D01/D08 mà không đặt lại tiến độ. Người đuổi phải có mục tiêu, thấy/đoán đúng lối và tiếp tục trả mệt; chính sách INIT-E dừng ở biên nên không tự đuổi.

Lời “dừng” phát sau 300 ms, tới người nghe trong bộ thử cùng địa điểm ngay mốc phát và được hiểu nếu họ chú ý. Chấp nhận tạo ý định kết thúc thù địch; đòn đã qua mốc cam kết vẫn diễn tiến trừ khi có cách dừng hợp lệ. Không đóng băng vũ khí đang quét.

Đầu hàng thật là đề nghị có điều kiện. Phạm vi DL06 chỉ kiểm tra nghe, chấp nhận/từ chối và kết thúc truy đuổi. Trói, áp giải, giam giữ, luật xử phạt và chăm sóc tù binh chưa có dữ liệu nên không tuyên bố đã hỗ trợ.

## 12. Hậu quả quay về thế giới

Kết thúc giao chiến không mở trạng thái thế giới mới. Vị trí người/vật giữ nguyên; V29/V30 còn hao mòn và chủ sở hữu; F, P, thương tích, đau và pha dở vẫn chạy theo đồng hồ chung. Trả đồ cần gặp người có quyền hoặc đặt vào kho hợp lệ.

N17/P00 tạo ký ức theo điều họ thấy; O03 không tự biết tấm hỏng trước khi quan sát hoặc nhận báo cáo. Thỏa thuận thử ghi ai làm gì, nhưng đánh giá trách nhiệm tùy thông tin/quan hệ. Một nhân chứng chỉ biết phần họ nhận biết, không nhận bản ghi toàn tri của công cụ kiểm chứng.

Việc/hẹn đang có không biến mất. Thương tích có thể làm kế hoạch đổi qua [[CONG_VIEC_THU]]; chăm sóc cần vật tư/quyền và quy trình phù hợp. Hồi phục vết cùn dùng lịch [[CHAM_SOC_K0]] và dừng khi mất điều kiện; giao diện nêu mốc theo giờ đủ điều kiện, không hứa thời gian lịch chắc chắn.

## 13. Dữ liệu phải lưu

Lưu không gian/phiên bản; vị trí/hướng/tư thế; vùng va chạm; nhận biết có thời điểm; chính sách; hành động/pha/mốc cam kết; tài nguyên tay/chân/chú ý; quỹ đạo và sai số đã rút; gói tác động; thứ tự lớp chắn; tình trạng vật; thương tích; F/P; giao tiếp; mục tiêu truy đuổi; mã giao dịch và nhóm tác động cùng mốc.

Tải lại ở 1.200 ms phải cho cùng tiếp xúc 1.250 ms, không rút lại sai số, dựng tấm sớm hơn hoặc trừ P lần hai. Mở nhật ký không làm thời gian phản ứng trôi hoặc thay vị trí.

## 14. Tình huống kiểm chứng khi triển khai

| Mã | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| GT01 | E-GUARD | Tấm 1.000→960; lượng tới mô 18; W-E01 |
| GT02 | E-SAME | Tấm mới chưa chắn nhóm cùng mốc; lượng tới mô 58; W-E02 |
| GT03 | E-DODGE | Dùng vị trí tại tiếp xúc; không cộng thêm tỷ lệ né |
| GT04 | Hai đòn cùng mốc | Cả hai có thể gây thương tích; không ưu tiên mã |
| GT05 | Đòn ngoài tầm | Không tạo tiếp xúc hoặc thương tích |
| GT06 | Quỹ đạo gặp tấm trước | Không đưa lại toàn bộ 60 vào cơ thể |
| GT07 | Tay mất khả năng giữ | Món rơi tại vị trí thật, không tự đổi chủ |
| GT08 | Nhặt cùng một món | Chỉ một giao dịch nhận món thành công |
| GT09 | Nói dừng khi đòn đã cam kết | Ý định đổi; đòn chỉ dừng nếu pha cho phép |
| GT10 | Rút khỏi E-01 | Nối đúng tuyến, giữ vị trí/tải/mệt |
| GT11 | E-LINH hoàn chỉnh | P còn 0,8; gói 24; thất thoát 0,8 |
| GT12 | E-LINH bị ngắt sau phát | Gói tồn tại; P còn 0; phần hồi thành thất thoát |
| GT13 | W-E01 sau trận | Việc sau dùng G/đau thật; hồi theo 48 giờ đủ điều kiện, không bằng B-CARE |
| GT14 | O03 ở xa | Không tự biết hao mòn tấm trước khi có thông tin |
| GT15 | Lưu ở 1.200 ms | Kết quả 1.250 ms tái hiện, không rút sai số/chi nguồn lại |
| GT16 | Đổi số lần mở giao diện | Không đổi nhận biết, phản ứng, vị trí hoặc kết quả |

Đã đối chiếu các mốc, lượng tác động và P trên giấy; K0.6 bổ sung hồi phục vết cùn. Chưa chạy GT; chưa có vật lộn, vũ khí sắc định lượng, cơ quan sâu, địa hình cao, chiến đấu nhóm lớn, giam giữ hoặc thư viện thuật chiến đấu.

## 15. Sau DL06

Sáu gói DL01–DL06 đã có thông số đề xuất đủ để rà soát chéo trên giấy, chưa đủ để gọi là game hoặc dữ liệu hoàn chỉnh. Bước kế hoạch tiếp theo là kiểm toán toàn bộ chuỗi A–E, lập bảng phần đã khép kín/phần còn thiếu và xác định bộ đặc tả tối thiểu trước khi triển khai. TN01–TN08 vẫn cần phản hồi rõ; “tiếp” không phải xác nhận.
