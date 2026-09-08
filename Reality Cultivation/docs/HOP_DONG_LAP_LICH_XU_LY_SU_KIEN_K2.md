---
title: Hợp đồng bộ lập lịch và xử lý sự kiện — K2.2
aliases:
  - K2.2
  - Bộ lập lịch sự kiện
tags:
  - reality-cultivation
  - thiet-ke
  - thoi-gian
  - su-kien
status: de-xuat
updated: 2026-09-06
---

# Hợp đồng bộ lập lịch và xử lý sự kiện — K2.2

Tài liệu này cụ thể hóa phần thời gian của [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]], kế thừa [[THOI_GIAN]], [[LUOC_DO_TRANG_THAI]], lịch [[LICH_21_NGUOI_K1]] và sổ [[SO_SU_KIEN_30_NGAY_K1]]. Nó định nghĩa ý nghĩa logic của hàng đợi, sự kiện lặp, quá trình liên tục, tám pha, sự kiện đồng thời, ngắt và quá tải.

Đây là đề xuất thiết kế, chưa phải mã nguồn hay bộ mô phỏng đã chạy. Cấu trúc hàng đợi trong bộ nhớ, luồng xử lý, ngôn ngữ và thư viện vẫn chưa được chọn.

## 1. Mục tiêu bắt buộc

Bộ lập lịch phải bảo đảm:

1. Thế giới chỉ tiến tới một mốc đã xác định, không bỏ qua biến cố quan trọng.
2. Mỗi ScheduledEvent được xét đúng một lần hoặc kết thúc có lý do.
3. Quá trình liên tục được tích phân chính xác theo đoạn và giữ phần dư.
4. Các sự kiện cùng thời điểm đọc cùng trạng thái thích hợp, không thắng theo id.
5. Giao dịch chỉ cam kết ở pha 50 sau khi quyền/tài nguyên đã được phân xử.
6. Sự kiện cũ không tác động bản ghi đã đổi revision.
7. Command, tạm dừng và quá tải không làm đổi kết quả logic.
8. Cùng snapshot/seed/policy/command stream cho cùng FactEvent trên điện thoại và máy tính.

## 2. Ba loại thời gian không được trộn

| Loại | Trường | Vai trò |
|---|---|---|
| Thời gian game | `GameInstant` ms | nguồn thứ tự và diễn biến thế giới |
| Thời gian thật đơn điệu | `RealMonotonicTime` | điều phối tốc độ, đo hiệu năng; không lưu thành Fact |
| Lịch hiển thị | ngày/giờ/mùa suy từ epoch | giao diện và recurrence theo lịch |

Không dùng giờ hệ điều hành để quyết định sự kiện game. Thay đồng hồ máy, đổi múi giờ hoặc mở ở thiết bị khác không làm `now_ms` đổi.

Ở tốc độ mặc định, bộ điều phối đặt ngân sách để 86.400.000 ms game tiến trong 5.000 ms thật khi máy đủ sức và không dừng. Nếu máy không đủ sức, thế giới chậm lại hoặc dừng quá tải; không bỏ event để giữ con số 5 giây.

## 3. SchedulerState

| Trường | Kiểu | Ý nghĩa |
|---|---|---|
| `now_ms` | `GameInstant` | mốc đã hoàn tất đến ranh giới hiện tại |
| `current_phase` | 10–80 hoặc BOUNDARY | pha đang mở |
| `current_wave` | số nguyên không âm | vòng nhân quả trong một pha |
| `queue_root` | tham chiếu hàng đợi logic | mọi event PENDING |
| `recurrence_cursors` | map rule→cursor | lần kế tiếp chưa vật chất hóa |
| `active_process_refs` | tập ProcessInstance | quá trình cần tích phân |
| `subscriptions` | map trigger key→consumer | đánh thức không cần polling |
| `pending_commands` | command theo thời điểm nhận | chỉ áp ở pha 80 |
| `pause_state` | RUNNING/PAUSE_REQUESTED/PAUSED | trạng thái điều phối |
| `overload_state` | CLEAR/WARNING/STOPPED | không thay luật mô phỏng |
| `causal_budget` | giới hạn wave/event cùng mốc | bắt vòng lặp dữ liệu |
| `last_committed_group` | group id/hash | phục hồi và kiểm toán |

`now_ms` chỉ tăng sau khi toàn bộ pha của mốc đã khép hoặc snapshot giữ chính xác pha/wave dang dở. Đề xuất lát cắt đầu chỉ lưu ở BOUNDARY.

## 4. EventQueueEntry

| Trường | Kiểu | Quy tắc |
|---|---|---|
| `event_id` | `Ref<ScheduledEvent>` | duy nhất |
| `due_ms` | `GameInstant` | không nhỏ hơn mốc cho phép |
| `phase` | enum 10–80 | event type đăng ký pha hợp lệ |
| `event_type` | mã + version | xác định payload/handler contract |
| `payload` | record có schema | không dùng text tự do |
| `caused_by` | Event/Action/Process/Command/Init | nguồn bắt buộc |
| `correlation_id` | id chuỗi nghiệp vụ | nhóm giao dịch/hành động |
| `expected_revisions` | map Ref→Revision | stale guard |
| `idempotency_key` | khóa trong world | chống thêm/chạy lặp |
| `same_time_policy` | LATER_PHASE/NEXT_WAVE/FORBIDDEN | luật phát sinh cùng mốc |
| `status` | PENDING/CANCELLED/CONSUMED/CONSUMED_WITHOUT_EFFECT | vòng đời |

Các trường kỹ thuật dùng để tìm event nhanh không thuộc ý nghĩa logic và không được vào state hash nếu có thể xây lại hoàn toàn.

## 5. Khóa thứ tự và nhóm đồng thời

Khóa tìm mốc nhỏ nhất là `(due_ms, phase)`. Tất cả event có cùng hai giá trị tạo một `EventBatch`. Event id chỉ dùng chuẩn hóa serialization, không quyết định kết quả tranh chấp.

Trong một batch:

- event độc lập có thể tính song song nhưng phải đọc cùng `phase_input_snapshot`;
- event sửa bản ghi chung đi vào cùng ConflictSet;
- policy của nguồn/quyền quyết định thắng, chia hoặc chờ;
- nếu policy không đủ, toàn ConflictSet bị từ chối/chờ rõ;
- kết quả batch được gộp trước khi commit.

Không có trường `priority` chung cho mọi event. Ưu tiên nghiệp vụ nằm trong Contract, Right, ResourcePool hoặc ConflictPolicy có nguồn.

## 6. Vòng đời ScheduledEvent

```text
CREATED → PENDING → CLAIMED_FOR_BATCH
                    ├─ CONSUMED
                    ├─ CONSUMED_WITHOUT_EFFECT
                    └─ PENDING lại chỉ khi batch chưa commit
PENDING → CANCELLED
```

`CLAIMED_FOR_BATCH` là trạng thái xử lý tạm, không cho worker khác lấy cùng event. Sau lỗi trước commit, batch có thể thử lại từ cùng snapshot mà không rút RNG mới. Sau commit, event không quay lại PENDING.

`CONSUMED_WITHOUT_EFFECT` cần reason như `STALE_REVISION`, `PRECONDITION_FALSE`, `TARGET_ENDED`, `SUPERSEDED` hoặc `FEATURE_UNSUPPORTED`. Nó vẫn tạo AuditResult; có tạo FactEvent cho người trong thế giới hay không tùy có hiện tượng quan sát được.

## 7. Thêm sự kiện và chống quá khứ

Khi đang ở `(t, phase p, wave w)`:

| Event mới | Kết quả |
|---|---|
| `due_ms > t` | thêm PENDING bình thường |
| `due_ms = t`, phase > p | vào batch pha sau cùng mốc |
| `due_ms = t`, phase = p | chỉ NEXT_WAVE nếu event type cho phép |
| `due_ms = t`, phase < p | từ chối `PHASE_ALREADY_CLOSED` |
| `due_ms < t` | từ chối `SCHEDULE_IN_PAST` |

Không âm thầm đổi event sai thành `t+1 ms`, vì điều đó làm thay đổi vật lý và thứ tự. Handler phải chọn mốc hợp lệ hoặc sửa quy tắc nguồn.

## 8. Wave nhân quả trong cùng pha

Wave dùng cho chuỗi cùng pha thật sự cần thiết, ví dụ Observation A đánh thức một phép gom Message ở pha 70.

1. Wave 0 chứa event đã có khi mở pha.
2. Mọi event wave đọc snapshot sau wave trước đã commit theo hợp đồng của pha.
3. Event mới cùng pha đi wave `w+1` và phải khai báo `NEXT_WAVE`.
4. Mỗi event lưu `causal_parent` và `causal_depth`.
5. Vượt giới hạn wave/event tại cùng mốc làm scheduler dừng `CAUSAL_LOOP`, giữ snapshot chẩn đoán.

Không dùng wave để lách thứ tự tám pha. Một quyền được cấp ở pha 50 không thể quay lại thắng tranh nguồn của pha 30 cùng mốc.

## 9. RecurrenceRule

| Trường | Kiểu | Ý nghĩa |
|---|---|---|
| `recurrence_id/version` | id + version | quy tắc bất biến theo version |
| `owner_id` | Person/Organization/Process | chủ lịch |
| `anchor_ms` | GameInstant | gốc tính, chống trôi |
| `kind` | FIXED_INTERVAL/CALENDAR/SEQUENCE | cách sinh lần kế |
| `period` | Duration hoặc calendar spec | không dùng float |
| `phase/event_template` | mẫu event có schema | payload mỗi lần |
| `start/end/count` | biên có cấu trúc | end loại trừ nếu là instant |
| `exception_refs` | SKIP/REPLACE/MOVE | không sửa rule gốc |
| `cursor_index` | lần nhỏ nhất chưa sinh | lưu/tải bắt buộc |
| `materialization_horizon` | số lần/khoảng | tối ưu, không đổi kết quả |

Fixed interval tính `anchor + index × period`, không lấy thời điểm lần trước cộng dồn để tránh trôi. Calendar recurrence dùng lịch thế giới có version, không dùng lịch hệ điều hành.

## 10. Ngoại lệ và thay lịch lặp

| Loại | Tác dụng |
|---|---|
| `SKIP_OCCURRENCE` | bỏ đúng index, tạo lý do |
| `MOVE_OCCURRENCE` | vô hiệu event cũ, tạo event mới có nguồn |
| `REPLACE_OCCURRENCE` | thay template/payload đúng lần |
| `END_SERIES` | kết thúc từ biên xác định |
| `SUSPEND_UNTIL_TRIGGER` | không sinh thêm cho tới trigger |

Ngoại lệ khớp bằng recurrence id + occurrence index, không bằng câu mô tả “ngày thứ sáu”. Khi base version đổi, overlay phải kiểm lại index/mốc.

Mỗi occurrence có idempotency key suy từ world, recurrence, version và index. Mở rộng horizon hai lần không tạo event trùng.

## 11. Materialization vừa đủ

Không cần tạo trước hàng triệu bữa ăn cho nhiều thế hệ. Scheduler giữ rule + cursor và vật chất hóa đủ để:

- biết event gần nhất;
- khóa các cam kết/nguồn cần đặt trước;
- hiển thị lịch trong cửa sổ người chơi biết;
- tạo snapshot có thể tái hiện.

Thay đổi horizon không đổi tập event cuối cùng trong cùng cửa sổ. Event đã vật chất hóa không tự đổi khi template mới xuất hiện; cần migration hoặc invalidation có version.

## 12. Trigger và subscription thay cho polling

Một kế hoạch chờ đăng ký `TriggerSubscription`:

| Trường | Nội dung |
|---|---|
| `subscriber_id` | Goal/Action/Decision/Process |
| `trigger_kind/key` | người trở lại, kho đổi, Message tới, deadline… |
| `predicate` | điều kiện hẹp có kiểu |
| `not_before/not_after` | cửa sổ |
| `delivery_phase` | thường 70 hoặc 80 |
| `once/repeating` | chống đánh thức lặp |
| `last_seen_revision` | chỉ phản ứng với đổi mới |

Không lập event “kiểm lại mỗi mili giây”. Nếu không có trigger tự nhiên, dùng mốc recheck có khoảng cách và backoff đã định.

## 13. ProcessInstance cho quá trình liên tục

| Trường | Kiểu |
|---|---|
| `process_id/type/version` | typed id |
| `subject_refs` | người/vật/nguồn/tuyến |
| `started_at`, `last_integrated_at` | instant |
| `status` | ACTIVE/PAUSED/ENDED/INVALIDATED |
| `rate_segments` | hàm từng đoạn bằng tỉ lệ nguyên |
| `state_inputs+revisions` | đầu vào tốc độ |
| `accumulators` | lượng đã tích + remainder |
| `next_boundary_ms` | mốc tốc độ/điều kiện có thể đổi |
| `stop_predicates` | cạn, đầy, tới đích, mất năng lực… |
| `output_contract` | mutation/event được phép tạo |

Ví dụ: di chuyển, đói/khát, ngủ, lành vết thương, nguồn nước chảy, linh khí bổ sung, thao tác công việc.

## 14. Tích phân đoạn bằng số nguyên

Với rate `numerator / denominator` đơn vị mỗi ms và khoảng `dt`:

`raw = previous_remainder + numerator × dt`

`delta = floor(raw / denominator)`; `new_remainder = raw mod denominator` theo quy ước dấu của miền.

Không tích phân qua một boundary nơi rate/precondition đổi. Scheduler chọn mốc gần nhất giữa event queue, process boundary, target và pause barrier. Nếu delta chạm 0/capacity/đích giữa đoạn, process phải cung cấp chính xác `next_internal_boundary` để dừng tại đó.

## 15. Hợp đồng bước tiến thời gian

Để tiến từ BOUNDARY `now=t0` tới `target`:

1. Thu nhận Command đã tới và yêu cầu pause hệ thống.
2. Vật chất hóa recurrence đủ nhìn tới candidate kế.
3. Tìm `t1 = min(target, next_event, next_process_boundary, pause_barrier)`.
4. Pha 10 tích phân mọi process từ t0 tới t1 trên input revision hợp lệ.
5. Mở lần lượt pha 20→80 tại t1, kể cả khi không có event nhưng boundary cần xử lý.
6. Sau mỗi pha, kiểm lỗi và causal budget; không công bố state nửa commit.
7. Khép group, cập nhật `now_ms=t1`, state hash và metric.
8. Nếu t1 < target và chưa pause/overload/error, lặp.

Target không buộc scheduler nhảy qua event. `advance_to` có thể kết thúc sớm vì auto-pause, lỗi, unsupported hoặc ngân sách thật.

## 16. Hợp đồng tám pha

### Pha 10 — INTEGRATE

Tích phân Position, tiến độ, nguồn và quá trình sinh lý đến t. Chỉ dùng rate của đoạn `[previous,t)`. Không áp tác động tức thời dự kiến tại t.

### Pha 20 — EXPIRE

Đóng quyền, hiệu ứng, reservation và interval kết thúc ở t. Event hết hạn được xét trước tranh nguồn pha 30.

### Pha 30 — VALIDATE_AND_ARBITRATE

Kiểm precondition, quyền, revision, vị trí, nguồn và tạo ConflictSet. Kết quả là candidate accepted/rejected/deferred; chưa đổi vật thật.

### Pha 40 — SNAPSHOT_AND_RESOLVE

Chụp `impact_input_snapshot`, giải tác động đồng thời, RNG hợp lệ và tạo MutationPlan. Hai đòn cùng mốc không đọc thương tích do đòn kia vừa gây.

### Pha 50 — COMMIT

Cam kết Transaction/MutationPlan nguyên tử, tăng revision và tạo FactEvent gốc. Đây là pha duy nhất đổi ownership/lượng/quyền tức thời đã phân xử.

### Pha 60 — COMPLETE_AND_ACTIVATE

Đóng Action/process đạt mốc và kích hoạt hiệu ứng duy trì mới. Hiệu ứng hoàn tất đúng t không bảo vệ tác động đã giải ở pha 40.

### Pha 70 — OBSERVE_AND_DERIVE

Tính capability/cache dẫn xuất, xác định tín hiệu, tạo Observation/Message delivery và cảnh báo có nguồn. Không chạy quyết định chọn việc ở đây.

### Pha 80 — DECIDE_AND_SCHEDULE

Nhận Command, đánh thức Goal/DecisionFrame, chọn/cam kết bước kế và tạo event tương lai. Không quay lại sửa kết quả pha đã đóng.

## 17. ConflictSet và tranh nguồn

ConflictSet nhóm candidate đụng cùng tài nguyên hoặc bất biến:

| Trường | Ý nghĩa |
|---|---|
| `conflict_id` | duy nhất trong batch |
| `resource_refs` | vật, slot, capability, quyền, Position hoặc lượng |
| `candidate_refs` | các ý định giao dịch/hành động |
| `input_revision_digest` | cùng snapshot pha 30 |
| `policy_id/version` | luật phân xử có nguồn |
| `outcome` | winners, shares, waiting, rejected |
| `explanation_refs` | lý do audit và phần được phép công khai |

Policy cho lát cắt gồm: quyền ưu tiên rõ, cam kết hợp lệ sớm hơn, vòng luân phiên đã lưu, chia theo lượng và từ chối nếu không phân xử được. Không có fallback “id nhỏ thắng”.

## 18. Giao dịch đồng thời và bất biến

Sau phân xử, các MutationPlan độc lập có thể commit trong cùng logical batch. Nếu chúng cùng sửa một record, phải gộp bằng rule giao hoán được chứng minh hoặc nằm trong một Transaction chung.

Ví dụ hai người mua món cuối:

- cả hai đọc cùng tồn kho ở pha 30;
- ConflictPolicy chỉ chấp nhận một Reservation/Transaction;
- người còn lại nhận failure có nguồn sau pha 50/70;
- không chạy người A xong rồi cho B thấy một “thế giới trước” khác trong cùng nhóm.

Tổng bảo toàn được kiểm trên toàn commit group, không chỉ từng mutation nếu có chuyển nhiều bên.

## 19. ScheduledEvent stale và invalidation

Event mang expected revision của Action/process/target. Khi mismatch:

1. handler không áp effect;
2. event thành `CONSUMED_WITHOUT_EFFECT:STALE_REVISION`;
3. nếu mốc cũ có ý nghĩa quan sát được, tạo Fact/Audit phù hợp;
4. Action mới phải đã có event thay hoặc trigger để tránh treo;
5. không tự sao chép payload event cũ sang record mới.

Thay tốc độ hành trình tăng revision, vô hiệu arrival cũ và tạo arrival mới từ quãng còn lại. Chữa lành mô mới không dùng completion event của vết thương version cũ.

## 20. Hủy, hoãn và dời sự kiện

`cancel_event` cần actor/system authority, reason, expected status/revision và caused_by. CANCELLED không bị xóa khỏi audit index.

Hoãn là hai thao tác nguyên tử trong cùng correlation:

- hủy/vô hiệu occurrence cũ;
- tạo occurrence mới với due_ms và cause rõ.

Nếu event đại diện nghĩa vụ, dời lịch không tự dời deadline Contract. Cần amendment/Right riêng.

## 21. Action và scheduler

| Chuyển trạng thái | Event/pha |
|---|---|
| WAITING→READY | trigger/precondition ở 70/80 |
| READY→RUNNING | reserve + START transaction ở 30–60 |
| RUNNING tiến độ | Process pha 10 |
| RUNNING→STOPPING | interrupt ở 80 hoặc mất capability |
| STOPPING→SUSPENDED/CANCELLED | safe-stop completion ở 60 |
| RUNNING→COMPLETED | completion candidate 30–60 |
| bất kỳ→FAILED | Fact + failure contract, không xóa hậu quả |

Action đang chạy chiếm capability/resource qua record thật. Hai Action chính không cùng giữ độc quyền một capability. Quá trình thụ động chỉ chạy song song nếu resource contract cho phép.

## 22. Hành trình và Position liên tục

MovementProcess lưu route, hướng, distance, speed segment, load/body revisions và arrival event. Pha 10 cập nhật distance; tới gate tạo candidate chuyển `ON_ROUTE→AT_PLACE`.

Đổi tốc độ do thương tích/tải:

1. tích phân đến đúng mốc thay đổi;
2. tăng process revision;
3. vô hiệu arrival cũ;
4. tính quãng còn và arrival mới bằng rate mới;
5. nếu speed=0, đăng ký trigger phục hồi/thay tuyến thay vì event lặp thất bại.

Vật/người trên tuyến không ở cả hai đầu. Đường đóng không dịch chuyển thực thể đã đi; policy quyết định dừng, quay lại hoặc tiếp tục theo vị trí thật.

## 23. Nhu cầu, hồi phục và nguồn liên tục

Hunger/thirst/sleep pressure, healing, decay, inflow và spirit flow đều dùng ProcessInstance nhưng có boundary riêng:

- ngưỡng tạo cảm giác/Observation;
- ngưỡng đổi capability;
- cạn/đầy nguồn;
- thay môi trường, hoạt động hoặc cơ thể;
- deadline chăm sóc.

Không tạo event mỗi giây cho một thanh nhu cầu. Tính mốc vượt ngưỡng kế tiếp và tích phân tới đó. Nếu cơ chế sâu chưa có dữ liệu, UnsupportedGuard dừng feature thay vì dùng rate ngầm.

## 24. Tạo Observation và Message ở pha 70

FactEvent không tự truyền tới mọi người. `ObservationCandidate` xét:

- Position/khoảng cách/che chắn;
- kênh giác quan và capability;
- focus/attention đang bị chiếm;
- cường độ/chất lượng tín hiệu;
- quyền truy cập hồ sơ nếu là đọc;
- thời lượng tín hiệu và phần người đó thật sự có mặt.

Observation tạo proposition fragments, không nhất thiết nhận diện nguyên nhân/danh tính. Message delivery chỉ tới actual receiver đã nghe/đọc/hiểu theo năng lực. Việc tạo Belief/Memory tiếp theo giữ source chain.

## 25. Command và quyết định ở pha 80

Command nhận trong lúc mô phỏng một batch được đóng dấu ở ranh giới tiếp nhận, không chen ngược vào pha 30–70 đã chạy. Pha 80:

1. chống lặp idempotency key;
2. kiểm issuer/target/policy;
3. tạo/sửa Goal hoặc yêu cầu hợp lệ;
4. đánh thức DecisionFrame liên quan;
5. lên lịch Action/event sớm nhất không ở pha đã đóng;
6. tạo phản hồi chỉ từ điều P00 được biết.

Chính sách P00 vẫn phụ thuộc TN03. Scheduler chỉ thực thi policy version được gắn, không tự chọn mức chống lệnh.

## 26. Tạm dừng và tự dừng

`PauseRequest` có source, requested_at_real, observed_game_boundary, reason và policy version. Dừng người dùng không phải FactEvent gameplay.

Hai loại:

- **Integrity pause:** lỗi, causal loop, invariant fail, thiếu dữ liệu; luôn dừng ở ranh giới an toàn.
- **Experience auto-pause:** nguy hiểm/decision cần người chơi; chỉ bật nếu policy TN01 tương ứng được chọn và trigger dựa trên Observation của P00.

Nếu yêu cầu pause đến giữa commit, hoàn tất transaction group rồi dừng. Không để trạng thái tiền đã trừ/hàng chưa chuyển.

## 27. Điều phối 5 giây/ngày

`PacingController` giữ:

| Trường | Vai trò |
|---|---|
| `game_ms_per_real_ms` | 17.280 ở tốc độ mặc định |
| `real_budget_per_slice` | thời gian tính trước khi trả UI |
| `target_game_ms` | đích logic tạm thời |
| `lag_game_ms` | phần chưa mô phỏng, không phải thời gian đã qua |
| `yield_reason` | UI, pause, overload, target reached |

Mỗi lát xử lý có thể kết thúc sớm để giao diện phản hồi. Lần sau tiếp tục từ BOUNDARY và cùng hàng đợi. Chia một ngày thành 1, 10 hay 1.000 lát thật phải cho cùng kết quả logic.

## 28. Quá tải và backpressure

Theo dõi số event, wave, transaction, process boundary, thời gian thật và bộ nhớ trên mỗi khoảng game. Khi vượt ngưỡng:

1. ngừng đặt target xa hơn;
2. hoàn tất atomic group hiện tại;
3. lưu diagnostic + state hash + queue head;
4. chuyển `overload_state=STOPPED`;
5. báo miền gây tải mà không làm lộ bí mật gameplay trong view thường.

Không được tự bỏ NPC, gộp thương tích, xóa Message hoặc đổi R-level để cứu tốc độ nếu policy chưa cho phép.

## 29. Mức mô phỏng xa R0–R4

Mỗi vùng/chủ thể có `ResolutionPlan` với level, valid interval, error budget, retained invariants và next boundary. Hạ mức chỉ dùng handler đã chứng minh bảo toàn đúng đại lượng cần giữ.

Trước tương tác nguy hiểm, giao dịch xuyên vùng, gặp P00 hoặc biến cố được theo dõi, scheduler nâng mức **trước** mốc sự kiện. Nâng mức vật chất hóa trạng thái từ aggregate có provenance; không bịa cuộc gặp, vết thương hoặc vật cá thể trong quá khứ.

K1 dùng vùng nhỏ ở mức chi tiết; R0–R4 vẫn là interface cho tương lai, chưa dùng để tuyên bố tối ưu đã hoạt động.

## 30. Lưu/tải và ranh giới scheduler

Snapshot BOUNDARY phải giữ:

- now, phase=BOUNDARY, queue logic và recurrence cursors;
- active processes, last_integrated_at và remainder;
- subscriptions, pending commands đã nhận;
- event statuses/idempotency keys/applied transactions;
- RNG cursors và random draws đã cam kết;
- pause/overload reason;
- state hash, ruleset/content/policy/fixture versions.

Khi tải: validate → migrate → xây index → kiểm queue head/process boundary → kiểm invariant/hash → mới chạy. Không materialize recurrence hoặc rút RNG theo cách khác chỉ vì cấu trúc index mới.

## 31. Sự kiện khi ứng dụng đóng

TN02 chưa được chốt. Scheduler hỗ trợ hai policy có version:

| Policy | Khi mở lại |
|---|---|
| `OFFLINE_STOP` | now giữ nguyên; chỉ thời gian thật thay đổi ngoài state gameplay |
| `OFFLINE_CATCHUP` | tạo CatchupRequest có giới hạn, mô phỏng đầy đủ từ snapshot; không cộng thẳng số ngày |

K1 đề xuất `OFFLINE_STOP` cho lát cắt đầu nhưng chưa được người dùng xác nhận. Nếu dùng CATCHUP, nguy hiểm, auto-pause, quá tải và cái chết phải có quy tắc riêng trước.

## 32. Chẩn đoán và metric không đổi logic

Metric đề xuất:

- event processed/consumed-stale/cancelled theo type;
- batch, conflict set, wave và causal depth;
- process integration segments;
- queue size/horizon;
- transaction commit/reject;
- game_ms xử lý trên real_ms;
- snapshot size và state hash time;
- auto-pause/overload counts.

Metric/log không được tiêu RNG, tạo Observation, đổi revision hoặc làm khác kết quả khi bật/tắt. ID metric không dùng làm source gameplay.

## 33. Mã lỗi scheduler

| Mã | Ý nghĩa | Phản ứng |
|---|---|---|
| `SCHEDULE_IN_PAST` | due < now | từ chối tạo event |
| `PHASE_ALREADY_CLOSED` | chen vào pha trước cùng t | từ chối, dừng fixture nếu bắt buộc |
| `SAME_PHASE_FORBIDDEN` | thiếu NEXT_WAVE contract | từ chối |
| `CAUSAL_LOOP` | vượt wave/event budget | integrity pause |
| `STALE_REVISION` | target đã đổi | consumed without effect |
| `DUPLICATE_IDEMPOTENCY_KEY` | event/transaction trùng | trả kết quả cũ hoặc lỗi dữ liệu |
| `UNRESOLVED_CONFLICT` | thiếu policy phân xử | defer/reject rõ |
| `PROCESS_BOUNDARY_MISSED` | tích phân vượt mốc nội bộ | invariant fail |
| `NEGATIVE_DURATION` | interval sai | lỗi tải/tạo |
| `QUEUE_HEAD_INCONSISTENT` | index khác event thật | xây lại rồi đối chiếu; dừng nếu vẫn lệch |
| `UNSUPPORTED_EVENT_TYPE` | thiếu handler contract | UnsupportedGuard |
| `OVERLOAD_STOP` | vượt ngân sách an toàn | dừng ở boundary |

Audit error toàn tri tách khỏi lời giải thích cho P00.

## 34. Bốn walkthrough chuẩn

### 34.1 Bữa ăn lặp

Rule bữa tối neo ngày 1 18:00, period một ngày. Cursor sinh occurrence riêng; Action ăn kiểm Position, suất V02 và capability. Nếu giao hàng trễ, occurrence không tự cấp suất: conflict/precondition dẫn tới chờ, thất bại hoặc kế hoạch mới.

### 34.2 Mua V02 lúc 17:05 ngày 6

P00 và N06 có Action giao dịch. Pha 30 kiểm tiền, hàng, quyền, vị trí; pha 50 chuyển V01/V02 nguyên tử; pha 60 đóng Action; pha 70 tạo Observation/Message; pha 80 cập nhật Goal. Mở bảng quầy không tham gia chuỗi.

### 34.3 Bị thương giữa hành trình

Pha 10 đưa người tới vị trí đúng tại mốc chấn thương. Pha 40–50 áp tác động; pha 70 tính capability mới; pha 80 tăng revision MovementProcess, vô hiệu arrival cũ và lên lịch lại. Event arrival cũ sau đó thành stale, không dịch chuyển người.

### 34.4 Hai tác động cùng mốc

Hai impact event cùng t/pha 40 đọc một impact snapshot. Cả hai kết quả được gộp, Transaction pha 50 áp hậu quả; bên bị tác động không mất đòn chỉ vì record thương tích của đòn kia commit trước trong serialization.

## 35. Ánh xạ FX-A-30D

| Dữ liệu K1 | Hợp đồng K2.2 |
|---|---|
| lịch nước/ăn/ngủ | RecurrenceRule + occurrence exceptions |
| hành trình theo phút | MovementProcess + arrival revision |
| J01 ngày 1–8 | Contract-triggered Action + completion event |
| mua ngày chẵn | Goal/schedule occurrence + Transaction batch |
| nhận suất trước N05 | Action/Position thật + allocation_for_day |
| C01 ngày 10 | Obligation deadline + payment Transaction |
| X01–X08 | OverlayPatch thay event/process có revision |
| hội thoại K1.11 | Dialogue Action + phase 70/80 events |
| sổ V01/V02/nước | assertions sau commit/boundary |

Việc ánh xạ chưa tạo dữ liệu máy. Nó chỉ chứng minh mỗi hàng trong sổ có một đường đi qua hợp đồng scheduler thay vì một thay đổi kể bằng văn bản.

## 36. Điều kiện lập lịch LS01–LS36

Các điều kiện mới đã định nghĩa nhưng chưa chạy:

1. LS01 — Scheduler không cho `now_ms` lùi hoặc nhảy qua event/process boundary gần hơn target.
2. LS02 — Event due trong quá khứ bị từ chối, không tự dời sang hiện tại.
3. LS03 — Event chen vào pha đã đóng cùng mốc bị từ chối rõ.
4. LS04 — Event cùng pha chỉ chạy wave sau khi type cho phép NEXT_WAVE.
5. LS05 — Causal loop vượt budget dừng ở boundary chẩn đoán, không bỏ event.
6. LS06 — Cùng due/phase được gom batch; event id không quyết định người thắng.
7. LS07 — Event độc lập đọc cùng phase input và cho cùng kết quả dù thứ tự storage đổi.
8. LS08 — Event lifecycle chỉ kết thúc CONSUMED/CANCELLED/CONSUMED_WITHOUT_EFFECT một lần.
9. LS09 — Event stale không tác động target revision mới và giữ reason.
10. LS10 — Fixed recurrence dùng anchor+index, không trôi sau nhiều lần.
11. LS11 — Mở rộng horizon lặp không sinh trùng occurrence/idempotency key.
12. LS12 — SKIP/MOVE/REPLACE chỉ tác động occurrence được chỉ rõ.
13. LS13 — Chờ trigger không tạo polling event mỗi mili giây.
14. LS14 — Process tích phân nhiều đoạn bằng kết quả một đoạn khi rate/boundary như nhau.
15. LS15 — Remainder giữ qua snapshot và hai nền tảng.
16. LS16 — Process không vượt mốc cạn/đầy/tới đích nằm giữa khoảng.
17. LS17 — Pha 20 hết hiệu lực trước tranh quyền/tài nguyên pha 30.
18. LS18 — Pha 40 giải tác động đồng thời trên cùng snapshot.
19. LS19 — Pha 50 commit toàn mutation group hoặc không mutation nào.
20. LS20 — Hiệu ứng hoàn tất pha 60 không hồi tố bảo vệ impact pha 40 cùng mốc.
21. LS21 — Observation chỉ sinh pha 70 sau Fact/Position/capability hợp lệ.
22. LS22 — Command nhận giữa batch chỉ tác động từ pha 80/ranh giới hợp lệ.
23. LS23 — ConflictSet dùng policy có nguồn; thiếu policy không dùng id fallback.
24. LS24 — Hai người tranh món cuối chỉ tối đa một người nhận.
25. LS25 — Dời event giữ cancellation nguồn và không tự dời deadline Contract.
26. LS26 — Đổi tốc độ hành trình vô hiệu arrival cũ và tạo arrival mới từ quãng còn.
27. LS27 — Người/vật trên tuyến không xuất hiện ở hai đầu trong tích phân.
28. LS28 — Nhu cầu liên tục dùng threshold boundary, không cần event mỗi giây.
29. LS29 — Pause giữa commit hoàn tất atomic group rồi mới dừng.
30. LS30 — Quá tải giữ queue/process/remainder, không giảm luật bí mật.
31. LS31 — Chia một ngày thành số lát UI khác nhau cho cùng state hash.
32. LS32 — OFFLINE_STOP không đổi now khi ứng dụng đóng.
33. LS33 — OFFLINE_CATCHUP nếu bật phải mô phỏng từng event, không cộng thẳng ngày.
34. LS34 — Save/load giữ recurrence cursor, event status, process remainder và queue head.
35. LS35 — Metric/log bật hoặc tắt không đổi RNG, event hay state hash logic.
36. LS36 — Cùng snapshot/seed/policy/command stream cho cùng FactEvent trên điện thoại và máy tính.

Thêm 36 LS vào 408 điều kiện trước đó thành **444 điều kiện thiết kế chưa chạy bằng validator/mô phỏng**.

## 37. Giới hạn và bước tiếp theo

K2.2 chưa chọn cấu trúc heap/calendar queue, số luồng, worker, cách lưu hàng đợi, ngưỡng causal/overload, thuật toán phân vùng hoặc ngân sách hiệu năng cụ thể. Các phần này chỉ được chọn sau khi có công nghệ và phép đo, nhưng không được đổi hợp đồng logic.

K2.3–K2.7 đã cụ thể hóa các hợp đồng nối, oracle và ngân sách; gói được rà tại [[KIEM_TOAN_DONG_GOI_K2]], kiến trúc tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
