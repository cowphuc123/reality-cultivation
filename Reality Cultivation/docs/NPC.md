---
aliases: [Đời sống và quyết định NPC]
tags: [thiet-ke, nen-tang, npc]
status: de-xuat
updated: 2026-09-05
---

# Đời sống và quyết định NPC — đặc tả 0.1

Liên quan: [[MASTER_PLAN|Kế hoạch]] · [[HANH_DONG|Hành động]] · [[CO_THE|Cơ thể]] · [[THOI_GIAN|Thời gian]] · [[DECISIONS|Quyết định]].

> Yêu cầu đã có: NPC tồn tại với đời sống và câu chuyện riêng. Các cơ chế dưới đây là đề xuất thiết kế, chưa được chốt hoặc lập trình. “Như người thật” là mục tiêu trải nghiệm, không phải tuyên bố mô phỏng được tâm trí con người hoàn chỉnh.

## 1. Câu chuyện phải đến từ đời sống

NPC tiếp tục sinh hoạt khi người chơi rời đi. Họ có việc cần làm, người cần chăm sóc, điều mong muốn và giới hạn riêng. Tiểu sử không đủ: một người được mô tả là thương con phải có những lựa chọn thể hiện điều đó khi thời gian, tiền bạc hoặc an toàn xung đột.

Không cần mỗi NPC có một cốt truyện viết sẵn. Chuỗi sự kiện có nguyên nhân, cách người đó hiểu chúng và lựa chọn tiếp theo sẽ tạo lịch sử cá nhân. Người chơi có thể chỉ biết một phần lịch sử ấy.

## 2. Những lớp dữ liệu độc lập

| Lớp | Nội dung | Đặc điểm cập nhật |
| --- | --- | --- |
| Danh tính | Mã, tên, tuổi, xuất thân, thân phận | Bền vững; đổi tên không đổi người |
| Cơ thể | Trạng thái và chức năng từ CO_THE | Thay đổi theo sinh lý và tác động |
| Hoàn cảnh | Nơi ở, nghề, tài sản, người phụ thuộc, tổ chức | Thay đổi qua hành động/sự kiện |
| Khuynh hướng | Thận trọng, kiên trì, hiếu kỳ, coi trọng danh dự… | Tương đối ổn định, có thể đổi lâu dài |
| Giá trị và mong muốn | Điều coi trọng, cuộc sống muốn hướng tới | Có thứ tự, có xung đột |
| Cảm xúc hiện tại | Sợ, giận, biết ơn, buồn, hài lòng… | Có nguồn và diễn biến theo thời gian |
| Hiểu biết | Quan sát, lời kể, suy đoán, cách làm đã học | Không đồng nhất sự thật thế giới |
| Ký ức | Những trải nghiệm được giữ lại | Có mức nổi bật, có thể tóm lược |
| Quan hệ | Cách đánh giá từng người/tổ chức | Có hướng, theo lĩnh vực |
| Ý định | Mục tiêu, kế hoạch, cam kết, việc đang làm | Dùng hệ HANH_DONG |

Hệ quyết định đọc phiên bản dữ liệu tại mốc thời gian hiện tại. Không sao chép một bộ sức khỏe riêng vào “AI NPC” rồi để nó lệch với cơ thể thật.

## 3. Nhu cầu, nghĩa vụ và khát vọng

Nhu cầu cơ thể xuất hiện qua cảm giác và giới hạn chức năng: đói, khát, đau, buồn ngủ. NPC không cần biết chính xác lượng nước nội bộ để muốn uống. Khi mất khả năng đứng, hành động bị chặn bởi cơ thể dù NPC chưa hiểu nguyên nhân.

Nhu cầu đời sống gồm an toàn, chỗ ở, sinh kế, quan hệ và khả năng duy trì vai trò. Nghĩa vụ là những việc gắn với người khác: nuôi người phụ thuộc, trả nợ, có mặt ở ca làm, thực hiện lời hứa. Khát vọng dài hạn có thể là học nghề, mở tiệm, vào môn phái, trả thù hoặc sống yên ổn.

Không sinh cùng một bộ khát vọng cho mọi người. Một nông dân hài lòng với gia đình có thể không muốn tu luyện dù biết tu sĩ mạnh hơn. Khi hoàn cảnh thay đổi, mục tiêu có thể hình thành, bị hoãn, được thay thế hoặc từ bỏ với lý do được lưu.

Mỗi mục tiêu phải có nguồn: triệu chứng, người giao việc, nghĩa vụ, ký ức, cơ hội nhận biết hoặc khát vọng. Không thêm mục tiêu “gây chuyện với người chơi” chỉ vì khu vực đang thiếu sự kiện.

## 4. Tính cách ảnh hưởng lựa chọn, không quyết định máy móc

Đề xuất các khuynh hướng liên tục thay vì chỉ nhãn tốt/xấu: chấp nhận rủi ro, kiên trì, tin người, hào phóng, hiếu kỳ, coi trọng thể diện, gắn bó và tự chủ. Chưa chốt danh mục hoặc thang số.

Một người nhát vẫn có thể cứu con khi động cơ đủ mạnh. Người hào phóng có thể từ chối cho vay vì không còn tiền ăn. Một lần tức giận không tự đổi tính cách lâu dài thành hung ác.

Giá trị ổn định định hướng mục tiêu; cảm xúc tạm thời điều chỉnh chú ý và cách đánh giá. Trải nghiệm lặp lại hoặc biến cố lớn mới có thể tạo thay đổi lâu dài theo quy tắc riêng. Không gán bệnh lý tâm thần như nhãn ngẫu nhiên để tạo hành vi khó đoán.

## 5. Cảm xúc có đối tượng và nguồn

Mỗi phản ứng cảm xúc có sự kiện nguồn, đối tượng nếu biết, cường độ và cách suy giảm/được củng cố. NPC diễn giải sự kiện theo mong đợi và niềm tin, không theo ý định bí mật của người gây ra.

Ví dụ không nhận được tiền đúng hẹn có thể gây lo lắng và bất mãn. Nếu NPC biết đối tác bị thương, cách diễn giải khác với khi họ tin đối tác bỏ trốn. Sự thật chỉ ảnh hưởng sau khi có con đường thông tin hợp lệ.

Không biến cảm xúc thành một bộ đếm chỉ giảm theo ngày bất kể hoàn cảnh. Được nhắc lại biến cố có thể làm cảm xúc nổi lên; được hỗ trợ hoặc giải quyết vấn đề có thể thay đổi nó. Công thức cường độ còn cần kiểm chứng gameplay.

## 6. Sự thật, quan sát và niềm tin

Hệ thế giới giữ sự thật. NPC chỉ nhận dữ liệu từ giác quan, hành động kiểm tra, liên lạc hoặc suy luận từ điều đã biết.

Một niềm tin có nội dung, chủ thể/đối tượng được nhận diện, thời điểm sự việc được cho là xảy ra, thời điểm nhận tin, nguồn, độ tin cậy và bằng chứng liên quan. Chưa biết thời điểm thì lưu là chưa biết, không tự lấy thời điểm hiện tại.

Ví dụ: “Lần tôi tới hôm trước, quầy còn gạo” khác “quầy còn gạo bây giờ”. NPC có thể đi kiểm tra rồi phát hiện đã hết. Độ chắc về tồn kho giảm nhanh hơn hiểu biết địa lý như vị trí ngọn núi.

Thông tin mâu thuẫn có thể cùng được giữ dưới dạng các giả thuyết. NPC cập nhật đánh giá khi có bằng chứng; không cần luôn tin thông tin mới nhất hoặc luôn tin người có thiện cảm cao nhất.

## 7. Nhận diện và giới hạn suy luận

Danh tính thật và danh tính được nhận ra là hai việc khác nhau. Người che mặt có thể chỉ được nhớ là “người mặc áo xám”, không tự liên kết với mã NPC thật trong hiểu biết của nhân chứng.

Hệ thống nội bộ giữ mã để nhất quán sự kiện nhưng lớp lập kế hoạch không được dùng mã bí mật như tri thức. Khi có bằng chứng nhận diện, có thể nối các quan sát cũ với người được nhận ra; vẫn giữ mức nghi ngờ nếu chưa chắc.

Suy luận cần quy tắc được mô tả: thấy người đi vào đường núi có thể đoán họ tới khu vực đó, không suy ra chính xác điểm đến. Đề xuất giới hạn suy đoán ý định người khác ở một tầng cho bản đầu; không tính vô hạn “A nghĩ B nghĩ C…”.

## 8. Ký ức và khả năng quên

| Loại | Ví dụ | Cách giữ đề xuất |
| --- | --- | --- |
| Trải nghiệm | Được cứu, bị lừa, buổi học quan trọng | Sự kiện có thời điểm, người liên quan, cảm nhận |
| Kiến thức | Đường đi, điều kiện tuyển sinh, cách dùng dụng cụ | Nội dung và nguồn học, mức thành thạo/tin cậy |
| Thói quen | Thường mua tại quầy quen, lịch làm | Quy tắc đã hình thành, có thể điều chỉnh |
| Cam kết | Nợ tiền, hẹn gặp, nhận chăm sóc | Hồ sơ bền vững riêng, không dựa vào nhớ toàn văn |

Ký ức nổi bật tùy tác động tới mục tiêu, cảm xúc, mức bất ngờ và quan hệ. Việc thông thường được gộp: “làm cùng người này nhiều mùa”, không lưu từng lần cầm cuốc thành một câu chuyện.

Tóm lược giữ mốc quan trọng, nguồn và các quan hệ còn cần. Nó không sửa sự thật hoặc tự hoàn thành khoản nợ. Có thể quên một lời hẹn, nhưng nghĩa vụ khách quan vẫn tồn tại; vi phạm và phản ứng của người khác vẫn được xử lý.

Quên chi tiết không có nghĩa thiện cảm tự về 0. Ấn tượng đã hình thành có thể còn trong quan hệ. Không cộng lại ảnh hưởng quan hệ khi nạp ký ức hoặc tóm lược: mỗi thay đổi được gắn sự kiện nguồn để áp dụng một lần.

## 9. Quan hệ có hướng và nhiều chiều

A tin B không có nghĩa B tin A. Quan hệ đề xuất gồm quen biết, tình cảm, tin cậy theo lĩnh vực, kính trọng, sợ hãi, bất mãn và gắn bó. Nợ và lời hứa là hồ sơ riêng, không chỉ một điểm cảm xúc.

Có thể tin một người giữ lời nhưng không tin khả năng chữa bệnh của họ. Kính trọng sức mạnh không đồng nghĩa yêu mến. Một kẻ thù có thể được đánh giá là đối tác giao dịch đáng tin trong điều kiện nhất định.

Mỗi thay đổi quan hệ cần có nhận thức nguồn, cách diễn giải và mức tác động. Không cộng thiện cảm vô hạn bằng việc chào lặp: tương tác giống nhau có giá trị giảm, chiếm thời gian và có thể gây phiền nếu không phù hợp.

Hòa giải cần điều kiện: thông tin mới, bồi thường, hành vi qua thời gian hoặc thay đổi mục tiêu. Không mặc định một món quà xóa mọi phản bội.

## 10. Danh tiếng và lời đồn

Danh tiếng là những đánh giá lưu truyền trong một nhóm hoặc mạng liên lạc, không phải thanh toàn thế giới cập nhật tức thời. Một thị trấn có thể kính trọng người mà nơi khác chưa từng nghe tên.

Lời đồn có nội dung, nguồn trực tiếp, nguồn gốc nếu biết, thời gian, đường truyền và biến thể. Kể lại tốn hành động giao tiếp hoặc sử dụng phương tiện truyền tin thật; phải xét khoảng cách và cơ hội gặp.

Nhiều người kể lại cùng nguồn không tự thành nhiều bằng chứng độc lập. Hệ nội bộ có thể giữ quan hệ nguồn để tránh khuếch đại sai; NPC chỉ biết nguồn mà họ được cung cấp hoặc tìm ra. Nếu nguồn bị che, họ vẫn có thể bị thuyết phục sai nhưng không được bốc thêm độ chắc vô hạn qua một vòng truyền tin không có đầu vào mới.

Không gửi mọi sự kiện đến mọi NPC. Tin được chọn theo liên quan, người nghe, mục đích kể, độ nhạy cảm và chi phí. Bí mật có quyền truy cập xã hội và động cơ tiết lộ, không chỉ một cờ “không bao giờ được nói”.

## 11. Chọn việc trong giới hạn hiểu biết

Ví dụ định lượng và lịch trách nhiệm An Khê nằm ở [[CONG_VIEC_THU]]; chưa thay mô hình động cơ dài hạn hoặc chứng minh NPC tự duy trì sinh kế.

Chu trình quyết định:

1. Nhận thay đổi có thể cảm nhận và kết quả hành động vừa thực hiện.
2. Cập nhật hiểu biết, cảm xúc và quan hệ bị ảnh hưởng.
3. Xem nhu cầu/ nghĩa vụ nào cần quan tâm; tạo hoặc đổi mục tiêu có nguồn.
4. Lấy các phương án đã biết từ hệ hành động.
5. Loại phương án không thể làm hoặc vượt giới hạn thực thi; đánh giá phương án còn lại theo niềm tin.
6. Chọn bước tiếp theo, cam kết tài nguyên hợp lệ và thực hiện theo đồng hồ chung.
7. So sánh kết quả với mong đợi để học và điều chỉnh.

Luật pháp xã hội khác giới hạn vật lý. NPC có thể cân nhắc phạm luật nếu tính cách, động cơ và đánh giá hậu quả cho phép; nhưng không có quyền dùng đồ của người khác như đồ mình. Nếu lấy trái phép, phải thực hiện hành động tương ứng với nguy cơ bị phát hiện và hậu quả. Giới hạn của nhân vật người chơi trong HANH_DONG vẫn được giữ nguyên.

Không biết có đường an toàn thì NPC có thể chọn đường nguy hiểm đã biết, hoặc tìm thông tin. Thiết kế không đảm bảo họ luôn tối ưu, nhưng phải giải thích được vì sao lựa chọn có vẻ hợp lý với họ.

## 12. Cam kết, kiên trì và tránh dao động

Mục tiêu đang làm có chi phí chuyển việc. Chênh lệch nhỏ không làm NPC bỏ ngang liên tục. Khẩn cấp, mất điều kiện hoặc thông tin quan trọng có thể vượt mức cam kết đó.

Lập kế hoạch dài hạn theo cột mốc; hành động gần thì cụ thể. Thất bại có mốc đánh giá lại và phương án dự phòng. Không lặp “đến cửa hàng đã đóng” mỗi giây nếu chưa có dữ kiện mới.

Trọng số ưu tiên, mức cam kết và thời gian đánh giá lại chưa chốt. Chúng cần kiểm chứng trên các cuộc sống khác nhau để tránh mọi NPC cùng có một lịch hoàn hảo hoặc đều bỏ việc kiếm ăn vì mải tu luyện.

## 13. Giao tiếp là hành động có kết quả thật

Ý định giao tiếp gồm hỏi, trả lời, nhờ, đề nghị, mặc cả, hứa, từ chối, cảnh báo, nói dối và xin lỗi. Đối tượng phải có thể tiếp nhận bằng hình thức liên lạc phù hợp.

Nội dung được tạo từ dữ kiện người nói có thể biết; nói dối là lựa chọn nội dung sai có chủ đích, khác nhầm lẫn. Người nghe đánh giá theo nguồn, bằng chứng và mục tiêu của mình, không biết tự động đâu là lời nói dối.

Đề xuất bản đầu dùng hội thoại có cấu trúc và nhiều cách diễn đạt. Nếu sau này dùng AI ngôn ngữ, văn bản phải dựa trên kết quả có cấu trúc; lời văn không được tự tạo nợ, vật phẩm, thân phận hoặc công pháp ngoài trạng thái đã được hệ thống xác nhận.

Thuyết phục thay đổi đánh giá/ý định trong điều kiện phù hợp; không là nút điều khiển tuyệt đối NPC. Một lời từ chối có thể giữ nguyên khi đề nghị không thay đổi.

## 14. Lời hứa và hợp tác

Sổ cam kết khách quan thuộc kinh tế/tổ chức theo [[LIEN_KET_HE_THONG]], mục 2; NPC giữ nhận thức, ký ức và phản ứng về cùng hồ sơ, không lưu một khoản nợ thứ hai. Nguồn tin nội bộ chống áp dụng lặp không được trở thành bằng chứng suy luận bí mật.

Cam kết giữ các bên, điều đã thỏa thuận, điều kiện, hạn, tài sản liên quan, cách xác nhận hoàn tất và quyền hủy. Giao tiếp chỉ tạo cam kết khi các bên chấp nhận; câu “tôi sẽ thử” không đồng nghĩa hợp đồng bảo đảm thành công.

Việc nhóm có vai trò, tiến độ và điều kiện gặp nhau. Người dẫn đoàn chờ quá lâu có thể đổi kế hoạch theo thỏa thuận. Không dịch chuyển thành viên đến điểm tập hợp hoặc giả định họ luôn có mặt.

Vi phạm cam kết là sự kiện khách quan theo quy tắc hợp đồng; đánh giá đạo đức tùy người biết tin. Chủ nợ có thể giận trong khi gia đình người bị thương cảm thông. Cần truyền tin để các đánh giá đó thay đổi.

## 15. Gia đình, nghề nghiệp và tổ chức

Gia đình là mạng người và nghĩa vụ, không chỉ một nhãn họ. Tài sản có chủ sở hữu hoặc quyền dùng rõ; không tự gộp tất cả tiền vào ví chung nếu chưa có quy tắc gia đình.

Nghề tạo lịch, kỹ năng, thu nhập, quan hệ và trách nhiệm. Mất khả năng làm nghề có thể dẫn đến điều trị, đổi dụng cụ, nhờ giúp, học nghề khác hoặc rời nơi sống. Lựa chọn phụ thuộc nguồn lực và hiểu biết.

Tổ chức giao việc qua vai trò/quyền hạn; thành viên có mục tiêu riêng. Hai người cùng môn phái không biết toàn bộ bí mật của nhau. Truyền thừa, bổng lộc, kỷ luật và quyền sở hữu tài nguyên sẽ nối với đặc tả tổ chức/kinh tế sau.

Hôn nhân, nuôi con, kế thừa và sinh sản sẽ có quy tắc vòng đời riêng. Tài liệu này chỉ xác định chỗ nối, chưa tự chốt chuẩn văn hóa hoặc mô hình gia đình cho thế giới.

## 16. Khởi tạo và lịch sử trước khi chơi

Khởi tạo người, quan hệ và tài sản phải nhất quán: cha mẹ lớn tuổi hơn con theo mẫu loài; người có nghề có nguồn kiến thức; nợ có hai phía tham chiếu cùng hồ sơ; gia đình không đồng thời sở hữu trọn cùng một món đồ riêng.

Đề xuất tạo một trạng thái khởi đầu có nguồn gốc được khai báo, rồi mô phỏng một khoảng lịch sử có giới hạn. Tài sản khởi tạo được ghi là tài sản ban đầu, không giả là đã sản xuất qua những ngày chưa được mô phỏng.

Tiểu sử được tóm tắt từ dữ kiện khởi tạo và lịch sử thật đã chạy. Không ghi “từng cứu người chơi” khi chưa có sự kiện tương ứng. Khoảng lịch sử, quy mô dân số và nội dung khởi tạo chưa chốt.

## 17. Vắng mặt, di cư và cái chết

NPC rời vùng vẫn giữ danh tính, mục tiêu, cam kết và lịch sử. Không sinh một bản sao cùng tên khi họ quay về. Di cư cần đường đi, chi phí và điều kiện như hành động khác.

Một người mất tích trong nhận thức của gia đình có thể đang sống ở nơi khác. Hệ gia đình không tự biết cái chết chỉ vì cờ sống/chết trong thế giới đã đổi. Thông báo, chứng kiến hoặc bằng chứng mới tạo nhận biết.

Khi chết, người đó ngừng quyết định; thi thể, vật phẩm, công việc dang dở và cam kết được xử lý theo các hệ liên quan. Ký ức người khác và hồ sơ lịch sử không mất theo đối tượng. Thừa kế cần quy tắc cụ thể sau, không chuyển ngay tài sản cho người chơi gần nhất.

## 18. NPC ngoài vùng quan sát và lưu trữ

Theo THOI_GIAN, bản kiểm chứng dùng vùng nhỏ trước. Mức tổng hợp tương lai phải giữ các quan hệ, khoản nợ, giao hẹn, người phụ thuộc và biến cố quan trọng. Không viết bù câu chuyện tùy ý khi người chơi tới.

Chỉ tạo quan hệ chi tiết cho người từng tương tác hoặc có liên hệ; không dựng bảng mọi người với mọi người. Lưu ký ức quan trọng và tóm lược sinh hoạt theo khoảng để tránh tăng dữ liệu vô hạn.

Khi tóm lược, giữ mã sự kiện còn được cam kết/niềm tin tham chiếu hoặc tạo bản lưu tối giản của nó. Không xóa nguồn khiến quan hệ và nợ trỏ tới dữ liệu không còn tồn tại.

Bản lưu gồm mục tiêu, hiểu biết, ký ức đã tóm lược, quan hệ, cảm xúc, cam kết, việc đang làm và trạng thái ngẫu nhiên. Cùng bản lưu, lệnh và phiên bản phải cho cùng diễn biến; mở trang NPC không bốc lại tính cách hoặc quyết định.

## 19. Giải thích hành vi cho người chơi

Giao diện chỉ hiển thị điều người chơi quan sát hoặc được biết: hành động công khai, lời nói, lịch đã được chia sẻ, quan hệ tự đánh giá. Không công khai toàn bộ động cơ, số tin cậy, tiền giấu hoặc vị trí NPC chưa biết.

Ví dụ:

> **Lâm, người hái thuốc:** lần cuối gặp ở y quán sáng hôm qua.  
> Anh nói đang tạm nghỉ vì chân đau và cần tìm việc gần làng.  
> Đã hứa mang dược liệu vào cuối tuần; hiện chưa có tin xác nhận.  
> Bạn nhớ anh từng trả khoản vay đúng hẹn.

Công cụ phát triển có thể xem chuỗi nguồn → niềm tin → mục tiêu → phương án → lựa chọn để tìm lỗi. Thông tin toàn tri đó không tự đi vào giao diện chơi.

## 20. Một câu chuyện mẫu có nhiều kết quả

Ví dụ dữ liệu kiểm chứng, không phải NPC đã được tạo trong game:

| Người | Hoàn cảnh | Động cơ có thể xung đột |
| --- | --- | --- |
| Lâm | Hái thuốc, có người thân phụ thuộc, chân bị thương | Cần thu nhập nhưng tránh làm chân nặng thêm |
| An | Thầy thuốc, kho dược liệu hạn chế | Muốn giúp người, phải duy trì y quán |
| Bình | Người vận chuyển từng giữ lời | Muốn nhận việc, đang có chuyến hàng khác |

Lâm biết An qua lần khám cũ, đề nghị chữa trả chậm. An xem nguồn lực và quan hệ, có thể nhận hoặc từ chối; sự giúp đỡ không được bảo đảm bởi cốt truyện. Nếu nhận, tạo khoản nợ và dùng thuốc thật.

An thiếu dược liệu nên tìm nguồn đã biết hoặc hỏi người vận chuyển. Bình cân nhắc lịch và thù lao; nếu nhận thì tạo cam kết. Chậm hàng có thể làm An nghi Bình thất hứa, nhưng chỉ sau mốc kỳ vọng và dựa trên thông tin An có.

Nếu thư báo đường bị chặn tới nơi, An có thể đổi đánh giá, tìm nguồn khác hoặc kéo dài hạn. Nếu không có thư, hiểu lầm có thể tồn tại. Lâm có thể làm việc nhẹ để trả nợ, nhờ người thân, hoặc tiếp tục mắc nợ; không bị ép tham gia một nhiệm vụ cố định.

Chuỗi trên vẫn diễn ra nếu người chơi đứng ngoài. Khi người chơi can thiệp, chỉ những hành động và thông tin thật được đưa vào mới thay đổi diễn biến.

## 21. Tiêu chí kiểm chứng khi triển khai

| ID | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| NPC01 | Người chơi rời làng | NPC tiếp tục công việc và nghĩa vụ theo thời gian chung |
| NPC02 | Giá hàng thay đổi khi NPC vắng | NPC không tự biết giá mới trước khi nhận thông tin |
| NPC03 | A tin B, B chưa biết A | Không tự tạo quan hệ đối xứng |
| NPC04 | Kể lại cùng một lời đồn qua vòng tròn | Không tăng độ chắc vô hạn hoặc coi là vô hạn nguồn độc lập |
| NPC05 | Người che mặt gây chuyện | Nhân chứng không tự biết danh tính thật |
| NPC06 | Tóm lược ký ức có khoản nợ | Nợ vẫn tồn tại, không mất nguồn tham chiếu |
| NPC07 | Tải hoặc xem lại một ký ức | Không cộng lại thiện cảm hay thù hằn |
| NPC08 | Người hào phóng không đủ tiền ăn | Có thể từ chối cho vay với lý do tài chính |
| NPC09 | Chân bị thương khi đang làm nghề | Dùng năng lực thật để đổi hành động; không có cơ thể riêng cho AI |
| NPC10 | Đối tác chết ở xa | Người khác chỉ đổi niềm tin khi có thông tin hợp lệ |
| NPC11 | Bằng chứng mới bác lời đồn | Có thể cập nhật niềm tin, giữ lịch sử nguồn cũ |
| NPC12 | Đề nghị thuê chưa được nhận | Không tạo cam kết hoặc điều khiển NPC |
| NPC13 | Chào/tặng quà lặp | Không tạo thiện cảm tăng vô hạn miễn phí |
| NPC14 | Hai mục tiêu gần ngang nhau | Không đổi việc liên tục khi chưa có thay đổi đáng kể |
| NPC15 | NPC rời rồi quay lại | Giữ danh tính, tài sản, cam kết và lịch sử |
| NPC16 | Hội thoại diễn đạt một lời hứa | Chỉ cam kết có cấu trúc được chấp nhận mới đổi trạng thái |
| NPC17 | Cùng bản lưu và đầu vào | Quyết định tái hiện được, không phụ thuộc mở giao diện |
| NPC18 | Không có người chơi can thiệp | Chuỗi đời sống mẫu vẫn hình thành từ nhu cầu và nguồn lực |

Chưa chạy các kiểm chứng này vì chưa có game. Khi triển khai cần quan sát cả hành vi cá nhân lẫn cộng đồng: tỷ lệ công việc kẹt, nghĩa vụ thất bại, nhu cầu không được đáp ứng và chi phí xử lý; không chỉ kiểm tra văn bản tiểu sử nghe hợp lý.

## 22. Phạm vi đầu và việc tiếp theo

Đề xuất kiểm chứng trước với một nhóm người có nghề, một quan hệ gia đình, một khoản nợ, một giao hẹn, một nguồn tin sai và một người bị thương. Dùng hành động có cấu trúc trước khi tăng lượng hội thoại hoặc số NPC.

Còn mở: thang tính cách, mức thay đổi lâu dài, chuẩn văn hóa, vòng đời gia đình, giới hạn suy luận, mức chi tiết ký ức và quyền tự chủ của nhân vật người chơi. NPC độc lập không đồng nghĩa tự chốt cho nhân vật người chơi quyền chống lệnh.

Bốn nền đã có bản đề xuất; K1/K2 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K1]] và [[KIEM_TOAN_DONG_GOI_K2]], K3.1 tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. Tất cả vẫn chưa chạy. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
