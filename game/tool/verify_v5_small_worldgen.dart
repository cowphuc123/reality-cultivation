import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260907;
const SimTime _historyCompletion = SimTime(1);

/// Bằng chứng đóng cổng V5: worldgen nhỏ, tiền sử, nhập thế và tính tái lập.
///
/// File này được dựng trước nhưng chỉ chạy trong lượt kiểm chứng/phát hành.
void main() {
  final _Fixture fixture = _fixture(_seed);
  final _Fixture repeated = _fixture(_seed);
  final _Fixture other = _fixture(_seed + 1);

  _expect(
    fixture.world.fingerprint == repeated.world.fingerprint &&
        fixture.history.fingerprint == repeated.history.fingerprint &&
        fixture.households.fingerprint == repeated.households.fingerprint,
    'Cùng seed và cấu hình phải sinh cùng bản đồ, lịch sử và hộ.',
  );
  _expect(
    fixture.world.fingerprint != other.world.fingerprint ||
        fixture.history.fingerprint != other.history.fingerprint,
    'Seed khác phải đổi bản đồ hoặc lịch sử.',
  );

  final Simulation continuous = _scheduled(fixture)
    ..advanceTo(_historyCompletion);
  final Simulation savePath = _scheduled(fixture)..advanceTo(const SimTime(0));
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load giữa worldgen và lúc lịch sử hoàn tất phải giữ nguyên hash.',
  );
  restored.advanceTo(_historyCompletion);
  final Simulation replay = _scheduled(fixture)..advanceTo(_historyCompletion);

  _assertAwaitingWorld(continuous, fixture);
  _assertAwaitingWorld(restored, fixture);
  _assertAwaitingWorld(replay, fixture);

  final String selectedSiteId = _selectedBirthSite(continuous);
  _expect(
    _selectedBirthSite(restored) == selectedSiteId &&
        _selectedBirthSite(replay) == selectedSiteId,
    'Ba đường phải đề xuất cùng một nơi sinh tốt nhất.',
  );
  _chooseBirth(continuous, selectedSiteId);
  _chooseBirth(restored, selectedSiteId);
  _chooseBirth(replay, selectedSiteId);

  final String finalHash = continuous.state.semanticHash();
  if (restored.state.semanticHash() != finalHash) {
    _printStructuralDifference(
      continuous.state.toJson(),
      restored.state.toJson(),
      r'$world',
    );
  }
  _expect(
    restored.state.semanticHash() == finalHash &&
        replay.state.semanticHash() == finalHash,
    'Chạy liền, save/load và replay phải có cùng snapshot cuối: '
    'continuous=$finalHash restored=${restored.state.semanticHash()} '
    'replay=${replay.state.semanticHash()}.',
  );
  _expect(
    continuous.state.people['P00'] != null &&
        continuous.state.worldEntry?.born == true &&
        continuous.state.worldEntry?.selectedSiteId == selectedSiteId,
    'P00 chỉ được sinh sau khi người chơi chọn nơi hợp lệ.',
  );

  print('V5 small worldgen verification passed.');
  print(
    'Seed $_seed | ${fixture.history.totalYears} years | '
    '${fixture.history.epochs.length} epochs | '
    '${continuous.state.worldHistory!.anchors.length} anchors.',
  );
  print('Selected birth site: $selectedSiteId.');
  print('Semantic hash: $finalHash');
}

void _assertAwaitingWorld(Simulation simulation, _Fixture fixture) {
  final WorldHistoryState history = simulation.state.worldHistory!;
  final HistoricalLegacyState legacy = simulation.state.historicalLegacy!;
  _expect(
    simulation.state.worldGenesis?.generatorVersion.startsWith('v5.') == true &&
        history.complete &&
        history.totalYears >= 300 &&
        history.epochs.length == 3 &&
        history.macroStepCount == 192 &&
        history.anchors.length == 6 &&
        history.recentAnchors.length == 4,
    'Tiền sử phải phủ ít nhất 300 năm và chỉ giữ kho tóm tắt hữu hạn.',
  );
  _expect(
    legacy.historyFingerprint == fixture.history.fingerprint &&
        legacy.formulaVersion == environmentalHistoricalLegacyFormulaVersion &&
        legacy.naturalResourceAdjustments.length == 4 &&
        legacy.ecologyAdjustments.length == 5 &&
        legacy.settlementAdjustments.length == 4,
    'Legacy V5 phải có provenance và ledger cho nguồn, sinh thái, dân cư.',
  );
  _expect(
    legacy.naturalResourceAdjustments.every(
          (HistoricalNaturalResourceAdjustment value) =>
              value.afterQuantity >= 0,
        ) &&
        legacy.ecologyAdjustments.every(
          (HistoricalEcologyAdjustment value) =>
              value.afterPopulation >= 0 &&
              value.afterHealth >= 0 &&
              value.afterHealth <= 1000,
        ),
    'Hậu quả lịch sử không được tạo lượng âm hoặc chỉ số sai miền.',
  );
  _expect(
    legacy.naturalResourceAdjustments.any(
          (HistoricalNaturalResourceAdjustment value) =>
              value.beforeQuantity != value.afterQuantity,
        ) &&
        legacy.ecologyAdjustments.any(
          (HistoricalEcologyAdjustment value) =>
              value.beforePopulation != value.afterPopulation ||
              value.beforeHealth != value.afterHealth,
        ) &&
        legacy.settlementAdjustments.any(
          (HistoricalSettlementAdjustment value) =>
              value.beforeScore != value.afterScore,
        ),
    'Tiền sử phải để lại thay đổi thật lên nguồn, sinh thái và nơi ở.',
  );
  final List<WorldSite> assessedSites = simulation.state.sites.values
      .where((WorldSite site) => site.settlementAssessment != null)
      .toList();
  final List<WorldSite> selectedSettlements = assessedSites
      .where(
        (WorldSite site) =>
            site.settlementAssessment!.selectedForBirthHousehold,
      )
      .toList();
  _expect(
    assessedSites.length == 4 &&
        selectedSettlements.length == 2 &&
        selectedSettlements.every(
          (WorldSite site) => fixture.households.households.any(
            (GeneratedBirthHousehold household) => household.siteId == site.id,
          ),
        ),
    'Hai hộ sinh phải nằm đúng hai nơi được lịch sử chọn từ môi trường.',
  );
  _expect(
    simulation.state.worldEntry?.awaitingBirthSite == true &&
        simulation.state.people['P00'] == null,
    'P00 không được tồn tại trước lựa chọn nhập thế.',
  );
  final List<BirthSiteCandidate> candidates = simulation.birthSiteCandidates();
  final List<BirthSiteCandidate> feasible = candidates
      .where((BirthSiteCandidate value) => value.feasible)
      .toList();
  _expect(
    feasible.length == 2 &&
        feasible.every(
          (BirthSiteCandidate value) =>
              value.settlementScore != null &&
              value.settlementReasons.length == 7 &&
              value.householdId != null &&
              value.caregiverId != null,
        ),
    'Màn nhập thế phải có hai hoàn cảnh thật với lý do môi trường/lịch sử.',
  );
}

String _selectedBirthSite(Simulation simulation) {
  final List<BirthSiteCandidate> candidates =
      simulation
          .birthSiteCandidates()
          .where((BirthSiteCandidate value) => value.feasible)
          .toList()
        ..sort((BirthSiteCandidate a, BirthSiteCandidate b) {
          final int byScore = (b.settlementScore ?? 0).compareTo(
            a.settlementScore ?? 0,
          );
          return byScore != 0 ? byScore : a.siteId.compareTo(b.siteId);
        });
  if (candidates.isEmpty) throw StateError('Không có nơi sinh khả thi.');
  return candidates.first.siteId;
}

void _chooseBirth(Simulation simulation, String siteId) {
  final bool accepted = simulation.issue(
    ChooseBirthSiteCommand(id: 'v5-choose-birth', siteId: siteId),
  );
  _expect(accepted, 'Lệnh chọn nơi sinh phải được nhận đúng một lần.');
  simulation.advanceTo(simulation.state.now);
}

Simulation _scheduled(_Fixture fixture) {
  final WorldSite home = fixture.world.site('SITE-HOME');
  final WorldSite market = fixture.world.site('SITE-MARKET');
  final Simulation simulation = Simulation.fromSeed(fixture.world.rootSeed)
    ..materializeWorld(fixture.world)
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
    ..materializeBirthHouseholds(fixture.households, history: fixture.history)
    ..simulatePrehistory(
      fixture.history,
      applyLegacy: true,
      due: _historyCompletion,
    )
    ..openWorldEntry(due: _historyCompletion);
  return simulation;
}

_Fixture _fixture(int seed) {
  final GeneratedWorld world = WorldGenerator.generate(
    rootSeed: seed,
    includeTerrainProfile: true,
  );
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: seed,
    worldFingerprint: world.fingerprint,
  );
  final GeneratedBirthHouseholds households = BirthHouseholdGenerator.generate(
    world: world,
    history: history,
    includeFamilyMembers: true,
    includeFamilyMemory: true,
    includeFamilyCareNegotiation: true,
    includeFamilyCareSupport: true,
    includeFamilyCareResilience: true,
    includeFamilyCareBurden: true,
    includeFamilyCareConflict: true,
    includeFamilyCarePromise: true,
    includeFamilyCareReliability: true,
    includeFamilyCareWitnessMemory: true,
    includeInfantAttachmentLearning: true,
  );
  return _Fixture(world: world, history: history, households: households);
}

class _Fixture {
  const _Fixture({
    required this.world,
    required this.history,
    required this.households,
  });

  final GeneratedWorld world;
  final GeneratedWorldHistory history;
  final GeneratedBirthHouseholds households;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}

bool _printStructuralDifference(Object? left, Object? right, String path) {
  if (left is Map && right is Map) {
    final List<String> keys = <String>{
      ...left.keys.cast<String>(),
      ...right.keys.cast<String>(),
    }.toList()..sort();
    for (final String key in keys) {
      if (!left.containsKey(key) || !right.containsKey(key)) {
        print('Different key at $path.$key: ${left[key]} / ${right[key]}');
        return true;
      }
      if (_printStructuralDifference(left[key], right[key], '$path.$key')) {
        return true;
      }
    }
    return false;
  }
  if (left is List && right is List) {
    if (left.length != right.length) {
      print('Different list length at $path: ${left.length} / ${right.length}');
      return true;
    }
    for (int index = 0; index < left.length; index++) {
      if (_printStructuralDifference(
        left[index],
        right[index],
        '$path[$index]',
      )) {
        return true;
      }
    }
    return false;
  }
  if (left != right) {
    print('Different value at $path: $left / $right');
    return true;
  }
  return false;
}
