---
title: Lưu trữ, phân vùng, chỉ mục và truy vấn thế giới — K3.5
aliases:
  - K3.5
  - Kiến trúc lưu trữ thế giới
tags:
  - reality-cultivation
  - thiet-ke
  - luu-tru
  - truy-van
  - quy-mo
status: de-xuat
updated: 2026-09-06
---

# Lưu trữ, phân vùng, chỉ mục và truy vấn thế giới — K3.5

Tài liệu này chuyển hợp đồng save trong [[HOP_DONG_LUU_TAI_MIGRATION_PHUC_HOI_K2]], kiến trúc runtime trong [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]] và PersonCore/capsule/shard/frontier của [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]] thành mô hình lưu trữ có thể triển khai.

Đây là thiết kế trung lập công nghệ. Chưa chọn file package, embedded relational database, key-value/LSM engine, codec hoặc thuật toán nén. 76 điều kiện LU cuối tài liệu đều chưa chạy.

## 1. Ba lớp dữ liệu không được trộn

| Lớp | Vai trò | Có thể dựng lại? |
|---|---|---|
| `Canonical World State` | sự thật gameplay đang có hiệu lực | không, trừ từ snapshot+journal hợp lệ |
| `Portable Save Image` | biểu diễn bền vững độc lập engine | là nguồn phục hồi được công bố |
| `Derived Index/Cache/View` | tăng tốc tìm kiếm và hiển thị | có, từ canonical state |

Database row, object runtime và cache không tự trở thành format save công khai.

## 2. Mục tiêu K3.5

1. Một writer authority và snapshot đọc nhất quán.
2. Save portable giữa điện thoại/máy tính.
3. Lazy-load thế giới lớn mà không bỏ frontier.
4. Truy vấn 100.000+ Person không quét toàn bộ.
5. Index không làm lộ tri thức bí mật.
6. Transaction xuyên shard không nhân/mất state.
7. Crash/compaction/migration luôn giữ generation hợp lệ cũ.
8. Storage engine có thể thay qua adapter và migration.

## 3. Các workload truy cập chính

| Mã | Truy cập |
|---|---|
| AP01 | lấy record theo typed id |
| AP02 | lấy mọi state nóng của region/place |
| AP03 | lấy frontier đến game time T |
| AP04 | tìm Person theo region/role/household/organization |
| AP05 | tìm asset theo owner/custody/container/location |
| AP06 | duyệt relation/memory/message có quyền |
| AP07 | commit mutation nhiều record nguyên tử |
| AP08 | append event/journal/receipt |
| AP09 | build boundary snapshot/save |
| AP10 | load active world rồi lazy cold shards |
| AP11 | compact history/capsule/tombstone có gate |
| AP12 | projection phân trang/tìm kiếm cho UI |

Thiết kế engine phải benchmark theo access pattern, không chỉ insert/second tổng quát.

## 4. Logical stores

- `ManifestStore` — world/branch/generation/revision vector;
- `RecordStore` — records canonical theo domain/id;
- `EventJournalStore` — committed transition log;
- `FrontierStore` — scheduled boundaries/wakeup;
- `CapsuleStore` — cold state có version/hash;
- `FlowStore` — BoundaryFlow/in-flight entity;
- `AnchorStore` — anchor/tombstone/provenance;
- `ContentStore` — compiled package bất biến;
- `IndexStore` — indices có thể rebuild;
- `EvidenceStore` — test/benchmark artifact, tách gameplay save.

Logical store có thể cùng một engine vật lý nhưng quyền/schema/lifecycle vẫn tách.

## 5. Record key

Khóa logic gồm `world_lineage + branch + typed_id + record_kind`. Revision không nằm trong identity; nó là version của value/commit.

Khóa phải:

- canonical byte ordering;
- không phụ thuộc locale/path/object address;
- phân biệt domain id;
- có checksum/type guard khi decode;
- hỗ trợ partition routing;
- không lộ secret qua UI.

## 6. Record envelope bền vững

Mỗi record lưu:

- id/kind/schema version;
- entity revision;
- created/updated game boundary;
- content/policy fingerprints khi liên quan;
- payload canonical;
- refs hoặc ref digest;
- provenance/owner module;
- logical checksum;
- tombstone state nếu có.

Engine metadata không đi vào logical hash.

## 7. Commit identity

Mỗi commit có `commit_id`, parent revision vector, game time/phase/wave, command/event causal refs, read/write sets, mutation digest, journal range và resulting root hash.

Retry cùng commit intent/idempotency key trả commit cũ hoặc conflict; không tạo revision song song trong cùng writer lineage.

## 8. Single-writer và nhiều reader

Simulation Runtime là writer duy nhất. UI projection, validator và save builder đọc immutable revision/snapshot handle.

Reader không giữ writer lock qua render/I/O. Reader quá cũ có thể nhận `SNAPSHOT_EXPIRED` và yêu cầu projection mới; không được đọc nửa commit.

## 9. Read snapshot

`ReadSnapshotToken` khóa:

- world/branch;
- root revision/vector;
- active shard revisions;
- content/policy versions;
- opened/expiry lifecycle;
- capabilities/viewer scope.

Token cho consistency, không tự cấp quyền biết mọi record.

## 10. Unit of work

Transaction chuẩn:

1. mở snapshot/revision;
2. đọc declared read set;
3. dựng MutationSet;
4. validate refs/revisions/invariants;
5. stage records/journal/index deltas;
6. ghi commit marker/root;
7. publish atomically;
8. phát Facts/View invalidations sau publish.

Index update lỗi không được công bố commit canonical nửa vời; có thể đánh dấu rebuild nếu index là derived.

## 11. Transaction xuyên shard

Không cho mỗi shard tự commit một nửa giao dịch. Dùng logical transaction coordinator:

- khóa/reserve declared keys theo canonical order;
- stage deltas ở shard;
- ghi transaction intent/digest;
- validate all participants;
- publish một commit decision;
- shard apply idempotently;
- recovery dựa decision, không đoán.

Baseline single-process vẫn cần semantics này cho save/crash.

## 12. Revision vector

Global root chỉ tới revision của từng shard/store. Commit không chạm shard nào giữ revision cũ của shard đó. Snapshot generation lưu một vector nhất quán.

Vector không dùng wall-clock. Hai vector không có ancestor rõ là divergence, không auto-merge.

## 13. Phân vùng cấp cao

Đề xuất partition axes:

- world lineage/branch;
- region stable id;
- entity domain/kind;
- hot/warm/cold tier;
- time segment cho journal;
- retention class cho history/anchor;
- content package fingerprint.

Không partition chỉ theo id hash nếu mọi truy vấn địa phương phải scatter toàn world.

## 14. Region shard

Region shard sở hữu place/environment/local organizations và routing refs tới Person/asset liên quan. PersonCore có thể nằm partition riêng để di cư không đổi identity key.

Shard boundary không được cắt một record canonical thành hai chủ quản. Cross-region facts dùng BoundaryFlow/refs.

## 15. Person partitions

PersonCore partition theo stable bucket có thể cộng region index. Di cư chỉ đổi current position/ref và indices, không di chuyển identity bằng delete+create.

Cold capsules có thể đặt gần PersonCore hoặc object segment riêng; manifest/digest bảo đảm tìm được. Household/organization refs không nhúng object graph toàn phần.

## 16. Asset partitions

Asset record theo typed id; location/owner/container là fields/refs và indices. Container tree không lưu bản sao child ở nhiều nơi.

Bulk lots có segment chuyên biệt nhưng split/merge dẫn provenance. Query stock vùng tổng hợp qua index/ledger, không là nguồn thật thứ hai.

## 17. Event journal partition

Journal chia segment theo sequence/game-time window và commit boundary, không cắt atomic commit. Header có start/end sequence, previous hash, schema/content versions, compression info và checksum.

Segment sealed bất biến. Tail segment recovery bỏ entry chưa có valid commit marker.

## 18. Frontier partition

Frontier cần index toàn cục đủ biết boundary sớm nhất dù cold shard chưa load. Entry tối thiểu giữ time/phase/wave, target routing, handler/version, payload ref/digest và stale guard.

Không lazy-load đến mức bỏ quên birth/death/deadline/message của cold Person.

## 19. BoundaryFlow store

Flow được lưu ngoài exclusive ownership của source/destination region khi IN_TRANSIT. Source/destination indices chỉ trỏ tới cùng flow id.

Arrival/departure idempotency và entity custody nằm trong flow record; crash không thể tạo một bản ở mỗi shard.

## 20. Anchor và tombstone partitions

Anchor/tombstone partition theo retention class + stable id, với reverse references. Permanent/legal anchors ưu tiên backup/validation; compactable history có segment riêng.

Không xóa tombstone chỉ vì primary record shard đã được compact.

## 21. Content-addressed blobs

Payload bất biến lớn như compiled content, sealed capsule hoặc snapshot chunk có thể lưu theo content hash. Manifest/ref count chỉ hỗ trợ GC; hash+type+length vẫn phải validate.

Trùng blob được deduplicate vật lý nhưng không merge hai logical entities. Mã hóa/nén khác không đổi logical content hash.

## 22. Root manifest

Root manifest công bố:

- world/branch/generation;
- root state hash;
- shard revision map;
- journal frontier;
- RNG/handler/content/policy versions;
- required blobs/segments;
- index rebuild status;
- compatibility/migration info;
- previous valid generation;
- created/published boundary.

Manifest nhỏ nhưng là điểm phục hồi quan trọng nhất; ghi theo protocol hai pha.

## 23. Live store khác save package

Live store tối ưu random access/transactions. Portable save tối ưu tính độc lập engine, kiểm tra và import/export. SaveBuilder đọc snapshot token rồi xuất canonical chunks/manifest.

Không copy thẳng file live database và gọi đó là format save nếu file phụ thuộc version/OS/locking/page state của engine.

## 24. Portable chunk

Chunk save có:

- logical kind/key range;
- schema/version;
- record count;
- canonical uncompressed digest;
- encoding/compression metadata;
- stored bytes checksum;
- dependency refs;
- min/max game time hoặc id;
- size limits.

Reader kiểm giới hạn trước giải nén để chống package độc hại/hỏng.

## 25. Full snapshot và incremental generation

Full snapshot tạo điểm nền độc lập. Incremental generation tham chiếu ancestor rõ và chứa changed chunks/journal range/tombstones.

Retention giữ đủ chain hoặc materialize full mới trước khi xóa ancestor. Không để slot phụ thuộc generation đã prune.

## 26. Lazy load

Load tối thiểu trước RUNNING:

- root manifest/vector;
- global frontier;
- active region/person pins;
- in-flight flows/transactions;
- RNG/idempotency/command state;
- required content/policies;
- index routing map.

Cold payload load khi query/promotion; missing required data dừng an toàn.

## 27. Prefetch

Prefetch dựa interaction horizon, route/message/deadline và observed access pattern, nhưng chỉ là tối ưu. Sai dự đoán làm tăng latency, không đổi result.

Prefetch có byte/time/energy budget riêng cho mobile; bị hủy không rollback gameplay. Không tiêu gameplay RNG.

## 28. Eviction

Chỉ eviction warm derived/capsule-decoded state đã có canonical cold form và không pin. Trước eviction kiểm dirty state đã commit, active reader/process và reload recipe.

Memory pressure có thể ép eviction; không được xóa PersonCore/frontier/flow hoặc mutation chưa bền vững.

## 29. Primary index theo ID

`IdRoutingIndex` ánh typed id tới logical store/partition/key/revision status. Đây là derived routing structure có generation/version/checksum.

Nếu index hỏng, scan manifest/segment headers để rebuild; không kết luận entity không tồn tại chỉ vì lookup miss bất thường.

## 30. Spatial index

Index Place/Route/Position theo region và topology. Nó lưu refs/bounds, không nhân Position canonical. Query cần exact position revalidate record revision sau candidate lookup.

Index hỗ trợ nhiều scale và entity in transit. Không dùng camera viewport làm world ownership.

## 31. Temporal index

Frontier/wakeup/deadline/message arrival sử dụng ordered time keys có phase/wave. Journal time index phục vụ audit/query nhưng journal sequence vẫn canonical.

Time bucket có thể tăng tốc range scan; boundary cùng bucket không mất order chính xác.

## 32. Ownership và custody index

Indices cho title, custody, possession, reservation và claim tách loại. UI/query không gộp thành “đồ của X” nếu semantics khác.

Mỗi result revalidate Asset/Right revisions. Index update chậm không được cho phép transaction dùng quyền cũ.

## 33. Social graph index

Adjacency theo directed relationship type/source/valid interval. Không tạo matrix N². High-degree organization/reputation dùng membership/channel indices riêng.

Query viewer chỉ nhận edges họ biết hoặc được quyền xem. Audit graph toàn tri dùng capability khác.

## 34. Cognition index

Belief/Memory/Knowledge index nằm theo owner Person, proposition/topic/source/time. Search không đối chiếu trực tiếp Fact để “sửa” belief.

Full-text text renderer có thể index câu hiển thị, nhưng semantic source vẫn là records. Re-localize có thể rebuild text index mà không đổi logic.

## 35. Body và cultivation index

Active condition/threshold/treatment/breakthrough frontier cần index đánh thức. Anatomy graph chủ yếu nằm capsule/record của Person, không global index từng bộ phận trừ workload chứng minh cần.

Query “mọi người bị thương” dựa condition summary index rồi revalidate; không load mọi body node.

## 36. Full-text search

Chỉ index text mà viewer có thể truy cập hoặc lọc bằng semantic ACL/knowledge trước trả kết quả. Không dựa post-filter sau khi snippet/score đã lộ secret.

Index theo locale/version; thay locale rebuild được. Search ranking không tham gia gameplay quyết định NPC.

## 37. Projection index

Danh sách UI thường dùng có materialized/derived projection cache theo viewer scope + source revision + query fingerprint. Cache invalidation lấy từ committed write set/facts.

Cache stale được đánh dấu; không trộn page cursor từ revision khác. Mobile/desktop page size khác vẫn cùng stable ordering.

## 38. Stable ordering và pagination

Mọi query phân trang định nghĩa sort semantic + stable tie-break không thiên vị gameplay. Cursor chứa query/version/revision/last key và checksum; không dùng offset cho tập đang đổi nếu gây trùng/mất dòng.

ID có thể là final tie-break hiển thị nhưng không dùng để phân tài nguyên/initiative.

## 39. Query API

`QuerySpec` có viewer/capability, projection kind, filters, sort, page limit/cursor, requested fields, consistency/freshness và cost budget.

Planner từ chối query không giới hạn/quá đắt hoặc trả continuation. UI không gửi raw query language có thể đọc mọi store.

## 40. Query cost budget

Ước lượng records/chunks/index scans/bytes/decode/time. Query vượt budget:

- yêu cầu thu hẹp;
- trả page/continuation;
- dùng summary hợp lệ;
- schedule background projection;
- báo unavailable nếu cold data thiếu.

Không hạ truth/knowledge filter để chạy nhanh.

## 41. Query consistency levels

| Mức | Dùng cho |
|---|---|
| EXACT_REVISION | command preview, giao dịch, debug/oracle |
| LATEST_COMMITTED | màn hình hiện tại |
| STALE_ALLOWED | lịch sử/danh sách lớn có nhãn freshness |
| SUMMARY_ALLOWED | thống kê vùng theo representation đã khai |

UI phải hiển thị freshness khi có ý nghĩa. Command vẫn revalidate trên latest boundary.

## 42. Không rò tri thức qua hiệu năng

Sự tồn tại của secret entity không được lộ qua count, pagination, error, timing rõ hoặc autocomplete. Query planner nên xử permission/knowledge scope trước candidate set nhạy cảm.

Không thể loại mọi side channel tuyệt đối trong game cục bộ, nhưng API/UI thường không cung cấp oracle bí mật ngoài gameplay.

## 43. Index lifecycle

Mỗi index có:

- definition/version;
- source record kinds;
- source revision coverage;
- build/checkpoint cursor;
- checksum/statistics;
- stale/rebuilding/ready status;
- update mode;
- memory/disk budget;
- validation samples;
- rebuild recipe.

Index READY chỉ khi coverage khớp root revision yêu cầu.

## 44. Synchronous và asynchronous index

Index cần cho correctness như id routing/frontier/reservation được cập nhật trong commit hoặc có delta overlay bắt buộc. Index chỉ phục vụ tìm kiếm/UI có thể async và mang freshness.

Không cho transaction tin asynchronous ownership index thay record canonical.

## 45. Rebuild index

Rebuild đọc immutable snapshot, tạo generation mới, validate counts/samples/digests rồi swap manifest. Mutation mới trong lúc build đi vào delta log và được catch up trước READY.

Crash giữ index generation cũ hoặc đánh dấu rebuild; không ảnh hưởng canonical world load.

## 46. Statistics và query planning

Cardinality/size/selectivity stats là derived, gắn revision range. Planner khác nhau có thể chọn access path khác nhưng output semantic/order phải giống.

Stats không đi vào state hash/RNG. Bad stats làm chậm, không làm sai hoặc lộ scope.

## 47. Cache hierarchy

| Tầng | Ví dụ | Eviction |
|---|---|---|
| C0 pinned | active Person/region/frontier | theo pin gate |
| C1 warm | sắp tương tác/promote | LRU/cost có deterministic neutrality |
| C2 decoded cold | capsule/blob vừa đọc | bỏ tự do khi clean |
| C3 projection | pages/text/search | theo viewer/revision |
| C4 OS storage cache | do platform | không được giả durability |

Cache policy có thể khác thiết bị nhưng không đổi logic.

## 48. Write-ahead journal logic

Trước publish root, durable intent/entries phải đủ recovery theo contract. Thứ tự khái niệm:

1. stage blobs/pages;
2. append mutation/commit payload;
3. durability barrier theo adapter capability;
4. publish root/commit marker;
5. ack;
6. index/view side effects.

Không khẳng định fsync nếu nền tảng không cung cấp; adapter phải mô tả guarantee thật.

## 49. Durability capability

`StorageCapabilityProfile` ghi atomic replace/append, durability barrier, file locking, max file/blob, random access, background write window, quota/free space và corruption behavior.

Protocol save chọn đường đã chứng minh cho profile. Desktop semantics không được áp giả cho mobile sandbox.

## 50. Mobile lifecycle và I/O

Write lớn được chia chunk/stage trước; publish manifest nhỏ tại safe boundary. Khi background time ngắn, ưu tiên khép commit và checkpoint tối thiểu hơn compact/index rebuild.

App bị kill giữa I/O phải load generation cũ/mới hợp lệ. UI không báo “đã lưu” trước publish/durability contract.

## 51. Dung lượng trống và quota

Trước save/compact/migrate ước lượng peak temporary bytes, giữ safety margin và kiểm lại. Thiếu chỗ:

- không xóa bản hợp lệ cũ;
- dọn cache/evidence theo policy;
- hủy staging an toàn;
- báo size/mức thiếu;
- cho export/prune lựa chọn hợp lệ;
- không xóa world records.

## 52. Compression

Nén theo chunk/segment để random/lazy read; dictionary/version có manifest. Logical hash tính trên canonical uncompressed form, stored checksum trên bytes thực.

Nén không chạy trong mutation critical path nếu làm vỡ latency; có thể staging/background từ frozen data.

## 53. Encryption

Mã hóa save là lựa chọn sản phẩm chưa chốt. Nếu có, khóa/nonce/KDF/version nằm ngoài gameplay semantics; xác thực trước decode và không tái dùng nonce sai.

Mất khóa không được “repair” bằng bỏ record. Export có chính sách rõ; secret cloud token không nằm trong save.

## 54. Checksums và Merkle/root digest

Mỗi chunk/segment có checksum; manifest có root digest theo canonical logical contents. Tree digest cho phép xác định shard hỏng/khác mà không đọc toàn world.

Checksum phát hiện lỗi, không chứng minh invariants gameplay. Load vẫn chạy schema/ref/domain validators phù hợp.

## 55. Corruption handling

Phân loại:

- manifest không đọc được;
- missing/truncated blob;
- checksum mismatch;
- schema/ref/invariant fail;
- journal fork/gap;
- index corruption;
- content dependency thiếu.

Chỉ index/cache được rebuild tự động. Canonical data chỉ phục hồi từ generation/backup/journal có bằng chứng; không bịa record.

## 56. Compaction

Compaction tạo artifact/generation mới từ snapshot đóng băng:

- gộp journal đã checkpoint;
- rewrite fragmented segments;
- deduplicate immutable blobs;
- compact history theo retention;
- giữ tombstone/anchors/refs;
- rebuild indices;
- validate root/invariants;
- publish rồi mới prune cũ.

Compaction không đổi logical state hash.

## 57. Garbage collection

GC chỉ xóa blob/segment không reachable từ bất kỳ retained manifest, pinned export, migration checkpoint hoặc evidence cần giữ. Reachability tính từ root set có version.

Reference count đơn lẻ không đủ khi crash có thể lệch; mark/sweep hoặc audit tương đương phải có recovery semantics.

## 58. Fragmentation và write amplification

Theo dõi live/stored byte ratio, segment count, small-record overhead, journal growth, rewrite bytes, flash writes và compaction pause. Mobile cần giới hạn write amplification vì pin/storage.

Không compact liên tục theo wall-clock nếu làm đổi scheduling; maintenance chỉ dùng real-time resource budget ngoài gameplay logic.

## 59. Retention policy

Policy tách:

- gameplay anchors/tombstones;
- technical checkpoints;
- manual saves/branches;
- crash recovery generations;
- evidence/benchmark;
- caches/indices;
- exports.

Prune phải hiển thị thứ bị xóa và không thay world đang mở. TN05 ảnh hưởng quyền save/branch, chưa chốt.

## 60. Migration storage

Migration chạy source generation read-only -> staging target format -> validate -> publish new generation/slot. Có progress/checkpoint/resume và mapping report.

Không migrate in-place. Engine migration và domain schema migration là hai lớp; cả hai ghi versions/provenance.

## 61. Backup và export

Export từ published generation, có manifest/checksum/content requirements và optional human-readable report. Backup incremental phải giữ ancestor chain hoàn chỉnh.

Copy file đang mở không được coi là backup nếu engine/protocol không bảo đảm consistency. Import staging và không ghi đè slot sống trước validate.

## 62. Đồng bộ nhiều thiết bị

Sync, nếu có, truyền portable immutable generations/chunks, không truyền live database pages. Dedupe theo logical chunk hash; xác định ancestor từ manifests.

Fast-forward khi rõ; divergence tạo branch. Index/cache không sync trừ tối ưu có thể bỏ. Core vẫn chạy không cloud.

## 63. Bốn họ storage cần so

| Họ | Điểm mạnh giả thuyết | Rủi ro cần spike |
|---|---|---|
| F — append segments + manifests | format kiểm soát, portable | tự xây query/index/transactions |
| R — embedded relational | transaction/query/index trưởng thành | schema/object mismatch, file portability/version |
| K — embedded key-value/LSM | key-range/write throughput | secondary index/transaction/compaction |
| H — hybrid live engine + portable chunks | cân bằng runtime/save | hai representation/migration complexity |

K3.5 không chọn họ thắng. H là hình dạng logic hứa hẹn nhưng vẫn cần chứng minh chi phí đồng bộ hai representation.

## 64. Spike storage chung

Mỗi ứng viên/họ phải chạy:

- 100.000 PersonCore nhỏ;
- 10.000 capsules biến kích thước;
- 1 triệu frontier/journal entries có phân bố thật;
- transaction chuyển asset xuyên hai shard;
- query AP01–AP12;
- snapshot/incremental/export/import;
- kill tại fault points;
- rebuild indices;
- compact/migrate;
- mobile/desktop parity và sustained growth.

Số này là workload kỹ thuật đề xuất, không là game content đã có.

## 65. Tiêu chí chấm storage

1. correctness/crash recovery;
2. portable canonical save;
3. query/access-pattern latency;
4. write amplification/storage growth;
5. memory/lazy load;
6. migration/tooling/inspection;
7. mobile lifecycle capability;
8. desktop performance;
9. dependency/license/maintenance;
10. adapter complexity và lock-in.

Correctness, recovery và portability là điều kiện loại trước tổng điểm.

## 66. Cổng K3.5

| Gate | Yêu cầu | Hiện tại |
|---|---|---|
| K3L01 | logical/canonical/save/index tách rõ | đạt trên giấy |
| K3L02 | partition/transaction/query/index lifecycle rõ | đạt đặc tả |
| K3L03 | mobile durability/compaction/migration rõ | đạt nguyên tắc |
| K3L04 | họ storage và spike chung rõ | đạt đặc tả |
| K3L05 | schema/chunk/index máy | chưa có |
| K3L06 | storage adapters/prototype | chưa code |
| K3L07 | crash/corruption/migration evidence | chưa chạy |
| K3L08 | 100.000 Person access evidence | chưa chạy |
| K3L09 | mobile/desktop parity/latency | chưa chạy |
| K3L10 | ADR chọn engine/format | chưa quyết |

Gate không cộng vào LU.

## 67. Điều kiện LU01–LU19 — canonical state và transaction

| ID | Điều kiện chưa chạy |
|---|---|
| LU01 | live engine layout không đi vào logical state hash |
| LU02 | cache/index bị xóa không làm mất canonical world |
| LU03 | typed id key không collision giữa domain |
| LU04 | record decode kiểm kind/schema/checksum |
| LU05 | retry commit id không tạo revision/mutation thứ hai |
| LU06 | reader chỉ thấy toàn bộ commit cũ hoặc mới |
| LU07 | UI reader không giữ writer lock qua render/I/O |
| LU08 | ReadSnapshotToken không tự cấp audit capability |
| LU09 | stale read set làm transaction conflict trước mutation |
| LU10 | Facts/View invalidation chỉ phát sau publish |
| LU11 | cross-shard transaction có một commit decision |
| LU12 | crash participant recovery theo decision, không đoán |
| LU13 | shard apply commit idempotently |
| LU14 | snapshot manifest khóa revision vector nhất quán |
| LU15 | divergence vector không auto-merge |
| LU16 | Person di cư không delete/create identity |
| LU17 | container child không có hai canonical owner/location copies |
| LU18 | journal segment không cắt atomic commit |
| LU19 | tail entry thiếu commit marker không được replay |

## 68. Điều kiện LU20–LU38 — shard, save và lazy load

| ID | Điều kiện chưa chạy |
|---|---|
| LU20 | global frontier thấy cold boundary dù shard chưa load |
| LU21 | in-transit entity chỉ có một canonical Flow record |
| LU22 | tombstone tồn tại độc lập với primary record compaction |
| LU23 | blob dedupe không merge logical entities |
| LU24 | root manifest dẫn đủ required chunks/versions/frontier |
| LU25 | live database copy không mặc định được nhận là portable save |
| LU26 | chunk kiểm kind/range/count/hash/size trước decode |
| LU27 | decompression bomb/oversized chunk bị từ chối an toàn |
| LU28 | incremental generation không phụ thuộc ancestor đã prune |
| LU29 | load trước RUNNING có manifest/frontier/flows/RNG/content |
| LU30 | missing required cold shard không làm Person biến mất |
| LU31 | prefetch on/off không đổi world result/hash |
| LU32 | prefetch bị hủy không rollback gameplay |
| LU33 | eviction dirty/pinned/active state bị từ chối |
| LU34 | memory pressure không xóa PersonCore/frontier/flow |
| LU35 | save mobile->desktop giữ canonical state hash |
| LU36 | save desktop->mobile giữ queue/RNG/capsules |
| LU37 | publish failure giữ generation hợp lệ cũ |
| LU38 | UI chỉ báo saved sau publish/durability contract |

## 69. Điều kiện LU39–LU57 — index và query

| ID | Điều kiện chưa chạy |
|---|---|
| LU39 | IdRoutingIndex miss bất thường kích validation/rebuild |
| LU40 | spatial candidate được revalidate bằng record revision |
| LU41 | temporal bucket không làm mất phase/wave order |
| LU42 | ownership/custody/possession/reservation không bị gộp semantics |
| LU43 | transaction không tin async ownership index |
| LU44 | social index giữ edge có hướng/source/interval |
| LU45 | cognition search không sửa Belief theo Fact |
| LU46 | body condition query không load mọi anatomy node |
| LU47 | full-text search không tạo snippet/count secret |
| LU48 | locale index rebuild không đổi logical state |
| LU49 | projection cache key có viewer/query/source revision |
| LU50 | page cursor khác revision không trộn/trùng/mất row |
| LU51 | stable display tie-break không tham gia gameplay allocation |
| LU52 | raw UI query không vượt capability/schema |
| LU53 | query quá budget trả continuation/diagnostic, không bỏ knowledge filter |
| LU54 | EXACT_REVISION query không đọc record revision khác |
| LU55 | stale/summary projection mang freshness/representation |
| LU56 | planner/index stats khác không đổi semantic output/order |
| LU57 | index READY chỉ khi coverage khớp revision yêu cầu |

## 70. Điều kiện LU58–LU76 — recovery, maintenance và lựa chọn engine

| ID | Điều kiện chưa chạy |
|---|---|
| LU58 | rebuild index snapshot+delta cho cùng entries/counts |
| LU59 | crash rebuild giữ index generation cũ hoặc trạng thái rõ |
| LU60 | cache policy mobile/desktop khác không đổi hash |
| LU61 | storage adapter công bố capability thật, không giả fsync/atomic replace |
| LU62 | thiếu dung lượng không xóa generation hợp lệ cũ |
| LU63 | compression khác giữ cùng logical uncompressed hash |
| LU64 | checksum mismatch dừng trước publish/load READY |
| LU65 | index corruption được rebuild, canonical corruption không được bịa sửa |
| LU66 | compaction giữ cùng logical root hash |
| LU67 | GC không xóa blob reachable từ retained root/export/evidence |
| LU68 | compact giữ anchor/tombstone/reverse refs theo retention |
| LU69 | maintenance scheduling không đi vào gameplay RNG/time |
| LU70 | migration source read-only và target staging trước publish |
| LU71 | engine migration và domain migration có version/provenance riêng |
| LU72 | import staging không ghi đè slot sống trước validate |
| LU73 | sync truyền portable generation, không live engine pages |
| LU74 | storage benchmark dùng cùng AP01–AP12/fault workload |
| LU75 | correctness/recovery/portability disqualifier thắng điểm hiệu năng |
| LU76 | ADR engine/format không ACCEPTED khi crash/parity/migration còn NOT_RUN |

## 71. Truy vết và tổng điều kiện

| Nhóm LU | Nguồn |
|---|---|
| LU01–LU19 | K2 transaction/save, K3 single writer và shards |
| LU20–LU38 | K3.4 frontier/flow/capsule, mobile lifecycle |
| LU39–LU57 | View/Query/Cognitive boundary và performance |
| LU58–LU76 | LP recovery/migration, HN benchmark, K3.2 ADR |

76 LU nâng tổng từ 948 lên **1.024 điều kiện thiết kế chưa chạy**, thuộc 32 họ.

## 72. Topology logic tương lai

```text
storage-api/
  records/
  transactions/
  snapshots/
  queries/
  indices/
  maintenance/
storage-adapters/
  candidate-f/
  candidate-r/
  candidate-k/
portable-save/
  manifests/
  chunks/
  migrations/
storage-evidence/
  crashes/
  corruption/
  access-patterns/
  parity/
```

Đây là topology khái niệm, chưa tạo code hoặc chọn engine.

## 73. Thứ tự hiện thực hóa khi được phép

1. in-memory canonical RecordStore + revision/commit;
2. portable canonical codec/chunk/root manifest;
3. journal/publish/recovery W0;
4. id/frontier correctness indices;
5. query/projection pagination;
6. PersonCore/capsule/flow partitions;
7. storage candidate adapters cùng conformance suite;
8. kill/corruption/migration tests;
9. W1 save/load/growth;
10. 100.000 Person storage spike;
11. mobile/desktop parity;
12. ADR rồi mới tối ưu engine-specific.

## 74. Điều không được tuyên bố

- Không nói đã chọn database/file format.
- Không nói 100.000 Person truy vấn nhanh.
- Không nói copy live store là portable save.
- Không nói checksum bảo đảm đúng gameplay.
- Không nói async index có thể dùng làm quyền giao dịch.
- Không nói compaction/migration an toàn trước fault tests.
- Không nói 1.024 điều kiện đã chạy.

## 75. Giá trị K3.5 cung cấp thật

- tách nguồn thật, save portable và dữ liệu dẫn xuất;
- access patterns làm chuẩn đánh giá;
- partition/routing/transaction xuyên shard rõ;
- frontier và flow không bị lazy load làm mất;
- index/query có capability và freshness;
- mobile durability/space/compaction có ranh giới;
- recovery/migration/backup/sync không phụ thuộc engine;
- spike và disqualifier để chọn storage có bằng chứng.

## 76. Bước tiếp theo

K3 đã đóng gói; K4.1–K4.3 đã lập nền hiện tượng, cơ thể và vật phẩm. K4.4 nay đã lập môi trường tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
