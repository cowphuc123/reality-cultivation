import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  final Simulation w = _world();
  w.advanceTo(const SimTime(6 * gameSecondsPerDay));
  int dropped = 0;
  int deferred = 0;
  for (final WorldFact f in w.state.facts) {
    if (f.kind == 'routine_block_dropped') dropped++;
    if (f.kind == 'routine_block_deferred') deferred++;
  }
  print('v23: dropped=$dropped deferred=$deferred');
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

