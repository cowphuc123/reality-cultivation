---
title: Từ điển dữ liệu máy và hợp đồng trạng thái — K2.1
aliases:
  - K2.1
  - Hợp đồng dữ liệu máy
tags:
  - reality-cultivation
  - thiet-ke
  - du-lieu
  - hop-dong
status: de-xuat
updated: 2026-09-06
---

# Từ điển dữ liệu máy và hợp đồng trạng thái — K2.1

Tài liệu này chuyển kết quả [[KIEM_TOAN_DONG_GOI_K1]] và nền [[LUOC_DO_TRANG_THAI]] thành một ngôn ngữ dữ liệu chung. Nó định nghĩa hình dạng logic, kiểu trường, khóa tham chiếu, đơn vị, phiên bản và bất biến; chưa chọn ngôn ngữ lập trình, định dạng file, cơ sở dữ liệu hoặc thư viện.

Mọi cấu trúc dưới đây là đề xuất kỹ thuật chưa được người dùng duyệt hoặc triển khai. Tên trường tiếng Anh dùng để tránh đổi nghĩa khi chuyển sang dữ liệu máy; phần giải thích tiếng Việt là chuẩn ý nghĩa.

## 1. Mục tiêu của hợp đồng

Mỗi trạng thái hoặc thay đổi phải trả lời được:

1. Bản ghi thuộc loại nào và có id nào?
2. Giá trị dùng đơn vị gì, miền hợp lệ ra sao?
3. Nó là sự thật thế giới, niềm tin của ai hay chỉ văn bản hiển thị?
4. Nó tham chiếu bản ghi nào và mong đợi revision nào?
5. Ai hoặc sự kiện nào tạo ra nó?
6. Nó có hiệu lực trong khoảng nào?
7. Thay đổi đã cam kết nguyên tử hay mới chỉ là đề nghị?
8. Khi lưu/tải hoặc đổi phiên bản, phải giữ điều gì?

Không dùng văn bản tự do để thay cho trường bắt buộc. Không suy quyền, vật, kỹ năng hoặc sự thật từ tên hiển thị.

## 2. Ký pháp kiểu trung lập công nghệ

| Ký pháp | Ý nghĩa | Quy tắc |
|---|---|---|
| `Bool` | đúng/sai khách quan | không dùng để mã hóa chưa biết |
| `Int(min..max)` | số nguyên có miền | tải từ chối khi vượt miền |
| `UInt(max)` | số nguyên không âm | không tự ép số âm về 0 |
| `Text(max)` | chuỗi Unicode giới hạn độ dài | chỉ hiển thị/tìm kiếm nếu không ghi khác |
| `Enum<E>` | đúng một giá trị đã đăng ký | giá trị lạ cần migration hoặc lỗi rõ |
| `Ref<K>` | id trỏ đúng loại K | khóa ngoại phải tồn tại hoặc dùng loại tham chiếu lịch sử |
| `Option<T>` | có T hoặc không áp dụng hợp lệ | không đồng nghĩa “chưa biết” |
| `List<T>` | danh sách có thứ tự, có thể lặp | thứ tự phải có ý nghĩa |
| `Set<T>` | tập duy nhất, không có thứ tự logic | serialize phải dùng thứ tự chuẩn |
| `Map<K,V>` | ánh xạ khóa duy nhất | khóa có comparator chuẩn |
| `OneOf<A,B…>` | hợp kiểu, đúng một nhánh | không cho nhiều nhánh cùng lúc |
| `Interval<T>` | `[start, end)` | `end` có thể mở nếu kiểu cho phép |
| `Fixed(scale)` | số nguyên biểu diễn số cố định | không lưu float chuẩn |
| `Revision` | số nguyên tăng trên một bản ghi | đổi logic phải tăng revision |
| `Version` | chuỗi phiên bản có quy tắc so sánh | không dùng nhãn mơ hồ như “mới nhất” |
| `Predicate` | biểu thức điều kiện có cấu trúc | không chạy mã nhúng hoặc câu tự nhiên |

`Text` không được parse ngược để tạo trạng thái. `Predicate` chỉ dùng toán tử đã đăng ký, tham chiếu trường có kiểu và version của luật đánh giá.

## 3. Đơn vị chuẩn

| Loại | Trường chuẩn | Đơn vị lưu | Miền |
|---|---|---|---|
| Thời điểm game | `GameInstant` | ms từ epoch thế giới | số nguyên có dấu 64 bit |
| Thời lượng | `Duration` | ms | 0…giới hạn 64 bit |
| Chiều dài/vị trí | `Length` | mm | không âm trừ tọa độ có hướng |
| Khối lượng | `Mass` | mg | không âm |
| Thể tích nước | `WaterVolume` | ml | không âm |
| Tiền V01 | `CoinQuantity` | đồng nguyên | không âm |
| Linh lực | `SpiritQuantity` | mLinh = 1/1.000 L | không âm nếu pool không cho nợ |
| Tỉ lệ | `RatioMilli` | 0…1.000 | 0 = 0%, 1.000 = 100% |
| Điểm xu hướng | `SignedScore` | −5.000…+5.000 | số nguyên |
| Xác suất | `ProbabilityPpm` | 0…1.000.000 | chỉ dùng khi luật thật cần rút RNG |
| Góc | `AngleMilliDegree` | 1/1.000 độ | chuẩn hóa theo luật hình học |

Mọi phép đổi đơn vị cần `conversion_rule_id` và `ruleset_version`. Hiển thị có thể đổi sang g, kg, m hoặc giờ nhưng không ghi số làm tròn ngược vào trạng thái.

Tốc độ 5 giây thật/ngày game là `RuntimePacing`, không đổi `GameInstant`: `86.400.000 game_ms` tương ứng `5.000 real_ms` ở tốc độ mặc định. Tạm dừng hoặc máy chậm chỉ đổi cách tiến tới mốc, không đổi kết quả logic của cùng chuỗi đầu vào.

## 4. Mã định danh có kiểu

Mã đầy đủ dùng `domain:local_id`. Ví dụ: `person:P00`, `place:D01`, `item_type:V12`, `contract:C01`, `event:E...`.

| Domain | Đích |
|---|---|
| `world`, `snapshot`, `fixture`, `overlay` | thế giới, ảnh lưu và nhánh thử |
| `person`, `body`, `cultivation` | người và trạng thái cá thể |
| `place`, `route`, `position` | không gian |
| `item_type`, `item`, `lot`, `container_edge` | vật chất |
| `household`, `organization`, `resource_pool` | nhóm và nguồn |
| `right`, `claim`, `contract`, `obligation`, `reservation` | quyền/cam kết |
| `goal`, `action`, `schedule`, `event`, `transaction` | vận hành |
| `fact`, `observation`, `message`, `belief`, `memory`, `inference` | nhận thức |
| `skill`, `relation`, `affect`, `pressure` | hồ sơ cá nhân/xã hội |
| `decision`, `dialogue`, `record`, `ledger_entry` | quyết định, lời nói, hồ sơ |
| `test`, `rng_stream`, `migration` | kiểm chứng và hạ tầng logic |

`Ref<K>` phải khớp domain K. Một mã đã cấp không được dùng lại sau khi bản ghi kết thúc. Đổi tên hiển thị không đổi id. Bộ cấp id phải tái hiện được và lưu counter; không dựa vào thứ tự đọc Map hoặc thời gian đồng hồ thiết bị.

## 5. RecordEnvelope chung

Mọi bản ghi có danh tính dùng phần đầu:

| Trường | Kiểu | Bắt buộc | Ý nghĩa |
|---|---|:---:|---|
| `id` | `Ref<self_kind>` | ✓ | duy nhất trong thế giới/domain |
| `kind` | `Enum<RecordKind>` | ✓ | loại bản ghi thật |
| `schema_version` | `Version` | ✓ | hình dạng bản ghi |
| `ruleset_version` | `Version` | ✓ | luật dùng để hiểu/cập nhật |
| `content_version` | `Version` | ✓ | mẫu nội dung liên quan |
| `revision` | `Revision` | ✓ | tăng khi trạng thái logic đổi |
| `lifecycle` | `Enum<ACTIVE,SUSPENDED,ENDED,DESTROYED,ARCHIVED>` | ✓ | không dùng xóa để che lịch sử |
| `created_at` | `GameInstant` | ✓ | mốc tạo logic |
| `created_by` | `Ref<FactEvent/InitRecord>` | ✓ | nguồn tạo |
| `ended_at` | `Option<GameInstant>` | ✓ | chỉ có khi kết thúc |
| `ended_by` | `Option<Ref<FactEvent>>` | ✓ | cùng quy tắc với `ended_at` |
| `labels` | `Set<Enum/NamespacedText>` |  | chỉ phân loại, không điều khiển luật nếu chưa đăng ký |

Hai trường `ended_at` và `ended_by` phải cùng có hoặc cùng không. Metadata giao diện có thể mở rộng theo namespace nhưng bộ mô phỏng phải từ chối trường logic lạ, không im lặng bỏ qua.

## 6. Không biết, không có và không áp dụng

`null` chỉ được dùng cho `Option<T>` khi ý nghĩa là **không áp dụng hợp lệ**. Bốn trường hợp sau phải tách:

| Trường hợp | Biểu diễn |
|---|---|
| Sự thật chưa xảy ra/chưa có đối tượng | không có bản ghi hoặc lifecycle phù hợp |
| Trường không áp dụng | `Option<T> = none` theo schema |
| Chủ thể không biết | không có Belief phù hợp, hoặc stance `UNRESOLVED` có nguồn |
| Dữ liệu bị che khỏi người xem | ViewProjection `REDACTED`; state gốc không đổi |
| Người nói cố ý giữ kín | intent/privacy trong Dialogue/Message |
| Dữ liệu thiết kế còn thiếu | `UNSUPPORTED` trong manifest/guard, không đưa vào state như giá trị thật |

World state không được chứa `unknown` cho lượng tiền/vật/vị trí đang cần mô phỏng. Nếu tác giả chưa định lượng, fixture phải loại tính năng hoặc dừng bằng UnsupportedGuard.

## 7. WorldManifest và Snapshot

### 7.1 WorldManifest

| Trường | Kiểu |
|---|---|
| `world_id` | `Ref<World>` |
| `schema_version` | `Version` |
| `ruleset_version` | `Version` |
| `content_manifest` | `Map<ContentPackId,Version+Hash>` |
| `fixture_id/version` | `Option<Ref<Fixture>+Version>` |
| `world_epoch` | lịch hiển thị + `GameInstant=0` |
| `global_seed` | số nguyên không âm có độ rộng cố định |
| `id_counters` | `Map<Domain,UInt>` |
| `feature_guards` | `Map<Feature,SUPPORTED/UNSUPPORTED/EXPERIMENTAL>` |
| `policy_versions` | TN/policy được gắn rõ, kể cả `UNCONFIRMED_FIXTURE_DEFAULT` |

### 7.2 Snapshot

| Trường | Kiểu |
|---|---|
| `snapshot_id` | `Ref<Snapshot>` |
| `world_id` | `Ref<World>` |
| `parent_snapshot_id` | `Option<Ref<Snapshot>>` |
| `now_ms` | `GameInstant` |
| `current_phase` | `Enum<10,20,30,40,50,60,70,80,BOUNDARY>` |
| `record_roots` | tập tham chiếu tới kho trạng thái |
| `pending_event_head` | `Option<Ref<ScheduledEvent>>` |
| `applied_transaction_digest` | tập/hash có dữ liệu kiểm đầy đủ |
| `rng_cursors` | `Map<Ref<RngStream>,UInt>` |
| `state_hash` | hash chuẩn của trạng thái logic |

Snapshot chỉ hợp lệ ở `BOUNDARY` hoặc phải giữ toàn bộ nhóm tác động dang dở. Bản đầu đề xuất chỉ lưu ở ranh giới nguyên tử để giảm trạng thái trung gian; đây chưa phải lựa chọn trải nghiệm TN05.

## 8. Person, nhóm và quan hệ

### 8.1 Person

| Trường | Kiểu |
|---|---|
| `person_id` | `Ref<Person>` |
| `display_name` | `Text(120)` |
| `birth_at` | `GameInstant` hoặc ngày lịch chuẩn |
| `body_id` | `Ref<Body>` |
| `position_id` | `Ref<Position>` |
| `controller` | `Enum<PLAYER_GOALS,NPC_POLICY,FIXTURE_SCRIPT>` |
| `household_refs` | `Set<Ref<HouseholdMembership>>` |
| `organization_refs` | `Set<Ref<RoleMembership>>` |
| `active_goal_refs` | `Set<Ref<Goal>>` |
| `decision_policy_id/version` | policy rõ; P00 không suy từ Trait nếu chưa chốt |

Tuổi hiển thị suy từ `birth_at` và lịch; không vừa lưu tuổi vừa để nó lệch theo thời gian.

### 8.2 Household/Organization

Hai loại dùng record riêng. `HouseholdMembership` không tự tạo quan hệ huyết thống, hôn phối, quyền sở hữu hoặc quyền cơ thể. `RoleMembership` ghi role, scope, valid interval, authority source và người biết; tên “giữ kho” không tự cấp mọi quyền kho.

### 8.3 RelationEdge

| Trường | Kiểu |
|---|---|
| `from_person`, `to_person` | hai `Ref<Person>` khác nhau |
| `domain` | TRUST, AFFECTION, DUTY, FEAR, RESPECT… |
| `score` | `SignedScore` |
| `evidence_refs` | Fact/Message/Memory mà chủ thể có |
| `last_changed_at/by` | thời gian và FactEvent |

Quan hệ có hướng. Bản ghi A→B không sinh B→A.

## 9. Place, Route và Position

### 9.1 Place/Route

`Place` có id, vùng cha, hình học/cổng, feature và policy vào. `Route` có hai cổng, chiều dài mm, hướng cho phép, trạng thái khả dụng, tải/sức chứa nếu dùng, và revision.

### 9.2 Position là OneOf

| Nhánh | Trường bắt buộc |
|---|---|
| `AT_PLACE` | `place_id`, x/y/z mm, orientation, posture |
| `ON_ROUTE` | `route_id`, `from_gate`, `distance_from_start_mm`, lane/group tùy chọn |
| `IN_CONTAINER` | `container_item_id`, `container_edge_id` |
| `ATTACHED_TO_BODY` | `body_id`, `body_slot_id`, attachment state |
| `OUT_OF_WORLD` | reason enum, `ended_by` |

Mỗi thực thể vật lý có đúng một Position hoạt động. Vị trí qua vật chứa được suy theo chuỗi; cấm vòng chứa và cấm vừa có tọa độ độc lập vừa nằm trong túi.

Chuyển vị trí cần expected revision của thực thể, vị trí cũ, tuyến/cổng và sức chứa liên quan. Đến đích chỉ xảy ra trong Transaction/FactEvent, không do giao diện sửa thẳng.

## 10. ItemType, Item, Lot và cấu tạo

### 10.1 ItemType

| Trường | Kiểu |
|---|---|
| `item_type_id` | `Ref<ItemType>` như V01–V36 |
| `display_name` | text |
| `quantity_kind` | DISCRETE, MASS, VOLUME, LENGTH, ENERGY |
| `base_unit` | enum đơn vị khớp quantity kind |
| `divisibility` | WHOLE_ONLY hoặc bước chia nguyên |
| `base_mass_mg` | giá trị hoặc công thức thành phần có version |
| `capabilities` | tập mã công dụng; không phải văn bản |
| `quality_dimensions` | danh sách trục có miền |
| `container_spec` | Option sức chứa/loại nhận |
| `component_slots` | Option slot và điều kiện lắp |

### 10.2 ItemInstance/Lot

Vật cá thể có `item_id`, type, condition, quality, position, owner/holder refs, component edges và revision. Lot có type đồng nhất, quantity có đơn vị, composition/quality distribution, provenance và position; tách lot bảo toàn tổng và tạo id mới có `derived_from`.

V01 vẫn là vật/lot thật. Số dư giao diện là phép tổng hợp theo ownership, không phải kho tiền thứ hai. V24 đang lắp trong V23 là component; tháo mới tạo Position độc lập.

### 10.3 ContainmentEdge

`parent_item`, `child_item/lot`, slot, quantity nếu chia, inserted_by, valid interval. Validator phải kiểm không vòng, không vượt dung tích/tải, không sai loại và không cộng khối lượng con hai lần.

## 11. Ownership, holding và ResourcePool

Ba quan hệ tách biệt:

- `OwnershipInterest`: ai có claim được công nhận, tỉ lệ/phạm vi và nguồn;
- `Custody`: ai đang giữ/chịu trách nhiệm, không tự thành chủ;
- `Position`: vật đang ở đâu, có thể khác nơi/chủ.

`ResourcePool` dùng cho nguồn nước, linh khí, sinh khối hoặc quỹ chia được:

| Trường | Kiểu |
|---|---|
| `resource_kind/unit` | loại và đơn vị cố định |
| `quantity` | số nguyên không âm |
| `capacity` | Option cùng đơn vị |
| `inflow/outflow_processes` | process refs có version |
| `allocation_policy` | policy có id/version |
| `owner/custodian/position` | refs tách biệt |
| `remainder` | phần dư nguyên có mẫu số nếu tích phân |

Không dùng ResourcePool để thay Item/Lot khi cần danh tính, chất lượng hoặc vị trí từng vật.

## 12. Transaction và Mutation

`Transaction` là đơn vị cam kết nguyên tử:

| Trường | Kiểu |
|---|---|
| `transaction_id` | `Ref<Transaction>` |
| `idempotency_key` | khóa duy nhất trong world |
| `status` | PROPOSED, RESERVED, COMMITTED, REJECTED, COMPENSATED |
| `caused_by` | Command/Action/Event/Contract ref |
| `expected_revisions` | `Map<Ref<Record>,Revision>` |
| `preconditions` | `List<Predicate>` |
| `mutations` | `List<Mutation>` |
| `committed_at/phase` | Option mốc và pha 50 |
| `result_event_id` | Option FactEvent |
| `failure_code` | Option enum + refs, không rò bí mật cho view |

Mutation đăng ký gồm: `MOVE_POSITION`, `TRANSFER_OWNERSHIP`, `CHANGE_CUSTODY`, `ADJUST_QUANTITY`, `SPLIT_LOT`, `MERGE_LOT`, `ATTACH`, `DETACH`, `CHANGE_CONDITION`, `GRANT/REVOKE_RIGHT`, `CREATE/END_RECORD`.

Mọi precondition được kiểm trên cùng snapshot pha 30/40. Hoặc tất cả mutation cam kết, hoặc không mutation nào áp. Hoàn tiền/đảo nghiệp vụ tạo transaction bù; không sửa lịch sử transaction đã cam kết.

## 13. Right, Claim, Contract, Obligation và Reservation

### 13.1 RightGrant

| Trường | Kiểu |
|---|---|
| `holder_id` | Person/Role/Organization ref |
| `target_scope` | object/type/place/organization + predicate có giới hạn |
| `allowed_actions` | set action codes |
| `limits` | lượng, mỗi giao dịch, tổng kỳ, thời gian, mục đích |
| `valid_interval` | `[start,end)` |
| `authority_source` | Rule/Ruling/Contract/Owner ref |
| `delegable` | Bool + giới hạn nếu đúng |
| `status` | PROPOSED, ACTIVE, SUSPENDED, EXPIRED, REVOKED |
| `recognition_scope` | ai/thể chế công nhận |

Quyền thật và Belief về quyền là hai bản ghi. Người không biết quyền có thể không thực thi; người tin sai có quyền vẫn có thể bị Transaction từ chối.

### 13.2 Contract/Obligation

Contract ghi parties, offer/accept evidence, terms version, effective interval, status và dispute policy. Mỗi `Obligation` có debtor, beneficiary, deliverable predicate, due condition, acceptance authority, fulfillment transaction và breach status. C01 không chứa 12 V01; nó đòi một Transaction hợp lệ.

### 13.3 Reservation

Reservation có resource ref, quantity, holder, purpose, priority source, interval và status. Nó giảm lượng khả dụng cho giao dịch khác nhưng không đổi ownership hoặc tiêu hao. Hết hạn/hủy tạo event, không biến mất không dấu vết.

## 14. Schedule, Goal và Action

### 14.1 Goal

`Goal` có owner, created_by, target predicate, priority, deadline, budget, constraints, policy khi kẹt, status, active plan refs và completion evidence. Mục tiêu không trực tiếp tạo sản phẩm/kỹ năng.

### 14.2 ScheduleRule

| Trường | Kiểu |
|---|---|
| `owner_id` | Person/Organization/Process |
| `time_rule` | mốc hoặc recurrence cấu trúc |
| `window` | earliest/latest/duration |
| `flexibility` | FIXED, MOVABLE, REPLACEABLE |
| `priority_source` | goal/contract/need/routine |
| `location_requirement` | place/route predicate |
| `resource_requirements` | refs và lượng |
| `replacement_policy` | cách tạo Action mới, không sửa im lặng |

### 14.3 ActionInstance

| Trường | Kiểu |
|---|---|
| `actor_id`, `action_type_id` | typed refs |
| `goal/contract/schedule_refs` | nguồn lý do |
| `status` | WAITING, READY, RUNNING, STOPPING, SUSPENDED, COMPLETED, FAILED, CANCELLED |
| `started_at`, `last_integrated_at` | Option instant |
| `work_required/done/remainder` | quantity có cùng unit |
| `occupied_capabilities` | body/attention/speech/cultivation channels |
| `reserved_resources` | Reservation refs |
| `start/continue/finish_conditions` | Predicate lists |
| `interrupt_policy` | enum + safe-stop process |
| `result_transaction_ids` | chỉ kết quả đã cam kết |
| `expected_record_revisions` | chống lịch cũ tác động state mới |

Action kết thúc chỉ áp output một lần. Thay lịch tạo version/Action mới và vô hiệu event cũ có lý do.

## 15. ScheduledEvent, FactEvent và tám pha

### 15.1 ScheduledEvent

`event_id`, `due_ms`, `phase`, `event_type`, payload có schema, cause, correlation id, expected revisions, status và idempotency key. Trạng thái: `PENDING`, `CANCELLED`, `CONSUMED`, `CONSUMED_WITHOUT_EFFECT`.

### 15.2 FactEvent

FactEvent bất biến có occurred_at, phase, type, participants, cause chain, transaction refs, before/after revision digest, observer-candidate facts và audit payload. Không lưu câu kể như sự thật duy nhất.

### 15.3 Pha chuẩn

| Pha | Hợp đồng |
|---:|---|
| 10 | tích phân quá trình/vị trí tới t, giữ phần dư |
| 20 | kết thúc interval `[start,t)` |
| 30 | kiểm quyền, precondition, reservation và tranh nguồn |
| 40 | chụp đầu nhóm, giải tác động đồng thời |
| 50 | cam kết mutation/Transaction nguyên tử |
| 60 | hoàn tất Action, kích hoạt hiệu ứng mới |
| 70 | tính derived state, tạo Observation/Message khả dụng |
| 80 | nhận Command, đánh giá Goal/Decision và lên lịch |

Cùng `due_ms` không dùng id nhỏ để phân thắng. Mọi comparator kỹ thuật chỉ chuẩn hóa serialization; kết quả logic phải do pha và policy tranh chấp quyết định.

## 16. Fact, Observation, Message, Belief, Memory và Inference

### 16.1 Proposition

Nội dung có cấu trúc gồm `subject_ref`, `predicate_code`, `object/value`, thời điểm/khoảng áp dụng và qualifiers. Proposition không tự là Fact hoặc Belief; các record sau trỏ tới nó.

### 16.2 Observation

Observer, signal source, sensory channel, start/end, raw features, resolved proposition fragments, uncertainty và caused_by FactEvent. Chỉ tạo nếu vị trí, cơ thể và chú ý cho phép.

### 16.3 Message

Sender, intended recipients, actual receivers, payload propositions, claimed sources, privacy scope, signal/DialogueAct refs, comprehension results và delivery times. Người không nhận không tự có Belief.

### 16.4 Belief

| Trường | Kiểu |
|---|---|
| `holder_id` | Person |
| `proposition_id` | proposition |
| `stance` | ACCEPTS, REJECTS, UNRESOLVED |
| `confidence_milli` | 0…1.000 |
| `source_refs` | Observation/Message/Memory/Inference |
| `formed_at`, `last_reviewed_at` | instant |
| `freshness_policy` | policy id/version |
| `supersedes/conflicts_with` | belief refs |

Confidence không biến Belief thành Fact. Hai belief mâu thuẫn có thể cùng tồn tại.

### 16.5 Memory/Inference

Memory trỏ episode/source, salience, retained details và compression provenance. Inference có premises mà holder thật sự biết, rule id/version, conclusion proposition và confidence. Tóm lược không được tạo premise mới.

## 17. Skill, ngôn ngữ và học

`CapabilityProfile` không phải một số kỹ năng chung. Mỗi `SkillRecord` có holder, domain, level/measure, source evidence, practiced_at, decay/update policy và recognition ref nếu có.

Ngôn ngữ dùng sáu kênh H/S/R/W/C/A riêng theo [[NANG_LUC_NGON_NGU_TRI_THUC_K1]]. `KnowledgeUnit` ghi nội dung, prerequisite, mức hiểu, nguồn và quyền dạy/chứng nhận tách biệt. Nghe tên việc không tăng kỹ năng; PracticeEvent hợp lệ mới cập nhật.

Đọc/viết/tính là Action có thời gian, cơ thể, công cụ và lỗi. CalculationAttempt lưu input refs, rule, thao tác, kết quả chủ thể tin và kết quả đối chiếu; tính đúng trên dòng sai không sửa kho thật.

## 18. Body và Cultivation ở mức hợp đồng nối

K2.1 chỉ khóa giao diện dữ liệu chung, chưa hoàn thiện sinh lý/cảnh giới.

### 18.1 BodyState

`body_id`, owner, species/body plan version, part graph root, active wound/condition refs, resource pools, derived capability cache + input revisions. `BodyPart` có parent, side, tissue/components, connections và lifecycle. Wound có site, mechanism, structural changes, contamination/fluid refs, pain signals, treatment refs và healing process version.

Không có thanh HP làm nguồn thật. Khả năng đi/cầm/nhìn/tập trung là derived state có provenance; hệ Action chỉ đọc capability và không trừ thương tích lần hai.

### 18.2 CultivationState

`cultivation_id`, owner, technique knowledge refs, energy pools P/B…, route/network state, active practice Action, adaptation/milestone refs và injury refs. Mọi chuyển năng lượng dùng Transaction/Process có đơn vị mLinh. Tên công pháp không tự cấp tác dụng chưa định lượng.

## 19. Trait, Value, Affect và Pressure

Trait/Value là hồ sơ chậm; Affect/Pressure là trạng thái có nguồn và thời gian.

| Record | Trường cốt lõi |
|---|---|
| `TraitProfile` | person, axis, SignedScore, evidence window, adaptation policy/version |
| `ValuePriority` | person, value code, priority, boundary predicates, source |
| `AffectState` | person, affect type, target, intensity, source appraisal, onset, decay policy |
| `PressureLoad` | person, six component values, source refs, window, recovery process |

P00 dùng trạng thái `UNSPECIFIED_BY_POLICY` cho Trait/Value khi fixture PLAYER-DIRECT yêu cầu; không dùng 0 vì 0 là mức trung tính đã biết. Affect không tự sửa quan hệ, quyền hoặc Action.

## 20. DecisionFrame và DecisionTrace

### 20.1 DecisionFrame

| Trường | Kiểu |
|---|---|
| `decision_id` | Ref<Decision> |
| `actor_id`, `wakeup_event_id` | refs |
| `snapshot_at/revision_digest` | mốc và state được đọc |
| `fact_access` | chỉ refs actor có quyền/tri thức sử dụng |
| `goal/belief/skill/right/body_refs` | đầu vào có provenance |
| `known_options` | List<DecisionOption> |
| `selected_option_id` | Option; chỉ sau resolve |
| `tie_break/draw_ref` | Option có log |
| `status` | OPEN, RESOLVED, INVALIDATED, ABORTED |

`DecisionOption` có source-of-option, required capability/right/resource, hard-filter result, score parts, expected outcomes theo Belief, cost, risk và recheck condition. Hard filter chạy trước score.

### 20.2 DecisionTrace

Trace là hồ sơ kiểm toán đóng sau quyết định: snapshot refs, option scores, selected, commitments, expected recheck, actual result refs và private/public explanation. Nó không phải Memory của NPC và không được sửa lại khi hậu quả tương lai xuất hiện.

## 21. DialogueIntent, UtteranceSignal, DialogueAct và DialogueTurn

| Record | Trường bắt buộc |
|---|---|
| `DialogueIntent` | owner, desired act/outcome, payload refs, privacy, source decision |
| `UtteranceSignal` | speaker, language, start/end, physical signal, perceivable range |
| `DialogueAct` | act type, structured payload, claimed source, intended recipients |
| `DialogueTurn` | conversation, speaker, recipient set, intent/signal/act refs, result messages, status |

Trạng thái turn: `PLANNED, SPEAKING, AWAITING_RESPONSE, CLARIFYING, ACCEPTED, REFUSED, INTERRUPTED, ENDED`. `ACCEPTED` phải trỏ DialogueAct ACCEPT và authority/precondition hợp lệ; im lặng hoặc hết thời gian không đủ.

Câu mẫu/LLM output nằm ở `RenderedText`, trỏ `DialogueAct` và locale/style. Nó không được parse ngược hoặc cam kết Transaction.

## 22. InstitutionalRecord và LedgerEntry

`InstitutionalRecord` đại diện V34/V35/V36 hoặc mục logic gắn với vật mang. Nó có physical carrier ref, author, writer, sign/mark evidence, content payload, written_at, revision chain, legibility và recognized scope.

`LedgerEntry` có entry type, institution, underlying transaction/contract/right/event ref, recorded_at/by, correction/supersedes và physical record ref. ENTRY-TXN thiếu Transaction chỉ là lời ghi/claim, không chuyển vật hoặc chứng minh thanh toán.

PublicNotice tạo cơ hội Observation tại vị trí; nó không phát Message toàn vùng.

## 23. OverlayPatch và fixture

| Trường | Kiểu |
|---|---|
| `overlay_id/version` | id + Version |
| `base_fixture/version/hash` | base chính xác |
| `preconditions` | Predicate list |
| `replacements` | record/event cũ + expected revision + bản thay |
| `additions` | record mới có created_by overlay init |
| `invalidations` | record cũ + reason |
| `forbidden_overlaps` | loại/xung đột đã biết |
| `rejoin_guard` | điều kiện nhập lại base |
| `assertion_delta` | oracle thay đổi, không sao chép toàn bộ base |

Áp nhiều overlay theo một `CompositionPlan` có thứ tự và kiểm lại precondition sau mỗi bước. Nếu hai nhánh sửa cùng field/bản ghi mà không có resolution rule, composition bị từ chối rõ.

FixtureManifest chứa participants, run window, injected inputs, command stream, seed, allowed branches, assertions, invariants và UnsupportedGuard. Dữ liệu thử phải mang `synthetic_test_input=true` để không lẫn lịch sử chơi thường.

## 24. RNG và tái hiện

`RngStreamId` được suy ổn định từ world + system domain + subject + source event + rule version. Mỗi stream giữ `draw_index`; `RandomDraw` có distribution id/params, raw draw, mapped result và FactEvent/Decision ref.

Không rút RNG khi:

- mở giao diện hoặc tạo tóm tắt;
- chỉ kiểm precondition chưa cam kết;
- deserialize lại kết quả đã có;
- hệ không liên quan thêm log/trang trí;
- comparator cần sắp thứ tự serialization.

Cùng snapshot hash, command stream, policy/content/ruleset version và seed phải cho cùng chuỗi FactEvent logic trên điện thoại và máy tính.

## 25. Command, ViewProjection và ranh giới quyền

`Command` là yêu cầu, không phải mutation. Nó có issuer, target, received_at, intent type, structured payload, budget/constraints, policy version và idempotency key. Bộ xử lý xác thực quyền rồi tạo Goal/Action/Message hoặc từ chối.

`ViewProjection` luôn có viewer, knowledge cutoff, source refs và redaction reasons. Công cụ phát triển có thể dùng `OMNISCIENT_DEBUG`; save chơi không cấp quyền này cho P00.

Mọi lỗi nội bộ có hai phần: `audit_failure` toàn tri và `viewer_explanation` chỉ dùng điều viewer biết. Không để lý do “N13 đang ở D10” làm lộ vị trí khi P00 chỉ biết N13 vắng.

## 26. Validation và lỗi tải

Ba mức:

1. **Shape:** đúng loại trường, enum, miền, độ dài, unit.
2. **Reference:** id duy nhất, Ref đúng domain, revision/version tồn tại, không vòng.
3. **World invariant:** một Position, không âm, bảo toàn, quyền, pha, idempotency, provenance.

Mã lỗi có cấu trúc: `category`, `code`, `record_refs`, `field_path`, `expected`, `actual`, `source_location`, `severity`. Không chỉ trả chuỗi “dữ liệu sai”.

`ERROR` chặn nạp/chạy; `UNSUPPORTED` chặn feature/fixture liên quan; `WARNING` chỉ dùng cho dữ liệu không ảnh hưởng logic. Không tự sửa số âm, id sai hoặc tham chiếu gần giống.

## 27. Phiên bản và migration

| Phiên bản | Thay đổi gì |
|---|---|
| `schema_version` | hình dạng/kiểu trường |
| `ruleset_version` | cách tính, pha, update, validator |
| `content_version` | mẫu vật, việc, công pháp, hệ số |
| `fixture_version` | INIT/base/overlay/oracle |
| `policy_version` | TN/autonomy/pause/AI behavior |
| `record_revision` | trạng thái một bản ghi trong thế giới |

Migration là chuỗi bước có `from`, `to`, precondition, transform, invariant checks, loss policy và hash. Không bỏ qua version trung gian nếu chưa có đường chuyển. Migration không được phát FactEvent gameplay, rút RNG hoặc thay lựa chọn quá khứ; thay đổi không bảo toàn phải dừng và giải thích.

## 28. Canonical serialization và state hash

Để hai nền tảng đối chiếu cùng trạng thái, dạng chuẩn logic phải:

- sắp record theo domain + id chuẩn;
- sắp Set theo comparator đã định, giữ List đúng thứ tự nghiệp vụ;
- dùng số nguyên thập phân không có cách viết tương đương khác;
- chuẩn hóa Unicode cho id/nội dung cần hash;
- không đưa text dịch, thời gian thiết bị, thứ tự giao diện hoặc cache tái tạo được vào state hash;
- đưa version, record revision, RNG cursor, hàng đợi và phần dư vào hash;
- hash từng kho rồi tạo root hash để tìm vùng lệch.

Thuật toán hash cụ thể chọn khi triển khai; hợp đồng chỉ yêu cầu ổn định, có version và giống nhau giữa nền tảng.

## 29. Tóm lược và lưu lịch sử

FactEvent/Observation/Message/Belief/Contract đang được bản ghi sống tham chiếu không được xóa. Tóm lược tạo `SummaryRecord` với range, source digest, retained propositions, omitted categories và summarizer version.

Summary không:

- phát lại ảnh hưởng quan hệ/cảm xúc;
- biến nhiều lời kể cùng gốc thành nguồn độc lập;
- tạo chi tiết không có trong source;
- thay Transaction/Right/Contract đang hiệu lực;
- được dùng làm oracle nếu đã làm mất dữ liệu cần kiểm.

Khi chi tiết có thể bỏ, retention policy phải có lý do và giữ aggregate bảo toàn cần thiết.

## 30. Gói K1 chuyển sang hợp đồng nào

| Nguồn | Hợp đồng đích K2.1 |
|---|---|
| INIT-A, V01–V36, P/N/D/J | registries + initial records + typed refs |
| Lịch K1.1 | ScheduleRule + Action templates |
| Sổ K1.3 | ScheduledEvent + FactEvent oracle + ledgers |
| X01–X08 | OverlayPatch + AssertionDelta |
| đời sống K1.5 | policy/process interface; phần dài hạn vẫn Unsupported |
| hồ sơ K1.6 | Person/Relation/Goal/Secret knowledge seeds |
| thể chế K1.7–K1.8 | Right/Contract/Record/LedgerEntry |
| năng lực K1.9 | Skill/KnowledgeUnit/CalculationAttempt |
| tâm lý K1.10 | Trait/Value/Affect/Pressure |
| hội thoại K1.11 | DecisionFrame/Trace + Dialogue records |
| 376 điều kiện | TestCase metadata + assertions/evidence slot |

K2.1 không tự chuyển các bảng thành file dữ liệu thật; nó khóa ý nghĩa để bước sau có thể làm việc đó mà không đoán.

## 31. Điều kiện hợp đồng HD01–HD32

Các điều kiện mới đã được định nghĩa nhưng chưa chạy bằng validator hoặc mô phỏng:

1. HD01 — Mọi record có id đúng domain, version và revision hợp lệ.
2. HD02 — Ref sai loại hoặc không tồn tại làm tải thất bại rõ.
3. HD03 — Id đã kết thúc không được tái cấp cho thực thể mới.
4. HD04 — `Option.none` chỉ xuất hiện ở trường cho phép và không thay nghĩa “không biết”.
5. HD05 — World state không dùng unknown cho lượng/vị trí bắt buộc.
6. HD06 — Mọi quantity khớp unit; không cộng WaterVolume với SpiritQuantity.
7. HD07 — Tính fixed-point giữ phần dư, không ghi số hiển thị làm tròn trở lại.
8. HD08 — Person có đúng một Body và một Position hoạt động.
9. HD09 — Vật trong container không đồng thời có Position độc lập.
10. HD10 — Đồ thị Containment không vòng và không vượt tải/dung tích.
11. HD11 — Owner, custodian và Position thay độc lập, không suy lẫn nhau.
12. HD12 — Transaction sai một precondition không áp bất kỳ mutation nào.
13. HD13 — Idempotency key đã cam kết trả kết quả cũ, không phát output lần hai.
14. HD14 — Transaction bù không xóa transaction nguồn.
15. HD15 — Reservation giảm lượng khả dụng nhưng không đổi ownership/tiêu hao.
16. HD16 — Right hết hạn/không đúng scope làm hành động bị từ chối có mã.
17. HD17 — Contract chỉ hiệu lực sau offer/accept/authority hợp lệ.
18. HD18 — Action hoàn tất chỉ cam kết output một lần và giữ event cũ vô hiệu có lý do.
19. HD19 — Cùng due_ms tuân pha 10–80; id không phân thắng.
20. HD20 — FactEvent bất biến và trỏ transaction/revision thực sự đã đổi.
21. HD21 — Observation chỉ sinh khi vị trí, giác quan và chú ý cho phép.
22. HD22 — Message chỉ tới actual receivers; người khác không tự có Belief.
23. HD23 — Belief mâu thuẫn không sửa Fact và giữ source chain.
24. HD24 — Inference chỉ dùng premise holder có nguồn biết tại thời điểm đó.
25. HD25 — Skill tăng qua PracticeEvent hợp lệ, không qua tên/câu kể.
26. HD26 — Trait/Affect/Pressure không trực tiếp ghi Action, Right hoặc Relation.
27. HD27 — DecisionFrame dùng đúng snapshot và không đọc kết quả tương lai.
28. HD28 — RenderedText không được parse ngược để tạo cam kết/sự thật.
29. HD29 — Overlay sai base hash/revision hoặc xung đột chưa giải bị từ chối.
30. HD30 — Migration không rút RNG, phát gameplay event hoặc âm thầm làm mất dữ liệu.
31. HD31 — Canonical state hash giống nhau trên điện thoại và máy tính với cùng logic.
32. HD32 — UnsupportedGuard dừng feature thiếu dữ liệu, không kể bù kết quả.

HD01–HD32 là 32 điều kiện hợp đồng mới. Cộng với 376 điều kiện trước đó thành **408 điều kiện thiết kế chưa chạy**; trong đó 376 kiểm hành vi/fixture và 32 kiểm hình dạng–hợp đồng dữ liệu.

## 32. Giới hạn và bước tiếp theo

K2.1 chưa quyết định định dạng JSON/binary/cơ sở dữ liệu, ngôn ngữ, framework, thuật toán hash, chiến lược lưu toàn bộ event hay snapshot theo chu kỳ, hoặc cách đồng bộ đám mây. Nó cũng chưa viết toàn bộ schema sâu cho cơ thể, sinh thái, tu luyện và chiến đấu ngoài các điểm nối chung.

K2.2–K2.7 đã cụ thể hóa các hợp đồng nối và ngân sách; gói được rà tại [[KIEM_TOAN_DONG_GOI_K2]], kiến trúc tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
