/// Quan hệ xã hội một chiều từ người sở hữu trạng thái tới [otherPersonId].
///
/// Quan hệ chỉ xuất hiện sau một tiếp xúc thật trong mô phỏng. Các thang điểm
/// nằm trong khoảng 0–1000; 500 là trung tính đối với lòng tin và thiện cảm.
class SocialRelationState {
  const SocialRelationState({
    required this.otherPersonId,
    this.familiarity = 0,
    this.tradeTrust = 500,
    this.informationTrust = 500,
    this.goodwill = 500,
    this.resentment = 0,
    this.encounterCount = 0,
    this.successfulTrades = 0,
    this.failedTrades = 0,
    this.receivedReports = 0,
    this.refusedResourceAid = 0,
    this.lastInteractionAtSeconds,
    this.lastInteractionKind,
    this.appliedInteractionIds = const <String>{},
  });

  final String otherPersonId;
  final int familiarity;
  final int tradeTrust;
  final int informationTrust;
  final int goodwill;
  final int resentment;
  final int encounterCount;
  final int successfulTrades;
  final int failedTrades;
  final int receivedReports;

  /// Số lần người kia từ chối một yêu cầu tài nguyên mà chủ quan hệ đã đưa.
  final int refusedResourceAid;
  final int? lastInteractionAtSeconds;
  final String? lastInteractionKind;

  /// Ngăn cùng một cuộc gặp/giao dịch/lời kể cộng tác động nhiều lần.
  final Set<String> appliedInteractionIds;

  bool hasApplied(String interactionId) =>
      appliedInteractionIds.contains(interactionId);

  SocialRelationState recordEncounter({
    required String interactionId,
    required int atSeconds,
  }) {
    if (hasApplied(interactionId)) return this;
    return _copy(
      familiarity: (familiarity + 35).clamp(0, 1000),
      goodwill: (goodwill + 4).clamp(0, 1000),
      encounterCount: encounterCount + 1,
      lastInteractionAtSeconds: atSeconds,
      lastInteractionKind: 'encounter',
      appliedInteractionIds: <String>{...appliedInteractionIds, interactionId},
    );
  }

  SocialRelationState recordTrade({
    required String interactionId,
    required int atSeconds,
    required bool succeeded,
  }) {
    if (hasApplied(interactionId)) return this;
    return _copy(
      familiarity: (familiarity + (succeeded ? 25 : 10)).clamp(0, 1000),
      tradeTrust: (tradeTrust + (succeeded ? 45 : -70)).clamp(0, 1000),
      goodwill: (goodwill + (succeeded ? 12 : -20)).clamp(0, 1000),
      resentment: (resentment + (succeeded ? -3 : 35)).clamp(0, 1000),
      successfulTrades: successfulTrades + (succeeded ? 1 : 0),
      failedTrades: failedTrades + (succeeded ? 0 : 1),
      lastInteractionAtSeconds: atSeconds,
      lastInteractionKind: succeeded ? 'trade_succeeded' : 'trade_failed',
      appliedInteractionIds: <String>{...appliedInteractionIds, interactionId},
    );
  }

  SocialRelationState recordInformationReceived({
    required String interactionId,
    required int atSeconds,
    required int confidence,
  }) {
    if (hasApplied(interactionId)) return this;
    final int trustGain = 5 + confidence.clamp(0, 1000) ~/ 100;
    return _copy(
      familiarity: (familiarity + 12).clamp(0, 1000),
      informationTrust: (informationTrust + trustGain).clamp(0, 1000),
      goodwill: (goodwill + 3).clamp(0, 1000),
      receivedReports: receivedReports + 1,
      lastInteractionAtSeconds: atSeconds,
      lastInteractionKind: 'information_received',
      appliedInteractionIds: <String>{...appliedInteractionIds, interactionId},
    );
  }

  /// Chủ quan hệ ghi nhớ việc [otherPersonId] từ chối giúp tài nguyên.
  ///
  /// Nhu cầu càng gấp thì lòng tin và thiện cảm mất càng nhiều, còn bất mãn
  /// tăng mạnh hơn. ID sự việc ngăn cùng một lời từ chối bị cộng hai lần khi
  /// sự kiện được nạp lại hoặc xử lý lặp.
  SocialRelationState recordResourceAidRefused({
    required String interactionId,
    required int atSeconds,
    required int urgency,
  }) {
    if (hasApplied(interactionId)) return this;
    final int boundedUrgency = urgency.clamp(0, 100);
    final int trustLoss = 15 + boundedUrgency * 45 ~/ 100;
    final int goodwillLoss = 10 + boundedUrgency * 30 ~/ 100;
    final int resentmentGain = 15 + boundedUrgency * 70 ~/ 100;
    return _copy(
      familiarity: (familiarity + 8).clamp(0, 1000),
      tradeTrust: (tradeTrust - trustLoss).clamp(0, 1000),
      goodwill: (goodwill - goodwillLoss).clamp(0, 1000),
      resentment: (resentment + resentmentGain).clamp(0, 1000),
      refusedResourceAid: refusedResourceAid + 1,
      lastInteractionAtSeconds: atSeconds,
      lastInteractionKind: 'resource_aid_refused',
      appliedInteractionIds: <String>{...appliedInteractionIds, interactionId},
    );
  }

  SocialRelationState _copy({
    int? familiarity,
    int? tradeTrust,
    int? informationTrust,
    int? goodwill,
    int? resentment,
    int? encounterCount,
    int? successfulTrades,
    int? failedTrades,
    int? receivedReports,
    int? refusedResourceAid,
    int? lastInteractionAtSeconds,
    String? lastInteractionKind,
    Set<String>? appliedInteractionIds,
  }) => SocialRelationState(
    otherPersonId: otherPersonId,
    familiarity: familiarity ?? this.familiarity,
    tradeTrust: tradeTrust ?? this.tradeTrust,
    informationTrust: informationTrust ?? this.informationTrust,
    goodwill: goodwill ?? this.goodwill,
    resentment: resentment ?? this.resentment,
    encounterCount: encounterCount ?? this.encounterCount,
    successfulTrades: successfulTrades ?? this.successfulTrades,
    failedTrades: failedTrades ?? this.failedTrades,
    receivedReports: receivedReports ?? this.receivedReports,
    refusedResourceAid: refusedResourceAid ?? this.refusedResourceAid,
    lastInteractionAtSeconds:
        lastInteractionAtSeconds ?? this.lastInteractionAtSeconds,
    lastInteractionKind: lastInteractionKind ?? this.lastInteractionKind,
    appliedInteractionIds: appliedInteractionIds ?? this.appliedInteractionIds,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'other_person_id': otherPersonId,
    'familiarity': familiarity,
    'trade_trust': tradeTrust,
    'information_trust': informationTrust,
    'goodwill': goodwill,
    'resentment': resentment,
    'encounter_count': encounterCount,
    'successful_trades': successfulTrades,
    'failed_trades': failedTrades,
    'received_reports': receivedReports,
    'refused_resource_aid': refusedResourceAid,
    if (lastInteractionAtSeconds != null)
      'last_interaction_at_seconds': lastInteractionAtSeconds,
    if (lastInteractionKind != null)
      'last_interaction_kind': lastInteractionKind,
    if (appliedInteractionIds.isNotEmpty)
      'applied_interaction_ids': appliedInteractionIds.toList()..sort(),
  };

  factory SocialRelationState.fromJson(Map<String, Object?> json) =>
      SocialRelationState(
        otherPersonId: json['other_person_id']! as String,
        familiarity: json['familiarity'] as int? ?? 0,
        tradeTrust: json['trade_trust'] as int? ?? 500,
        informationTrust: json['information_trust'] as int? ?? 500,
        goodwill: json['goodwill'] as int? ?? 500,
        resentment: json['resentment'] as int? ?? 0,
        encounterCount: json['encounter_count'] as int? ?? 0,
        successfulTrades: json['successful_trades'] as int? ?? 0,
        failedTrades: json['failed_trades'] as int? ?? 0,
        receivedReports: json['received_reports'] as int? ?? 0,
        refusedResourceAid: json['refused_resource_aid'] as int? ?? 0,
        lastInteractionAtSeconds: json['last_interaction_at_seconds'] as int?,
        lastInteractionKind: json['last_interaction_kind'] as String?,
        appliedInteractionIds:
            (json['applied_interaction_ids'] as List<Object?>? ??
                    const <Object?>[])
                .cast<String>()
                .toSet(),
      );
}
