import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.19: nhiều hộ vật chất hóa tạo nhiều hoàn cảnh sinh khác nhau.
void main() {
  final Simulation simulation = _preparedWorld();
  final List<BirthSiteCandidate> candidates = simulation.birthSiteCandidates();
  final List<BirthSiteCandidate> feasible = candidates
      .where((BirthSiteCandidate candidate) => candidate.feasible)
      .toList();

  _expect(
    simulation.state.households.length == 3 &&
        simulation.state.historicalLegacy?.adjustments.length == 12,
    'Ba hộ và mười hai kho chịu lịch sử phải tồn tại trước P00.',
  );
  _expect(
    feasible
            .map((BirthSiteCandidate value) => value.siteId)
            .toSet()
            .containsAll(<String>{'SITE-HOME', 'SITE-FIELD', 'SITE-MARKET'}) &&
        feasible.length == 3,
    'Nhà ven suối, hộ giữ đồng và quán trọ chợ phải đều cho phép sinh.',
  );
  _expect(
    candidates
                .singleWhere(
                  (BirthSiteCandidate value) => value.siteId == 'SITE-RIVER',
                )
                .feasible ==
            false &&
        candidates
                .singleWhere(
                  (BirthSiteCandidate value) => value.siteId == 'SITE-PASS',
                )
                .feasible ==
            false,
    'Sông và đèo không có hộ/phòng thật nên phải tiếp tục bị khóa.',
  );

  final BirthSiteCandidate home = _candidate(feasible, 'SITE-HOME');
  final BirthSiteCandidate field = _candidate(feasible, 'SITE-FIELD');
  final BirthSiteCandidate market = _candidate(feasible, 'SITE-MARKET');
  _expect(
    home.householdId == 'H01' &&
        home.caregiverId == 'N01' &&
        home.risks.isEmpty,
    'Hộ ven suối phải là lựa chọn ổn định không có cảnh báo đầu kỳ.',
  );
  _expect(
    field.householdId == 'H02' &&
        field.caregiverId == 'N05' &&
        field.infantFeedQuantity == 4200 &&
        field.waterQuantity == 14865 &&
        field.fuelQuantity == 2265 &&
        field.risks.toSet().containsAll(<String>{
          'Dự trữ sữa mỏng',
          'Nguồn nước dự trữ thấp',
          'Thiếu nhiên liệu dự phòng',
          'Người chăm ít kinh nghiệm',
        }),
    'Hộ giữ đồng phải có đúng nguồn lực và bốn rủi ro suy ra từ trạng thái.',
  );
  _expect(
    market.householdId == 'H03' &&
        market.caregiverId == 'N06' &&
        market.foodQuantity == 10017 &&
        market.risks.length == 1 &&
        market.risks.single == 'Lương thực dự trữ thấp',
    'Hộ chợ phải có người chăm giỏi nhưng lương thực đầu kỳ mỏng.',
  );
  _expect(
    <int>{
          home.caregiverSkill!,
          field.caregiverSkill!,
          market.caregiverSkill!,
        }.length ==
        3,
    'Ba hoàn cảnh phải có ba mức tay nghề chăm trẻ khác nhau.',
  );

  final String awaitingHash = simulation.state.semanticHash();
  final Simulation restored = Simulation.fromSave(simulation.state.save());
  _expect(
    restored.state.semanticHash() == awaitingHash &&
        restored
                .birthSiteCandidates()
                .where((BirthSiteCandidate value) => value.feasible)
                .length ==
            3,
    'Save/load trước sinh phải dựng lại đúng ba lựa chọn.',
  );

  final Map<String, String> expectedHousehold = <String, String>{
    'SITE-HOME': 'H01',
    'SITE-FIELD': 'H02',
    'SITE-MARKET': 'H03',
  };
  final Set<String> bornHashes = <String>{};
  for (final MapEntry<String, String> choice in expectedHousehold.entries) {
    final Simulation branch = _preparedWorld();
    branch
      ..issue(
        ChooseBirthSiteCommand(id: 'choose-${choice.key}', siteId: choice.key),
      )
      ..advanceTo(const SimTime(0));
    final WorldEntryState entry = branch.state.worldEntry!;
    _expect(
      entry.born &&
          entry.selectedSiteId == choice.key &&
          entry.householdId == choice.value &&
          branch.state.people['P00']?.householdId == choice.value &&
          branch.state.households[choice.value]!.memberIds.contains('P00'),
      'Chọn ${choice.key} phải sinh P00 vào đúng ${choice.value}.',
    );
    bornHashes.add(branch.state.semanticHash());
  }
  _expect(
    bornHashes.length == 3,
    'Ba nơi sinh phải tạo ba trạng thái nguồn gốc khác nhau.',
  );

  print('V2.19 multiple birth households verification passed.');
  print('Awaiting-choice hash: $awaitingHash');
  for (final BirthSiteCandidate candidate in feasible) {
    print(
      '${candidate.siteId} | ${candidate.householdId} | '
      'carer=${candidate.caregiverId}:${candidate.caregiverSkill} | '
      'feed=${candidate.infantFeedQuantity} food=${candidate.foodQuantity} '
      'water=${candidate.waterQuantity} fuel=${candidate.fuelQuantity} | '
      'risks=${candidate.risks.join(',')}',
    );
  }
}

BirthSiteCandidate _candidate(
  List<BirthSiteCandidate> candidates,
  String siteId,
) => candidates.singleWhere(
  (BirthSiteCandidate candidate) => candidate.siteId == siteId,
);

Simulation _preparedWorld() {
  final GeneratedWorld generated = WorldGenerator.generate(rootSeed: 20260907);
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: generated.rootSeed,
    worldFingerprint: generated.fingerprint,
  );
  final WorldSite home = generated.site('SITE-HOME');
  final WorldSite field = generated.site('SITE-FIELD');
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
    );
  _addHousehold(
    simulation: simulation,
    site: home,
    householdId: 'H01',
    householdName: 'Hộ ven suối',
    roomId: 'ROOM-HOME',
    personId: 'N01',
    personName: 'Người chăm sóc',
    careSkill: 700,
    food: 15000,
    water: 48000,
    fuel: 4500,
    feed: 10000,
  );
  _addHousehold(
    simulation: simulation,
    site: field,
    householdId: 'H02',
    householdName: 'Hộ giữ đồng',
    roomId: 'ROOM-FIELD-HOME',
    personId: 'N05',
    personName: 'Lâm Thị Sương',
    careSkill: 560,
    food: 26000,
    water: 15000,
    fuel: 2400,
    feed: 4200,
  );
  _addHousehold(
    simulation: simulation,
    site: market,
    householdId: 'H03',
    householdName: 'Hộ quán trọ chợ',
    roomId: 'ROOM-MARKET-LOFT',
    personId: 'N06',
    personName: 'Trần Bách',
    careSkill: 860,
    food: 9000,
    water: 36000,
    fuel: 7000,
    feed: 7500,
  );
  simulation
    ..simulatePrehistory(history, applyLegacy: true)
    ..openWorldEntry()
    ..advanceTo(const SimTime(0));
  return simulation;
}

void _addHousehold({
  required Simulation simulation,
  required WorldSite site,
  required String householdId,
  required String householdName,
  required String roomId,
  required String personId,
  required String personName,
  required int careSkill,
  required int food,
  required int water,
  required int fuel,
  required int feed,
}) {
  simulation
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: <String, Object?>{
        'room_id': roomId,
        'name': 'Phòng $householdName',
        'household_id': householdId,
        'anchor_position_mm': site.center.xMm,
        'anchor_position_y_mm': site.center.yMm,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': personId,
        'name': personName,
        'birth_seconds': -30 * 365 * gameSecondsPerDay,
        'position_mm': site.center.xMm,
        'position_y_mm': site.center.yMm,
        'room_id': roomId,
        'household_id': householdId,
        'caregiver_agent': true,
        'care_skill': careSkill,
      },
    );
  final Map<String, (int, String)> quantities = <String, (int, String)>{
    'food': (food, 'g'),
    'water': (water, 'ml'),
    'fuel': (fuel, 'g'),
    'infant_feed': (feed, 'ml'),
  };
  final Map<String, String> resourceItemIds = <String, String>{};
  final Map<String, List<String>> permissions = <String, List<String>>{};
  for (final MapEntry<String, (int, String)> resource in quantities.entries) {
    final String itemId = 'I-$householdId-${resource.key}';
    resourceItemIds[resource.key] = itemId;
    permissions[itemId] = <String>[personId];
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': itemId,
        'kind': resource.key,
        'position_mm': site.center.xMm,
        'position_y_mm': site.center.yMm,
        'room_id': roomId,
        'quantity': resource.value.$1,
        'unit': resource.value.$2,
        'owner_household_id': householdId,
      },
    );
  }
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'household_created',
    payload: <String, Object?>{
      'household_id': householdId,
      'name': householdName,
      'member_ids': <String>[personId],
      'resource_item_ids': resourceItemIds,
      'authorized_users_by_item_id': permissions,
      'scheduled_work_seconds_by_person': const <String, int>{},
      'meal_actor_id': personId,
      'infant_id': 'P00',
      'caregiver_id': personId,
    },
  );
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
