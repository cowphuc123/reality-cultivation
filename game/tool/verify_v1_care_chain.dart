import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  final Simulation simulation = _world();
  final SimulationHost host = SimulationHost(simulation);
  _expect(
    host
        .submit(
          const InfantIntentCommand(
            id: 'cry-now',
            personId: 'P00',
            intent: InfantIntent.cryForCare,
          ),
        )
        .accepted,
    'Lệnh khóc phải được nhận.',
  );
  _expect(
    host.person('P00')!.infancy!.careInteractions == 0,
    'Khóc không được biến thành chăm sóc tức thì.',
  );

  simulation.advanceTo(const SimTime(1));
  _expect(_hasFact(simulation, 'cry_heard'), 'Người chăm sóc phải nghe thấy.');
  _expect(
    simulation.state.people['N01']!.caregiverAgent!.currentActivity ==
        'respond_to_infant',
    'Người chăm sóc phải tạm ngắt công việc.',
  );
  final String midChainSave = simulation.state.save();

  simulation.advanceTo(const SimTime(6));
  _expect(
    simulation.state.people['N01']!.positionMm == 0,
    'Người chăm sóc phải mất thời gian di chuyển đến trẻ.',
  );
  _expect(
    host.person('P00')!.infancy!.careInteractions == 0,
    'Đến nơi chưa đồng nghĩa chăm sóc đã hoàn tất.',
  );
  simulation.advanceTo(const SimTime(66));
  _expect(
    host.person('P00')!.infancy!.careInteractions == 1,
    'Chăm sóc phải hoàn tất sau thời gian thao tác.',
  );
  _expect(
    simulation.state.items['I-FEED-01']!.quantity == 72,
    'Khả năng bú phải giới hạn lượng tiêu thụ còn 48 ml.',
  );
  _expect(
    simulation.state.items['I-CLOTH-01']!.condition == 995,
    'Khăn phải hao mòn sau sử dụng.',
  );
  _expect(
    simulation.state.people['N01']!.caregiverAgent!.currentActivity ==
        'prepare_meal',
    'Công việc bị ngắt phải được khôi phục.',
  );

  final Simulation restored = Simulation.fromSave(midChainSave)
    ..advanceTo(const SimTime(66));
  _expect(
    restored.state.semanticHash() == simulation.state.semanticHash(),
    'Lưu giữa chuỗi phải tiếp tục đúng cùng kết quả.',
  );

  final Simulation unheard = _world(caregiverPositionMm: 10000);
  SimulationHost(unheard).submit(
    const InfantIntentCommand(
      id: 'unheard-cry',
      personId: 'P00',
      intent: InfantIntent.cryForCare,
    ),
  );
  unheard.advanceTo(const SimTime(2));
  _expect(
    _hasFact(unheard, 'cry_not_heard'),
    'Tiếng khóc xa phải không được nghe.',
  );
  _expect(
    SimulationHost(unheard).person('P00')!.infancy!.unmetCareEpisodes == 1,
    'Lần gọi không được nghe phải được ghi nhận.',
  );

  final Simulation immobile = _world(movementSpeedMmPerSecond: 0);
  SimulationHost(immobile).submit(
    const InfantIntentCommand(
      id: 'immobile-cry',
      personId: 'P00',
      intent: InfantIntent.cryForCare,
    ),
  );
  immobile.advanceTo(const SimTime(2));
  _expect(
    _hasFact(immobile, 'caregiver_cannot_reach'),
    'Nghe thấy nhưng không di chuyển được phải thất bại riêng.',
  );

  final Simulation noSupplies = _world(withSupplies: false);
  SimulationHost(noSupplies).submit(
    const InfantIntentCommand(
      id: 'supply-cry',
      personId: 'P00',
      intent: InfantIntent.cryForCare,
    ),
  );
  noSupplies.advanceTo(const SimTime(66));
  _expect(
    _hasFact(noSupplies, 'care_failed_missing_supply'),
    'Đến nơi nhưng thiếu vật dụng phải thất bại riêng.',
  );
  _expect(
    SimulationHost(noSupplies).person('P00')!.infancy!.careInteractions == 0,
    'Thiếu vật dụng không được tính là đã chăm sóc.',
  );

  print('V1.1 causal care-chain verification passed.');
  print('Semantic hash: ${simulation.state.semanticHash()}');
}

Simulation _world({
  int caregiverPositionMm = 5000,
  int movementSpeedMmPerSecond = 1000,
  bool withSupplies = true,
}) {
  final Simulation simulation = Simulation.fromSeed(20260907)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': 'N01',
        'name': 'Người chăm sóc',
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': caregiverPositionMm,
        'caregiver_agent': true,
        'hearing_threshold': 300,
        'movement_speed_mm_per_second': movementSpeedMmPerSecond,
        'current_activity': 'prepare_meal',
      },
    )
    ..schedule(
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
  if (withSupplies) {
    simulation
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: const <String, Object?>{
          'item_id': 'I-FEED-01',
          'kind': 'infant_feed',
          'position_mm': 0,
          'quantity': 120,
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

bool _hasFact(Simulation simulation, String kind) =>
    simulation.state.facts.any((WorldFact fact) => fact.kind == kind);

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
