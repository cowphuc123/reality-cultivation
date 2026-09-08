import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  final Simulation simulation = _world();
  final int onset = 3 * gameSecondsPerDay + 9 * 3600;
  simulation.advanceTo(SimTime(onset));
  final IllnessState onsetState = simulation.state.illnesses['ILL-P00-01']!;
  _expect(onsetState.severity == 420, 'Bệnh phải khởi phát ở mức 420.');
  _expect(
    !onsetState.detected,
    'Bệnh chưa thể được phát hiện cùng tức khởi phát.',
  );

  final int waterBeforeCare = simulation.state.items['I-WATER']!.quantity;
  final int interruptionBeforeCare =
      simulation
          .state
          .households['H01']!
          .totalCareInterruptionSecondsByPerson['N01'] ??
      0;
  simulation.advanceTo(SimTime(onset + 906));
  final IllnessState cared = simulation.state.illnesses['ILL-P00-01']!;
  _expect(cared.detected, 'Người chăm sóc phải phát hiện bệnh.');
  _expect(cared.severity == 300, 'Chăm sóc phải giảm mức bệnh xuống 300.');
  _expect(cared.careMinutes == 10, 'Phải ghi đúng mười phút chăm sóc.');
  _expect(
    simulation.state.items['I-WATER']!.quantity == waterBeforeCare - 100,
    'Chăm sóc phải dùng đúng 100 ml nước sạch.',
  );
  _expect(
    simulation.state.people['N01']!.roomId == 'ROOM-SLEEP',
    'Người chăm sóc phải tới gian ngủ.',
  );
  final int illnessInterruption =
      (simulation
              .state
              .households['H01']!
              .totalCareInterruptionSecondsByPerson['N01'] ??
          0) -
      interruptionBeforeCare;
  _expect(
    illnessInterruption >= 600 && illnessInterruption <= 605,
    'Sổ lao động phải ghi thời gian đổi lịch vì bệnh, nhận $illnessInterruption.',
  );

  simulation.advanceTo(const SimTime(6 * gameSecondsPerDay));
  _expect(
    simulation.state.illnesses['ILL-P00-01']!.stage == IllnessStage.resolved,
    'Bệnh nhẹ phải lui sau chuỗi chăm sóc và hồi phục.',
  );
  _expect(
    simulation.state.households['H01']!.supplyDeliveries == 1,
    'Đến ngày 6 phải có một chuyến tiếp tế.',
  );
  _expect(
    simulation.state.households['H01']!.productionRuns == 5,
    'Đến ngày 6 phải có năm lượt kiếm củi.',
  );

  final Simulation original = _world();
  original.advanceTo(const SimTime(4 * gameSecondsPerDay));
  final Simulation restored = Simulation.fromSave(original.state.save());
  original.advanceTo(const SimTime(10 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(10 * gameSecondsPerDay));
  _expect(
    original.state.semanticHash() == restored.state.semanticHash(),
    'Lưu/tải giữa lúc bệnh phải tiếp tục cùng kết quả.',
  );

  print('V2.1 household health verification passed.');
  print('Day 10 hash: ${original.state.semanticHash()}');
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
  for (final (String, String, int, String, bool) person
      in <(String, String, int, String, bool)>[
        ('N01', 'Người chăm sóc', 5000, 'ROOM-KITCHEN', true),
        ('N02', 'Người nấu ăn', 5000, 'ROOM-KITCHEN', false),
        ('N03', 'Người kiếm củi', 12000, 'ROOM-YARD', false),
      ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': person.$1,
        'name': person.$2,
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': person.$3,
        'room_id': person.$4,
        'household_id': 'H01',
        'caregiver_agent': person.$5,
        'current_activity': person.$1 == 'N01' ? 'may vá' : 'lao động',
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
        'I-FEED': <String>['N01'],
        'I-CLOTH': <String>['N01'],
      },
      'scheduled_work_seconds_by_person': <String, int>{
        'N01': 28800,
        'N02': 28800,
        'N03': 28800,
      },
      'meal_actor_id': 'N02',
      'enable_v2_1': true,
      'infant_id': 'P00',
      'caregiver_id': 'N01',
      'production_actor_id': 'N03',
    },
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
