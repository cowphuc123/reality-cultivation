import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.8: nước của người lớn có hậu quả — uống lấy từ kho hộ, thiếu quyền hoặc
/// cạn kho thì khát, và khát ăn vào sức làm việc nhanh hơn cả sụt cân.
void main() {
  // KN01: quy tắc đủ nước và sức làm việc là số, không phải nhãn.
  const AdultBodyState full = AdultBodyState(
    massGrams: 52000,
    healthyMassGrams: 52000,
    energyReserveKj: AdultBodyState.reserveCapacityKj,
    bodyWaterMl: 31200,
  );
  final AdultBodyState dry = AdultBodyState(
    massGrams: 52000,
    healthyMassGrams: 52000,
    energyReserveKj: AdultBodyState.reserveCapacityKj,
    bodyWaterMl: 31200 * 90 ~/ 100,
  );
  _expect(
    full.hydration == 1000 && full.waterCapability == 1000,
    'Đủ nước thì sức làm việc theo nước phải đầy.',
  );
  _expect(
    dry.hydration == 900 && dry.waterCapability == 500,
    'Mất một phần mười lượng nước thì sức làm việc chỉ còn một nửa.',
  );
  _expect(
    dry.dehydrated && dry.thirst == 100,
    'Dưới mức chín phần mười phải được ghi là thiếu nước.',
  );

  // KN02: thiếu nước ăn vào sức làm việc nhanh hơn sụt cân.
  final AdultBodyState thinButWatered = AdultBodyState(
    massGrams: 49400,
    healthyMassGrams: 52000,
    energyReserveKj: 0,
    bodyWaterMl: 49400 * 60 ~/ 100,
  );
  _expect(
    thinButWatered.massCapability < 1000 &&
        thinButWatered.capability == thinButWatered.massCapability,
    'Đủ nước nhưng sụt cân thì cân nặng là thứ quyết định.',
  );
  _expect(
    dry.capability == dry.waterCapability &&
        dry.waterCapability < dry.massCapability,
    'Đủ cân nhưng thiếu nước thì nước là thứ quyết định.',
  );

  final Simulation world = _world();

  // KN03: người lớn uống nước thật lấy từ kho hộ.
  // Đo ngay quanh mốc chốt ngày 22:00, vì trong ngày kế hoạch còn cử người
  // đi gánh nước về nên kho có thể tăng.
  world.advanceTo(const SimTime(21 * 3600));
  final int storeBeforeSettlement = world.state.items['I-WATER']!.quantity;
  world.advanceTo(const SimTime(23 * 3600));
  _expect(
    world.state.people['N01']!.body!.totalDrunkMl > 0,
    'Hết ngày thì người lớn phải đã uống nước.',
  );
  _expect(
    world.state.facts.any((WorldFact fact) => fact.kind == 'body_drank'),
    'Lần uống nước phải được ghi lại.',
  );
  _expect(
    world.state.items['I-WATER']!.quantity < storeBeforeSettlement,
    'Nước uống phải bị trừ khỏi kho của hộ.',
  );

  // KN04: nhu cầu nước của hộ nay tính cả phần người uống.
  final HouseholdNeed water = world
      .householdNeeds('H01')
      .firstWhere((HouseholdNeed need) => need.kind == 'water');
  _expect(
    water.dailyUse > 6000,
    'Nhịp dùng nước phải cộng thêm phần ba người lớn uống mỗi ngày.',
  );

  // KN05: không có quyền dùng kho thì không uống được và phải chịu khát.
  final Simulation barred = _world(waterRights: const <String>['N01', 'N02']);
  barred.advanceTo(const SimTime(3 * gameSecondsPerDay));
  final AdultBodyState outsider = barred.state.people['N03']!.body!;
  _expect(
    outsider.totalDrunkMl == 0,
    'Không có quyền dùng kho nước thì không uống được giọt nào.',
  );
  _expect(
    outsider.dehydrated && outsider.thirst > 0,
    'Không uống được thì phải thiếu nước thật.',
  );
  _expect(
    barred.state.people['N01']!.body!.totalDrunkMl > 0,
    'Người có quyền vẫn uống bình thường.',
  );

  // KN06: khát đẩy ngưỡng nhận việc lên và thành nguyên nhân chính.
  final PersonAgenda parched = barred.state.people['N03']!.agenda!;
  _expect(
    parched.thirst > 0 && parched.acceptanceFloor >= parched.thirst ~/ 15,
    'Cơn khát phải góp vào ngưỡng nhận việc.',
  );
  _expect(
    parched.thirst ~/ 15 >= 20,
    'Cơn khát phải đóng góp đáng kể chứ không chỉ là nhãn.',
  );
  // So thẳng với ngưỡng khi chưa tính khát để thấy phần khát cộng thêm.
  _expect(
    parched.acceptanceFloor >
        parched.fatigue ~/ 10 +
            parched.hunger ~/ 20 +
            (1000 - parched.mood) ~/ 25,
    'Ngưỡng nhận việc phải cao hơn hẳn mức khi chưa tính khát.',
  );

  // KN07: thiếu nước kéo sức làm việc và sản lượng dự kiến xuống.
  _expect(
    outsider.capability < 1000 &&
        outsider.capability == outsider.waterCapability,
    'Sức làm việc phải bị chính cơn khát chặn lại.',
  );
  _expect(
    barred.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'body_dehydrated' && fact.subjectId == 'N03',
    ),
    'Lần thiếu nước phải được ghi thành sự kiện đọc được.',
  );

  // KN08: kho cạn thì ai cũng khát, không riêng người thiếu quyền.
  final Simulation dryWell = _world(waterStock: 9000, noWaterCarrier: true);
  dryWell.advanceTo(const SimTime(4 * gameSecondsPerDay));
  _expect(
    dryWell.state.items['I-WATER']!.quantity == 0,
    'Kho nước phải cạn thật trong lượt chạy này.',
  );
  _expect(
    dryWell.state.people.values.where(
      (PersonState person) => person.body?.dehydrated ?? false,
    ).length >= 2,
    'Kho cạn thì nhiều người cùng thiếu nước.',
  );

  // KN09: thế giới không có cơ thể thì không ai uống, kho không đổi vì uống.
  final Simulation legacy = _world(bodies: false);
  legacy.advanceTo(const SimTime(2 * gameSecondsPerDay));
  _expect(
    legacy.state.facts.every((WorldFact fact) => fact.kind != 'body_drank'),
    'Không có cơ thể thì không có chuyện uống nước.',
  );

  // KN10: lưu giữa lúc đang khát vẫn tái hiện đúng.
  final Simulation continuous = _world(
    waterRights: const <String>['N01', 'N02'],
  );
  continuous.advanceTo(const SimTime(2 * gameSecondsPerDay + 12 * 3600));
  _expect(
    continuous.state.people['N03']!.body!.dehydrated,
    'Mốc lưu phải nằm lúc đã có người thiếu nước.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(5 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(5 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa lúc đang khát phải tiếp tục cùng kết quả.',
  );

  print('V2.8 water and thirst verification passed.');
  print('Day 5 hash: ${continuous.state.semanticHash()}');
  print(
    'Người không có quyền dùng kho nước sau ba ngày: '
    'đủ nước ${outsider.hydration}/1000, khát ${outsider.thirst}, '
    'sức làm việc ${outsider.capability}/1000, ngưỡng nhận việc '
    '${parched.acceptanceFloor} (nặng nhất là ${parched.mainStrain}).',
  );
  final AdultBodyState served = world.state.people['N01']!.body!;
  print(
    'Người uống đủ: đã uống ${served.totalDrunkMl} ml, '
    'đủ nước ${served.hydration}/1000, sức làm việc ${served.capability}/1000.',
  );
  print('Nhịp dùng nước của hộ: ${water.dailyUse} ml mỗi ngày.');
}

Simulation _world({
  bool bodies = true,
  int waterStock = 48000,
  bool noWaterCarrier = false,
  List<String> waterRights = const <String>['N01', 'N02', 'N03'],
}) {
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
  final Map<String, Object?>? body = bodies
      ? const <String, Object?>{'mass_g': 52000}
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
      'skills': <String, int>{
        'fetch_water': noWaterCarrier ? 100 : 700,
        'gather_food': 300,
      },
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
        'fetch_water': noWaterCarrier ? 100 : 400,
        'gather_food': 250,
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
        'gather_food': 700,
        // Nhà cạn nước: không ai đủ nghề đi gánh nên kho không đầy lại.
        'fetch_water': noWaterCarrier ? 100 : 600,
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
      'quantity': 30000,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-WATER',
      'kind': 'clean_water',
      'quantity': waterStock,
      'unit': 'ml',
    },
    <String, Object?>{
      'item_id': 'I-FUEL',
      'kind': 'firewood',
      'quantity': 12000,
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
        'I-WATER': waterRights,
        'I-FUEL': const <String>['N02', 'N03'],
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
