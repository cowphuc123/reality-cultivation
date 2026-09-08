---
title: "K4.7 — Kinh tế, tổ chức, xã hội, quyền lực và luật pháp sâu"
aliases:
  - "Kinh tế xã hội sâu K4"
  - "Tổ chức và quyền lực K4"
tags: [reality-cultivation, ke-hoach, k4, kinh-te, xa-hoi]
status: de-xuat
updated: 2026-09-06
---

# K4.7 — Kinh tế, tổ chức, xã hội, quyền lực và luật pháp sâu

> [!summary]
> Tài liệu này mở rộng [[KINH_TE_TO_CHUC]], [[SINH_KE]] và [[VAN_HOA_THE_CHE_AN_KHE_K1]] trên nền giao dịch K2.3, vật phẩm K4.3 và NPC K4.6. Kinh tế là dòng vật, công, quyền và thông tin thật; tổ chức hành động qua thành viên, vai trò và thủ tục. Đây là thiết kế chưa triển khai, không phải mô tả kinh tế hay pháp luật ngoài đời.

## 1. Mục tiêu

```text
nhu cầu + tài nguyên + kỹ năng + quyền + thông tin
→ sản xuất/dịch vụ/trao đổi
→ thu nhập, thiếu hụt, tích lũy và nghĩa vụ
→ hợp tác, tổ chức, chuẩn mực và quyền lực
→ quyết định tập thể, thực thi và phản ứng
→ lịch sử kinh tế–xã hội có thể truy nguyên
```

Không có cửa hàng vô hạn, giá toàn cầu, ngân khố ảo hoặc “ý chí tổ chức” toàn tri.

## 2. Phạm vi

K4.7 định hộ gia đình, lao động, sản xuất, dịch vụ, kho, thị trường, giá, tiền, tín dụng, vận tải, đất/tài nguyên, tổ chức, tông môn, gia tộc, chính quyền, luật, điều tra, địa vị, quyền lực, bất bình đẳng, khủng hoảng, SE0–SE5, fixture và điều kiện kiểm chứng.

## 3. Ranh giới chủ quản

| Miền | Sở hữu |
|---|---|
| K4.3/K4.4 | vật, công trình, đất, nguồn và biến đổi vật chất |
| K4.6 | quyết định, belief, plan và quan hệ của người |
| K2.3 | title, custody, right, claim, contract, transaction |
| K4.7 | institution, market, policy, collective procedure và social status |
| K4.8 | cưỡng chế vật lý, chiến đấu và hậu quả xung đột |

Tổ chức không sửa tài sản hoặc điều khiển thành viên ngoài các port này.

## 4. EconomicActor

Actor kinh tế có thể là Person, Household hoặc Organization có năng lực pháp lý theo InstitutionRule. Mỗi actor giữ rights, obligations, accounts, authorized agents và information view.

Một vật chỉ có một trạng thái title/custody canonical; nhiều trang chỉ là View.

## 5. Hộ gia đình

Household là thỏa thuận sống/chăm sóc/chia sẻ, không đồng nhất huyết thống. Nó có thành viên, người phụ thuộc, quyền dùng, contribution rules, decision procedure và exit rule.

Không mặc định toàn bộ tài sản cá nhân thành của chung.

## 6. Household budget

Ngân sách dự báo thức ăn, nước, chỗ ở, thuốc, công cụ, nợ, học và dự trữ bằng belief hiện có. Khoản dự kiến chưa nhận không được tiêu.

Thiếu hụt sinh Goal và thương lượng giữa thành viên.

## 7. Chăm sóc không trả công

Nấu ăn, nuôi trẻ, chăm bệnh và sửa nhà dùng thời gian/năng lực thật dù không có tiền công. Chúng ảnh hưởng sản xuất và quan hệ.

Không coi lao động không bán trên thị trường là bằng không.

## 8. Sinh kế hỗn hợp

Một người có thể làm ruộng, hái thuốc, đổi công và luyện tập theo mùa. IncomeStream giữ nguồn, biến động, chi phí và độ chắc.

Nghề là lịch sử năng lực/cơ hội, không là bộ tạo tiền mỗi ngày.

## 9. ProductionPlan

Kế hoạch sản xuất nối demand belief, design/process, input, tool, station, labor, thời gian, yield uncertainty, storage và buyer.

Chỉ Workpiece/process thật mới tạo output.

## 10. Năng lực sản xuất

Capacity phụ thuộc người, ca làm, kỹ năng, cơ thể, máy, bảo trì, nguồn và bottleneck. Không lấy số thợ nhân năng suất lý tưởng.

Đứt một công đoạn có thể làm toàn chuỗi chậm.

## 11. Dịch vụ

Dịch vụ như chữa bệnh, dạy học, vận tải, giám định giữ Provider, Recipient, appointment, inputs, result criteria và liability.

Một người không cung cấp đồng thời vô hạn dịch vụ.

## 12. Chất lượng và sai lệch

Quality thực từ vật/process; quality được mua bán là Claim dựa trên inspection, reputation và lời người bán.

Tranh chấp chỉ phát sinh khi khác biệt được biết hoặc điều khoản cho phép.

## 13. Lao động

LaborOffer mô tả công việc, nơi, thời gian, trả công, điều kiện, rủi ro và quyền chấm dứt. Acceptance tạo obligation chứ không chiếm quyền điều khiển cơ thể.

NPC có thể nghỉ, đình công, bỏ việc hoặc vi phạm và chịu hậu quả.

## 14. Tiền công

Trả theo thời gian, sản lượng, mốc hoặc chia lợi ích có cách xác minh khác nhau. Công đã làm tạo claim dù người thuê tạm thiếu tiền.

Không xóa lao động vì hợp đồng thất bại ở bước thanh toán.

## 15. Phân công

Manager lập JointPlan từ người có thật và chỉ biết lịch/năng lực qua báo cáo. Overbooking bị phát hiện ở reservation hoặc execution.

Vai trò quản lý không cấp omniscience.

## 16. Thất nghiệp và thiếu người

Không có việc phù hợp khác không có người. Vacancy và JobSeeker chỉ gặp nhau qua thông tin, khoảng cách, điều kiện và quyết định.

Thiếu lao động có thể tăng giá chào, đổi công nghệ hoặc giảm sản lượng.

## 17. Kho

Kho tách on-hand, reserved, in-transit, damaged, quarantined và available. Custodian không luôn là owner.

Kiểm kê là hành động có sai số; sổ không tự sửa vật thật.

## 18. Hao hụt

Hỏng, bay hơi, trộm, sâu bệnh và sai đo cần event/process. “Hao hụt kinh doanh” là phân loại sau, không là sink tùy ý.

Mọi mất vật có conservation/source-sink ref.

## 19. Offer

Offer giữ seller, asset/service, quantity, disclosed attributes, price terms, location, expiry và eligibility.

Offer hết điều kiện không tự sinh hàng thay thế.

## 20. Order và matching

Thị trường ghép offer qua địa điểm/kênh mà actor tiếp cận. Matching tạo proposal; giao dịch chỉ commit sau quyền, reservation và acceptance.

Không có sàn toàn thế giới mặc định.

## 21. Giá

Giá là điều khoản giữa các bên. ReferencePrice là thống kê từ giao dịch/offer đã biết, có phạm vi, tuổi dữ liệu và bias.

Không có một “giá thật” mọi NPC đọc được.

## 22. Price formation

Người bán xét chi phí tin được, tồn, dòng tiền, tốc độ hỏng, đối thủ và quan hệ. Người mua xét nhu cầu, ngân sách, thay thế, chất lượng và urgency.

Công thức chỉ sinh estimate, không ép giao dịch.

## 23. Mặc cả

Negotiation tạo chuỗi proposal có thời gian và concession policy. Lặp đề nghị không tự giảm giá; xúc phạm hoặc gấp có thể đổi quan hệ.

Outcome theo hai Agent K4.6.

## 24. Khả năng thanh toán

Affordable theo asset/right thực, khoản đã reserve và nghĩa vụ gần. Tín dụng khả dụng là quyền vay đã được chấp nhận, không phải tiền.

Không tiêu cùng số dư hai lần.

## 25. Tiền vật chất

Coin, phiếu hay linh thạch là item/claim theo luật phát hành. Linh thạch đã tiêu năng lượng có thể đổi quality và acceptance.

Đếm tiền vẫn chịu custody, mất cắp và giả mạo.

## 26. Tiền sổ sách

AccountBalance là claim với issuer/custodian; gửi tiền chuyển custody/title theo hợp đồng. Không đồng thời tiêu coin gửi và số dư.

Settlement cần ledger hai phía và finality rule.

## 27. Phát hành

Minting/issuance có authority, input/collateral, limit và audit. Tiền mới chỉ có SourceEvent hợp lệ.

Lạm phát là hậu quả phân phối/cung–cầu, không là debuff chung.

## 28. Ngoại tệ và tỷ giá

Mỗi vùng/tổ chức có acceptance và belief khác nhau. ExchangeOffer có tồn thật, spread, phí và rủi ro.

Không đổi vô hạn qua vòng tỷ giá.

## 29. Tín dụng

CreditProposal xét relationship, income belief, collateral, purpose và enforcement expectation. Acceptance tạo receivable/payable cùng ID.

Cho vay không tạo tiền mặt nếu lender không chuyển asset/claim.

## 30. Lãi và kỳ hạn

Accrual theo game time, agreement và cap; tải lại không tính lặp. Deadline tạo wakeup.

Lãi, phí và phạt là điều khoản riêng, chưa chốt chuẩn thế giới.

## 31. Bảo đảm

Collateral tạo encumbrance lên asset cụ thể. Con nợ vẫn có thể giữ custody nhưng không chuyển title hợp lệ trái điều khoản.

Thu giữ cần authority và hành động tiếp cận thật.

## 32. Vỡ nợ

Default là obligation không hoàn thành tại boundary, không tự tịch thu. Các bên có thể gia hạn, bù trừ, kiện, thu giữ hoặc chịu lỗ.

Mỗi phương án có quyền, chi phí và rủi ro.

## 33. Phá sản

InsolvencyCase đóng băng/ưu tiên claim theo InstitutionRule, kiểm kê estate và phân phối phần thật. Nó không xóa vật hoặc tạo đủ tiền trả.

Quy tắc ưu tiên chủ nợ chưa được người dùng chốt.

## 34. Bảo hiểm và chia sẻ rủi ro

Pool cần contribution, covered event, evidence, reserve và payout rule. Nhiều claim cùng lúc có thể làm pool thiếu.

Không bồi thường nếu quỹ không có nguồn hoặc sự kiện không được xác minh.

## 35. Vận tải

Shipment giữ item/custody, route, carrier, deadline, condition, risk bearer và handoff evidence. Hàng luôn ở một vị trí.

Đường, thời tiết và cướp bóc nối K4.4/K4.8.

## 36. Logistics

SupplyPlan tính nguồn, lead time, storage, spoilage, vehicle, escort và reorder point theo belief. Delay lan đến production và promises.

Không teleport input giữa kho.

## 37. Chợ địa phương

MarketVenue có giờ, chỗ, người quản, phí, rule, information reach và security. Người vắng không tự thấy offer.

Chợ đóng vì bão hoặc xung đột ngừng matching thật.

## 38. Thương mại liên vùng

Chênh giá chỉ thành cơ hội khi biết tin và có vốn/tuyến/thời gian. Giá có thể đổi trước khi hàng đến.

Arbitrage chịu capacity và risk, không bảo đảm lợi nhuận.

## 39. Thuế và phí

TaxRule giữ jurisdiction, base, rate/formula, liable party, due time, exemptions, collector và appeal. Assessment khác payment.

Thu cần người/kênh và không trừ từ túi từ xa.

## 40. Hàng công

Đường, giếng, tường và cứu trợ cần tài nguyên, maintenance và quyền tiếp cận. Public không nghĩa vô chủ.

Free-riding và phân bổ là vấn đề quyết định tập thể thật.

## 41. Tài nguyên chung

CommonResource có membership/access, extraction limits, monitoring và restoration. Khai thác thật đổi K4.4.

Quy tắc giấy không ngăn trộm vật lý nếu không thực thi.

## 42. Đất

LandParcel giữ topology, uses, title, possession, easement, tax và environmental obligations. Quyền mặt đất, nước, mỏ và linh mạch có thể tách.

Không coi tọa độ là quyền sở hữu.

## 43. Tiếp cận linh địa

Quyền tu luyện/khai thác quy định thời gian, công suất, người, technique và phí. K4.5/K4.4 quyết định hiệu quả/hậu quả thật.

Token vào cửa không tạo linh lượng.

## 44. Organization

```text
identity + charter + membership
+ roles/authority + decision procedures
+ assets/claims/obligations
+ policies + records + information channels
+ branches + external relations + history
```

Organization không có bộ não; người và procedure tạo Command.

## 45. Charter

Điều lệ định mục đích, phạm vi, thành viên, cơ quan, sửa đổi, kế nhiệm và giải thể. Nó có version/effective time.

Belief về điều lệ có thể sai; enforcement dùng bản có hiệu lực và bằng chứng.

## 46. Membership

Gia nhập/rời/khai trừ là process có consent, điều kiện, quyền, nghĩa vụ và effective boundary. Danh sách thành viên không tự truyền tới mọi chi nhánh.

Không kế thừa membership nếu charter không nói.

## 47. Role

RoleDefinition tách khỏi RoleAssignment. Assignment có holder, scope, term, limits, delegation và revocation.

Quan hệ cá nhân không tự cấp RoleRight.

## 48. Authority

AuthoritySpec nêu loại quyết định, tài sản, địa bàn, mức tiền, đồng ký và emergency power. Transaction kiểm scope tại commit.

Quyền được công nhận khác khả năng vật lý.

## 49. Delegation

Người có quyền chỉ ủy quyền phần được phép, theo phạm vi/thời hạn. Chuỗi delegation có provenance và chống vòng.

Thu hồi không hồi tố xóa hành động đã commit.

## 50. Collective decision

Proposal → notice → deliberation → vote/consent → quorum → resolution → execution. Mỗi bước có người, thời gian và evidence.

Resolution không tự xây công trình hoặc chuyển vật.

## 51. Quorum và biểu quyết

Eligibility theo membership/role tại record date; abstain, absent và conflict of interest tách nhau. Tie-break theo charter.

Không đếm một người hai lần qua nhiều vai trò nếu luật không cho.

## 52. Đồng thuận

Consensus là tập chấp nhận có bằng chứng, không là biến “mọi người đồng ý”. Im lặng chỉ là đồng ý nếu rule hợp lệ và đã được thông báo.

Người không nhận notice không tự biết proposal.

## 53. Policy

Policy là rule có owner, scope, version, effective time, exceptions và sunset/review. Nó sinh constraint/goal cho người thi hành.

Policy không đọc/sửa World State ngoài port.

## 54. Record và hành chính

Register lưu quyết định, quyền, thu, chi, thành viên và vụ việc. Record có custodian, medium, access, authenticity và error correction.

Sổ bị cháy không xóa quyền thật nhưng làm chứng minh khó hơn.

## 55. Information flow

Báo cáo, thư, họp và công bố là Message/Artifact. Tổ chức chỉ biết tổng hợp mà thành viên có thẩm quyền đã nhận.

Không có knowledge chung tức thời.

## 56. Branch

Chi nhánh có local roles/assets/policies và communication delay. Central resolution chỉ áp khi jurisdiction và notice hợp lệ.

Hai chi nhánh có thể hành động khác vì thông tin lệch.

## 57. Tông môn

Tông môn nối truyền thừa K4.5 với đất, kho, lớp học, nhiệm vụ, quyền pháp và kỷ luật. Tuyển thêm người tạo chi phí nuôi/dạy thật.

Điểm cống hiến là claim theo rule, không tạo phần thưởng khi kho rỗng.

## 58. Gia tộc

Gia tộc là kinship + institution, có tài sản chung, nghi lễ, người đại diện và succession riêng. Huyết thống không tự cấp quyền.

Các nhánh có thể tranh quyền và tài nguyên.

## 59. Thương hội

Thương hội cung cấp thông tin, kho, bảo lãnh, tiêu chuẩn và vận tải từ contribution thật. Membership không đồng nhất ownership.

Độc quyền cần capacity và enforcement.

## 60. Phường nghề

Guild kiểm chuẩn nghề, đào tạo, chứng nhận và tương trợ theo authority. Certificate là Claim có issuer/evidence, không tăng kỹ năng thật.

Người giỏi không giấy vẫn có năng lực nhưng có thể thiếu quyền hành nghề.

## 61. Chính quyền

Government là mạng office, jurisdiction, revenue, services, lawmaking và enforcement. Quan chức vẫn là NPC với belief/goal riêng.

Đổi người không tự xóa institution; đảo chính cần K4.8.

## 62. Jurisdiction

Jurisdiction theo lãnh thổ, người, hành vi hoặc membership và có xung đột rule. Một việc có thể thuộc nhiều claim quyền.

Conflict-of-law cần forum/procedure, không chọn luật có lợi tự động.

## 63. Law

LawRule định conduct, elements, defenses, liable actor, remedy/sanction, authority và effective time.

Luật không phải tường vật lý.

## 64. Norm

Norm xã hội có group, expectation, mức chia sẻ, sanctions phi chính thức và variance. Cá nhân có thể không đồng ý hoặc không biết.

Culture không là một thanh toàn vùng.

## 65. Custom

Tập quán hình thành từ hành vi/expectation lặp và được viện dẫn. Việc phổ biến không tự thành law nếu thể chế không công nhận.

Nguồn và phạm vi phải được lưu.

## 66. Vi phạm

Conduct Fact, suspicion, accusation, finding và liability là trạng thái khác nhau. CrimeRecord không được tạo từ tin đồn thành sự thật.

Hành vi có thể vi phạm nhiều rule.

## 67. Chứng cứ

Evidence giữ source, chain of custody, integrity, relevance và người có quyền truy cập. Lời khai là evidence về điều được nói/nhận, không tự là Fact.

Giả mạo cần action vật chất.

## 68. Điều tra

InvestigationPlan có câu hỏi, giả thuyết, người, quyền, phương pháp, chi phí và giới hạn. Điều tra viên chỉ suy từ evidence họ có.

Không highlight thủ phạm canonical.

## 69. Phiên xử

Case có parties, claims/charges, forum, notice, evidence, procedure, decision maker và appeal. Vắng mặt không mặc định nhận tội.

Ruling là Fact về quyết định, có thể sai về sự kiện.

## 70. Biện pháp

Remedy gồm hoàn trả, bồi thường, làm lại, injunction, mất quyền hoặc hòa giải. Sanction cần authority và execution.

Phán quyết không teleport vật hay gây thương tích.

## 71. Cưỡng chế

EnforcementPlan cần người, lệnh, target, nơi, thời gian, logistics và proportionality rule. Kháng cự chuyển sang K4.8.

Không có cảnh vệ vô hình.

## 72. Giam giữ

Detention cần căn cứ, custodian, địa điểm, ăn ở, thời hạn, review và health care. Người bị giữ vẫn có body/Agent trong giới hạn vật lý.

Chưa chốt cho bản đầu.

## 73. Thu hồi và tịch thu

Seizure tách possession, custody, title và disposition. Vật bị giữ phải được vận chuyển/lưu kho, có thể hỏng hoặc thất lạc.

Không xóa item để biểu diễn phạt.

## 74. Kháng nghị

Appeal cần ground, deadline, forum và record. Nó có thể đình chỉ một phần execution theo rule.

Không mở lại vô hạn chỉ vì thua.

## 75. Địa vị

StatusClaim có community/domain, basis, recognition và privileges/burdens. Danh hiệu khác capability thật.

Một người có địa vị khác nhau ở hai vùng.

## 76. Danh tiếng

Reputation là phân bố belief trong network, theo lĩnh vực và nguồn. Không có điểm toàn cầu.

Public ruling chỉ ảnh hưởng người nhận tin.

## 77. Uy tín

Prestige phát sinh từ thành tựu được biết và chuẩn nhóm. Nó ảnh hưởng attention/influence nhưng không cấp quyền pháp lý.

Tông môn khác có thể không công nhận.

## 78. Giai cấp

Class/Caste nếu tồn tại là institution/norm bundle về quyền, nghề, hôn nhân và status. Đây là nội dung văn hóa chưa chốt.

Không suy địa vị đạo đức từ giai cấp.

## 79. Nô lệ và lệ thuộc

Nếu thế giới có slavery/bondage, phải biểu diễn claim bị tranh chấp, coercion, consent limits, escape và hậu quả; không coi người là item.

Việc có đưa cơ chế này vào game vẫn là câu hỏi mở.

## 80. Quyền lực

Power là khả năng đạt outcome trong context qua nguồn, chức vụ, thông tin, quan hệ, uy tín, bạo lực hoặc kiểm soát hạ tầng.

Không có power score canonical.

## 81. Ảnh hưởng

InfluenceAttempt là giao tiếp/đề nghị/đe dọa có target và leverage được tin. Người nhận vẫn quyết định qua K4.6.

Leverage có thể mất khi thông tin đổi.

## 82. Patronage

Bảo trợ trao nguồn/cơ hội đổi kỳ vọng hoặc loyalty, thông qua giao dịch/role thật. Quan hệ không tự thành quyền sở hữu người.

Client có thể đổi phe hoặc phản bội.

## 83. Tham nhũng

CorruptAct dùng authority vì lợi riêng: ưu ái, biển thủ, bán quyền, che evidence. Nó cần cơ hội, transfer và concealment thật.

Không trừ ngân khố ngẫu nhiên rồi gán “tham nhũng”.

## 84. Giám sát

Audit kiểm record/vật/process bằng người và công cụ. Detection có coverage, competence, bias và tamper risk.

Audit report không tự là sự thật tuyệt đối.

## 85. Faction

Faction là coalition của người quanh mục tiêu/lợi ích, có membership belief, coordination và resources. Nó có thể nằm trong organization.

Không sinh phe chỉ để cân bằng cốt truyện.

## 86. Chính trị

PoliticalProcess là cạnh tranh/thương lượng về policy, role và resource allocation. Campaign dùng thời gian, message, promise và coalition.

Thắng chức không tự hoàn thành lời hứa.

## 87. Kế nhiệm

SuccessionRule định vacancy, eligibility, interim authority và selection. Vai trò không thành di sản trừ khi charter nói.

Nhiều claim tạo crisis, không nhân đôi chức vụ.

## 88. Đảo chính và ly khai

Attempt cần faction, plan, access, lực lượng, communication và legitimacy belief. Outcome qua transaction/command/K4.8.

Đổi cờ UI không đủ đổi quyền kiểm soát.

## 89. Quan hệ giữa tổ chức

InterOrgRelation tách treaty, trade, debt, recognition, grievance, dependency và conflict belief. Tổ chức không có thiện cảm một chiều duy nhất.

Các thành viên có thể hiểu quan hệ khác nhau.

## 90. Hiệp ước

Treaty là contract giữa đại diện có authority, cần ratification/notice và implementation. Vi phạm là Fact riêng và cần được biết.

Hiệp ước không tạo tài nguyên cam kết.

## 91. Ngoại giao

Envoy mang mandate, message, credential và reporting duty. Thông tin chậm/sai có thể đổi đàm phán.

Không hội thoại tức thời xuyên thế giới nếu thiếu kênh.

## 92. Cấm vận

Embargo hạn chế transaction hợp lệ trong jurisdiction; buôn lậu vẫn có thể xảy ra vật lý. Hiệu quả phụ thuộc kiểm soát tuyến và compliance.

Không xóa offer đối phương toàn cầu.

## 93. Chiến tranh và hậu cần

WarDecision xác định mục tiêu, authority, mobilization, supply và termination. Người, vũ khí, lương và đường thật quyết định capacity.

Chiến đấu cụ thể thuộc K4.8.

## 94. Dân số và nhân khẩu

Population statistics là View từ Person/cohort records, có uncertainty. Sinh, chết, di cư đổi người thật trước khi đổi thống kê.

Không dùng số dân tổng thay Person M2+.

## 95. Bất bình đẳng

Đo distribution title, access, income, health, education và influence theo phạm vi. Chỉ số không tự gây hành động; NPC phản ứng qua belief/value.

Không rút gọn xã hội thành một thanh ổn định.

## 96. Nghèo đói

Poverty là thiếu khả năng tiếp cận nhu cầu qua thời gian, không chỉ ít coin. Hỗ trợ cần nguồn, eligibility và delivery.

NPC nghèo vẫn có tài sản, quan hệ và quyết định riêng.

## 97. Khủng hoảng

Mất mùa, dịch, chiến tranh, ngân hàng vỡ hoặc linh mạch suy tạo shock thật. Response gồm rationing, aid, price change, migration, theft, policy và conflict.

Không chọn một outcome viết sẵn.

## 98. Rationing

AllocationRule có eligible set, priority, quota, duration và appeal. Distribution chuyển hàng thật; hàng thiếu tạo unmet claim.

Quan chức có thể sai hoặc gian lận qua hành động.

## 99. Cứu trợ

ReliefPlan nối donor stock, transport, recipient information, local custodian và accountability. Hàng có thể đến muộn/hỏng/bị chiếm.

Thông báo viện trợ không làm no.

## 100. Thích nghi thể chế

Policy đổi sau feedback, pressure và proposal. Institution có thể học chậm, khóa bởi lợi ích hoặc sụp đổ.

Không tối ưu hóa tổ chức tự động.

## 101. Thành lập

OrganizationFormation cần founders, charter, contribution, recognition và initial roles. Tài sản góp chuyển theo transaction.

Không sinh organization cùng kho từ mô tả.

## 102. Sáp nhập và chia tách

Merger/Split xử membership, assets, liabilities, records, policy và dissent. Không nhân đôi claim.

Người phản đối có quyền theo rule, không mặc định đi theo.

## 103. Giải thể

Dissolution đóng việc, thanh lý asset, trả claim theo thứ tự, lưu archive và chấm dứt authority. Thiếu tài sản ghi loss/default.

Lịch sử tổ chức vẫn tồn tại.

## 104. Lịch sử xã hội

InstitutionEvent giữ founder, policy revision, office change, dispute, crisis, treaty và dissolution. Narrative chỉ đọc các event này.

Không viết tiểu sử tập thể trái ledger.

## 105. SE0–SE5

| Mức | Phạm vi | Cách giải |
|---|---|---|
| SE0 CONTACT | giao dịch/phiên xử trực tiếp | từng act, item, người |
| SE1 LOCAL | giờ–ngày | order, work, meeting chính xác |
| SE2 PERIOD | ngày–tuần | ledger + boundary |
| SE3 MARKET | tuần–tháng | batch offer/production có phân phối |
| SE4 INSTITUTION | tháng–năm | policy/cohort flow, giữ anchor |
| SE5 DORMANT | không tương tác | chỉ obligation/crisis wakeup |

SE phối hợp R/M/AR, không thay identity.

## 106. Market batch

Batch chỉ gộp hàng fungible cùng market, quality band, time, rights và information reach. Kết quả phân về seller/buyer/lot riêng.

Item có identity không bị biến thành tồn vô danh.

## 107. OrganizationCapsule

Capsule giữ charter, roles, authority, assets/claims refs, policies, branches, pending cases, obligations, records anchors và next review.

Hạ SE không xóa tranh chấp hoặc quyền.

## 108. Boundary flow

Giữa vùng phải giữ shipment, migration, payment, message, tax, environmental extraction và military supply. Mỗi flow có source/destination/time/custody.

Không cân bằng bằng delta vô chủ.

## 109. Determinism và save

Cùng save/command/content/policy cho cùng ledger và resolution. Save giữ accrual cursor, offers, reservations, votes, cases, shipments và SE plan.

Load không tính lãi/thuế/quan hệ hai lần.

## 110. Mobile và desktop

Cùng core, Command, View semantic và save. Điện thoại mở dần “vật–quyền–nghĩa vụ–nguồn”; desktop có bảng ledger, market và tổ chức song song.

Bố cục không đổi giá, vote hay quyền.

## 111. Giao diện

Người chơi chỉ thấy giá, luật, sổ, danh tiếng và quyết định họ có đường tiếp cận. UI giải thích giao dịch thất bại bằng thiếu vật, quyền, người, thông tin hay thời gian.

Chế độ audit toàn tri là công cụ phát triển riêng.

## 112. Artifact tương lai

Cần EconomicActor/Household/Market/Organization/Institution schemas; policy/charter/law IR; price/production/logistics handlers; case/evidence registry; SE capsule; fixture và catalog XH01–XH96.

Hiện chưa tạo artifact máy.

## 113. Fixture K4X-F01 — hộ thiếu lương

Hộ dự báo thiếu, đổi lịch lao động/mua/nhờ giúp; không tự sinh thức ăn hay tiền.

## 114. Fixture K4X-F02 — xưởng tắc nguyên liệu

Shipment trễ làm Workpiece và lương đổi; hợp đồng giao hàng giữ claim và negotiation.

## 115. Fixture K4X-F03 — chợ thiếu thuốc

Offer/giá phản ứng khác nhau theo tồn, belief và quan hệ; không có giá global.

## 116. Fixture K4X-F04 — vay và vỡ nợ

Khoản vay tạo hai phía, accrual một lần, collateral không teleport khi default.

## 117. Fixture K4X-F05 — tiền giả

Item giả đi qua custody; chỉ người kiểm/nhận evidence đổi belief và acceptance.

## 118. Fixture K4X-F06 — linh địa quá tải

Nhiều quyền truy cập cạnh tranh capacity; extraction thật làm field/ecology đổi.

## 119. Fixture K4X-F07 — tuyển đệ tử

Tông môn cân chỗ, thầy, lương và nguồn tu; nhận người tăng chi phí thật.

## 120. Fixture K4X-F08 — đổi chưởng môn

Vacancy kích succession; role, kho và knowledge access chuyển theo procedure, không theo proximity.

## 121. Fixture K4X-F09 — tham ô

NPC chuyển vật qua quyền có kẽ hở, sửa báo cáo; audit chỉ phát hiện từ evidence.

## 122. Fixture K4X-F10 — tranh đất

Hai title claim, possession và custom mâu thuẫn; Case giữ vật tại chỗ tới execution.

## 123. Fixture K4X-F11 — vụ án sai

Ruling có thể kết luận sai từ evidence yếu; World Fact không bị viết lại.

## 124. Fixture K4X-F12 — cứu trợ bão

Quỹ, hàng, vận tải, rationing và theft đều dùng entity thật.

## 125. Fixture K4X-F13 — chi nhánh mất liên lạc

Central đổi policy nhưng branch chưa nhận; hành động cũ tạo hậu quả/tranh chấp, không hồi tố.

## 126. Fixture K4X-F14 — tổ chức giải thể

Assets/liabilities/member roles được xử không nhân đôi; archive còn.

## 127. Fixture K4X-F15 — SE round-trip

Một năm SE4 rồi nâng SE0 giữ ledger, person, shipment, case, policy và market totals.

## 128. Fixture K4X-F16 — parity

Cùng save/command trên điện thoại và máy tính cho cùng transaction, vote và Fact.

## 129. Điều kiện XH01–XH96

### Vật, lao động và thị trường

| ID | Điều kiện |
|---|---|
| XH01 | một asset không có hai title toàn phần |
| XH02 | household không tự gộp tài sản |
| XH03 | chăm sóc dùng thời gian thật |
| XH04 | nghề không tự tạo thu nhập |
| XH05 | sản xuất cần input/process |
| XH06 | service không overbook |
| XH07 | wage claim giữ sau khi làm |
| XH08 | manager không đọc lịch bí mật |
| XH09 | kho tách on-hand/reserved |
| XH10 | hao hụt có event/source-sink |
| XH11 | offer hết hàng không tự refill |
| XH12 | matching không tự commit |
| XH13 | reference price có phạm vi/thời |
| XH14 | buyer không đọc quality ẩn |
| XH15 | haggle lặp không giảm vô hạn |
| XH16 | cùng balance không tiêu hai lần |
| XH17 | tiền vật chất giữ custody |
| XH18 | deposit không nhân đôi coin |
| XH19 | issuance có authority/source |
| XH20 | exchange loop không sinh giá trị |
| XH21 | shipment luôn có vị trí |
| XH22 | market đóng thì ngừng matching |
| XH23 | arbitrage chịu lead time |
| XH24 | public good cần maintenance |

### Hợp đồng, đất và tài chính

| ID | Điều kiện |
|---|---|
| XH25 | debt hai phía cùng ID |
| XH26 | accrual không chạy lặp khi load |
| XH27 | collateral không teleport |
| XH28 | default không tự seize |
| XH29 | insolvency không tạo đủ tiền |
| XH30 | insurance payout theo reserve |
| XH31 | tax assessment khác payment |
| XH32 | tax không trừ vật từ xa |
| XH33 | land topology khác title |
| XH34 | quyền nước/mỏ có thể tách |
| XH35 | common extraction đổi resource |
| XH36 | linh địa token không tạo linh lượng |
| XH37 | delivery giữ custody handoff |
| XH38 | contract amendment cần consent |
| XH39 | obligation quên không biến mất |
| XH40 | compensation không nhân vật/tiền |

### Tổ chức và thủ tục

| ID | Điều kiện |
|---|---|
| XH41 | organization không có knowledge toàn tri |
| XH42 | charter có version/effective time |
| XH43 | membership đổi qua process |
| XH44 | role definition tách assignment |
| XH45 | authority kiểm scope tại commit |
| XH46 | delegation không vượt quyền gốc |
| XH47 | revocation không hồi tố |
| XH48 | proposal không tự thành resolution |
| XH49 | quorum đếm đúng eligibility |
| XH50 | một người không double vote |
| XH51 | im lặng không tự là consent |
| XH52 | policy không tự thực thi vật lý |
| XH53 | record mất không xóa Fact |
| XH54 | public notice không tạo knowledge toàn vùng |
| XH55 | branch giữ information delay |
| XH56 | contribution point không tạo reward |
| XH57 | certificate không tăng skill |
| XH58 | merger không nhân claim |
| XH59 | dissolution giữ archive |
| XH60 | succession không nhân role |

### Luật, địa vị và quyền lực

| ID | Điều kiện |
|---|---|
| XH61 | law không chặn vật lý |
| XH62 | norm không đồng nhất belief |
| XH63 | conduct tách accusation |
| XH64 | rumor không thành evidence độc lập |
| XH65 | evidence giữ chain of custody |
| XH66 | investigator không thấy thủ phạm canonical |
| XH67 | notice tới đúng party |
| XH68 | ruling không viết lại World Fact |
| XH69 | remedy không teleport asset |
| XH70 | enforcement cần người/logistics |
| XH71 | detention giữ body/Agent |
| XH72 | seizure tách custody/title |
| XH73 | appeal có ground/deadline |
| XH74 | status không thành capability |
| XH75 | reputation chỉ lan theo network |
| XH76 | prestige không tự cấp authority |
| XH77 | influence không điều khiển Agent |
| XH78 | corruption cần transfer thật |
| XH79 | audit report có uncertainty |
| XH80 | faction có thành viên/nguồn thật |

### Liên vùng, khủng hoảng và phân tầng

| ID | Điều kiện |
|---|---|
| XH81 | treaty cần representative authority |
| XH82 | treaty không tạo promised resource |
| XH83 | diplomacy chịu message delay |
| XH84 | embargo không xóa offer toàn cầu |
| XH85 | war mobilization cần supply |
| XH86 | population View không thay Person |
| XH87 | inequality metric không điều khiển NPC |
| XH88 | relief có donor stock |
| XH89 | rationing phân item thật |
| XH90 | crisis không chọn outcome viết sẵn |
| XH91 | SE batch phân delta actor/lot |
| XH92 | OrganizationCapsule giữ case/claim |
| XH93 | boundary flow có source/destination |
| XH94 | SE round-trip giữ invariant |
| XH95 | save/load giữ accrual/vote/reservation |
| XH96 | mobile/desktop cùng semantic outcome |

XH01–XH96 là điều kiện thiết kế chưa mã hóa và chưa chạy. Tổng hồ sơ tăng từ 1.668 lên 1.764 điều kiện thuộc 40 họ.

## 130. Cổng K4.7

| Cổng | Đạt khi | Hiện tại |
|---|---|---|
| K4X01 | vật–quyền–tiền–claim boundary rõ | đạt trên giấy |
| K4X02 | giá/production/logistics có nhân quả | đạt trên giấy |
| K4X03 | organization hành động qua người/procedure | đạt trên giấy |
| K4X04 | law/evidence/ruling/execution tách | đạt trên giấy |
| K4X05 | power/status/reputation không thành stat toàn tri | đạt trên giấy |
| K4X06 | SE0–SE5 và vùng xa rõ | đạt trên giấy |
| K4X07 | schema/policy/law IR tồn tại | chưa |
| K4X08 | K4X-F01–F16 mã hóa | chưa |
| K4X09 | XH01–XH96 chạy có evidence | chưa |
| K4X10 | workload liên vùng đạt | chưa |

## 131. Vấn đề mở

1. Tiền tệ, đơn vị và issuer chính thức?
2. Quyền đất, nước, mỏ và linh mạch theo vùng?
3. Mức tự do hợp đồng?
4. Thuế và hàng công chặng đầu?
5. Hình thức chính quyền/tông môn/gia tộc?
6. Quyền cá nhân, trẻ em và người phụ thuộc?
7. Có giai cấp, nông nô hoặc nô lệ không?
8. Chuẩn chứng cứ và hình phạt?
9. Thừa kế và phá sản?
10. Mức mô phỏng chính trị?
11. Tổ chức có thể sở hữu công pháp tới đâu?
12. Đồng bộ thị trường xa theo SE nào?
13. Chỉ số kinh tế nào hiện cho người chơi?
14. Quy mô tổ chức/market trên điện thoại?
15. Chiến tranh và cưỡng chế sâu tới đâu trong K4.8?
16. Nội dung văn hóa nào dành riêng An Khê?

Chưa mục nào được tự chốt.

## 132. Rủi ro

| Rủi ro | Hậu quả | Kiểm soát |
|---|---|---|
| tiền/vật sinh vô nguồn | kinh tế giả | ledger + source/sink |
| giá global | NPC toàn tri | local information |
| organization là hive mind | xã hội giả | người + message + procedure |
| luật là tường vật lý | mất tự trị | violation/evidence/enforcement |
| điểm quyền lực | mất chiều sâu | capability theo nguồn/context |
| batch nuốt cá thể | mất lịch sử | actor/lot delta |
| record vô hạn | save phình | capsule/anchor/retention |
| UI quá dày | khó chơi mobile | progressive disclosure |

## 133. Trình tự hiện thực hóa khi được yêu cầu

1. EconomicActor/Household/Asset–Claim views.
2. production, service, labor và inventory.
3. offer/order/local price và settlement.
4. credit, shipment, land/resource rights.
5. Organization/Charter/Role/Authority.
6. proposal/vote/policy/branch communication.
7. law/evidence/case/remedy/enforcement.
8. status/power/faction/inter-org.
9. SE0–SE5, capsule, save/parity.
10. mã hóa fixture và XH01–XH96.

Đây là thứ tự triển khai tương lai, chưa phải việc đã làm.

## 134. Những điều không được tuyên bố

- Không nói đã có nền kinh tế, thị trường hoặc tổ chức chạy được.
- Không nói đã chốt tiền, luật, chính quyền hoặc chế độ xã hội.
- Không nói giá hay mô hình là dự báo kinh tế ngoài đời.
- Không nói đã mô phỏng chiến tranh hoặc cưỡng chế.
- Không nói SE0–SE5 đã đạt parity.
- Không nói XH01–XH96 đã chạy.
- Không nói 1.764 điều kiện là test tự động.

## 135. Giá trị K4.7 cung cấp thật

- vật, tiền, công và quyền đi qua ledger chung;
- giá và thị trường phát sinh từ actor có thông tin giới hạn;
- tổ chức hành động qua vai trò và thủ tục;
- tông môn/gia tộc/chính quyền có chi phí và xung đột nội bộ;
- luật tách vi phạm, chứng cứ, phán quyết và thực thi;
- địa vị/quyền lực không rút thành một chỉ số;
- SE0–SE5 giữ kinh tế xã hội vùng xa;
- 16 fixture và 96 điều kiện có thể mã hóa sau.

## 136. Bước tiếp theo

K4.8 đã được lập tại [[CHIEN_DAU_XUNG_DOT_TRUY_DUOI_AN_NAP_DIEU_TRA_HAU_QUA_K4]]. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chưa lập trình.
