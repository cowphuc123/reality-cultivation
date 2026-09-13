/// Ảnh chụp khả năng tự duy trì của một hộ ở cuối một ngày.
class HouseholdSurvivalSnapshot {
  const HouseholdSurvivalSnapshot({
    required this.householdId,
    required this.foodQuantity,
    required this.waterQuantity,
    required this.fuelQuantity,
    required this.availableAdultWorkers,
    required this.activeIllnesses,
    required this.mealShortfalls,
    required this.newMealShortfalls,
    required this.pressureKinds,
    required this.criticalReasons,
  });

  final String householdId;
  final int? foodQuantity;
  final int? waterQuantity;
  final int? fuelQuantity;
  final int availableAdultWorkers;
  final int activeIllnesses;
  final int mealShortfalls;
  final int newMealShortfalls;
  final List<String> pressureKinds;
  final List<String> criticalReasons;

  bool get critical => criticalReasons.isNotEmpty;
  bool get underPressure => pressureKinds.isNotEmpty || critical;

  Map<String, Object?> toJson() => <String, Object?>{
    'household_id': householdId,
    'food_quantity': foodQuantity,
    'water_quantity': waterQuantity,
    'fuel_quantity': fuelQuantity,
    'available_adult_workers': availableAdultWorkers,
    'active_illnesses': activeIllnesses,
    'meal_shortfalls': mealShortfalls,
    'new_meal_shortfalls': newMealShortfalls,
    'pressure_kinds': pressureKinds,
    'critical_reasons': criticalReasons,
  };

  factory HouseholdSurvivalSnapshot.fromJson(Map<String, Object?> json) =>
      HouseholdSurvivalSnapshot(
        householdId: json['household_id']! as String,
        foodQuantity: json['food_quantity'] as int?,
        waterQuantity: json['water_quantity'] as int?,
        fuelQuantity: json['fuel_quantity'] as int?,
        availableAdultWorkers: json['available_adult_workers']! as int,
        activeIllnesses: json['active_illnesses']! as int,
        mealShortfalls: json['meal_shortfalls']! as int,
        newMealShortfalls: json['new_meal_shortfalls']! as int,
        pressureKinds: (json['pressure_kinds']! as List<Object?>)
            .cast<String>(),
        criticalReasons: (json['critical_reasons']! as List<Object?>)
            .cast<String>(),
      );
}

/// Một lần kiểm tra toàn làng ở cuối ngày, dựa hoàn toàn trên trạng thái thật.
class CommunityDaySnapshot {
  const CommunityDaySnapshot({
    required this.day,
    required this.recordedAtSeconds,
    required this.households,
    required this.travelingExchanges,
    required this.overdueExchanges,
  });

  final int day;
  final int recordedAtSeconds;
  final List<HouseholdSurvivalSnapshot> households;
  final int travelingExchanges;
  final int overdueExchanges;

  int get pressuredHouseholds => households
      .where((HouseholdSurvivalSnapshot value) => value.underPressure)
      .length;
  int get criticalHouseholds => households
      .where((HouseholdSurvivalSnapshot value) => value.critical)
      .length;
  bool get requiresUnsupportedRescue =>
      criticalHouseholds > 0 || overdueExchanges > 0;

  Map<String, Object?> toJson() => <String, Object?>{
    'day': day,
    'recorded_at_seconds': recordedAtSeconds,
    'households': households
        .map((HouseholdSurvivalSnapshot value) => value.toJson())
        .toList(),
    'traveling_exchanges': travelingExchanges,
    'overdue_exchanges': overdueExchanges,
  };

  factory CommunityDaySnapshot.fromJson(Map<String, Object?> json) =>
      CommunityDaySnapshot(
        day: json['day']! as int,
        recordedAtSeconds: json['recorded_at_seconds']! as int,
        households: <HouseholdSurvivalSnapshot>[
          for (final Object? value in json['households']! as List<Object?>)
            HouseholdSurvivalSnapshot.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
        travelingExchanges: json['traveling_exchanges']! as int,
        overdueExchanges: json['overdue_exchanges']! as int,
      );
}

enum CommunityResourceRequestStatus {
  detected,
  seeking,
  inquiring,
  introductionTravel,
  negotiating,
  goodsInTransit,
  resolved,
  failed,
  cancelled,
}

/// Vòng đời một nhu cầu mà hộ cố giải quyết qua mạng cộng đồng.
class CommunityResourceRequestState {
  const CommunityResourceRequestState({
    required this.id,
    required this.householdId,
    required this.resource,
    required this.openedAtSeconds,
    required this.updatedAtSeconds,
    required this.status,
    required this.urgency,
    this.attemptCount = 0,
    this.askerId,
    this.intermediaryId,
    this.providerHouseholdId,
    this.providerContactId,
    this.exchangeId,
    this.lastFailureReason,
    this.nextRetryAtSeconds,
  });

  final String id;
  final String householdId;
  final String resource;
  final int openedAtSeconds;
  final int updatedAtSeconds;
  final CommunityResourceRequestStatus status;
  final int urgency;
  final int attemptCount;
  final String? askerId;
  final String? intermediaryId;
  final String? providerHouseholdId;
  final String? providerContactId;
  final String? exchangeId;
  final String? lastFailureReason;
  final int? nextRetryAtSeconds;

  bool get active => switch (status) {
    CommunityResourceRequestStatus.resolved ||
    CommunityResourceRequestStatus.failed ||
    CommunityResourceRequestStatus.cancelled => false,
    _ => true,
  };

  CommunityResourceRequestState advance({
    required CommunityResourceRequestStatus status,
    required int atSeconds,
    String? askerId,
    String? intermediaryId,
    String? providerHouseholdId,
    String? providerContactId,
    String? exchangeId,
    bool countAttempt = false,
  }) => CommunityResourceRequestState(
    id: id,
    householdId: householdId,
    resource: resource,
    openedAtSeconds: openedAtSeconds,
    updatedAtSeconds: atSeconds,
    status: status,
    urgency: urgency,
    attemptCount: attemptCount + (countAttempt ? 1 : 0),
    askerId: askerId ?? this.askerId,
    intermediaryId: intermediaryId ?? this.intermediaryId,
    providerHouseholdId: providerHouseholdId ?? this.providerHouseholdId,
    providerContactId: providerContactId ?? this.providerContactId,
    exchangeId: exchangeId ?? this.exchangeId,
  );

  CommunityResourceRequestState fail({
    required int atSeconds,
    required String reason,
    required int retryAfterSeconds,
  }) => CommunityResourceRequestState(
    id: id,
    householdId: householdId,
    resource: resource,
    openedAtSeconds: openedAtSeconds,
    updatedAtSeconds: atSeconds,
    status: CommunityResourceRequestStatus.failed,
    urgency: urgency,
    attemptCount: attemptCount,
    askerId: askerId,
    intermediaryId: intermediaryId,
    providerHouseholdId: providerHouseholdId,
    providerContactId: providerContactId,
    exchangeId: exchangeId,
    lastFailureReason: reason,
    nextRetryAtSeconds: atSeconds + retryAfterSeconds,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'household_id': householdId,
    'resource': resource,
    'opened_at_seconds': openedAtSeconds,
    'updated_at_seconds': updatedAtSeconds,
    'status': status.name,
    'urgency': urgency,
    'attempt_count': attemptCount,
    if (askerId != null) 'asker_id': askerId,
    if (intermediaryId != null) 'intermediary_id': intermediaryId,
    if (providerHouseholdId != null)
      'provider_household_id': providerHouseholdId,
    if (providerContactId != null) 'provider_contact_id': providerContactId,
    if (exchangeId != null) 'exchange_id': exchangeId,
    if (lastFailureReason != null) 'last_failure_reason': lastFailureReason,
    if (nextRetryAtSeconds != null) 'next_retry_at_seconds': nextRetryAtSeconds,
  };

  factory CommunityResourceRequestState.fromJson(Map<String, Object?> json) =>
      CommunityResourceRequestState(
        id: json['id']! as String,
        householdId: json['household_id']! as String,
        resource: json['resource']! as String,
        openedAtSeconds: json['opened_at_seconds']! as int,
        updatedAtSeconds: json['updated_at_seconds']! as int,
        status: CommunityResourceRequestStatus.values.byName(
          json['status']! as String,
        ),
        urgency: json['urgency']! as int,
        attemptCount: json['attempt_count'] as int? ?? 0,
        askerId: json['asker_id'] as String?,
        intermediaryId: json['intermediary_id'] as String?,
        providerHouseholdId: json['provider_household_id'] as String?,
        providerContactId: json['provider_contact_id'] as String?,
        exchangeId: json['exchange_id'] as String?,
        lastFailureReason: json['last_failure_reason'] as String?,
        nextRetryAtSeconds: json['next_retry_at_seconds'] as int?,
      );
}

/// Hồ sơ 30 ngày dùng để tìm chính xác nơi cộng đồng không tự vận hành được.
class CommunitySurvivalState {
  const CommunitySurvivalState({
    this.targetDays = 30,
    this.days = const <CommunityDaySnapshot>[],
    this.resourceRequests = const <String, CommunityResourceRequestState>{},
  });

  final int targetDays;
  final List<CommunityDaySnapshot> days;
  final Map<String, CommunityResourceRequestState> resourceRequests;

  int get recordedDays => days.length;
  bool get complete => recordedDays >= targetDays;
  int get daysRequiringUnsupportedRescue => days
      .where((CommunityDaySnapshot day) => day.requiresUnsupportedRescue)
      .length;
  CommunityDaySnapshot? get latest => days.isEmpty ? null : days.last;

  CommunitySurvivalState record(CommunityDaySnapshot snapshot) {
    if (days.any((CommunityDaySnapshot value) => value.day == snapshot.day)) {
      return this;
    }
    return CommunitySurvivalState(
      targetDays: targetDays,
      days: <CommunityDaySnapshot>[...days, snapshot],
      resourceRequests: resourceRequests,
    );
  }

  CommunitySurvivalState withResourceRequest(
    CommunityResourceRequestState request,
  ) => CommunitySurvivalState(
    targetDays: targetDays,
    days: days,
    resourceRequests: <String, CommunityResourceRequestState>{
      ...resourceRequests,
      request.id: request,
    },
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'target_days': targetDays,
    'days': days.map((CommunityDaySnapshot value) => value.toJson()).toList(),
    if (resourceRequests.isNotEmpty)
      'resource_requests': <String, Object?>{
        for (final String key in resourceRequests.keys.toList()..sort())
          key: resourceRequests[key]!.toJson(),
      },
  };

  factory CommunitySurvivalState.fromJson(
    Map<String, Object?> json,
  ) => CommunitySurvivalState(
    targetDays: json['target_days'] as int? ?? 30,
    days: <CommunityDaySnapshot>[
      for (final Object? value
          in (json['days'] as List<Object?>? ?? const <Object?>[]))
        CommunityDaySnapshot.fromJson((value! as Map).cast<String, Object?>()),
    ],
    resourceRequests: <String, CommunityResourceRequestState>{
      for (final MapEntry<String, Object?> entry
          in ((json['resource_requests'] as Map?)?.cast<String, Object?>() ??
                  const <String, Object?>{})
              .entries)
        entry.key: CommunityResourceRequestState.fromJson(
          (entry.value! as Map).cast<String, Object?>(),
        ),
    },
  );
}
