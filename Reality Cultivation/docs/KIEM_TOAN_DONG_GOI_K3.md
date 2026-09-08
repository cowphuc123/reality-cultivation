---
title: Kiểm toán và đóng gói kiến trúc K3.1–K3.6
aliases:
  - K3.7
  - Kiểm toán K3
tags:
  - reality-cultivation
  - kiem-toan
  - kien-truc
  - da-nen-tang
status: de-xuat
updated: 2026-09-06
---

# Kiểm toán và đóng gói kiến trúc K3.1–K3.6

Tài liệu này kiểm toán sáu tài liệu K3 sau [[KIEM_TOAN_DONG_GOI_K2]]. Mục tiêu là xác định kiến trúc có khép kín ở mức hợp đồng hay không, điểm nào còn là giả thuyết và thứ tự công việc nếu sau này người dùng yêu cầu triển khai.

Kết luận: **K3.1–K3.6 khép chuỗi kiến trúc trên giấy, đủ để tiếp tục thiết kế domain sâu hoặc chuẩn bị prototype; chưa đủ để chọn stack, viết production core hay tuyên bố game chạy được.** K3.7 không thêm điều kiện mới. Tổng vẫn là 1.104 điều kiện chưa chạy.

## 1. Phạm vi kiểm toán

Kiểm:

- inventory và phép cộng điều kiện;
- dependency direction và owner;
- mobile/desktop parity;
- Command/Event/View/Save boundary;
- content generation và identity;
- M0–M4/R0–R4;
- storage/query/index;
- schema/catalog/evidence chain;
- vấn đề mở, rủi ro, gate và vertical slices.

Không kiểm runtime, source code, binary, thiết bị hoặc EvidenceBundle vì chúng chưa tồn tại.

## 2. Inventory sáu tài liệu K3

| Chặng | Tài liệu | Dòng | Họ | Điều kiện |
|---|---|---:|---|---:|
| K3.1 | [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]] | 821 | KT | 60 |
| K3.2 | [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]] | 678 | CN | 64 |
| K3.3 | [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]] | 864 | ND | 68 |
| K3.4 | [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]] | 838 | PT | 72 |
| K3.5 | [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]] | 800 | LU | 76 |
| K3.6 | [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]] | 916 | AM | 80 |
| **Tổng K3** | **6 tài liệu** | **4.917** | **6 họ** | **420** |

Số dòng chỉ giúp nhận diện revision hiện tại, không đo chất lượng.

## 3. Tổng inventory toàn hồ sơ

| Gói | Điều kiện |
|---|---:|
| DL/K0/K1 trước K2 | 376 |
| K2.1–K2.7 | 308 |
| K3.1–K3.6 | 420 |
| **Tổng** | **1.104** |

Có 33 họ: SK, VT, CB, CV, LT, GT, DS, LK, CS, LC, QD, SS, NX, DT, HS, VH, ST, NL, TL, DV, HD, LS, GV, NT, LP, VO, HN, KT, CN, ND, PT, LU, AM.

## 4. Trạng thái bằng chứng trung thực

| Hạng mục | Số lượng hiện tại |
|---|---:|
| điều kiện mô tả trong Markdown | 1.104 |
| ConditionSpec máy | 0 |
| schema registry/artifact máy | 0 |
| fixture máy | 0 |
| runner/oracle implementation | 0 |
| run đã publish | 0 |
| PASS/FAIL có EvidenceBundle | 0 |
| benchmark thiết bị | 0 |
| build mobile/desktop | 0 |

Mọi “đạt” trong audit này chỉ là đầy đủ/nhất quán ở mức tài liệu.

## 5. Chuỗi phụ thuộc K3

```text
K2 contracts/audit
 -> K3.1 module/ports/runtime boundaries
 -> K3.2 candidate stacks + common spike/ADR
 -> K3.3 content/instance/generation architecture
 -> K3.4 materialization/resolution/entity lifecycle
 -> K3.5 storage/partition/index/query
 -> K3.6 schema/artifact/catalog/build/evidence
```

Không thấy vòng phụ thuộc có quyền mutation. K3.6 mô tả artifact cho các hợp đồng trước nhưng không trở thành nguồn nghĩa ngược lại.

## 6. Dependency direction

Thứ tự quyền giữ nhất quán:

`Platform Shell -> Command/Query ports -> Simulation Application -> Scheduler/Cognition/Domain -> Transaction -> World Model`.

Storage, projection, oracle và observability đi qua ports. UI/platform/storage adapter không ghi World Model trực tiếp. Nội dung là input có schema/capability, không là code có quyền tùy ý.

## 7. Owner matrix

| State/khả năng | Owner ghi |
|---|---|
| record canonical/revision | World Model qua Transaction |
| event queue/frontier | Scheduler |
| mutation/reservation/commit | Transaction authority |
| belief/memory/goal/decision | Cognition qua mutation hợp lệ |
| domain outcomes | domain handler lập intent, Transaction commit |
| M/R plan | ResolutionCoordinator qua event/plan revision |
| save manifest/journal publish | Save subsystem |
| indices/cache/projection | derived subsystems, không là gameplay truth |
| schemas/catalog/artifacts | build/spec toolchain, không mutation world |

Không thấy hai owner cùng được phép ghi một field canonical.

## 8. Audit single-writer

K3.1, K3.4 và K3.5 thống nhất một Simulation Runtime authority. Worker chỉ tạo candidate delta từ input đóng băng; authority sort, validate và commit.

Điểm chưa chứng minh: thread model thật của S1/S2/S3, callback platform, I/O completion, cancellation và worker stale result. Chúng nằm trong KT/CN/LU chưa chạy.

## 9. Audit Command và View

CommandEnvelope có idempotency/revision/actor/payload/constraints; lifecycle phân ACK khỏi APPLIED. ViewProjection có viewer/knowledge/revision/freshness và không tạo observation khi mở trang.

K3.5 bổ sung QuerySpec, capability, cost, stable cursor và index filtering. K3.6 cho phép sinh bindings từ cùng IR. Chuỗi khép trên giấy nhưng chưa có schema/bridge/UI.

## 10. Audit event và transaction

ScheduledEvent, DomainFact, ObservationCandidate và ViewDelta được tách. Chỉ scheduler/transaction authority làm đổi state. Cross-shard commit có một decision; BoundaryFlow có idempotency và custody.

Không thấy đường hợp lệ để event bus subscriber, index hoặc projection tự mutation. Chưa có conformance/static dependency check.

## 11. Audit mobile và desktop

Hai nền tảng dùng cùng:

- core semantics;
- Command/View contracts;
- canonical codec/hash;
- content/policy/schema versions;
- portable save;
- conditions/oracles;
- M/R plans.

Shell khác lifecycle/input/layout/storage capabilities. Thiết bị chậm chỉ đổi throughput/cache/prefetch, không đổi logic. Đây là ràng buộc thiết kế, chưa là hỗ trợ thực tế.

## 12. Audit lựa chọn công nghệ

K3.2 giữ S1 Rust/Tauri 2, S2 Dart/Flutter, S3 Kotlin/Compose ngang hàng; S4 .NET MAUI dự phòng, PWA đối chứng. Cùng spike, disqualifier, score, tie-break và ADR ngăn chọn theo cảm giác.

Nguồn vendor được chụp ngày 2026-09-06 và phải kiểm tra lại trước quyết định. Chưa khóa PlatformScope P0/P1, chưa chạy candidate nào và chưa có ADR ACCEPTED.

## 13. Audit vòng đời ứng dụng

Mobile background/kill và desktop close/sleep đều quy về safe boundary, staging, publish và recovery. UI không báo saved trước durability contract.

Điểm mở: TN02 OFFLINE_STOP/CATCHUP, storage capability từng OS, thời gian background, iOS build resource và fault evidence.

## 14. Audit content architecture

Definition, Blueprint, Instance và View tách rõ. Content package/version/namespace/provenance/seed tree/constraint/budget/validator ngăn tổ hợp tùy tiện.

Vật phẩm, công pháp, cơ thể, NPC, xã hội, địa lý, sinh thái và linh khí có điểm nối chung. Đây là ontology/architecture, chưa có taxonomy máy hoặc generator.

## 15. Audit tính duy nhất

Khác biệt phải ảnh hưởng capability, constraint, cost/risk, compatibility, perception, provenance hoặc social meaning. Uniqueness/diversity audit không chỉ đếm tên/definition.

Không thấy đề xuất modifier rỗng để phóng đại số lượng. Chưa có metric/sample để chứng minh distribution hữu ích.

## 16. Audit sinh thế giới

Seed phân cấp và stable keys giữ order independence. M0 latent/M1 summarized không được tuyên bố là cá thể đã sống đầy đủ. Query không sinh tài nguyên để chiều mục tiêu.

Boundary contracts, anchors, persistent delta và tombstone ngăn seam conflict/reroll/hồi sinh. Chưa có world topology, generator IR hoặc seam tests.

## 17. Audit identity NPC

K3.3 và K3.4 được hòa giải rõ:

- M0/M1 có thể chưa có cá thể;
- từ M2, Person có id/PersonCore và không quay về cohort;
- R4 chỉ batch cách tính, vẫn phân delta về từng Person;
- birth của cha mẹ M2 tạo Person id;
- death tạo tombstone/succession;
- migration giữ cùng identity.

Điều này đáp ứng nguyên tắc “NPC đã tồn tại là người riêng” ở mức hợp đồng.

## 18. Audit M0–M4 và R0–R4

Hai trục độc lập loại bỏ mâu thuẫn “giảm chi tiết = xóa người”. ResolutionPlan giữ valid interval, error budget, frontier, promotion/demotion và evidence class.

Exact invariants bằng 0 cho identity, vật chất, quyền, nghĩa vụ, lineage và event neo. Chưa có handler R2–R4 hoặc baseline parity.

## 19. Audit promotion/demotion

Promotion diễn ra trước contact/deadline/risk; trễ thì world dừng trước boundary. Demotion khép process, kết sổ, tạo capsule/anchors và kiểm round-trip.

Pin/hysteresis chống thrashing nhưng correctness trigger thắng. Chưa có predicted horizon, cost model, capsule schemas hoặc latency evidence.

## 20. Audit cohort và PersonBatch

PopulationCohort M1 đại diện người chưa cá thể hóa. PersonBatch R4 xử nhiều Person M2+ đã có id. Cohort-to-Person allocation trừ integer bins/stocks nguyên tử; batch phân state delta/outcome riêng.

W4 chỉ được đếm 100.000 Person M2+, không tính cohort. Đây là tiêu chuẩn công bố trung thực; chưa có 100.000 record thật.

## 21. Audit boundary flows

Người, vật, message, bệnh, hàng và quyền đi qua BoundaryFlow có source/destination/time/custody/idempotency. In-transit entity có một canonical record, không ở hai region.

Cross-region organization/market/message có hooks nhưng công thức/handler chưa tồn tại.

## 22. Audit storage source of truth

K3.5 tách Canonical World State, Portable Save Image và Derived Index/Cache/View. Live engine layout không là save format công khai.

Root manifest/revision vector/chunks/journal/frontier/flow/anchor/capsule tạo đường recovery. Chưa chọn họ storage F/R/K/H, codec, checksum, compression hoặc engine.

## 23. Audit transaction xuyên shard

Coordinator stage all participants, ghi decision, publish và apply idempotently. Recovery không đoán. Đây phù hợp K2.3/K2.5 single atomic mutation.

Điểm mở: lock/reservation implementation, deadlock/cancellation, durability capability, page/chunk format và failure injection.

## 24. Audit lazy load

Trước RUNNING phải có global frontier, pins, flows, RNG/idempotency và content. Cold payload có thể lazy-load; missing shard không biến entity thành không tồn tại.

Prefetch/eviction là tối ưu không can thiệp. Query 100.000 Person không load toàn Body/Memory graph. Chưa có access-pattern benchmark.

## 25. Audit index và query

ID, spatial, temporal, ownership, social, cognition, body và full-text indices đều derived. Correctness index đồng bộ hoặc có delta overlay; async index không được quyết quyền giao dịch.

Query có viewer/capability/cost/freshness/cursor. Secret không lộ qua kết quả/count/snippet thông thường. Chưa có schema/planner/index implementation.

## 26. Audit compaction/migration

Compaction từ frozen snapshot, giữ root hash/anchors/tombstones/refs rồi publish trước prune. Migration source read-only -> staging -> validate -> publish; storage migration tách domain migration.

Không thấy đường sửa in-place hoặc tự repair canonical data không bằng chứng. Chưa có fault/corruption/migration run.

## 27. Audit artifact hierarchy

ArtifactEnvelope/URI/SourceRef/SchemaRegistry/IR/BuildManifest có owner/version/digest/provenance. Published id+version immutable. Generated docs không thay DECISIONS/MASTER.

Vault vẫn là nguồn giải thích cho người; runtime schema sau này là artifact phát hành. Chưa có semantic anchors hoặc registry máy.

## 28. Audit catalog trung thực

Condition có hai trục:

- automation: TEXT_ONLY/ENCODED/IMPLEMENTABLE/IMPLEMENTED;
- result: NOT_RUN/BLOCKED/UNSUPPORTED/PASS/FAIL/ERROR/INCONCLUSIVE/FLAKY/STALE.

Catalog hóa 1.104 entry không tạo PASS. Result append theo fingerprint/EvidenceBundle và giữ lịch sử. Đây là ranh giới đúng; catalog hiện vẫn là 0 entry máy.

## 29. Audit code generation

Neutral IR sinh types/codecs/bindings/validation skeleton; không sinh luật NPC/oracle phức tạp từ field name. Generated output có digest, không chỉnh tay và phải qua cross-target conformance.

Chưa chọn schema language hoặc target stack nên codegen vẫn là contract.

## 30. Audit compatibility

Schema/content/policy/RNG/handler/storage/command/projection/platform versions tách riêng. Compatibility theo READ/WRITE/ROUND_TRIP/EXECUTE/MIGRATE; unknown fields preserve hoặc UNSUPPORTED rõ.

Không dùng một app version để suy mọi compatibility. Chưa có CompatibilityManifest/migration edges thật.

## 31. Audit validation/evidence chain

`source -> schema/content/fixture/condition/oracle -> RunSpec -> runtime -> EvidenceBundle -> Result -> Gate`.

Mỗi bước có digest/version/source. Missing artifact tạo BLOCKED/UNSUPPORTED, không fallback “không crash là PASS”. Chuỗi khép logic nhưng toàn bộ implementation/evidence vẫn thiếu.

## 32. Các bất biến xuyên K3

1. Một writer authority.
2. Dependency hướng vào core.
3. UI/adapter không mutation.
4. Platform time khác GameClock.
5. Canonical order/hash/RNG portable.
6. NPC không đọc Fact toàn tri.
7. Entity M2 giữ identity.
8. R-level không phụ thuộc sức máy.
9. Save portable không phụ thuộc live engine.
10. Index/cache/query không là source gameplay.
11. Artifact/version đã publish bất biến.
12. ENCODED/IMPLEMENTED không đồng nghĩa PASS.

Không phát hiện tài liệu K3 nào cho phép phá một bất biến trên.

## 33. Điểm giao cần chú ý khi triển khai

| Giao điểm | Nguy cơ |
|---|---|
| Command ↔ bridge | retry/copy/order |
| Event ↔ Transaction | Fact trước commit |
| Cognition ↔ World | truth leak |
| Generator ↔ Runtime | sinh theo nhu cầu/camera |
| R4 ↔ PersonCore | batch không phân delta |
| Region ↔ Flow | nhân entity/asset |
| Live store ↔ Save | engine dump lock-in |
| Index ↔ Authority | stale quyền/vị trí |
| Schema ↔ Binding | cross-target byte/hash lệch |
| Catalog ↔ Result | mã hóa bị báo thành test |

Các điểm này nên là vertical-slice fault tests sớm.

## 34. Rủi ro kiến trúc ưu tiên

1. Over-engineering trước W0/W1.
2. Schema/abstraction không có scenario thật.
3. Chọn stack theo sở thích trước spike.
4. R4 batch làm mất cá thể ngầm.
5. Content combinatorics tạo rác thay chiều sâu.
6. Save hai representation lệch nhau.
7. Shard transaction/recovery phức tạp quá sớm.
8. UI query làm lộ world truth.
9. Generated bindings lệch semantic.
10. Catalog lớn tạo cảm giác tiến độ giả.
11. W4 tối ưu trước W1 correctness.
12. Tài liệu vendor K3.2 lỗi thời khi quyết định.

## 35. Vấn đề mở cấp chặn prototype

| ID | Vấn đề | Cách đóng |
|---|---|---|
| OPEN-K3-01 | người dùng chưa yêu cầu code | chỉ triển khai khi được yêu cầu |
| OPEN-K3-02 | PlatformScope P0/P1 chưa khóa | chốt trước candidate spike |
| OPEN-K3-03 | TN ảnh hưởng pause/offline/P00 | variant trước, chốt khi spike rẽ nhánh |
| OPEN-K3-04 | chưa có shared W0 fixture máy | artifact bootstrap |
| OPEN-K3-05 | chưa có expected trace/hash | oracle/fixture review độc lập |
| OPEN-K3-06 | chưa có schema/IR/compiler | K3.6 implementation slice |
| OPEN-K3-07 | chưa có candidate projects | PRT-1 sau ủy quyền |
| OPEN-K3-08 | thiếu device matrix/Mac cho iOS | khóa scope/tài nguyên |

## 36. Vấn đề mở cấp chặn production core

| ID | Vấn đề | Cách đóng |
|---|---|---|
| OPEN-K3-09 | chưa có ADR stack | cùng spike/evidence |
| OPEN-K3-10 | chưa có ADR storage | AP01–AP12/fault spike |
| OPEN-K3-11 | chưa có catalog 1.104 | bootstrap C0–C7 |
| OPEN-K3-12 | chưa có runner/oracles | vertical W0 correctness |
| OPEN-K3-13 | chưa có portable save/fault proof | kill/import round-trip |
| OPEN-K3-14 | chưa có UI accessibility proof | SP-E mobile/desktop |
| OPEN-K3-15 | chưa có migration/compatibility proof | version N→N+1 fixture |
| OPEN-K3-16 | chưa có W1 performance | release builds/device profiles |

## 37. Vấn đề mở cấp quy mô/nội dung

| ID | Vấn đề | Cách đóng |
|---|---|---|
| OPEN-K3-17 | taxonomy/schema domain chưa máy hóa | K4 design + artifact batch |
| OPEN-K3-18 | generator/order/seam chưa chạy | W0 region generator |
| OPEN-K3-19 | R2–R4 handlers chưa có | baseline rồi parity |
| OPEN-K3-20 | PersonCore/capsules chưa schema | K4/K3.6 implementation |
| OPEN-K3-21 | W2–W4 fixtures chưa có | generator có invariants |
| OPEN-K3-22 | 100.000 Person chưa chứng minh | W4 evidence gates |
| OPEN-K3-23 | retention/compaction chưa định lượng | long-run storage tests |
| OPEN-K3-24 | domain sâu còn thiếu công thức | K4 theo dependency |

## 38. Tổng hợp 60 gate nội bộ K3.1–K3.6

Mỗi tài liệu có 10 gate:

| Gói | Đạt đặc tả/trên giấy | Chưa đạt implementation/evidence |
|---|---:|---:|
| K3.1 K3G | 4 | 6 |
| K3.2 K3T | 4 | 6 |
| K3.3 K3D | 4 | 6 |
| K3.4 K3P | 4 | 6 |
| K3.5 K3L | 4 | 6 |
| K3.6 K3A | 4 | 6 |
| **Tổng** | **24** | **36** |

Đây là gate, không thuộc 1.104 conditions.

## 39. Cổng kiểm toán K3X01–K3X24

| Gate | Điều kiện | Kết quả |
|---|---|---|
| K3X01 | đủ sáu tài liệu K3.1–K3.6 | Đạt |
| K3X02 | wiki links phân giải | Đạt |
| K3X03 | 60+64+68+72+76+80=420 | Đạt |
| K3X04 | 684+420=1.104, 33 họ | Đạt |
| K3X05 | dependency direction không vòng mutation | Đạt trên giấy |
| K3X06 | owner/write authority nhất quán | Đạt trên giấy |
| K3X07 | Command/Event/View boundary khép | Đạt hợp đồng |
| K3X08 | mobile/desktop core/save parity là invariant | Đạt nguyên tắc |
| K3X09 | content identity/provenance/order rõ | Đạt đặc tả |
| K3X10 | M/R/cohort/Person semantics không mâu thuẫn | Đạt đặc tả |
| K3X11 | storage/save/index/query source rõ | Đạt đặc tả |
| K3X12 | artifact/catalog/result semantics rõ | Đạt đặc tả |
| K3X13 | TN/stack/engine chưa bị tự chọn | Đạt |
| K3X14 | claims 100.000/vô hạn được giới hạn trung thực | Đạt |
| K3X15 | backlog theo evidence/correctness trước scale | Đạt trên giấy |
| K3X16 | PlatformScope được chốt | Chưa |
| K3X17 | schema/catalog/fixture máy tồn tại | Chưa |
| K3X18 | candidate stack/storage spikes | Chưa |
| K3X19 | W0 deterministic runtime | Chưa |
| K3X20 | save/kill/import parity evidence | Chưa |
| K3X21 | UI/accessibility mobile/desktop evidence | Chưa |
| K3X22 | W1 30 ngày correctness/performance | Chưa |
| K3X23 | R2–R4/W2–W4 evidence | Chưa |
| K3X24 | 1.104 current EvidenceBundles | Chưa |

K3X01–K3X15 đạt hoặc đạt trên giấy; K3X16–K3X24 chưa đạt.

## 40. Ma trận sẵn sàng

| Thành phần | Spec | Machine artifact | Code | Evidence | Kết luận |
|---|---|---|---|---|---|
| module/ports | đủ | chưa | chưa | chưa | sẵn sàng prototype |
| stack decision | matrix | chưa | chưa | chưa | cần spike |
| content model | rộng | chưa | chưa | chưa | sẵn sàng K4/schema hóa |
| materialization/R | đủ interface | chưa | chưa | chưa | cần baseline/handler |
| storage/query | đủ architecture | chưa | chưa | chưa | cần candidate spike |
| schema/catalog | đủ meta-spec | chưa | chưa | chưa | sẵn sàng bootstrap |
| mobile/desktop | invariant | chưa | chưa | chưa | chưa hỗ trợ thực tế |
| W1/W4 | workload | chưa | chưa | chưa | chưa công bố capacity |

## 41. Lát cắt prototype PRT-0

Trước khi chọn stack, cùng specification cần:

- ArtifactEnvelope/primitive/unit/id tối thiểu;
- fixture ba Person/V01/V02/hai Place;
- Command giao Goal;
- 12 events/một process remainder;
- transaction chuyển 3 V02;
- one Message/Observation/Belief;
- canonical trace/hash;
- save/kill/import scenario;
- semantic text UI nhỏ;
- metrics/fingerprint.

Đây là spike bỏ đi có kiểm soát, không là production content.

## 42. Backlog vertical slices nếu được yêu cầu triển khai

| Slice | Kết quả reviewable | Gate chính |
|---|---|---|
| V0 | artifact/schema/fixture W0 | K3X17 |
| V1 | candidate core-only parity | K3X18–19 |
| V2 | Command→Goal→Event→Transaction→View | K3X19 |
| V3 | boundary save/kill/load/import | K3X20 |
| V4 | mobile/desktop shell text/accessibility | K3X21 |
| V5 | CognitionView/Message/Belief | NT/KT parity |
| V6 | W1 V01/V02/sinh kế 30 ngày | K3X22 correctness |
| V7 | body/care/cultivation/combat từng lát | domain gates |
| V8 | content generator nhỏ + delta | K3D06–09 |
| V9 | R2–R4 1.000 Person | K3X23 |
| V10 | W3/W4 sau evidence | capacity gates |

Mỗi slice xuất artifact/evidence; không chờ toàn thế giới mới review.

## 43. Thứ tự quyết định kỹ thuật

1. khóa phạm vi spike và expected trace;
2. dựng S1–S3 cùng W0;
3. loại candidate vi phạm correctness/lifecycle;
4. chọn stack bằng ADR;
5. chạy storage F/R/K/H trên stack finalist;
6. chọn live engine + portable format bằng ADR riêng;
7. bootstrap catalog/schema production;
8. triển khai slices V2–V6;
9. benchmark W1;
10. chỉ sau đó thiết kế/tối ưu scale implementation.

Stack và storage không nên bị gộp thành một quyết định duy nhất.

## 44. Lộ trình thiết kế domain K4

Trong khi chưa được yêu cầu code, kế hoạch có thể tiếp tục theo dependency:

1. K4.1 vật chất, năng lượng, trường và hiện tượng nền;
2. K4.2 giải phẫu, sinh lý và cân bằng nội môi;
3. K4.3 bệnh lý, độc chất, điều trị và hồi phục;
4. K4.4 vật liệu, chế tác, công cụ và công trình;
5. K4.5 linh khí, kinh mạch, công pháp và đột phá sâu;
6. K4.6 sinh thái, tiến hóa, khí hậu và địa mạch;
7. K4.7 kinh tế, tổ chức, chiến tranh và lịch sử vùng;
8. kiểm toán dependency/domain data readiness.

Thứ tự có thể điều chỉnh; đây chưa là quyết định người dùng.

## 45. Điều chưa cần hỏi ngay

- enum/codec/hash cụ thể;
- worker count;
- storage engine;
- schema language;
- compression/encryption;
- cloud sync;
- W4 hard limit;
- mod scripting;
- mọi hệ số domain.

Những điểm này có thể giữ thành variant cho tới khi bằng chứng hoặc trải nghiệm thực sự rẽ nhánh.

## 46. Điều cần hỏi trước các mốc tương ứng

| Trước mốc | Cần quyết |
|---|---|
| prototype platform build | Android+Windows trước hay thêm iOS/macOS/Linux |
| gameplay shell | TN01 pause, TN03 P00, TN04 tầm nhìn |
| lifecycle test | TN02 offline |
| save/product loop | TN05 chết/tải lại và slot/branch UX |
| W1 fixture final | TN06–TN08 |
| release scope | thiết bị tối thiểu, OS targets, distribution |

Không cần dừng toàn bộ K4 để hỏi tất cả ngay bây giờ.

## 47. Những điều không được tuyên bố sau K3

- Không nói kiến trúc đã được hiện thực hóa.
- Không nói Rust/Tauri, Flutter hoặc Kotlin đã thắng.
- Không nói đã chọn database/save format.
- Không nói có schema/catalog máy.
- Không nói 1.104 điều kiện đã test.
- Không nói game chạy 5 giây/ngày.
- Không nói hỗ trợ điện thoại/máy tính đã hoàn thành.
- Không nói thế giới vô hạn hoặc 100.000 NPC đã tồn tại.
- Không nói R4 parity, save recovery hoặc migration đã chứng minh.
- Không nói nội dung procedural đã có chiều sâu.

## 48. Những gì K3 đã cung cấp thật

- module/port/authority architecture;
- tiêu chí và protocol chọn stack;
- content/generation identity architecture;
- mô phỏng phân tầng không xóa NPC;
- storage/query/save portability architecture;
- artifact/schema/catalog/evidence meta-model;
- 420 điều kiện kiến trúc có thể chuyển thành test;
- gate, risk và backlog reviewable;
- đường tiếp tục thiết kế domain mà không khóa công nghệ.

## 49. Định nghĩa sẵn sàng prototype

Về mặt tài liệu, K3 đủ để chuẩn bị prototype vì có common scenario, disqualifier, ports, save fault points và evidence requirements. Để **bắt đầu** vẫn cần:

- yêu cầu triển khai từ người dùng;
- PlatformScope;
- shared machine fixture/trace;
- timebox/device access;
- candidate toolchains;
- nơi lưu artifact/evidence.

## 50. Định nghĩa sẵn sàng production foundation

Chỉ sau khi:

- ADR stack/storage accepted;
- schema registry/catalog tồn tại;
- W0 core/save/parity chạy;
- dependency rules enforce được;
- portable save fault tests đạt;
- UI shell cơ bản chạy hai nền tảng;
- CI/evidence publication hoạt động;
- W1 vertical slice có correctness evidence.

K3 hiện chưa đạt định nghĩa này.

## 51. Gói bàn giao K3

```text
K3 architecture package
  K3.1 modules/ports/runtime
  K3.2 technology spike/ADR
  K3.3 content/generation
  K3.4 materialization/resolution
  K3.5 storage/query
  K3.6 machine artifacts/catalog
  K3.7 audit/gates/backlog
```

Vault hiện tại là gói bàn giao thật. Cấu trúc code/artifact vẫn chỉ là topology đề xuất.

## 52. Kết luận và bước tiếp theo

K3 khép kiến trúc ở mức hợp đồng và không phát hiện mâu thuẫn bắt buộc giữa sáu tài liệu. Điểm quan trọng nhất được giữ: cùng core cho mobile/desktop, một writer, NPC M2 không mất identity, R4 không biến thành dân số, portable save tách live engine và catalog hóa không biến thành PASS.

K4.1–K4.4 đã cụ thể hóa nền hiện tượng, cơ thể, vật phẩm và môi trường. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
