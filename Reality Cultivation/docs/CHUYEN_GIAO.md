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
2. **`docs/DECISIONS.md`** — bảng U001–U015 là **yêu cầu người dùng đã xác nhận**; mọi thứ khác là đề xuất chưa chốt.
3. **Tài liệu K5 mới nhất** (`docs/K5_19_V2_12_NGHI_BENH.md`) — lát cắt vừa xong.
4. **`docs/CHANGELOG.md`** — chỉ khi cần tra lịch sử.

`docs/MASTER_PLAN.md` và các tài liệu K0–K4 là **thiết kế trên giấy**, không phải mã đang chạy. Đừng lẫn hai thứ.

---

## 1. Dự án là gì, trong ba câu

Game text mô phỏng thế giới tu tiên, tham vọng chiều sâu vượt Dwarf Fortress. Người chơi giao mục tiêu cho nhân vật chứ không điều khiển từng bước; 5 giây ngoài đời = 1 ngày trong game. Hiện đã có **lõi mô phỏng chạy được** (Dart) và **giao diện text đa nền tảng** (Flutter), đang triển khai theo từng lát cắt dọc V0 → V2.12.

Địa chỉ chơi thử: **https://cowphuc123.github.io/reality-cultivation/**
Kho mã: **https://github.com/cowphuc123/reality-cultivation** (công khai)

---

## 2. Hai tầng phải phân biệt rõ

| Tầng | Nội dung | Trạng thái |
| --- | --- | --- |
| **Kế hoạch K0–K4** | 9 đặc tả nền, DL01–DL06, K0–K4 (~60 tài liệu) | **1.860 điều kiện thiết kế, chưa chạy** bằng mô phỏng thật |
| **Mã K5** | `game/` + `client/`, V0 → V2.12 | **331 điều kiện có bộ chạy tự động**, tất cả đang xanh |

Hai bộ đếm này **độc lập**. Đừng cộng chúng, và đừng nói 1.860 điều kiện đã chạy.

---

## 3. Cấu trúc mã

```
D:\Reality Cultivation\
├── Reality Cultivation\        ← vault Obsidian: toàn bộ hồ sơ
│   ├── README.md               (mục lục)
│   ├── AGENTS.md               (chỉ dẫn cho trợ lý làm trong vault)
│   └── docs\                   (STATE, DECISIONS, CHANGELOG, K0–K5…)
├── game\                       ← lõi mô phỏng Dart, 7.359 dòng
│   ├── lib\src\simulation.dart (3.616 dòng — trung tâm, mọi sự kiện ở đây)
│   ├── lib\src\*.dart          (routine, agenda, adult_body, route, geometry…)
│   ├── tool\verify_*.dart      (17 bộ chạy kiểm chứng)
│   └── artifacts\conditions\   (catalog điều kiện, JSON)
├── client\                     ← shell Flutter, 4.099 dòng
│   ├── lib\main.dart           (3.173 dòng — toàn bộ GUI)
│   └── test\widget_test.dart   (16 bài, 881 dòng)
└── .github\workflows\          (tự động build và đăng web khi push)
```

`AGENTS.md` ở gốc và trong vault đều có chỉ dẫn; đọc cả hai.

---

## 4. Nề nếp làm việc — phần quan trọng nhất

Đây là những quy ước đã hình thành qua 13 lát cắt. **Giữ đúng chúng, nếu không dự án sẽ mất khả năng phát hiện lỗi.**

### 4.1. Hash là tín hiệu phát hiện hồi quy — đừng làm hỏng

Mỗi bộ chạy in ra một `semanticHash` của trạng thái thế giới. Sau **mọi** thay đổi lõi, chạy lại toàn bộ 17 bộ và so hash. Hash cũ đổi mà không có lý do rõ ràng nghĩa là **vừa phá một thứ gì đó**.

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
- **Không có RNG.** `WorldState.seed` được lưu nhưng **chưa có bộ sinh số ngẫu nhiên nào tiêu thụ nó**. Mọi thứ dùng ngưỡng xác định. Nếu muốn thêm ngẫu nhiên, phải làm bộ RNG theo seed chung (thuộc K2.1) — đừng bịa `Random()` vào một chỗ, sẽ phá tính tái lập của cả 17 bộ chạy.
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
- **Không tự đẩy lên GitHub.** Làm việc và cập nhật hồ sơ tại chỗ; **chỉ commit + build web + push khi người dùng nói "đẩy lên"**. Yêu cầu này đưa ra ngày 2026-09-08 để tiết kiệm token.
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
| V2.11–V2.12 | Bệnh của người lớn, và người ốm được nghỉ |

**Chuỗi nhân quả dài nhất hiện có** (không đoạn nào viết sẵn):

> Không có quyền lấy nước → khát dần → đổ bệnh vì mất nước → phải nghỉ → khối việc bị bỏ → hộ mất giờ công → sản lượng thấp → kho cạn → nhu cầu gấp hơn → kế hoạch xếp việc ưu tiên cao hơn cho người khác

Và một chuỗi khác nối cơ thể với địa lý:

> Người chở gầy đi → sức làm việc giảm → không qua nổi khúc lội suối → buộc đi đường đèo → hàng về muộn hơn 8 giờ

---

## 8. Chỗ hở lớn nhất và bước tiếp

**Việc nên làm ngay:** khối việc của người đang nghỉ bệnh **mất hẳn chứ không ai gánh**. Kế hoạch chào được việc mới cho người khác, nhưng bảng giờ cố định của người ốm thì chỉ bỏ — nhà mất luôn phần công đó. Sửa chỗ này nối thẳng vào bộ chào việc (`_offerWork`) đã có, phạm vi nhỏ.

**Hướng lớn hơn:** bản đồ vùng để `WorldPoint` có chỗ dùng thật. Hiện hai chiều đã có nhưng chỉ tuyến vận tải dùng; ba gian nhà vẫn nằm trên trục. Đây là đường đi về U013 (sinh thế giới → mô phỏng tiền sử → chọn nơi trên bản đồ → sinh ra ở đó), là yêu cầu đã xác nhận mà mã còn cách rất xa.

**Danh sách chưa có** (đầy đủ trong STATE.md): giải phẫu đa bộ phận, thương tích, già đi, chết, lây bệnh, thuốc, thân nhiệt người lớn *(cố ý hoãn — chưa có mô hình môi trường để phản ứng lại)*, quan hệ giữa người với người, mục tiêu cá nhân dài hạn, worldgen, hệ cảnh giới, tu luyện.

**Câu hỏi còn mở với người dùng:** TN01–TN08 trong `docs/LUA_CHON_TRAI_NGHIEM.md` chưa có phản hồi; ADR chọn công nghệ vẫn ở trạng thái PROPOSED (Dart/Flutter là working stack, chưa phải quyết định cuối).

---

## 9. Việc đầu tiên nên làm khi tiếp nhận

1. Chạy `dart analyze`, `flutter analyze`, `flutter test` và toàn bộ 17 bộ chạy. So hash với bảng ở mục 4.1. **Nếu khớp hết thì bạn đang ở đúng điểm bàn giao.**
2. Đọc `docs/STATE.md` và `docs/K5_19_V2_12_NGHI_BENH.md`.
3. Hỏi người dùng muốn làm hướng nào ở mục 8.

## Liên kết

- Trạng thái hiện tại: [[STATE]]
- Yêu cầu đã xác nhận và câu hỏi mở: [[DECISIONS]]
- Lát cắt mới nhất: [[K5_19_V2_12_NGHI_BENH]]
- Kế hoạch tổng: [[MASTER_PLAN]]
- Cách dùng vault: [[HUONG_DAN]]
