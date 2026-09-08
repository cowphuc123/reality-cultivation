---
title: "K4.6 — NPC tự trị, nhu cầu, kế hoạch, quan hệ, ký ức và câu chuyện phát sinh sâu"
aliases:
  - "NPC tự trị sâu K4"
  - "Đời sống NPC phát sinh K4"
tags:
  - reality-cultivation
  - ke-hoach
  - k4
  - npc
status: de-xuat
updated: 2026-09-06
---

# K4.6 — NPC tự trị, nhu cầu, kế hoạch, quan hệ, ký ức và câu chuyện phát sinh sâu

> [!summary]
> Tài liệu này mở rộng [[NPC]], [[DOI_SONG_TU_SINH_K1]] và hợp đồng nhận thức K2.4 trên nền cơ thể, vật phẩm, môi trường và công pháp K4. Mỗi NPC có đời sống riêng vì họ cảm nhận, đánh giá, lập kế hoạch, hành động, học và chịu hậu quả trong cùng thế giới. Đây là thiết kế chưa triển khai; “như người thật” là mục tiêu trải nghiệm, không phải tuyên bố mô phỏng hoàn chỉnh tâm trí con người.

## 1. Mục tiêu

NPC phải có chuỗi nhân quả cá nhân:

```text
trạng thái thật → tín hiệu có thể cảm nhận → chú ý và diễn giải
→ nhu cầu/giá trị/nghĩa vụ → mục tiêu → kế hoạch
→ hành động dùng thời gian và tài nguyên thật → hậu quả
→ ký ức, học hỏi, cảm xúc, quan hệ và kế hoạch mới
```

Câu chuyện là cách nhìn vào chuỗi này, không phải kịch bản bí mật điều khiển NPC.

## 2. Phạm vi

K4.6 định:

- PersonAgent và ranh giới với World State;
- nhu cầu, động cơ, giá trị, vai trò và nghĩa vụ;
- mục tiêu, kế hoạch nhiều tầng, lịch và khả năng thích nghi;
- chú ý, niềm tin, ký ức, học hỏi và mô hình về người khác;
- cảm xúc, stress, thói quen và thay đổi dài hạn;
- quan hệ hai chiều, mạng xã hội, gia đình và nhóm;
- giao tiếp, thương lượng, hợp tác, xung đột và lừa dối;
- nghề nghiệp, sinh kế, tu luyện và lựa chọn đường đời;
- vòng đời, di cư, mất tích, chết và di sản;
- câu chuyện phát sinh, độ đáng chú ý và cách kể theo góc nhìn;
- AR0–AR5 cho NPC xa, lưu tải, hiệu năng và giao diện;
- fixture, điều kiện kiểm chứng và cổng triển khai.

## 3. Ranh giới chủ quản

| Miền | Sở hữu |
|---|---|
| cơ thể K4.2 | sinh lý, đau, bệnh, chức năng và tử vong |
| vật phẩm K4.3 | vật thật, công dụng, tình trạng và chế tác |
| môi trường K4.4 | nơi, thời tiết, tài nguyên và hiểm họa |
| công pháp K4.5 | Program, Knowledge, Mastery và đột phá |
| cognition K2.4/K4.6 | chú ý, belief, memory, goal, plan và decision |
| giao dịch K2.3 | quyền, claim, nghĩa vụ và chuyển giao |
| scheduler K2.2 | thời gian, event, process và conflict |
| xã hội K4.7 | luật, thị trường, tổ chức và quyền lực tập thể |

Agent chỉ gửi Command; không tự sửa body, tiền, vật, quan hệ pháp lý hoặc kết quả thế giới.

## 4. PersonAgent

```text
person_ref
policy_profile + values + drives
belief_store + memory_store + relationship_views
goal_graph + plan_portfolio + commitments
affect_state + habits + self_model
social_models + decision_history
attention/wakeup state + cognition budget
```

PersonAgent dùng cùng Person identity; không sinh “bộ não” thay thế người thật.

## 5. Sự thật, nhận thức và hành động

Ba lớp bắt buộc tách:

1. World Fact là điều thực sự xảy ra.
2. Belief là điều NPC cho là đúng.
3. Command là điều NPC thử làm dựa trên Belief.

Thành công của Command do hệ thống thật quyết định. NPC không được biết trước outcome.

## 6. SelfModel

NPC có niềm tin về sức khỏe, kỹ năng, địa vị, tài sản, danh tiếng và giới hạn của chính mình. SelfModel có thể lạc hậu hoặc sai.

Người bị bệnh nhưng tưởng chỉ mệt sẽ lập kế hoạch khác người đã được chẩn đoán đúng.

## 7. Nhu cầu không phải thanh điều khiển

Nhu cầu là áp lực quyết định được suy từ cảm giác, dự báo và hoàn cảnh:

- sống còn: thở, nước, thức ăn, nhiệt, ngủ;
- an toàn: trú ẩn, điều trị, tránh đe dọa;
- duy trì: sinh kế, dụng cụ, chỗ ở, dự trữ;
- xã hội: gắn bó, chăm sóc, thuộc về, được công nhận;
- năng lực: học, làm chủ nghề, tu luyện;
- ý nghĩa: giá trị, đức tin, lý tưởng, di sản.

Không bắt mọi người tối đa hóa cùng một tháp nhu cầu.

## 8. DriveInstance

Mỗi áp lực đang hoạt động giữ source, perceived state, urgency, trajectory, satiation expectation, uncertainty và next review.

Khát tăng từ physiology nhưng NPC chỉ phản ứng qua tín hiệu nhận được và kinh nghiệm.

## 9. Homeostatic forecast

NPC dự báo “nếu tiếp tục thế này” bằng mô hình đã học. Kế hoạch có thể ưu tiên ăn trước khi đói nặng, mua thuốc trước khi hết hoặc trú trước bão.

Dự báo sai tạo hành vi sai có lý do, không phải lỗi ngẫu nhiên.

## 10. Giá trị

ValueProfile biểu diễn những điều người đó coi trọng: gia đình, tự do, danh dự, từ bi, chính thống, tri thức, giàu có, quyền lực, an toàn hoặc tu đạo.

Giá trị ảnh hưởng cách đánh giá phương án; nó không tạo quyền hoặc knowledge.

## 11. Xung đột giá trị

Một lựa chọn có thể giữ lời nhưng nguy hiểm, cứu người thân nhưng phạm luật, hoặc tăng cảnh giới bằng phương pháp NPC ghê sợ. DecisionTrace lưu các giá trị đã xung đột.

Không ép xung đột về một điểm đạo đức thiện–ác duy nhất.

## 12. Aspiration

Khát vọng là hướng dài hạn có thể chưa có kế hoạch khả thi: thành thầy thuốc, vào tông môn, bảo vệ gia đình, tìm trường sinh.

Khát vọng chỉ thành Goal khi NPC nhận ra đường đi hoặc quyết định tìm đường.

## 13. Vai trò và nghĩa vụ

Role gồm kỳ vọng, quyền, lịch, người phụ thuộc và hậu quả dự kiến. Một người có nhiều role: cha, học đồ, chủ nợ, trưởng nhóm.

Nghĩa vụ khách quan nằm ở hợp đồng/xã hội; cognition giữ hiểu biết và ý định thực hiện.

## 14. GoalGraph

Goal có source, desired proposition, priority basis, deadline/window, dependencies, conflict set, success/failure evidence, commitment và review rule.

Goal con không được tồn tại nếu không dẫn tới mục tiêu cha, nhu cầu, nghĩa vụ hoặc hành động khám phá hợp lệ.

## 15. Các loại mục tiêu

- duy trì trạng thái;
- đạt trạng thái;
- tránh trạng thái;
- tìm hiểu;
- bảo vệ người/tài sản;
- thực hiện nghĩa vụ;
- học hoặc rèn;
- thay đổi quan hệ;
- tạo ảnh hưởng lâu dài.

Mỗi loại có cách kiểm tra tiến triển riêng.

## 16. Sinh mục tiêu

Nguồn gồm signal cơ thể, event, message, deadline, role, habit, aspiration, opportunity và dự báo. GoalProposal ghi nguồn để giải thích.

Không tạo mục tiêu gây chuyện chỉ vì hệ thống muốn có nội dung.

## 17. Chọn mục tiêu

Goal arbitration xét urgency, expected harm, value fit, obligation, opportunity window, confidence, switching cost và resource conflict.

Đây là so sánh có cấu trúc; trọng số cụ thể chưa chốt và có thể khác theo cá nhân.

## 18. Commitment

Commitment giữ NPC theo việc đủ lâu để có hành vi ổn định. Nó tăng theo lời hứa, đầu tư đã thực hiện, căn tính và người phụ thuộc; giảm khi mục tiêu mất nghĩa hoặc không khả thi.

Sunk cost có thể gây cố chấp nhưng không mặc định là quyết định đúng.

## 19. Goal abandonment

Từ bỏ cần reason: đạt, bất khả thi, chi phí vượt ngưỡng, deadline mất, giá trị đổi, thông tin mới, cưỡng ép hoặc mục tiêu cao hơn thắng.

Lịch sử giữ reason để câu chuyện có tính liên tục.

## 20. PlanPortfolio

NPC giữ nhiều kế hoạch:

- kế hoạch đang thi hành;
- phương án dự phòng;
- kế hoạch chờ điều kiện;
- routine định kỳ;
- dự án dài hạn;
- kế hoạch phối hợp với người khác.

Chỉ các bước gần mới cần cụ thể.

## 21. Lập kế hoạch phân cấp

Khát vọng → milestone → project → task → Action Command. Ví dụ “vào môn phái” phân thành tìm điều kiện, học chữ, kiếm lộ phí, tới kỳ khảo hạch.

Planner không lập từng bữa ăn cho mười năm.

## 22. Temporal plan

Mỗi bước có duration belief, earliest/latest time, precondition, reservation need, location, collaborators và interruptibility.

Lịch phải tôn trọng 5 giây ngoài đời bằng một ngày game nhưng hành động vẫn có độ dài giờ/phút khi cần.

## 23. Resource-aware plan

NPC chỉ dựa trên tài nguyên họ tin có thể tiếp cận. Execution kiểm quyền và tồn kho thật.

Kế hoạch dùng cùng tiền, thức ăn, công cụ, thuốc, linh thạch và thời gian với người chơi.

## 24. Contingency

PlanBranch định trigger và phương án: mưa thì làm trong nhà; thuốc hết thì hỏi nơi khác; thầy từ chối thì tìm người giới thiệu.

Không cần nhánh cho mọi khả năng; thất bại lạ sẽ kích hoạt replanning.

## 25. Replanning

Replan khi precondition sai, thời lượng lệch, resource mất, message tới, cơ thể đổi, deadline gần hoặc outcome khác dự kiến.

Không replan mỗi tick. Scheduler đánh thức tại boundary có ý nghĩa.

## 26. Avoidance of loops

FailureSignature giữ action, target, reason, context revision và retry condition. Không thử lại cùng việc khi chưa có thay đổi liên quan.

Sau nhiều thất bại, NPC đổi phương án, tìm trợ giúp, hạ mục tiêu hoặc chấp nhận hậu quả.

## 27. Routine

Routine là plan template học được cho việc lặp như ăn, ngủ, mở quầy, luyện công. Nó tiết kiệm cognition nhưng vẫn kiểm điều kiện.

Routine không teleport tài nguyên hoặc bỏ qua hành động.

## 28. Habit

Habit hình thành khi cue–action–outcome lặp ổn định. Nó tăng xác suất chọn nhanh, giảm chi phí suy nghĩ và có thể tiếp tục dù không tối ưu.

Thay thói quen cần gián đoạn, động cơ hoặc môi trường mới.

## 29. Attention

NPC không xử mọi tín hiệu. Attention budget phân theo độ nổi bật, mục tiêu, nguy hiểm, mới lạ, cảm xúc, kỳ vọng và tải hiện tại.

Không chú ý không đồng nghĩa tín hiệu chưa tồn tại.

## 30. Perception episode

PerceptionEpisode giữ signal, sensor/channel, thời gian, vị trí, chất lượng, attention allocation và interpretation candidates.

Quan sát không tự thành Fact trong đầu; nó tạo Evidence cho BeliefRevision.

## 31. Salience

Salience tăng khi liên quan sống còn, mục tiêu, người thân, bất ngờ, lặp lại hoặc đối tượng có ý nghĩa. Mệt, đau, phân tâm và kỹ thuật che giấu làm giảm.

Không dùng khoảng cách đơn thuần để quyết định điều NPC nhận ra.

## 32. BeliefStore

Belief giữ proposition, scope, event time, learned time, confidence range, sources, supporting/conflicting evidence, freshness và access sensitivity.

Hai giả thuyết mâu thuẫn có thể cùng tồn tại.

## 33. Niềm tin về khả năng

NPC ước lượng outcome, chi phí và rủi ro từ kinh nghiệm, lời dạy và quan sát. Estimate có uncertainty.

NPC khôn ngoan vẫn có thể sai khi dữ liệu thiếu hoặc thế giới vừa đổi.

## 34. Belief revision

Cập nhật xét độ tin của nguồn, độc lập nguồn, độ mới, năng lực hiểu và consistency. Nhiều lời đồn cùng gốc không thành nhiều bằng chứng độc lập.

Không tự đồng bộ niềm tin với canonical state.

## 35. Ignorance

Unknown là trạng thái thật. NPC có thể biết mình không biết, không nhận ra lỗ hổng, hoặc tin sai rằng mình biết.

Biết thiếu thông tin có thể sinh Goal tìm hiểu.

## 36. Mental model of others

SocialModel chứa điều NPC tin về tính cách, năng lực, sở thích, nguồn lực, quan hệ và ý định của người khác.

Không đọc PersonAgent đối phương. Suy đoán phải dựa trên evidence.

## 37. Theory depth

Bản đầu giới hạn suy nghĩ xã hội ở “A nghĩ B có thể muốn X”; không mở vô hạn “A nghĩ B nghĩ C nghĩ…”.

Tầng sâu hơn chỉ tạo khi tương tác cụ thể cần và có ngân sách.

## 38. MemoryEpisode

Episode giữ event refs, những gì được nhận, cách hiểu lúc đó, affect, người liên quan, goal impact và retrieval cues.

Ký ức không phải bản sao toàn bộ Event.

## 39. Semantic memory

Kiến thức tổng quát được rút từ nhiều episode: đường thường nguy hiểm, thương nhân hay trễ, loại thuốc từng giúp.

Generalization có sample size, confidence và ngoại lệ.

## 40. Procedural memory

Kỹ năng/thói quen nối với hệ Mastery K4.5 và hành động. Cognition giữ cue, strategy và confidence; domain giữ năng lực thật.

Nhớ cách làm không bảo đảm cơ thể còn làm được.

## 41. Prospective memory

Việc cần nhớ trong tương lai tạo reminder/wakeup gắn thời điểm, tín hiệu hoặc người gặp. Quên có thể làm lỡ hẹn nhưng không xóa nghĩa vụ thật.

Đồ ghi chép và người nhắc là hỗ trợ vật chất/xã hội thật.

## 42. Consolidation

Ngủ, lặp lại, cảm xúc và ôn tập ảnh hưởng giữ ký ức. Consolidation dùng process theo khoảng, không xử từng ký ức mỗi tick.

Thông số tâm lý cụ thể cần hiệu chỉnh cho gameplay.

## 43. Retrieval

Nhớ lại phụ thuộc cue, recency, salience, context và interference. Truy hồi có thể thất bại hoặc trả bản tóm lược.

Engine không xóa record nguồn chỉ vì NPC tạm thời không nhớ được.

## 44. Forgetting

Quên giảm khả năng truy hồi/chi tiết/confidence; các anchor quan trọng và nghĩa vụ khách quan được giữ ở lớp thích hợp.

Không cho mọi quan hệ trở về trung tính sau một thời gian.

## 45. Distortion

Ký ức được kể lại hoặc diễn giải lại có thể đổi chi tiết, nhưng distortion phải có operation/provenance và không sửa World Fact.

Không dùng méo ký ức như RNG vô điều kiện.

## 46. Memory compaction

Việc thường ngày có thể gộp thành summary theo giai đoạn, giữ frequency, trend, exceptions, people, resource totals và anchor refs.

Một lần cứu mạng hoặc phản bội không bị chìm trong trung bình.

## 47. AffectState

Cảm xúc gồm appraisal có đối tượng: sợ nguy cơ, giận người bị cho là gây hại, biết ơn người được cho là giúp, buồn vì mất mát.

Affect có source, onset, intensity range, decay/reinforcement và action tendencies.

## 48. Appraisal

NPC đánh giá event theo goal relevance, responsibility belief, controllability, novelty và chuẩn mực cá nhân.

Cùng một Fact có thể tạo phản ứng khác nhau ở hai người.

## 49. Mood

Mood là nền chậm hơn từ sức khỏe, stress và chuỗi trải nghiệm; nó thiên lệch chú ý và dự báo nhưng không ra lệnh hành động.

Không thay personality sau một ngày xấu.

## 50. Stress load

Stress tích từ đe dọa, thiếu kiểm soát, quá tải, xung đột và thiếu hồi phục. Nó ảnh hưởng attention, sleep, error, patience và health qua interface cơ thể.

Stress không là debuff vô nguồn.

## 51. Coping

NPC có chiến lược giải quyết vấn đề, tìm hỗ trợ, né tránh, nghỉ, nghi lễ, dùng chất hoặc gây hấn. Việc chọn phụ thuộc học, văn hóa và nguồn lực.

Kết quả coping quay lại body, relation và goal.

## 52. Personality

Trait tương đối ổn định điều chỉnh threshold và preference. Biến cố lớn/lặp dài có thể tạo TraitChangeProposal với evidence.

Không gán hành vi cứng theo nhãn “tham”, “nhát” hoặc “ác”.

## 53. Identity narrative

NPC duy trì niềm tin về “mình là ai”: người chữa bệnh, đệ tử chính thống, người nuôi gia đình. Nó nối role, value, memory và aspiration.

Mâu thuẫn kéo dài có thể làm đổi self-concept.

## 54. RelationshipState

Quan hệ A→B tách:

- familiarity;
- affection;
- trust theo lĩnh vực;
- respect;
- fear;
- grievance;
- attachment;
- obligation awareness;
- boundary/preference.

B→A là record khác.

## 55. Relationship evidence

Mọi thay đổi quan hệ có event/evidence source và applied marker. Tải lại hoặc kể lại không cộng tác động lần hai.

Ấn tượng tổng hợp là View, không phải một thanh canonical.

## 56. Trust

Trust theo lĩnh vực: giữ lời, chuyên môn, giữ bí mật, an toàn, công bằng. Nó cập nhật từ kỳ vọng so với outcome mà NPC biết.

Yêu mến không tự thành tin chuyên môn.

## 57. Grievance

Grievance giữ perceived harm, blamed party, evidence, severity, desired remedy và status. Tha thứ, bồi thường và quên là các quá trình khác nhau.

NPC có thể trách nhầm người do belief sai.

## 58. Reciprocity

Giúp đỡ tạo ký ức, kỳ vọng hoặc nghĩa vụ theo văn hóa/tình huống; không tự đẻ khoản nợ pháp lý.

Đáp lễ phụ thuộc giá trị, khả năng và quan hệ.

## 59. Boundaries

NPC có preference về riêng tư, tiếp xúc, tài sản và chủ đề. Vi phạm có thể giảm trust hoặc sinh conflict dù không gây sát thương.

SocialModel học boundary qua giao tiếp và hậu quả.

## 60. Social network

Mạng chỉ lưu edge có căn cứ. Người chưa gặp không cần RelationshipState đầy đủ.

Các nhóm tạo đường truyền tin, hỗ trợ, ảnh hưởng và áp lực; không phải hive mind.

## 61. Household

Household gồm thành viên, quyền dùng tài sản, phân công, người phụ thuộc, ngân sách và quyết định chung theo quy tắc văn hóa.

Không gộp mọi vật thành sở hữu chung.

## 62. Kinship

Huyết thống, nhận nuôi, hôn nhân và quan hệ xã hội là edge khác nhau. Nghĩa vụ và cách gọi phụ thuộc văn hóa.

Lineage vẫn tồn tại sau di cư/chết và hỗ trợ thừa kế sau.

## 63. Friendship

Tình bạn hình thành từ thời gian chung, tương trợ, tương hợp và trải nghiệm; cần cơ hội tương tác thật.

Không farm tình bạn vô hạn bằng câu chào lặp.

## 64. Rivalry

Cạnh tranh có domain, mục tiêu, lịch sử và quy tắc. Hai người có thể là đối thủ tu luyện nhưng hợp tác bảo vệ làng.

Rivalry không tự thành thù giết người.

## 65. Group identity

Thành viên có mức gắn bó, hiểu chuẩn mực và kỳ vọng khác nhau. Nhóm ảnh hưởng quyết định qua role, incentive, sanction và belonging.

NPC không biết mọi bí mật của tổ chức.

## 66. Communication act

Giao tiếp là Action có người gửi/nhận, channel, nội dung belief, intent, timing, khả năng nghe/hiểu và quyền.

Lời nói không tự chuyển vật, tạo hợp đồng hoặc đổi Fact.

## 67. Dialogue turn

Turn chọn DialogueAct như hỏi, báo, yêu cầu, đề nghị, hứa, từ chối, cảnh báo, đe dọa, xin lỗi. Nội dung dựa trên belief có thể truy cập.

Ngôn ngữ hiển thị là projection của payload.

## 68. Conversation goal

Mỗi bên có mục tiêu, reservation, topic state và exit condition. Họ có thể đổi ý, tránh trả lời hoặc kết thúc.

Không bắt NPC đứng nói vô hạn khi có nguy hiểm.

## 69. Comprehension

Hiểu phụ thuộc ngôn ngữ, thuật ngữ, nghe thấy, chú ý và knowledge nền. Người nghe có thể hiểu một phần hoặc hiểu sai.

Result tạo evidence đúng với điều họ hiểu.

## 70. Honesty

Người nói có thể nói đúng, nói sai do nhầm, nói dối, giấu hoặc nói mơ hồ. Intent chỉ thuộc người nói; người nghe suy đoán qua dấu hiệu.

Hệ thống không đánh dấu lời nói dối trực tiếp cho người nghe.

## 71. Persuasion

Thuyết phục cung cấp evidence, framing, incentive hoặc social pressure. Belief/goal chỉ đổi nếu cơ chế đủ.

Không có nút Charisma điều khiển tuyệt đối người khác.

## 72. Negotiation

Đàm phán tạo proposal có terms, expiry, assumptions và quyền. Mỗi bên đánh giá utility/risk/fairness theo belief riêng.

Chỉ acceptance hợp lệ mới chuyển proposal thành commitment/transaction.

## 73. Cooperation

JointPlan có shared goal, role, task dependencies, rendezvous, resource contributions, communication và failure policy.

Mỗi người vẫn có GoalGraph và có thể rút theo điều kiện.

## 74. Coordination failure

Trễ, hiểu sai, mất liên lạc, thiếu vật hoặc đổi ưu tiên có thể làm kế hoạch nhóm hỏng. Outcome giữ trách nhiệm thật và trách nhiệm mỗi người tin.

Không teleport người tới điểm hẹn.

## 75. Conflict

Xung đột bắt đầu từ goal/resource/norm incompatibility được nhận biết. Escalation phụ thuộc grievance, fear, power belief, support và cơ hội.

Chiến đấu chỉ là một phương án.

## 76. Threat assessment

NPC ước lượng năng lực, ý định, đường thoát và đồng minh từ perception/belief. Sai lầm có thể dẫn đến bỏ chạy quá sớm hoặc đối đầu quá sức.

Không dùng power_level canonical của đối thủ.

## 77. Crime and secrecy

Hành vi trái luật có plan về cơ hội, che giấu, lợi ích và rủi ro theo điều NPC biết. Việc bị phát hiện cần witness/evidence/message.

Danh tiếng không cập nhật toàn thế giới ngay lập tức.

## 78. Helping behavior

Cứu giúp xét nguy cấp, quan hệ, giá trị, kỹ năng, rủi ro, nghĩa vụ và người khác có thể giúp. NPC có thể giúp người lạ nhưng phải có lý do.

Hỗ trợ dùng thời gian và vật thật.

## 79. Work and livelihood

NPC chọn việc theo nhu cầu household, role, kỹ năng, công cụ, giá, lịch, sức khỏe, khoảng cách và niềm tin về cơ hội.

Thu nhập chỉ xuất hiện qua giao dịch/sản xuất hợp lệ.

## 80. Career

Nghề nghiệp là lịch sử kỹ năng, vai trò, uy tín, công cụ và mạng quan hệ. Chuyển nghề cần học, cơ hội và chịu chi phí.

Thương tích hoặc biến động thị trường có thể đổi đường đời.

## 81. Learning

NPC tạo learning goal khi thấy thiếu năng lực và biết nguồn học. Họ cân thời gian, học phí, thầy, rủi ro và lợi ích.

Học dùng cơ chế Knowledge/Mastery K4.5.

## 82. Cultivation choice

Chọn công pháp dựa trên TechniqueBelief, compatibility được tin, thầy/truyền thừa, tài nguyên, giá trị, rủi ro, tuổi và nghĩa vụ.

NPC không mặc định muốn tu tiên hoặc chọn pháp mạnh nhất.

## 83. Cultivation schedule

Luyện công cạnh tranh với ngủ, ăn, việc, chăm sóc và quan hệ. Kế hoạch dài hạn giữ resource forecast và review tại bottleneck.

Thành quả/rủi ro đi qua Program thật.

## 84. Breakthrough decision

NPC đánh giá readiness bằng self-model, lời thầy, triệu chứng, cơ hội và áp lực. Họ có thể chờ, tìm thêm chuẩn bị hoặc liều.

Không đọc xác suất thành công canonical.

## 85. Moral and cultural learning

Chuẩn mực được học qua gia đình, tổ chức, nghi lễ, thưởng phạt và quan sát. NPC có thể đồng ý, tuân vì sợ hoặc phản đối.

Culture không là code hành vi cứng.

## 86. Development

Tuổi, trải nghiệm và role làm thay đổi năng lực, self-model, value và mục tiêu theo process. Trẻ em có người giám hộ và giới hạn riêng.

Không sinh người trưởng thành với nghề mà không có lịch sử hợp lệ.

## 87. Aging

NPC nhận biết tuổi và suy giảm qua tín hiệu/chuẩn xã hội, rồi đổi kế hoạch về công việc, tu luyện, chăm sóc và di sản.

Tuổi thọ thật thuộc body/cultivation; dự đoán có uncertainty.

## 88. Reproduction and caregiving

Sinh sản thuộc body; quyết định gia đình phụ thuộc văn hóa, quan hệ, nguồn lực và quyền. Trẻ tạo nhu cầu chăm sóc, không chỉ tăng population.

Chi tiết nhạy cảm chỉ mô phỏng ở mức phục vụ đời sống và hậu quả.

## 89. Migration

Di cư là project: động cơ, tin về nơi đến, tuyến, chi phí, tài sản, người đi cùng, giấy/quyền và rủi ro.

NPC giữ identity và obligations khi đổi vùng.

## 90. Missing persons

“Mất tích” là trạng thái nhận thức của người/nhóm, không phải life status canonical. Tìm kiếm cần goal, manh mối, thời gian và nguồn lực.

Tin chết chỉ hình thành qua evidence.

## 91. Death

Khi body chết, Agent ngừng tạo quyết định. Kế hoạch, vật, thi thể, nghĩa vụ, quan hệ và ký ức của người khác tiếp tục theo chủ quản.

Không xóa lịch sử người chết.

## 92. Grief and succession

Người biết tin mất mát có appraisal riêng; grief ảnh hưởng đời sống qua thời gian. Thừa kế cần luật/di chúc/quyền K4.7.

Không tự chuyển tài sản cho người gần nhất.

## 93. Legacy

Di sản gồm học trò, tác phẩm, công pháp truyền, tài sản, con cháu, danh tiếng và hậu quả. Mỗi phần có entity/provenance thật.

Story View có thể tóm lược nhưng không tạo di sản mới.

## 94. EmergentStory

StoryCandidate là truy vấn trên event/goal/relation change, không can thiệp World State. Nó nhóm các event có nhân quả và nhân vật chung.

Một đời sống vẫn tồn tại dù không được chọn kể.

## 95. Story thread

Thread có initiating tension, participants, stakes, causal event refs, turning points, unresolved questions và current status.

Nó không khóa outcome; diễn biến mới có thể đổi hướng hoặc làm thread lắng xuống.

## 96. Narrative salience

Độ đáng kể xét tác động, bất ngờ, irreversibility, quan hệ với người chơi, rarity, duration và khả năng người chơi biết.

Salience chỉ chọn cách trình bày, không tăng xác suất event.

## 97. Viewpoint

Cùng lịch sử có bản nhìn từ NPC, người chơi, tổ chức hoặc người kể toàn tri dùng cho debug. Giao diện chơi chỉ dùng thông tin được phép.

Không lộ động cơ bí mật dưới dạng văn kể chắc chắn.

## 98. Explanation

Khi hỏi “vì sao NPC làm vậy”, hệ thống trả chuỗi ngắn:

```text
belief/evidence → goal/value/obligation → phương án được cân nhắc
→ ràng buộc → lý do chọn → outcome đã biết
```

Chi tiết nhạy cảm bị lọc theo quyền nhìn.

## 99. Surprise without randomness

Hành vi bất ngờ có thể đến từ thông tin người chơi không biết, quan hệ kín, belief sai hoặc value khác. Trace nội bộ vẫn phải hợp lệ.

Không cần RNG vô cớ để NPC “có vẻ sống”.

## 100. AR0–AR5

| Mức | Dùng khi | Cách giải |
|---|---|---|
| AR0 CONTACT | hội thoại/chiến đấu trực tiếp | perception và decision chi tiết |
| AR1 ACTIVE | giờ gần người chơi | event/action chính xác |
| AR2 DAILY | sinh hoạt ngày | lịch, nhu cầu, việc, giao tiếp |
| AR3 INTERVAL | ngày–tuần | cắt tại deadline/threshold |
| AR4 BATCHED_PERSON | tuần–tháng | batch tính nhưng delta từng Person |
| AR5 DORMANT | không có pressure gần | chỉ wakeup anchors bắt buộc |

AR là độ phân giải tác nhân, phối hợp M0–M4/R0–R4/CR0–CR5 nhưng không thay chúng.

## 101. AgentCapsule

Capsule giữ goal/commitment anchors, routine, drive forecast, affect summary, beliefs/memories quan trọng, relation edges, pending messages, plan boundaries, policy version và RNG cursor.

Hạ AR không xóa identity hoặc viết lại quá khứ.

## 102. Wakeup

Đánh thức khi:

- physiology/drive chạm ngưỡng;
- action/plan kết thúc;
- deadline hoặc lịch tới;
- message/perception quan trọng;
- resource/context đổi;
- threat, bệnh, birth/death;
- interaction horizon tới;
- breakthrough hay joint plan;
- query debug yêu cầu evidence.

Không polling từng NPC mỗi tick.

## 103. Interval resolution

AR3/AR4 cắt tại thức ăn hết, lịch việc, message, bệnh chuyển, deadline, gặp người, di cư hoặc biến cố tu luyện. Handler tạo state delta riêng cho mỗi Person.

Không giải một tháng xuyên qua mọi mốc quan trọng.

## 104. Batch fairness

Batch key xét routine, region context, role, resource access, body band, goal pressure và handler version. Phân việc/tài nguyên theo quyền, policy và RNG từng người.

ID không tạo ưu tiên; gần người chơi không cho lợi ích vô cớ.

## 105. Promotion và demotion

Nâng AR trước tương tác cần chi tiết; mở capsule, reconcile plan/resource/message rồi mới xử. Hạ tại safe boundary sau khi khép action/dialogue/reservation.

Round-trip phải giữ goal, belief, relation, nghĩa vụ, event và outcome.

## 106. Cognition budget

Ngân sách đo số option, plan depth, belief updates, social models và memory retrieval. Quá tải giảm candidate hợp lệ theo heuristic đã khai, không cho NPC gian lận.

Máy chậm không đổi semantic outcome trong workload đã hỗ trợ.

## 107. Candidate generation

Action candidates đến từ affordance đã biết, routine, plan, lời đề nghị, role, learned technique và exploration. Mỗi candidate có source.

Không quét toàn bộ action/content thế giới cho mỗi quyết định.

## 108. Option evaluation

Đánh giá dùng khoảng utility đa chiều: survival, value, obligation, progress, social effect, risk, time, resource và uncertainty. Dominated option có thể bỏ; các phương án gần nhau dùng policy/RNG xác định.

Không ép một hàm điểm toàn cầu cho mọi người.

## 109. DecisionTrace

Trace giữ input revision, attended facts/beliefs, active goals, candidates, rejection reasons, estimates, chosen option, policy/version và RNG draw.

Trace có thể compact nhưng quyết định neo giữ evidence.

## 110. Determinism

Cùng save, command, content/policy version và device-independent workload phải cho cùng Fact. Cache, UI và số luồng không đổi lựa chọn.

Ngẫu nhiên dùng stream có ngữ nghĩa và ghi provenance.

## 111. Save/load

Save chứa PersonAgent/capsule, pending wakeup, plans, beliefs, memory anchors, relations và version. Load không decay thêm thời gian hoặc phát lại relation delta.

Migration phải khai cách đổi schema cognition.

## 112. Mobile và desktop

Cùng core Agent chạy trên hai nền tảng. Điện thoại ưu tiên danh sách việc, cảnh báo, timeline và giải thích từng lớp; desktop cho bảng so sánh/mạng quan hệ rộng hơn.

UI khác bố cục nhưng Command, View semantic và save giống nhau.

## 113. Giao diện đời sống

Mặc định người chơi thấy:

- NPC đang làm gì nếu có thể biết;
- tình trạng/quan hệ được nhân vật nhận ra;
- lời họ nói và hành vi công khai;
- lịch sử người chơi đã chứng kiến/nghe;
- lý do họ tự nguyện chia sẻ.

Debug toàn tri là chế độ phát triển riêng.

## 114. Notification

Chỉ báo người chơi khi event đã tới kênh nhận biết và đủ liên quan. Có thể gộp “ba tuần thường nhật”, nhưng không gộp mất một lời cầu cứu hay người phụ thuộc nguy cấp.

Thông báo không làm pause nếu policy người chơi không yêu cầu.

## 115. Bảo vệ quyền tự trị

Lệnh người chơi với nhân vật của mình vẫn qua mục tiêu; yêu cầu NPC là giao tiếp/đề nghị/quyền tổ chức. NPC có thể từ chối, thương lượng hoặc tuân vì lý do.

Không biến quan hệ cao thành quyền điều khiển.

## 116. Generative language

Nếu dùng mô hình ngôn ngữ, nó chỉ diễn đạt DialoguePayload/StoryView đã được core tạo và phải trả output có kiểm tra. Nó không sửa Fact, tạo item, biết bí mật hoặc quyết định thay Agent.

Game phải chạy được không cần dịch vụ AI.

## 117. An toàn nội dung mô phỏng

Các chủ đề gia đình, bệnh, bạo lực và tâm lý có mức hiển thị cấu hình được. Cơ chế nhân quả vẫn giữ; văn bản có thể giảm chi tiết.

Không dùng bệnh tâm thần hoặc đau khổ làm biến cố trang trí ngẫu nhiên.

## 118. Artifact tương lai

Khi triển khai cần:

- PersonAgent schema;
- drive/value/trait/policy registry;
- goal/plan/decision IR;
- belief/memory/relationship schemas;
- dialogue payload grammar;
- AgentCapsule và AR handlers;
- fixture An Khê;
- condition catalog NP01–NP96;
- evidence bundle và profiler.

Hiện chưa tạo các artifact này.

## 119. Fixture K4N-F01 — một ngày tự duy trì

Một NPC ngủ, ăn, lấy nước, làm việc, nghỉ và về nhà bằng tài nguyên/lịch thật. Thiếu nước làm plan đổi trước khi kiệt.

## 120. Fixture K4N-F02 — lời hứa và việc gấp

NPC đã hứa giao thuốc nhưng con bị sốt. Trace phải hiện obligation, care goal, phương án nhờ người và lý do lựa chọn.

## 121. Fixture K4N-F03 — tin sai về kho gạo

NPC đi mua theo belief cũ, phát hiện hết hàng, ghi failure signature rồi hỏi/tìm nguồn khác; không lặp vô hạn.

## 122. Fixture K4N-F04 — học nghề

Một người dành tiền/thời gian học, tiến bộ qua practice, mất buổi khi phải kiếm ăn và điều chỉnh milestone.

## 123. Fixture K4N-F05 — chọn công pháp

Ba người có body, value, resource và TechniqueBelief khác nhau chọn ba đường hợp lý; không dùng power rank.

## 124. Fixture K4N-F06 — đột phá liều lĩnh

Áp lực tuổi và cơ hội ngắn làm NPC thử dù readiness không chắc. Outcome theo K4.5; người khác chỉ biết qua evidence.

## 125. Fixture K4N-F07 — hiểu lầm

A thấy B rời hiện trường, suy B gây hại; grievance tăng. Evidence mới có thể sửa belief nhưng không tự xóa hậu quả đã làm.

## 126. Fixture K4N-F08 — lời đồn vòng

Ba người kể cùng nguồn; confidence không tăng như ba nguồn độc lập. Biến thể có provenance.

## 127. Fixture K4N-F09 — hợp tác thất bại

Nhóm vận chuyển trễ vì một người bệnh; không teleport. Các thành viên quy trách nhiệm khác nhau theo điều họ biết.

## 128. Fixture K4N-F10 — di cư

Household chuẩn bị, bán/chuyển vật, đi tuyến thật, giữ nợ và quan hệ; nơi cũ chỉ biết họ đi khi có evidence.

## 129. Fixture K4N-F11 — mất tích và tìm kiếm

Gia đình tạo search goal từ việc không về, huy động người theo relation/role; không đọc life status.

## 130. Fixture K4N-F12 — cái chết và di sản

Agent dừng; thi thể, vật, công việc, học trò, grief và claim thừa kế đi qua các hệ đúng.

## 131. Fixture K4N-F13 — AR round-trip

Một năm AR4 rồi nâng AR0 phải giữ resource, mastery, memories neo, quan hệ và decision provenance; không dựng chuyện bù.

## 132. Fixture K4N-F14 — mobile/desktop

Cùng save và command cho cùng decision/fact; hai UI chỉ khác projection.

## 133. Fixture K4N-F15 — 100.000 Person

Workload đo wakeup, memory, plan và storage với Person M2+ thật; không đếm cohort thay NPC.

## 134. Fixture K4N-F16 — câu chuyện không can thiệp

Bật/tắt Story View không đổi event hash. Thread kể chỉ tham chiếu event đã xảy ra.

## 135. Điều kiện NP01–NP96

### Boundary và identity

| ID | Điều kiện |
|---|---|
| NP01 | Agent không sửa canonical body trực tiếp |
| NP02 | Agent không đọc Fact chưa quan sát |
| NP03 | Command thất bại theo state thật |
| NP04 | SelfModel sai vẫn được giữ có provenance |
| NP05 | một Person chỉ có một identity |
| NP06 | chết dừng decision nhưng không xóa history |
| NP07 | role không tự cấp quyền ngoài registry |
| NP08 | debug omniscience không lọt gameplay View |

### Nhu cầu, mục tiêu và kế hoạch

| ID | Điều kiện |
|---|---|
| NP09 | drive có source và trajectory |
| NP10 | đói không đọc trực tiếp lượng canonical |
| NP11 | GoalProposal có nguồn |
| NP12 | goal con nối goal cha |
| NP13 | goal conflict được ghi |
| NP14 | abandonment có reason |
| NP15 | commitment ngăn dao động nhỏ |
| NP16 | deadline tạo wakeup |
| NP17 | plan tôn trọng thời lượng |
| NP18 | plan chỉ reserve quyền có thể tiếp cận |
| NP19 | contingency chỉ chạy khi trigger |
| NP20 | failure signature ngăn loop |
| NP21 | routine vẫn kiểm precondition |
| NP22 | replan không polling mỗi tick |
| NP23 | joint plan giữ từng participant |
| NP24 | kế hoạch xa cắt tại boundary |

### Nhận thức và niềm tin

| ID | Điều kiện |
|---|---|
| NP25 | signal không chú ý không thành evidence |
| NP26 | perception giữ channel/quality |
| NP27 | belief giữ event time và learned time |
| NP28 | unknown không đổi thành false |
| NP29 | belief mâu thuẫn có thể cùng tồn tại |
| NP30 | source vòng không nhân confidence |
| NP31 | freshness tùy loại proposition |
| NP32 | identity che mặt không tự giải |
| NP33 | social model không đọc Agent khác |
| NP34 | suy nghĩ xã hội không đệ quy vô hạn |
| NP35 | estimate có uncertainty |
| NP36 | thông tin mới kích review hợp lệ |
| NP37 | nói dối khác nói sai do nhầm |
| NP38 | comprehension một phần tạo belief tương ứng |
| NP39 | secret cần đường rò thật |
| NP40 | query UI không tạo knowledge |

### Ký ức và học

| ID | Điều kiện |
|---|---|
| NP41 | episode tách Event canonical |
| NP42 | consolidation không chạy hai lần |
| NP43 | retrieval failure không xóa record |
| NP44 | quên hẹn không xóa obligation |
| NP45 | compaction giữ anchor |
| NP46 | summary giữ trend/exception |
| NP47 | distortion không sửa Fact |
| NP48 | semantic generalization giữ sample |
| NP49 | procedural memory không thay Mastery |
| NP50 | body mất chức năng dù còn nhớ kỹ thuật |
| NP51 | học dùng thời gian và tài nguyên |
| NP52 | teacher không truyền knowledge mình không có |
| NP53 | misconception tồn tại qua AR |
| NP54 | load không decay thêm |
| NP55 | memory relation effect không áp dụng lặp |
| NP56 | ghi chép cần item/access thật |

### Cảm xúc và con người

| ID | Điều kiện |
|---|---|
| NP57 | affect có appraisal source |
| NP58 | hai NPC phản ứng khác có trace |
| NP59 | mood không thay trait tức thì |
| NP60 | stress nối body qua interface |
| NP61 | coping dùng affordance thật |
| NP62 | trait không khóa hành vi |
| NP63 | TraitChange có lịch sử đủ |
| NP64 | self-concept ảnh hưởng nhưng không tạo Fact |

### Quan hệ và xã hội

| ID | Điều kiện |
|---|---|
| NP65 | A→B tách B→A |
| NP66 | trust tách theo lĩnh vực |
| NP67 | affection không thành trust chuyên môn |
| NP68 | grievance có perceived harm/evidence |
| NP69 | tha thứ không tự xóa claim |
| NP70 | quà lặp có diminishing effect |
| NP71 | tương tác relation có applied marker |
| NP72 | household không gộp title |
| NP73 | kinship giữ sau di cư |
| NP74 | group không chia sẻ toàn knowledge |
| NP75 | reputation chỉ truyền theo network |
| NP76 | crime cần witness/evidence để bị biết |
| NP77 | persuasion không điều khiển tuyệt đối |
| NP78 | negotiation chỉ commit sau acceptance |
| NP79 | giúp đỡ tiêu hao resource thật |
| NP80 | coordination không teleport |

### Vòng đời, tu luyện và câu chuyện

| ID | Điều kiện |
|---|---|
| NP81 | nghề có lịch sử học/cơ hội |
| NP82 | thu nhập không tự sinh |
| NP83 | chọn pháp dùng belief/compatibility |
| NP84 | luyện công cạnh tranh lịch sống |
| NP85 | breakthrough không đọc xác suất thật |
| NP86 | di cư giữ debt/relation/identity |
| NP87 | mất tích tách life status |
| NP88 | death xử pending plans đúng chủ quản |
| NP89 | inheritance không tự chọn người gần |
| NP90 | StoryCandidate không sửa state |
| NP91 | viewpoint không lộ bí mật |
| NP92 | bật/tắt narrative không đổi hash |

### Phân tầng, lưu tải và parity

| ID | Điều kiện |
|---|---|
| NP93 | AR4 vẫn phân delta từng Person |
| NP94 | AR round-trip giữ anchor/invariant |
| NP95 | save/load giữ decision/RNG/wakeup |
| NP96 | mobile/desktop cho cùng semantic outcome |

NP01–NP96 là điều kiện thiết kế chưa mã hóa và chưa chạy. Tổng hồ sơ tăng từ 1.572 lên 1.668 điều kiện thuộc 39 họ.

## 136. Cổng K4.6

| Cổng | Đạt khi | Hiện tại |
|---|---|---|
| K4N01 | Fact–Belief–Command boundary rõ | đạt trên giấy |
| K4N02 | need–goal–plan–action chain rõ | đạt trên giấy |
| K4N03 | memory/affect/relation có provenance | đạt trên giấy |
| K4N04 | social interaction không toàn tri | đạt trên giấy |
| K4N05 | life/cultivation/story boundary rõ | đạt trên giấy |
| K4N06 | AR0–AR5 và NPC xa rõ | đạt trên giấy |
| K4N07 | schema/IR/policy registry tồn tại | chưa |
| K4N08 | K4N-F01–F16 mã hóa | chưa |
| K4N09 | NP01–NP96 chạy có evidence | chưa |
| K4N10 | workload 100.000 Person đạt | chưa |

## 137. Vấn đề mở

1. Danh mục Value/Trait/Drive chính thức?
2. NPC có quyền chống lệnh người chơi tới mức nào?
3. Độ sâu planner cho chặng đầu?
4. Có mô phỏng giấc mơ, sang chấn và bệnh tâm lý không?
5. Mức forgetting/distortion phù hợp?
6. Trẻ em, giáo dục và giám hộ sâu tới đâu?
7. Hôn nhân, sinh sản và gia đình theo những nền văn hóa nào?
8. Tự sát, tra tấn và chủ đề nhạy cảm được biểu diễn ra sao?
9. NPC dùng ngôn ngữ sinh tùy chọn hay chỉ template?
10. Bao nhiêu episode giữ trước khi compact?
11. Người chơi được xem explanation sâu tới mức nào?
12. Story View chọn độ nổi bật nhưng tránh thiên vị ra sao?
13. AR4 có thể giải khoảng tối đa bao lâu?
14. Ngân sách 100.000 Person trên điện thoại?
15. Luật thừa kế, nô lệ, giai cấp và quyền cá nhân thuộc K4.7?
16. K4.7 ưu tiên kinh tế hay thể chế/chính trị?

Chưa mục nào được tự chốt.

## 138. Rủi ro

| Rủi ro | Hậu quả | Kiểm soát đề xuất |
|---|---|---|
| NPC đọc toàn tri | hành vi giả | Fact–Evidence–Belief boundary |
| utility giống nhau | mọi NPC một tính | value/policy/history cá thể |
| planner quá sâu | không đạt tốc độ | hierarchy, horizon, AR |
| planner quá nông | hành vi vòng | failure memory, project/milestone |
| quan hệ một thanh | xã hội phẳng | edge đa chiều có evidence |
| ký ức vô hạn | save phình | consolidation/compaction/anchor |
| story director can thiệp | nhân quả giả | read-only StoryCandidate |
| NPC xa được ưu ái | lịch sử giả | resource/person delta |
| lời văn tạo sự thật | phá state | payload/schema validation |
| UI lộ bí mật | phá nhận thức | viewpoint/access projection |

## 139. Trình tự hiện thực hóa khi được yêu cầu

1. PersonAgent, SelfModel, Drive, Value và Goal schemas.
2. Plan/Decision IR và scheduler wakeup.
3. Belief/Memory/Relationship records.
4. routine, failure/replan và resource-aware execution.
5. dialogue, negotiation và JointPlan.
6. work/learning/cultivation/lifecycle integrations.
7. AR0–AR5 và AgentCapsule.
8. StoryCandidate/View read-only.
9. mã hóa K4N-F01–F16.
10. workload 100.000 Person và parity.
11. mã hóa NP01–NP96, chạy evidence và hiệu chỉnh.

Đây là thứ tự triển khai tương lai, chưa phải việc đã làm.

## 140. Những điều không được tuyên bố

- Không nói đã tạo NPC có ý thức hoặc giống người thật hoàn toàn.
- Không nói planner, memory hay story engine đã tồn tại.
- Không nói đã mô phỏng 100.000 NPC.
- Không nói đã chốt mô hình tâm lý, gia đình hoặc đạo đức.
- Không nói AR0–AR5 đã đạt parity.
- Không nói NP01–NP96 đã mã hóa/chạy.
- Không nói 1.668 điều kiện là test tự động.
- Không nói game đã chạy trên điện thoại/máy tính.

## 141. Giá trị K4.6 cung cấp thật

- NPC có vòng need–belief–goal–plan–action–learning đầy đủ;
- hành vi chỉ dựa trên nhận thức hợp lệ;
- kế hoạch dài hạn dùng thời gian và tài nguyên thật;
- ký ức, cảm xúc và quan hệ có nguồn;
- nghề nghiệp, tu luyện, di cư và cái chết nối cùng World State;
- câu chuyện phát sinh chỉ đọc lịch sử thật;
- AR0–AR5 giữ cá thể ở vùng xa;
- 16 fixture và 96 điều kiện có thể mã hóa sau.

## 142. Bước tiếp theo

K4.7–K4.8 đã định xã hội và chiến đấu. K4.9 đã hoàn thành tại [[KIEM_TOAN_TICH_HOP_K4_PHAM_VI_BAN_DAU_VA_CHUAN_BI_LAP_TRINH]]. Kế hoạch nền đã đủ; chưa lập trình.
