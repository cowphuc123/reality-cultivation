---
aliases: [Chiến đấu và hậu quả xung đột]
tags: [thiet-ke, chien-dau]
status: de-xuat
updated: 2026-09-05
---

# Chiến đấu và hậu quả xung đột — đặc tả 0.1

Liên quan: [[THOI_GIAN|Thời gian]] · [[HANH_DONG|Hành động]] · [[CO_THE|Cơ thể]] · [[VAT_PHAM|Vật phẩm]] · [[TU_LUYEN|Tu luyện]] · [[NPC|NPC]] · [[MOI_TRUONG|Môi trường]] · [[KINH_TE_TO_CHUC|Tổ chức]] · [[DECISIONS|Quyết định]].

> Bản đề xuất cho game hư cấu, chưa chốt hoặc triển khai. Chiến đấu dùng các hệ nền chung; đây không phải hướng dẫn chiến đấu ngoài đời.

## 1. Mục tiêu của xung đột

Các bên có mục tiêu riêng: thoát thân, giữ hàng, ngăn xâm nhập, bắt giữ, bảo vệ người khác, tranh tài hoặc giết đối thủ. Kết thúc không nhất thiết là một bên chết.

Thành công xét mục tiêu và hậu quả: sống sót nhưng mất hàng có thể thất bại về hợp đồng; đuổi được đối thủ nhưng bị thương nặng có thể làm mất sinh kế. Không đặt lại cơ thể, đồ dùng và quan hệ sau khi rời trạng thái giao chiến.

## 2. Điều khiển ở tốc độ 5 giây/ngày

Người chơi chủ yếu đặt chính sách trước và điều chỉnh tại thời điểm dừng được phép. Một phút game chỉ kéo dài khoảng 0,00347 giây ngoài đời ở tốc độ mặc định, nên thiết kế không thể đòi phản xạ bấm nút cho từng đòn.

Đề xuất tự dừng khi nhận biết xung đột mới hoặc thay đổi nguy cấp, theo THOI_GIAN. Dừng toàn thế giới, không chỉ đối thủ. Khi chạy lại, nhân vật hành động theo khả năng/hiểu biết và chính sách; mệnh lệnh không bỏ qua thời gian phản ứng hay pha đang cam kết.

Tốc độ chậm chuyên cho chiến đấu còn mở. Bản đặc tả phải hoạt động với điều khiển bằng ý định ngay cả khi không bổ sung tốc độ này.

## 3. Chính sách chiến đấu

Hồ sơ chính sách gồm mục tiêu, đối tượng cần bảo vệ, mức rủi ro, nguồn được phép dùng, điều kiện rút lui, thái độ với đề nghị đầu hàng và giới hạn hành vi.

Ví dụ: ưu tiên thoát thân; không truy đuổi sau khi đường rút đã mở; không dùng thuật gây tổn hại lâu dài; giữ linh thạch dự phòng; chấp nhận mất hàng nếu cần cứu người theo quyền đã giao.

Ý định “hạn chế gây chết” chọn các phương án phù hợp nhưng không bảo đảm không ai chết. Hậu quả vẫn đi qua cơ thể; không có đòn phi sát thương luôn an toàn bất kể trạng thái mục tiêu.

Giới hạn của người chơi phải được giữ; NPC độc lập chọn giới hạn theo động cơ/giá trị riêng. Yêu cầu tự bảo vệ không mặc định cấp quyền dùng mọi tài sản hoặc công pháp cấm.

## 4. Không gian giao chiến

Đề xuất dùng vị trí cục bộ, hướng, kích thước vùng chiếm chỗ, vật cản và liên kết ra/vào địa điểm. Có thể trình bày toàn bộ bằng chữ, không cần đồ họa.

Các trạng thái gần/xa/chạm tầm là nhãn suy ra từ khoảng cách và khả năng, không là nguồn dữ liệu mâu thuẫn với vị trí. Bản đầu có thể giới hạn hình học mặt phẳng; độ cao hoặc bay cần mở rộng rõ trước khi có thuật sử dụng nó.

Không tự chuyển sang một đấu trường tách biệt: người đi ngang, cửa, vật rơi và hành trình ngoài vùng vẫn thuộc thế giới chung. Khi chuyển mức chi tiết, giữ vị trí/tiến độ và những tác động đang diễn ra.

## 5. Nhận biết và phản ứng

Mỗi bên dùng mục tiêu đã thấy/nghe/cảm nhận và vị trí ước lượng có thời điểm. Không đọc ý định, chiêu đã chọn hoặc vị trí bí mật của đối thủ.

Phát hiện tạo cơ hội phản ứng, không phản ứng tức thì. Thời gian phản ứng phụ thuộc năng lực, chú ý, bất ngờ và pha đang làm theo dữ liệu sẽ chốt. Bất tỉnh hoặc mất chức năng cần thiết chặn hành động ngay cả khi người chơi đã ra lệnh.

Mất dấu khiến hiểu biết vị trí cũ dần kém tin cậy. Thuật truy dấu hoặc thần thức phải có cơ chế nhận biết riêng; không mặc định xuyên mọi vật cản và nhận đúng danh tính.

## 6. Hồ sơ hành động giao chiến

| Nhóm | Nội dung |
| --- | --- |
| Chủ thể/mục tiêu | Ai làm, nhắm ai/vùng nào theo hiểu biết |
| Điều kiện | Vị trí, bộ phận, công cụ, năng lượng và kiến thức |
| Pha | Chuẩn bị, cam kết, tác động, hồi phục hoặc duy trì |
| Thời gian | Mốc bắt đầu, mốc tác động, cửa sổ đổi/hủy |
| Chi phí | Phần trả lúc đầu, theo thời gian và lúc phát tác |
| Tác động | Loại hiệu ứng, phạm vi, nguồn, đường truyền |
| Ngắt | Điều kiện, phần giữ lại, tổn hao và hậu quả |
| Dấu hiệu | Những gì bên khác có thể nhận biết |

Mỗi lần thực hiện có mã/phiên bản riêng. Thay mục tiêu, mất vũ khí hoặc bị ngắt làm sự kiện dự báo cũ hết hiệu lực theo quy tắc. Không cho sự kiện đòn cũ tự đánh trúng sau khi hành động đã bị hủy hợp lệ.

## 7. Các pha và sự cam kết

Chuẩn bị có thể đổi kế hoạch trong giới hạn; sau mốc cam kết, hủy có thể mất công hoặc không thu hồi được tác động đã phóng. Hồi phục là thời gian lấy lại khả năng thao tác, không được bỏ qua bằng cách đổi tên hành động.

Hành động duy trì tiêu nguồn theo thời gian và bị ngắt khi mất điều kiện. Một hiệu ứng đã tách khỏi người phát như vật phóng có thể tiếp tục sau khi họ bất tỉnh; hiệu ứng cần điều khiển liên tục thì tuân thủ điều kiện duy trì.

Không áp một bộ pha giống hệt cho mọi công pháp. Mỗi kiểu cần mô tả rõ nguồn, mốc hiệu lực và cách kết thúc.

## 8. Từ ý định đánh tới thương tích

1. Kiểm tra hành động còn hợp lệ tại mốc tác động, không chỉ tại lúc lên kế hoạch.
2. Xác định khả năng tiếp cận/đường tác động theo vị trí và vật cản hiện tại.
3. Giải quyết phản ứng thực sự kịp diễn ra và tư thế của các bên.
4. Xác định vùng tiếp xúc hoặc trượt theo mô hình đã chọn.
5. Xử lý phòng hộ/trang bị rồi chuyển tác động còn lại sang CO_THE.
6. Cập nhật năng lực, hành động bị ảnh hưởng và thông tin có thể quan sát.

Chưa chốt công thức xác suất/hình học tiếp xúc. Nếu dùng ngẫu nhiên cho sai số thao tác, phải dựa trên trạng thái và lưu để tái hiện; không bốc lại khi mở nhật ký.

Không vừa trừ “máu chiến đấu” vừa tạo thương tích cho cùng một tác động. Nhãn mức nguy hiểm chỉ tóm tắt tình trạng cơ thể.

## 9. Di chuyển, tư thế và phòng thủ

Di chuyển dùng năng lực, tải và địa hình; không có một tốc độ riêng bỏ qua gãy chân. Tư thế ảnh hưởng những hành động được thực hiện, tầm và khả năng chuyển đổi.

Né/đỡ là hành động cần thời gian và năng lực, không chỉ phần trăm miễn phí trên mọi đòn. Phòng thủ thụ động như giáp vẫn hoạt động theo vật liệu/vùng che phủ, còn phản ứng chủ động cần nhận biết và điều khiển.

Đồng thời bảo vệ nhiều hướng bị giới hạn bởi cơ thể, công cụ và chú ý. Không cho một chi vừa dùng toàn công suất ở hai thao tác xung đột. Những khả năng tu tiên vượt giới hạn thông thường phải được khai báo qua TU_LUYEN.

## 10. Vũ khí, giáp và vật thể môi trường

Vũ khí dùng cấu tạo, tình trạng và khả năng từ VAT_PHAM. Mòn/gãy ảnh hưởng hành động từ mốc xảy ra; vũ khí rơi có vị trí thật và muốn nhặt lại phải thực hiện hành động.

Giáp có vùng che phủ, lớp, tình trạng và cách truyền/chặn tác động. Giáp tốt ở thân không tự bảo vệ mọi ngón tay. Khi một lớp hỏng, phần tiếp theo được giải quyết theo cấu trúc còn lại, tránh tính hấp thu trùng.

Cửa, tường, bàn và công trình có khả năng chắn hoặc bị hỏng nếu hệ vật thể đã hỗ trợ; không giả mọi vật cảnh đều không thể phá hoặc đều xuyên được. Giới hạn phá hủy bản đầu phải ghi rõ.

## 11. Thuật, linh lực và hiệu ứng kéo dài

Thuật kiểm tra kiến thức, tuyến vận hành, nguồn năng lượng, vật hỗ trợ và trạng thái điều khiển. Nhãn cảnh giới không bỏ qua những điều kiện đó.

Hiệu ứng có nguồn, đối tượng/phạm vi, mốc bắt đầu, điều kiện duy trì, cách kết thúc và quy tắc chồng lấp. Lớp bảo vệ tiêu linh lực phải trừ nguồn một lần; khi cạn không tiếp tục chặn miễn phí.

Tác động vùng xét những chủ thể thực trong vùng, kể cả đồng đội hoặc đồ vật nếu cơ chế có ảnh hưởng. Phân biệt khả năng tác động và chính sách tránh gây hại; không tự có miễn nhiễm đồng minh trừ khi thuật thật sự cung cấp.

## 12. Tác động đồng thời

Theo THOI_GIAN, các tác động đã đủ điều kiện cùng mốc được giải quyết trên trạng thái trước nhóm tác động, rồi tổng hợp hậu quả. Hai bên có thể cùng bị thương; không ưu tiên mặc định mã nhân vật nhỏ hơn.

Phản ứng hoàn tất trước mốc tác động được tính vào trạng thái tại mốc. Phản ứng bắt đầu sau khi nhận thương tích không hồi tố tránh đòn vừa xảy ra. Các trường hợp đúng cùng mốc cần quy tắc pha rõ, không để thứ tự đọc file quyết định.

Bổ sung đề xuất: thế đỡ/phòng hộ duy trì mới hoàn tất đúng mốc t chỉ có hiệu lực sau nhóm tác động ở t; hoàn tất trước t và chưa hết hạn mới bảo vệ nhóm này. Tham chiếu [[LIEN_KET_HE_THONG]], mục 3, cho thứ tự thống nhất với cơ thể và thời gian.

Nguồn chung hữu hạn vẫn phải phân xử trước cam kết; hai thuật không cùng tiêu một lượng linh lực cuối. Tác động đồng thời không có nghĩa cho phép dùng tài nguyên hai lần.

## 13. Mệt mỏi, thương tích và thích nghi

Chi phí gắng sức đi qua CO_THE. Giảm năng lực làm thay đổi lựa chọn và thời lượng; không cộng lại một hình phạt “đang bị thương” trùng với phần đã tính trong chức năng.

Nhân vật có thể đổi cách hành động theo những gì đã học và bộ phận còn dùng được. Không tự học một kỹ thuật mới hoàn hảo chỉ vì mất công cụ quen thuộc.

Giảm đau có thể giúp duy trì chú ý nhưng không phục hồi cấu trúc. Rút lui và kết thúc xung đột không chữa thương, hết độc hoặc nạp đầy linh lực.

## 14. Quyết định của NPC

NPC cân nhắc mục tiêu, sức mình theo nhận biết, đối thủ đã quan sát, đường thoát, người cần bảo vệ, giá trị tài sản và ý nghĩa quan hệ. Quyết định có thể sai vì thông tin thiếu, nhưng phải có nguồn giải thích.

Sợ hãi hoặc tức giận ảnh hưởng đánh giá, không bắt mọi người chạy khi còn cùng một phần trăm sức khỏe. Người bảo vệ gia đình có thể chấp nhận rủi ro hơn người được thuê giữ hàng.

Không có cơ chế toàn tri điều chỉnh đối thủ để luôn ngang người chơi. Cân bằng vùng khởi đầu là thiết kế nội dung; sức mạnh thực vẫn thuộc cá thể và lịch sử của họ.

## 15. Giao chiến nhóm và mệnh lệnh

Nhóm có vai trò, mục tiêu và cách liên lạc. Lệnh cần được nghe/nhận và có độ trễ; người chỉ huy không điều khiển mọi thành viên bất kể vị trí hoặc mất liên lạc.

Đồng đội nhận việc theo quyền/cam kết và khả năng hiện tại. Người bị thương có thể không giữ nổi vai trò, buộc người khác điều chỉnh. Không làm sống lại hoặc dịch chuyển người vắng mặt để đủ đội hình.

Bản đầu đề xuất nhóm nhỏ, chưa mô phỏng chiến tranh lớn chi tiết. Khi mở rộng cần hậu cần, giao tiếp và mức tổng hợp giữ những chủ thể quan trọng.

## 16. Phục kích, ẩn nấp và mất dấu

Ẩn nấp phụ thuộc vị trí, vật che, dấu hiệu và khả năng quan sát. Gặp phục kích không tự cho người chơi biết số lượng/vị trí mọi kẻ địch.

Phát hiện bất ngờ tạo sự kiện và khả năng phản ứng từ thời điểm nhận biết. Tự dừng không xóa những hậu quả đã diễn ra trước lúc phát hiện.

Mất dấu lưu vị trí cuối, thời điểm và bằng chứng có thể theo dõi. Tìm lại là hành động khảo sát/truy dấu; không dùng mã đích để bám chính xác xuyên vùng.

## 17. Rút lui và truy đuổi

Rút lui là di chuyển theo đường hợp lệ, có thể bị ngăn hoặc bị theo. Quyết định bỏ lại tải phải theo quyền được giao; đồ bỏ lại chuyển tới vị trí thật, không bị xóa.

Người đuổi cân nhắc khả năng theo dấu, gắng sức, nguồn, mục tiêu và giới hạn truy đuổi. Không chạy mãi chỉ vì từng có cờ thù địch. Tốc độ cao giúp thu hẹp khoảng cách nhưng không bảo đảm bắt được khi mất dấu hoặc đường không qua được.

Thoát giao chiến là kết quả không còn tác động gần đang giải quyết và đối thủ không tiếp tục áp sát được theo tình trạng; nó không xóa trạng thái thù địch, dấu vết hoặc khả năng truy tìm sau này.

## 18. Đầu hàng, đình chiến và bắt giữ

Đề nghị đầu hàng là giao tiếp: cần được truyền tới đối phương, được hiểu và được chấp nhận để hình thành thỏa thuận. Nó không tự đóng băng mọi đòn đang trên đường tới hoặc bảo đảm đối phương giữ lời.

Đình chiến ghi điều kiện, bên tham gia và hiệu lực. Thành viên chưa nhận tin hoặc không thuộc thỏa thuận có thể tiếp tục hành động; hậu quả thông tin/quan hệ theo NPC và tổ chức.

Bắt giữ cần khả năng tiếp cận/khống chế và các hành động được mô hình hóa. Người bị giữ vẫn có cơ thể, nhu cầu, vị trí, đồ và khả năng hành động còn lại. Không tự biến thành một món đồ trong túi hoặc vận chuyển miễn phí.

Phạm vi bản đầu có thể chỉ gồm chấp nhận đầu hàng và chấm dứt truy đuổi; giam giữ lâu dài, xét xử và trao đổi tù nhân cần đặc tả sau. Không tuyên bố đã hỗ trợ sâu mọi hình thức khi mới có trạng thái cơ bản.

## 19. Hậu quả sau xung đột

Tính trạng thái cơ thể, đồ hỏng/rơi, nguồn đã tiêu, vị trí, công việc dang dở và nghĩa vụ còn lại. Chăm sóc người bị thương cần hành động và vật tư thật.

Lấy đồ không tự trở thành sở hữu hợp pháp. Quyền, nhân chứng, cáo buộc và thực thi theo KINH_TE_TO_CHUC; không tăng danh tiếng toàn thế giới ngay khi xung đột kết thúc.

Ký ức gồm điều từng người nhận biết, cảm xúc và đánh giá. Hai nhân chứng có thể kể khác nhau. Mất tích, cái chết và tin tức đến gia đình theo kênh thật; không thông báo toàn tri cho mọi người quen.

## 20. Lưu tải, hiệu năng và nhật ký

Bản lưu giữ vị trí, pha hành động, tác động đã phóng/đang duy trì, nguồn đã dùng, phiên bản sự kiện, mục tiêu theo nhận biết và trạng thái ngẫu nhiên. Tải không đặt lại hồi phục thao tác hoặc cho phản ứng miễn phí.

Xử lý ở mốc cần thiết, không quét mọi NPC thế giới theo mili giây vì một nhóm đang đánh. Tuy nhiên các vùng khác vẫn tiến theo đồng hồ chung và trao đổi sự kiện đúng mốc.

Nhật ký gộp thao tác lặp, giữ quyết định và hậu quả quan trọng. Công cụ phát triển lưu chuỗi nguyên nhân để tái hiện; giao diện chơi chỉ thấy phần nhân vật biết. Thất bại khó hiểu phải được phân biệt giữa thiếu thông tin có chủ ý và lỗi mô phỏng.

## 21. Giao diện quyết định

Thẻ xung đột nêu mục tiêu đang theo, mối đe dọa nhận biết, tình trạng có ảnh hưởng, phương án đã biết và giới hạn nguồn. Không yêu cầu đọc hàng trăm dòng đòn đánh mới hiểu vì sao nhân vật chạy.

Ví dụ:

> **Đang ưu tiên thoát thân.** Tay trái không phù hợp thao tác nặng; đường trở lại làng vẫn trong tầm quan sát.  
> Đối phương còn ở phía cầu theo lần thấy gần nhất. Chưa biết có người khác.  
> Quy tắc: không truy đuổi, không dùng thuật tổn hại lâu dài.  
> Lệnh mới sẽ thực hiện khi nhân vật kết thúc pha đang cam kết hoặc có thể ngắt hợp lệ.

Không hiển thị tỷ lệ thắng chính xác khi chưa có mô hình đáng tin và thông tin đủ. Có thể nêu ưu/nhược và phần chưa biết.

## 22. Kịch bản mẫu

Đoàn hàng gặp một người chặn đường. Người hộ tống có mục tiêu giữ người và hàng, còn người chặn đường có mục tiêu riêng. Đàm phán có thể giải quyết trước chiến đấu nếu các bên chấp nhận.

Nếu giao chiến, người hộ tống bị thương và đánh giá lại khả năng. Đường rút, tải hàng, thông tin đồng đội và chính sách quyết định có bỏ hàng, xin hỗ trợ hay tiếp tục. Không bắt trận luôn có người chết.

Sau đó hàng còn ở nơi thật, hợp đồng được xử lý theo tình trạng giao, người bị thương cần chăm sóc, người chứng kiến có ký ức riêng. Kịch bản kiểm chứng phải chạy được cả khi người chơi không tham gia.

## 23. Tiêu chí kiểm chứng khi triển khai

DL06 tại [[CHIEN_DAU_THU]] cụ thể hóa INIT-E, thời lượng, tiếp xúc, lớp chắn, thương tích và ứng dụng linh lực thử. Đây là bộ đối chiếu hư cấu chưa chạy, không thay phạm vi chiến đấu dài hạn.

| ID | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| CD01 | Hai tác động hợp lệ cùng mốc | Có thể cùng gây hậu quả, không ưu tiên mã nhân vật |
| CD02 | Hủy trước mốc cam kết | Sự kiện tác động cũ không chạy lại |
| CD03 | Người phát bất tỉnh sau khi phóng | Tác động độc lập tiếp tục; hiệu ứng cần duy trì xử lý riêng |
| CD04 | Mất vũ khí trước thao tác cần nó | Hành động cập nhật đúng điều kiện |
| CD05 | Hai thuật cần nguồn cuối | Không tiêu cùng lượng hai lần |
| CD06 | Vùng cơ thể không được giáp che | Không nhận bảo vệ từ giáp ở vùng khác |
| CD07 | Chân bị thương giữa truy đuổi | Tốc độ đổi từ mốc, giữ vị trí đã đi |
| CD08 | Đối thủ chưa bị phát hiện | Không lộ vị trí/ý định qua chính sách hoặc tự dừng |
| CD09 | Mất dấu qua ranh giới | Không bám tọa độ thật bằng mã đích |
| CD10 | Đầu hàng chưa được chấp nhận | Không tự xóa tác động hoặc tạo thỏa thuận |
| CD11 | Kết thúc trận | Không hồi máu/linh lực miễn phí |
| CD12 | Bỏ hàng để chạy | Hàng còn tại vị trí và giữ quyền/hậu quả liên quan |
| CD13 | Chỉ huy mất liên lạc | Không cập nhật lệnh tức thời cho mọi người |
| CD14 | Lưu tải giữa pha | Giữ chi phí, thời điểm, phản ứng và ngẫu nhiên |
| CD15 | Mở nhật ký nhiều lần | Không bốc lại kết quả |
| CD16 | Giao chiến ngoài người chơi | Dùng cùng cơ thể, nguồn và quyết định |
| CD17 | Hiệu ứng vùng có đồng đội | Áp đúng phạm vi/cơ chế, không miễn theo phe nếu không có lý do |
| CD18 | Hai việc cùng chi/chú ý | Không vượt năng lực bằng chạy song song miễn phí |
| CD19 | Nhân chứng không biết danh tính | Không tự cáo buộc đúng mã người gây ra |
| CD20 | Thuê hộ tống thất bại | Hậu quả hợp đồng và tài sản nối hệ tổ chức, không reset |

Chưa chạy kiểm chứng vì chưa có game. Cần mô hình vị trí, thời lượng, tiếp xúc, độ chính xác và bộ dữ liệu cân bằng trước khi đánh giá kết quả.

## 24. Phạm vi và bước tiếp theo

Đề xuất kiểm chứng nhóm nhỏ trong địa điểm đơn giản, có di chuyển, một kiểu công cụ, một kiểu phòng hộ, một thuật tiêu nguồn, rút lui và đầu hàng. Đây là tập tình huống kiểm chứng, không giới hạn mục tiêu dài hạn.

Còn mở: hình học, chiến đấu trên cao, công thức tiếp xúc, tốc độ chậm, độ sâu bắt giữ, chiến tranh lớn và mức thông tin người chơi thấy. Các lựa chọn chưa chốt không được coi là đã triển khai.

Bước tiếp theo: rà soát chín đặc tả hệ thống, lập bảng phần nào quản lý dữ liệu nào và giải quyết mâu thuẫn; sau đó viết kịch bản chơi thử xuyên hệ thống cùng danh sách quyết định cần chốt trước lập trình. Vẫn ở giai đoạn kế hoạch.
