import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.9: tuyến vận tải thật — nhiều chặng có vị trí, địa hình và quãng đường;
/// giờ đến ra từ tốc độ thật chứ không phải một con số viết sẵn.
void main() {
  // KV01: tốc độ ra từ địa hình, tải hàng và sức lực người chở.
  const Map<String, int> heavy = <String, int>{'food': 20000, 'water': 20000};
  const Map<String, int> light = <String, int>{'food': 1000};
  _expect(
    CarrierPace.loadFactorPerMille(light) >
        CarrierPace.loadFactorPerMille(heavy),
    'Mang nặng thì hệ số tải phải thấp hơn mang nhẹ.',
  );
  final int flat = CarrierPace.speedMmPerSecond(
    terrainSpeedPerMille: 1000,
    cargo: light,
    capabilityPerMille: 1000,
  );
  final int mountain = CarrierPace.speedMmPerSecond(
    terrainSpeedPerMille: 400,
    cargo: light,
    capabilityPerMille: 1000,
  );
  final int weak = CarrierPace.speedMmPerSecond(
    terrainSpeedPerMille: 1000,
    cargo: light,
    capabilityPerMille: 500,
  );
  _expect(
    mountain < flat && weak < flat && weak == flat ~/ 2,
    'Đường núi và người yếu đều phải làm tốc độ giảm đúng theo hệ số.',
  );
  _expect(
    CarrierPace.travelSeconds(distanceMm: 1000, speedMmPerSecond: 300) == 4,
    'Thời gian đi phải làm tròn lên để không về sớm hơn thực tế.',
  );

  final Simulation world = _world();

  // KV02: tuyến được vật chất hóa với đủ điểm mốc và chặng.
  final TradeRoute route = world.state.routes['RT-ANKHE']!;
  _expect(
    route.waypoints.length == 4 && route.legs.length == 3,
    'Tuyến phải có bốn điểm mốc và ba chặng.',
  );
  _expect(
    route.totalDistanceMm == 12000000,
    'Tổng quãng đường phải bằng ba chặng bốn ki lô mét.',
  );
  _expect(
    route.slowestLeg!.terrain == 'duong_nui',
    'Chặng chậm nhất phải là đoạn đường núi.',
  );

  // KV03: người chở đi qua từng điểm mốc thật, không nhảy thẳng tới nơi.
  // Chuyến khởi hành 18:00; chặng đầu bốn ki lô mét mất khoảng một tiếng rưỡi.
  world.advanceTo(const SimTime(4 * gameSecondsPerDay + 22 * 3600));
  final SupplyJourneyState leg0 = world.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    leg0.onRoute && leg0.legCount == 3,
    'Chuyến hàng phải biết mình đang chạy trên tuyến có ba chặng.',
  );
  final List<WorldFact> arrivals = world.state.facts
      .where((WorldFact fact) => fact.kind == 'route_leg_arrived')
      .toList();
  _expect(
    arrivals.isNotEmpty,
    'Người chở phải tới được ít nhất một điểm mốc trung gian.',
  );
  _expect(
    world.state.people['N04']!.positionMm != 12012000,
    'Vị trí người chở phải đổi thật khi đi đường.',
  );

  // KV04: đi hết tuyến thì hàng vào kho.
  world.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final SupplyJourneyState done = world.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    done.status == SupplyJourneyStatus.delivered,
    'Đi hết ba chặng thì chuyến hàng phải được giao.',
  );
  _expect(
    done.travelledMm == route.totalDistanceMm,
    'Quãng đường đã đi phải bằng đúng tổng chiều dài tuyến.',
  );
  _expect(
    world.state.households['H01']!.supplyDeliveries >= 1,
    'Kho của hộ phải nhận được hàng.',
  );
  _expect(
    world.state.facts
            .where((WorldFact fact) => fact.kind == 'route_leg_arrived')
            .length >=
        3,
    'Phải ghi lại đủ ba lần tới điểm mốc.',
  );

  // KV05: trễ giờ sinh ra từ địa hình chứ không phải hằng số viết sẵn.
  _expect(
    done.delaySeconds > 0 && done.delayReason == 'duong_nui',
    'Chuyến hàng phải trễ vì đường núi, và nói đúng tên địa hình.',
  );
  final WorldFact started = world.state.facts.firstWhere(
    (WorldFact fact) => fact.kind == 'supply_journey_started',
  );
  _expect(
    started.detail.contains('load_factor=') &&
        started.detail.contains('capability='),
    'Lúc khởi hành phải ghi rõ tải hàng và sức lực đã tính vào tốc độ.',
  );

  // KV06: người chở yếu thì đi chậm hơn hẳn.
  final Simulation weakWorld = _world(carrierReserveKj: 0, carrierMassG: 44000);
  weakWorld.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final SupplyJourneyState weakTrip =
      weakWorld.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    weakTrip.delaySeconds > done.delaySeconds,
    'Người chở yếu sức phải làm chuyến hàng trễ nhiều hơn.',
  );

  // KV07: nhánh cũ không có tuyến vẫn chạy y như trước.
  final Simulation legacy = _world(withRoute: false);
  legacy.advanceTo(const SimTime(6 * gameSecondsPerDay));
  final SupplyJourneyState old = legacy.state.supplyJourneys['SUP-H01-0']!;
  _expect(
    !old.onRoute && old.status == SupplyJourneyStatus.delivered,
    'Thế giới không khai báo tuyến vẫn dùng nhánh cũ và giao được hàng.',
  );
  _expect(
    legacy.state.facts.every(
      (WorldFact fact) => fact.kind != 'route_leg_arrived',
    ),
    'Nhánh cũ không được sinh ra chặng đường nào.',
  );

  // KV08: lưu giữa đường vẫn tái hiện đúng.
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

  print('V2.9 trade route verification passed.');
  print('Day 8 hash: ${continuous.state.semanticHash()}');
  print(
    'Tuyến ${route.name}: ${route.legs.length} chặng, '
    '${route.totalDistanceMm} mm, chặng chậm nhất ${route.slowestLeg!.terrain}.',
  );
  print(
    'Chuyến đầu: dự kiến ${done.expectedArrivalSeconds}, '
    'tới thật ${done.actualArrivalSeconds}, '
    'trễ ${done.delaySeconds} giây vì ${done.delayReason}.',
  );
  print(
    'Người chở yếu sức làm chuyến trễ ${weakTrip.delaySeconds} giây, '
    'nhiều hơn ${weakTrip.delaySeconds - done.delaySeconds} giây.',
  );
}

Simulation _world({
  bool withRoute = true,
  int carrierMassG = 52000,
  int? carrierReserveKj,
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
  if (withRoute) {
    // Chợ cách nhà 12 km: một chặng đường bằng, một đoạn đường núi, một khúc lội suối.
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'route_created',
      payload: const <String, Object?>{
        'route': <String, Object?>{
          'id': 'RT-ANKHE',
          'name': 'Tuyến chợ An Khê',
          'waypoints': <Map<String, Object?>>[
            <String, Object?>{
              'id': 'WP-CHO',
              'name': 'Chợ An Khê',
              'position_mm': 12012000,
            },
            <String, Object?>{
              'id': 'WP-DEO',
              'name': 'Chân đèo',
              'position_mm': 8012000,
            },
            <String, Object?>{
              'id': 'WP-SUOI',
              'name': 'Khúc lội suối',
              'position_mm': 4012000,
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
              'terrain': 'duong_bang',
              'terrain_speed_per_mille': 1000,
            },
            <String, Object?>{
              'from_id': 'WP-DEO',
              'to_id': 'WP-SUOI',
              'terrain': 'duong_nui',
              'terrain_speed_per_mille': 400,
            },
            <String, Object?>{
              'from_id': 'WP-SUOI',
              'to_id': 'WP-SAN',
              'terrain': 'loi_suoi',
              'terrain_speed_per_mille': 600,
            },
          ],
        },
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
        if (carrierReserveKj != null) 'energy_reserve_kj': carrierReserveKj,
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
      'authorized_users_by_item_id': const <String, List<String>>{
        'I-FOOD': <String>['N02'],
        'I-WATER': <String>['N01', 'N02'],
        'I-FUEL': <String>['N02'],
        'I-FEED': <String>['N01', 'N02'],
        'I-CLOTH': <String>['N01', 'N02'],
      },
      'scheduled_work_seconds_by_person': const <String, int>{
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
      if (withRoute) 'supply_route_id': 'RT-ANKHE',
    },
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
