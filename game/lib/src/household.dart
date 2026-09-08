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
  }) => HouseholdState(
    id: id,
    name: name,
    memberIds: memberIds,
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
    );
  }
}

Map<String, T> _sortedMap<T>(Map<String, T> source) => <String, T>{
  for (final String key in source.keys.toList()..sort()) key: source[key] as T,
};
