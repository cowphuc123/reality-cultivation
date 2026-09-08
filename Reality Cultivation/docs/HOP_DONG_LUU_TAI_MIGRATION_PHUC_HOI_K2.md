---
title: Hợp đồng lưu tải, migration và phục hồi thế giới — K2.5
aliases:
  - K2.5
  - Lưu tải và phục hồi thế giới
tags:
  - reality-cultivation
  - thiet-ke
  - save-load
  - migration
  - phuc-hoi
status: de-xuat
updated: 2026-09-06
---

# Hợp đồng lưu tải, migration và phục hồi thế giới — K2.5

Tài liệu này cụ thể hóa WorldManifest/Snapshot/version/hash của [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]], ranh giới scheduler của [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]], trạng thái nguyên tử trong [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]] và trạng thái tác nhân của [[HOP_DONG_NHAN_THUC_QUYET_DINH_TAC_NHAN_K2]]. Luồng người dùng nối với [[GIAO_DIEN]] và chính sách thời gian nối với [[THOI_GIAN]].

Đây là hợp đồng thiết kế chưa triển khai. Nó không chọn định dạng file, cơ sở dữ liệu, thuật toán hash, dịch vụ đám mây, ứng dụng web/native hay TN02/TN05. “Lưu” dưới đây là yêu cầu logic độc lập công nghệ.

## 1. Chín bất biến lưu trữ

1. Một thế hệ save đã công bố phải chứa trạng thái trước hoặc sau một nhóm nguyên tử, không chứa nửa giao dịch.
2. Tải lại không phát sự kiện, rút RNG, gửi Message hoặc áp update lần hai.
3. Save không tương thích/hỏng không được âm thầm biến thành thế giới mới.
4. Migration không thay quá khứ gameplay, không bịa vật/nguồn/quyền để làm dữ liệu hợp lệ.
5. Bản cũ còn nguyên cho tới khi bản mới đã được kiểm tra và công bố.
6. Thời gian thiết bị và thời gian game không được trộn.
7. Khôi phục kỹ thuật khác tải lại có chủ ý vì gameplay.
8. Đồng bộ nhiều thiết bị không tự gộp hai nhánh thế giới đã cùng tiến triển.
9. Cùng save logic phải nạp thành cùng state hash trên điện thoại và máy tính.

## 2. Bốn lớp không được gọi chung là “file save”

| Lớp | Vai trò |
|---|---|
| `SnapshotImage` | ảnh trạng thái logic tại một ranh giới xác định |
| `JournalSegment` | chuỗi thay đổi/command/event đã cam kết sau snapshot |
| `Checkpoint` | điểm snapshot+journal đã xác minh có thể phục hồi |
| `SaveSlot` | tên/nhánh/lịch sử người dùng nhìn thấy, trỏ một checkpoint |

`Autosave`, `ManualSave`, `CrashRecovery` và `CloudReplica` là policy/cách công bố checkpoint, không phải bốn dạng world state khác nhau.

## 3. Danh tính thế giới và dòng dõi

`WorldIdentity` có:

| Trường | Ý nghĩa |
|---|---|
| `world_id` | danh tính thế giới không đổi qua save bình thường |
| `lineage_id` | dòng lịch sử chung |
| `branch_id` | nhánh sau tải lại/fork/xung đột đồng bộ |
| `generation` | số thế hệ công bố tăng đơn điệu trong nhánh |
| `parent_checkpoint_id` | cha trực tiếp |
| `created_from` | NEW/LOAD_BRANCH/RECOVERY/IMPORT/MIGRATION |
| `origin_digest` | bằng chứng nguồn của nhánh |

Tải checkpoint cũ rồi tiếp tục không ghi đè lịch sử mới hơn nếu policy chưa cho phép; nó tạo branch/generation rõ. Hai bản cùng `world_id` nhưng khác hậu duệ không được coi là “cùng save mới nhất” chỉ theo giờ thiết bị.

## 4. SaveSlotManifest

Mỗi slot có phần manifest nhỏ, có thể đọc trước khi nạp world:

- slot id và tên hiển thị;
- world/lineage/branch/generation/checkpoint ids;
- game instant và lịch hiển thị;
- schema/ruleset/content/fixture/policy versions;
- required content pack ids + hashes;
- platform writer id/version chỉ để chẩn đoán;
- save reason: MANUAL/AUTO/LIFECYCLE/CRASH_RECOVERY/MIGRATED/IMPORTED;
- completion state và root hash;
- thumbnail/text preview không thuộc state logic;
- previous valid generation refs.

Manifest không được chứa bí mật gameplay rồi hiển thị ngoài ViewProjection. Preview như vị trí/tình trạng P00 phải được tạo theo policy giao diện, không dùng debug state để lộ NPC mất tích hoặc vật giấu.

## 5. Vòng đời một thế hệ save

```text
REQUESTED
 -> CAPTURING
 -> STAGED
 -> VALIDATING
 -> COMMITTED
 -> PUBLISHED
```

Nhánh lỗi: `FAILED_RETAINED`, trong đó thế hệ trước vẫn dùng được. `PUBLISHED` chỉ sau khi payload đầy đủ, root refs tồn tại, hash/invariant đạt và con trỏ slot được đổi nguyên tử theo khả năng tầng lưu trữ.

Giao diện chỉ báo “đã lưu” ở PUBLISHED. CAPTURING/STAGED không được dùng làm checkpoint hợp lệ sau crash nếu thiếu marker hoàn tất.

## 6. SaveBoundaryToken

Scheduler phát `SaveBoundaryToken` khi:

- toàn bộ pha 10–80 tại `now_ms` đã khép;
- không có TransactionGroup ở giữa commit;
- mutation registry đã đóng;
- event wave hiện tại hoàn tất;
- các process đã tích phân tới boundary và giữ remainder;
- Command đến trước cửa nhận đã được xếp vào pending hoặc đã xử lý, không ở trạng thái mơ hồ;
- RNG draw đã cam kết có cursor/draw record tương ứng.

Token gồm now, phase=BOUNDARY, scheduler revision, state root revisions, transaction digest, queue head digest và RNG digest. Token hết hiệu lực nếu world tiến thêm trước lúc snapshot view được đóng.

## 7. Hai chiến lược capture cùng một hợp đồng

K2.5 cho phép triển khai sau này chọn:

| Chiến lược | Yêu cầu logic |
|---|---|
| `QUIESCENT_CAPTURE` | dừng tiến game ở boundary, chụp roots, công bố rồi chạy tiếp |
| `REVISION_PINNED_CAPTURE` | ghim immutable revisions tại boundary, game có thể tiếp tục trên revisions mới |

Cả hai phải tạo cùng SnapshotImage cho cùng token. Không cho copy record đang biến đổi mà không revision pin. Thời gian thật lâu hơn chỉ ảnh hưởng thông báo/hiệu năng, không đổi `now_ms`.

## 8. SnapshotImage tối thiểu

Snapshot giữ:

- WorldManifest và mọi version/policy/feature guard;
- `now_ms`, phase/boundary và calendar parameters;
- root của mọi record store sống;
- scheduler queue, statuses, subscriptions và recurrence cursors;
- active Action/Process/Movement, last integrated và remainder;
- Transaction/Reservation/Right/Obligation/ownership/Position;
- Fact/Observation/Message/Belief/Memory/Goal/Decision/Dialogue cần giữ;
- RNG streams/cursors/draws đã cam kết;
- id counters, idempotency sets và applied update digests;
- R0–R4 state, summary/materialization provenance;
- pause/overload/offline state;
- canonical root hash cùng per-store hashes.

Cache/index/view text có thể tái tạo không nằm trong state logic hoặc được đánh dấu disposable với builder version.

## 9. Record store và tính đóng của tham chiếu

Mỗi root trỏ một tập record theo domain. Snapshot chỉ hợp lệ khi:

1. mọi ref bắt buộc giải được trong generation hoặc immutable shared ancestor;
2. record revision đúng digest;
3. không có dangling owner/Position/event/source;
4. các ref vòng chỉ xuất hiện ở loại graph cho phép;
5. record tombstone còn nếu lịch sử sống đang trỏ;
6. Summary có provenance tối thiểu.

Không chỉ serialize “vật đang gần người chơi”. NPC xa, nợ, lời hứa, event chờ và nguồn nhận thức vẫn thuộc closure nếu có thể ảnh hưởng tương lai.

## 10. JournalEntry

Journal không phải log chữ tự do. Mỗi entry có:

- sequence trong branch;
- game instant, phase, wave;
- entry kind;
- command/event/transaction/update ids;
- precondition revision digest;
- mutation/result refs;
- RNG draw refs;
- previous entry hash và entry hash;
- ruleset/content/policy versions;
- committed marker.

Entry chưa committed bị bỏ khi phục hồi. Journal có thể lưu command+result, event transition hoặc mutation batch tùy kiến trúc; lựa chọn sau này phải đủ để replay/kiểm toán mà không gọi lại I/O bên ngoài hoặc mô hình ngôn ngữ không xác định.

## 11. JournalSegment và chain

Segment có first/last sequence, parent checkpoint, entry count, canonical digest và completion marker. Segment mới không thay nội dung segment đã công bố.

Hash chain phát hiện thiếu/đổi thứ tự; nó không tự chứng minh file không hỏng nếu thuật toán/khóa chưa định. Root checkpoint trỏ đúng segment range. Segment orphan sau crash được giữ để chẩn đoán hoặc dọn sau, không tự nối vào world chỉ vì sequence lớn.

## 12. Checkpoint

`Checkpoint` đóng gói:

| Trường | Ý nghĩa |
|---|---|
| `checkpoint_id` | danh tính bất biến |
| `base_snapshot_ref` | SnapshotImage nền |
| `journal_range` | có thể rỗng |
| `resolved_state_hash` | state sau replay range |
| `boundary_token_digest` | ranh giới nguồn |
| `validation_report_ref` | cổng đã đạt |
| `parent/branch/generation` | lịch sử |
| `status` | STAGED/VALID/INVALID/QUARANTINED |

Checkpoint được slot trỏ chỉ khi VALID. Một autosave mới hỏng không làm checkpoint cha mất VALID.

## 13. Công bố hai pha và chống mất save cũ

Quy trình logic:

1. tạo generation id mới, không ghi đè generation đang công bố;
2. ghi payload vào vùng staging;
3. đóng completion markers;
4. đọc lại metadata/hash cần thiết;
5. chạy structural + invariant validation;
6. tạo Checkpoint VALID;
7. đổi slot pointer sang generation mới;
8. giữ generation cha theo retention policy.

Nếu crash ở bước 1–6, slot vẫn trỏ bản cũ. Nếu crash khi đổi pointer, loader dùng pointer record có generation/checksum hợp lệ cao nhất theo lineage, không dùng modified time.

## 14. Lưu thủ công, tự động và lifecycle

| Loại | Trigger | Tính chất |
|---|---|---|
| MANUAL | yêu cầu người chơi | checkpoint có tên/ghi chú, không bị autosave ghi đè nếu chưa có policy |
| AUTO_INTERVAL | mốc game/real đã định | xoay vòng hữu hạn, chỉ tại boundary |
| AUTO_IMPORTANT | trước/sau quyết định hay biến cố theo policy | không lộ biến cố bí mật qua tên preview |
| LIFECYCLE | ứng dụng sắp xuống nền/đóng nếu còn thời gian | best effort, không được hứa chắc trước PUBLISHED |
| RECOVERY_MARKER | nhật ký tiến trình tối thiểu | hỗ trợ crash recovery, không tự là manual save |

Tần suất, số slot và chế độ tải lại thuộc TN05/chính sách trải nghiệm, chưa chốt trong K2.5.

## 15. Điện thoại xuống nền hoặc bị hệ điều hành đóng

Không giả định hệ điều hành luôn cho đủ thời gian chạy callback. Hợp đồng yêu cầu:

- duy trì checkpoint định kỳ đã công bố trong lúc chơi;
- khi nhận lifecycle signal, ngừng nhận Command mới ở cửa rõ ràng;
- nếu đang commit, hoàn tất nhóm nguyên tử hoặc bỏ nhóm chưa commit;
- capture boundary sớm nhất nếu ngân sách cho phép;
- giao diện hiển thị SAVING cho tới khi có durable publication acknowledgment;
- nếu bị giết đột ngột, phục hồi từ checkpoint+journal committed gần nhất;
- không dùng thời gian app nền làm game time trừ policy OFFLINE_CATCHUP đã chọn.

Mất vài giây tiến trình giữa checkpoint và entry chưa committed phải được báo như phục hồi kỹ thuật, không bịa kết quả tiếp theo.

## 16. Save giữa tám pha

Đề xuất mặc định là đợi BOUNDARY. Nếu ứng dụng chết giữa pha, journal/recovery marker cho biết:

- boundary checkpoint gần nhất;
- event/phase/wave nào đã committed;
- mutation group nào chưa committed;
- cursor RNG trước/sau draw đã cam kết;
- queue revision đã công bố.

Loader replay từ boundary và chỉ áp entry COMMITTED. Nó không tiếp tục từ object bộ nhớ dở dang. Một triển khai muốn snapshot giữa pha phải lưu đầy đủ phase cursor, wave frontier, mutation staging và locks; feature guard giữ UNSUPPORTED cho tới khi có validator riêng.

## 17. Transaction và Reservation khi crash

| Trạng thái trước crash | Phục hồi |
|---|---|
| PLAN/VALIDATING/RESERVED chưa commit | phục hồi đúng status nếu checkpoint giữ; không chuyển asset |
| COMMIT group chưa có committed marker | bỏ toàn group và trả về pre-state |
| COMMITTED có mutation digest | giữ chuyển đổi đúng một lần |
| receipt/ledger chưa viết sau transaction | có thể tạo tác vụ dẫn xuất idempotent nếu hợp đồng yêu cầu |
| Reservation đã hết hạn theo now lưu | expiry event còn trong queue hoặc được materialize đúng cursor |

Idempotency key và applied transaction digest là bắt buộc. Không “sửa” bằng cách trừ tiền lần nữa để khớp receipt.

## 18. Action, Process và Movement đang chạy

Mỗi process giữ start, last_integrated_at, input revisions, rate segments, remainder, next boundary event và interruption state.

Khi tải:

- không cộng lại đoạn đã tích phân;
- không làm tròn bỏ remainder;
- không tái tiêu hao input đã transaction hóa;
- kiểm Position/route và arrival event nhất quán;
- Action WAITING phải còn trigger/recheck;
- Action RUNNING phải có process/event hoặc bị loader từ chối.

Animation/thanh tiến trình giao diện không là nguồn phục hồi.

## 19. Scheduler, recurrence và queue

Snapshot/journal giữ event id, due time, phase, priority policy key, status, causal parent/depth, recurrence rule+cursor, exception refs và queue membership digest.

Loader xây lại index kỹ thuật rồi đối chiếu logical queue digest. Nó không:

- materialize thêm recurrence chỉ vì cách index mới;
- đổi thứ tự hòa theo id;
- đưa event stale về PENDING;
- xóa subscription BLOCKED;
- phát lại event COMPLETED/CANCELLED/CONSUMED_STALE.

Queue head phải không ở quá khứ trái policy; event cùng boundary tuân tám pha như trước save.

## 20. Command và input trong lúc lưu

Mỗi Command có idempotency key và `accepted_boundary`. Cửa nhận input phải quyết định rõ:

- command đã ACCEPTED và nằm trong state/journal;
- hoặc chưa nhận, client có thể gửi lại cùng key;
- không có trạng thái server áp command nhưng client được báo thất bại vĩnh viễn mà không thể đối chiếu.

UI lưu draft chưa gửi riêng với world state và ghi rõ nó chưa phải Command gameplay. Tải world không tự gửi draft cũ.

## 21. RNG và lựa chọn chưa hoàn tất

Snapshot giữ seed/stream/cursor; journal giữ draw đã cam kết cùng purpose. Quy tắc:

1. draw chỉ tăng cursor khi consumer logic commit theo hợp đồng;
2. draw dự kiến nhưng group abort không được biến thành kết quả gameplay;
3. replay dùng draw record/cursor đúng, không gọi RNG mới;
4. migration/validation/index build không rút RNG;
5. UI/preview/open slot không rút RNG.

DecisionFrame OPEN tại boundary phải giữ snapshot refs và RNG state; nếu thiết kế chỉ cho resolve nguyên tử, save đợi frame resolve hoặc abort có reason trước boundary.

## 22. Observation, Message và hội thoại

Save giữ ranh giới riêng:

- signal đã phát bao nhiêu thời lượng;
- ai thực sự đã quan sát;
- ComprehensionAttempt đã commit;
- Message actual receivers;
- DialogueTurn status và người đang chờ;
- payload/RenderedText refs;
- Belief/Appraisal updates đã áp.

Tải lại không cho người nghe thứ hai nhận lời đã nói nếu họ chưa có Observation trước save. Không phát lại Affect/Relationship update. RenderedText có thể tái tạo nếu chỉ là cache, nhưng phải giữ act/payload và không đổi meaning.

## 23. Belief, Memory, Goal và DecisionFrame

Các idempotency/applied sets cần giữ cho BeliefRevision, MemoryEncoding, Appraisal, RelationshipUpdate, Goal transition và DecisionTrace.

Sau tải:

- frame RESOLVED không chạy lại;
- frame OPEN chỉ tiếp tục nếu snapshot/revision vẫn hợp lệ;
- Goal BLOCKED còn subscription;
- expectation còn recheck trigger;
- Memory summary giữ source digest;
- freshness dựa trên game time, không dựa thời gian thiết bị vắng mặt dưới OFFLINE_STOP.

Không quên hoặc hồi phục cảm xúc chỉ vì người chơi đóng ứng dụng.

## 24. OfflinePolicy

K2.5 hỗ trợ hai policy có version nhưng không chọn TN02:

| Policy | Hành vi khi mở lại |
|---|---|
| `OFFLINE_STOP` | `now_ms` giữ nguyên; wall clock chỉ ở metadata chẩn đoán |
| `OFFLINE_CATCHUP` | tạo CatchupRequest từ checkpoint tới đích giới hạn và chạy scheduler đầy đủ |

CATCHUP không cộng thẳng nhu cầu, tiền, tuổi hoặc sản lượng. Nó phải xử event, transaction, perception, decision, nguy hiểm và auto-pause như mô phỏng thường. Cần giới hạn catchup chunk, quyền dừng, xử quá tải và chính sách khi P00 cần quyết định; thiếu thì feature UNSUPPORTED.

Thay đổi OfflinePolicy chỉ ở boundary và ghi vào world policy history; không áp hồi tố cho khoảng app đã đóng nếu chưa có lựa chọn rõ.

## 25. LoadPipeline

```text
DISCOVER
 -> READ_MANIFEST
 -> SELECT_VALID_GENERATION
 -> VERIFY_PAYLOAD
 -> RESOLVE_COMPATIBILITY
 -> BACKUP_IF_MIGRATING
 -> MIGRATE_IN_STAGING
 -> BUILD_DISPOSABLE_INDEXES
 -> VALIDATE_STRUCTURE
 -> VALIDATE_INVARIANTS
 -> VERIFY_STATE_HASH
 -> READY_PAUSED
 -> RESUME_BY_USER/POLICY
```

Thứ tự không được đổi theo hướng chạy world trước rồi mới kiểm. READY_PAUSED cho UI xem báo cáo và chính sách offline/migration; chưa phát gameplay event.

## 26. Chọn generation hợp lệ

Loader không dùng duy nhất tên file hoặc modified time. Nó xét slot pointer, branch/generation, completion marker, parent chain và hash.

Nếu generation mới nhất invalid:

1. cách ly nó;
2. thử previous valid generation cùng branch;
3. báo rõ mốc game bị lùi và lượng tiến trình có thể mất;
4. không xóa artifact lỗi trước khi người dùng/chính sách lưu giữ quyết định;
5. không gắn generation cũ thành mới nhất mà không tạo RecoveryRecord.

## 27. CompatibilityManifest

Loader so:

- schema version;
- ruleset version;
- từng content pack id/version/hash;
- fixture/base/overlay versions;
- policy versions;
- feature guards;
- canonical serialization/hash version;
- required migration graph.

Kết quả: `EXACT`, `MIGRATABLE`, `MISSING_CONTENT`, `FUTURE_VERSION`, `INCOMPATIBLE_RULESET`, `CORRUPT_OR_TAMPERED`, `UNSUPPORTED_FEATURE`.

Không coi cùng số phiên bản là tương thích nếu hash khác. Nội dung chỉ đổi văn bản dịch có thể ngoài state hash nếu manifest phân loại chính xác.

## 28. MigrationGraph

Mỗi `MigrationStep` có:

- from/to chính xác cho schema/ruleset/content/policy liên quan;
- preconditions;
- transform thuần trên staging state;
- mapping id/field/unit;
- loss classification;
- invariant suite trước/sau;
- expected canonical digest rule;
- rollback/discard procedure;
- migration tool version/hash.

Đường chuyển phải liên tục. Không nhảy qua bước nếu không có edge được khai báo. Chọn path theo compatibility policy cố định, không theo thứ tự file hệ thống.

## 29. Migration cấu trúc và migration ngữ nghĩa

| Loại | Ví dụ | Yêu cầu |
|---|---|---|
| cấu trúc | đổi tên trường, tách record, chuẩn hóa enum | bảo toàn ý nghĩa và refs |
| đơn vị | ml sang đơn vị nguyên mới | quy tắc exact/remainder, không làm tròn im lặng |
| nội dung | ItemType đổi schema/chia template | map instance/provenance cụ thể |
| luật | cách tính mới làm state cũ khó biểu diễn | cần semantic adapter hoặc báo không bảo toàn |
| policy | đổi TN/autonomy/offline | không viết lại quyết định quá khứ |

Migration không chạy scheduler, AI, RNG hay wall-clock logic. Nếu ý nghĩa cũ không biểu diễn được, dừng với báo cáo record bị ảnh hưởng; không dùng giá trị mặc định “hợp lý”.

## 30. Quy tắc migration theo miền

- **Vật/lot:** giữ lượng, Position, owner, provenance, contamination, quality và reservations.
- **Tiền/tài nguyên:** giữ conservation digest; mọi chênh phải có migration remainder record, không Source/Sink gameplay giả.
- **Cơ thể:** giữ part graph, wound/process/remainder; field mới unknown/unsupported theo hợp đồng, không coi khỏe.
- **Scheduler:** giữ due/phase/status/cursor/causal chain; không materialize lại.
- **Nhận thức:** giữ holder, proposition scope, evidence/lineage và applied updates.
- **Quyền/hợp đồng:** giữ recognition scope, interval, obligation progress và dispute.
- **R0–R4:** giữ summary provenance; không bịa episode khi đổi representation.

## 31. Backup trước migration và công bố kết quả

Trước migration, giữ immutable reference tới checkpoint nguồn. Toàn bộ transform diễn ra trong staging branch/generation với `created_from=MIGRATION`.

Chỉ công bố khi:

- tất cả step hoàn tất;
- validation report đạt;
- root refs/hash hợp lệ;
- report liệt kê warning/loss đã được policy cho phép;
- nguồn cũ vẫn truy cập được theo retention.

Migration thất bại không làm slot nguồn mất. Retry cùng tool/input phải idempotent hoặc tạo staging mới không chạm bản cũ.

## 32. Ruleset thay đổi và tính tái hiện lịch sử

State đã lưu giữ ruleset từng tạo Event/Decision/Transaction cũ. Sau migration, không chạy lại quá khứ bằng luật mới rồi thay kết quả.

Các process đang chạy cần adapter rõ:

- giữ kết quả đã tích phân tới boundary theo luật cũ;
- chuyển state/remainder sang luật mới tại mốc migration;
- ghi `RuleTransitionRecord` và event tương lai dùng luật mới;
- nếu không thể chuyển, yêu cầu kết thúc process bằng bản cũ hoặc từ chối migration.

DecisionTrace cũ vẫn giữ score/policy version cũ; không “sửa cho hợp lý”.

## 33. Content pack thiếu, thừa hoặc đổi

Save liệt kê content thực sự được instance/record sống tham chiếu. Khi tải:

- thiếu pack bắt buộc → MISSING_CONTENT, không thay ItemType bằng vật chung;
- pack thừa nhưng không được save dùng → có thể nạp ngoài state theo policy, chưa tự kích hoạt vào world;
- hash đổi cùng version → lỗi manifest;
- content đã bỏ cần migration mapping cụ thể;
- text/localization thay đổi không được làm id/type đổi.

Không xóa NPC/vật/công pháp vì “mod không có”; artifact thiếu phải được khôi phục hoặc migration có ý nghĩa.

## 34. Phát hiện hỏng dữ liệu

Các tầng kiểm:

1. kích thước/format/completion marker;
2. per-chunk/per-store digest;
3. manifest và reference closure;
4. journal hash chain/sequence;
5. canonical state hash;
6. invariant theo miền;
7. cross-store invariant;
8. optional replay/oracle check.

Hash mismatch chỉ nói dữ liệu không khớp, chưa tự kết luận nguyên nhân. Loader ghi CorruptionReport với vùng, expected/actual digest, dependency và khả năng fallback mà không lộ bí mật trong UI thường.

## 35. RepairPolicy: chỉ sửa từ bằng chứng

Phục hồi được phép từ:

- generation cha đã VALID;
- bản sao chunk cùng digest;
- journal committed có thể replay xác định;
- checkpoint replica cùng lineage/hash;
- migration inverse/forward đã khai báo.

Không được tự sửa bằng cách đặt lượng âm thành 0, đưa vật lạc về kho gần nhất, hồi sinh NPC, xóa event lỗi, cấp quyền mặc định hoặc tạo Source/Sink. Nếu không chứng minh được state, dừng và trình bày phạm vi mất.

## 36. Rollback kỹ thuật và tải lại gameplay

`TechnicalRecovery` chọn checkpoint VALID gần nhất vì bản mới hỏng; tạo RecoveryRecord và không mang ý nghĩa nhân vật quay ngược thời gian.

`UserLoadHistorical` là người chơi chủ động chọn checkpoint cũ. Nếu tiếp tục chơi, tạo branch mới. Giao diện phải nói rõ tiến trình hiện tại chưa lưu sẽ bị thay và cho lưu hiện tại nếu có thể.

Permadeath/một đời/kế thừa/quyền tải lại thuộc TN05. Dù chọn chế độ khắc nghiệt, checkpoint kỹ thuật vẫn cần để lỗi phần mềm không được tính thành hậu quả gameplay.

## 37. Autosave rotation và retention

Retention policy phân biệt:

- manual checkpoints;
- autosave generations;
- pre-migration backups;
- crash artifacts/quarantine;
- branch heads;
- exported archives.

Xóa chỉ khi không còn slot/branch/backup policy trỏ tới và dependency closure an toàn. Compaction không xóa Fact/Message/Contract nguồn còn được record sống tham chiếu; nó dùng Summary/tombstone theo K2.1/K2.4.

K2.5 chưa chốt số bản hay dung lượng. UI phải hiển thị tình trạng thiếu chỗ trước khi hứa lưu thành công.

## 38. Compaction

Compaction có thể:

- hợp nhất journal đã nằm trước snapshot verified;
- deduplicate immutable chunks theo digest;
- bỏ cache/index/RenderedText tái tạo được;
- dùng SummaryRecord đã được gameplay tạo hợp lệ;
- dọn staging/orphan hết hạn theo retention.

Compaction không được đổi resolved state hash logic, id counters, RNG, event order, provenance hay branch history. Chạy compaction hay không phải cho cùng diễn biến.

## 39. Export và import

Archive xuất gồm manifest, checkpoint closure, required content list, hashes và tùy chọn diagnostics đã lọc. Không đưa credential/token/path cá nhân vào archive.

Import:

1. không ghi đè slot hiện có theo tên;
2. kiểm archive trước khi giải nén/nạp;
3. tạo import staging;
4. xác minh compatibility/hash;
5. giữ world/lineage hoặc tạo imported lineage theo policy;
6. chỉ công bố sau validation.

Tên hiển thị, preview và text trong save là dữ liệu không tin cậy; không dùng chúng làm đường dẫn hay lệnh.

## 40. Đồng bộ điện thoại–máy tính là tính năng riêng

Yêu cầu đa nền tảng không tự suy ra cloud sync. Nếu sau này có đồng bộ, đơn vị là checkpoint/immutable chunk theo lineage, không phải copy file mới nhất theo timestamp.

Trạng thái replica có vector/ancestor knowledge đủ phát hiện:

- fast-forward cùng nhánh;
- cùng checkpoint;
- remote/local thiếu generation;
- divergence: hai branch cùng tiến triển;
- corrupt/incomplete upload.

Divergence không auto-merge world state. Người dùng chọn nhánh hoặc giữ cả hai; merge chỉ có thể có hợp đồng miền riêng trong tương lai. Upload/download không làm game time tiến.

## 41. Xung đột đồng bộ và chống nhân bản

Ví dụ cùng checkpoint C0:

- điện thoại tiến tới C1, tiêu 20 V01;
- máy tính offline tiến tới C2, dùng cùng 20 V01 mua vật khác.

Không gộp inventory của C1+C2. Hai kết quả là hai branch hợp lệ riêng. UI hiển thị game time, thiết bị ghi, summary đã lọc và ancestor; lựa chọn một branch không xóa branch kia ngay.

Nếu cùng Command idempotency key xuất hiện trên hai branch, nó chỉ chống lặp trong mỗi lineage history tương ứng, không chứng minh hai thế giới có thể merge.

## 42. Quyền riêng tư và dữ liệu chẩn đoán

Save gameplay chứa state cần thiết, kể cả bí mật NPC; ViewProjection ngăn UI lộ, nhưng file vật lý vẫn cần policy bảo vệ ở tầng triển khai sau.

Diagnostic export mặc định:

- loại credential/path/tên thiết bị nhạy cảm;
- cho chọn kèm hoặc không kèm world payload;
- không tự tải lên mạng;
- ghi rõ nếu chứa bí mật gameplay/debug;
- không thay state khi bật/tắt logging.

Mã hóa, khóa và dịch vụ tài khoản chưa được chọn; K2.5 không tuyên bố save đã an toàn trước truy cập ngoài game.

## 43. View giao diện lưu/tải

Người chơi cần thấy:

- tên slot, game time, policy offline, version và trạng thái xác minh;
- đang lưu/đã công bố/thất bại trung thực;
- manual/auto/recovery/migrated;
- nhánh và cảnh báo khi tải lịch sử;
- compatibility/missing content bằng ngôn ngữ dễ hiểu;
- migration đang staging và bản cũ vẫn còn;
- generation fallback cùng lượng tiến trình có thể mất;
- dung lượng/thiếu chỗ khi biết được.

Điện thoại dùng danh sách thẻ và trang chi tiết; máy tính có thể đặt lịch sử nhánh cạnh báo cáo. Cả hai gọi cùng Save/Load command, không dùng thao tác hover/nhấp phải thiết yếu.

## 44. Mã lỗi chính

| Mã | Ý nghĩa |
|---|---|
| `SAVE_NO_BOUNDARY` | token không hợp lệ/hết hiệu lực |
| `SAVE_INCOMPLETE_GENERATION` | staging thiếu completion marker |
| `SAVE_HASH_MISMATCH` | payload khác digest |
| `SAVE_DANGLING_REFERENCE` | closure thiếu record |
| `SAVE_INVARIANT_FAILED` | bất biến miền/cross-store sai |
| `SAVE_STORAGE_EXHAUSTED` | không đủ chỗ để công bố an toàn |
| `LOAD_NO_VALID_GENERATION` | không còn checkpoint hợp lệ |
| `LOAD_FUTURE_VERSION` | save mới hơn loader |
| `LOAD_MISSING_CONTENT` | thiếu pack bắt buộc |
| `LOAD_QUEUE_INCONSISTENT` | scheduler/process không khép |
| `MIGRATION_NO_PATH` | không có chuỗi step liên tục |
| `MIGRATION_LOSS_FORBIDDEN` | cần mất nghĩa nhưng policy cấm |
| `RECOVERY_ROLLBACK_REQUIRED` | phải về generation cha |
| `SYNC_DIVERGED` | hai nhánh cùng tiến triển |

Lỗi giữ artifact nguồn và tạo report. Không fallback thành new game hoặc state mặc định.

## 45. Sáu walkthrough chuẩn

### 45.1 Mua hai V02 rồi ứng dụng bị đóng

Nếu crash trước marker commit Transaction, bốn V01 và hai V02 đều ở pre-state. Nếu marker committed cùng mutation digest đã có, cả hai chiều chuyển đúng một lần. Receipt chưa viết có thể được tái tạo idempotent từ Transaction; không trừ tiền lại. Loader đối chiếu conservation digest trước READY_PAUSED.

### 45.2 Đang đi trên tuyến

P00 có MovementProcess đã tích phân tới 1.250.000 mm với remainder và arrival event. Save boundary giữ đúng distance/Position ON_ROUTE, rate segment và last_integrated_at. Tải lại tiếp từ đó; không đưa P00 về đầu/cuối tuyến theo thanh giao diện và không cộng đoạn thời gian ứng dụng đóng dưới OFFLINE_STOP.

### 45.3 Hội thoại bị ngắt giữa lượt

N05 đã phát tín hiệu đủ để N06 nghe nửa đầu nhưng ComprehensionAttempt chưa commit trước crash. Phục hồi chỉ dùng journal committed: hoặc Signal progress được giữ và lượt tiếp tục theo contract giữa pha, hoặc quay boundary trước lượt. Không tạo Message đầy đủ rồi phát lại Affect. Nếu DialogueTurn đã COMMITTED, actual receiver/payload được giữ đúng một lần.

### 45.4 Migration tách một Lot

Schema mới yêu cầu tách Lot theo contamination. Migration chỉ làm khi state cũ có dữ liệu partition xác định; child quantities/provenance/Position/owner/reservation cộng đúng parent. Thiếu dữ liệu thì dừng MIGRATION_LOSS_FORBIDDEN, không chia đều tùy ý hoặc đánh dấu tất cả sạch.

### 45.5 Autosave mới hỏng

Slot đang trỏ generation 20. Generation 21 ghi payload nhưng mất completion marker. Loader cách ly 21, xác minh 20, tạo RecoveryRecord và báo game time lùi. Nó không xóa 21 ngay và không chọn một file orphan có modified time mới hơn.

### 45.6 Hai thiết bị cùng chơi offline

Cả điện thoại và máy tính bắt đầu C0 rồi sinh C1/C2 khác nhau. Đồng bộ phát hiện common ancestor và divergence. Hai branch được giữ; không cộng tiền/vật/NPC event. Chọn C1 để tiếp tục chỉ đổi branch head người dùng chọn, không viết C2 thành “đã chưa xảy ra” trong cùng lịch sử.

## 46. Điều kiện kiểm thử LP01–LP48

1. LP01 — Save chỉ PUBLISHED sau payload, marker, hash và validation đạt.
2. LP02 — Crash trước publish giữ slot trỏ generation hợp lệ cũ.
3. LP03 — Snapshot BOUNDARY không chứa nửa TransactionGroup/event wave.
4. LP04 — SaveBoundaryToken hết hiệu lực khi world revision tiến thêm.
5. LP05 — Quiescent và revision-pinned capture cho cùng state hash với cùng token.
6. LP06 — Snapshot closure giữ cả NPC xa, nợ, event và nguồn đang được tham chiếu.
7. LP07 — Dangling ref/tombstone/provenance thiếu làm checkpoint invalid.
8. LP08 — Journal chỉ replay entry COMMITTED theo đúng sequence/hash chain.
9. LP09 — Orphan segment không tự nối vì có sequence hoặc timestamp lớn.
10. LP10 — Checkpoint invalid mới không làm checkpoint cha mất VALID.
11. LP11 — UI không báo đã lưu trước PUBLISHED.
12. LP12 — Manual save không bị autosave ghi đè khi thiếu policy cho phép.
13. LP13 — Preview slot không lộ Fact/NPC bí mật ngoài ViewProjection.
14. LP14 — Điện thoại bị kill đột ngột phục hồi từ committed checkpoint/journal gần nhất.
15. LP15 — Lifecycle save thất bại báo thật và không phá bản trước.
16. LP16 — Save/crash giữa pha chỉ replay mutation group committed.
17. LP17 — Transaction pre-commit không chuyển một nửa tiền/hàng sau tải.
18. LP18 — Transaction committed không bị áp lần hai dù receipt chưa có.
19. LP19 — Reservation/expiry/available projection giữ đúng qua tải.
20. LP20 — Process không tích phân lại đoạn đã lưu hoặc mất remainder.
21. LP21 — Movement giữ distance/route/Position/arrival event nhất quán.
22. LP22 — Recurrence cursor không sinh thiếu/thừa occurrence sau tải.
23. LP23 — Event COMPLETED/CANCELLED/STALE không trở lại PENDING.
24. LP24 — Command được nhận hoặc chưa nhận rõ; gửi lại cùng key không nhân hiệu ứng.
25. LP25 — Draft UI chưa gửi không tự thành Command sau tải.
26. LP26 — Replay không rút RNG mới và giữ cursor/purpose đúng.
27. LP27 — Observation/Message chỉ giữ actual receiver đã commit.
28. LP28 — Belief/Appraisal/Relationship/Memory update không phát lại.
29. LP29 — DecisionFrame RESOLVED không chạy lại; OPEN phải kiểm revision.
30. LP30 — OFFLINE_STOP không tăng game time, freshness, đói hoặc hồi phục.
31. LP31 — OFFLINE_CATCHUP chạy scheduler đầy đủ, không cộng thẳng số ngày.
32. LP32 — Loader validate/migrate/hash trước READY_PAUSED và chạy world.
33. LP33 — Generation được chọn theo manifest/chain/hash, không chỉ modified time.
34. LP34 — Future version/missing content không âm thầm tạo state mặc định.
35. LP35 — MigrationGraph không bỏ qua edge trung gian chưa khai báo.
36. LP36 — Migration không phát FactEvent, chạy AI hoặc rút RNG.
37. LP37 — Migration unit/lot/body giữ lượng, remainder và provenance hoặc dừng.
38. LP38 — Ruleset mới không viết lại DecisionTrace/Event quá khứ.
39. LP39 — Migration thất bại giữ checkpoint nguồn nguyên vẹn và tải được.
40. LP40 — Content pack thiếu không biến item/NPC/công pháp thành mẫu chung.
41. LP41 — Corruption detection xác định vùng lỗi và fallback không bịa state.
42. LP42 — Repair chỉ dùng bản sao/journal/checkpoint có digest chứng minh.
43. LP43 — TechnicalRecovery và UserLoadHistorical tạo record/branch khác nhau.
44. LP44 — Compaction không đổi resolved state hash hoặc diễn biến tiếp theo.
45. LP45 — Import không ghi đè slot theo tên và chỉ publish sau validation.
46. LP46 — Hai nhánh đồng bộ diverged không auto-merge tài sản/sự kiện.
47. LP47 — Cùng checkpoint nạp ra cùng state hash trên điện thoại và máy tính.
48. LP48 — Tắt/bật diagnostic, preview hoặc mở menu save không đổi state/RNG.

Thêm 48 LP vào 528 điều kiện trước đó thành **576 điều kiện thiết kế chưa chạy bằng validator/mô phỏng**.

## 47. Giới hạn và bước tiếp theo

K2.5 chưa chốt định dạng lưu, database, chunk size, hash/checksum, nén/mã hóa, tần suất autosave, số slot, dung lượng, dịch vụ cloud, merge branch, thời lượng catchup hoặc permadeath. Các lựa chọn trải nghiệm TN02/TN05 và công nghệ đa nền tảng vẫn mở.

K2.6–K2.7 đã định oracle và ngân sách save/storage/memory; gói được rà tại [[KIEM_TOAN_DONG_GOI_K2]], kiến trúc tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
