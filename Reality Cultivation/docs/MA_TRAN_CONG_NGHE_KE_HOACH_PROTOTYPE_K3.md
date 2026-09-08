---
title: Ma trận công nghệ và kế hoạch prototype quyết định stack — K3.2
aliases:
  - K3.2
  - Ma trận công nghệ
tags:
  - reality-cultivation
  - thiet-ke
  - kien-truc
  - cong-nghe
  - da-nen-tang
status: de-xuat
updated: 2026-09-07
---

# Ma trận công nghệ và kế hoạch prototype quyết định stack — K3.2

Tài liệu này cụ thể hóa tiêu chí công nghệ của [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. Nó lập shortlist, chuẩn hóa một prototype so sánh, cách thu bằng chứng và ADR nháp cho game text chạy trên điện thoại và máy tính.

Thông tin hệ sinh thái được đối chiếu ngày 2026-09-06 từ tài liệu chính thức. Điểm “phù hợp trên giấy” là suy luận kiến trúc, chưa phải benchmark. Không stack nào được chọn trong K3.2; 64 điều kiện CN cuối tài liệu đều chưa chạy.

## 1. Kết luận tạm thời

Ba ứng viên vào vòng prototype ngang hàng:

1. **S1 — Rust core + Tauri 2 + UI web có cấu trúc**;
2. **S2 — Dart core + Flutter**;
3. **S3 — Kotlin Multiplatform core + Compose Multiplatform**.

**S4 — C#/.NET + .NET MAUI** là phương án dự phòng cần đưa vào ma trận nhưng chưa bắt buộc dựng spike đầu. **S0 — PWA thuần** là mẫu đối chứng cho UI/đóng gói, không là ứng viên authority mặc định. Danh sách này có thể đổi nếu phạm vi hệ điều hành hoặc nhân lực được chốt khác.

## 2. Điều chưa được quyết định

- Android có phải mobile đầu tiên hay phải đồng thời iOS;
- “máy tính” ban đầu là Windows hay cả macOS/Linux;
- UI dùng WebView hay renderer riêng;
- core dùng Rust, Dart, Kotlin hoặc C#;
- file/embedded database/codec cụ thể;
- cloud sync;
- ngày bắt đầu code.

K3.2 không biến Windows hiện tại của dự án thành yêu cầu phát hành chỉ-Windows.

## 3. Nguồn chính thức và ảnh chụp thời điểm

| Nguồn | Dữ kiện dùng |
|---|---|
| [Tauri — What is Tauri?](https://v2.tauri.app/start/) | Tauri 2 nhắm desktop và mobile, dùng frontend HTML/CSS/JS cùng backend Rust/Swift/Kotlin khi cần |
| [Tauri Architecture](https://v2.tauri.app/concept/architecture/) | WebView giao tiếp Rust qua message passing; WRY/TAO làm lớp nền |
| [Tauri WebView versions](https://v2.tauri.app/reference/webview-versions/) | engine WebView phụ thuộc nền tảng/thiết bị, đặc biệt Android dùng system WebView |
| [Flutter supported platforms](https://docs.flutter.dev/reference/supported-platforms) | Flutter 3.47.2 liệt kê Android/iOS/Windows/macOS/Linux được hỗ trợ |
| [Flutter concurrency and isolates](https://docs.flutter.dev/perf/isolates) | isolate tách bộ nhớ, giao tiếp message; có thể chuyển tính toán nặng khỏi UI isolate |
| [Flutter platform channels](https://docs.flutter.dev/platform-integration/platform-channels) | có channel/codec và Pigeon cho lời gọi platform có kiểu |
| [Flutter FFI](https://docs.flutter.dev/platform-integration/bind-native-code) | có đường gọi native code qua `dart:ffi` nếu tách core sau này |
| [Kotlin platform stability](https://kotlinlang.org/docs/multiplatform/supported-platforms.html) | KMP core và Compose UI ổn định cho Android, iOS, desktop; web Compose còn Beta |
| [Compose compatibility](https://kotlinlang.org/docs/multiplatform/compose-compatibility-and-versioning.html) | phiên bản/OS/kiến trúc hỗ trợ có ma trận và toolchain liên quan |
| [.NET MAUI supported platforms](https://learn.microsoft.com/en-us/dotnet/maui/supported-platforms) | Android, iOS, macOS qua Mac Catalyst và Windows; iOS build cần Mac |

Tất cả cần kiểm tra lại trước khi chốt ADR vì phiên bản và hỗ trợ có thể thay đổi.

## 4. Ràng buộc loại trực tiếp

Ứng viên bị loại nếu spike không thể:

1. tạo cùng canonical end hash trên mobile và desktop;
2. giữ single-writer simulation authority ngoài UI thread;
3. dừng tại boundary và phục hồi sau kill giữa publish;
4. dùng cùng Command/View semantics;
5. lưu package portable không phụ thuộc object dump runtime;
6. chạy hoàn toàn cục bộ;
7. giữ UI phản hồi trong workload W0/W1 dự kiến;
8. đặt core sau API không phụ thuộc framework UI.

Tổng điểm cao không cứu được lỗi loại trực tiếp.

## 5. Phạm vi nền tảng để benchmark

Vì U011 chỉ nói điện thoại và máy tính, prototype chia hai vòng:

| Vòng | Bắt buộc đề xuất | Mục đích |
|---|---|---|
| P0 | Android thật + Windows thật | vòng nhanh, phù hợp máy phát triển hiện tại |
| P1 | iOS thật/simulator + macOS; Linux nếu muốn hỗ trợ | xác minh phạm vi phát hành rộng |

P0 là đề xuất tiến độ, không phải quyết định bỏ iOS/macOS/Linux. Muốn công bố hỗ trợ nền tảng nào phải có run trên nền tảng đó. iOS cần tài nguyên macOS/Xcode theo tài liệu toolchain của các ứng viên.

## 6. Workload chung của spike

Mọi ứng viên dùng cùng dữ liệu logic `SPIKE-W0-01`:

- P00, N01, N02;
- V01 tiền, V02 lương khô, một bình nước;
- hai Place và một Route;
- 12 ScheduledEvent thuộc đủ boundary cần thiết;
- một Command giao mục tiêu;
- một Transaction chuyển 3 V02;
- một Message tạo Observation/Belief;
- một ProcessInstance có remainder;
- ba RNG stream cố định;
- một lifecycle checkpoint;
- expected trace/hash do specification tạo độc lập.

Không thêm animation/network/database phức tạp để che chi phí lõi.

## 7. Scenario chuẩn SP-A — command đến projection

1. load fixture ở PAUSED;
2. UI gửi cùng `CommandEnvelope`;
3. runtime ACK rồi accept tại boundary;
4. scheduler tạo Goal/Event;
5. transaction commit;
6. projection trả receipt, trạng thái mục tiêu và nhật ký;
7. UI đổi layout mobile/desktop;
8. so trace và hash.

Scenario đo `input_ack_ms`, `view_ready_ms`, số message qua boundary và allocation chính.

## 8. Scenario SP-B — một ngày game

Runtime chạy một ngày game với WorkSlice 1/2/5/10 ms thật. Mỗi cấu hình phải có cùng:

- event order;
- transaction receipt;
- process remainder;
- RNG cursors;
- end state hash;
- semantic projection.

Đo p50/p95 slice, tổng thời gian, CPU, working set và UI responsiveness. W0 không dùng để tuyên bố đạt 5 giây/ngày W1.

## 9. Scenario SP-C — save và kill

Fault points:

- trước staging;
- sau blob staging;
- trước manifest publish;
- sau publish trước UI receipt;
- khi app vừa background;
- khi resume.

Mỗi fault chạy lại load pipeline, xác định generation được chọn, start/end hash và side effect không bị phát lại.

## 10. Scenario SP-D — portability

Nền tảng A export package; nền tảng B import vào slot mới. So:

- manifest/schema/content fingerprints;
- canonical uncompressed logical bytes;
- world/event/RNG hash;
- query projection;
- chạy tiếp thêm một ngày rồi so hash.

Không chỉ kiểm “mở file thành công”.

## 11. Scenario SP-E — text UI thực tế

UI spike cần có:

- danh sách 1.000 nhật ký ảo hóa/phân trang;
- mục tiêu có form và validation;
- cây cơ thể 100 node thu gọn;
- bảng vật phẩm 500 dòng;
- tìm kiếm không lộ dữ liệu bí mật;
- font scale/reflow;
- bàn phím và touch;
- screen reader/semantics tối thiểu;
- giữ vị trí đọc qua ViewDelta.

Đo view/update latency và kiểm bằng thao tác thật, không chỉ screenshot.

## 12. Scenario SP-F — tải và nhiệt

Chạy sustained loop 30 phút thật ở workload spike nhân tải có kiểm soát. Ghi CPU, memory growth, GC/pause, battery/thermal nếu API có, input latency và lag game-time.

Mục tiêu là tìm xu hướng và công cụ đo; không dùng dữ liệu W0 nhân tuyến tính để dự đoán W4.

## 13. Fingerprint bắt buộc

Mỗi run lưu:

- candidate id/version/commit;
- OS/device/architecture;
- toolchain và build mode;
- fixture/content/schema/policy hash;
- start snapshot hash;
- command/fault schedule;
- core/UI/adapter revision;
- instrumentation level;
- thermal/power state;
- raw metrics và artifact paths.

Run thiếu fingerprint chỉ dùng chẩn đoán, không chấm ADR.

## 14. Ứng viên S1 — Rust core + Tauri 2

Hình dạng:

```text
HTML/CSS/TypeScript semantic UI
        <-> typed invoke/channel
Rust Simulation Runtime
        <-> Rust storage/platform ports
Tauri shell trên mobile/desktop
```

Tauri tuyên bố phủ desktop/mobile và dùng WebView hệ thống; Rust phù hợp một core portable, kiểm soát kiểu/bộ nhớ và single writer. Message boundary khớp Command/View architecture.

## 15. Điểm mạnh giả thuyết của S1

- core native có đường hiệu năng và memory control tốt;
- ownership/type system hỗ trợ authority/read-only boundaries;
- UI web mạnh cho text, bảng, tìm kiếm và responsive layout;
- WebView không cần bundle toàn browser, có thể giảm kích thước;
- cùng Rust core/codec/hash trên mục tiêu;
- Tauri command/channel gần với ports K3.1;
- có thể test core không cần UI.

Đây là giả thuyết cần đo, không là kết luận Rust tự động deterministic.

## 16. Rủi ro cần chứng minh của S1

- Tauri mobile và plugin/lifecycle có thể ít trưởng thành hơn desktop;
- system WebView khác phiên bản làm UI/accessibility khác nhau;
- bridge JS–Rust có thể tốn serialization/copy nếu ViewDelta quá lớn;
- Rust tăng độ khó tuyển người/thời gian phát triển;
- iOS/Android plugin cần Swift/Kotlin cho capability đặc thù;
- async/task vô kỷ luật vẫn tạo nondeterminism;
- hot reload/UI tooling và debugging qua hai ngôn ngữ phức tạp hơn.

Spike phải đo bridge payload 1 KiB/100 KiB/1 MiB và lifecycle thật.

## 17. Ứng viên S2 — Dart core + Flutter

Hình dạng:

```text
Flutter widgets / semantic UI
        <-> immutable messages
long-lived Simulation Isolate
        <-> typed platform/storage adapter
Dart packages dùng chung mobile/desktop
```

Flutter chính thức phủ các nền tảng mobile/desktop chính. Isolate tách bộ nhớ và giao tiếp message phù hợp single-writer authority ngoài main UI isolate.

## 18. Điểm mạnh giả thuyết của S2

- một ngôn ngữ cho core và UI;
- một framework UI xuyên mobile/desktop;
- isolate model ép chia sẻ bằng message;
- tooling/hot reload và widget testing mạnh;
- renderer nhất quán hơn system WebView;
- platform channels/Pigeon có đường adapter có kiểu;
- FFI vẫn cho phép thay core native nếu benchmark buộc.

## 19. Rủi ro cần chứng minh của S2

- copying/transfer của projection lớn giữa isolates;
- GC/memory trong world sống dài;
- background isolate/plugin có giới hạn; unsolicited platform messages không tự do ở helper isolate;
- custom renderer cần kiểm screen reader, text selection, bảng dài;
- canonical codec/hash phải tự khóa, không dựa object serialization;
- chuyển core sang FFI sau này sẽ làm tăng hai ngôn ngữ và migration risk;
- web target không có isolate như native, nên không lấy Flutter web làm bằng chứng cho app native.

## 20. Ứng viên S3 — Kotlin + Compose Multiplatform

Hình dạng:

```text
Compose Multiplatform UI
        <-> shared immutable contracts
KMP Simulation Core
        <-> expect/actual platform adapters
JVM desktop / Android / Kotlin Native iOS
```

Tài liệu JetBrains hiện đánh dấu KMP core và Compose UI ổn định trên Android, iOS và desktop. Shared Kotlin thuận lợi cho model, codec, validation và UI semantics.

## 21. Điểm mạnh giả thuyết của S3

- code và UI dùng chung với type system mạnh;
- Android ecosystem/lifecycle integration tốt;
- Compose phù hợp UI khai báo và adaptive layout;
- expect/actual làm ranh giới platform rõ;
- JVM desktop có tooling/profile trưởng thành;
- có thể giữ core package không phụ thuộc Compose;
- native iOS không cần WebView.

## 22. Rủi ro cần chứng minh của S3

- desktop chạy JVM còn iOS chạy Kotlin/Native: runtime/GC/concurrency khác;
- canonical byte/hash và iteration order phải test chéo backend;
- Gradle/Kotlin/Compose/AGP/Xcode compatibility matrix phức tạp;
- memory/GC của world dài trên iOS và JVM có thể khác nhiều;
- accessibility/input có khác biệt platform;
- binary/startup/package size cần đo;
- một số platform API vẫn cần source set riêng.

## 23. Ứng viên dự phòng S4 — .NET MAUI

.NET MAUI chia sẻ C#/XAML/app logic và chính thức nhắm Android, iOS, macOS và Windows. Đây là ứng viên đáng giữ nếu ưu tiên C#, Windows hoặc hệ sinh thái .NET.

Điểm cần lưu ý:

- Linux desktop không nằm trong danh sách hỗ trợ chính thức nêu trên;
- macOS dùng Mac Catalyst;
- UI/lifecycle/virtualization cần đo;
- GC/AOT và canonical parity khác runtime cần kiểm;
- iOS build vẫn cần Mac;
- cộng đồng/thư viện phù hợp game simulation cần khảo sát khi vào vòng spike.

S4 vào spike nếu S1–S3 gặp blocker hoặc phạm vi sản phẩm ưu tiên Windows/.NET.

## 24. Mẫu đối chứng S0 — PWA thuần

PWA giúp kiểm tra tốc độ làm UI text, responsive layout và portability qua browser. Nó không được coi là Simulation Runtime chuẩn trước khi chứng minh:

- storage quota/durability;
- lifecycle/background/termination;
- worker availability;
- file export/import;
- memory sustained load;
- browser/version variance;
- distribution/offline trên mobile.

S0 có thể tái dùng UI prototype, nhưng không được dùng lời hứa web chung thay evidence thiết bị.

## 25. Vì sao chưa ưu tiên game engine đồ họa

Yêu cầu là text, bảng, tìm kiếm, biểu mẫu và accessibility. Một engine đồ họa thêm render loop, widget/accessibility riêng và package lớn mà chưa chứng minh lợi ích cho simulation core.

Engine chỉ trở lại shortlist nếu có nhu cầu bản đồ/hiển thị làm thay đổi trọng số hoặc spike chứng minh text/accessibility/lifecycle tốt hơn. K3.2 không tuyên bố engine không bao giờ dùng.

## 26. Ma trận phủ nền tảng trên giấy

| Ứng viên | Android | iOS | Windows | macOS | Linux | Trạng thái |
|---|---|---|---|---|---|---|
| S1 Tauri 2 | tài liệu hỗ trợ | tài liệu hỗ trợ | hỗ trợ | hỗ trợ | hỗ trợ | cần spike mobile |
| S2 Flutter | hỗ trợ | hỗ trợ | hỗ trợ | hỗ trợ | hỗ trợ | cần spike isolate/lifecycle |
| S3 KMP/Compose | stable | stable | desktop stable | desktop stable | desktop stable | cần parity JVM/Native |
| S4 .NET MAUI | hỗ trợ | hỗ trợ | hỗ trợ | Mac Catalyst | không chính thức | dự phòng |
| S0 PWA | browser | browser | browser | browser | browser | đối chứng, capability tùy browser |

“Hỗ trợ” chỉ là vendor support, chưa là game đạt U011.

## 27. Ma trận phù hợp kiến trúc trên giấy

Thang `TỐT / CẦN CHỨNG MINH / RỦI RO`, không phải điểm cuối.

| Tiêu chí | S1 | S2 | S3 | S4 |
|---|---|---|---|---|
| core tách UI | TỐT | TỐT nếu package/isolate rõ | TỐT nếu common core không Compose | TỐT nếu project core riêng |
| single writer ngoài UI | TỐT | TỐT qua isolate | CẦN CHỨNG MINH dispatcher/thread | CẦN CHỨNG MINH |
| text responsive | TỐT qua web | TỐT | TỐT | TỐT |
| cross-runtime parity | TỐT giả thuyết | TỐT giả thuyết | CẦN CHỨNG MINH JVM/Native | CẦN CHỨNG MINH JIT/AOT |
| memory control | TỐT giả thuyết | CẦN ĐO GC | CẦN ĐO GC/backend | CẦN ĐO GC |
| platform bridge | invoke/channel | channel/Pigeon | expect/actual | handler/platform API |
| Linux desktop | có | có | có | RỦI RO |
| độ phức tạp toolchain | Rust+web+native | Dart+native tools | Gradle+KMP+Xcode | .NET+native tools |

## 28. Thang chấm 0–5

| Điểm | Nghĩa |
|---:|---|
| 0 | không đáp ứng hoặc không có đường khả thi |
| 1 | workaround lớn, rủi ro không kiểm soát |
| 2 | có thể nhưng evidence yếu/chi phí cao |
| 3 | đáp ứng spike cơ bản |
| 4 | đáp ứng tốt, evidence lặp lại trên hai nền tảng |
| 5 | đáp ứng tốt, tooling/bảo trì rõ và margin tốt |

Không chấm 4–5 chỉ từ tài liệu vendor. Các ô hiện tại để trống đến khi có Run/EvidenceBundle.

## 29. Trọng số đề xuất

| Nhóm | Trọng số |
|---|---:|
| correctness + deterministic parity | 25 |
| lifecycle + save/recovery | 15 |
| W1 performance/memory path | 15 |
| text UI + accessibility + input | 15 |
| maintainability/test/tooling | 15 |
| packaging/portability/platform coverage | 10 |
| ecosystem/license/bus factor | 5 |

Trọng số chưa được người dùng chốt. Nếu chỉ phát hành Android+Windows hoặc bắt buộc iOS+Linux, điểm platform/toolchain sẽ thay đổi.

## 30. Phép đo correctness

- canonical start/end hash;
- exact event/transaction/RNG trace;
- command idempotency;
- WorkSlice/worker metamorphic parity;
- save/load continuation parity;
- cross-platform import/run parity;
- fault recovery generation;
- secret/cognitive boundary tests.

Một mismatch phải tạo first-divergence artifact, không chỉ PASS/FAIL.

## 31. Phép đo hiệu năng

- release/AOT build tương ứng;
- warm-up và cold-start tách riêng;
- p50/p95/p99 real time per scenario;
- input ack/view ready/pause/save/load;
- working set/peak/allocation/GC;
- bridge message bytes/copies;
- sustained thermal/power;
- build/package size ghi riêng, không lấn correctness.

Không so debug build của ứng viên này với release build của ứng viên khác.

## 32. Phép đo trải nghiệm phát triển

Ghi giờ và lỗi thực tế cho:

- tạo core test;
- thêm một record schema;
- thêm command/projection;
- debug first divergence;
- tích hợp lifecycle/save;
- build Android/Windows;
- build iOS khi có máy;
- nâng một phiên bản dependency;
- đọc profile memory/CPU;
- onboarding một người mới giả lập bằng checklist.

“Dễ dùng” phải có tác vụ và thời lượng, không dựa cảm giác.

## 33. Cấu trúc repository spike đề xuất

```text
spikes/                  chỉ tạo khi được phép triển khai
  shared-spec/
    fixture/
    commands/
    expected-trace/
  s1-tauri-rust/
  s2-flutter-dart/
  s3-kmp-compose/
  runner/
  evidence/
```

Mỗi candidate không được sửa shared expected để làm test của mình PASS. Đây mới là topology kế hoạch, chưa tạo thư mục/source code.

## 34. Khóa scope chống prototype giả đẹp

Mỗi spike phải có đúng:

- cùng record count và payload;
- cùng scenario/fault points;
- cùng semantic UI features;
- cùng build class;
- cùng device run window;
- cùng acceptance thresholds;
- cùng thời gian phát triển tối đa đề xuất;
- danh sách workaround/dependency riêng.

Không được bỏ save/accessibility ở một ứng viên vì “sẽ làm sau”.

## 35. Kế hoạch thực hiện prototype

| Chặng | Kết quả |
|---|---|
| PRT-0 | khóa PlatformScope, fixture, expected trace, metric protocol |
| PRT-1 | core-only runner cho S1–S3 |
| PRT-2 | Command/View UI tối thiểu Android+Windows |
| PRT-3 | save/kill/import portability |
| PRT-4 | text/accessibility/load UI |
| PRT-5 | sustained run và profiler |
| PRT-6 | cross-candidate audit, score và ADR nháp |
| PRT-7 | spike bổ sung cho tie/blocker, không thêm feature tùy ý |

Chỉ bắt đầu PRT khi người dùng yêu cầu triển khai.

## 36. Stop conditions của spike

Dừng sớm một candidate khi:

- vi phạm điều kiện loại trực tiếp và không có sửa nhỏ rõ;
- toolchain không tạo build cho platform đã khóa;
- lifecycle/save không thể kiểm soát theo K3.1;
- core bắt buộc phụ thuộc UI/runtime framework;
- canonical parity không thể quan sát/debug;
- dependency/license tạo blocker đã xác minh.

Ghi artifact và lý do; không âm thầm bỏ ứng viên.

## 37. Tie-break khi điểm sát nhau

Nếu chênh dưới 5/100:

1. ưu tiên ứng viên không có correctness/lifecycle uncertainty;
2. chạy W1-A-BOOT nhỏ thay vì thêm điểm chủ quan;
3. thử nâng dependency/toolchain một lần;
4. đo memory sustained lâu hơn;
5. kiểm một luồng accessibility thật;
6. so thời gian sửa một lỗi cố ý;
7. ghi tổng chi phí phức tạp, không chỉ runtime speed.

## 38. ADR nháp cần điền

```text
ADR-K3-STACK-001 — Runtime và UI đa nền tảng
Status: PROPOSED / ACCEPTED / REJECTED / SUPERSEDED
PlatformScope:
Constraints:
Candidates:
Disqualifiers:
Evidence fingerprints:
Weighted scores:
Decision:
Consequences:
Required mitigations:
Revisit triggers:
User decisions involved:
```

K3.2 chỉ tạo khuôn. Không đặt `ACCEPTED` trước evidence và quyết định phù hợp.

## 39. Revisit triggers

ADR phải xem lại nếu:

- platform mục tiêu đổi;
- candidate ngừng hỗ trợ một target;
- W1 không đạt margin sau tối ưu hợp lệ;
- save/parity có mismatch không giải được;
- accessibility blocker;
- toolchain/license/security thay đổi lớn;
- nhân lực dự án thay đổi làm chi phí duy trì đảo chiều;
- scope chuyển sang server/multiplayer.

## 40. Rủi ro chung không stack nào tự giải quyết

- thiết kế domain quá lớn;
- 744 điều kiện vẫn chưa có machine catalog;
- thiếu oracle độc lập;
- thiếu Mac/iPhone nếu cần iOS;
- TN01–TN08 chưa chốt;
- chưa có W1 implementation;
- save format chưa mã hóa;
- nội dung cơ thể/tu luyện/combat sâu còn mở;
- W2–W4 chưa có generator.

Chọn framework không thay thế công việc mô hình hóa và kiểm chứng.

## 41. Cổng K3.2

| Gate | Yêu cầu | Hiện tại |
|---|---|---|
| K3T01 | shortlist và nguồn chính thức | đạt trên giấy tại 2026-09-06 |
| K3T02 | cùng fixture/scenario/metric | đạt đặc tả |
| K3T03 | disqualifier/score/tie-break rõ | đạt đặc tả |
| K3T04 | ADR/revisit format rõ | đạt đặc tả |
| K3T05 | PlatformScope được chốt | chưa |
| K3T06 | S1–S3 core runs | chưa code |
| K3T07 | Android+Windows runs | chưa code/chạy |
| K3T08 | save/kill/parity evidence | chưa chạy |
| K3T09 | UI/accessibility/performance evidence | chưa chạy |
| K3T10 | ADR stack accepted | chưa quyết |

Các gate không cộng vào 64 CN.

## 42. Điều kiện CN01–CN16 — khóa scope và công bằng

| ID | Điều kiện chưa chạy |
|---|---|
| CN01 | mỗi candidate dùng đúng cùng shared fixture hash |
| CN02 | mỗi candidate nhận cùng command/fault schedule |
| CN03 | expected trace độc lập, candidate không tự sinh expected |
| CN04 | mọi run ghi đủ fingerprint bắt buộc |
| CN05 | debug và release không bị so chéo |
| CN06 | thiết bị/power/thermal window được ghi và giữ tương đương |
| CN07 | candidate thiếu scenario bắt buộc nhận NOT_RUN, không nhận điểm trung bình |
| CN08 | điều kiện loại trực tiếp thắng weighted score |
| CN09 | vendor support được ghi riêng khỏi evidence chạy game |
| CN10 | PlatformScope thay đổi làm score cũ hết hiệu lực rõ ràng |
| CN11 | workaround riêng được tính vào complexity/maintenance |
| CN12 | shared spec không phụ thuộc API của candidate |
| CN13 | cùng semantic UI feature set ở mọi spike |
| CN14 | source/version của tài liệu công nghệ được đóng dấu thời điểm |
| CN15 | unsupported OS không được báo là đã hỗ trợ |
| CN16 | spike bị dừng sớm vẫn giữ FailureArtifact và lý do |

## 43. Điều kiện CN17–CN32 — core, parity và bridge

| ID | Điều kiện chưa chạy |
|---|---|
| CN17 | S1 core-only chạy SP-A/SP-B với canonical hash |
| CN18 | S2 simulation isolate chạy SP-A/SP-B với canonical hash |
| CN19 | S3 common core chạy SP-A/SP-B với canonical hash |
| CN20 | cùng candidate lặp run không đổi trace/hash |
| CN21 | Android và Windows cùng candidate có end hash bằng nhau |
| CN22 | WorkSlice 1/2/5/10 ms giữ eventual trace/hash |
| CN23 | bridge payload 1 KiB/100 KiB/1 MiB được đo copy/latency |
| CN24 | UI restart không restart/nhân simulation authority ngoài policy |
| CN25 | stale ViewDelta bị từ chối/refresh đúng |
| CN26 | retry command qua bridge giữ idempotency |
| CN27 | platform callback không chen mutation ngoài canonical inbox |
| CN28 | iteration/map order khác backend không đổi serialization |
| CN29 | integer overflow/rounding cases cho cùng kết quả |
| CN30 | RNG streams và cursors bằng nhau chéo nền tảng |
| CN31 | first-divergence tool chỉ đúng event/field đầu lệch |
| CN32 | core test chạy headless không cần khởi tạo UI toolkit |

## 44. Điều kiện CN33–CN48 — lifecycle, save và UI

| ID | Điều kiện chưa chạy |
|---|---|
| CN33 | background/close signal dừng runtime tại boundary |
| CN34 | kill sau blob staging phục hồi generation cũ |
| CN35 | kill sau manifest publish phục hồi generation mới đúng |
| CN36 | resume không phát lại Command/Message/Transaction đã commit |
| CN37 | Android export được Windows import và chạy tiếp parity |
| CN38 | Windows export được Android import và chạy tiếp parity |
| CN39 | storage adapter không báo published trước durability contract |
| CN40 | slot lock ngăn hai writer cùng lineage |
| CN41 | danh sách 1.000 log cuộn/cập nhật trong latency budget spike |
| CN42 | cây cơ thể 100 node giữ state mở/đóng qua ViewDelta |
| CN43 | form mục tiêu dùng touch và keyboard cùng Command semantics |
| CN44 | font scale/reflow không che action bắt buộc |
| CN45 | screen reader đọc heading/label/status theo thứ tự hợp lý |
| CN46 | tìm kiếm/error không lộ entity bí mật |
| CN47 | WebView/renderer version được ghi trong evidence UI |
| CN48 | UI frame/input vẫn phản hồi khi runtime chạy sustained |

## 45. Điều kiện CN49–CN64 — hiệu năng, bảo trì và ADR

| ID | Điều kiện chưa chạy |
|---|---|
| CN49 | mỗi candidate có cold/warm startup metrics |
| CN50 | mỗi candidate có working set/peak/allocation/GC evidence |
| CN51 | sustained 30 phút không tăng memory vô hạn |
| CN52 | pause/save/load p95 được đo cùng protocol |
| CN53 | thermal/power state được ghi nếu thiết bị cung cấp |
| CN54 | profiler/instrumentation level không bị giấu khỏi báo cáo |
| CN55 | thêm một record/command/projection được đo effort thực |
| CN56 | dependency upgrade rehearsal có log lỗi/thời gian |
| CN57 | build Android/Windows tái lập từ toolchain manifest |
| CN58 | license/dependency inventory tồn tại cho finalist |
| CN59 | security boundary của bridge/platform API được review |
| CN60 | weighted score dẫn ngược tới EvidenceBundle từng ô |
| CN61 | chênh dưới 5/100 kích hoạt tie-break evidence |
| CN62 | ADR ghi hệ quả xấu và mitigation, không chỉ điểm mạnh |
| CN63 | ADR không ACCEPTED khi còn disqualifier hoặc gate bắt buộc NOT_RUN |
| CN64 | quyết định cuối giữ trigger xem lại theo platform/performance/support |

## 46. Truy vết và tổng điều kiện

| Nhóm CN | Nguồn |
|---|---|
| CN01–CN16 | K3.1 mục 43–48, VO evidence/fingerprint |
| CN17–CN32 | HD/LS/KT determinism, Command/View ports |
| CN33–CN48 | LP/KT lifecycle, portability và GIAO_DIEN |
| CN49–CN64 | HN benchmark, ADR và maintainability |

64 CN nâng tổng từ 744 lên **808 điều kiện thiết kế chưa chạy**, thuộc 29 họ.

## 47. Việc cần có trước khi thực sự chạy prototype

1. người dùng yêu cầu chuyển từ lập kế hoạch sang triển khai spike;
2. khóa PlatformScope vòng P0;
3. tạo shared machine fixture/expected trace;
4. xác định thiết bị Android/Windows dùng đo;
5. có macOS/Xcode nếu đưa iOS vào cùng vòng;
6. khóa timebox và acceptance thresholds;
7. không dùng code spike làm production core trước review.

## 48. Kết quả K3.2 và bước tiếp theo

K3.2 đã tạo trên giấy shortlist, nguồn chính thức, sáu scenario chung, fingerprint, disqualifier, score, tie-break, stop condition, ADR template và 64 CN. Chưa có candidate nào chạy hoặc thắng.

K3.3 nay đã được cụ thể hóa tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.

## 49. Trạng thái thực thi sau K5.2

Ngày 2026-09-07, [[K5_2_SPIKE_DOI_CHUNG_VA_ADR_CONG_NGHE]] đã tạo `SPIKE-V0-01` làm tập con máy đọc được. S2 Dart và S0 JavaScript cùng đạt expected trace/hash qua 500 lượt. K3T02 đạt trong phạm vi tập con; K3T08/K3T09 đạt một phần. K3T05–K3T07 và K3T10 vẫn chưa đạt. ADR chỉ PROPOSED S2 làm working stack cho V1; bảng gate ở mục 41 giữ vai trò baseline trước thực thi.
