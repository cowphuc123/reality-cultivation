import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.5: kỹ năng nghề chọn người, người mệt được quyền từ chối, việc bị lùi
/// hết lượt thì được xếp lại thay vì mất trắng.
void main() {
  final Simulation world = _world();
  world.advanceTo(const SimTime(5 * 3600 + 60));

  final WorldFact plan = world.state.facts.lastWhere(
    (WorldFact fact) => fact.kind == 'household_plan_made',
  );

  // KN01: không đủ tay nghề thì không được giao, dù có quyền dùng kho.
  _expect(
    plan.detail.contains('fuel:N03'),
    'Việc kiếm củi phải về tay người có nghề, không phải người nấu ăn.',
  );
  _expect(
    world.state.households['H01']!.canUse('N02', 'I-FUEL'),
    'N02 vẫn có quyền dùng kho củi; bị loại là do tay nghề chứ không do quyền.',
  );

  // KN02: cùng đủ nghề thì người giỏi hơn được chọn trước.
  _expect(
    plan.detail.contains('water:N01'),
    'Gánh nước phải về tay người có tay nghề nước cao nhất.',
  );

  // KN03: người đang mệt từ chối việc chưa đủ gấp, việc chuyển sang người khác.
  final WorldFact refusal = world.state.facts.firstWhere(
    (WorldFact fact) => fact.kind == 'work_offer_refused',
  );
  _expect(
    refusal.subjectId == 'N03' && refusal.detail.contains('skill=gather_food'),
    'N03 đang mệt phải từ chối việc kiếm lương thực chưa gấp.',
  );
  _expect(
    plan.detail.contains('food:N02'),
    'Việc bị từ chối phải được chào tiếp cho người sau, không bỏ lửng.',
  );
  _expect(
    world.state.people['N03']!.agenda!.refusedOffers == 1 &&
        world.state.people['N02']!.agenda!.acceptedOffers == 1,
    'Cả lần từ chối lẫn lần nhận việc đều phải được ghi vào hồ sơ riêng.',
  );

  // KN04: sản lượng dự kiến đã tính theo tay nghề của đúng người nhận việc.
  final RoutineBlock fuelBlock = world.state.people['N03']!.routine!
      .generatedBlocks
      .firstWhere((RoutineBlock block) => block.needKind == 'fuel');
  _expect(
    fuelBlock.outputAmount == 2256,
    'Tay nghề 850 phải cho sản lượng 2256 thay vì mức gốc 2400.',
  );

  // KN05: việc bị lùi hết lượt được xếp lại vào giờ trống chứ không mất.
  world.advanceTo(const SimTime(7 * 3600 + 30 * 60));
  final RoutineState caregiver = world.state.people['N01']!.routine!;
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'routine_block_rescheduled' &&
          fact.detail.contains('activity=quét sân'),
    ),
    'Quét sân bị lùi hết lượt phải được xếp lại chứ không bị bỏ.',
  );
  _expect(
    caregiver.droppedBlocks == 0,
    'Không được bỏ hẳn khối nào khi trong ngày vẫn còn giờ trống.',
  );
  _expect(
    caregiver.generatedBlocks.any(
      (RoutineBlock block) => block.id.startsWith('RESCHED-'),
    ),
    'Bản xếp lại phải nằm trong nhịp sống dưới dạng khối riêng của ngày.',
  );

  // KN06: làm việc thì mệt thêm, và bản xếp lại vẫn chạy thật.
  world.advanceTo(const SimTime(18 * 3600));
  _expect(
    world.state.people['N03']!.agenda!.fatigue > 600,
    'Làm bốn giờ kiếm củi phải khiến N03 mệt hơn lúc sáng.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'routine_block_started' &&
          fact.detail.contains('RESCHED-'),
    ),
    'Khối đã xếp lại phải thật sự được bắt đầu ở giờ mới.',
  );

  // KN07: ngủ một đêm thì hồi sức, ưu tiên chấp nhận việc hạ xuống.
  final int beforeNight = world.state.people['N03']!.agenda!.fatigue;
  world.advanceTo(const SimTime(gameSecondsPerDay + 5 * 3600 + 60));
  final PersonAgenda morning = world.state.people['N03']!.agenda!;
  _expect(
    morning.fatigue == beforeNight - 250,
    'Một đêm ngủ phải hồi đúng số điểm mệt đã định.',
  );

  // KN08: cả nhà kiệt sức thì hộ ghi thiếu người, không ép ai làm.
  final Simulation exhausted = _world(exhausted: true);
  exhausted.advanceTo(const SimTime(5 * 3600 + 60));
  _expect(
    exhausted.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'household_need_unstaffed' &&
          fact.detail.contains('need=fuel'),
    ),
    'Không ai đồng ý thì nhu cầu phải được ghi là thiếu người.',
  );
  _expect(
    exhausted.state.people.values.every(
      (PersonState person) => person.routine?.generatedBlocks.isEmpty ?? true,
    ),
    'Không được ép giao việc cho người đã từ chối.',
  );

  // KN09: lưu giữa lúc có người đang từ chối việc vẫn tái hiện đúng.
  final Simulation continuous = _world();
  continuous.advanceTo(const SimTime(9 * 3600));
  _expect(
    continuous.state.people['N03']!.agenda!.refusedOffers > 0,
    'Mốc lưu phải nằm sau khi đã có lần từ chối.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(4 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(4 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa lúc có người từ chối việc phải tiếp tục cùng kết quả.',
  );

  print('V2.5 skills and refusal verification passed.');
  print('Day 4 hash: ${continuous.state.semanticHash()}');
  print('Kế hoạch ngày 0: ${plan.detail}');
  final PersonAgenda laborer = world.state.people['N03']!.agenda!;
  print(
    'N03: mệt ${laborer.fatigue}/1000, nhận ${laborer.acceptedOffers}, '
    'từ chối ${laborer.refusedOffers} (${laborer.lastRefusalReason}).',
  );
}

Simulation _world({bool exhausted = false}) {
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
      'skills': const <String, int>{'fetch_water': 700, 'gather_food': 300},
      'agenda': <String, Object?>{'fatigue': exhausted ? 1000 : 0},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N01-SAN',
          'activity': 'quét sân',
          'start_second_of_day': 22500,
          'duration_seconds': 1800,
          'room_id': 'ROOM-YARD',
          'priority': 20,
        },
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
      'skills': const <String, int>{
        'cook': 900,
        'gather_fuel': 150,
        'fetch_water': 400,
        'gather_food': 400,
      },
      'agenda': <String, Object?>{'fatigue': exhausted ? 1000 : 0},
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
      'skills': const <String, int>{
        'gather_fuel': 850,
        'gather_food': 700,
        'fetch_water': 600,
      },
      // Đã kiệt sức từ trước, nên chỉ còn nhận việc thật gấp.
      'agenda': <String, Object?>{'fatigue': exhausted ? 1000 : 850},
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
    payload: const <String, Object?>{
      'household_id': 'H01',
      'name': 'Hộ ven suối',
      'member_ids': <String>['N01', 'N02', 'N03', 'P00'],
      'resource_item_ids': <String, String>{
        'food': 'I-FOOD',
        'water': 'I-WATER',
        'fuel': 'I-FUEL',
        'infant_feed': 'I-FEED',
      },
      'authorized_users_by_item_id': <String, List<String>>{
        'I-FOOD': <String>['N02', 'N03'],
        'I-WATER': <String>['N01', 'N02', 'N03'],
        'I-FUEL': <String>['N02', 'N03'],
        'I-FEED': <String>['N01', 'N02'],
        'I-CLOTH': <String>['N01', 'N02'],
      },
      'scheduled_work_seconds_by_person': <String, int>{
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
