enum ChildDevelopmentStage {
  settlingAfterNewborn('settling_after_newborn', 'Qua tháng sơ sinh'),
  mobileInfancy('mobile_infancy', 'Học tự di chuyển'),
  toddler('toddler', 'Chập chững'),
  earlyChildhood('early_childhood', 'Tuổi thơ sớm'),
  middleChildhood('middle_childhood', 'Tuổi thơ giữa');

  const ChildDevelopmentStage(this.code, this.label);
  final String code;
  final String label;

  static ChildDevelopmentStage forAgeDays(int ageDays) {
    if (ageDays < 180) return settlingAfterNewborn;
    if (ageDays < 365) return mobileInfancy;
    if (ageDays < 1095) return toddler;
    if (ageDays < 2190) return earlyChildhood;
    return middleChildhood;
  }
}

enum ChildIntent {
  observe('observe', 'Quan sát người và vật gần mình'),
  vocalize('vocalize', 'Thử phát âm đáp lại'),
  practiceReach('practice_reach', 'Tập với và giữ vật'),
  floorPlay('floor_play', 'Chơi vận động trên nền');

  const ChildIntent(this.code, this.label);
  final String code;
  final String label;

  int get durationSeconds => switch (this) {
    ChildIntent.observe => 300,
    ChildIntent.vocalize => 300,
    ChildIntent.practiceReach => 900,
    ChildIntent.floorPlay => 1800,
  };
}

class ChildBodyState {
  const ChildBodyState({
    required this.massGrams,
    required this.expectedMassGrams,
    required this.nutrition,
    required this.hydration,
    required this.totalFoodGrams,
    required this.totalWaterMl,
    required this.supportedGrowthDays,
    required this.constrainedGrowthDays,
    required this.lastFoodGrams,
    required this.lastWaterMl,
    required this.lastGrowthGrams,
  });

  const ChildBodyState.fallback()
    : massGrams = 4300,
      expectedMassGrams = 4300,
      nutrition = 800,
      hydration = 800,
      totalFoodGrams = 0,
      totalWaterMl = 0,
      supportedGrowthDays = 0,
      constrainedGrowthDays = 0,
      lastFoodGrams = 0,
      lastWaterMl = 0,
      lastGrowthGrams = 0;

  final int massGrams;
  final int expectedMassGrams;
  final int nutrition;
  final int hydration;
  final int totalFoodGrams;
  final int totalWaterMl;
  final int supportedGrowthDays;
  final int constrainedGrowthDays;
  final int lastFoodGrams;
  final int lastWaterMl;
  final int lastGrowthGrams;

  int get condition => (nutrition * 2 + hydration) ~/ 3;
  int get massRatio => expectedMassGrams <= 0
      ? 1000
      : (massGrams * 1000 ~/ expectedMassGrams).clamp(0, 1200);
  int get developmentSupport =>
      ((condition * 3 + massRatio) ~/ 4).clamp(0, 1000);

  static int foodNeedGrams(int ageDays) => (180 + ageDays ~/ 8).clamp(180, 450);

  static int waterNeedMl(int ageDays) => (600 + ageDays ~/ 2).clamp(600, 1600);

  static int expectedGrowthGrams(int ageDays) => ageDays < 365
      ? 12
      : ageDays < 1095
      ? 7
      : 5;

  ChildBodyState advanceDay({
    required int ageDays,
    required int foodGrams,
    required int waterMl,
  }) {
    final int foodNeed = foodNeedGrams(ageDays);
    final int waterNeed = waterNeedMl(ageDays);
    final int foodFulfillment = (foodGrams * 1000 ~/ foodNeed).clamp(0, 1000);
    final int waterFulfillment = (waterMl * 1000 ~/ waterNeed).clamp(0, 1000);
    final int nextNutrition = ((nutrition * 3 + foodFulfillment) ~/ 4).clamp(
      0,
      1000,
    );
    final int nextHydration = ((hydration * 2 + waterFulfillment) ~/ 3).clamp(
      0,
      1000,
    );
    final int expectedGrowth = expectedGrowthGrams(ageDays);
    final int support = (nextNutrition * 2 + nextHydration) ~/ 3;
    final int actualGrowth = expectedGrowth * support ~/ 1000;
    return ChildBodyState(
      massGrams: massGrams + actualGrowth,
      expectedMassGrams: expectedMassGrams + expectedGrowth,
      nutrition: nextNutrition,
      hydration: nextHydration,
      totalFoodGrams: totalFoodGrams + foodGrams,
      totalWaterMl: totalWaterMl + waterMl,
      supportedGrowthDays: supportedGrowthDays + (support >= 700 ? 1 : 0),
      constrainedGrowthDays: constrainedGrowthDays + (support < 700 ? 1 : 0),
      lastFoodGrams: foodGrams,
      lastWaterMl: waterMl,
      lastGrowthGrams: actualGrowth,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'mass_g': massGrams,
    'expected_mass_g': expectedMassGrams,
    'nutrition': nutrition,
    'hydration': hydration,
    'total_food_g': totalFoodGrams,
    'total_water_ml': totalWaterMl,
    'supported_growth_days': supportedGrowthDays,
    'constrained_growth_days': constrainedGrowthDays,
    'last_food_g': lastFoodGrams,
    'last_water_ml': lastWaterMl,
    'last_growth_g': lastGrowthGrams,
  };

  factory ChildBodyState.fromJson(Map<String, Object?> json) => ChildBodyState(
    massGrams: json['mass_g']! as int,
    expectedMassGrams: json['expected_mass_g']! as int,
    nutrition: json['nutrition']! as int,
    hydration: json['hydration']! as int,
    totalFoodGrams: json['total_food_g'] as int? ?? 0,
    totalWaterMl: json['total_water_ml'] as int? ?? 0,
    supportedGrowthDays: json['supported_growth_days'] as int? ?? 0,
    constrainedGrowthDays: json['constrained_growth_days'] as int? ?? 0,
    lastFoodGrams: json['last_food_g'] as int? ?? 0,
    lastWaterMl: json['last_water_ml'] as int? ?? 0,
    lastGrowthGrams: json['last_growth_g'] as int? ?? 0,
  );
}

class ChildHazardIncidentState {
  const ChildHazardIncidentState({
    required this.id,
    required this.kind,
    required this.detectedAtSeconds,
    required this.noticedBeforeHarm,
    required this.childReaction,
    required this.severity,
    required this.outcome,
    this.caregiverId,
    this.resolvedAtSeconds,
    this.securityChange = 0,
  });

  final String id;
  final String kind;
  final int detectedAtSeconds;
  final bool noticedBeforeHarm;
  final String childReaction;
  final int severity;
  final String outcome;
  final String? caregiverId;
  final int? resolvedAtSeconds;
  final int securityChange;

  bool get pending => outcome == 'pending';

  ChildHazardIncidentState resolve({
    required String outcome,
    required int atSeconds,
    required int securityChange,
  }) => ChildHazardIncidentState(
    id: id,
    kind: kind,
    detectedAtSeconds: detectedAtSeconds,
    noticedBeforeHarm: noticedBeforeHarm,
    childReaction: childReaction,
    severity: severity,
    outcome: outcome,
    caregiverId: caregiverId,
    resolvedAtSeconds: atSeconds,
    securityChange: securityChange,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'kind': kind,
    'detected_at_seconds': detectedAtSeconds,
    'noticed_before_harm': noticedBeforeHarm,
    'child_reaction': childReaction,
    'severity': severity,
    'outcome': outcome,
    if (caregiverId != null) 'caregiver_id': caregiverId,
    if (resolvedAtSeconds != null) 'resolved_at_seconds': resolvedAtSeconds,
    if (securityChange != 0) 'security_change': securityChange,
  };

  factory ChildHazardIncidentState.fromJson(Map<String, Object?> json) =>
      ChildHazardIncidentState(
        id: json['id']! as String,
        kind: json['kind']! as String,
        detectedAtSeconds: json['detected_at_seconds']! as int,
        noticedBeforeHarm: json['noticed_before_harm']! as bool,
        childReaction: json['child_reaction']! as String,
        severity: json['severity']! as int,
        outcome: json['outcome']! as String,
        caregiverId: json['caregiver_id'] as String?,
        resolvedAtSeconds: json['resolved_at_seconds'] as int?,
        securityChange: json['security_change'] as int? ?? 0,
      );
}

class ChildMemoryEpisodeState {
  const ChildMemoryEpisodeState({
    required this.id,
    required this.atSeconds,
    required this.kind,
    required this.outcome,
    required this.summary,
    required this.importance,
    this.sourceIds = const <String>[],
    this.influenceKey,
  });

  final String id;
  final int atSeconds;
  final String kind;
  final String outcome;
  final String summary;
  final int importance;
  final List<String> sourceIds;
  final String? influenceKey;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'at_seconds': atSeconds,
    'kind': kind,
    'outcome': outcome,
    'summary': summary,
    'importance': importance,
    if (sourceIds.isNotEmpty) 'source_ids': sourceIds,
    if (influenceKey != null) 'influence_key': influenceKey,
  };

  factory ChildMemoryEpisodeState.fromJson(Map<String, Object?> json) =>
      ChildMemoryEpisodeState(
        id: json['id']! as String,
        atSeconds: json['at_seconds']! as int,
        kind: json['kind']! as String,
        outcome: json['outcome']! as String,
        summary: json['summary']! as String,
        importance: json['importance']! as int,
        sourceIds: (json['source_ids'] as List<Object?>? ?? const <Object?>[])
            .cast<String>(),
        influenceKey: json['influence_key'] as String?,
      );
}

class ChildMemorySummaryState {
  const ChildMemorySummaryState({
    required this.periodIndex,
    required this.firstAtSeconds,
    required this.lastAtSeconds,
    required this.episodeCount,
    required this.successCount,
    required this.failureCount,
    required this.hazardCount,
    required this.kindCounts,
    required this.sourceIds,
  });

  final int periodIndex;
  final int firstAtSeconds;
  final int lastAtSeconds;
  final int episodeCount;
  final int successCount;
  final int failureCount;
  final int hazardCount;
  final Map<String, int> kindCounts;
  final List<String> sourceIds;

  factory ChildMemorySummaryState.fromEpisode(
    ChildMemoryEpisodeState episode, {
    required int memoryTimelineStartedAtSeconds,
  }) => ChildMemorySummaryState(
    periodIndex: episode.atSeconds <= memoryTimelineStartedAtSeconds
        ? 0
        : (episode.atSeconds - memoryTimelineStartedAtSeconds) ~/
              _memoryPeriodSeconds,
    firstAtSeconds: episode.atSeconds,
    lastAtSeconds: episode.atSeconds,
    episodeCount: 1,
    successCount: episode.outcome == 'succeeded' ? 1 : 0,
    failureCount: episode.outcome == 'failed' ? 1 : 0,
    hazardCount: episode.kind.startsWith('hazard_') ? 1 : 0,
    kindCounts: <String, int>{episode.kind: 1},
    sourceIds: episode.sourceIds.take(_maxSummarySources).toList(),
  );

  ChildMemorySummaryState merge(
    ChildMemorySummaryState other, {
    int? periodIndex,
  }) {
    final Map<String, int> mergedKinds = <String, int>{...kindCounts};
    for (final MapEntry<String, int> entry in other.kindCounts.entries) {
      mergedKinds[entry.key] = (mergedKinds[entry.key] ?? 0) + entry.value;
    }
    final List<String> mergedSources = <String>{
      ...sourceIds,
      ...other.sourceIds,
    }.take(_maxSummarySources).toList();
    return ChildMemorySummaryState(
      periodIndex: periodIndex ?? this.periodIndex,
      firstAtSeconds: firstAtSeconds < other.firstAtSeconds
          ? firstAtSeconds
          : other.firstAtSeconds,
      lastAtSeconds: lastAtSeconds > other.lastAtSeconds
          ? lastAtSeconds
          : other.lastAtSeconds,
      episodeCount: episodeCount + other.episodeCount,
      successCount: successCount + other.successCount,
      failureCount: failureCount + other.failureCount,
      hazardCount: hazardCount + other.hazardCount,
      kindCounts: mergedKinds,
      sourceIds: mergedSources,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'period_index': periodIndex,
    'first_at_seconds': firstAtSeconds,
    'last_at_seconds': lastAtSeconds,
    'episode_count': episodeCount,
    'success_count': successCount,
    'failure_count': failureCount,
    'hazard_count': hazardCount,
    'kind_counts': kindCounts,
    if (sourceIds.isNotEmpty) 'source_ids': sourceIds,
  };

  factory ChildMemorySummaryState.fromJson(Map<String, Object?> json) =>
      ChildMemorySummaryState(
        periodIndex: json['period_index']! as int,
        firstAtSeconds: json['first_at_seconds']! as int,
        lastAtSeconds: json['last_at_seconds']! as int,
        episodeCount: json['episode_count']! as int,
        successCount: json['success_count']! as int,
        failureCount: json['failure_count']! as int,
        hazardCount: json['hazard_count']! as int,
        kindCounts: (json['kind_counts']! as Map).cast<String, int>(),
        sourceIds: (json['source_ids'] as List<Object?>? ?? const <Object?>[])
            .cast<String>(),
      );
}

const int _memoryPeriodSeconds = 30 * 86400;
const int _recentMemoryWindowSeconds = 30 * 86400;
const int _maxRecentMemories = 64;
const int _maxMemoryAnchors = 32;
const int _maxMemorySummaries = 84;
const int _maxSummarySources = 8;

/// Lớp phát triển bắt đầu sau 30 ngày đầu đời.
///
/// Tuổi chỉ tạo mức trưởng thành nền. Năng lực sử dụng được còn cần số lần
/// quan sát, tiếp xúc ngôn ngữ, tập vận động và chơi đã thật sự diễn ra.
class ChildhoodState {
  const ChildhoodState({
    required this.startedAtSeconds,
    required this.lastAdvancedAgeDays,
    required this.security,
    required this.grossMotor,
    required this.fineMotor,
    required this.receptiveLanguage,
    required this.expressiveLanguage,
    required this.observationExperience,
    required this.movementPractice,
    required this.languageExposure,
    required this.playExperience,
    this.body = const ChildBodyState.fallback(),
    this.maturationProgressPerMille = 0,
    this.completedPhysicalActivities = 0,
    this.successfulPhysicalActivities = 0,
    this.failedPhysicalActivities = 0,
    this.completedLearningActivities = 0,
    this.successfulLearningActivities = 0,
    this.failedLearningActivities = 0,
    this.lastIntent,
    this.lastIntentAtSeconds,
    this.lastOutcome,
    this.lastActivityRoomId,
    this.lastActivityItemId,
    this.lastActivityDurationSeconds,
    this.lastLearnedConceptId,
    this.lastLearningSourceId,
    this.hazardIncidents = 0,
    this.hazardsNoticedBeforeHarm = 0,
    this.hazardsResolvedByCaregiver = 0,
    this.lastHazard,
    this.recentMemories = const <ChildMemoryEpisodeState>[],
    this.memoryAnchors = const <ChildMemoryEpisodeState>[],
    this.memorySummaries = const <ChildMemorySummaryState>[],
    this.compressedMemoryCount = 0,
  });

  factory ChildhoodState.afterNewborn({
    required int nowSeconds,
    required int ageDays,
    required int attachment,
    required Iterable<int> caregiverSafety,
    required ChildBodyState body,
  }) {
    final List<int> learnedSafety = caregiverSafety.toList();
    final int averageSafety = learnedSafety.isEmpty
        ? attachment
        : learnedSafety.reduce((int a, int b) => a + b) ~/ learnedSafety.length;
    return ChildhoodState(
      startedAtSeconds: nowSeconds,
      lastAdvancedAgeDays: ageDays,
      security: _clamp((attachment * 2 + averageSafety) ~/ 3),
      grossMotor: 70,
      fineMotor: 45,
      receptiveLanguage: 55,
      expressiveLanguage: 10,
      observationExperience: 0,
      movementPractice: 0,
      languageExposure: 0,
      playExperience: 0,
      body: body,
      maturationProgressPerMille: ageDays * 1000,
    );
  }

  final int startedAtSeconds;
  final int lastAdvancedAgeDays;
  final int security;
  final int grossMotor;
  final int fineMotor;
  final int receptiveLanguage;
  final int expressiveLanguage;
  final int observationExperience;
  final int movementPractice;
  final int languageExposure;
  final int playExperience;
  final ChildBodyState body;
  final int maturationProgressPerMille;
  final int completedPhysicalActivities;
  final int successfulPhysicalActivities;
  final int failedPhysicalActivities;
  final int completedLearningActivities;
  final int successfulLearningActivities;
  final int failedLearningActivities;
  final ChildIntent? lastIntent;
  final int? lastIntentAtSeconds;
  final String? lastOutcome;
  final String? lastActivityRoomId;
  final String? lastActivityItemId;
  final int? lastActivityDurationSeconds;
  final String? lastLearnedConceptId;
  final String? lastLearningSourceId;
  final int hazardIncidents;
  final int hazardsNoticedBeforeHarm;
  final int hazardsResolvedByCaregiver;
  final ChildHazardIncidentState? lastHazard;
  final List<ChildMemoryEpisodeState> recentMemories;
  final List<ChildMemoryEpisodeState> memoryAnchors;
  final List<ChildMemorySummaryState> memorySummaries;
  final int compressedMemoryCount;

  ChildDevelopmentStage get stage =>
      ChildDevelopmentStage.forAgeDays(lastAdvancedAgeDays);

  List<ChildIntent> get allowedIntents => <ChildIntent>[
    ChildIntent.observe,
    if (receptiveLanguage >= 60 && observationExperience >= 2)
      ChildIntent.vocalize,
    if (grossMotor >= 75 && observationExperience >= 1)
      ChildIntent.practiceReach,
    if (grossMotor >= 90 && security >= 250 && movementPractice >= 2)
      ChildIntent.floorPlay,
  ];

  ChildhoodState advanceToAgeDay(int ageDays, {int? bodyConditionPerMille}) {
    if (ageDays <= lastAdvancedAgeDays) return this;
    final int days = ageDays - lastAdvancedAgeDays;
    final int nextMaturationProgress =
        maturationProgressPerMille +
        days * (bodyConditionPerMille ?? body.developmentSupport);
    final int previousMaturationDays = maturationProgressPerMille ~/ 1000;
    final int nextMaturationDays = nextMaturationProgress ~/ 1000;
    // Trưởng thành mở khả năng nền chậm; thực hành ở afterIntent mới tạo phần
    // lớn tiến bộ có thể dùng. Nhờ vậy việc chỉ chờ thời gian không cấp kỹ năng.
    final ChildhoodState next = _copy(
      lastAdvancedAgeDays: ageDays,
      maturationProgressPerMille: nextMaturationProgress,
      grossMotor: _clamp(
        grossMotor + nextMaturationDays - previousMaturationDays,
      ),
      fineMotor: _clamp(
        fineMotor + (nextMaturationDays ~/ 2) - (previousMaturationDays ~/ 2),
      ),
      receptiveLanguage: _clamp(
        receptiveLanguage +
            (nextMaturationDays ~/ 2) -
            (previousMaturationDays ~/ 2),
      ),
      expressiveLanguage: _clamp(
        expressiveLanguage +
            (nextMaturationDays ~/ 4) -
            (previousMaturationDays ~/ 4),
      ),
    );
    return next;
  }

  ChildhoodState withDailyNutrition({
    required int ageDays,
    required int foodGrams,
    required int waterMl,
  }) => _copy(
    body: body.advanceDay(
      ageDays: ageDays,
      foodGrams: foodGrams,
      waterMl: waterMl,
    ),
  );

  ChildhoodState completePhysicalActivity({
    required ChildIntent intent,
    required bool succeeded,
    required int nowSeconds,
    required String roomId,
    String? itemId,
  }) {
    if (intent != ChildIntent.practiceReach &&
        intent != ChildIntent.floorPlay) {
      throw ArgumentError('Hoạt động này không phải vận động/chơi.');
    }
    final int gain = succeeded ? 4 : 1;
    final ChildhoodState next = _copy(
      grossMotor: _clamp(grossMotor + gain),
      fineMotor: _clamp(
        fineMotor + (intent == ChildIntent.practiceReach ? gain : 1),
      ),
      movementPractice: movementPractice + 1,
      playExperience:
          playExperience + (intent == ChildIntent.floorPlay ? 1 : 0),
      completedPhysicalActivities: completedPhysicalActivities + 1,
      successfulPhysicalActivities:
          successfulPhysicalActivities + (succeeded ? 1 : 0),
      failedPhysicalActivities: failedPhysicalActivities + (succeeded ? 0 : 1),
      lastIntent: intent,
      lastIntentAtSeconds: nowSeconds,
      lastOutcome: succeeded ? 'succeeded' : 'failed',
      lastActivityRoomId: roomId,
      lastActivityItemId: itemId,
      lastActivityDurationSeconds: intent.durationSeconds,
    );
    return next.remember(
      ChildMemoryEpisodeState(
        id: 'memory-physical-$nowSeconds-${completedPhysicalActivities + 1}',
        atSeconds: nowSeconds,
        kind: intent.code,
        outcome: succeeded ? 'succeeded' : 'failed',
        summary:
            '${intent.label}: ${succeeded ? 'thành công' : 'chưa thành công'}',
        importance: succeeded ? 250 : 350,
        sourceIds: <String>[roomId, if (itemId != null) itemId],
      ),
    );
  }

  ChildhoodState completeLearningActivity({
    required ChildIntent intent,
    required bool succeeded,
    required int nowSeconds,
    required String roomId,
    required String sourceId,
    String? conceptId,
    String? itemId,
  }) {
    if (intent != ChildIntent.observe && intent != ChildIntent.vocalize) {
      throw ArgumentError('Hoạt động này không phải quan sát/ngôn ngữ.');
    }
    final int gain = succeeded ? 4 : 1;
    final ChildhoodState next = _copy(
      receptiveLanguage: _clamp(receptiveLanguage + gain),
      expressiveLanguage: _clamp(
        expressiveLanguage + (intent == ChildIntent.vocalize ? gain : 1),
      ),
      observationExperience:
          observationExperience + (intent == ChildIntent.observe ? 1 : 0),
      languageExposure:
          languageExposure + (intent == ChildIntent.vocalize ? 1 : 0),
      completedLearningActivities: completedLearningActivities + 1,
      successfulLearningActivities:
          successfulLearningActivities + (succeeded ? 1 : 0),
      failedLearningActivities: failedLearningActivities + (succeeded ? 0 : 1),
      lastIntent: intent,
      lastIntentAtSeconds: nowSeconds,
      lastOutcome: succeeded ? 'succeeded' : 'failed',
      lastActivityRoomId: roomId,
      lastActivityItemId: itemId,
      lastActivityDurationSeconds: intent.durationSeconds,
      lastLearnedConceptId: succeeded ? conceptId : null,
      lastLearningSourceId: sourceId,
    );
    return next.remember(
      ChildMemoryEpisodeState(
        id: 'memory-learning-$nowSeconds-${completedLearningActivities + 1}',
        atSeconds: nowSeconds,
        kind: intent.code,
        outcome: succeeded ? 'succeeded' : 'failed',
        summary: succeeded
            ? '${intent.label}: học được ${conceptId ?? 'một điều mới'}'
            : '${intent.label}: chưa học được',
        importance: succeeded ? 500 : 300,
        sourceIds: <String>[
          roomId,
          sourceId,
          if (itemId != null && itemId != sourceId) itemId,
        ],
      ),
    );
  }

  ChildhoodState startHazard(ChildHazardIncidentState incident) {
    final ChildhoodState next = _copy(
      hazardIncidents: hazardIncidents + 1,
      hazardsNoticedBeforeHarm:
          hazardsNoticedBeforeHarm + (incident.noticedBeforeHarm ? 1 : 0),
      lastHazard: incident,
    );
    return next.remember(
      ChildMemoryEpisodeState(
        id: 'memory-${incident.id}-detected',
        atSeconds: incident.detectedAtSeconds,
        kind: 'hazard_detected',
        outcome: incident.noticedBeforeHarm ? 'noticed' : 'fell',
        summary: incident.noticedBeforeHarm
            ? 'Nhận ra nguy hiểm và tìm người an toàn'
            : 'Mất thăng bằng, ngã và khóc',
        importance: incident.noticedBeforeHarm ? 750 : 900,
        sourceIds: <String>[
          if (incident.caregiverId != null) incident.caregiverId!,
        ],
        influenceKey: incident.id,
      ),
    );
  }

  ChildhoodState resolveHazard({
    required String incidentId,
    required String outcome,
    required int atSeconds,
    required int securityChange,
  }) {
    final ChildHazardIncidentState? incident = lastHazard;
    if (incident == null || incident.id != incidentId || !incident.pending) {
      return this;
    }
    final ChildhoodState next = _copy(
      security: _clamp(security + securityChange),
      hazardsResolvedByCaregiver:
          hazardsResolvedByCaregiver + (outcome == 'soothed' ? 1 : 0),
      lastHazard: incident.resolve(
        outcome: outcome,
        atSeconds: atSeconds,
        securityChange: securityChange,
      ),
    );
    return next.remember(
      ChildMemoryEpisodeState(
        id: 'memory-${incident.id}-resolved',
        atSeconds: atSeconds,
        kind: 'hazard_resolved',
        outcome: outcome,
        summary: outcome == 'soothed'
            ? 'Được người chăm đến trấn an sau nguy hiểm'
            : 'Không được đáp ứng sau nguy hiểm',
        importance: outcome == 'soothed' ? 800 : 900,
        sourceIds: <String>[
          if (incident.caregiverId != null) incident.caregiverId!,
        ],
      ),
    );
  }

  ChildhoodState remember(ChildMemoryEpisodeState episode) => _copy(
    recentMemories: <ChildMemoryEpisodeState>[...recentMemories, episode],
  ).compressMemories(nowSeconds: episode.atSeconds);

  ChildhoodState compressMemories({required int nowSeconds}) {
    if (recentMemories.isEmpty) return this;
    final String? activeInfluence = lastHazard?.pending == true
        ? lastHazard!.id
        : null;
    final List<ChildMemoryEpisodeState> ordered =
        <ChildMemoryEpisodeState>[...recentMemories]..sort(
          (ChildMemoryEpisodeState a, ChildMemoryEpisodeState b) =>
              a.atSeconds.compareTo(b.atSeconds),
        );
    // Một loại hoạt động có thể lặp lại với cùng id nghiệp vụ. Nén theo từng
    // episode thay vì theo id để giới hạn bộ nhớ vẫn đúng trong trường hợp đó.
    final Set<ChildMemoryEpisodeState> compactedEpisodes =
        <ChildMemoryEpisodeState>{};
    for (final ChildMemoryEpisodeState memory in ordered) {
      if (activeInfluence != null && memory.influenceKey == activeInfluence) {
        continue;
      }
      if (nowSeconds - memory.atSeconds > _recentMemoryWindowSeconds) {
        compactedEpisodes.add(memory);
      }
    }
    final int retainedWithoutActive = ordered
        .where(
          (ChildMemoryEpisodeState memory) =>
              !compactedEpisodes.contains(memory) &&
              (activeInfluence == null ||
                  memory.influenceKey != activeInfluence),
        )
        .length;
    int excess = retainedWithoutActive - _maxRecentMemories;
    if (excess > 0) {
      for (final ChildMemoryEpisodeState memory in ordered) {
        if (excess == 0) break;
        if (compactedEpisodes.contains(memory) ||
            (activeInfluence != null &&
                memory.influenceKey == activeInfluence)) {
          continue;
        }
        compactedEpisodes.add(memory);
        excess -= 1;
      }
    }
    if (compactedEpisodes.isEmpty) return this;

    final List<ChildMemoryEpisodeState> compacted = ordered
        .where(
          (ChildMemoryEpisodeState memory) =>
              compactedEpisodes.contains(memory),
        )
        .toList();
    final Map<int, ChildMemorySummaryState> summaries =
        <int, ChildMemorySummaryState>{
          for (final ChildMemorySummaryState summary in memorySummaries)
            summary.periodIndex: summary,
        };
    for (final ChildMemoryEpisodeState memory in compacted) {
      final ChildMemorySummaryState addition =
          ChildMemorySummaryState.fromEpisode(
            memory,
            memoryTimelineStartedAtSeconds: startedAtSeconds,
          );
      summaries.update(
        addition.periodIndex,
        (ChildMemorySummaryState current) => current.merge(addition),
        ifAbsent: () => addition,
      );
    }
    List<ChildMemorySummaryState> summaryList = summaries.values.toList()
      ..sort(
        (ChildMemorySummaryState a, ChildMemorySummaryState b) =>
            a.periodIndex.compareTo(b.periodIndex),
      );
    if (summaryList.length > _maxMemorySummaries) {
      final int mergeCount = summaryList.length - _maxMemorySummaries + 1;
      ChildMemorySummaryState earlier = summaryList.first;
      for (final ChildMemorySummaryState summary
          in summaryList.skip(1).take(mergeCount - 1)) {
        earlier = earlier.merge(summary, periodIndex: -1);
      }
      summaryList = <ChildMemorySummaryState>[
        earlier,
        ...summaryList.skip(mergeCount),
      ];
    }

    final Map<String, ChildMemoryEpisodeState> anchors =
        <String, ChildMemoryEpisodeState>{
          for (final ChildMemoryEpisodeState memory in memoryAnchors)
            memory.id: memory,
          for (final ChildMemoryEpisodeState memory in compacted.where(
            (ChildMemoryEpisodeState memory) => memory.importance >= 700,
          ))
            memory.id: memory,
        };
    final List<ChildMemoryEpisodeState> anchorList = anchors.values.toList()
      ..sort((ChildMemoryEpisodeState a, ChildMemoryEpisodeState b) {
        final int importance = b.importance.compareTo(a.importance);
        return importance != 0
            ? importance
            : b.atSeconds.compareTo(a.atSeconds);
      });

    return _copy(
      recentMemories: ordered
          .where(
            (ChildMemoryEpisodeState memory) =>
                !compactedEpisodes.contains(memory),
          )
          .toList(),
      memoryAnchors: anchorList.take(_maxMemoryAnchors).toList(),
      memorySummaries: summaryList,
      compressedMemoryCount: compressedMemoryCount + compacted.length,
    );
  }

  ChildhoodState _copy({
    int? lastAdvancedAgeDays,
    int? security,
    int? grossMotor,
    int? fineMotor,
    int? receptiveLanguage,
    int? expressiveLanguage,
    int? observationExperience,
    int? movementPractice,
    int? languageExposure,
    int? playExperience,
    ChildBodyState? body,
    int? maturationProgressPerMille,
    int? completedPhysicalActivities,
    int? successfulPhysicalActivities,
    int? failedPhysicalActivities,
    int? completedLearningActivities,
    int? successfulLearningActivities,
    int? failedLearningActivities,
    ChildIntent? lastIntent,
    int? lastIntentAtSeconds,
    String? lastOutcome,
    String? lastActivityRoomId,
    String? lastActivityItemId,
    int? lastActivityDurationSeconds,
    String? lastLearnedConceptId,
    String? lastLearningSourceId,
    int? hazardIncidents,
    int? hazardsNoticedBeforeHarm,
    int? hazardsResolvedByCaregiver,
    ChildHazardIncidentState? lastHazard,
    List<ChildMemoryEpisodeState>? recentMemories,
    List<ChildMemoryEpisodeState>? memoryAnchors,
    List<ChildMemorySummaryState>? memorySummaries,
    int? compressedMemoryCount,
  }) => ChildhoodState(
    startedAtSeconds: startedAtSeconds,
    lastAdvancedAgeDays: lastAdvancedAgeDays ?? this.lastAdvancedAgeDays,
    security: security ?? this.security,
    grossMotor: grossMotor ?? this.grossMotor,
    fineMotor: fineMotor ?? this.fineMotor,
    receptiveLanguage: receptiveLanguage ?? this.receptiveLanguage,
    expressiveLanguage: expressiveLanguage ?? this.expressiveLanguage,
    observationExperience: observationExperience ?? this.observationExperience,
    movementPractice: movementPractice ?? this.movementPractice,
    languageExposure: languageExposure ?? this.languageExposure,
    playExperience: playExperience ?? this.playExperience,
    body: body ?? this.body,
    maturationProgressPerMille:
        maturationProgressPerMille ?? this.maturationProgressPerMille,
    completedPhysicalActivities:
        completedPhysicalActivities ?? this.completedPhysicalActivities,
    successfulPhysicalActivities:
        successfulPhysicalActivities ?? this.successfulPhysicalActivities,
    failedPhysicalActivities:
        failedPhysicalActivities ?? this.failedPhysicalActivities,
    completedLearningActivities:
        completedLearningActivities ?? this.completedLearningActivities,
    successfulLearningActivities:
        successfulLearningActivities ?? this.successfulLearningActivities,
    failedLearningActivities:
        failedLearningActivities ?? this.failedLearningActivities,
    lastIntent: lastIntent ?? this.lastIntent,
    lastIntentAtSeconds: lastIntentAtSeconds ?? this.lastIntentAtSeconds,
    lastOutcome: lastOutcome ?? this.lastOutcome,
    lastActivityRoomId: lastActivityRoomId ?? this.lastActivityRoomId,
    lastActivityItemId: lastActivityItemId ?? this.lastActivityItemId,
    lastActivityDurationSeconds:
        lastActivityDurationSeconds ?? this.lastActivityDurationSeconds,
    lastLearnedConceptId: lastLearnedConceptId ?? this.lastLearnedConceptId,
    lastLearningSourceId: lastLearningSourceId ?? this.lastLearningSourceId,
    hazardIncidents: hazardIncidents ?? this.hazardIncidents,
    hazardsNoticedBeforeHarm:
        hazardsNoticedBeforeHarm ?? this.hazardsNoticedBeforeHarm,
    hazardsResolvedByCaregiver:
        hazardsResolvedByCaregiver ?? this.hazardsResolvedByCaregiver,
    lastHazard: lastHazard ?? this.lastHazard,
    recentMemories: recentMemories ?? this.recentMemories,
    memoryAnchors: memoryAnchors ?? this.memoryAnchors,
    memorySummaries: memorySummaries ?? this.memorySummaries,
    compressedMemoryCount: compressedMemoryCount ?? this.compressedMemoryCount,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'started_at_seconds': startedAtSeconds,
    'last_advanced_age_days': lastAdvancedAgeDays,
    'security': security,
    'gross_motor': grossMotor,
    'fine_motor': fineMotor,
    'receptive_language': receptiveLanguage,
    'expressive_language': expressiveLanguage,
    'observation_experience': observationExperience,
    'movement_practice': movementPractice,
    'language_exposure': languageExposure,
    'play_experience': playExperience,
    'body': body.toJson(),
    'maturation_progress_per_mille': maturationProgressPerMille,
    'completed_physical_activities': completedPhysicalActivities,
    'successful_physical_activities': successfulPhysicalActivities,
    'failed_physical_activities': failedPhysicalActivities,
    'completed_learning_activities': completedLearningActivities,
    'successful_learning_activities': successfulLearningActivities,
    'failed_learning_activities': failedLearningActivities,
    if (lastIntent != null) 'last_intent': lastIntent!.name,
    if (lastIntentAtSeconds != null)
      'last_intent_at_seconds': lastIntentAtSeconds,
    if (lastOutcome != null) 'last_outcome': lastOutcome,
    if (lastActivityRoomId != null) 'last_activity_room_id': lastActivityRoomId,
    if (lastActivityItemId != null) 'last_activity_item_id': lastActivityItemId,
    if (lastActivityDurationSeconds != null)
      'last_activity_duration_seconds': lastActivityDurationSeconds,
    if (lastLearnedConceptId != null)
      'last_learned_concept_id': lastLearnedConceptId,
    if (lastLearningSourceId != null)
      'last_learning_source_id': lastLearningSourceId,
    'hazard_incidents': hazardIncidents,
    'hazards_noticed_before_harm': hazardsNoticedBeforeHarm,
    'hazards_resolved_by_caregiver': hazardsResolvedByCaregiver,
    if (lastHazard != null) 'last_hazard': lastHazard!.toJson(),
    if (recentMemories.isNotEmpty)
      'recent_memories': recentMemories
          .map((ChildMemoryEpisodeState memory) => memory.toJson())
          .toList(),
    if (memoryAnchors.isNotEmpty)
      'memory_anchors': memoryAnchors
          .map((ChildMemoryEpisodeState memory) => memory.toJson())
          .toList(),
    if (memorySummaries.isNotEmpty)
      'memory_summaries': memorySummaries
          .map((ChildMemorySummaryState summary) => summary.toJson())
          .toList(),
    if (compressedMemoryCount != 0)
      'compressed_memory_count': compressedMemoryCount,
  };

  factory ChildhoodState.fromJson(Map<String, Object?> json) => ChildhoodState(
    startedAtSeconds: json['started_at_seconds']! as int,
    lastAdvancedAgeDays: json['last_advanced_age_days']! as int,
    security: json['security']! as int,
    grossMotor: json['gross_motor']! as int,
    fineMotor: json['fine_motor']! as int,
    receptiveLanguage: json['receptive_language']! as int,
    expressiveLanguage: json['expressive_language']! as int,
    observationExperience: json['observation_experience']! as int,
    movementPractice: json['movement_practice']! as int,
    languageExposure: json['language_exposure']! as int,
    playExperience: json['play_experience']! as int,
    body: json['body'] == null
        ? const ChildBodyState.fallback()
        : ChildBodyState.fromJson(
            (json['body']! as Map).cast<String, Object?>(),
          ),
    maturationProgressPerMille:
        json['maturation_progress_per_mille'] as int? ??
        (json['last_advanced_age_days']! as int) * 1000,
    completedPhysicalActivities:
        json['completed_physical_activities'] as int? ?? 0,
    successfulPhysicalActivities:
        json['successful_physical_activities'] as int? ?? 0,
    failedPhysicalActivities: json['failed_physical_activities'] as int? ?? 0,
    completedLearningActivities:
        json['completed_learning_activities'] as int? ?? 0,
    successfulLearningActivities:
        json['successful_learning_activities'] as int? ?? 0,
    failedLearningActivities: json['failed_learning_activities'] as int? ?? 0,
    lastIntent: json['last_intent'] == null
        ? null
        : ChildIntent.values.byName(json['last_intent']! as String),
    lastIntentAtSeconds: json['last_intent_at_seconds'] as int?,
    lastOutcome: json['last_outcome'] as String?,
    lastActivityRoomId: json['last_activity_room_id'] as String?,
    lastActivityItemId: json['last_activity_item_id'] as String?,
    lastActivityDurationSeconds: json['last_activity_duration_seconds'] as int?,
    lastLearnedConceptId: json['last_learned_concept_id'] as String?,
    lastLearningSourceId: json['last_learning_source_id'] as String?,
    hazardIncidents: json['hazard_incidents'] as int? ?? 0,
    hazardsNoticedBeforeHarm: json['hazards_noticed_before_harm'] as int? ?? 0,
    hazardsResolvedByCaregiver:
        json['hazards_resolved_by_caregiver'] as int? ?? 0,
    lastHazard: json['last_hazard'] == null
        ? null
        : ChildHazardIncidentState.fromJson(
            (json['last_hazard']! as Map).cast<String, Object?>(),
          ),
    recentMemories:
        (json['recent_memories'] as List<Object?>? ?? const <Object?>[])
            .map(
              (Object? value) => ChildMemoryEpisodeState.fromJson(
                (value! as Map).cast<String, Object?>(),
              ),
            )
            .toList(),
    memoryAnchors:
        (json['memory_anchors'] as List<Object?>? ?? const <Object?>[])
            .map(
              (Object? value) => ChildMemoryEpisodeState.fromJson(
                (value! as Map).cast<String, Object?>(),
              ),
            )
            .toList(),
    memorySummaries:
        (json['memory_summaries'] as List<Object?>? ?? const <Object?>[])
            .map(
              (Object? value) => ChildMemorySummaryState.fromJson(
                (value! as Map).cast<String, Object?>(),
              ),
            )
            .toList(),
    compressedMemoryCount: json['compressed_memory_count'] as int? ?? 0,
  );
}

int _clamp(int value) => value.clamp(0, 1000);
