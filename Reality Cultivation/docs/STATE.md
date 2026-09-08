# Trạng thái hiện tại

Cập nhật: 2026-09-08.

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
| V2.5 | Kỹ năng nghề chọn người, quyền từ chối việc, xếp lại lịch | [[K5_12_V2_5_KY_NANG_NGHE_VA_QUYEN_TU_CHOI]] · `9d3521d32a5b66b6` |

Web đang chạy: **https://cowphuc123.github.io/reality-cultivation/** — tự động build lại mỗi lần đẩy `client/` lên GitHub (`.github/workflows/deploy-web.yml`). Bản cũ trên Sites (`chatgpt.site`) vẫn còn, chưa gỡ.
Mở tại máy: `MO_GAME.bat` ở gốc dự án; hướng dẫn tại [[HUONG_DAN_MO_BAN_TEST]].

## Chưa thực hiện

- Chưa chọn công nghệ cuối cùng. S2 Dart/Flutter là working stack PROPOSED (ADR chưa ACCEPTED); S1/S3, full workload, APK/EXE chưa chạy.
- Chưa chốt phạm vi bản đầu, quy tắc tạm dừng, mô phỏng khi đóng game hoặc hệ cảnh giới.
- Chưa có: giải phẫu đa bộ phận, tay nghề tăng theo số giờ đã làm, đói/tâm trạng/quan hệ trong quyết định nhận việc, hậu quả xã hội của việc từ chối, mục tiêu cá nhân dài hạn, lây nhiễm/thuốc, tuyến vận tải theo địa hình, chuỗi game sau tháng đầu.
- Kho git đã có commit đầu và đẩy lên `github.com/cowphuc123/reality-cultivation` (công khai); chưa thiết lập sao lưu tự động ngoài GitHub.

## Bước tiếp theo đề xuất

Cho tay nghề tăng theo số giờ đã làm, thêm đói và tâm trạng vào quyết định nhận việc, rồi mở tuyến vận tải thật có vị trí trung gian.

Shared fixture V1 chưa chạy parity PWA. TN01–TN08 ([[LUA_CHON_TRAI_NGHIEM]]) và ADR công nghệ ACCEPTED vẫn mở.

Khi người dùng yêu cầu tiếp tục: đọc [[DECISIONS]], [[MASTER_PLAN]] và mục K5 mới nhất trong [[CHANGELOG]] trước; dựa trên mã và kết quả chạy thật, không suy từ kế hoạch cũ.

## Điều cần giữ nguyên trong bối cảnh

Người dùng muốn chiều sâu rất lớn, tham vọng vượt Dwarf Fortress và CDDA. Phạm vi bản đầu nhỏ chỉ là đề xuất của trợ lý để kiểm chứng nền tảng, chưa được người dùng xác nhận.
