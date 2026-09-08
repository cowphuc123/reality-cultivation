---
title: Kiến trúc dữ liệu nội dung và sinh thế giới có kiểm soát — K3.3
aliases:
  - K3.3
  - Dữ liệu nội dung và sinh thế giới
tags:
  - reality-cultivation
  - thiet-ke
  - noi-dung
  - sinh-the-gioi
  - du-lieu
status: de-xuat
updated: 2026-09-06
---

# Kiến trúc dữ liệu nội dung và sinh thế giới có kiểm soát — K3.3

Tài liệu này nối [[VAT_PHAM]], [[TU_LUYEN]], [[CO_THE]], [[NPC]], [[MOI_TRUONG]] với kiến trúc core/content trong [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. Mục tiêu là cho phép thế giới mở rộng rất lớn, có vô số tổ hợp có ý nghĩa, trong khi từng thực thể đã tồn tại vẫn giữ danh tính, nguyên nhân và lịch sử riêng.

Đây là đề xuất dữ liệu, chưa phải generator hoặc thư viện nội dung đã chạy. Từ “vô hạn” trong tên chặng được hiểu là **không gian nội dung có thể mở rộng theo quy tắc và seed**, không phải lưu vô hạn record trong máy. 68 điều kiện ND cuối tài liệu đều chưa chạy.

## 1. Mục tiêu K3.3

1. Tách định nghĩa chung khỏi thực thể cụ thể.
2. Sinh khác biệt từ cơ chế, không chỉ tên và chỉ số ngẫu nhiên.
3. Mọi kết quả sinh được đều có seed, version và provenance.
4. Không phụ thuộc thứ tự người chơi khám phá vùng.
5. Cá thể đã materialize không bị sinh lại thành người/vật khác.
6. Nội dung tổ hợp vẫn qua bất biến vật chất, cơ thể, tu luyện và xã hội.
7. Tác giả có thể viết nội dung tay, generator có thể kết hợp, cả hai dùng cùng schema.
8. Save chỉ giữ điều cần thiết nhưng không xóa hậu quả lịch sử.

## 2. Bốn tầng tồn tại

| Tầng | Ví dụ | Tính chất |
|---|---|---|
| `Definition` | sắt, mô cơ, kiểu khớp, thao tác dẫn khí | bất biến theo content version |
| `Blueprint` | dao sắt kiểu A, cơ thể người, công pháp hình thành | cấu trúc có tham số, chưa là vật cụ thể |
| `Instance` | con dao V104, cơ thể N07, bản chép CP12 | có id, state, vị trí, lịch sử |
| `Derived View` | “dao tốt”, “kinh mạch yếu”, mô tả UI | tính từ dữ liệu và tri thức người xem |

Không lưu nhãn UI như nguồn thật nếu có thể suy ra từ instance + definition + viewer knowledge.

## 3. Content package

Mỗi gói nội dung có:

- `package_id`, `semantic_version`, `schema_version`;
- dependency và conflict ranges;
- feature requirements;
- namespace owner;
- definitions/blueprints/generators/policies/locales;
- migrations;
- canonical manifest/hash;
- license/source metadata;
- validation status.

Load order không được âm thầm quyết định override. Patch/overlay phải khai target id, base hash và chiến lược merge hợp lệ.

## 4. Không gian tên và id

ID nội dung có dạng khái niệm `namespace:domain:name@revision`; instance dùng typed id của world. Tên hiển thị không là id.

Quy tắc:

- rename locale không phá save;
- hai package không chiếm cùng id;
- alias có thời hạn migration, không tạo hai definition;
- id generated dựa generator path/seed, không dựa vị trí trong array;
- hash collision phải được phát hiện, không coi hai nội dung là một.

## 5. Definition không chứa state sống

Definition có thể nêu đặc tính chuẩn, đơn vị, constraints, relations và operator. Nó không chứa owner, current damage, vị trí, ký ức hay số lượng của instance.

Ví dụ `material:iron` mô tả mật độ/range cơ học; thanh sắt cụ thể lưu khối lượng, tạp chất, nhiệt, biến dạng và provenance của chính nó.

## 6. Blueprint là đồ thị cấu tạo

Blueprint là graph node/edge có slot, vật liệu, hình học, chức năng và constraint. Cùng một cơ chế dùng cho:

- vật phẩm nhiều bộ phận;
- cơ thể và mạng mạch;
- công pháp dạng tuyến/operator;
- công trình;
- tổ chức và chức vụ;
- quy trình chế tác/điều trị/nghi lễ.

Graph phải hữu hạn sau khi resolve; recursion chỉ hợp lệ với depth/budget rõ.

## 7. Instance và identity permanence

Khi materialize, instance nhận:

- typed id ổn định;
- blueprint/content fingerprints;
- creation event/time/place/agent;
- parameters đã resolve;
- initial state hash;
- provenance graph;
- lifecycle status.

Từ đó, load/regenerate không được đổi identity hoặc reroll thuộc tính. Thay đổi chỉ qua event/mutation/migration có dấu vết.

## 8. Provenance graph

Mọi thực thể generated có `GenerationProvenance`:

- world seed lineage;
- generator id/version;
- hierarchical seed path;
- input definitions/constraints;
- parent entities/region/culture nếu có;
- choices và rejected-choice digest cần thiết;
- creation boundary;
- output hash.

Provenance không nhất thiết lưu toàn bộ trace chi tiết mãi; digest/tóm lược phải đủ tái hiện hoặc chứng minh nguồn.

## 9. Seed phân cấp

Không dùng một RNG toàn cục cho sinh nội dung. Seed tree khái niệm:

```text
world_seed
  / cosmology
  / region:<stable-coordinate>
      / geology
      / ecology
      / culture:<id>
      / settlement:<id>
          / household:<id>
          / person:<id>
          / item:<id>
```

Mỗi node dẫn xuất bằng hàm canonical từ parent seed + stable key + generator version. Sinh vùng B trước A không đổi kết quả của A.

## 10. Generator là pipeline có kiểu

Các pha chuẩn:

1. chọn context và budgets;
2. sinh candidate structure;
3. resolve dependencies;
4. áp constraints cứng;
5. chấm mục tiêu mềm/đa dạng;
6. repair/backtrack trong budget;
7. validate domain/cross-domain;
8. canonicalize;
9. gán identity/provenance;
10. publish nguyên tử.

Generator thất bại trả artifact, không xuất instance nửa hợp lệ.

## 11. Constraint cứng và mục tiêu mềm

| Loại | Ví dụ | Hành vi |
|---|---|---|
| hard invariant | khối lượng không âm, route nối được | reject/backtrack |
| compatibility | công pháp cần cấu trúc mạch tương thích | reject hoặc đánh dấu không học được |
| ecological feasibility | quần thể cần nguồn sống | repair/reject |
| cultural plausibility | tên/tập tục hợp lịch sử vùng | score mềm, ngoại lệ có nguồn |
| diversity target | tránh 100 dao giống nhau | score mềm |
| gameplay relevance | có tradeoff, không một lựa chọn trội | score + audit, không bẻ vật lý |

Mục tiêu mềm không được vi phạm hard invariant để tạo nội dung “hay”.

## 12. Budget sinh nội dung

Mỗi request có:

- node/edge/instance limit;
- attempt/backtrack limit;
- CPU/memory/time slice;
- maximum dependency depth;
- uniqueness search radius;
- validation level;
- fallback policy;
- failure visibility.

Hết budget trả `GENERATION_DEFERRED/FAILED_CONSTRAINT`, không treo UI hoặc dùng candidate chưa kiểm.

## 13. Tính duy nhất không đồng nghĩa ngẫu nhiên tuyệt đối

Mỗi thực thể có thể khác ở lịch sử, vật liệu, người chế tác, hao mòn, quyền sở hữu, tri thức và quan hệ ngay cả khi dùng cùng blueprint. Generator chỉ tạo biến thể khi khác biệt ảnh hưởng ít nhất một:

- capability;
- constraint;
- cost/risk;
- compatibility;
- perception/knowledge;
- provenance/history;
- social meaning.

Không sinh hàng triệu modifier không ai dùng chỉ để tăng con số.

## 14. Uniqueness ledger

Ledger theo scope ghi semantic signature của:

- tên/biểu tượng;
- cấu trúc blueprint;
- mechanism vector;
- lịch sử nguồn;
- niche/capability profile.

Trùng chữ có thể hợp lệ; trùng toàn cơ chế cần lý do như truyền thừa, sao chép hoặc sản xuất hàng loạt. Ledger là index derived, có thể rebuild từ canonical entities.

## 15. Độ đa dạng đo được

Không dùng số definition làm chỉ số duy nhất. Báo cáo nội dung gồm:

- số mechanism distinct;
- phân bố capability/niche;
- pairwise similarity sample;
- dominance rate;
- unused/dead combinations;
- constraint rejection reasons;
- provenance depth;
- player-observable distinction;
- duplication theo region/culture/time.

## 16. Taxonomy vật liệu

Vật liệu tổ chức theo composition + structure + state, không chỉ “cấp”. Các trục gồm:

- thành phần hóa học/hư cấu;
- phase, porosity, grain/fiber;
- density, hardness, toughness, elasticity;
- nhiệt/ẩm/ăn mòn;
- dẫn/trữ/tương tác linh lực;
- độc tính/sinh học;
- purity/defect;
- nguồn địa chất/sinh vật/chế tác.

Giá và rarity là dữ liệu kinh tế theo nơi/thời, không là thuộc tính vật lý bất biến.

## 17. Sinh vật phẩm từ capability

Vật phẩm không có danh sách công dụng đóng. Blueprint kết hợp:

- geometry/contact surfaces;
- parts/joints/containers;
- material fields;
- current condition;
- handling requirements;
- affordance operators như CUT, HOLD, SEAL, INSULATE, CONDUCT_QI;
- user skill/body/environment.

Action resolver tìm capability phù hợp; tên loại chỉ hỗ trợ tra cứu và tri thức.

## 18. Chất lượng nhiều chiều

Quality vector của instance có nguồn từ:

- input material batch;
- process steps/tool precision;
- crafter skill/attention;
- environment;
- defect events;
- repair/wear history;
- appraisal uncertainty.

Không nén thành một sao/màu để dùng trong logic. UI có thể tóm lược theo hiểu biết người xem.

## 19. Họ vật phẩm và sản xuất hàng loạt

`ItemFamilyBlueprint` tạo họ; `ProductionRecipe` tạo lô; `ItemInstance` chỉ tách khi cần identity. Hạt gạo không có id riêng, nhưng lô giữ composition, quality distribution, owner và history.

Tách/gộp lô dùng K2.3 conservation. Vật quan trọng tách khỏi lô với provenance dẫn ngược về batch, không được reroll chất lượng.

## 20. Sinh công pháp theo cơ chế

`TechniqueBlueprint` là graph operator:

- sensing/intake;
- route qua body/meridian nodes;
- transform/store/release;
- cadence/posture/breath/mental operations;
- preconditions;
- efficiency/loss/heat/strain;
- failure transitions;
- learning representation;
- compatibility/conflict hooks;
- observable signs.

Tên hệ hỏa/thủy chỉ là taxonomy văn hóa; kết quả đến từ graph và cơ thể người dùng.

## 21. Nguồn gốc và truyền thừa công pháp

Công pháp generated cần lineage:

- người/tổ chức sáng tạo;
- vấn đề họ muốn giải;
- công pháp cha/quan sát/thí nghiệm;
- body/environment assumptions;
- revision/biến thể;
- phần bí truyền/bị mất/sao chép sai;
- văn bản/người truyền giữ phiên bản nào.

Hai bản chép cùng tên có thể khác nội dung thật. Người chơi chỉ biết phần đã đọc/hiểu.

## 22. Cải biến công pháp

Biến thể không cộng modifier tùy ý. Generator biến đổi graph bằng operator có quy tắc:

- thay route;
- đổi nhịp;
- thêm buffer;
- đổi nguồn/đích năng lượng;
- thay safety gate;
- chuyên hóa body/environment;
- bỏ/mất bước;
- kết hợp hai lineage.

Mỗi biến đổi chạy conservation, compatibility, learnability và failure analysis.

## 23. Chống công pháp tối ưu tuyệt đối

Audit Pareto theo context: tốc độ, hiệu suất, ổn định, yêu cầu, rủi ro, tính kín đáo, khả năng chiến đấu, tuổi thọ và chi phí học. Một công pháp trội mọi trục chỉ hợp lệ nếu rarity/requirements/history giải thích và vẫn không phá quy luật.

Nội dung yếu vẫn có thể tồn tại do truyền thống, sai lầm hoặc hoàn cảnh; NPC không biết bảng cân bằng toàn tri.

## 24. Blueprint cơ thể

`SpeciesBodyBlueprint` gồm:

- part hierarchy;
- structural/vascular/neural/qi edges;
- tissue layers;
- organs and functional contributions;
- symmetry/variation rules;
- growth/aging/reproduction hooks;
- normal ranges theo tuổi/giới/lineage nếu có;
- disease/injury interfaces;
- sensory/perception channels.

Body instance resolve variation một lần, rồi thay đổi qua sinh lý/sự kiện.

## 25. Dị biệt cá thể cơ thể

Dị biệt có nguồn từ heredity, development, dinh dưỡng, bệnh, lao động, tu luyện, thương tích và điều trị. Generator không tạo “+7% gan” vô nghĩa; variation phải ánh xạ sang cấu trúc/chức năng hoặc uncertainty hợp lệ.

Khuyết tật/đặc điểm cơ thể không tự suy ra tính cách, đạo đức hoặc giá trị con người.

## 26. Sinh thương tích và bệnh

Thương tích là kết quả interaction solver, không content loot table. Disease/toxin definitions nêu tác nhân, đường vào, target, kinetics và immune/environment interactions.

Generator scenario có thể tạo nguồn phơi nhiễm, nhưng mutation cơ thể vẫn đi qua body domain và timeline. Không gắn bệnh chỉ để làm “cốt truyện” nếu thiếu đường nhân quả.

## 27. Hồ sơ NPC sinh ra

`PersonGenesis` tạo:

- biological/social parents hoặc nguồn gốc hợp lệ;
- birth time/place;
- household/culture/language;
- body blueprint/variation;
- early resources and constraints;
- initial relationships;
- education/apprenticeship opportunities;
- memory seeds từ event thật;
- current assets/claims/obligations;
- personality/value priors có nguồn và uncertainty.

Nó không viết sẵn toàn bộ tương lai hoặc một “vai truyện” bắt buộc.

## 28. Tiểu sử nhân quả

Backstory generator chạy event timeline rút gọn:

1. tạo context hộ/vùng;
2. đặt các mốc bắt buộc như sinh, di cư, học nghề;
3. mô phỏng/giải constraints tài nguyên và tuổi;
4. tạo quan hệ qua encounter hợp lệ;
5. tạo ký ức từ observation/message;
6. kết sổ tài sản/nghĩa vụ/cơ thể;
7. validate current state;
8. publish biography facts + subjective memories tách biệt.

Không viết “hai người thân nhau” nếu chưa có đường gặp hoặc nguồn quan hệ.

## 29. Tên và ngôn ngữ

Name generator phụ thuộc culture, language, thời kỳ, gia đình, giới hạn âm vị/chữ viết và phong tục đặt tên. Lưu semantic identity tách display forms.

Tên trùng được phép. UI phân biệt bằng thông tin người xem biết, không tự lộ global id. Phiên âm/dịch/localization không đổi danh tính.

## 30. Quan hệ và mạng xã hội

Generator không tạo graph N². Nó sinh edge qua hộ, nơi, nghề, tổ chức, hành trình, biến cố và giao tiếp. Mỗi edge có hướng, loại, nguồn, thời điểm và mức chủ quan.

Degree/distribution constraints ngăn NPC cô lập vô lý hoặc mọi người đều biết nhau. Quan hệ xa chỉ materialize khi có encounter/message lineage.

## 31. Hộ, tổ chức và thể chế

Organization blueprint gồm purpose, roles, admission, authority, resources, obligations, succession, norms và information channels. Instance có thành viên, lịch sử quyết định, tài sản và tranh chấp thật.

Generator phải kiểm vai trò có người đủ năng lực, nguồn sống, quyền không tự biến thành kiểm soát vật lý và thể chế có đường truyền thông/thực thi.

## 32. Văn hóa không phải gói modifier

Culture được mô hình bằng practices, values distributions, norms, kinship, language, material techniques, ritual, history và contested variants. Một người tham gia nhiều cộng đồng và có thể bất đồng.

Không gắn mọi thành viên cùng tính cách/niềm tin. Generator tạo xác suất/áp lực xã hội; cognition và đời sống tạo lựa chọn cá thể.

## 33. Địa lý phân cấp

Không gian dùng stable coordinates/keys:

- world/cosmology;
- macro region;
- watershed/geological province;
- local region;
- settlement/site;
- place/room/container.

Biên hành chính/văn hóa không bắt buộc trùng địa chất. Route là edge có hình học, địa hình, mùa, nguy hiểm và lịch sử bảo trì.

## 34. Sinh địa chất và tài nguyên

Pipeline địa chất tạo nền, quá trình, strata/deposit, thủy văn và exposed resources. Mỏ không là node loot vô hạn; extraction chuyển stock, làm đổi địa hình/chất lượng/dễ tiếp cận.

Resource definition nối material composition. Rarity xuất hiện từ phân bố địa chất + mức khám phá + chi phí khai thác, không từ nhãn cấp.

## 35. Khí hậu, mùa và thời tiết

Climate là baseline field theo vị trí/độ cao; season và weather là process/event. Generator tạo tham số/quan hệ hợp lệ, không ghi sẵn từng giờ vô hạn.

Weather realization dùng seed stream theo vùng/time bucket, nhưng khi ảnh hưởng state phải materialize event và lưu hậu quả. Regenerate không được đổi trận mưa đã tác động mùa màng.

## 36. Sinh thái và quần thể

Species definitions nêu niche, lifecycle, energy/material needs, reproduction, mortality, movement và interactions. Region giữ population cohorts/flows ở mức phù hợp; cá thể materialize khi cần identity/interaction.

Không tuyên bố mỗi côn trùng xa là NPC chi tiết. Cá thể đã materialize vì quan sát, sở hữu, thương tích hoặc quan hệ phải giữ identity theo retention policy.

## 37. Linh khí và địa mạch

Qi field có source, sink, flow, storage, affinity và disturbance. Linh địa sinh từ địa chất/sinh thái/lịch sử/formation, không đặt marker ngẫu nhiên độc lập.

Công pháp, cơ thể, vật liệu và môi trường dùng cùng đơn vị/conversion contracts. Khai thác/đột phá/trận pháp có thể làm đổi field và để dấu vết lâu dài.

## 38. Lịch sử thế giới trước khi chơi

Luồng này đã được người dùng xác nhận và được cụ thể hóa tại [[KHOI_TAO_THE_GIOI_LICH_SU_TIEN_GAME_VA_NHAP_THE_NGUOI_CHOI]]: lịch sử có thể kéo dài hàng trăm, hàng nghìn hoặc hàng vạn năm, hoàn toàn trước khi nhân vật người chơi tồn tại; sau snapshot hiện tại, người chơi mới chọn vị trí trên bản đồ và sinh/nhập thế. Không có cốt truyện chính cố định hoặc “người được chọn” được dành chỗ trong tiền sử.

World genesis chạy theo epoch:

1. cosmology/geology;
2. ecology baseline;
3. population/culture origins;
4. settlement/organization growth;
5. trade/conflict/migration epochs;
6. recent detailed window;
7. current boundary snapshot.

Epoch xa dùng aggregate nhưng phải bảo toàn stock, lineage và biến cố neo. Recent window materialize đủ cho NPC/asset/obligation hiện tại.

## 39. Anchor events

Biến cố neo là sự kiện không được tóm lược mất:

- sinh/chết/di cư quan trọng;
- thành lập/tan rã tổ chức;
- chuyển quyền lớn;
- thiên tai/thay địa hình;
- phát minh/truyền thừa công pháp;
- chiến tranh/hiệp ước;
- nguồn gốc vật/công trình độc nhất;
- sự kiện người chơi/NPC nhớ hoặc còn nghĩa vụ.

Aggregate history phải dẫn lại được tới anchor liên quan.

## 40. Vùng tiềm ẩn và vùng materialize

| Trạng thái | Dữ liệu |
|---|---|
| `LATENT` | seed path, macro constraints, chưa có instance cá thể |
| `SUMMARIZED` | population/resource/organization ledgers và anchors |
| `MATERIALIZING` | staging candidates, chưa công bố |
| `MATERIALIZED` | instance/relations/events canonical |
| `ARCHIVED_DETAIL` | chi tiết lạnh nén nhưng còn phục hồi được |

Không nói NPC cá thể “đã sống đầy đủ” khi vùng mới LATENT. Khi cần promotion, lịch sử được tạo từ macro ledger + seed + anchors, không theo lợi ích hiện tại của người chơi.

## 41. Materialization order independence

Vùng A sinh trước/sau B phải giống nếu cùng inputs và chưa có giao thoa. Giao thoa qua trade/migration/weather/message được ghi bằng boundary ledger/event; nó trở thành input cho cả hai.

Generator không được đọc camera, build máy, thời gian CPU hoặc lựa chọn UI để quyết nội dung.

## 42. Biên vùng và seam reconciliation

Hai vùng chia watershed, route, tổ chức hoặc dòng hàng dùng `BoundaryContract`:

- stable boundary id;
- shared macro facts;
- directional flows;
- time ranges/revisions;
- claims/reservations;
- unresolved conflicts;
- reconciliation rule.

Nếu hai vùng sinh độc lập không khớp, staging phải repair/reject trước publish; không chồng hai con sông hay nhân đoàn buôn.

## 43. Không sinh ngược để chiều người chơi

Khi người chơi hỏi “gần đây có linh dược không”, query chỉ đọc world đã materialize/latent rules theo quyền biết. Nó không sinh một cây thuốc vì mục tiêu đang cần, trừ hệ thống content/quest công khai có event nhân quả hợp lệ.

Discovery làm lộ state; không tạo phần thưởng theo truy vấn.

## 44. Persistent delta

Sau materialization, save giữ:

- generator fingerprints/base hash;
- instance identity và current state;
- mutations khác base;
- anchor events/provenance;
- boundary flows;
- tombstones;
- knowledge/claims/obligations;
- regeneration compatibility data.

Có thể không lưu derived cache hoặc chi tiết reconstructible, nhưng regenerate phải cho cùng canonical result trước khi áp delta.

## 45. Tombstone và không hồi sinh vô ý

Entity bị hủy/chết/tiêu thụ có tombstone hoặc anchor đủ để generator không tạo lại cùng identity. Tombstone lưu id, cause/time, successor/split/merge refs và retention class.

Compaction có thể gộp tombstone khi chứng minh không còn ref/lineage cần thiết; không xóa chỉ vì entity xa người chơi.

## 46. Nội dung thủ công và procedural cùng tồn tại

Tác giả có thể tạo landmark/NPC/công pháp tay bằng cùng blueprint/instance schema, gắn provenance `AUTHORED`. Generator điền vùng xung quanh qua constraints, không được sửa anchor tay.

Nội dung tay cũng phải qua validator; “đặc biệt” không miễn conservation, reference hoặc compatibility trừ khi có luật thế giới rõ.

## 47. Authoring schema và DSL

DSL nội dung tương lai cần:

- kiểu/unit/ref có miền;
- composition/graph;
- constraints và diagnostics;
- deterministic expressions;
- localization keys;
- examples/fixtures;
- migration hooks khai báo;
- cấm I/O, wall-clock, network và RNG ngoài context;
- complexity budgets.

K3.3 chưa chọn YAML/JSON/binary/ngôn ngữ DSL.

## 48. Pipeline biên soạn nội dung

```text
source package
 -> parse/schema
 -> resolve ids/dependencies
 -> unit/type check
 -> graph/constraint check
 -> domain validators
 -> generator sample/property tests
 -> canonical compile
 -> content fingerprint
 -> signed/release manifest nếu cần
```

Runtime chỉ nạp artifact đã compile/validate đúng capability. Dev hot reload không được áp giữa world mutation mà thiếu migration/boundary.

## 49. Validator theo domain

- item: mass/component/capability/process closure;
- body: part graph/function/flow reachability;
- cultivation: energy route/conversion/failure closure;
- NPC: age/timeline/encounter/assets/knowledge consistency;
- society: role/authority/obligation/resource feasibility;
- geography: topology/water/route/boundary consistency;
- ecology: energy/resource/lifecycle feasibility;
- cross-domain: units, references, source/sink, feature guards.

Validator không tự sửa âm thầm. Repair của generator phải tạo trace và validate lại.

## 50. Generator oracle

Không có một expected world duy nhất cho mọi seed. Oracle kiểm:

- determinism cùng seed/version;
- invariants cho mọi sample;
- distribution/property bounds;
- metamorphic relations;
- order/partition independence;
- shrink seed/context khi fail;
- novelty/duplication metrics;
- reachability/playability constraints;
- save/regenerate/delta parity.

Golden fixture chỉ dùng cho seed/case neo, không khóa toàn generator khỏi cải tiến có migration/version.

## 51. Metamorphic tests quan trọng

- sinh A rồi B so B rồi A;
- thêm locale không đổi logic;
- đổi worker/slice không đổi output;
- serialize/load context không đổi kết quả;
- chia region rồi ghép so generation một vùng tương đương;
- tăng budget không làm candidate đã publish đổi;
- query trước/sau không đổi world;
- compact cache không đổi instance;
- materialize xa không đổi vùng không liên quan;
- duplicate authored anchor bị phát hiện.

## 52. Ngân sách nội dung và storage

Theo dõi:

- compiled bytes/definition;
- instance bytes theo domain;
- provenance/tombstone/event bytes;
- generation ms/allocation/rejection rate;
- materialization/promotion latency;
- cache/index size;
- save delta growth/game-year;
- unique mechanisms per MiB;
- authoring/validation time;
- localization growth.

Không tối ưu bằng xóa identity, nghĩa vụ hoặc lịch sử còn ảnh hưởng.

## 53. Trình bày nội dung cho người chơi

UI dùng progressive disclosure:

- tên/mô tả theo tri thức;
- khả năng đã biết và uncertainty;
- nguồn gốc/lịch sử khi được biết;
- so sánh nhiều chiều theo tác vụ;
- lineage công pháp/vật phẩm;
- lý do generator không bao giờ lộ ra như “seed 42” trong gameplay;
- debug provenance chỉ ở chế độ kiểm toán có quyền.

Mô tả văn chương là renderer từ facts/knowledge, không được bịa hậu quả chưa xảy ra.

## 54. Nội dung ngôn ngữ tự nhiên

Template/grammar có thể tạo câu biến thể từ semantic facts. Mô hình ngôn ngữ, nếu dùng sau này, chỉ đề xuất diễn đạt hoặc candidate content qua schema/validator; nó không có quyền commit Fact, item, NPC hoặc công pháp.

Câu đã hiển thị quan trọng có thể lưu semantic message + template/model version để audit. Gameplay phải hoạt động khi không có dịch vụ AI.

## 55. Version và migration nội dung

Thay content chia:

- cosmetic locale/text: không đổi logic hash;
- compatible additive: id mới, không sửa instance cũ;
- rule revision: definition version mới, policy rõ cho world cũ;
- corrective migration: transform có evidence/provenance;
- breaking removal: unsupported cho tới migration, không bỏ record.

World đang tồn tại giữ fingerprints. Update không reroll vùng/công pháp/NPC đã materialize.

## 56. Cổng K3.3

| Gate | Điều kiện | Hiện tại |
|---|---|---|
| K3D01 | definition/blueprint/instance/view tách rõ | đạt trên giấy |
| K3D02 | seed/provenance/order independence rõ | đạt đặc tả |
| K3D03 | taxonomy năm miền chính có kiến trúc | đạt trên giấy |
| K3D04 | latent/summary/materialized/delta rõ | đạt trên giấy |
| K3D05 | schema/DSL máy tồn tại | chưa |
| K3D06 | generator W0 chạy deterministic | chưa code |
| K3D07 | validators/oracles có implementation | chưa code |
| K3D08 | save/regenerate/delta parity | chưa chạy |
| K3D09 | diversity/content budget evidence | chưa chạy |
| K3D10 | W1 An Khê được compile từ pipeline | chưa làm |

Gate không cộng vào điều kiện ND.

## 57. Điều kiện ND01–ND17 — package, identity và provenance

| ID | Điều kiện chưa chạy |
|---|---|
| ND01 | hai package chiếm cùng content id bị từ chối |
| ND02 | load order khác không đổi definition đã resolve |
| ND03 | overlay sai base hash bị từ chối |
| ND04 | đổi tên/locale không đổi content hoặc instance identity |
| ND05 | Definition không chứa owner/location/current damage |
| ND06 | blueprint recursion vượt depth/budget bị từ chối |
| ND07 | materialize cấp id ổn định và initial hash |
| ND08 | load/regenerate không reroll parameters instance |
| ND09 | provenance dẫn tới generator/version/seed path/inputs |
| ND10 | hash collision được phát hiện, không merge entity |
| ND11 | cùng seed path/version cho cùng canonical output |
| ND12 | sinh vùng A/B đảo thứ tự không đổi output độc lập |
| ND13 | RNG stream content không tiêu RNG gameplay |
| ND14 | generator thất bại không publish graph nửa hợp lệ |
| ND15 | hết budget trả DEFERRED/FAILED rõ |
| ND16 | repair tạo trace và chạy lại validator |
| ND17 | generated instance có creation boundary/provenance canonical |

## 58. Điều kiện ND18–ND34 — vật phẩm, công pháp và cơ thể

| ID | Điều kiện chưa chạy |
|---|---|
| ND18 | rarity/giá không được lưu như tính chất vật lý bất biến |
| ND19 | vật phẩm capability suy từ geometry/material/condition |
| ND20 | chất lượng nhiều chiều không bị logic thay bằng một tier |
| ND21 | tách instance khỏi batch giữ provenance và không reroll |
| ND22 | split/merge generated lot giữ conservation |
| ND23 | hai vật cùng blueprint có history/condition riêng |
| ND24 | biến thể vô tác dụng bị diversity audit gắn cờ |
| ND25 | công pháp graph khép route/source/sink/loss |
| ND26 | mutation công pháp giữ lineage và operator trace |
| ND27 | công pháp incompatible body không được tự áp dụng |
| ND28 | bản chép sai khác semantic content dù cùng tên hiển thị |
| ND29 | Pareto audit phát hiện công pháp trội mọi context |
| ND30 | body blueprint resolve part/flow/function graph hợp lệ |
| ND31 | variation cơ thể có nguồn và tác động cấu trúc/chức năng |
| ND32 | đặc điểm cơ thể không tự sinh tính cách/đạo đức |
| ND33 | thương tích generated scenario vẫn qua body solver |
| ND34 | bệnh/độc có đường phơi nhiễm và kinetics hợp lệ |

## 59. Điều kiện ND35–ND51 — NPC, xã hội và thế giới

| ID | Điều kiện chưa chạy |
|---|---|
| ND35 | PersonGenesis khép tuổi, cha mẹ/nguồn gốc, place và household |
| ND36 | quan hệ tiểu sử có encounter/message lineage |
| ND37 | current assets/claims khớp event timeline sinh trước game |
| ND38 | memory seed tách Fact khỏi điều NPC biết |
| ND39 | tên trùng không làm identity trùng hoặc lộ global id |
| ND40 | social graph không sinh N² edge không nguồn |
| ND41 | organization role có authority/resource/succession hợp lệ |
| ND42 | culture không ép mọi thành viên cùng belief/trait |
| ND43 | geology tạo deposit nối đúng material definition |
| ND44 | khai thác làm giảm stock/đổi môi trường, không loot vô hạn |
| ND45 | weather đã tác động được materialize, không reroll |
| ND46 | population cohort promotion tạo cá thể nhất quán macro ledger |
| ND47 | cá thể sinh vật đã materialize giữ identity |
| ND48 | qi source/flow/sink dùng cùng conservation contract |
| ND49 | history aggregate giữ anchor event và stock/lineage |
| ND50 | route/watershed qua biên dùng BoundaryContract duy nhất |
| ND51 | seam conflict bị repair/reject trước publish |

## 60. Điều kiện ND52–ND68 — materialization, pipeline và quy mô

| ID | Điều kiện chưa chạy |
|---|---|
| ND52 | query/discovery không sinh vật cần thiết để chiều mục tiêu |
| ND53 | camera/UI/device speed không ảnh hưởng generation output |
| ND54 | region promotion dùng seed+ledger+anchors, không current player need |
| ND55 | persistent delta áp đúng lên regenerated base hash |
| ND56 | base mismatch dừng/migrate, không áp delta mù |
| ND57 | tombstone ngăn hồi sinh identity đã chết/tiêu thụ |
| ND58 | compaction không xóa tombstone còn reference/lineage |
| ND59 | authored anchor qua cùng domain validators |
| ND60 | generator không sửa authored anchor để repair |
| ND61 | DSL expression không gọi I/O/network/wall-clock/RNG ngoài context |
| ND62 | compiled artifact có canonical fingerprint tái lập |
| ND63 | sample/property test shrink được seed/context lỗi |
| ND64 | thêm locale không đổi logic hash |
| ND65 | tăng worker/slice không đổi generation output |
| ND66 | update content không reroll entity/vùng đã materialize |
| ND67 | diversity report đo mechanism/niche/duplication, không chỉ count |
| ND68 | storage budget không được đạt bằng xóa identity/nghĩa vụ còn ảnh hưởng |

## 61. Truy vết và tổng điều kiện

| Nhóm ND | Nguồn |
|---|---|
| ND01–ND17 | K2 data/save, K3 content port, provenance/determinism |
| ND18–ND34 | [[VAT_PHAM]], [[TU_LUYEN]], [[CO_THE]] |
| ND35–ND51 | [[NPC]], [[MOI_TRUONG]], K1 đời sống/thể chế |
| ND52–ND68 | R0–R4, save delta, validator, performance |

68 ND nâng tổng từ 808 lên **876 điều kiện thiết kế chưa chạy**, thuộc 30 họ.

## 62. Gói dữ liệu máy tương lai

```text
content/
  packages/
  definitions/
  blueprints/
  generators/
  constraints/
  policies/
  locales/
  migrations/
compiled-content/
  manifests/
  artifacts/
  fingerprints/
generation-evidence/
  samples/
  failures/
  distributions/
  seam-tests/
```

Đây là topology khái niệm; chưa tạo thư mục ngoài vault hoặc code.

## 63. Thứ tự hiện thực hóa khi được phép

1. content id/package/schema tối thiểu;
2. definition–blueprint–instance cho V01/V02;
3. canonical seed/provenance;
4. generator W0 thuần và order test;
5. validators vật phẩm/công pháp/cơ thể nhỏ;
6. PersonGenesis ba người;
7. region latent/summary/materialize nhỏ;
8. save base+delta+tombstone;
9. authoring compile pipeline;
10. diversity/budget evidence;
11. chuyển An Khê từ Markdown sang artifact máy;
12. mở rộng domain sau khi W1 đúng.

## 64. Những điều không được tuyên bố

- Không nói có thế giới vô hạn đã tồn tại trong máy.
- Không nói mọi NPC xa đã có đời sống chi tiết nếu chỉ có cohort.
- Không nói hàng triệu vật/công pháp chỉ vì không gian tổ hợp lớn.
- Không nói procedural đồng nghĩa có ý nghĩa.
- Không nói generator deterministic là generator hợp lý.
- Không nói content update an toàn trước migration tests.
- Không nói 876 điều kiện đã chạy.

## 65. Giá trị K3.3 cung cấp thật

- ranh giới rõ giữa luật chung và cá thể sống;
- identity permanence cùng provenance;
- seed phân cấp chống phụ thuộc thứ tự khám phá;
- mô hình tổ hợp cho vật phẩm, công pháp, cơ thể, NPC và vùng;
- lịch sử tiền game có nhân quả;
- cách mở vùng tiềm ẩn mà không bịa theo nhu cầu người chơi;
- pipeline validation và ngân sách nội dung;
- đường lưu base/delta/tombstone lâu dài.

## 66. Vấn đề mở

- hình dạng tọa độ/world topology cụ thể;
- cosmology và quy tắc sinh vùng;
- taxonomy nguyên tố/linh khí;
- species ngoài người;
- độ sâu lịch sử trước game;
- retention class cho cá thể xa;
- mức authored/procedural mong muốn;
- ngôn ngữ/format DSL;
- hard budgets W1–W4;
- phạm vi modding.

Các điểm này được giữ thành policy/schema extension, không chặn kiến trúc chung.

## 67. Quan hệ với tham vọng dài hạn

Chiều sâu vượt các game mô phỏng lớn không đến từ đếm definition. Nó đến từ việc một thay đổi vật chất, cơ thể, tri thức, quan hệ và lịch sử cùng để lại hậu quả có thể truy vết. Kiến trúc K3.3 ưu tiên mật độ tương tác nhân quả trước rồi mới mở rộng số lượng.

Phạm vi nhỏ ban đầu vẫn chỉ là lát cắt kiểm chứng. Generator và package model được thiết kế để mở rộng lâu dài, không khóa thế giới vào An Khê.

## 68. Bước tiếp theo

K3.4 nay đã được cụ thể hóa tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
