import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.6: tay nghề lên theo giờ đã làm; đói và tâm trạng cùng quyết định
/// một người có nhận việc hay không.
void main() {
  final Simulation world = _world();

  final int fuelBefore = world.state.people['N03']!.skills!.level('gather_fuel');
  final int waterBefore = world.state.people['N01']!.skills!.level(
    'fetch_water',
  );

  // KT01: làm xong việc thì tay nghề lên, và có ghi lại.
  world.advanceTo(const SimTime(11 * 3600));
  final int fuelAfter = world.state.people['N03']!.skills!.level('gather_fuel');
  final int waterAfter = world.state.people['N01']!.skills!.level(
    'fetch_water',
  );
  _expect(
    fuelAfter > fuelBefore && waterAfter > waterBefore,
    'Làm xong khối việc thì tay nghề tương ứng phải lên.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'skill_improved' &&
          fact.subjectId == 'N03' &&
          fact.detail.contains('skill=gather_fuel'),
    ),
    'Lần lên tay nghề phải được ghi thành sự kiện đọc được.',
  );

  // KT02: cùng số giờ làm thì người mới lên nhanh hơn người đã giỏi.
  const PersonSkills novice = PersonSkills(<String, int>{'x': 100});
  const PersonSkills expert = PersonSkills(<String, int>{'x': 900});
  final int noviceGain = novice.gainFrom('x', 8 * 3600);
  final int expertGain = expert.gainFrom('x', 8 * 3600);
  _expect(
    noviceGain > expertGain && expertGain > 0,
    'Cùng công sức thì người tay nghề thấp phải lên nhiều điểm hơn người giỏi.',
  );
  _expect(
    const PersonSkills(<String, int>{'x': 1000}).gainFrom('x', 8 * 3600) == 0,
    'Đã kịch trần thì không lên thêm được nữa.',
  );

  // KT03: tay nghề lên rồi thì sản lượng dự kiến hôm sau cao hơn.
  world.advanceTo(const SimTime(gameSecondsPerDay + 6 * 3600));
  final RoutineBlock? dayOneFuel = world.state.people['N03']!.routine!
      .generatedBlocks
      .where((RoutineBlock block) => block.needKind == 'fuel')
      .firstOrNull;
  if (dayOneFuel != null) {
    _expect(
      dayOneFuel.outputAmount > 2256,
      'Tay nghề đã lên thì sản lượng dự kiến phải cao hơn hôm trước.',
    );
  }

  // KT04: ăn được bữa thì cơn đói hạ, không tích lại.
  _expect(
    world.state.people['N02']!.agenda!.hunger == 0,
    'Ăn đủ ba bữa thì không được tích cơn đói.',
  );

  // KT05: hụt bữa thì đói lên, tâm trạng xuống, và có ghi nhận.
  final Simulation starving = _world(starving: true);
  starving.advanceTo(const SimTime(2 * gameSecondsPerDay));
  final PersonAgenda hungry = starving.state.people['N01']!.agenda!;
  _expect(
    starving.state.households['H01']!.mealShortfalls > 0,
    'Kho cạn thì bữa ăn phải hụt thật.',
  );
  _expect(
    hungry.hunger > 0 && hungry.mood < 1000,
    'Hụt bữa phải làm người ta vừa đói vừa bực.',
  );
  _expect(
    starving.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'household_need_unstaffed' &&
          fact.detail.contains('need=food'),
    ),
    'Không ai đủ nghề kiếm lương thực thì kho không tự đầy lại được.',
  );

  // KT06: đói và bực đẩy ngưỡng nhận việc lên so với chỉ tính mệt.
  _expect(
    hungry.acceptanceFloor > hungry.fatigue ~/ 10,
    'Ngưỡng nhận việc phải cao hơn mức chỉ do mệt gây ra.',
  );
  _expect(
    hungry.hunger ~/ 20 >= 20,
    'Đói phải đóng góp đáng kể vào ngưỡng nhận việc, không chỉ là nhãn.',
  );
  // Người làm ít giờ hơn thì đói mới là nguyên nhân chính, không phải mệt.
  _expect(
    starving.state.people['N02']!.agenda!.mainStrain == 'đói',
    'Với người không làm nhiều, đói phải là nguyên nhân chính khiến khó nhận việc.',
  );

  // KT07: lý do từ chối nói rõ cả ba trục khi hộ có theo dõi.
  final WorldFact? refusal = starving.state.facts
      .where((WorldFact fact) => fact.kind == 'work_offer_refused')
      .lastOrNull;
  if (refusal != null) {
    _expect(
      refusal.detail.contains('hunger=') &&
          refusal.detail.contains('mood=') &&
          refusal.detail.contains('strain='),
      'Sự kiện từ chối phải ghi đủ mệt, đói, tâm trạng và nguyên nhân chính.',
    );
  }

  // KT08: bị cắt ngang giữa việc thì tâm trạng xấu đi.
  world.advanceTo(const SimTime(3 * gameSecondsPerDay + 13 * 3600));
  _expect(
    world.state.people['N02']!.agenda!.mood < 1000,
    'Người bị điều đi chăm trẻ giữa buổi phải bực hơn lúc đầu.',
  );

  // KT09: thế giới không bật cờ thì không có ba trục mới.
  final Simulation legacy = _world(wellbeing: false);
  legacy.advanceTo(const SimTime(2 * gameSecondsPerDay));
  _expect(
    legacy.state.people.values.every(
      (PersonState person) =>
          person.agenda == null ||
          (person.agenda!.hunger == 0 && person.agenda!.mood == 1000),
    ),
    'Hộ chưa bật theo dõi thì đói và tâm trạng phải đứng yên.',
  );
  _expect(
    legacy.state.people['N03']!.skills!.level('gather_fuel') == fuelBefore,
    'Hộ chưa bật theo dõi thì tay nghề không được tự lên.',
  );

  // KT10: lưu giữa lúc đang đói vẫn tái hiện đúng.
  final Simulation continuous = _world(starving: true);
  continuous.advanceTo(const SimTime(gameSecondsPerDay + 13 * 3600));
  _expect(
    continuous.state.people['N01']!.agenda!.hunger > 0,
    'Mốc lưu phải nằm lúc trong nhà đã có người đói.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(4 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(4 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa lúc đang đói phải tiếp tục cùng kết quả.',
  );

  print('V2.6 growth, hunger and mood verification passed.');
  print('Day 4 hash: ${continuous.state.semanticHash()}');
  print(
    'Tay nghề kiếm củi N03: $fuelBefore -> $fuelAfter; '
    'gánh nước N01: $waterBefore -> $waterAfter.',
  );
  print('Lên tay: người mới $noviceGain điểm, người giỏi $expertGain điểm.');
  print(
    'Nhà đói sau hai ngày: đói ${hungry.hunger}, tâm trạng ${hungry.mood}, '
    'ngưỡng ${hungry.acceptanceFloor} (${hungry.mainStrain}).',
  );
}

Simulation _world({bool starving = false, bool wellbeing = true}) {
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
      'skills': <String, int>{
        'fetch_water': 700,
        'gather_food': starving ? 100 : 300,
      },
      'agenda': const <String, Object?>{'fatigue': 0},
      'routine': const <Map<String, Object?>>[
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
      // Nghề kiếm lương thực còn non, để thấy người mới lên tay nhanh hơn.
      'skills': <String, int>{
        'cook': 900,
        'gather_fuel': 150,
        'fetch_water': 400,
        'gather_food': starving ? 100 : 250,
      },
      'agenda': const <String, Object?>{'fatigue': 0},
      'routine': const <Map<String, Object?>>[
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
      'skills': <String, int>{
        'gather_fuel': 850,
        // Nhà đói: không ai đủ nghề kiếm lương thực nên kho không tự đầy lại.
        'gather_food': starving ? 150 : 700,
        'fetch_water': 600,
      },
      'agenda': const <String, Object?>{'fatigue': 500},
      'routine': const <Map<String, Object?>>[
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
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-FOOD',
      'kind': 'staple_food',
      // Nhà đói: chỉ đủ hai bữa rồi hụt.
      'quantity': starving ? 1000 : 15000,
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
      'authorized_users_by_item_id': const <String, List<String>>{
        'I-FOOD': <String>['N02', 'N03'],
        'I-WATER': <String>['N01', 'N02', 'N03'],
        'I-FUEL': <String>['N02', 'N03'],
        'I-FEED': <String>['N01', 'N02'],
        'I-CLOTH': <String>['N01', 'N02'],
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
      'enable_v2_6': wellbeing,
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
