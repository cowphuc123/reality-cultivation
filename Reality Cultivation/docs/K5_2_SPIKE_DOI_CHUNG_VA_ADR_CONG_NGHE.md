---
aliases:
  - K5.2 — Spike đối chứng và ADR công nghệ
  - ADR-K3-STACK-001
tags:
  - trien-khai
  - cong-nghe
  - adr
status: proposed
updated: 2026-09-07
---

# K5.2 — Spike đối chứng và ADR công nghệ tạm thời

## 1. Quyết định đề xuất

**Dùng S2 — Dart core + Flutter làm working stack có thể đảo ngược cho V1.**

Trạng thái ADR là **PROPOSED**, không phải ACCEPTED. Quyết định này cho phép tiếp tục xây tháng đầu sơ sinh trên artifact đang chạy, nhưng không tuyên bố Flutter đã thắng vòng chọn stack cuối.

S0 PWA được giữ làm đối chứng cho canonical parity, UI web và storage/lifecycle browser. S1 Rust/Tauri và S3 Kotlin/Compose vẫn nằm trong hồ sơ nhưng chưa có toolchain để chạy trên máy này.

## 2. Phạm vi bằng chứng

Lượt này tạo `SPIKE-V0-01`, một tập con nhỏ hơn `SPIKE-W0-01` trong K3.2:

- seed `20260906`;
- BirthEvent tạo P00;
- một lệnh giao mục tiêu;
- hai sự kiện cùng giây nhưng khác pha;
- save trước advance, load rồi chạy đến ngày 1;
- expected trace gồm birth → goal_assigned → transfer → observe;
- expected semantic hash `5629ba88282991c6`.

Fixture có SHA-256 `7C7033ED0F33C7A5798750A0EEEAC5698E1182C3638EEE6D97C35E9AE279F31A`. Expected state có SHA-256 `BE2AB5B26E77E9F39314CF529EACCFC92537C651C7AA11E98F14FDA1D0CA3AB4`.

## 3. Kết quả chạy

| Candidate | Runtime chẩn đoán | Lượt | Hash | p50 | p95 | Kết quả |
| --- | --- | ---: | --- | ---: | ---: | --- |
| S2 Dart core | Dart 3.10.7 JIT | 500 | `5629ba88282991c6` | 140 µs | 477 µs | Đạt |
| S0 PWA core | Node 24.14.0 | 500 | `5629ba88282991c6` | 66 µs | 99 µs | Đạt |

Cả hai cho cùng thứ tự fact và đều save/load giữa scenario. PWA có semantic control tương ứng cho mục tiêu, pause, lưu, tải và lịch sử; static test đạt.

Không dùng chênh lệch microsecond để xếp hạng hiệu năng. Đây là hai JIT diagnostic runner, workload quá nhỏ, chưa có UI đang tải, GC dài hạn hoặc release/AOT tương đương.

## 4. Bằng chứng riêng của S2

- Lõi Dart tách khỏi Flutter và chạy headless.
- Clock 5 giây/ngày, pause/backlog, Command/Query port, save schema và hash đã chạy.
- Shell Flutter dùng cùng core; bố cục 390×844 và 1280×800 đã qua widget test.
- Round-trip save A→B→A và lifecycle autosave/restore đã qua test.
- Flutter Web release biên dịch được.
- Catalog V0 có 14 điều kiện.

Điểm chưa chứng minh: isolate authority riêng, Android thật, Windows native, import save chéo native, memory dài hạn, accessibility thật và workload W1.

## 5. Bằng chứng riêng của S0

- Core JavaScript chạy cùng fixture/expected state và khớp hash Dart.
- PWA text dùng CSS responsive, localStorage, manifest và service worker tối thiểu.
- Không cần dependency ngoài cho runner.

Điểm chưa chứng minh: browser lifecycle thật, durability/quota, worker authority, file import/export, browser variance, accessibility và tải dài hạn. S0 chưa đủ làm canonical simulation runtime.

## 6. Candidate chưa chạy

| Candidate | Trạng thái môi trường | Kết luận lượt này |
| --- | --- | --- |
| S1 Rust/Tauri | Không có `rustc`/`cargo` | NOT_RUN, không bị loại về kiến trúc |
| S3 Kotlin/Compose | Có Java nhưng không có Gradle/Android SDK | NOT_RUN, không bị loại về kiến trúc |
| S4 .NET MAUI | Có .NET SDK 6 nhưng không có workload MAUI | Không kích hoạt candidate dự phòng |

Không cài ba toolchain lớn chỉ để tạo bằng chứng tượng trưng. Nếu S2 gặp blocker ở isolate, memory hoặc native lifecycle, phải mở lại S1/S3 trên môi trường phù hợp.

## 7. Đánh giá gate K3.2

| Gate | Trạng thái sau K5.2 |
| --- | --- |
| K3T01 shortlist/nguồn | Đạt trên giấy |
| K3T02 cùng fixture/scenario/metric | Đạt cho tập con `SPIKE-V0-01` |
| K3T03 disqualifier/score/tie-break | Đạt trên giấy |
| K3T04 ADR/revisit format | Đạt; ADR này là PROPOSED |
| K3T05 PlatformScope | Chưa được người dùng chốt |
| K3T06 S1–S3 core runs | Chưa đạt; mới S2 và S0 |
| K3T07 Android+Windows runs | Chưa đạt |
| K3T08 save/kill/parity | Đạt một phần ở V0; chưa fault/native parity |
| K3T09 UI/accessibility/performance | Đạt một phần; chưa accessibility/tải thật |
| K3T10 ADR accepted | Chưa đạt |

## 8. Hệ quả của working decision

- V1 tiếp tục trong `game/` và `client/`, tránh viết lại ngay khi chưa có blocker.
- Domain core không được import Flutter; UI chỉ dùng port/view.
- Save schema và expected state tiếp tục trung lập công nghệ.
- Mọi dữ liệu V1 phải chạy headless để S0 hoặc candidate khác có thể tái kiểm tra.
- Không dựa Flutter object serialization cho canonical state.
- Không dùng PWA microbenchmark để hạ yêu cầu isolate hoặc memory profiling.

## 9. Trigger xem lại

Mở lại quyết định trước khi gọi ADR ACCEPTED nếu xảy ra một trong các điều kiện:

- Dart/Flutter không giữ 5 giây/ngày ở workload W1 với margin;
- isolate bridge tạo copy/latency quá ngân sách;
- Android hoặc Windows lifecycle/save không kiểm soát được;
- memory/GC tăng không chặn được trong lượt chạy dài;
- accessibility của text/table/tree không đạt;
- save chéo nền tảng lệch hash;
- phạm vi phát hành yêu cầu nền tảng mà Flutter/toolchain không đáp ứng;
- S1 hoặc S3 có bằng chứng tốt hơn trên cùng full workload.

## 10. Việc tiếp theo

1. Bắt đầu V1 trong working stack S2: cơ thể sơ sinh, nhu cầu, giác quan và người chăm sóc.
2. Nâng shared fixture dần tới `SPIKE-W0-01` thay vì làm spike tách rời game.
3. Thêm simulation isolate trước workload có thể khóa UI.
4. Chạy Android/Windows thật khi toolchain có sẵn.
5. Chỉ đổi ADR sang ACCEPTED sau khi các disqualifier bắt buộc có evidence.

## 11. Liên kết

- [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]
- [[K5_1_PROTOTYPE_LOI_V0]]
- [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]
- [[STATE]]
