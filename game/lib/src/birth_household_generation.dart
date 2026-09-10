import 'dart:convert';

import 'world_generation.dart';
import 'world_history.dart';

const String birthHouseholdGeneratorVersion = 'v2.20.0';
const String extendedBirthHouseholdGeneratorVersion = 'v2.21.0';

class GeneratedFamilyMember {
  const GeneratedFamilyMember({
    required this.id,
    required this.name,
    required this.ageYears,
    required this.careSkill,
    required this.relationshipToCaregiver,
    required this.roleToChild,
    required this.routine,
    required this.authorizedResourceKeys,
  });

  final String id;
  final String name;
  final int ageYears;
  final int careSkill;
  final String relationshipToCaregiver;
  final String roleToChild;
  final List<Map<String, Object?>> routine;
  final List<String> authorizedResourceKeys;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'age_years': ageYears,
    'care_skill': careSkill,
    'relationship_to_caregiver': relationshipToCaregiver,
    'role_to_child': roleToChild,
    'routine': routine,
    'authorized_resource_keys': authorizedResourceKeys,
  };
}

/// Một hộ nền có thể đón nhân vật người chơi khi chào đời.
class GeneratedBirthHousehold {
  const GeneratedBirthHousehold({
    required this.siteId,
    required this.householdId,
    required this.householdName,
    required this.roomId,
    required this.roomName,
    required this.caregiverId,
    required this.caregiverName,
    required this.caregiverAgeYears,
    required this.caregiverSkill,
    required this.caregiverRole,
    required this.familyOriginSummary,
    required this.foodQuantity,
    required this.waterQuantity,
    required this.fuelQuantity,
    required this.infantFeedQuantity,
    this.caregiverRoutine = const <Map<String, Object?>>[],
    this.familyMembers = const <GeneratedFamilyMember>[],
  });

  final String siteId;
  final String householdId;
  final String householdName;
  final String roomId;
  final String roomName;
  final String caregiverId;
  final String caregiverName;
  final int caregiverAgeYears;
  final int caregiverSkill;

  /// Vai trò của NPC đối với P00: `mother`, `father` hoặc `guardian`.
  final String caregiverRole;
  final String familyOriginSummary;
  final int foodQuantity;
  final int waterQuantity;
  final int fuelQuantity;
  final int infantFeedQuantity;
  final List<Map<String, Object?>> caregiverRoutine;
  final List<GeneratedFamilyMember> familyMembers;

  Map<String, Object> toJson() => <String, Object>{
    'site_id': siteId,
    'household_id': householdId,
    'household_name': householdName,
    'room_id': roomId,
    'room_name': roomName,
    'caregiver_id': caregiverId,
    'caregiver_name': caregiverName,
    'caregiver_age_years': caregiverAgeYears,
    'caregiver_skill': caregiverSkill,
    'caregiver_role': caregiverRole,
    'family_origin_summary': familyOriginSummary,
    'food_quantity': foodQuantity,
    'water_quantity': waterQuantity,
    'fuel_quantity': fuelQuantity,
    'infant_feed_quantity': infantFeedQuantity,
    if (caregiverRoutine.isNotEmpty) 'caregiver_routine': caregiverRoutine,
    if (familyMembers.isNotEmpty)
      'family_members': familyMembers
          .map((GeneratedFamilyMember value) => value.toJson())
          .toList(),
  };
}

class GeneratedBirthHouseholds {
  GeneratedBirthHouseholds({
    required this.rootSeed,
    required this.worldFingerprint,
    required this.historyFingerprint,
    required List<GeneratedBirthHousehold> households,
    this.generatorVersion = birthHouseholdGeneratorVersion,
  }) : households = List<GeneratedBirthHousehold>.unmodifiable(households) {
    final Set<String> siteIds = <String>{};
    final Set<String> householdIds = <String>{};
    final Set<String> roomIds = <String>{};
    final Set<String> caregiverIds = <String>{};
    final Set<String> personIds = <String>{};
    for (final GeneratedBirthHousehold value in this.households) {
      if (!siteIds.add(value.siteId) ||
          !householdIds.add(value.householdId) ||
          !roomIds.add(value.roomId) ||
          !caregiverIds.add(value.caregiverId)) {
        throw ArgumentError('Generated birth household identifiers overlap.');
      }
      if (!personIds.add(value.caregiverId)) {
        throw ArgumentError('Generated birth family person identifiers overlap.');
      }
      if (!const <String>{'mother', 'father', 'guardian'}
              .contains(value.caregiverRole) ||
          value.caregiverName.isEmpty ||
          value.familyOriginSummary.isEmpty ||
          value.caregiverAgeYears < 18 ||
          value.caregiverSkill < 0 ||
          value.caregiverSkill > 1000 ||
          value.foodQuantity <= 0 ||
          value.waterQuantity <= 0 ||
          value.fuelQuantity <= 0 ||
          value.infantFeedQuantity <= 0) {
        throw ArgumentError('Generated birth household data is invalid.');
      }
      for (final GeneratedFamilyMember member in value.familyMembers) {
        if (!personIds.add(member.id) ||
            member.name.isEmpty ||
            member.ageYears < 18 ||
            member.careSkill < 0 ||
            member.careSkill > 1000 ||
            !const <String>{'mother', 'father', 'guardian'}.contains(
              member.roleToChild,
            ) ||
            !const <String>{'spouse', 'sibling'}.contains(
              member.relationshipToCaregiver,
            ) ||
            !member.authorizedResourceKeys.contains('infant_feed')) {
          throw ArgumentError('Generated birth family member data is invalid.');
        }
      }
    }
    fingerprint = _fingerprint(<String, Object?>{
      'root_seed': rootSeed,
      'world_fingerprint': worldFingerprint,
      'history_fingerprint': historyFingerprint,
      'generator_version': generatorVersion,
      'households': this.households
          .map((GeneratedBirthHousehold value) => value.toJson())
          .toList(),
    });
  }

  final int rootSeed;
  final String worldFingerprint;
  final String historyFingerprint;
  final List<GeneratedBirthHousehold> households;
  final String generatorVersion;
  late final String fingerprint;
}

/// Sinh hộ từ seed và hậu quả của lịch sử, không dùng Random của nền tảng.
class BirthHouseholdGenerator {
  const BirthHouseholdGenerator._();

  static GeneratedBirthHouseholds generate({
    required GeneratedWorld world,
    required GeneratedWorldHistory history,
    bool includeFamilyMembers = false,
  }) {
    if (world.rootSeed != history.rootSeed ||
        world.fingerprint != history.worldFingerprint) {
      throw StateError('Birth households require a matching map and history.');
    }
    final HistoricalMetrics metrics = history.epochs.isEmpty
        ? const HistoricalMetrics.initial()
        : history.epochs.last.metricsAfter;
    return GeneratedBirthHouseholds(
      rootSeed: world.rootSeed,
      worldFingerprint: world.fingerprint,
      historyFingerprint: history.fingerprint,
      generatorVersion: includeFamilyMembers
          ? extendedBirthHouseholdGeneratorVersion
          : birthHouseholdGeneratorVersion,
      households: <GeneratedBirthHousehold>[
        _generate(
          world: world,
          metrics: metrics,
          historyFingerprint: history.fingerprint,
          siteId: 'SITE-FIELD',
          householdId: 'H02',
          roomId: 'ROOM-FIELD-HOME',
          caregiverId: 'N05',
          householdKinds: const <String>[
            'Hộ giữ đồng',
            'Hộ trồng kê',
            'Hộ canh ruộng',
          ],
          roomKinds: const <String>[
            'Chòi giữ đồng',
            'Nhà đất cạnh ruộng',
            'Lều ruộng phía nam',
          ],
          roleKinds: const <String>['mother', 'father', 'guardian'],
          skillBase: 470,
          foodBase: 19000,
          waterBase: 12500,
          fuelBase: 1900,
          feedBase: 3200,
          includeFamilyMembers: includeFamilyMembers,
          supportingCaregiverId: 'N07',
        ),
        _generate(
          world: world,
          metrics: metrics,
          historyFingerprint: history.fingerprint,
          siteId: 'SITE-MARKET',
          householdId: 'H03',
          roomId: 'ROOM-MARKET-LOFT',
          caregiverId: 'N06',
          householdKinds: const <String>[
            'Hộ quán trọ chợ',
            'Hộ hàng thuốc',
            'Hộ bán trà',
          ],
          roomKinds: const <String>[
            'Gác quán trọ',
            'Phòng sau hiệu thuốc',
            'Buồng trên quán trà',
          ],
          roleKinds: const <String>['guardian', 'mother', 'father'],
          skillBase: 720,
          foodBase: 7500,
          waterBase: 27000,
          fuelBase: 5200,
          feedBase: 6000,
          includeFamilyMembers: includeFamilyMembers,
          supportingCaregiverId: 'N08',
        ),
      ],
    );
  }

  static GeneratedBirthHousehold _generate({
    required GeneratedWorld world,
    required HistoricalMetrics metrics,
    required String historyFingerprint,
    required String siteId,
    required String householdId,
    required String roomId,
    required String caregiverId,
    required List<String> householdKinds,
    required List<String> roomKinds,
    required List<String> roleKinds,
    required int skillBase,
    required int foodBase,
    required int waterBase,
    required int fuelBase,
    required int feedBase,
    required bool includeFamilyMembers,
    required String supportingCaregiverId,
  }) {
    final _SeedStream stream = _SeedStream.derived(
      world.rootSeed,
      '$historyFingerprint:$siteId:${metrics.populationEstimate}:'
      '${metrics.tradeReach}:${metrics.resourcePressure}',
    );
    final String role = roleKinds[stream.nextInt(roleKinds.length)];
    final String name = _names[stream.nextInt(_names.length)];
    final int pressure = metrics.resourcePressure;
    final int trade = metrics.tradeReach;
    final String householdName =
        householdKinds[stream.nextInt(householdKinds.length)];
    final String origin = switch (role) {
      'mother' =>
        '$name là mẹ ruột, đã sống trong $householdName qua những biến động cuối thời tiền sử.',
      'father' => '$name là cha ruột, đang tự tay chăm con tại $householdName.',
      _ =>
        '$name nhận nuôi và là người giám hộ đầu tiên của đứa trẻ tại $householdName.',
    };
    final String supporterRole = switch (role) {
      'mother' => 'father',
      'father' => 'mother',
      _ => 'guardian',
    };
    final String relationship = role == 'guardian' ? 'sibling' : 'spouse';
    final List<Map<String, Object?>> primaryRoutine = includeFamilyMembers
        ? <Map<String, Object?>>[
            <String, Object?>{
              'id': 'R-$caregiverId-MORNING',
              'activity': siteId == 'SITE-FIELD'
                  ? 'làm việc ngoài ruộng'
                  : 'trông quầy buổi sáng',
              'start_second_of_day': 6 * 3600,
              'duration_seconds': 6 * 3600,
              'room_id': roomId,
              'priority': 70,
              'blocking': true,
            },
          ]
        : const <Map<String, Object?>>[];
    final List<GeneratedFamilyMember> familyMembers = includeFamilyMembers
        ? <GeneratedFamilyMember>[
            GeneratedFamilyMember(
              id: supportingCaregiverId,
              name: _distinctName(stream, name),
              ageYears: 22 + stream.nextInt(27),
              careSkill: (400 + stream.nextInt(61)).clamp(0, 1000),
              relationshipToCaregiver: relationship,
              roleToChild: supporterRole,
              routine: <Map<String, Object?>>[
                <String, Object?>{
                  'id': 'R-$supportingCaregiverId-AFTERNOON',
                  'activity': siteId == 'SITE-FIELD'
                      ? 'gánh nước cuối ngày'
                      : 'trông quầy buổi chiều',
                  'start_second_of_day': 12 * 3600,
                  'duration_seconds': 6 * 3600,
                  'room_id': roomId,
                  'priority': 70,
                  'blocking': true,
                },
              ],
              authorizedResourceKeys: const <String>[
                'food',
                'water',
                'fuel',
                'infant_feed',
              ],
            ),
          ]
        : const <GeneratedFamilyMember>[];
    return GeneratedBirthHousehold(
      siteId: siteId,
      householdId: householdId,
      householdName: householdName,
      roomId: roomId,
      roomName: roomKinds[stream.nextInt(roomKinds.length)],
      caregiverId: caregiverId,
      caregiverName: name,
      caregiverAgeYears: 24 + stream.nextInt(24),
      caregiverSkill: (skillBase + stream.nextInt(171)).clamp(0, 1000),
      caregiverRole: role,
      familyOriginSummary: origin,
      foodQuantity: (foodBase + stream.nextInt(8501) - pressure * 3).clamp(
        3200,
        42000,
      ),
      waterQuantity: (waterBase + stream.nextInt(13001) - pressure * 4).clamp(
        5000,
        60000,
      ),
      fuelQuantity: (fuelBase + stream.nextInt(3501) - pressure).clamp(
        800,
        12000,
      ),
      infantFeedQuantity:
          (feedBase + stream.nextInt(3501) + trade * 2 - pressure * 2).clamp(
            1200,
            14000,
          ),
      caregiverRoutine: primaryRoutine,
      familyMembers: familyMembers,
    );
  }

  static String _distinctName(_SeedStream stream, String existing) {
    String result = _names[stream.nextInt(_names.length)];
    while (result == existing) {
      result = _names[stream.nextInt(_names.length)];
    }
    return result;
  }
}

const List<String> _names = <String>[
  'Lâm Thị Sương',
  'Trần Bách',
  'Đỗ Thanh Mai',
  'Phạm Kính',
  'Nguyễn Vân Chi',
  'Tạ Quang',
  'Hoàng Ngọc Lan',
  'Vũ Mộc',
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
