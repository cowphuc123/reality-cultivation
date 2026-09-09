# Trạng thái hiện tại

Cập nhật: 2026-09-10.

> Trợ lý mới tiếp nhận dự án: đọc [[CHUYEN_GIAO]] trước tiên.

## Giai đoạn

Kế hoạch nền đã hoàn thành. Dự án đang triển khai theo vertical slice có thể chạy, bắt đầu từ V0 và tuổi sơ sinh. Mọi hệ số prototype vẫn tách khỏi quyết định đã xác nhận (xem bảng U trong [[DECISIONS]]).

Luồng mở đầu đã xác nhận: tạo thế giới, mô phỏng tiền sử hàng trăm–hàng vạn năm không có nhân vật chính, người chơi chọn nơi trên bản đồ, sinh ra và điều khiển ngay từ lúc sơ sinh. Game không có cốt truyện chính cố định; xem [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]].

## Đã hoàn thành

Lịch sử đầy đủ từng lượt việc nằm trong [[CHANGELOG]]. Tóm tắt hiện trạng:

**Kế hoạch (K0–K4):** 9 đặc tả nền 0.1, 6 gói dữ liệu thử DL01–DL06, K0 (fixture/K0.1–K0.6), K1 (đời sống An Khê/K1.1–K1.12), K2 (hợp đồng máy/K2.1–K2.8), K3 (kiến trúc triển khai/K3.1–K3.7), K4 (mô phỏng sâu/K4.1–K4.9) — tổng **1.860 điều kiện thiết kế thuộc 41 họ**, tất cả vẫn ở trạng thái **chưa chạy bằng mô phỏng thật** (chỉ đúng "trên giấy"). Xem [[MASTER_PLAN]] để tra theo chủ đề.

**Mã chạy được (K5, gói riêng khỏi 1.860 điều kiện trên):**

| Bản | Nội dung | Runner / hash |
| --- | --- | --- |
| V0 | Đồng hồ, hàng đợi sự kiện, save/replay | [[K5_1_PROTOTYPE_LOI_V0]] · `5629ba88282991c6` |
| V1 | Sơ sinh 0–30 ngày, nhu cầu/giác quan/ý định theo tuổi | [[K5_3_V1_THANG_DAU_SO_SINH]] |
| V1.1 | Chuỗi chăm sóc nhân quả (khóc → nghe → tới → dùng vật) | [[K5_4_V1_1_CHUOI_CHAM_SOC_NHAN_QUA]] · `69988c4593598846` |
| V1.2 | Sinh lý sơ sinh theo giờ (khối lượng, dạ dày, ngủ, nhiệt) | [[K5_5_V1_2_CO_THE_SINH_LY_SO_SINH]] · `5d418dc95af7118d` |
| V2.0 | Hộ gia đình, kho hữu hạn, quyền dùng, bữa ăn | [[K5_6_V2_0_HO_GIA_DINH_TAI_NGUYEN_QUYEN_LICH]] · `985a29eb4aaa240b` |
| GUI | 5 khu vực thích nghi điện thoại/máy tính | [[K5_7_GUI_TEXT_GAME_DA_NEN_TANG]] |
| V2.1 | Phòng, bệnh nhẹ, sản xuất, tiếp tế định kỳ | [[K5_8_V2_1_BENH_NHE_TIEP_TE_KHONG_GIAN_DOI_LICH]] · `3d83fc8e0cc7b77f` |
| V2.2 | Vận chuyển có trễ, bệnh nối sinh lý, người thay | [[K5_9_V2_2_VAN_CHUYEN_BENH_SINH_LY_NGUOI_THAY]] · `d0b87de633a4765a` |
| V2.3 | Nhịp sống NPC, xung đột lịch, hồ sơ toàn thế giới | [[K5_10_V2_3_NHIP_SONG_NPC_VA_HO_SO_THE_GIOI]] · `ade0b8a4300276c9` |
| V2.4 | Nhu cầu hộ sinh việc, ưu tiên phân xử, sản lượng theo giờ làm | [[K5_11_V2_4_NHU_CAU_SINH_VIEC_VA_UU_TIEN]] · `5b36f570a39e4bde` |
| V2.5 | Kỹ năng nghề chọn người, quyền từ chối việc, xếp lại lịch | [[K5_12_V2_5_KY_NANG_NGHE_VA_QUYEN_TU_CHOI]] · `29bf49642c71fb18` |
| V2.6 | Tay nghề lên tay, đói và tâm trạng vào quyết định nhận việc | [[K5_13_V2_6_LEN_TAY_NGHE_DOI_VA_TAM_TRANG]] · `b9f0b0d8269b8653` |
| V2.7 | Cơ thể người lớn: bữa ăn nuôi thật, đói thì sụt cân và yếu đi | [[K5_14_V2_7_CO_THE_NGUOI_LON]] · `dc54cde35203486a` |
| V2.8 | Nước và cơn khát: uống từ kho hộ, thiếu nước thì kiệt sức nhanh | [[K5_15_V2_8_NUOC_VA_CON_KHAT]] · `469fab7582a4aa34` |
| V2.9 | Tuyến vận tải thật: điểm mốc, địa hình, trễ giờ là hệ quả | [[K5_16_V2_9_TUYEN_VAN_TAI_THAT]] · `a4830eb8844ec469` |
| V2.10 | Vị trí hai chiều và tuyến có ngã rẽ; sức lực đổi cả đường đi | [[K5_17_V2_10_HAI_CHIEU_VA_NGA_RE]] · `2a87b934f03e0f29` |
| V2.11 | Bệnh của người lớn, khởi phát từ mất nước hoặc kiệt sức | [[K5_18_V2_11_BENH_CUA_NGUOI_LON]] · `beabb8f20438f377` |
| V2.12 | Người ốm được nghỉ thật, tới khi khỏi hẳn | [[K5_19_V2_12_NGHI_BENH]] · `f57b6f0fb06205bb` |
| V2.13 | Chuyển ca cố định của người nghỉ bệnh cho người đủ điều kiện | [[K5_20_V2_13_GANH_VIEC_KHI_NGHI_BENH]] · `edf67b2b36cda0eb` |
| V2.14 | Vùng, địa điểm và quy người/phòng/vật theo tọa độ hai chiều | [[K5_21_V2_14_BAN_DO_VUNG_DAU_TIEN]] · `1d70b51a89d4b142` |
| V2.15 | Seed sinh kích thước vùng, tọa độ và bán kính địa điểm; lưu provenance | [[K5_22_V2_15_SINH_BAN_DO_TU_SEED]] · `5595e41dd7f499bc` |
| V2.16 | Thế giới/NPC có trước; chọn nơi đủ điều kiện rồi P00 mới sinh | [[K5_23_V2_16_CHON_NOI_SINH_SAU_KHI_TAO_THE_GIOI]] · `de0313eb51f483ba` |

Hiện có **21/21 runner**, **18/18 widget test** và **419 điều kiện catalog chạy được**; đây là bộ kiểm chứng triển khai riêng, không cộng vào 1.860 điều kiện thiết kế chưa chạy.

Web đang chạy: **https://cowphuc123.github.io/reality-cultivation/** — tự động build lại mỗi lần đẩy `client/` lên GitHub (`.github/workflows/deploy-web.yml`). Bản cũ trên Sites (`chatgpt.site`) vẫn còn, chưa gỡ.

**Cách làm từ 2026-09-09:** sau khi hoàn tất trọn một lát cắt, chạy kiểm tra, cập nhật hồ sơ Obsidian, rồi tự commit và push. Không đẩy trạng thái đang dở hoặc đang lỗi. GitHub Actions tự build web khi `client/` thay đổi.
Mở tại máy: `MO_GAME.bat` ở gốc dự án; hướng dẫn tại [[HUONG_DAN_MO_BAN_TEST]].
Làm tiếp từ điện thoại: ưu tiên Remote vào chính PC; xem [[HUONG_DAN_LAM_TIEP_TREN_DIEN_THOAI]].

## Chưa thực hiện

- Chưa chọn công nghệ cuối cùng. S2 Dart/Flutter là working stack PROPOSED (ADR chưa ACCEPTED); S1/S3, full workload, APK/EXE chưa chạy.
- Chưa chốt phạm vi bản đầu, quy tắc tạm dừng, mô phỏng khi đóng game hoặc hệ cảnh giới.
- Chưa có: giải phẫu đa bộ phận, thương tích, già đi, chết; diễn biến cơ thể trong ngày (cơ thể người lớn chạy theo ngày); nước bẩn và bệnh do nước; khẩu phần riêng từng người; quan hệ giữa người với người; hậu quả xã hội của việc từ chối; mục tiêu cá nhân dài hạn; lây bệnh và thuốc; chuỗi game sau tháng đầu.
- Nghỉ bệnh vẫn là **tất cả hoặc không có gì**: chưa có làm nhẹ hay nửa buổi. Ca nay có thể chuyển nguyên khối cho một người khác, nhưng chưa chia ca, đổi công hay tạo nghĩa vụ bù; xem [[K5_20_V2_13_GANH_VIEC_KHI_NGHI_BENH]].
- Seed đã sinh được kích thước một vùng cùng tọa độ/bán kính năm địa điểm; người/phòng/vật và tuyến client bám kết quả đó. Tên, loại và số lượng địa điểm vẫn là template An Khê: chưa có ô đất, độ cao, khí hậu, tài nguyên, biên giới, sinh dân số hay lịch sử tiền game. Đồ thị đường đi chưa sinh từ địa hình.
- Đã tách thế giới khỏi P00 và có màn chọn nơi sinh thật, nhưng mới chỉ `SITE-HOME` đủ điều kiện trong một hộ fixture. Chưa có nhiều hoàn cảnh sinh, phả hệ hoặc epoch tiền sử; thanh tiến độ hiện là bản tổng kết các bước đồng bộ đã hoàn tất.
- Thân nhiệt người lớn **cố ý chưa làm**: chưa có mùa, thời tiết hay nhiệt độ môi trường để nó phản ứng lại; xem [[K5_15_V2_8_NUOC_VA_CON_KHAT]].
- Kho git đã có commit đầu và đẩy lên `github.com/cowphuc123/reality-cultivation` (công khai); chưa thiết lập sao lưu tự động ngoài GitHub.

## Bước tiếp theo đề xuất

Ưu tiên V2.17 thêm epoch tiền sử tối thiểu trước lúc nhập thế: số năm do seed quyết định, mô phỏng không có P00, lưu các mốc lịch sử và chỉ mở chọn nơi sinh sau khi epoch cuối hoàn tất. Sau đó tăng số hộ và hoàn cảnh sinh khả thi. Nhánh gần khác là làm việc nhẹ/nửa buổi khi hồi bệnh. Thân nhiệt nên chờ có khí hậu/mùa.

Shared fixture V1 chưa chạy parity PWA. TN01–TN08 ([[LUA_CHON_TRAI_NGHIEM]]) và ADR công nghệ ACCEPTED vẫn mở.

Khi người dùng yêu cầu tiếp tục: đọc [[DECISIONS]], [[MASTER_PLAN]] và mục K5 mới nhất trong [[CHANGELOG]] trước; dựa trên mã và kết quả chạy thật, không suy từ kế hoạch cũ.

## Điều cần giữ nguyên trong bối cảnh

Người dùng muốn chiều sâu rất lớn, tham vọng vượt Dwarf Fortress và CDDA. Phạm vi bản đầu nhỏ chỉ là đề xuất của trợ lý để kiểm chứng nền tảng, chưa được người dùng xác nhận.
