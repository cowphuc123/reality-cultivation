import 'care.dart';
import 'household.dart';
import 'world_history.dart';

const String historicalLegacyFormulaVersion = 'v2.18.0';

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
  };

  factory HistoricalLegacyState.fromJson(Map<String, Object?> json) =>
      HistoricalLegacyState(
        historyFingerprint: json['history_fingerprint']! as String,
        formulaVersion: json['formula_version']! as String,
        foodReservePerMille: json['food_reserve_per_mille']! as int,
        waterReservePerMille: json['water_reserve_per_mille']! as int,
        fuelReservePerMille: json['fuel_reserve_per_mille']! as int,
        infantFeedReservePerMille:
            json['infant_feed_reserve_per_mille']! as int,
        supplyDeliveryPerMille: json['supply_delivery_per_mille']! as int,
        floodDamagePerMille: json['flood_damage_per_mille']! as int,
        adjustments: <HistoricalResourceAdjustment>[
          for (final Object? value in json['adjustments']! as List<Object?>)
            HistoricalResourceAdjustment.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
      );
}

class GeneratedHistoricalLegacy {
  const GeneratedHistoricalLegacy({required this.state, required this.items});

  final HistoricalLegacyState state;
  final Map<String, CareItemState> items;
}

/// Chuyển đại lượng lịch sử thành tồn kho và năng lực tiếp tế hiện tại.
class HistoricalLegacyGenerator {
  static GeneratedHistoricalLegacy generate({
    required WorldHistoryState history,
    required Map<String, HouseholdState> households,
    required Map<String, CareItemState> items,
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
    return GeneratedHistoricalLegacy(
      state: HistoricalLegacyState(
        historyFingerprint: history.planFingerprint,
        formulaVersion: historicalLegacyFormulaVersion,
        foodReservePerMille: food,
        waterReservePerMille: water,
        fuelReservePerMille: fuel,
        infantFeedReservePerMille: infantFeed,
        supplyDeliveryPerMille: supply,
        floodDamagePerMille: floodDamage,
        adjustments: List<HistoricalResourceAdjustment>.unmodifiable(
          adjustments,
        ),
      ),
      items: Map<String, CareItemState>.unmodifiable(adjustedItems),
    );
  }
}
