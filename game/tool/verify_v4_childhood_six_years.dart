import 'dart:convert';

import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260918;
const SimTime _midpoint = SimTime(3 * 365 * gameSecondsPerDay);
const SimTime _end = SimTime(6 * 365 * gameSecondsPerDay + 3600);

/// Runner đóng tám cổng V4. Chỉ chạy trong lượt kiểm chứng phát hành.
void main() {
  final Simulation continuous = _exercisePrelude(_seed)..advanceTo(_end);

  final Simulation throughSave = _exercisePrelude(_seed)..advanceTo(_midpoint);
  final String midpointHash = throughSave.state.semanticHash();
  final Simulation restored = Simulation.fromSave(throughSave.state.save());
  _expect(
    restored.state.semanticHash() == midpointHash,
    'Save/load giữa tuổi thơ phải giữ nguyên semantic hash.',
  );
  restored.advanceTo(_end);

  final Simulation replay = _exercisePrelude(_seed)..advanceTo(_end);
  final WorldState state = continuous.state;
  final PersonState child = state.people['P00']!;
  final ChildhoodState childhood = child.childhood!;
  final Set<String> rememberedKinds = <String>{
    for (final ChildMemoryEpisodeState memory in childhood.recentMemories)
      memory.kind,
    for (final ChildMemoryEpisodeState memory in childhood.memoryAnchors)
      memory.kind,
    for (final ChildMemorySummaryState summary in childhood.memorySummaries)
      ...summary.kindCounts.keys,
  };

  _expect(
    state.now.seconds == _end.seconds &&
        childhood.lastAdvancedAgeDays >= 6 * 365 &&
        childhood.stage == ChildDevelopmentStage.middleChildhood,
    'Mỗi ngày phải đi qua hàng đợi tới ít nhất sáu năm tuổi thơ.',
  );
  _expect(
    childhood.body.totalFoodGrams > 0 &&
        childhood.body.totalWaterMl > 0 &&
        childhood.body.supportedGrowthDays > 0 &&
        childhood.body.constrainedGrowthDays > 0 &&
        childhood.maturationProgressPerMille <
            childhood.lastAdvancedAgeDays * 1000,
    'Cơ thể phải nhận khẩu phần thật và cả đủ lẫn thiếu phải đổi trưởng thành.',
  );
  _expect(
    childhood.completedPhysicalActivities > 0 &&
        childhood.completedLearningActivities > 0 &&
        rememberedKinds.containsAll(<String>{
          ChildIntent.observe.code,
          ChildIntent.vocalize.code,
          ChildIntent.practiceReach.code,
          ChildIntent.floorPlay.code,
        }),
    'Bốn trục hoạt động phải chạy, tốn thời gian và để lại ký ức.',
  );
  _expect(
    child.infancy!.careExpectations['N01']?.successfulResponses != null &&
        continuous.childCaregiverPreferences('P00').containsKey('N01'),
    'Kinh nghiệm chăm sơ sinh phải tiếp tục tham gia lựa chọn tuổi thơ.',
  );
  _expect(
    childhood.hazardIncidents > 0 &&
        childhood.hazardsResolvedByCaregiver > 0 &&
        childhood.lastHazard?.outcome == 'soothed',
    'Nguy hiểm phải đi qua nhận biết, người chăm đáp ứng và hậu quả tâm lý.',
  );
  _expect(
    childhood.recentMemories.length <= 64 &&
        childhood.memoryAnchors.length <= 32 &&
        childhood.memorySummaries.length <= 84 &&
        childhood.compressedMemoryCount > 0 &&
        childhood.memoryAnchors.any(
          (ChildMemoryEpisodeState memory) =>
              memory.kind.startsWith('hazard_') &&
              memory.sourceIds.contains('N01'),
        ),
    'Nén ký ức phải hữu hạn nhưng vẫn giữ nguy hiểm và nguồn người chăm: '
    'recent=${childhood.recentMemories.length} '
    'anchors=${childhood.memoryAnchors.length} '
    'summaries=${childhood.memorySummaries.length} '
    'compressed=${childhood.compressedMemoryCount} '
    'hazard_sources=${childhood.memoryAnchors.where((ChildMemoryEpisodeState memory) => memory.kind.startsWith('hazard_')).map((ChildMemoryEpisodeState memory) => memory.sourceIds).toList()}',
  );
  _expect(
    child.beliefs.values.any(
      (BeliefState belief) =>
          belief.learningActivity != null &&
          (belief.sourceObjectId != null || belief.sourcePersonId == 'N01'),
    ),
    'Ít nhất một điều đã học phải giữ nguồn người hoặc vật.',
  );
  _expect(
    child.timeCommitment == null &&
        state.items.values.every((CareItemState item) => item.quantity >= 0),
    'Kết thúc không được còn hoạt động trẻ mắc kẹt hay kho âm.',
  );

  if (state.semanticHash() != restored.state.semanticHash()) {
    print('Continuous hash: ${state.semanticHash()}');
    print('Restored hash: ${restored.state.semanticHash()}');
    _printStructuralDifference(
      jsonDecode(state.save()),
      jsonDecode(restored.state.save()),
      r'$',
    );
  }
  _expect(
    state.semanticHash() == restored.state.semanticHash(),
    'Chạy liền và save/load giữa kỳ phải tới cùng semantic hash.',
  );
  _expect(
    state.semanticHash() == replay.state.semanticHash(),
    'Replay cùng seed và chuỗi lệnh phải tới cùng semantic hash.',
  );

  print('V4 childhood six-year verification passed.');
  print('Age days: ${childhood.lastAdvancedAgeDays}');
  print('Mass: ${childhood.body.massGrams} g');
  print(
    'Maturation equivalent: '
    '${childhood.maturationProgressPerMille ~/ 1000} days',
  );
  print('Physical activities: ${childhood.completedPhysicalActivities}');
  print('Learning activities: ${childhood.completedLearningActivities}');
  print('Hazards: ${childhood.hazardIncidents}');
  print('Compressed memories: ${childhood.compressedMemoryCount}');
  print('Final hash: ${state.semanticHash()}');
}

Simulation _exercisePrelude(int seed) {
  final Simulation simulation = _prepared(seed);
  final SimulationHost host = SimulationHost(simulation);

  simulation.advanceTo(const SimTime(29 * gameSecondsPerDay + 22 * 3600));
  for (int index = 0; index < 12; index++) {
    _submitInfant(host, 'late-care-$index');
    simulation.advanceTo(simulation.state.now.addSeconds(180));
  }
  simulation.advanceTo(const SimTime(30 * gameSecondsPerDay + 60));
  _expect(
    simulation.state.people['P00']?.childhood != null,
    'Trẻ phải chuyển liên tục khỏi tháng sơ sinh.',
  );

  _submitChild(host, ChildIntent.observe, 'early-observe');
  simulation.advanceTo(
    simulation.state.now.addSeconds(ChildIntent.observe.durationSeconds),
  );

  int dayGuard = 0;
  while (!simulation.state.people['P00']!.childhood!.allowedIntents.contains(
    ChildIntent.practiceReach,
  )) {
    simulation.advanceTo(simulation.state.now.addDays(1));
    if (++dayGuard > 90) {
      throw StateError('Tập với vật không mở trong 90 ngày đầu tuổi thơ.');
    }
  }
  int reachAttempts = 0;
  while (!simulation.state.people['P00']!.childhood!.allowedIntents.contains(
    ChildIntent.floorPlay,
  )) {
    _submitChild(host, ChildIntent.practiceReach, 'reach-${reachAttempts + 1}');
    simulation.advanceTo(
      simulation.state.now.addSeconds(
        ChildIntent.practiceReach.durationSeconds,
      ),
    );
    if (++reachAttempts > 30) {
      throw StateError('Chơi vận động không mở sau 30 lần tập với vật.');
    }
  }
  _submitChild(host, ChildIntent.floorPlay, 'hazardous-floor-play');
  simulation.advanceTo(
    simulation.state.now.addSeconds(
      ChildIntent.floorPlay.durationSeconds + 3600,
    ),
  );

  simulation.advanceTo(const SimTime(75 * gameSecondsPerDay));
  int learningAttempts = 0;
  while (!simulation.state.people['P00']!.beliefs.values.any(
    (BeliefState belief) => belief.learningActivity == ChildIntent.observe.code,
  )) {
    _submitChild(
      host,
      ChildIntent.observe,
      'observe-source-${learningAttempts + 1}',
    );
    simulation.advanceTo(
      simulation.state.now.addSeconds(ChildIntent.observe.durationSeconds),
    );
    if (++learningAttempts > 30) {
      throw StateError('Quan sát không tạo tri thức có nguồn sau 30 lần.');
    }
  }
  while (!simulation.state.people['P00']!.childhood!.allowedIntents.contains(
    ChildIntent.vocalize,
  )) {
    _submitChild(host, ChildIntent.observe, 'observe-for-language');
    simulation.advanceTo(
      simulation.state.now.addSeconds(ChildIntent.observe.durationSeconds),
    );
  }
  _submitChild(host, ChildIntent.vocalize, 'vocalize-with-caregiver');
  simulation.advanceTo(
    simulation.state.now.addSeconds(ChildIntent.vocalize.durationSeconds),
  );

  for (int index = 0; index < 70; index++) {
    _submitChild(host, ChildIntent.observe, 'memory-volume-$index');
    simulation.advanceTo(
      simulation.state.now.addSeconds(ChildIntent.observe.durationSeconds),
    );
  }
  simulation.advanceTo(simulation.state.now.addDays(31));
  return simulation;
}

Simulation _prepared(int seed) {
  final Simulation simulation = Simulation.fromSeed(seed)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: const <String, Object?>{
        'room_id': 'ROOM-CHILD',
        'name': 'Gian ở của gia đình',
        'household_id': 'H01',
        'anchor_position_mm': 0,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: const <String, Object?>{
        'person_id': 'N01',
        'name': 'Người chăm chính',
        'birth_seconds': -30 * 365 * gameSecondsPerDay,
        'position_mm': 0,
        'room_id': 'ROOM-CHILD',
        'household_id': 'H01',
        'caregiver_agent': true,
        'caregiver_available': false,
        'care_skill': 900,
        'family_relationships': <String, String>{'N02': 'spouse'},
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: const <String, Object?>{
        'person_id': 'N02',
        'name': 'Người thân cùng nhà',
        'birth_seconds': -28 * 365 * gameSecondsPerDay,
        'position_mm': 0,
        'room_id': 'ROOM-CHILD',
        'household_id': 'H01',
        'family_relationships': <String, String>{'N01': 'spouse'},
      },
    );
  _scheduleItem(
    simulation,
    id: 'I-FOOD',
    kind: 'staple_food',
    quantity: 45000,
    unit: 'g',
  );
  _scheduleItem(
    simulation,
    id: 'I-WATER',
    kind: 'clean_water',
    quantity: 180000,
    unit: 'ml',
  );
  _scheduleItem(
    simulation,
    id: 'I-FUEL',
    kind: 'firewood',
    quantity: 27000,
    unit: 'g',
  );
  _scheduleItem(
    simulation,
    id: 'I-FEED',
    kind: 'infant_feed',
    quantity: 500000,
    unit: 'ml',
    energyKjPer100Ml: 300,
    waterMlPer100Ml: 92,
  );
  _scheduleItem(
    simulation,
    id: 'I-CLOTH',
    kind: 'swaddling_cloth',
    quantity: 1,
    unit: 'piece',
    condition: 1000,
  );
  simulation
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H01',
        'name': 'Hộ kiểm chứng V4',
        'member_ids': <String>['N01', 'N02'],
        'resource_item_ids': <String, String>{
          'food': 'I-FOOD',
          'water': 'I-WATER',
          'fuel': 'I-FUEL',
          'infant_feed': 'I-FEED',
        },
        'authorized_users_by_item_id': <String, List<String>>{
          'I-FOOD': <String>['N01'],
          'I-WATER': <String>['N01'],
          'I-FUEL': <String>['N01'],
          'I-FEED': <String>['N01'],
          'I-CLOTH': <String>['N01'],
        },
        'scheduled_work_seconds_by_person': <String, int>{},
        'meal_actor_id': 'N01',
        'family_memory': true,
        'infant_attachment_learning': true,
        'birth_family_roles_by_person_id': <String, String>{
          'N01': 'mother',
          'N02': 'father',
        },
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'birth',
      payload: const <String, Object?>{
        'person_id': 'P00',
        'name': 'Đứa trẻ V4',
        'infant': true,
        'caregiver_id': 'N01',
        'position_mm': 0,
        'room_id': 'ROOM-CHILD',
        'household_id': 'H01',
        'caregiver_role': 'mother',
      },
    )
    ..advanceTo(const SimTime(0))
    ..enableChildhoodDevelopment('P00')
    ..schedule(
      due: const SimTime(29 * gameSecondsPerDay + 22 * 3600),
      phase: EventPhase.completion,
      kind: 'caregiver_availability_changed',
      payload: const <String, Object?>{
        'person_id': 'N01',
        'available': true,
        'reason': 'fixture_v4_recovery',
      },
    );
  for (int day = 60; day <= 6 * 365; day += 15) {
    simulation.schedule(
      due: SimTime(day * gameSecondsPerDay),
      phase: EventPhase.transfer,
      kind: 'household_supply_delivery',
      payload: const <String, Object?>{
        'household_id': 'H01',
        'single_delivery': true,
      },
    );
  }
  return simulation;
}

void _scheduleItem(
  Simulation simulation, {
  required String id,
  required String kind,
  required int quantity,
  required String unit,
  int condition = 1000,
  int? energyKjPer100Ml,
  int? waterMlPer100Ml,
}) {
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'item_created',
    payload: <String, Object?>{
      'item_id': id,
      'kind': kind,
      'position_mm': 0,
      'room_id': 'ROOM-CHILD',
      'quantity': quantity,
      'unit': unit,
      'condition': condition,
      'owner_household_id': 'H01',
      if (energyKjPer100Ml != null) 'energy_kj_per_100ml': energyKjPer100Ml,
      if (waterMlPer100Ml != null) 'water_ml_per_100ml': waterMlPer100Ml,
    },
  );
}

void _submitInfant(SimulationHost host, String suffix) {
  final CommandResult result = host.submit(
    InfantIntentCommand(
      id: 'v4-infant-$suffix',
      personId: 'P00',
      intent: InfantIntent.cryForCare,
    ),
  );
  _expect(
    result.accepted,
    'Lệnh sơ sinh $suffix bị từ chối: ${result.message}',
  );
}

void _submitChild(SimulationHost host, ChildIntent intent, String suffix) {
  final CommandResult result = host.submit(
    ChildIntentCommand(id: 'v4-child-$suffix', personId: 'P00', intent: intent),
  );
  _expect(
    result.accepted,
    'Hoạt động ${intent.code} $suffix bị từ chối: ${result.message}',
  );
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}

bool _printStructuralDifference(Object? left, Object? right, String path) {
  if (left is Map && right is Map) {
    final List<String> keys = <String>{
      ...left.keys.cast<String>(),
      ...right.keys.cast<String>(),
    }.toList()..sort();
    for (final String key in keys) {
      if (!left.containsKey(key) || !right.containsKey(key)) {
        print('Different key at $path.$key: ${left[key]} / ${right[key]}');
        return true;
      }
      if (_printStructuralDifference(left[key], right[key], '$path.$key')) {
        return true;
      }
    }
    return false;
  }
  if (left is List && right is List) {
    if (left.length != right.length) {
      print('Different list length at $path: ${left.length} / ${right.length}');
      return true;
    }
    for (int index = 0; index < left.length; index++) {
      if (_printStructuralDifference(
        left[index],
        right[index],
        '$path[$index]',
      )) {
        return true;
      }
    }
    return false;
  }
  if (left != right) {
    print('Different value at $path: $left / $right');
    return true;
  }
  return false;
}
