---
aliases:
  - Chuyển giao
  - Bàn giao cho trợ lý khác
tags:
  - huong-dan
  - muc-luc
---

# Chuyển giao dự án cho trợ lý khác

Viết ngày 2026-09-09. Tài liệu này dành cho **trợ lý AI tiếp nhận** (ChatGPT hoặc bất kỳ ai khác) để tiếp tục dự án mà không cần đọc lại toàn bộ hội thoại cũ.

Đọc theo đúng thứ tự sau, đừng nhảy bước:

1. **`docs/STATE.md`** — đang ở đâu, làm gì tiếp. Ngắn, đọc trước.
2. **`docs/DECISIONS.md`** — bảng U001–U016 là **yêu cầu người dùng đã xác nhận**; mọi thứ khác là đề xuất chưa chốt.
3. **Tài liệu K5 mới nhất** (`docs/K5_22_V2_15_SINH_BAN_DO_TU_SEED.md`) — lát cắt vừa xong.
4. **`docs/CHANGELOG.md`** — chỉ khi cần tra lịch sử.

`docs/MASTER_PLAN.md` và các tài liệu K0–K4 là **thiết kế trên giấy**, không phải mã đang chạy. Đừng lẫn hai thứ.

---

## 1. Dự án là gì, trong ba câu

Game text mô phỏng thế giới tu tiên, tham vọng chiều sâu vượt Dwarf Fortress. Người chơi giao mục tiêu cho nhân vật chứ không điều khiển từng bước; 5 giây ngoài đời = 1 ngày trong game. Hiện đã có **lõi mô phỏng chạy được** (Dart) và **giao diện text đa nền tảng** (Flutter), đang triển khai theo từng lát cắt dọc V0 → V2.15.

Địa chỉ chơi thử: **https://cowphuc123.github.io/reality-cultivation/**
Kho mã: **https://github.com/cowphuc123/reality-cultivation** (công khai)

---

## 2. Hai tầng phải phân biệt rõ

| Tầng | Nội dung | Trạng thái |
| --- | --- | --- |
| **Kế hoạch K0–K4** | 9 đặc tả nền, DL01–DL06, K0–K4 (~60 tài liệu) | **1.860 điều kiện thiết kế, chưa chạy** bằng mô phỏng thật |
| **Mã K5** | `game/` + `client/`, V0 → V2.15 | **401 điều kiện trong catalog triển khai**, 20 runner đang xanh |

Hai bộ đếm này **độc lập**. Đừng cộng chúng, và đừng nói 1.860 điều kiện đã chạy.

---

## 3. Cấu trúc mã

```
D:\Reality Cultivation\
├── Reality Cultivation\        ← vault Obsidian: toàn bộ hồ sơ
│   ├── README.md               (mục lục)
│   ├── AGENTS.md               (chỉ dẫn cho trợ lý làm trong vault)
│   └── docs\                   (STATE, DECISIONS, CHANGELOG, K0–K5…)
├── game\                       ← lõi mô phỏng Dart, 7.793 dòng trong `lib/src`
│   ├── lib\src\simulation.dart (3.838 dòng — trung tâm, mọi sự kiện ở đây)
│   ├── lib\src\*.dart          (routine, agenda, adult_body, route, geometry…)
│   ├── tool\verify_*.dart      (20 bộ chạy kiểm chứng)
│   └── artifacts\conditions\   (catalog điều kiện, JSON)
├── client\                     ← shell Flutter
│   ├── lib\main.dart           (3.256 dòng — toàn bộ GUI)
│   └── test\widget_test.dart   (17 bài, 864 dòng)
└── .github\workflows\          (tự động build và đăng web khi push)
```

`AGENTS.md` ở gốc và trong vault đều có chỉ dẫn; đọc cả hai.

---

## 4. Nề nếp làm việc — phần quan trọng nhất

Đây là những quy ước đã hình thành qua các lát cắt. **Giữ đúng chúng, nếu không dự án sẽ mất khả năng phát hiện lỗi.**

### 4.1. Hash là tín hiệu phát hiện hồi quy — đừng làm hỏng

Mỗi bộ chạy in ra một `semanticHash` của trạng thái thế giới. Sau **mọi** thay đổi lõi, chạy lại toàn bộ 20 bộ và so hash. Hash cũ đổi mà không có lý do rõ ràng nghĩa là **vừa phá một thứ gì đó**.

Hash hiện tại (2026-09-09):

| Bộ chạy | Hash |
| --- | --- |
| `verify_v0` | `5629ba88282991c6` |
| `verify_v1_infancy` | `a6639c12675fafe7` |
| `verify_v1_care_chain` | `69988c4593598846` |
| `verify_v1_body` | `5d418dc95af7118d` |
| `verify_v2_household` | `985a29eb4aaa240b` |
| `verify_v2_1_household_health` | `3d83fc8e0cc7b77f` |
| `verify_v2_2_transport_substitution` | `d0b87de633a4765a` |
| `verify_v2_3_routine_directory` | `ade0b8a4300276c9` |
| `verify_v2_4_need_driven_plan` | `5b36f570a39e4bde` |
| `verify_v2_5_skills_and_refusal` | `29bf49642c71fb18` |
| `verify_v2_6_growth_hunger_mood` | `b9f0b0d8269b8653` |
| `verify_v2_7_adult_body` | `dc54cde35203486a` |
| `verify_v2_8_water_and_thirst` | `469fab7582a4aa34` |
| `verify_v2_9_trade_route` | `a4830eb8844ec469` |
| `verify_v2_10_two_axes_and_fork` | `2a87b934f03e0f29` |
| `verify_v2_11_adult_illness` | `beabb8f20438f377` |
| `verify_v2_12_illness_rest` | `f57b6f0fb06205bb` |
| `verify_v2_13_work_substitution` | `edf67b2b36cda0eb` |
| `verify_v2_14_region_map` | `1d70b51a89d4b142` |
| `verify_v2_15_seeded_world_generation` | `5595e41dd7f499bc` |

Lệnh chạy tất cả:

```bash
cd "D:/Reality Cultivation/game" && for f in tool/verify_*.dart; do echo "$f"; dart run "$f" | tail -3; done
```

### 4.2. Tính năng mới phải nằm sau cờ bật, để hash cũ không đổi

Đây là kỹ thuật đã cứu dự án nhiều lần. Cờ đặt trong payload `household_created`:

| Cờ | Bật gì |
| --- | --- |
| `enable_v2_1` | bệnh trẻ sơ sinh, sản xuất, tiếp tế |
| `enable_v2_2` | vận chuyển có người chở, người chăm thay thế |
| `auto_plan` | hộ tự lập kế hoạch từ nhu cầu |
| `enable_v2_6` | tay nghề lên tay, cơn đói, tâm trạng |
| `enable_v2_11` | bệnh của người lớn |

Ngoài ra dùng **trường dữ liệu không bắt buộc**: `PersonState.skills`, `.agenda`, `.body`, `.routine`, `.positionYMm` — người không khai báo thì giữ nguyên hành vi cũ. Nhờ vậy refactor 1D→2D ở V2.10 **không đổi một hash nào**.

### 4.3. Mỗi lát cắt gồm đúng năm phần

1. Sửa lõi trong `game/lib/src/`
2. Viết `game/tool/verify_v2_X_<tên>.dart` — bộ chạy có khẳng định đánh mã (KH01, KB02…)
3. Viết `game/artifacts/conditions/v2_X_<tên>.json` — catalog ~20 điều kiện
4. Nối lên GUI trong `client/lib/main.dart` + thêm bài widget test
5. Viết `docs/K5_XX_V2_X_<TÊN>.md` rồi cập nhật CHANGELOG, STATE, DECISIONS, README

Bỏ bước nào cũng làm hồ sơ lệch khỏi mã.

### 4.4. Nguyên tắc thiết kế đã theo

- **Nguyên nhân phải là trạng thái thật, không phải hẹn giờ.** Bệnh người lớn khởi phát từ mức nước/mệt thật, không từ mốc thời gian viết sẵn như bệnh trẻ sơ sinh ở V2.1.
- **RNG phải đi qua stream seed chung.** V2.15 đã có Park–Miller 31-bit cho worldgen hình học, với stream dẫn xuất theo nhãn miền. Không dùng `Random()` cục bộ; mọi kết quả mới phải tái lập từ seed/config/version và không làm xô lệch stream miền khác.
- **Số nguyên hết.** Không dùng `double` trong lõi. Có `integerSquareRoot` trong `geometry.dart`.
- **Mọi con số là fixture chưa duyệt.** Trừ bảng U trong DECISIONS, mọi ngưỡng/hệ số đều là số kỹ thuật để kiểm chứng chuỗi nhân quả — **không phải mô hình y khoa, không phải cân bằng đã chốt**. Nói rõ điều này khi báo cáo.
- **Ghi rõ chỗ chưa làm.** Mỗi tài liệu K5 có mục "Giới hạn và bước tiếp theo". Đừng bỏ.

### 4.5. Khi hash cũ buộc phải đổi

Có ba lý do hợp lệ, và cả ba đều phải ghi lại:

| Lý do | Ví dụ đã xảy ra |
| --- | --- |
| **Sửa lỗi thật** | V2.3 nuốt khối việc (sửa ở V2.4); mất mệt mỏi vì bản chụp cũ (sửa ở V2.6) |
| **Mở rộng mô hình có chủ đích** | nước có hậu quả (V2.8 đổi hash V2.7) |
| **Lưu thêm trạng thái** | chuyến hàng lưu đường đã chọn (V2.10 đổi hash V2.9) |

Khi đổi: cập nhật hash trong tài liệu K5 cũ, trong catalog JSON, trong STATE, và ghi lý do vào CHANGELOG + DECISIONS. Đã làm mẫu 5 lần, cứ theo.

### 4.6. Một họ lỗi đã gặp hai lần — để ý

**Đọc trạng thái một lần rồi ghi lại sau khi đã có thay đổi xen giữa.** Trong `simulation.dart`, `_replace()` tạo `WorldState` mới; nếu giữ một `PersonState` cũ rồi ghi lại sau, mọi cập nhật xen giữa bị xoá.

Đã trúng lỗi này hai lần (V2.4 và V2.6). Quy tắc: **sau mỗi `_replace()`, đọc lại từ `_state`**, đừng dùng biến cũ.

---

## 5. Cách chạy và kiểm chứng

```bash
# Phân tích tĩnh
cd "D:/Reality Cultivation/game" && dart analyze
cd "D:/Reality Cultivation/client" && flutter analyze

# Một bộ chạy
cd "D:/Reality Cultivation/game" && dart run tool/verify_v2_12_illness_rest.dart
cd "D:/Reality Cultivation/game" && dart run tool/verify_v2_13_work_substitution.dart
cd "D:/Reality Cultivation/game" && dart run tool/verify_v2_14_region_map.dart
cd "D:/Reality Cultivation/game" && dart run tool/verify_v2_15_seeded_world_generation.dart

# Test giao diện
cd "D:/Reality Cultivation/client" && flutter test

# Build bản web (chỉ để kiểm tra; GitHub Actions tự build khi push)
cd "D:/Reality Cultivation/client" && flutter build web --release
```

Máy hiện có: **Dart 3.10.7**, **Flutter 3.38.7**. **Không có Android SDK và Visual Studio C++**, nên chưa đóng gói được APK hay EXE — đây là lý do V0 tới giờ vẫn chưa kiểm chứng trên thiết bị native thật.

`gh` (GitHub CLI) đã cài nhưng có thể chưa nằm trong PATH của phiên mới:

```bash
export PATH="/c/Program Files/GitHub CLI:$PATH"
```

Đã đăng nhập sẵn với tài khoản `cowphuc123`.

---

## 6. Cách người dùng muốn làm việc

Đây là những điều người dùng đã yêu cầu rõ — **tôn trọng chúng**:

- **Viết tiếng Việt.** Toàn bộ hồ sơ, chú thích mã, nhãn giao diện và báo cáo đều bằng tiếng Việt.
- **Sau khi hoàn tất trọn một lát cắt:** chạy kiểm tra, cập nhật hồ sơ, rồi tự commit và push theo U016. Không đẩy trạng thái đang dở hoặc đang lỗi. Yêu cầu ngày 2026-09-09 này thay quy tắc cũ ngày 2026-09-08.
- **Nhắc trước khi đụng lõi.** Khi việc sắp làm sửa `simulation.dart`/`routine.dart` hoặc là thiết kế hệ mới, nói trước để người dùng đổi sang model mạnh hơn, rồi hãy làm. Người dùng dùng Sonnet cho việc thường và Opus cho việc lõi.
- **Ưu tiên GUI** (U015): mọi chức năng thật phải có nơi truy cập trên cả điện thoại và máy tính; hệ chưa có thì ghi rõ "chưa mở", đừng bịa số.
- **Báo cáo trung thực.** Nói rõ cái gì chạy được, cái gì chỉ đúng trên giấy, cái gì là fixture chưa duyệt.

---

## 7. Đang ở đâu: các hệ đã chạy được

| Bản | Nội dung |
| --- | --- |
| V0 | Đồng hồ nguyên, hàng đợi sự kiện, lưu/tải, replay |
| V1–V1.2 | Trẻ sơ sinh ngày 0–30: nhu cầu, giác quan, tiếng khóc, chuỗi chăm sóc nhân quả, sinh lý theo giờ |
| V2.0 | Hộ gia đình: kho hữu hạn, quyền dùng theo người–vật, bữa ăn nguyên tử |
| GUI | Năm khu vực thích nghi điện thoại/máy tính |
| V2.1–V2.2 | Phòng, bệnh trẻ nhẹ, sản xuất, tiếp tế, người chăm thay thế |
| V2.3 | Nhịp sống NPC, xung đột lịch, hồ sơ toàn thế giới |
| V2.4 | Nhu cầu hộ sinh việc, ưu tiên phân xử, sản lượng theo giờ làm |
| V2.5 | Tay nghề chọn người, quyền từ chối việc, xếp lại lịch |
| V2.6 | Tay nghề lên tay, đói và tâm trạng |
| V2.7–V2.8 | Cơ thể người lớn: ăn, đốt, sụt cân, nước và cơn khát |
| V2.9–V2.10 | Tuyến vận tải thật, vị trí hai chiều, ngã rẽ và chọn đường |
| V2.11–V2.13 | Bệnh của người lớn, nghỉ bệnh và chuyển ca cho người gánh thay |
| V2.14 | Vùng, địa điểm và quy người/phòng/vật theo tọa độ hai chiều |
| V2.15 | Seed sinh hình học vùng/địa điểm, fingerprint và provenance lưu được |

**Chuỗi nhân quả dài nhất hiện có** (không đoạn nào viết sẵn):

> Không có quyền lấy nước → khát dần → đổ bệnh vì mất nước → phải nghỉ → khối việc bị bỏ → hộ mất giờ công → sản lượng thấp → kho cạn → nhu cầu gấp hơn → kế hoạch xếp việc ưu tiên cao hơn cho người khác

Và một chuỗi khác nối cơ thể với địa lý:

> Người chở gầy đi → sức làm việc giảm → không qua nổi khúc lội suối → buộc đi đường đèo → hàng về muộn hơn 8 giờ

---

## 8. Chỗ hở lớn nhất và bước tiếp

**Việc nên làm ngay:** tách tạo thế giới khỏi sinh nhân vật. V2.15 đã sinh hình học từ seed nhưng client vẫn tạo P00 ngay trong cùng fixture. Bước kế nên cho xem tiến độ tạo, xem bản đồ, chọn một địa điểm sinh hợp lệ rồi mới tạo P00; đây là phần tiếp theo trực tiếp của U013.

**Nhánh gần khác:** làm việc nhẹ hoặc nửa buổi khi người bệnh hồi phục. V2.13 đã chuyển được nguyên ca cho một người đủ điều kiện nhưng chưa chia ca, đổi công hoặc tạo nghĩa vụ bù.

**Danh sách chưa có** (đầy đủ trong STATE.md): giải phẫu đa bộ phận, thương tích, già đi, chết, lây bệnh, thuốc, thân nhiệt người lớn *(cố ý hoãn — chưa có mô hình môi trường để phản ứng lại)*, quan hệ giữa người với người, mục tiêu cá nhân dài hạn, worldgen ngoài hình học một vùng, lịch sử tiền game, chọn nơi sinh, hệ cảnh giới, tu luyện.

**Câu hỏi còn mở với người dùng:** TN01–TN08 trong `docs/LUA_CHON_TRAI_NGHIEM.md` chưa có phản hồi; ADR chọn công nghệ vẫn ở trạng thái PROPOSED (Dart/Flutter là working stack, chưa phải quyết định cuối).

---

## 9. Việc đầu tiên nên làm khi tiếp nhận

1. Chạy `dart analyze`, `flutter analyze`, `flutter test` và toàn bộ 20 bộ chạy. So hash với bảng ở mục 4.1. **Nếu khớp hết thì bạn đang ở đúng điểm bàn giao.**
2. Đọc `docs/STATE.md` và `docs/K5_22_V2_15_SINH_BAN_DO_TU_SEED.md`.
3. Hỏi người dùng muốn làm hướng nào ở mục 8.

## Liên kết

- Trạng thái hiện tại: [[STATE]]
- Yêu cầu đã xác nhận và câu hỏi mở: [[DECISIONS]]
- Lát cắt mới nhất: [[K5_22_V2_15_SINH_BAN_DO_TU_SEED]]
- Kế hoạch tổng: [[MASTER_PLAN]]
- Cách dùng vault: [[HUONG_DAN]]
