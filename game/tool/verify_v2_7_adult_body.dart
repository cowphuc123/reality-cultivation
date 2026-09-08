import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.7: cơ thể người lớn — bữa ăn nuôi thật, ngày trôi thì đốt năng lượng,
/// đói lâu thì sụt cân và làm ra ít hơn.
void main() {
  // KC01: quy tắc sức làm việc theo cân nặng là số, không phải nhãn.
  const AdultBodyState healthy = AdultBodyState(
    massGrams: 52000,
    healthyMassGrams: 52000,
    energyReserveKj: AdultBodyState.reserveCapacityKj,
    bodyWaterMl: 31200,
  );
  const AdultBodyState thin = AdultBodyState(
    massGrams: 44200,
    healthyMassGrams: 52000,
    energyReserveKj: 0,
    bodyWaterMl: 26520,
  );
  _expect(
    healthy.capability == 1000 && thin.capability == 500,
    'Đủ cân thì sức làm việc đầy; sụt còn 85% thì chỉ còn một nửa.',
  );
  _expect(
    healthy.hunger == 0 && thin.hunger == 1000,
    'Cơn đói phải suy từ dự trữ còn lại của cơ thể.',
  );

  // KC02: đốt năng lượng theo số giờ đã lao động thật.
  final AdultBodyDayResult idle = healthy.advanceDay(workedSeconds: 0);
  final AdultBodyDayResult busy = healthy.advanceDay(workedSeconds: 8 * 3600);
  _expect(
    idle.burnedKj == 5500 && busy.burnedKj == 5500 + 8 * 200,
    'Làm nhiều giờ hơn thì đốt nhiều năng lượng hơn.',
  );
  _expect(
    idle.lostGrams == 0 && busy.lostGrams == 0,
    'Còn dự trữ thì chưa đụng tới khối lượng.',
  );

  // KC03: hết dự trữ mới ăn vào khối lượng.
  final AdultBodyDayResult starved = thin.advanceDay(workedSeconds: 0);
  _expect(
    starved.lostGrams == 5500 ~/ 30,
    'Hết dự trữ thì thiếu bao nhiêu kilojoule phải sụt bấy nhiêu gam.',
  );

  final Simulation world = _world();

  // KC04: bữa ăn của hộ đi thẳng vào dự trữ của từng người lớn.
  final int reserveStart = world.state.people['N01']!.body!.energyReserveKj;
  world.advanceTo(const SimTime(8 * 3600));
  _expect(
    world.state.people['N01']!.body!.totalIntakeKj > 0,
    'Ăn xong bữa sáng thì phải có năng lượng vào cơ thể.',
  );
  _expect(
    world.state.people['P00']!.body == null,
    'Trẻ sơ sinh dùng cơ thể riêng của mình, không dùng cơ thể người lớn.',
  );

  // KC05: chốt ngày thì cơ thể đốt năng lượng theo giờ đã làm.
  world.advanceTo(const SimTime(23 * 3600));
  final AdultBodyState afterDay = world.state.people['N01']!.body!;
  _expect(
    afterDay.totalBurnedKj >= AdultBodyState.basalKjPerDay,
    'Hết ngày thì cơ thể phải đốt ít nhất mức nền.',
  );
  _expect(
    afterDay.energyReserveKj != reserveStart,
    'Dự trữ phải đổi sau một ngày ăn và làm.',
  );

  // KC06: nhà đói thì sụt cân thật và có ghi lại.
  final Simulation starving = _world(starving: true);
  starving.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final AdultBodyState worn = starving.state.people['N03']!.body!;
  _expect(
    worn.massLostGrams > 0 && worn.massGrams < worn.healthyMassGrams,
    'Đói nhiều ngày thì phải sụt cân thật.',
  );
  _expect(
    starving.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'body_mass_lost' && fact.detail.contains('capability='),
    ),
    'Lần sụt cân phải được ghi kèm sức làm việc còn lại.',
  );

  // KC07: sụt cân thì sức làm việc giảm và sản lượng dự kiến giảm theo.
  _expect(
    worn.capability < 1000,
    'Sụt cân phải kéo sức làm việc xuống dưới mức đầy.',
  );
  final RoutineBlock? weakened = starving.state.people['N03']!.routine!
      .generatedBlocks
      .firstOrNull;
  if (weakened != null && weakened.outputAmount > 0) {
    final int bySkillOnly = starving.state.people['N03']!.skills!.output(
      'gather_fuel',
      2400,
    );
    _expect(
      weakened.needKind != 'fuel' || weakened.outputAmount <= bySkillOnly,
      'Người yếu đi thì sản lượng dự kiến không được cao hơn mức tay nghề.',
    );
  }

  // KC08: ăn no trở lại thì hồi được phần cân đã sụt.
  const AdultBodyState recovering = AdultBodyState(
    massGrams: 50000,
    healthyMassGrams: 52000,
    energyReserveKj: AdultBodyState.reserveCapacityKj,
    bodyWaterMl: 30000,
  );
  final AdultBodyState recovered = recovering.recover();
  _expect(
    recovered.massGrams > recovering.massGrams &&
        recovered.energyReserveKj < recovering.energyReserveKj,
    'Dư dả thì phải đổi dự trữ lấy cân nặng đã mất.',
  );
  _expect(
    healthy.recover().massGrams == healthy.massGrams,
    'Đã đủ cân thì không tự béo thêm.',
  );

  // KC09: người không có cơ thể giữ nguyên hành vi cũ.
  final Simulation legacy = _world(bodies: false);
  legacy.advanceTo(const SimTime(2 * gameSecondsPerDay));
  _expect(
    legacy.state.people.values.every(
      (PersonState person) => person.body == null,
    ),
    'Thế giới không khai báo cơ thể thì không được tự sinh ra cơ thể.',
  );
  _expect(
    legacy.state.facts.every(
      (WorldFact fact) => fact.kind != 'body_mass_lost',
    ),
    'Không có cơ thể thì không có chuyện sụt cân.',
  );

  // KC10: lưu giữa lúc đang sụt cân vẫn tái hiện đúng.
  final Simulation continuous = _world(starving: true);
  continuous.advanceTo(const SimTime(3 * gameSecondsPerDay + 12 * 3600));
  _expect(
    continuous.state.people['N03']!.body!.energyReserveKj <
        AdultBodyState.reserveCapacityKj,
    'Mốc lưu phải nằm lúc dự trữ đã vơi.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(6 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(6 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa lúc cơ thể đang sụt phải tiếp tục cùng kết quả.',
  );

  print('V2.7 adult body verification passed.');
  print('Day 6 hash: ${continuous.state.semanticHash()}');
  print(
    'Nhà đói sau sáu ngày, N03: ${worn.massGrams} g '
    '(mất ${worn.massLostGrams} g), dự trữ ${worn.energyReserveKj} kJ, '
    'sức làm việc ${worn.capability}/1000.',
  );
  final AdultBodyState fed = world.state.people['N01']!.body!;
  print(
    'Nhà đủ ăn, N01: ${fed.massGrams} g, dự trữ ${fed.energyReserveKj} kJ, '
    'đã ăn ${fed.totalIntakeKj} kJ, đã đốt ${fed.totalBurnedKj} kJ.',
  );
}

Simulation _world({bool starving = false, bool bodies = true}) {
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
  // Nhà đói vốn đã ít mỡ dự phòng, nên vài ngày là chạm tới khối lượng.
  final Map<String, Object?>? body = bodies
      ? <String, Object?>{
          'mass_g': 52000,
          if (starving) 'energy_reserve_kj': 12000,
        }
      : null;
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
      'agenda': const <String, Object?>{'fatigue': 0},
      'adult_body': body,
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
      'skills': <String, int>{
        'cook': 900,
        'gather_fuel': 150,
        'fetch_water': 400,
        'gather_food': starving ? 100 : 250,
      },
      'agenda': const <String, Object?>{'fatigue': 0},
      'adult_body': body,
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
        // Nhà đói: không ai đủ nghề kiếm lương thực nên kho không đầy lại.
        'gather_food': starving ? 150 : 700,
        'fetch_water': 600,
      },
      'agenda': const <String, Object?>{'fatigue': 0},
      'adult_body': body,
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
      'enable_v2_6': true,
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
