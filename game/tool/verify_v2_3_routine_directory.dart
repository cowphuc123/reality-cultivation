import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.3: nhịp sống NPC có xung đột lịch thật và hồ sơ mọi người/vật trong thế giới.
void main() {
  final Simulation world = _world();
  final SimulationHost host = SimulationHost(world);

  // NN01: nhịp sống đưa người tới đúng phòng vào đúng giờ.
  world.advanceTo(const SimTime(6 * 3600 + 30 * 60));
  _expect(
    world.state.people['N02']!.routine!.activeBlock?.id == 'R-N02-SANG',
    'N02 phải đang nấu bữa sáng lúc 06:30.',
  );
  _expect(
    world.state.people['N02']!.roomId == 'ROOM-KITCHEN',
    'Khối nấu ăn phải đưa N02 vào gian bếp.',
  );
  _expect(
    world.state.people['N03']!.routine!.activeBlock?.id == 'R-N03-CUI',
    'N03 phải đang kiếm củi lúc 06:30.',
  );
  _expect(
    world.state.people['N03']!.positionMm == 12000,
    'Khối kiếm củi phải đưa N03 ra sân.',
  );

  // NN02: bữa trưa phải lùi giờ vì người nấu đang ở tuyến nước xa.
  world.advanceTo(const SimTime(12 * 3600));
  _expect(
    world.state.people['N02']!.routine!.blockingActivity ==
        'gánh nước suối xa',
    'Lúc 12:00 N02 phải đang ở tuyến nước xa và không nhận việc khác.',
  );
  _expect(
    world.state.households['H01']!.mealsCompleted == 1,
    'Chỉ bữa sáng được hoàn tất trước khi bữa trưa bị lùi.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'household_meal_deferred' &&
          fact.detail.contains('competing=gánh nước suối xa'),
    ),
    'Bữa trưa phải được ghi nhận là bị lùi vì xung đột lịch.',
  );

  // NN03: bữa trưa vẫn diễn ra khi người nấu về, và bị ghi là muộn.
  world.advanceTo(const SimTime(13 * 3600 + 60));
  final WorldFact lateMeal = world.state.facts.lastWhere(
    (WorldFact fact) => fact.kind == 'household_meal_completed',
  );
  _expect(
    lateMeal.detail.contains('late_seconds=3600') &&
        lateMeal.detail.contains('deferrals=2'),
    'Bữa trưa phải hoàn tất muộn đúng một giờ sau hai lần lùi.',
  );
  _expect(
    world.state.households['H01']!.mealsCompleted == 2,
    'Bữa bị lùi vẫn phải được nấu, không bị mất.',
  );

  // NN05: người ngoài hộ vẫn có nhịp sống riêng.
  final PersonProfileView carrier = host
      .directory()
      .people
      .firstWhere((PersonProfileView value) => value.id == 'N04');
  _expect(
    !carrier.inHousehold && carrier.routine != null,
    'Người vận chuyển ở ngoài hộ nhưng vẫn phải có nhịp sống riêng.',
  );
  _expect(
    carrier.activity == 'đi tuyến An Khê',
    'Hồ sơ phải cho biết người ngoài hộ đang làm gì.',
  );

  // NN04: bữa tối vẫn giữ đúng giờ gốc, lùi giờ không kéo trôi cả ngày.
  world.advanceTo(const SimTime(18 * 3600 + 60));
  _expect(
    world.state.households['H01']!.mealsCompleted == 3,
    'Bữa tối phải diễn ra đúng 18:00 dù bữa trưa đã lùi.',
  );

  // NN06: bệnh của trẻ cắt ngang công việc của người thay và ghi lại giờ mất.
  world.advanceTo(const SimTime(3 * gameSecondsPerDay + 11 * 3600));
  final RoutineState substitute = world.state.people['N02']!.routine!;
  final ScheduleConflict preempted = substitute.conflicts.lastWhere(
    (ScheduleConflict value) =>
        value.resolution == 'preempted' &&
        value.competingActivity == 'chăm trẻ bệnh',
  );
  _expect(
    preempted.plannedActivity == 'giã gạo' && preempted.lostSeconds > 0,
    'Việc giã gạo của N02 phải bị cắt và ghi lại số giây đã mất.',
  );
  _expect(
    substitute.lostSeconds >= preempted.lostSeconds,
    'Tổng giờ mất phải bao gồm lần bị cắt này.',
  );

  // NN07: người chăm sóc nghỉ bệnh cũng làm hỏng khối việc đang dở.
  final RoutineState caregiver = world.state.people['N01']!.routine!;
  _expect(
    caregiver.conflicts.any(
      (ScheduleConflict value) =>
          value.competingActivity.startsWith('nghỉ vì') &&
          value.plannedActivity == 'may vá',
    ),
    'Khi N01 nghỉ vì sốt, khối may vá phải được ghi là mất giờ.',
  );

  // NN08: hồ sơ mở cho mọi người và mọi vật, kể cả ngoài sổ kho.
  final WorldDirectoryView directory = host.directory();
  _expect(
    directory.people.length == world.state.people.length &&
        directory.items.length == world.state.items.length,
    'Danh bạ phải liệt kê đủ mọi người và mọi vật đã tồn tại.',
  );
  _expect(
    directory.outsideHousehold
            .map((PersonProfileView value) => value.id)
            .toList()
            .join(',') ==
        'N04',
    'Đúng một người ngoài hộ phải được tách ra rõ ràng.',
  );
  final ItemProfileView cloth = directory.items.firstWhere(
    (ItemProfileView value) => value.id == 'I-CLOTH',
  );
  _expect(
    !cloth.inHouseholdLedger &&
        cloth.ownerHouseholdName == 'Hộ ven suối' &&
        cloth.authorizedUserNames.isNotEmpty,
    'Khăn quấn nằm ngoài sổ kho nhưng vẫn có chủ và người được dùng.',
  );
  final ItemProfileView food = directory.items.firstWhere(
    (ItemProfileView value) => value.id == 'I-FOOD',
  );
  _expect(
    food.resourceKey == 'food' && food.quantity > 0 && food.unit == 'g',
    'Vật phẩm trong sổ kho phải mang đúng khóa nguồn lực và số thật.',
  );

  // NN09: trẻ sơ sinh không bị gán nhịp sống của người lớn.
  _expect(
    directory.people
            .firstWhere((PersonProfileView value) => value.id == 'P00')
            .routine ==
        null,
    'Trẻ sơ sinh chưa có nhịp sống lao động.',
  );

  // NN10: lưu giữa lúc bữa ăn đang bị lùi vẫn tái hiện đúng.
  final Simulation continuous = _world();
  continuous.advanceTo(const SimTime(12 * 3600 + 10 * 60));
  _expect(
    continuous.state.facts.any(
      (WorldFact fact) => fact.kind == 'household_meal_deferred',
    ),
    'Mốc lưu phải nằm sau lần lùi bữa đầu tiên.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(4 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(4 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa lúc lịch đang xung đột phải tiếp tục cùng kết quả.',
  );

  print('V2.3 routine and directory verification passed.');
  print('Day 4 hash: ${continuous.state.semanticHash()}');
  print(
    'N02: ${substitute.completedBlocks} khối xong, '
    '${substitute.deferredStarts} lần lùi, '
    '${substitute.conflictCount} xung đột, '
    '${substitute.lostSeconds} giây mất.',
  );
  print(
    'N01: ${caregiver.completedBlocks} khối xong, '
    '${caregiver.conflictCount} xung đột, '
    '${caregiver.lostSeconds} giây mất.',
  );
}

Simulation _world() {
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
      'routine': routineN01,
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
      'routine': routineN02,
    },
    <String, Object?>{
      'person_id': 'N03',
      'name': 'Người kiếm củi',
      'position_mm': 12000,
      'room_id': 'ROOM-YARD',
      'household_id': 'H01',
      'routine': routineN03,
    },
    <String, Object?>{
      'person_id': 'N04',
      'name': 'Người vận chuyển',
      'position_mm': 500000,
      'routine': routineN04,
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
      'quantity': 50000,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-WATER',
      'kind': 'clean_water',
      'quantity': 200000,
      'unit': 'ml',
    },
    <String, Object?>{
      'item_id': 'I-FUEL',
      'kind': 'firewood',
      'quantity': 40000,
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
        'I-FOOD': <String>['N02'],
        'I-WATER': <String>['N01', 'N02'],
        'I-FUEL': <String>['N02'],
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
      'infant_id': 'P00',
      'caregiver_id': 'N01',
      'production_actor_id': 'N03',
      'supply_carrier_id': 'N04',
    },
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

/// Các khối nhịp sống là fixture kỹ thuật để kiểm chứng xung đột lịch.
const List<Map<String, Object?>> routineN01 = <Map<String, Object?>>[
  <String, Object?>{
    'id': 'R-N01-NUOC',
    'activity': 'gánh nước sáng',
    'start_second_of_day': 19800,
    'duration_seconds': 5400,
    'room_id': 'ROOM-YARD',
  },
  <String, Object?>{
    'id': 'R-N01-VA',
    'activity': 'may vá',
    'start_second_of_day': 25200,
    'duration_seconds': 14400,
    'room_id': 'ROOM-KITCHEN',
  },
  <String, Object?>{
    'id': 'R-N01-VUON',
    'activity': 'chăm vườn',
    'start_second_of_day': 46800,
    'duration_seconds': 14400,
    'room_id': 'ROOM-YARD',
  },
];

const List<Map<String, Object?>> routineN02 = <Map<String, Object?>>[
  <String, Object?>{
    'id': 'R-N02-SANG',
    'activity': 'nấu bữa sáng',
    'start_second_of_day': 21600,
    'duration_seconds': 5400,
    'room_id': 'ROOM-KITCHEN',
    'priority': 70,
  },
  <String, Object?>{
    'id': 'R-N02-GAO',
    'activity': 'giã gạo',
    'start_second_of_day': 28800,
    'duration_seconds': 10800,
    'room_id': 'ROOM-KITCHEN',
  },
  <String, Object?>{
    'id': 'R-N02-XA',
    'activity': 'gánh nước suối xa',
    'start_second_of_day': 41400,
    'duration_seconds': 4200,
    'room_id': 'ROOM-YARD',
    'blocking': true,
  },
  <String, Object?>{
    'id': 'R-N02-TOI',
    'activity': 'nấu bữa tối',
    'start_second_of_day': 61200,
    'duration_seconds': 7200,
    'room_id': 'ROOM-KITCHEN',
    'priority': 70,
  },
];

const List<Map<String, Object?>> routineN03 = <Map<String, Object?>>[
  <String, Object?>{
    'id': 'R-N03-CUI',
    'activity': 'kiếm củi',
    'start_second_of_day': 23400,
    'duration_seconds': 32400,
    'room_id': 'ROOM-YARD',
  },
];

const List<Map<String, Object?>> routineN04 = <Map<String, Object?>>[
  <String, Object?>{
    'id': 'R-N04-TUYEN',
    'activity': 'đi tuyến An Khê',
    'start_second_of_day': 18000,
    'duration_seconds': 43200,
  },
];

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
