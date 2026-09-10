import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.20: các hộ nơi sinh được tạo từ seed + lịch sử và sinh quan hệ gia đình.
void main() {
  final GeneratedBirthHouseholds first = _generate(20260907);
  final GeneratedBirthHouseholds repeated = _generate(20260907);
  final GeneratedBirthHouseholds different = _generate(42);
  _expect(
    first.fingerprint == repeated.fingerprint &&
        first.households
                .map((GeneratedBirthHousehold value) => value.toJson())
                .toString() ==
            repeated.households
                .map((GeneratedBirthHousehold value) => value.toJson())
                .toString(),
    'Cùng seed và cùng lịch sử phải sinh đúng cùng gia đình.',
  );
  _expect(
    first.fingerprint != different.fingerprint,
    'Seed khác phải có dấu vết gia đình khác.',
  );
  _expect(
    first.households.length == 2 &&
        first.households
            .map((GeneratedBirthHousehold value) => value.siteId)
            .toSet()
            .containsAll(<String>{'SITE-FIELD', 'SITE-MARKET'}),
    'Bộ sinh đầu tiên phải tạo hộ ở đồng và chợ.',
  );

  final Simulation awaiting = _prepared(20260907);
  _expect(
    awaiting.state.people.keys.toSet().containsAll(<String>{'N05', 'N06'}) &&
        awaiting.state.people['P00'] == null &&
        awaiting.state.historicalLegacy?.adjustments.length == 8,
    'Hai người chăm và tám kho phải tồn tại qua tiền sử trước P00.',
  );
  final List<BirthSiteCandidate> feasible = awaiting
      .birthSiteCandidates()
      .where((BirthSiteCandidate value) => value.feasible)
      .toList();
  _expect(
    feasible.length == 2 &&
        feasible.every(
          (BirthSiteCandidate value) =>
              value.caregiverRole != null &&
              value.familyOriginSummary?.isNotEmpty == true,
        ),
    'Mỗi nơi sinh phải công bố vai trò người chăm và nguồn gốc gia đình.',
  );

  for (final BirthSiteCandidate candidate in feasible) {
    final Simulation branch = _prepared(20260907)
      ..issue(
        ChooseBirthSiteCommand(
          id: 'choose-${candidate.siteId}',
          siteId: candidate.siteId,
        ),
      )
      ..advanceTo(const SimTime(0));
    final PersonState child = branch.state.people['P00']!;
    final PersonState caregiver = branch.state.people[candidate.caregiverId]!;
    final String reverseRole = candidate.caregiverRole == 'guardian'
        ? 'ward'
        : 'child';
    _expect(
      child.familyRelationships[candidate.caregiverId] ==
              candidate.caregiverRole &&
          caregiver.familyRelationships['P00'] == reverseRole &&
          branch.state.worldEntry?.familyOriginSummary ==
              candidate.familyOriginSummary,
      'Sinh tại ${candidate.siteId} phải tạo quan hệ hai chiều đúng vai trò.',
    );
    final Simulation restored = Simulation.fromSave(branch.state.save());
    _expect(
      restored.state.semanticHash() == branch.state.semanticHash() &&
          restored.state.people['P00']!.familyRelationships.toString() ==
              child.familyRelationships.toString(),
      'Save/load phải giữ nguyên nguồn gốc và quan hệ gia đình.',
    );
  }

  bool rejectedMismatch = false;
  try {
    BirthHouseholdGenerator.generate(
      world: WorldGenerator.generate(rootSeed: 42),
      history: WorldHistoryGenerator.generate(
        rootSeed: 20260907,
        worldFingerprint: WorldGenerator.generate(
          rootSeed: 20260907,
        ).fingerprint,
      ),
    );
  } on StateError {
    rejectedMismatch = true;
  }
  _expect(rejectedMismatch, 'Bản đồ và lịch sử lệch nhau phải bị từ chối.');

  print('V2.20 seeded birth families verification passed.');
  print('Family fingerprint: ${first.fingerprint}');
  print('Awaiting-choice hash: ${awaiting.state.semanticHash()}');
  for (final GeneratedBirthHousehold household in first.households) {
    print(
      '${household.siteId} | ${household.householdName} | '
      '${household.caregiverName}:${household.caregiverRole} | '
      'skill=${household.caregiverSkill} feed=${household.infantFeedQuantity}',
    );
  }
}

GeneratedBirthHouseholds _generate(int seed) {
  final GeneratedWorld world = WorldGenerator.generate(rootSeed: seed);
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: seed,
    worldFingerprint: world.fingerprint,
  );
  return BirthHouseholdGenerator.generate(world: world, history: history);
}

Simulation _prepared(int seed) {
  final GeneratedWorld world = WorldGenerator.generate(rootSeed: seed);
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: seed,
    worldFingerprint: world.fingerprint,
  );
  final GeneratedBirthHouseholds families = BirthHouseholdGenerator.generate(
    world: world,
    history: history,
  );
  final WorldSite market = world.site('SITE-MARKET');
  final WorldSite home = world.site('SITE-HOME');
  return Simulation.fromSeed(seed)
    ..materializeWorld(world)
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
    ..materializeBirthHouseholds(families, history: history)
    ..simulatePrehistory(history, applyLegacy: true)
    ..openWorldEntry()
    ..advanceTo(const SimTime(0));
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
