---
title: Bộ validator, oracle và kế hoạch chạy điều kiện — K2.6
aliases:
  - K2.6
  - Validator và oracle
tags:
  - reality-cultivation
  - thiet-ke
  - kiem-thu
  - validator
  - oracle
status: de-xuat
updated: 2026-09-06
---

# Bộ validator, oracle và kế hoạch chạy điều kiện — K2.6

Tài liệu này biến sổ điều kiện từ [[KIEM_TOAN_DONG_GOI_K1]] và K2.1–K2.5 thành hợp đồng kiểm chứng có thể mã hóa sau này. Nó dựa trên schema [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]], scheduler [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]], giao dịch [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]], tác nhân [[HOP_DONG_NHAN_THUC_QUYET_DINH_TAC_NHAN_K2]] và lưu tải [[HOP_DONG_LUU_TAI_MIGRATION_PHUC_HOI_K2]].

Đây vẫn là kế hoạch, chưa có bộ chạy hoặc bằng chứng máy. Không điều kiện nào trong 576 điều kiện trước được đổi từ “chưa chạy” thành PASS bởi tài liệu này.

## 1. Mục tiêu và ranh giới

K2.6 phải trả lời được:

- điều kiện nào tồn tại, thuộc tài liệu/fixture/phiên bản nào;
- cần dữ liệu đầu vào và policy nào để chạy;
- thao tác nào tạo tình huống;
- quan sát nào là kết quả thực tế;
- oracle nào có quyền kết luận;
- PASS khác “không crash” như thế nào;
- khi FAIL phải giữ đủ bằng chứng để tái hiện;
- hai nền tảng được so ở lớp logic nào;
- thay schema/ruleset làm kết quả cũ hết hiệu lực ra sao.

K2.6 không chọn framework test, ngôn ngữ, CI, thiết bị chuẩn hoặc ngưỡng hiệu năng. Nó cũng không viết gameplay để làm điều kiện “dễ đạt”.

## 2. Bảy bất biến của kiểm chứng

1. `NOT_RUN` không bao giờ được hiển thị là PASS.
2. Oracle đọc kết quả đã chạy, không sửa world để làm kết quả đúng.
3. Test phải khóa fixture/ruleset/content/policy/seed; thiếu một phần thì không thể so hợp lệ.
4. PASS chỉ có giá trị cho đúng fingerprint đã chạy.
5. Failure artifact phải đủ để replay mà không cần nhớ thao tác thủ công.
6. So parity dùng state/event logic chuẩn, không so bố cục hay thời gian CPU như nội dung gameplay.
7. Validator/oracle/log không được tiêu RNG, tạo event hoặc đổi state.

## 3. Các loại kiểm tra

| Loại | Câu hỏi |
|---|---|
| `STATIC_SCHEMA` | dữ liệu có đúng kiểu/miền/ref/version không? |
| `STATE_INVARIANT` | một snapshot có vi phạm bất biến không? |
| `TRANSITION` | pre-state + input có cho đúng post-state không? |
| `SCENARIO` | chuỗi A–E/30 ngày có đạt outcome theo mốc không? |
| `NEGATIVE` | input sai có bị từ chối mà không mutation không? |
| `METAMORPHIC` | biến đổi không liên quan có giữ kết quả bắt buộc không? |
| `REPLAY` | cùng run bundle có tái tạo cùng trace/hash không? |
| `DIFFERENTIAL` | hai runtime/nền tảng có cùng logic không? |
| `MIGRATION` | state trước/sau chuyển phiên bản có bảo toàn nghĩa không? |
| `PERFORMANCE` | đạt ngân sách đo đã chốt mà không giảm luật không? |
| `MANUAL_UX` | thao tác/trình bày có đáp ứng yêu cầu người dùng không? |

Một ConditionSpec có thể cần nhiều loại. Ví dụ LP17 cần TRANSITION + crash injection + REPLAY; NT44 cần DIFFERENTIAL; UI15 cần MANUAL_UX và command parity.

## 4. ConditionSpec

| Trường | Ý nghĩa |
|---|---|
| `condition_id` | id duy nhất toàn catalog |
| `title/statement` | mệnh đề phải kiểm, không chỉ tên ngắn |
| `source_doc/anchor/revision` | nơi phát sinh và phiên bản văn bản |
| `family/system_tags` | họ và hệ liên quan |
| `test_kinds` | một hay nhiều loại mục 3 |
| `fixture_requirements` | base/overlay/generator cần có |
| `version_constraints` | schema/ruleset/content/policy |
| `preconditions` | state hợp lệ trước run |
| `stimulus` | command/event/fault/migration cần đưa vào |
| `observation_window` | mốc bắt đầu/kết thúc/dừng |
| `oracle_refs` | kết luận mong đợi |
| `evidence_requirements` | artifact bắt buộc |
| `dependencies` | điều kiện/capability phải sẵn sàng |
| `automation_state` | SPECIFIED/ENCODABLE/IMPLEMENTED |
| `owner/status` | quản lý công việc, không đổi kết quả run |

`statement` là nguồn nghĩa. Tên test trong framework sau này chỉ là mapping; không được rút gọn làm mất phủ định, phạm vi thời gian hoặc điều kiện ngoại lệ.

## 5. Condition identity và registry

Registry dùng id hiện có: SK/VT/CB/CV/LT/GT, DS/LK/CS, LC/QD/SS/NX/DT/HS/VH/ST/NL/TL/DV, HD/LS/GV/NT/LP. ID không được tái sử dụng sau khi bỏ.

Mỗi entry có lifecycle:

- `ACTIVE`: nghĩa hiện tại phải chạy;
- `SUPERSEDED`: được điều kiện khác thay, giữ mapping/lý do;
- `RETIRED`: không còn áp dụng, giữ lịch sử;
- `DRAFT`: chưa tính vào tổng chính thức;
- `BLOCKED_SPEC`: mệnh đề chưa đủ để tạo oracle.

Sửa nghĩa đáng kể phải tăng `condition_revision`; không âm thầm dùng PASS cũ cho revision mới.

## 6. Inventory 576 điều kiện trước K2.6

| Nhóm | Họ | Số lượng | Tài liệu chủ quản |
|---|---|---:|---|
| DL01–DL06 | SK/VT/CB/CV/LT/GT | 12/14/14/16/16/16 = 88 | [[SINH_KE]], [[VAT_THE_THU]], [[CO_THE_THU]], [[CONG_VIEC_THU]], [[TU_LUYEN_THU]], [[CHIEN_DAU_THU]] |
| K0 state/link/care | DS/LK/CS | 16/16/18 = 50 | [[LUOC_DO_TRANG_THAI]], [[DU_LIEU_LIEN_KET_K0]], [[CHAM_SOC_K0]] |
| K1.1–K1.4 | LC/QD/SS/NX | 18/20/16/18 = 72 | lịch, nguồn quyết định, sổ 30 ngày, nhánh xung đột |
| K1.5–K1.8 | DT/HS/VH/ST | 22/20/22/24 = 88 | đời sống, hồ sơ NPC, văn hóa, sổ thể chế |
| K1.9–K1.11 | NL/TL/DV | 24/26/28 = 78 | năng lực, tâm lý, quyết định–hội thoại |
| K2.1–K2.5 | HD/LS/GV/NT/LP | 32/36/40/44/48 = 200 | năm hợp đồng K2 |
| **Tổng** | 25 họ | **576** | tất cả vẫn NOT_RUN |

BT01–BT12 và K1G01–K1G12 là cổng/tiêu chí tổng hợp, không cộng vào 576. Chúng trỏ tập điều kiện và EvidenceBundle thay vì được đếm như cùng một bài test hành vi.

## 7. Catalog nguồn người đọc và catalog máy

Markdown trong vault là nguồn giải thích cho người. Catalog máy tương lai là bản biểu diễn có kiểu dùng để chạy. Hai bản phải nối bằng `source_doc + anchor + condition_revision`.

Quy trình đồng bộ đề xuất:

1. phát hiện id trong Markdown;
2. đối chiếu mỗi id có đúng một ConditionSpec ACTIVE;
3. kiểm statement digest/anchor;
4. sinh báo cáo id thiếu, thừa, trùng, sai thứ tự;
5. người biên tập giải quyết, không tự đoán nghĩa từ câu văn;
6. catalog build có manifest/hash riêng.

Không coi regex tìm đủ 576 id là chứng minh catalog đúng nghĩa; đó chỉ là static inventory gate.

## 8. FixtureSpec

`FixtureSpec` có:

- fixture id/version và base hash;
- required content/ruleset/policy versions;
- initial snapshot hoặc construction recipe xác định;
- overlays có scope, precondition và conflict policy;
- command/event/fault script;
- run window/stop conditions;
- seed và RNG stream manifest;
- expected supported/unsupported features;
- cleanup/isolation policy.

Fixture không được dựa vào trạng thái còn sót từ test trước. Mỗi run bắt đầu từ immutable base hoặc bản dựng có cùng canonical hash.

## 9. Base, overlay và matrix variant

Base INIT-A…E giữ trạng thái chung. Overlay chỉ sửa trường liệt kê và có expected base revision/hash. Variant matrix tách:

- MSG/NOMSG;
- LOCAL/REMOTE;
- EARLY/LATE/ABSENT/INJURED;
- policy P00;
- OFFLINE_STOP/CATCHUP;
- R0–R4;
- mobile/desktop runtime;
- failure injection point.

Không ghép mọi chiều thành tích Descartes khổng lồ. ConditionSpec chỉ khai báo các chiều có thể đổi kết luận; pairwise/metamorphic coverage được dùng cho chiều phụ sau khi có lý do.

## 10. RunSpec và RunFingerprint

`RunSpec` đóng băng fixture, variants, command stream, start checkpoint, stop rule, timeout logic, seed/RNG, oracle set và artifact level.

`RunFingerprint` gồm hash của:

- catalog/condition revisions;
- fixture/base/overlay;
- schema/ruleset/content/policy;
- runner/validator/oracle implementations;
- canonical serialization version;
- platform runtime build;
- input/seed/fault schedule.

PASS chỉ gắn fingerprint. Thay oracle code, fixture hoặc ruleset làm kết quả cũ thành `STALE_RESULT`, không tự FAIL nhưng không dùng làm bằng chứng hiện tại.

## 11. Runner lifecycle

```text
DISCOVER -> PRECHECK -> BUILD_FIXTURE -> VALIDATE_INITIAL
-> EXECUTE -> OBSERVE -> ORACLE_EVALUATE
-> VALIDATE_FINAL -> PACKAGE_EVIDENCE -> PUBLISH_RESULT
```

Nhánh kết thúc: FAIL, ERROR, BLOCKED, UNSUPPORTED, INCONCLUSIVE. Runner không tiếp tục gameplay sau invariant nghiêm trọng chỉ để thu thêm PASS; nó đóng failure boundary và artifact trước.

## 12. Trạng thái kết quả

| Trạng thái | Nghĩa |
|---|---|
| `NOT_RUN` | chưa có run artifact |
| `BLOCKED` | dependency/fixture/oracle chưa đủ |
| `UNSUPPORTED` | feature guard chủ động chặn đúng hợp đồng |
| `PASS` | mọi oracle bắt buộc đạt trên fingerprint hiện tại |
| `FAIL` | world chạy nhưng mệnh đề bị phản chứng |
| `ERROR` | runner/validator/oracle/hạ tầng không cho kết luận |
| `INCONCLUSIVE` | artifact thiếu hoặc kết quả nằm ngoài miền oracle |
| `FLAKY` | cùng fingerprint cho kết quả khác; luôn chặn gate |
| `STALE_RESULT` | kết quả thuộc revision/version cũ |

Expected failure của NEGATIVE test chỉ PASS khi hệ từ chối đúng mã và state không đổi; không phải khi runner crash.

## 13. Validator khác Oracle

- `Validator`: kiểm dữ liệu/state/transition có tuân hợp đồng chung hay không.
- `Oracle`: kết luận outcome cụ thể của ConditionSpec.
- `Monitor`: quan sát trong lúc chạy và ghi violation sớm.
- `Gate`: tổng hợp nhiều RunResult/Evidence thành quyết định tiến độ.

Ví dụ validator phát hiện lượng âm ở bất kỳ run; oracle SK kiểm tổng V02/mốc bữa cụ thể. Một run có thể không âm nhưng vẫn FAIL vì giao sai người hoặc sai giờ.

## 14. OracleSpec

| Trường | Ý nghĩa |
|---|---|
| `oracle_id/version` | danh tính logic |
| `condition_ref` | điều kiện được kết luận |
| `input_artifacts` | state/event/trace/diff nào được đọc |
| `projection` | trường chuẩn cần so |
| `predicate` | mệnh đề xác định PASS/FAIL |
| `tolerance` | chỉ khi miền cho phép, có đơn vị |
| `failure_explanation` | expected/actual/source refs |
| `independence_notes` | tránh oracle chép lại implementation |
| `unsupported_domain` | khi nào không được kết luận |

Oracle không gọi gameplay action, không materialize event, không sửa index và không rút RNG. Chạy oracle hai lần cho cùng artifact phải cho cùng output.

## 15. Oracle độc lập và nguy cơ cùng sai

Nếu sản xuất và oracle dùng cùng hàm tính tổng, cùng lỗi có thể PASS. Kế hoạch ưu tiên:

- công thức oracle đơn giản, khai báo từ đặc tả;
- đối chiếu hai đại lượng độc lập như inventory ledger và đếm vật instance;
- golden nhỏ được tính tay cho fixture hữu hạn;
- metamorphic relation không cần biết outcome đầy đủ;
- differential runtime chỉ là bổ sung, vì hai runtime có thể cùng sai spec;
- review provenance của expected values.

Không tự động cập nhật golden chỉ vì output mới khác.

## 16. StaticValidator

Chạy trước mô phỏng:

- id/domain/ref/revision/version;
- unit/range/enum/unknown/null;
- containment/part graph không vòng;
- one Position/Body constraints;
- fixture base/overlay scope;
- event/recurrence/trigger shape;
- contract/right/transaction field closure;
- proposition/source lineage;
- save manifest/reference closure;
- catalog/condition uniqueness.

Static PASS không chứng minh transition hoặc lịch 30 ngày đúng.

## 17. InvariantMonitor

Monitor chạy ở boundary và sau mutation group theo mức chi phí:

| Mức | Thời điểm | Ví dụ |
|---|---|---|
| I0 | mọi mutation commit | quantity không âm, ref tồn tại, atomic group |
| I1 | mọi game boundary | Position, queue, process, reservation, RNG cursor |
| I2 | mốc fixture/oracle | conservation toàn miền, lịch/tri thức/quyền |
| I3 | cuối run | closure, leak/orphan, summary/save hash |

Tắt monitor tối ưu không được đổi logic. Bản kiểm chứng phải chạy mức ConditionSpec yêu cầu; PASS ở I0 không thay I2/I3.

## 18. TransitionOracle

Một transition oracle giữ:

- pre-state projection/hash;
- stimulus và accepted boundary;
- expected mutation set hoặc predicate;
- forbidden mutations;
- post-state projection/hash;
- event/transaction/reason refs.

Không cần golden toàn thế giới. Ví dụ “mua hai V02” chỉ định bốn V01/two V02 đổi title/custody/Position, totals bảo toàn, unrelated store hash không đổi và đúng FactEvent được tạo.

## 19. ScenarioOracle

Scenario oracle theo mốc thay vì chỉ end-state:

- sequence/pattern sự kiện bắt buộc;
- khoảng thời gian và thứ tự nhân quả;
- state assertions tại checkpoints;
- allowed variants;
- forbidden outcomes;
- stop/failure conditions;
- summary cuối.

Hai đường hợp lệ khác nhau có thể cùng PASS nếu spec cho phép. Không dùng một event trace vàng duy nhất cho NPC tự chủ trừ khi fixture/policy khóa lựa chọn.

## 20. ConservationOracle

Theo từng `ConservationDomain`:

`opening + sources + transfers_in = closing + sinks + transfers_out`

Oracle đối chiếu:

- instance/lot/resource totals;
- Transaction legs;
- Source/Sink/Transformation records;
- container/component attachment;
- process remainder;
- migration remainder;
- ownership/available projection không bị đếm như vật mới.

Giá trị, danh tiếng và utility không là vật chất bảo toàn. Sai ledger không được dùng để cân world state.

## 21. SchedulerOracle

Kiểm:

- due time/phase/wave và causal depth;
- recurrence anchor/index/exception;
- stale/cancelled/completed lifecycle;
- queue head và không event quá khứ trái policy;
- process integration/remainder;
- conflict policy thay vì id tie-break;
- trigger subscription và không polling;
- pause/overload không bỏ luật.

Trace comparator chuẩn hóa thứ tự serialization nhưng vẫn giữ nhóm đồng thời; không bịa thứ tự nghiệp vụ giữa event cùng pha nếu spec coi đồng thời.

## 22. EpistemicOracle

Oracle nhận thức tách hai view:

- `OmniscientAuditView` để biết Fact/signal thực;
- `CognitiveView(actor)` để xác nhận actor chỉ dùng nguồn được phép.

Nó kiểm source chain, actual receiver, identity uncertainty, freshness, evidence independence, inference premises, known option sources và DecisionFrame snapshot. PASS không yêu cầu NPC tin Fact đúng; nhiều test yêu cầu NPC giữ niềm tin sai hợp lý.

Không dùng private explanation làm dữ liệu P00 nhìn thấy.

## 23. TransactionOracle

Kiểm lifecycle plan/reservation/commit, expected revisions, right scope, atomic mutation, ownership/custody/Position, obligations và compensation.

Hai projection bắt buộc:

1. state vật lý/pháp lý thật;
2. ledger/receipt/audit records trỏ state change.

Oracle không coi receipt là bằng chứng duy nhất tiền đã chuyển. Negative transaction phải chứng minh forbidden mutation set rỗng.

## 24. Body, cultivation và combat oracle

Các oracle miền đọc đơn vị/part graph/process cụ thể:

- thương tích theo site/tissue/function và treatment transaction;
- nhu cầu, dịch, hồi phục theo tích phân/remainder;
- linh lực P/B/route/source/sink;
- tiếp xúc, phòng hộ, impulse/damage package;
- capability derived với input revisions.

Không dùng thanh HP hoặc câu kể làm expected state nếu fixture không định. FX-E-BOTH hiện thiếu oracle số hợp nhất phải BLOCKED_SPEC, không tự điền từ E-LINH/E-VAT-LY.

## 25. SaveMigrationOracle

Kiểm:

- generation publication/parent chain;
- crash point trước/sau committed marker;
- snapshot/journal resolved hash;
- no replay of transaction/message/appraisal/RNG;
- migration preservation theo miền;
- invalid generation fallback;
- branch divergence không merge;
- compaction không đổi state/continuation.

Fault injector chỉ cắt ở điểm đã định và không sửa payload ngoài kịch bản lỗi. Mỗi crash run ghi điểm cắt chính xác.

## 26. MetamorphicOracle

Khi outcome đầy đủ quá lớn, dùng quan hệ biến hình:

- mở/đóng UI không đổi state/RNG;
- đổi ngôn ngữ/bố cục không đổi Command payload;
- đổi thứ tự serialize Set không đổi canonical hash;
- thêm event không liên quan với RNG stream riêng không đổi đột phá;
- chạy save/load giữa hai boundary tương đương không đổi continuation;
- QUIESCENT và REVISION_PINNED capture cho cùng snapshot;
- R0/R1 cho sự kiện bắt buộc cho cùng logical outcome;
- tách một TransactionPlan thành preview nhiều lần không commit thêm.

Mỗi relation khai báo phần state được phép khác như cache/RenderedText/metric.

## 27. ReplayOracle

Replay bundle gồm start checkpoint, input stream, fault schedule, RNG, versions và stop condition. So:

- state hash tại checkpoints;
- FactEvent/Transaction/Decision identity và payload digest;
- queue/process cursors;
- RNG draws;
- result statuses;
- allowed nondeterministic metadata bị loại.

Wall-clock duration, thread scheduling, log order không nghiệp vụ và text dịch không thuộc equality logic. Replay mismatch phải chỉ ra checkpoint đầu tiên lệch.

## 28. Differential/parity oracle

So sánh ít nhất hai runtime build/nền tảng với cùng RunSpec. `PlatformResult` giữ platform/runtime/architecture/build và logical artifacts.

Ba lớp:

1. canonical input digest giống;
2. checkpoint/event/transaction/RNG digest giống;
3. final logical state hash giống.

UI screenshot không dùng chứng minh logic parity. Ngược lại state parity không chứng minh giao diện điện thoại dùng được; UI conditions cần manual/automation riêng.

## 29. Determinism audit

Một run fingerprint được lặp nhiều lần trên cùng và khác nền tảng. Nếu có lệch:

- tìm checkpoint đầu tiên;
- so input acceptance boundary;
- event/wave order;
- iteration order của Set/Map;
- fixed-point/remainder;
- RNG stream/cursor;
- uninitialized/unknown field;
- wall-clock/device dependent branch;
- oracle nondeterminism.

Không gắn FLAKY thành PASS theo tỷ lệ. Mọi flakiness logic chặn gate tái hiện.

## 30. NegativeTest và fault injection

Danh mục lỗi có kiểm soát:

- ref/id/unit/version sai;
- quyền/Position/quantity thiếu;
- stale revision và duplicate idempotency;
- event quá khứ/vòng nhân quả;
- Message tới sai receiver;
- migration thiếu path;
- save thiếu marker/chunk/hash;
- crash trước/sau commit;
- storage exhausted;
- content pack thiếu;
- sync divergence.

Fault schedule là input được log. Không dùng lỗi ngẫu nhiên ngoài seed vì không thể tái hiện.

## 31. Generator và property-based test tương lai

Generator chỉ tạo state trong miền schema và có proof/validator cho preconditions. Nó có version, seed, size, shrink rules và feature guards.

Thuộc tính phù hợp:

- không lượng âm;
- one Position;
- split/merge bảo toàn;
- transaction atomic;
- recurrence không trùng;
- save/load continuation;
- belief source closure;
- graph không vòng;
- migration idempotent nơi được yêu cầu.

Generator không thay fixture có câu chuyện/mốc cụ thể. Random state invalid chỉ hữu ích cho NegativeTest được nhãn rõ.

## 32. Shrink và giảm failure

Khi property/scenario FAIL, reducer thử giảm:

- command/event không liên quan;
- NPC/vật/place ngoài dependency closure;
- run window;
- overlay fields;
- số recurrence;
- fault schedule;
- seed complexity.

Mỗi bước chỉ được giữ nếu failure predicate và initial validity vẫn còn. Minimized artifact trỏ original artifact; không ghi đè bằng case nhỏ làm mất bằng chứng bối cảnh.

## 33. EvidenceBundle

Một kết quả có giá trị giữ:

- RunFingerprint/RunSpec/ConditionSpec digests;
- initial/final checkpoint refs và hashes;
- input/command/fault stream;
- event/transaction/RNG/decision trace cần thiết;
- validator/oracle outputs;
- first failure boundary;
- expected vs actual projections;
- platform/build/version metadata;
- stdout/log chẩn đoán đã lọc nếu có;
- result status, time measured và artifact manifest.

Không cần lưu toàn state cho mọi PASS nếu retention cho phép dùng content-addressed checkpoint chung. FAIL/FLAKY phải giữ closure đủ replay.

## 34. FailureArtifact

Failure artifact ưu tiên khả năng hành động:

| Phần | Nội dung |
|---|---|
| mệnh đề | condition/revision đã bị phản chứng |
| điểm đầu lệch | game time/phase/wave/event/transaction |
| expected/actual | projection nhỏ nhất đủ hiểu |
| causal slice | nguồn/refs dẫn tới khác biệt |
| reproduction | checkpoint + inputs + versions + seed |
| invariants liên đới | pass/fail/error |
| scope | một platform hay mọi platform |
| artifacts | đường dẫn/digests, không chỉ câu log |

Log “expected true, got false” không đủ. Failure explanation không được lộ bí mật gameplay trong UI người chơi; đây là công cụ phát triển.

## 35. Golden artifact

Golden chỉ dùng cho fixture nhỏ, output ổn định và review được. Mỗi golden có source rationale, version và generator/hand-authored marker.

Quy tắc đổi golden:

1. xác định spec thay hay implementation sai;
2. nếu spec thay, tăng condition/oracle/fixture revision;
3. review diff theo miền, không accept all;
4. lưu golden cũ cùng kết quả lịch sử;
5. không dùng output hiện tại tự làm expected trong cùng run.

Trace NPC dài nên so predicate/checkpoint thay vì snapshot toàn văn dễ vỡ.

## 36. CoverageMap

Coverage không chỉ là dòng mã. Mỗi ConditionSpec map tới:

- hệ thống/record/transition;
- fixture/variant;
- phase/time window;
- positive/negative path;
- oracle kind;
- platform;
- save/replay point;
- policy/R-level;
- evidence state.

Dashboard phải chỉ ra vùng chưa phủ và BLOCKED_SPEC. Phần trăm điều kiện PASS không được che việc một bất biến nền như atomicity hoặc source knowledge chưa chạy.

## 37. DependencyGraph của điều kiện

Ví dụ:

- scenario SK/CV phụ thuộc schema HD, scheduler LS và transaction GV;
- QD/DV phụ thuộc epistemic NT;
- mọi replay/parity phụ thuộc LP;
- migration test phụ thuộc state validators miền;
- UI parity phụ thuộc Command/ViewProjection schema;
- performance gate phụ thuộc logic correctness trước.

Dependency PASS không tự làm condition con PASS. Khi dependency FAIL/ERROR, condition con BLOCKED để tránh chuỗi failure giả.

## 38. Các tầng chạy

| Tầng | Phạm vi | Mục đích |
|---|---|---|
| V0 | catalog/static schema/docs links | lỗi nhanh trước runner |
| V1 | record + single transition + negative | nền dữ liệu/nguyên tử |
| V2 | subsystem processes và short replay | scheduler, body, transaction, cognition |
| V3 | chuỗi A–E và 30 ngày | tích hợp đời sống |
| V4 | save/migration/crash/parity | độ bền và đa nền tảng |
| V5 | dài hạn R0–R4, tải và hiệu năng | quy mô sau khi đúng logic |

Không chạy V5 để khoe tốc độ khi V1 atomicity còn FAIL. Tuy vậy mọi condition giữ trong catalog; không xóa tham vọng dài hạn.

## 39. Thứ tự đưa 576 điều kiện vào máy

1. Inventory + ConditionSpec skeleton cho đủ 576.
2. Mã hóa 50 DS/LK/CS và 200 HD/LS/GV/NT/LP làm nền hợp đồng.
3. Mã hóa 88 DL theo sáu subsystem.
4. Mã hóa 72 LC/QD/SS/NX cho lịch và nhánh.
5. Mã hóa 166 DT/HS/VH/ST/NL/TL/DV còn lại của K1.
6. Nối BT01–BT12 và K1G thành gates.
7. Chạy replay/parity/save/crash matrix.
8. Sau correctness mới benchmark 5 giây/ngày.

Đây là thứ tự phụ thuộc, không phải quyết định cắt NPC sâu khỏi game.

## 40. Mẫu ConditionSpec: DS05

```text
condition_id: DS05
kind: [TRANSITION, NEGATIVE, STATE_INVARIANT]
fixture: TXN-ATOMIC-MIN-v1
stimulus: commit cùng idempotency key hai lần; một variant làm precondition sai
oracle:
  - lần đầu áp đúng một mutation group
  - lần hai trả kết quả cũ, state hash không đổi
  - variant sai không áp mutation nào
evidence: pre/post hash, transaction trace, mutation digest, idempotency registry
```

Mẫu không chọn serialization cụ thể. “Không áp lần hai” được chứng minh bằng state/trace, không chỉ đếm một dòng log.

## 41. Mẫu ConditionSpec: NT13

```text
condition_id: NT13
fixture: BELIEF-STALE-STOCK-v1
fact: kho giảm sau khi N01 rời nơi
cognitive_input: không Message/Observation mới tới N01
oracle:
  - world quantity đổi
  - Belief last-seen của N01 không tự đồng bộ Fact
  - DecisionFrame chỉ đọc CognitiveView
  - khi kiểm kho, Observation mới mới cho phép revision
```

Oracle chủ ý mong niềm tin sai tồn tại; so Belief với Fact bằng equality sẽ là oracle sai.

## 42. Mẫu ConditionSpec: LP17

```text
condition_id: LP17
matrix: crash_before_commit_marker / crash_after_commit_marker
fixture: PURCHASE-2-V02-v1
oracle before:
  tiền và hàng đều pre-state
oracle after:
  hai chiều đều post-state đúng một lần
common:
  conservation giữ; receipt không là nguồn chuyển; replay hash ổn định
```

Fault injector phải cắt đúng marker đã log. Kill ở thời điểm thật không xác định không đủ làm bằng chứng chuẩn.

## 43. Policy matrix và lựa chọn chưa chốt

TN01–TN08 chưa được xác nhận. Catalog gắn:

- `UNCONFIRMED_FIXTURE_DEFAULT` cho fixture hiện tại;
- `REQUIRES_POLICY_CHOICE` nếu outcome khác bản chất;
- nhiều expected branch nếu hợp đồng hỗ trợ cả hai;
- không chạy/không PASS condition phụ thuộc policy thiếu.

Ví dụ OFFLINE_STOP và CATCHUP là hai variant riêng; kết quả của một variant không xác nhận TN02. PLAYER_DIRECT không xác nhận TN03.

## 44. Manual UX evidence

Điều kiện giao diện cần task script giống nhau về ý nghĩa trên mobile/desktop:

- giao/chỉnh/hủy Goal;
- xem lý do việc kẹt;
- đọc điều khoản/nguồn tri thức;
- phản hồi tự dừng;
- lưu/tải/phục hồi;
- thao tác không hover/right-click bắt buộc;
- không cuộn ngang toàn trang cho tác vụ chính.

Evidence gồm viewport/device class, input method, command payload, completion, lỗi và ảnh/video khi cần. UI PASS không thay logic parity; logic PASS không thay usability.

## 45. Performance measurement contract

K1G12 chưa có ngưỡng. Trước benchmark phải định:

- thiết bị/cấu hình tham chiếu tối thiểu;
- world/fixture/seed/policy/R-level;
- warm/cold load;
- khoảng game time và số lần lặp;
- wall time đơn điệu, memory, save size, battery proxy nếu có;
- percentile/chấp nhận;
- correctness monitors bật;
- overload/failure policy.

Mục tiêu 5 giây/ngày là yêu cầu nhịp gameplay khi đủ hiệu năng. Benchmark không được bỏ event, giảm cognition budget logic hoặc hạ R-level ngoài RunSpec để đạt số đẹp.

## 46. Flaky, quarantine và retry

Retry không biến một FAIL thành PASS bằng đa số. Nếu lần lặp khác nhau cùng fingerprint:

- trạng thái FLAKY;
- giữ mọi artifact khác nhau;
- chặn gate liên quan;
- quarantine chỉ tách lịch chạy, không coi đạt;
- điều tra nondeterminism trước cập nhật baseline.

Infrastructure ERROR có thể retry theo policy nhưng lịch sử lỗi vẫn giữ. Timeout logic khác timeout hạ tầng phải phân biệt.

## 47. GateReport

Một gate có:

- gate id/version;
- condition selection cố định;
- acceptable statuses;
- required platform/variant matrix;
- freshness window theo build;
- evidence completeness rules;
- blocking dependencies;
- signed/content-addressed report digest nếu triển khai hỗ trợ;
- conclusion + danh sách ngoại lệ rõ.

Gate không tự chọn bỏ condition FAIL. Waiver nếu có phải có phạm vi, lý do, người/quyết định, hạn và không đổi RunResult gốc.

## 48. Ánh xạ BT01–BT12

| Cổng BT | Nguồn bằng chứng chính |
|---|---|
| BT01 một nguồn dữ liệu | HD/DS + reference closure |
| BT02–BT04 thời gian/vị trí/vật chất | LS/GV + scenario A–E |
| BT05 cơ thể | CB/CS + Body oracle |
| BT06 NPC/tri thức | QD/NT/DV + epistemic oracle |
| BT07 kinh tế/quyền | SK/CV/ST/GV |
| BT08 tu luyện | LT + conservation/process |
| BT09 chiến đấu | GT + phase/contact oracle |
| BT10 lưu/tải | DS14/LK16/LP |
| BT11 trở ngại giải thích | CV/QD/NX/NT traces |
| BT12 hiệu năng/ổn định | correctness gates + benchmark contract |

BT chỉ đạt khi mọi condition bắt buộc và evidence matrix đạt; “đạt trên giấy” được ghi riêng.

## 49. Nâng K1G01–K1G12

| Gate | Sau K2.6 trên giấy |
|---|---|
| K1G01–K1G08 | giữ kết quả kiểm toán tài liệu, không phải run result |
| K1G09 | schema/validator đã được đặc tả; vẫn chưa có implementation |
| K1G10 | catalog/run plan đã đặc tả; 576 vẫn NOT_RUN |
| K1G11 | parity/save evidence contract đã có; chưa chạy |
| K1G12 | measurement contract có, thiếu thiết bị/ngưỡng/run |

Không đổi chữ “chưa chạy” chỉ vì cổng đã được mô tả chi tiết hơn.

## 50. Báo cáo tiến độ trung thực

Dashboard tối thiểu hiển thị:

- tổng ACTIVE theo family/revision;
- SPECIFIED/ENCODABLE/IMPLEMENTED;
- NOT_RUN/BLOCKED/UNSUPPORTED/PASS/FAIL/ERROR/INCONCLUSIVE/FLAKY/STALE;
- coverage theo system/fixture/platform/policy;
- evidence completeness;
- oldest current PASS fingerprint;
- blockers có dependency;
- gate conclusions.

Không gộp UNSUPPORTED/BLOCKED vào PASS hoặc bỏ khỏi mẫu số mà không ghi. “90% test pass” phải kèm số chưa chạy và phạm vi build.

## 51. Bảo quản bằng chứng và dữ liệu riêng

PASS artifacts có thể rút gọn theo content-addressed retention; FAIL/FLAKY/gate release giữ lâu hơn. Chính sách phải giữ:

- manifest/digest ngay cả khi payload được dọn;
- reproduction closure cho failure còn mở;
- migration source/target;
- platform parity pair;
- waiver/gate history.

World fixture có bí mật NPC nhưng là dữ liệu thử. Artifact từ save người chơi thật không được tự thu thập/tải lên; diagnostic export theo K2.5 và cần hành động rõ của người dùng nếu sau này triển khai.

## 52. Mã lỗi validator/runner

| Mã | Ý nghĩa |
|---|---|
| `CATALOG_DUPLICATE_ID` | id ACTIVE trùng |
| `CATALOG_SOURCE_DRIFT` | văn bản/anchor khác revision |
| `FIXTURE_HASH_MISMATCH` | base/overlay không đúng |
| `PRECONDITION_FAILED` | run không bắt đầu trong state yêu cầu |
| `RUNNER_UNSUPPORTED_FEATURE` | feature guard chặn |
| `RUNNER_TIMEOUT_LOGIC` | không đạt stop condition game |
| `RUNNER_INFRA_ERROR` | lỗi hạ tầng không kết luận gameplay |
| `ORACLE_MISSING_INPUT` | thiếu artifact cần đọc |
| `ORACLE_DOMAIN_ERROR` | outcome ngoài miền oracle |
| `ORACLE_NONDETERMINISTIC` | cùng artifact cho kết luận khác |
| `INVARIANT_VIOLATION` | state/transition sai hợp đồng |
| `REPLAY_DIVERGENCE` | hash/trace lệch khi replay |
| `PARITY_DIVERGENCE` | hai runtime lệch logic |
| `EVIDENCE_INCOMPLETE` | không đủ bundle để công bố |

Reason code không thay FailureArtifact chi tiết.

## 53. Kế hoạch triển khai sau khi được yêu cầu viết mã

Chặng có thể review:

1. catalog loader + static inventory cho 576;
2. canonical state projection + validators I0/I1;
3. deterministic runner cho transition nhỏ;
4. evidence bundle + replay;
5. domain oracles DS/HD/LS/GV/NT/LP;
6. fixture A–E và scenario oracles;
7. crash/migration/parity harness;
8. manual UI scripts;
9. benchmark sau correctness.

Mỗi chặng phải tạo artifact thật trước khi đổi trạng thái. Đây là roadmap triển khai, không phải xác nhận bắt đầu code.

## 54. Điều kiện kiểm thử VO01–VO52

1. VO01 — Mỗi condition ACTIVE có id/revision/source duy nhất.
2. VO02 — Catalog thiếu/thừa/trùng so Markdown bị báo, không tự đoán nghĩa.
3. VO03 — Đủ id không được coi là đủ ConditionSpec/oracle.
4. VO04 — Sửa statement đáng kể làm PASS cũ thành STALE_RESULT.
5. VO05 — Fixture run bắt đầu từ base hash đúng, không dính state test trước.
6. VO06 — Overlay sai scope/revision bị từ chối trước execute.
7. VO07 — RunFingerprint khóa catalog/fixture/ruleset/policy/runner/oracle/platform/input.
8. VO08 — NOT_RUN/BLOCKED/UNSUPPORTED không hiển thị thành PASS.
9. VO09 — Negative test chỉ PASS khi đúng refusal và forbidden mutation rỗng.
10. VO10 — Runner ERROR không được coi là expected failure gameplay.
11. VO11 — Validator/oracle chạy không đổi state, event, index logic hoặc RNG.
12. VO12 — Oracle lặp cùng artifact cho cùng kết luận.
13. VO13 — Static schema PASS không tự làm transition/scenario PASS.
14. VO14 — Invariant monitor chụp first violating boundary trước khi chạy tiếp.
15. VO15 — Transition oracle giữ pre/stimulus/post và forbidden mutation.
16. VO16 — Scenario oracle cho phép đúng các variant đã khai báo, không ép một trace vàng.
17. VO17 — Conservation oracle không đếm ownership/ledger như vật mới.
18. VO18 — Scheduler oracle không dùng id serialization làm tie-break logic.
19. VO19 — Epistemic oracle cho phép Belief sai nhưng cấm nguồn toàn tri.
20. VO20 — Transaction oracle kiểm state thật độc lập receipt/ledger.
21. VO21 — FX-E-BOTH thiếu số giữ BLOCKED_SPEC, không bịa expected.
22. VO22 — Save oracle phân biệt crash trước/sau committed marker.
23. VO23 — Metamorphic relation khai báo rõ projection được phép khác.
24. VO24 — Mở UI/preview không đổi state hash hoặc RNG.
25. VO25 — Replay bundle tái tạo cùng checkpoint/event/RNG/result digest.
26. VO26 — Replay mismatch chỉ ra checkpoint đầu tiên lệch.
27. VO27 — Parity so canonical logic, không dùng screenshot thay state.
28. VO28 — Logic parity không tự chứng minh usability mobile/desktop.
29. VO29 — Cùng fingerprint khác outcome bị FLAKY và chặn gate.
30. VO30 — Retry không chọn đa số để đổi FLAKY/FAIL thành PASS.
31. VO31 — Fault injection có điểm/seed/version và tái hiện được.
32. VO32 — Generator chỉ tạo positive state sau precondition validator.
33. VO33 — Shrink giữ initial validity và cùng failure predicate.
34. VO34 — Minimized artifact giữ liên kết artifact thất bại gốc.
35. VO35 — EvidenceBundle đủ fingerprint/input/checkpoints/oracle/platform.
36. VO36 — FailureArtifact chứa expected/actual, first divergence và reproduction closure.
37. VO37 — Golden không tự cập nhật từ output khác trong cùng run.
38. VO38 — Đổi golden vì spec tăng revision và giữ lịch sử cũ.
39. VO39 — Coverage map hiển thị BLOCKED_SPEC và matrix chưa phủ.
40. VO40 — Dependency FAIL/ERROR làm test con BLOCKED, không tạo chuỗi FAIL giả.
41. VO41 — V5 performance không chạy thay correctness gate V1–V4.
42. VO42 — 576 điều kiện kiểm kê đúng 25 họ và đúng nguồn chủ quản.
43. VO43 — BT/K1G là gate tổng hợp, không bị đếm lặp vào condition total cũ.
44. VO44 — Policy chưa chốt tạo variant/blocker, không âm thầm xác nhận TN.
45. VO45 — Manual UX giữ cùng Command payload trên mobile/desktop.
46. VO46 — Benchmark khóa fixture/device/policy/monitor và không hạ luật để đạt tốc độ.
47. VO47 — Gate không bỏ condition FAIL; waiver giữ reason/scope/expiry.
48. VO48 — Dashboard báo đủ PASS/FAIL/NOT_RUN/BLOCKED/ERROR/FLAKY/STALE.
49. VO49 — Retention không xóa reproduction closure của failure còn mở.
50. VO50 — Artifact người chơi thật không tự thu thập/tải lên.
51. VO51 — Runner/validator/oracle reason code không thay bằng chứng chi tiết.
52. VO52 — Tài liệu K2.6 không đổi bất kỳ điều kiện cũ thành đã chạy.

Thêm 52 VO vào 576 điều kiện trước đó thành **628 điều kiện thiết kế chưa chạy bằng validator/mô phỏng**. VO cũng chưa chạy; chúng kiểm chính bộ kiểm chứng khi được triển khai.

## 55. Giới hạn và bước tiếp theo

K2.6 chưa tạo catalog máy, runner, oracle code, CI, thiết bị chuẩn, ngưỡng hiệu năng hoặc EvidenceBundle thật. K1G09–K1G12 và BT01–BT12 vẫn chưa có bằng chứng chạy; 628 điều kiện đều chưa chạy.

K2.7 đã định workload, device profile, ngân sách và benchmark tại [[NGAN_SACH_HIEU_NANG_QUY_MO_K2]]; toàn gói được rà tại [[KIEM_TOAN_DONG_GOI_K2]], kiến trúc tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
