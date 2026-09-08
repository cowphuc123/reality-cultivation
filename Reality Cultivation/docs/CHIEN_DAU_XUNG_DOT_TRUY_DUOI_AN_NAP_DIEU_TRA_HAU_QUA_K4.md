---
title: "K4.8 — Chiến đấu, xung đột, truy đuổi, ẩn nấp, điều tra và hậu quả sâu"
aliases: ["Chiến đấu sâu K4", "Xung đột và hậu quả K4"]
tags: [reality-cultivation, ke-hoach, k4, chien-dau]
status: de-xuat
updated: 2026-09-06
---

# K4.8 — Chiến đấu, xung đột, truy đuổi, ẩn nấp, điều tra và hậu quả sâu

> [!summary]
> Tài liệu này mở rộng [[CHIEN_DAU]] và [[CHIEN_DAU_THU]] bằng cơ thể K4.2, vật phẩm K4.3, môi trường K4.4, thuật pháp K4.5, NPC K4.6 và luật K4.7. Xung đột là quá trình liên tục trong thế giới chung; không có đấu trường tách biệt, HP canonical hoặc reset hậu quả. Đây là thiết kế chưa triển khai.

## 1. Mục tiêu

```text
động cơ + nhận thức + chuẩn bị
→ tiếp cận/phát hiện/đe dọa
→ thương lượng, tránh, phục kích hoặc giao chiến
→ action phases + vật lý + thuật pháp
→ thương tích, hỏng vật, mất vị trí và dấu vết
→ cứu chữa, truy đuổi, điều tra, luật và quan hệ
```

Thắng một trận có thể vẫn là thất bại về sinh kế, danh dự hoặc mục tiêu.

## 2. Phạm vi

K4.8 định conflict lifecycle, combat intent, không gian, perception, reaction, action phase, contact/impact, phòng thủ, vũ khí, thuật pháp, nhóm, phục kích, truy đuổi, ẩn nấp, đầu hàng, bắt giữ, hiện trường, truy dấu, điều tra, hậu quả, BR0–BR5, fixture và điều kiện CX01–CX96.

## 3. Ranh giới chủ quản

| Miền | Sở hữu |
|---|---|
| K4.1 | lực, nhiệt, field, transfer và hiện tượng |
| K4.2 | body state, function, injury, pain và death |
| K4.3 | weapon/armor/tool condition và fracture |
| K4.4 | terrain, weather, visibility và dấu môi trường |
| K4.5 | Technique Program, cast, sustain và counter |
| K4.6 | belief, goal, fear, decision và memory |
| K4.7 | authority, crime, evidence, ruling và enforcement |
| K4.8 | conflict orchestration, interaction và combat resolution |

Không miền nào vừa trừ HP vừa tạo injury cho cùng tác động.

## 4. ConflictInstance

Giữ participants được biết, goals, disputed resources, hostility beliefs, location, escalation stage, communication, active threats, ceasefire terms và causal events.

Xung đột có thể tồn tại lâu mà không chiến đấu.

## 5. Mục tiêu xung đột

Thoát, bảo vệ, giữ đường, lấy vật, bắt giữ, trì hoãn, chứng minh kỹ năng, ép nhượng bộ hoặc giết là các mục tiêu khác nhau.

Không mặc định AI chiến đấu đến chết.

## 6. Escalation

Các mức: bất đồng → đe dọa → chuẩn bị cưỡng ép → tiếp xúc bạo lực → truy đuổi/hậu chiến. Chuyển mức cần hành động/nhận thức nguồn.

Story layer không tự tăng escalation.

## 7. De-escalation

Xin lỗi, bồi thường, rút lui, trung gian, đầu hàng hoặc mất mục tiêu có thể giảm xung đột. Điều kiện tùy belief và commitment.

Hạ vũ khí không hồi tố dừng vật đã phóng.

## 8. CombatPolicy

Policy chứa ưu tiên, người/vật cần bảo vệ, mức lực cho phép, tài nguyên giữ lại, retreat threshold, pursuit limit, surrender response và hành vi cấm.

Policy hướng dẫn Agent; không bảo đảm outcome.

## 9. Ý định người chơi

Người chơi đặt mục tiêu và giới hạn thay vì bấm từng đòn ở tốc độ 5 giây/ngày. Tự dừng tại mối đe dọa được nhận biết, thương tích nguy cấp hoặc quyết định cam kết.

Lệnh mới chỉ áp khi phase cho phép.

## 10. Không gian chung

Combat dùng Position, orientation, occupied volume, route, cover và topology của địa điểm. Không chuyển người vào bản đồ chiến đấu riêng.

Người đi ngang và vật rơi vẫn thuộc world.

## 11. Khoảng cách

Near/reach/range là View từ geometry, body, weapon, technique và obstruction. Không là state độc lập dễ lệch.

Khoảng cách đường đi khác khoảng cách thẳng.

## 12. Độ cao

Độ cao, dốc, tầng nhà, cây và bay ảnh hưởng line-of-effect, rơi và di chuyển. Nếu phiên bản đầu giản lược phải khai capability.

Thuật bay không bỏ qua khí hậu/nguồn.

## 13. Tư thế

Posture gồm đứng, cúi, quỳ, nằm, treo, mất thăng bằng và thế kỹ thuật. Chuyển tư thế tốn thời gian và body capacity.

Không reset tư thế giữa action.

## 14. Footing

Ma sát, bùn, băng, đá vụn, nước, dốc và vật cản ảnh hưởng lực/ổn định. Trượt là interaction có nguyên nhân.

Không dùng debuff địa hình chung nếu geometry đủ.

## 15. Cover

Cover có geometry, material, integrity và angle. Nó chỉ chắn đường thực sự cắt qua.

Tường hỏng cập nhật khả năng chắn từ mốc hỏng.

## 16. Visibility

Ánh sáng, bụi, sương, mưa, vật che, mắt và kỹ thuật ảnh hưởng signal. Visibility không đồng nghĩa nhận diện.

Thấy bóng người không tự biết identity/cảnh giới.

## 17. Âm và dấu hiệu

Tiếng bước, hơi thở, va chạm, mùi, nhiệt và linh dao động là signal có propagation/noise. Người nghe ước lượng nguồn với sai số.

Không dùng combat flag để báo mọi người.

## 18. PerceptionTrack

Mỗi observer giữ target hypothesis, vị trí/velocity ước lượng, time, uncertainty, identity belief và evidence.

Mất dấu làm uncertainty tăng, không xóa target tức thì.

## 19. Surprise

Bất ngờ là thiếu dự báo/attention tại mốc signal, làm reaction bắt đầu muộn. Nó không cho “lượt miễn phí” cố định.

Tự dừng không quay ngược hậu quả trước lúc phát hiện.

## 20. Reaction

Reaction cần signal đã nhận, comprehension, decision latency, body function và action window. Né/đỡ/chạy đều là Action.

Không có phản ứng miễn phí theo phần trăm.

## 21. CombatAction

```text
actor + believed target/area
+ prerequisites + reservations
+ prepare/commit/effect/recover phases
+ trajectory/contact model
+ interrupt/abort rules
+ signals + outputs + evidence
```

Definition tách ActionInstance.

## 22. Pha chuẩn bị

Chuẩn bị chỉnh tư thế, lấy đà, niệm/chuyển khí hoặc ngắm. Có thể đổi/hủy trong giới hạn.

Đối phương có thể thấy dấu chuẩn bị.

## 23. Điểm cam kết

Sau commit, lực/vật/PhenomenonProcess có thể không thu hồi. Resource được tiêu đúng phase.

Save/load không bốc lại quyết định.

## 24. Pha hiệu lực

Effect giải trajectory, collision, field overlap hoặc contact tại world time. Kiểm lại target và obstruction hiện tại.

Event cũ không đánh trúng target đã rời nếu đường không còn hợp lệ.

## 25. Pha hồi phục

Recovery là thời gian lấy lại tư thế, chú ý và khả năng dùng chi. Đổi action không xóa recovery.

Kỹ năng có thể giảm bằng cơ chế thật.

## 26. Ngắt

Interrupt do mất ý thức, mất footing, đau, contact, thiếu nguồn hoặc quyết định hợp lệ. Outcome phụ thuộc phase.

Không mặc định mọi ngắt gây tẩu hỏa.

## 27. Đồng thời

Các effect cùng mốc đọc state trước wave, tạo deltas rồi resolve conflict theo luật miền. Hai người có thể cùng bị thương.

ID nhỏ không được ưu tiên thắng.

## 28. Reservation

Chi, tay, vũ khí, không gian, attention, linh lực và item hỗ trợ được giữ theo interval. Hai action không dùng toàn công suất cùng nguồn.

Reservation không tự tiêu resource.

## 29. Movement action

Đi, chạy, bò, nhảy, leo, bơi và bay dùng body/terrain/encumbrance. Path có thời gian và có thể bị chặn.

Không teleport theo nhãn “rút lui”.

## 30. Momentum

Vận tốc và khối lượng ảnh hưởng dừng, đổi hướng, va chạm và ngã. Mức chi tiết theo K4.1 và BR.

Không cần mô phỏng phân tử.

## 31. Reach

Reach phụ thuộc anatomy, posture, grip, weapon geometry và obstacle. Mất tay hoặc đổi grip sửa affordance.

Một vũ khí dài có bất lợi ở nơi chật.

## 32. Targeting

TargetSpec dựa trên PerceptionTrack hoặc vùng ước lượng. Không dùng global entity ID bí mật.

Mục tiêu giả/che chắn có thể đánh lừa.

## 33. Accuracy

Sai lệch từ perception, timing, control, motion, fatigue, pain, weapon và environment. RNG chỉ lấy trong distribution có nguồn.

Không dùng tỷ lệ trúng tách rời state.

## 34. Contact

ContactSolver tìm vùng chạm, hướng, area, relative speed và material interfaces. Miss/graze/hit là kết quả dẫn xuất.

Không bốc body part sau khi đã có geometry.

## 35. Impact

Impulse/pressure/shear/penetration/heat/chemical/spiritual transfer đi qua vật cản, giáp và body. Mỗi lớp nhận delta một lần.

Không cộng damage number lần hai.

## 36. Vết thương

K4.2 tạo InjuryPath trên tissue/organ/network, rồi Function ảnh hưởng action tiếp theo. Không có thanh máu canonical.

Chảy máu, đau và bất tỉnh tiếp tục sau giao chiến.

## 37. Critical outcome

“Chí mạng” là hậu quả của cấu trúc bị ảnh hưởng, không phải xác suất nhân damage. Vết nhỏ đúng vị trí có thể nguy hiểm.

UI chỉ mô tả điều nhân vật biết.

## 38. Pain và shock

Pain signal, stress response và tuần hoàn ảnh hưởng attention/control. Ý chí có thể đổi decision nhưng không phục hồi mô.

Thuốc giảm đau không chữa injury.

## 39. Grapple

Khống chế giữ contact graph, grips, leverage, posture và joint limits. Mỗi bên có action/reaction theo body.

Không biến người thành trạng thái “stunned” vô nguồn.

## 40. Falling

Ngã/rơi dùng độ cao, collision surface, orientation và vật cản. Kết quả qua vật lý/body.

Bay mất nguồn có transition, không teleport xuống đất.

## 41. Vũ khí

Weapon capability từ material, geometry, edge, mass, balance, grip và condition. Dùng sai cách vẫn có thể nhưng khác hiệu quả/rủi ro.

Tên phẩm cấp không thay solver.

## 42. Hỏng vũ khí

Stress, fatigue, edge wear và joint failure tạo state thật. Mảnh gãy có identity/trajectory khi cần.

Không xóa weapon khi durability về 0.

## 43. Giáp

Armor coverage theo vùng/góc/lớp/fit; truyền lực/nhiệt và hỏng theo material. Khe hở thật mới cho penetration.

Giáp thân không bảo vệ ngón tay.

## 44. Khiên và phòng hộ

Shield cần position/orientation/grip, chịu lực và có thể lệch/gãy. Barrier thuật dùng source/field riêng.

Hai loại không cộng thành phần trăm giảm chung.

## 45. Vật phóng

Projectile giữ launch state, trajectory, drag/gravity/field, collision và remaining energy. Sau phóng có thể tiếp tục khi người bắn bất tỉnh.

Đạn/mũi tên là item thật.

## 46. Nhiều vật phóng

Volley được batch khi trajectory/context tương đồng nhưng collision/outcome phân từng projectile hoặc parcel hợp lệ.

Không biến thành sát thương vùng vô căn cứ.

## 47. Lửa, độc và chất

Cháy, khói, độc, acid và khí dùng K4.1/K4.2/K4.4, tiếp tục theo process. Friendly fire theo vùng thật.

Kết thúc combat không xóa chúng.

## 48. Thuật pháp

Cast dùng ProgramIR K4.5: prerequisites, route, source, phase, target, propagation, sustain và byproduct.

Cảnh giới không bỏ qua thiếu nguồn hay injury.

## 49. Line of effect

Thuật truyền qua ray, volume, field, medium, resonance hoặc link đã khai. Cover/counter chỉ tác động nếu interface phù hợp.

Không dùng “ma pháp xuyên mọi thứ” mặc định.

## 50. Sustain

Hiệu ứng duy trì có rate, control, attention và termination. Mất condition dừng/biến đổi theo Program.

Không chặn miễn phí sau khi cạn linh lực.

## 51. Counter

Counter tác động source, phase, route, medium, waveform, target lock hoặc output. Timing và compatibility quyết định.

Không dùng vòng nguyên tố nhãn cứng.

## 52. Dispel

Dispel là interaction với Process/anchor, có detection và transfer. Thành công có thể để residue/byproduct.

Không xóa effect bằng quyền UI.

## 53. Trận pháp

Formation có node, connection, source, field và operator. Phá node đổi topology từ mốc thật.

Ra khỏi vùng chỉ thoát nếu geometry/field cho phép.

## 54. Pháp khí

Artifact có ports, stored energy, control interface, condition và ownership. Bị cướp không tự đổi quyền hợp pháp nhưng đổi custody.

Vật khóa chủ cần cơ chế nhận diện thật.

## 55. Luyện thể

Adaptation đổi capacity/tolerance/anatomy, không miễn injury. Tải vượt giới hạn vẫn có hậu quả.

Khắc chế dựa interaction, không nhãn cảnh giới.

## 56. Thần thức

Sense thần thức có source, range, propagation, noise, signature và counter. Nó không đọc tâm trí/identity mặc định.

Chi tiết bản chất còn chưa chốt.

## 57. Tâm trí

Thuật ảnh hưởng nhận thức tạo signal/process vào cognition; belief/decision đổi theo cơ chế. Không trực tiếp ra lệnh Agent nếu không định nghĩa capability.

Ký ức sai không sửa World Fact.

## 58. Nhóm

SquadPlan có goal, roles, formation, signals, rendezvous, retreat và casualty response. Thành viên vẫn là Agent độc lập.

Chỉ huy không điều khiển khi lệnh chưa tới.

## 59. Mệnh lệnh

Order là Message từ authority/relationship, có scope và timestamp. Người nhận hiểu, đánh giá và thi hành khi có thể.

Mất liên lạc tạo local initiative.

## 60. Formation movement

Đội hình là constraint mềm theo vị trí/tốc độ/tầm nhìn; địa hình và thương tích làm biến dạng.

Không snap người vào ô.

## 61. Friendly fire

Targeting và area effect xét đồng minh thật. Policy có thể tránh nhưng không tạo miễn nhiễm.

Nhận diện sai có thể gây tai nạn.

## 62. Morale

Morale là View từ fear, goal, cohesion, leadership belief, loss và retreat options của từng người. Không có thanh ép cả đội chạy.

Tan vỡ là chuỗi quyết định cá nhân có tương tác.

## 63. Phục kích

AmbushPlan cần concealment, timing, target belief và escape. Người phục kích vẫn phát signal.

Không bảo đảm critical hit.

## 64. Ẩn nấp

Concealment giảm signal theo cover, light, noise, odor, qi và behavior. Hidden là quan hệ observer-target.

Không có trạng thái vô hình toàn cục.

## 65. Ngụy trang

Camouflage/disguise đổi signal/identity evidence; kiểm tra gần hoặc hành vi có thể phá.

Trang phục không tự cấp danh tính khác.

## 66. Theo dõi

Follower giữ mục tiêu qua PerceptionTrack, route prediction và khoảng cách. Mất dấu tạo search.

Không bám bằng entity ID.

## 67. Dấu vết

Footprint, máu, vật rơi, cành gãy, mùi, residue thuật và witness message là entity/signal có decay, contamination và provenance.

Không sinh clue chỉ vì có quest.

## 68. Truy đuổi

Pursuit là Joint/competing plans qua route, stamina, track belief, terrain và goal. Pursuit limit ngăn chạy vô hạn.

Thoát contact không xóa việc truy tìm.

## 69. Tìm kiếm

SearchPlan phân vùng theo last-known position, uncertainty, mobility và evidence. Người tìm có thể bỏ sót.

Không quét fog-of-war bằng query toàn tri.

## 70. Thoát thân

Escape đạt khi không còn effect/contact hợp lệ và pursuer không duy trì track/khả năng chặn trong horizon. Nó không xóa hostility.

Đồ bỏ lại nằm tại chỗ.

## 71. Đầu hàng

SurrenderOffer cần truyền, hiểu và chấp nhận. Terms gồm hạ vũ khí, custody, bảo đảm và thời điểm.

Đòn đã phóng vẫn tiếp tục nếu không có cơ chế chặn.

## 72. Đình chiến

Ceasefire là contract có parties, scope, start, duration và breach. Người chưa nhận tin có thể tiếp tục và tạo tranh chấp.

Không đổi toàn bộ faction tức thì.

## 73. Bắt giữ

Capture cần control/custody Action, restraints và người canh. Người bị bắt vẫn có body, needs, rights và Agent.

Không đưa Person vào inventory.

## 74. Trói và giam

Restraint là item/contact constraint có fit, integrity và khả năng thoát. Detention cần nơi, food, care và review K4.7.

Không duy trì miễn phí.

## 75. Cứu hộ

Sau nguy hiểm, triage và evacuation cạnh tranh thời gian. Cõng người đổi tải/tốc độ; chữa trị dùng vật thật.

Không hồi sinh đồng đội khi combat kết thúc.

## 76. Hiện trường

SceneSnapshot không đóng băng world; nó ghi boundary, topology, item/body positions, stains, damage và known access.

Mưa, người qua và dọn dẹp tiếp tục đổi evidence.

## 77. Evidence

EvidenceItem có origin hypothesis, chain of custody, integrity, contamination, observations và access. Investigator không biết origin canonical.

Vật chứng vẫn là Item.

## 78. Nhân chứng

WitnessMemory chỉ chứa điều đã cảm nhận/diễn giải. Stress, góc nhìn và thời gian ảnh hưởng retrieval.

Lời khai không tự thành Fact.

## 79. Tái dựng

Reconstruction tạo hypotheses về timeline/trajectory từ evidence và model, kèm uncertainty. Nhiều giả thuyết có thể cùng sống.

Không phát lại “đoạn phim thật” cho gameplay.

## 80. Pháp y

Examination dùng knowledge, tool, body/item state và thời gian. Kết luận có scope/confidence và có thể sai.

Chi tiết y sinh chưa được tuyên bố chính xác ngoài đời.

## 81. Truy nguồn thuật

Residue/signature có thể gợi Technique family, source composition hoặc artifact; không tự biết người thi triển.

Ngụy tạo và contamination cần operation.

## 82. Trách nhiệm

Conduct, causation, intent belief, justification và legal finding tách nhau. Combat solver chỉ tạo Facts/evidence.

K4.7 xử Case/Ruling.

## 83. Tự vệ

SelfDefenseClaim phụ thuộc threat belief, timing, necessity và proportionality rule của jurisdiction. Có thể hợp lý với actor nhưng bị xử khác.

Nhãn tự vệ không xóa injury.

## 84. Danh tiếng

Tin về chiến đấu truyền qua witness/message/record. Người có thể kính, sợ hoặc ghét theo value.

Không cộng fame toàn thế giới.

## 85. Trả thù

Revenge goal sinh từ grievance/belief và cạnh tranh với nhu cầu khác. Nó cần tìm mục tiêu, chuẩn bị và cơ hội.

Không spawn kẻ báo thù tức thì.

## 86. Chấn thương dài hạn

Sẹo, mất chức năng, sợ hãi, nợ điều trị, mất nghề và thay quan hệ tiếp tục nhiều năm. Recovery theo body/cognition/economy.

Không reset khi qua vùng.

## 87. Tử vong

Death theo K4.2. Thi thể, vật, claim, message, grief, succession và investigation tiếp tục.

Killer belief khác legal responsibility.

## 88. Trẻ em và người yếu thế

Khả năng chạy, hiểu nguy hiểm, tự vệ và consent theo phát triển thật. Người chăm sóc có Goal bảo vệ nhưng không bảo đảm thành công.

Game không trao kỹ năng chiến đấu người lớn cho nhân vật sơ sinh.

## 89. Sinh vật

Động vật/quái vật có perception, physiology, drives và technique phù hợp loài. Không mặc định mọi sinh vật đánh đến chết.

Săn bắt nối quần thể K4.4.

## 90. Phá hủy môi trường

Lửa, hố, tường sập, ô nhiễm linh và cây gãy đổi world. Repair/erosion/succession tiếp tục.

Không reset chiến trường.

## 91. Chiến tranh

Campaign nối mobilization, supply, command, movement, battle, occupation và diplomacy. Trận lớn dùng phân tầng nhưng giữ Person/anchor quan trọng.

Không lấy population trừ nhau bằng một tỷ lệ vô nguồn.

## 92. Bao vây

Siege có fortification, food/water, disease, morale, engineering và relief. Thời gian làm cả hai bên đổi.

Kết quả không chỉ từ power score.

## 93. BR0–BR5

| Mức | Dùng khi | Cách giải |
|---|---|---|
| BR0 CONTACT | đòn/thuật trực tiếp | geometry, phase, part |
| BR1 SKIRMISH | nhóm nhỏ, giây–phút | từng Action/Event |
| BR2 ENCOUNTER | phút–giờ | plan + breakpoint |
| BR3 PURSUIT | giờ–ngày | route/evidence/interval |
| BR4 BATTLE | nhiều nhóm | formation/cohort + Person anchors |
| BR5 CAMPAIGN | ngày–năm | logistics/territory + battles |

BR không thay M/R/AR/SE và không xóa identity.

## 94. Promotion

Nâng BR trước contact với Person quan trọng, injury part-level, unique item, spell interaction, witness/evidence hoặc player horizon.

Không giải BR4 xong rồi bịa đòn BR0 ngược.

## 95. Demotion

Hạ khi action/effect/contact khép, body/item deltas committed, evidence sinh, casualty/custody xác định và pursuit frontier lập.

Active projectile/fire/poison ngăn hạ nếu handler thấp không hỗ trợ.

## 96. CombatCapsule

Giữ participants, goals, positions/classes, body/item summaries, active effects, supplies, morale beliefs, command links, evidence anchors và next boundary.

Capsule là canonical compressed state.

## 97. Batch battle

Batch key theo formation, equipment, training, terrain, command, supply và objective. Outcome phân casualties, injuries, item loss và position về đơn vị/Person theo rule.

ID không quyết định ai chết.

## 98. Bảo toàn

Vật, năng lượng, đạn, linh lực, người và vị trí có ledger/boundary flow. Casualty không biến thành sink tài sản.

Loot cần custody/transaction sau.

## 99. Determinism

Cùng save, command, content, policy và RNG stream cho cùng Fact. Số luồng, FPS và UI không đổi collision/outcome.

Save giữa phase không phát effect hai lần.

## 100. Hiệu năng

Scheduler chỉ đánh thức combat horizon và process liên quan. Continuous processes tích phân tới breakpoint.

Máy chậm không được bỏ projectile hay injury.

## 101. Mobile và desktop

Cùng core và save. Điện thoại trình bày threat/goal/body/choices theo thẻ; desktop thêm timeline, vị trí text-grid và causal trace.

Không yêu cầu thao tác phản xạ.

## 102. Giao diện text

Mặc định nêu: điều nhận biết, mục tiêu hiện tại, phase, nguy cơ, chức năng bị ảnh hưởng, nguồn và phương án. Cho mở sâu tới route/contact/injury khi biết.

Không lộ tỷ lệ thắng canonical.

## 103. Nhật ký

CombatLog nhóm thao tác thường nhưng giữ commit, effect, injury, break, death, surrender và evidence. Mỗi dòng gameplay theo viewpoint.

Debug trace tham chiếu Fact/Process IDs.

## 104. Artifact tương lai

Cần Conflict/CombatAction/PerceptionTrack/Trajectory/Contact/Formation/Pursuit/Scene/Evidence schemas; BR handlers; combat policy; fixture; catalog CX01–CX96 và profiler.

Hiện chưa tạo.

## 105. Fixture K4B-F01 — hai đòn cùng mốc

Hai effect hợp lệ cùng xảy ra; cả hai injury có thể giữ, không ưu tiên ID.

## 106. Fixture K4B-F02 — né muộn

Reaction hoàn tất sau impact không hồi tố; movement tiếp theo dùng body đã bị thương.

## 107. Fixture K4B-F03 — giáp lệch

Trajectory chạm vùng không được che; giáp không hấp thu. Hit khác chạm lớp giáp làm nó hỏng.

## 108. Fixture K4B-F04 — kiếm gãy

Weapon fracture sinh mảnh/vị trí; action sau mất affordance, không biến item mất.

## 109. Fixture K4B-F05 — thuật bị ngắt

Ngắt trước/sau commit cho resource/residue khác, save/load giữ phase.

## 110. Fixture K4B-F06 — barrier cạn

Sustain tiêu nguồn theo thời gian; cạn trước impact thì không chặn miễn phí.

## 111. Fixture K4B-F07 — friendly fire

Area effect tác động đồng minh trong volume; policy chỉ ảnh hưởng quyết định phát.

## 112. Fixture K4B-F08 — phục kích

Signal/perception/reaction tạo surprise; pause không rewind.

## 113. Fixture K4B-F09 — mất dấu

Target rời sight; tracker tìm từ last-known/evidence, không theo ID.

## 114. Fixture K4B-F10 — đầu hàng khi đạn đã bay

Offer được nhận nhưng projectile tiếp tục; hậu quả ảnh hưởng acceptance/trách nhiệm.

## 115. Fixture K4B-F11 — bắt giữ

Restraint/custody/guard/needs giữ; Person không thành item.

## 116. Fixture K4B-F12 — mưa xóa dấu

Footprint/blood decay theo weather; investigator không nhận clue bù.

## 117. Fixture K4B-F13 — phán quyết sai

Evidence thiếu dẫn Ruling sai có provenance; World Fact giữ nguyên.

## 118. Fixture K4B-F14 — hậu quả mười năm

Injury, nghề, nợ, quan hệ và revenge goal tiến theo hệ thật.

## 119. Fixture K4B-F15 — BR round-trip

Battle BR4 nâng tới BR0 giữ casualty, supply, position, evidence và Person anchors.

## 120. Fixture K4B-F16 — parity

Cùng save/intent trên điện thoại và máy tính cho cùng Facts.

## 121. Điều kiện CX01–CX96

### Boundary, thời gian và không gian

| ID | Điều kiện |
|---|---|
| CX01 | combat không tạo arena copy |
| CX02 | conflict có goal/source |
| CX03 | de-escalation không rewind effect |
| CX04 | policy không bảo đảm outcome |
| CX05 | lệnh mới tôn trọng phase |
| CX06 | range dẫn xuất geometry |
| CX07 | posture chuyển có thời gian |
| CX08 | footing có material/terrain source |
| CX09 | cover chỉ chắn đường cắt |
| CX10 | visibility không thành identity |
| CX11 | signal propagation có noise |
| CX12 | surprise không tạo lượt miễn phí |
| CX13 | reaction cần perception/time/body |
| CX14 | cùng mốc không ưu tiên ID |
| CX15 | reservation không tiêu resource |
| CX16 | movement không teleport |

### Action, vật lý và cơ thể

| ID | Điều kiện |
|---|---|
| CX17 | ActionInstance giữ phase/version |
| CX18 | commit tiêu đúng một lần |
| CX19 | event cũ kiểm lại trajectory |
| CX20 | recovery không bị bỏ qua |
| CX21 | interrupt outcome theo phase |
| CX22 | chi/tay không dùng hai action xung đột |
| CX23 | targeting không dùng ID bí mật |
| CX24 | RNG accuracy có distribution nguồn |
| CX25 | contact không bốc body part tùy ý |
| CX26 | impact qua mỗi lớp một lần |
| CX27 | injury không cộng HP damage |
| CX28 | critical từ cấu trúc |
| CX29 | pain không chữa/nhân injury |
| CX30 | grapple giữ contact graph |
| CX31 | fall theo height/surface |
| CX32 | death theo body state |

### Vật phẩm và thuật pháp

| ID | Điều kiện |
|---|---|
| CX33 | weapon capability từ cấu trúc |
| CX34 | weapon gãy không biến mất |
| CX35 | armor coverage theo vùng/góc |
| CX36 | shield cần orientation/grip |
| CX37 | projectile là entity thật |
| CX38 | người bắn ngất không xóa projectile |
| CX39 | ammo không vô hạn |
| CX40 | fire/poison tiếp tục sau combat |
| CX41 | cast dùng ProgramIR |
| CX42 | cast không bỏ qua resource |
| CX43 | line-of-effect theo medium |
| CX44 | sustain cạn thì dừng |
| CX45 | counter theo interface/timing |
| CX46 | dispel không xóa vô nguồn |
| CX47 | formation node hỏng đổi topology |
| CX48 | pháp khí đổi custody không tự đổi title |
| CX49 | luyện thể không miễn injury |
| CX50 | thần thức không đọc identity mặc định |
| CX51 | mind effect không sửa World Fact |
| CX52 | friendly fire theo volume |

### Nhóm, ẩn nấp và truy đuổi

| ID | Điều kiện |
|---|---|
| CX53 | order cần message/authority |
| CX54 | mất liên lạc không giữ control |
| CX55 | formation không snap position |
| CX56 | morale không là thanh đội |
| CX57 | ambush cần concealment/timing |
| CX58 | hidden là quan hệ observer-target |
| CX59 | disguise không đổi identity |
| CX60 | following không dùng ID |
| CX61 | trace có decay/provenance |
| CX62 | pursuit dùng route/stamina |
| CX63 | search không quét toàn tri |
| CX64 | escape không xóa hostility |
| CX65 | surrender cần truyền/accept |
| CX66 | ceasefire chỉ áp đúng parties |
| CX67 | capture không biến Person thành item |
| CX68 | detention cần guard/resource |

### Hiện trường và hậu quả

| ID | Điều kiện |
|---|---|
| CX69 | cứu hộ dùng thời gian/vật |
| CX70 | scene tiếp tục bị môi trường đổi |
| CX71 | evidence giữ chain of custody |
| CX72 | witness chỉ kể điều nhận |
| CX73 | reconstruction giữ uncertainty |
| CX74 | pháp y cần skill/tool |
| CX75 | residue không tự chỉ caster |
| CX76 | conduct tách legal finding |
| CX77 | self-defense claim không xóa injury |
| CX78 | reputation cần message/network |
| CX79 | revenge goal có belief/source |
| CX80 | sẹo/mất nghề giữ lâu dài |
| CX81 | death không xóa item/claim |
| CX82 | trẻ em không có capability người lớn |
| CX83 | động vật không mặc định đánh chết |
| CX84 | môi trường không reset |

### Phân tầng, save và parity

| ID | Điều kiện |
|---|---|
| CX85 | war cần mobilization/supply |
| CX86 | siege dùng food/water/disease |
| CX87 | BR không thay identity |
| CX88 | promotion trước contact chi tiết |
| CX89 | không dựng ngược đòn sau batch |
| CX90 | demotion chờ active effect |
| CX91 | capsule giữ evidence/pursuit |
| CX92 | batch phân casualty từng anchor |
| CX93 | vật/người qua boundary có flow |
| CX94 | save/load không phát effect lặp |
| CX95 | số luồng không đổi outcome |
| CX96 | mobile/desktop cùng semantic outcome |

CX01–CX96 là điều kiện thiết kế chưa mã hóa và chưa chạy. Tổng hồ sơ tăng từ 1.764 lên 1.860 điều kiện thuộc 41 họ.

## 122. Cổng K4.8

| Cổng | Đạt khi | Hiện tại |
|---|---|---|
| K4B01 | intent–action–interaction–injury rõ | đạt trên giấy |
| K4B02 | perception/reaction không toàn tri | đạt trên giấy |
| K4B03 | weapon/spell/counter theo cơ chế | đạt trên giấy |
| K4B04 | group/pursuit/surrender có nhân quả | đạt trên giấy |
| K4B05 | scene/evidence/law boundary rõ | đạt trên giấy |
| K4B06 | BR0–BR5 và hậu quả xa rõ | đạt trên giấy |
| K4B07 | schema/solver/IR tồn tại | chưa |
| K4B08 | K4B-F01–F16 mã hóa | chưa |
| K4B09 | CX01–CX96 chạy có evidence | chưa |
| K4B10 | battle workload đạt | chưa |

## 123. Vấn đề mở

1. Geometry bản đầu dùng continuous, grid hay hybrid?
2. Có tốc độ chậm riêng khi chiến đấu không?
3. Độ sâu projectile/fluid/fire?
4. Quy tắc đau, shock và bất tỉnh?
5. Võ kỹ khởi đầu nào?
6. Thuật chiến đấu chặng đầu?
7. Bay và không chiến có trong bản đầu?
8. Grapple/bắt giữ sâu tới đâu?
9. Trẻ em có thể gặp/bị ảnh hưởng bạo lực ở mức hiển thị nào?
10. Cơ chế đầu hàng và tù nhân?
11. Chuẩn tự vệ/hình phạt theo vùng?
12. Battle lớn tối đa bao nhiêu Person?
13. Dấu vết giữ bao lâu?
14. UI vị trí text trên điện thoại?
15. Mức gore/chi tiết nhạy cảm?
16. K4.9 chốt vertical slice nào?

Chưa mục nào được tự chốt.

## 124. Rủi ro

| Rủi ro | Hậu quả | Kiểm soát |
|---|---|---|
| HP/damage trùng injury | sai cơ thể | transfer một lần |
| turn arena | phá thời gian chung | world-time phases |
| AI toàn tri | phục kích vô nghĩa | PerceptionTrack |
| phản xạ quá nhanh | không chơi được | intent + pause |
| thuật theo nhãn | combat nông | Program/interface |
| dấu vết quest | điều tra giả | physical evidence |
| reset hậu chiến | đời sống rỗng | body/item/social persistence |
| battle batch xóa người | mất lịch sử | Person anchors |

## 125. Trình tự hiện thực hóa khi được yêu cầu

1. Conflict/CombatAction/phase/reservation.
2. local geometry, movement, perception/reaction.
3. contact/impact → item/body.
4. projectile, armor, cover.
5. spell propagation/sustain/counter.
6. group/order/ambush/pursuit.
7. surrender/capture/rescue.
8. scene/evidence/investigation/law.
9. BR0–BR5, capsule, save/parity.
10. fixture, CX01–CX96 và workload.

Đây là thứ tự triển khai tương lai, chưa phải việc đã làm.

## 126. Những điều không được tuyên bố

- Không nói combat solver hoặc game đã chạy.
- Không nói mô hình thương tích/vật lý chính xác ngoài đời.
- Không nói đã chốt geometry, võ kỹ hay thuật chiến đấu.
- Không nói đã hỗ trợ chiến tranh quy mô lớn.
- Không nói BR0–BR5 đạt parity.
- Không nói CX01–CX96 đã chạy.
- Không nói 1.860 điều kiện là test tự động.

## 127. Giá trị K4.8 cung cấp thật

- chiến đấu ở trong world time/space chung;
- nhận biết, phản ứng và target không toàn tri;
- tác động đi qua vật phẩm, hiện tượng và body một lần;
- thuật pháp có phase, đường truyền và counter;
- phục kích, truy đuổi, đầu hàng và bắt giữ có quá trình;
- dấu vết nối điều tra và luật;
- hậu quả tiếp tục nhiều năm;
- BR0–BR5 giữ quy mô lớn;
- 16 fixture và 96 điều kiện có thể mã hóa sau.

## 128. Bước tiếp theo

K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; bước tiếp theo là prototype chọn stack và V0 skeleton khi người dùng yêu cầu bắt đầu làm game.
