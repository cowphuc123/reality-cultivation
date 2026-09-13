---
title: K5.29 — V3 làng nhỏ tự vận hành 30 ngày
aliases:
  - V3 làng nhỏ
  - V3 village 30 days
tags:
  - k5
  - v3
  - phat-hanh
---

# K5.29 — V3 làng nhỏ tự vận hành 30 ngày

Ngày hoàn tất: 2026-09-13.

## Kết quả

V3 đã đóng đủ bảy cổng trong [[LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC]]. Seed phát hành `20260907` tạo 50 NPC chi tiết thuộc 12 hộ. Mỗi người có cơ thể, nghề, kỹ năng, lịch và trạng thái cá nhân; các hộ có kho, nguồn sống và chuyên môn khác nhau.

Trong chu kỳ 30 ngày, hộ tự nhận ra thiếu hụt, dùng tri thức và quan hệ riêng để hỏi nguồn, nhận giới thiệu, thương lượng và đổi hàng. Hàng rời kho, nằm trong chuyến vận chuyển rồi mới nhập kho. Người tham gia bị giữ thời gian thật, có thể mất sản lượng và tích mệt. Người ngoài chỉ biết sự việc sau quan sát hoặc lời kể có nguồn.

Runner để thêm hai ngày lắng sau chu kỳ kiểm toán. Kết quả cuối:

- 50 NPC, 12 hộ;
- 291 cuộc đổi hàng liên hộ hoàn tất;
- 2.333 bằng chứng nằm trong trí nhớ cá nhân;
- 172 quan hệ có hướng giữa người thuộc các hộ khác nhau;
- 207 yêu cầu tài nguyên có vòng đời;
- 30/30 ảnh chụp sức sống cộng đồng;
- 0 ngày cần cứu hộ vô căn cứ;
- không vật phẩm âm, chuyến hàng, yêu cầu hoặc cam kết thời gian bị mắc kẹt ở ngày 32.

## Tính xác định

Ba đường chạy cùng seed đã được so sánh: chạy liên tục, lưu/tải ở ngày 15 rồi chạy tiếp, và replay mới từ đầu. Cả ba kết thúc với semantic hash:

`8b27413973a433d7`

Trong lúc kiểm chứng đã sửa một lỗi phá tính xác định: khi nhiều bằng chứng có cùng điểm, việc chọn câu trả lời từng phụ thuộc thứ tự chèn của `Map`, vốn thay đổi sau save/load. Bộ so sánh nay phá hòa bằng đầy đủ mã người hỏi, người trung gian, hộ nguồn, người đại diện và bằng chứng.

## Sửa lỗi hồi quy và cân bằng fixture

- Khôi phục tương thích chuỗi chăm sóc V1: caregiver cũ không có hồ sơ lịch gia đình vẫn hoạt động theo quy tắc cũ; cường độ tiếng khóc cơ sở giữ mức đã phát hành.
- Quy mô dự trữ và sản lượng nghề của làng được cân theo số hộ mà mỗi hộ chuyên môn phải hỗ trợ. Đây là dữ liệu fixture của V3, không phải hệ kinh tế hoàn chỉnh.
- Người vận chuyển được chọn theo mức mệt thấp nhất rồi theo mã, tránh dồn toàn bộ gánh nặng lên người đầu danh sách.
- Lịch nghề được thu về khung giờ có thể hồi sức hằng ngày, để làng bình thường không sụp vì một bảng lịch tự mâu thuẫn.

## Bằng chứng phát hành

- `dart analyze`: đạt.
- 27/27 runner V0–V3: đạt.
- `flutter analyze`: đạt.
- 20/20 widget test: đạt, gồm bố cục 390×844 và 1280×800 cho V3.
- 530/530 điều kiện catalog triển khai hợp lệ và không trùng mã.
- Flutter web release build: đạt.
- Runner V3: `game/tool/verify_v3_village_30_days.dart`.
- Catalog V3: `game/artifacts/conditions/v3_village_30_days.json`.

## Giới hạn giữ lại

V3 chứng minh một làng nhỏ tự vận hành trong một tháng, không chứng minh toàn bộ game dài hạn. Danh tiếng gián tiếp, hội thoại sâu, nhiều loại hàng/nghề hơn và mở rộng xã hội khác nằm trong backlog; chúng không phải phần còn thiếu của V3.

Chặng kế tiếp theo roadmap là V4 tuổi thơ. Chỉ bắt đầu khi người dùng yêu cầu, với danh sách cổng hữu hạn của chính V4; không kéo dài V3 bằng số phụ mới.

## Liên kết

- [[STATE]]
- [[ACTIVE_WORK]]
- [[DECISIONS]]
- [[CHANGELOG]]
- [[MASTER_PLAN]]
- [[LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC]]
