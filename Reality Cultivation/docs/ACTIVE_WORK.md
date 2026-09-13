---
title: Công việc đang hoạt động
aliases:
  - Active work
  - Lượt làm hiện tại
tags:
  - huong-dan
  - chuyen-giao
---

# Công việc đang hoạt động

Cập nhật: 2026-09-13.

## Trạng thái lượt

| Trường | Giá trị |
| --- | --- |
| Chủ lượt | Không có việc dở sau phát hành |
| Trạng thái | V3 đã hoàn thành và qua kiểm chứng phát hành |
| Nhánh ổn định | `master` |
| Commit game ổn định | V3 — xem `HEAD` của `master` |
| Nhánh bàn giao | Không có |
| Lát cắt phát hành gần nhất | [[K5_29_V3_LANG_NHO_TU_VAN_HANH_30_NGAY]] |
| Việc tiếp theo | Chờ người dùng yêu cầu bắt đầu V4 tuổi thơ; trước khi viết mã phải đối chiếu cổng V4 và chỉ lấy phần thật sự còn thiếu |
| Chặng hiện tại | V3 đã đóng; V4 chưa bắt đầu chính thức |

## Kết quả kiểm chứng tại mốc ổn định

- `dart analyze`: đạt.
- 27/27 runner V0–V3: đạt.
- Runner V3: 50 NPC, 12 hộ, 291 cuộc đổi hàng, 2.333 bằng chứng, 172 quan hệ xuyên hộ, 207 yêu cầu tài nguyên, 0 ngày cứu hộ vô căn cứ.
- Chạy liền, save/load ngày 15 và replay: cùng hash `8b27413973a433d7`.
- `flutter analyze`: đạt.
- 20/20 widget test: đạt, gồm V3 ở 390×844 và 1280×800.
- 530/530 điều kiện catalog triển khai hợp lệ, không trùng mã.
- Flutter web release build: đạt.
- Web: https://cowphuc123.github.io/reality-cultivation/

## Phạm vi đã khóa

- V3 kết thúc tại [[K5_29_V3_LANG_NHO_TU_VAN_HANH_30_NGAY]]. Không tạo `V3.0-dev.21`.
- Danh tiếng gián tiếp, hội thoại sâu và các mở rộng xã hội khác là backlog, không phải lỗi còn thiếu của V3.
- Nền `V4.0-dev.1` về trẻ học kỳ vọng với người chăm đã nằm trong mã. Nó chưa có nghĩa V4 hoàn thành.
- Khi bắt đầu V4, đọc [[LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC]] và lập danh sách hữu hạn từ cổng V4 trước; mọi đề xuất ngoài cổng đưa vào backlog.

## Cách nhận lượt

1. Đồng bộ `master` từ GitHub và kiểm tra working tree sạch.
2. Đọc [[STATE]], [[DECISIONS]], [[MASTER_PLAN]] và hồ sơ K5 gần nhất.
3. Nếu người dùng yêu cầu V4, đối chiếu mã hiện có với cổng V4 trước khi chọn lát cắt; không tự mở rộng phạm vi.
4. Ghi chủ lượt, mục tiêu, nhánh và việc đang dở vào file này nếu công việc kéo dài qua phiên.

## Cách kết thúc lượt

- Khi chỉ được yêu cầu viết mã: ghi đúng phần chưa kiểm chứng; không push `master`.
- Khi người dùng yêu cầu kiểm chứng/GitHub: chạy đầy đủ analyzer, runner, widget test, catalog và web build; hoàn thiện hồ sơ rồi commit/push `master`.
- Nếu sắp hết giới hạn khi còn dở: cập nhật file này, commit `WIP:` lên `handoff/<tên-lát-cắt>` và push nhánh; không đưa WIP vào `master`.

## Liên kết

- [[STATE]]
- [[DECISIONS]]
- [[MASTER_PLAN]]
- [[CHANGELOG]]
- [[CHUYEN_GIAO]]
- [[LO_TRINH_PHIEN_BAN_VA_DIEU_KIEN_KET_THUC]]
