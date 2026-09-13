import 'dart:convert';

import 'world_generation.dart';
import 'world_history.dart';

const String settlementPopulationGeneratorVersion = 'v3.0.0';

/// Một người dân được sinh từ seed và dấu vết lịch sử của làng.
class GeneratedSettlementPerson {
  const GeneratedSettlementPerson({
    required this.id,
    required this.name,
    required this.ageYears,
    required this.householdRole,
    required this.occupationCode,
    required this.occupationName,
    required this.careSkill,
    required this.skills,
    required this.routine,
    required this.originSummary,
  });

  final String id;
  final String name;
  final int ageYears;
  final String householdRole;
  final String occupationCode;
  final String occupationName;
  final int careSkill;
  final Map<String, int> skills;
  final List<Map<String, Object?>> routine;
  final String originSummary;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'age_years': ageYears,
    'household_role': householdRole,
    'occupation_code': occupationCode,
    'occupation_name': occupationName,
    'care_skill': careSkill,
    'skills': skills,
    'routine': routine,
    'origin_summary': originSummary,
  };
}

/// Một hộ thường trú trong làng, độc lập với ba hộ ứng viên nơi sinh.
class GeneratedSettlementHousehold {
  const GeneratedSettlementHousehold({
    required this.id,
    required this.name,
    required this.roomId,
    required this.roomName,
    required this.siteId,
    required this.livelihood,
    required this.people,
    required this.foodQuantity,
    required this.waterQuantity,
    required this.fuelQuantity,
  });

  final String id;
  final String name;
  final String roomId;
  final String roomName;
  final String siteId;
  final String livelihood;
  final List<GeneratedSettlementPerson> people;
  final int foodQuantity;
  final int waterQuantity;
  final int fuelQuantity;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'room_id': roomId,
    'room_name': roomName,
    'site_id': siteId,
    'livelihood': livelihood,
    'people': people
        .map((GeneratedSettlementPerson value) => value.toJson())
        .toList(),
    'food_quantity': foodQuantity,
    'water_quantity': waterQuantity,
    'fuel_quantity': fuelQuantity,
  };
}

/// Dân số chi tiết hiện diện khi nhân vật người chơi chào đời.
class GeneratedSettlementPopulation {
  GeneratedSettlementPopulation({
    required this.rootSeed,
    required this.worldFingerprint,
    required this.historyFingerprint,
    required this.targetDetailedPopulation,
    required this.existingDetailedPersonCount,
    required List<GeneratedSettlementHousehold> households,
    this.generatorVersion = settlementPopulationGeneratorVersion,
  }) : households = List<GeneratedSettlementHousehold>.unmodifiable(
         households,
       ) {
    if (targetDetailedPopulation < 20 ||
        targetDetailedPopulation > 50 ||
        existingDetailedPersonCount < 0 ||
        detailedPersonCount + existingDetailedPersonCount !=
            targetDetailedPopulation) {
      throw ArgumentError('Generated settlement population size is invalid.');
    }
    final Set<String> householdIds = <String>{};
    final Set<String> roomIds = <String>{};
    final Set<String> personIds = <String>{};
    for (final GeneratedSettlementHousehold household in this.households) {
      if (!householdIds.add(household.id) ||
          !roomIds.add(household.roomId) ||
          household.people.isEmpty ||
          household.foodQuantity <= 0 ||
          household.waterQuantity <= 0 ||
          household.fuelQuantity <= 0) {
        throw ArgumentError('Generated settlement household is invalid.');
      }
      for (final GeneratedSettlementPerson person in household.people) {
        if (!personIds.add(person.id) ||
            person.name.isEmpty ||
            person.ageYears < 16 ||
            person.ageYears > 80 ||
            person.careSkill < 0 ||
            person.careSkill > 1000 ||
            person.skills.isEmpty ||
            person.originSummary.isEmpty) {
          throw ArgumentError('Generated settlement person is invalid.');
        }
      }
    }
    fingerprint = _fingerprint(<String, Object?>{
      'root_seed': rootSeed,
      'world_fingerprint': worldFingerprint,
      'history_fingerprint': historyFingerprint,
      'generator_version': generatorVersion,
      'target_detailed_population': targetDetailedPopulation,
      'existing_detailed_person_count': existingDetailedPersonCount,
      'households': this.households
          .map((GeneratedSettlementHousehold value) => value.toJson())
          .toList(),
    });
  }

  final int rootSeed;
  final String worldFingerprint;
  final String historyFingerprint;
  final int targetDetailedPopulation;
  final int existingDetailedPersonCount;
  final List<GeneratedSettlementHousehold> households;
  final String generatorVersion;
  late final String fingerprint;

  int get detailedPersonCount => households.fold<int>(
    0,
    (int total, GeneratedSettlementHousehold household) =>
        total + household.people.length,
  );
}

/// Chuyển dân số ước lượng của lịch sử thành những con người có đời sống thật.
class SettlementPopulationGenerator {
  const SettlementPopulationGenerator._();

  static GeneratedSettlementPopulation generate({
    required GeneratedWorld world,
    required GeneratedWorldHistory history,
    int existingDetailedPersonCount = 0,
  }) {
    if (world.rootSeed != history.rootSeed ||
        world.fingerprint != history.worldFingerprint) {
      throw StateError('Settlement population requires matching provenance.');
    }
    final HistoricalMetrics metrics = history.epochs.isEmpty
        ? const HistoricalMetrics.initial()
        : history.epochs.last.metricsAfter;
    final int target = metrics.populationEstimate.clamp(20, 50);
    if (existingDetailedPersonCount > target) {
      throw ArgumentError.value(
        existingDetailedPersonCount,
        'existingDetailedPersonCount',
        'cannot exceed the detailed population target',
      );
    }
    final int generatedCount = target - existingDetailedPersonCount;
    final _SeedStream stream = _SeedStream.derived(
      world.rootSeed,
      '${history.fingerprint}:settlement:${metrics.populationEstimate}:'
      '${metrics.householdEstimate}:${metrics.tradeReach}:'
      '${metrics.resourcePressure}',
    );
    final int householdCount = generatedCount == 0
        ? 0
        : ((generatedCount + 3) ~/ 4).clamp(1, 12);
    final List<int> householdSizes = <int>[
      for (int index = 0; index < householdCount; index++)
        generatedCount ~/ householdCount +
            (index < generatedCount % householdCount ? 1 : 0),
    ];
    final Set<String> usedNames = <String>{};
    int personIndex = 1;
    final List<GeneratedSettlementHousehold> households =
        <GeneratedSettlementHousehold>[];
    for (
      int householdIndex = 0;
      householdIndex < householdSizes.length;
      householdIndex++
    ) {
      final _Livelihood livelihood =
          _livelihoods[(householdIndex + stream.nextInt(_livelihoods.length)) %
              _livelihoods.length];
      final String householdId =
          'VH${(householdIndex + 1).toString().padLeft(3, '0')}';
      final String roomId =
          'VROOM${(householdIndex + 1).toString().padLeft(3, '0')}';
      final int familyNumber = householdIndex + 1;
      final List<GeneratedSettlementPerson> people =
          <GeneratedSettlementPerson>[];
      for (
        int memberIndex = 0;
        memberIndex < householdSizes[householdIndex];
        memberIndex++
      ) {
        final String personId = 'VN${personIndex.toString().padLeft(3, '0')}';
        final String name = _uniqueName(stream, usedNames, personIndex);
        final int ageYears = 16 + stream.nextInt(55);
        final _Occupation occupation = _occupationFor(
          livelihood,
          memberIndex,
          stream,
        );
        final int primarySkill = (360 + stream.nextInt(541)).clamp(0, 1000);
        final int secondarySkill = (120 + stream.nextInt(431)).clamp(0, 1000);
        final String role = memberIndex == 0
            ? 'chủ hộ'
            : memberIndex == 1
            ? 'bạn đời'
            : 'người thân';
        people.add(
          GeneratedSettlementPerson(
            id: personId,
            name: name,
            ageYears: ageYears,
            householdRole: role,
            occupationCode: occupation.skillCode,
            occupationName: occupation.name,
            careSkill: (220 + stream.nextInt(541)).clamp(0, 1000),
            skills: <String, int>{
              occupation.skillCode: primarySkill,
              livelihood.secondarySkill: secondarySkill,
            },
            routine: <Map<String, Object?>>[
              <String, Object?>{
                'id': 'R-$personId-WORK',
                'activity': occupation.activity,
                'start_second_of_day':
                    (5 + stream.nextInt(3)) * 3600 + stream.nextInt(1800),
                // Nhịp thường 4–5 giờ nằm trong sức hồi phục ban đêm hiện có;
                // chuyến đi và việc gấp vẫn có thể đẩy người ta tới kiệt sức.
                'duration_seconds': (4 + stream.nextInt(2)) * 3600,
                'room_id': roomId,
                'priority': 60 + stream.nextInt(21),
                'blocking': true,
                'required_skill': occupation.skillCode,
                if (occupation.outputResource != null)
                  'output_resource': occupation.outputResource,
                if (occupation.outputResource != null)
                  'output_amount': occupation.baseOutput,
              },
            ],
            originSummary:
                '$name thuộc hộ số $familyNumber, sống bằng ${livelihood.name}; '
                'những biến động lịch sử khiến ${occupation.name} trở thành nghề chính.',
          ),
        );
        personIndex++;
      }
      final int pressure = metrics.resourcePressure;
      final int householdSize = people.length;
      households.add(
        GeneratedSettlementHousehold(
          id: householdId,
          name: '${livelihood.householdPrefix} $familyNumber',
          roomId: roomId,
          roomName: '${livelihood.roomPrefix} $familyNumber',
          siteId: livelihood.siteId,
          livelihood: livelihood.name,
          people: List<GeneratedSettlementPerson>.unmodifiable(people),
          foodQuantity:
              (householdSize * 8500 + stream.nextInt(7001) - pressure * 4)
                  .clamp(6000, 60000),
          // Mỗi người lớn uống khoảng 2.500 ml/ngày và sinh hoạt hộ dùng
          // thêm 6.000 ml. Cho 13–18 ngày dự trữ để mạng trao đổi có thời
          // gian hình thành; công thức cũ chỉ đủ 2–3 ngày và làm làng sụp
          // trước khi phản ứng thiếu hàng có thể chạy.
          waterQuantity: () {
            final int dailyWater = 6000 + householdSize * 2500;
            return (dailyWater * (13 + stream.nextInt(6)) - pressure * 5).clamp(
              dailyWater * 12,
              dailyWater * 20,
            );
          }(),
          // Bữa ăn dùng 300 g và nhịp sinh tồn dự trù 900 g/ngày. Dự trữ
          // cùng khoảng chạy 13–18 ngày như nước để hộ kịp tự sản xuất/đổi.
          fuelQuantity: (900 * (13 + stream.nextInt(6)) - pressure).clamp(
            900 * 12,
            900 * 20,
          ),
        ),
      );
    }
    return GeneratedSettlementPopulation(
      rootSeed: world.rootSeed,
      worldFingerprint: world.fingerprint,
      historyFingerprint: history.fingerprint,
      targetDetailedPopulation: target,
      existingDetailedPersonCount: existingDetailedPersonCount,
      households: households,
    );
  }

  static _Occupation _occupationFor(
    _Livelihood livelihood,
    int memberIndex,
    _SeedStream stream,
  ) {
    if (memberIndex == 0) return livelihood.primaryOccupation;
    final List<_Occupation> choices = <_Occupation>[
      livelihood.primaryOccupation,
      livelihood.supportOccupation,
      _commonOccupations[stream.nextInt(_commonOccupations.length)],
    ];
    return choices[stream.nextInt(choices.length)];
  }

  static String _uniqueName(_SeedStream stream, Set<String> used, int ordinal) {
    for (int attempt = 0; attempt < 80; attempt++) {
      final String candidate =
          '${_familyNames[stream.nextInt(_familyNames.length)]} '
          '${_givenNames[stream.nextInt(_givenNames.length)]}';
      if (used.add(candidate)) return candidate;
    }
    final String fallback =
        '${_familyNames[stream.nextInt(_familyNames.length)]} '
        '${_givenNames[stream.nextInt(_givenNames.length)]} $ordinal';
    used.add(fallback);
    return fallback;
  }
}

class _Livelihood {
  const _Livelihood({
    required this.siteId,
    required this.name,
    required this.householdPrefix,
    required this.roomPrefix,
    required this.primaryOccupation,
    required this.supportOccupation,
    required this.secondarySkill,
  });

  final String siteId;
  final String name;
  final String householdPrefix;
  final String roomPrefix;
  final _Occupation primaryOccupation;
  final _Occupation supportOccupation;
  final String secondarySkill;
}

class _Occupation {
  const _Occupation(
    this.skillCode,
    this.name,
    this.activity,
    this.outputResource,
    this.baseOutput,
  );

  final String skillCode;
  final String name;
  final String activity;
  final String? outputResource;
  final int baseOutput;
}

const _Occupation _farmer = _Occupation(
  'gather_food',
  'nông phu',
  'chăm ruộng và thu lương thực',
  'food',
  7200,
);
const _Occupation _waterCarrier = _Occupation(
  'fetch_water',
  'người gánh nước',
  'lấy nước và chuyển về hộ',
  'water',
  // Một hộ chuyên nước cần nuôi chính mình và khoảng ba hộ chuyên nghề khác.
  54000,
);
const _Occupation _woodcutter = _Occupation(
  'gather_fuel',
  'tiều phu',
  'kiếm củi ở chân đèo',
  'fuel',
  4200,
);
const _Occupation _cook = _Occupation(
  'cook',
  'người nấu ăn',
  'chuẩn bị bữa ăn cho hộ',
  null,
  0,
);
const _Occupation _trader = _Occupation(
  'trade',
  'tiểu thương',
  'mở quầy và đổi hàng',
  'food',
  6000,
);
const _Occupation _herbalist = _Occupation(
  'herbalism',
  'người hái thuốc',
  'tìm và sơ chế dược thảo',
  'food',
  4800,
);

const List<_Occupation> _commonOccupations = <_Occupation>[
  _cook,
  _waterCarrier,
  _woodcutter,
  _herbalist,
];

const List<_Livelihood> _livelihoods = <_Livelihood>[
  _Livelihood(
    siteId: 'SITE-FIELD',
    name: 'trồng kê và rau',
    householdPrefix: 'Hộ canh đồng',
    roomPrefix: 'Nhà đất ngoài đồng',
    primaryOccupation: _farmer,
    supportOccupation: _waterCarrier,
    secondarySkill: 'cook',
  ),
  _Livelihood(
    siteId: 'SITE-RIVER',
    name: 'gánh nước và mò thức ăn ven suối',
    householdPrefix: 'Hộ ven suối',
    roomPrefix: 'Nhà sàn ven suối',
    primaryOccupation: _waterCarrier,
    supportOccupation: _farmer,
    secondarySkill: 'gather_food',
  ),
  _Livelihood(
    siteId: 'SITE-PASS',
    name: 'đốn củi và dẫn đường',
    householdPrefix: 'Hộ chân đèo',
    roomPrefix: 'Nhà gỗ chân đèo',
    primaryOccupation: _woodcutter,
    supportOccupation: _herbalist,
    secondarySkill: 'fetch_water',
  ),
  _Livelihood(
    siteId: 'SITE-MARKET',
    name: 'buôn bán và nấu ăn',
    householdPrefix: 'Hộ trong chợ',
    roomPrefix: 'Gác nhà chợ',
    primaryOccupation: _trader,
    supportOccupation: _cook,
    secondarySkill: 'gather_food',
  ),
];

const List<String> _familyNames = <String>[
  'Lâm',
  'Trần',
  'Đỗ',
  'Phạm',
  'Nguyễn',
  'Tạ',
  'Hoàng',
  'Vũ',
  'Bùi',
  'Lê',
  'Dương',
  'Hứa',
];
const List<String> _givenNames = <String>[
  'Bách',
  'Sương',
  'Thanh Mai',
  'Kính',
  'Vân Chi',
  'Quang',
  'Ngọc Lan',
  'Mộc',
  'An',
  'Hạ',
  'Minh',
  'Tú',
  'Dần',
  'Liên',
  'Cẩn',
  'Nghi',
  'Thạch',
  'Thuận',
  'Nhu',
  'Viễn',
];

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
    final int high = _state ~/ 127773;
    final int low = _state % 127773;
    final int candidate = 16807 * low - 2836 * high;
    _state = candidate > 0 ? candidate : candidate + _modulus;
    return _state % maximumExclusive;
  }

  int _state;
}

String _fingerprint(Map<String, Object?> value) {
  final List<int> bytes = utf8.encode(jsonEncode(value));
  BigInt hash = BigInt.parse('cbf29ce484222325', radix: 16);
  final BigInt prime = BigInt.parse('100000001b3', radix: 16);
  final BigInt mask = (BigInt.one << 64) - BigInt.one;
  for (final int byte in bytes) {
    hash ^= BigInt.from(byte);
    hash = (hash * prime) & mask;
  }
  return hash.toRadixString(16).padLeft(16, '0');
}
