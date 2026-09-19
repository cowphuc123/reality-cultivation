import 'care.dart';
import 'household.dart';
import 'region.dart';
import 'world_history.dart';

const String historicalLegacyFormulaVersion = 'v2.18.0';
const String environmentalHistoricalLegacyFormulaVersion = 'v5.0-dev.6';

/// Một thay đổi tồn kho hiện tại có thể lần ngược về kết quả tiền sử.
class HistoricalResourceAdjustment {
  const HistoricalResourceAdjustment({
    required this.householdId,
    required this.resourceKey,
    required this.itemId,
    required this.beforeQuantity,
    required this.afterQuantity,
    required this.multiplierPerMille,
  });

  final String householdId;
  final String resourceKey;
  final String itemId;
  final int beforeQuantity;
  final int afterQuantity;
  final int multiplierPerMille;

  int get delta => afterQuantity - beforeQuantity;

  Map<String, Object> toJson() => <String, Object>{
    'household_id': householdId,
    'resource_key': resourceKey,
    'item_id': itemId,
    'before_quantity': beforeQuantity,
    'after_quantity': afterQuantity,
    'multiplier_per_mille': multiplierPerMille,
  };

  factory HistoricalResourceAdjustment.fromJson(Map<String, Object?> json) =>
      HistoricalResourceAdjustment(
        householdId: json['household_id']! as String,
        resourceKey: json['resource_key']! as String,
        itemId: json['item_id']! as String,
        beforeQuantity: json['before_quantity']! as int,
        afterQuantity: json['after_quantity']! as int,
        multiplierPerMille: json['multiplier_per_mille']! as int,
      );
}

class HistoricalNaturalResourceAdjustment {
  const HistoricalNaturalResourceAdjustment({
    required this.siteId,
    required this.resourceId,
    required this.kind,
    required this.beforeQuantity,
    required this.afterQuantity,
    required this.multiplierPerMille,
  });

  final String siteId;
  final String resourceId;
  final String kind;
  final int beforeQuantity;
  final int afterQuantity;
  final int multiplierPerMille;

  Map<String, Object> toJson() => <String, Object>{
    'site_id': siteId,
    'resource_id': resourceId,
    'kind': kind,
    'before_quantity': beforeQuantity,
    'after_quantity': afterQuantity,
    'multiplier_per_mille': multiplierPerMille,
  };

  factory HistoricalNaturalResourceAdjustment.fromJson(
    Map<String, Object?> json,
  ) => HistoricalNaturalResourceAdjustment(
    siteId: json['site_id']! as String,
    resourceId: json['resource_id']! as String,
    kind: json['kind']! as String,
    beforeQuantity: json['before_quantity']! as int,
    afterQuantity: json['after_quantity']! as int,
    multiplierPerMille: json['multiplier_per_mille']! as int,
  );
}

class HistoricalEcologyAdjustment {
  const HistoricalEcologyAdjustment({
    required this.siteId,
    required this.populationId,
    required this.speciesCode,
    required this.beforePopulation,
    required this.afterPopulation,
    required this.beforeHealth,
    required this.afterHealth,
    required this.supportPerMille,
  });

  final String siteId;
  final String populationId;
  final String speciesCode;
  final int beforePopulation;
  final int afterPopulation;
  final int beforeHealth;
  final int afterHealth;
  final int supportPerMille;

  Map<String, Object> toJson() => <String, Object>{
    'site_id': siteId,
    'population_id': populationId,
    'species_code': speciesCode,
    'before_population': beforePopulation,
    'after_population': afterPopulation,
    'before_health': beforeHealth,
    'after_health': afterHealth,
    'support_per_mille': supportPerMille,
  };

  factory HistoricalEcologyAdjustment.fromJson(Map<String, Object?> json) =>
      HistoricalEcologyAdjustment(
        siteId: json['site_id']! as String,
        populationId: json['population_id']! as String,
        speciesCode: json['species_code']! as String,
        beforePopulation: json['before_population']! as int,
        afterPopulation: json['after_population']! as int,
        beforeHealth: json['before_health']! as int,
        afterHealth: json['after_health']! as int,
        supportPerMille: json['support_per_mille']! as int,
      );
}

class HistoricalSettlementAdjustment {
  const HistoricalSettlementAdjustment({
    required this.siteId,
    required this.beforeScore,
    required this.afterScore,
  });

  final String siteId;
  final int beforeScore;
  final int afterScore;

  Map<String, Object> toJson() => <String, Object>{
    'site_id': siteId,
    'before_score': beforeScore,
    'after_score': afterScore,
  };

  factory HistoricalSettlementAdjustment.fromJson(Map<String, Object?> json) =>
      HistoricalSettlementAdjustment(
        siteId: json['site_id']! as String,
        beforeScore: json['before_score']! as int,
        afterScore: json['after_score']! as int,
      );
}

/// Dấu vết của lịch sử đã được vật chất hóa vào snapshot bắt đầu chơi.
class HistoricalLegacyState {
  const HistoricalLegacyState({
    required this.historyFingerprint,
    required this.formulaVersion,
    required this.foodReservePerMille,
    required this.waterReservePerMille,
    required this.fuelReservePerMille,
    required this.infantFeedReservePerMille,
    required this.supplyDeliveryPerMille,
    required this.floodDamagePerMille,
    required this.adjustments,
    this.naturalResourceAdjustments =
        const <HistoricalNaturalResourceAdjustment>[],
    this.ecologyAdjustments = const <HistoricalEcologyAdjustment>[],
    this.settlementAdjustments = const <HistoricalSettlementAdjustment>[],
  });

  final String historyFingerprint;
  final String formulaVersion;
  final int foodReservePerMille;
  final int waterReservePerMille;
  final int fuelReservePerMille;
  final int infantFeedReservePerMille;
  final int supplyDeliveryPerMille;
  final int floodDamagePerMille;
  final List<HistoricalResourceAdjustment> adjustments;
  final List<HistoricalNaturalResourceAdjustment> naturalResourceAdjustments;
  final List<HistoricalEcologyAdjustment> ecologyAdjustments;
  final List<HistoricalSettlementAdjustment> settlementAdjustments;

  int multiplierFor(String resourceKey) => switch (resourceKey) {
    'food' => foodReservePerMille,
    'water' => waterReservePerMille,
    'fuel' => fuelReservePerMille,
    'infant_feed' => infantFeedReservePerMille,
    _ => 1000,
  };

  Map<String, Object> toJson() => <String, Object>{
    'history_fingerprint': historyFingerprint,
    'formula_version': formulaVersion,
    'food_reserve_per_mille': foodReservePerMille,
    'water_reserve_per_mille': waterReservePerMille,
    'fuel_reserve_per_mille': fuelReservePerMille,
    'infant_feed_reserve_per_mille': infantFeedReservePerMille,
    'supply_delivery_per_mille': supplyDeliveryPerMille,
    'flood_damage_per_mille': floodDamagePerMille,
    'adjustments': adjustments
        .map((HistoricalResourceAdjustment value) => value.toJson())
        .toList(),
    if (naturalResourceAdjustments.isNotEmpty)
      'natural_resource_adjustments': naturalResourceAdjustments
          .map((HistoricalNaturalResourceAdjustment value) => value.toJson())
          .toList(),
    if (ecologyAdjustments.isNotEmpty)
      'ecology_adjustments': ecologyAdjustments
          .map((HistoricalEcologyAdjustment value) => value.toJson())
          .toList(),
    if (settlementAdjustments.isNotEmpty)
      'settlement_adjustments': settlementAdjustments
          .map((HistoricalSettlementAdjustment value) => value.toJson())
          .toList(),
  };

  factory HistoricalLegacyState.fromJson(
    Map<String, Object?> json,
  ) => HistoricalLegacyState(
    historyFingerprint: json['history_fingerprint']! as String,
    formulaVersion: json['formula_version']! as String,
    foodReservePerMille: json['food_reserve_per_mille']! as int,
    waterReservePerMille: json['water_reserve_per_mille']! as int,
    fuelReservePerMille: json['fuel_reserve_per_mille']! as int,
    infantFeedReservePerMille: json['infant_feed_reserve_per_mille']! as int,
    supplyDeliveryPerMille: json['supply_delivery_per_mille']! as int,
    floodDamagePerMille: json['flood_damage_per_mille']! as int,
    adjustments: <HistoricalResourceAdjustment>[
      for (final Object? value in json['adjustments']! as List<Object?>)
        HistoricalResourceAdjustment.fromJson(
          (value! as Map).cast<String, Object?>(),
        ),
    ],
    naturalResourceAdjustments: <HistoricalNaturalResourceAdjustment>[
      for (final Object? value
          in json['natural_resource_adjustments'] as List<Object?>? ??
              const <Object?>[])
        HistoricalNaturalResourceAdjustment.fromJson(
          (value! as Map).cast<String, Object?>(),
        ),
    ],
    ecologyAdjustments: <HistoricalEcologyAdjustment>[
      for (final Object? value
          in json['ecology_adjustments'] as List<Object?>? ?? const <Object?>[])
        HistoricalEcologyAdjustment.fromJson(
          (value! as Map).cast<String, Object?>(),
        ),
    ],
    settlementAdjustments: <HistoricalSettlementAdjustment>[
      for (final Object? value
          in json['settlement_adjustments'] as List<Object?>? ??
              const <Object?>[])
        HistoricalSettlementAdjustment.fromJson(
          (value! as Map).cast<String, Object?>(),
        ),
    ],
  );
}

class GeneratedHistoricalLegacy {
  const GeneratedHistoricalLegacy({
    required this.state,
    required this.items,
    required this.sites,
  });

  final HistoricalLegacyState state;
  final Map<String, CareItemState> items;
  final Map<String, WorldSite> sites;
}

/// Chuyển đại lượng lịch sử thành tồn kho và năng lực tiếp tế hiện tại.
class HistoricalLegacyGenerator {
  static GeneratedHistoricalLegacy generate({
    required WorldHistoryState history,
    required Map<String, HouseholdState> households,
    required Map<String, CareItemState> items,
    Map<String, WorldSite> sites = const <String, WorldSite>{},
  }) {
    if (!history.complete || history.currentMetrics == null) {
      throw StateError('Only completed history can produce a legacy.');
    }
    final HistoricalMetrics metrics = history.currentMetrics!;
    final int floodDamage = history.anchors
        .where((HistoricalAnchor anchor) => anchor.kind == 'river_flood')
        .fold<int>(
          0,
          (int total, HistoricalAnchor anchor) =>
              total + anchor.effect.resourcePressureDelta,
        )
        .clamp(0, 400);
    final int food =
        (750 +
                metrics.cultivatedLandMu * 4 +
                metrics.tradeReach ~/ 5 -
                metrics.resourcePressure ~/ 2)
            .clamp(500, 1400);
    final int water =
        (1050 +
                metrics.tradeReach ~/ 10 -
                metrics.resourcePressure ~/ 3 -
                floodDamage ~/ 2)
            .clamp(500, 1400);
    final int fuel =
        (950 + metrics.tradeReach ~/ 8 - metrics.resourcePressure ~/ 2).clamp(
          500,
          1400,
        );
    final int infantFeed =
        (850 + metrics.tradeReach ~/ 4 - metrics.resourcePressure ~/ 4).clamp(
          500,
          1400,
        );
    final int supply =
        (750 + metrics.tradeReach ~/ 2 - metrics.resourcePressure ~/ 4).clamp(
          500,
          1400,
        );
    final Map<String, int> multipliers = <String, int>{
      'food': food,
      'water': water,
      'fuel': fuel,
      'infant_feed': infantFeed,
    };
    final Map<String, CareItemState> adjustedItems = <String, CareItemState>{
      ...items,
    };
    final List<HistoricalResourceAdjustment> adjustments =
        <HistoricalResourceAdjustment>[];
    final Set<String> adjustedItemIds = <String>{};
    final List<HouseholdState> orderedHouseholds = households.values.toList()
      ..sort((HouseholdState a, HouseholdState b) => a.id.compareTo(b.id));
    for (final HouseholdState household in orderedHouseholds) {
      final List<String> resourceKeys = multipliers.keys.toList()..sort();
      for (final String resourceKey in resourceKeys) {
        final String? itemId = household.resourceItemIds[resourceKey];
        final CareItemState? item = itemId == null ? null : items[itemId];
        if (item == null || !adjustedItemIds.add(item.id)) continue;
        final int multiplier = multipliers[resourceKey]!;
        final int after = item.quantity * multiplier ~/ 1000;
        adjustedItems[item.id] = item.withQuantity(after);
        adjustments.add(
          HistoricalResourceAdjustment(
            householdId: household.id,
            resourceKey: resourceKey,
            itemId: item.id,
            beforeQuantity: item.quantity,
            afterQuantity: after,
            multiplierPerMille: multiplier,
          ),
        );
      }
    }
    final List<WorldSite> orderedSites = sites.values.toList()
      ..sort((WorldSite a, WorldSite b) => a.id.compareTo(b.id));
    final Map<String, WorldSite> adjustedSites = <String, WorldSite>{
      for (final WorldSite site in orderedSites) site.id: site,
    };
    final List<HistoricalNaturalResourceAdjustment> naturalAdjustments =
        <HistoricalNaturalResourceAdjustment>[];
    final List<HistoricalEcologyAdjustment> ecologyAdjustments =
        <HistoricalEcologyAdjustment>[];
    final List<HistoricalSettlementAdjustment> settlementAdjustments =
        <HistoricalSettlementAdjustment>[];
    if (sites.isNotEmpty) {
      for (final WorldSite site in orderedSites) {
        final SettlementAssessmentState? assessment = site.settlementAssessment;
        if (assessment != null &&
            assessment.historyFingerprint != history.planFingerprint) {
          throw StateError(
            'Settlement ${site.id} does not belong to this history.',
          );
        }
      }
      for (final WorldSite original in orderedSites) {
        WorldSite changed = original;
        for (final NaturalResourceDeposit resource
            in original.resourceDeposits) {
          final int multiplier = switch (resource.kind) {
            'surface_water' =>
              (1050 -
                      metrics.resourcePressure ~/ 3 -
                      floodDamage ~/ 4 +
                      metrics.tradeReach ~/ 20)
                  .clamp(350, 1300)
                  .toInt(),
            'fertile_topsoil' =>
              (900 +
                      metrics.cultivatedLandMu * 3 +
                      floodDamage ~/ 3 -
                      metrics.resourcePressure ~/ 2)
                  .clamp(350, 1300)
                  .toInt(),
            'timber_stand' =>
              (1050 -
                      metrics.resourcePressure ~/ 2 -
                      metrics.householdEstimate.clamp(0, 300).toInt())
                  .clamp(350, 1300)
                  .toInt(),
            'mixed_stone_ore' =>
              (1000 - metrics.tradeReach ~/ 4 - metrics.resourcePressure ~/ 3)
                  .clamp(350, 1300)
                  .toInt(),
            _ => 1000,
          };
          final int after = (resource.quantity * multiplier ~/ 1000)
              .clamp(0, resource.capacity)
              .toInt();
          final NaturalResourceDeposit replacement = NaturalResourceDeposit(
            id: resource.id,
            kind: resource.kind,
            quantity: after,
            capacity: resource.capacity,
            unit: resource.unit,
            quality: resource.quality,
            accessibility: resource.accessibility,
            annualRenewal: resource.annualRenewal,
            origin: resource.origin,
          );
          changed = changed.replaceResource(replacement);
          naturalAdjustments.add(
            HistoricalNaturalResourceAdjustment(
              siteId: original.id,
              resourceId: resource.id,
              kind: resource.kind,
              beforeQuantity: resource.quantity,
              afterQuantity: after,
              multiplierPerMille: multiplier,
            ),
          );
        }
        adjustedSites[original.id] = changed;
      }

      final Map<String, int> resourceQuantity = <String, int>{};
      final Map<String, int> resourceCapacity = <String, int>{};
      final Map<String, int> speciesPopulation = <String, int>{};
      final Map<String, int> speciesCapacity = <String, int>{};
      for (final WorldSite site in adjustedSites.values) {
        for (final NaturalResourceDeposit resource in site.resourceDeposits) {
          resourceQuantity[resource.kind] =
              (resourceQuantity[resource.kind] ?? 0) + resource.quantity;
          resourceCapacity[resource.kind] =
              (resourceCapacity[resource.kind] ?? 0) + resource.capacity;
        }
        for (final EcologicalPopulationState population
            in site.ecologicalPopulations) {
          speciesPopulation[population.speciesCode] =
              (speciesPopulation[population.speciesCode] ?? 0) +
              population.population;
          speciesCapacity[population.speciesCode] =
              (speciesCapacity[population.speciesCode] ?? 0) +
              population.carryingCapacity;
        }
      }
      int ratio(
        Map<String, int> values,
        Map<String, int> capacities,
        String id,
      ) {
        final int capacity = capacities[id] ?? 0;
        return capacity == 0
            ? 0
            : ((values[id] ?? 0) * 1000 ~/ capacity).clamp(0, 1000).toInt();
      }

      for (final WorldSite original in adjustedSites.values.toList()) {
        final List<EcologicalPopulationState> populations =
            <EcologicalPopulationState>[];
        for (final EcologicalPopulationState population
            in original.ecologicalPopulations) {
          int support = 1000;
          final String? resourceKind = population.requiredResourceKind;
          if (resourceKind != null) {
            final int value = ratio(
              resourceQuantity,
              resourceCapacity,
              resourceKind,
            );
            if (value < support) support = value;
          }
          final String? foodSpecies = population.foodSpeciesCode;
          if (foodSpecies != null) {
            final int value = ratio(
              speciesPopulation,
              speciesCapacity,
              foodSpecies,
            );
            if (value < support) support = value;
          }
          final int populationMultiplier =
              (650 + support ~/ 2 - metrics.resourcePressure ~/ 4)
                  .clamp(300, 1200)
                  .toInt();
          final int afterPopulation =
              (population.population * populationMultiplier ~/ 1000)
                  .clamp(0, population.carryingCapacity)
                  .toInt();
          final int afterHealth =
              ((population.health + support - metrics.resourcePressure ~/ 2) ~/
                      2)
                  .clamp(0, 1000)
                  .toInt();
          populations.add(
            EcologicalPopulationState(
              id: population.id,
              speciesCode: population.speciesCode,
              kind: population.kind,
              population: afterPopulation,
              carryingCapacity: population.carryingCapacity,
              health: afterHealth,
              annualGrowthPerMille: population.annualGrowthPerMille,
              annualMortalityPerMille: population.annualMortalityPerMille,
              requiredResourceKind: population.requiredResourceKind,
              foodSpeciesCode: population.foodSpeciesCode,
            ),
          );
          ecologyAdjustments.add(
            HistoricalEcologyAdjustment(
              siteId: original.id,
              populationId: population.id,
              speciesCode: population.speciesCode,
              beforePopulation: population.population,
              afterPopulation: afterPopulation,
              beforeHealth: population.health,
              afterHealth: afterHealth,
              supportPerMille: support,
            ),
          );
        }
        WorldSite changed = original.withEcologicalPopulations(populations);
        final SettlementAssessmentState? settlement =
            original.settlementAssessment;
        if (settlement != null) {
          final int floodPenalty =
              original.kind == 'field' || original.kind == 'household'
              ? floodDamage ~/ 3
              : 0;
          final int tradeBenefit =
              original.kind == 'market' || original.kind == 'pass'
              ? metrics.tradeReach ~/ 8
              : 0;
          final int afterScore =
              (settlement.score +
                      tradeBenefit -
                      metrics.resourcePressure ~/ 6 -
                      floodPenalty)
                  .clamp(0, 1000)
                  .toInt();
          changed = changed.withSettlementAssessment(
            SettlementAssessmentState(
              score: afterScore,
              viable: settlement.viable,
              reasons: <String>[
                ...settlement.reasons,
                'Dư âm tiền sử: ${afterScore - settlement.score >= 0 ? '+' : ''}${afterScore - settlement.score}',
              ],
              historyFingerprint: settlement.historyFingerprint,
              selectedForBirthHousehold: settlement.selectedForBirthHousehold,
            ),
          );
          settlementAdjustments.add(
            HistoricalSettlementAdjustment(
              siteId: original.id,
              beforeScore: settlement.score,
              afterScore: afterScore,
            ),
          );
        }
        adjustedSites[original.id] = changed;
      }
    }
    return GeneratedHistoricalLegacy(
      state: HistoricalLegacyState(
        historyFingerprint: history.planFingerprint,
        formulaVersion: sites.isEmpty
            ? historicalLegacyFormulaVersion
            : environmentalHistoricalLegacyFormulaVersion,
        foodReservePerMille: food,
        waterReservePerMille: water,
        fuelReservePerMille: fuel,
        infantFeedReservePerMille: infantFeed,
        supplyDeliveryPerMille: supply,
        floodDamagePerMille: floodDamage,
        adjustments: List<HistoricalResourceAdjustment>.unmodifiable(
          adjustments,
        ),
        naturalResourceAdjustments:
            List<HistoricalNaturalResourceAdjustment>.unmodifiable(
              naturalAdjustments,
            ),
        ecologyAdjustments: List<HistoricalEcologyAdjustment>.unmodifiable(
          ecologyAdjustments,
        ),
        settlementAdjustments:
            List<HistoricalSettlementAdjustment>.unmodifiable(
              settlementAdjustments,
            ),
      ),
      items: Map<String, CareItemState>.unmodifiable(adjustedItems),
      sites: Map<String, WorldSite>.unmodifiable(adjustedSites),
    );
  }
}
