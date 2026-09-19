import 'dart:convert';

import 'region.dart';
import 'world_generation.dart';
import 'world_history.dart';

const String birthHouseholdGeneratorVersion = 'v2.20.0';
const String extendedBirthHouseholdGeneratorVersion = 'v2.21.0';
const String relationalBirthHouseholdGeneratorVersion = 'v3.0.0-dev.1';
const String negotiatedBirthHouseholdGeneratorVersion = 'v3.0.0-dev.2';
const String supportedBirthHouseholdGeneratorVersion = 'v3.0.0-dev.3';
const String resilientBirthHouseholdGeneratorVersion = 'v3.0.0-dev.4';
const String burdenedBirthHouseholdGeneratorVersion = 'v3.0.0-dev.5';
const String conflictedBirthHouseholdGeneratorVersion = 'v3.0.0-dev.6';
const String promisedBirthHouseholdGeneratorVersion = 'v3.0.0-dev.7';
const String reliableBirthHouseholdGeneratorVersion = 'v3.0.0-dev.8';
const String witnessedBirthHouseholdGeneratorVersion = 'v3.0.0-dev.9';
const String attachedBirthHouseholdGeneratorVersion = 'v4.0.0-dev.1';
const String environmentalBirthHouseholdGeneratorVersion = 'v5.0-dev.5';

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
    this.familyMemoryEnabled = false,
    this.familyCareNegotiationEnabled = false,
    this.familyCareSupportEnabled = false,
    this.familyCareResilienceEnabled = false,
    this.familyCareBurdenEnabled = false,
    this.familyCareConflictEnabled = false,
    this.familyCarePromiseEnabled = false,
    this.familyCareReliabilityEnabled = false,
    this.familyCareWitnessMemoryEnabled = false,
    this.infantAttachmentLearningEnabled = false,
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
  final bool familyMemoryEnabled;
  final bool familyCareNegotiationEnabled;
  final bool familyCareSupportEnabled;
  final bool familyCareResilienceEnabled;
  final bool familyCareBurdenEnabled;
  final bool familyCareConflictEnabled;
  final bool familyCarePromiseEnabled;
  final bool familyCareReliabilityEnabled;
  final bool familyCareWitnessMemoryEnabled;
  final bool infantAttachmentLearningEnabled;

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
    if (familyMemoryEnabled) 'family_memory_enabled': true,
    if (familyCareNegotiationEnabled) 'family_care_negotiation_enabled': true,
    if (familyCareSupportEnabled) 'family_care_support_enabled': true,
    if (familyCareResilienceEnabled) 'family_care_resilience_enabled': true,
    if (familyCareBurdenEnabled) 'family_care_burden_enabled': true,
    if (familyCareConflictEnabled) 'family_care_conflict_enabled': true,
    if (familyCarePromiseEnabled) 'family_care_promise_enabled': true,
    if (familyCareReliabilityEnabled) 'family_care_reliability_enabled': true,
    if (familyCareWitnessMemoryEnabled)
      'family_care_witness_memory_enabled': true,
    if (infantAttachmentLearningEnabled)
      'infant_attachment_learning_enabled': true,
  };
}

class GeneratedBirthHouseholds {
  GeneratedBirthHouseholds({
    required this.rootSeed,
    required this.worldFingerprint,
    required this.historyFingerprint,
    required List<GeneratedBirthHousehold> households,
    this.settlementAssessments = const <String, SettlementAssessmentState>{},
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
        throw ArgumentError(
          'Generated birth family person identifiers overlap.',
        );
      }
      if (!const <String>{
            'mother',
            'father',
            'guardian',
          }.contains(value.caregiverRole) ||
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
            !const <String>{
              'mother',
              'father',
              'guardian',
            }.contains(member.roleToChild) ||
            !const <String>{
              'spouse',
              'sibling',
            }.contains(member.relationshipToCaregiver) ||
            !member.authorizedResourceKeys.contains('infant_feed')) {
          throw ArgumentError('Generated birth family member data is invalid.');
        }
      }
    }
    for (final MapEntry<String, SettlementAssessmentState> entry
        in settlementAssessments.entries) {
      final SettlementAssessmentState assessment = entry.value;
      if (entry.key.isEmpty ||
          assessment.score < 0 ||
          assessment.score > 1000 ||
          assessment.reasons.isEmpty ||
          assessment.historyFingerprint != historyFingerprint) {
        throw ArgumentError('Generated settlement assessment is invalid.');
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
      if (settlementAssessments.isNotEmpty)
        'settlement_assessments': <Map<String, Object>>[
          for (final MapEntry<String, SettlementAssessmentState> entry
              in settlementAssessments.entries)
            <String, Object>{
              'site_id': entry.key,
              ...entry.value.toJson(),
            },
        ],
    });
  }

  final int rootSeed;
  final String worldFingerprint;
  final String historyFingerprint;
  final List<GeneratedBirthHousehold> households;
  final Map<String, SettlementAssessmentState> settlementAssessments;
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
    bool includeFamilyMemory = false,
    bool includeFamilyCareNegotiation = false,
    bool includeFamilyCareSupport = false,
    bool includeFamilyCareResilience = false,
    bool includeFamilyCareBurden = false,
    bool includeFamilyCareConflict = false,
    bool includeFamilyCarePromise = false,
    bool includeFamilyCareReliability = false,
    bool includeFamilyCareWitnessMemory = false,
    bool includeInfantAttachmentLearning = false,
  }) {
    if (world.rootSeed != history.rootSeed ||
        world.fingerprint != history.worldFingerprint) {
      throw StateError('Birth households require a matching map and history.');
    }
    final HistoricalMetrics metrics = history.epochs.isEmpty
        ? const HistoricalMetrics.initial()
        : history.epochs.last.metricsAfter;
    final bool useEnvironmentalPlacement =
        world.generatorVersion.startsWith('v5.');
    final Map<String, SettlementAssessmentState> settlementAssessments =
        useEnvironmentalPlacement
        ? _assessSettlementSites(
            world: world,
            metrics: metrics,
            historyFingerprint: history.fingerprint,
          )
        : const <String, SettlementAssessmentState>{};
    final List<String> selectedSiteIds = useEnvironmentalPlacement
        ? <String>[
            for (final MapEntry<String, SettlementAssessmentState> entry
                in settlementAssessments.entries)
              if (entry.value.selectedForBirthHousehold) entry.key,
          ]
        : const <String>['SITE-FIELD', 'SITE-MARKET'];
    if (selectedSiteIds.length != 2) {
      throw StateError(
        'Environmental placement must select exactly two birth settlements.',
      );
    }
    final WorldSite firstSite = world.site(selectedSiteIds[0]);
    final WorldSite secondSite = world.site(selectedSiteIds[1]);
    return GeneratedBirthHouseholds(
      rootSeed: world.rootSeed,
      worldFingerprint: world.fingerprint,
      historyFingerprint: history.fingerprint,
      settlementAssessments: settlementAssessments,
      generatorVersion: useEnvironmentalPlacement
          ? environmentalBirthHouseholdGeneratorVersion
          : includeInfantAttachmentLearning
          ? attachedBirthHouseholdGeneratorVersion
          : includeFamilyCareWitnessMemory
          ? witnessedBirthHouseholdGeneratorVersion
          : includeFamilyCareReliability
          ? reliableBirthHouseholdGeneratorVersion
          : includeFamilyCarePromise
          ? promisedBirthHouseholdGeneratorVersion
          : includeFamilyCareConflict
          ? conflictedBirthHouseholdGeneratorVersion
          : includeFamilyCareBurden
          ? burdenedBirthHouseholdGeneratorVersion
          : includeFamilyCareResilience
          ? resilientBirthHouseholdGeneratorVersion
          : includeFamilyCareSupport
          ? supportedBirthHouseholdGeneratorVersion
          : includeFamilyCareNegotiation
          ? negotiatedBirthHouseholdGeneratorVersion
          : includeFamilyMemory
          ? relationalBirthHouseholdGeneratorVersion
          : includeFamilyMembers
          ? extendedBirthHouseholdGeneratorVersion
          : birthHouseholdGeneratorVersion,
      households: <GeneratedBirthHousehold>[
        _generate(
          world: world,
          metrics: metrics,
          historyFingerprint: history.fingerprint,
          siteId: firstSite.id,
          householdId: 'H02',
          roomId: 'ROOM-FIELD-HOME',
          caregiverId: 'N05',
          householdKinds: _householdKinds(firstSite),
          roomKinds: _roomKinds(firstSite),
          roleKinds: const <String>['mother', 'father', 'guardian'],
          skillBase: 470,
          foodBase: 19000,
          waterBase: 12500,
          fuelBase: 1900,
          feedBase: 3200,
          includeFamilyMembers:
              includeFamilyMembers ||
              includeFamilyMemory ||
              includeFamilyCareNegotiation ||
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyMemory:
              includeFamilyMemory ||
              includeFamilyCareNegotiation ||
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareNegotiation:
              includeFamilyCareNegotiation ||
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareSupport:
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareResilience:
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareBurden:
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareConflict:
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability,
          includeFamilyCarePromise:
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareReliability:
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareWitnessMemory:
              includeFamilyCareWitnessMemory || includeInfantAttachmentLearning,
          includeInfantAttachmentLearning: includeInfantAttachmentLearning,
          supportingCaregiverId: 'N07',
        ),
        _generate(
          world: world,
          metrics: metrics,
          historyFingerprint: history.fingerprint,
          siteId: secondSite.id,
          householdId: 'H03',
          roomId: 'ROOM-MARKET-LOFT',
          caregiverId: 'N06',
          householdKinds: _householdKinds(secondSite),
          roomKinds: _roomKinds(secondSite),
          roleKinds: const <String>['guardian', 'mother', 'father'],
          skillBase: 720,
          foodBase: 7500,
          waterBase: 27000,
          fuelBase: 5200,
          feedBase: 6000,
          includeFamilyMembers:
              includeFamilyMembers ||
              includeFamilyMemory ||
              includeFamilyCareNegotiation ||
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyMemory:
              includeFamilyMemory ||
              includeFamilyCareNegotiation ||
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareNegotiation:
              includeFamilyCareNegotiation ||
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareSupport:
              includeFamilyCareSupport ||
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareResilience:
              includeFamilyCareResilience ||
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareBurden:
              includeFamilyCareBurden ||
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareConflict:
              includeFamilyCareConflict ||
              includeFamilyCarePromise ||
              includeFamilyCareReliability,
          includeFamilyCarePromise:
              includeFamilyCarePromise ||
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareReliability:
              includeFamilyCareReliability ||
              includeFamilyCareWitnessMemory ||
              includeInfantAttachmentLearning,
          includeFamilyCareWitnessMemory:
              includeFamilyCareWitnessMemory || includeInfantAttachmentLearning,
          includeInfantAttachmentLearning: includeInfantAttachmentLearning,
          supportingCaregiverId: 'N08',
        ),
      ],
    );
  }

  static Map<String, SettlementAssessmentState> _assessSettlementSites({
    required GeneratedWorld world,
    required HistoricalMetrics metrics,
    required String historyFingerprint,
  }) {
    final int distanceScale = world.region.widthMm + world.region.heightMm;

    int proximity(WorldSite from, WorldSite to) =>
        (1000 - from.distanceTo(to.center) * 1000 ~/ distanceScale)
            .clamp(0, 1000)
            .toInt();

    int resourceAccess(WorldSite target, String kind) {
      int best = 0;
      for (final WorldSite source in world.sites) {
        for (final NaturalResourceDeposit resource
            in source.resourceDeposits) {
          if (resource.kind != kind) continue;
          final int fullness = resource.quantity * 1000 ~/ resource.capacity;
          final int value =
              (fullness * 4 +
                  resource.accessibility * 3 +
                  proximity(target, source) * 3) ~/
              10;
          if (value > best) best = value;
        }
      }
      return best;
    }

    int ecologicalSupport(WorldSite target) {
      int best = 0;
      for (final WorldSite source in world.sites) {
        for (final EcologicalPopulationState population
            in source.ecologicalPopulations) {
          final int abundance =
              population.population * 1000 ~/ population.carryingCapacity;
          final int value =
              (population.health * 4 +
                  abundance * 3 +
                  proximity(target, source) * 3) ~/
              10;
          if (value > best) best = value;
        }
      }
      return best;
    }

    final Map<String, SettlementAssessmentState> raw =
        <String, SettlementAssessmentState>{};
    for (final WorldSite site in world.sites) {
      if (site.kind == 'river') continue;
      final int terrain = switch (site.terrainCode) {
        'alluvial_terrace' => 850,
        'floodplain' => 680,
        'mountain_pass' => 360,
        _ => 500,
      };
      final int water = resourceAccess(site, 'surface_water');
      final int farmland = resourceAccess(site, 'fertile_topsoil');
      final int timber = resourceAccess(site, 'timber_stand');
      final int ecology = ecologicalSupport(site);
      final int cultivation = (metrics.cultivatedLandMu * 20)
          .clamp(0, 1000)
          .toInt();
      final int historicalBase =
          ((1000 - metrics.resourcePressure) +
                  metrics.tradeReach +
                  cultivation) ~/
              3;
      final int specialization = switch (site.kind) {
        'market' => metrics.tradeReach ~/ 5,
        'field' => cultivation ~/ 5,
        'household' => (1000 - metrics.resourcePressure) ~/ 8,
        _ => 0,
      };
      final int score =
          ((terrain * 30 +
                          water * 25 +
                          farmland * 15 +
                          timber * 10 +
                          ecology * 10 +
                          historicalBase * 10) ~/
                      100 +
                  specialization)
              .clamp(0, 1000)
              .toInt();
      final bool viable = water >= 250 && score >= 450;
      raw[site.id] = SettlementAssessmentState(
        score: score,
        viable: viable,
        reasons: <String>[
          'Địa hình ${site.terrainCode}: $terrain/1000',
          'Tiếp cận nước: $water/1000',
          'Tiếp cận đất canh tác: $farmland/1000',
          'Tiếp cận gỗ: $timber/1000',
          'Hỗ trợ sinh thái: $ecology/1000',
          'Dấu vết lịch sử: $historicalBase/1000',
        ],
        historyFingerprint: historyFingerprint,
        selectedForBirthHousehold: false,
      );
    }
    final List<MapEntry<String, SettlementAssessmentState>> ranked = raw.entries
        .where(
          (MapEntry<String, SettlementAssessmentState> entry) =>
              entry.value.viable && world.site(entry.key).kind != 'household',
        )
        .toList()
      ..sort((a, b) {
        final int byScore = b.value.score.compareTo(a.value.score);
        return byScore != 0 ? byScore : a.key.compareTo(b.key);
      });
    if (ranked.length < 2) {
      throw StateError('World history leaves fewer than two viable settlements.');
    }
    final Set<String> selected = <String>{ranked[0].key, ranked[1].key};
    return <String, SettlementAssessmentState>{
      for (final MapEntry<String, SettlementAssessmentState> entry
          in raw.entries)
        entry.key: SettlementAssessmentState(
          score: entry.value.score,
          viable: entry.value.viable,
          reasons: entry.value.reasons,
          historyFingerprint: entry.value.historyFingerprint,
          selectedForBirthHousehold: selected.contains(entry.key),
        ),
    };
  }

  static List<String> _householdKinds(WorldSite site) => switch (site.kind) {
    'field' => const <String>['Hộ giữ đồng', 'Hộ trồng kê', 'Hộ canh ruộng'],
    'market' => const <String>['Hộ quán trọ chợ', 'Hộ hàng thuốc', 'Hộ bán trà'],
    'pass' => const <String>['Hộ giữ đèo', 'Hộ tiều phu', 'Hộ dẫn đường'],
    _ => const <String>['Hộ ven suối', 'Hộ làm vườn', 'Hộ bám thung lũng'],
  };

  static List<String> _roomKinds(WorldSite site) => switch (site.kind) {
    'field' => const <String>[
      'Chòi giữ đồng',
      'Nhà đất cạnh ruộng',
      'Lều ruộng phía nam',
    ],
    'market' => const <String>[
      'Gác quán trọ',
      'Phòng sau hiệu thuốc',
      'Buồng trên quán trà',
    ],
    'pass' => const <String>[
      'Nhà đá chân đèo',
      'Lều gỗ ven rừng',
      'Trạm nghỉ đường núi',
    ],
    _ => const <String>['Nhà đất ven suối', 'Nhà sàn thấp', 'Nhà vườn'],
  };

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
    required bool includeFamilyMemory,
    required bool includeFamilyCareNegotiation,
    required bool includeFamilyCareSupport,
    required bool includeFamilyCareResilience,
    required bool includeFamilyCareBurden,
    required bool includeFamilyCareConflict,
    required bool includeFamilyCarePromise,
    required bool includeFamilyCareReliability,
    required bool includeFamilyCareWitnessMemory,
    required bool includeInfantAttachmentLearning,
    required String supportingCaregiverId,
  }) {
    final WorldSite site = world.site(siteId);
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
              'activity': switch (site.kind) {
                'field' => 'làm việc ngoài ruộng',
                'market' => 'trông quầy buổi sáng',
                'pass' => 'kiểm tra đường đèo',
                _ => 'chăm nom vườn nhà',
              },
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
                  'activity': switch (site.kind) {
                    'field' => 'gánh nước cuối ngày',
                    'market' => 'trông quầy buổi chiều',
                    'pass' => 'gom củi cuối ngày',
                    _ => 'gánh nước về nhà',
                  },
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
      familyMemoryEnabled: includeFamilyMemory,
      familyCareNegotiationEnabled: includeFamilyCareNegotiation,
      familyCareSupportEnabled: includeFamilyCareSupport,
      familyCareResilienceEnabled: includeFamilyCareResilience,
      familyCareBurdenEnabled: includeFamilyCareBurden,
      familyCareConflictEnabled: includeFamilyCareConflict,
      familyCarePromiseEnabled: includeFamilyCarePromise,
      familyCareReliabilityEnabled: includeFamilyCareReliability,
      familyCareWitnessMemoryEnabled: includeFamilyCareWitnessMemory,
      infantAttachmentLearningEnabled: includeInfantAttachmentLearning,
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
