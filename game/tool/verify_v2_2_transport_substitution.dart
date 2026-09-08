import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  final Simulation world = _world();
  world.advanceTo(const SimTime(4 * gameSecondsPerDay));
  final HouseholdState dayFour = world.state.households['H01']!;
  final InfantBodyState body = world.state.people['P00']!.infancy!.body!;
  _expect(
    dayFour.caregiverSubstitutions >= 1,
    'Hộ phải tìm được ít nhất một lượt người chăm sóc thay thế.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'illness_detected' &&
          fact.detail.contains('caregiver=N02'),
    ),
    'N02 phải thay N01 phát hiện và chăm bệnh.',
  );
  _expect(
    body.illnessEnergyCostKj > 0 &&
        body.illnessWaterLossMl > 0 &&
        body.illnessSleepDisruptionMinutes > 0,
    'Bệnh phải tác động trực tiếp lên năng lượng, nước và giấc ngủ.',
  );

  world.advanceTo(const SimTime(5 * gameSecondsPerDay + 6 * 3600));
  final SupplyJourneyState delayed = world.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    delayed.status == SupplyJourneyStatus.delayed,
    'Chuyến đầu phải bước vào trạng thái bị trễ.',
  );
  _expect(delayed.delaySeconds == 6 * 3600, 'Chuyến đầu phải trễ sáu giờ.');
  _expect(
    world.state.households['H01']!.supplyDeliveries == 0,
    'Hàng đang trễ chưa được cộng vào kho.',
  );

  world.advanceTo(const SimTime(5 * gameSecondsPerDay + 12 * 3600));
  final SupplyJourneyState first = world.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    first.status == SupplyJourneyStatus.delivered &&
        first.actualArrivalSeconds == first.expectedArrivalSeconds + 6 * 3600,
    'Chuyến đầu phải tới sau đúng thời gian trễ.',
  );
  _expect(
    world.state.households['H01']!.supplyDeliveries == 1,
    'Kho chỉ nhận hàng khi người vận chuyển tới.',
  );

  world.advanceTo(const SimTime(10 * gameSecondsPerDay + 6 * 3600));
  final SupplyJourneyState second = world.state.supplyJourneys['SUP-H01-1']!;
  _expect(
    second.status == SupplyJourneyStatus.delivered &&
        second.actualArrivalSeconds == second.expectedArrivalSeconds &&
        second.delaySeconds == 0,
    'Chuyến thứ hai phải tới đúng lịch.',
  );
  final HouseholdState household = world.state.households['H01']!;
  _expect(household.supplyDeliveries == 2, 'Phải có đúng hai chuyến đã giao.');
  _expect(
    world.state.items['I-FOOD']!.quantity ==
        50000 - household.foodConsumedGrams + 2 * 7500,
    'Sổ lương thực phải bằng đầu kỳ trừ tiêu dùng cộng hàng giao.',
  );
  _expect(
    world.state.items['I-WATER']!.quantity ==
        200000 - household.waterConsumedMl - 100 + 2 * 30000,
    'Sổ nước phải gồm bữa ăn, chăm bệnh và hai chuyến giao.',
  );
  _expect(
    world.state.items['I-FUEL']!.quantity ==
        40000 - household.fuelConsumedGrams + household.productionRuns * 1200,
    'Sổ củi phải bằng đầu kỳ trừ bữa ăn cộng sản xuất.',
  );

  final Simulation continuous = _world();
  continuous.advanceTo(const SimTime(5 * gameSecondsPerDay + 8 * 3600));
  _expect(
    continuous.state.supplyJourneys['SUP-H01-0']!.status ==
        SupplyJourneyStatus.delayed,
    'Mốc lưu phải nằm giữa lúc chuyến hàng đang trễ.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(11 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(11 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa hành trình trễ phải tiếp tục đúng cùng kết quả.',
  );

  print('V2.2 transport and substitution verification passed.');
  print('Day 11 hash: ${continuous.state.semanticHash()}');
  print(
    'Illness costs: ${body.illnessEnergyCostKj} kJ, '
    '${body.illnessWaterLossMl} ml, '
    '${body.illnessSleepDisruptionMinutes} sleep-disruption minutes.',
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
    },
    <String, Object?>{
      'person_id': 'N03',
      'name': 'Người kiếm củi',
      'position_mm': 12000,
      'room_id': 'ROOM-YARD',
      'household_id': 'H01',
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

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
