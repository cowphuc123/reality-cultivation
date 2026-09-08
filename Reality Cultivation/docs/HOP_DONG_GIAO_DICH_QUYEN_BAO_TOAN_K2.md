---
title: Hợp đồng giao dịch, quyền và bảo toàn vật chất — K2.3
aliases:
  - K2.3
  - Giao dịch và bảo toàn
tags:
  - reality-cultivation
  - thiet-ke
  - giao-dich
  - quyen
  - vat-chat
status: de-xuat
updated: 2026-09-06
---

# Hợp đồng giao dịch, quyền và bảo toàn vật chất — K2.3

Tài liệu này cụ thể hóa Transaction/Right/Item/Lot của [[TU_DIEN_DU_LIEU_HOP_DONG_TRANG_THAI_K2]] và pha tranh nguồn–cam kết trong [[HOP_DONG_LAP_LICH_XU_LY_SU_KIEN_K2]]. Nó nối nền vật phẩm [[VAT_PHAM]], kinh tế–tổ chức [[KINH_TE_TO_CHUC]], tồn kho [[DU_LIEU_KHOI_DAU]], tiền vật chất [[DU_LIEU_LIEN_KET_K0]] và sổ thể chế [[SO_THE_CHE_30_NGAY_K1]].

Đây là hợp đồng thiết kế chưa triển khai. Chế độ sở hữu, luật, tiền tệ, giá, thuế và thể chế của thế giới lớn vẫn chưa được người dùng chốt. Fixture An Khê chỉ cung cấp dữ liệu thử.

## 1. Sáu nguyên tắc không được phá

1. Vật chất có danh tính, lượng, vị trí, người giữ và lịch sử nguồn.
2. Sở hữu, giữ hộ, kiểm soát vật lý và quyền sử dụng là các quan hệ khác nhau.
3. Đề nghị, dự kiến, Reservation và giao dịch đã cam kết là bốn trạng thái khác nhau.
4. Transaction cam kết toàn bộ hoặc không đổi gì.
5. Biến đổi phải chỉ ra đầu vào, đầu ra, phần dư, phế phẩm và đích thất thoát.
6. Sổ/biên nhận mô tả giao dịch; chúng không tự chuyển vật hoặc tạo quyền.

Giá trị kinh tế và cảm nhận công bằng không phải đại lượng bảo toàn. Một món có thể tăng giá mà không sinh thêm vật; một giao dịch hợp lệ về vật lý vẫn có thể vi phạm luật hoặc hợp đồng.

## 2. Ba lớp của một hành vi chuyển tài sản

| Lớp | Câu hỏi | Kết quả |
|---|---|---|
| `PhysicalFeasibility` | người/vật có ở đúng chỗ, có thể cầm/chuyển không? | Action/Mutation có thể xảy ra |
| `OperationalAuthorization` | khóa, người gác, chứng từ hoặc cơ chế tại chỗ có cho qua không? | chặn hoặc cho thao tác thực tế |
| `NormativeValidity` | theo quyền/luật/hợp đồng được công nhận, hành vi có hợp lệ không? | ownership/right/violation/dispute |

Không dùng `Right=false` như tường phép thuật chung. Nếu kho không có khóa/người ngăn, một người có thể lấy vật dù không có quyền: Position/Custody đổi, ownership không tự đổi, và có thể tạo ViolationFact. Người khác chỉ biết khi quan sát, kiểm kê hoặc nhận tin.

Ngược lại, giấy tờ hết hiệu lực nhưng người giữ kho chưa biết có thể khiến giao dịch vật lý được thực hiện theo OperationalAuthorization cũ; NormativeValidity ghi tranh chấp để xử sau.

## 3. AssetRef và QuantitySpec

`AssetRef` là `OneOf<Item,Lot,ResourcePool,OwnershipInterest,Right,Claim,ContractualEntitlement>`. Mỗi loại có quy tắc chuyển riêng; không truyền `Text` tên món vào Transaction.

| Trường QuantitySpec | Ý nghĩa |
|---|---|
| `quantity_kind` | DISCRETE/MASS/VOLUME/LENGTH/ENERGY/SHARE |
| `unit` | đơn vị chuẩn theo K2.1 |
| `amount` | số nguyên không âm |
| `item_type/material_filter` | loại được phép |
| `quality_predicate` | yêu cầu đa chiều có schema |
| `identity_requirement` | đúng item/lot hay bất kỳ vật tương đương |
| `rounding_rule` | chỉ có khi luật cho phép chia |

Không dùng “một ít”, “đủ tốt” hoặc “tương đương” làm điều kiện máy nếu chưa có Predicate định nghĩa.

## 4. Item, Lot và ResourcePool dùng khi nào

| Dạng | Dùng khi | Không dùng khi |
|---|---|---|
| `ItemInstance` | vật cá thể, cấu tạo, hao mòn, lịch sử riêng | hàng rời đồng nhất chỉ cần lượng |
| `Lot` | cùng type/composition/quality/provenance và một Position | từng cá thể khác tình trạng hoặc vị trí |
| `ResourcePool` | nước nguồn, linh khí, sinh khối chưa cá thể hóa | hàng đã đóng gói/có quyền sở hữu riêng |

Một Lot phải tách trước khi các phần có owner, Position, quality hoặc lịch sử khác nhau. Không gộp lại chỉ vì cùng ItemType nếu provenance/quality quan trọng đã khác.

## 5. OwnershipInterest

| Trường | Kiểu/ý nghĩa |
|---|---|
| `asset_ref` | tài sản được yêu sách |
| `holder_ref` | Person/Household/Organization |
| `interest_kind` | TITLE/SHARED_TITLE/SECURITY/USUFRUCT… |
| `share` | phần nguyên có mẫu số chuẩn nếu đồng sở hữu |
| `scope` | toàn vật, phần lượng, công dụng hoặc thời gian |
| `recognized_by` | thể chế/quy tắc công nhận |
| `source_ref` | Transaction/Inheritance/Ruling/Init |
| `valid_interval` | `[start,end)` |
| `status` | CLAIMED/RECOGNIZED/CONTESTED/ENDED |

Tổng share của các title được cùng một thể chế công nhận không vượt 100%. Nhiều thể chế có thể công nhận khác nhau; đó là tranh chấp, không nhân đôi vật.

Fixture K1 dùng một owner chính cho phần lớn tài sản. Cấu trúc rộng hơn chỉ chuẩn bị cho thừa kế, góp vốn và tranh chấp sau này.

## 6. Custody, possession, control và Position

| Quan hệ | Ý nghĩa |
|---|---|
| `Custody` | ai nhận trách nhiệm giữ/chăm nom theo thỏa thuận |
| `Possession` | ai đang chiếm hữu trực tiếp theo trạng thái vật lý |
| `ControlCapability` | ai có thể mở, dùng, ra lệnh cho cơ chế ở mốc đó |
| `Position` | vật thật ở đâu/trong gì/gắn vào đâu |

N05 chở hàng có Custody/Possession nhưng hàng có thể vẫn thuộc O04 cho tới giao. N06 giữ V34 trên khung tin không sở hữu nội dung. Một vật trong phòng của owner nhưng bị khóa bởi người khác có Position gần owner mà ControlCapability khác.

Mỗi thay đổi quan hệ có nguồn riêng; không suy tất cả từ `holder_id` duy nhất.

## 7. Claim và tranh chấp

Claim là lời yêu sách có claimant, asset/scope, basis, evidence refs, filed_at, recognition status và đối thủ. Claim không đổi ownership trước khi rule/ruling/transaction có thẩm quyền thực hiện.

Khi hai Claim xung đột:

- vật vẫn có một Position và lượng thật;
- mỗi thể chế/người có thể có Belief khác về chủ hợp pháp;
- giao dịch mới kiểm cả OperationalAuthorization lẫn NormativeValidity;
- có thể tạo encumbrance chặn chuyển quyền được công nhận nhưng không dịch chuyển vật từ xa;
- phán quyết kết thúc/ưu tiên Claim bằng event, không tạo bản sao tài sản.

## 8. RightGrant có phạm vi

| Trường | Ý nghĩa |
|---|---|
| `holder` | người, role hoặc tổ chức |
| `action_set` | xem/giữ/dùng/chuyển/chi/duyệt/ủy quyền… |
| `target_scope` | asset, loại, kho, tổ chức hoặc Predicate |
| `purpose_scope` | mục đích được phép |
| `per_transaction_limit` | giới hạn một lần |
| `period_limit` | giới hạn cộng dồn trong kỳ |
| `valid_interval` | thời gian hiệu lực |
| `authority_source` | owner/rule/ruling/contract |
| `delegation_policy` | có thể ủy quyền gì |
| `recognition_scope` | ai công nhận |
| `enforcement_mode` | NORMATIVE/CREDENTIAL/PHYSICAL_LOCK |

Quyền O06 của N18 tối đa 20 V01 không cho phép chia một khoản 32 thành hai giao dịch giả để lách nếu `period/purpose/linked_plan` vẫn cùng một quyết định.

## 9. Đánh giá quyền tại mốc thực hiện

`AuthorizationEvaluation` có:

| Trường | Nội dung |
|---|---|
| `actor`, `action`, `target`, `purpose`, `quantity` | yêu cầu cụ thể |
| `evaluated_at` | mốc pha 30 |
| `right_candidates` | các RightGrant phù hợp actor biết/xuất trình |
| `objective_right_status` | VALID/INVALID/CONTESTED/UNRESOLVED |
| `operational_status` | ALLOWED/BLOCKED/BYPASSED/NOT_ENFORCED |
| `evidence_presented` | chìa khóa, dấu, người duyệt, Message… |
| `limits_before/after` | mức đã dùng trong kỳ |
| `decision_code` | lý do có cấu trúc |

Quyền được kiểm lại lúc commit; quyền hợp lệ khi lập kế hoạch không giữ mãi nếu hết hạn/revoked. Knowledge về quyền của actor nằm ở Belief, không được Transaction engine đưa ngược bí mật vào DecisionFrame.

## 10. Ủy quyền, thu hồi và thay vai trò

Delegation tạo RightGrant con trỏ parent, scope không rộng hơn, interval không dài hơn và depth có giới hạn. Thu hồi quyền cha xử lý quyền con theo policy đã ghi; không để quyền mồ côi tiếp tục vô hạn.

Thu hồi có hai thời điểm:

- `normative_effective_at`: lúc quyền chính thức hết;
- `notice_received_at`: lúc người thực thi biết hoặc credential được vô hiệu.

Khoảng giữa hai mốc có thể sinh giao dịch bị tranh chấp. Nếu cơ chế khóa trung tâm thật sự cập nhật tức thời, OperationalAuthorization có thể chặn; nếu không, luật không tự tác động vật lý từ xa.

## 11. Offer, Acceptance và Contract

Offer có offeror có quyền, terms version, đối tượng, giá/đổi, deadline, revocation policy và actual recipients. Acceptance phải:

- trỏ đúng offer/version;
- tới trước hạn và sau khi người nhận thực sự nhận;
- không sửa điều khoản; sửa là counteroffer;
- do người/đại diện có quyền;
- tạo Contract đúng một lần bằng idempotency key.

Contract có parties, terms, effective interval, obligations, acceptance/authority evidence, amendment chain, dispute policy và status. Văn bản câu “đồng ý” không đủ nếu DialogueAct payload hoặc quyền đại diện không hợp lệ.

## 12. Obligation và nghiệm thu

| Trường | Ý nghĩa |
|---|---|
| `debtor`, `beneficiary` | bên phải làm và bên hưởng |
| `deliverable` | Asset/Service/State Predicate |
| `quantity/quality` | yêu cầu định lượng |
| `due_condition` | instant/window/event/predicate |
| `acceptance_authority` | ai được nghiệm thu |
| `performance_refs` | Action/Transaction/Fact đã thực hiện |
| `fulfilled_amount` | tiến độ nghiệp vụ, không là tài sản |
| `status` | PENDING/PARTIAL/FULFILLED/BREACHED/WAIVED/DISPUTED |
| `remedy_refs` | nghĩa vụ bù/phạt được tạo hợp lệ |

Nghiệm thu không tạo sản phẩm đã thiếu. Nó xác nhận deliverable thật và có thể mở nghĩa vụ thanh toán. Nghĩa vụ C01 không chứa 12 V01; thanh toán mới chuyển đồng.

## 13. Transaction lifecycle

```text
DRAFT → PROPOSED → VALIDATING
  ├─ REJECTED
  ├─ WAITING_FOR_AUTHORITY
  ├─ WAITING_FOR_RESOURCE
  └─ RESERVED → READY_TO_COMMIT → COMMITTED
COMMITTED → COMPENSATED_BY(new transaction)
PROPOSED/RESERVED → EXPIRED/CANCELLED
```

Chỉ COMMITTED đổi state thật. `RESERVED` chỉ giữ khả dụng. Không chuyển transaction COMMITTED về DRAFT; sửa hậu quả dùng transaction mới.

## 14. TransactionPlan

| Trường | Kiểu/ý nghĩa |
|---|---|
| `transaction_id`, `idempotency_key` | danh tính/chống lặp |
| `transaction_type/version` | PURCHASE, TRANSFER, CONSUME, PRODUCE, PAY… |
| `initiator`, `participants` | actor và bên liên quan |
| `caused_by/correlation_id` | Goal/Action/Contract/Event |
| `effective_at/phase` | mốc pha 50 |
| `asset_legs` | nguồn, đích, AssetRef, quantity |
| `right_evaluations` | bằng chứng quyền/operational gate |
| `expected_revisions` | mọi record sẽ sửa |
| `preconditions` | Predicate có schema |
| `reservation_refs` | giữ chỗ liên quan |
| `mutations` | thay đổi dự kiến |
| `conservation_equations` | các sổ phải cân |
| `obligation_updates` | chỉ sau performance đúng |
| `fact/output_contract` | FactEvent và tín hiệu có thể sinh |

TransactionPlan đóng băng khi vào READY_TO_COMMIT. Thay asset, giá hoặc bên tham gia cần plan/revision mới.

## 15. Thứ tự validation

1. Shape/type/unit và feature support.
2. ID/ref tồn tại, lifecycle và schema/ruleset tương thích.
3. Thời điểm/pha/idempotency key.
4. Expected revision.
5. Position, reach, container/component feasibility.
6. OperationalAuthorization.
7. NormativeValidity và quyền/limit.
8. Contract/Obligation/acceptance conditions.
9. Reservation ownership, status và expiry.
10. Quantity, quality, capacity, divisibility.
11. ConflictSet/arbitration.
12. Conservation equations và invariant sau mutation.

Lỗi sớm không được rò giá trị bí mật qua viewer explanation. Audit có thể ghi đầy đủ.

## 16. Reservation

| Trường | Ý nghĩa |
|---|---|
| `reservation_id` | danh tính |
| `asset/source_ref` | vật/lot/pool/quyền/capability |
| `quantity/scope` | phần giữ |
| `holder/purpose` | ai giữ cho việc gì |
| `priority_basis` | Contract/Right/ConflictPolicy |
| `created/expires_at` | interval |
| `status` | ACTIVE/CONSUMED/RELEASED/EXPIRED/INVALIDATED |
| `expected_asset_revision` | stale guard |
| `group_id` | nhiều nguồn phải được giữ cùng nhau |

ReservationGroup cho giao dịch nhiều nguồn phải giữ tất cả hoặc không giữ gì. Không giữ tiền rồi chờ hàng vô hạn. Hết hạn tạo event pha 20 và trả lượng về available; ownership/quantity tổng không đổi.

## 17. Available, reserved và committed

Với một asset chia được:

`available = total_present − active_reserved − committed_out_not_yet_reflected`

Trong thiết kế này, commit pha 50 phản ánh ngay vào state nên vế cuối thường bằng 0 ở BOUNDARY. Nó chỉ tồn tại trong batch nội bộ và không được serialize như số dư độc lập.

Không lưu `available` làm nguồn thật nếu có thể tính từ lot/pool + reservations. Cache phải có input revision digest.

## 18. ConflictPolicy

| Policy | Điều kiện dùng | Kết quả |
|---|---|---|
| `EXPLICIT_RIGHT_PRIORITY` | quyền có thứ bậc rõ | chọn quyền cao hơn |
| `EARLIEST_VALID_COMMITMENT` | thời điểm cam kết được chứng minh | cam kết hợp lệ sớm hơn |
| `ROTATION_CURSOR` | nguồn có chính sách luân phiên | dùng cursor lưu trong state |
| `PROPORTIONAL_SHARE` | vật chia được và rule cho phép | chia lượng bằng số nguyên + remainder |
| `LOTTERY_DRAW` | thể chế cho phép | RNG stream có log |
| `REJECT_UNRESOLVED` | không có rule | tất cả chờ/từ chối, không dùng id |

Giá cao hơn, quan hệ tốt hơn hoặc nhu cầu nặng hơn chỉ có hiệu lực nếu policy nguồn/thể chế khai báo; không phải ưu tiên bí mật của engine.

## 19. Commit nguyên tử

Pha 50:

1. Khóa logical write set theo input batch, không theo thứ tự id nghiệp vụ.
2. Kiểm lại expected revision, reservation và right evaluation có thời hạn.
3. Tạo before digest.
4. Áp toàn bộ mutation vào bản nháp cô lập.
5. Kiểm invariant/conservation trên bản nháp.
6. Nếu đạt, xuất toàn bộ revision mới + FactEvent + after digest.
7. Nếu lỗi, bỏ bản nháp; state trước commit không đổi.

Cách khóa/copy cụ thể là lựa chọn triển khai. Hợp đồng chỉ yêu cầu kết quả quan sát tương đương commit nguyên tử.

## 20. Mutation registry

| Mutation | Thay đổi được phép |
|---|---|
| `MOVE_POSITION` | một Position cũ→mới |
| `TRANSFER_TITLE` | OwnershipInterest theo scope |
| `CHANGE_CUSTODY/POSSESSION` | quan hệ giữ/chiếm hữu |
| `ADJUST_POOL` | quantity nguồn theo leg hợp lệ |
| `SPLIT_LOT/MERGE_LOTS` | identity/provenance + lượng |
| `CREATE/END_ITEM` | nguồn/sink hoặc transformation |
| `ATTACH/DETACH_COMPONENT` | cấu tạo và Position |
| `CHANGE_CONDITION/QUALITY` | process/evidence có version |
| `GRANT/REVOKE_RIGHT` | state thể chế, không là vật |
| `CREATE/UPDATE_OBLIGATION` | tiến độ cam kết |
| `CREATE_LEDGER_ENTRY` | chỉ trỏ transaction/event |

Mỗi mutation type có validator và conservation effect riêng. Không cho plugin/nội dung gọi `set arbitrary field` trong gameplay.

## 21. Split Lot

Split cần source lot, expected revision, danh sách child quantity, phân phối composition/quality/provenance và remainder. Bất biến:

- tổng child + explicit loss = source quantity;
- source kết thúc hoặc còn remainder rõ;
- mỗi child có Position/owner/custody kế thừa hoặc thay có leg;
- thuộc tính không phân chia được phải có rule;
- id child suy từ transaction/counter, không phụ thuộc thứ tự Map.

Tách 30 V02 khỏi lô ruộng không tạo thêm 30 suất khi nghiệm thu hoặc tải lại.

## 22. Merge Lot

Chỉ merge khi cùng item type, unit, Position logic, owner/custody tương thích và policy cho phép gộp provenance/quality. Kết quả giữ:

- tổng lượng;
- tập source lots hoặc digest tóm lược không mất nguồn cần thiết;
- quality distribution thay vì lấy trung bình làm mất cực trị;
- contamination/expiry xấu hơn theo rule, không “rửa sạch” bằng gộp.

Không merge tiền/vật đang bị reservation khác scope nếu không chuyển Reservation an toàn.

## 23. Container và component

Thêm/di chuyển vật vào container kiểm:

- container tồn tại, mở/tiếp cận được;
- actor có khả năng vật lý/OperationalAuthorization;
- type/shape tương thích;
- mass/volume/slot capacity sau commit;
- không tạo vòng chứa;
- child mất Position độc lập và dùng IN_CONTAINER;
- owner không đổi nếu mutation không chỉ rõ.

Component attach khác containment: nó có slot, orientation, compatibility, fastener và condition. V24 lắp vào V23 không còn là bánh rời nhưng vẫn có identity/provenance.

## 24. ConservationDomain và Equation

| Trường | Ý nghĩa |
|---|---|
| `domain_id/version` | COIN_COUNT, MASS, WATER_VOLUME, SPIRIT… |
| `scope` | world/closed fixture/process boundary |
| `unit` | một đơn vị chuẩn |
| `input_legs` | asset/source quantities |
| `output_legs` | asset/destination quantities |
| `source_terms` | nguồn được phép tạo |
| `sink_terms` | đích tiêu thụ/thất thoát |
| `remainder_terms` | phần dư số nguyên |
| `equation` | input+source = output+sink+remainder |
| `tolerance` | 0 cho fixture integer trừ khi rule công bố khác |

Không bắt giá trị tiền hay số record phải bảo toàn. Bảo toàn áp theo đại lượng vật lý/logic được đăng ký.

## 25. Source và Sink

Tạo vật cần SourceRecord: nguồn môi trường, sinh trưởng, khai thác, sản xuất từ input hoặc mint có thẩm quyền. Tiêu thụ/phá hủy cần SinkRecord: ăn, đốt, rơi khỏi phạm vi, chất thải, tiêu tán năng lượng.

`OUT_OF_WORLD` không có nghĩa xóa lịch sử. Nó ghi reason, quantity/composition, event và sink. Nếu sản phẩm biến thành chất khác, dùng transformation outputs chứ không gọi toàn bộ “mất”.

Source/Sink chưa có mô hình phải bị UnsupportedGuard; không dùng `spawn/despawn` chung trong luật gameplay.

## 26. Recipe/TransformationContract

| Trường | Nội dung |
|---|---|
| `recipe_id/version` | quy trình cụ thể |
| `input_specs` | item/lot/pool + quantity/quality |
| `tool/capability requirements` | không tiêu nếu chỉ dùng |
| `process/action refs` | thời gian/thao tác thật |
| `yield_function` | số nguyên, inputs/remainders/RNG rõ |
| `output_specs` | sản phẩm, phụ phẩm, chất thải |
| `condition_transfer` | quality/contamination/provenance |
| `commit_points` | khi nào input tiêu và output tạo |
| `interrupt_outcomes` | bán thành phẩm/phế phẩm |

Recipe không tự chạy khi chỉ có nguyên liệu. Nghiệm thu sau sản xuất không tạo output lần hai.

## 27. V01 và thanh toán

V01 là Item/Lot rời; tổng 2.000 trong fixture đóng. Purchase có ít nhất hai nhóm leg cùng transaction:

- V01 từ buyer ownership/possession sang seller;
- hàng từ seller ownership sang buyer;
- Position/Custody thay theo giao ngay hoặc giao sau.

“Số dư” là Projection. V33 là container, không phải tài khoản tạo tiền. Ba đồng vượt túi P00 phải có Position trong V13.

Thế giới lớn có thể có mint/demonetization nhưng cần Source/Sink và authority riêng; K2.3 không tự chọn hệ tiền tệ.

## 28. Nước, linh lực và nguồn chia được

Lấy nước từ D11 là Transaction/Process giữa ResourcePool và V12, kiểm capacity, Position, quyền tiếp cận và WaterVolume. Uống chuyển nước từ container sang body process/sink; không chỉ giảm thanh khát.

Linh lực dùng SpiritQuantity và pool/tuyến riêng, không cộng với ml nước. Hấp thu/chuyển hóa ghi source, destination, loss và remainder. Hiệu ứng chưa định lượng không được tiêu linh lực rồi kể kết quả tùy ý.

## 29. Dùng, hao mòn, sửa và phá hủy

Sử dụng có thể đổi condition/quality mà không đổi owner. WearProcess trỏ Action/contact/load/environment và rule version. Sửa chữa:

- không đặt condition về mới nếu recipe không cho;
- tiêu vật tư/phụ tùng thật;
- giữ lịch sử component cũ/mới;
- tạo phế phẩm hoặc sink;
- không nhân V24 khi tháo/lắp bánh V23.

Phá hủy kết thúc identity vật nhưng giữ vật liệu còn lại theo outputs. “Hỏng” có thể vẫn tồn tại và dùng cho mục đích khác.

## 30. Dịch vụ và giao dịch phi vật chất

Dịch vụ không tạo Item giả. Transaction dịch vụ trỏ Action/FactEvidence và cập nhật Obligation/Right/Knowledge theo contract:

- dạy J05 cần N13/P00 cùng thời gian, acceptance và Practice/Knowledge evidence;
- vận chuyển J07 cần giao vật thật/ProofOfDelivery;
- nghiệm thu J01 cần đúng lô, lượng và authority;
- quyền học/role được GRANT bằng institutional mutation, không là “vật vô hình” cộng kho.

Thanh toán dịch vụ có thể là transaction riêng sau khi nghĩa vụ performance đạt, liên kết cùng correlation.

## 31. Giao ngay, giao sau và rủi ro mất hàng

Contract terms phải tách:

- `title_transfer_condition`;
- `custody_transfer_condition`;
- `delivery_acceptance_condition`;
- `risk_of_loss_holder` theo interval;
- `payment_condition`;
- `return/rejection policy`.

Trả trước giao sau chuyển tiền nhưng tạo obligation giao; không cấp hàng ngay. Hàng bán nhưng đang trên xe có owner/custody/Position theo terms. Mất hàng không tự xóa mọi nghĩa vụ; remedy theo risk/dispute policy.

## 32. Nợ, trả một phần và giao dịch bù

Debt/Obligation giữ principal/deliverable còn lại, không là tiền âm. Trả một phần:

1. chuyển V01/vật thật;
2. cập nhật fulfilled amount trong cùng atomic group;
3. giữ balance suy ra từ obligation, không tạo ví nợ thứ hai;
4. tạo Receipt/LedgerEntry trỏ Transaction.

Sai giao dịch đã commit được sửa bằng CompensationTransaction có `compensates_id`, quyền và nguồn thật. Nếu người nhận đã tiêu tiền/hàng, không thể rollback thần kỳ; có thể tạo nghĩa vụ hoàn trả/tranh chấp.

## 33. LedgerEntry, receipt và kiểm kê

LedgerEntry có institution, type, transaction/event/contract ref, recorded_by/at, physical carrier, revision/supersedes và status. Nó là bằng chứng/báo cáo, không là state tài sản.

Kiểm kê tạo Observation/CountAttempt với phạm vi, phương pháp, skill, vật thấy và sai số. Lệch sổ–kho tạo Belief/InvestigationGoal; không tự chỉnh kho theo con số trên giấy.

Biên nhận mất không xóa Transaction. Biên nhận giả có physical record/provenance nhưng không tạo payment thật.

## 34. Trộm, gian lận, nhầm lẫn và biển thủ

| Trường hợp | State thật |
|---|---|
| Trộm vật | Position/Possession đổi; title thường giữ nguyên; ViolationFact nếu rule nhận diện |
| Biển thủ | người có OperationalAccess dùng ngoài purpose; ownership tổ chức không tự đổi |
| Báo kho sai | Message/LedgerEntry sai; quantity thật giữ nguyên |
| Đưa nhầm vật | asset thật chuyển; obligation có thể chưa fulfilled |
| Bán không có quyền | vật có thể giao về vật lý; title/normative status contested |
| Tiền giả | Item type/provenance khác; chỉ được chấp nhận nếu người nhận tin nhầm |

Phát hiện thủ phạm là chuỗi Observation/Belief/Investigation, không phải hệ Transaction thông báo toàn tri.

## 35. Vùng xa và giao dịch liên vùng

Ở R-level thấp, aggregate vẫn phải giữ tổng asset theo owner/region, obligations, reservations, shipments, source/sink và conservation digest. Giao dịch xuyên vùng có shipment identity, custody, route/process và mốc chuyển title/risk.

Trước khi hai aggregate tranh cùng vật cá thể hoặc gặp P00, nâng mức trước event. Không materialize một món đã bán/mất hai lần ở hai vùng. Sai số aggregate không được áp cho V01, vật độc nhất, Contract sống hoặc người đang nguy cấp nếu invariant yêu cầu chính xác.

## 36. View và bảo mật thông tin

Viewer thấy:

- tài sản/quyền/nghĩa vụ mình biết;
- offer và giá đã nhận, có timestamp/source;
- tồn kho người khác theo Observation/Message, có thể cũ/sai;
- failure explanation không vượt tri thức.

Audit view thấy title, custody, Position, quantity, right evaluation, transaction legs và conservation equation. Mở audit view không tạo Knowledge gameplay.

## 37. Save/load, replay và migration

Snapshot phải giữ transaction state, reservation expiry, obligation progress, right interval/usage counters, ownership/custody/position, lot provenance, applied idempotency keys và conservation digests.

Replay từ cùng boundary không commit lại Transaction. Migration:

- không gộp lot làm mất provenance sống;
- không đổi owner vì tên role thay;
- không tạo receipt thay cho transaction thiếu;
- không tự cân sổ bằng source/sink giả;
- báo lỗi nếu contract mới không biểu diễn được state cũ.

## 38. Mã lỗi giao dịch

| Mã | Ý nghĩa |
|---|---|
| `ASSET_NOT_FOUND/WRONG_KIND` | ref thiếu hoặc sai domain |
| `STALE_ASSET_REVISION` | asset đổi sau plan |
| `INSUFFICIENT_AVAILABLE` | lượng rảnh không đủ |
| `QUALITY_MISMATCH` | không đạt predicate |
| `DIVISIBILITY_VIOLATION` | chia sai bước/whole-only |
| `POSITION_UNREACHABLE` | không thể tiếp cận vật |
| `OPERATIONALLY_BLOCKED` | khóa/người/cơ chế chặn |
| `RIGHT_INVALID/OUT_OF_SCOPE` | thiếu quyền chuẩn tắc |
| `LIMIT_EXCEEDED` | vượt hạn lần/kỳ/purpose |
| `RESERVATION_CONFLICT/EXPIRED` | giữ chỗ không hợp lệ |
| `CONTRACT_CONDITION_FALSE` | chưa đủ điều kiện nghĩa vụ |
| `UNRESOLVED_CONFLICT` | thiếu policy phân xử |
| `CONSERVATION_FAILED` | equation không cân |
| `CONTAINER_CYCLE/CAPACITY` | vòng chứa hoặc quá tải |
| `ALREADY_COMMITTED` | idempotency key đã có |
| `FEATURE_UNSUPPORTED` | thiếu hợp đồng dữ liệu |

Viewer explanation được lọc; audit error giữ field/ref/expected/actual.

## 39. Sáu walkthrough chuẩn

### 39.1 P00 mua hai V02 giá bốn V01

Pha 30 kiểm P00/N06 ở D01, offer còn hiệu lực, hai V02 available, bốn V01 P00 có Position và quyền. Một Transaction pha 50 chuyển title/possession/Position của hai V02 và bốn đồng theo hai chiều. Tổng V01/V02 không đổi; LedgerEntry nếu viết sau chỉ trỏ transaction.

### 39.2 J01 sản xuất và trả công

ProductionTransaction kết thúc Action tạo 30 V02 từ lô sinh khối theo recipe/conservation. N12 nghiệm thu đúng lot mở PaymentObligation. PaymentTransaction riêng chuyển 8 V01 từ H02 sang P00. Tải lại không tạo thêm sản phẩm hoặc công.

### 39.3 C01 ngày 10

C01 đã tồn tại như Obligation 12 V01. N02 mang đồng thật tới O01; payment commit chuyển V01 và cập nhật obligation FULFILLED. Biên nhận thất lạc chỉ đổi evidence vật lý, không mở lại nợ hay đảo tiền.

### 39.4 N05 chở hàng

Khi nhận kiện, Custody/Possession và Position chuyển sang N05/V23; title/risk theo terms. Khi giao và nghiệm thu, title/custody/payment đổi ở mốc riêng. Xe hỏng giữa đường không dịch hàng về kho và không tự hoàn tiền.

### 39.5 B-CARE dùng băng

V05 tiếp xúc vết thương rồi chuyển condition/type lifecycle sang V06 theo transformation. Hủy chăm sóc sau tiếp xúc không trả lại V05 sạch. Dịch cơ thể đi vào các đích đã khai báo; conservation giữ tổng fixture.

### 39.6 O06 cần chi 32 V01

RightGrant thường của N18 giới hạn 20. Plan 32 bị WAITING_FOR_AUTHORITY, không chia giả. Evidence kiểm cầu + Ruling hợp lệ có thể tạo RightGrant/approval riêng; sau đó Transaction mới kiểm lại quỹ, vật tư, người bán và commit. Ruling không tự sửa cầu hay sinh V24.

## 40. Điều kiện giao dịch GV01–GV40

Các điều kiện mới đã định nghĩa nhưng chưa chạy:

1. GV01 — AssetRef sai domain hoặc thiếu record làm plan bị từ chối rõ.
2. GV02 — QuantitySpec sai unit không được chuyển đổi ngầm.
3. GV03 — Một vật có thể đổi custody/Position mà title không tự đổi.
4. GV04 — Nhiều Claim không nhân đôi asset/quantity.
5. GV05 — Tổng share title cùng recognition scope không vượt 100%.
6. GV06 — Right đúng actor nhưng sai target/purpose/time vẫn bị OUT_OF_SCOPE.
7. GV07 — Hạn per-transaction/period không bị lách bằng chia plan liên kết.
8. GV08 — Thu hồi quyền chuẩn tắc và thông báo thực thi giữ hai mốc riêng.
9. GV09 — Delegation con không rộng/dài hơn quyền cha.
10. GV10 — Acceptance sai offer version hoặc đến sau hạn không tạo Contract.
11. GV11 — Counteroffer không bị hiểu thành Acceptance.
12. GV12 — Nghiệm thu chỉ cập nhật Obligation khi deliverable thật đạt.
13. GV13 — Transaction chưa COMMITTED không đổi asset state.
14. GV14 — Expected revision sai làm toàn plan thất bại, không áp một phần.
15. GV15 — ReservationGroup nhiều nguồn giữ tất cả hoặc không giữ gì.
16. GV16 — Reservation hết hạn trả available nhưng không đổi total/title.
17. GV17 — Available là projection có revision, không là kho thứ hai.
18. GV18 — ConflictPolicy thiếu không dùng id nhỏ làm người thắng.
19. GV19 — Hai người tranh món cuối chỉ một Transaction được commit.
20. GV20 — Atomic commit thất bại conservation giữ state trước nguyên vẹn.
21. GV21 — Transaction bù giữ transaction gốc và cần nguồn hoàn trả thật.
22. GV22 — Mutation lạ không được phép sửa field gameplay tùy ý.
23. GV23 — Split lot bảo toàn lượng, quality/provenance và Position từng child.
24. GV24 — Merge lot không xóa contamination/expiry/provenance cần giữ.
25. GV25 — Container không vòng, không vượt capacity và child có một Position.
26. GV26 — Attach V24 vào V23 không để cùng bánh tồn tại như vật rời.
27. GV27 — Mọi transformation cân input+source với output+sink+remainder.
28. GV28 — Tạo/phá vật cần Source/Sink có event, không spawn/despawn chung.
29. GV29 — V01 là vật thật; số dư/V33/sổ không tạo bản sao tiền.
30. GV30 — Purchase giao ngay chuyển tiền và hàng cùng atomic group.
31. GV31 — Trả trước giao sau tạo Obligation, không cấp hàng tức thì.
32. GV32 — ResourcePool nước và linh lực không trộn unit hoặc ledger.
33. GV33 — Dùng/sửa/phá vật giữ phế phẩm, component và condition có nguồn.
34. GV34 — Dịch vụ chỉ hoàn tất khi có Action/Fact evidence, không tạo item giả.
35. GV35 — Trả nợ một phần chuyển asset thật và cập nhật một balance nghĩa vụ.
36. GV36 — LedgerEntry/receipt thiếu Transaction không đổi tài sản.
37. GV37 — Trộm có thể đổi possession/Position nhưng không tự đổi title.
38. GV38 — Báo kho sai đổi Belief/sổ, không đổi quantity thật.
39. GV39 — Save/load không commit lại transaction/reservation đã kết thúc.
40. GV40 — Cùng input/seed/policy cho cùng transaction legs và conservation digest trên điện thoại/máy tính.

Thêm 40 GV vào 444 điều kiện trước đó thành **484 điều kiện thiết kế chưa chạy bằng validator/mô phỏng**.

## 41. Giới hạn và bước tiếp theo

K2.3 chưa chốt luật sở hữu toàn thế giới, thuế, ngân hàng, tiền tín dụng, giá động, phá sản, escrow, bảo hiểm, thị trường đấu giá hoặc thuật toán khóa transaction. Những hệ này phải xây trên cùng title/custody/right/obligation/conservation, không tạo sổ tài sản song song.

K2.4–K2.7 đã chuẩn hóa tác nhân, phục hồi, oracle và capacity; gói được rà tại [[KIEM_TOAN_DONG_GOI_K2]], kiến trúc tại [[KIEN_TRUC_DA_NEN_TANG_RANH_GIOI_MODULE_K3]]. K3.2 đã được lập tại [[MA_TRAN_CONG_NGHE_KE_HOACH_PROTOTYPE_K3]]. K3.3 đã được lập tại [[KIEN_TRUC_DU_LIEU_NOI_DUNG_SINH_THE_GIOI_K3]]. K3.4 đã được lập tại [[MO_PHONG_PHAN_TANG_VONG_DOI_THUC_THE_K3]]. K3.5 đã được lập tại [[LUU_TRU_PHAN_VUNG_CHI_MUC_TRUY_VAN_K3]]. K3.6 đã được lập tại [[ARTIFACT_MAY_SCHEMA_REGISTRY_CONDITION_CATALOG_K3]]. K3.7 đã được kiểm toán tại [[KIEM_TOAN_DONG_GOI_K3]]. K4.1 đã được lập tại [[NEN_VAT_CHAT_NANG_LUONG_TRUONG_HIEN_TUONG_K4]]. K4.2 đã được lập tại [[CO_THE_DA_TANG_SINH_LY_BENH_LY_TU_LUYEN_K4]]. K4.3 đã được lập tại [[VAT_LIEU_VAT_PHAM_CAU_TRUC_CONG_DUNG_CHE_TAC_K4]]. K4.4 đã được lập tại [[DIA_LY_KHI_HAU_THUY_VAN_DAT_SINH_THAI_LINH_SINH_QUYEN_K4]]. K4.5 đã được lập tại [[CONG_PHAP_CANH_GIOI_LINH_CAN_KY_NANG_THUAT_PHAP_TRUYEN_THUA_K4]]. K4.6 đã được lập tại [[NPC_TU_TRI_NHU_CAU_KE_HOACH_QUAN_HE_KY_UC_CAU_CHUYEN_PHAT_SINH_K4]]. K4.7 đã được lập tại [[KINH_TE_TO_CHUC_XA_HOI_QUYEN_LUC_LUAT_PHAP_K4]]. K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chờ người dùng yêu cầu bắt đầu K5.1 prototype và V0.
