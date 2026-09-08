---
title: "Khởi tạo thế giới, lịch sử tiền game và nhập thế của người chơi"
aliases:
  - "Lịch sử thế giới trước người chơi"
  - "Worldgen và nhập thế"
tags: [reality-cultivation, yeu-cau, worldgen, lich-su]
status: da-xac-nhan-mot-phan
updated: 2026-09-06
---

# Khởi tạo thế giới, lịch sử tiền game và nhập thế của người chơi

> [!summary]
> Người dùng đã xác nhận thế giới phải được tạo và mô phỏng lịch sử hàng trăm, hàng nghìn hoặc hàng vạn năm trước khi nhân vật người chơi tồn tại. Game không có cốt truyện chính cố định. Các quy tắc triển khai chi tiết dưới đây vẫn là đề xuất.

## 1. Trải nghiệm đã xác nhận

1. Người chơi yêu cầu tạo một thế giới mới.
2. Game sinh nền địa lý, sinh thái, linh khí, dân cư và văn hóa.
3. Game mô phỏng một thời kỳ dài không có nhân vật chính.
4. Tông môn, gia tộc, thành thị, chiến tranh, công pháp và di tích hình thành hoặc biến mất theo lịch sử.
5. Khi lịch sử tới hiện tại, người chơi xem bản đồ và chọn nơi nhập thế.
6. Nhân vật người chơi được sinh ra/đưa vào thế giới tại đó rồi mới bắt đầu hành trình.

Thế giới không được sửa quá khứ để tạo thuận lợi cho nhân vật vừa sinh.

## 2. Không dùng cốt truyện chính cố định

Không có tuyến bắt buộc “được chọn”, ma vương phải xuất hiện vào năm X hoặc tông môn nhất định luôn thắng. Nội dung viết tay cung cấp:

- quy luật vật chất và tu luyện;
- loại hình văn hóa, tổ chức và công pháp;
- mục tiêu, nghi lễ, luật và tập quán có thể sinh;
- mẫu biến cố có điều kiện;
- cách diễn đạt lịch sử.

Outcome do trạng thái, quyết định và tương tác quyết định.

## 3. Không phải ngẫu nhiên thuần túy

RNG chỉ giải bất định trong phạm vi hợp lệ. Mỗi kết quả phải có:

- hạt giống và stream;
- điều kiện đầu vào;
- rule/handler version;
- tài nguyên và tác nhân tham gia;
- outcome và hậu quả;
- provenance đủ để tái hiện.

Cùng seed, cấu hình và phiên bản phải tạo cùng snapshot.

## 4. WorldGenesis

```text
WorldConfig + root_seed + content_fingerprint
→ cosmology/geology
→ climate/water/soil/ecology/qi
→ populations/cultures/languages
→ settlements/organizations/economies
→ techniques/inventions/transmissions
→ historical epochs
→ recent detailed window
→ playable present snapshot
```

Mỗi bước chỉ publish khi invariant đạt.

## 5. Tuổi thế giới

Người chơi có thể chọn hoặc để game sinh:

- **Cổ sơ:** vài trăm năm lịch sử văn minh;
- **Cổ đại:** vài nghìn năm;
- **Thái cổ:** vài vạn năm.

Độ dài này là lịch sử từ mốc phù hợp của thế giới, không bắt buộc toàn bộ là lịch sử loài người. Tên và khoảng chính thức chưa chốt.

## 6. Mô phỏng theo thời đại

Không xử từng giây của mười nghìn năm. Các epoch xa dùng độ phân giải lớn:

| Giai đoạn | Độ phân giải đề xuất | Dữ liệu giữ |
|---|---|---|
| địa chất/sinh thái xa | năm–thiên niên kỷ | field, strata, climate, species flows |
| văn minh sơ kỳ | mùa–năm | population, settlement, resource, culture |
| lịch sử tổ chức | tháng–năm | lineage, institution, trade, conflict |
| thời kỳ gần | ngày–tháng | Person quan trọng, asset, claim, event |
| trước nhập thế | giờ–ngày khi cần | trạng thái chơi hiện tại đầy đủ |

Mọi tầng phải cắt tại biến cố neo và bảo toàn đại lượng đã cam kết.

## 7. Lịch sử xa

Lịch sử xa có thể gộp sản xuất thường nhật, sinh tử phổ thông và biến động nhỏ. Nó vẫn phải giữ:

- dân số và dòng di cư;
- cân bằng vật chất/tài nguyên;
- huyết thống hoặc dòng truyền thừa còn liên quan;
- thành lập, phân nhánh và tan rã tổ chức;
- phát minh, cải biên, thất truyền công pháp;
- địa hình/linh mạch bị thay đổi;
- chiến tranh, dịch, thiên tai và hiệp ước lớn.

Không tuyên bố mỗi cá thể trong mười nghìn năm đã được mô phỏng ở mức từng phút.

## 8. Biến cố neo

AnchorEvent không được compact mất nếu nó giải thích hiện tại: nguồn gốc di tích, chủ quyền, thù hận, dòng họ, bí pháp, vật độc nhất, vùng ô nhiễm hoặc tuyệt chủng.

Tóm lược lịch sử phải dẫn về các anchor liên quan.

## 9. Công pháp qua lịch sử

Công pháp có thể được phát minh, truyền dạy, chép sai, phân nhánh, độc quyền, cải biên hoặc thất truyền. Bản hiện tại của một tông môn phải có lineage từ lịch sử.

Không đặt kho bí kíp ngẫu nhiên sau khi biết người chơi cần gì.

## 10. Di tích

Di tích là phần còn lại vật chất của settlement, organization, trận pháp, chiến tranh hoặc thảm họa thật. Nó có tuổi, vật liệu, decay, đồ còn lại và quyền/niềm tin quanh nó.

Không sinh dungeon như phòng độc lập với địa lý và lịch sử.

## 11. Văn minh và tổ chức

Tông môn, gia tộc và quốc gia có thể chưa xuất hiện, đang thịnh, suy tàn, chia rẽ hoặc đã mất khi game bắt đầu. Không tổ chức nào được bảo đảm tồn tại ở mọi seed.

World validator chỉ yêu cầu snapshot còn đủ con đường sống/chơi theo cấu hình đã chọn.

## 12. Nhân vật lịch sử

Person quan trọng được materialize khi cần cho lineage, invention, quyền hoặc anchor. Người thường ở epoch xa có thể tồn tại qua cohort/household ledger.

Person đã materialize giữ identity; không được gộp thành người vô danh rồi tái sinh khác.

## 13. Câu chuyện phát sinh

Story View nhóm các event đã xảy ra thành niên biểu, truyền thuyết và hồ sơ. Truyền thuyết trong thế giới có thể sai vì đi qua ký ức/văn hóa; debug history vẫn giữ provenance thật.

Bật hay tắt phần kể chuyện không đổi lịch sử.

## 14. Tạo hiện tại có thể chơi

Sau tiền sử, hệ thống kiểm:

- vùng sống được và tuyến kết nối;
- nguồn nước/thức ăn và kinh tế cơ bản;
- dân cư/tổ chức còn nhất quán;
- quyền, nợ, kho và shipment cân;
- lịch sử công pháp hợp lệ;
- không có process dang dở vượt snapshot;
- save/fingerprint hoàn chỉnh.

Nếu không đạt, generator sửa trong staging theo constraint; không âm thầm sửa snapshot đã công bố.

## 15. Bản đồ chọn nơi nhập thế

Bản đồ hiển thị theo mức thông tin khởi đầu được phép:

- khí hậu và địa hình tổng quát;
- dân cư/văn hóa/ngôn ngữ;
- mức nguy hiểm được biết;
- tổ chức và cơ hội tu luyện công khai;
- độ khan hiếm tài nguyên ước lượng;
- tuổi và nét lịch sử vùng.

Không lộ kho bí mật, công pháp thất truyền hoặc số liệu canonical ẩn.

## 16. Điểm nhập thế

Người chơi chọn region/settlement hoặc vùng hoang hợp lệ. Hệ thống chỉ đưa ra nơi có Birth/Entry feasibility theo world state.

Vị trí được chọn không được làm tăng tài nguyên hoặc viết lại tổ chức quanh đó.

## 17. Sinh nhân vật

Nhân vật người chơi được tạo sau snapshot lịch sử và nhận:

- birth/entry time và place;
- cơ thể/lineage hợp lệ;
- household hoặc hoàn cảnh xuất thân;
- ngôn ngữ/văn hóa;
- quyền, vật và nghĩa vụ ban đầu;
- kiến thức chỉ từ nguồn xuất thân;
- quan hệ có đường lịch sử;
- world seed không bị đổi.

Người chơi điều khiển ngay từ lúc sơ sinh; không dùng giai đoạn trưởng thành rút gọn. Command/Goal khả dụng phải theo giác quan, vận động, ngôn ngữ, nhận thức, cơ thể và người chăm sóc thực tế của từng tuổi. Ở giai đoạn đầu, lựa chọn có thể là chú ý, khóc, ngủ, cố với, bám, bắt chước hoặc hình thành sự gắn bó; không cho trẻ sơ sinh dùng ý định và kiến thức của người lớn.

## 18. Không có nhân vật chính trước khi nhập thế

Tiền sử không giữ chỗ lời tiên tri, huyết mạch, bảo vật hoặc kẻ thù dành riêng cho người chơi. Sau khi sinh, nhân vật là một Person dùng cùng quy tắc với NPC.

Sự chú ý của giao diện không trao bảo hộ cốt truyện.

## 19. Thất bại và cái chết

Nhân vật có thể chết mà thế giới tiếp tục. Cơ chế chọn hậu duệ, nhập vai người khác hoặc kết thúc bản lưu chưa chốt.

Lịch sử của nhân vật sau khi chết trở thành một phần lịch sử chung nếu có hậu quả.

## 20. Hiệu năng

Mục tiêu hàng vạn năm đòi hỏi:

- epoch handlers theo miền;
- cohort cho người chưa cá thể hóa;
- Person identity bền sau materialization;
- sparse anchors;
- interval resolution và boundary flow;
- compaction có kiểm chứng;
- snapshot phân vùng;
- tiến trình tạo có thể tạm dừng/tiếp tục;
- dự báo thời gian và dung lượng trước khi chạy.

“Hàng vạn năm” không đồng nghĩa lưu từng hành động của mọi sinh vật.

## 21. Màn hình tạo thế giới

Luồng đề xuất:

1. chọn seed hoặc ngẫu nhiên;
2. chọn kích thước, tuổi và mức chi tiết;
3. xem ước lượng thời gian/dung lượng;
4. chạy từng giai đoạn với tiến độ;
5. xem tóm tắt lịch sử và bản đồ;
6. đổi seed/tạo lại nếu muốn;
7. chọn nơi nhập thế;
8. tạo nhân vật trong world snapshot;
9. bắt đầu đồng hồ 5 giây/ngày.

Việc tạo lại tạo world lineage mới, không ghi đè bản đã chơi nếu chưa xác nhận.

## 22. Điện thoại và máy tính

Cùng seed/config/version phải tạo cùng world hash. Điện thoại có preset nhỏ/chạy lâu hơn; máy tính có thể tạo rộng hơn. Thiết bị không được đổi quy luật hay kết quả trong cùng cấu hình được hỗ trợ.

Có thể tạo trên máy tính rồi chuyển portable save sang điện thoại.

## 23. Điều đã xác nhận và điều còn mở

Đã xác nhận:

- không có cốt truyện chính cố định;
- thế giới được tạo trước nhân vật người chơi;
- lịch sử tiền game có thể dài hàng trăm, hàng nghìn hoặc hàng vạn năm;
- không có nhân vật chính trong giai đoạn đó;
- người chơi chọn vị trí trên bản đồ rồi mới sinh/nhập thế.
- người chơi điều khiển ngay từ lúc sơ sinh; tuổi thơ không bị bỏ qua.

Còn mở:

- tuổi thế giới mặc định;
- độ lớn bản đồ và thời gian tạo cho từng thiết bị;
- được chọn gia đình/xuất thân sâu tới đâu;
- có cho xem toàn bộ lịch sử thật hay chỉ lịch sử được thế giới biết;
- điều kiện từ chối một seed không còn nơi sống được;
- cơ chế tiếp tục sau khi nhân vật chết.

## 24. Quan hệ với kế hoạch

Kiến trúc seed, epoch, anchor và vùng LATENT/SUMMARIZED nằm tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. Vòng đời/phân tầng nằm tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]], NPC tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]], kinh tế–thể chế tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]].

K4.9 phải đưa worldgen–prehistory–entry thành một vertical slice và đặt ngân sách tạo thế giới riêng cho điện thoại/máy tính.
