import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  final Simulation firstMeal = _householdWorld();
  firstMeal.advanceTo(const SimTime(7 * 3600));
  final HouseholdState first = firstMeal.state.households['H01']!;
  _expect(first.mealsCompleted == 1, 'Bữa sáng phải hoàn tất.');
  _expect(
    firstMeal.state.items['I-FOOD']!.quantity == 49500,
    'Sai lượng thức ăn.',
  );
  _expect(
    firstMeal.state.items['I-WATER']!.quantity == 198000,
    'Sai lượng nước.',
  );
  _expect(
    firstMeal.state.items['I-FUEL']!.quantity == 39700,
    'Sai lượng nhiên liệu.',
  );

  final Simulation unauthorized = _householdWorld(mealActorId: 'N03');
  unauthorized.advanceTo(const SimTime(7 * 3600));
  _expect(
    unauthorized.state.households['H01']!.unauthorizedAttempts == 1,
    'Người không có quyền phải bị từ chối.',
  );
  _expect(
    unauthorized.state.items['I-FOOD']!.quantity == 50000 &&
        unauthorized.state.items['I-WATER']!.quantity == 200000 &&
        unauthorized.state.items['I-FUEL']!.quantity == 40000,
    'Từ chối quyền không được làm hao kho.',
  );

  final Simulation shortfall = _householdWorld(fuelQuantity: 299);
  shortfall.advanceTo(const SimTime(7 * 3600));
  _expect(
    shortfall.state.households['H01']!.mealShortfalls == 1,
    'Thiếu một thành phần phải ghi nhận thiếu bữa.',
  );
  _expect(
    shortfall.state.items['I-FOOD']!.quantity == 50000 &&
        shortfall.state.items['I-WATER']!.quantity == 200000 &&
        shortfall.state.items['I-FUEL']!.quantity == 299,
    'Giao dịch thiếu nhiên liệu phải thất bại nguyên tử.',
  );

  final Simulation month = _householdWorld();
  month.advanceTo(const SimTime(10 * gameSecondsPerDay));
  final Simulation restored = Simulation.fromSave(month.state.save());
  month.advanceTo(const SimTime(30 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(30 * gameSecondsPerDay));
  _expect(
    month.state.semanticHash() == restored.state.semanticHash(),
    'Lưu ngày 10 phải tiếp tục đúng cùng kết quả đến ngày 30.',
  );
  final HouseholdState completed = month.state.households['H01']!;
  _expect(completed.mealsCompleted == 90, 'Ba mươi ngày phải có đúng 90 bữa.');
  _expect(completed.foodConsumedGrams == 45000, 'Sai tổng thức ăn tháng.');
  _expect(completed.waterConsumedMl == 180000, 'Sai tổng nước tháng.');
  _expect(completed.fuelConsumedGrams == 27000, 'Sai tổng nhiên liệu tháng.');
  _expect(
    month.state.items['I-FOOD']!.quantity == 5000,
    'Kho thức ăn không khớp.',
  );
  _expect(
    month.state.items['I-WATER']!.quantity == 20000,
    'Kho nước không khớp.',
  );
  _expect(
    month.state.items['I-FUEL']!.quantity == 13000,
    'Kho nhiên liệu không khớp.',
  );

  final Simulation care = _householdWorld(withInfant: true);
  final SimulationHost host = SimulationHost(care);
  _expect(
    host
        .submit(
          const InfantIntentCommand(
            id: 'v2-care',
            personId: 'P00',
            intent: InfantIntent.cryForCare,
          ),
        )
        .accepted,
    'Lệnh gọi chăm sóc phải được nhận.',
  );
  care.advanceTo(const SimTime(66));
  _expect(
    care.state.households['H01']!.totalCareInterruptionSecondsByPerson['N01'] ==
        65,
    'Hộ phải ghi đúng 65 giây công việc bị ngắt.',
  );
  care.advanceTo(const SimTime(22 * 3600));
  final HouseholdState careHousehold = care.state.households['H01']!;
  _expect(
    careHousehold.workCompletedSecondsByPerson['N01'] ==
        28800 - careHousehold.totalCareInterruptionSecondsByPerson['N01']!,
    'Sổ lao động phải trừ thời gian chăm trẻ khỏi 8 giờ dự kiến.',
  );

  print('V2.0 household verification passed.');
  print('Month hash: ${month.state.semanticHash()}');
  print('Care hash: ${care.state.semanticHash()}');
}

Simulation _householdWorld({
  String mealActorId = 'N02',
  int fuelQuantity = 40000,
  bool withInfant = false,
}) {
  final Simulation simulation = Simulation.fromSeed(20260907);
  for (final (String, String, String) person in <(String, String, String)>[
    ('N01', 'Người chăm sóc', 'may vá'),
    ('N02', 'Người nấu ăn', 'chuẩn bị bữa ăn'),
    ('N03', 'Người kiếm củi', 'kiếm củi'),
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': person.$1,
        'name': person.$2,
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': person.$1 == 'N01' ? 5000 : 0,
        'household_id': 'H01',
        'caregiver_agent': person.$1 == 'N01',
        'current_activity': person.$3,
      },
    );
  }
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: withInfant ? 'birth' : 'person_created',
    payload: <String, Object?>{
      'person_id': 'P00',
      'name': 'Vô Danh',
      if (withInfant) ...<String, Object?>{
        'infant': true,
        'caregiver_id': 'N01',
      } else
        'birth_seconds': 0,
      'position_mm': 0,
      'household_id': 'H01',
    },
  );
  final List<Map<String, Object?>> items = <Map<String, Object?>>[
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
      'quantity': fuelQuantity,
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
  ];
  for (final Map<String, Object?> item in items) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
        'position_mm': 0,
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
      'meal_actor_id': mealActorId,
    },
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
