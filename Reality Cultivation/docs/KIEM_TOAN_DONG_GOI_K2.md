---
title: Kiểm toán và đóng gói K2.1–K2.7
aliases:
  - K2.8
  - Kiểm toán K2
tags:
  - reality-cultivation
  - kiem-toan
  - k2
  - dong-goi
status: de-xuat
updated: 2026-09-06
---

# Kiểm toán và đóng gói K2.1–K2.7 — K2.8

Tài liệu này kiểm toán bảy đặc tả K2 từ dữ liệu tới hiệu năng. Nó kế thừa cách phân biệt “đạt trên giấy” và “đã chạy” của [[KIEM_TOAN_DONG_GOI_K1]].

Kết luận ngắn: **K2.1–K2.7 khép kín về ranh giới hợp đồng trên giấy và đủ để chuyển sang thiết kế kiến trúc triển khai; chưa có dữ liệu máy, runner, oracle, save hoạt động, parity hay benchmark để gọi là đã triển khai hoặc đã kiểm thử.**

K2.8 không thêm điều kiện kiểm thử mới. Tổng vẫn là **684 điều kiện thiết kế chưa chạy**.

## 1. Phạm vi kiểm toán

Kiểm toán bao phủ:

- hiện diện và liên kết của bảy tài liệu K2;
- phép cộng điều kiện và tính duy nhất theo họ;
- thứ tự phụ thuộc giữa schema, scheduler, mutation, cognition, save, validation và performance;
- ranh giới giữa Fact/Belief, title/possession, plan/commit và state/cache;
- atomicity, idempotency, replay và parity đa nền tảng;
- R0–R4 cùng quy tắc không giảm logic theo thiết bị;
- trạng thái các cổng sẵn sàng;
- vấn đề mở phải mang sang giai đoạn sau.

Không kiểm toán code, runtime, package cài đặt hay thiết bị thật vì chúng chưa tồn tại.

## 2. Bản kê gói K2

| Gói | Tài liệu | Dòng/H2 tại lần kiểm | Điều kiện | Vai trò |
|---|---|---:|---:|---|
| K2.1 | [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]] | 647/32 | HD01–HD32 = 32 | kiểu, record, version, hash |
| K2.2 | [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]] | 574/37 | LS01–LS36 = 36 | thời gian, pha, event, process |
| K2.3 | [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]] | 604/41 | GV01–GV40 = 40 | quyền, transaction, bảo toàn |
| K2.4 | [[HOP_DONG_NHAN_THUC_QUYET_DINH_TAC_NHAN_K2]] | 621/43 | NT01–NT44 = 44 | tri thức, mục tiêu, quyết định, NPC |
| K2.5 | [[HOP_DONG_LUU_TAI_MIGRATION_PHUC_HOI_K2]] | 709/47 | LP01–LP48 = 48 | snapshot, journal, migration, recovery |
| K2.6 | [[KE_HOACH_VALIDATOR_ORACLE_K2]] | 860/55 | VO01–VO52 = 52 | catalog, runner, oracle, evidence |
| K2.7 | [[NGAN_SACH_HIEU_NANG_QUY_MO_K2]] | 807/56 | HN01–HN56 = 56 | workload, ngân sách, benchmark |
| **Tổng K2** | 7 tài liệu | **4.822 dòng** | **308** | tất cả chưa chạy |

Tổng trước K2 là 376. Vì vậy toàn sổ hiện tại: `376 + 308 = 684`.

## 3. Sổ 27 họ điều kiện

| Tầng | Họ và số lượng | Tổng |
|---|---|---:|
| DL01–DL06 | SK12, VT14, CB14, CV16, LT16, GT16 | 88 |
| K0 | DS16, LK16, CS18 | 50 |
| K1 | LC18, QD20, SS16, NX18, DT22, HS20, VH22, ST24, NL24, TL26, DV28 | 238 |
| K2 | HD32, LS36, GV40, NT44, LP48, VO52, HN56 | 308 |
| **Tổng** | **27 họ** | **684** |

BT01–BT12, K1G01–K1G12 và K2G ở tài liệu này là gate tổng hợp, không cộng vào 684.

## 4. Trạng thái thật của 684 điều kiện

| Trạng thái | Số lượng |
|---|---:|
| đã định nghĩa trong Markdown | 684 |
| đã có ConditionSpec máy | 0 |
| đã có implementation test | 0 |
| đã chạy với RunFingerprint | 0 |
| PASS có EvidenceBundle | 0 |
| FAIL có FailureArtifact | 0 |

Các phép tính tay, kiểm liên kết và rà logic trong K1/K2 không thay `NOT_RUN`. Một số mệnh đề đã “khép trên giấy” chỉ nói không thấy mâu thuẫn trong đặc tả hiện tại.

## 5. Thứ tự phụ thuộc chuẩn

```text
K0/K1 fixtures và yêu cầu
  -> K2.1 schema/state contracts
  -> K2.2 scheduler/time/phase
  -> K2.3 rights/transaction/conservation
  -> K2.4 cognition/decision/agent
  -> K2.5 save/migration/recovery
  -> K2.6 validator/oracle/evidence
  -> K2.7 workload/performance/capacity
```

K2.2–K2.4 có liên kết ngang nhưng không tạo vòng nghĩa:

- scheduler gọi handler theo pha;
- transaction engine cam kết mutation;
- cognition đọc post-state qua CognitiveView rồi đề nghị Action;
- Action tương lai quay lại scheduler, không sửa pha cũ.

## 6. Chuỗi khép kín từ lệnh tới hậu quả

1. UI tạo `Command` có idempotency key.
2. Scheduler nhận ở boundary và pha 80.
3. Command tạo/sửa Goal theo policy.
4. DecisionFrame đọc CognitiveView, không đọc Fact bí mật.
5. Option được chọn tạo Plan/Action/Dialogue/Reservation request.
6. Scheduler kiểm thời điểm/pha và tranh nguồn.
7. Transaction/Action kiểm state thật, quyền, Position và capability.
8. Mutation group cam kết nguyên tử ở pha phù hợp.
9. FactEvent ghi hậu quả khách quan.
10. Pha 70 tạo tín hiệu/Observation/Message cho đúng người.
11. Belief/Memory/Appraisal/Goal được cập nhật có nguồn.
12. Snapshot/journal giữ boundary, idempotency và RNG.
13. Oracle có thể đối chiếu trace/state mà không can thiệp.

Không thấy đường tắt hợp đồng nào cho `RenderedText -> Fact`, `Belief -> quantity`, `Ledger -> asset`, `UI -> RNG` hoặc `performance -> dropped event`.

## 7. Chủ quản dữ liệu

| Dữ liệu | Chủ quản thật | View/record dẫn xuất |
|---|---|---|
| thời gian, queue, event status | scheduler | lịch hiển thị, metric |
| Person/Body/Position | world/domain stores | capability/view |
| Item/Lot/ResourcePool | vật chất/transaction | inventory projection |
| title/right/contract/obligation | transaction/institution stores | ledger/receipt/view |
| FactEvent | event history bất biến | Episode/Summary |
| Observation/Message/Belief | cognition theo holder | player/NPC view |
| Goal/Decision/Plan | agent | explanation/view |
| RNG cursor/draw | RNG registry | diagnostic |
| snapshot/journal/checkpoint | save subsystem | slot preview |
| cache/index/metric | hạ tầng dẫn xuất | không là source gameplay |

Không có hai chủ quản cho cùng lượng, cùng quyền hoặc cùng quyết định.

## 8. Kiểm toán kiểu, id và revision

K2.1 đã khóa:

- id có miền và không tái cấp;
- record envelope/version/revision;
- Option/unknown/null tách nghĩa;
- đơn vị nguyên/fixed-point/remainder;
- reference closure;
- canonical serialization/hash;
- UnsupportedGuard.

K2.2–K2.7 đều tham chiếu các nguyên tắc này. Chưa có schema máy để xác minh khóa ngoại, enum, unit hoặc serializer thực tế.

## 9. Kiểm toán thời gian và tám pha

K2.2 giữ một thứ tự 10–80, wave nhân quả và boundary. K2.3 commit ở pha mutation; K2.4 perception/decision ở 70/80; K2.5 chỉ công bố snapshot boundary mặc định; K2.6 oracle so theo phase; K2.7 yield không đổi order.

Các trường hợp đã được ràng:

- event chen vào pha đã đóng bị từ chối;
- cùng `due_ms` không phân thắng bằng id;
- process tích phân tới boundary và giữ remainder;
- pause đợi atomic group;
- save/crash replay entry committed;
- WorkSlice khác nhau giữ cùng logic.

Chưa có runner để chứng minh causal loop guard, recurrence hoặc process integration.

## 10. Kiểm toán giao dịch và bảo toàn

K2.3 tách vật lý, cho phép vận hành và hợp lệ chuẩn tắc. Điều này nhất quán với K2.4: NPC có thể cân nhắc hành vi trái quyền nhưng Transaction/Action xử state thật và hậu quả.

Chuỗi bảo toàn có:

- AssetRef/QuantitySpec;
- title/custody/possession/Position;
- Reservation và available projection;
- TransactionPlan/revision/idempotency;
- split/merge/container/component;
- Source/Sink/Transformation/ConservationEquation;
- obligation/debt/compensation;
- save/replay/migration digest;
- conservation oracle và benchmark cost.

Chưa chốt luật sở hữu rộng, tiền tín dụng, thuế, thị trường hay thuật toán khóa. Chúng không chặn lát cắt V01/V02 hiện tại nếu giữ fixture policy.

## 11. Kiểm toán nhận thức và NPC

K2.4 giữ đường ống:

`Signal -> Observation -> Message/Comprehension -> Evidence -> Belief/Memory -> Appraisal -> Goal -> Decision -> request`.

Các ranh giới khớp với K1:

- Fact không tự truyền;
- người nghe thực khác người dự định nghe;
- danh tính mô tả khác id thật;
- nguồn chung không nhân bằng chứng;
- Belief mâu thuẫn có thể cùng tồn tại;
- option cần nguồn biết cách;
- Affect không tự tạo Action;
- lời/DecisionTrace không viết lại theo hậu quả;
- NPC xa vẫn là Person riêng.

Chưa chốt công thức confidence/score, quên/chú ý, thần thức hoặc policy P00. K2.4 cho phép mã hóa chúng thành policy/feature guard thay vì hard-code.

## 12. Kiểm toán save, replay và migration

K2.5 nối đầy đủ state sống của K2.1–K2.4:

- world lineage/branch/generation;
- snapshot/journal/checkpoint;
- scheduler/process/recurrence;
- transaction/reservation/idempotency;
- observation/message/appraisal/decision;
- RNG/version/policy;
- R-level/summary provenance;
- crash/lifecycle/offline;
- migration/corruption/repair;
- sync divergence.

Không thấy trường hợp được phép tự “sửa hợp lý” bằng tạo vật, hồi sinh, xóa event hoặc gộp hai nhánh. Snapshot giữa pha vẫn UNSUPPORTED nếu chưa lưu frontier/mutation staging đầy đủ; boundary save là đường mặc định nhất quán.

## 13. Kiểm toán validator và oracle

K2.6 đã tách:

- ConditionSpec/FixtureSpec/RunSpec;
- Validator/Monitor/Oracle/Gate;
- fingerprint và trạng thái kết quả;
- transition/scenario/domain/metamorphic/replay/parity;
- negative/fault/generator/shrink;
- evidence/failure/golden/coverage/dependency;
- tầng V0–V5.

Điểm quan trọng đã giữ: oracle nhận thức không ép Belief bằng Fact; oracle giao dịch không tin receipt thay state; performance không chạy trước correctness. Catalog máy, runner và oracle implementation đều chưa tồn tại.

## 14. Kiểm toán hiệu năng và quy mô

K2.7 giữ:

- target 17.280 game-ms/real-ms;
- W0–W4 với shape workload;
- DeviceProfile/calibration;
- W1 là mục tiêu ban đầu mobile/desktop;
- p50/p95/p99, UI/pause/save latency;
- memory/storage/energy/thermal;
- cost theo domain;
- R0–R4/ErrorBudget;
- CapacityEnvelope/backpressure/STOPPED_SAFE;
- benchmark/evidence/regression.

Không có số đo thực. Ngưỡng W1 là đề xuất kỹ thuật revision đầu; W2–W4 chưa là lời hứa. Điều này nhất quán với yêu cầu đa nền tảng nhưng chưa chứng minh thiết bị nào được hỗ trợ.

## 15. Kiểm toán R0–R4

K1.5, K2.2, K2.4 và K2.7 đều thống nhất:

- mỗi NPC đã tồn tại giữ Person riêng;
- hạ mức không xóa danh tính, tài sản, nghĩa vụ hoặc lịch sử cần thiết;
- promotion xảy ra trước tương tác/biến cố chi tiết;
- interval bị cắt ở threshold/deadline/message/di chuyển;
- error budget bằng 0 cho vật chất và biến cố bắt buộc;
- thiết bị chậm không tự đổi ResolutionPlan;
- handler chưa có parity/oracle evidence là UNSUPPORTED.

Chưa có thuật toán tổng hợp/materialize hoặc fixture W2–W4, nên R0–R4 mới là interface, chưa là tối ưu hoạt động.

## 16. Kiểm toán điện thoại và máy tính

Yêu cầu U011 đã được đưa xuyên gói:

- cùng Command/payload và state logic;
- fixed-point, canonical hash và RNG parity;
- WorkSlice/yield giữ UI phản hồi;
- bố cục khác không đổi thông tin/chức năng;
- lifecycle save và crash recovery;
- DeviceProfile/budget riêng;
- sync là tính năng tùy chọn, divergence không auto-merge.

Chưa có UI, build hay thiết bị. Vì vậy chỉ đạt nguyên tắc thiết kế, chưa đạt hỗ trợ đa nền tảng thực tế.

## 17. Kiểm toán lựa chọn TN01–TN08

Không tài liệu K2 nào coi từ “tiếp” là xác nhận. Các điểm còn mở được giữ:

| TN | Ảnh hưởng K2 |
|---|---|
| TN01 pause/auto-pause | PausePolicy, benchmark exclusion, UI |
| TN02 chạy khi đóng | OFFLINE_STOP/CATCHUP |
| TN03 tự chủ P00 | PLAYER_DIRECT/CHARACTER/HYBRID |
| TN04 tầm nhìn | ViewProjection/debug separation |
| TN05 tải lại/chết | slot/branch/technical recovery |
| TN06 tự động sinh hoạt/cam kết | Goal/Contract policy |
| TN07 phạm vi An Khê | W1/fixture/content scope |
| TN08 khởi đầu/cảnh giới | content/feature guard |

Fixture defaults có nhãn `UNCONFIRMED_FIXTURE_DEFAULT`, không phải quyết định người dùng.

## 18. Kiểm toán base và overlay

K2.1 yêu cầu base hash/revision; K2.6 FixtureSpec yêu cầu overlay scope/conflict; K2.5 save giữ fixture/overlay version.

Ranh giới giữ được:

- INIT không bị sửa bởi nhánh thử;
- biến thể không đồng thời được coi là một lịch sử;
- overlay sai base bị từ chối;
- PASS chỉ gắn đúng variant/fingerprint;
- load/migration không tự kích hoạt content/overlay mới.

Chưa có patch schema máy hoặc overlay validator implementation.

## 19. Kiểm toán bất biến không can thiệp

Các tác vụ sau được yêu cầu không đổi logic:

- mở UI/view/save menu;
- bật/tắt metric/profiler/diagnostic;
- chạy validator/oracle;
- serialize/compact cache;
- chia WorkSlice;
- đổi số worker;
- save/load boundary;
- đổi bố cục/ngôn ngữ hiển thị.

Mỗi mục đã có điều kiện HD/LS/GV/NT/LP/VO/HN tương ứng. Chưa có metamorphic run để chứng minh.

## 20. Ma trận sẵn sàng theo thành phần

| Thành phần | Hợp đồng | Fixture giấy | Schema máy | Runner/evidence | Trạng thái |
|---|---|---|---|---|---|
| kiểu/id/unit/version | đủ chung | có ví dụ | chưa | chưa | sẵn sàng mã hóa |
| scheduler/process | đủ interface | A–E/30 ngày | chưa | chưa | sẵn sàng mã hóa lõi |
| transaction/conservation | đủ lát cắt | V01/V02/nước/J01 | chưa | chưa | sẵn sàng mã hóa lõi |
| cognition/decision | đủ pipeline | 21 người/8 traces | chưa | chưa | cần policy số cho hành vi rộng |
| save/migration | đủ lifecycle | walkthrough/fault points | chưa | chưa | sẵn sàng kiến trúc |
| validator/oracle | đủ contract | mẫu DS05/NT13/LP17 | chưa | chưa | sẵn sàng thiết kế module |
| performance | đủ measurement | W0–W4 shape | chưa | chưa | cần thiết bị/benchmark |
| body sâu | điểm nối | CB/CS/W-E | chưa đủ sâu | chưa | mở rộng theo chặng |
| tu luyện sâu | điểm nối | LT/INIT-D | chưa đủ sâu | chưa | mở rộng theo chặng |
| chiến đấu sâu | điểm nối | GT/INIT-E | chưa đủ; E-BOTH thiếu | chưa | blocker cho oracle E-BOTH |
| sinh thái/thế giới lớn | điểm nối | chưa có W2–W4 thật | chưa | chưa | chưa sẵn sàng nội dung lớn |

## 21. Vấn đề mở ưu tiên cao

| ID | Vấn đề | Ảnh hưởng | Cách đóng |
|---|---|---|---|
| OPEN-K2-01 | TN01–TN08 chưa xác nhận | policy/UX/fixture branch | giữ variant; hỏi khi cần chốt trải nghiệm |
| OPEN-K2-02 | chưa có catalog máy 684 ConditionSpec | không tự chạy | triển khai catalog loader sau khi được yêu cầu code |
| OPEN-K2-03 | chưa có schema/record store máy | không validate/ref/hash | K3 kiến trúc + implementation |
| OPEN-K2-04 | chưa có deterministic scheduler | không chạy 5 giây/ngày | implementation theo K2.2 |
| OPEN-K2-05 | chưa có transaction/conservation engine | chưa chứng minh vật chất | implementation theo K2.3 |
| OPEN-K2-06 | chưa chốt Belief/Decision policy số | NPC rộng chưa định lượng | fixture/calibration riêng, không chặn pipeline |
| OPEN-K2-07 | snapshot giữa pha chưa hỗ trợ | crash quay boundary | giữ boundary+journal hoặc thiết kế frontier sâu |
| OPEN-K2-08 | chưa chốt OFFLINE_STOP/CATCHUP | hành vi đóng app | phụ thuộc TN02 |
| OPEN-K2-09 | FX-E-BOTH thiếu oracle số | một nhánh chiến đấu BLOCKED_SPEC | hoàn thiện lát cắt combat trước test đó |
| OPEN-K2-10 | chưa có W2–W4 generator/handler | không chứng minh quy mô | làm sau W1 correctness |
| OPEN-K2-11 | chưa có thiết bị chuẩn/số đo | W1 budget chưa xác minh | benchmark matrix sau build |
| OPEN-K2-12 | chưa chọn công nghệ đa nền tảng | chưa có kiến trúc mã | K3.1 lập tiêu chí/quyết định có bằng chứng |

## 22. Vấn đề mở ưu tiên vừa

| ID | Vấn đề | Ranh giới |
|---|---|---|
| OPEN-K2-13 | luật sở hữu/thị trường thế giới rộng | không chặn fixture An Khê hiện tại |
| OPEN-K2-14 | công thức quên/chú ý/uy tín | policy version, chưa giả là tâm lý chung |
| OPEN-K2-15 | thần thức/tu luyện nhận thức | feature guard UNSUPPORTED |
| OPEN-K2-16 | schema sâu cơ thể/sinh thái/tu luyện/combat | điểm nối có, nội dung sâu làm theo chặng |
| OPEN-K2-17 | autosave/retention/hash/nén/mã hóa | K2.5 chỉ khóa nghĩa logic |
| OPEN-K2-18 | cloud sync | không suy ra từ U011 |
| OPEN-K2-19 | hard capacity phát hành | chỉ công bố sau PerformanceEvidenceBundle |
| OPEN-K2-20 | vòng đời thế giới hàng thế hệ có dữ liệu rộng | K1.5/K2 interface có, chưa có generator |

## 23. Rủi ro kiến trúc lớn nhất

1. **State kép:** cùng lượng/quyền/niềm tin được lưu ở hai subsystem và lệch nhau.
2. **Thứ tự ẩn:** collection/thread order quyết định kết quả cùng mốc.
3. **Truth leak:** NPC planner đọc world state bí mật để “thông minh”.
4. **Atomicity leak:** UI/save/crash thấy nửa giao dịch.
5. **Replay leak:** load phát lại Message/RNG/update.
6. **Fidelity leak:** thiết bị chậm âm thầm đổi R-level/kết quả.
7. **Oracle cùng sai:** expected dùng lại cùng implementation.
8. **Data explosion:** lưu mọi tick/quan hệ N² thay vì event/graph thưa/tóm lược có nguồn.
9. **UI coupling:** mở trang làm query thay state hoặc tiêu RNG.
10. **Premature scale:** tối ưu W4 khi W1 atomicity/correctness chưa chạy.

K3 phải dùng các rủi ro này làm tiêu chí loại kiến trúc, không chỉ so tốc độ phát triển.

## 24. Cổng kiểm toán K2G01–K2G20

Các cổng này không cộng vào 684 điều kiện.

| Gate | Điều kiện | Kết quả hiện tại |
|---|---|---|
| K2G01 | đủ bảy tài liệu K2.1–K2.7 | Đạt |
| K2G02 | wiki links phân giải | Đạt |
| K2G03 | phép cộng 376 + 308 = 684 | Đạt |
| K2G04 | 27 họ/id có số lượng đúng | Đạt qua kiểm kê văn bản |
| K2G05 | thứ tự phụ thuộc không có vòng mutation | Đạt trên giấy |
| K2G06 | state/type/revision/source owner rõ | Đạt trên giấy, schema máy chưa có |
| K2G07 | tám pha/boundary/remainder khép | Đạt hợp đồng |
| K2G08 | transaction/right/conservation khép | Đạt lát cắt trên giấy |
| K2G09 | cognition không đọc Fact toàn tri | Đạt hợp đồng |
| K2G10 | save/crash/migration không replay/bịa state | Đạt hợp đồng |
| K2G11 | validator/oracle/evidence semantics rõ | Đạt đặc tả |
| K2G12 | performance không giảm correctness | Đạt nguyên tắc/ngân sách |
| K2G13 | mobile/desktop logic parity có ranh giới | Đạt nguyên tắc |
| K2G14 | TN01–TN08 không bị tự xác nhận | Đạt |
| K2G15 | catalog/schema máy tồn tại | Chưa đạt |
| K2G16 | deterministic runner/oracles chạy được | Chưa đạt |
| K2G17 | 684 conditions có EvidenceBundle | Chưa chạy |
| K2G18 | save/replay/parity có bằng chứng | Chưa chạy |
| K2G19 | W1 đạt ngân sách trên device profiles | Chưa benchmark |
| K2G20 | W2–W4/R0–R4 có capacity evidence | Chưa có fixture/benchmark |

K2 kết thúc ở mức thiết kế với K2G01–K2G14 đạt hoặc đạt trên giấy; K2G15–K2G20 thuộc implementation/evidence sau khi người dùng yêu cầu.

## 25. Định nghĩa “sẵn sàng thiết kế kiến trúc”

Gói được xem là sẵn sàng bước K3.1 vì:

- trách nhiệm dữ liệu và mutation có ranh giới;
- order/boundary/replay constraints rõ;
- module cần hỗ trợ có thể suy ra;
- workload và evidence contract đã có;
- vấn đề trải nghiệm mở được tách thành policy;
- công nghệ có thể được đánh giá bằng tiêu chí cụ thể.

Điều này không đồng nghĩa sẵn sàng viết toàn game. K3.1 cần thiết kế kiến trúc/module và tiêu chí chọn công nghệ trước; việc code vẫn cần yêu cầu rõ của người dùng.

## 26. Các ràng buộc kiến trúc bắt buộc mang sang K3

1. Core logic xác định, số nguyên/fixed-point và RNG có stream.
2. Typed ids, revisioned records và một nguồn thật.
3. Scheduler tám pha với boundary và causal trace.
4. Mutation/transaction nguyên tử, idempotent.
5. CognitiveView tách khỏi omniscient audit.
6. UI gửi Command có cấu trúc và chỉ đọc ViewProjection.
7. Save portable giữ versions/hash/queue/RNG/provenance.
8. Runtime có thể yield mà không đổi event order.
9. R0–R4 handler phải có parity/error-budget evidence.
10. Validator/oracle được chạy ngoài mutation path.
11. Cache/index/metrics không là source gameplay.
12. Mobile lifecycle có checkpoint/recovery path.

Kiến trúc không đáp ứng một mục phải nêu tradeoff và cách chứng minh, không được bỏ âm thầm.

## 27. Module logic tối thiểu suy ra từ hợp đồng

Tên dưới đây là trách nhiệm, chưa là thư mục/code package:

- `world-model` — records, ids, units, revisions;
- `scheduler` — queue, phase, process, recurrence;
- `mutation-transaction` — validation/commit/conservation;
- `agent-cognition` — signal, belief, goal, decision;
- `domain-body/item/cultivation/combat/economy` — handlers;
- `save-migration` — snapshot/journal/recovery;
- `view-command` — projection/input boundary;
- `content-fixture` — definitions/base/overlay;
- `validation-oracle` — catalog/runner/evidence;
- `performance-observability` — metric/profile không can thiệp;
- `platform-shell` — lifecycle/storage/input/render cho mobile/desktop.

K3.1 phải quyết định dependency direction để platform/UI không điều khiển core state trực tiếp.

## 28. Gói bàn giao đề xuất

```text
specs/
  contracts/       K2.1–K2.5
  verification/    K2.6
  performance/     K2.7
  audits/          K1.12, K2.8
future-machine/
  schemas/
  condition-catalog/
  fixtures/
  policies/
  migrations/
  oracles/
future-evidence/
  runs/
  failures/
  parity/
  benchmarks/
```

Đây là topology khái niệm. Vault hiện vẫn là nguồn tài liệu duy nhất; không tạo bản sao hồ sơ ở gốc. Tên thư mục triển khai chỉ được tạo khi bắt đầu code/data máy.

## 29. Thứ tự hiện thực hóa có thể review

Sau khi người dùng yêu cầu triển khai:

1. skeleton kiến trúc + typed core records;
2. catalog/static validators cho id/ref/unit/version;
3. scheduler boundary và deterministic transition runner;
4. transaction/conservation nhỏ;
5. save/replay tối thiểu;
6. fixture W0 rồi W1-A-BOOT;
7. agent CognitiveView/Goal/Decision tối thiểu;
8. oracle/evidence cho chuỗi nhỏ;
9. mở lần lượt body/sinh kế/tu luyện/combat;
10. UI mobile/desktop trên cùng Command/ViewProjection;
11. W1 30 ngày, crash/parity;
12. benchmark rồi mới W2–W4.

Mỗi bước có diff/artifact/run riêng; không cần chờ toàn thế giới được định lượng để bắt đầu nền khi đã được yêu cầu.

## 30. Điều không được tuyên bố sau K2

- Không nói 684 điều kiện đã test.
- Không nói game đã chạy 5 giây/ngày.
- Không nói hỗ trợ điện thoại/máy tính đã hoàn thành.
- Không nói có 100.000 NPC đang sống.
- Không nói save chống hỏng đã hoạt động.
- Không nói NPC hiện đã suy nghĩ như người thật.
- Không nói R0–R4 giữ parity đã được chứng minh.
- Không nói W1 budget đạt.
- Không nói TN01–TN08 đã được chọn.
- Không nói đã chọn ngôn ngữ/framework/database.

## 31. Những gì K2 đã cung cấp thật

- một ngôn ngữ dữ liệu chung để tránh state mơ hồ;
- một trật tự thời gian/mutation rõ;
- mô hình giao dịch/quyền/bảo toàn đủ lát cắt;
- ranh giới nhận thức giúp NPC không toàn tri;
- hợp đồng lưu/phục hồi không nhân hiệu ứng;
- định nghĩa thế nào là bằng chứng kiểm thử;
- ngân sách đo hiệu năng và quy mô trung thực;
- danh sách blocker có phạm vi;
- tiêu chí loại kiến trúc không phù hợp.

Đây là giá trị thiết kế và kiểm toán, chưa là sản phẩm chạy được.

## 32. Việc người dùng chưa cần quyết ngay

Chưa cần chọn từng enum, hash, queue, database, hệ số confidence, chunk size hay số worker. K3 có thể tiếp tục so kiến trúc theo các ràng buộc đã có.

Khi một lựa chọn TN thật sự làm hai hướng kiến trúc khác hẳn, tài liệu phải chỉ ra điểm quyết định cụ thể. Không dừng toàn bộ thiết kế chỉ vì mọi TN chưa được trả lời.

## 33. Bước tiếp theo

K3.1 nay đã được cụ thể hóa tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
