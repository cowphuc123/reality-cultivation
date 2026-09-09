import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.13: ca cố định của người nghỉ bệnh được chào cho người cùng hộ.
void main() {
  final Simulation world = _world(enableV213: true);
  world.advanceTo(const SimTime(2 * gameSecondsPerDay));

  final List<WorldFact> transfers = world.state.facts
      .where(
        (WorldFact fact) =>
            fact.kind == 'routine_block_reassigned' &&
            fact.detail.contains('block=R-N01-FUEL'),
      )
      .toList();
  _expect(transfers.length == 1, 'Ca gom củi phải được chuyển đúng một lần.');
  _expect(
    transfers.single.subjectId == 'N01' &&
        transfers.single.detail.contains('substitute=N03'),
    'Ca của N01 phải sang N03 sau khi N02 từ chối.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'work_substitution_refused' && fact.subjectId == 'N02',
    ),
    'Người quá mệt phải được quyền từ chối ca gánh thay.',
  );
  _expect(
    !transfers.single.detail.contains('substitute=N04'),
    'Người chưa đủ tay nghề không được nhận ca.',
  );

  final RoutineBlock cover = world.state.people['N03']!.routine!.blocks
      .singleWhere(
        (RoutineBlock block) => block.id.startsWith('COVER-R-N01-FUEL'),
      );
  _expect(
    cover.durationSeconds == 10800 &&
        cover.roomId == 'ROOM-YARD' &&
        cover.priority == 70 &&
        cover.outputAmount == 1200 &&
        cover.requiredSkill == 'gather_fuel',
    'Ca gánh thay phải giữ nguyên thời lượng, nơi, ưu tiên, sản lượng và nghề.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'routine_block_started' &&
          fact.subjectId == 'N03' &&
          fact.detail.contains('block=${cover.id}'),
    ),
    'Người nhận phải thật sự bắt đầu ca gánh thay.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'routine_work_delivered' &&
          fact.subjectId == 'N03' &&
          fact.detail.contains('block=${cover.id}') &&
          fact.detail.contains('amount=1200'),
    ),
    'Ca gánh thay hoàn tất phải giao đủ sản lượng vào kho thật.',
  );
  _expect(
    world.state.people['N01']!.routine!.conflicts.any(
      (ScheduleConflict conflict) =>
          conflict.blockId == 'R-N01-FUEL' &&
          conflict.competingActivity.contains('đã chuyển cho N03'),
    ),
    'Sổ lịch của người bệnh phải ghi rõ người nhận thay.',
  );

  final Simulation disabled = _world(enableV213: false);
  disabled.advanceTo(const SimTime(2 * gameSecondsPerDay));
  _expect(
    !disabled.state.facts.any(
      (WorldFact fact) => fact.kind == 'routine_block_reassigned',
    ),
    'Tắt cờ V2.13 phải giữ hành vi cũ.',
  );

  final Simulation unavailable = _world(
    enableV213: true,
    eligibleSubstitute: false,
  );
  unavailable.advanceTo(const SimTime(2 * gameSecondsPerDay));
  _expect(
    unavailable.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'routine_block_reassignment_failed' &&
          fact.detail.contains('block=R-N01-FUEL'),
    ),
    'Không còn ai đủ điều kiện phải ghi lần chuyển ca thất bại.',
  );

  final Simulation continuous = _world(enableV213: true);
  continuous.advanceTo(const SimTime(gameSecondsPerDay + 9 * 3600));
  _expect(
    continuous.state.people['N03']!.routine!.activeBlockId?.startsWith(
          'COVER-',
        ) ==
        true,
    'Mốc lưu phải nằm giữa ca gánh thay.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(3 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(3 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa ca gánh thay phải tiếp tục cùng kết quả.',
  );

  print('V2.13 work substitution verification passed.');
  print('Day 3 hash: ${continuous.state.semanticHash()}');
  print('Transfer: ${transfers.single.detail}');
}

Simulation _world({required bool enableV213, bool eligibleSubstitute = true}) {
  final Simulation simulation = Simulation.fromSeed(20260909);
  for (final (String, String, int) room in <(String, String, int)>[
    ('ROOM-HOME', 'Nhà chính', 0),
    ('ROOM-YARD', 'Sân củi', 8000),
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
      'name': 'Người đang kiệt sức',
      'position_mm': 8000,
      'room_id': 'ROOM-YARD',
      'household_id': 'H01',
      'skills': const <String, int>{'gather_fuel': 800},
      'agenda': const <String, Object?>{'fatigue': 800},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N01-LONG',
          'activity': 'lao động nặng',
          'start_second_of_day': 21600,
          'duration_seconds': 43200,
          'room_id': 'ROOM-YARD',
          'priority': 20,
        },
        <String, Object?>{
          'id': 'R-N01-FUEL',
          'activity': 'gom củi',
          'start_second_of_day': 25200,
          'duration_seconds': 10800,
          'room_id': 'ROOM-YARD',
          'priority': 70,
          'need_kind': 'fuel',
          'required_skill': 'gather_fuel',
          'output_resource': 'fuel',
          'output_amount': 1200,
        },
      ],
    },
    <String, Object?>{
      'person_id': 'N02',
      'name': 'Người giỏi nhưng quá mệt',
      'position_mm': 0,
      'room_id': 'ROOM-HOME',
      'household_id': 'H01',
      'skills': const <String, int>{'gather_fuel': 900},
      'agenda': const <String, Object?>{'fatigue': 850, 'night_recovery': 0},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[],
    },
    <String, Object?>{
      'person_id': 'N03',
      'name': 'Người nhận thay',
      'position_mm': 8000,
      'room_id': 'ROOM-YARD',
      'household_id': 'H01',
      'skills': <String, int>{'gather_fuel': eligibleSubstitute ? 700 : 100},
      'agenda': const <String, Object?>{'fatigue': 0},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N03-NOON',
          'activity': 'sửa mái',
          'start_second_of_day': 43200,
          'duration_seconds': 7200,
          'room_id': 'ROOM-YARD',
          'priority': 80,
        },
      ],
    },
    <String, Object?>{
      'person_id': 'N04',
      'name': 'Người chưa biết nghề',
      'position_mm': 0,
      'room_id': 'ROOM-HOME',
      'household_id': 'H01',
      'skills': const <String, int>{'gather_fuel': 100},
      'agenda': const <String, Object?>{'fatigue': 0},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[],
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
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-FOOD',
      'kind': 'staple_food',
      'quantity': 100000,
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
      'quantity': 50000,
      'unit': 'g',
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
        'position_mm': 0,
        'room_id': 'ROOM-HOME',
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
      'name': 'Hộ thử chuyển ca',
      'member_ids': const <String>['N01', 'N02', 'N03', 'N04'],
      'resource_item_ids': const <String, String>{
        'food': 'I-FOOD',
        'water': 'I-WATER',
        'fuel': 'I-FUEL',
      },
      'authorized_users_by_item_id': const <String, List<String>>{
        'I-FOOD': <String>['N01', 'N02', 'N03', 'N04'],
        'I-WATER': <String>['N01', 'N02', 'N03', 'N04'],
        'I-FUEL': <String>['N01', 'N02', 'N03', 'N04'],
      },
      'scheduled_work_seconds_by_person': const <String, int>{
        'N01': 10800,
        'N02': 0,
        'N03': 7200,
        'N04': 0,
      },
      'meal_actor_id': 'N02',
      'enable_v2_6': true,
      'enable_v2_11': true,
      'enable_v2_13': enableV213,
    },
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
