import 'dart:convert';

import 'world_generation.dart';

const String worldHistoryGeneratorVersion = 'v2.17.0';

enum WorldHistoryStatus { simulating, complete }

/// Các đại lượng vùng được truyền từ epoch trước sang epoch sau.
class HistoricalMetrics {
  const HistoricalMetrics({
    required this.populationEstimate,
    required this.householdEstimate,
    required this.cultivatedLandMu,
    required this.tradeReach,
    required this.resourcePressure,
  });

  const HistoricalMetrics.initial()
    : populationEstimate = 24,
      householdEstimate = 5,
      cultivatedLandMu = 2,
      tradeReach = 0,
      resourcePressure = 80;

  final int populationEstimate;
  final int householdEstimate;
  final int cultivatedLandMu;

  /// Chỉ số fixture 0–1000, chưa phải đơn vị kinh tế đã duyệt.
  final int tradeReach;

  /// Chỉ số fixture 0–1000, cao hơn nghĩa là tài nguyên chịu sức ép lớn hơn.
  final int resourcePressure;

  HistoricalMetrics apply(HistoricalEffect effect) {
    final int population = (populationEstimate + effect.populationDelta).clamp(
      1,
      1000000000,
    );
    return HistoricalMetrics(
      populationEstimate: population,
      householdEstimate: (population ~/ 5).clamp(1, 200000000),
      cultivatedLandMu: (cultivatedLandMu + effect.cultivatedLandDelta).clamp(
        0,
        1000000000,
      ),
      tradeReach: (tradeReach + effect.tradeReachDelta).clamp(0, 1000),
      resourcePressure: (resourcePressure + effect.resourcePressureDelta).clamp(
        0,
        1000,
      ),
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'population_estimate': populationEstimate,
    'household_estimate': householdEstimate,
    'cultivated_land_mu': cultivatedLandMu,
    'trade_reach': tradeReach,
    'resource_pressure': resourcePressure,
  };

  factory HistoricalMetrics.fromJson(Map<String, Object?> json) =>
      HistoricalMetrics(
        populationEstimate: json['population_estimate']! as int,
        householdEstimate: json['household_estimate']! as int,
        cultivatedLandMu: json['cultivated_land_mu']! as int,
        tradeReach: json['trade_reach']! as int,
        resourcePressure: json['resource_pressure']! as int,
      );
}

class HistoricalEffect {
  const HistoricalEffect({
    this.populationDelta = 0,
    this.cultivatedLandDelta = 0,
    this.tradeReachDelta = 0,
    this.resourcePressureDelta = 0,
  });

  final int populationDelta;
  final int cultivatedLandDelta;
  final int tradeReachDelta;
  final int resourcePressureDelta;

  Map<String, Object> toJson() => <String, Object>{
    'population_delta': populationDelta,
    'cultivated_land_delta': cultivatedLandDelta,
    'trade_reach_delta': tradeReachDelta,
    'resource_pressure_delta': resourcePressureDelta,
  };

  factory HistoricalEffect.fromJson(Map<String, Object?> json) =>
      HistoricalEffect(
        populationDelta: json['population_delta']! as int,
        cultivatedLandDelta: json['cultivated_land_delta']! as int,
        tradeReachDelta: json['trade_reach_delta']! as int,
        resourcePressureDelta: json['resource_pressure_delta']! as int,
      );
}

/// Biến cố không được compact vì nó giải thích một phần snapshot hiện tại.
class HistoricalAnchor {
  const HistoricalAnchor({
    required this.id,
    required this.kind,
    required this.subjectId,
    required this.yearsBeforePresent,
    required this.summary,
    required this.effect,
  });

  final String id;
  final String kind;
  final String subjectId;
  final int yearsBeforePresent;
  final String summary;
  final HistoricalEffect effect;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'kind': kind,
    'subject_id': subjectId,
    'years_before_present': yearsBeforePresent,
    'summary': summary,
    'effect': effect.toJson(),
  };

  factory HistoricalAnchor.fromJson(Map<String, Object?> json) =>
      HistoricalAnchor(
        id: json['id']! as String,
        kind: json['kind']! as String,
        subjectId: json['subject_id']! as String,
        yearsBeforePresent: json['years_before_present']! as int,
        summary: json['summary']! as String,
        effect: HistoricalEffect.fromJson(
          (json['effect']! as Map).cast<String, Object?>(),
        ),
      );
}

class HistoricalEpochResult {
  const HistoricalEpochResult({
    required this.index,
    required this.id,
    required this.name,
    required this.startYearsBeforePresent,
    required this.endYearsBeforePresent,
    required this.macroStepCount,
    required this.metricsAfter,
    required this.anchors,
  });

  final int index;
  final String id;
  final String name;
  final int startYearsBeforePresent;
  final int endYearsBeforePresent;
  final int macroStepCount;
  final HistoricalMetrics metricsAfter;
  final List<HistoricalAnchor> anchors;

  int get durationYears => startYearsBeforePresent - endYearsBeforePresent;

  Map<String, Object> toJson() => <String, Object>{
    'index': index,
    'id': id,
    'name': name,
    'start_years_before_present': startYearsBeforePresent,
    'end_years_before_present': endYearsBeforePresent,
    'macro_step_count': macroStepCount,
    'metrics_after': metricsAfter.toJson(),
    'anchors': anchors.map((HistoricalAnchor value) => value.toJson()).toList(),
  };

  factory HistoricalEpochResult.fromJson(Map<String, Object?> json) =>
      HistoricalEpochResult(
        index: json['index']! as int,
        id: json['id']! as String,
        name: json['name']! as String,
        startYearsBeforePresent: json['start_years_before_present']! as int,
        endYearsBeforePresent: json['end_years_before_present']! as int,
        macroStepCount: json['macro_step_count']! as int,
        metricsAfter: HistoricalMetrics.fromJson(
          (json['metrics_after']! as Map).cast<String, Object?>(),
        ),
        anchors: <HistoricalAnchor>[
          for (final Object? value in json['anchors']! as List<Object?>)
            HistoricalAnchor.fromJson((value! as Map).cast<String, Object?>()),
        ],
      );
}

class GeneratedWorldHistory {
  const GeneratedWorldHistory({
    required this.rootSeed,
    required this.worldFingerprint,
    required this.generatorVersion,
    required this.totalYears,
    required this.epochs,
    required this.fingerprint,
  });

  final int rootSeed;
  final String worldFingerprint;
  final String generatorVersion;
  final int totalYears;
  final List<HistoricalEpochResult> epochs;
  final String fingerprint;
}

class WorldHistoryState {
  const WorldHistoryState({
    required this.rootSeed,
    required this.worldFingerprint,
    required this.generatorVersion,
    required this.totalYears,
    required this.expectedEpochCount,
    required this.planFingerprint,
    required this.status,
    required this.epochs,
  });

  factory WorldHistoryState.started(GeneratedWorldHistory generated) =>
      WorldHistoryState(
        rootSeed: generated.rootSeed,
        worldFingerprint: generated.worldFingerprint,
        generatorVersion: generated.generatorVersion,
        totalYears: generated.totalYears,
        expectedEpochCount: generated.epochs.length,
        planFingerprint: generated.fingerprint,
        status: WorldHistoryStatus.simulating,
        epochs: const <HistoricalEpochResult>[],
      );

  final int rootSeed;
  final String worldFingerprint;
  final String generatorVersion;
  final int totalYears;
  final int expectedEpochCount;
  final String planFingerprint;
  final WorldHistoryStatus status;
  final List<HistoricalEpochResult> epochs;

  bool get complete => status == WorldHistoryStatus.complete;

  List<HistoricalAnchor> get anchors => <HistoricalAnchor>[
    for (final HistoricalEpochResult epoch in epochs) ...epoch.anchors,
  ];

  HistoricalMetrics? get currentMetrics =>
      epochs.isEmpty ? null : epochs.last.metricsAfter;

  WorldHistoryState applyEpoch(HistoricalEpochResult epoch) {
    if (complete) throw StateError('Completed history cannot accept an epoch.');
    if (epoch.index != epochs.length) {
      throw StateError('Historical epoch index is not contiguous.');
    }
    final int expectedStart = epochs.isEmpty
        ? totalYears
        : epochs.last.endYearsBeforePresent;
    if (epoch.startYearsBeforePresent != expectedStart ||
        epoch.endYearsBeforePresent < 0 ||
        epoch.endYearsBeforePresent >= epoch.startYearsBeforePresent ||
        epoch.macroStepCount <= 0) {
      throw StateError('Historical epoch boundaries are invalid.');
    }
    final Set<String> existingAnchorIds = anchors
        .map((HistoricalAnchor value) => value.id)
        .toSet();
    for (final HistoricalAnchor anchor in epoch.anchors) {
      if (existingAnchorIds.contains(anchor.id) ||
          anchor.yearsBeforePresent > epoch.startYearsBeforePresent ||
          anchor.yearsBeforePresent < epoch.endYearsBeforePresent) {
        throw StateError('Historical anchor is invalid: ${anchor.id}.');
      }
    }
    return WorldHistoryState(
      rootSeed: rootSeed,
      worldFingerprint: worldFingerprint,
      generatorVersion: generatorVersion,
      totalYears: totalYears,
      expectedEpochCount: expectedEpochCount,
      planFingerprint: planFingerprint,
      status: status,
      epochs: List<HistoricalEpochResult>.unmodifiable(<HistoricalEpochResult>[
        ...epochs,
        epoch,
      ]),
    );
  }

  WorldHistoryState markComplete() {
    if (epochs.length != expectedEpochCount ||
        epochs.isEmpty ||
        epochs.last.endYearsBeforePresent != 0) {
      throw StateError('Historical epochs have not reached the present.');
    }
    final String actualFingerprint = WorldHistoryGenerator.fingerprintOf(
      rootSeed: rootSeed,
      worldFingerprint: worldFingerprint,
      generatorVersion: generatorVersion,
      totalYears: totalYears,
      epochs: epochs,
    );
    if (actualFingerprint != planFingerprint) {
      throw StateError('World history fingerprint does not match its plan.');
    }
    return WorldHistoryState(
      rootSeed: rootSeed,
      worldFingerprint: worldFingerprint,
      generatorVersion: generatorVersion,
      totalYears: totalYears,
      expectedEpochCount: expectedEpochCount,
      planFingerprint: planFingerprint,
      status: WorldHistoryStatus.complete,
      epochs: epochs,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'root_seed': rootSeed,
    'world_fingerprint': worldFingerprint,
    'generator_version': generatorVersion,
    'total_years': totalYears,
    'expected_epoch_count': expectedEpochCount,
    'plan_fingerprint': planFingerprint,
    'status': status.name,
    'epochs': epochs
        .map((HistoricalEpochResult value) => value.toJson())
        .toList(),
  };

  factory WorldHistoryState.fromJson(Map<String, Object?> json) =>
      WorldHistoryState(
        rootSeed: json['root_seed']! as int,
        worldFingerprint: json['world_fingerprint']! as String,
        generatorVersion: json['generator_version']! as String,
        totalYears: json['total_years']! as int,
        expectedEpochCount: json['expected_epoch_count']! as int,
        planFingerprint: json['plan_fingerprint']! as String,
        status: WorldHistoryStatus.values.byName(json['status']! as String),
        epochs: <HistoricalEpochResult>[
          for (final Object? value in json['epochs']! as List<Object?>)
            HistoricalEpochResult.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
      );
}

/// Sinh và chạy lịch sử vùng bằng các bước vĩ mô xác định từ seed.
class WorldHistoryGenerator {
  static GeneratedWorldHistory generate({
    required int rootSeed,
    required String worldFingerprint,
  }) {
    if (rootSeed < minimumWorldSeed || rootSeed > maximumWorldSeed) {
      throw RangeError.range(
        rootSeed,
        minimumWorldSeed,
        maximumWorldSeed,
        'rootSeed',
      );
    }
    final _HistoryStream stream = _HistoryStream(rootSeed);
    final int ageTier = stream.nextInt(3);
    final int totalYears = switch (ageTier) {
      0 => 300 + stream.nextInt(701),
      1 => 1000 + stream.nextInt(9000),
      _ => 10000 + stream.nextInt(20001),
    };
    final int firstEnd = totalYears * 64 ~/ 100;
    final int secondEnd = totalYears * 18 ~/ 100;
    HistoricalMetrics metrics = const HistoricalMetrics.initial();
    final List<HistoricalEpochResult> epochs = <HistoricalEpochResult>[];

    final List<_AnchorPlan> founding = <_AnchorPlan>[
      _AnchorPlan(
        id: 'ANCHOR-HOME-FOUNDED',
        kind: 'settlement_founded',
        subjectId: 'SITE-HOME',
        step: 9 + stream.nextInt(12),
        summary: 'Nhóm cư dân đầu tiên lập nơi ở bền vững ven suối.',
        effect: HistoricalEffect(
          populationDelta: 18 + stream.nextInt(18),
          cultivatedLandDelta: 3 + stream.nextInt(5),
          resourcePressureDelta: 20 + stream.nextInt(25),
        ),
      ),
      _AnchorPlan(
        id: 'ANCHOR-FIELD-OPENED',
        kind: 'fields_expanded',
        subjectId: 'SITE-FIELD',
        step: 34 + stream.nextInt(18),
        summary: 'Các hộ khai khẩn vùng đất bằng thành đồng canh tác.',
        effect: HistoricalEffect(
          cultivatedLandDelta: 12 + stream.nextInt(12),
          resourcePressureDelta: -(15 + stream.nextInt(20)),
        ),
      ),
    ];
    final HistoricalEpochResult first = _simulateEpoch(
      index: 0,
      id: 'EPOCH-FOUNDING',
      name: 'Định cư sơ kỳ',
      startYears: totalYears,
      endYears: firstEnd,
      metricsBefore: metrics,
      anchorPlans: founding,
      stream: stream,
    );
    epochs.add(first);
    metrics = first.metricsAfter;

    final List<_AnchorPlan> expansion = <_AnchorPlan>[
      _AnchorPlan(
        id: 'ANCHOR-RIVER-FLOOD',
        kind: 'river_flood',
        subjectId: 'SITE-RIVER',
        step: 12 + stream.nextInt(18),
        summary: 'Một trận lũ lớn đổi bãi bồi và buộc nhiều hộ dời chỗ.',
        effect: HistoricalEffect(
          populationDelta: -(4 + stream.nextInt(12)),
          cultivatedLandDelta: -(2 + stream.nextInt(5)),
          resourcePressureDelta: 70 + stream.nextInt(70),
        ),
      ),
      _AnchorPlan(
        id: 'ANCHOR-MARKET-FOUNDED',
        kind: 'market_founded',
        subjectId: 'SITE-MARKET',
        step: 38 + stream.nextInt(16),
        summary:
            'Chợ An Khê thành điểm trao đổi thường kỳ của các hộ trong vùng.',
        effect: HistoricalEffect(
          populationDelta: 10 + stream.nextInt(20),
          tradeReachDelta: 170 + stream.nextInt(100),
          resourcePressureDelta: -(20 + stream.nextInt(35)),
        ),
      ),
    ];
    final HistoricalEpochResult second = _simulateEpoch(
      index: 1,
      id: 'EPOCH-EXPANSION',
      name: 'Mở đất và lập chợ',
      startYears: firstEnd,
      endYears: secondEnd,
      metricsBefore: metrics,
      anchorPlans: expansion,
      stream: stream,
    );
    epochs.add(second);
    metrics = second.metricsAfter;

    final List<_AnchorPlan> recent = <_AnchorPlan>[
      _AnchorPlan(
        id: 'ANCHOR-PASS-OPENED',
        kind: 'mountain_pass_opened',
        subjectId: 'SITE-PASS',
        step: 10 + stream.nextInt(16),
        summary: 'Đường qua chân đèo được duy trì thành lối đi ổn định.',
        effect: HistoricalEffect(
          tradeReachDelta: 110 + stream.nextInt(80),
          resourcePressureDelta: 15 + stream.nextInt(25),
        ),
      ),
      _AnchorPlan(
        id: 'ANCHOR-ROUTE-ESTABLISHED',
        kind: 'trade_route_established',
        subjectId: 'RT-ANKHE',
        step: 42 + stream.nextInt(14),
        summary: 'Tuyến chợ hiện nay hình thành từ các lối đi cũ trong vùng.',
        effect: HistoricalEffect(
          populationDelta: 8 + stream.nextInt(16),
          tradeReachDelta: 130 + stream.nextInt(80),
          resourcePressureDelta: -(10 + stream.nextInt(25)),
        ),
      ),
    ];
    final HistoricalEpochResult third = _simulateEpoch(
      index: 2,
      id: 'EPOCH-RECENT',
      name: 'Cận thế',
      startYears: secondEnd,
      endYears: 0,
      metricsBefore: metrics,
      anchorPlans: recent,
      stream: stream,
    );
    epochs.add(third);

    final String fingerprint = fingerprintOf(
      rootSeed: rootSeed,
      worldFingerprint: worldFingerprint,
      generatorVersion: worldHistoryGeneratorVersion,
      totalYears: totalYears,
      epochs: epochs,
    );
    return GeneratedWorldHistory(
      rootSeed: rootSeed,
      worldFingerprint: worldFingerprint,
      generatorVersion: worldHistoryGeneratorVersion,
      totalYears: totalYears,
      epochs: List<HistoricalEpochResult>.unmodifiable(epochs),
      fingerprint: fingerprint,
    );
  }

  static String fingerprintOf({
    required int rootSeed,
    required String worldFingerprint,
    required String generatorVersion,
    required int totalYears,
    required List<HistoricalEpochResult> epochs,
  }) {
    final String source = jsonEncode(<String, Object>{
      'root_seed': rootSeed,
      'world_fingerprint': worldFingerprint,
      'generator_version': generatorVersion,
      'total_years': totalYears,
      'epochs': epochs
          .map((HistoricalEpochResult value) => value.toJson())
          .toList(),
    });
    return _fnv1a64(source);
  }

  static HistoricalEpochResult _simulateEpoch({
    required int index,
    required String id,
    required String name,
    required int startYears,
    required int endYears,
    required HistoricalMetrics metricsBefore,
    required List<_AnchorPlan> anchorPlans,
    required _HistoryStream stream,
  }) {
    const int stepCount = 64;
    HistoricalMetrics metrics = metricsBefore;
    final List<HistoricalAnchor> anchors = <HistoricalAnchor>[];
    for (int step = 0; step < stepCount; step++) {
      final int populationRoll = stream.nextInt(10);
      final int organicGrowth = switch (populationRoll) {
        0 => -(metrics.populationEstimate ~/ 100).clamp(1, 1000000),
        <= 5 => (metrics.populationEstimate * (1 + stream.nextInt(4)) ~/ 1000)
            .clamp(1, 1000000),
        _ => 0,
      };
      final int cultivation = stream.nextInt(3) == 0 ? 1 : 0;
      final int pressureDrift = organicGrowth > cultivation ? 2 : -1;
      metrics = metrics.apply(
        HistoricalEffect(
          populationDelta: organicGrowth,
          cultivatedLandDelta: cultivation,
          tradeReachDelta: stream.nextInt(4),
          resourcePressureDelta: pressureDrift,
        ),
      );
      for (final _AnchorPlan plan in anchorPlans.where(
        (_AnchorPlan value) => value.step == step,
      )) {
        metrics = metrics.apply(plan.effect);
        final int year =
            startYears - ((startYears - endYears) * (step + 1) ~/ stepCount);
        anchors.add(
          HistoricalAnchor(
            id: plan.id,
            kind: plan.kind,
            subjectId: plan.subjectId,
            yearsBeforePresent: year,
            summary: plan.summary,
            effect: plan.effect,
          ),
        );
      }
    }
    anchors.sort(
      (HistoricalAnchor a, HistoricalAnchor b) =>
          b.yearsBeforePresent.compareTo(a.yearsBeforePresent),
    );
    return HistoricalEpochResult(
      index: index,
      id: id,
      name: name,
      startYearsBeforePresent: startYears,
      endYearsBeforePresent: endYears,
      macroStepCount: stepCount,
      metricsAfter: metrics,
      anchors: List<HistoricalAnchor>.unmodifiable(anchors),
    );
  }
}

class _AnchorPlan {
  const _AnchorPlan({
    required this.id,
    required this.kind,
    required this.subjectId,
    required this.step,
    required this.summary,
    required this.effect,
  });

  final String id;
  final String kind;
  final String subjectId;
  final int step;
  final String summary;
  final HistoricalEffect effect;
}

class _HistoryStream {
  _HistoryStream(int rootSeed)
    : _state = (rootSeed * 48271 + 104729) % _modulus {
    if (_state == 0) _state = 1;
  }

  static const int _modulus = 2147483647;
  int _state;

  int nextInt(int upperBound) {
    if (upperBound <= 0) throw ArgumentError.value(upperBound, 'upperBound');
    _state = _state * 48271 % _modulus;
    return _state % upperBound;
  }
}

String _fnv1a64(String input) {
  final BigInt mask = (BigInt.one << 64) - BigInt.one;
  BigInt hash = BigInt.parse('cbf29ce484222325', radix: 16);
  final BigInt prime = BigInt.parse('100000001b3', radix: 16);
  for (final int byte in utf8.encode(input)) {
    hash ^= BigInt.from(byte);
    hash = (hash * prime) & mask;
  }
  return hash.toRadixString(16).padLeft(16, '0');
}
