import 'family.dart';

class HouseholdState {
  const HouseholdState({
    required this.id,
    required this.name,
    required this.memberIds,
    required this.resourceItemIds,
    required this.authorizedUsersByItemId,
    required this.scheduledWorkSecondsByPerson,
    this.careInterruptionSecondsByPerson = const <String, int>{},
    this.totalCareInterruptionSecondsByPerson = const <String, int>{},
    this.workCompletedSecondsByPerson = const <String, int>{},
    this.foodConsumedGrams = 0,
    this.waterConsumedMl = 0,
    this.fuelConsumedGrams = 0,
    this.mealsCompleted = 0,
    this.mealShortfalls = 0,
    this.unauthorizedAttempts = 0,
    this.supplyDeliveries = 0,
    this.productionRuns = 0,
    this.caregiverSubstitutions = 0,
    this.wellbeing = false,
    this.adultIllness = false,
    this.workSubstitution = false,
    this.birthCaregiverRole,
    this.familyOriginSummary,
    this.birthGenesisFingerprint,
    this.birthFamilyRolesByPersonId = const <String, String>{},
    this.familyCareScheduling = false,
    this.familyMemory = false,
    this.familyCareNegotiation = false,
    this.familyCareSupport = false,
    this.familyCareResilience = false,
    this.familyCareBurdenEnabled = false,
    this.familyCareConflictEnabled = false,
    this.familyCarePromiseEnabled = false,
    this.familyCareReliabilityEnabled = false,
    this.familyCareWitnessMemory = false,
    this.infantAttachmentLearning = false,
    this.familyCareSubjectId,
    this.familyCarePlan,
    this.familyCareSupportRequests = const <FamilyCareSupportRequestState>[],
    this.familyCareBurdenByPersonId = const <String, FamilyCareBurdenState>{},
    this.familyCareConflicts = const <FamilyCareConflictState>[],
    this.familyCarePromises = const <FamilyCarePromiseState>[],
    this.familyCareReliabilityByPersonId =
        const <String, FamilyCareReliabilityState>{},
  });

  final String id;
  final String name;
  final List<String> memberIds;
  final Map<String, String> resourceItemIds;
  final Map<String, Set<String>> authorizedUsersByItemId;
  final Map<String, int> scheduledWorkSecondsByPerson;
  final Map<String, int> careInterruptionSecondsByPerson;
  final Map<String, int> totalCareInterruptionSecondsByPerson;
  final Map<String, int> workCompletedSecondsByPerson;
  final int foodConsumedGrams;
  final int waterConsumedMl;
  final int fuelConsumedGrams;
  final int mealsCompleted;
  final int mealShortfalls;
  final int unauthorizedAttempts;
  final int supplyDeliveries;
  final int productionRuns;
  final int caregiverSubstitutions;

  /// Hộ có theo dõi tay nghề lên tay, cơn đói và tâm trạng của thành viên hay không.
  final bool wellbeing;

  /// Hộ có theo dõi bệnh của người lớn hay không.
  final bool adultIllness;

  /// Hộ có thể chuyển ca việc cố định của người nghỉ bệnh cho người khác.
  final bool workSubstitution;

  /// Metadata nguồn gốc chỉ xuất hiện ở hộ được phép đón P00.
  final String? birthCaregiverRole;
  final String? familyOriginSummary;
  final String? birthGenesisFingerprint;
  final Map<String, String> birthFamilyRolesByPersonId;

  /// Nếu bật, ca việc blocking và quyền dùng sữa tham gia chọn người chăm.
  final bool familyCareScheduling;

  /// Nếu bật, chăm sóc tạo ký ức quan hệ và hao sức của người thực hiện.
  final bool familyMemory;

  /// Nếu bật, hộ chia lại ca chăm dựa trên trạng thái từng thành viên mỗi ngày.
  final bool familyCareNegotiation;
  final bool familyCareSupport;
  final bool familyCareResilience;
  final bool familyCareBurdenEnabled;
  final bool familyCareConflictEnabled;
  final bool familyCarePromiseEnabled;
  final bool familyCareReliabilityEnabled;
  final bool familyCareWitnessMemory;
  final bool infantAttachmentLearning;
  final String? familyCareSubjectId;
  final FamilyCarePlanState? familyCarePlan;
  final List<FamilyCareSupportRequestState> familyCareSupportRequests;
  final Map<String, FamilyCareBurdenState> familyCareBurdenByPersonId;
  final List<FamilyCareConflictState> familyCareConflicts;
  final List<FamilyCarePromiseState> familyCarePromises;
  final Map<String, FamilyCareReliabilityState> familyCareReliabilityByPersonId;

  int get brokenCareShifts => familyCareSupportRequests.length;
  int get fulfilledCareSupportRequests => familyCareSupportRequests
      .where(
        (FamilyCareSupportRequestState request) =>
            request.status == FamilyCareSupportStatus.fulfilled,
      )
      .length;
  int get pendingCareSupportRequests => familyCareSupportRequests
      .where(
        (FamilyCareSupportRequestState request) =>
            request.status == FamilyCareSupportStatus.pending,
      )
      .length;
  int get expiredCareSupportRequests => familyCareSupportRequests
      .where(
        (FamilyCareSupportRequestState request) =>
            request.status == FamilyCareSupportStatus.expired,
      )
      .length;

  bool canUse(String personId, String itemId) =>
      authorizedUsersByItemId[itemId]?.contains(personId) ?? false;

  HouseholdState recordCareInterruption(String personId, int seconds) => _copy(
    careInterruptionSecondsByPerson: <String, int>{
      ...careInterruptionSecondsByPerson,
      personId: (careInterruptionSecondsByPerson[personId] ?? 0) + seconds,
    },
    totalCareInterruptionSecondsByPerson: <String, int>{
      ...totalCareInterruptionSecondsByPerson,
      personId: (totalCareInterruptionSecondsByPerson[personId] ?? 0) + seconds,
    },
  );

  HouseholdState recordMeal({
    required int foodGrams,
    required int waterMl,
    required int fuelGrams,
  }) => _copy(
    foodConsumedGrams: foodConsumedGrams + foodGrams,
    waterConsumedMl: waterConsumedMl + waterMl,
    fuelConsumedGrams: fuelConsumedGrams + fuelGrams,
    mealsCompleted: mealsCompleted + 1,
  );

  HouseholdState recordShortfall() => _copy(mealShortfalls: mealShortfalls + 1);

  HouseholdState recordUnauthorizedAttempt() =>
      _copy(unauthorizedAttempts: unauthorizedAttempts + 1);

  HouseholdState recordSupplyDelivery() =>
      _copy(supplyDeliveries: supplyDeliveries + 1);

  HouseholdState recordProduction() =>
      _copy(productionRuns: productionRuns + 1);

  HouseholdState recordCaregiverSubstitution() =>
      _copy(caregiverSubstitutions: caregiverSubstitutions + 1);

  HouseholdState withFamilyCarePlan(FamilyCarePlanState value) =>
      _copy(familyCarePlan: value);

  HouseholdState recordFamilyCareSupport(
    FamilyCareSupportRequestState request,
  ) => _copy(
    familyCareSupportRequests: <FamilyCareSupportRequestState>[
      ...familyCareSupportRequests,
      request,
    ].skip(familyCareSupportRequests.length >= 32 ? 1 : 0).toList(),
  );

  HouseholdState updateFamilyCareSupport(
    FamilyCareSupportRequestState request,
  ) => _copy(
    familyCareSupportRequests: <FamilyCareSupportRequestState>[
      for (final FamilyCareSupportRequestState existing
          in familyCareSupportRequests)
        if (existing.id == request.id) request else existing,
    ],
  );

  HouseholdState recordEmergencyCareBurden({
    required String? plannedCaregiverId,
    required String supporterId,
    required int atSeconds,
    required int delaySeconds,
  }) {
    if (!familyCareBurdenEnabled || plannedCaregiverId == supporterId) {
      return this;
    }
    final Map<String, FamilyCareBurdenState> burdens =
        <String, FamilyCareBurdenState>{...familyCareBurdenByPersonId};
    burdens[supporterId] =
        (burdens[supporterId] ?? const FamilyCareBurdenState())
            .recordEmergencyShift(
              atSeconds: atSeconds,
              delaySeconds: delaySeconds,
            );
    final Map<String, FamilyCareReliabilityState> reliability =
        <String, FamilyCareReliabilityState>{
          ...familyCareReliabilityByPersonId,
        };
    if (familyCareReliabilityEnabled) {
      reliability[supporterId] =
          (reliability[supporterId] ?? const FamilyCareReliabilityState())
              .recordEmergencyResponse(atSeconds);
    }
    if (plannedCaregiverId != null) {
      burdens[plannedCaregiverId] =
          (burdens[plannedCaregiverId] ?? const FamilyCareBurdenState())
              .recordMissedShift(atSeconds: atSeconds);
    }
    return _copy(
      familyCareBurdenByPersonId: burdens,
      familyCareReliabilityByPersonId: reliability,
    );
  }

  HouseholdState settleFamilyCareBurden(Map<String, int> assignedShifts) {
    if (!familyCareBurdenEnabled) return this;
    return _copy(
      familyCareBurdenByPersonId: <String, FamilyCareBurdenState>{
        for (final String personId in <String>{
          ...familyCareBurdenByPersonId.keys,
          ...assignedShifts.keys,
        })
          personId:
              (familyCareBurdenByPersonId[personId] ??
                      const FamilyCareBurdenState())
                  .afterDailyPlan(assignedShifts[personId] ?? 0),
      },
    );
  }

  HouseholdState recordFamilyCareConflict(FamilyCareConflictState conflict) =>
      _copy(
        familyCareConflicts: <FamilyCareConflictState>[
          ...familyCareConflicts,
          conflict,
        ].skip(familyCareConflicts.length >= 24 ? 1 : 0).toList(),
      );

  HouseholdState updateFamilyCareConflict(FamilyCareConflictState conflict) =>
      _copy(
        familyCareConflicts: <FamilyCareConflictState>[
          for (final FamilyCareConflictState existing in familyCareConflicts)
            if (existing.id == conflict.id) conflict else existing,
        ],
      );

  HouseholdState recordFamilyCarePromise(FamilyCarePromiseState promise) {
    final Map<String, FamilyCareReliabilityState> reliability =
        <String, FamilyCareReliabilityState>{
          ...familyCareReliabilityByPersonId,
        };
    if (familyCareReliabilityEnabled) {
      reliability[promise.debtorId] =
          (reliability[promise.debtorId] ?? const FamilyCareReliabilityState())
              .recordPromiseMade(promise.madeAtSeconds);
    }
    return _copy(
      familyCarePromises: <FamilyCarePromiseState>[
        ...familyCarePromises,
        promise,
      ].skip(familyCarePromises.length >= 24 ? 1 : 0).toList(),
      familyCareReliabilityByPersonId: reliability,
    );
  }

  HouseholdState updateFamilyCarePromises(
    List<FamilyCarePromiseState> promises,
  ) {
    final Map<String, FamilyCareReliabilityState> reliability =
        <String, FamilyCareReliabilityState>{
          ...familyCareReliabilityByPersonId,
        };
    if (familyCareReliabilityEnabled) {
      for (final FamilyCarePromiseState next in promises) {
        final FamilyCarePromiseState? previous = familyCarePromises
            .where((FamilyCarePromiseState value) => value.id == next.id)
            .firstOrNull;
        if (previous?.status != FamilyCarePromiseStatus.active ||
            next.status == FamilyCarePromiseStatus.active) {
          continue;
        }
        reliability[next.debtorId] =
            (reliability[next.debtorId] ?? const FamilyCareReliabilityState())
                .recordPromiseResult(
                  atSeconds: next.resolvedAtSeconds ?? next.madeAtSeconds,
                  kept: next.status == FamilyCarePromiseStatus.fulfilled,
                );
      }
    }
    return _copy(
      familyCarePromises: promises,
      familyCareReliabilityByPersonId: reliability,
    );
  }

  HouseholdState addMember(String personId) {
    if (memberIds.contains(personId)) return this;
    return _copy(memberIds: <String>[...memberIds, personId]);
  }

  HouseholdState settleWorkDay() {
    final Map<String, int> completed = <String, int>{
      ...workCompletedSecondsByPerson,
    };
    for (final MapEntry<String, int> entry
        in scheduledWorkSecondsByPerson.entries) {
      final int lost = careInterruptionSecondsByPerson[entry.key] ?? 0;
      completed[entry.key] =
          (completed[entry.key] ?? 0) +
          (entry.value - lost).clamp(0, entry.value);
    }
    return _copy(
      careInterruptionSecondsByPerson: const <String, int>{},
      workCompletedSecondsByPerson: completed,
    );
  }

  HouseholdState _copy({
    List<String>? memberIds,
    Map<String, int>? careInterruptionSecondsByPerson,
    Map<String, int>? totalCareInterruptionSecondsByPerson,
    Map<String, int>? workCompletedSecondsByPerson,
    int? foodConsumedGrams,
    int? waterConsumedMl,
    int? fuelConsumedGrams,
    int? mealsCompleted,
    int? mealShortfalls,
    int? unauthorizedAttempts,
    int? supplyDeliveries,
    int? productionRuns,
    int? caregiverSubstitutions,
    FamilyCarePlanState? familyCarePlan,
    List<FamilyCareSupportRequestState>? familyCareSupportRequests,
    Map<String, FamilyCareBurdenState>? familyCareBurdenByPersonId,
    List<FamilyCareConflictState>? familyCareConflicts,
    List<FamilyCarePromiseState>? familyCarePromises,
    Map<String, FamilyCareReliabilityState>? familyCareReliabilityByPersonId,
  }) => HouseholdState(
    id: id,
    name: name,
    memberIds: memberIds ?? this.memberIds,
    resourceItemIds: resourceItemIds,
    authorizedUsersByItemId: authorizedUsersByItemId,
    scheduledWorkSecondsByPerson: scheduledWorkSecondsByPerson,
    careInterruptionSecondsByPerson:
        careInterruptionSecondsByPerson ?? this.careInterruptionSecondsByPerson,
    totalCareInterruptionSecondsByPerson:
        totalCareInterruptionSecondsByPerson ??
        this.totalCareInterruptionSecondsByPerson,
    workCompletedSecondsByPerson:
        workCompletedSecondsByPerson ?? this.workCompletedSecondsByPerson,
    foodConsumedGrams: foodConsumedGrams ?? this.foodConsumedGrams,
    waterConsumedMl: waterConsumedMl ?? this.waterConsumedMl,
    fuelConsumedGrams: fuelConsumedGrams ?? this.fuelConsumedGrams,
    mealsCompleted: mealsCompleted ?? this.mealsCompleted,
    mealShortfalls: mealShortfalls ?? this.mealShortfalls,
    unauthorizedAttempts: unauthorizedAttempts ?? this.unauthorizedAttempts,
    supplyDeliveries: supplyDeliveries ?? this.supplyDeliveries,
    productionRuns: productionRuns ?? this.productionRuns,
    caregiverSubstitutions:
        caregiverSubstitutions ?? this.caregiverSubstitutions,
    wellbeing: wellbeing,
    adultIllness: adultIllness,
    workSubstitution: workSubstitution,
    birthCaregiverRole: birthCaregiverRole,
    familyOriginSummary: familyOriginSummary,
    birthGenesisFingerprint: birthGenesisFingerprint,
    birthFamilyRolesByPersonId: birthFamilyRolesByPersonId,
    familyCareScheduling: familyCareScheduling,
    familyMemory: familyMemory,
    familyCareNegotiation: familyCareNegotiation,
    familyCareSupport: familyCareSupport,
    familyCareResilience: familyCareResilience,
    familyCareBurdenEnabled: familyCareBurdenEnabled,
    familyCareConflictEnabled: familyCareConflictEnabled,
    familyCarePromiseEnabled: familyCarePromiseEnabled,
    familyCareReliabilityEnabled: familyCareReliabilityEnabled,
    familyCareWitnessMemory: familyCareWitnessMemory,
    infantAttachmentLearning: infantAttachmentLearning,
    familyCareSubjectId: familyCareSubjectId,
    familyCarePlan: familyCarePlan ?? this.familyCarePlan,
    familyCareSupportRequests:
        familyCareSupportRequests ?? this.familyCareSupportRequests,
    familyCareBurdenByPersonId:
        familyCareBurdenByPersonId ?? this.familyCareBurdenByPersonId,
    familyCareConflicts: familyCareConflicts ?? this.familyCareConflicts,
    familyCarePromises: familyCarePromises ?? this.familyCarePromises,
    familyCareReliabilityByPersonId:
        familyCareReliabilityByPersonId ?? this.familyCareReliabilityByPersonId,
  );

  Map<String, Object?> toJson() {
    final Map<String, List<String>> rights = <String, List<String>>{};
    for (final String itemId in authorizedUsersByItemId.keys.toList()..sort()) {
      rights[itemId] = authorizedUsersByItemId[itemId]!.toList()..sort();
    }
    return <String, Object?>{
      'id': id,
      'name': name,
      'member_ids': memberIds.toList()..sort(),
      'resource_item_ids': _sortedMap(resourceItemIds),
      'authorized_users_by_item_id': rights,
      'scheduled_work_seconds_by_person': _sortedMap(
        scheduledWorkSecondsByPerson,
      ),
      'care_interruption_seconds_by_person': _sortedMap(
        careInterruptionSecondsByPerson,
      ),
      'total_care_interruption_seconds_by_person': _sortedMap(
        totalCareInterruptionSecondsByPerson,
      ),
      'work_completed_seconds_by_person': _sortedMap(
        workCompletedSecondsByPerson,
      ),
      'food_consumed_grams': foodConsumedGrams,
      'water_consumed_ml': waterConsumedMl,
      'fuel_consumed_grams': fuelConsumedGrams,
      'meals_completed': mealsCompleted,
      'meal_shortfalls': mealShortfalls,
      'unauthorized_attempts': unauthorizedAttempts,
      if (supplyDeliveries > 0) 'supply_deliveries': supplyDeliveries,
      if (productionRuns > 0) 'production_runs': productionRuns,
      if (caregiverSubstitutions > 0)
        'caregiver_substitutions': caregiverSubstitutions,
      if (wellbeing) 'wellbeing': true,
      if (adultIllness) 'adult_illness': true,
      if (workSubstitution) 'work_substitution': true,
      if (birthCaregiverRole != null)
        'birth_caregiver_role': birthCaregiverRole!,
      if (familyOriginSummary != null)
        'family_origin_summary': familyOriginSummary!,
      if (birthGenesisFingerprint != null)
        'birth_genesis_fingerprint': birthGenesisFingerprint!,
      if (birthFamilyRolesByPersonId.isNotEmpty)
        'birth_family_roles_by_person_id': _sortedMap(
          birthFamilyRolesByPersonId,
        ),
      if (familyCareScheduling) 'family_care_scheduling': true,
      if (familyMemory) 'family_memory': true,
      if (familyCareNegotiation) 'family_care_negotiation': true,
      if (familyCareSupport) 'family_care_support': true,
      if (familyCareResilience) 'family_care_resilience': true,
      if (familyCareBurdenEnabled) 'family_care_burden_enabled': true,
      if (familyCareConflictEnabled) 'family_care_conflict_enabled': true,
      if (familyCarePromiseEnabled) 'family_care_promise_enabled': true,
      if (familyCareReliabilityEnabled) 'family_care_reliability_enabled': true,
      if (familyCareWitnessMemory) 'family_care_witness_memory': true,
      if (infantAttachmentLearning) 'infant_attachment_learning': true,
      if (familyCareSubjectId != null)
        'family_care_subject_id': familyCareSubjectId,
      if (familyCarePlan != null) 'family_care_plan': familyCarePlan!.toJson(),
      if (familyCareSupportRequests.isNotEmpty)
        'family_care_support_requests': familyCareSupportRequests
            .map((FamilyCareSupportRequestState request) => request.toJson())
            .toList(),
      if (familyCareBurdenByPersonId.isNotEmpty)
        'family_care_burden_by_person_id': <String, Object?>{
          for (final String personId
              in familyCareBurdenByPersonId.keys.toList()..sort())
            personId: familyCareBurdenByPersonId[personId]!.toJson(),
        },
      if (familyCareConflicts.isNotEmpty)
        'family_care_conflicts': familyCareConflicts
            .map((FamilyCareConflictState value) => value.toJson())
            .toList(),
      if (familyCarePromises.isNotEmpty)
        'family_care_promises': familyCarePromises
            .map((FamilyCarePromiseState value) => value.toJson())
            .toList(),
      if (familyCareReliabilityByPersonId.isNotEmpty)
        'family_care_reliability_by_person_id': <String, Object?>{
          for (final String personId
              in familyCareReliabilityByPersonId.keys.toList()..sort())
            personId: familyCareReliabilityByPersonId[personId]!.toJson(),
        },
    };
  }

  factory HouseholdState.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> rawRights =
        (json['authorized_users_by_item_id']! as Map).cast<String, Object?>();
    return HouseholdState(
      id: json['id']! as String,
      name: json['name']! as String,
      memberIds: (json['member_ids']! as List<Object?>).cast<String>(),
      resourceItemIds: (json['resource_item_ids']! as Map)
          .cast<String, String>(),
      authorizedUsersByItemId: <String, Set<String>>{
        for (final MapEntry<String, Object?> entry in rawRights.entries)
          entry.key: (entry.value! as List<Object?>).cast<String>().toSet(),
      },
      scheduledWorkSecondsByPerson:
          (json['scheduled_work_seconds_by_person']! as Map)
              .cast<String, int>(),
      careInterruptionSecondsByPerson:
          (json['care_interruption_seconds_by_person'] as Map?)
              ?.cast<String, int>() ??
          const <String, int>{},
      totalCareInterruptionSecondsByPerson:
          (json['total_care_interruption_seconds_by_person'] as Map?)
              ?.cast<String, int>() ??
          const <String, int>{},
      workCompletedSecondsByPerson:
          (json['work_completed_seconds_by_person'] as Map?)
              ?.cast<String, int>() ??
          const <String, int>{},
      foodConsumedGrams: json['food_consumed_grams'] as int? ?? 0,
      waterConsumedMl: json['water_consumed_ml'] as int? ?? 0,
      fuelConsumedGrams: json['fuel_consumed_grams'] as int? ?? 0,
      mealsCompleted: json['meals_completed'] as int? ?? 0,
      mealShortfalls: json['meal_shortfalls'] as int? ?? 0,
      unauthorizedAttempts: json['unauthorized_attempts'] as int? ?? 0,
      supplyDeliveries: json['supply_deliveries'] as int? ?? 0,
      productionRuns: json['production_runs'] as int? ?? 0,
      caregiverSubstitutions: json['caregiver_substitutions'] as int? ?? 0,
      wellbeing: json['wellbeing'] as bool? ?? false,
      adultIllness: json['adult_illness'] as bool? ?? false,
      workSubstitution: json['work_substitution'] as bool? ?? false,
      birthCaregiverRole: json['birth_caregiver_role'] as String?,
      familyOriginSummary: json['family_origin_summary'] as String?,
      birthGenesisFingerprint: json['birth_genesis_fingerprint'] as String?,
      birthFamilyRolesByPersonId:
          (json['birth_family_roles_by_person_id'] as Map?)
              ?.cast<String, String>() ??
          const <String, String>{},
      familyCareScheduling: json['family_care_scheduling'] as bool? ?? false,
      familyMemory: json['family_memory'] as bool? ?? false,
      familyCareNegotiation: json['family_care_negotiation'] as bool? ?? false,
      familyCareSupport: json['family_care_support'] as bool? ?? false,
      familyCareResilience: json['family_care_resilience'] as bool? ?? false,
      familyCareBurdenEnabled:
          json['family_care_burden_enabled'] as bool? ?? false,
      familyCareConflictEnabled:
          json['family_care_conflict_enabled'] as bool? ?? false,
      familyCarePromiseEnabled:
          json['family_care_promise_enabled'] as bool? ?? false,
      familyCareReliabilityEnabled:
          json['family_care_reliability_enabled'] as bool? ?? false,
      familyCareWitnessMemory:
          json['family_care_witness_memory'] as bool? ?? false,
      infantAttachmentLearning:
          json['infant_attachment_learning'] as bool? ?? false,
      familyCareSubjectId: json['family_care_subject_id'] as String?,
      familyCarePlan: json['family_care_plan'] == null
          ? null
          : FamilyCarePlanState.fromJson(
              (json['family_care_plan']! as Map).cast<String, Object?>(),
            ),
      familyCareSupportRequests:
          (json['family_care_support_requests'] as List<Object?>? ??
                  const <Object?>[])
              .map(
                (Object? value) => FamilyCareSupportRequestState.fromJson(
                  (value! as Map).cast<String, Object?>(),
                ),
              )
              .toList(),
      familyCareBurdenByPersonId: <String, FamilyCareBurdenState>{
        for (final MapEntry<String, Object?> entry
            in ((json['family_care_burden_by_person_id'] as Map?)
                        ?.cast<String, Object?>() ??
                    const <String, Object?>{})
                .entries)
          entry.key: FamilyCareBurdenState.fromJson(
            (entry.value! as Map).cast<String, Object?>(),
          ),
      },
      familyCareConflicts:
          (json['family_care_conflicts'] as List<Object?>? ?? const <Object?>[])
              .map(
                (Object? value) => FamilyCareConflictState.fromJson(
                  (value! as Map).cast<String, Object?>(),
                ),
              )
              .toList(),
      familyCarePromises:
          (json['family_care_promises'] as List<Object?>? ?? const <Object?>[])
              .map(
                (Object? value) => FamilyCarePromiseState.fromJson(
                  (value! as Map).cast<String, Object?>(),
                ),
              )
              .toList(),
      familyCareReliabilityByPersonId: <String, FamilyCareReliabilityState>{
        for (final MapEntry<String, Object?> entry
            in ((json['family_care_reliability_by_person_id'] as Map?)
                        ?.cast<String, Object?>() ??
                    const <String, Object?>{})
                .entries)
          entry.key: FamilyCareReliabilityState.fromJson(
            (entry.value! as Map).cast<String, Object?>(),
          ),
      },
    );
  }
}

Map<String, T> _sortedMap<T>(Map<String, T> source) => <String, T>{
  for (final String key in source.keys.toList()..sort()) key: source[key] as T,
};
