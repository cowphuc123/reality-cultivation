import 'dart:convert';

import 'geometry.dart';
import 'region.dart';

const String worldGeneratorVersion = 'v2.15.0';
const String worldEnvironmentGeneratorVersion = 'v5.0-dev.4';
const int minimumWorldSeed = 1;
const int maximumWorldSeed = 2147483646;

/// Cấu hình nội dung cho một lượt sinh thế giới.
///
/// V2.15 mới sinh một vùng thử. Tên gọi và loại địa điểm thuộc gói nội dung;
/// seed quyết định hình học của vùng và từng địa điểm.
class WorldGenerationConfig {
  const WorldGenerationConfig({
    required this.id,
    required this.regionId,
    required this.regionName,
    required this.minWidthMm,
    required this.maxWidthMm,
    required this.minHeightMm,
    required this.maxHeightMm,
  });

  static const WorldGenerationConfig anKhe = WorldGenerationConfig(
    id: 'first_region_ankhe_v1',
    regionId: 'REG-ANKHE',
    regionName: 'Thung lũng An Khê',
    minWidthMm: 12000000,
    maxWidthMm: 16000000,
    minHeightMm: 3200000,
    maxHeightMm: 5200000,
  );

  final String id;
  final String regionId;
  final String regionName;
  final int minWidthMm;
  final int maxWidthMm;
  final int minHeightMm;
  final int maxHeightMm;
}

/// Provenance được lưu cùng thế giới đã công bố.
class WorldGenesisRecord {
  const WorldGenesisRecord({
    required this.rootSeed,
    required this.generatorVersion,
    required this.configId,
    required this.fingerprint,
    required this.regionCount,
    required this.siteCount,
  });

  final int rootSeed;
  final String generatorVersion;
  final String configId;
  final String fingerprint;
  final int regionCount;
  final int siteCount;

  Map<String, Object> toJson() => <String, Object>{
    'root_seed': rootSeed,
    'generator_version': generatorVersion,
    'config_id': configId,
    'fingerprint': fingerprint,
    'region_count': regionCount,
    'site_count': siteCount,
  };

  factory WorldGenesisRecord.fromJson(Map<String, Object?> json) =>
      WorldGenesisRecord(
        rootSeed: json['root_seed']! as int,
        generatorVersion: json['generator_version']! as String,
        configId: json['config_id']! as String,
        fingerprint: json['fingerprint']! as String,
        regionCount: json['region_count']! as int,
        siteCount: json['site_count']! as int,
      );
}

class GeneratedWorld {
  GeneratedWorld({
    required this.rootSeed,
    required this.generatorVersion,
    required this.configId,
    required this.region,
    required List<WorldSite> sites,
  }) : sites = List<WorldSite>.unmodifiable(sites) {
    fingerprint = WorldGenerator.fingerprintOf(
      rootSeed: rootSeed,
      generatorVersion: generatorVersion,
      configId: configId,
      region: region,
      sites: this.sites,
    );
  }

  final int rootSeed;
  final String generatorVersion;
  final String configId;
  final WorldRegion region;
  final List<WorldSite> sites;
  late final String fingerprint;

  WorldGenesisRecord get record => WorldGenesisRecord(
    rootSeed: rootSeed,
    generatorVersion: generatorVersion,
    configId: configId,
    fingerprint: fingerprint,
    regionCount: 1,
    siteCount: sites.length,
  );

  WorldSite site(String id) => sites.singleWhere(
    (WorldSite site) => site.id == id,
    orElse: () => throw StateError('Generated site $id does not exist.'),
  );
}

/// Bộ sinh hình học xác định, không dùng `Random()` phụ thuộc nền tảng.
class WorldGenerator {
  const WorldGenerator._();

  static GeneratedWorld generate({
    required int rootSeed,
    WorldGenerationConfig config = WorldGenerationConfig.anKhe,
    bool includeTerrainProfile = false,
  }) {
    if (rootSeed < minimumWorldSeed || rootSeed > maximumWorldSeed) {
      throw RangeError.range(
        rootSeed,
        minimumWorldSeed,
        maximumWorldSeed,
        'rootSeed',
      );
    }
    if (config.minWidthMm <= 0 ||
        config.minHeightMm <= 0 ||
        config.maxWidthMm < config.minWidthMm ||
        config.maxHeightMm < config.minHeightMm) {
      throw ArgumentError('World generation dimensions are invalid.');
    }
    final _SeedStream dimensions = _SeedStream.derived(
      rootSeed,
      '${config.id}:region_dimensions',
    );
    final _SeedStream terrain = _SeedStream.derived(
      rootSeed,
      '${config.id}:terrain_profile',
    );
    final int valleyFloorElevationM = includeTerrainProfile
        ? 180 + terrain.nextInt(341)
        : 0;
    final int rimElevationM = includeTerrainProfile
        ? valleyFloorElevationM + 420 + terrain.nextInt(681)
        : 0;
    final int annualRainfallMm = includeTerrainProfile
        ? 900 + terrain.nextInt(1201)
        : 0;
    final String climateCode = !includeTerrainProfile
        ? 'unspecified'
        : annualRainfallMm >= 1650
        ? 'humid_monsoon_valley'
        : annualRainfallMm >= 1250
        ? 'seasonal_monsoon_valley'
        : 'dry_monsoon_valley';
    final WorldRegion region = WorldRegion(
      id: config.regionId,
      name: config.regionName,
      minXMm: 0,
      minYMm: 0,
      widthMm:
          config.minWidthMm +
          dimensions.nextInt(config.maxWidthMm - config.minWidthMm + 1),
      heightMm:
          config.minHeightMm +
          dimensions.nextInt(config.maxHeightMm - config.minHeightMm + 1),
      valleyFloorElevationM: valleyFloorElevationM,
      rimElevationM: rimElevationM,
      annualRainfallMm: annualRainfallMm,
      climateCode: climateCode,
    );
    final List<WorldSite> sites = <WorldSite>[
      for (final _SiteTemplate template in _siteTemplates)
        _generateSite(
          rootSeed,
          config.id,
          region,
          template,
          includeTerrainProfile: includeTerrainProfile,
        ),
    ];
    return GeneratedWorld(
      rootSeed: rootSeed,
      generatorVersion: includeTerrainProfile
          ? worldEnvironmentGeneratorVersion
          : worldGeneratorVersion,
      configId: config.id,
      region: region,
      sites: sites,
    );
  }

  static String fingerprintOf({
    required int rootSeed,
    required String generatorVersion,
    required String configId,
    required WorldRegion region,
    required List<WorldSite> sites,
  }) {
    final List<WorldSite> orderedSites = sites.toList()
      ..sort((WorldSite a, WorldSite b) => a.id.compareTo(b.id));
    return _fingerprint(<String, Object?>{
      'root_seed': rootSeed,
      'generator_version': generatorVersion,
      'config_id': configId,
      'region': region.toJson(),
      'sites': orderedSites.map((WorldSite site) => site.toJson()).toList(),
    });
  }

  static WorldSite _generateSite(
    int rootSeed,
    String configId,
    WorldRegion region,
    _SiteTemplate template, {
    required bool includeTerrainProfile,
  }) {
    final _SeedStream stream = _SeedStream.derived(
      rootSeed,
      '$configId:site:${template.id}',
    );
    final int radius =
        template.minRadiusMm +
        stream.nextInt(template.maxRadiusMm - template.minRadiusMm + 1);
    final int minX = region.minXMm + radius;
    final int maxX = region.maxXMm - radius;
    final int minY = region.minYMm + radius;
    final int maxY = region.maxYMm - radius;
    if (minX > maxX || minY > maxY) {
      throw StateError('Region ${region.id} is too small for ${template.id}.');
    }
    final int x = _placedCoordinate(
      stream: stream,
      minimum: minX,
      maximum: maxX,
      positionPerMille: template.xPerMille,
    );
    final int y = _placedCoordinate(
      stream: stream,
      minimum: minY,
      maximum: maxY,
      positionPerMille: template.yPerMille,
    );
    final int elevationM = includeTerrainProfile
        ? region.valleyFloorElevationM +
              template.minElevationAboveFloorM +
              stream.nextInt(
                template.maxElevationAboveFloorM -
                    template.minElevationAboveFloorM +
                    1,
              )
        : 0;
    final List<NaturalResourceDeposit> resources = includeTerrainProfile
        ? _generateResources(
            rootSeed: rootSeed,
            configId: configId,
            region: region,
            template: template,
          )
        : const <NaturalResourceDeposit>[];
    final List<EcologicalPopulationState> ecology = includeTerrainProfile
        ? _generateEcology(
            rootSeed: rootSeed,
            configId: configId,
            template: template,
          )
        : const <EcologicalPopulationState>[];
    return WorldSite(
      id: template.id,
      regionId: region.id,
      name: template.name,
      kind: template.kind,
      center: WorldPoint(x, y),
      radiusMm: radius,
      terrainCode: includeTerrainProfile
          ? template.terrainCode
          : 'unspecified',
      elevationM: elevationM,
      resourceDeposits: resources,
      ecologicalPopulations: ecology,
    );
  }

  static List<EcologicalPopulationState> _generateEcology({
    required int rootSeed,
    required String configId,
    required _SiteTemplate template,
  }) {
    final _SeedStream stream = _SeedStream.derived(
      rootSeed,
      '$configId:ecology:${template.id}',
    );
    EcologicalPopulationState population({
      required String species,
      required String kind,
      required int minimumCapacity,
      required int capacityRange,
      required int growth,
      required int mortality,
      String? resource,
      String? food,
    }) {
      final int capacity = minimumCapacity + stream.nextInt(capacityRange + 1);
      return EcologicalPopulationState(
        id: 'ECO-${template.id}-$species',
        speciesCode: species,
        kind: kind,
        population: capacity * (560 + stream.nextInt(321)) ~/ 1000,
        carryingCapacity: capacity,
        health: 600 + stream.nextInt(351),
        annualGrowthPerMille: growth,
        annualMortalityPerMille: mortality,
        requiredResourceKind: resource,
        foodSpeciesCode: food,
      );
    }

    return switch (template.kind) {
      'river' => <EcologicalPopulationState>[
          population(
            species: 'river_reed',
            kind: 'plant',
            minimumCapacity: 50000,
            capacityRange: 50000,
            growth: 520,
            mortality: 140,
            resource: 'surface_water',
          ),
        ],
      'field' => <EcologicalPopulationState>[
          population(
            species: 'meadow_grass',
            kind: 'plant',
            minimumCapacity: 240000,
            capacityRange: 260000,
            growth: 620,
            mortality: 180,
            resource: 'fertile_topsoil',
          ),
          population(
            species: 'field_hare',
            kind: 'herbivore',
            minimumCapacity: 600,
            capacityRange: 900,
            growth: 420,
            mortality: 210,
            resource: 'surface_water',
            food: 'meadow_grass',
          ),
        ],
      'pass' => <EcologicalPopulationState>[
          population(
            species: 'upland_pine',
            kind: 'plant',
            minimumCapacity: 9000,
            capacityRange: 11000,
            growth: 90,
            mortality: 35,
            resource: 'timber_stand',
          ),
          population(
            species: 'muntjac_deer',
            kind: 'herbivore',
            minimumCapacity: 180,
            capacityRange: 360,
            growth: 260,
            mortality: 150,
            resource: 'surface_water',
            food: 'upland_pine',
          ),
        ],
      _ => const <EcologicalPopulationState>[],
    };
  }

  static List<NaturalResourceDeposit> _generateResources({
    required int rootSeed,
    required String configId,
    required WorldRegion region,
    required _SiteTemplate template,
  }) {
    final _SeedStream stream = _SeedStream.derived(
      rootSeed,
      '$configId:natural_resources:${template.id}',
    );
    NaturalResourceDeposit deposit({
      required String suffix,
      required String kind,
      required int minimumCapacity,
      required int capacityRange,
      required String unit,
      required int renewalPerMille,
      required String origin,
      int accessibilityBase = 500,
    }) {
      final int capacity = minimumCapacity + stream.nextInt(capacityRange + 1);
      final int initialPerMille = 650 + stream.nextInt(351);
      return NaturalResourceDeposit(
        id: 'RESOURCE-${template.id}-$suffix',
        kind: kind,
        quantity: capacity * initialPerMille ~/ 1000,
        capacity: capacity,
        unit: unit,
        quality: 400 + stream.nextInt(601),
        accessibility: (accessibilityBase + stream.nextSigned(180)).clamp(
          100,
          1000,
        ).toInt(),
        annualRenewal: capacity * renewalPerMille ~/ 1000,
        origin: origin,
      );
    }

    return switch (template.kind) {
      'river' => <NaturalResourceDeposit>[
          deposit(
            suffix: 'WATER',
            kind: 'surface_water',
            minimumCapacity: 1200000 + region.annualRainfallMm * 400,
            capacityRange: 900000,
            unit: 'm3',
            renewalPerMille: 850,
            origin: 'watershed_and_monsoon_rain',
            accessibilityBase: 760,
          ),
        ],
      'field' => <NaturalResourceDeposit>[
          deposit(
            suffix: 'SOIL',
            kind: 'fertile_topsoil',
            minimumCapacity: 18000,
            capacityRange: 14000,
            unit: 'tonne',
            renewalPerMille: 8,
            origin: 'river_alluvium',
            accessibilityBase: 820,
          ),
        ],
      'pass' => <NaturalResourceDeposit>[
          deposit(
            suffix: 'TIMBER',
            kind: 'timber_stand',
            minimumCapacity: 3200000,
            capacityRange: 2800000,
            unit: 'kg',
            renewalPerMille: 35,
            origin: 'upland_woodland_growth',
            accessibilityBase: 430,
          ),
          deposit(
            suffix: 'MINERAL',
            kind: 'mixed_stone_ore',
            minimumCapacity: 900000,
            capacityRange: 2200000,
            unit: 'kg',
            renewalPerMille: 0,
            origin: 'valley_bedrock',
            accessibilityBase: 280,
          ),
        ],
      _ => const <NaturalResourceDeposit>[],
    };
  }

  static int _placedCoordinate({
    required _SeedStream stream,
    required int minimum,
    required int maximum,
    required int positionPerMille,
  }) {
    final int span = maximum - minimum;
    final int base = minimum + span * positionPerMille ~/ 1000;
    final int jitterLimit = _min(250000, span ~/ 24);
    final int value = base + stream.nextSigned(jitterLimit);
    return value.clamp(minimum, maximum);
  }
}

class _SiteTemplate {
  const _SiteTemplate({
    required this.id,
    required this.name,
    required this.kind,
    required this.xPerMille,
    required this.yPerMille,
    required this.minRadiusMm,
    required this.maxRadiusMm,
    required this.terrainCode,
    required this.minElevationAboveFloorM,
    required this.maxElevationAboveFloorM,
  });

  final String id;
  final String name;
  final String kind;
  final int xPerMille;
  final int yPerMille;
  final int minRadiusMm;
  final int maxRadiusMm;
  final String terrainCode;
  final int minElevationAboveFloorM;
  final int maxElevationAboveFloorM;
}

const List<_SiteTemplate> _siteTemplates = <_SiteTemplate>[
  _SiteTemplate(
    id: 'SITE-HOME',
    name: 'Hộ ven suối',
    kind: 'household',
    xPerMille: 20,
    yPerMille: 240,
    minRadiusMm: 90000,
    maxRadiusMm: 150000,
    terrainCode: 'alluvial_terrace',
    minElevationAboveFloorM: 12,
    maxElevationAboveFloorM: 38,
  ),
  _SiteTemplate(
    id: 'SITE-RIVER',
    name: 'Khúc lội suối',
    kind: 'river',
    xPerMille: 340,
    yPerMille: 330,
    minRadiusMm: 220000,
    maxRadiusMm: 350000,
    terrainCode: 'river_channel',
    minElevationAboveFloorM: 0,
    maxElevationAboveFloorM: 6,
  ),
  _SiteTemplate(
    id: 'SITE-FIELD',
    name: 'Đồng ngoài',
    kind: 'field',
    xPerMille: 400,
    yPerMille: 830,
    minRadiusMm: 350000,
    maxRadiusMm: 550000,
    terrainCode: 'floodplain',
    minElevationAboveFloorM: 4,
    maxElevationAboveFloorM: 18,
  ),
  _SiteTemplate(
    id: 'SITE-PASS',
    name: 'Chân đèo',
    kind: 'pass',
    xPerMille: 660,
    yPerMille: 300,
    minRadiusMm: 300000,
    maxRadiusMm: 500000,
    terrainCode: 'mountain_pass',
    minElevationAboveFloorM: 280,
    maxElevationAboveFloorM: 400,
  ),
  _SiteTemplate(
    id: 'SITE-MARKET',
    name: 'Chợ An Khê',
    kind: 'market',
    xPerMille: 930,
    yPerMille: 220,
    minRadiusMm: 450000,
    maxRadiusMm: 650000,
    terrainCode: 'alluvial_terrace',
    minElevationAboveFloorM: 18,
    maxElevationAboveFloorM: 55,
  ),
];

/// Park–Miller 31-bit với phép nhân luôn dưới giới hạn số nguyên chính xác của
/// JavaScript. Vì vậy cùng seed cho cùng kết quả trên Dart VM và Flutter web.
class _SeedStream {
  _SeedStream._(this._state);

  static const int _modulus = 2147483647;

  factory _SeedStream.derived(int rootSeed, String label) {
    int state = rootSeed % _modulus;
    if (state <= 0) state += _modulus - 1;
    for (final int code in label.codeUnits) {
      state = (state * 131 + code) % _modulus;
      if (state == 0) state = 1;
    }
    return _SeedStream._(state);
  }

  int nextInt(int maximumExclusive) {
    if (maximumExclusive <= 0) {
      throw ArgumentError.value(maximumExclusive, 'maximumExclusive');
    }
    final int high = _state ~/ 127773;
    final int low = _state % 127773;
    final int candidate = 16807 * low - 2836 * high;
    _state = candidate > 0 ? candidate : candidate + _modulus;
    return _state % maximumExclusive;
  }

  int nextSigned(int magnitude) {
    if (magnitude <= 0) return 0;
    return nextInt(magnitude * 2 + 1) - magnitude;
  }

  int _state;
}

int _min(int a, int b) => a < b ? a : b;

String _fingerprint(Map<String, Object?> value) {
  final String source = jsonEncode(value);
  final List<int> bytes = utf8.encode(source);
  BigInt hash = BigInt.parse('cbf29ce484222325', radix: 16);
  final BigInt prime = BigInt.parse('100000001b3', radix: 16);
  final BigInt mask = (BigInt.one << 64) - BigInt.one;
  for (final int byte in bytes) {
    hash ^= BigInt.from(byte);
    hash = (hash * prime) & mask;
  }
  return hash.toRadixString(16).padLeft(16, '0');
}
