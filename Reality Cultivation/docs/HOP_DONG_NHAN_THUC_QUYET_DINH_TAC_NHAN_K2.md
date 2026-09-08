---
title: Hợp đồng nhận thức, quyết định và tác nhân NPC — K2.4
aliases:
  - K2.4
  - Nhận thức và tác nhân NPC
tags:
  - reality-cultivation
  - thiet-ke
  - nhan-thuc
  - quyet-dinh
  - npc
status: de-xuat
updated: 2026-09-06
---

# Hợp đồng nhận thức, quyết định và tác nhân NPC — K2.4

Tài liệu này cụ thể hóa Proposition/Observation/Message/Belief/Memory/Inference/Goal/Decision/Dialogue của [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]]. Nó nối pha 70–80 của [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]], quyền và giao dịch của [[HOP_DONG_GIAO_DICH_QUYEN_BAO_TOAN_K2]], nền đời sống [[NPC]], nguồn quyết định [[NGUON_QUYET_DINH_K1]], tâm lý [[TAM_LY_21_NGUOI_K1]] và dấu vết hội thoại [[DAU_VET_QUYET_DINH_HOI_THOAI_K1]].

Đây là hợp đồng thiết kế chưa triển khai. Nó không tuyên bố mô phỏng đầy đủ tâm trí thật và không chốt TN01–TN08, quyền tự chủ P00, công thức tâm lý, thuật toán AI hay mô hình ngôn ngữ.

## 1. Tám bất biến của tác nhân

1. Sự thật thế giới không tự trở thành tri thức của NPC.
2. Tín hiệu, quan sát, cách hiểu, niềm tin và hành động là các record khác nhau.
3. Mọi Belief/Memory/Inference đều có chuỗi nguồn; `confidence` không phải cờ sự thật.
4. NPC chỉ cân nhắc phương án họ biết hoặc có thể tự cấu tạo bằng quy tắc đã học.
5. Quyết định đọc một snapshot đóng; hậu quả tương lai không được viết ngược vào lý do cũ.
6. Cảm xúc làm thay đổi đánh giá và độ nổi bật, không trực tiếp ra lệnh Action.
7. NPC xa vẫn giữ danh tính, cam kết, mục tiêu và lịch sử cần thiết.
8. Cùng state, input, policy và RNG phải cho cùng kết quả logic trên điện thoại và máy tính.

## 2. Đường ống nhận thức–hành động

```text
FactEvent/State
  -> PerceivableSignal
  -> ObservationCandidate
  -> Observation
  -> Interpretation/MessageComprehension
  -> EvidenceLink
  -> BeliefRevision + MemoryEncoding
  -> Appraisal/Affect update
  -> Goal activation
  -> DecisionFrame
  -> DecisionOption -> selected option
  -> Plan/DialogueIntent/Action/Reservation
  -> Event/Transaction result
  -> Observation mới và học từ sai lệch kỳ vọng
```

Mỗi mũi tên có thể thất bại hoặc chỉ tạo kết quả một phần. Không có đường tắt `FactEvent -> Belief` cho NPC thường, `Biography -> Action`, `Affect -> Action` hoặc `RenderedText -> Contract`.

## 3. Proposition là nội dung, không là niềm tin

| Trường | Ý nghĩa |
|---|---|
| `proposition_id` | mã nội dung bất biến |
| `subject_ref` | đối tượng được nói tới hoặc mô tả chưa nhận diện |
| `predicate_code/version` | quan hệ/thuộc tính có schema |
| `object_or_value` | ref, enum hoặc lượng có đơn vị |
| `valid_time` | instant/interval mà nội dung nói tới |
| `spatial_scope` | nơi áp dụng nếu cần |
| `modality` | ASSERTED/POSSIBLE/EXPECTED/OBLIGATORY/COUNTERFACTUAL |
| `qualifiers` | điều kiện, lượng hóa, phủ định, phạm vi |

Hai câu diễn đạt khác nhau có thể trỏ cùng Proposition. “Tôi thấy kho có 20 suất hôm qua” không được rút thành “kho hiện có 20 suất”: thời điểm và nguồn là phần bắt buộc.

Proposition chứa một danh tính mô tả như `UNKNOWN-GRAY-ROBE-01` cho tới khi có bằng chứng nối danh tính. Mã Person bí mật của engine không được lộ qua nội dung chủ quan.

## 4. Fact, Evidence và quyền truy cập

`FactEvent` là lịch sử khách quan của mô phỏng. `EvidenceLink` nói một chủ thể có bằng chứng gì, bằng cách nào và bằng chứng hỗ trợ/phản bác Proposition nào.

| Trường EvidenceLink | Ý nghĩa |
|---|---|
| `holder_id` | người có thể sử dụng bằng chứng |
| `evidence_ref` | Observation/Message/Memory/RecordAccess/Inference |
| `relation` | SUPPORTS/CONTRADICTS/CONTEXT_ONLY |
| `independence_group` | nguồn gốc chung để chống đếm lặp |
| `reliability_basis` | căn cứ chủ thể biết, không phải độ đúng toàn tri |
| `available_interval` | lúc bằng chứng còn truy hồi/được truy cập |

Engine/validator được đọc Fact để xử lý vật lý và kiểm toán. Bộ quyết định của NPC chỉ nhận `CognitiveView(actor, snapshot)`. Quyền đọc sổ thật tạo cơ hội thực hiện Reading/Inspection Action; nó không tự đổ toàn bộ nội dung vào đầu người có quyền.

## 5. PerceivableSignal và ObservationCandidate

Mọi quan sát bắt đầu từ tín hiệu vật lý hoặc kết quả thao tác kiểm tra:

- ánh sáng, hình dạng, chuyển động, âm thanh, mùi, nhiệt, đau/cảm giác cơ thể;
- chữ, dấu, trận văn hoặc dữ liệu trên vật mang;
- kết quả cân, đo, khám, mở vật chứa, truy vấn sổ;
- linh giác/thần thức chỉ khi hệ tu luyện định nghĩa kênh, tầm, nhiễu và phản tác dụng.

`ObservationCandidate` có observer, signal, interval chồng lấn, Position, khoảng cách, vật cản, sensory capability, focus allocation, signal-to-noise và privacy/access check. Candidate không phải Observation; nó có thể bị loại với mã lý do.

Không tạo candidate chỉ vì NPC nằm trong cùng Place cấp cao. Hai người ở D01 nhưng khác phòng, bị tường chắn hoặc không có mặt cùng lúc không tự nghe nhau.

## 6. Observation và nhận diện từng phần

`Observation` lưu raw feature đã lấy mẫu, kênh giác quan, độ rõ, khoảng quan sát, phần chú ý, đối tượng mô tả, proposition fragments được giải và uncertainty.

Một quan sát có thể xác nhận:

- “có người” nhưng chưa biết ai;
- “vật dài sáng” nhưng chưa biết là kiếm;
- “có tiếng va” nhưng chưa biết nguyên nhân;
- “máu ở cẳng tay” nhưng chưa biết mạch/tổn thương sâu;
- “tờ giấy có dấu O03” nhưng chưa đọc được nội dung.

Nhận diện về sau tạo `IdentityHypothesis` nối descriptor với một hay nhiều candidate identity và bằng chứng. Không sửa Observation cũ; chỉ thêm liên kết diễn giải mới.

## 7. Chú ý, tập trung và bỏ sót

`AttentionState` gồm focus targets, channel allocation, task demand, arousal/source, interruption threshold và switch cost. Tổng phân bổ mỗi kênh không vượt 1.000 milli.

- Làm việc tinh vi có thể giảm khả năng nghe lời nhỏ.
- Cảnh báo mạnh có thể chen qua nếu vượt ngưỡng, nhưng tạo gián đoạn thật cho Action.
- Pressure/Affect đổi độ nổi bật của tín hiệu liên quan; không làm NPC nhìn xuyên tường.
- Một tín hiệu không được xử lý không tạo ký ức “đã thấy nhưng quên”.

Khi nhiều tín hiệu cạnh tranh, policy chọn candidate phải dùng salience, nhiệm vụ hiện tại, nguy hiểm được nhận dạng và RNG có log nếu hòa thật; không dùng id nhỏ.

## 8. Message: ý định truyền khác kết quả nhận

`Message` giữ sender, intended recipients, actual receivers, payload propositions, expressed certainty, claimed source, privacy, medium, send/delivery time và provenance chain.

Đường truyền gồm:

1. `DialogueIntent` hoặc RecordTransfer định nội dung muốn truyền;
2. `UtteranceSignal/WrittenSignal` tồn tại vật lý;
3. người nhận có Observation hợp lệ;
4. `ComprehensionAttempt` dùng ngôn ngữ, khái niệm, chú ý và ngữ cảnh;
5. chỉ phần hiểu được trở thành Message payload ở phía người nhận.

Nghe được âm thanh không đồng nghĩa hiểu. Đọc được chữ không đồng nghĩa biết thuật ngữ. Message có thể tới muộn, thiếu đoạn, sai người hoặc không tới.

## 9. Lời kể, nguồn chung và chuỗi chuyển tiếp

Mười lời đồn cùng bắt nguồn từ N05 không là mười nguồn độc lập. `SourceLineage` giữ origin đã biết hoặc opaque origin, các relay, biến thể payload và chỗ chuỗi bị mất.

NPC chỉ dùng quan hệ nguồn mà họ có bằng chứng biết. Engine dùng `independence_group` để chống vòng lặp kỹ thuật và có thể đánh dấu `suspected_common_source`; nó không bí mật nói cho NPC rằng hai tin có cùng gốc.

Kể lại có thể:

- giữ nguyên, lược điều kiện hoặc đổi mức chắc;
- trộn suy luận của người kể với nội dung nghe được;
- cố ý bóp méo;
- nhớ sai do compression.

Mỗi biến thể tạo Proposition/Message mới và vẫn trỏ lineage; không ghi đè bản trước.

## 10. BeliefSet thay vì một ô đúng/sai

Một người có `BeliefSet` theo chủ đề, gồm nhiều `BeliefHypothesis`:

| Trường | Ý nghĩa |
|---|---|
| `holder_id/proposition_id` | người tin và nội dung |
| `stance` | ACCEPTS/REJECTS/UNRESOLVED |
| `confidence_milli` | 0–1.000 theo policy |
| `supporting/opposing_evidence` | bằng chứng hai phía |
| `independence_digest` | nhóm nguồn đã tính |
| `formed/last_reviewed` | mốc thời gian |
| `freshness_state` | CURRENT/AGING/STALE/UNKNOWN |
| `actionability` | DIRECT/CHECK_FIRST/DO_NOT_USE |
| `conflicts_with/supersedes` | liên kết, không xóa lịch sử |

Belief về quyền, vị trí, giá hoặc thương tích tách khỏi record khách quan tương ứng. Một Transaction có thể bị từ chối vì state thật dù NPC tin mình đủ tiền/quyền.

## 11. BeliefRevision có phiên bản

`BeliefRevisionPolicy` xác định cho từng miền:

- trọng số theo loại bằng chứng mà chủ thể nhận biết;
- giảm lợi ích của nguồn lặp/cùng lineage;
- xử lý bằng chứng trực tiếp nhưng mơ hồ;
- uy tín theo lĩnh vực và lịch sử được chủ thể biết;
- độ mới, tính phù hợp về thời gian/nơi;
- ngưỡng ACCEPTS/REJECTS/UNRESOLVED;
- mức thay đổi tối đa mỗi lần nếu tâm lý bảo thủ được dùng.

Không chốt công thức Bayesian hoặc hệ số trong K2.4. Mọi policy phải có mã/phiên bản, dùng số nguyên cố định và ghi `BeliefRevisionTrace`. Quan hệ tốt không biến lời nói thành đúng; chỉ ảnh hưởng đánh giá nguồn trong phạm vi có căn cứ.

## 12. Mâu thuẫn, phủ định và chưa quyết

Khi hai bằng chứng xung đột, hệ có thể giữ cả hai hypothesis. `UNRESOLVED` là trạng thái thật, không phải dữ liệu thiếu.

Phủ định phải có phạm vi: “không thấy N05 ở D01 lúc 08:00” khác “N05 không ở D01”. Thiếu quan sát không là bằng chứng phủ định trừ khi observer đã kiểm tra với điều kiện đủ và policy miền cho phép.

Nếu không thể quyết, phương án hợp lệ gồm hỏi nguồn, kiểm tra vật/sổ, chờ tín hiệu mới, hành động thận trọng hoặc chấp nhận rủi ro. Không ép NPC đoán một nhánh chỉ để scheduler tiếp tục.

## 13. Độ mới và điều kiện xét lại

`FreshnessPolicy` phụ thuộc predicate:

| Miền | Cách cũ đi |
|---|---|
| vị trí người | cũ ngay khi rời quan sát; giữ last-seen |
| tồn kho/giá/giờ mở | cũ theo biến động và thời gian từ lần kiểm |
| địa hình | bền hơn nhưng bị sự kiện thay đổi phản bác |
| quyền/hợp đồng | bền tới hạn hoặc bằng chứng sửa/thu hồi |
| trạng thái cơ thể | tín hiệu bản thân liên tục nhưng chẩn đoán sâu có hạn |
| ý định người khác | cũ nhanh; không dùng như lời hứa |

Belief hết mới không bị xóa. `actionability` hạ xuống CHECK_FIRST/DO_NOT_USE và đăng ký recheck khi Goal cần nó; không lập polling cho mọi belief.

## 14. MemoryEpisode và ký ức ngữ nghĩa

Hai dạng chính:

- `EpisodicMemory`: trải nghiệm có thời gian/nơi/người, nội dung giữ lại, affect và góc nhìn.
- `SemanticMemory`: tri thức tổng quát đã rút ra, prerequisite, nguồn episodes/messages và miền áp dụng.

`MemoryEncoding` dùng salience từ ảnh hưởng mục tiêu, bất ngờ, cảm xúc, lặp có ý nghĩa và chủ động ghi nhớ. Nó không lưu mọi tick hay mọi thao tác cầm đồ.

Ký ức về cam kết không thay Contract/Obligation. Người quên vẫn có thể vi phạm nghĩa vụ khách quan; họ chỉ không lập kế hoạch đúng nếu không có nhắc nhở khác.

## 15. Quên, truy hồi và tóm lược

Quên có ba dạng riêng:

1. `retrieval_failure`: chi tiết còn nhưng chưa gọi lại được trong frame hiện tại;
2. `detail_loss`: chi tiết bị loại qua policy;
3. `semantic_compression`: nhiều episode được gộp thành tri thức/tóm lược có provenance.

Memory giữ salience, retrieval cues, last_recalled, retained propositions, omitted categories và compression source digest. Truy hồi là thao tác nhận thức có thời gian/budget trong quyết định khó; không cho phép quét toàn lịch sử miễn phí.

Tóm lược không tạo nhân chứng, danh tính, số lượng hay quan hệ nhân quả mới. Một Summary đang được Belief/Goal/Relationship tham chiếu phải giữ nguồn tối thiểu có thể kiểm toán.

## 16. InferenceRule và giới hạn suy luận

Mỗi `Inference` gồm premises mà holder có, rule id/version, kết luận, confidence cap, scope, created_at, invalidation condition và trace.

Danh mục nền được phép mở rộng có kiểm soát:

- nối tuyến đã biết;
- dự báo lịch lặp;
- chi tiêu/nguồn giữ trừ nhu cầu đã biết;
- Contract/Obligation được biết sinh deadline Goal;
- kết quả Action thất bại cung cấp điều kiện thiếu đã được báo/quan sát;
- last-seen + tuyến đã biết sinh vùng vị trí có thể;
- mẫu nghề/kỹ năng đã học sinh một phương án thao tác;
- lời nói/hành vi sinh giả thuyết ý định một tầng với confidence bị chặn.

Không cho suy luận vô hạn A nghĩ B nghĩ C, không đọc biến private để “đoán”, và không kết luận nhân quả chỉ từ thứ tự thời gian nếu rule không cho phép.

## 17. KnowledgeUnit, khái niệm và biết cách làm

Biết rằng một kỹ thuật tồn tại khác biết cách thực hiện. `KnowledgeUnit` có domain, proposition/recipe/rule, prerequisite, comprehension level, practical capability gate, source, last practice và quyền dạy/chứng nhận.

`OptionGenerator` chỉ dùng action template khi actor:

- có khái niệm nhận ra tình huống;
- biết thao tác hoặc biết người/nơi có thể hỏi;
- có thể biểu diễn đầu vào/đích;
- không bị policy cấm sử dụng tri thức chưa hiểu.

Nghe tên công pháp không sinh đường vận khí. Nhìn người chữa một lần có thể tạo Observation và KnowledgeUnit sơ khai, không tự tăng kỹ năng thực hành tới mức chữa sâu.

## 18. Goal và GoalGraph

`Goal` có desired proposition/state, owner, source, priority class, utility hints, constraints, budget, deadline, autonomy, completion/failure predicates, parent/child/dependency và recheck policy.

Trạng thái: `DORMANT, ACTIVE, BLOCKED, SUSPENDED, SATISFIED, FAILED, ABANDONED`. Chuyển trạng thái cần event/source; không đổi chỉ vì mở giao diện.

Nguồn Goal hợp lệ gồm nhu cầu được cảm nhận, nghĩa vụ được biết, vai trò/thói quen, Message/Command đã nhận, cơ hội quan sát, khát vọng bền, kết quả thất bại và Goal cha. Tiểu sử chỉ tạo disposition/latent concern; cần trigger để thành Goal hoạt động.

## 19. Xung đột mục tiêu và ưu tiên

`GoalArbitration` trước hết dùng lớp ưu tiên có policy: sinh tồn/nguy hiểm được tin, nghĩa vụ bắt buộc, deadline, người phụ thuộc, cam kết đang làm, sinh kế, quan hệ, học/tu luyện và khát vọng. Thứ tự cụ thể chưa chốt toàn thế giới.

Trong cùng lớp, DecisionFrame xét:

- mức cấp bách và hậu quả theo Belief;
- Value/Relationship liên quan;
- tiến độ đã đầu tư và switch cost;
- tài nguyên/quyền/capability được tin;
- khả năng trì hoãn, chia bước hoặc nhờ người;
- policy vai trò/tổ chức mà actor biết.

Một NPC có thể chọn sai, ích kỷ, trái luật hoặc quá thận trọng. Kết quả phải truy được về dữ liệu chủ quan và policy, không cần là tối ưu toàn cục.

## 20. Appraisal nối sự kiện với cảm xúc

`AppraisalRecord` có actor, perceived event/proposition, goal relevance, expectedness, controllability, responsibility hypothesis, norm fit, relationship context, coping potential và policy version.

Appraisal chỉ dùng Belief. Nếu N02 tin N01 cố ý thất hẹn, giận có thể khác khi N02 biết N01 bị thương. Fact bí mật không sửa Affect cho tới khi có bằng chứng mới và appraisal mới.

Mỗi evidence/event chỉ áp một appraisal update theo idempotency key. Sửa niềm tin không xóa cảm xúc đã từng có; nó có thể tạo appraisal sửa, đổi đối tượng/cường độ và ký ức về việc hiểu lầm.

## 21. Affect, Pressure và coping

Affect có type, target, intensity, source appraisal, onset, recovery rule và expression policy. Pressure có sáu thành phần theo [[TAM_LY_21_NGUOI_K1]] và nguồn riêng.

Affect/Pressure có thể:

- đổi salience và OptionGenerator;
- đổi dự báo rủi ro/chi phí theo policy;
- tăng sai sót chỉ khi Action có error model;
- tạo coping option như nghỉ, hỏi, tránh, đối đầu, tìm hỗ trợ;
- thay cách diễn đạt DialogueAct.

Chúng không tự dịch chuyển, gây bạo lực, tiết lộ bí mật, trừ kỹ năng hoặc sửa quan hệ. Quan hệ chỉ đổi sau Observation/Appraisal/RelationshipUpdate có nguồn.

## 22. AgentState tối thiểu cho mỗi NPC

| Nhóm | Record sống |
|---|---|
| thân thể/nơi | Body/Cultivation capability view, Position, current Action |
| nhận thức | AttentionState, active BeliefSet, retrievable Memory index |
| năng lực | Skill/Knowledge/Language/recognized identity |
| động cơ | GoalGraph, Value, Trait, Affect, Pressure |
| xã hội | directed Relationship, reputation beliefs, role/right beliefs |
| ràng buộc | known Contract/Obligation, held Reservation, Plan |
| điều phối | subscriptions, open DecisionFrame/Dialogue, policy versions, RNG cursor |

NPC không cần có quan hệ đầy đủ với mọi người. Record thưa được tạo từ lịch sử thật. Trường không biết dùng trạng thái unknown, không điền trung bình giả.

## 23. Mở và đóng DecisionFrame

Một frame chỉ mở khi có `DecisionWakeup` hợp lệ và không bị coalesce với wakeup tương đương đang chờ. Frame đóng dấu:

- actor và wakeup event;
- snapshot/revision digest;
- CognitiveView đã đọc;
- Goal/Belief/Memory/Skill/Right/Body refs;
- attention/cognitive budget;
- policy/RNG version.

Trạng thái `OPEN -> RESOLVED/INVALIDATED/ABORTED`. Nếu state quan trọng đổi trước commit, frame bị INVALIDATED và frame mới trỏ `supersedes`; không sửa frame cũ.

## 24. Sinh phương án trong giới hạn hiểu biết

Nguồn `DecisionOption` gồm thói quen, plan đang làm, ActionTemplate đã biết, lời khuyên đã hiểu, affordance quan sát, suy luận hợp lệ và phương án meta: hỏi, kiểm tra, chờ, nghỉ, báo không thể, thương lượng, ủy quyền.

Mỗi option giữ `source_of_option`, preconditions được actor tin, required true-state checks, expected outcomes, time/resource estimate, uncertainty và recheck condition.

Không sinh “đi đúng nơi giấu vật” nếu actor không biết nơi. Không tự sinh “dùng công pháp X” chỉ vì engine thấy X hiệu quả. Budget thấp có thể dừng sau tập phương án quen thuộc; budget cao mở rộng dần theo thứ tự policy có log.

## 25. Hard filter, kiểm tra thật và vi phạm chuẩn tắc

Ba loại không trộn:

1. `KnownImpossible`: actor tin không thể nên OptionGenerator loại hoặc chuyển thành tìm hiểu.
2. `ExecutionPrecondition`: engine kiểm tra trạng thái thật khi Action/Transaction commit; có thể làm phương án thất bại.
3. `NormativeRisk`: trái quyền/luật theo nhận thức; vẫn có thể được cân nhắc nếu khả thi vật lý.

Không có quyền không phải hard filter vật lý chung. Tuy nhiên chính sách nhân vật có thể đặt boundary đạo đức/cam kết thành `actor_policy_reject`, với nguồn Value/Role/Command rõ ràng.

## 26. Đánh giá phương án

K2.4 giữ cấu trúc thay vì chốt hệ số:

`OptionEvaluation = GoalFit + ValueFit + RelationshipFit + ExpectedBenefit - ExpectedHarm - ResourceCost - SwitchCost + AffectAttention`

Mỗi thành phần dùng số nguyên, miền và policy version; trỏ Belief/Goal làm căn cứ. Trước phép cộng có thể có lớp ưu tiên từ GoalArbitration và boundary bắt buộc. Không dùng float phụ thuộc nền tảng.

ExpectedOutcome là dự báo của actor. `actual_result` chỉ được gắn vào DecisionTrace sau này để học/kiểm toán, không tính lại điểm cũ.

## 27. Cam kết, hysteresis và tránh dao động

Plan/Action đang làm có commitment strength, sunk progress, interruption cost, deadline và safe interruption points. Một phương án mới chỉ thay khi:

- vượt ngưỡng hysteresis của policy;
- nguy hiểm/nhu cầu/điều kiện bắt buộc đổi;
- Action mất tiền điều kiện;
- Message/Command có quyền ưu tiên phù hợp;
- tới recheck đã định.

Không đánh thức lại mỗi mili giây vì điểm dao động. Cùng một đề nghị bị từ chối không được mở lại frame nếu không có dữ kiện, điều khoản, quan hệ hay deadline mới.

## 28. Từ lựa chọn sang hành động

DecisionFrame không trực tiếp sửa thế giới. Option đã chọn tạo một hoặc nhiều:

- `PlanStep`;
- `DialogueIntent`;
- `ActionRequest`;
- `ReservationRequest`;
- `GoalStateChange`;
- `TriggerSubscription`.

Scheduler đặt event sớm nhất ở pha hợp lệ. Transaction/Action kiểm tra state thật và ConflictPolicy. Nếu bị từ chối, kết quả có reason code; NPC chỉ học phần được quan sát/báo, không đọc reason nội bộ nếu không có tín hiệu.

## 29. Kỳ vọng, phản hồi và học

`Expectation` gồm proposition dự kiến, cửa sổ thời gian, confidence, tiêu chí quan sát và recheck trigger. Sau kết quả:

1. FactEvent xảy ra;
2. actor có hoặc không có Observation/Message;
3. `OutcomeComparison` so điều được nhận thức với kỳ vọng;
4. Belief/Knowledge/SourceTrust/Plan heuristic có thể đổi theo rule;
5. Skill chỉ đổi qua Practice/Learning event hợp lệ.

Không phạt “quyết định sai” bằng tri thức toàn tri. Nếu kết quả xấu nhưng actor không biết hoặc không thể quy nguyên nhân, họ không tự học đúng bài học.

## 30. DecisionWakeup và subscription

Trigger chuẩn gồm:

- Action/PlanStep hoàn tất, thất bại hoặc mất điều kiện;
- nhu cầu/capability vượt ngưỡng được cảm nhận;
- Message/Observation/BeliefRevision liên quan;
- Contract/Right/Reservation actor biết đã đổi;
- deadline, appointment, recheck hoặc routine window;
- Goal cha/con đổi;
- Command hợp lệ tới P00;
- Dialogue tới lượt/phải phản hồi;
- region fidelity đổi làm materialize agent.

Subscription có relevance predicate, once/repeating, debounce/coalesce key, earliest wake, backoff và owner. Một event có thể đánh thức nhiều agent; mỗi người vẫn dùng CognitiveView riêng.

## 31. Chống polling và bão quyết định

Không chạy toàn bộ NPC mỗi tick hay mỗi mili giây game. Khi BLOCKED, Goal phải có trigger hoặc mốc recheck hữu hạn. Khi không có việc mới, RoutinePlan đặt occurrence kế tiếp.

`WakeupCoalescer` gộp các thay đổi cùng batch trước khi mở frame. Giới hạn `max_frames_per_actor_per_game_minute` chỉ là bảo vệ lỗi; vượt giới hạn tạo IntegrityPause/diagnostic, không âm thầm bỏ quyết định quan trọng.

Vòng nhân quả pha 80 không được tự tạo vô hạn frame→goal→frame. Cùng cause chain và decision purpose chỉ mở một lần mỗi revision, trừ khi output tạo state gameplay mới ở pha sau.

## 32. Dialogue là Action nhiều bước

Vòng đời hội thoại:

```text
DialogueIntent -> UtteranceSignal -> Observation
-> ComprehensionAttempt -> DialogueAct nhận được
-> Belief/Appraisal/Goal update -> DecisionFrame đáp lời
```

Mỗi lượt chiếm thời gian, chú ý, Position/range và kênh ngôn ngữ. Chen lời, bỏ đi, mất ý thức, tiếng ồn hoặc Action khẩn có thể INTERRUPT. Im lặng, timeout hay không hiểu không thành ACCEPT.

`RenderedText` chỉ diễn đạt payload đã cấu trúc. Nếu dùng mô hình ngôn ngữ, output bị khóa vào act, facts được phép, mức chắc, privacy và style; không parse ngược để tạo quyền, nợ, vật, công pháp hoặc kết quả.

## 33. Bí mật, né tránh, nhầm và nói dối

| Trạng thái | Điều kiện |
|---|---|
| giữ kín | biết nội dung nhưng không chọn truyền |
| né/trả lời thiếu | chủ động bỏ phần, không nhất thiết phát biểu sai |
| nhầm | speaker tin payload đúng |
| nói dối | speaker tin payload sai và muốn receiver tin nó |
| bịa không chắc | speaker không biết nhưng trình bày như chắc |

PrivacyScope ảnh hưởng OptionGenerator và DialogueIntent, không phải tường vật lý: người khác có thể nghe lén nếu tín hiệu cho phép. Người nghe không tự biết intent nói dối. Phát hiện cần mâu thuẫn, hành vi, nguồn hoặc thú nhận được quan sát.

## 34. Quan hệ, tin cậy và danh tiếng chủ quan

`RelationshipState(A->B)` có trust theo miền, affection, respect, fear, grievance, attachment và source history. `ReputationBelief` thuộc một người/nhóm nhận thức; không có thanh danh tiếng toàn thế giới.

Một Interaction không trực tiếp cộng điểm. Chuỗi là Observation/Message → Appraisal → RelationshipUpdate có diminishing/repetition policy và idempotency key.

Trust nguồn ảnh hưởng BeliefRevision trong đúng miền. Tin N03 về y thuật không đồng nghĩa tin N03 về giá khoáng. Nhiều lời đồn cùng nguồn giữ independence group và không nhân uy tín.

## 35. P00 và ba chính sách trải nghiệm

K2.4 giữ ba policy chưa chốt:

| Policy | Cách quyết định |
|---|---|
| `PLAYER_DIRECT` | Command người chơi tạo Goal ưu tiên; không dùng Trait/Value ẩn để bí mật chống lệnh |
| `PLAYER_CHARACTER` | hồ sơ Trait/Value do người chơi đã xác lập tham gia như NPC; phải giải thích và cho xem ranh giới trước |
| `HYBRID_CONSENT` | tự xử trong giới hạn đã giao, dừng hỏi khi xung đột/nguy hiểm vượt ngưỡng |

Mỗi save gắn một policy/version. Scheduler không trộn policy giữa frame. P00 vẫn chỉ thấy thông tin đã quan sát; giao diện không được dùng debug Fact để cảnh báo toàn tri.

NPC khác luôn là tác nhân độc lập. Command của người chơi tới họ là lời đề nghị, quyền tổ chức hoặc Contract tùy quan hệ thật; không sửa Goal/Value trực tiếp nếu thiếu cơ chế.

## 36. NPC ngoài vùng và mức R0–R4

| Mức | Nhận thức/quyết định được giữ |
|---|---|
| R0 | agent đầy đủ, Observation chi tiết, frame từng hành động |
| R1 | gộp thao tác ngắn nhưng giữ quyết định/transaction/interaction quan trọng |
| R2 | process/routine theo khoảng; materialize khi threshold, conflict hoặc message |
| R3 | milestone sinh kế/quan hệ/cam kết; belief/memory quan trọng vẫn theo cá nhân |
| R4 | trạng thái dài hạn và biến cố bắt buộc; không cộng dân số rồi phân ngược tiểu sử |

Đổi mức không được đổi kết quả logic của cùng sự kiện bắt buộc. Vùng xa không bịa hội thoại, tình yêu, phản bội, công pháp hay cái chết để lấp khoảng trống. Mọi Episode sinh ra phải có process/event/source digest và policy version.

Khi người chơi tới gần, `MaterializationPlan` mở chi tiết từ state đã có; không hồi tố cho NPC biết cảnh người chơi từng làm nếu không có kênh tin.

## 37. Ngân sách nhận thức và quy mô thế giới

Độ sâu không đồng nghĩa mọi NPC suy nghĩ tối đa liên tục. `CognitiveBudget` giới hạn có giải thích:

- số memory candidates được truy hồi;
- độ sâu inference;
- số option được mở rộng;
- số quan hệ/chủ đề đang hoạt động;
- mức chi tiết hội thoại;
- khoảng horizon của plan.

Budget phụ thuộc mức mô phỏng, urgency và độ phức tạp, không phụ thuộc thiết bị. Máy chậm chỉ mất thêm thời gian thật hoặc hạ tốc độ thế giới; không cho NPC ít thông minh hơn. Nếu budget logic là phần gameplay, nó nằm trong policy/save và giống nhau trên điện thoại/máy tính.

## 38. Lưu/tải và tái hiện

Bản lưu phải giữ:

- Belief hypothesis và evidence links đang sống;
- Memory/Summary provenance;
- GoalGraph, Plan, expectations và subscriptions;
- Affect/Pressure/Relationship updates đã áp;
- open Dialogue/DecisionFrame hoặc ranh giới phục hồi an toàn;
- policy/version, RNG stream/cursor và idempotency keys;
- fidelity level cùng materialization digest.

Tải lại không phát Message, Appraisal, RelationshipUpdate hoặc quyết định lần hai. Mở trang NPC không tiêu RNG. Canonical order chỉ dùng cho serialization/hash; không làm tie-break gameplay.

## 39. ViewProjection và giải thích hành vi

Ba mức xem:

1. **Người chơi:** chỉ lời/hành vi/tài liệu P00 nhận được, uncertainty dễ hiểu và điều khoản cần quyết định.
2. **Hồi tưởng của P00:** Belief/Memory của P00 với nguồn mà P00 biết; không hiện Fact debug.
3. **Công cụ phát triển:** chuỗi đầy đủ Signal→Observation→Belief→Appraisal→Goal→Option→Action cùng reason code.

Không hiện điểm Trait, Affect, confidence hay Score thật của NPC như số chính xác trong giao diện chơi. Có thể diễn đạt “Bình có vẻ do dự” nếu P00 quan sát dấu hiệu và suy luận tương ứng.

Trên điện thoại, nguồn và chi tiết mở theo thẻ/xếp lớp; trên máy tính có thể đặt timeline, mục tiêu và nguồn cạnh nhau. Hai giao diện gửi cùng Command/DialogueAct có cấu trúc.

## 40. Mã lỗi và trạng thái thất bại

| Mã | Ý nghĩa |
|---|---|
| `COG_NO_SOURCE` | Belief/Inference thiếu nguồn |
| `COG_ILLEGAL_FACT_ACCESS` | actor đọc Fact/private state trái hợp đồng |
| `COG_BAD_PROPOSITION_SCOPE` | thiếu thời gian/phủ định/phạm vi bắt buộc |
| `COG_DUPLICATE_EVIDENCE` | đếm lại cùng evidence/lineage |
| `COG_INVALID_INFERENCE` | premise/rule/scope không hợp lệ |
| `COG_UNKNOWN_OPTION_SOURCE` | option không có nguồn biết cách |
| `COG_STALE_FRAME` | revision đầu vào đổi trước commit |
| `COG_WAKEUP_LOOP` | vòng đánh thức không tạo state mới |
| `COG_REPLAY_UPDATE` | tải/tóm lược áp lại update |
| `COG_FIDELITY_DIVERGENCE` | R-level làm đổi kết quả bắt buộc |
| `COG_POLICY_MISSING` | thiếu policy/version cần thiết |
| `COG_RENDERED_TEXT_ESCAPE` | lời văn thêm payload ngoài act |

Lỗi hợp đồng dừng mutation liên quan và giữ snapshot trước. Không tự sửa bằng cách cấp tri thức, chọn option đầu tiên hoặc bỏ event.

## 41. Sáu walkthrough chuẩn

### 41.1 Kho V02 đã đổi sau lần nhìn cuối

N01 thấy 20 V02 lúc 08:00. Đến 10:00, Transaction khác lấy 15 nhưng N01 ở xa. Belief của N01 vẫn là last-seen 20, freshness giảm. N01 lập kế hoạch lấy 10; khi tới kho, Inspection cho thấy còn 5. Action không thể lấy 10, tạo Observation mới và DecisionFrame chọn lấy 5, hỏi nguồn khác hoặc đổi kế hoạch. NPC không được biết giao dịch 10:00 nếu không thấy sổ/nghe kể.

### 41.2 FX-C-MSG và FX-C-NOMSG

Cầu đổi trạng thái là Fact. Ở MSG, tín hiệu tới đúng người, được hiểu và Belief tuyến đổi trước lúc chọn đường. Ở NOMSG, NPC giữ belief cũ, có thể đi tới rồi quan sát chướng ngại. Cùng Fact nhưng hành vi khác vì chuỗi nhận thức khác; engine không lén sửa tuyến đã biết.

### 41.3 Tin bánh V23 qua nhiều người

N05 quan sát dấu mòn, nói N06; N06 kể N17; một người khác nghe lại từ N17. Ba Message giữ lineage N05. NPC có thể không biết cùng nguồn nếu relay giấu; validator vẫn chống đếm vòng. Chỉ Inspection mới tạo bằng chứng độc lập về condition thật. Tin không tự sinh V24, giá hay quyền chi.

### 41.4 N17 chọn giúp P00 bị thương

N17 chỉ thấy máu, tư thế và đáp ứng, không đọc W-B01 debug. Observation + kỹ năng MED hẹp tạo giả thuyết nguy cơ, Appraisal nối DUTY/CARE, rồi Goal xung đột với nghĩa vụ gác. Option chữa sâu bị loại do không biết cách; giúp tối thiểu/gọi người/rời gác có hậu quả thật. Lý do quyết định giữ nguyên dù sau đó biết vết nhẹ hơn dự đoán.

### 41.5 Yêu cầu chi 32 V01 tại O06

Tiếng rung chỉ kích hoạt Goal kiểm tra. Inspection/Estimate được Tâm hiểu tạo Belief cần sửa và option xin hội đồng; quyền 20 V01 làm tự chi 32 bị actor policy/Transaction chặn theo đúng lớp. Hội đồng chỉ quyết sau Message tới, hiểu nguồn và mở frame riêng cho từng thành viên. Ruling tạo quyền/Claim, chưa tự sửa cầu.

### 41.6 Lệnh rủi ro cho P00 trên hai thiết bị

Cùng save và `PLAYER_DIRECT`, điện thoại/máy tính gửi cùng Command idempotency key. P00 dùng cùng Belief nguy hiểm và giới hạn dừng, sinh cùng Goal/Plan/RNG cursor. Khác bố cục không đổi quyết định. Nếu ứng dụng xuống nền rồi tải lại, frame đã resolve không chạy lại và không nhân Reservation.

## 42. Điều kiện kiểm thử NT01–NT44

1. NT01 — FactEvent không tự tạo Belief cho mọi NPC.
2. NT02 — Proposition giữ đúng thời gian, nơi, phủ định và modality.
3. NT03 — Mã Person bí mật không lộ qua descriptor chưa nhận diện.
4. NT04 — Candidate thiếu vị trí/kênh/chú ý bị loại trước Observation.
5. NT05 — Cùng Place nhưng bị chắn hoặc lệch thời gian không tự nghe/nhìn.
6. NT06 — Observation mơ hồ không tự giải danh tính/nguyên nhân/vật loại cụ thể.
7. NT07 — IdentityHypothesis mới không sửa nội dung Observation cũ.
8. NT08 — Attention phân bổ không vượt 1.000 và gián đoạn Action có hậu quả.
9. NT09 — Nghe tín hiệu nhưng không hiểu không nhận payload đầy đủ.
10. NT10 — Message chỉ tới actual receiver và giữ send/delivery riêng.
11. NT11 — Nhiều relay cùng nguồn không được đếm thành bằng chứng độc lập.
12. NT12 — Người nhận không được biết lineage bị che chỉ vì engine biết.
13. NT13 — Belief trái Fact vẫn tồn tại và chỉ đổi qua bằng chứng hợp lệ.
14. NT14 — Hai hypothesis mâu thuẫn có thể cùng ở UNRESOLVED.
15. NT15 — Thiếu quan sát không biến thành phủ định nếu chưa kiểm đủ.
16. NT16 — BeliefRevision dùng policy/version và số nguyên tái hiện được.
17. NT17 — Freshness hạ actionability, không xóa Belief hay tạo polling.
18. NT18 — Memory không thay Contract/Obligation khách quan.
19. NT19 — Truy hồi thất bại, mất chi tiết và tóm lược là ba trạng thái riêng.
20. NT20 — Tóm lược không sinh danh tính, số lượng, nhân quả hay nhân chứng mới.
21. NT21 — Inference chỉ dùng premise holder thật sự có và rule đúng scope.
22. NT22 — Suy đoán ý định không vượt độ sâu policy hoặc đọc private state.
23. NT23 — Nghe tên công pháp/thao tác không tự cấp cách làm hay Skill.
24. NT24 — Mọi Goal hoạt động có nguồn và chuyển trạng thái có event.
25. NT25 — Goal xung đột giữ dependency, deadline và hậu quả trì hoãn.
26. NT26 — Appraisal dùng Belief chủ quan và áp đúng một lần mỗi nguồn.
27. NT27 — Sửa Belief không xóa Affect lịch sử hoặc viết lại Memory cũ.
28. NT28 — Affect/Pressure không trực tiếp tạo Action, quyền hay quan hệ.
29. NT29 — DecisionFrame đóng dấu snapshot, CognitiveView, policy và RNG.
30. NT30 — State đổi quan trọng làm frame stale, không sửa frame cũ.
31. NT31 — known_options chỉ gồm phương án có nguồn tri thức/affordance.
32. NT32 — Hỏi, kiểm tra, chờ, nghỉ và báo không thể là option hợp lệ.
33. NT33 — Không quyền không bị dùng như bất khả thi vật lý toàn cục.
34. NT34 — Score dùng expected outcome theo Belief, không dùng hậu quả thật tương lai.
35. NT35 — Hysteresis ngăn đổi việc lặp khi không có trigger đủ mạnh.
36. NT36 — Quyết định chỉ tạo request/plan; mutation vẫn qua scheduler/transaction.
37. NT37 — Action fail chỉ dạy phần actor quan sát hoặc được báo.
38. NT38 — Wakeup cùng batch được coalesce và không sinh vòng pha 80 vô hạn.
39. NT39 — Im lặng/timeout/không hiểu không thành ACCEPT hoặc Contract.
40. NT40 — Nhầm, né, giữ kín và nói dối phân biệt bằng Belief + intent.
41. NT41 — R0–R4 giữ cùng kết quả bắt buộc, danh tính và cam kết cá nhân.
42. NT42 — Save/load không phát lại Message/Appraisal/Relation/Decision update.
43. NT43 — RenderedText không thêm fact, quyền, vật, nợ hoặc công pháp ngoài payload.
44. NT44 — Cùng save/input/policy/RNG cho cùng logic trên điện thoại và máy tính.

Thêm 44 NT vào 484 điều kiện trước đó thành **528 điều kiện thiết kế chưa chạy bằng validator/mô phỏng**.

## 43. Giới hạn và bước tiếp theo

K2.4 chưa chốt công thức confidence, trọng số lựa chọn, mô hình chú ý/sai sót, độ quên, ngân sách nhận thức, văn hóa hội thoại, thần thức, NPC tập thể, chính trị quy mô lớn hoặc mô hình sinh lời cuối. Các phần này phải dùng policy có phiên bản và fixture riêng, không hard-code thành “tính người chung”.

K2.5–K2.7 đã khóa phục hồi, oracle và ngân sách cognition/R0–R4; gói được rà tại [[KIEM_TOAN_DONG_GOI_K2]], kiến trúc tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
