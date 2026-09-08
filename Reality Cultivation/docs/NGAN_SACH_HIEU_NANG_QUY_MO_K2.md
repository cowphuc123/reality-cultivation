---
title: Ngân sách hiệu năng, quy mô và chiến lược đo tải — K2.7
aliases:
  - K2.7
  - Hiệu năng và quy mô
tags:
  - reality-cultivation
  - thiet-ke
  - hieu-nang
  - quy-mo
  - da-nen-tang
status: de-xuat
updated: 2026-09-06
---

# Ngân sách hiệu năng, quy mô và chiến lược đo tải — K2.7

Tài liệu này cụ thể hóa nhịp 5 giây/ngày của [[THOI_GIAN]], PacingController/R0–R4 của [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]], tác nhân xa của [[HOP_DONG_NHAN_THUC_QUYET_DINH_TAC_NHAN_K2]], lưu trữ của [[HOP_DONG_LUU_TAI_MIGRATION_PHUC_HOI_K2]] và tầng V5 của [[KE_HOACH_VALIDATOR_ORACLE_K2]]. Nó nối yêu cầu điện thoại–máy tính trong [[GIAO_DIEN]] và vòng đời dài hạn trong [[DOI_SONG_TU_SINH_K1]].

Đây là ngân sách kỹ thuật đề xuất, chưa phải kết quả benchmark hay cấu hình tối thiểu đã cam kết. Công nghệ, thiết bị chuẩn, mức thế giới thương mại và ngưỡng pin cuối cùng vẫn chưa được người dùng chốt.

## 1. Mục tiêu hiệu năng không được làm sai mô phỏng

Ở tốc độ mặc định, 86.400.000 ms game cần được giải trong khoảng 5.000 ms thật khi workload nằm trong capacity envelope của thiết bị. Nếu không kịp:

1. UI vẫn phải phản hồi;
2. world time chỉ tiến tới boundary đã giải đúng;
3. `lag_game_ms` ghi phần còn nợ;
4. scheduler giảm target horizon hoặc dừng overload;
5. không bỏ event, NPC, thương tích, Message, giao dịch hay RNG;
6. không đổi R-level/CognitiveBudget chỉ vì thiết bị chậm nếu state/policy chưa ra quyết định đó.

## 2. Mười bất biến hiệu năng

1. Hiệu năng không tham gia logic gameplay hoặc seed.
2. Máy nhanh/chậm cho cùng state logic, chỉ khác thời gian thật hoàn thành.
3. Metric/profiler bật hay tắt không đổi state hash.
4. R0–R4 là kế hoạch logic có version, không là nút chất lượng đồ họa theo thiết bị.
5. Backpressure bảo toàn event/order/remainder/idempotency.
6. Benchmark chỉ hợp lệ sau correctness gates liên quan.
7. Cache/index có thể bỏ nhưng phải tái tạo đúng.
8. Không dùng trung bình che p95/p99, spike hoặc thermal throttling.
9. Quy mô được công bố theo workload/device profile cụ thể.
10. “Hỗ trợ điện thoại và máy tính” không đồng nghĩa mọi thiết bị chạy mọi quy mô.

## 3. Ba loại ngân sách

| Loại | Ý nghĩa |
|---|---|
| `CorrectnessBudget` | không được vượt: sai số vật chất, event bị bỏ, state lệch đều bằng 0 trừ xấp xỉ R-level có hợp đồng |
| `ResponsivenessBudget` | UI/input/pause/save phải có cơ hội xử lý trong khi mô phỏng chạy |
| `CapacityBudget` | CPU time, memory, storage, energy và throughput cho workload/profile |

Khi xung đột, correctness đứng trước tốc độ. Responsiveness được giữ bằng yield/boundary, không bằng cắt logic. Capacity quyết định tốc độ thực đạt được hoặc quy mô được chứng nhận.

## 4. Đơn vị đo chuẩn

| Metric | Đơn vị/ý nghĩa |
|---|---|
| `simulation_ratio` | game_ms đã commit / real_monotonic_ms |
| `real_ms_per_game_day` | thời gian thật giải một ngày |
| `committed_events_per_real_s` | throughput tham khảo, không là mục tiêu duy nhất |
| `event_cost_ns/us` | theo type/phase, distribution |
| `slice_real_ms` | thời lượng một lát trước yield |
| `input_ack_ms` | nhận Command tới ack không gameplay |
| `view_ready_ms` | Command/view request tới projection hiển thị được |
| `pause_boundary_ms` | yêu cầu dừng tới boundary an toàn |
| `working_set_bytes` | bộ nhớ sống đo theo phương pháp profile |
| `peak_bytes` | đỉnh trong run window |
| `save/load_ms` | request tới PUBLISHED/READY_PAUSED |
| `save_bytes/journal_growth` | dung lượng và tăng theo game time |
| `energy_per_real_minute` | năng lượng tiêu thụ chuẩn hóa nếu thiết bị đo được |
| `thermal_state` | trạng thái nhiệt/throttle theo API/phương pháp profile |

Mọi metric thực dùng thời gian đơn điệu; không dùng đồng hồ tường có thể chỉnh.

## 5. WorkloadProfile

Một workload benchmark khóa:

- world/fixture/seed;
- số Person/Item/Lot/Place/Route;
- phân bố R0–R4;
- event/transaction/message/decision rate;
- active process/recurrence/goal/subscription;
- content/ruleset/policy;
- run duration game và warm-up;
- command/fault/save schedule;
- ViewProjection/UI activity;
- validator/monitor level;
- start checkpoint hash.

Chỉ ghi “10.000 NPC” không đủ: 10.000 người ngủ R4 khác 10.000 người chiến đấu R0.

## 6. Bậc workload chuẩn

| Mã | Quy mô | Mục đích |
|---|---:|---|
| `W0-MICRO` | 1–5 actor, vài record/process | đo chi phí nền và transition |
| `W1-ANKHE` | 21 người, 11 nơi, 36 loại vật, 30 ngày | lát cắt bắt buộc ban đầu |
| `W2-TOWN` | 1.000 Person liên quan | chứng minh R0–R4 địa phương/vùng |
| `W3-REGION` | 10.000 Person | tải dài hạn nhiều cộng đồng |
| `W4-WORLD` | 100.000 Person | mục tiêu nghiên cứu/kiến trúc xa |

W2–W4 cần fixture/generator riêng có bất biến, không nhân bản An Khê rồi giả đó là thế giới đa dạng. Chúng chưa là cam kết chạy 5 giây/ngày trên mọi điện thoại.

## 7. Bốn biến thể tải của mỗi bậc

| Biến thể | Nội dung |
|---|---|
| `STEADY` | lịch/routine bình thường, ít xung đột |
| `BUSY` | chợ, giao hàng, nhiều Message/Decision cùng giờ |
| `CRISIS` | thương tích, cầu hỏng, tranh nguồn, auto-pause candidate |
| `PATHOLOGICAL` | dữ liệu hợp lệ nhưng event wave/queue/memory pressure sát giới hạn |

Không dùng PATHOLOGICAL làm đại diện trải nghiệm thường. Nó xác minh backpressure và failure behavior. Báo cáo capacity phải nêu variant.

## 8. DeviceProfile thay cho tên máy tùy ý

`DeviceProfile` lưu:

- class MOBILE_MIN/MOBILE_REF/DESKTOP_MIN/DESKTOP_REF;
- OS/runtime/build/architecture;
- logical/physical core info nếu biết;
- memory available tại start;
- storage class/free space;
- battery/charging/power mode;
- thermal state và ambient band nếu đo;
- screen/refresh chỉ cho UI workload;
- calibration results;
- background/lifecycle restrictions;
- profile revision.

Tên thương mại của thiết bị là metadata, không thay các số đo. Cấu hình tối thiểu cuối cùng chỉ được chốt sau khi có benchmark thật.

## 9. Calibration workload

Trước benchmark world, chạy tác vụ không gameplay để phát hiện môi trường bất thường:

- fixed-point integer loop chuẩn;
- canonical serialization/hash mẫu;
- memory allocation/copy mẫu;
- storage write/read staging nhỏ;
- timer resolution/monotonicity;
- sustained load ngắn để thấy throttle sớm.

Calibration không dùng để chuẩn hóa kết quả gameplay hoặc tự đổi R-level. Nó gắn cờ run không so sánh được như power saver, thermal severe, thiếu storage.

## 10. Điều kiện môi trường của run

Mỗi run ghi cold/warm, plugged/battery, foreground/background, power mode, thermal start/end, app/process contention biết được và storage free.

Run release capacity cần:

- build tối ưu tương ứng người dùng;
- diagnostics ở mức đã định, không profiler xâm lấn nặng;
- ít nhất một cold load và nhiều warm simulation repetitions;
- correctness monitors bắt buộc bật;
- dữ liệu cùng fingerprint;
- không thay device setting giữa các repetition.

Dev/debug run chỉ dùng tìm lỗi, không công bố capacity.

## 11. Ngân sách W1 bắt buộc đề xuất

Các ngưỡng dưới đây là mục tiêu kỹ thuật ban đầu để kiểm chứng, chưa phải quyết định sản phẩm:

| Metric W1-ANKHE | MOBILE_MIN | DESKTOP_MIN |
|---|---:|---:|
| ngày game steady p95 | ≤ 5.000 ms thật | ≤ 5.000 ms thật |
| ngày game busy p95 | ≤ 5.000 ms thật | ≤ 5.000 ms thật |
| ngày game crisis p95 | ≤ 6.000 ms, không bỏ logic | ≤ 5.000 ms |
| input ack p95 khi chạy | ≤ 100 ms | ≤ 75 ms |
| view projection ready p95 | ≤ 250 ms | ≤ 150 ms |
| pause tới boundary p95 | ≤ 500 ms hoặc báo atomic group đang khép | ≤ 250 ms |
| working set steady | ≤ 512 MiB | ≤ 1 GiB |
| peak W1 | ≤ 768 MiB | ≤ 1,5 GiB |
| manual save PUBLISHED p95 | ≤ 2.000 ms | ≤ 1.500 ms |
| cold load READY_PAUSED p95 | ≤ 5.000 ms | ≤ 3.000 ms |
| checkpoint 30 ngày | ≤ 100 MiB | cùng định dạng logic |

Nếu số đo cho thấy ngưỡng không hợp lý, thay đổi phải tăng revision và ghi lý do; không sửa kết quả run cũ.

## 12. Ý nghĩa của p50, p95 và p99

- p50 cho trải nghiệm thường;
- p95 là ngân sách chính của nhịp/độ trễ;
- p99 hoặc max có chú giải dùng phát hiện spike;
- confidence interval/repetition count được giữ trong report;
- outlier chỉ loại theo rule có trước, không xóa vì “máy bận”.

Một ngày trung bình 4 giây nhưng cứ mười ngày có một spike 30 giây không đạt trải nghiệm 5 giây/ngày ổn định. Báo cả sustained throughput và per-day distribution.

## 13. Nhịp 5 giây/ngày

Target chính:

`simulation_ratio >= 17.280 game_ms / real_ms`

được đánh giá trên committed game time, không target đã đặt. Pause người dùng/auto-pause/IntegrityPause được loại khỏi mẫu theo event log; yield UI vẫn nằm trong wall time chạy.

Một run 30 ngày W1 mục tiêu hoàn tất trong ≤150 giây thật ở steady/busy nếu không pause theo fixture. Không được chạy một batch 150 giây khóa UI rồi báo đạt throughput.

## 14. Real-time slicing và UI responsiveness

PacingController chia computation thành `WorkSlice` có:

- start boundary/revision;
- target game instant;
- real budget;
- processed counts;
- yield reason;
- next continuation token.

Ngân sách đề xuất: mỗi slice liên tục trước cơ hội yield không quá 8 ms trên MOBILE_MIN và 12 ms trên DESKTOP_MIN trong workload giao diện hoạt động; atomic group dài hơn phải được metric riêng và giữ giới hạn thiết kế.

Yield không đổi event order. Chia một ngày thành số slice khác nhau phải cho cùng state hash.

## 15. Command latency

Tách ba mốc:

1. `input_ack`: UI/input layer đã nhận Command/key;
2. `accepted_boundary`: scheduler đóng dấu nhận ở boundary;
3. `visible_effect`: ViewProjection phản ánh gameplay sau xử lý.

Ack nhanh không được nói lệnh đã thành công. Khi simulation lag, UI hiển thị Command đang chờ và game instant hiện tại. Command không chen ngược vào pha đã đóng để giảm latency.

## 16. Pause latency

PauseRequest có priority điều phối nhưng không cắt transaction giữa commit. Báo cáo pause gồm:

- request real time;
- boundary nhận;
- atomic group/process step đang khép;
- stopped game instant;
- latency và reason.

Nếu atomic group có thể vượt ngân sách pause, đó là vấn đề thiết kế cần chia/stage hoặc giới hạn group, không được rollback nửa nhóm.

## 17. Front-end workload tách khỏi simulation

UI benchmark gồm:

- cập nhật nhật ký theo lô;
- danh sách NPC/vật có phân trang/virtualization logic;
- mở chi tiết nguồn/Belief/Contract;
- chỉnh Goal;
- hội thoại nhiều lượt;
- save slot history;
- màn hình hẹp/màn hình rộng.

Projection cache có thể khác theo thiết bị nhưng payload logic/hash phải giống. UI không được yêu cầu serialize toàn world mỗi lần render.

## 18. Bộ nhớ: resident, logical và cache

Tách:

- `canonical_state_bytes`: dữ liệu logic nếu serialize chuẩn;
- `resident_core_bytes`: record/index cần chạy;
- `cache_bytes`: có thể evict/tái tạo;
- `transient_peak_bytes`: staging save/migration/query;
- `artifact_bytes`: log/evidence ngoài runtime;
- `graphics/ui_bytes`: dù game text vẫn có runtime UI.

Chỉ báo heap không đủ. Peak migration/save phải nằm trong device envelope hoặc dùng staging strategy khác; không để OS kill app vì cần hai bản world đầy đủ mà không đo.

## 19. Ngân sách bộ nhớ theo bậc

Mục tiêu đề xuất, cần benchmark xác nhận:

| Bậc | MOBILE_REF | DESKTOP_REF | Ghi chú |
|---|---:|---:|---|
| W1 | steady ≤512 MiB, peak ≤768 MiB | steady ≤1 GiB | bắt buộc ban đầu |
| W2 | steady ≤1 GiB nếu thiết bị cho phép | steady ≤2 GiB | cổng mở rộng |
| W3 | chưa cam kết | steady ≤4 GiB đề xuất | cần R2–R4 chứng minh |
| W4 | chưa cam kết | đo capacity, chưa đặt PASS | mục tiêu nghiên cứu |

Không giữ object graph chi tiết R0 cho mọi Person ở W3/W4. Tuy vậy mỗi Person và state bắt buộc vẫn tồn tại theo representation đã chứng minh.

## 20. Memory pressure ladder

Khi memory pressure tăng:

1. ngừng prefetch/view cache mới;
2. evict cache tái tạo được có metric;
3. flush artifact/log đã được phép;
4. giảm target horizon và tạo checkpoint nếu an toàn;
5. dừng OVERLOAD_MEMORY tại boundary.

Không xóa Memory của NPC, Summary provenance, event, vật, thương tích hoặc idempotency set. Hạ R-level chỉ qua ResolutionPlan gameplay đã định, không do callback thiếu RAM.

## 21. Leak và tăng trưởng lâu dài

Benchmark 30 ngày, 1 năm, 10 năm và 100 năm game theo workload phù hợp. Theo dõi:

- resident bytes sau compaction/quiescence;
- live record count theo domain;
- tombstone/source refs;
- queue/subscription/orphan counts;
- memory per Person/Item/Event-year;
- slope và breakpoint;
- unreachable/leak candidates.

Tăng vì lịch sử thật được phân loại khác memory leak. Cả hai cần ngân sách; tóm lược không được mất nguồn sống.

## 22. Dung lượng save và journal

Đo:

- full checkpoint bytes;
- incremental generation bytes;
- journal bytes/game-day;
- bytes per Person-year;
- content-addressed dedup ratio;
- compaction input/output/time/peak memory;
- retention total theo policy;
- import/export archive bytes.

Mục tiêu W1 đề xuất: checkpoint sau 30 ngày ≤100 MiB và journal trung bình ≤5 MiB/ngày trước compaction. Đây là trần phát hiện thiết kế phình sớm, không là cam kết cuối.

## 23. Save/load trong ngân sách giao diện

Save không được khóa UI quá slice budget ngoài đoạn publish pointer nhỏ có metric. Nếu capture/write kéo dài:

- UI thấy tiến độ thật;
- world có thể pause hoặc dùng revision-pinned capture theo policy;
- bản cũ vẫn hợp lệ;
- storage pressure không tạo save nửa vời;
- lifecycle path ưu tiên checkpoint đã công bố, không hứa callback dài.

Load tách manifest listing, verify, migration, index build và validation để biết phần chậm; không bỏ hash/invariant chỉ để nhanh.

## 24. Storage pressure

Trước save, ước lượng staging + bản cũ + overhead. Nếu không đủ:

1. báo thiếu chỗ;
2. có thể dọn cache/orphan/retention được policy cho phép;
3. không xóa manual/pre-migration/branch head đang cần;
4. thử lại bằng generation mới;
5. nếu vẫn thiếu, giữ bản cũ và FAIL rõ.

Benchmark storage-full xác nhận không hỏng slot hiện tại và thời gian UI phản hồi hợp lý.

## 25. Năng lượng và pin

Pin phụ thuộc thiết bị nên K2.7 dùng hai lớp:

- normalized energy/real minute và game-day trên thiết bị đo được;
- user-facing sustained battery drain trong kịch bản chuẩn.

Mục tiêu khám phá ban đầu cho MOBILE_REF: W1 steady foreground 30 phút không tiêu quá 10% dung lượng pin danh định sau khi loại run pin/chế độ bất thường. Ngưỡng này phải được sửa bằng thiết bị thật và không dùng để tuyên bố mọi máy.

Chạy khi sạc và khi pin phải tách report. Không tự hạ logic khi pin yếu; power policy có thể giảm pacing target với thông báo, world kết quả vẫn giống.

## 26. Nhiệt và sustained performance

Benchmark burst 30 giây không đủ. Suite gồm 5, 15, 30 và 60 phút thật cho W1/W2 phù hợp, ghi thermal state và simulation ratio theo cửa sổ.

PASS sustained yêu cầu:

- không Integrity/thermal crash;
- state correctness giữ;
- p95 ở cửa sổ cuối vẫn trong ngân sách profile hoặc chuyển trạng thái giảm pacing công khai;
- không sawtooth lag tăng vô hạn;
- save/pause vẫn phản hồi dưới tải.

Không làm mát thiết bị bất thường rồi gọi đó là profile người dùng.

## 27. CPU và song song hóa

K2.7 không chọn số thread/worker. Metric phải tách:

- scheduler/phase time;
- domain handler time;
- serialization/hash;
- view/UI;
- synchronization/wait;
- parallel efficiency nếu có;
- deterministic commit time.

Song song hóa có thể tính candidate độc lập nhưng commit vẫn tuân phase/conflict policy. Số worker khác nhau phải cho cùng state hash.

## 28. Event cost model

Mỗi event type lưu distribution chi phí theo:

- handler self time và inclusive time;
- records đọc/ghi;
- allocations/bytes;
- candidate/wave fan-out;
- downstream events/messages/decisions;
- cache hit/miss;
- R-level;
- outcome status.

Không tối ưu chỉ event đắt nhất nếu event rẻ sinh hàng triệu lần. Dùng tổng contribution và fan-out.

## 29. Queue và event density

Theo dõi:

- pending count/horizon;
- due events/game-day;
- batch size cùng timestamp;
- wave depth/width;
- stale/cancelled ratio;
- recurrence materialized horizon;
- subscriptions active/woken;
- event bytes;
- processing cost theo phase.

Queue tăng tuyến tính vô hạn khi recurrence đã qua hoặc stale không được dọn là failure dài hạn, dù W1 30 ngày vẫn nhanh.

## 30. Decision và cognition cost

Metric theo agent/frame:

- wakeup/coalesce count;
- Belief/Memory candidates;
- inference depth/count;
- known options generated/evaluated;
- source/evidence traversal;
- dialogue turns/comprehension;
- frame duration/allocations;
- BLOCKED subscriptions;
- CognitiveBudget policy.

Không giảm budget vì máy yếu. Tối ưu bằng index, incremental update, coalescing và R-level đã chứng minh. Cùng policy phải xét cùng tập option logic.

## 31. Perception và không gian

Đo ObservationCandidate theo:

- entities/signals queried;
- spatial cells/routes/occluders;
- candidates rejected sớm;
- channel/capability checks;
- identity resolution;
- messages actual receivers;
- bytes/cache.

Mở rộng R0 đông người có thể tạo N×M. Workload BUSY/CRISIS phải có chợ/hội thoại/tiếng động đông để phát hiện. Không broadcast Fact cho nhanh.

## 32. Vật phẩm, lot và container cost

Đo:

- ItemInstance/Lot/ResourcePool counts;
- split/merge/quality/provenance cost;
- containment depth/fan-out;
- inventory available projection;
- conservation audit;
- transaction conflict set;
- component attach/detach;
- storage bytes.

W2–W4 dùng Lot nơi hợp nghĩa; không gộp vật khác quality/provenance chỉ để giảm record. Materialize instance xác định trước khi tương tác cá thể.

## 33. Cơ thể, thương tích và quá trình liên tục

Đo active BodyPart/Wound/Condition/Process, threshold boundaries, integration segments, remainder và derived capability invalidations.

CRISIS workload phải gồm nhiều thương tích/chăm sóc đồng thời. Không update mọi mô mỗi millisecond; tính boundary tiếp theo. Nhưng vết nguy cấp được nâng chi tiết trước outcome, không giải bằng “HP trung bình”.

## 34. Tu luyện và chiến đấu

Hai tải riêng:

- `CULTIVATION_DENSE`: nhiều người luyện, nguồn linh lực, route, adaptation/milestone;
- `COMBAT_DENSE`: nhiều R0, perception, movement, contact, defense, injury.

Combat có thể làm target 5 giây/ngày không phù hợp trải nghiệm nếu TN về pause/điều khiển chưa chốt; benchmark vẫn đo throughput và responsiveness, không tự chọn làm chậm thời gian gameplay.

## 35. Kinh tế, tổ chức và mạng xã hội

Đo transaction/day, reservations, contracts/obligations, claim disputes, market queries, organization decisions, relationships active và rumor edges.

Không tạo ma trận quan hệ đầy đủ N². Graph thưa theo lịch sử thật; benchmark báo edges per Person và fan-out. Aggregate tổ chức không có tri thức toàn tri và không thay tài sản cá nhân.

## 36. R0–R4 là representation có chứng minh

Mỗi ResolutionPlan khai báo:

- level và valid interval;
- retained invariants;
- exact/approximate fields;
- error budget theo miền;
- promotion triggers;
- demotion preconditions;
- next boundary;
- summarizer/materializer version;
- proof/oracle set đã đạt.

Handler R3/R4 chưa có parity/metamorphic evidence thì UNSUPPORTED cho workload dùng nó. Không coi ý tưởng tổng hợp là tối ưu đã hoạt động.

## 37. ErrorBudget không phải quyền bịa

Error budget chỉ áp cho đại lượng được phép xấp xỉ, có range/provenance. Bằng 0 cho:

- danh tính Person/Item quan trọng;
- tổng vật chất/tiền/năng lượng;
- quyền/nghĩa vụ/transaction committed;
- sinh/chết/đột phá và biến cố không đảo ngược;
- Message đã tới;
- RNG draw và event order bắt buộc;
- Position trước tương tác R0/R1.

Tổng sản lượng dự báo xa có thể là interval; khi giao dịch thật cần materialize lượng xác định từ state/process hợp lệ.

## 38. Promotion trước tương tác

Promotion deadline phải sớm hơn:

- P00/agent R0 tới tầm tác động;
- giao dịch/tranh nguồn xuyên vùng;
- Message có thể đổi quyết định;
- nguy hiểm, thương tích, chiến đấu;
- sinh/chết/đột phá;
- biên tuyến/vùng;
- inspection/observation chi tiết.

Đo promotion latency, peak memory và catch-up work. Nếu không materialize kịp, scheduler giảm target horizon/dừng trước event; không xử outcome bằng R4 rồi bịa chi tiết R0.

## 39. Demotion và compaction

Chỉ demote khi không có Action ngắn, signal/Observation đang truyền, Reservation/conflict, wound gần ngưỡng, DecisionFrame/Dialogue mở hoặc event không đảo ngược sắp tới.

Demotion đo:

- state bytes trước/sau;
- time/allocations;
- Summary provenance;
- next boundary/event;
- parity continuation;
- promotion round-trip.

Không lặp promote/demote do ngưỡng rung; dùng hysteresis và minimum residency theo policy.

## 40. CapacityEnvelope

Capacity report không đưa một số “NPC tối đa” duy nhất. Nó là tập:

`{DeviceProfile, WorkloadProfile, ruleset, R-distribution, target, achieved percentiles, memory, storage, energy, result}`

Các nhãn:

- `QUALIFIED_DEFAULT`: đạt correctness + nhịp + responsiveness;
- `QUALIFIED_SLOW`: đúng logic nhưng không đạt 5 giây/ngày, UI vẫn dùng được;
- `OVERLOAD_SAFE`: dừng đúng, không mất state;
- `UNQUALIFIED`: chưa chạy/FAIL/FLAKY/không đủ evidence.

Không quảng bá QUALIFIED_SLOW như đạt yêu cầu tốc độ mặc định.

## 41. Bậc quy mô và lời hứa sản phẩm

- W1 là mục tiêu bắt buộc ban đầu trên MOBILE_MIN và DESKTOP_MIN.
- W2 là cổng mở rộng ưu tiên; có thể đạt trên desktop trước nhưng save vẫn chuyển được sang mobile nếu mobile báo quy mô không đủ thay vì làm sai.
- W3 cần R2–R4, lưu dài hạn và graph thưa đã chứng minh.
- W4 là mục tiêu nghiên cứu để kiểm kiến trúc; chưa là yêu cầu phát hành đầu.

Mục tiêu dài hạn “thế giới cực sâu” được giữ. Công bố quy mô phải kèm mức chi tiết và workload thật.

## 42. Backpressure ladder

Khi `lag_game_ms`, queue, memory hoặc thermal vượt ngưỡng profile:

1. yield UI thường xuyên hơn;
2. không tăng target game horizon;
3. ưu tiên causal frontier đang tới boundary, không ưu tiên NPC theo danh tính;
4. hoàn tất atomic group;
5. công bố checkpoint/diagnostic nếu policy cho phép;
6. chuyển `DEGRADED_PACING` rồi `OVERLOAD_STOPPED`;
7. yêu cầu người dùng giảm tốc/đóng tải khác hoặc chọn world/profile phù hợp.

Không drop event hoặc xóa lag bằng cách nhảy `now_ms`.

## 43. OverloadState

| Trạng thái | Ý nghĩa |
|---|---|
| `NORMAL` | đạt target/slice budget |
| `LAGGING_RECOVERABLE` | nợ nhỏ, không tăng horizon |
| `DEGRADED_PACING` | công khai chạy chậm hơn 5 giây/ngày |
| `OVERLOAD_MEMORY` | memory pressure, đã evict cache |
| `OVERLOAD_THERMAL` | profile nhiệt yêu cầu dừng/giảm pacing |
| `OVERLOAD_CAUSAL` | wave/fan-out vượt guard |
| `STOPPED_SAFE` | boundary an toàn, world không tiến |

Transition có metric/reason/game boundary. Trạng thái overload không là Fact gameplay và không hiện bí mật debug trong view thường.

## 44. Causal storm và pathological input

Guard theo cause chain, wave depth/width, fan-out/event type và real budget. Khi vượt:

- dừng tạo wave mới;
- giữ frontier/causal refs;
- hoàn tất mutation group đang commit;
- STOPPED_SAFE;
- tạo FailureArtifact theo K2.6.

Không cắt vòng và tiếp tục world với vài event bị thiếu. Một luật tạo bão là FAIL/Unsupported, không chỉ “máy yếu”.

## 45. CachePolicy

Mỗi cache có:

- source revisions/digest;
- builder version;
- size/cost/hit metrics;
- eviction/rebuild rule;
- logical/nonlogical marker;
- validation sample.

Cache không được là nguồn sự thật duy nhất. Evict/rebuild, thay capacity hoặc tắt cache phải cho cùng state hash/trace logic. Cache cognition không được cấp tri thức vượt source refs.

## 46. Phân vùng và locality

Partition có thể theo region/domain/time horizon nhưng phải giữ:

- cross-partition event/transaction/message ordering;
- ownership/Position ref;
- atomic group hoặc coordinator contract;
- promotion trước tương tác;
- save closure;
- deterministic id/RNG.

K2.7 không chọn thread/process/server. Benchmark phải đo cross-partition traffic và hotspot; phân vùng không được biến vùng xa thành thế giới độc lập mất nợ/tin.

## 47. Benchmark suite tối thiểu

| Suite | Nội dung |
|---|---|
| `P0-MICRO` | W0 transition/cost baseline |
| `P1-30D` | W1 30 ngày steady/busy/crisis |
| `P2-SUSTAIN` | W1 30–60 phút thật, thermal/energy |
| `P3-LONG` | W1/W2 1–100 năm game, growth/compaction |
| `P4-SCALE` | W2/W3/W4 với R distribution khóa |
| `P5-SAVE` | save/load/migration/storage-full |
| `P6-BURST` | chợ, chiến đấu, rumor/decision fan-out |
| `P7-PARITY` | mobile/desktop cùng RunSpec |
| `P8-OVERLOAD` | memory/thermal/causal safe stop |

Mỗi suite phụ thuộc correctness gates của các hệ nó dùng.

## 48. BenchmarkRunSpec

Ngoài RunSpec K2.6, benchmark thêm:

- measurement start/end và warm-up;
- repetition count;
- device/environment profile;
- target metrics/budgets;
- sampling interval/overhead calibration;
- UI activity script;
- power/thermal mode;
- cooldown rule;
- allowable exclusions;
- output PerformanceEvidenceBundle.

Benchmark không tự thay seed hoặc giảm crisis event khi run chậm.

## 49. Warm-up, repetition và cooldown

JIT/cache/runtime có thể làm lượt đầu khác lượt sau dù công nghệ chưa chọn. Báo cold và warm riêng. Warm-up không làm game state nguồn thay đổi; dùng bản checkpoint mới cho mỗi repetition.

Sustained mobile cần cooldown/thermal starting band thống nhất. Không chạy lần nhanh ngay sau khi máy lạnh và bỏ các lần throttle. Repetition order có thể xoay nhưng được log.

## 50. PerformanceEvidenceBundle

Bao gồm:

- BenchmarkRunSpec/Fingerprint;
- device/calibration/environment;
- correctness GateReport refs;
- raw samples và aggregation method;
- state hashes/checkpoints;
- phase/domain/event profiles;
- memory/storage/energy/thermal timelines;
- overload/pause/save events;
- p50/p95/p99/max + confidence;
- profiler overhead notes;
- comparison baseline;
- result PASS/FAIL/ERROR/FLAKY/UNQUALIFIED.

Chỉ lưu biểu đồ không đủ; raw/summary có provenance phải có để kiểm lại.

## 51. Regression baseline

Baseline gắn đúng fingerprint family và device profile. So:

- absolute budget;
- phần trăm/absolute regression;
- confidence/noise band;
- correctness unchanged;
- workload shape unchanged.

Một tối ưu được nhận khi logic parity đạt và metric mục tiêu cải thiện hoặc đổi có giải thích. Đổi workload khiến nhanh hơn không được ghi là tối ưu cùng baseline.

## 52. Tối ưu hóa có chứng minh

Mỗi đề xuất tối ưu ghi:

- hotspot/evidence;
- invariant cần giữ;
- state/cache/algorithm boundary bị đổi;
- expected metric;
- correctness/metamorphic/parity conditions;
- before/after bundle;
- memory/storage/energy tradeoff;
- rollback.

Không tối ưu dựa trên cảm giác hoặc benchmark micro nếu workload contribution thấp. Không đưa logic đặc biệt chỉ cho fixture để đạt số.

## 53. Giới hạn quy mô mềm và cứng

- `soft_capacity`: vượt vẫn chạy đúng nhưng chậm/cảnh báo.
- `hard_safety_limit`: vượt có nguy cơ mất an toàn bộ nhớ/causal; loader/generator chặn hoặc STOPPED_SAFE.
- `content_limit`: dữ liệu chưa hỗ trợ, không liên quan hiệu năng.
- `tested_capacity`: lớn nhất đã có evidence, không đồng nghĩa hard max.

Save lớn hơn tested capacity vẫn phải được nhận diện trung thực. Không cố tải rồi âm thầm bỏ vùng/NPC.

## 54. Mã lỗi hiệu năng

| Mã | Ý nghĩa |
|---|---|
| `PERF_PROFILE_MISSING` | thiếu workload/device profile |
| `PERF_CORRECTNESS_NOT_MET` | gate logic chưa đạt |
| `PERF_TARGET_MISSED` | vượt ngân sách metric |
| `PERF_MEASUREMENT_INVALID` | môi trường/overhead/sampling sai |
| `PERF_THERMAL_INVALID` | thermal start/run ngoài profile |
| `PERF_MEMORY_LIMIT` | vượt working/peak budget |
| `PERF_STORAGE_LIMIT` | save/retention/staging vượt budget |
| `PERF_CAUSAL_STORM` | wave/fan-out guard |
| `PERF_PARITY_DIVERGENCE` | tối ưu làm lệch logic |
| `PERF_REGRESSION` | chậm/phình vượt noise/budget |
| `PERF_UNQUALIFIED_SCALE` | quy mô chưa có evidence |
| `PERF_UI_STARVATION` | simulation không yield cho UI |

## 55. Điều kiện kiểm thử HN01–HN56

1. HN01 — Máy nhanh/chậm với cùng RunSpec cho cùng state hash logic.
2. HN02 — Metric/profiler bật tắt không đổi state/event/RNG.
3. HN03 — Benchmark thiếu correctness gate không được kết luận PASS hiệu năng.
4. HN04 — Workload khóa đủ population/R-level/event/decision/save/UI shape.
5. HN05 — Chỉ ghi số NPC không được coi là WorkloadProfile đầy đủ.
6. HN06 — DeviceProfile có calibration/environment/revision, không chỉ tên máy.
7. HN07 — Run dev/debug không dùng công bố release capacity.
8. HN08 — W1 steady/busy đạt p95 5.000 ms/ngày trên profile đủ điều kiện.
9. HN09 — Crisis vượt 5 giây không được bỏ logic để đạt target.
10. HN10 — Báo p50/p95/p99/max, không dùng trung bình che spike.
11. HN11 — 30 ngày throughput không khóa UI suốt run.
12. HN12 — Chia WorkSlice khác nhau giữ cùng state hash.
13. HN13 — Command ack không bị báo thành gameplay success trước boundary.
14. HN14 — Pause đợi atomic group và ghi latency/reason đúng.
15. HN15 — UI projection không serialize toàn world mỗi lần render.
16. HN16 — Payload logic mobile/desktop giống dù cache/layout khác.
17. HN17 — Báo riêng canonical/resident/cache/transient/UI memory.
18. HN18 — Peak save/migration nằm trong envelope hoặc dừng an toàn.
19. HN19 — Memory pressure chỉ evict cache tái tạo được.
20. HN20 — Thiếu RAM không xóa NPC Memory/event/provenance/idempotency.
21. HN21 — Long run phân biệt tăng lịch sử hợp lệ với memory leak.
22. HN22 — Queue/subscription/orphan không tăng vô hạn sau recurrence đã qua.
23. HN23 — Save/journal growth báo bytes/day và bytes/Person-year.
24. HN24 — Storage-full giữ generation hợp lệ cũ và báo FAIL rõ.
25. HN25 — Save/load đo từng pha verify/migrate/index/validate/publish.
26. HN26 — Energy report tách battery/charging và ghi điều kiện thiết bị.
27. HN27 — Pin yếu chỉ đổi pacing có thông báo, không đổi logic.
28. HN28 — Sustained run đo thermal/throttle và cửa sổ cuối.
29. HN29 — Số worker khác nhau cho cùng state hash.
30. HN30 — Event cost report có count, distribution, fan-out và total contribution.
31. HN31 — Event rẻ tần suất lớn không bị che bởi bảng top self-time.
32. HN32 — Decision coalescing không đổi tập option theo cùng policy.
33. HN33 — Spatial/perception tải đông không được thay bằng broadcast Fact.
34. HN34 — Lot optimization không gộp khác quality/provenance.
35. HN35 — Body/process tối ưu boundary không bỏ threshold/remainder.
36. HN36 — Combat/cultivation workload giữ nguồn, contact và phase invariants.
37. HN37 — Social graph giữ thưa theo lịch sử, không tạo N² mặc định.
38. HN38 — Handler R-level chưa có oracle evidence giữ UNSUPPORTED.
39. HN39 — ErrorBudget bằng 0 cho vật chất, danh tính và biến cố bắt buộc.
40. HN40 — Promotion hoàn tất trước tương tác/nguy hiểm/giao dịch cần chi tiết.
41. HN41 — Promotion không kịp làm scheduler dừng trước event, không bịa outcome.
42. HN42 — Demotion giữ Summary provenance và parity continuation.
43. HN43 — Hysteresis ngăn promote/demote rung lặp.
44. HN44 — Capacity report gắn device/workload/R-distribution/version cụ thể.
45. HN45 — QUALIFIED_SLOW không bị công bố là đạt 5 giây/ngày.
46. HN46 — W2–W4 chưa có evidence không bị hứa cho mọi điện thoại.
47. HN47 — Backpressure không nhảy now, drop event hoặc giảm cognition bí mật.
48. HN48 — Overload chuyển STOPPED_SAFE tại boundary và giữ continuation.
49. HN49 — Causal storm tạo artifact và không tiếp tục với event bị cắt.
50. HN50 — Cache evict/rebuild/tắt giữ cùng logic.
51. HN51 — Partition giữ cross-region transaction/message/event ordering.
52. HN52 — Benchmark repetition bắt đầu cùng checkpoint và ghi warm/cold riêng.
53. HN53 — PerformanceEvidenceBundle giữ raw sample, aggregation và state refs.
54. HN54 — Regression so cùng workload/fingerprint và không accept bằng đổi tải.
55. HN55 — Tối ưu chỉ được nhận sau correctness/metamorphic/parity evidence.
56. HN56 — Vượt tested capacity báo đúng, không âm thầm bỏ vùng/NPC.

Thêm 56 HN vào 628 điều kiện trước đó thành **684 điều kiện thiết kế chưa chạy bằng validator/mô phỏng/benchmark**.

## 56. Giới hạn và bước tiếp theo

K2.7 chưa có thiết bị chuẩn, benchmark executable, raw sample, ngưỡng sản phẩm cuối, thuật toán R0–R4 đã chứng minh hay capacity thực tế. Các mức 21/1.000/10.000/100.000 và ngân sách W1 là bậc đo đề xuất, không phải lời hứa phát hành.

Gói K2.1–K2.7 đã được rà tại [[KIEM_TOAN_DONG_GOI_K2]]; kiến trúc nằm tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
