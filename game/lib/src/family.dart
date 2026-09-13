/// Phần quan hệ có thể thay đổi bởi những lần sống và chăm sóc cùng nhau.
///
/// Vai trò huyết thống/xã hội vẫn nằm ở `familyRelationships`; trạng thái này
/// chỉ giữ mức gắn bó, nghĩa vụ và ký ức tích lũy của một chiều quan hệ.
class FamilyBondState {
  const FamilyBondState({
    this.affection = 500,
    this.trust = 500,
    this.careObligation = 0,
    this.careGiven = 0,
    this.careReceived = 0,
    this.substituteCareGiven = 0,
    this.witnessedPromisesKept = 0,
    this.witnessedPromisesBroken = 0,
    this.accumulatedCareSeconds = 0,
    this.lastInteractionSeconds,
    this.lastInteractionKind,
  });

  final int affection;
  final int trust;

  /// Mức tự xem mình có trách nhiệm chăm người kia, thang 0–1000.
  final int careObligation;
  final int careGiven;
  final int careReceived;
  final int substituteCareGiven;
  final int witnessedPromisesKept;
  final int witnessedPromisesBroken;
  final int accumulatedCareSeconds;
  final int? lastInteractionSeconds;
  final String? lastInteractionKind;

  /// Động lực nhận chăm sóc trước khi sức lực và lịch cá nhân được tính.
  int get careCommitment =>
      careObligation +
      affection ~/ 4 +
      trust ~/ 5 -
      careGiven * 3 +
      witnessedPromisesKept * 3 -
      witnessedPromisesBroken * 6;

  FamilyBondState recordCareGiven({
    required int atSeconds,
    required int durationSeconds,
    required bool substituted,
  }) => _copy(
    affection: (affection + (substituted ? 5 : 3)).clamp(0, 1000),
    trust: (trust + 2).clamp(0, 1000),
    careGiven: careGiven + 1,
    substituteCareGiven: substituteCareGiven + (substituted ? 1 : 0),
    accumulatedCareSeconds: accumulatedCareSeconds + durationSeconds,
    lastInteractionSeconds: atSeconds,
    lastInteractionKind: substituted ? 'substitute_care_given' : 'care_given',
  );

  FamilyBondState recordCareReceived({
    required int atSeconds,
    required int durationSeconds,
    required bool substituted,
  }) => _copy(
    affection: (affection + (substituted ? 4 : 3)).clamp(0, 1000),
    trust: (trust + 3).clamp(0, 1000),
    careReceived: careReceived + 1,
    accumulatedCareSeconds: accumulatedCareSeconds + durationSeconds,
    lastInteractionSeconds: atSeconds,
    lastInteractionKind: substituted
        ? 'substitute_care_received'
        : 'care_received',
  );

  FamilyBondState recordConflict({
    required int atSeconds,
    required int severity,
  }) => _copy(
    affection: (affection - severity ~/ 8).clamp(0, 1000),
    trust: (trust - severity ~/ 5).clamp(0, 1000),
    lastInteractionSeconds: atSeconds,
    lastInteractionKind: 'family_conflict',
  );

  FamilyBondState recordReconciliation({
    required int atSeconds,
    required int strength,
  }) => _copy(
    affection: (affection + strength ~/ 12).clamp(0, 1000),
    trust: (trust + strength ~/ 8).clamp(0, 1000),
    lastInteractionSeconds: atSeconds,
    lastInteractionKind: 'family_reconciliation',
  );

  FamilyBondState recordReliabilityObservation({
    required int atSeconds,
    required bool keptPromise,
  }) => _copy(
    trust: (trust + (keptPromise ? 18 : -42)).clamp(0, 1000),
    affection: (affection + (keptPromise ? 5 : -12)).clamp(0, 1000),
    witnessedPromisesKept: witnessedPromisesKept + (keptPromise ? 1 : 0),
    witnessedPromisesBroken: witnessedPromisesBroken + (keptPromise ? 0 : 1),
    lastInteractionSeconds: atSeconds,
    lastInteractionKind: keptPromise
        ? 'witnessed_promise_kept'
        : 'witnessed_promise_broken',
  );

  FamilyBondState _copy({
    int? affection,
    int? trust,
    int? careObligation,
    int? careGiven,
    int? careReceived,
    int? substituteCareGiven,
    int? witnessedPromisesKept,
    int? witnessedPromisesBroken,
    int? accumulatedCareSeconds,
    int? lastInteractionSeconds,
    String? lastInteractionKind,
  }) => FamilyBondState(
    affection: affection ?? this.affection,
    trust: trust ?? this.trust,
    careObligation: careObligation ?? this.careObligation,
    careGiven: careGiven ?? this.careGiven,
    careReceived: careReceived ?? this.careReceived,
    substituteCareGiven: substituteCareGiven ?? this.substituteCareGiven,
    witnessedPromisesKept: witnessedPromisesKept ?? this.witnessedPromisesKept,
    witnessedPromisesBroken:
        witnessedPromisesBroken ?? this.witnessedPromisesBroken,
    accumulatedCareSeconds:
        accumulatedCareSeconds ?? this.accumulatedCareSeconds,
    lastInteractionSeconds:
        lastInteractionSeconds ?? this.lastInteractionSeconds,
    lastInteractionKind: lastInteractionKind ?? this.lastInteractionKind,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'affection': affection,
    'trust': trust,
    if (careObligation > 0) 'care_obligation': careObligation,
    if (careGiven > 0) 'care_given': careGiven,
    if (careReceived > 0) 'care_received': careReceived,
    if (substituteCareGiven > 0) 'substitute_care_given': substituteCareGiven,
    if (witnessedPromisesKept > 0)
      'witnessed_promises_kept': witnessedPromisesKept,
    if (witnessedPromisesBroken > 0)
      'witnessed_promises_broken': witnessedPromisesBroken,
    if (accumulatedCareSeconds > 0)
      'accumulated_care_seconds': accumulatedCareSeconds,
    if (lastInteractionSeconds != null)
      'last_interaction_seconds': lastInteractionSeconds,
    if (lastInteractionKind != null)
      'last_interaction_kind': lastInteractionKind,
  };

  factory FamilyBondState.fromJson(Map<String, Object?> json) =>
      FamilyBondState(
        affection: json['affection'] as int? ?? 500,
        trust: json['trust'] as int? ?? 500,
        careObligation: json['care_obligation'] as int? ?? 0,
        careGiven: json['care_given'] as int? ?? 0,
        careReceived: json['care_received'] as int? ?? 0,
        substituteCareGiven: json['substitute_care_given'] as int? ?? 0,
        witnessedPromisesKept: json['witnessed_promises_kept'] as int? ?? 0,
        witnessedPromisesBroken: json['witnessed_promises_broken'] as int? ?? 0,
        accumulatedCareSeconds: json['accumulated_care_seconds'] as int? ?? 0,
        lastInteractionSeconds: json['last_interaction_seconds'] as int?,
        lastInteractionKind: json['last_interaction_kind'] as String?,
      );
}

/// Một ca chăm trẻ đã được các thành viên trong hộ phân chia cho một ngày.
class FamilyCareShiftState {
  const FamilyCareShiftState({
    required this.id,
    required this.startSecondOfDay,
    required this.durationSeconds,
    required this.caregiverId,
    required this.reason,
    this.declinedPersonIds = const <String>[],
  });

  final String id;
  final int startSecondOfDay;
  final int durationSeconds;
  final String? caregiverId;
  final String reason;
  final List<String> declinedPersonIds;

  int get endSecondOfDay => startSecondOfDay + durationSeconds;

  bool containsSecond(int secondOfDay) =>
      secondOfDay >= startSecondOfDay && secondOfDay < endSecondOfDay;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'start_second_of_day': startSecondOfDay,
    'duration_seconds': durationSeconds,
    if (caregiverId != null) 'caregiver_id': caregiverId,
    'reason': reason,
    if (declinedPersonIds.isNotEmpty)
      'declined_person_ids': declinedPersonIds.toList()..sort(),
  };

  factory FamilyCareShiftState.fromJson(Map<String, Object?> json) =>
      FamilyCareShiftState(
        id: json['id']! as String,
        startSecondOfDay: json['start_second_of_day']! as int,
        durationSeconds: json['duration_seconds']! as int,
        caregiverId: json['caregiver_id'] as String?,
        reason: json['reason']! as String,
        declinedPersonIds:
            (json['declined_person_ids'] as List<Object?>? ?? const <Object?>[])
                .cast<String>(),
      );
}

/// Kết quả thương lượng ca chăm của một hộ trong một ngày game.
class FamilyCarePlanState {
  const FamilyCarePlanState({
    required this.day,
    required this.revision,
    required this.negotiatedAtSeconds,
    required this.shifts,
  });

  final int day;
  final int revision;
  final int negotiatedAtSeconds;
  final List<FamilyCareShiftState> shifts;

  FamilyCareShiftState? shiftAt(int absoluteSeconds) {
    if (absoluteSeconds ~/ 86400 != day) return null;
    final int secondOfDay = absoluteSeconds % 86400;
    return shifts
        .where(
          (FamilyCareShiftState shift) => shift.containsSecond(secondOfDay),
        )
        .firstOrNull;
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'day': day,
    'revision': revision,
    'negotiated_at_seconds': negotiatedAtSeconds,
    'shifts': shifts
        .map((FamilyCareShiftState shift) => shift.toJson())
        .toList(),
  };

  factory FamilyCarePlanState.fromJson(Map<String, Object?> json) =>
      FamilyCarePlanState(
        day: json['day']! as int,
        revision: json['revision']! as int,
        negotiatedAtSeconds: json['negotiated_at_seconds']! as int,
        shifts: (json['shifts']! as List<Object?>)
            .map(
              (Object? value) => FamilyCareShiftState.fromJson(
                (value! as Map).cast<String, Object?>(),
              ),
            )
            .toList(),
      );
}

enum FamilyCareSupportStatus { pending, fulfilled, failed, expired }

/// Dấu vết một ca chăm bị vỡ và kết quả gọi người khác gánh ngay lúc đó.
class FamilyCareSupportRequestState {
  const FamilyCareSupportRequestState({
    required this.id,
    required this.shiftId,
    required this.infantId,
    required this.openedAtSeconds,
    required this.reason,
    required this.status,
    required this.trigger,
    this.plannedCaregiverId,
    this.supporterId,
    this.attempts = 1,
    this.lastAttemptAtSeconds,
    this.nextRetryAtSeconds,
    this.resolvedAtSeconds,
  });

  final String id;
  final String? shiftId;
  final String infantId;
  final int openedAtSeconds;
  final String reason;
  final FamilyCareSupportStatus status;
  final String trigger;
  final String? plannedCaregiverId;
  final String? supporterId;
  final int attempts;
  final int? lastAttemptAtSeconds;
  final int? nextRetryAtSeconds;
  final int? resolvedAtSeconds;

  int? get responseDelaySeconds =>
      resolvedAtSeconds == null ? null : resolvedAtSeconds! - openedAtSeconds;

  FamilyCareSupportRequestState retryAt({
    required int atSeconds,
    required int nextRetryAtSeconds,
  }) => _copy(
    attempts: attempts + 1,
    lastAttemptAtSeconds: atSeconds,
    nextRetryAtSeconds: nextRetryAtSeconds,
  );

  FamilyCareSupportRequestState fulfill({
    required String supporterId,
    required int atSeconds,
  }) => _copy(
    status: FamilyCareSupportStatus.fulfilled,
    supporterId: supporterId,
    attempts: attempts + 1,
    lastAttemptAtSeconds: atSeconds,
    resolvedAtSeconds: atSeconds,
    clearNextRetry: true,
  );

  FamilyCareSupportRequestState expire(int atSeconds) => _copy(
    status: FamilyCareSupportStatus.expired,
    attempts: attempts + 1,
    lastAttemptAtSeconds: atSeconds,
    resolvedAtSeconds: atSeconds,
    clearNextRetry: true,
  );

  FamilyCareSupportRequestState _copy({
    FamilyCareSupportStatus? status,
    String? supporterId,
    int? attempts,
    int? lastAttemptAtSeconds,
    int? nextRetryAtSeconds,
    int? resolvedAtSeconds,
    bool clearNextRetry = false,
  }) => FamilyCareSupportRequestState(
    id: id,
    shiftId: shiftId,
    infantId: infantId,
    openedAtSeconds: openedAtSeconds,
    reason: reason,
    status: status ?? this.status,
    trigger: trigger,
    plannedCaregiverId: plannedCaregiverId,
    supporterId: supporterId ?? this.supporterId,
    attempts: attempts ?? this.attempts,
    lastAttemptAtSeconds: lastAttemptAtSeconds ?? this.lastAttemptAtSeconds,
    nextRetryAtSeconds: clearNextRetry
        ? null
        : nextRetryAtSeconds ?? this.nextRetryAtSeconds,
    resolvedAtSeconds: resolvedAtSeconds ?? this.resolvedAtSeconds,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    if (shiftId != null) 'shift_id': shiftId,
    'infant_id': infantId,
    'opened_at_seconds': openedAtSeconds,
    'reason': reason,
    'status': status.name,
    'trigger': trigger,
    if (plannedCaregiverId != null) 'planned_caregiver_id': plannedCaregiverId,
    if (supporterId != null) 'supporter_id': supporterId,
    if (attempts > 1) 'attempts': attempts,
    if (lastAttemptAtSeconds != null)
      'last_attempt_at_seconds': lastAttemptAtSeconds,
    if (nextRetryAtSeconds != null) 'next_retry_at_seconds': nextRetryAtSeconds,
    if (resolvedAtSeconds != null) 'resolved_at_seconds': resolvedAtSeconds,
  };

  factory FamilyCareSupportRequestState.fromJson(Map<String, Object?> json) =>
      FamilyCareSupportRequestState(
        id: json['id']! as String,
        shiftId: json['shift_id'] as String?,
        infantId: json['infant_id']! as String,
        openedAtSeconds: json['opened_at_seconds']! as int,
        reason: json['reason']! as String,
        status: FamilyCareSupportStatus.values.byName(
          json['status']! as String,
        ),
        trigger: json['trigger'] as String? ?? 'unknown',
        plannedCaregiverId: json['planned_caregiver_id'] as String?,
        supporterId: json['supporter_id'] as String?,
        attempts: json['attempts'] as int? ?? 1,
        lastAttemptAtSeconds: json['last_attempt_at_seconds'] as int?,
        nextRetryAtSeconds: json['next_retry_at_seconds'] as int?,
        resolvedAtSeconds: json['resolved_at_seconds'] as int?,
      );
}

/// Gánh nặng xã hội mà một thành viên tích lũy qua các ca chăm đã hứa và ca
/// phải nhận thay. Trạng thái này thuộc về đời sống của hộ, không chỉ là log.
class FamilyCareBurdenState {
  const FamilyCareBurdenState({
    this.emergencyShiftsTaken = 0,
    this.missedPlannedShifts = 0,
    this.careDebt = 0,
    this.strain = 0,
    this.lastChangedAtSeconds,
    this.lastReason,
  });

  final int emergencyShiftsTaken;
  final int missedPlannedShifts;
  final int careDebt;
  final int strain;
  final int? lastChangedAtSeconds;
  final String? lastReason;

  FamilyCareBurdenState recordEmergencyShift({
    required int atSeconds,
    required int delaySeconds,
  }) => _copy(
    emergencyShiftsTaken: emergencyShiftsTaken + 1,
    strain: (strain + 90 + delaySeconds ~/ 60).clamp(0, 1000),
    lastChangedAtSeconds: atSeconds,
    lastReason: 'emergency_shift_taken',
  );

  FamilyCareBurdenState recordMissedShift({required int atSeconds}) => _copy(
    missedPlannedShifts: missedPlannedShifts + 1,
    careDebt: (careDebt + 180).clamp(0, 1000),
    lastChangedAtSeconds: atSeconds,
    lastReason: 'planned_shift_missed',
  );

  FamilyCareBurdenState afterDailyPlan(int assignedShifts) => _copy(
    careDebt: (careDebt - assignedShifts * 90).clamp(0, 1000),
    strain: (strain - 20).clamp(0, 1000),
    lastReason: assignedShifts > 0 ? 'debt_repayment_planned' : lastReason,
  );

  FamilyCareBurdenState _copy({
    int? emergencyShiftsTaken,
    int? missedPlannedShifts,
    int? careDebt,
    int? strain,
    int? lastChangedAtSeconds,
    String? lastReason,
  }) => FamilyCareBurdenState(
    emergencyShiftsTaken: emergencyShiftsTaken ?? this.emergencyShiftsTaken,
    missedPlannedShifts: missedPlannedShifts ?? this.missedPlannedShifts,
    careDebt: careDebt ?? this.careDebt,
    strain: strain ?? this.strain,
    lastChangedAtSeconds: lastChangedAtSeconds ?? this.lastChangedAtSeconds,
    lastReason: lastReason ?? this.lastReason,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    if (emergencyShiftsTaken > 0)
      'emergency_shifts_taken': emergencyShiftsTaken,
    if (missedPlannedShifts > 0) 'missed_planned_shifts': missedPlannedShifts,
    if (careDebt > 0) 'care_debt': careDebt,
    if (strain > 0) 'strain': strain,
    if (lastChangedAtSeconds != null)
      'last_changed_at_seconds': lastChangedAtSeconds,
    if (lastReason != null) 'last_reason': lastReason,
  };

  factory FamilyCareBurdenState.fromJson(Map<String, Object?> json) =>
      FamilyCareBurdenState(
        emergencyShiftsTaken: json['emergency_shifts_taken'] as int? ?? 0,
        missedPlannedShifts: json['missed_planned_shifts'] as int? ?? 0,
        careDebt: json['care_debt'] as int? ?? 0,
        strain: json['strain'] as int? ?? 0,
        lastChangedAtSeconds: json['last_changed_at_seconds'] as int?,
        lastReason: json['last_reason'] as String?,
      );
}

enum FamilyCareConflictStatus { open, repaired, unresolved }

/// Một mâu thuẫn cụ thể do thành viên phải gánh ca của người khác.
class FamilyCareConflictState {
  const FamilyCareConflictState({
    required this.id,
    required this.supporterId,
    required this.responsibleId,
    required this.causeRequestId,
    required this.openedAtSeconds,
    required this.severity,
    this.status = FamilyCareConflictStatus.open,
    this.conversationAtSeconds,
    this.outcome,
  });

  final String id;
  final String supporterId;
  final String responsibleId;
  final String causeRequestId;
  final int openedAtSeconds;
  final int severity;
  final FamilyCareConflictStatus status;
  final int? conversationAtSeconds;
  final String? outcome;

  FamilyCareConflictState conclude({
    required int atSeconds,
    required bool repaired,
    required String outcome,
  }) => FamilyCareConflictState(
    id: id,
    supporterId: supporterId,
    responsibleId: responsibleId,
    causeRequestId: causeRequestId,
    openedAtSeconds: openedAtSeconds,
    severity: severity,
    status: repaired
        ? FamilyCareConflictStatus.repaired
        : FamilyCareConflictStatus.unresolved,
    conversationAtSeconds: atSeconds,
    outcome: outcome,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'supporter_id': supporterId,
    'responsible_id': responsibleId,
    'cause_request_id': causeRequestId,
    'opened_at_seconds': openedAtSeconds,
    'severity': severity,
    'status': status.name,
    if (conversationAtSeconds != null)
      'conversation_at_seconds': conversationAtSeconds,
    if (outcome != null) 'outcome': outcome,
  };

  factory FamilyCareConflictState.fromJson(Map<String, Object?> json) =>
      FamilyCareConflictState(
        id: json['id']! as String,
        supporterId: json['supporter_id']! as String,
        responsibleId: json['responsible_id']! as String,
        causeRequestId: json['cause_request_id']! as String,
        openedAtSeconds: json['opened_at_seconds']! as int,
        severity: json['severity']! as int,
        status: FamilyCareConflictStatus.values.byName(
          json['status']! as String,
        ),
        conversationAtSeconds: json['conversation_at_seconds'] as int?,
        outcome: json['outcome'] as String?,
      );
}

enum FamilyCarePromiseStatus { active, fulfilled, broken }

/// Cam kết bù ca được tạo ra sau một cuộc hòa giải giữa hai thành viên.
class FamilyCarePromiseState {
  const FamilyCarePromiseState({
    required this.id,
    required this.debtorId,
    required this.beneficiaryId,
    required this.sourceConflictId,
    required this.madeAtSeconds,
    required this.dueDay,
    required this.promisedShifts,
    this.assignedShifts = 0,
    this.status = FamilyCarePromiseStatus.active,
    this.resolvedAtSeconds,
  });

  final String id;
  final String debtorId;
  final String beneficiaryId;
  final String sourceConflictId;
  final int madeAtSeconds;
  final int dueDay;
  final int promisedShifts;
  final int assignedShifts;
  final FamilyCarePromiseStatus status;
  final int? resolvedAtSeconds;

  int get missingShifts =>
      (promisedShifts - assignedShifts).clamp(0, promisedShifts);

  FamilyCarePromiseState settle({
    required int assignedShifts,
    required int atSeconds,
  }) => FamilyCarePromiseState(
    id: id,
    debtorId: debtorId,
    beneficiaryId: beneficiaryId,
    sourceConflictId: sourceConflictId,
    madeAtSeconds: madeAtSeconds,
    dueDay: dueDay,
    promisedShifts: promisedShifts,
    assignedShifts: assignedShifts,
    status: assignedShifts >= promisedShifts
        ? FamilyCarePromiseStatus.fulfilled
        : FamilyCarePromiseStatus.broken,
    resolvedAtSeconds: atSeconds,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'debtor_id': debtorId,
    'beneficiary_id': beneficiaryId,
    'source_conflict_id': sourceConflictId,
    'made_at_seconds': madeAtSeconds,
    'due_day': dueDay,
    'promised_shifts': promisedShifts,
    if (assignedShifts > 0) 'assigned_shifts': assignedShifts,
    'status': status.name,
    if (resolvedAtSeconds != null) 'resolved_at_seconds': resolvedAtSeconds,
  };

  factory FamilyCarePromiseState.fromJson(Map<String, Object?> json) =>
      FamilyCarePromiseState(
        id: json['id']! as String,
        debtorId: json['debtor_id']! as String,
        beneficiaryId: json['beneficiary_id']! as String,
        sourceConflictId: json['source_conflict_id']! as String,
        madeAtSeconds: json['made_at_seconds']! as int,
        dueDay: json['due_day']! as int,
        promisedShifts: json['promised_shifts']! as int,
        assignedShifts: json['assigned_shifts'] as int? ?? 0,
        status: FamilyCarePromiseStatus.values.byName(
          json['status']! as String,
        ),
        resolvedAtSeconds: json['resolved_at_seconds'] as int?,
      );
}

/// Danh tiếng nội bộ của một thành viên về việc chăm sóc và giữ cam kết.
class FamilyCareReliabilityState {
  const FamilyCareReliabilityState({
    this.score = 500,
    this.emergencyResponses = 0,
    this.promisesMade = 0,
    this.promisesKept = 0,
    this.promisesBroken = 0,
    this.lastChangedAtSeconds,
    this.lastReason,
  });

  final int score;
  final int emergencyResponses;
  final int promisesMade;
  final int promisesKept;
  final int promisesBroken;
  final int? lastChangedAtSeconds;
  final String? lastReason;

  FamilyCareReliabilityState recordEmergencyResponse(int atSeconds) => _copy(
    score: (score + 12).clamp(0, 1000),
    emergencyResponses: emergencyResponses + 1,
    lastChangedAtSeconds: atSeconds,
    lastReason: 'emergency_response',
  );

  FamilyCareReliabilityState recordPromiseMade(int atSeconds) => _copy(
    promisesMade: promisesMade + 1,
    lastChangedAtSeconds: atSeconds,
    lastReason: 'promise_made',
  );

  FamilyCareReliabilityState recordPromiseResult({
    required int atSeconds,
    required bool kept,
  }) => _copy(
    score: (score + (kept ? 55 : -110)).clamp(0, 1000),
    promisesKept: promisesKept + (kept ? 1 : 0),
    promisesBroken: promisesBroken + (kept ? 0 : 1),
    lastChangedAtSeconds: atSeconds,
    lastReason: kept ? 'promise_kept' : 'promise_broken',
  );

  FamilyCareReliabilityState _copy({
    int? score,
    int? emergencyResponses,
    int? promisesMade,
    int? promisesKept,
    int? promisesBroken,
    int? lastChangedAtSeconds,
    String? lastReason,
  }) => FamilyCareReliabilityState(
    score: score ?? this.score,
    emergencyResponses: emergencyResponses ?? this.emergencyResponses,
    promisesMade: promisesMade ?? this.promisesMade,
    promisesKept: promisesKept ?? this.promisesKept,
    promisesBroken: promisesBroken ?? this.promisesBroken,
    lastChangedAtSeconds: lastChangedAtSeconds ?? this.lastChangedAtSeconds,
    lastReason: lastReason ?? this.lastReason,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'score': score,
    if (emergencyResponses > 0) 'emergency_responses': emergencyResponses,
    if (promisesMade > 0) 'promises_made': promisesMade,
    if (promisesKept > 0) 'promises_kept': promisesKept,
    if (promisesBroken > 0) 'promises_broken': promisesBroken,
    if (lastChangedAtSeconds != null)
      'last_changed_at_seconds': lastChangedAtSeconds,
    if (lastReason != null) 'last_reason': lastReason,
  };

  factory FamilyCareReliabilityState.fromJson(Map<String, Object?> json) =>
      FamilyCareReliabilityState(
        score: json['score'] as int? ?? 500,
        emergencyResponses: json['emergency_responses'] as int? ?? 0,
        promisesMade: json['promises_made'] as int? ?? 0,
        promisesKept: json['promises_kept'] as int? ?? 0,
        promisesBroken: json['promises_broken'] as int? ?? 0,
        lastChangedAtSeconds: json['last_changed_at_seconds'] as int?,
        lastReason: json['last_reason'] as String?,
      );
}
