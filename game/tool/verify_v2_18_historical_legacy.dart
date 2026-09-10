import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.18: kết quả tiền sử phải thay đổi tài nguyên và tiếp tế hiện tại.
void main() {
  final GeneratedWorld generated = WorldGenerator.generate(rootSeed: 20260907);
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: generated.rootSeed,
    worldFingerprint: generated.fingerprint,
  );
  final Simulation simulation = _preparedWorld(
    generated: generated,
    history: history,
  );
  final HistoricalLegacyState legacy = simulation.state.historicalLegacy!;

  _expect(
    legacy.historyFingerprint == history.fingerprint &&
        legacy.formulaVersion == historicalLegacyFormulaVersion,
    'Di sản phải giữ provenance của lịch sử và phiên bản công thức.',
  );
  _expect(
    legacy.foodReservePerMille == 1113 &&
        legacy.waterReservePerMille == 991 &&
        legacy.fuelReservePerMille == 944 &&
        legacy.infantFeedReservePerMille == 1000 &&
        legacy.supplyDeliveryPerMille == 1103 &&
        legacy.floodDamagePerMille == 138,
    'Seed mặc định phải cho đúng các hệ số hậu quả xác định.',
  );
  _expect(
    simulation.state.items['I-FOOD-01']!.quantity == 16695 &&
        simulation.state.items['I-WATER-01']!.quantity == 47568 &&
        simulation.state.items['I-FUEL-01']!.quantity == 4248 &&
        simulation.state.items['I-FEED-01']!.quantity == 10000,
    'Hậu quả phải đổi lượng của chính vật phẩm hiện tại.',
  );
  _expect(
    legacy.adjustments.length == 4 &&
        legacy.adjustments.every(
          (HistoricalResourceAdjustment adjustment) =>
              adjustment.beforeQuantity != adjustment.afterQuantity ||
              adjustment.resourceKey == 'infant_feed',
        ),
    'Mọi kho được liên kết phải có bản ghi trước/sau.',
  );
  _expect(
    simulation
                .birthSiteCandidates()
                .where((BirthSiteCandidate candidate) => candidate.feasible)
                .length ==
            1 &&
        simulation.state.worldEntry?.awaitingBirthSite == true &&
        simulation.state.people['P00'] == null,
    'Sau hậu quả lịch sử vẫn phải còn đúng một nơi sinh khả thi và chưa có P00.',
  );
  final int historyIndex = simulation.state.facts.indexWhere(
    (WorldFact fact) => fact.kind == 'world_history_completed',
  );
  final int legacyIndex = simulation.state.facts.indexWhere(
    (WorldFact fact) => fact.kind == 'historical_legacy_applied',
  );
  final int entryIndex = simulation.state.facts.indexWhere(
    (WorldFact fact) => fact.kind == 'world_entry_opened',
  );
  _expect(
    historyIndex >= 0 && legacyIndex > historyIndex && entryIndex > legacyIndex,
    'Di sản phải được áp dụng giữa lúc lịch sử hoàn tất và lúc mở nhập thế.',
  );

  final String hashBeforeDelivery = simulation.state.semanticHash();
  final Simulation restored = Simulation.fromSave(simulation.state.save());
  _expect(
    restored.state.semanticHash() == hashBeforeDelivery &&
        restored.state.historicalLegacy?.adjustments.length == 4,
    'Save/load phải giữ nguyên di sản và hash.',
  );

  final Map<String, int> beforeDelivery = <String, int>{
    for (final String id in <String>['I-FOOD-01', 'I-WATER-01', 'I-FEED-01'])
      id: simulation.state.items[id]!.quantity,
  };
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.transfer,
    kind: 'household_supply_delivery',
    payload: const <String, Object?>{
      'household_id': 'H01',
      'single_delivery': true,
    },
  );
  simulation.advanceTo(const SimTime(0));
  _expect(
    simulation.state.items['I-FOOD-01']!.quantity -
                beforeDelivery['I-FOOD-01']! ==
            8272 &&
        simulation.state.items['I-WATER-01']!.quantity -
                beforeDelivery['I-WATER-01']! ==
            33090 &&
        simulation.state.items['I-FEED-01']!.quantity -
                beforeDelivery['I-FEED-01']! ==
            1654,
    'Giao thương lịch sử phải đổi lượng thật của chuyến tiếp tế.',
  );

  final int fragileSeed = _seedWithReducedInfantFeed();
  final GeneratedWorld fragileWorld = WorldGenerator.generate(
    rootSeed: fragileSeed,
  );
  final GeneratedWorldHistory fragileHistory = WorldHistoryGenerator.generate(
    rootSeed: fragileSeed,
    worldFingerprint: fragileWorld.fingerprint,
  );
  bool unsafeSnapshotRejected = false;
  try {
    _preparedWorld(
      generated: fragileWorld,
      history: fragileHistory,
      infantFeedQuantity: 1,
    );
  } on StateError {
    unsafeSnapshotRejected = true;
  }
  _expect(
    unsafeSnapshotRejected,
    'Snapshot bị lịch sử làm mất nơi sinh cuối cùng phải bị từ chối.',
  );

  print('V2.18 historical legacy verification passed.');
  print('World hash before delivery: $hashBeforeDelivery');
  print(
    'Reserve multipliers: food=${legacy.foodReservePerMille}, '
    'water=${legacy.waterReservePerMille}, fuel=${legacy.fuelReservePerMille}, '
    'infant_feed=${legacy.infantFeedReservePerMille}.',
  );
  print(
    'Supply=${legacy.supplyDeliveryPerMille}, '
    'flood_damage=${legacy.floodDamagePerMille}, '
    'adjustments=${legacy.adjustments.length}.',
  );
}

int _seedWithReducedInfantFeed() {
  for (int seed = 1; seed <= 100; seed++) {
    final GeneratedWorld world = WorldGenerator.generate(rootSeed: seed);
    final GeneratedWorldHistory generated = WorldHistoryGenerator.generate(
      rootSeed: seed,
      worldFingerprint: world.fingerprint,
    );
    WorldHistoryState history = WorldHistoryState.started(generated);
    for (final HistoricalEpochResult epoch in generated.epochs) {
      history = history.applyEpoch(epoch);
    }
    history = history.markComplete();
    final HistoricalLegacyState legacy = HistoricalLegacyGenerator.generate(
      history: history,
      households: const <String, HouseholdState>{},
      items: const <String, CareItemState>{},
    ).state;
    if (legacy.infantFeedReservePerMille < 1000) return seed;
  }
  throw StateError('Fixture không tìm được seed làm giảm dự trữ sữa.');
}

Simulation _preparedWorld({
  required GeneratedWorld generated,
  required GeneratedWorldHistory history,
  int infantFeedQuantity = 10000,
}) {
  final WorldSite home = generated.site('SITE-HOME');
  final WorldSite market = generated.site('SITE-MARKET');
  final Simulation simulation = Simulation.fromSeed(generated.rootSeed)
    ..materializeWorld(generated)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'route_created',
      payload: <String, Object?>{
        'route': <String, Object?>{
          'id': 'RT-ANKHE',
          'name': 'Tuyến chợ An Khê',
          'origin_id': 'WP-MARKET',
          'destination_id': 'WP-HOME',
          'waypoints': <Map<String, Object?>>[
            <String, Object?>{
              'id': 'WP-MARKET',
              'name': 'Chợ An Khê',
              'position_mm': market.center.xMm,
              'position_y_mm': market.center.yMm,
            },
            <String, Object?>{
              'id': 'WP-HOME',
              'name': 'Hộ ven suối',
              'position_mm': home.center.xMm,
              'position_y_mm': home.center.yMm,
            },
          ],
          'legs': <Map<String, Object?>>[
            <String, Object?>{
              'from_id': 'WP-MARKET',
              'to_id': 'WP-HOME',
              'terrain': 'duong_bang',
              'terrain_speed_per_mille': 1000,
            },
          ],
        },
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: <String, Object?>{
        'room_id': 'ROOM-SLEEP',
        'name': 'Gian ngủ',
        'household_id': 'H01',
        'anchor_position_mm': home.center.xMm,
        'anchor_position_y_mm': home.center.yMm,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': 'N01',
        'name': 'Người chăm sóc',
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'household_id': 'H01',
        'caregiver_agent': true,
      },
    );
  final Map<String, (String, int, String)> resources =
      <String, (String, int, String)>{
        'food': ('I-FOOD-01', 15000, 'g'),
        'water': ('I-WATER-01', 48000, 'ml'),
        'fuel': ('I-FUEL-01', 4500, 'g'),
        'infant_feed': ('I-FEED-01', infantFeedQuantity, 'ml'),
      };
  for (final MapEntry<String, (String, int, String)> resource
      in resources.entries) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': resource.value.$1,
        'kind': resource.key,
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': resource.value.$2,
        'unit': resource.value.$3,
        'owner_household_id': 'H01',
      },
    );
  }
  simulation
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H01',
        'name': 'Hộ ven suối',
        'member_ids': <String>['N01'],
        'resource_item_ids': <String, String>{
          'food': 'I-FOOD-01',
          'water': 'I-WATER-01',
          'fuel': 'I-FUEL-01',
          'infant_feed': 'I-FEED-01',
        },
        'authorized_users_by_item_id': <String, List<String>>{
          'I-FOOD-01': <String>['N01'],
          'I-WATER-01': <String>['N01'],
          'I-FUEL-01': <String>['N01'],
          'I-FEED-01': <String>['N01'],
        },
        'scheduled_work_seconds_by_person': <String, int>{},
        'meal_actor_id': 'N01',
      },
    )
    ..simulatePrehistory(history, applyLegacy: true)
    ..openWorldEntry()
    ..advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
