import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  final Simulation simulation = _newInfantWorld(withCaregiver: true);
  final SimulationHost host = SimulationHost(simulation);
  final PersonView newborn = host.person('P00')!;
  _expect(newborn.ageSeconds == 0, 'Nhân vật phải bắt đầu đúng lúc sinh.');
  _expect(newborn.infancy != null, 'Trạng thái sơ sinh phải tồn tại.');
  _expect(
    !newborn.infancy!.allowedIntents.contains(InfantIntent.reach),
    'Ngày 0 chưa được vươn tay có chủ đích.',
  );

  final CommandResult rejectedGoal = host.submit(
    const SetGoalCommand(
      id: 'adult-goal-too-early',
      personId: 'P00',
      goal: 'Tu luyện công pháp',
    ),
  );
  _expect(!rejectedGoal.accepted, 'Mục tiêu người lớn phải bị từ chối.');
  final CommandResult acceptedIntent = host.submit(
    const InfantIntentCommand(
      id: 'listen-0',
      personId: 'P00',
      intent: InfantIntent.attendVoice,
    ),
  );
  _expect(acceptedIntent.accepted, 'Ý định phù hợp tuổi phải được nhận.');
  _expect(
    !host
        .submit(
          const InfantIntentCommand(
            id: 'reach-too-early',
            personId: 'P00',
            intent: InfantIntent.reach,
          ),
        )
        .accepted,
    'Ý định chưa mở theo tuổi phải bị từ chối.',
  );

  simulation.advanceTo(const SimTime(10 * gameSecondsPerDay));
  final InfantView day10 = host.person('P00')!.infancy!;
  _expect(
    day10.careInteractions > 0,
    'Người chăm sóc phải phản ứng khi trẻ khóc.',
  );
  _expect(
    day10.unmetCareEpisodes == 0,
    'Có người chăm sóc thì không tích ngày bỏ mặc.',
  );
  _expect(
    simulation.state.facts.any((WorldFact fact) => fact.kind == 'infant_cry'),
    'Phải có sự kiện tiếng khóc.',
  );
  _expect(
    simulation.state.facts.any(
      (WorldFact fact) => fact.kind == 'caregiver_care',
    ),
    'Phải có sự kiện chăm sóc.',
  );

  final String checkpoint = simulation.state.save();
  final Simulation restored = Simulation.fromSave(checkpoint);
  simulation.advanceTo(const SimTime(30 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(30 * gameSecondsPerDay));
  _expect(
    restored.state.semanticHash() == simulation.state.semanticHash(),
    'Lưu rồi khôi phục phải cho cùng kết quả đến ngày 30.',
  );
  final InfantView day30 = SimulationHost(restored).person('P00')!.infancy!;
  _expect(
    day30.allowedIntents.contains(InfantIntent.reach),
    'Vươn tay phải mở ở nửa sau tháng đầu.',
  );
  _expect(
    day30.visionRangeMm > newborn.infancy!.visionRangeMm,
    'Khả năng thị giác phải phát triển theo tuổi.',
  );

  final Simulation unattended = _newInfantWorld(withCaregiver: false);
  unattended.advanceTo(const SimTime(5 * gameSecondsPerDay));
  final InfantView neglected = SimulationHost(
    unattended,
  ).person('P00')!.infancy!;
  _expect(neglected.careInteractions == 0, 'Không được tạo chăm sóc giả.');
  _expect(
    neglected.unmetCareEpisodes > 0,
    'Thiếu chăm sóc phải được ghi nhận.',
  );

  print('V1 infancy verification passed.');
  print('Day 30 semantic hash: ${restored.state.semanticHash()}');
  print('Care interactions: ${day30.careInteractions}');
  print(
    'Body: mass=${day30.massGrams}g energy=${day30.energyReserveKj}kJ '
    'water=${day30.bodyWaterMl}ml temp=${day30.bodyTemperatureMilliC}mC',
  );
  print(
    'Needs: hunger=${day30.hunger} thirst=${day30.thirst} '
    'sleep=${day30.sleepPressure} thermal=${day30.thermalStress}',
  );
  print('Feed remaining: ${day30.feedRemaining}ml');
}

Simulation _newInfantWorld({required bool withCaregiver}) {
  final Simulation simulation = Simulation.fromSeed(20260907);
  if (withCaregiver) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: const <String, Object?>{
        'person_id': 'N01',
        'name': 'Người chăm sóc',
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': 5000,
        'caregiver_agent': true,
        'hearing_threshold': 300,
        'movement_speed_mm_per_second': 1000,
        'current_activity': 'prepare_meal',
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
    },
  );
  if (withCaregiver) {
    simulation
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: const <String, Object?>{
          'item_id': 'I-FEED-01',
          'kind': 'infant_feed',
          'position_mm': 0,
          'quantity': 10000,
          'energy_kj_per_100ml': 300,
          'water_ml_per_100ml': 92,
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: const <String, Object?>{
          'item_id': 'I-CLOTH-01',
          'kind': 'swaddling_cloth',
          'position_mm': 0,
          'quantity': 1,
          'condition': 1000,
        },
      );
  }
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
