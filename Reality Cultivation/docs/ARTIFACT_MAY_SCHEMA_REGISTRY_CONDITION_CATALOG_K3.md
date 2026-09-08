---
title: Artifact máy, schema registry và condition catalog — K3.6
aliases:
  - K3.6
  - Artifact máy và condition catalog
tags:
  - reality-cultivation
  - thiet-ke
  - schema
  - kiem-thu
  - artifact
status: de-xuat
updated: 2026-09-06
---

# Artifact máy, schema registry và condition catalog — K3.6

Tài liệu này chuyển các hợp đồng của [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]], [[KE_HOACH_VALIDATOR_ORACLE_K2]], [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]] và [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]] thành một hệ artifact máy có thể xây sau này.

Vault Obsidian vẫn là nguồn giải thích và quyết định cho người. Artifact máy là biểu diễn có kiểu để validator/runner/runtime dùng, phải dẫn ngược đúng nguồn. K3.6 chưa tạo schema, catalog hay source code thật. 80 điều kiện AM cuối tài liệu đều chưa chạy.

## 1. Mục tiêu K3.6

1. Mỗi artifact có id, kind, version, owner và provenance.
2. Schema trung lập stack nhưng sinh binding cho stack được chọn.
3. 1.024 điều kiện hiện có được chuyển thành catalog không mất nghĩa.
4. `ENCODED` không bị nhầm với `IMPLEMENTED`, `RUN` hoặc `PASS`.
5. Fixture/content/condition/oracle/migration liên kết bằng dependency graph.
6. Build artifact tái lập và có manifest/hash.
7. Mobile/desktop dùng cùng logical schemas/catalog.
8. Compatibility và migration được kiểm trước runtime.

## 2. Nguồn thật theo loại

| Loại | Nguồn có thẩm quyền |
|---|---|
| yêu cầu/quyết định | [[DECISIONS]] và chỉ dẫn người dùng |
| giải thích thiết kế | tài liệu Markdown chủ quản |
| schema runtime sau này | Schema Registry artifact đã phát hành |
| content/fixture chạy | compiled artifact + manifest |
| kết quả test | EvidenceBundle/RunResult đã publish |
| trạng thái dự án | [[STATE]] được đối chiếu artifact thật |

Generated docs không được ghi đè quyết định của người dùng.

## 3. ArtifactEnvelope chung

Mọi artifact máy có:

- `artifact_id` và `artifact_kind`;
- `schema_version` của chính envelope;
- `artifact_version`;
- `status`;
- `namespace/owner`;
- `source_refs`;
- `dependencies` và version constraints;
- `capabilities_required/provided`;
- `canonical_payload_digest`;
- `build_provenance`;
- `created_at_build`, không dùng làm gameplay;
- `deprecation/supersession` nếu có.

## 4. Các kind artifact

- `SCHEMA`;
- `ENUM_UNIT_REGISTRY`;
- `CONTENT_PACKAGE`;
- `FIXTURE`;
- `OVERLAY`;
- `POLICY`;
- `GENERATOR`;
- `CONDITION_CATALOG`;
- `ORACLE_SPEC`;
- `MIGRATION`;
- `WORKLOAD_PROFILE`;
- `BUILD_MANIFEST`;
- `RUN_SPEC`;
- `EVIDENCE_BUNDLE`;
- `COMPATIBILITY_MANIFEST`.

Mỗi kind có schema riêng nhưng dùng cùng envelope/provenance.

## 5. Artifact URI

Tham chiếu logic dạng khái niệm:

```text
rc://<namespace>/<kind>/<name>@<version>#<fragment>
```

URI không là đường dẫn filesystem hoặc URL mạng. Resolver map URI sang artifact trong build/package/store hiện tại. Move thư mục không đổi identity.

## 6. SourceRef

`SourceRef` tối thiểu:

- `vault_doc_id/path`;
- `semantic_anchor`;
- `source_revision/digest`;
- `excerpt_digest` hoặc statement digest;
- `relationship`: DEFINES/EXPLAINS/DERIVES/CONSTRAINS;
- optional line hint chỉ để điều hướng.

Line number không là identity vì biên tập phía trên làm nó đổi.

## 7. Semantic anchor

Mỗi định nghĩa/điều kiện khi mã hóa cần anchor ổn định như `condition:PT48` hoặc `contract:scheduler.event-order`. Heading text có thể đổi nhưng anchor id không tái sử dụng.

K3.6 chưa chèn anchor vào mọi Markdown. Quá trình catalog hóa phải lập mapping reviewable và báo anchor thiếu/thừa.

## 8. Schema Registry Manifest

Registry ghi:

- registry id/version;
- artifact envelope version;
- danh sách schema id/version/digest;
- imports/dependency DAG;
- primitive/unit/id registries;
- compatibility class;
- codegen targets/profiles;
- validator versions;
- migration edges;
- build fingerprint;
- release status.

Registry không cho hai schema cùng id/version nhưng khác digest.

## 9. Schema ID và version

Schema identity tách khỏi file. Thay documentation/cosmetic metadata không nhất thiết tăng schema version; thay field semantics/type/requiredness phải tăng theo compatibility policy.

Một version đã phát hành là immutable. Sửa lỗi tạo version mới hoặc rebuild chỉ khi canonical payload thực sự giống.

## 10. Compatibility classes

| Class | Ý nghĩa |
|---|---|
| EXACT | digest/version phải trùng |
| BACKWARD_READ | reader mới đọc artifact cũ |
| FORWARD_PRESERVE | reader cũ giữ unknown fields mà không hiểu |
| MIGRATION_REQUIRED | cần edge chuyển rõ |
| INCOMPATIBLE | từ chối/giữ bản cũ |

Compatibility phải tính theo operation: READ, WRITE, ROUND_TRIP, EXECUTE, MIGRATE; không dùng một boolean chung.

## 11. Unknown field policy

Unknown fields được:

- preserve nguyên bytes/semantic value khi round-trip nếu class yêu cầu;
- expose cho audit;
- cấm runtime dùng nếu capability chưa có;
- không tự default thành zero/false;
- không bị codegen bỏ khi save lại.

Unknown gameplay mutation làm artifact UNSUPPORTED nếu không thể giữ nghĩa.

## 12. Primitive và fixed-point registry

Registry định nghĩa integer widths/ranges, fixed-point scale, decimal policy, boolean, text normalization, byte arrays, game time, duration, quantities và canonical map/list ordering.

Không dùng float platform mặc định cho state cần parity nếu chưa có contract/tolerance rõ.

## 13. Unit registry

Mỗi unit có dimension, base scale integer, allowed ranges, display conversions và rounding/overflow rules. Schema field tham chiếu unit id thay vì chỉ ghi tên trong comment.

Codegen tạo wrapper/type hoặc validator phù hợp; UI formatting không đổi stored base value.

## 14. Typed ID registry

Registry liệt kê domain prefix, logical kind, serialization, namespace, allocation strategy và allowed reference targets. Cross-kind coercion bị cấm dù cùng underlying string/integer.

Retired id/prefix không tái sử dụng. Generated binding phải giữ opaque typed id.

## 15. Enum và extensibility

Enum phân:

- CLOSED: unknown value là lỗi;
- OPEN_PRESERVE: giữ value lạ nhưng không execute;
- FEATURE_GATED: hiểu khi capability tồn tại;
- CONTENT_DEFINED: id từ content registry, không compile-time enum.

Không biến hàng nghìn vật/công pháp thành enum hard-code.

## 16. Record schema

Schema record nêu:

- fields/id/type/unit;
- required/optional/nullable/unknown semantics;
- default chỉ khi có nghĩa;
- invariants và ref targets;
- owner module/write capability;
- canonical ordering/hash inclusion;
- retention/security/view classification;
- lifecycle/versioning;
- examples và negative examples.

## 17. Union và state machine

Tagged union bắt buộc discriminant có version. State machine schema nêu states, transitions, preconditions, terminal states và illegal transitions.

Deserializer không nhận object chứa fields của nhiều variant rồi chọn tùy thứ tự. Transition validator tách khỏi parser.

## 18. Graph schema

Graph nêu node/edge kinds, direction, multiplicity, ownership, cycles, reachability và deletion/ref policy. Body, blueprint, relationship, dependency và migration graph dùng profile riêng.

Generic graph library không tự quyết business invariants.

## 19. Constraint representation

Constraint chia:

- structural/schema;
- local record;
- reference closure;
- graph;
- cross-record/domain;
- temporal/transition;
- conservation;
- observational/security.

Mỗi constraint có id, severity, phase và diagnostic template. Không giấu luật quan trọng chỉ trong prose/code.

## 20. Neutral intermediate representation

Schema nguồn compile thành IR canonical trước codegen. IR giữ type, unit, constraints, docs refs, unknown policy, hash rules và capabilities.

Binding Rust/Dart/Kotlin/C# nếu có đều sinh từ cùng IR digest. Không duy trì bốn schema viết tay lệch nhau.

## 21. Code generation boundary

Codegen được phép tạo:

- data types/wrappers;
- codecs;
- builders/readers;
- static validation skeleton;
- visitor/matcher;
- schema metadata;
- API bindings;
- test fixtures mẫu.

Codegen không tạo quyết định NPC, luật giao dịch hoặc expected oracle phức tạp từ tên field.

## 22. Generated và handwritten code

Generated file có header artifact/build digest và không chỉnh tay. Handwritten domain logic import public generated types/interfaces; không import codegen internals.

Regenerate tạo diff ổn định. Thay thứ tự file/worker không làm output khác.

## 23. Multi-target conformance

Mỗi binding target phải qua cùng vectors:

- encode/decode golden;
- unknown preserve;
- boundary integer/unit;
- invalid ref/enum/union;
- canonical bytes/hash;
- migration input/output;
- large/deep input limits;
- cross-target round-trip.

Một binding không đạt thì platform đó UNSUPPORTED cho schema revision.

## 24. Content artifact

Compiled content dùng schema registry version, package manifest, definitions/blueprints/generators/locales, dependency closure và content fingerprint.

Source authoring format có thể khác compiled IR. Runtime không cần parser đầy đủ của format tác giả nếu artifact đã compile an toàn.

## 25. Fixture artifact

Fixture artifact chứa construction recipe hoặc canonical initial snapshot, content/policy requirements, seed/RNG manifest, base hash, allowed overlays và expected supported features.

Fixture build phải tái lập cùng initial state hash. Không đọc trạng thái còn sót từ run trước.

## 26. Overlay artifact

Overlay nêu base fixture id/version/hash, explicit operations, target refs/fields, preconditions, conflict policy và resulting expected digest/range.

Overlay không được tự tìm entity theo tên mơ hồ. Hai overlay conflict phải báo trước run.

## 27. Policy artifact

Các lựa chọn TN, P00 control, pause/offline, resolution và retention được biểu diễn thành policy artifact có trạng thái `UNCONFIRMED_FIXTURE_DEFAULT` khi chưa được chốt.

Tên “default” không biến đề xuất thành quyết định. RunFingerprint luôn chứa policy digest.

## 28. Generator artifact

Generator IR nêu input/output schemas, seed paths, constraints, budgets, deterministic operators, repair/backtrack policy và validation requirements.

Executable implementation có version/digest/capability riêng. Spec có nhưng implementation thiếu thì UNSUPPORTED, không giả output.

## 29. Migration artifact

Migration edge ghi source/target schema/content/storage versions, preconditions, transform steps, preservation rules, unknown handling, validators, rollback/staging policy và provenance.

Graph không vòng cho đường phát hành. Không tự chọn đường nhiều cạnh nếu ambiguity/chính sách khác nhau.

## 30. Workload artifact

WorkloadProfile đóng băng fixture/generator, scale/shape, R/M distributions, command/save/fault/UI schedules, run duration, device requirements và metrics.

W0–W4 id/version không phụ thuộc candidate stack. Candidate-specific adapter config nằm ngoài logical workload digest.

## 31. Condition catalog mục tiêu

Catalog chứa **đúng 1.024 ConditionSpec ACTIVE hiện tại** khi quá trình mã hóa hoàn tất, chia 32 họ. Việc này chưa được thực hiện trong K3.6.

Mỗi entry giữ nguyên id, statement đầy đủ, source anchor/revision, dependencies, fixture/oracle/evidence requirements và automation state.

## 32. Kiểm kê 32 họ

| Nhóm | Họ và số lượng |
|---|---|
| DL/K0 | SK12, VT14, CB14, CV16, LT16, GT16, DS16, LK16, CS18 |
| K1 | LC18, QD20, SS16, NX18, DT22, HS20, VH22, ST24, NL24, TL26, DV28 |
| K2 | HD32, LS36, GV40, NT44, LP48, VO52, HN56 |
| K3 | KT60, CN64, ND68, PT72, LU76 |
| **Tổng** | **1.024 điều kiện, 32 họ, tất cả chưa chạy** |

Gate BT/K1G/K2G/K3G/K3T/K3D/K3P/K3L không được đếm vào catalog condition hành vi trừ khi sau này tạo id mới rõ.

## 33. ConditionSpec bắt buộc

| Trường | Ý nghĩa |
|---|---|
| `condition_id/revision` | identity không tái sử dụng |
| `statement` | mệnh đề đầy đủ |
| `source_refs/digest` | nguồn nghĩa |
| `family/tags/test_kinds` | phân loại |
| `dependencies` | điều kiện/capability cần trước |
| `fixture/variant requirements` | state đầu |
| `stimulus` | command/event/fault |
| `observation_window` | giới hạn run |
| `oracle_refs` | cách kết luận |
| `evidence_requirements` | artifact bắt buộc |
| `automation_state` | mức mã hóa |
| `result_state` | trạng thái chạy riêng |

## 34. Hai trục trạng thái condition

`automation_state`:

- TEXT_ONLY;
- ENCODED;
- IMPLEMENTABLE;
- IMPLEMENTED;
- DISABLED_WITH_REASON.

`result_state`:

- NOT_RUN;
- BLOCKED;
- UNSUPPORTED;
- PASS/FAIL/ERROR/INCONCLUSIVE/FLAKY;
- STALE_RESULT.

ENCODED + NOT_RUN là trạng thái đúng sau catalog hóa ban đầu.

## 35. Lifecycle condition

ACTIVE, DRAFT, SUPERSEDED, RETIRED, BLOCKED_SPEC được quản lý riêng. Sửa nghĩa đáng kể tăng condition revision; kết quả cũ thành STALE_RESULT.

Không xóa condition khỏi lịch sử để làm tỷ lệ PASS đẹp hơn. Supersession ghi replacement ids và lý do.

## 36. Statement fidelity

Statement máy phải giữ:

- phủ định;
- phạm vi/actor/viewer;
- thời gian/boundary;
- precondition/exception;
- quantity/unit;
- expected state và state không được đổi;
- trạng thái unsupported khi có.

Không rút `retry không nhân giao dịch` thành tên test `retry works`.

## 37. Markdown-to-catalog mapping

Quy trình:

1. scan candidate ids và source lines;
2. group theo tài liệu chủ quản;
3. người biên tập gắn semantic anchor;
4. tạo ConditionSpec draft;
5. so statement/digest;
6. resolve dependencies/fixtures/oracles;
7. review diff Markdown ↔ catalog;
8. publish catalog generation;
9. cập nhật báo cáo coverage;
10. giữ result NOT_RUN.

Regex chỉ hỗ trợ inventory, không tự hiểu nghĩa.

## 38. Duplicate và missing detection

Compiler báo:

- một id ở nhiều source owner;
- source id thiếu catalog;
- catalog ACTIVE không còn source;
- duplicate statement khác id;
- family count lệch manifest;
- gap/format id bất thường;
- source digest stale;
- superseded target thiếu;
- dependency cycle;
- orphan fixture/oracle.

## 39. Dependency graph condition

Edge typed: REQUIRES_SCHEMA, REQUIRES_FIXTURE, REQUIRES_CAPABILITY, REQUIRES_CONDITION, INVALIDATES_RESULT, COVERED_BY_GATE.

Graph condition bắt buộc DAG ở prerequisite edges. Gate aggregation có thể tham chiếu nhiều node nhưng không tạo prerequisite ngược.

## 40. Fixture matrix

Condition chỉ khai variants làm đổi kết luận. Catalog compiler mở matrix có giới hạn, kiểm pairwise/metamorphic coverage và phát hiện tích Descartes quá lớn.

Mỗi expanded RunSpec có stable derived id/fingerprint; không tính expanded runs thành condition mới.

## 41. Oracle binding

ConditionSpec tham chiếu OracleSpec id/version, không nhúng code path tùy stack. Oracle implementation manifest map spec sang executable capability.

Thiếu implementation -> BLOCKED/UNSUPPORTED. Không fallback sang “không crash là PASS”.

## 42. Expected data provenance

Expected constant/golden có source: phép tính tay, contract formula, independent implementation hoặc approved snapshot. Ghi author/reviewer/revision/digest và tolerance/unit.

Không auto-update golden theo actual output. Regenerate expected cần review riêng.

## 43. RunSpec compilation

Compiler kết hợp condition + fixture + variants + policy + oracle + workload thành RunSpec đóng băng. Nó resolve dependency/version/capability và báo lý do không runnable.

RunSpec digest không chứa timestamp/path máy; environment/device đi vào RunFingerprint.

## 44. EvidenceBundle

Bundle gồm:

- condition/run/fingerprint ids;
- start/end state hash;
- event/transaction/RNG traces theo yêu cầu;
- validator/oracle results;
- metrics/environment;
- failure diff/artifacts;
- logs có cấu trúc;
- result status;
- signatures/digests/provenance;
- retention/security classification.

Một dòng log không đủ thay EvidenceBundle.

## 45. Result publication

Result chỉ publish sau artifact checksums, required evidence và oracle outputs đầy đủ. Catalog không chứa mutable “PASS” field chung; result store append theo fingerprint/revision.

Dashboard tính trạng thái hiện hành từ latest compatible result. Không ghi đè lịch sử FAIL/FLAKY.

## 46. Gate artifact

GateSpec nêu required conditions/run variants, accepted statuses, freshness/version constraints, evidence level và waiver policy. Gate result dẫn tới từng EvidenceBundle.

Waiver có owner/reason/expiry/scope; không đổi FAIL thành PASS. Gate có thể cho tiến với risk accepted nhưng báo rõ.

## 47. Build graph

```text
Markdown source refs
 + schema sources
 + content/fixture/policy sources
 + condition/oracle sources
 -> parse/lint
 -> registry resolve
 -> validate dependency/compatibility
 -> canonical IR
 -> codegen/compile artifacts
 -> conformance tests
 -> manifests/fingerprints/reports
```

Mỗi node cache theo input digest; cache hit không bỏ validation bắt buộc của output provenance.

## 48. Validation stages

| Stage | Kiểm |
|---|---|
| V-A syntax | parse/shape/limits |
| V-B schema | types/required/union/units |
| V-C references | ids/dependencies/version closure |
| V-D semantics | invariants/graphs/conservation/security |
| V-E fixtures | build/hash/overlay conflict |
| V-F catalog | counts/sources/dependencies/oracles |
| V-G bindings | codegen/golden/round-trip |
| V-H package | manifest/digests/reproducibility |

Stage sau không biến lỗi stage trước thành warning im lặng.

## 49. Severity và diagnostics

ERROR chặn artifact; WARNING cần mã/lý do; INFO chỉ hướng dẫn. Diagnostic có constraint id, artifact/source ref, semantic path, expected/actual và remediation hint.

Không dựa chỉ vào câu tiếng Anh/Vietnamese tự do để tool hiểu lỗi. Diagnostic code ổn định cho CI/report.

## 50. Reproducible build

Cùng source digests, tool versions, config và target profile phải tạo cùng canonical artifact digests. Timestamp, absolute path, thread order và host locale bị loại khỏi payload.

Binary/package bytes có thể khác do container signing/compression metadata, nhưng canonical logical digest phải giống và khác biệt được giải thích.

## 51. BuildManifest

Manifest ghi:

- source/artifact dependency closure;
- compiler/codegen/validator versions;
- target profiles;
- canonical digests;
- generated outputs;
- warnings/waivers;
- compatibility summary;
- reproducibility status;
- toolchain/environment fingerprint;
- release channel/status.

## 52. Capability manifest

Runtime công bố schema/content/migration/oracle/handler/storage capabilities theo id/version/range. Loader/runner so required vs provided trước execute.

Không suy capability từ app version hoặc platform name. Mobile và desktop cùng build logic nên công bố cùng core capabilities; adapter capability có thể khác rõ.

## 53. Compatibility manifest

Ma trận giữa save schema, content, policy, RNG, handler, storage format, command/projection API và platform adapter. Mỗi cạnh ghi operation support và migration path.

“Cùng phiên bản game” không đủ. Missing edge làm load/execute UNSUPPORTED trước mutation.

## 54. Release channels

Artifact có DRAFT, DEV, TEST, RELEASE_CANDIDATE, RELEASED, DEPRECATED. Save production chỉ tham chiếu RELEASED/allowed RC theo policy rõ.

Dev artifact không tự load vào world người dùng. Channel promotion giữ digest, evidence và approvals cần thiết.

## 55. Artifact immutability và registry append

Published `(artifact_id, version)` không đổi digest. Registry update append version/status/supersession; không sửa lịch sử.

Nếu rebuild cùng version cho digest khác, build fail hoặc dùng build metadata/version mới theo policy; không cache-poison artifact cũ.

## 56. Package signing và trust

Signing là tùy chọn phát hành, không thay checksum/schema validation. Trust policy phân official/local-dev/community và capability được phép.

Unsigned content cục bộ có thể được cho phép theo chế độ sau này, nhưng script/capability vẫn sandbox. K3.6 chưa chọn cơ chế khóa/chữ ký.

## 57. Input limits

Parser/compiler/runtime giới hạn file/artifact size, nesting, string, records, refs, graph depth, decompressed bytes, regex/expression cost và dependency count.

Limit thuộc profile/version và báo diagnostic. Không dùng stack overflow/OOM làm cách từ chối dữ liệu xấu.

## 58. Secret và dữ liệu riêng

Artifact source/content/save không chứa token signing/cloud. Evidence/log có classification/redaction; fixture công khai không chứa dữ liệu cá nhân thật.

Secret được inject qua platform/CI secure channel khi có, không đi vào canonical digest trừ public key/trust metadata cần thiết.

## 59. Localization artifact

Locale package map semantic keys sang text/forms, có plural/grammar/fallback/version. Missing translation không đổi logic và không dùng raw secret id làm fallback gameplay.

Schema docs có thể song ngữ sau này; field/id semantics vẫn độc lập locale.

## 60. Generated documentation

Registry có thể sinh bảng schema, artifact dependency, family counts và catalog coverage vào khu generated riêng. Báo cáo dẫn link về vault nhưng không trở thành bản sao MASTER/DECISIONS.

Người dùng sửa tài liệu nguồn; generated docs bị ghi đè ở build và không chứa quyết định mới.

## 61. Repository topology tương lai

```text
spec-machine/
  registry/
  schemas/
  units-ids/
  content/
  fixtures-overlays/
  policies/
  generators/
  conditions/
  oracles/
  migrations/
  workloads/
tools/
  spec-compiler/
  codegen/
  catalog-audit/
generated/
  ir/
  bindings/
  manifests/
  reports/
evidence/
  runs/
  failures/
  parity/
  benchmarks/
```

Đây là topology kế hoạch. Vault `Reality Cultivation/` vẫn là nguồn hồ sơ duy nhất; chưa tạo các thư mục trên.

## 62. Quy tắc ownership trong repository

- schema owner duyệt semantics;
- domain owner viết rule/oracle;
- fixture owner khóa state/hash;
- condition owner giữ statement/source;
- toolchain owner giữ compiler/codegen;
- runtime owner implement capability;
- evidence publisher không sửa spec;
- generated output không có owner biên tập tay.

Một người có thể giữ nhiều vai trò, nhưng artifact ghi vai trò logic để review.

## 63. Change workflow

1. sửa nguồn Markdown/quyết định nếu semantics đổi;
2. sửa schema/spec source;
3. compiler tạo impact report;
4. update migration/fixtures/conditions/oracles;
5. regenerate bindings/manifests;
6. chạy conformance và impacted runs khi đã có runner;
7. review compatibility/evidence;
8. publish artifact version;
9. cập nhật STATE/CHANGELOG trung thực.

Không publish schema rồi mới đi tìm điều kiện bị phá.

## 64. Impact analysis

Từ artifact/field/constraint đổi, graph tìm:

- schemas dependent;
- content/fixtures;
- bindings/platforms;
- migrations/save compatibility;
- conditions/oracles;
- workload/golden;
- released manifests;
- docs/source refs;
- prior results thành stale.

Impact report không tự khẳng định semantic safety; nó chỉ chỉ ra phạm vi review/run.

## 65. Bootstrap catalog theo chặng

| Chặng | Phạm vi |
|---|---|
| C0 | manifest 32 họ và source mapping 1.024 ids |
| C1 | ConditionSpec skeleton giữ statement/source/NOT_RUN |
| C2 | K0 + W0 fixtures/schema refs |
| C3 | HD/LS/GV/LP contracts và core oracles |
| C4 | K1 An Khê scenarios |
| C5 | cognition/domain/UI conditions |
| C6 | performance/K3 architecture/storage conditions |
| C7 | full dependency/coverage audit |

Mỗi chặng có count/diff; skeleton không được báo là executable.

## 66. Definition of encoded

Condition chỉ ENCODED khi:

- id/revision/lifecycle hợp lệ;
- statement/source digest đã review;
- family/kinds/tags có;
- dependencies/fixture/oracle requirements ghi rõ, kể cả missing;
- expected unsupported/blocker có;
- schema validation pass;
- không trùng id;
- result_state vẫn độc lập.

Không yêu cầu implementation để encode, nhưng không gắn IMPLEMENTABLE nếu blocker spec còn mơ hồ.

## 67. Definition of implemented

IMPLEMENTED cần runner có thể discover, build fixture, đưa stimulus, thu required artifacts và gọi oracle implementation trên ít nhất một supported target. Nó vẫn có thể NOT_RUN cho build hiện tại.

PASS chỉ đến từ published EvidenceBundle đúng fingerprint. Compile/test discovery thành công không là PASS behavior.

## 68. Catalog coverage dashboard

Hiển thị theo family/system:

- source ids;
- ENCODED/IMPLEMENTABLE/IMPLEMENTED;
- NOT_RUN/BLOCKED/UNSUPPORTED/PASS/FAIL/...;
- missing fixture/oracle/capability;
- stale source/result;
- last compatible run;
- evidence level;
- gate impact.

Mặc định không gộp NOT_RUN vào “passed percentage”.

## 69. K3.6 gates

| Gate | Yêu cầu | Hiện tại |
|---|---|---|
| K3A01 | artifact/schema/catalog semantics rõ | đạt trên giấy |
| K3A02 | registry/version/compatibility/codegen rõ | đạt đặc tả |
| K3A03 | 32 họ/1.024 inventory được đối chiếu | đạt văn bản |
| K3A04 | bootstrap/build/impact workflow rõ | đạt đặc tả |
| K3A05 | schema registry máy tồn tại | chưa |
| K3A06 | 1.024 ConditionSpec ENCODED | chưa |
| K3A07 | codegen bindings/conformance | chưa code |
| K3A08 | runner/oracle implementations | chưa code |
| K3A09 | EvidenceBundle hiện hành | chưa chạy |
| K3A10 | mobile/desktop full artifact parity | chưa chạy |

Gate không cộng vào AM.

## 70. Điều kiện AM01–AM20 — identity, registry và schema

| ID | Điều kiện chưa chạy |
|---|---|
| AM01 | artifact id/kind/version trùng nhưng digest khác bị từ chối |
| AM02 | ArtifactEnvelope thiếu owner/source/dependency/digest bị từ chối |
| AM03 | artifact URI resolve độc lập đường dẫn filesystem |
| AM04 | SourceRef line đổi nhưng semantic anchor/digest đúng vẫn map |
| AM05 | semantic anchor id không được tái sử dụng cho nghĩa khác |
| AM06 | registry import graph có cycle bị từ chối |
| AM07 | một schema id/version chỉ có một canonical digest |
| AM08 | compatibility được đánh theo READ/WRITE/ROUND_TRIP/EXECUTE/MIGRATE |
| AM09 | unknown field required-preserve sống qua round-trip |
| AM10 | unknown executable semantics làm runtime UNSUPPORTED |
| AM11 | fixed-point/integer boundary có overflow diagnostic xác định |
| AM12 | unit field không nhận quantity khác dimension |
| AM13 | display unit đổi không đổi stored logical value |
| AM14 | typed id underlying giống nhau không cross-kind coercion |
| AM15 | retired id/prefix không được cấp lại |
| AM16 | CLOSED enum unknown fail; OPEN enum preserve không execute |
| AM17 | CONTENT_DEFINED value không bị hard-code thành enum binding |
| AM18 | union nhiều discriminant/variant fields mâu thuẫn bị từ chối |
| AM19 | graph multiplicity/cycle/reachability constraints chạy đúng phase |
| AM20 | constraint diagnostic có code/source/path/expected/actual |

## 71. Điều kiện AM21–AM40 — IR, codegen và artifact domain

| ID | Điều kiện chưa chạy |
|---|---|
| AM21 | cùng schema sources tạo cùng canonical IR digest |
| AM22 | host locale/path/thread order không đổi codegen output logic |
| AM23 | bindings Rust/Dart/Kotlin/C# tham chiếu cùng IR digest khi được tạo |
| AM24 | generated file chỉnh tay bị regenerate/check phát hiện |
| AM25 | handwritten domain logic không import codegen internals |
| AM26 | cross-target golden encode cho cùng canonical bytes/hash |
| AM27 | binding làm mất unknown field bị conformance fail |
| AM28 | binding không đạt schema revision làm target UNSUPPORTED |
| AM29 | compiled content dependency closure và fingerprint đầy đủ |
| AM30 | fixture recipe lặp lại cho cùng initial state hash |
| AM31 | fixture không đọc state dư từ run trước |
| AM32 | overlay sai base hash/ref/precondition bị từ chối |
| AM33 | overlay conflict được phát hiện trước run |
| AM34 | policy unconfirmed giữ nhãn, không biến thành quyết định user |
| AM35 | RunFingerprint chứa policy digest |
| AM36 | generator spec thiếu implementation không tạo output giả |
| AM37 | migration graph ambiguous/cycle bị từ chối |
| AM38 | migration preserve rules kiểm unknown/ids/provenance |
| AM39 | Workload artifact không chứa config riêng của candidate stack trong logical digest |
| AM40 | runtime capability được so theo id/version, không app version chung |

## 72. Điều kiện AM41–AM60 — catalog và run compilation

| ID | Điều kiện chưa chạy |
|---|---|
| AM41 | source inventory manifest đếm đúng 1.024 ids/32 họ |
| AM42 | gate ids không bị đếm vào condition catalog |
| AM43 | mỗi ACTIVE condition có đúng một owner/source mapping |
| AM44 | condition id/revision không tái sử dụng |
| AM45 | statement machine giữ phủ định/phạm vi/thời gian/exception/unit |
| AM46 | source digest đổi làm mapping stale |
| AM47 | ENCODED không tự đổi result khỏi NOT_RUN |
| AM48 | IMPLEMENTED không tự tạo PASS |
| AM49 | superseded/retired condition vẫn còn lịch sử/replacement reason |
| AM50 | semantic revision mới làm prior result STALE_RESULT |
| AM51 | source id thiếu catalog được báo |
| AM52 | ACTIVE catalog id mất source được báo |
| AM53 | duplicate id/statement/family count gap được báo |
| AM54 | prerequisite dependency cycle bị từ chối |
| AM55 | matrix expansion không đổi số condition gốc |
| AM56 | RunSpec derived id ổn định theo inputs |
| AM57 | thiếu fixture/oracle/capability trả blocker rõ |
| AM58 | oracle binding thiếu không fallback “không crash là PASS” |
| AM59 | expected/golden thiếu provenance bị từ chối |
| AM60 | auto-update golden từ actual output bị cấm |

## 73. Điều kiện AM61–AM80 — evidence, build và vận hành

| ID | Điều kiện chưa chạy |
|---|---|
| AM61 | RunSpec digest độc lập timestamp/absolute host path |
| AM62 | EvidenceBundle thiếu required artifact không publish PASS |
| AM63 | result append theo fingerprint, không ghi đè FAIL/FLAKY cũ |
| AM64 | dashboard chỉ dùng latest compatible result |
| AM65 | waiver không đổi FAIL thành PASS và có expiry/scope |
| AM66 | build stage sau không hạ lỗi bắt buộc stage trước thành warning |
| AM67 | cùng source/tool/config tạo cùng canonical artifact digests |
| AM68 | BuildManifest dẫn đủ dependency/tool/output/warning/compatibility |
| AM69 | missing compatibility edge dừng load/execute trước mutation |
| AM70 | DEV artifact không tự load vào released world |
| AM71 | published artifact version immutable |
| AM72 | parser giới hạn size/depth/ref/expression trước OOM/stack overflow |
| AM73 | secret/token không vào canonical artifact/save/evidence công khai |
| AM74 | locale package thiếu key không làm lộ secret raw id |
| AM75 | generated docs không ghi đè vault decisions/master plan |
| AM76 | impact report tìm schema/content/fixture/condition/oracle/result bị ảnh hưởng |
| AM77 | C0–C7 bootstrap báo riêng TEXT_ONLY/ENCODED/IMPLEMENTED |
| AM78 | dashboard không tính NOT_RUN vào tỷ lệ passed |
| AM79 | mobile/desktop cùng registry/catalog logical digests |
| AM80 | claim “1.024 đã test” bị audit từ chối khi không có 1.024 EvidenceBundle hợp lệ |

## 74. Truy vết và tổng điều kiện

| Nhóm AM | Nguồn |
|---|---|
| AM01–AM20 | K2.1 schema/state, K3.3 content package |
| AM21–AM40 | K3.1 đa nền tảng, K3.2 bindings, migration/workload |
| AM41–AM60 | K2.6 Condition/Fixture/Run/Oracle contracts |
| AM61–AM80 | evidence/build/compatibility/security/parity |

80 AM nâng tổng từ 1.024 lên **1.104 điều kiện thiết kế chưa chạy**, thuộc 33 họ.

## 75. Manifest kiểm kê đề xuất

```text
catalog_manifest:
  revision: 1
  expected_active_conditions: 1024  # tại đầu K3.6
  families: 32
  source_snapshot: <vault digest>
  encoded_conditions: 0             # trạng thái thật hiện tại
  implemented_conditions: 0
  current_pass_results: 0
```

Sau khi thêm AM01–AM80, inventory thiết kế mới là 1.104/33 họ; manifest máy vẫn chưa tồn tại. Ví dụ trên chỉ mô tả cấu trúc và phải lấy count từ generation cụ thể khi được triển khai.

## 76. Thứ tự hiện thực hóa khi được phép

1. ArtifactEnvelope/URI/SourceRef;
2. primitive/unit/typed-id registry;
3. schema IR/compiler tối thiểu;
4. canonical codec + một target binding;
5. catalog manifest/inventory scanner;
6. C1 ConditionSpec skeleton 1.104 điều kiện theo snapshot mới;
7. fixture/overlay/policy schemas;
8. RunSpec/Oracle/Evidence schemas;
9. multi-target bindings/conformance;
10. migration/compatibility/build manifests;
11. dashboard/impact report;
12. chỉ sau đó implement runner/domain theo vertical slices.

## 77. Review batch để tránh 1.104 entry sai hàng loạt

Không tự sinh toàn catalog rồi coi xong. Review theo họ/tài liệu, ưu tiên:

1. DS/HD primitives và state;
2. LS/GV/LP runtime correctness;
3. KT/LU architecture/storage;
4. fixture K0/K1;
5. cognition/domain/UI;
6. performance/generation/resolution;
7. cross-family dependency audit.

Mỗi batch có before/after count, source diff và unresolved list.

## 78. Điều không được tuyên bố

- Không nói schema registry/catalog đã tồn tại.
- Không nói 1.104 ConditionSpec đã mã hóa.
- Không nói codegen/bindings đã chạy.
- Không nói compatibility/migration đã chứng minh.
- Không nói catalog hóa tương đương kiểm thử.
- Không nói một condition PASS nếu thiếu EvidenceBundle hiện hành.
- Không nói đã chọn format/schema language/toolchain.

## 79. Giá trị K3.6 cung cấp thật

- taxonomy artifact và envelope chung;
- registry/version/compatibility/unknown policy;
- IR/codegen boundary đa nền tảng;
- mapping bền từ Obsidian sang machine catalog;
- hai trục automation/result chống báo cáo sai;
- build/validation/evidence/impact workflow;
- bootstrap có thể review cho hơn một nghìn điều kiện;
- tiêu chí rõ để kiểm toán mức sẵn sàng triển khai.

## 80. Bước tiếp theo

K3 đã đóng gói; K4.1–K4.3 đã lập nền hiện tượng, cơ thể và vật phẩm. K4.4 nay đã lập môi trường tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
