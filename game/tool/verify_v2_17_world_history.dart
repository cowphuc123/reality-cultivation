import 'dart:convert';

import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.17: lịch sử vĩ mô chạy hết trước khi P00 được phép nhập thế.
void main() {
  final GeneratedWorld generated = WorldGenerator.generate(rootSeed: 20260907);
  final GeneratedWorldHistory first = WorldHistoryGenerator.generate(
    rootSeed: generated.rootSeed,
    worldFingerprint: generated.fingerprint,
  );
  final GeneratedWorldHistory repeated = WorldHistoryGenerator.generate(
    rootSeed: generated.rootSeed,
    worldFingerprint: generated.fingerprint,
  );
  final GeneratedWorld otherWorld = WorldGenerator.generate(rootSeed: 20260908);
  final GeneratedWorldHistory other = WorldHistoryGenerator.generate(
    rootSeed: otherWorld.rootSeed,
    worldFingerprint: otherWorld.fingerprint,
  );

  _expect(
    first.fingerprint == repeated.fingerprint &&
        first.totalYears == repeated.totalYears &&
        jsonEncode(
              first.epochs
                  .map((HistoricalEpochResult e) => e.toJson())
                  .toList(),
            ) ==
            jsonEncode(
              repeated.epochs
                  .map((HistoricalEpochResult e) => e.toJson())
                  .toList(),
            ),
    'Cùng seed và bản đồ phải sinh cùng một lịch sử.',
  );
  _expect(
    first.fingerprint != other.fingerprint ||
        first.totalYears != other.totalYears,
    'Seed khác phải làm thay đổi tuổi hoặc nội dung lịch sử.',
  );
  _expect(
    first.totalYears >= 300 && first.totalYears <= 30000,
    'Tuổi lịch sử phải thuộc miền vài trăm tới vài vạn năm.',
  );
  final List<int> tierYears = <int>[
    for (final int seed in <int>[1, 20, 8])
      WorldHistoryGenerator.generate(
        rootSeed: seed,
        worldFingerprint: WorldGenerator.generate(rootSeed: seed).fingerprint,
      ).totalYears,
  ];
  _expect(
    tierYears[0] < 1000 &&
        tierYears[1] >= 1000 &&
        tierYears[1] < 10000 &&
        tierYears[2] >= 10000,
    'Seed phải thật sự phủ được lịch sử hàng trăm, hàng nghìn và hàng vạn năm.',
  );
  _expect(first.epochs.length == 3, 'Fixture phải có ba epoch nối tiếp.');
  _expect(
    first.epochs.first.startYearsBeforePresent == first.totalYears &&
        first.epochs.last.endYearsBeforePresent == 0 &&
        first.epochs[0].endYearsBeforePresent ==
            first.epochs[1].startYearsBeforePresent &&
        first.epochs[1].endYearsBeforePresent ==
            first.epochs[2].startYearsBeforePresent,
    'Epoch phải phủ liên tục từ đầu lịch sử tới hiện tại.',
  );
  _expect(
    first.epochs.every(
      (HistoricalEpochResult epoch) => epoch.macroStepCount == 64,
    ),
    'Mỗi epoch phải thật sự chạy 64 bước vĩ mô.',
  );
  final List<HistoricalAnchor> anchors = <HistoricalAnchor>[
    for (final HistoricalEpochResult epoch in first.epochs) ...epoch.anchors,
  ];
  _expect(anchors.length == 6, 'Sáu biến cố neo phải được giữ lại.');
  _expect(
    anchors
        .map((HistoricalAnchor anchor) => anchor.subjectId)
        .toSet()
        .containsAll(<String>{
          'SITE-HOME',
          'SITE-FIELD',
          'SITE-RIVER',
          'SITE-MARKET',
          'SITE-PASS',
          'RT-ANKHE',
        }),
    'Mốc lịch sử phải giải thích các địa điểm và tuyến hiện tại.',
  );
  _expect(
    anchors
            .singleWhere((HistoricalAnchor a) => a.kind == 'river_flood')
            .effect
            .populationDelta <
        0,
    'Lũ phải có tổn thất dân số thật trong phép chuyển trạng thái.',
  );
  _expect(
    first.epochs.last.metricsAfter.populationEstimate >
            const HistoricalMetrics.initial().populationEstimate &&
        first.epochs.last.metricsAfter.tradeReach > 0,
    'Các epoch phải truyền và thay đổi đại lượng vùng tích lũy.',
  );

  final Simulation simulation = _preparedWorld(
    generated: generated,
    history: first,
    historyBeforeEntry: true,
  );
  final WorldHistoryState history = simulation.state.worldHistory!;
  _expect(history.complete, 'Lịch sử phải hoàn tất trong snapshot hiện tại.');
  _expect(
    history.epochs.length == 3 && history.anchors.length == 6,
    'WorldState phải giữ đủ epoch và biến cố neo.',
  );
  _expect(
    simulation.state.people['P00'] == null &&
        simulation.state.worldEntry?.awaitingBirthSite == true,
    'P00 chưa tồn tại dù tiền sử đã hoàn tất và màn chọn đã mở.',
  );
  final int completedIndex = simulation.state.facts.indexWhere(
    (WorldFact fact) => fact.kind == 'world_history_completed',
  );
  final int entryIndex = simulation.state.facts.indexWhere(
    (WorldFact fact) => fact.kind == 'world_entry_opened',
  );
  _expect(
    completedIndex >= 0 && entryIndex > completedIndex,
    'Tiền sử phải hoàn tất trước khi mở nhập thế.',
  );
  final String hash = simulation.state.semanticHash();
  final Simulation restored = Simulation.fromSave(simulation.state.save());
  _expect(
    restored.state.semanticHash() == hash &&
        restored.state.worldHistory?.planFingerprint == first.fingerprint &&
        restored.state.worldHistory?.complete == true,
    'Save/load phải giữ nguyên lịch sử và hash.',
  );

  bool earlyEntryRejected = false;
  try {
    _preparedWorld(
      generated: generated,
      history: first,
      historyBeforeEntry: false,
    );
  } on StateError {
    earlyEntryRejected = true;
  }
  _expect(
    earlyEntryRejected,
    'Nhập thế được xếp trước lịch sử phải bị từ chối.',
  );

  final Simulation wrongMap = Simulation.fromSeed(generated.rootSeed)
    ..materializeWorld(generated);
  final GeneratedWorldHistory mismatched = WorldHistoryGenerator.generate(
    rootSeed: generated.rootSeed,
    worldFingerprint: '0000000000000000',
  );
  bool wrongMapRejected = false;
  try {
    wrongMap.simulatePrehistory(mismatched);
  } on StateError {
    wrongMapRejected = true;
  }
  _expect(
    wrongMapRejected &&
        wrongMap.state.pendingEvents.every(
          (ScheduledEvent event) => !event.kind.contains('history'),
        ),
    'Sai fingerprint bản đồ phải bị chặn trước khi xếp sự kiện lịch sử.',
  );

  final GeneratedWorldHistory forged = GeneratedWorldHistory(
    rootSeed: first.rootSeed,
    worldFingerprint: first.worldFingerprint,
    generatorVersion: first.generatorVersion,
    totalYears: first.totalYears,
    epochs: first.epochs,
    fingerprint: '0000000000000000',
  );
  final Simulation forgedSimulation = Simulation.fromSeed(generated.rootSeed)
    ..materializeWorld(generated);
  bool forgedRejected = false;
  try {
    forgedSimulation.simulatePrehistory(forged);
  } on StateError {
    forgedRejected = true;
  }
  _expect(
    forgedRejected &&
        forgedSimulation.state.pendingEvents.every(
          (ScheduledEvent event) => !event.kind.contains('history'),
        ),
    'Fingerprint kế hoạch giả phải bị chặn trước khi ghi một phần.',
  );

  final Simulation missingPresentSubject =
      Simulation.fromSeed(generated.rootSeed)
        ..materializeWorld(generated)
        ..simulatePrehistory(first);
  bool missingSubjectRejected = false;
  try {
    missingPresentSubject.advanceTo(const SimTime(0));
  } on StateError {
    missingSubjectRejected = true;
  }
  _expect(
    missingSubjectRejected,
    'Anchor không được trỏ tới thực thể vắng khỏi snapshot hiện tại.',
  );

  bool duplicateRejected = false;
  try {
    simulation.simulatePrehistory(first);
  } on StateError {
    duplicateRejected = true;
  }
  _expect(duplicateRejected, 'Không được chạy tiền sử hai lần.');

  print('V2.17 world history verification passed.');
  print('World hash: $hash');
  print(
    'Seed ${first.rootSeed}: ${first.totalYears} years, '
    '${first.epochs.length} epochs, ${anchors.length} anchors, '
    'fingerprint ${first.fingerprint}.',
  );
  final HistoricalMetrics finalMetrics = first.epochs.last.metricsAfter;
  print(
    'Present regional metrics: population ${finalMetrics.populationEstimate}, '
    'households ${finalMetrics.householdEstimate}, '
    'land ${finalMetrics.cultivatedLandMu}, trade ${finalMetrics.tradeReach}, '
    'pressure ${finalMetrics.resourcePressure}.',
  );
  for (final HistoricalAnchor anchor in anchors) {
    print(
      '${anchor.yearsBeforePresent} BP | ${anchor.kind} | '
      '${anchor.subjectId} | ${anchor.effect.toJson()}',
    );
  }
}

Simulation _preparedWorld({
  required GeneratedWorld generated,
  required GeneratedWorldHistory history,
  required bool historyBeforeEntry,
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
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': 'I-FEED-01',
        'kind': 'infant_feed',
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': 1000,
        'owner_household_id': 'H01',
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H01',
        'name': 'Hộ ven suối',
        'member_ids': <String>['N01'],
        'resource_item_ids': <String, String>{'infant_feed': 'I-FEED-01'},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-FEED-01': <String>['N01'],
        },
        'scheduled_work_seconds_by_person': <String, int>{},
        'meal_actor_id': 'N01',
      },
    );
  if (historyBeforeEntry) {
    simulation
      ..simulatePrehistory(history)
      ..openWorldEntry();
  } else {
    simulation
      ..openWorldEntry()
      ..simulatePrehistory(history);
  }
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
