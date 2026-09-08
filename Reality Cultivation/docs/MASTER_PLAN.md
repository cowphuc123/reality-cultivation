# Kế hoạch game text mô phỏng thế giới tu tiên — 0.1

Ngày lập: 2026-09-05.

Nguồn: kế hoạch nền tảng trong hội thoại khởi tạo, được biên tập thành hồ sơ dự án. Đây là bản thiết kế đề xuất, không phải đặc tả đã được người dùng duyệt toàn bộ. Xem [DECISIONS.md](DECISIONS.md) để biết yêu cầu đã xác nhận.

## 1. Trải nghiệm cốt lõi

Một thế giới tu tiên sống và vận hành liên tục. Người chơi là một người tồn tại trong thế giới, giao việc, đặt mục tiêu và điều chỉnh hành xử; nhân vật thực hiện trong giới hạn năng lực, hiểu biết và hoàn cảnh.

Mỗi bản lưu bắt đầu bằng [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI|WorldGenesis]]: sinh thế giới, mô phỏng lịch sử hàng trăm, hàng nghìn hoặc hàng vạn năm khi chưa có nhân vật chính, rồi mới cho người chơi chọn vị trí trên bản đồ, sinh ra và điều khiển ngay từ lúc sơ sinh. Đây là yêu cầu người dùng đã xác nhận.

Một ngày có thể dành cho kiếm ăn, chữa thương, sửa nhà; nhiều năm dành cho nghiên cứu công pháp. Đột phá thất bại có thể đổi cả con đường tu luyện.

Ví dụ câu chuyện mong muốn: nhân vật nhận hái thuốc để trả tiền trọ, bị cắt tay và nhiễm trùng do dụng cụ bẩn, phải ngừng luyện kiếm. Thầy thuốc chữa trả chậm vì từng mang ơn sư phụ nhân vật. Khi thầy thuốc mất tích trong chuyến vận chuyển dược liệu, nhân vật có động cơ thật để tìm kiếm. Câu chuyện phải hình thành từ các hệ thống liên kết, không chỉ chọn ngẫu nhiên một đoạn văn.

Vượt Dwarf Fortress hoặc CDDA là tham vọng dài hạn, không phải lời hứa cho bản đầu. Xây nền nhỏ nhưng sâu rồi mở rộng mà không viết lại toàn bộ.

## 2. Nguyên tắc thiết kế

- Nhân quả: thay đổi quan trọng có nguyên nhân truy vết được.
- Liên tục: người, vật và tổ chức quan trọng có danh tính, lịch sử bền vững.
- Nhận thức có giới hạn: nhân vật chỉ biết điều đã quan sát, học hoặc được kể.
- Chi phí thực: hành động tiêu hao thời gian, công sức, vật liệu hoặc cơ hội.
- Khác biệt có tác dụng: chất lượng, thương tích, tính cách, công pháp làm thay đổi kết quả.
- Người chơi hiểu được: giao diện giải thích được mô phỏng và hỗ trợ quản lý.

“Chi tiết vô cùng” được hiểu là khả năng bổ sung chiều sâu mà không phá nền. Không mô phỏng từng phân tử khi chưa tạo ra khác biệt có ích cho gameplay.

## 3. Thời gian và mô phỏng liên tục

Đặc tả đề xuất: [[THOI_GIAN|Thời gian thế giới — 0.1]].

Yêu cầu: 5 giây ngoài đời = 1 ngày game. Tương đương 12 ngày mỗi phút và 720 ngày mỗi giờ ngoài đời.

Đề xuất tạm dừng và quản lý tự động vì đời nhân vật trôi nhanh. Độ chính xác thời gian bên trong phải nhỏ hơn một ngày: lao động kéo dài hàng giờ, chiến đấu và tai nạn có thể cần mức giây hoặc từng hành động.

- Đồng hồ chung theo thời gian game.
- Hành động có bắt đầu, tiến độ, thời điểm kết thúc hoặc lần kiểm tra tiếp theo.
- Xử lý sự kiện theo thứ tự thời gian; không đợi mỗi 5 giây mới tính mọi thứ một lần.
- Tự dừng theo thiết lập khi bị tấn công, nguy cấp, cần quyết định hoặc sắp đột phá.
- Đề xuất bản đầu chỉ chạy khi mở game; mô phỏng khi đóng game chưa chốt.

## 4. Điều khiển bằng ý định

Đặc tả đề xuất: [[HANH_DONG|Hành động và mục tiêu — 0.1]].

Ba mức: hành động cụ thể (băng tay trái), công việc (sáng chăm ruộng, chiều luyện công), mục tiêu (tích lũy tiền và kiến thức để gia nhập môn phái).

Mục tiêu có ưu tiên, ngân sách, điều kiện hoàn thành và giới hạn rủi ro. Ví dụ: trong 30 ngày ưu tiên chữa chân, không đi xa quá nửa ngày đường, giữ tiền đủ ăn 10 ngày, chỉ luyện bài không làm thương tích nặng hơn.

Nhân vật chia mục tiêu thành việc nhỏ dựa trên hiểu biết. Khi không tìm được cách, báo nguyên nhân. Cần hàng đợi công việc, lịch sinh hoạt, quy tắc khẩn cấp và khả năng xem “Tại sao đang làm việc này?”.

## 5. Cơ thể, sức khỏe và thương tích

Đặc tả đề xuất: [[CO_THE|Cơ thể, thương tích và sinh lý — 0.1]].

Dữ liệu kiểm chứng ngắn hạn: [[CO_THE_THU]] và [[CHAM_SOC_K0]] về chức năng tay/chân, vòng đời băng, đích dịch và hồi phục hai vết cùn.

Cơ thể có cấu trúc bộ phận: đầu, cổ, thân, tay, chân; cơ quan, xương, khớp, mạch máu, thần kinh quan trọng; lớp mô phù hợp; kinh mạch và đan điền ở lớp sinh lý tu tiên. Bản đầu có thể giới hạn chi tiết nhưng mô hình phải mở rộng được.

Mỗi thương tích là một đối tượng riêng với vị trí và mô bị ảnh hưởng, nguyên nhân, mức độ, thời điểm, chảy máu, đau, nhiễm bẩn, nhiễm trùng, suy giảm chức năng, điều trị, tiến trình lành, sẹo và di chứng.

Không chỉ dùng một thanh máu: gãy chân ảnh hưởng di chuyển, tổn thương phổi ảnh hưởng hô hấp, tổn thương kinh mạch ảnh hưởng vận công.

Sinh tồn gồm nước, dinh dưỡng, ngủ, mệt mỏi, thân nhiệt và độc chất; liên kết với lao động, chữa bệnh, tu luyện. Y thuật là mô hình gameplay hư cấu, không phải mô phỏng y khoa hoàn chỉnh.

## 6. Tu luyện có cấu trúc và đánh đổi

Đặc tả đề xuất: [[TU_LUYEN|Tu luyện, công pháp và đột phá — 0.1]].

Cảnh giới thay đổi khả năng và cách tương tác với thế giới, không chỉ tăng chỉ số.

Thuộc tính gồm cảm nhận và hấp thu linh khí; dung lượng, độ tinh khiết, tính chất linh lực; khả năng điều khiển; trạng thái kinh mạch, đan điền; kiến thức, kinh nghiệm, hiểu công pháp; tương thích giữa cơ thể, môi trường và phương pháp.

Công pháp có tuyến vận hành, chuyển hóa năng lượng, điều kiện nhập môn, tốc độ, hiệu suất, ổn định, tài nguyên cần dùng, tổn hại tích lũy, dấu hiệu bất thường, phối hợp hoặc xung đột, giới hạn phát triển và hướng cải tiến.

Hai công pháp cùng hệ hỏa có thể khác thực chất: chậm ổn định so với bộc phát mạnh nhưng gây tổn thương khi dùng liên tục.

Đột phá là quá trình chuẩn bị, diễn biến và hậu quả. Ngẫu nhiên phụ thuộc trạng thái cụ thể; phần lớn nguyên nhân thành bại phải giải thích được. Hệ cảnh giới cụ thể chưa chốt.

## 7. NPC có đời sống riêng

Đặc tả đề xuất: [[NPC|Đời sống và quyết định NPC — 0.1]]. Nguồn quyết định cụ thể nằm tại [[NGUON_QUYET_DINH_K1]]; vòng đời nhiều năm và mức mô phỏng xa nằm tại [[DOI_SONG_TU_SINH_K1]]; dữ liệu lịch sử của 20 NPC An Khê nằm tại [[HO_SO_NPC_AN_KHE_K1]]; quy tắc xã hội địa phương nằm tại [[VAN_HOA_THE_CHE_AN_KHE_K1]], sổ kiểm toán 30 ngày tại [[SO_THE_CHE_30_NGAY_K1]], năng lực truyền tri thức tại [[NANG_LUC_NGON_NGU_TRI_THUC_K1]], trạng thái tâm lý tại [[TAM_LY_21_NGUOI_K1]] và dấu vết lựa chọn–hội thoại tại [[DAU_VET_QUYET_DINH_HOI_THOAI_K1]]. Bản kê K1 nằm tại [[KIEM_TOAN_DONG_GOI_K1]]; K2.1–K2.7 nằm tại [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]], [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]], [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]], [[HOP_DONG_NHAN_THUC_QUYET_DINH_TAC_NHAN_K2]], [[HOP_DONG_LUU_TAI_MIGRATION_PHUC_HOI_K2]], [[KE_HOACH_VALIDATOR_ORACLE_K2]] và [[NGAN_SACH_HIEU_NANG_QUY_MO_K2]]; bản kiểm toán tại [[KIEM_TOAN_DONG_GOI_K2]] và kiến trúc triển khai tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]].

NPC dùng chung nền cơ thể, vật phẩm, công việc và tu luyện với người chơi. Mỗi người có xuất thân, tuổi, gia đình, nhu cầu, tính cách, giá trị, kiến thức và niềm tin có thể sai, kỹ năng, tài sản, nghề, nghĩa vụ, mục tiêu và ký ức quan trọng.

Hành động dựa trên hoàn cảnh. Người tham tiền nhưng sợ chết có thể từ chối chuyến hộ tống nguy hiểm dù thù lao cao.

Quan hệ gồm tin tưởng, tình cảm, sợ hãi, kính trọng, món nợ, bất mãn; không nén vào một chỉ số thiện cảm.

NPC có thể đổi nghề, đi xa, kết hôn, nhận đệ tử, bị thương, phá sản hoặc chết. Câu chuyện riêng đến từ thay đổi và phản ứng. Đời sống bình thường như người bán gạo nuôi gia đình cũng cần có ý nghĩa.

## 8. Thông tin, ký ức và lời đồn

Chi tiết nhận thức, nguồn tin và ký ức: [[NPC|Đặc tả NPC]], mục 6–10.

Phân biệt sự thật thế giới với hiểu biết từng người. Thông tin có nguồn, thời điểm, độ tin cậy; lời đồn có thể sai lệch hoặc là lời nói dối có mục đích.

Ví dụ tin hang có linh thảo đã ba tháng tuổi: cây có thể đã bị hái; người đưa tin có thể đang dụ đối thủ.

Nhật ký phân biệt quan sát, lời kể và suy đoán. Tóm lược ký ức thông thường theo thời gian, giữ biến cố quan trọng chi tiết để kiểm soát dung lượng.

## 9. Vật phẩm, vật liệu và chế tác

Đặc tả đề xuất: [[VAT_PHAM|Vật phẩm, vật liệu và chế tác — 0.1]].

Tách loại vật phẩm; vật liệu và thiết kế; vật thể cụ thể với chủ sở hữu, tình trạng, lịch sử, đặc tính riêng.

Công dụng xuất phát từ đặc tính và yêu cầu công việc: dao dùng nấu ăn, thu hoạch, chiến đấu, gia công. Chất lượng gồm độ bền, sắc, tinh khiết, sai số chế tạo, dẫn linh lực, khuyết tật; không chỉ cấp màu.

Chế tác phụ thuộc công cụ, nguyên liệu, môi trường, kỹ năng và từng bước xử lý. Hàng nghìn loại vật phẩm là mục tiêu lâu dài; trước hết chứng minh các loại tạo lựa chọn thực sự khác nhau.

Đồ đồng nhất như gạo, quặng quản lý theo lô; vật quan trọng, bị biến đổi hoặc có lịch sử theo dõi riêng. Không cần danh tính cho từng hạt gạo.

## 10. Thiên nhiên và địa lý

Đặc tả đề xuất: [[MOI_TRUONG|Môi trường, địa lý, sinh thái và linh khí — 0.1]].

Vùng nối bằng tuyến di chuyển, bên trong có địa điểm. Môi trường có mùa, thời tiết, nước, đất, sinh vật và phân bố linh khí.

Tài nguyên có điều kiện hình thành, phục hồi; khai thác quá mức gây cạn kiệt, cây bị sâu bệnh, lạnh làm đứt vận chuyển. Linh địa tác động sinh thái và chịu ảnh hưởng từ sinh vật, trận pháp, khai thác.

Khoảng cách có tác dụng: hàng và tin đi mất thời gian; nơi cô lập khó được cứu viện.

## 11. Kinh tế và tổ chức

Đặc tả đề xuất: [[KINH_TE_TO_CHUC|Kinh tế và tổ chức — 0.1]].

Hàng hóa đến từ sản xuất, tồn kho, nhập khẩu. Cửa hàng có vốn và sức chứa hữu hạn. Giá phụ thuộc cung cầu địa phương, chất lượng, rủi ro vận chuyển và quan hệ.

Gia đình, thương hội, môn phái, chính quyền có thành viên, quyền hạn, tài sản, thu chi, quy tắc, nghĩa vụ, mục tiêu, quan hệ ngoài và tài nguyên hoặc kiến thức kiểm soát.

Môn phái phải duy trì người, đất, thuốc, công pháp, uy tín. Chiến tranh làm hao nhân lực có thể thay đổi chính sách tuyển đệ tử.

## 12. Chiến đấu và nguy hiểm

Đặc tả đề xuất: [[CHIEN_DAU|Chiến đấu và hậu quả xung đột — 0.1]].

Dùng chung cơ thể, vật phẩm, thời gian. Xét khoảng cách, tư thế, địa hình, tầm nhìn, mệt mỏi, tốc độ hành động và ý định đối thủ.

Đòn đánh qua tiếp cận, né hoặc đỡ, vị trí trúng, bảo vệ, rồi thương tích. Đặt trước quy tắc như ưu tiên thoát thân, giữ khoảng cách, tránh thuật hại đan điền, chạy khi chân bị thương.

Đầu hàng, thương lượng, phục kích, truy đuổi đều có vai trò; xung đột không luôn kết thúc bằng chết.

## 13. Nhiệm vụ và diễn biến thế giới

Game không có cốt truyện chính cố định. Câu chuyện được nhận ra từ lịch sử thật của người, vật, tổ chức và môi trường; ngẫu nhiên chỉ hoạt động trong các quy tắc có seed và provenance.

Nhiệm vụ sinh từ nhu cầu thật: thiếu thuốc, hộ tống lô hàng, tìm người, điều tra nước độc. Nếu vấn đề được giải quyết bằng cách khác, nhiệm vụ đổi hoặc kết thúc.

Sự kiện viết tay bổ sung văn hóa và tình huống đặc sắc nhưng phải kiểm tra điều kiện thế giới, để lại hậu quả.

Không bắt buộc AI sinh văn bản để vận hành NPC. Quyết định và trạng thái cần quy tắc kiểm tra được. Nếu thêm AI ngôn ngữ, ưu tiên diễn đạt hội thoại dựa trên dữ kiện đã xác lập.

## 14. Giao diện text

Luồng giao việc, đọc thông tin, tự dừng và lưu tải: [[GIAO_DIEN|Giao diện text và luồng chơi — 0.1]].

Yêu cầu đã xác nhận: cùng trò chơi phải dùng được trên điện thoại và máy tính. Màn hình hẹp chuyển sang một cột/trang con; màn hình rộng có thể đặt nhiều vùng cạnh nhau. Cả hai phải truy cập cùng chức năng và thông tin, không giấu thao tác thiết yếu sau rê chuột, nhấp phải hoặc kéo thả chính xác.

Các khu vực: tình trạng và việc đang làm; mục tiêu, lịch, quy tắc; địa điểm, người, vật xung quanh; nhật ký có bộ lọc; kiểm tra chi tiết cơ thể, vật phẩm, quan hệ.

Mặc định ngắn gọn, cho mở sâu. Ví dụ:

> Ngày 18, đầu hạ — sân sau y quán. Đang sắc thuốc, còn 40 phút. Bàn tay trái: vết cắt đang lành, đau nhẹ khi cầm nắm. Mục tiêu chữa thương đang tiến triển. Tiền đủ khoảng 8 ngày. Giá thanh diệp tăng vì chuyến hàng đến muộn.

Giao diện trả lời: đang xảy ra gì, vì sao, có thể làm gì.

## 15. Kiến trúc và hiệu năng

Rà soát trách nhiệm dữ liệu, thứ tự cập nhật và các điểm giao nhau: [[LIEN_KET_HE_THONG]]. Đây là bổ sung đề xuất, chưa là kiến trúc mã nguồn đã triển khai.

Đề xuất chạy cục bộ với giao diện trình duyệt bằng chữ, bảng, nút; công nghệ chưa chốt. Việc hỗ trợ điện thoại và máy tính là yêu cầu, nhưng chưa quyết định ứng dụng web, gói cài riêng hay cách khác.

Tách đồng hồ và hàng đợi sự kiện, trạng thái thế giới, hệ cơ thể/hành động/xã hội/tu luyện, dữ liệu nội dung, lưu tải và giao diện. Dữ liệu công pháp, vật phẩm, sinh vật có cấu trúc để mở rộng không sửa lõi liên tục.

Mô phỏng nhiều mức: người và sự kiện liên quan trực tiếp được tính chi tiết; vùng xa tính theo khoảng lớn và kết quả tổng hợp; khi liên quan khôi phục mức chi tiết phù hợp. Giản lược vẫn phải giữ nhất quán danh tính, tài sản, thương tích và cam kết. [[DOI_SONG_TU_SINH_K1]] đề xuất R0–R4 nhưng vẫn giữ từng Person ở mức xa; không dùng tổng dân số thay cho NPC đã tồn tại. Ghi rõ phần chính xác và phần xấp xỉ.

Lưu trạng thái định kỳ, lịch sử sự kiện quan trọng; dùng hạt giống ngẫu nhiên hỗ trợ tái hiện lỗi.

Đặt ngân sách hiệu năng riêng cho điện thoại và máy tính: tốc độ mô phỏng, độ trễ thao tác, bộ nhớ, dung lượng bản lưu, pin và khả năng khôi phục sau khi hệ điều hành tạm treo ứng dụng. Một định dạng thế giới/bản lưu phải có quy tắc phiên bản chung; đồng bộ tự động giữa thiết bị là câu hỏi riêng, không suy ra từ yêu cầu đa nền tảng.

## 16. Phạm vi bản đầu đề xuất

Kịch bản tích hợp và điều kiện đánh giá: [[BAN_CHOI_THU]]. Các con số phạm vi bên dưới vẫn chưa được người dùng chốt.

- Một làng, một vùng hoang dã, một cơ sở tu luyện nhỏ.
- Khoảng 20–30 NPC có danh tính.
- Cơ thể người và thương tích thiết yếu; ăn, ngủ, lao động, đi lại, điều trị.
- Một số chuỗi sản xuất liên kết, 30–50 loại vật phẩm sử dụng được.
- Ba công pháp có cơ chế khác nhau; một giai đoạn tu luyện và một lần đột phá.
- Giao việc, đặt mục tiêu, tự dừng, lưu tải.

Chuỗi chơi: kiếm sống → có quan hệ → tìm cách tu luyện → thu thập tài nguyên → gặp rủi ro → chữa trị hoặc đổi kế hoạch → tiến bộ. Cả NPC và nhân vật người chơi phải có thể trải qua chuỗi này mà không cần điều khiển từng bước.

Đây chưa phải phạm vi được người dùng chốt và không thay thế tham vọng dài hạn.

## 17. Thứ tự triển khai đề xuất

| Chặng | Kết quả |
| --- | --- |
| 1. Đặc tả nền | Thời gian, quy luật thế giới, hành động và dữ liệu |
| 2. Mô phỏng tối thiểu | Ăn, ngủ, làm, di chuyển; thời gian và lưu tải |
| 3. Cơ thể và sinh tồn | Thương tích ảnh hưởng đúng đến công việc và hồi phục |
| 4. Đời sống NPC | Lịch, mục tiêu, quan hệ và trao đổi tài nguyên |
| 5. Tu luyện | Công pháp, linh lực, luyện tập, đột phá gắn với cơ thể |
| 6. Bản chơi thử | Giao diện, hướng dẫn, giải thích hành vi và chuỗi trải nghiệm đầy đủ |
| 7. Mở rộng | Sinh thái, tổ chức, kinh tế vùng, chiến đấu sâu, nhiều nội dung |

Mỗi chặng triển khai phải quan sát hoặc chơi được, không chỉ có dữ liệu và công thức. K5.1 đã bắt đầu bằng prototype lõi V0; phần lớn hệ thống vẫn ở mức kế hoạch.

## 18. Tiêu chí đánh giá

- Lưu tải không đổi kết quả mô phỏng.
- Tiền và vật không tự sinh hoặc mất ngoài quy tắc.
- NPC không dùng kiến thức chưa có.
- Thương tích tạo hậu quả nhất quán.
- Công việc kẹt có nguyên nhân hiển thị.
- Cộng đồng duy trì sinh hoạt trong điều kiện bình thường.
- Chạy nhiều năm không làm thời gian xử lý và dung lượng tăng mất kiểm soát.
- Công pháp tạo lựa chọn khác nhau, tránh một lựa chọn luôn tốt nhất.
- Người chơi hiểu nguyên nhân chính dẫn đến thất bại.

Kịch bản kiểm chứng: mất mùa, thiếu thuốc, người thợ duy nhất chết, tuyến buôn bán bị chặn, nhân vật trọng thương, đột phá thất bại. Ngưỡng hiệu năng cụ thể cần xác định sau.

## 19. Giả định tạm thời và bước tiếp

Chơi đơn, cục bộ; 5 giây/ngày và cho tạm dừng; bắt đầu là người thường; biết theo nhận thức nhân vật; thế giới tự vận hành; cái chết có hậu quả, kế thừa thiết kế sau; chưa chạy khi đóng game; làm sâu vùng nhỏ trước. Trừ tốc độ và tầm nhìn người dùng nêu, đây là các đề xuất chưa chốt.

K3 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1–K4.8 đã định nền hiện tượng, cơ thể, vật phẩm, linh sinh quyển, tu luyện, NPC, xã hội và chiến đấu; K4.9 tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]] đã đóng gói 8 tài liệu K4/8.296 dòng/756 điều kiện và lập 12 vertical slice. Toàn bộ 1.860 điều kiện thiết kế thuộc 41 họ vẫn chưa được chạy theo catalog gốc và chưa có quyết định stack. [[K5_1_PROTOTYPE_LOI_V0]] đã thêm catalog 14 điều kiện riêng cho lõi và shell, không hồi tố trạng thái các điều kiện cũ.

Phần chức năng V0 của K5.1 đã có time/event/command/query/save, shell Flutter responsive, persistence UI, autosave/restore lifecycle và web release. K5.2 đã cho Dart và PWA chạy cùng shared fixture/expected hash; ADR PROPOSED dùng S2 làm working stack, chưa ACCEPTED. [[K5_3_V1_THANG_DAU_SO_SINH]] đã triển khai V1 ngày 0–30 với nhu cầu, giác quan và ý định theo tuổi. [[K5_4_V1_1_CHUOI_CHAM_SOC_NHAN_QUA]] đã nối tiếng khóc qua nhận thức NPC, ngắt việc, di chuyển và vật phẩm thật. [[K5_5_V1_2_CO_THE_SINH_LY_SO_SINH]] đã thêm sinh lý theo giờ, bú–nuốt, dạ dày, ngủ, nhiệt, bài tiết và tăng trưởng để đóng V1 tối thiểu. [[K5_6_V2_0_HO_GIA_DINH_TAI_NGUYEN_QUYEN_LICH]] đã thêm hộ bốn người, kho hữu hạn, quyền vận hành, bữa ăn nguyên tử và sổ chăm sóc–lao động 30 ngày. Theo ưu tiên GUI của người dùng, [[K5_7_GUI_TEXT_GAME_DA_NEN_TANG]] đã tổ chức toàn bộ chức năng thật thành năm khu vực thích nghi cho điện thoại/máy tính. [[K5_8_V2_1_BENH_NHE_TIEP_TE_KHONG_GIAN_DOI_LICH]] đã thêm phòng trong nhà, bệnh nhẹ có diễn tiến, chăm sóc dùng vật chất/quyền, đổi lịch NPC, sản xuất và tiếp tế. [[K5_9_V2_2_VAN_CHUYEN_BENH_SINH_LY_NGUOI_THAY]] đã vật chất hóa chuyến tiếp tế có người chở và giờ đến thật, nối bệnh vào sinh lý theo giờ, cùng cơ chế người chăm sóc thay thế. [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]] đã thêm nhịp sống hằng ngày cho NPC, xung đột lịch có hậu quả thật lên bữa ăn và giờ công, cùng hồ sơ mở cho mọi người và mọi vật kể cả ngoài hộ. Bước kế tiếp đề xuất là cho NPC tự sinh khối việc từ nhu cầu thay vì bảng giờ cứng và mở tuyến vận tải thật; shared fixture V1 còn chờ parity PWA.

