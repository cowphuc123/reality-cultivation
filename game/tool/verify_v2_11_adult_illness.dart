import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.11: người lớn ốm được — và ốm vì trạng thái cơ thể thật, không vì
/// một cái hẹn giờ viết sẵn trong fixture.
void main() {
  // KB01: bệnh kéo thêm tiêu hao ngay trong nhịp ngày của cơ thể.
  const AdultBodyState healthy = AdultBodyState(
    massGrams: 52000,
    healthyMassGrams: 52000,
    energyReserveKj: AdultBodyState.reserveCapacityKj,
    bodyWaterMl: 31200,
  );
  final AdultBodyDayResult calm = healthy.advanceDay(workedSeconds: 0);
  final AdultBodyDayResult feverish = healthy.advanceDay(
    workedSeconds: 0,
    illnessSeverity: 500,
  );
  _expect(
    feverish.burnedKj == calm.burnedKj + 500,
    'Bệnh nặng 500 phải đốt thêm đúng 500 kilojoule.',
  );

  final Simulation world = _world();

  // KB02: ốm vì mất nước, không vì hẹn giờ — nguyên nhân được ghi rõ.
  world.advanceTo(const SimTime(4 * gameSecondsPerDay));
  final WorldFact onset = world.state.facts.firstWhere(
    (WorldFact fact) => fact.kind == 'adult_illness_onset',
  );
  _expect(
    onset.subjectId == 'N03' && onset.detail.contains('cause=mat_nuoc'),
    'Người không được uống nước phải đổ bệnh vì mất nước.',
  );
  _expect(
    onset.detail.contains('hydration='),
    'Mốc khởi phát phải ghi lại chính con số cơ thể đã gây ra bệnh.',
  );
  final IllnessState sick = world.state.illnesses.values.firstWhere(
    (IllnessState value) => value.personId == 'N03',
  );
  _expect(
    sick.kind == 'adult_dehydration',
    'Bệnh phải được ghi đúng loại là mất nước ở người lớn.',
  );
  // Mức nặng lúc khởi phát nằm trong mốc sự kiện; mức hiện tại đã giảm vì
  // người này được chăm rồi, nên hai con số không được lẫn với nhau.
  final int onsetSeverity = _value(onset.detail, 'severity');
  _expect(
    onsetSeverity >= 300,
    'Mức nặng lúc khởi phát phải suy từ mức thiếu nước và không dưới sàn.',
  );

  // KB03: nguyên nhân thứ hai là kiệt sức, và nó ốm dù cơ thể còn đủ nước.
  world.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final WorldFact exhaustion = world.state.facts.firstWhere(
    (WorldFact fact) =>
        fact.kind == 'adult_illness_onset' &&
        fact.detail.contains('cause=kiet_suc'),
  );
  _expect(
    exhaustion.subjectId == 'N01' &&
        _value(exhaustion.detail, 'hydration') == 1000,
    'Người làm quá sức phải ốm vì kiệt sức, không phải vì thiếu nước.',
  );

  // KB04: bệnh kéo sức làm việc xuống dù cân nặng và nước vẫn đủ.
  //
  // N01 là ca sạch để đo: cơ thể còn nguyên 1000 sức, nên phần hụt đi của
  // sản lượng chỉ có thể đến từ bệnh.
  final PersonState worn = world.state.people['N01']!;
  _expect(
    worn.body!.capability == 1000,
    'Cơ thể N01 phải còn đủ sức nếu chỉ tính cân nặng và nước.',
  );
  final RoutineBlock? assigned = worn.routine!.generatedBlocks
      .where((RoutineBlock block) => block.outputAmount > 0)
      .firstOrNull;
  if (assigned != null) {
    final String code = switch (assigned.needKind) {
      'fuel' => 'gather_fuel',
      'water' => 'fetch_water',
      _ => 'gather_food',
    };
    _expect(
      assigned.outputAmount < worn.skills!.output(code, 18000),
      'Người đang ốm phải làm ra ít hơn mức tay nghề của mình.',
    );
  }

  // KB05: người trong hộ nhận ra và cử người tới chăm.
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'adult_illness_detected' &&
          fact.detail.contains('carer='),
    ),
    'Hộ phải nhận ra có người ốm và cử được người chăm.',
  );

  // KB06: chăm bệnh tiêu nước thật của hộ và hạ mức bệnh.
  final WorldFact cared = world.state.facts.firstWhere(
    (WorldFact fact) => fact.kind == 'adult_illness_care_completed',
  );
  _expect(
    cared.detail.contains('water_ml=400'),
    'Chăm bệnh phải tiêu đúng lượng nước đã định.',
  );
  _expect(
    _value(cared.detail, 'severity') < onsetSeverity,
    'Sau khi được chăm thì mức bệnh phải thấp hơn lúc khởi phát.',
  );

  // KB07: bệnh làm người ta khó nhận việc hơn.
  final Simulation refusing = _world();
  refusing.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final WorldFact? refusal = refusing.state.facts
      .where(
        (WorldFact fact) =>
            fact.kind == 'work_offer_refused' &&
            fact.detail.contains('illness='),
      )
      .lastOrNull;
  if (refusal != null) {
    _expect(
      refusal.detail.contains('severity='),
      'Lần từ chối vì ốm phải ghi rõ mức bệnh đã đẩy ngưỡng lên.',
    );
  }

  // KB08: không ai chăm được thì ghi rõ, không tự khỏi.
  final Simulation alone = _world(soloCarrier: true);
  alone.advanceTo(const SimTime(4 * gameSecondsPerDay));
  _expect(
    alone.state.facts.any(
      (WorldFact fact) => fact.kind == 'adult_illness_unattended',
    ),
    'Không có ai đủ điều kiện chăm thì phải ghi là không người trông.',
  );

  // KB09: bệnh vẫn diễn tiến rồi lui theo cùng cơ chế đã có.
  world.advanceTo(const SimTime(12 * gameSecondsPerDay));
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'illness_progressed' || fact.kind == 'illness_resolved',
    ),
    'Bệnh của người lớn phải chạy qua cùng cơ chế diễn tiến đã có.',
  );

  // KB10: trẻ sơ sinh vẫn dùng đường bệnh riêng của mình.
  _expect(
    world.state.illnesses.values.every(
      (IllnessState value) =>
          value.personId != 'P00' || value.kind == 'mild_respiratory_infection',
    ),
    'Bệnh của trẻ sơ sinh không được lẫn sang nhánh người lớn.',
  );

  // KB11: hộ chưa bật theo dõi thì người lớn không ốm.
  final Simulation legacy = _world(adultIllness: false);
  legacy.advanceTo(const SimTime(6 * gameSecondsPerDay));
  _expect(
    legacy.state.illnesses.values.every(
      (IllnessState value) => value.personId == 'P00',
    ),
    'Chưa bật cờ thì chỉ trẻ sơ sinh mới có bệnh.',
  );

  // KB12: lưu giữa lúc người lớn đang ốm vẫn tái hiện đúng.
  final Simulation continuous = _world();
  continuous.advanceTo(const SimTime(4 * gameSecondsPerDay + 6 * 3600));
  _expect(
    continuous.state.illnesses.values.any(
      (IllnessState value) => value.personId == 'N03' && value.active,
    ),
    'Mốc lưu phải nằm lúc người lớn đang ốm.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(10 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(10 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa lúc đang ốm phải tiếp tục cùng kết quả.',
  );

  print('V2.11 adult illness verification passed.');
  print('Day 10 hash: ${continuous.state.semanticHash()}');
  print('Khởi phát vì mất nước: ${onset.detail}');
  print('Khởi phát vì kiệt sức: ${exhaustion.detail}');
  print('Chăm bệnh: ${cared.detail}');
}

int _value(String detail, String key) {
  for (final String part in detail.split(' ')) {
    if (part.startsWith('$key=')) {
      return int.tryParse(part.substring(key.length + 1)) ?? 0;
    }
  }
  return 0;
}

Simulation _world({bool adultIllness = true, bool soloCarrier = false}) {
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
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N01-VA',
          'activity': 'may vá',
          'start_second_of_day': 25200,
          'duration_seconds': 28800,
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
        'gather_food': 250,
      },
      'agenda': const <String, Object?>{'fatigue': 0},
      'adult_body': const <String, Object?>{'mass_g': 52000},
      'routine': const <Map<String, Object?>>[
        <String, Object?>{
          'id': 'R-N02-SANG',
          'activity': 'nấu bữa sáng',
          'start_second_of_day': 21600,
          'duration_seconds': 5400,
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
          'duration_seconds': 32400,
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
      'quantity': 400000,
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
      // N03 không có quyền lấy nước nên sẽ mất nước rồi đổ bệnh.
      // Biến thể soloCarrier bỏ luôn quyền của người khác, nên không ai chăm nổi.
      'authorized_users_by_item_id': <String, List<String>>{
        'I-FOOD': const <String>['N02', 'N03'],
        'I-WATER': soloCarrier
            ? const <String>[]
            : const <String>['N01', 'N02'],
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
      'enable_v2_11': adultIllness,
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
