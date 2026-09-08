import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.10: vị trí hai chiều và tuyến có ngã rẽ thật.
///
/// Người chở tự chọn đường nhanh nhất cho mình; chặng nào không đủ sức qua
/// thì bị loại, nên người yếu có thể phải đi đường vòng — hoặc không đi được.
void main() {
  // KH01: khoảng cách hai chiều bằng số nguyên, tam giác 3-4-5 phải khớp.
  _expect(
    const WorldPoint(0, 0).distanceTo(const WorldPoint(3000, 4000)) == 5000,
    'Khoảng cách hai chiều phải đúng với tam giác vuông 3-4-5.',
  );
  _expect(
    integerSquareRoot(0) == 0 &&
        integerSquareRoot(1) == 1 &&
        integerSquareRoot(15) == 3 &&
        integerSquareRoot(16) == 4 &&
        integerSquareRoot(1000000) == 1000,
    'Căn nguyên phải lấy đúng phần nguyên, không dùng số thực.',
  );

  // KH02: thế giới một chiều cũ không đổi kết quả — đây là lý do giữ được hash.
  _expect(
    const WorldPoint(12000).distanceTo(const WorldPoint(5000)) == 7000 &&
        const WorldPoint(5000).distanceTo(const WorldPoint(12000)) == 7000,
    'Hai điểm cùng nằm trên trục thì khoảng cách phải bằng đúng hiệu tuyệt đối.',
  );
  _expect(
    const WorldPoint(12000).onAxis && !const WorldPoint(12000, 5).onAxis,
    'Điểm có trục thứ hai bằng 0 mới được coi là nằm trên trục.',
  );

  final Simulation world = _world();
  final TradeRoute route = world.state.routes['RT-FORK']!;

  // KH03: tuyến có ngã rẽ thật, hai đường khác nhau cùng nối chợ với sân hộ.
  _expect(route.hasFork, 'Tuyến phải có ít nhất một điểm rẽ.');
  _expect(
    route.legsFrom('WP-CHO').length == 2,
    'Từ chợ phải có hai lối đi khác nhau.',
  );

  // KH04: đường vòng bằng phẳng nhanh hơn đường ngắn leo đèo.
  const Map<String, int> cargo = <String, int>{
    'food': 7500,
    'water': 30000,
    'infant_feed': 1500,
  };
  final List<String> viaPass = <String>['WP-CHO', 'WP-DEO', 'WP-SAN'];
  final List<String> viaPlain = <String>['WP-CHO', 'WP-DONG', 'WP-SAN'];
  final int passDistance = route.pathDistanceMm(viaPass);
  final int plainDistance = route.pathDistanceMm(viaPlain);
  final int passSeconds = route.pathSeconds(
    path: viaPass,
    cargo: cargo,
    capabilityPerMille: 1000,
  );
  final int plainSeconds = route.pathSeconds(
    path: viaPlain,
    cargo: cargo,
    capabilityPerMille: 1000,
  );
  _expect(
    plainDistance > passDistance,
    'Đường vòng phải dài hơn đường qua đèo về quãng đường.',
  );
  _expect(
    plainSeconds < passSeconds,
    'Nhưng đường vòng bằng phẳng phải nhanh hơn về thời gian.',
  );

  // KH05: người khỏe chọn đúng đường nhanh hơn, không phải đường ngắn hơn.
  final List<String> chosen = route.fastestPath(
    from: 'WP-CHO',
    to: 'WP-SAN',
    cargo: cargo,
    capabilityPerMille: 1000,
  );
  _expect(
    chosen.join('>') == viaPlain.join('>'),
    'Người khỏe phải chọn đường vòng bằng phẳng.',
  );

  // KH06: người yếu bị chặn ở khúc lội suối nên buộc phải leo đèo.
  final List<String> weakChoice = route.fastestPath(
    from: 'WP-CHO',
    to: 'WP-SAN',
    cargo: cargo,
    capabilityPerMille: 500,
  );
  _expect(
    weakChoice.join('>') == viaPass.join('>'),
    'Người yếu không qua được suối thì phải đi đường đèo.',
  );

  // KH07: yếu quá thì không có đường nào đi được.
  _expect(
    route
        .fastestPath(
          from: 'WP-CHO',
          to: 'WP-SAN',
          cargo: cargo,
          capabilityPerMille: 200,
        )
        .isEmpty,
    'Không đủ sức qua bất cứ chặng nào thì không có đường về.',
  );

  // KH08: chuyến hàng thật đi đúng đường đã chọn, qua điểm mốc lệch trục.
  world.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final SupplyJourneyState trip = world.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    trip.pathWaypointIds.join('>') == viaPlain.join('>'),
    'Chuyến hàng phải được ghi lại đúng đường đã chọn.',
  );
  _expect(
    trip.status == SupplyJourneyStatus.delivered &&
        trip.travelledMm == plainDistance,
    'Đi hết đường vòng thì phải giao được hàng và cộng đúng quãng đường.',
  );
  _expect(
    world.state.facts.any(
      (WorldFact fact) =>
          fact.kind == 'route_leg_arrived' && fact.detail.contains('WP-DONG'),
    ),
    'Người chở phải thật sự đi qua điểm mốc lệch khỏi trục.',
  );
  final WorldFact started = world.state.facts.firstWhere(
    (WorldFact fact) => fact.kind == 'supply_journey_started',
  );
  _expect(
    started.detail.contains('path=WP-CHO>WP-DONG>WP-SAN'),
    'Lúc khởi hành phải ghi rõ đường đã chọn.',
  );

  // KH09: người chở yếu thật thì chuyến hàng đi đường khác.
  final Simulation weakWorld = _world(carrierMassG: 44000);
  weakWorld.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final SupplyJourneyState weakTrip =
      weakWorld.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    weakTrip.pathWaypointIds.contains('WP-DEO'),
    'Người chở yếu phải bị đẩy sang đường đèo.',
  );
  _expect(
    weakTrip.pathWaypointIds.join('>') != trip.pathWaypointIds.join('>'),
    'Hai người khác sức phải đi hai đường khác nhau trên cùng một tuyến.',
  );

  // KH10: yếu quá thì chuyến hàng không khởi hành được, và ghi rõ lý do.
  final Simulation strandedWorld = _world(carrierMassG: 40000);
  strandedWorld.advanceTo(const SimTime(6 * gameSecondsPerDay));
  _expect(
    strandedWorld.state.facts.any(
      (WorldFact fact) => fact.kind == 'supply_route_impassable',
    ),
    'Không có đường đi được thì phải ghi nhận là tuyến không qua nổi.',
  );
  _expect(
    strandedWorld.state.supplyJourneys.isEmpty,
    'Không được tạo chuyến hàng khi không có đường nào đi được.',
  );

  // KH11: lưu giữa đường vẫn tái hiện đúng.
  final Simulation continuous = _world();
  continuous.advanceTo(const SimTime(4 * gameSecondsPerDay + 21 * 3600));
  _expect(
    continuous.state.supplyJourneys['SUP-H01-0']!.status !=
        SupplyJourneyStatus.delivered,
    'Mốc lưu phải nằm lúc người chở còn đang trên đường.',
  );
  final Simulation restored = Simulation.fromSave(continuous.state.save());
  continuous.advanceTo(const SimTime(8 * gameSecondsPerDay));
  restored.advanceTo(const SimTime(8 * gameSecondsPerDay));
  _expect(
    continuous.state.semanticHash() == restored.state.semanticHash(),
    'Lưu giữa đường phải tiếp tục cùng kết quả.',
  );

  print('V2.10 two-axis positions and route fork verification passed.');
  print('Day 8 hash: ${continuous.state.semanticHash()}');
  print(
    'Đường qua đèo: ${passDistance ~/ 1000} m, '
    '${(passSeconds / 3600).toStringAsFixed(1)} giờ.',
  );
  print(
    'Đường vòng bằng: ${plainDistance ~/ 1000} m, '
    '${(plainSeconds / 3600).toStringAsFixed(1)} giờ — dài hơn nhưng nhanh hơn.',
  );
  print('Người khỏe chọn: ${chosen.join(' > ')}');
  print('Người yếu buộc đi: ${weakChoice.join(' > ')}');
}

Simulation _world({int carrierMassG = 52000}) {
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
  // Hai lối từ chợ về sân hộ: đường đèo ngắn mà dốc, đường vòng dài mà bằng.
  // Điểm Đồng lệch khỏi trục 5 km, nên ngã rẽ này chỉ có nghĩa trong hai chiều.
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'route_created',
    payload: const <String, Object?>{
      'route': <String, Object?>{
        'id': 'RT-FORK',
        'name': 'Tuyến chợ An Khê có ngã rẽ',
        'origin_id': 'WP-CHO',
        'destination_id': 'WP-SAN',
        'waypoints': <Map<String, Object?>>[
          <String, Object?>{
            'id': 'WP-CHO',
            'name': 'Chợ An Khê',
            'position_mm': 12012000,
          },
          <String, Object?>{
            'id': 'WP-DEO',
            'name': 'Đỉnh đèo',
            'position_mm': 6012000,
          },
          <String, Object?>{
            'id': 'WP-DONG',
            'name': 'Đồng ngoài',
            'position_mm': 6012000,
            'position_y_mm': 5000000,
          },
          <String, Object?>{
            'id': 'WP-SAN',
            'name': 'Sân hộ',
            'position_mm': 12000,
          },
        ],
        'legs': <Map<String, Object?>>[
          <String, Object?>{
            'from_id': 'WP-CHO',
            'to_id': 'WP-DEO',
            'terrain': 'duong_nui',
            'terrain_speed_per_mille': 400,
            'min_capability_per_mille': 300,
          },
          <String, Object?>{
            'from_id': 'WP-DEO',
            'to_id': 'WP-SAN',
            'terrain': 'duong_nui',
            'terrain_speed_per_mille': 400,
            'min_capability_per_mille': 300,
          },
          <String, Object?>{
            'from_id': 'WP-CHO',
            'to_id': 'WP-DONG',
            'terrain': 'loi_suoi',
            'terrain_speed_per_mille': 600,
            'min_capability_per_mille': 600,
          },
          <String, Object?>{
            'from_id': 'WP-DONG',
            'to_id': 'WP-SAN',
            'terrain': 'duong_bang',
            'terrain_speed_per_mille': 1000,
          },
        ],
      },
    },
  );
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
      'name': 'Người làm công',
      'position_mm': 12000,
      'room_id': 'ROOM-YARD',
      'household_id': 'H01',
    },
    <String, Object?>{
      'person_id': 'N04',
      'name': 'Người vận chuyển',
      'position_mm': 12012000,
      'adult_body': <String, Object?>{
        'mass_g': carrierMassG,
        'healthy_mass_g': 52000,
      },
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
      'supply_route_id': 'RT-FORK',
    },
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
