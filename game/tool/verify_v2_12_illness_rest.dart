import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.12: người ốm được nghỉ thật.
///
/// Nghỉ cho tới khi khỏi, không theo một mức nặng tuỳ ý — vì một lượt chăm hạ
/// mức nặng ngay trong nửa giờ, nên lấy mức nặng làm ngưỡng thì người ta lại
/// đi làm hôm sau và ốm lại.
void main() {
  final Simulation world = _world();
  world.advanceTo(const SimTime(8 * gameSecondsPerDay));

  // KN01: đang ốm thì khối việc bị lùi rồi bỏ, chứ không cứ thế chạy.
  final List<WorldFact> restDeferrals = world.state.facts
      .where(
        (WorldFact fact) =>
            fact.kind == 'routine_block_deferred' &&
            fact.detail.contains('competing=nghỉ vì ốm'),
      )
      .toList();
  _expect(
    restDeferrals.isNotEmpty,
    'Người đang ốm phải bị lùi khối việc với lý do nghỉ vì ốm.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'routine_block_dropped' &&
          fact.detail.contains('competing=nghỉ vì ốm'),
    ),
    'Hết lượt lùi mà vẫn ốm thì khối việc phải mất hẳn trong ngày.',
  );

  // KN02: nghỉ tới khi khỏi, kể cả lúc mức nặng đã rất thấp.
  final List<int> restSeverities = restDeferrals
      .map((WorldFact fact) => _severityFromReason(fact.detail))
      .where((int value) => value > 0)
      .toList();
  _expect(
    restSeverities.isNotEmpty,
    'Lý do nghỉ phải kèm mức nặng để đọc được.',
  );
  final int lowestRestSeverity = restSeverities.reduce(
    (int a, int b) => a < b ? a : b,
  );
  _expect(
    lowestRestSeverity > 0 && lowestRestSeverity < 300,
    'Vẫn phải nghỉ khi mức nặng đã tụt sâu, miễn là chưa khỏi hẳn.',
  );

  // KN03: kỳ nghỉ được ghi thành xung đột lịch, có tên việc bị bỏ.
  //
  // Bệnh khởi phát lúc chốt ngày 22:00, khi khối việc trong ngày đã xong,
  // nên kỳ nghỉ chặn từ khối đầu tiên của hôm sau chứ không cắt giữa buổi.
  _expect(
    world.state.people['N01']!.routine!.conflicts.any(
      (ScheduleConflict value) =>
          value.competingActivity.startsWith('nghỉ vì ốm') &&
          value.plannedActivity == 'may vá',
    ),
    'Kỳ nghỉ vì ốm phải được ghi thành xung đột lịch với tên việc bị bỏ.',
  );

  // KN04: khỏi hẳn thì được trả về việc, và có mốc ghi lại.
  _expect(
    world.state.facts.any(
      (WorldFact fact) => fact.kind == 'illness_rest_ended',
    ),
    'Khỏi bệnh phải có mốc kết thúc kỳ nghỉ.',
  );

  // KN05: nghỉ thì thật sự không làm, nên cơ thể chỉ đốt mức nền.
  final Simulation resting = _world();
  resting.advanceTo(const SimTime(gameSecondsPerDay + 20 * 3600));
  final PersonState sickDay = resting.state.people['N02']!;
  _expect(
    _activeFor(resting, 'N02') != null,
    'Mốc đo phải nằm trong ngày N02 còn đang ốm.',
  );
  _expect(
    sickDay.agenda!.workedSecondsToday == 0,
    'Ngày nghỉ vì ốm thì sổ giờ lao động phải bằng không.',
  );

  // KN06: nghỉ làm mệt mỏi giảm thật, không chỉ là nhãn.
  final int beforeRest = _world().state.people['N02']!.agenda!.fatigue;
  world.advanceTo(const SimTime(12 * gameSecondsPerDay));
  _expect(
    world.state.people['N02']!.agenda!.fatigue < beforeRest,
    'Sau kỳ nghỉ thì mệt mỏi phải thấp hơn lúc bắt đầu.',
  );

  // KN07: hai lịch khác nhau cho hai kết cục khác nhau.
  //
  // N01 làm hơn mười tiếng mỗi ngày; nghỉ giúp giãn vòng ốm nhưng không cứu
  // được, vì lịch đó vốn không bền. N02 làm sáu tiếng nên khỏi rồi là yên.
  final int overworkedOnsets = _onsetCount(world, 'N01');
  final int moderateOnsets = _onsetCount(world, 'N02');
  _expect(
    overworkedOnsets >= 2,
    'Người làm quá sức vẫn phải ốm lại dù đã được nghỉ.',
  );
  _expect(
    moderateOnsets < overworkedOnsets,
    'Người làm vừa phải phải ốm ít lần hơn người làm quá sức.',
  );

  // KN08: nghỉ có giá — số giờ công mất đi được ghi lại đầy đủ.
  _expect(
    world.state.people['N01']!.routine!.lostSeconds > 0 &&
        world.state.people['N01']!.routine!.droppedBlocks > 0,
    'Kỳ nghỉ phải để lại dấu trong sổ giờ mất và số khối bỏ hẳn.',
  );

  // KN09: hộ vẫn lo được việc nhờ giao cho người khác.
  _expect(
    world.state.facts.any(
      (WorldFact fact) => fact.kind == 'household_plan_made',
    ),
    'Hộ vẫn lập kế hoạch mỗi ngày dù có người đang nghỉ bệnh.',
  );

  // KN10: lưu giữa kỳ nghỉ vẫn tái hiện đúng.
  final Simulation continuous = _world();
  continuous.advanceTo(const SimTime(gameSecondsPerDay + 12 * 3600));
  _expect(
    _activeFor(continuous, 'N02') != null,
    'Mốc lưu phải nằm trong kỳ nghỉ bệnh.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(10 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(10 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa kỳ nghỉ bệnh phải tiếp tục cùng kết quả.',
  );

  print('V2.12 illness rest verification passed.');
  print('Day 10 hash: ${continuous.state.semanticHash()}');
  print(
    'N01 làm 10,3 giờ/ngày: ốm $overworkedOnsets lần, '
    'bỏ ${world.state.people['N01']!.routine!.droppedBlocks} khối, '
    'mất ${world.state.people['N01']!.routine!.lostSeconds} giây công, '
    'mệt cuối kỳ ${world.state.people['N01']!.agenda!.fatigue}.',
  );
  print(
    'N02 làm 6 giờ/ngày: ốm $moderateOnsets lần, '
    'mệt cuối kỳ ${world.state.people['N02']!.agenda!.fatigue}.',
  );
  print('Mức nặng thấp nhất mà vẫn còn nghỉ: $lowestRestSeverity/1000.');
}

IllnessState? _activeFor(Simulation world, String personId) => world
    .state
    .illnesses
    .values
    .where(
      (IllnessState value) => value.personId == personId && value.active,
    )
    .firstOrNull;

int _onsetCount(Simulation world, String personId) => world.state.facts
    .where(
      (WorldFact fact) =>
          fact.kind == 'adult_illness_onset' && fact.subjectId == personId,
    )
    .length;

/// Đọc mức nặng trong lý do "nghỉ vì ốm (167/1000)".
///
/// Có hai dạng lý do: lúc dừng việc giữa buổi thì chỉ ghi "nghỉ vì ốm", còn
/// lúc chặn khối mới thì kèm mức nặng. Dạng không có số trả về 0.
int _severityFromReason(String detail) {
  final int open = detail.indexOf('(');
  if (open < 0) return 0;
  final int slash = detail.indexOf('/', open);
  if (slash < 0) return 0;
  return int.tryParse(detail.substring(open + 1, slash)) ?? 0;
}

Simulation _world() {
  final Simulation simulation = Simulation.fromSeed(20260909);
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
    // N01 làm hơn mười tiếng mỗi ngày: lịch không bền.
    <String, Object?>{
      'person_id': 'N01',
      'name': 'Người may vá',
      'position_mm': 5000,
      'room_id': 'ROOM-KITCHEN',
      'household_id': 'H01',
      'caregiver_agent': true,
      'care_skill': 800,
      'current_activity': 'may vá',
      'skills': const <String, int>{'fetch_water': 700, 'gather_food': 300},
      'agenda': const <String, Object?>{'fatigue': 600},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N01-VA',
          'activity': 'may vá',
          'start_second_of_day': 25200,
          'duration_seconds': 37200,
          'room_id': 'ROOM-KITCHEN',
          'priority': 30,
        },
      ],
    },
    // N02 làm sáu tiếng, nhưng vào cuộc đã sẵn mệt nên ốm ngay ngày đầu.
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
        'gather_food': 250,
      },
      'agenda': const <String, Object?>{'fatigue': 880},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N02-NAU',
          'activity': 'nấu ăn cả buổi',
          'start_second_of_day': 25200,
          'duration_seconds': 21600,
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
      'agenda': const <String, Object?>{'fatigue': 0},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N03-MAI',
          'activity': 'sửa mái',
          'start_second_of_day': 21600,
          'duration_seconds': 18000,
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
      'quantity': 60000,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-WATER',
      'kind': 'clean_water',
      'quantity': 500000,
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
      'enable_v2_11': true,
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
