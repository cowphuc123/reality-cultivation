import 'geometry.dart';

/// Một nguồn tự nhiên có sổ lượng riêng, không phải vật phẩm tự sinh trong kho.
class NaturalResourceDeposit {
  const NaturalResourceDeposit({
    required this.id,
    required this.kind,
    required this.quantity,
    required this.capacity,
    required this.unit,
    required this.quality,
    required this.accessibility,
    required this.annualRenewal,
    required this.origin,
  });

  final String id;
  final String kind;
  final int quantity;
  final int capacity;
  final String unit;
  final int quality;
  final int accessibility;
  final int annualRenewal;
  final String origin;

  bool get renewable => annualRenewal > 0;

  NaturalResourceDeposit extract(int amount) {
    if (amount <= 0 || amount > quantity) {
      throw StateError('Cannot extract $amount $unit from $id ($quantity).');
    }
    return _copy(quantity: quantity - amount);
  }

  NaturalResourceDeposit renewOneYear() => annualRenewal == 0
      ? this
      : _copy(
          quantity: (quantity + annualRenewal).clamp(0, capacity).toInt(),
        );

  NaturalResourceDeposit _copy({required int quantity}) =>
      NaturalResourceDeposit(
        id: id,
        kind: kind,
        quantity: quantity,
        capacity: capacity,
        unit: unit,
        quality: quality,
        accessibility: accessibility,
        annualRenewal: annualRenewal,
        origin: origin,
      );

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'kind': kind,
    'quantity': quantity,
    'capacity': capacity,
    'unit': unit,
    'quality': quality,
    'accessibility': accessibility,
    'annual_renewal': annualRenewal,
    'origin': origin,
  };

  factory NaturalResourceDeposit.fromJson(Map<String, Object?> json) =>
      NaturalResourceDeposit(
        id: json['id']! as String,
        kind: json['kind']! as String,
        quantity: json['quantity']! as int,
        capacity: json['capacity']! as int,
        unit: json['unit']! as String,
        quality: json['quality']! as int,
        accessibility: json['accessibility']! as int,
        annualRenewal: json['annual_renewal']! as int,
        origin: json['origin']! as String,
      );
}

/// Một quần thể sinh vật được theo dõi ở cấp địa điểm, hữu hạn và có sức chứa.
class EcologicalPopulationState {
  const EcologicalPopulationState({
    required this.id,
    required this.speciesCode,
    required this.kind,
    required this.population,
    required this.carryingCapacity,
    required this.health,
    required this.annualGrowthPerMille,
    required this.annualMortalityPerMille,
    this.requiredResourceKind,
    this.foodSpeciesCode,
  });

  final String id;
  final String speciesCode;
  final String kind;
  final int population;
  final int carryingCapacity;
  final int health;
  final int annualGrowthPerMille;
  final int annualMortalityPerMille;
  final String? requiredResourceKind;
  final String? foodSpeciesCode;

  EcologicalPopulationState advanceYear({required int supportPerMille}) {
    final int support = supportPerMille.clamp(0, 1000).toInt();
    final int availableSpace = (carryingCapacity - population).clamp(
      0,
      carryingCapacity,
    ).toInt();
    final int potentialBirths = population * annualGrowthPerMille ~/ 1000;
    final int births = potentialBirths * support ~/ 1000 * availableSpace ~/
        carryingCapacity;
    final int stressMortality = (1000 - support) ~/ 3;
    final int deaths = population *
        (annualMortalityPerMille + stressMortality).clamp(0, 1000) ~/
        1000;
    return EcologicalPopulationState(
      id: id,
      speciesCode: speciesCode,
      kind: kind,
      population: (population + births - deaths)
          .clamp(0, carryingCapacity)
          .toInt(),
      carryingCapacity: carryingCapacity,
      health: ((health * 2 + support) ~/ 3).clamp(0, 1000).toInt(),
      annualGrowthPerMille: annualGrowthPerMille,
      annualMortalityPerMille: annualMortalityPerMille,
      requiredResourceKind: requiredResourceKind,
      foodSpeciesCode: foodSpeciesCode,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'species_code': speciesCode,
    'kind': kind,
    'population': population,
    'carrying_capacity': carryingCapacity,
    'health': health,
    'annual_growth_per_mille': annualGrowthPerMille,
    'annual_mortality_per_mille': annualMortalityPerMille,
    if (requiredResourceKind != null)
      'required_resource_kind': requiredResourceKind!,
    if (foodSpeciesCode != null) 'food_species_code': foodSpeciesCode!,
  };

  factory EcologicalPopulationState.fromJson(Map<String, Object?> json) =>
      EcologicalPopulationState(
        id: json['id']! as String,
        speciesCode: json['species_code']! as String,
        kind: json['kind']! as String,
        population: json['population']! as int,
        carryingCapacity: json['carrying_capacity']! as int,
        health: json['health']! as int,
        annualGrowthPerMille: json['annual_growth_per_mille']! as int,
        annualMortalityPerMille: json['annual_mortality_per_mille']! as int,
        requiredResourceKind: json['required_resource_kind'] as String?,
        foodSpeciesCode: json['food_species_code'] as String?,
      );
}

/// Kết quả đánh giá một địa điểm để hình thành khu dân cư trong lịch sử.
///
/// Đây là dữ liệu có nguồn gốc, không phải cờ khả dụng do giao diện tự đặt.
class SettlementAssessmentState {
  const SettlementAssessmentState({
    required this.score,
    required this.viable,
    required this.reasons,
    required this.historyFingerprint,
    required this.selectedForBirthHousehold,
  });

  final int score;
  final bool viable;
  final List<String> reasons;
  final String historyFingerprint;
  final bool selectedForBirthHousehold;

  Map<String, Object> toJson() => <String, Object>{
    'score': score,
    'viable': viable,
    'reasons': reasons,
    'history_fingerprint': historyFingerprint,
    'selected_for_birth_household': selectedForBirthHousehold,
  };

  factory SettlementAssessmentState.fromJson(Map<String, Object?> json) =>
      SettlementAssessmentState(
        score: json['score']! as int,
        viable: json['viable']! as bool,
        reasons: (json['reasons']! as List<Object?>).cast<String>(),
        historyFingerprint: json['history_fingerprint']! as String,
        selectedForBirthHousehold:
            json['selected_for_birth_household']! as bool,
      );
}

/// Một vùng chữ nhật của thế giới, dùng đơn vị milimét như mọi vị trí khác.
class WorldRegion {
  const WorldRegion({
    required this.id,
    required this.name,
    required this.minXMm,
    required this.minYMm,
    required this.widthMm,
    required this.heightMm,
    this.valleyFloorElevationM = 0,
    this.rimElevationM = 0,
    this.annualRainfallMm = 0,
    this.climateCode = 'unspecified',
  });

  final String id;
  final String name;
  final int minXMm;
  final int minYMm;
  final int widthMm;
  final int heightMm;

  /// Độ cao nền thung lũng và vành núi, được sinh cùng địa hình V5.
  final int valleyFloorElevationM;
  final int rimElevationM;

  /// Lượng mưa năm đại diện và mã khí hậu dùng làm đầu vào cho sinh thái sau.
  final int annualRainfallMm;
  final String climateCode;

  int get maxXMm => minXMm + widthMm;
  int get maxYMm => minYMm + heightMm;

  bool contains(WorldPoint point) =>
      point.xMm >= minXMm &&
      point.xMm <= maxXMm &&
      point.yMm >= minYMm &&
      point.yMm <= maxYMm;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'min_x_mm': minXMm,
    'min_y_mm': minYMm,
    'width_mm': widthMm,
    'height_mm': heightMm,
    if (valleyFloorElevationM != 0)
      'valley_floor_elevation_m': valleyFloorElevationM,
    if (rimElevationM != 0) 'rim_elevation_m': rimElevationM,
    if (annualRainfallMm != 0) 'annual_rainfall_mm': annualRainfallMm,
    if (climateCode != 'unspecified') 'climate_code': climateCode,
  };

  factory WorldRegion.fromJson(Map<String, Object?> json) => WorldRegion(
    id: json['id']! as String,
    name: json['name']! as String,
    minXMm: json['min_x_mm']! as int,
    minYMm: json['min_y_mm']! as int,
    widthMm: json['width_mm']! as int,
    heightMm: json['height_mm']! as int,
    valleyFloorElevationM: json['valley_floor_elevation_m'] as int? ?? 0,
    rimElevationM: json['rim_elevation_m'] as int? ?? 0,
    annualRainfallMm: json['annual_rainfall_mm'] as int? ?? 0,
    climateCode: json['climate_code'] as String? ?? 'unspecified',
  );
}

/// Một địa điểm có vùng ảnh hưởng thật trên bản đồ, không chỉ là nhãn.
class WorldSite {
  const WorldSite({
    required this.id,
    required this.regionId,
    required this.name,
    required this.kind,
    required this.center,
    required this.radiusMm,
    this.terrainCode = 'unspecified',
    this.elevationM = 0,
    this.resourceDeposits = const <NaturalResourceDeposit>[],
    this.ecologicalPopulations = const <EcologicalPopulationState>[],
    this.settlementAssessment,
  });

  final String id;
  final String regionId;
  final String name;

  /// Mã loại địa điểm, ví dụ `household`, `market`, `river`, `field`.
  final String kind;
  final WorldPoint center;
  final int radiusMm;
  final String terrainCode;
  final int elevationM;
  final List<NaturalResourceDeposit> resourceDeposits;
  final List<EcologicalPopulationState> ecologicalPopulations;
  final SettlementAssessmentState? settlementAssessment;

  bool contains(WorldPoint point) {
    final int dx = point.xMm - center.xMm;
    final int dy = point.yMm - center.yMm;
    return dx * dx + dy * dy <= radiusMm * radiusMm;
  }

  int distanceTo(WorldPoint point) => center.distanceTo(point);

  WorldSite replaceResource(NaturalResourceDeposit replacement) {
    if (!resourceDeposits.any(
      (NaturalResourceDeposit value) => value.id == replacement.id,
    )) {
      throw StateError('Unknown resource ${replacement.id} at $id.');
    }
    return WorldSite(
      id: id,
      regionId: regionId,
      name: name,
      kind: kind,
      center: center,
      radiusMm: radiusMm,
      terrainCode: terrainCode,
      elevationM: elevationM,
      resourceDeposits: <NaturalResourceDeposit>[
        for (final NaturalResourceDeposit value in resourceDeposits)
          value.id == replacement.id ? replacement : value,
      ],
      ecologicalPopulations: ecologicalPopulations,
      settlementAssessment: settlementAssessment,
    );
  }

  WorldSite renewResourcesOneYear() => WorldSite(
    id: id,
    regionId: regionId,
    name: name,
    kind: kind,
    center: center,
    radiusMm: radiusMm,
    terrainCode: terrainCode,
    elevationM: elevationM,
    resourceDeposits: <NaturalResourceDeposit>[
      for (final NaturalResourceDeposit value in resourceDeposits)
        value.renewOneYear(),
    ],
    ecologicalPopulations: ecologicalPopulations,
    settlementAssessment: settlementAssessment,
  );

  WorldSite withEcologicalPopulations(
    List<EcologicalPopulationState> populations,
  ) => WorldSite(
    id: id,
    regionId: regionId,
    name: name,
    kind: kind,
    center: center,
    radiusMm: radiusMm,
    terrainCode: terrainCode,
    elevationM: elevationM,
    resourceDeposits: resourceDeposits,
    ecologicalPopulations: populations,
    settlementAssessment: settlementAssessment,
  );

  WorldSite withSettlementAssessment(SettlementAssessmentState assessment) =>
      WorldSite(
        id: id,
        regionId: regionId,
        name: name,
        kind: kind,
        center: center,
        radiusMm: radiusMm,
        terrainCode: terrainCode,
        elevationM: elevationM,
        resourceDeposits: resourceDeposits,
        ecologicalPopulations: ecologicalPopulations,
        settlementAssessment: assessment,
      );

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'region_id': regionId,
    'name': name,
    'kind': kind,
    'center_x_mm': center.xMm,
    'center_y_mm': center.yMm,
    'radius_mm': radiusMm,
    if (terrainCode != 'unspecified') 'terrain_code': terrainCode,
    if (elevationM != 0) 'elevation_m': elevationM,
    if (resourceDeposits.isNotEmpty)
      'resource_deposits': resourceDeposits
          .map((NaturalResourceDeposit value) => value.toJson())
          .toList(),
    if (ecologicalPopulations.isNotEmpty)
      'ecological_populations': ecologicalPopulations
          .map((EcologicalPopulationState value) => value.toJson())
          .toList(),
    if (settlementAssessment != null)
      'settlement_assessment': settlementAssessment!.toJson(),
  };

  factory WorldSite.fromJson(Map<String, Object?> json) => WorldSite(
    id: json['id']! as String,
    regionId: json['region_id']! as String,
    name: json['name']! as String,
    kind: json['kind']! as String,
    center: WorldPoint(
      json['center_x_mm']! as int,
      json['center_y_mm']! as int,
    ),
    radiusMm: json['radius_mm']! as int,
    terrainCode: json['terrain_code'] as String? ?? 'unspecified',
    elevationM: json['elevation_m'] as int? ?? 0,
    resourceDeposits:
        (json['resource_deposits'] as List<Object?>? ?? const <Object?>[])
            .map(
              (Object? value) => NaturalResourceDeposit.fromJson(
                (value! as Map).cast<String, Object?>(),
              ),
            )
            .toList(),
    ecologicalPopulations:
        (json['ecological_populations'] as List<Object?>? ??
                const <Object?>[])
            .map(
              (Object? value) => EcologicalPopulationState.fromJson(
                (value! as Map).cast<String, Object?>(),
              ),
            )
            .toList(),
    settlementAssessment: json['settlement_assessment'] == null
        ? null
        : SettlementAssessmentState.fromJson(
            (json['settlement_assessment']! as Map).cast<String, Object?>(),
          ),
  );
}
