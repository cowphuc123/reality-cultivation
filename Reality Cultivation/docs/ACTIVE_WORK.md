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

Cập nhật: 2026-09-10.

## Trạng thái lượt

| Trường | Giá trị |
| --- | --- |
| Chủ lượt | Chưa có — sẵn sàng cho Codex hoặc Claude nhận việc tiếp theo |
| Trạng thái | Không có mã đang làm dở |
| Nhánh ổn định | `master` |
| Commit game ổn định | `ae3d740` — V2.20 sinh hộ và quan hệ gia đình |
| Nhánh bàn giao | Không có |
| Lát cắt hoàn tất gần nhất | [[K5_27_V2_20_SINH_HO_VA_QUAN_HE_GIA_DINH]] |
| Việc đề xuất tiếp theo | V2.21 — hộ nhiều thành viên, quan hệ nội bộ và lịch chăm trẻ |

## Kết quả kiểm tra tại mốc ổn định

- 25/25 runner đạt.
- 18/18 widget test đạt.
- `dart analyze` và `flutter analyze` không báo lỗi.
- Flutter web release build thành công.
- 491 điều kiện catalog triển khai.
- Web: https://cowphuc123.github.io/reality-cultivation/

## File đang sửa dở

Không có.

## Cách nhận lượt

1. Đồng bộ `master` từ GitHub và kiểm tra working tree sạch.
2. Ghi tên trợ lý, mục tiêu, nhánh và commit bắt đầu vào file này.
3. Tạo nhánh làm việc nếu lát cắt có nguy cơ kéo dài qua giới hạn phiên.
4. Đọc [[STATE]], [[DECISIONS]], [[MASTER_PLAN]] và tài liệu K5 gần nhất.
5. Làm tiếp từ trạng thái thật của mã; không dựng lại theo ký ức cuộc trò chuyện.

## Cách kết thúc lượt

- **Đã hoàn tất:** kiểm tra đạt, cập nhật hồ sơ, commit/push; đưa bảng trên về trạng thái “sẵn sàng”.
- **Còn dở:** cập nhật chính xác việc đã làm/chưa làm, lỗi đang có, test đã chạy và bước kế; commit WIP lên `handoff/<tên-lát-cắt>`, push nhánh đó và ghi hash commit vào bảng.
