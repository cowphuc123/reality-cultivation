import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.4: nhu cầu thật của hộ sinh ra việc, ưu tiên phân xử khi hai việc va nhau.
void main() {
  final Simulation world = _world();

  // KH01: nhu cầu suy từ tồn kho thật, không viết sẵn.
  final List<HouseholdNeed> needs = world.householdNeeds('H01');
  final HouseholdNeed fuel = needs.firstWhere(
    (HouseholdNeed need) => need.kind == 'fuel',
  );
  final HouseholdNeed water = needs.firstWhere(
    (HouseholdNeed need) => need.kind == 'water',
  );
  _expect(
    fuel.daysOfSupply == 5 && water.daysOfSupply == 8,
    'Số ngày dự trữ phải tính từ tồn kho và nhịp tiêu thụ thật.',
  );
  _expect(
    needs.first.kind == 'fuel' && fuel.priority > water.priority,
    'Thiếu nhiều hơn thì ưu tiên cao hơn và được xếp trước.',
  );

  // KH02: kế hoạch ngày 0 giao việc cho người có quyền và còn giờ trống.
  world.advanceTo(const SimTime(5 * 3600 + 60));
  final WorldFact plan = world.state.facts.lastWhere(
    (WorldFact fact) => fact.kind == 'household_plan_made',
  );
  _expect(
    plan.detail.contains('needs=3'),
    'Cả ba kho đều dưới ngưỡng nên phải sinh ba nhu cầu.',
  );
  _expect(
    plan.detail.contains('fuel:N02') &&
        plan.detail.contains('water:N01') &&
        plan.detail.contains('food:N03'),
    'Việc phải chia cho ba người theo quyền và giờ trống, không dồn một người.',
  );
  _expect(
    world.state.people['N03']!.routine!.generatedBlocks.single.needKind ==
        'food',
    'Khối do kế hoạch sinh phải nhớ nhu cầu đã tạo ra nó.',
  );

  // KH03: việc gấp giành chỗ của khối cố định ưu tiên thấp hơn.
  world.advanceTo(const SimTime(6 * 3600 + 60));
  final RoutineState laborer = world.state.people['N03']!.routine!;
  final ScheduleConflict outranked = laborer.conflicts.last;
  _expect(
    outranked.resolution == 'outranked' &&
        outranked.plannedActivity == 'sửa mái' &&
        outranked.competingActivity == 'kiếm lương thực',
    'Việc sửa mái ưu tiên thấp phải nhường chỗ cho việc kiếm lương thực.',
  );
  _expect(
    laborer.activeBlock?.needKind == 'food',
    'Sau khi giành chỗ, N03 phải đang thật sự đi kiếm lương thực.',
  );

  // KH04: khối ưu tiên thấp bị lùi giờ chứ không bị nuốt mất.
  world.advanceTo(const SimTime(7 * 3600 + 45 * 60));
  final RoutineState caregiver = world.state.people['N01']!.routine!;
  _expect(
    caregiver.deferredStarts >= 1 &&
        caregiver.conflicts.any(
          (ScheduleConflict value) =>
              value.resolution == 'deferred' &&
              value.plannedActivity == 'may vá' &&
              value.competingActivity == 'gánh nước',
        ),
    'May vá phải lùi giờ vì N01 còn đang gánh nước.',
  );
  _expect(
    caregiver.activeBlock?.activity == 'may vá',
    'Sau khi gánh nước xong, may vá phải được bắt đầu chứ không mất.',
  );

  // KH05: làm xong thì hàng vào kho thật.
  final int waterAfter = world.state.items['I-WATER']!.quantity;
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'routine_work_delivered' &&
          fact.detail.contains('resource=water') &&
          fact.detail.contains('amount=18000'),
    ),
    'Gánh nước trọn khối phải giao đủ sản lượng vào kho.',
  );
  _expect(
    waterAfter > 48000 - 6000,
    'Kho nước phải tăng thật sau chuyến gánh.',
  );

  // KH06: khối cố định nối đuôi nhau không còn bị nuốt.
  world.advanceTo(const SimTime(12 * 3600));
  _expect(
    world.state.people['N02']!.routine!.completedBlocks >= 2,
    'Nấu bữa sáng và kiếm củi nối đuôi nhau đều phải được tính là xong.',
  );

  // KH07: nhu cầu giảm sau khi làm, kế hoạch hôm sau đổi theo.
  world.advanceTo(const SimTime(gameSecondsPerDay + 5 * 3600 + 60));
  final HouseholdNeed waterDayOne = world
      .householdNeeds('H01')
      .firstWhere((HouseholdNeed need) => need.kind == 'water');
  _expect(
    waterDayOne.daysOfSupply > water.daysOfSupply,
    'Làm xong việc thì số ngày dự trữ phải tăng lên.',
  );
  _expect(
    waterDayOne.priority < water.priority,
    'Bớt gấp thì ưu tiên hôm sau phải thấp hơn hôm trước.',
  );

  // KH08: bị cắt ngang đi chăm trẻ bệnh thì sản lượng giảm theo giờ đã mất.
  world.advanceTo(const SimTime(3 * gameSecondsPerDay + 13 * 3600));
  final WorldFact partial = world.state.facts.lastWhere(
    (WorldFact fact) =>
        fact.kind == 'routine_work_delivered' &&
        !fact.detail.contains('lost_seconds=0'),
  );
  final int planned = _value(partial.detail, 'planned');
  final int amount = _value(partial.detail, 'amount');
  final int lost = _value(partial.detail, 'lost_seconds');
  _expect(
    lost > 0 && amount < planned,
    'Mất giờ vì chăm trẻ thì sản lượng phải thấp hơn kế hoạch.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'caregiver_substituted' &&
          fact.detail.contains('substitute=N02'),
    ),
    'Chính người bị cắt ngang phải là người được điều đi chăm trẻ.',
  );

  // KH09: không ai đủ quyền thì ghi rõ là thiếu người, không tự bịa người làm.
  final Simulation unstaffed = _world(fuelRights: const <String>['P00']);
  unstaffed.advanceTo(const SimTime(5 * 3600 + 60));
  _expect(
    unstaffed.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'household_need_unstaffed' &&
          fact.detail.contains('need=fuel'),
    ),
    'Nhu cầu củi không có người lớn đủ quyền phải được ghi là thiếu người.',
  );
  _expect(
    unstaffed.state.people.values.every(
      (PersonState person) =>
          person.routine?.generatedBlocks.any(
            (RoutineBlock block) => block.needKind == 'fuel',
          ) !=
          true,
    ),
    'Không được giao việc củi cho bất kỳ ai khi không ai có quyền.',
  );

  // KH10: lưu giữa lúc kế hoạch đang chạy vẫn tái hiện đúng.
  final Simulation continuous = _world();
  continuous.advanceTo(const SimTime(8 * 3600));
  _expect(
    continuous.state.people['N02']!.routine!.activeBlock?.needKind == 'fuel',
    'Mốc lưu phải nằm giữa lúc một khối do kế hoạch sinh đang chạy.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(4 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(4 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa lúc kế hoạch đang chạy phải tiếp tục cùng kết quả.',
  );

  print('V2.4 need-driven planning verification passed.');
  print('Day 4 hash: ${continuous.state.semanticHash()}');
  print(
    'Ngày 0: củi ${fuel.daysOfSupply} ngày (ưu tiên ${fuel.priority}), '
    'nước ${water.daysOfSupply} ngày (ưu tiên ${water.priority}).',
  );
  print(
    'Khối bị cắt ngang: kế hoạch $planned, giao $amount, mất $lost giây.',
  );
  final RoutineState n03 = world.state.people['N03']!.routine!;
  print(
    'N03: ${n03.completedBlocks} khối xong, '
    '${n03.outrankedBlocks} lần bị giành chỗ, '
    '${n03.conflictCount} xung đột.',
  );
}

int _value(String detail, String key) {
  for (final String part in detail.split(' ')) {
    if (part.startsWith('$key=')) {
      return int.tryParse(part.substring(key.length + 1)) ?? 0;
    }
  }
  return 0;
}

Simulation _world({List<String> fuelRights = const <String>['N02', 'N03']}) {
  final Simulation simulation = Simulation.fromSeed(20260908);
  for (final (String, String, int) room in <(String, String, int)>[
    ('ROOM-SLEEP', 'Gian ngủ', 0),
    ('ROOM-KITCHEN', 'Gian bếp', 5000),
    ('ROOM-YARD', 'Sân và kho củi', 12000),
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: <String, Object?>{
        'room_id': room.$1,
        'name': room.$2,
        'household_id': 'H01',
        'anchor_position_mm': room.$3,
      },
    );
  }
  for (final Map<String, Object?> person in <Map<String, Object?>>[
    <String, Object?>{
      'person_id': 'N01',
      'name': 'Người chăm sóc',
      'position_mm': 5000,
      'room_id': 'ROOM-KITCHEN',
      'household_id': 'H01',
      'caregiver_agent': true,
      'care_skill': 800,
      'current_activity': 'may vá',
      'routine': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N01-VA',
          'activity': 'may vá',
          'start_second_of_day': 25200,
          'duration_seconds': 35400,
          'room_id': 'ROOM-KITCHEN',
          'priority': 30,
        },
      ],
    },
    <String, Object?>{
      'person_id': 'N02',
      'name': 'Người nấu ăn',
      'position_mm': 5000,
      'room_id': 'ROOM-KITCHEN',
      'household_id': 'H01',
      'caregiver_agent': true,
      'care_skill': 520,
      'current_activity': 'nấu ăn',
      'routine': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N02-SANG',
          'activity': 'nấu bữa sáng',
          'start_second_of_day': 21600,
          'duration_seconds': 5400,
          'room_id': 'ROOM-KITCHEN',
          'priority': 70,
        },
        <String, Object?>{
          'id': 'R-N02-TOI',
          'activity': 'nấu bữa tối',
          'start_second_of_day': 61200,
          'duration_seconds': 7200,
          'room_id': 'ROOM-KITCHEN',
          'priority': 70,
        },
      ],
    },
    <String, Object?>{
      'person_id': 'N03',
      'name': 'Người làm công',
      'position_mm': 12000,
      'room_id': 'ROOM-YARD',
      'household_id': 'H01',
      'routine': <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N03-MAI',
          'activity': 'sửa mái',
          'start_second_of_day': 21600,
          'duration_seconds': 43200,
          'room_id': 'ROOM-YARD',
          'priority': 25,
        },
      ],
    },
    <String, Object?>{
      'person_id': 'N04',
      'name': 'Người vận chuyển',
      'position_mm': 500000,
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        ...person,
        'birth_seconds': -30 * 365 * gameSecondsPerDay,
      },
    );
  }
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'birth',
    payload: const <String, Object?>{
      'person_id': 'P00',
      'name': 'Vô Danh',
      'infant': true,
      'caregiver_id': 'N01',
      'position_mm': 0,
      'room_id': 'ROOM-SLEEP',
      'household_id': 'H01',
    },
  );
  // Kho khởi đầu đặt thấp để nhu cầu thật sự sinh việc trong vài ngày đầu.
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-FOOD',
      'kind': 'staple_food',
      'quantity': 15000,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-WATER',
      'kind': 'clean_water',
      'quantity': 48000,
      'unit': 'ml',
    },
    <String, Object?>{
      'item_id': 'I-FUEL',
      'kind': 'firewood',
      'quantity': 4500,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-FEED',
      'kind': 'infant_feed',
      'quantity': 10000,
      'unit': 'ml',
      'energy_kj_per_100ml': 300,
      'water_ml_per_100ml': 92,
    },
    <String, Object?>{
      'item_id': 'I-CLOTH',
      'kind': 'swaddling_cloth',
      'quantity': 1,
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
        'position_mm': 0,
        'room_id': 'ROOM-SLEEP',
        'condition': 1000,
        'owner_household_id': 'H01',
      },
    );
  }
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'household_created',
    payload: <String, Object?>{
      'household_id': 'H01',
      'name': 'Hộ ven suối',
      'member_ids': const <String>['N01', 'N02', 'N03', 'P00'],
      'resource_item_ids': const <String, String>{
        'food': 'I-FOOD',
        'water': 'I-WATER',
        'fuel': 'I-FUEL',
        'infant_feed': 'I-FEED',
      },
      'authorized_users_by_item_id': <String, List<String>>{
        'I-FOOD': const <String>['N02', 'N03'],
        'I-WATER': const <String>['N01', 'N02', 'N03'],
        'I-FUEL': fuelRights,
        'I-FEED': const <String>['N01', 'N02'],
        'I-CLOTH': const <String>['N01', 'N02'],
      },
      'scheduled_work_seconds_by_person': const <String, int>{
        'N01': 28800,
        'N02': 28800,
        'N03': 28800,
      },
      'meal_actor_id': 'N02',
      'enable_v2_1': true,
      'enable_v2_2': true,
      'auto_plan': true,
      'infant_id': 'P00',
      'caregiver_id': 'N01',
      'production_actor_id': 'N03',
      'supply_carrier_id': 'N04',
    },
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
