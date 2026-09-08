---
aliases: [Cơ thể thương tích và sinh lý]
tags: [thiet-ke, nen-tang, co-the]
status: de-xuat
updated: 2026-09-05
---

# Cơ thể, thương tích và sinh lý — đặc tả 0.1

Liên quan: [[MASTER_PLAN|Kế hoạch tổng thể]] · [[THOI_GIAN|Thời gian]] · [[HANH_DONG|Hành động]] · [[DECISIONS|Quyết định]].

> Người dùng yêu cầu cơ thể có các bộ phận và thương tích rất chi tiết. Cấu trúc, quy tắc và phạm vi dưới đây là đề xuất thiết kế game; chưa được chốt hoặc triển khai. Đây là mô hình sinh lý hư cấu phục vụ gameplay, chưa có công thức y khoa hoặc thời lượng điều trị thực tế.

## 1. Kết quả trải nghiệm

Một vết thương phải có địa điểm, lịch sử và hậu quả riêng. Đau bàn tay làm thay đổi cách cầm dao, chậm thu hoạch và giảm thu nhập; không chỉ trừ một lượng máu chung. Nhân vật có thể đổi tay, dùng công cụ khác, thuê người giúp hoặc nghỉ để hồi phục.

Sức mạnh tu luyện không tự xóa mọi nhu cầu cơ thể. Muốn chịu được độc, không cần ăn, tái tạo chi hoặc thay thế hô hấp, công pháp/cảnh giới phải cung cấp một cơ chế cụ thể với điều kiện và chi phí.

NPC dùng cùng mô hình. Người thợ bị thương có thể ngừng sản xuất, gia đình thiếu thu nhập, cửa hàng thiếu hàng. Tổn thương cơ thể phải nối được tới những hậu quả xã hội đó.

## 2. Bốn lớp cần tách biệt

| Lớp | Nội dung | Ví dụ |
| --- | --- | --- |
| Cấu trúc | Bộ phận, mô, liên kết | Cẳng tay trái, gân, khớp cổ tay |
| Trạng thái | Tình trạng thực tại thời điểm game | Mô rách, nhiễm bẩn, thiếu nước |
| Chức năng | Khả năng cơ thể đang cung cấp | Lực nắm, sức chịu tải, thị giác |
| Nhận biết | Điều nhân vật hoặc thầy thuốc biết | Đau khi xoay tay; nghi tổn thương sâu |

Chức năng được tính từ trạng thái, không chỉnh tay ở nhiều nơi. Nhận biết có thể thiếu hoặc sai; thiếu triệu chứng không có nghĩa cơ thể lành.

## 3. Cơ thể là cây bộ phận cộng mạng liên kết

Cây bộ phận dùng để định vị và quản lý sở hữu mô. Các mạng khác thể hiện phụ thuộc chức năng; chỉ một cây cha–con không đủ biểu diễn tuần hoàn, thần kinh hoặc kinh mạch.

Ví dụ khung người, chưa phải danh mục giải phẫu hoàn chỉnh:

```text
Cơ thể
├─ Đầu: sọ, não, mắt trái/phải, tai trái/phải, mũi, miệng, hàm
├─ Cổ: cấu trúc nâng đỡ, đường dẫn quan trọng
├─ Thân
│  ├─ Ngực: thành ngực, tim, phổi trái/phải
│  ├─ Bụng: thành bụng, dạ dày, ruột, gan, thận trái/phải
│  ├─ Chậu: cấu trúc nâng đỡ, cơ quan liên quan
│  └─ Cột sống: các vùng có quan hệ với thần kinh và vận động
├─ Tay trái/phải: vai → cánh tay → khuỷu → cẳng tay → cổ tay → bàn tay → ngón
└─ Chân trái/phải: háng → đùi → gối → cẳng chân → cổ chân → bàn chân → ngón
```

Các cấu trúc thiếu trong khung này được thêm bằng mẫu dữ liệu, không coi là không tồn tại trong thế giới. Trước triển khai cần danh mục bộ phận theo chặng, ghi rõ bộ phận nào được tách riêng và bộ phận nào đang tổng hợp.

Mỗi bộ phận có mã bền vững, bên trái/phải nếu có, vị trí, kích thước, khối lượng, mô cấu thành, vùng che phủ và các liên kết. Không dựa vào chuỗi tên để kiểm tra hành động; sinh vật bốn tay cũng phải dùng được cùng hệ thống.

Các mạng đề xuất:

- Cơ học: gắn kết, khớp, đường truyền lực và giới hạn chuyển động.
- Tuần hoàn: vùng được cung cấp và đường liên quan tới mất máu.
- Thần kinh: truyền điều khiển và cảm giác giữa các vùng.
- Đường dẫn: hô hấp, tiêu hóa và bài tiết ở mức mô phỏng đã chọn.
- Kinh mạch: mạng hư cấu dẫn linh lực, có thể giao thoa với bộ phận hữu cơ nhưng không đồng nhất với mạch máu.

Mô hình tổng hợp không cần ghi từng mao mạch; một nhóm mạch có thể đại diện vùng cung cấp. Phải ghi giới hạn này rõ trong dữ liệu.

## 4. Mẫu loài và cơ thể từng cá thể

Mẫu loài định nghĩa cấu trúc và chức năng bình thường. Cá thể có kích thước, tuổi, đặc điểm bẩm sinh, biến đổi do sống và tu luyện, bộ phận thiếu/thay thế và lịch sử riêng.

Không nhân bản toàn bộ mô tả loài vào mỗi NPC; lưu tham chiếu phiên bản mẫu và phần trạng thái khác biệt. Khi mẫu thay đổi, bản lưu cần quy tắc chuyển đổi chứ không tự mọc thêm bộ phận ngoài ý muốn.

Loài mới có thể không có máu, có nhiều cơ quan thay thế, hoặc sử dụng cấu trúc khác. Hành động kiểm tra chức năng cần thiết thay vì mặc định ai cũng có hai tay và hai chân.

## 5. Mô và mức tổn hại

Đề xuất nhóm mô: lớp che phủ, mô mềm, cơ, gân/dây chằng, xương, mô thần kinh, cấu trúc mạch và mô cơ quan chuyên biệt. Không phải bộ phận nào cũng có mọi nhóm hoặc theo cùng thứ tự lớp.

Mô ghi độ liên tục cấu trúc, phần bị mất/hỏng, biến đổi lâu dài, khả năng phục hồi và đặc tính chịu tác động. Các thuộc tính này dựa trên vật liệu sinh học của loài và biến đổi tu luyện.

Không dùng một chỉ số nguyên vẹn để đại diện đồng thời vết cắt, độc và kiệt sức. Tổn thương cấu trúc, tình trạng hóa học, mệt mỏi và nhiễm bệnh là các trạng thái khác nhau, dù cùng làm giảm chức năng.

Đường tác động xác định lớp bị trúng. Một đòn từ phía ngoài không tự gây thương tích cơ quan được che kín nếu chưa có đường xuyên, truyền lực hoặc cơ chế thuật pháp phù hợp.

## 6. Hồ sơ thương tích

| Nhóm dữ liệu | Trường cần giữ |
| --- | --- |
| Danh tính | Mã thương tích, chủ thể, thời điểm, sự kiện nguyên nhân |
| Vị trí | Bộ phận, mô, vùng bị ảnh hưởng, đường xuyên nếu có |
| Cơ chế | Cắt, đâm, va đập, kéo/xoắn, nhiệt, hóa chất, linh lực |
| Cấu trúc | Mức đứt liên tục, mô mất, dị vật, độ ổn định |
| Quá trình | Chảy máu, diễn biến viêm/nhiễm, tiến độ sửa chữa |
| Chăm sóc | Can thiệp, người thực hiện, vật tư, thời điểm, hiệu lực |
| Lịch sử | Tái tổn thương, biến chứng, sẹo, di chứng |
| Liên kết | Chức năng và quá trình bị ảnh hưởng |

Một đòn có thể tạo một hồ sơ tổn thương với nhiều mục mô, hoặc nhiều thương tích liên quan cùng sự kiện. Chỉ một nơi chịu trách nhiệm tổng hợp lượng mô hỏng và mất máu để tránh đếm đôi.

Vết thương mới đè lên vết cũ phải xét phần mô còn lại; tổng mô mất không vượt phần đang tồn tại. Hồi phục vết cũ không được tự khôi phục mô vừa bị phá hủy bởi vết mới. Đề xuất bộ phận giữ trạng thái mô hiện tại, hồ sơ thương tích giữ nguyên nhân và phần đóng góp có giới hạn.

## 7. Từ tác động thành hậu quả

1. Hệ chiến đấu/tai nạn cung cấp loại tác động, vị trí, hướng và cường độ theo đơn vị game sẽ chốt.
2. Hệ vật phẩm và phòng hộ xử lý lớp che chắn còn hiệu lực; ghi hư hỏng và tác động còn truyền vào.
3. Hệ cơ thể giải quyết mô bị ảnh hưởng, tạo hồ sơ thương tích.
4. Cập nhật quá trình như mất máu, đau, mất ổn định khớp, rò linh lực nếu có cơ chế.
5. Tính lại chức năng và phát thông báo cho hành động đang dùng chức năng đó.
6. Hệ nhận thức xác định triệu chứng mà nhân vật nhận biết; chính sách hành động chọn phản ứng.

“Sát thương” đầu vào không bị trừ một lần ở thanh máu rồi tiếp tục trừ lần nữa ở mô. Không cần thanh máu tổng để quyết định sống chết. Có thể dùng nhãn tóm tắt tình trạng trên giao diện.

## 8. Năng lực chức năng

| Năng lực | Đầu vào chính trong mô hình | Hoạt động liên quan |
| --- | --- | --- |
| Chịu tải và di chuyển | Chi hỗ trợ, khớp, điều khiển, thể lực, đau | Đi, chạy, mang vác |
| Nắm giữ từng chi | Cấu trúc bàn/ngón, gân, điều khiển | Cầm kiếm, mang đồ |
| Thao tác tinh | Điều khiển, cảm giác, thị giác, ổn định | Châm khắc, luyện đan, sửa đồ |
| Quan sát | Cơ quan cảm giác, môi trường, chú ý | Đọc, phát hiện, nhận diện |
| Phát âm | Cấu trúc liên quan, hơi, điều khiển | Giao tiếp, thuật cần đọc chú |
| Duy trì gắng sức | Trao đổi khí, tuần hoàn, dự trữ, mệt mỏi | Lao động và chiến đấu dài |
| Tập trung chủ động | Mức tỉnh táo, thiếu ngủ, đau, trạng thái khác | Học, vận công, theo dõi lò |
| Dẫn và điều khiển linh lực | Tuyến kinh mạch, đan điền, khả năng điều khiển | Tu luyện, thi triển công pháp |

Mỗi chức năng trả mức khả dụng, giới hạn, nguyên nhân và phiên bản cập nhật. Đề xuất chuẩn hóa hiệu suất quanh mức cơ thể bình thường của chính cá thể, nhưng yêu cầu hành động vẫn cần lượng tuyệt đối: một người yếu khỏe mạnh không nâng được vật nặng như một người khỏe mạnh hơn.

Không cộng lực tất cả chi để cho phép hành động đòi hỏi một chi riêng: nắm hai tay, nắm một tay và thao tác tinh có điều kiện khác nhau. Chi giả/công cụ trợ giúp cung cấp chức năng theo cơ chế riêng, không nhất thiết khôi phục cảm giác.

Tránh nhân cùng một hình phạt nhiều lần: nếu thương tích đã giảm tốc độ qua chức năng nắm, hành động không tiếp tục trừ một hệ số “bị thương tay” chung cho cùng tác động. Nguy cơ tái thương do tải là một hiệu ứng khác, có nguyên nhân riêng.

## 9. Sinh lý toàn thân

Đề xuất các kho và quá trình liên kết, không biến thành danh sách thanh trạng thái độc lập:

| Hệ | Trạng thái cần theo dõi | Tương tác |
| --- | --- | --- |
| Nước | Dự trữ, thu nhận, thất thoát | Môi trường, vận động, bài tiết |
| Dinh dưỡng | Thức ăn đang xử lý, năng lượng và vật liệu cơ thể dùng được | Lao động, sửa mô, tăng trưởng |
| Hô hấp và tuần hoàn | Khả năng cung cấp cho nhu cầu hiện tại | Gắng sức, thương tích, bất tỉnh |
| Nhiệt | Trạng thái nhiệt trung tâm và vùng khi cần | Quần áo, thời tiết, lửa, thuật pháp |
| Mệt mỏi | Toàn thân và vùng cơ đang làm việc | Năng suất, nghỉ, tái tổn thương |
| Ngủ | Nhu cầu ngủ, chất lượng nghỉ, nhịp sinh hoạt | Tập trung, lịch làm việc, hồi phục |
| Bài tiết và vệ sinh | Tải cần xử lý, điều kiện vệ sinh | Nước, môi trường, nguy cơ phơi nhiễm |
| Tăng trưởng và lão hóa | Giai đoạn sống, khả năng nền và lịch sử hao tổn | Nhu cầu, thích nghi, tu luyện |

Ăn đưa thực phẩm vào quá trình xử lý, không lập tức biến toàn bộ thành thể lực. Ngủ giảm những dạng mệt mỏi tương ứng, không tự liền gãy xương sau một đêm. Một bình nước không chữa mọi nguyên nhân chóng mặt.

Các kho vật chất có đơn vị và giới hạn rõ khi triển khai. Dùng cùng đơn vị với vật phẩm; không để một phần thức ăn vừa còn trong túi vừa được hấp thu. Những ngoại lệ tạo/chuyển vật chất bằng linh lực phải được khai báo riêng.

## 10. Đau, tỉnh táo và khả năng hành động

Đau là triệu chứng và yếu tố ảnh hưởng chú ý/hành xử, không đồng nghĩa lượng mô hỏng. Giảm đau có thể giúp làm việc nhưng không sửa cấu trúc và có thể khiến nhân vật ước lượng sai khả năng chịu tải.

Tách tỉnh táo, khả năng điều khiển và sống/chết. Nhân vật có thể tỉnh nhưng không đứng được; đang ngủ không phải đã chết; bất tỉnh không làm các quá trình sinh lý ngừng chạy.

Ngưỡng mất năng lực phát sự kiện tới [[HANH_DONG]]: hủy hoặc ngắt thao tác chủ động, thả tài nguyên không còn giữ được, xử lý hậu quả của công pháp/lò đang vận hành. Quá trình thụ động và tác động bên ngoài vẫn tiếp tục.

Không dùng một xác suất chết hàng ngày độc lập với tình trạng. Cái chết phải đến từ quy tắc suy sụp hoặc phá hủy chức năng thiết yếu của loài; ngưỡng và độ trễ là dữ liệu thiết kế chưa chốt. Linh hồn, đoạt xá, hồi sinh là hệ hư cấu tương lai, không được mặc định tự cứu nhân vật.

## 11. Nhiễm bẩn, bệnh và độc chất

Phân biệt tiếp xúc nguồn, chất/tác nhân vào cơ thể, quá trình phát triển, triệu chứng và hậu quả chức năng. Vết bẩn không lập tức đồng nghĩa nhiễm trùng nặng.

Độc chất đề xuất có hồ sơ lượng hiện diện, đường vào, vùng/tác dụng đích, tốc độ biến đổi và thải trừ theo mô hình game. Thuốc cũng dùng cơ chế hiệu ứng có điều kiện, có thể có tác dụng phụ và tương tác; không coi mọi thuốc là “+hồi phục”. Không định nghĩa liều dùng thực tế trong đặc tả này.

Bệnh có điều kiện phơi nhiễm, diễn biến, nguồn lây nếu có, khả năng phòng vệ và biểu hiện. Xác suất biến chứng phải gắn với quá trình phơi nhiễm theo thời gian, không bốc thăm lại mỗi lần mở bảng cơ thể hoặc đổi tốc độ giao diện.

Chi tiết bệnh, dược lý, hệ miễn dịch và tác nhân sẽ cần đặc tả riêng. Bản đầu kiểm chứng một quá trình nhiễm tại vết thương và một hiệu ứng độc hư cấu, không tuyên bố đã có y học toàn diện.

## 12. Điều trị và phục hồi

Điều trị là hành động có người thực hiện, kiến thức, khả năng thao tác, dụng cụ, vật liệu, thời gian và đối tượng cụ thể. Tự chăm sóc phải kiểm tra vùng có thể tiếp cận và số chi còn dùng được.

Các nhóm hiệu ứng thiết kế: giảm mất máu, ổn định cấu trúc, thay đổi mức nhiễm bẩn, hỗ trợ quá trình phục hồi, giảm triệu chứng, thay thế chức năng. Mỗi cách chỉ tác động đúng những quá trình được khai báo.

Hiệu ứng có nguồn, thời điểm bắt đầu, thời hạn hoặc điều kiện kết thúc và quy tắc chồng lấp. Hai lớp băng không mặc định nhân đôi tốc độ hồi phục; hiệu ứng mạnh hơn có thể thay thế hoặc cùng tồn tại theo loại.

Phục hồi xét mô còn sống, nguồn dinh dưỡng, điều kiện tại chỗ, sử dụng bộ phận, bệnh và năng lực loài. Một số tổn thương để sẹo, lệch cấu trúc hoặc mất chức năng lâu dài. Không định nghĩa mọi vết thương là thanh đếm về 0 chắc chắn.

Đồ băng/nẹp là vật phẩm có danh tính hoặc lô, độ bẩn, độ bền và vị trí trang bị. Khi tháo ra, hiệu ứng phụ thuộc nó phải chấm dứt; đồ vật không biến mất khỏi sổ tài nguyên.

## 13. Sát thương và chữa trị cùng thời điểm

Thứ tự thống nhất đề xuất nằm ở [[LIEN_KET_HE_THONG]], mục 3. Can thiệp duy trì mới được kích hoạt sau nhóm tác động tức thời cùng mốc, rồi mới chi phối đoạn tiếp theo.

Theo [[THOI_GIAN]], tính các quá trình cũ tới mốc hiện tại trước. Mất máu xảy ra trong khoảng trước mốc không được hoàn lại bởi băng vừa hoàn tất ở mốc đó.

Những tác động tức thời đồng thời được giải quyết theo nhóm. Can thiệp giữ hiệu lực từ mốc hoàn tất trở đi, sau khi kiểm tra cơ thể/vật phẩm còn đáp ứng điều kiện. Ví dụ chi bị tách rời đúng mốc hoàn tất cố định khớp thì hiệu ứng cố định không được gắn như thể chi vẫn ở trên thân.

Nếu cơ thể đã tới ngưỡng suy sụp không thể đảo ngược theo quy tắc loài, thao tác thường không hồi sinh. Các thuật tái tạo/hồi sinh tương lai phải có quy tắc riêng và không hồi tố đoạn thời gian đã trôi.

## 14. Tái tổn thương, mất chi và vật thay thế

Làm việc trên bộ phận chưa ổn định có thể khiến vết cũ diễn biến xấu theo tải và đặc tính tổn thương. Không trừ một lượng máu chung cho mọi vận động; đi bộ và thao tác tay gây tải ở các vùng khác nhau.

Nếu triển khai mất chi, cập nhật mạng cơ thể và tạo phần cơ thể tách rời đúng một lần với khối lượng, mô và lịch sử tương ứng. Đồ đang đeo/cầm được xử lý theo vị trí gắn thật; không nhân đôi trang bị. Phần tách rời không tiếp tục cung cấp chức năng cho thân.

Chi giả, ghép và tái tạo là ba cơ chế khác nhau. Tái tạo cần nguồn vật chất/năng lượng, mẫu cấu trúc và quá trình nối chức năng. Không tự đặt lại danh tính nhân vật hoặc xóa toàn bộ lịch sử thương tích.

Các cơ chế này được thiết kế chỗ kết nối từ đầu; danh mục triển khai và giới hạn tái tạo còn mở.

## 15. Kinh mạch và đan điền

Lớp hư cấu đề xuất gồm các nút/vùng tích trữ, đường dẫn, sức chịu tải, độ thông suốt, khả năng điều khiển và tổn thương riêng. Công pháp chọn đường đi và nhịp vận hành qua mạng đó.

Một tuyến hỏng có thể giảm lưu lượng, rò năng lượng hoặc buộc đổi tuyến. Linh lực không phải máu thứ hai: mỗi dạng tổn thương có cơ chế, biểu hiện và phương pháp phục hồi riêng.

Quan hệ với cơ thể hữu cơ phải khai báo: quá tải gây hại mô nào, mô nào hỗ trợ vận hành, công pháp nào thay thế chức năng sinh tồn. Đan điền bị tổn thương không mặc định gây chết nếu chưa có quy tắc như vậy.

Ví dụ công pháp A cho vận hành qua thân khi tay trái tổn thương; công pháp B cần tuyến qua tay trái nên phải ngừng hoặc dùng biến thể đã học. Không có biến thể thì nhân vật không tự sáng tạo một cách an toàn hoàn hảo.

Không chốt số huyệt, số kinh mạch, vị trí đan điền hay hệ cảnh giới ở tài liệu này. Chúng cần phù hợp bộ quy luật tu tiên sẽ thiết kế riêng.

## 16. Gắn với thời gian và hiệu năng

Mỗi quá trình giữ mốc đã cập nhật, trạng thái, nguồn tác động, ngưỡng tiếp theo và phiên bản. Khi bị thương hoặc điều trị, tính tới mốc thay đổi rồi dự báo lại; sự kiện cũ hết hiệu lực không tiếp tục trừ máu.

Quá trình đơn giản có thể tính theo đoạn; quá trình phi tuyến cần bước tính đủ nhỏ hoặc tìm ngưỡng phù hợp. Không giả định dự báo tuyến tính luôn đúng. Ngưỡng nguy cấp phải được phát hiện trước khi cho hành động sau đó hoàn tất.

Cơ thể khỏe đang nghỉ không cần cập nhật từng mô mỗi giây. Chỉ cập nhật phần bị ảnh hưởng và các chức năng phụ thuộc; kiểm tra các quá trình nền tại mốc phù hợp. Vùng xa không được bỏ qua thương tích nguy cấp chỉ vì người chơi không nhìn thấy.

Lưu cả trạng thái tiến trình và nguồn hiệu ứng, tránh tải game làm hết độc, đặt lại thời gian lành hoặc cộng lại tác dụng thuốc. Kết quả phải không phụ thuộc số lần mở bảng cơ thể.

## 17. Nhận biết và giao diện

Ba tầng: tóm tắt ảnh hưởng đến việc đang làm; danh sách vùng có triệu chứng; hồ sơ chi tiết theo điều nhân vật biết. Người chơi không phải đọc toàn bộ cây cơ thể mỗi ngày.

Ví dụ giao diện cho tình huống hư cấu:

> **Tay trái:** đau khi nắm chặt, vết cắt còn nhìn thấy.  
> **Ảnh hưởng:** chưa phù hợp cầm dụng cụ nặng bằng tay trái. Có thể dùng tay phải cho việc nhẹ đã biết.  
> **Đã chăm sóc:** băng vải đang đeo; cần theo dõi tình trạng băng.  
> **Chưa rõ:** mức ảnh hưởng tới mô sâu.  
> **Kế hoạch:** tạm hoãn luyện kiếm hai tay, đánh giá lại sau lần kiểm tra tiếp theo.

Khám và chẩn đoán tạo thông tin có nguồn, thời điểm, độ tin cậy. Thầy thuốc khác nhau có thể nhận định khác nhau. Không hiển thị “gân còn 63%” nếu nhân vật không có khả năng đo tương ứng; số nội bộ thuộc công cụ phát triển.

Tự dừng chỉ dùng dấu hiệu nhận biết hoặc sự mất khả năng điều khiển mà người chơi có thể thấy, không báo tên độc chưa được xác định. Bất tỉnh vẫn có thể hiển thị nhân vật không phản hồi mà không tiết lộ nguyên nhân bí mật.

## 18. Tình huống xuyên hệ thống

**Bối cảnh:** người chơi giao thu hoạch thuốc, giữ tiền sinh hoạt và luyện kiếm buổi chiều.

1. Dụng cụ gây vết cắt tay trái: vật phẩm cung cấp nguồn tác động và mức bẩn.
2. Cơ thể tạo tổn thương tại vùng bị trúng, cập nhật chức năng nắm và triệu chứng.
3. Hành động thu hoạch xét khả năng dùng tay phải hoặc cần dừng; không tự mất toàn bộ tiến độ đã làm.
4. Nhân vật chọn chăm sóc trong hiểu biết và ngân sách; nếu thiếu vật tư, tìm nguồn đã biết.
5. Luyện kiếm hai tay bị hoãn vì không đáp ứng chức năng; việc đọc có thể thay thế nếu đã được giao.
6. Diễn biến vết thương phụ thuộc điều kiện và sử dụng, không chắc chắn nhiễm chỉ vì có vết cắt.
7. Nếu phải nghỉ nhiều ngày, thu nhập giảm và mục tiêu tài chính cần đổi kế hoạch.
8. Khi hồi phục chức năng đủ, nhân vật quay lại việc phù hợp; sẹo hoặc di chứng vẫn được giữ nếu có.

Đây là kịch bản kiểm chứng nhân quả, không phải sự kiện bắt buộc mọi nhân vật phải gặp.

## 19. Chặng kiểm chứng đề xuất

Bộ thông số hư cấu DL03 ở [[CO_THE_THU]] cụ thể hóa chức năng, nhu cầu và vết thương W-B01 cho chuỗi B. Chưa thay thế danh mục đầy đủ hoặc mô phỏng mọi cơ quan trong đặc tả này.

| Chặng | Độ sâu cần kiểm chứng |
| --- | --- |
| A. Cấu trúc và chức năng | Cơ thể người, trái/phải, chi, nhóm mô/cơ quan thiết yếu, hành động cần chức năng |
| B. Thương tích kéo dài | Vết cắt, tổn thương xương/khớp, mất máu, đau, phục hồi và can thiệp |
| C. Sinh lý liên kết | Nước, dinh dưỡng, mệt mỏi, ngủ, nhiệt; một quá trình nhiễm và một độc hư cấu |
| D. Sinh lý tu tiên | Một mạng kinh mạch và hai công pháp dùng nó khác nhau |
| E. Mở rộng | Chi tiết ngón/cơ quan, bệnh, loài khác, lão hóa sâu, mất chi/ghép/tái tạo |

Chặng E không có nghĩa bỏ chi tiết ngón khỏi tầm nhìn; khung dữ liệu đã cho phép định vị, còn mức tính riêng được bổ sung có kiểm chứng. Các chặng chưa là phạm vi người dùng xác nhận.

Trước lập trình cần bảng bộ phận/mô theo chặng, đơn vị đo, hệ số chức năng, quy tắc tổn thương và bộ dữ liệu tình huống. Không gán số tùy ý rồi gọi là chân thật.

## 20. Tiêu chí kiểm chứng khi triển khai

| ID | Tình huống | Kết quả cần đạt |
| --- | --- | --- |
| CT01 | Chỉ tay trái bị thương | Không tự giảm cấu trúc tay phải; hiệu ứng toàn thân chỉ xuất hiện qua cơ chế khai báo |
| CT02 | Hai thương tích trùng vùng | Không hỏng quá lượng mô tồn tại; không cộng mất máu hai lần cho cùng nguồn |
| CT03 | Đổi công cụ hỗ trợ | Chức năng hành động đổi đúng; mô hỏng không tự lành |
| CT04 | Giảm đau | Triệu chứng giảm nhưng tổn thương cấu trúc giữ nguyên |
| CT05 | Tháo vật phẩm điều trị | Hiệu ứng phụ thuộc vật phẩm chấm dứt đúng mốc |
| CT06 | Điều trị cùng mốc sát thương | Không hồi tố mất máu; không gắn hiệu ứng lên vị trí không còn hợp lệ |
| CT07 | Bất tỉnh khi chế tác | Ngắt việc chủ động và giữ hậu quả; sinh lý vẫn chạy |
| CT08 | Lưu tải khi đang hồi phục/nhiễm | Giữ tiến độ, hiệu ứng và ngẫu nhiên; không chữa miễn phí |
| CT09 | Đổi số lần cập nhật màn hình | Kết quả cơ thể giữ nguyên với cùng đầu vào |
| CT10 | Tách chi | Không nhân đôi mô, khối lượng hoặc trang bị; mất đúng chức năng |
| CT11 | Cùng thương tích ở NPC và người chơi | Cùng quy tắc sinh lý nếu thuộc tính và điều kiện bằng nhau |
| CT12 | Kinh mạch bị hỏng | Chỉ công pháp/tuyến phụ thuộc chịu ảnh hưởng theo quy tắc |
| CT13 | Uống/ăn khi vật tư không còn | Không cộng dự trữ; giao dịch vật phẩm và cơ thể nhất quán |
| CT14 | Khám bởi người ít kiến thức | Không tiết lộ trạng thái nội bộ vượt khả năng quan sát |
| CT15 | Mô đã mất gặp sự kiện lành cũ | Sự kiện cũ không tự tái tạo mô |

Hiện chưa chạy các kiểm chứng này vì chưa có mô phỏng. Khi có công thức xấp xỉ, cần thêm kiểm tra hội tụ theo bước thời gian và công bố sai số chấp nhận được.

## 21. Vấn đề mở

- Danh mục giải phẫu chi tiết ở bản đầu và mức tổng hợp chấp nhận được.
- Mức khắc nghiệt, khả năng thích nghi với di chứng và độ phổ biến của tái tạo.
- Quy luật kinh mạch, quan hệ cơ thể–linh hồn, giới hạn thay thế sinh lý bằng linh lực.
- Quy tắc tăng trưởng, lão hóa, di truyền và sinh sản ở đặc tả đời sống tương lai.
- Công thức và thời lượng hư cấu cần cân bằng; nếu sau này muốn đối chiếu sinh học thực, thực hiện một bước nghiên cứu nguồn riêng trước khi gọi thông số là hiện thực.

Bước tiếp theo của kế hoạch: động cơ, nhận thức, ký ức và quan hệ NPC, dùng trạng thái cơ thể làm một nguồn nhu cầu và trải nghiệm.
