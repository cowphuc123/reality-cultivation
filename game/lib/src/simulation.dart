import 'dart:convert';

import 'adult_body.dart';
import 'birth_household_generation.dart';
import 'agenda.dart';
import 'care.dart';
import 'childhood.dart';
import 'community_exchange.dart';
import 'community_survival.dart';
import 'social_relation.dart';
import 'domestic.dart';
import 'family.dart';
import 'geometry.dart';
import 'household.dart';
import 'historical_legacy.dart';
import 'infancy.dart';
import 'infant_body.dart';
import 'knowledge.dart';
import 'livelihood.dart';
import 'region.dart';
import 'route.dart';
import 'routine.dart';
import 'settlement_population_generation.dart';
import 'world_generation.dart';
import 'world_entry.dart';
import 'world_history.dart';

part 'simulation_livelihood.dart';
part 'simulation_state.dart';

const int gameSecondsPerDay = 86400;
const int realMillisecondsPerGameDay = 5000;

class Simulation {
  Simulation.fromSeed(int seed) : _state = WorldState.initial(seed);
  Simulation.fromSave(String source) : _state = WorldState.load(source);

  WorldState _state;
  WorldState get state => _state;

  Map<String, int> childCaregiverPreferences(String personId) {
    final PersonState? child = _state.people[personId];
    if (child == null || child.childhood == null) return const <String, int>{};
    final Map<String, int> result = <String, int>{};
    for (final String caregiverId in child.familyRelationships.keys) {
      final PersonState? caregiver = _state.people[caregiverId];
      if (caregiver != null) {
        result[caregiverId] = _childCaregiverPreference(child, caregiver);
      }
    }
    return Map<String, int>.unmodifiable(result);
  }

  int _childBodyAdjustedScore(int rawScore, ChildhoodState childhood) =>
      rawScore * (700 + childhood.body.developmentSupport) ~/ 1700;

  /// Bật đường phát triển V4 cho một trẻ đã sinh mà không làm thay đổi các
  /// fixture phiên bản cũ. Mốc đầu tiên vẫn tới qua hàng đợi ở ngày 31.
  void enableChildhoodDevelopment(String personId) {
    final PersonState? person = _state.people[personId];
    if (person == null) throw StateError('Unknown person: $personId');
    if (person.infancy == null) {
      throw StateError('Nhân vật không có hồ sơ sơ sinh để nối sang tuổi thơ.');
    }
    final String playItemId = 'I-CHILD-$personId-PLAY-01';
    final bool playItemExists =
        _state.items.containsKey(playItemId) ||
        _state.pendingEvents.any(
          (ScheduledEvent event) =>
              event.kind == 'item_created' &&
              event.payload['item_id'] == playItemId,
        );
    if (!playItemExists && person.roomId != null && person.positionMm != null) {
      schedule(
        due: _state.now,
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': playItemId,
          'kind': 'child_play_object',
          'position_mm': person.positionMm!,
          'position_y_mm': person.positionYMm,
          'quantity': 1,
          'condition': 1000,
          'unit': 'piece',
          'owner_household_id': person.householdId,
          'room_id': person.roomId,
        },
      );
    }
    if (person.childhood != null ||
        _state.pendingEvents.any(
          (ScheduledEvent event) =>
              event.kind == 'childhood_started' &&
              event.payload['person_id'] == personId,
        )) {
      return;
    }
    final SimTime due = person.birthTime.addDays(30).compareTo(_state.now) < 0
        ? _state.now
        : person.birthTime.addDays(30);
    schedule(
      due: due,
      phase: EventPhase.bookkeeping,
      kind: 'childhood_started',
      payload: <String, Object?>{'person_id': personId},
    );
  }

  ScheduledEvent schedule({
    required SimTime due,
    required EventPhase phase,
    required String kind,
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    if (due.compareTo(_state.now) < 0) {
      throw ArgumentError('Cannot schedule an event in the past.');
    }
    final int sequence = _state.nextSequence;
    final ScheduledEvent event = ScheduledEvent(
      id: 'event-' + sequence.toString(),
      due: due,
      phase: phase,
      sequence: sequence,
      kind: kind,
      payload: Map<String, Object?>.unmodifiable(payload),
    );
    final List<ScheduledEvent> queue = <ScheduledEvent>[
      ..._state.pendingEvents,
      event,
    ]..sort();
    _replace(nextSequence: sequence + 1, pendingEvents: queue);
    return event;
  }

  /// Đưa một kết quả worldgen vào hàng đợi sự kiện theo đúng thứ tự công bố.
  void materializeWorld(GeneratedWorld generated, {SimTime? due}) {
    if (generated.rootSeed != _state.seed) {
      throw StateError('Generated world seed does not match simulation seed.');
    }
    if (_state.worldGenesis != null ||
        _state.regions.isNotEmpty ||
        _state.sites.isNotEmpty ||
        _state.pendingEvents.any(
          (ScheduledEvent event) =>
              event.kind == 'world_genesis_completed' ||
              event.kind == 'region_created' ||
              event.kind == 'site_created',
        )) {
      throw StateError('World geography has already been materialized.');
    }
    final SimTime publishAt = due ?? _state.now;
    schedule(
      due: publishAt,
      phase: EventPhase.completion,
      kind: 'region_created',
      payload: generated.region.toJson(),
    );
    for (final WorldSite site in generated.sites) {
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'site_created',
        payload: site.toJson(),
      );
    }
    schedule(
      due: publishAt,
      phase: EventPhase.completion,
      kind: 'world_genesis_completed',
      payload: generated.record.toJson(),
    );
    if (generated.sites.any(
      (WorldSite site) => site.resourceDeposits.any(
        (NaturalResourceDeposit resource) => resource.renewable,
      ),
    )) {
      schedule(
        due: publishAt.addDays(365),
        phase: EventPhase.transfer,
        kind: 'natural_resource_yearly_renewal',
      );
    }
    if (generated.sites.any(
      (WorldSite site) => site.ecologicalPopulations.isNotEmpty,
    )) {
      schedule(
        due: publishAt.addDays(365),
        phase: EventPhase.bookkeeping,
        kind: 'ecology_yearly_tick',
      );
    }
  }

  ScheduledEvent scheduleNaturalResourceExtraction({
    required String siteId,
    required String resourceId,
    required int amount,
    required String outputItemId,
    String? actorId,
    String? ownerHouseholdId,
    SimTime? due,
  }) {
    if (amount <= 0) throw ArgumentError.value(amount, 'amount');
    final WorldSite? site = _state.sites[siteId];
    if (site == null) throw StateError('Unknown site: $siteId');
    if (!site.resourceDeposits.any(
      (NaturalResourceDeposit value) => value.id == resourceId,
    )) {
      throw StateError('Unknown natural resource: $resourceId');
    }
    return schedule(
      due: due ?? _state.now,
      phase: EventPhase.transfer,
      kind: 'natural_resource_extracted',
      payload: <String, Object?>{
        'site_id': siteId,
        'resource_id': resourceId,
        'amount': amount,
        'output_item_id': outputItemId,
        if (actorId != null) 'actor_id': actorId,
        if (ownerHouseholdId != null) 'owner_household_id': ownerHouseholdId,
      },
    );
  }

  /// Chạy các epoch vĩ mô trước khi mở nhập thế cho người chơi.
  void simulatePrehistory(
    GeneratedWorldHistory generated, {
    SimTime? due,
    bool applyLegacy = false,
  }) {
    if (generated.rootSeed != _state.seed) {
      throw StateError('World history seed does not match simulation seed.');
    }
    if (_state.worldHistory != null ||
        _state.pendingEvents.any(
          (ScheduledEvent event) =>
              event.kind == 'world_history_started' ||
              event.kind == 'historical_epoch_simulated' ||
              event.kind == 'world_history_completed',
        )) {
      throw StateError('World history has already been scheduled.');
    }
    final String? scheduledWorldFingerprint =
        _state.worldGenesis?.fingerprint ??
        _state.pendingEvents
            .where(
              (ScheduledEvent event) => event.kind == 'world_genesis_completed',
            )
            .map(
              (ScheduledEvent event) => event.payload['fingerprint'] as String?,
            )
            .firstOrNull;
    if (scheduledWorldFingerprint == null ||
        scheduledWorldFingerprint != generated.worldFingerprint) {
      throw StateError('World history does not belong to this generated map.');
    }
    WorldHistoryState validation = WorldHistoryState.started(generated);
    for (final HistoricalEpochResult epoch in generated.epochs) {
      validation = validation.applyEpoch(epoch);
    }
    validation.markComplete();
    final SimTime publishAt = due ?? _state.now;
    schedule(
      due: publishAt,
      phase: EventPhase.completion,
      kind: 'world_history_started',
      payload: <String, Object?>{
        'root_seed': generated.rootSeed,
        'world_fingerprint': generated.worldFingerprint,
        'generator_version': generated.generatorVersion,
        'total_years': generated.totalYears,
        'expected_epoch_count': generated.epochs.length,
        'plan_fingerprint': generated.fingerprint,
      },
    );
    for (final HistoricalEpochResult epoch in generated.epochs) {
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'historical_epoch_simulated',
        payload: epoch.toJson(),
      );
    }
    schedule(
      due: publishAt,
      phase: EventPhase.completion,
      kind: 'world_history_completed',
      payload: <String, Object?>{if (applyLegacy) 'apply_legacy': true},
    );
  }

  /// Vật chất hóa các hộ nơi sinh do seed và lịch sử tạo ra.
  void materializeBirthHouseholds(
    GeneratedBirthHouseholds generated, {
    required GeneratedWorldHistory history,
    SimTime? due,
  }) {
    if (generated.rootSeed != _state.seed) {
      throw StateError('Birth household seed does not match simulation seed.');
    }
    final String? worldFingerprint =
        _state.worldGenesis?.fingerprint ??
        _state.pendingEvents
            .where(
              (ScheduledEvent event) => event.kind == 'world_genesis_completed',
            )
            .map(
              (ScheduledEvent event) => event.payload['fingerprint'] as String?,
            )
            .firstOrNull;
    if (worldFingerprint != generated.worldFingerprint) {
      throw StateError('Birth households do not belong to this map.');
    }
    if (history.rootSeed != _state.seed ||
        history.worldFingerprint != generated.worldFingerprint ||
        history.fingerprint != generated.historyFingerprint) {
      throw StateError('Birth households do not belong to this history.');
    }
    if (_state.households.isNotEmpty ||
        _state.pendingEvents.any(
          (ScheduledEvent event) =>
              event.payload['birth_genesis_fingerprint'] != null,
        )) {
      throw StateError('Birth households have already been materialized.');
    }
    final SimTime publishAt = due ?? _state.now;
    for (final MapEntry<String, SettlementAssessmentState> entry
        in generated.settlementAssessments.entries) {
      _generatedSiteFor(entry.key);
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'settlement_assessed',
        payload: <String, Object?>{
          'site_id': entry.key,
          ...entry.value.toJson(),
        },
      );
    }
    for (final GeneratedBirthHousehold plan in generated.households) {
      final WorldSite site = _generatedSiteFor(plan.siteId);
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'room_created',
        payload: <String, Object?>{
          'room_id': plan.roomId,
          'name': plan.roomName,
          'household_id': plan.householdId,
          'anchor_position_mm': site.center.xMm,
          'anchor_position_y_mm': site.center.yMm,
        },
      );
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'person_created',
        payload: <String, Object?>{
          'person_id': plan.caregiverId,
          'name': plan.caregiverName,
          'birth_seconds': -plan.caregiverAgeYears * 365 * gameSecondsPerDay,
          'position_mm': site.center.xMm,
          'position_y_mm': site.center.yMm,
          'room_id': plan.roomId,
          'household_id': plan.householdId,
          'caregiver_agent': true,
          'care_skill': plan.caregiverSkill,
          'current_activity': 'trông nom nhà cửa',
          'adult_body': const <String, Object?>{'mass_g': 52000},
          if (plan.familyMemoryEnabled) 'agenda': const <String, Object?>{},
          if (plan.caregiverRoutine.isNotEmpty)
            'routine': plan.caregiverRoutine,
          if (plan.familyMembers.isNotEmpty)
            'family_relationships': <String, String>{
              for (final GeneratedFamilyMember member in plan.familyMembers)
                member.id: member.relationshipToCaregiver,
            },
          if (plan.familyMemoryEnabled)
            'family_bonds': <String, Object?>{
              for (final GeneratedFamilyMember member in plan.familyMembers)
                member.id: <String, Object?>{
                  'affection': member.relationshipToCaregiver == 'spouse'
                      ? 650
                      : 600,
                  'trust': 600,
                },
            },
        },
      );
      for (final GeneratedFamilyMember member in plan.familyMembers) {
        schedule(
          due: publishAt,
          phase: EventPhase.completion,
          kind: 'person_created',
          payload: <String, Object?>{
            'person_id': member.id,
            'name': member.name,
            'birth_seconds': -member.ageYears * 365 * gameSecondsPerDay,
            'position_mm': site.center.xMm,
            'position_y_mm': site.center.yMm,
            'room_id': plan.roomId,
            'household_id': plan.householdId,
            'caregiver_agent': true,
            'care_skill': member.careSkill,
            'current_activity': 'trông nom nhà cửa',
            'adult_body': const <String, Object?>{'mass_g': 52000},
            if (plan.familyMemoryEnabled) 'agenda': const <String, Object?>{},
            'routine': member.routine,
            'family_relationships': <String, String>{
              plan.caregiverId: member.relationshipToCaregiver,
            },
            if (plan.familyMemoryEnabled)
              'family_bonds': <String, Object?>{
                plan.caregiverId: <String, Object?>{
                  'affection': member.relationshipToCaregiver == 'spouse'
                      ? 650
                      : 600,
                  'trust': 600,
                },
              },
          },
        );
      }
      final Map<String, (String, int, String)> resources =
          <String, (String, int, String)>{
            'food': ('staple_food', plan.foodQuantity, 'g'),
            'water': ('clean_water', plan.waterQuantity, 'ml'),
            'fuel': ('firewood', plan.fuelQuantity, 'g'),
            'infant_feed': ('infant_feed', plan.infantFeedQuantity, 'ml'),
          };
      final Map<String, String> itemIds = <String, String>{};
      final Map<String, List<String>> rights = <String, List<String>>{};
      for (final MapEntry<String, (String, int, String)> resource
          in resources.entries) {
        final String itemId =
            'I-${plan.householdId}-${resource.key.toUpperCase()}';
        itemIds[resource.key] = itemId;
        rights[itemId] = <String>[plan.caregiverId];
        for (final GeneratedFamilyMember member in plan.familyMembers) {
          if (member.authorizedResourceKeys.contains(resource.key)) {
            rights[itemId]!.add(member.id);
          }
        }
        schedule(
          due: publishAt,
          phase: EventPhase.completion,
          kind: 'item_created',
          payload: <String, Object?>{
            'item_id': itemId,
            'kind': resource.value.$1,
            'position_mm': site.center.xMm,
            'position_y_mm': site.center.yMm,
            'room_id': plan.roomId,
            'quantity': resource.value.$2,
            'unit': resource.value.$3,
            if (resource.key == 'infant_feed') ...<String, Object?>{
              'energy_kj_per_100ml': 300,
              'water_ml_per_100ml': 92,
            },
            'owner_household_id': plan.householdId,
          },
        );
      }
      final String clothId = 'I-${plan.householdId}-CLOTH';
      rights[clothId] = <String>[plan.caregiverId];
      for (final GeneratedFamilyMember member in plan.familyMembers) {
        rights[clothId]!.add(member.id);
      }
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': clothId,
          'kind': 'swaddling_cloth',
          'position_mm': site.center.xMm,
          'position_y_mm': site.center.yMm,
          'room_id': plan.roomId,
          'quantity': 1,
          'condition': 850,
          'owner_household_id': plan.householdId,
        },
      );
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'household_created',
        payload: <String, Object?>{
          'household_id': plan.householdId,
          'name': plan.householdName,
          'member_ids': <String>[
            plan.caregiverId,
            ...plan.familyMembers.map(
              (GeneratedFamilyMember value) => value.id,
            ),
          ],
          'resource_item_ids': itemIds,
          'authorized_users_by_item_id': rights,
          'scheduled_work_seconds_by_person': const <String, int>{},
          'meal_actor_id': plan.caregiverId,
          'infant_id': 'P00',
          'caregiver_id': plan.caregiverId,
          'birth_caregiver_role': plan.caregiverRole,
          'family_origin_summary': plan.familyOriginSummary,
          'birth_genesis_fingerprint': generated.fingerprint,
          if (plan.familyMembers.isNotEmpty) ...<String, Object?>{
            'birth_family_roles_by_person_id': <String, String>{
              plan.caregiverId: plan.caregiverRole,
              for (final GeneratedFamilyMember member in plan.familyMembers)
                member.id: member.roleToChild,
            },
            'family_care_scheduling': true,
            if (plan.familyMemoryEnabled) 'family_memory': true,
            if (plan.familyCareNegotiationEnabled)
              'family_care_negotiation': true,
            if (plan.familyCareSupportEnabled) 'family_care_support': true,
            if (plan.familyCareResilienceEnabled)
              'family_care_resilience': true,
            if (plan.familyCareBurdenEnabled) 'family_care_burden': true,
            if (plan.familyCareConflictEnabled) 'family_care_conflict': true,
            if (plan.familyCarePromiseEnabled) 'family_care_promise': true,
            if (plan.familyCareReliabilityEnabled)
              'family_care_reliability': true,
            if (plan.familyCareWitnessMemoryEnabled)
              'family_care_witness_memory': true,
            if (plan.infantAttachmentLearningEnabled)
              'infant_attachment_learning': true,
          },
        },
      );
      if (plan.familyCareNegotiationEnabled) {
        schedule(
          due: publishAt,
          phase: EventPhase.bookkeeping,
          kind: 'family_care_plan_review',
          payload: <String, Object?>{'household_id': plan.householdId},
        );
      }
    }
  }

  /// Vật chất hóa phần dân số còn lại của làng thành người, hộ và tài sản thật.
  void materializeSettlementPopulation(
    GeneratedSettlementPopulation generated, {
    required GeneratedWorldHistory history,
    SimTime? due,
  }) {
    if (generated.rootSeed != _state.seed) {
      throw StateError('Settlement population seed does not match simulation.');
    }
    final String? worldFingerprint =
        _state.worldGenesis?.fingerprint ??
        _state.pendingEvents
            .where(
              (ScheduledEvent event) => event.kind == 'world_genesis_completed',
            )
            .map(
              (ScheduledEvent event) => event.payload['fingerprint'] as String?,
            )
            .firstOrNull;
    if (worldFingerprint != generated.worldFingerprint) {
      throw StateError('Settlement population does not belong to this map.');
    }
    if (history.rootSeed != _state.seed ||
        history.worldFingerprint != generated.worldFingerprint ||
        history.fingerprint != generated.historyFingerprint) {
      throw StateError(
        'Settlement population does not belong to this history.',
      );
    }
    if (_state.pendingEvents.any(
          (ScheduledEvent event) =>
              event.payload['settlement_population_fingerprint'] != null,
        ) ||
        _state.households.keys.any((String id) => id.startsWith('VH'))) {
      throw StateError('Settlement population has already been materialized.');
    }
    final SimTime publishAt = due ?? _state.now;
    for (final GeneratedSettlementHousehold household in generated.households) {
      final WorldSite site = _generatedSiteFor(household.siteId);
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'room_created',
        payload: <String, Object?>{
          'room_id': household.roomId,
          'name': household.roomName,
          'household_id': household.id,
          'anchor_position_mm': site.center.xMm,
          'anchor_position_y_mm': site.center.yMm,
        },
      );
      for (
        int personIndex = 0;
        personIndex < household.people.length;
        personIndex++
      ) {
        final GeneratedSettlementPerson person = household.people[personIndex];
        final Map<String, String> relationships = <String, String>{};
        final Map<String, Object?> bonds = <String, Object?>{};
        for (
          int otherIndex = 0;
          otherIndex < household.people.length;
          otherIndex++
        ) {
          if (otherIndex == personIndex) continue;
          final GeneratedSettlementPerson other = household.people[otherIndex];
          final bool spouses =
              (personIndex == 0 && otherIndex == 1) ||
              (personIndex == 1 && otherIndex == 0);
          relationships[other.id] = spouses ? 'spouse' : 'relative';
          bonds[other.id] = <String, Object?>{
            'affection': spouses ? 650 : 520,
            'trust': spouses ? 620 : 540,
          };
        }
        schedule(
          due: publishAt,
          phase: EventPhase.completion,
          kind: 'person_created',
          payload: <String, Object?>{
            'person_id': person.id,
            'name': person.name,
            'birth_seconds': -person.ageYears * 365 * gameSecondsPerDay,
            'position_mm': site.center.xMm + personIndex * 1400,
            'position_y_mm': site.center.yMm + personIndex * 900,
            'room_id': household.roomId,
            'household_id': household.id,
            'caregiver_agent': true,
            'care_skill': person.careSkill,
            'current_activity': person.occupationName,
            'routine': person.routine,
            'skills': person.skills,
            'agenda': const <String, Object?>{},
            'adult_body': <String, Object?>{
              'mass_g': 45000 + (person.ageYears % 15) * 900,
            },
            'occupation_code': person.occupationCode,
            'occupation_name': person.occupationName,
            'origin_summary': person.originSummary,
            'family_relationships': relationships,
            'family_bonds': bonds,
          },
        );
      }
      final Map<String, (String, int, String)> resources =
          <String, (String, int, String)>{
            'food': ('staple_food', household.foodQuantity, 'g'),
            'water': ('clean_water', household.waterQuantity, 'ml'),
            'fuel': ('firewood', household.fuelQuantity, 'g'),
          };
      final Map<String, String> itemIds = <String, String>{};
      final Map<String, List<String>> rights = <String, List<String>>{};
      for (final MapEntry<String, (String, int, String)> resource
          in resources.entries) {
        final String itemId = 'I-${household.id}-${resource.key.toUpperCase()}';
        itemIds[resource.key] = itemId;
        rights[itemId] = household.people
            .map((GeneratedSettlementPerson value) => value.id)
            .toList();
        schedule(
          due: publishAt,
          phase: EventPhase.completion,
          kind: 'item_created',
          payload: <String, Object?>{
            'item_id': itemId,
            'kind': resource.value.$1,
            'position_mm': site.center.xMm,
            'position_y_mm': site.center.yMm,
            'room_id': household.roomId,
            'quantity': resource.value.$2,
            'unit': resource.value.$3,
            'owner_household_id': household.id,
          },
        );
      }
      final GeneratedSettlementPerson mealActor = household.people.firstWhere(
        (GeneratedSettlementPerson person) => person.occupationCode == 'cook',
        orElse: () => household.people.first,
      );
      schedule(
        due: publishAt,
        phase: EventPhase.completion,
        kind: 'household_created',
        payload: <String, Object?>{
          'household_id': household.id,
          'name': household.name,
          'member_ids': household.people
              .map((GeneratedSettlementPerson value) => value.id)
              .toList(),
          'resource_item_ids': itemIds,
          'authorized_users_by_item_id': rights,
          'scheduled_work_seconds_by_person': <String, int>{
            for (final GeneratedSettlementPerson person in household.people)
              person.id: 0,
          },
          'meal_actor_id': mealActor.id,
          'auto_plan': true,
          'enable_v2_6': true,
          'enable_v2_11': true,
          'enable_v2_13': true,
          'settlement_population_fingerprint': generated.fingerprint,
          'settlement_livelihood': household.livelihood,
        },
      );
    }
    if (generated.households.length >= 2) {
      schedule(
        due: publishAt.addSeconds(17 * 3600),
        phase: EventPhase.transfer,
        kind: 'community_exchange_cycle',
        payload: <String, Object?>{
          'population_fingerprint': generated.fingerprint,
        },
      );
    }
    schedule(
      due: publishAt.addSeconds(23 * 3600 + 50 * 60),
      phase: EventPhase.observation,
      kind: 'community_survival_audit',
      payload: <String, Object?>{
        'population_fingerprint': generated.fingerprint,
      },
    );
  }

  WorldSite _generatedSiteFor(String siteId) {
    final WorldSite? stateSite = _state.sites[siteId];
    if (stateSite != null) return stateSite;
    for (final ScheduledEvent event in _state.pendingEvents) {
      if (event.kind == 'site_created' && event.payload['id'] == siteId) {
        return WorldSite.fromJson(event.payload);
      }
    }
    throw StateError('Generated household references unknown site $siteId.');
  }

  /// Mở giai đoạn chọn nơi sinh sau khi bản đồ và đời sống nền đã tồn tại.
  void openWorldEntry({
    String playerPersonId = 'P00',
    String playerName = 'Vô Danh',
    SimTime? due,
  }) {
    if (_state.worldEntry != null ||
        _state.pendingEvents.any(
          (ScheduledEvent event) => event.kind == 'world_entry_opened',
        )) {
      throw StateError('World entry has already been opened.');
    }
    schedule(
      due: due ?? _state.now,
      phase: EventPhase.completion,
      kind: 'world_entry_opened',
      payload: <String, Object?>{
        'player_person_id': playerPersonId,
        'player_name': playerName,
      },
    );
  }

  /// Địa điểm được kiểm tra từ trạng thái thật, không lưu cờ khả dụng riêng.
  List<BirthSiteCandidate> birthSiteCandidates() => _birthSiteCandidates();

  /// Lớp quyết định phải dùng truy vấn này thay vì đọc WorldFact toàn tri.
  List<BeliefState> beliefsOf(String personId, {String? topic}) {
    final PersonState? person = _state.people[personId];
    if (person == null) return const <BeliefState>[];
    final List<BeliefState> beliefs =
        person.beliefs.values
            .where(
              (BeliefState belief) => topic == null || belief.topic == topic,
            )
            .toList()
          ..sort((BeliefState a, BeliefState b) {
            final int byLearned = b.learnedAtSeconds.compareTo(
              a.learnedAtSeconds,
            );
            return byLearned != 0 ? byLearned : a.id.compareTo(b.id);
          });
    return List<BeliefState>.unmodifiable(beliefs);
  }

  bool personKnowsClaim(String personId, String claimId) => beliefsOf(
    personId,
  ).any((BeliefState belief) => belief.claimId == claimId);

  List<BirthSiteCandidate> _birthSiteCandidates({
    Map<String, CareItemState>? items,
    Map<String, WorldSite>? sites,
  }) {
    final List<WorldSite> orderedSites = (sites ?? _state.sites).values.toList()
      ..sort((WorldSite a, WorldSite b) => a.id.compareTo(b.id));
    return <BirthSiteCandidate>[
      for (final WorldSite site in orderedSites)
        _evaluateBirthSite(site, items: items ?? _state.items),
    ];
  }

  BirthSiteCandidate _evaluateBirthSite(
    WorldSite site, {
    required Map<String, CareItemState> items,
  }) {
    final SettlementAssessmentState? settlement = site.settlementAssessment;
    if (settlement != null && !settlement.viable) {
      return BirthSiteCandidate(
        siteId: site.id,
        siteName: site.name,
        siteKind: site.kind,
        feasible: false,
        reason: 'Địa hình và nguồn lực chưa đủ để hình thành khu dân cư.',
        settlementScore: settlement.score,
        settlementReasons: settlement.reasons,
      );
    }
    final List<RoomState> rooms =
        _state.rooms.values
            .where(
              (RoomState room) =>
                  _state.households.containsKey(room.householdId) &&
                  site.contains(
                    WorldPoint(room.anchorPositionMm, room.anchorPositionYMm),
                  ),
            )
            .toList()
          ..sort((RoomState a, RoomState b) {
            final int byDistance = site.center
                .distanceTo(WorldPoint(a.anchorPositionMm, a.anchorPositionYMm))
                .compareTo(
                  site.center.distanceTo(
                    WorldPoint(b.anchorPositionMm, b.anchorPositionYMm),
                  ),
                );
            return byDistance != 0 ? byDistance : a.id.compareTo(b.id);
          });
    if (rooms.isEmpty) {
      return BirthSiteCandidate(
        siteId: site.id,
        siteName: site.name,
        siteKind: site.kind,
        feasible: false,
        reason: settlement?.selectedForBirthHousehold == false
            ? 'Nơi này có tiềm năng nhưng lịch sử chưa hình thành hộ sinh.'
            : 'Chưa có hộ với phòng ở thật tại địa điểm này.',
        settlementScore: settlement?.score,
        settlementReasons: settlement?.reasons ?? const <String>[],
      );
    }
    String lastReason = 'Chưa có điều kiện chăm trẻ.';
    for (final RoomState room in rooms) {
      final HouseholdState household = _state.households[room.householdId]!;
      final List<PersonState> caregivers =
          _state.people.values
              .where(
                (PersonState person) =>
                    person.householdId == household.id &&
                    person.caregiverAgent?.available == true &&
                    person.point != null &&
                    site.contains(person.point!),
              )
              .toList()
            ..sort((PersonState a, PersonState b) {
              final int bySkill = (b.caregiverAgent?.careSkill ?? 0).compareTo(
                a.caregiverAgent?.careSkill ?? 0,
              );
              return bySkill != 0 ? bySkill : a.id.compareTo(b.id);
            });
      if (caregivers.isEmpty) {
        lastReason = 'Hộ tại đây chưa có người chăm trẻ sẵn sàng.';
        continue;
      }
      final String? feedId = household.resourceItemIds['infant_feed'];
      final CareItemState? feed = feedId == null ? null : items[feedId];
      final PersonState? caregiver = caregivers
          .where(
            (PersonState person) =>
                feed != null &&
                feed.quantity > 0 &&
                household.canUse(person.id, feed.id),
          )
          .firstOrNull;
      if (caregiver == null) {
        lastReason = 'Hộ tại đây chưa có sữa và quyền chăm trẻ hợp lệ.';
        continue;
      }
      final CareItemState usableFeed = feed!;
      int quantityOf(String resourceKey) {
        final String? itemId = household.resourceItemIds[resourceKey];
        return itemId == null ? 0 : items[itemId]?.quantity ?? 0;
      }

      final int foodQuantity = quantityOf('food');
      final int waterQuantity = quantityOf('water');
      final int fuelQuantity = quantityOf('fuel');
      final List<String> risks = <String>[
        if (usableFeed.quantity < 5000) 'Dự trữ sữa mỏng',
        if (foodQuantity < 12000) 'Lương thực dự trữ thấp',
        if (waterQuantity < 20000) 'Nguồn nước dự trữ thấp',
        if (fuelQuantity < 3000) 'Thiếu nhiên liệu dự phòng',
        if ((caregiver.caregiverAgent?.careSkill ?? 0) < 600)
          'Người chăm ít kinh nghiệm',
      ];
      return BirthSiteCandidate(
        siteId: site.id,
        siteName: site.name,
        siteKind: site.kind,
        feasible: true,
        reason: 'Có phòng ở, người chăm và nguồn sữa thật.',
        householdId: household.id,
        householdName: household.name,
        roomId: room.id,
        caregiverId: caregiver.id,
        caregiverName: caregiver.name,
        caregiverSkill: caregiver.caregiverAgent?.careSkill,
        infantFeedQuantity: usableFeed.quantity,
        foodQuantity: foodQuantity,
        waterQuantity: waterQuantity,
        fuelQuantity: fuelQuantity,
        risks: List<String>.unmodifiable(risks),
        caregiverRole:
            household.birthFamilyRolesByPersonId[caregiver.id] ??
            household.birthCaregiverRole,
        familyOriginSummary: household.familyOriginSummary,
        familyMembers: List<BirthFamilyMemberSummary>.unmodifiable(
          <BirthFamilyMemberSummary>[
            for (final MapEntry<String, String> relation
                in household.birthFamilyRolesByPersonId.entries)
              if (_state.people[relation.key] case final PersonState member)
                BirthFamilyMemberSummary(
                  personId: member.id,
                  name: member.name,
                  roleToChild: relation.value,
                  careSkill: member.caregiverAgent?.careSkill ?? 0,
                  currentActivity:
                      member.routine?.currentActivity ??
                      member.caregiverAgent?.currentActivity,
                  canUseInfantFeed: household.canUse(member.id, usableFeed.id),
                ),
          ]..sort(
            (BirthFamilyMemberSummary a, BirthFamilyMemberSummary b) =>
                a.personId.compareTo(b.personId),
          ),
        ),
        settlementScore: settlement?.score,
        settlementReasons: settlement?.reasons ?? const <String>[],
      );
    }
    return BirthSiteCandidate(
      siteId: site.id,
      siteName: site.name,
      siteKind: site.kind,
      feasible: false,
      reason: lastReason,
      settlementScore: settlement?.score,
      settlementReasons: settlement?.reasons ?? const <String>[],
    );
  }

  bool issue(SimCommand command) {
    if (_state.acceptedCommandIds.contains(command.id)) return false;
    if (command case SetGoalCommand(:final personId, :final goal)) {
      final PersonState? person = _state.people[personId];
      if (person == null) throw StateError('Unknown person: ' + personId);
      if (person.infancy != null) {
        throw StateError(
          'Trẻ sơ sinh chưa thể hiểu mục tiêu tự do; hãy chọn một ý định phù hợp độ tuổi.',
        );
      }
      final Map<String, PersonState> people = <String, PersonState>{
        ..._state.people,
        personId: person.withGoal(goal),
      };
      final Set<String> commands = <String>{
        ..._state.acceptedCommandIds,
        command.id,
      };
      final List<WorldFact> facts = <WorldFact>[
        ..._state.facts,
        _fact('goal_assigned', personId, goal),
      ];
      _replace(people: people, acceptedCommandIds: commands, facts: facts);
      return true;
    }
    if (command case InfantIntentCommand(:final personId, :final intent)) {
      final PersonState? person = _state.people[personId];
      if (person == null) throw StateError('Unknown person: ' + personId);
      final InfantState? infancy = person.infancy;
      if (infancy == null) {
        throw StateError('Nhân vật này không còn ở giai đoạn sơ sinh.');
      }
      if (person.childhood != null) {
        throw StateError(
          'Trẻ đã qua tháng sơ sinh; hãy chọn hoạt động tuổi thơ.',
        );
      }
      final int ageDays =
          (_state.now.seconds - person.birthTime.seconds) ~/ gameSecondsPerDay;
      if (!InfantState.allowedIntents(ageDays).contains(intent)) {
        throw StateError('Ý định này chưa phù hợp ở ngày tuổi $ageDays.');
      }
      final InfantState next = infancy.afterIntent(intent);
      _replace(
        people: <String, PersonState>{
          ..._state.people,
          personId: person.withInfancy(next, goal: intent.label),
        },
        acceptedCommandIds: <String>{..._state.acceptedCommandIds, command.id},
        facts: <WorldFact>[
          ..._state.facts,
          _fact('infant_intent', personId, intent.code),
        ],
      );
      if (intent == InfantIntent.cryForCare) _startCryResponse(personId);
      return true;
    }
    if (command case ChildIntentCommand(:final personId, :final intent)) {
      final PersonState? person = _state.people[personId];
      if (person == null) throw StateError('Unknown person: $personId');
      final ChildhoodState? childhood = person.childhood;
      if (childhood == null) {
        throw StateError(
          'Nhân vật này chưa bước vào giai đoạn phát triển tuổi thơ.',
        );
      }
      if (!childhood.allowedIntents.contains(intent)) {
        throw StateError('Năng lực hiện tại chưa đủ cho hoạt động này.');
      }
      final String? obligation = _competingObligation(person);
      if (obligation != null) {
        throw StateError('Trẻ đang bận: $obligation.');
      }
      final String? roomId = person.roomId;
      final RoomState? room = roomId == null ? null : _state.rooms[roomId];
      if (room == null || room.householdId != person.householdId) {
        throw StateError('Trẻ chưa ở trong một không gian an toàn của hộ.');
      }
      CareItemState? activityItem;
      if (intent == ChildIntent.practiceReach ||
          intent == ChildIntent.observe) {
        final List<CareItemState> candidates =
            _state.items.values
                .where(
                  (CareItemState item) =>
                      item.usable &&
                      (item.roomId == roomId ||
                          (item.positionMm == person.positionMm &&
                              item.positionYMm == person.positionYMm)) &&
                      const <String>{
                        'swaddling_cloth',
                        'child_play_object',
                      }.contains(item.kind),
                )
                .toList()
              ..sort((CareItemState a, CareItemState b) {
                final int aPriority = a.kind == 'child_play_object' ? 0 : 1;
                final int bPriority = b.kind == 'child_play_object' ? 0 : 1;
                final int byKind = aPriority.compareTo(bPriority);
                return byKind != 0 ? byKind : a.id.compareTo(b.id);
              });
        activityItem = candidates.firstOrNull;
        if (activityItem == null) {
          throw StateError(
            'Không có vật mềm hoặc đồ chơi dùng được ở gần trẻ.',
          );
        }
      }
      PersonState? teacher;
      if (intent == ChildIntent.vocalize) {
        final List<PersonState> candidates =
            _state.people.values
                .where(
                  (PersonState value) =>
                      value.id != personId &&
                      value.roomId == roomId &&
                      _competingObligation(value) == null,
                )
                .toList()
              ..sort((PersonState a, PersonState b) {
                final int byPreference = _childCaregiverPreference(
                  person,
                  b,
                ).compareTo(_childCaregiverPreference(person, a));
                return byPreference != 0 ? byPreference : a.id.compareTo(b.id);
              });
        teacher = candidates.firstOrNull;
        if (teacher == null) {
          throw StateError('Không có người rảnh ở cùng phòng để đáp lời trẻ.');
        }
      }
      final String commitmentId = 'child-activity-${command.id}';
      final List<String> participants = <String>[
        personId,
        if (teacher != null) teacher.id,
      ];
      final bool begun = _beginPersonalCommitments(
        personIds: participants,
        commitmentId: commitmentId,
        kind: 'child_activity',
        activity: intent.label,
        endsAtSeconds: _state.now.seconds + intent.durationSeconds,
        relatedId: teacher?.id ?? activityItem?.id ?? roomId,
      );
      if (!begun) {
        throw StateError('Không thể dành thời gian cho hoạt động này.');
      }
      _replace(
        people: <String, PersonState>{
          ..._state.people,
          personId: _state.people[personId]!.withGoal(intent.label),
        },
        acceptedCommandIds: <String>{..._state.acceptedCommandIds, command.id},
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'child_activity_started',
            personId,
            'intent=${intent.code} duration_seconds=${intent.durationSeconds} '
                'room=$roomId item=${activityItem?.id ?? 'none'} '
                'teacher=${teacher?.id ?? 'none'} preference='
                '${teacher == null ? 0 : _childCaregiverPreference(person, teacher)}',
          ),
        ],
      );
      schedule(
        due: _state.now.addSeconds(intent.durationSeconds),
        phase: EventPhase.completion,
        kind: 'child_activity_completed',
        payload: <String, Object?>{
          'person_id': personId,
          'intent': intent.name,
          'commitment_id': commitmentId,
          'room_id': roomId,
          if (activityItem != null) 'item_id': activityItem.id,
          if (teacher != null) 'teacher_id': teacher.id,
        },
      );
      return true;
    }
    if (command case ChooseBirthSiteCommand(:final siteId)) {
      final WorldEntryState? entry = _state.worldEntry;
      if (entry == null || !entry.awaitingBirthSite) {
        throw StateError('Thế giới không chờ chọn nơi sinh.');
      }
      final BirthSiteCandidate? candidate = birthSiteCandidates()
          .where((BirthSiteCandidate value) => value.siteId == siteId)
          .firstOrNull;
      if (candidate == null) {
        throw StateError('Địa điểm sinh không tồn tại.');
      }
      if (!candidate.feasible) throw StateError(candidate.reason);
      _replace(
        acceptedCommandIds: <String>{..._state.acceptedCommandIds, command.id},
      );
      schedule(
        due: _state.now,
        phase: EventPhase.completion,
        kind: 'birth_site_selected',
        payload: <String, Object?>{'site_id': siteId},
      );
      return true;
    }
    return false;
  }

  void advanceTo(SimTime target) {
    if (target.compareTo(_state.now) < 0) {
      throw ArgumentError('Simulation time cannot move backwards.');
    }
    while (_state.pendingEvents.isNotEmpty &&
        _state.pendingEvents.first.due.compareTo(target) <= 0) {
      final ScheduledEvent event = _state.pendingEvents.first;
      _state = WorldState(
        seed: _state.seed,
        now: event.due,
        revision: _state.revision,
        nextSequence: _state.nextSequence,
        people: _state.people,
        pendingEvents: _state.pendingEvents.sublist(1),
        facts: _state.facts,
        acceptedCommandIds: _state.acceptedCommandIds,
        items: _state.items,
        households: _state.households,
        rooms: _state.rooms,
        illnesses: _state.illnesses,
        supplyJourneys: _state.supplyJourneys,
        communityExchanges: _state.communityExchanges,
        productionBatches: _state.productionBatches,
        serviceAppointments: _state.serviceAppointments,
        laborOffers: _state.laborOffers,
        laborClaims: _state.laborClaims,
        marketOffers: _state.marketOffers,
        marketOrders: _state.marketOrders,
        marketShipments: _state.marketShipments,
        supplyShocks: _state.supplyShocks,
        routes: _state.routes,
        regions: _state.regions,
        sites: _state.sites,
        worldGenesis: _state.worldGenesis,
        worldEntry: _state.worldEntry,
        worldHistory: _state.worldHistory,
        historicalLegacy: _state.historicalLegacy,
        communitySurvival: _state.communitySurvival,
      );
      _applyEvent(event);
    }
    if (_state.now.compareTo(target) < 0) _replace(now: target);
  }

  void _applyEvent(ScheduledEvent event) {
    switch (event.kind) {
      case 'world_history_started':
        _applyWorldHistoryStarted(event);
      case 'historical_epoch_simulated':
        _applyHistoricalEpochSimulated(event);
      case 'world_history_completed':
        _applyWorldHistoryCompleted(event);
      case 'world_entry_opened':
        _applyWorldEntryOpened(event);
      case 'birth_site_selected':
        _applyBirthSiteSelected(event);
      case 'birth':
        final String personId = event.payload['person_id']! as String;
        final String name = event.payload['name']! as String;
        if (_state.people.containsKey(personId)) return;
        final bool isInfant = event.payload['infant'] == true;
        final String caregiverId =
            event.payload['caregiver_id'] as String? ?? '';
        final String? householdId = event.payload['household_id'] as String?;
        final HouseholdState? household = householdId == null
            ? null
            : _state.households[householdId];
        final Map<String, HouseholdState> households = household == null
            ? _state.households
            : <String, HouseholdState>{
                ..._state.households,
                household.id: household.addMember(personId),
              };
        final WorldEntryState? worldEntry =
            _state.worldEntry?.playerPersonId == personId
            ? _state.worldEntry!.markBorn()
            : _state.worldEntry;
        final String? caregiverRole =
            event.payload['caregiver_role'] as String?;
        final Map<String, String> familyRoles =
            household?.birthFamilyRolesByPersonId.isNotEmpty == true
            ? household!.birthFamilyRolesByPersonId
            : caregiverRole == null || caregiverId.isEmpty
            ? const <String, String>{}
            : <String, String>{caregiverId: caregiverRole};
        final Map<String, PersonState> people = <String, PersonState>{
          ..._state.people,
        };
        for (final MapEntry<String, String> relation in familyRoles.entries) {
          final PersonState? adult = people[relation.key];
          if (adult == null) continue;
          PersonState nextAdult = adult.withFamilyRelationship(
            personId,
            relation.value == 'guardian' ? 'ward' : 'child',
          );
          if (household?.familyMemory == true) {
            nextAdult = nextAdult.withFamilyBond(
              personId,
              FamilyBondState(
                affection: 620,
                trust: 600,
                careObligation: relation.value == 'guardian' ? 760 : 860,
              ),
            );
          }
          people[adult.id] = nextAdult;
        }
        _replace(
          people: <String, PersonState>{
            ...people,
            personId: PersonState(
              id: personId,
              name: name,
              birthTime: event.due,
              infancy: isInfant ? InfantState.initial(caregiverId) : null,
              positionMm: event.payload['position_mm'] as int?,
              positionYMm: event.payload['position_y_mm'] as int? ?? 0,
              householdId: householdId,
              roomId: event.payload['room_id'] as String?,
              familyRelationships: familyRoles,
              familyBonds: household?.familyMemory == true
                  ? <String, FamilyBondState>{
                      for (final String adultId in familyRoles.keys)
                        adultId: const FamilyBondState(
                          affection: 600,
                          trust: 650,
                        ),
                    }
                  : const <String, FamilyBondState>{},
            ),
          },
          facts: <WorldFact>[
            ..._state.facts,
            _fact('birth', personId, name + ' was born'),
          ],
          households: households,
          worldEntry: worldEntry,
        );
        if (isInfant) {
          schedule(
            due: event.due.addDays(1),
            phase: EventPhase.intent,
            kind: 'infant_daily_tick',
            payload: <String, Object?>{'person_id': personId},
          );
          schedule(
            due: event.due.addSeconds(3600),
            phase: EventPhase.bookkeeping,
            kind: 'infant_physiology_tick',
            payload: <String, Object?>{
              'person_id': personId,
              'ambient_temperature_millic':
                  event.payload['ambient_temperature_millic'] as int? ?? 24000,
            },
          );
        }
      case 'person_created':
        final String personId = event.payload['person_id']! as String;
        if (_state.people.containsKey(personId)) return;
        final String name = event.payload['name']! as String;
        final int birthSeconds = event.payload['birth_seconds']! as int;
        _replace(
          people: <String, PersonState>{
            ..._state.people,
            personId: PersonState(
              id: personId,
              name: name,
              birthTime: SimTime(birthSeconds),
              positionMm: event.payload['position_mm'] as int?,
              positionYMm: event.payload['position_y_mm'] as int? ?? 0,
              caregiverAgent: event.payload['caregiver_agent'] == true
                  ? CaregiverAgentState(
                      hearingThreshold:
                          event.payload['hearing_threshold'] as int? ?? 300,
                      movementSpeedMmPerSecond:
                          event.payload['movement_speed_mm_per_second']
                              as int? ??
                          1000,
                      currentActivity:
                          event.payload['current_activity'] as String? ??
                          'idle',
                      available:
                          event.payload['caregiver_available'] as bool? ?? true,
                      careSkill: event.payload['care_skill'] as int? ?? 700,
                    )
                  : null,
              householdId: event.payload['household_id'] as String?,
              roomId: event.payload['room_id'] as String?,
              routine: _routineFromPayload(event.payload['routine']),
              skills: event.payload['skills'] == null
                  ? null
                  : PersonSkills.fromJson(
                      (event.payload['skills']! as Map).cast<String, Object?>(),
                    ),
              agenda: event.payload['agenda'] == null
                  ? null
                  : PersonAgenda.fromJson(
                      (event.payload['agenda']! as Map).cast<String, Object?>(),
                    ),
              body: event.payload['adult_body'] == null
                  ? null
                  : _adultBodyFromPayload(
                      (event.payload['adult_body']! as Map)
                          .cast<String, Object?>(),
                    ),
              occupationCode: event.payload['occupation_code'] as String?,
              occupationName: event.payload['occupation_name'] as String?,
              originSummary: event.payload['origin_summary'] as String?,
              familyRelationships:
                  (event.payload['family_relationships'] as Map?)
                      ?.cast<String, String>() ??
                  const <String, String>{},
              familyBonds: <String, FamilyBondState>{
                for (final MapEntry<String, Object?> entry
                    in ((event.payload['family_bonds'] as Map?)
                                ?.cast<String, Object?>() ??
                            const <String, Object?>{})
                        .entries)
                  entry.key: FamilyBondState.fromJson(
                    (entry.value! as Map).cast<String, Object?>(),
                  ),
              },
            ),
          },
          facts: <WorldFact>[
            ..._state.facts,
            _fact('person_created', personId, name),
          ],
        );
        _scheduleRoutineStarts(personId);
      case 'infant_daily_tick':
        _applyInfantDailyTick(event);
      case 'infant_physiology_tick':
        _applyInfantPhysiologyTick(event);
      case 'childhood_started':
        _applyChildhoodStarted(event);
      case 'childhood_daily_tick':
        _applyChildhoodDailyTick(event);
      case 'child_activity_completed':
        _applyChildActivityCompleted(event);
      case 'child_hazard_response_completed':
        _applyChildHazardResponseCompleted(event);
      case 'item_created':
        _applyItemCreated(event);
      case 'household_created':
        _applyHouseholdCreated(event);
      case 'community_exchange_cycle':
        _applyCommunityExchangeCycle(event);
      case 'community_exchange_arrived':
        _applyCommunityExchangeArrived(event);
      case 'knowledge_shared':
        _applyKnowledgeShared(event);
      case 'community_survival_audit':
        _applyCommunitySurvivalAudit(event);
      case 'community_resource_response':
        _applyCommunityResourceResponse(event);
      case 'community_resource_inquiry_answered':
        _applyCommunityResourceInquiryAnswered(event);
      case 'community_resource_introduction_arrived':
        _applyCommunityResourceIntroductionArrived(event);
      case 'family_care_plan_review':
        _applyFamilyCarePlanReview(event);
      case 'family_care_support_retry':
        _applyFamilyCareSupportRetry(event);
      case 'family_care_conflict_conversation':
        _applyFamilyCareConflictConversation(event);
      case 'household_meal':
        _applyHouseholdMeal(event);
      case 'household_work_settlement':
        _applyHouseholdWorkSettlement(event);
      case 'room_created':
        _applyRoomCreated(event);
      case 'route_created':
        _applyRouteCreated(event);
      case 'region_created':
        _applyRegionCreated(event);
      case 'site_created':
        _applySiteCreated(event);
      case 'settlement_assessed':
        _applySettlementAssessed(event);
      case 'world_genesis_completed':
        _applyWorldGenesisCompleted(event);
      case 'natural_resource_extracted':
        _applyNaturalResourceExtracted(event);
      case 'production_batch_completed':
        this._applyProductionBatchCompleted(event);
      case 'service_appointment_started':
        this._applyServiceAppointmentStarted(event);
      case 'service_appointment_completed':
        this._applyServiceAppointmentCompleted(event);
      case 'labor_work_started':
        this._applyLaborWorkStarted(event);
      case 'labor_work_completed':
        this._applyLaborWorkCompleted(event);
      case 'market_shipment_arrived':
        this._applyMarketShipmentArrived(event);
      case 'supply_shock_audit':
        this._applySupplyShockAudit(event);
      case 'natural_resource_yearly_renewal':
        _applyNaturalResourceYearlyRenewal(event);
      case 'ecology_yearly_tick':
        _applyEcologyYearlyTick(event);
      case 'route_leg_arrived':
        _applyRouteLegArrived(event);
      case 'infant_illness_onset':
        _applyInfantIllnessOnset(event);
      case 'adult_illness_observed':
        _applyAdultIllnessObserved(event);
      case 'adult_illness_care':
        _applyAdultIllnessCare(event);
      case 'illness_observed':
        _applyIllnessObserved(event);
      case 'illness_caregiver_arrives':
        _applyIllnessCaregiverArrives(event);
      case 'illness_care':
        _applyIllnessCare(event);
      case 'illness_progress':
        _applyIllnessProgress(event);
      case 'household_supply_delivery':
        _applyHouseholdSupplyDelivery(event);
      case 'household_production':
        _applyHouseholdProduction(event);
      case 'caregiver_availability_changed':
        _applyCaregiverAvailabilityChanged(event);
      case 'supply_journey_started':
        _applySupplyJourneyStarted(event);
      case 'supply_journey_checkpoint':
        _applySupplyJourneyCheckpoint(event);
      case 'supply_journey_arrived':
        _applySupplyJourneyArrived(event);
      case 'cry_signal_arrives':
        _applyCrySignalArrives(event);
      case 'caregiver_arrives':
        _applyCaregiverArrives(event);
      case 'caregiver_uses_supplies':
        _applyCaregiverUsesSupplies(event);
      case 'household_planning':
        _applyHouseholdPlanning(event);
      case 'routine_block_started':
        _applyRoutineBlockStarted(event);
      case 'routine_block_ended':
        _applyRoutineBlockEnded(event);
      default:
        _replace(
          facts: <WorldFact>[
            ..._state.facts,
            _fact(event.kind, event.id, jsonEncode(event.payload)),
          ],
        );
    }
  }

  void _applyChildhoodStarted(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final PersonState? person = _state.people[personId];
    final InfantState? infancy = person?.infancy;
    if (person == null || infancy == null || person.childhood != null) return;
    final int ageDays =
        (_state.now.seconds - person.birthTime.seconds) ~/ gameSecondsPerDay;
    final InfantBodyState? infantBody = infancy.body;
    final ChildhoodState childhood = ChildhoodState.afterNewborn(
      nowSeconds: _state.now.seconds,
      ageDays: ageDays,
      attachment: infancy.attachment,
      caregiverSafety: infancy.careExpectations.values.map(
        (InfantCareExpectationState value) => value.safety,
      ),
      body: infantBody == null
          ? const ChildBodyState.fallback()
          : ChildBodyState(
              massGrams: infantBody.massGrams,
              expectedMassGrams: infantBody.massGrams,
              nutrition: (1000 - infantBody.hunger).clamp(0, 1000),
              hydration: (1000 - infantBody.thirst).clamp(0, 1000),
              totalFoodGrams: 0,
              totalWaterMl: 0,
              supportedGrowthDays: 0,
              constrainedGrowthDays: 0,
              lastFoodGrams: 0,
              lastWaterMl: 0,
              lastGrowthGrams: 0,
            ),
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: person.withChildhood(
          childhood,
          goal: 'Quan sát thế giới sau tháng sơ sinh',
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'childhood_started',
          personId,
          'age_days=$ageDays security=${childhood.security} '
              'mass_g=${childhood.body.massGrams} '
              'nutrition=${childhood.body.nutrition} '
              'hydration=${childhood.body.hydration}',
        ),
      ],
    );
    schedule(
      due: event.due.addDays(1),
      phase: EventPhase.bookkeeping,
      kind: 'childhood_daily_tick',
      payload: <String, Object?>{'person_id': personId},
    );
  }

  void _applyChildhoodDailyTick(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final PersonState? person = _state.people[personId];
    final ChildhoodState? childhood = person?.childhood;
    if (person == null || childhood == null) return;
    final int ageDays =
        (_state.now.seconds - person.birthTime.seconds) ~/ gameSecondsPerDay;
    final ChildDevelopmentStage previousStage = childhood.stage;
    final HouseholdState? household = person.householdId == null
        ? null
        : _state.households[person.householdId];
    final String? foodId = household?.resourceItemIds['food'];
    final String? waterId = household?.resourceItemIds['water'];
    final CareItemState? food = foodId == null ? null : _state.items[foodId];
    final CareItemState? water = waterId == null ? null : _state.items[waterId];
    final int foodNeed = ChildBodyState.foodNeedGrams(ageDays);
    final int waterNeed = ChildBodyState.waterNeedMl(ageDays);
    final int foodTaken = food == null ? 0 : food.quantity.clamp(0, foodNeed);
    final int waterTaken = water == null
        ? 0
        : water.quantity.clamp(0, waterNeed);
    final Map<String, CareItemState> nextItems = <String, CareItemState>{
      ..._state.items,
      if (food != null && foodTaken > 0) food.id: food.consume(foodTaken),
      if (water != null && waterTaken > 0) water.id: water.consume(waterTaken),
    };
    final ChildhoodState nourished = childhood.withDailyNutrition(
      ageDays: ageDays,
      foodGrams: foodTaken,
      waterMl: waterTaken,
    );
    final ChildhoodState next = nourished
        .advanceToAgeDay(
          ageDays,
          bodyConditionPerMille: nourished.body.developmentSupport,
        )
        .compressMemories(nowSeconds: _state.now.seconds);
    final List<WorldFact> addedFacts = <WorldFact>[
      _fact(
        'child_daily_nutrition',
        personId,
        'food_g=$foodTaken food_need_g=$foodNeed '
            'water_ml=$waterTaken water_need_ml=$waterNeed '
            'mass_g=${next.body.massGrams} '
            'growth_g=${next.body.lastGrowthGrams} '
            'nutrition=${next.body.nutrition} '
            'hydration=${next.body.hydration} '
            'development_support=${next.body.developmentSupport}',
      ),
    ];
    if (next.stage != previousStage) {
      addedFacts.add(
        _fact(
          'child_development_stage_changed',
          personId,
          '${previousStage.code}->${next.stage.code}',
        ),
      );
    }
    if (next.compressedMemoryCount > childhood.compressedMemoryCount) {
      addedFacts.add(
        _fact(
          'child_memories_compressed',
          personId,
          'compressed=${next.compressedMemoryCount - childhood.compressedMemoryCount} '
              'recent=${next.recentMemories.length} '
              'anchors=${next.memoryAnchors.length} '
              'summaries=${next.memorySummaries.length}',
        ),
      );
    }
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: person.withChildhood(next),
      },
      items: nextItems,
      facts: <WorldFact>[..._state.facts, ...addedFacts],
    );
    if (ageDays < 2190) {
      schedule(
        due: event.due.addDays(1),
        phase: EventPhase.bookkeeping,
        kind: 'childhood_daily_tick',
        payload: <String, Object?>{'person_id': personId},
      );
    }
  }

  void _applyChildActivityCompleted(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String commitmentId = event.payload['commitment_id']! as String;
    final PersonState? beforeRelease = _state.people[personId];
    final PersonalTimeCommitment? commitment = beforeRelease?.timeCommitment;
    if (beforeRelease?.childhood == null ||
        commitment == null ||
        commitment.id != commitmentId) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'child_activity_cancelled',
            personId,
            'commitment=$commitmentId reason=time_commitment_missing',
          ),
        ],
      );
      return;
    }
    final ChildIntent intent = ChildIntent.values.byName(
      event.payload['intent']! as String,
    );
    final String? teacherId = event.payload['teacher_id'] as String?;
    final PersonState? teacherBeforeRelease = teacherId == null
        ? null
        : _state.people[teacherId];
    final bool teacherStayed =
        teacherId == null ||
        (teacherBeforeRelease?.roomId == event.payload['room_id'] &&
            teacherBeforeRelease?.timeCommitment?.id == commitmentId);
    _endPersonalCommitments(<String>[
      personId,
      if (teacherId != null) teacherId,
    ], commitmentId);
    final PersonState person = _state.people[personId]!;
    final ChildhoodState childhood = person.childhood!;
    final String roomId = event.payload['room_id']! as String;
    final String? itemId = event.payload['item_id'] as String?;
    final RoomState? room = _state.rooms[roomId];
    final CareItemState? item = itemId == null ? null : _state.items[itemId];
    final bool stayedInRoom =
        person.roomId == roomId &&
        room != null &&
        room.householdId == person.householdId;
    if (intent == ChildIntent.observe || intent == ChildIntent.vocalize) {
      final bool itemAvailable =
          item != null &&
          item.usable &&
          (item.roomId == roomId ||
              (item.positionMm == person.positionMm &&
                  item.positionYMm == person.positionYMm));
      final PersonState? teacher = teacherId == null
          ? null
          : _state.people[teacherId];
      final int score;
      final int threshold;
      final String sourceId;
      final String conceptId;
      final String summary;
      final String reason;
      if (intent == ChildIntent.observe) {
        score = _childBodyAdjustedScore(
          childhood.fineMotor +
              childhood.receptiveLanguage * 2 +
              ((item?.condition ?? 0) ~/ 4) +
              childhood.observationExperience * 10,
          childhood,
        );
        threshold = 400;
        sourceId = itemId ?? 'missing-object';
        conceptId = item == null
            ? 'object:missing'
            : 'object_kind:${item.id}:${item.kind}';
        summary = item == null
            ? 'Không xác định được vật đã quan sát.'
            : '${item.id} là ${item.kind}.';
        reason = !stayedInRoom
            ? 'left_room'
            : !itemAvailable
            ? 'object_unavailable'
            : score >= threshold
            ? 'recognized_object'
            : 'attention_broke';
      } else {
        score = _childBodyAdjustedScore(
          childhood.expressiveLanguage * 2 +
              childhood.receptiveLanguage +
              (childhood.security ~/ 2) +
              ((teacher?.caregiverAgent?.careSkill ?? 0) ~/ 2),
          childhood,
        );
        threshold = 500;
        sourceId = teacherId ?? 'missing-teacher';
        conceptId = teacher == null
            ? 'person:missing'
            : 'person_name:${teacher.id}:${teacher.name}';
        summary = teacher == null
            ? 'Không có người đáp lời.'
            : '${teacher.id} được gọi là ${teacher.name}.';
        reason = !stayedInRoom
            ? 'left_room'
            : !teacherStayed || teacher == null
            ? 'teacher_unavailable'
            : score >= threshold
            ? 'matched_voice'
            : 'sound_not_stable';
      }
      final bool succeeded =
          stayedInRoom &&
          (intent == ChildIntent.observe
              ? itemAvailable
              : teacherStayed && teacher != null) &&
          score >= threshold;
      final ChildhoodState next = childhood.completeLearningActivity(
        intent: intent,
        succeeded: succeeded,
        nowSeconds: _state.now.seconds,
        roomId: roomId,
        sourceId: sourceId,
        conceptId: conceptId,
        itemId: itemId,
      );
      PersonState learned = person.withChildhood(next);
      if (succeeded) {
        final String evidenceId =
            'child-learning-$personId-${intent.code}-$sourceId';
        learned = learned.learn(
          BeliefState(
            id: evidenceId,
            claimId: conceptId,
            topic: intent == ChildIntent.observe
                ? 'object_recognition'
                : 'person_name',
            subjectId: intent == ChildIntent.observe ? sourceId : teacherId!,
            summary: summary,
            eventAtSeconds: _state.now.seconds,
            learnedAtSeconds: _state.now.seconds,
            acquisition: intent == ChildIntent.observe
                ? KnowledgeAcquisition.observation
                : KnowledgeAcquisition.testimony,
            sourcePersonId: teacherId ?? personId,
            originPersonId: teacherId ?? personId,
            originEvidenceId: evidenceId,
            confidence: score.clamp(100, 1000),
            sourceObjectId: itemId,
            learningActivity: intent.code,
          ),
        );
      }
      _replace(
        people: <String, PersonState>{..._state.people, personId: learned},
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            succeeded ? 'child_learning_succeeded' : 'child_learning_failed',
            personId,
            'intent=${intent.code} score=$score threshold=$threshold '
            'reason=$reason source=$sourceId concept=$conceptId '
            'room=$roomId duration_seconds=${intent.durationSeconds}',
          ),
        ],
      );
      return;
    }
    bool activityItemAvailable = true;
    int score;
    int threshold;
    String reason;
    if (intent == ChildIntent.practiceReach) {
      activityItemAvailable =
          item != null &&
          item.usable &&
          (item.roomId == roomId ||
              (item.positionMm == person.positionMm &&
                  item.positionYMm == person.positionYMm));
      score = _childBodyAdjustedScore(
        childhood.fineMotor * 2 +
            childhood.grossMotor +
            ((item?.condition ?? 0) ~/ 4),
        childhood,
      );
      threshold = 300;
      reason = !stayedInRoom
          ? 'left_room'
          : !activityItemAvailable
          ? 'item_unavailable'
          : score >= threshold
          ? 'controlled_grasp'
          : 'lost_grip';
    } else {
      score = _childBodyAdjustedScore(
        childhood.grossMotor * 2 +
            (childhood.security ~/ 2) +
            childhood.playExperience * 10,
        childhood,
      );
      threshold = 360;
      reason = !stayedInRoom
          ? 'left_room'
          : score >= threshold
          ? 'balanced_play'
          : 'stopped_after_losing_balance';
    }
    final bool succeeded =
        stayedInRoom && activityItemAvailable && score >= threshold;
    final ChildhoodState next = childhood.completePhysicalActivity(
      intent: intent,
      succeeded: succeeded,
      nowSeconds: _state.now.seconds,
      roomId: roomId,
      itemId: itemId,
    );
    final Map<String, CareItemState> items = <String, CareItemState>{
      ..._state.items,
      if (item != null && stayedInRoom && activityItemAvailable)
        item.id: item.wear(succeeded ? 1 : 2),
    };
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: person.withChildhood(next),
      },
      items: items,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          succeeded ? 'child_activity_succeeded' : 'child_activity_failed',
          personId,
          'intent=${intent.code} score=$score threshold=$threshold '
          'reason=$reason room=$roomId item=${itemId ?? 'none'} '
          'duration_seconds=${intent.durationSeconds}',
        ),
      ],
    );
    if (intent == ChildIntent.floorPlay && !succeeded) {
      _startChildHazardIncident(personId);
    }
  }

  void _startChildHazardIncident(String personId) {
    final PersonState? child = _state.people[personId];
    final ChildhoodState? childhood = child?.childhood;
    if (child == null || childhood == null || child.point == null) return;
    final int awarenessScore = _childBodyAdjustedScore(
      childhood.receptiveLanguage +
          childhood.fineMotor +
          childhood.observationExperience * 15,
      childhood,
    );
    final bool noticed = awarenessScore >= 180;
    final int severity = noticed ? 80 : 220;
    final String reaction = noticed
        ? 'stopped_and_reached_for_caregiver'
        : 'fell_and_cried';
    final List<PersonState> caregivers =
        child.familyRelationships.keys
            .map((String id) => _state.people[id])
            .whereType<PersonState>()
            .where(
              (PersonState person) =>
                  person.caregiverAgent != null &&
                  person.point != null &&
                  _competingObligation(person) == null,
            )
            .toList()
          ..sort((PersonState a, PersonState b) {
            final int byPreference = _childCaregiverPreference(
              child,
              b,
            ).compareTo(_childCaregiverPreference(child, a));
            return byPreference != 0 ? byPreference : a.id.compareTo(b.id);
          });
    final PersonState? caregiver = caregivers.firstOrNull;
    final String incidentId =
        'child-hazard-$personId-${_state.now.seconds}-${childhood.hazardIncidents + 1}';
    final ChildHazardIncidentState incident = ChildHazardIncidentState(
      id: incidentId,
      kind: 'floor_balance_loss',
      detectedAtSeconds: _state.now.seconds,
      noticedBeforeHarm: noticed,
      childReaction: reaction,
      severity: severity,
      outcome: 'pending',
      caregiverId: caregiver?.id,
    );
    if (caregiver == null) {
      final int securityChange = noticed ? -30 : -110;
      final ChildhoodState next = childhood
          .startHazard(incident)
          .resolveHazard(
            incidentId: incidentId,
            outcome: 'unattended',
            atSeconds: _state.now.seconds,
            securityChange: securityChange,
          );
      _replace(
        people: <String, PersonState>{
          ..._state.people,
          personId: child.withChildhood(next),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'child_hazard_unattended',
            personId,
            'incident=$incidentId noticed=$noticed reaction=$reaction '
                'severity=$severity security_change=$securityChange',
          ),
        ],
      );
      return;
    }
    final int speed = caregiver.caregiverAgent!.movementSpeedMmPerSecond.clamp(
      1,
      0x7fffffff,
    );
    final int travelSeconds =
        (caregiver.point!.distanceTo(child.point!) ~/ speed).clamp(1, 300);
    const int soothingSeconds = 300;
    final int responseSeconds = travelSeconds + soothingSeconds;
    final String commitmentId = 'hazard-response-$incidentId';
    final bool begun = _beginPersonalCommitments(
      personIds: <String>[personId, caregiver.id],
      commitmentId: commitmentId,
      kind: 'child_hazard_response',
      activity: 'Tìm người an toàn và trấn an sau khi mất thăng bằng',
      endsAtSeconds: _state.now.seconds + responseSeconds,
      relatedId: incidentId,
    );
    if (!begun) {
      final int securityChange = noticed ? -30 : -110;
      final ChildhoodState next = childhood
          .startHazard(incident)
          .resolveHazard(
            incidentId: incidentId,
            outcome: 'unattended',
            atSeconds: _state.now.seconds,
            securityChange: securityChange,
          );
      _replace(
        people: <String, PersonState>{
          ..._state.people,
          personId: child.withChildhood(next),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'child_hazard_unattended',
            personId,
            'incident=$incidentId caregiver=${caregiver.id} '
                'reason=commitment_failed severity=$severity '
                'security_change=$securityChange',
          ),
        ],
      );
      return;
    }
    final PersonState committedChild = _state.people[personId]!;
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: committedChild.withChildhood(childhood.startHazard(incident)),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'child_hazard_detected',
          personId,
          'incident=$incidentId noticed=$noticed reaction=$reaction '
              'severity=$severity caregiver=${caregiver.id} preference='
              '${_childCaregiverPreference(child, caregiver)} '
              'response_seconds=$responseSeconds',
        ),
      ],
    );
    schedule(
      due: _state.now.addSeconds(responseSeconds),
      phase: EventPhase.completion,
      kind: 'child_hazard_response_completed',
      payload: <String, Object?>{
        'person_id': personId,
        'caregiver_id': caregiver.id,
        'incident_id': incidentId,
        'commitment_id': commitmentId,
        'soothing_seconds': soothingSeconds,
      },
    );
  }

  void _applyChildHazardResponseCompleted(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String caregiverId = event.payload['caregiver_id']! as String;
    final String incidentId = event.payload['incident_id']! as String;
    final String commitmentId = event.payload['commitment_id']! as String;
    final PersonState? childBefore = _state.people[personId];
    final PersonState? caregiverBefore = _state.people[caregiverId];
    final ChildHazardIncidentState? incident =
        childBefore?.childhood?.lastHazard;
    if (childBefore == null ||
        caregiverBefore == null ||
        incident == null ||
        incident.id != incidentId ||
        !incident.pending) {
      return;
    }
    final bool responded =
        childBefore.timeCommitment?.id == commitmentId &&
        caregiverBefore.timeCommitment?.id == commitmentId;
    _endPersonalCommitments(<String>[personId, caregiverId], commitmentId);
    final PersonState child = _state.people[personId]!;
    final PersonState caregiver = _state.people[caregiverId]!;
    final int securityChange = responded
        ? (incident.noticedBeforeHarm ? 12 : -20)
        : (incident.noticedBeforeHarm ? -30 : -110);
    final String outcome = responded ? 'soothed' : 'unattended';
    PersonState nextChild = child.withChildhood(
      child.childhood!.resolveHazard(
        incidentId: incidentId,
        outcome: outcome,
        atSeconds: _state.now.seconds,
        securityChange: securityChange,
      ),
    );
    PersonState nextCaregiver = caregiver;
    if (responded) {
      final int duration = event.payload['soothing_seconds']! as int;
      nextChild = nextChild.withFamilyBond(
        caregiverId,
        (nextChild.familyBonds[caregiverId] ?? const FamilyBondState())
            .recordCareReceived(
              atSeconds: _state.now.seconds,
              durationSeconds: duration,
              substituted: caregiverId != child.infancy?.caregiverId,
            ),
      );
      nextCaregiver = nextCaregiver.withFamilyBond(
        personId,
        (nextCaregiver.familyBonds[personId] ?? const FamilyBondState())
            .recordCareGiven(
              atSeconds: _state.now.seconds,
              durationSeconds: duration,
              substituted: caregiverId != child.infancy?.caregiverId,
            ),
      );
      if (child.point != null && child.roomId != null) {
        nextCaregiver = nextCaregiver.withLocation(
          positionMm: child.positionMm!,
          positionYMm: child.positionYMm,
          roomId: child.roomId!,
        );
      }
    }
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: nextChild,
        caregiverId: nextCaregiver,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          responded ? 'child_hazard_soothed' : 'child_hazard_unattended',
          personId,
          'incident=$incidentId caregiver=$caregiverId outcome=$outcome '
          'security_change=$securityChange severity=${incident.severity}',
        ),
      ],
    );
  }

  void _applyInfantDailyTick(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final PersonState? person = _state.people[personId];
    final InfantState? infancy = person?.infancy;
    if (person == null || infancy == null) return;
    final int ageDays =
        (_state.now.seconds - person.birthTime.seconds) ~/ gameSecondsPerDay;
    final bool caregiverAvailable = _state.people.containsKey(
      infancy.caregiverId,
    );
    final InfantState next = infancy.passDay(
      ageDays,
      caregiverAvailable: caregiverAvailable,
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: person.withInfancy(next),
      },
      facts: next.crying
          ? <WorldFact>[
              ..._state.facts,
              _fact('infant_cry', personId, 'distress=${next.needs.distress}'),
            ]
          : null,
    );
    if (next.crying) {
      _startCryResponse(personId);
    }
    if (ageDays < 30) {
      schedule(
        due: event.due.addDays(1),
        phase: EventPhase.intent,
        kind: 'infant_daily_tick',
        payload: <String, Object?>{'person_id': personId},
      );
    }
  }

  void _applyInfantPhysiologyTick(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final PersonState? person = _state.people[personId];
    final InfantState? infancy = person?.infancy;
    if (person == null || infancy == null) return;
    final IllnessState? activeIllness = _state.illnesses.values
        .where(
          (IllnessState value) => value.personId == personId && value.active,
        )
        .firstOrNull;
    final InfantPhysiologyStep step = infancy.advancePhysiologyHour(
      event.payload['ambient_temperature_millic']! as int,
      illnessSeverity: activeIllness?.physiologyCoupled == true
          ? activeIllness!.severity
          : 0,
      illnessFeverTargetMilliC: activeIllness?.physiologyCoupled == true
          ? activeIllness!.bodyTemperatureMilliC
          : 37000,
    );
    String? factKind;
    String? factDetail;
    if (!infancy.crying && step.state.crying) {
      factKind = 'infant_cry';
      factDetail = 'distress=${step.state.needs.distress}';
    } else if (step.fellAsleep) {
      factKind = 'infant_fell_asleep';
      factDetail = 'sleep_pressure=${step.state.needs.sleepPressure}';
    } else if (step.wokeUp) {
      factKind = 'infant_woke_up';
      factDetail = 'sleep_pressure=${step.state.needs.sleepPressure}';
    } else if (step.urineMl > 0 || step.stoolGrams > 0) {
      factKind = 'infant_elimination';
      factDetail = 'urine_ml=${step.urineMl} stool_g=${step.stoolGrams}';
    }
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: person.withInfancy(step.state),
      },
      facts: factKind == null
          ? null
          : <WorldFact>[
              ..._state.facts,
              _fact(factKind, personId, factDetail!),
            ],
    );
    if (step.state.crying) _startCryResponse(personId);
    final int ageSeconds = _state.now.seconds - person.birthTime.seconds;
    if (ageSeconds < 30 * gameSecondsPerDay) {
      schedule(
        due: event.due.addSeconds(3600),
        phase: EventPhase.bookkeeping,
        kind: 'infant_physiology_tick',
        payload: event.payload,
      );
    }
  }

  static const int _routineDeferSeconds = 15 * 60;
  static const int _routineMaxDeferrals = 3;

  RoutineState? _routineFromPayload(Object? payload) {
    if (payload is! List) return null;
    return RoutineState(
      blocks: <RoutineBlock>[
        for (final Object? raw in payload)
          RoutineBlock.fromJson((raw! as Map).cast<String, Object?>()),
      ],
    );
  }

  void _scheduleRoutineStarts(String personId) {
    final RoutineState? routine = _state.people[personId]?.routine;
    if (routine == null) return;
    final int today =
        (_state.now.seconds ~/ gameSecondsPerDay) * gameSecondsPerDay;
    for (final RoutineBlock block in routine.blocks) {
      int due = today + block.startSecondOfDay;
      if (due < _state.now.seconds) due += gameSecondsPerDay;
      schedule(
        due: SimTime(due),
        phase: EventPhase.intent,
        kind: 'routine_block_started',
        payload: <String, Object?>{'person_id': personId, 'block_id': block.id},
      );
    }
  }

  /// Một ngày trôi qua với cơ thể từng người lớn trong hộ.
  ///
  /// Đốt năng lượng theo số giờ đã lao động thật, hết dự trữ thì sụt cân,
  /// dư dả thì hồi lại phần đã sụt. Cơn đói và sức làm việc đều suy từ đây.
  void _settleAdultBodies(HouseholdState household) {
    final Map<String, PersonState> updated = <String, PersonState>{
      ..._state.people,
    };
    final List<WorldFact> facts = <WorldFact>[..._state.facts];
    bool changed = false;
    for (final String memberId in household.memberIds) {
      final PersonState? member = updated[memberId];
      final AdultBodyState? body = member?.body;
      final PersonAgenda? agenda = member?.agenda;
      if (member == null || body == null || agenda == null) continue;
      // Bệnh đang hoạt động thì đốt thêm năng lượng và mất thêm nước.
      final IllnessState? sick = _activeIllness(memberId);
      final AdultBodyDayResult result = body.advanceDay(
        workedSeconds: agenda.workedSecondsToday,
        illnessSeverity: sick?.severity ?? 0,
      );
      AdultBodyState settled = result.body.recover();
      // Uống nước lấy từ kho hộ, phải có quyền và kho phải còn.
      final int wanted = settled.drinkNeedMl;
      if (wanted > 0) {
        final int drunk = _drawWater(household, memberId, wanted);
        if (drunk > 0) {
          settled = settled.drink(drunk);
          facts.add(
            _fact(
              'body_drank',
              memberId,
              'ml=$drunk wanted=$wanted hydration=${settled.hydration}',
            ),
          );
        }
      }
      updated[memberId] = member
          .withBody(settled)
          .withAgenda(
            agenda.withHunger(settled.hunger).withThirst(settled.thirst),
          );
      changed = true;
      if (result.lostGrams > 0) {
        facts.add(
          _fact(
            'body_mass_lost',
            memberId,
            'lost_g=${result.lostGrams} mass_g=${settled.massGrams} '
                'capability=${settled.capability} '
                'burned_kj=${result.burnedKj} work_hours=${result.workHours}',
          ),
        );
      }
      if (settled.dehydrated) {
        facts.add(
          _fact(
            'body_dehydrated',
            memberId,
            'hydration=${settled.hydration} thirst=${settled.thirst} '
                'capability=${settled.capability}',
          ),
        );
      }
    }
    if (changed) _replace(people: updated, facts: facts);
    if (household.adultIllness) {
      for (final String memberId in household.memberIds) {
        _checkAdultIllnessOnset(household.id, memberId);
      }
    }
  }

  /// Rút nước uống khỏi kho hộ, trả về số mililít thật sự lấy được.
  ///
  /// Không có quyền dùng kho hoặc kho đã cạn thì lấy được ít hơn mong muốn,
  /// và người đó phải chịu khát.
  int _drawWater(HouseholdState household, String personId, int wantedMl) {
    final String? itemId = household.resourceItemIds['water'];
    if (itemId == null) return 0;
    if (!household.canUse(personId, itemId)) return 0;
    final CareItemState? item = _state.items[itemId];
    if (item == null || item.quantity <= 0) return 0;
    final int drawn = wantedMl.clamp(0, item.quantity);
    if (drawn <= 0) return 0;
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        itemId: item.consume(drawn),
      },
    );
    return drawn;
  }

  /// Hộ của người này có theo dõi tay nghề, cơn đói và tâm trạng hay không.
  bool _wellbeing(PersonState person) {
    final String? householdId = person.householdId;
    if (householdId == null) return false;
    return _state.households[householdId]?.wellbeing ?? false;
  }

  /// Điều đang giữ chân một người khỏi cam kết mới, nếu có.
  String? _competingObligation(PersonState person) {
    final PersonalTimeCommitment? commitment = person.timeCommitment;
    if (commitment != null && commitment.endsAtSeconds > _state.now.seconds) {
      return commitment.activity;
    }
    final RoutineState? routine = person.routine;
    if (routine?.preemptedBy != null) return routine!.preemptedBy;
    if (person.caregiverAgent?.available == false) {
      return 'không đủ sức làm việc';
    }
    // Đang ốm thì nghỉ cho tới khi khỏi, không theo một mức nặng tuỳ ý.
    //
    // Lấy mức nặng làm ngưỡng thì hỏng: một lượt chăm hạ mức nặng xuống dưới
    // ngưỡng ngay trong nửa giờ, nên hôm sau người ta lại đi làm và ốm lại.
    final IllnessState? sick = _activeIllness(person.id);
    if (sick != null) return 'nghỉ vì ốm (${sick.severity}/1000)';
    return null;
  }

  /// Mức trẻ chủ động tìm đến một người, chỉ dùng điều trẻ đã trải qua cùng
  /// quan hệ một chiều của chính trẻ. Người lạ không tự nhận điểm gia đình.
  int _childCaregiverPreference(PersonState child, PersonState caregiver) {
    final InfantCareExpectationState? expectation =
        child.infancy?.careExpectations[caregiver.id];
    final FamilyBondState? bond = child.familyBonds[caregiver.id];
    final int familyBonus = child.familyRelationships.containsKey(caregiver.id)
        ? 250
        : 0;
    return familyBonus +
        (expectation?.safety ?? 0) * 2 +
        (expectation?.predictability ?? 0) +
        (bond?.trust ?? 0) +
        (bond?.affection ?? 0) +
        (caregiver.caregiverAgent?.careSkill ?? 0) ~/ 2;
  }

  /// Giữ đồng thời thời gian của mọi người tham gia một hành trình.
  ///
  /// Kiểm tra toàn bộ trước rồi mới ghi để không xảy ra trạng thái một nửa
  /// đoàn đã đi còn người khác vẫn ở nhà. Khối việc đang chạy được cắt ngang;
  /// giờ mất sẽ được [RoutineState] tính vào sản lượng khi khối kết thúc.
  bool _beginPersonalCommitments({
    required Iterable<String> personIds,
    required String commitmentId,
    required String kind,
    required String activity,
    required int endsAtSeconds,
    String? relatedId,
    String? serviceReservationId,
    String? laborReservationId,
  }) {
    final List<String> ids = personIds.toSet().toList()..sort();
    if (endsAtSeconds <= _state.now.seconds || ids.isEmpty) return false;
    final List<PersonState> people = <PersonState>[];
    for (final String id in ids) {
      final PersonState? person = _state.people[id];
      final bool overlapsReservedService = _state.serviceAppointments.values
          .any(
            (ServiceAppointmentState value) =>
                value.id != serviceReservationId &&
                value.reservesPerson(id, _state.now.seconds, endsAtSeconds),
          );
      final bool overlapsAcceptedLabor = _state.laborOffers.values.any(
        (LaborOfferState value) =>
            value.id != laborReservationId &&
            value.reservesWorker(id, _state.now.seconds, endsAtSeconds),
      );
      if (person == null ||
          _competingObligation(person) != null ||
          overlapsReservedService ||
          overlapsAcceptedLabor) {
        return false;
      }
      people.add(person);
    }
    final Map<String, PersonState> updated = <String, PersonState>{
      ..._state.people,
    };
    final List<WorldFact> facts = <WorldFact>[..._state.facts];
    for (final PersonState person in people) {
      final PersonalTimeCommitment commitment = PersonalTimeCommitment(
        id: commitmentId,
        kind: kind,
        activity: activity,
        startedAtSeconds: _state.now.seconds,
        endsAtSeconds: endsAtSeconds,
        relatedId: relatedId,
      );
      updated[person.id] = _preemptRoutine(
        person.withTimeCommitment(commitment),
        activity,
      );
      facts.add(
        _fact(
          'personal_time_committed',
          person.id,
          'commitment=$commitmentId kind=$kind activity=$activity '
              'ends_at=$endsAtSeconds related=${relatedId ?? 'none'}',
        ),
      );
    }
    _replace(people: updated, facts: facts);
    return true;
  }

  /// Trả người tham gia về nhịp sống cũ và tính mệt cho thời gian đi đường.
  void _endPersonalCommitments(
    Iterable<String> personIds,
    String commitmentId,
  ) {
    final Map<String, PersonState> updated = <String, PersonState>{
      ..._state.people,
    };
    final List<WorldFact> facts = <WorldFact>[..._state.facts];
    bool changed = false;
    for (final String id in personIds.toSet()) {
      final PersonState? person = updated[id];
      final PersonalTimeCommitment? commitment = person?.timeCommitment;
      if (person == null ||
          commitment == null ||
          commitment.id != commitmentId) {
        continue;
      }
      final int elapsed = (_state.now.seconds - commitment.startedAtSeconds)
          .clamp(0, commitment.durationSeconds);
      PersonState next = _resumeRoutine(person).clearTimeCommitment();
      if (next.agenda != null && elapsed > 0) {
        next = next.withAgenda(next.agenda!.tire(elapsed).logWork(elapsed));
      }
      updated[id] = next;
      facts.add(
        _fact(
          'personal_time_released',
          id,
          'commitment=$commitmentId kind=${commitment.kind} '
              'elapsed_seconds=$elapsed',
        ),
      );
      changed = true;
    }
    if (changed) _replace(people: updated, facts: facts);
  }

  /// Năng lượng của một trăm gam lương thực khô trong fixture.
  static const int _kjPerHundredGramsFood = 1400;

  /// Dựng cơ thể người lớn từ payload.
  ///
  /// Dự trữ để trống thì coi như đầy; khối lượng lúc khỏe để trống thì lấy
  /// bằng khối lượng hiện tại. Cả hai trường đều được đọc độc lập — trước đây
  /// `healthy_mass_g` bị bỏ qua nếu không kèm `energy_reserve_kj`, nên người
  /// khai báo là gầy vẫn được coi là đủ sức.
  static AdultBodyState _adultBodyFromPayload(Map<String, Object?> payload) {
    final int mass = payload['mass_g'] as int? ?? 52000;
    final int healthy = payload['healthy_mass_g'] as int? ?? mass;
    final int reserve =
        (payload['energy_reserve_kj'] as int? ??
                AdultBodyState.reserveCapacityKj)
            .clamp(0, AdultBodyState.reserveCapacityKj);
    return AdultBodyState(
      massGrams: mass,
      healthyMassGrams: healthy,
      energyReserveKj: reserve,
      bodyWaterMl: mass * AdultBodyState.waterPerMilleOfMass ~/ 1000,
    );
  }

  /// Nhịp tiêu thụ mỗi ngày của hộ, dùng để suy ra số ngày còn dùng được.
  static const Map<String, int> _dailyUseByResource = <String, int>{
    'food': 1500,
    'water': 6000,
    'fuel': 900,
  };

  /// Còn dưới ngần này ngày dự trữ thì nhu cầu bắt đầu sinh việc.
  static const int _supplyHorizonDays = 12;

  /// Mã nghề cần cho từng loại việc do nhu cầu sinh ra.
  static const Map<String, String> _skillByResource = <String, String>{
    'fuel': 'gather_fuel',
    'water': 'fetch_water',
    'food': 'gather_food',
  };

  /// Dưới mức này thì coi như chưa biết làm, không được giao việc.
  static const int _minimumWorkSkill = 200;

  /// Việc do kế hoạch sinh ra: thời lượng, phòng và sản lượng nếu làm trọn.
  static const Map<String, (String, int, int, String)> _workByResource =
      <String, (String, int, int, String)>{
        'fuel': ('kiếm củi', 4 * 3600, 2400, 'ROOM-YARD'),
        'water': ('gánh nước', 5400, 18000, 'ROOM-YARD'),
        'food': ('kiếm lương thực', 5 * 3600, 3000, 'ROOM-YARD'),
      };

  /// Người lớn có cơ thể uống chừng này nước mỗi ngày ngoài bữa ăn.
  static const int _dailyDrinkMlPerAdult = 2500;

  /// Nhịp tiêu thụ thật mỗi ngày, tính cả phần người trong hộ uống.
  int _dailyUse(String key, HouseholdState household) {
    final int base = _dailyUseByResource[key]!;
    if (key != 'water') return base;
    final int drinkers = household.memberIds
        .where((String memberId) => _state.people[memberId]?.body != null)
        .length;
    return base + drinkers * _dailyDrinkMlPerAdult;
  }

  String? _workRoomForHousehold(
    HouseholdState household,
    String preferredRoomId,
  ) {
    final RoomState? preferred = _state.rooms[preferredRoomId];
    if (preferred?.householdId == household.id) return preferredRoomId;
    return _state.rooms.values
        .where((RoomState room) => room.householdId == household.id)
        .map((RoomState room) => room.id)
        .firstOrNull;
  }

  /// Nhu cầu vật chất của hộ, suy từ tồn kho thật tại thời điểm gọi.
  List<HouseholdNeed> householdNeeds(String householdId) {
    final HouseholdState? household = _state.households[householdId];
    if (household == null) return const <HouseholdNeed>[];
    final List<HouseholdNeed> needs = <HouseholdNeed>[];
    for (final String key in _dailyUseByResource.keys.toList()..sort()) {
      final String? itemId = household.resourceItemIds[key];
      final CareItemState? item = itemId == null ? null : _state.items[itemId];
      if (item == null) continue;
      needs.add(
        HouseholdNeed(
          kind: key,
          resourceKey: key,
          quantity: item.quantity,
          dailyUse: _dailyUse(key, household),
          horizonDays: _supplyHorizonDays,
        ),
      );
    }
    needs.sort((HouseholdNeed a, HouseholdNeed b) {
      final int byUrgency = b.urgency.compareTo(a.urgency);
      return byUrgency != 0 ? byUrgency : a.kind.compareTo(b.kind);
    });
    return List<HouseholdNeed>.unmodifiable(needs);
  }

  /// Mỗi chiều đổi một phần sản lượng đặc trưng của hộ kia. Hai lượng hàng
  /// rời kho cùng lúc; sự kiện đến nơi chỉ giải phóng hàng đang vận chuyển.
  void _applyCommunityExchangeCycle(ScheduledEvent event) {
    final SimTime nextCycle = event.due.addDays(1);
    if (nextCycle.seconds < 30 * gameSecondsPerDay) {
      schedule(
        due: nextCycle,
        phase: EventPhase.transfer,
        kind: event.kind,
        payload: event.payload,
      );
    }
    final List<HouseholdState> eligible =
        _state.households.values
            .where(
              (HouseholdState household) =>
                  household.id.startsWith('VH') &&
                  !_state.communityExchanges.values.any(
                    (CommunityExchangeState exchange) =>
                        exchange.status == CommunityExchangeStatus.traveling &&
                        (exchange.firstHouseholdId == household.id ||
                            exchange.secondHouseholdId == household.id),
                  ),
            )
            .toList()
          ..sort((HouseholdState a, HouseholdState b) => a.id.compareTo(b.id));
    if (eligible.length < 2) return;
    final int rotation = _state.now.day % eligible.length;
    final List<HouseholdState> waiting = <HouseholdState>[
      ...eligible.skip(rotation),
      ...eligible.take(rotation),
    ];
    int ordinal = 0;
    while (waiting.length >= 2) {
      final HouseholdState first = waiting.removeAt(0);
      final String? firstResource = _householdSpecialty(first);
      if (firstResource == null) continue;
      final int partnerIndex = waiting.indexWhere((HouseholdState candidate) {
        final String? resource = _householdSpecialty(candidate);
        return resource != null && resource != firstResource;
      });
      if (partnerIndex < 0) continue;
      final HouseholdState second = waiting.removeAt(partnerIndex);
      if (_departCommunityExchange(first, second, ordinal)) ordinal++;
    }
  }

  String? _householdSpecialty(HouseholdState household) {
    final PersonState? lead = household.memberIds
        .map((String id) => _state.people[id])
        .whereType<PersonState>()
        .firstOrNull;
    return switch (lead?.occupationCode) {
      'gather_food' || 'trade' || 'herbalism' => 'food',
      'fetch_water' => 'water',
      'gather_fuel' => 'fuel',
      _ => null,
    };
  }

  PersonState? _exchangeCarrier(HouseholdState household, String itemId) {
    final Set<String> authorized =
        household.authorizedUsersByItemId[itemId] ?? const <String>{};
    final List<PersonState> available = household.memberIds
        .map((String id) => _state.people[id])
        .whereType<PersonState>()
        .where(
          (PersonState person) =>
              authorized.contains(person.id) &&
              person.caregiverAgent?.available != false &&
              _competingObligation(person) == null &&
              !_state.illnesses.values.any(
                (IllnessState illness) =>
                    illness.personId == person.id && illness.active,
              ),
        )
        .toList();
    available.sort((PersonState left, PersonState right) {
      final int byFatigue = (left.agenda?.fatigue ?? 0).compareTo(
        right.agenda?.fatigue ?? 0,
      );
      return byFatigue != 0 ? byFatigue : left.id.compareTo(right.id);
    });
    return available.firstOrNull;
  }

  bool _departCommunityExchange(
    HouseholdState first,
    HouseholdState second,
    int ordinal,
  ) {
    final String? firstResource = _householdSpecialty(first);
    final String? secondResource = _householdSpecialty(second);
    if (firstResource == null ||
        secondResource == null ||
        firstResource == secondResource) {
      return false;
    }
    final String? firstItemId = first.resourceItemIds[firstResource];
    final String? secondItemId = second.resourceItemIds[secondResource];
    final CareItemState? firstItem = firstItemId == null
        ? null
        : _state.items[firstItemId];
    final CareItemState? secondItem = secondItemId == null
        ? null
        : _state.items[secondItemId];
    if (firstItem == null || secondItem == null) return false;
    final PersonState? firstCarrier = _exchangeCarrier(first, firstItem.id);
    final PersonState? secondCarrier = _exchangeCarrier(second, secondItem.id);
    if (firstCarrier == null || secondCarrier == null) return false;
    final int firstDailyUse = _dailyUse(firstResource, first);
    final int secondDailyUse = _dailyUse(secondResource, second);
    final int firstAvailable = firstItem.quantity - firstDailyUse * 2;
    final int secondAvailable = secondItem.quantity - secondDailyUse * 2;
    if (firstAvailable <= 0 || secondAvailable <= 0) return false;
    final int firstAmount = firstAvailable < firstDailyUse
        ? firstAvailable
        : firstDailyUse;
    final int secondAmount = secondAvailable < secondDailyUse
        ? secondAvailable
        : secondDailyUse;
    final RoomState? firstRoom = _state.rooms.values
        .where((RoomState room) => room.householdId == first.id)
        .firstOrNull;
    final RoomState? secondRoom = _state.rooms.values
        .where((RoomState room) => room.householdId == second.id)
        .firstOrNull;
    if (firstRoom == null || secondRoom == null) return false;
    final int distanceMm =
        WorldPoint(
          firstRoom.anchorPositionMm,
          firstRoom.anchorPositionYMm,
        ).distanceTo(
          WorldPoint(secondRoom.anchorPositionMm, secondRoom.anchorPositionYMm),
        );
    final int firstSpeed =
        firstCarrier.caregiverAgent?.movementSpeedMmPerSecond ?? 1000;
    final int secondSpeed =
        secondCarrier.caregiverAgent?.movementSpeedMmPerSecond ?? 1000;
    final int slowestSpeed = firstSpeed < secondSpeed
        ? firstSpeed
        : secondSpeed;
    final int rawTravelSeconds = distanceMm ~/ slowestSpeed.clamp(1, 1000000);
    final int travelSeconds = rawTravelSeconds.clamp(15 * 60, 12 * 3600);
    final int arrivalSeconds = _state.now.seconds + travelSeconds;
    final String exchangeId =
        'EX-${_state.now.day}-${ordinal + 1}-${first.id}-${second.id}';
    final CommunityExchangeState exchange = CommunityExchangeState(
      id: exchangeId,
      firstHouseholdId: first.id,
      secondHouseholdId: second.id,
      firstCarrierId: firstCarrier.id,
      secondCarrierId: secondCarrier.id,
      firstResource: firstResource,
      firstAmount: firstAmount,
      secondResource: secondResource,
      secondAmount: secondAmount,
      departedAtSeconds: _state.now.seconds,
      expectedArrivalSeconds: arrivalSeconds,
      status: CommunityExchangeStatus.traveling,
    );
    final String commitmentId = 'TRAVEL-${exchange.id}';
    if (!_beginPersonalCommitments(
      personIds: <String>[firstCarrier.id, secondCarrier.id],
      commitmentId: commitmentId,
      kind: 'community_exchange',
      activity: 'đang mang hàng đổi giữa các hộ',
      endsAtSeconds: arrivalSeconds,
      relatedId: exchange.id,
    )) {
      return false;
    }
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        firstItem.id: firstItem.consume(firstAmount),
        secondItem.id: secondItem.consume(secondAmount),
      },
      communityExchanges: <String, CommunityExchangeState>{
        ..._state.communityExchanges,
        exchange.id: exchange,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_exchange_departed',
          exchange.id,
          'first=${first.id} give=$firstResource:$firstAmount '
              'second=${second.id} give=$secondResource:$secondAmount '
              'travel_seconds=$travelSeconds',
        ),
      ],
    );
    schedule(
      due: SimTime(arrivalSeconds),
      phase: EventPhase.transfer,
      kind: 'community_exchange_arrived',
      payload: <String, Object?>{'exchange_id': exchange.id},
    );
    _recordExchangeEncounter(exchange);
    _recordExchangeObservation(exchange, 'departed');
    _scheduleKnowledgeContact(
      speakerId: firstCarrier.id,
      listenerId: secondCarrier.id,
      contextExchangeId: exchange.id,
      delaySeconds: 10 * 60,
    );
    _scheduleKnowledgeContact(
      speakerId: secondCarrier.id,
      listenerId: firstCarrier.id,
      contextExchangeId: exchange.id,
      delaySeconds: 12 * 60,
    );
    return true;
  }

  bool _departNeedDrivenExchange({
    required HouseholdState requester,
    required HouseholdState donor,
    required PersonState requesterActor,
    required PersonState donorContact,
    required String requestedResource,
    required String offerResource,
    required HouseholdNeed need,
    required int relationScore,
    required int donorWillingness,
    required String resourceRequestId,
  }) {
    final String? offerItemId = requester.resourceItemIds[offerResource];
    final String? requestedItemId = donor.resourceItemIds[requestedResource];
    final CareItemState? offerItem = offerItemId == null
        ? null
        : _state.items[offerItemId];
    final CareItemState? requestedItem = requestedItemId == null
        ? null
        : _state.items[requestedItemId];
    if (offerItem == null || requestedItem == null) return false;
    if (!requester.canUse(requesterActor.id, offerItem.id) ||
        !donor.canUse(donorContact.id, requestedItem.id)) {
      return false;
    }
    final int offerSurplus =
        offerItem.quantity - _dailyUse(offerResource, requester) * 2;
    final int requestedSurplus =
        requestedItem.quantity - _dailyUse(requestedResource, donor) * 2;
    if (offerSurplus <= 0 || requestedSurplus <= 0) return false;
    final int offerDailyUse = _dailyUse(offerResource, requester);
    final int offerAmount = offerSurplus < offerDailyUse
        ? offerSurplus
        : offerDailyUse;
    final int requestedAmount = requestedSurplus < need.dailyUse
        ? requestedSurplus
        : need.dailyUse;
    final RoomState? requesterRoom = _state.rooms.values
        .where((RoomState room) => room.householdId == requester.id)
        .firstOrNull;
    final RoomState? donorRoom = _state.rooms.values
        .where((RoomState room) => room.householdId == donor.id)
        .firstOrNull;
    if (requesterRoom == null || donorRoom == null) return false;
    final int distanceMm =
        WorldPoint(
          requesterRoom.anchorPositionMm,
          requesterRoom.anchorPositionYMm,
        ).distanceTo(
          WorldPoint(donorRoom.anchorPositionMm, donorRoom.anchorPositionYMm),
        );
    final int requesterSpeed =
        requesterActor.caregiverAgent?.movementSpeedMmPerSecond ?? 1000;
    final int donorSpeed =
        donorContact.caregiverAgent?.movementSpeedMmPerSecond ?? 1000;
    final int slowestSpeed = requesterSpeed < donorSpeed
        ? requesterSpeed
        : donorSpeed;
    final int travelSeconds = (distanceMm ~/ slowestSpeed.clamp(1, 1000000))
        .clamp(15 * 60, 12 * 3600);
    final String exchangeId =
        'EX-NEED-${_state.now.seconds}-${requester.id}-${donor.id}';
    if (_state.communityExchanges.containsKey(exchangeId)) return false;
    final CommunityExchangeState exchange = CommunityExchangeState(
      id: exchangeId,
      firstHouseholdId: requester.id,
      secondHouseholdId: donor.id,
      firstCarrierId: requesterActor.id,
      secondCarrierId: donorContact.id,
      firstResource: offerResource,
      firstAmount: offerAmount,
      secondResource: requestedResource,
      secondAmount: requestedAmount,
      departedAtSeconds: _state.now.seconds,
      expectedArrivalSeconds: _state.now.seconds + travelSeconds,
      status: CommunityExchangeStatus.traveling,
      resourceRequestId: resourceRequestId,
    );
    final String commitmentId = 'TRAVEL-${exchange.id}';
    if (!_beginPersonalCommitments(
      personIds: <String>[requesterActor.id, donorContact.id],
      commitmentId: commitmentId,
      kind: 'need_driven_exchange',
      activity: 'đang mang hàng cứu nhu cầu của hộ',
      endsAtSeconds: exchange.expectedArrivalSeconds,
      relatedId: exchange.id,
    )) {
      return false;
    }
    final CommunityResourceRequestState? request = _communityResourceRequest(
      resourceRequestId,
    );
    if (request != null) {
      _saveCommunityResourceRequest(
        request.advance(
          status: CommunityResourceRequestStatus.goodsInTransit,
          atSeconds: _state.now.seconds,
          askerId: requesterActor.id,
          providerHouseholdId: donor.id,
          providerContactId: donorContact.id,
          exchangeId: exchange.id,
        ),
      );
    }
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        offerItem.id: offerItem.consume(offerAmount),
        requestedItem.id: requestedItem.consume(requestedAmount),
      },
      communityExchanges: <String, CommunityExchangeState>{
        ..._state.communityExchanges,
        exchange.id: exchange,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_resource_response_started',
          requester.id,
          'resource=$requestedResource actor=${requesterActor.id} '
              'contact=${donorContact.id} donor=${donor.id} '
              'received=$requestedAmount offer=$offerResource:$offerAmount '
              'relation_score=$relationScore '
              'donor_willingness=$donorWillingness '
              'travel_seconds=$travelSeconds',
        ),
      ],
    );
    schedule(
      due: SimTime(exchange.expectedArrivalSeconds),
      phase: EventPhase.transfer,
      kind: 'community_exchange_arrived',
      payload: <String, Object?>{'exchange_id': exchange.id},
    );
    _recordExchangeEncounter(exchange);
    _recordExchangeObservation(exchange, 'departed');
    _scheduleKnowledgeContact(
      speakerId: requesterActor.id,
      listenerId: donorContact.id,
      contextExchangeId: exchange.id,
      delaySeconds: 10 * 60,
    );
    _scheduleKnowledgeContact(
      speakerId: donorContact.id,
      listenerId: requesterActor.id,
      contextExchangeId: exchange.id,
      delaySeconds: 12 * 60,
    );
    return true;
  }

  void _applyCommunityExchangeArrived(ScheduledEvent event) {
    final String exchangeId = event.payload['exchange_id']! as String;
    final CommunityExchangeState? exchange =
        _state.communityExchanges[exchangeId];
    if (exchange == null ||
        exchange.status != CommunityExchangeStatus.traveling) {
      return;
    }
    _endPersonalCommitments(<String>[
      exchange.firstCarrierId,
      exchange.secondCarrierId,
    ], 'TRAVEL-${exchange.id}');
    final HouseholdState? first = _state.households[exchange.firstHouseholdId];
    final HouseholdState? second =
        _state.households[exchange.secondHouseholdId];
    final CareItemState? firstDestination = first == null
        ? null
        : _state.items[first.resourceItemIds[exchange.secondResource]];
    final CareItemState? secondDestination = second == null
        ? null
        : _state.items[second.resourceItemIds[exchange.firstResource]];
    if (first == null ||
        second == null ||
        firstDestination == null ||
        secondDestination == null) {
      final Map<String, CareItemState> restored = <String, CareItemState>{
        ..._state.items,
      };
      final String? firstSourceId =
          first?.resourceItemIds[exchange.firstResource];
      final String? secondSourceId =
          second?.resourceItemIds[exchange.secondResource];
      if (firstSourceId != null && restored[firstSourceId] != null) {
        restored[firstSourceId] = restored[firstSourceId]!.replenish(
          exchange.firstAmount,
        );
      }
      if (secondSourceId != null && restored[secondSourceId] != null) {
        restored[secondSourceId] = restored[secondSourceId]!.replenish(
          exchange.secondAmount,
        );
      }
      _replace(
        items: restored,
        communityExchanges: <String, CommunityExchangeState>{
          ..._state.communityExchanges,
          exchange.id: exchange.cancel(
            _state.now.seconds,
            'destination_ledger_missing',
          ),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'community_exchange_cancelled',
            exchange.id,
            'reason=destination_ledger_missing cargo_returned=true',
          ),
        ],
      );
      _recordExchangeTradeOutcome(exchange, succeeded: false);
      if (exchange.resourceRequestId != null) {
        _recordCommunityResourceResponseFailure(
          exchange.firstHouseholdId,
          exchange.secondResource,
          'exchange_cancelled_${exchange.cancelReason ?? 'destination_ledger_missing'}',
          requestId: exchange.resourceRequestId,
        );
      }
      return;
    }
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        firstDestination.id: firstDestination.replenish(exchange.secondAmount),
        secondDestination.id: secondDestination.replenish(exchange.firstAmount),
      },
      communityExchanges: <String, CommunityExchangeState>{
        ..._state.communityExchanges,
        exchange.id: exchange.complete(_state.now.seconds),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_exchange_completed',
          exchange.id,
          'first=${first.id} received=${exchange.secondResource}:'
              '${exchange.secondAmount} second=${second.id} '
              'received=${exchange.firstResource}:${exchange.firstAmount}',
        ),
      ],
    );
    final CommunityExchangeState completed =
        _state.communityExchanges[exchange.id]!;
    final CommunityResourceRequestState? resourceRequest =
        _communityResourceRequest(completed.resourceRequestId);
    if (resourceRequest != null && resourceRequest.active) {
      _saveCommunityResourceRequest(
        resourceRequest.advance(
          status: CommunityResourceRequestStatus.resolved,
          atSeconds: _state.now.seconds,
          exchangeId: completed.id,
        ),
        factKind: 'community_resource_request_resolved',
        factDetail:
            'resource=${resourceRequest.resource} exchange=${completed.id} '
            'amount=${completed.secondAmount}',
      );
    }
    _recordExchangeTradeOutcome(completed, succeeded: true);
    _recordExchangeObservation(completed, 'completed');
    _scheduleHouseholdDebrief(completed, completed.firstCarrierId);
    _scheduleHouseholdDebrief(completed, completed.secondCarrierId);
  }

  void _recordExchangeEncounter(CommunityExchangeState exchange) {
    final PersonState? first = _state.people[exchange.firstCarrierId];
    final PersonState? second = _state.people[exchange.secondCarrierId];
    if (first == null || second == null) return;
    final bool relationStarted =
        !first.socialRelations.containsKey(second.id) ||
        !second.socialRelations.containsKey(first.id);
    final String interactionId = 'encounter:${exchange.id}';
    final SocialRelationState firstRelation =
        (first.socialRelations[second.id] ??
                SocialRelationState(otherPersonId: second.id))
            .recordEncounter(
              interactionId: interactionId,
              atSeconds: _state.now.seconds,
            );
    final SocialRelationState secondRelation =
        (second.socialRelations[first.id] ??
                SocialRelationState(otherPersonId: first.id))
            .recordEncounter(
              interactionId: interactionId,
              atSeconds: _state.now.seconds,
            );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        first.id: first.withSocialRelation(second.id, firstRelation),
        second.id: second.withSocialRelation(first.id, secondRelation),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          relationStarted
              ? 'social_relation_started'
              : 'social_encounter_recorded',
          exchange.id,
          'first=${first.id} second=${second.id} '
          'cause=community_exchange',
        ),
      ],
    );
  }

  void _recordExchangeTradeOutcome(
    CommunityExchangeState exchange, {
    required bool succeeded,
  }) {
    final PersonState? first = _state.people[exchange.firstCarrierId];
    final PersonState? second = _state.people[exchange.secondCarrierId];
    if (first == null || second == null) return;
    final String interactionId = 'trade:${exchange.id}';
    final SocialRelationState firstRelation =
        (first.socialRelations[second.id] ??
                SocialRelationState(otherPersonId: second.id))
            .recordTrade(
              interactionId: interactionId,
              atSeconds: _state.now.seconds,
              succeeded: succeeded,
            );
    final SocialRelationState secondRelation =
        (second.socialRelations[first.id] ??
                SocialRelationState(otherPersonId: first.id))
            .recordTrade(
              interactionId: interactionId,
              atSeconds: _state.now.seconds,
              succeeded: succeeded,
            );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        first.id: first.withSocialRelation(second.id, firstRelation),
        second.id: second.withSocialRelation(first.id, secondRelation),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'social_trade_trust_changed',
          exchange.id,
          'first=${first.id} second=${second.id} succeeded=$succeeded '
              'first_trust=${firstRelation.tradeTrust} '
              'second_trust=${secondRelation.tradeTrust}',
        ),
      ],
    );
  }

  void _recordExchangeObservation(
    CommunityExchangeState exchange,
    String stage,
  ) {
    final String claimId = 'exchange:${exchange.id}:$stage';
    final List<String> witnesses = <String>[
      exchange.firstCarrierId,
      exchange.secondCarrierId,
    ];
    final Map<String, PersonState> people = <String, PersonState>{
      ..._state.people,
    };
    int learned = 0;
    for (final String witnessId in witnesses) {
      final PersonState? witness = people[witnessId];
      if (witness == null) continue;
      final String evidenceId = '$claimId:$witnessId';
      final BeliefState belief = BeliefState(
        id: evidenceId,
        claimId: claimId,
        topic: 'community_exchange',
        subjectId: exchange.id,
        summary: stage == 'departed'
            ? '${exchange.firstHouseholdId} và ${exchange.secondHouseholdId} đã giao hàng để đổi.'
            : 'Hàng đổi giữa ${exchange.firstHouseholdId} và ${exchange.secondHouseholdId} đã tới nơi.',
        eventAtSeconds: _state.now.seconds,
        learnedAtSeconds: _state.now.seconds,
        acquisition: KnowledgeAcquisition.observation,
        sourcePersonId: witnessId,
        originPersonId: witnessId,
        originEvidenceId: evidenceId,
        confidence: 1000,
      );
      final PersonState next = witness.learn(belief);
      if (!identical(next, witness)) {
        people[witnessId] = next;
        learned++;
      }
    }
    if (learned == 0) return;
    _replace(
      people: people,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'knowledge_observed',
          exchange.id,
          'claim=$claimId witnesses=${witnesses.join(',')} count=$learned',
        ),
      ],
    );
  }

  void _scheduleKnowledgeContact({
    required String speakerId,
    required String listenerId,
    required String contextExchangeId,
    required int delaySeconds,
  }) {
    final PersonState? speaker = _state.people[speakerId];
    final PersonState? listener = _state.people[listenerId];
    if (speaker == null || listener == null) return;
    final List<BeliefState> shareable =
        speaker.beliefs.values
            .where(
              (BeliefState belief) => !listener.beliefs.containsKey(belief.id),
            )
            .toList()
          ..sort((BeliefState a, BeliefState b) {
            final int byTime = b.learnedAtSeconds.compareTo(a.learnedAtSeconds);
            return byTime != 0 ? byTime : a.id.compareTo(b.id);
          });
    if (shareable.isEmpty) return;
    schedule(
      due: _state.now.addSeconds(delaySeconds),
      phase: EventPhase.observation,
      kind: 'knowledge_shared',
      payload: <String, Object?>{
        'speaker_id': speakerId,
        'listener_id': listenerId,
        'belief_id': shareable.first.id,
        'context_exchange_id': contextExchangeId,
      },
    );
  }

  void _scheduleHouseholdDebrief(
    CommunityExchangeState exchange,
    String speakerId,
  ) {
    final PersonState? speaker = _state.people[speakerId];
    final HouseholdState? household = speaker?.householdId == null
        ? null
        : _state.households[speaker!.householdId];
    final List<String> listenerIds = <String>[
      ...?household?.memberIds.where((String id) => id != speakerId),
    ]..sort();
    final String? listenerId = listenerIds.firstOrNull;
    if (listenerId == null) return;
    _scheduleKnowledgeContact(
      speakerId: speakerId,
      listenerId: listenerId,
      contextExchangeId: exchange.id,
      delaySeconds: 30 * 60,
    );
  }

  void _applyKnowledgeShared(ScheduledEvent event) {
    final String speakerId = event.payload['speaker_id']! as String;
    final String listenerId = event.payload['listener_id']! as String;
    final String beliefId = event.payload['belief_id']! as String;
    final String exchangeId = event.payload['context_exchange_id']! as String;
    final PersonState? speaker = _state.people[speakerId];
    final PersonState? listener = _state.people[listenerId];
    final BeliefState? belief = speaker?.beliefs[beliefId];
    final CommunityExchangeState? exchange =
        _state.communityExchanges[exchangeId];
    if (speaker == null ||
        listener == null ||
        belief == null ||
        exchange == null) {
      return;
    }
    final bool sameHousehold =
        speaker.householdId != null &&
        speaker.householdId == listener.householdId;
    final Set<String> carriers = <String>{
      exchange.firstCarrierId,
      exchange.secondCarrierId,
    };
    if (!sameHousehold || !carriers.contains(speakerId)) {
      if (!(carriers.contains(speakerId) && carriers.contains(listenerId))) {
        return;
      }
    }
    final BeliefState relayed = belief.relayedBy(
      speakerId: speakerId,
      learnedAtSeconds: _state.now.seconds,
    );
    PersonState next = listener.learn(relayed);
    if (identical(next, listener)) return;
    SocialRelationState? informationRelation;
    if (speaker.householdId != listener.householdId) {
      informationRelation =
          (next.socialRelations[speakerId] ??
                  SocialRelationState(otherPersonId: speakerId))
              .recordInformationReceived(
                interactionId:
                    'information:${belief.originEvidenceId}:$speakerId:$listenerId',
                atSeconds: _state.now.seconds,
                confidence: relayed.confidence,
              );
      next = next.withSocialRelation(speakerId, informationRelation);
    }
    _replace(
      people: <String, PersonState>{..._state.people, listenerId: next},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'knowledge_shared',
          listenerId,
          'speaker=$speakerId claim=${belief.claimId} '
              'origin=${belief.originPersonId} confidence=${relayed.confidence} '
              'hops=${relayed.transmissionCount}'
              '${informationRelation == null ? '' : ' information_trust=${informationRelation.informationTrust}'}',
        ),
      ],
    );
  }

  void _applyCommunitySurvivalAudit(ScheduledEvent event) {
    final CommunitySurvivalState current =
        _state.communitySurvival ?? const CommunitySurvivalState();
    if (current.complete) return;
    final CommunityDaySnapshot? previous = current.latest;
    final List<HouseholdState> households = _state.households.values.toList()
      ..sort((HouseholdState a, HouseholdState b) => a.id.compareTo(b.id));
    final List<HouseholdSurvivalSnapshot> snapshots =
        <HouseholdSurvivalSnapshot>[];
    for (final HouseholdState household in households) {
      int? quantityOf(String resource) {
        final String? itemId = household.resourceItemIds[resource];
        return itemId == null ? null : _state.items[itemId]?.quantity;
      }

      final List<String> pressureKinds = householdNeeds(household.id)
          .where((HouseholdNeed need) => need.needed)
          .map((HouseholdNeed need) => need.kind)
          .toList();
      final int activeIllnesses = household.memberIds
          .where((String personId) => _activeIllness(personId) != null)
          .length;
      final int availableWorkers = household.memberIds.where((String id) {
        final PersonState? person = _state.people[id];
        return person != null &&
            person.infancy == null &&
            person.body != null &&
            person.caregiverAgent?.available != false &&
            _activeIllness(id) == null;
      }).length;
      final HouseholdSurvivalSnapshot? previousHousehold = previous?.households
          .where(
            (HouseholdSurvivalSnapshot value) =>
                value.householdId == household.id,
          )
          .firstOrNull;
      final int newMealShortfalls =
          (household.mealShortfalls - (previousHousehold?.mealShortfalls ?? 0))
              .clamp(0, household.mealShortfalls);
      final int? food = quantityOf('food');
      final int? water = quantityOf('water');
      final int? fuel = quantityOf('fuel');
      final List<String> criticalReasons = <String>[
        if (food == null) 'missing_food_ledger' else if (food <= 0) 'no_food',
        if (water == null)
          'missing_water_ledger'
        else if (water <= 0)
          'no_water',
        if (fuel == null) 'missing_fuel_ledger' else if (fuel <= 0) 'no_fuel',
        if (availableWorkers == 0) 'no_available_adult_worker',
        if (newMealShortfalls > 0) 'meal_shortfall',
      ];
      snapshots.add(
        HouseholdSurvivalSnapshot(
          householdId: household.id,
          foodQuantity: food,
          waterQuantity: water,
          fuelQuantity: fuel,
          availableAdultWorkers: availableWorkers,
          activeIllnesses: activeIllnesses,
          mealShortfalls: household.mealShortfalls,
          newMealShortfalls: newMealShortfalls,
          pressureKinds: pressureKinds,
          criticalReasons: criticalReasons,
        ),
      );
    }
    final int traveling = _state.communityExchanges.values
        .where(
          (CommunityExchangeState exchange) =>
              exchange.status == CommunityExchangeStatus.traveling,
        )
        .length;
    final int overdue = _state.communityExchanges.values
        .where(
          (CommunityExchangeState exchange) =>
              exchange.status == CommunityExchangeStatus.traveling &&
              exchange.expectedArrivalSeconds < _state.now.seconds,
        )
        .length;
    final CommunityDaySnapshot snapshot = CommunityDaySnapshot(
      day: _state.now.day,
      recordedAtSeconds: _state.now.seconds,
      households: snapshots,
      travelingExchanges: traveling,
      overdueExchanges: overdue,
    );
    final CommunitySurvivalState next = current.record(snapshot);
    _replace(
      communitySurvival: next,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          next.complete
              ? 'community_survival_audit_completed'
              : 'community_survival_day_recorded',
          'community',
          'day=${snapshot.day} recorded=${next.recordedDays}/'
              '${next.targetDays} pressured=${snapshot.pressuredHouseholds} '
              'critical=${snapshot.criticalHouseholds} overdue=$overdue '
              'rescue_days=${next.daysRequiringUnsupportedRescue}',
        ),
      ],
    );
    if (!next.complete) {
      schedule(
        due: event.due.addDays(1),
        phase: event.phase,
        kind: event.kind,
        payload: event.payload,
      );
    }
    for (final HouseholdSurvivalSnapshot household in snapshots) {
      if (household.pressureKinds.isEmpty) continue;
      final String resource = household.pressureKinds.first;
      final List<CommunityResourceRequestState> earlier =
          (_state.communitySurvival?.resourceRequests.values ??
                  const <CommunityResourceRequestState>[])
              .where(
                (CommunityResourceRequestState request) =>
                    request.householdId == household.householdId &&
                    request.resource == resource,
              )
              .toList()
            ..sort(
              (
                CommunityResourceRequestState a,
                CommunityResourceRequestState b,
              ) => b.updatedAtSeconds.compareTo(a.updatedAtSeconds),
            );
      final CommunityResourceRequestState? latestRequest = earlier.firstOrNull;
      final bool requestBlocksRetry =
          latestRequest?.active == true ||
          (latestRequest?.nextRetryAtSeconds ?? 0) > _state.now.seconds;
      final bool alreadyTrading = _state.communityExchanges.values.any(
        (CommunityExchangeState exchange) =>
            exchange.status == CommunityExchangeStatus.traveling &&
            (exchange.firstHouseholdId == household.householdId ||
                exchange.secondHouseholdId == household.householdId),
      );
      if (requestBlocksRetry || alreadyTrading) continue;
      final HouseholdNeed? need = householdNeeds(
        household.householdId,
      ).where((HouseholdNeed value) => value.kind == resource).firstOrNull;
      if (need == null) continue;
      final CommunityResourceRequestState request =
          CommunityResourceRequestState(
            id: 'RR-${snapshot.day}-${household.householdId}-$resource',
            householdId: household.householdId,
            resource: resource,
            openedAtSeconds: _state.now.seconds,
            updatedAtSeconds: _state.now.seconds,
            status: CommunityResourceRequestStatus.detected,
            urgency: need.urgency,
          );
      _saveCommunityResourceRequest(
        request,
        factKind: 'community_resource_request_opened',
        factDetail:
            'resource=$resource urgency=${need.urgency} day=${snapshot.day}',
      );
      schedule(
        due: event.due.addSeconds(10 * 60),
        phase: EventPhase.intent,
        kind: 'community_resource_response',
        payload: <String, Object?>{
          'household_id': household.householdId,
          'resource': resource,
          'audit_day': snapshot.day,
          'request_id': request.id,
        },
      );
    }
  }

  CommunityResourceRequestState? _communityResourceRequest(String? id) =>
      id == null ? null : _state.communitySurvival?.resourceRequests[id];

  void _saveCommunityResourceRequest(
    CommunityResourceRequestState request, {
    String? factKind,
    String? factDetail,
  }) {
    final CommunitySurvivalState survival =
        _state.communitySurvival ?? const CommunitySurvivalState();
    _replace(
      communitySurvival: survival.withResourceRequest(request),
      facts: factKind == null
          ? null
          : <WorldFact>[
              ..._state.facts,
              _fact(factKind, request.id, factDetail ?? ''),
            ],
    );
  }

  bool _personKnowsHouseholdProvides(
    PersonState person,
    String householdId,
    String resource,
  ) {
    for (final BeliefState belief in person.beliefs.values) {
      if (_beliefShowsHouseholdProvides(belief, householdId, resource)) {
        return true;
      }
    }
    return false;
  }

  void _applyCommunityResourceResponse(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String resource = event.payload['resource']! as String;
    final String? requestId = event.payload['request_id'] as String?;
    final CommunityResourceRequestState? request = _communityResourceRequest(
      requestId,
    );
    if (request == null || !request.active) return;
    final CommunityResourceRequestState seeking = request.advance(
      status: CommunityResourceRequestStatus.seeking,
      atSeconds: _state.now.seconds,
      countAttempt: true,
    );
    _saveCommunityResourceRequest(seeking);
    final HouseholdState? requester = _state.households[householdId];
    if (requester == null) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'requesting_household_missing',
        requestId: request.id,
      );
      return;
    }
    final HouseholdNeed? currentNeed = householdNeeds(householdId)
        .where((HouseholdNeed need) => need.kind == resource && need.needed)
        .firstOrNull;
    if (currentNeed == null) {
      _saveCommunityResourceRequest(
        seeking.advance(
          status: CommunityResourceRequestStatus.cancelled,
          atSeconds: _state.now.seconds,
        ),
        factKind: 'community_resource_response_cancelled',
        factDetail: 'resource=$resource reason=need_resolved_before_action',
      );
      return;
    }
    final bool alreadyTrading = _state.communityExchanges.values.any(
      (CommunityExchangeState exchange) =>
          exchange.status == CommunityExchangeStatus.traveling &&
          (exchange.firstHouseholdId == householdId ||
              exchange.secondHouseholdId == householdId),
    );
    if (alreadyTrading) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'household_already_has_goods_in_transit',
        requestId: request.id,
      );
      return;
    }
    final String? offerResource = _householdSpecialty(requester);
    if (offerResource == null || offerResource == resource) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'no_distinct_offer_resource',
      );
      return;
    }
    final String? offerItemId = requester.resourceItemIds[offerResource];
    final CareItemState? offerItem = offerItemId == null
        ? null
        : _state.items[offerItemId];
    if (offerItem == null) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'offer_ledger_missing',
      );
      return;
    }
    final int offerSurplus =
        offerItem.quantity - _dailyUse(offerResource, requester) * 2;
    if (offerSurplus <= 0) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'no_offer_surplus',
      );
      return;
    }
    final List<
      ({
        PersonState actor,
        PersonState contact,
        HouseholdState donor,
        int requesterScore,
        int donorWillingness,
        int donorResourceUrgency,
        bool accepted,
      })
    >
    choices =
        <
          ({
            PersonState actor,
            PersonState contact,
            HouseholdState donor,
            int requesterScore,
            int donorWillingness,
            int donorResourceUrgency,
            bool accepted,
          })
        >[];
    for (final String actorId in requester.memberIds) {
      final PersonState? actor = _state.people[actorId];
      if (actor == null ||
          actor.infancy != null ||
          _competingObligation(actor) != null ||
          !requester.canUse(actor.id, offerItem.id)) {
        continue;
      }
      for (final SocialRelationState relation in actor.socialRelations.values) {
        final PersonState? contact = _state.people[relation.otherPersonId];
        final HouseholdState? donor = contact?.householdId == null
            ? null
            : _state.households[contact!.householdId];
        if (contact == null ||
            donor == null ||
            donor.id == requester.id ||
            _competingObligation(contact) != null ||
            !_personKnowsHouseholdProvides(actor, donor.id, resource)) {
          continue;
        }
        final String? donorItemId = donor.resourceItemIds[resource];
        final CareItemState? donorItem = donorItemId == null
            ? null
            : _state.items[donorItemId];
        if (donorItem == null || !donor.canUse(contact.id, donorItem.id)) {
          continue;
        }
        final int donorSurplus =
            donorItem.quantity - _dailyUse(resource, donor) * 2;
        if (donorSurplus <= 0) continue;
        final SocialRelationState? reverseRelation =
            contact.socialRelations[actor.id];
        if (reverseRelation == null) continue;
        final int donorResourceUrgency =
            householdNeeds(donor.id)
                .where((HouseholdNeed need) => need.kind == resource)
                .map((HouseholdNeed need) => need.urgency)
                .firstOrNull ??
            100;
        final int offeredResourceUrgency =
            householdNeeds(donor.id)
                .where((HouseholdNeed need) => need.kind == offerResource)
                .map((HouseholdNeed need) => need.urgency)
                .firstOrNull ??
            0;
        final int donorWillingness =
            reverseRelation.tradeTrust * 2 +
            reverseRelation.goodwill +
            reverseRelation.familiarity -
            reverseRelation.resentment * 2 -
            donorResourceUrgency * 8 +
            offeredResourceUrgency * 4;
        final int score =
            relation.familiarity +
            relation.tradeTrust * 2 +
            relation.informationTrust +
            relation.goodwill -
            relation.resentment * 2;
        choices.add((
          actor: actor,
          contact: contact,
          donor: donor,
          requesterScore: score,
          donorWillingness: donorWillingness,
          donorResourceUrgency: donorResourceUrgency,
          accepted: donorWillingness >= 900,
        ));
      }
    }
    choices.sort((left, right) {
      final int byPreference = right.requesterScore.compareTo(
        left.requesterScore,
      );
      if (byPreference != 0) return byPreference;
      final int byActor = left.actor.id.compareTo(right.actor.id);
      return byActor != 0
          ? byActor
          : left.contact.id.compareTo(right.contact.id);
    });
    final choice = choices.firstOrNull;
    if (choice == null) {
      if (_scheduleCommunityResourceInquiry(
        requester: requester,
        requestedResource: resource,
        offerItem: offerItem,
        request: seeking,
      )) {
        return;
      }
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'no_known_contact_with_surplus',
        requestId: request.id,
      );
      return;
    }
    if (!choice.accepted) {
      _recordResourceAidRefusal(
        request: seeking,
        actor: choice.actor,
        contact: choice.contact,
        donor: choice.donor,
        resource: resource,
        urgency: currentNeed.urgency,
        donorResourceUrgency: choice.donorResourceUrgency,
        donorWillingness: choice.donorWillingness,
      );
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'known_contact_refused_to_risk_stock',
        requestId: request.id,
      );
      return;
    }
    if (!_departNeedDrivenExchange(
      requester: requester,
      donor: choice.donor,
      requesterActor: choice.actor,
      donorContact: choice.contact,
      requestedResource: resource,
      offerResource: offerResource,
      need: currentNeed,
      relationScore: choice.requesterScore,
      donorWillingness: choice.donorWillingness,
      resourceRequestId: request.id,
    )) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'departure_conditions_changed',
        requestId: request.id,
      );
    }
  }

  void _recordResourceAidRefusal({
    required CommunityResourceRequestState request,
    required PersonState actor,
    required PersonState contact,
    required HouseholdState donor,
    required String resource,
    required int urgency,
    required int donorResourceUrgency,
    required int donorWillingness,
  }) {
    final PersonState? currentActor = _state.people[actor.id];
    final SocialRelationState? relation =
        currentActor?.socialRelations[contact.id];
    if (currentActor == null || relation == null) return;
    final String interactionId =
        'resource-aid-refusal:${request.id}:${actor.id}:${contact.id}';
    final SocialRelationState remembered = relation.recordResourceAidRefused(
      interactionId: interactionId,
      atSeconds: _state.now.seconds,
      urgency: urgency,
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        actor.id: currentActor.withSocialRelation(contact.id, remembered),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'social_resource_aid_refused',
          actor.id,
          'request=${request.id} contact=${contact.id} donor=${donor.id} '
              'resource=$resource urgency=$urgency '
              'donor_urgency=$donorResourceUrgency '
              'willingness=$donorWillingness '
              'trade_trust=${remembered.tradeTrust} '
              'goodwill=${remembered.goodwill} '
              'resentment=${remembered.resentment}',
        ),
      ],
    );
    _saveCommunityResourceRequest(
      request.advance(
        status: CommunityResourceRequestStatus.seeking,
        atSeconds: _state.now.seconds,
        askerId: actor.id,
        providerHouseholdId: donor.id,
        providerContactId: contact.id,
      ),
    );
  }

  bool _scheduleCommunityResourceInquiry({
    required HouseholdState requester,
    required String requestedResource,
    required CareItemState offerItem,
    required CommunityResourceRequestState request,
  }) {
    final List<
      ({
        PersonState asker,
        PersonState intermediary,
        HouseholdState provider,
        PersonState providerContact,
        BeliefState answer,
        int score,
      })
    >
    possibilities =
        <
          ({
            PersonState asker,
            PersonState intermediary,
            HouseholdState provider,
            PersonState providerContact,
            BeliefState answer,
            int score,
          })
        >[];
    for (final String askerId in requester.memberIds) {
      final PersonState? asker = _state.people[askerId];
      if (asker == null ||
          asker.infancy != null ||
          _competingObligation(asker) != null ||
          !requester.canUse(asker.id, offerItem.id)) {
        continue;
      }
      for (final SocialRelationState relation in asker.socialRelations.values) {
        final PersonState? intermediary = _state.people[relation.otherPersonId];
        if (intermediary == null ||
            _competingObligation(intermediary) != null) {
          continue;
        }
        for (final BeliefState answer in intermediary.beliefs.values) {
          if (asker.beliefs.containsKey(answer.id)) continue;
          final String? providerId = _providerHouseholdFromBelief(
            answer,
            requestedResource,
          );
          final HouseholdState? provider = providerId == null
              ? null
              : _state.households[providerId];
          if (provider == null || provider.id == requester.id) continue;
          final CommunityExchangeState? knownExchange =
              _state.communityExchanges[answer.subjectId];
          if (knownExchange == null) continue;
          final String providerContactId =
              knownExchange.firstHouseholdId == provider.id
              ? knownExchange.firstCarrierId
              : knownExchange.secondCarrierId;
          final PersonState? providerContact = _state.people[providerContactId];
          if (providerContact == null ||
              providerContact.householdId != provider.id ||
              _competingObligation(providerContact) != null) {
            continue;
          }
          final bool providerIsIntermediaryHousehold =
              intermediary.householdId == provider.id;
          final SocialRelationState? referralRelation =
              intermediary.socialRelations[providerContact.id];
          if (!providerIsIntermediaryHousehold && referralRelation == null) {
            continue;
          }
          final String? providerItemId =
              provider.resourceItemIds[requestedResource];
          final CareItemState? providerItem = providerItemId == null
              ? null
              : _state.items[providerItemId];
          if (providerItem == null ||
              !provider.canUse(providerContact.id, providerItem.id) ||
              providerItem.quantity <=
                  _dailyUse(requestedResource, provider) * 2) {
            continue;
          }
          possibilities.add((
            asker: asker,
            intermediary: intermediary,
            provider: provider,
            providerContact: providerContact,
            answer: answer,
            score:
                relation.informationTrust * 2 +
                relation.familiarity +
                relation.goodwill -
                relation.resentment * 2 +
                answer.confidence +
                (referralRelation?.familiarity ?? 0),
          ));
        }
      }
    }
    possibilities.sort((left, right) {
      final int byScore = right.score.compareTo(left.score);
      if (byScore != 0) return byScore;
      final int byAsker = left.asker.id.compareTo(right.asker.id);
      if (byAsker != 0) return byAsker;
      final int byIntermediary = left.intermediary.id.compareTo(
        right.intermediary.id,
      );
      if (byIntermediary != 0) return byIntermediary;
      final int byProvider = left.provider.id.compareTo(right.provider.id);
      if (byProvider != 0) return byProvider;
      final int byProviderContact = left.providerContact.id.compareTo(
        right.providerContact.id,
      );
      return byProviderContact != 0
          ? byProviderContact
          : left.answer.id.compareTo(right.answer.id);
    });
    if (possibilities.isEmpty) return false;
    final possibility = possibilities.first;
    final RoomState? askerRoom = possibility.asker.roomId == null
        ? null
        : _state.rooms[possibility.asker.roomId];
    final RoomState? intermediaryRoom = possibility.intermediary.roomId == null
        ? null
        : _state.rooms[possibility.intermediary.roomId];
    if (askerRoom == null || intermediaryRoom == null) return false;
    final int distanceMm =
        WorldPoint(
          askerRoom.anchorPositionMm,
          askerRoom.anchorPositionYMm,
        ).distanceTo(
          WorldPoint(
            intermediaryRoom.anchorPositionMm,
            intermediaryRoom.anchorPositionYMm,
          ),
        );
    final int speed =
        possibility.asker.caregiverAgent?.movementSpeedMmPerSecond ?? 1000;
    final int travelSeconds = (distanceMm ~/ speed.clamp(1, 1000000)).clamp(
      10 * 60,
      12 * 3600,
    );
    final String commitmentId = 'INQUIRY-${request.id}';
    if (!_beginPersonalCommitments(
      personIds: <String>[possibility.asker.id],
      commitmentId: commitmentId,
      kind: 'resource_inquiry',
      activity: 'đang đi hỏi nguồn hàng',
      endsAtSeconds: _state.now.seconds + travelSeconds,
      relatedId: request.id,
    )) {
      return false;
    }
    schedule(
      due: _state.now.addSeconds(travelSeconds),
      phase: EventPhase.observation,
      kind: 'community_resource_inquiry_answered',
      payload: <String, Object?>{
        'household_id': requester.id,
        'resource': requestedResource,
        'asker_id': possibility.asker.id,
        'intermediary_id': possibility.intermediary.id,
        'belief_id': possibility.answer.id,
        'provider_household_id': possibility.provider.id,
        'provider_contact_id': possibility.providerContact.id,
        'request_id': request.id,
        'commitment_id': commitmentId,
      },
    );
    _saveCommunityResourceRequest(
      request.advance(
        status: CommunityResourceRequestStatus.inquiring,
        atSeconds: _state.now.seconds,
        askerId: possibility.asker.id,
        intermediaryId: possibility.intermediary.id,
        providerHouseholdId: possibility.provider.id,
        providerContactId: possibility.providerContact.id,
      ),
    );
    _replace(
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_resource_inquiry_started',
          requester.id,
          'resource=$requestedResource asker=${possibility.asker.id} '
              'intermediary=${possibility.intermediary.id} '
              'provider=${possibility.provider.id} '
              'travel_seconds=$travelSeconds',
        ),
      ],
    );
    return true;
  }

  String? _providerHouseholdFromBelief(BeliefState belief, String resource) {
    if (belief.topic != 'community_exchange') return null;
    final CommunityExchangeState? known =
        _state.communityExchanges[belief.subjectId];
    if (known == null) return null;
    if (known.firstResource == resource) return known.firstHouseholdId;
    if (known.secondResource == resource) return known.secondHouseholdId;
    return null;
  }

  bool _beliefShowsHouseholdProvides(
    BeliefState belief,
    String householdId,
    String resource,
  ) {
    return _providerHouseholdFromBelief(belief, resource) == householdId;
  }

  void _applyCommunityResourceInquiryAnswered(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String resource = event.payload['resource']! as String;
    final String askerId = event.payload['asker_id']! as String;
    final String intermediaryId = event.payload['intermediary_id']! as String;
    final String beliefId = event.payload['belief_id']! as String;
    final String providerHouseholdId =
        event.payload['provider_household_id']! as String;
    final String providerContactId =
        event.payload['provider_contact_id']! as String;
    final String requestId = event.payload['request_id']! as String;
    _endPersonalCommitments(<String>[
      askerId,
    ], event.payload['commitment_id'] as String? ?? 'INQUIRY-$requestId');
    final CommunityResourceRequestState? request = _communityResourceRequest(
      requestId,
    );
    if (request == null || !request.active) return;
    final PersonState? asker = _state.people[askerId];
    final PersonState? intermediary = _state.people[intermediaryId];
    final PersonState? providerContact = _state.people[providerContactId];
    final BeliefState? answer = intermediary?.beliefs[beliefId];
    if (asker == null ||
        intermediary == null ||
        providerContact == null ||
        answer == null) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'inquiry_contact_or_memory_lost',
      );
      return;
    }
    if (asker.householdId != householdId ||
        providerContact.householdId != providerHouseholdId ||
        !_beliefShowsHouseholdProvides(answer, providerHouseholdId, resource)) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'inquiry_answer_no_longer_matches_need',
      );
      return;
    }
    if (providerHouseholdId != intermediary.householdId &&
        !intermediary.socialRelations.containsKey(providerContactId)) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'intermediary_no_longer_knows_provider_contact',
      );
      return;
    }
    final SocialRelationState? askerRelation =
        asker.socialRelations[intermediaryId];
    final SocialRelationState? intermediaryRelation =
        intermediary.socialRelations[askerId];
    if (askerRelation == null || intermediaryRelation == null) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'inquiry_relationship_lost',
      );
      return;
    }
    final String encounterId =
        'resource-inquiry:${event.id}:$askerId:$intermediaryId';
    final BeliefState relayed = answer.relayedBy(
      speakerId: intermediaryId,
      learnedAtSeconds: _state.now.seconds,
    );
    PersonState nextAsker = asker.learn(relayed);
    final SocialRelationState nextAskerRelation = askerRelation
        .recordEncounter(
          interactionId: '$encounterId:encounter',
          atSeconds: _state.now.seconds,
        )
        .recordInformationReceived(
          interactionId: '$encounterId:answer:${answer.originEvidenceId}',
          atSeconds: _state.now.seconds,
          confidence: relayed.confidence,
        );
    nextAsker = nextAsker.withSocialRelation(intermediaryId, nextAskerRelation);
    final PersonState nextIntermediary = intermediary.withSocialRelation(
      askerId,
      intermediaryRelation.recordEncounter(
        interactionId: '$encounterId:encounter',
        atSeconds: _state.now.seconds,
      ),
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        askerId: nextAsker,
        intermediaryId: nextIntermediary,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_resource_inquiry_answered',
          householdId,
          'resource=$resource asker=$askerId '
              'intermediary=$intermediaryId '
              'provider_household=$providerHouseholdId '
              'provider_contact=$providerContactId '
              'confidence=${relayed.confidence} '
              'origin=${answer.originPersonId}',
        ),
      ],
    );
    if (nextAsker.socialRelations.containsKey(providerContactId)) {
      _saveCommunityResourceRequest(
        request.advance(
          status: CommunityResourceRequestStatus.negotiating,
          atSeconds: _state.now.seconds,
          askerId: askerId,
          intermediaryId: intermediaryId,
          providerHouseholdId: providerHouseholdId,
          providerContactId: providerContactId,
        ),
      );
      schedule(
        due: _state.now.addSeconds(10 * 60),
        phase: EventPhase.intent,
        kind: 'community_resource_response',
        payload: <String, Object?>{
          'household_id': householdId,
          'resource': resource,
          'retry_after_inquiry': true,
          'request_id': requestId,
        },
      );
      return;
    }
    final RoomState? intermediaryRoom = intermediary.roomId == null
        ? null
        : _state.rooms[intermediary.roomId];
    final RoomState? providerRoom = providerContact.roomId == null
        ? null
        : _state.rooms[providerContact.roomId];
    if (intermediaryRoom == null || providerRoom == null) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'introduction_route_missing',
      );
      return;
    }
    final int distanceMm =
        WorldPoint(
          intermediaryRoom.anchorPositionMm,
          intermediaryRoom.anchorPositionYMm,
        ).distanceTo(
          WorldPoint(
            providerRoom.anchorPositionMm,
            providerRoom.anchorPositionYMm,
          ),
        );
    final int askerSpeed =
        asker.caregiverAgent?.movementSpeedMmPerSecond ?? 1000;
    final int intermediarySpeed =
        intermediary.caregiverAgent?.movementSpeedMmPerSecond ?? 1000;
    final int slowestSpeed = askerSpeed < intermediarySpeed
        ? askerSpeed
        : intermediarySpeed;
    final int travelSeconds = (distanceMm ~/ slowestSpeed.clamp(1, 1000000))
        .clamp(10 * 60, 12 * 3600);
    final String commitmentId = 'INTRODUCTION-$requestId';
    if (!_beginPersonalCommitments(
      personIds: <String>[askerId, intermediaryId],
      commitmentId: commitmentId,
      kind: 'resource_introduction',
      activity: 'đang đi gặp người của hộ nguồn',
      endsAtSeconds: _state.now.seconds + travelSeconds,
      relatedId: requestId,
    )) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'introduction_participant_became_busy',
        requestId: requestId,
      );
      return;
    }
    schedule(
      due: _state.now.addSeconds(travelSeconds),
      phase: EventPhase.observation,
      kind: 'community_resource_introduction_arrived',
      payload: <String, Object?>{
        'household_id': householdId,
        'resource': resource,
        'asker_id': askerId,
        'intermediary_id': intermediaryId,
        'provider_household_id': providerHouseholdId,
        'provider_contact_id': providerContactId,
        'source_belief_id': beliefId,
        'request_id': requestId,
        'commitment_id': commitmentId,
      },
    );
    _saveCommunityResourceRequest(
      request.advance(
        status: CommunityResourceRequestStatus.introductionTravel,
        atSeconds: _state.now.seconds,
        askerId: askerId,
        intermediaryId: intermediaryId,
        providerHouseholdId: providerHouseholdId,
        providerContactId: providerContactId,
      ),
    );
    _replace(
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_resource_introduction_started',
          householdId,
          'resource=$resource asker=$askerId '
              'intermediary=$intermediaryId '
              'provider_contact=$providerContactId '
              'provider_household=$providerHouseholdId '
              'travel_seconds=$travelSeconds',
        ),
      ],
    );
  }

  void _applyCommunityResourceIntroductionArrived(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String resource = event.payload['resource']! as String;
    final String askerId = event.payload['asker_id']! as String;
    final String intermediaryId = event.payload['intermediary_id']! as String;
    final String providerHouseholdId =
        event.payload['provider_household_id']! as String;
    final String providerContactId =
        event.payload['provider_contact_id']! as String;
    final String requestId = event.payload['request_id']! as String;
    _endPersonalCommitments(<String>[
      askerId,
      intermediaryId,
    ], event.payload['commitment_id'] as String? ?? 'INTRODUCTION-$requestId');
    final CommunityResourceRequestState? request = _communityResourceRequest(
      requestId,
    );
    if (request == null || !request.active) return;
    final PersonState? asker = _state.people[askerId];
    final PersonState? intermediary = _state.people[intermediaryId];
    final PersonState? providerContact = _state.people[providerContactId];
    if (asker == null || intermediary == null || providerContact == null) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'introduction_participant_missing',
      );
      return;
    }
    if (asker.householdId != householdId ||
        providerContact.householdId != providerHouseholdId ||
        !intermediary.socialRelations.containsKey(providerContactId)) {
      _recordCommunityResourceResponseFailure(
        householdId,
        resource,
        'introduction_connection_broken',
      );
      return;
    }
    final String interactionId =
        'introduction:${event.id}:$askerId:$providerContactId';
    final SocialRelationState askerToProvider =
        (asker.socialRelations[providerContactId] ??
                SocialRelationState(otherPersonId: providerContactId))
            .recordEncounter(
              interactionId: interactionId,
              atSeconds: _state.now.seconds,
            );
    final SocialRelationState providerToAsker =
        (providerContact.socialRelations[askerId] ??
                SocialRelationState(otherPersonId: askerId))
            .recordEncounter(
              interactionId: interactionId,
              atSeconds: _state.now.seconds,
            );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        askerId: asker.withSocialRelation(providerContactId, askerToProvider),
        providerContactId: providerContact.withSocialRelation(
          askerId,
          providerToAsker,
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_resource_introduction_arrived',
          householdId,
          'resource=$resource asker=$askerId '
              'intermediary=$intermediaryId '
              'provider_contact=$providerContactId '
              'provider_household=$providerHouseholdId',
        ),
      ],
    );
    final bool stillNeeded = householdNeeds(
      householdId,
    ).any((HouseholdNeed need) => need.kind == resource && need.needed);
    if (stillNeeded) {
      _saveCommunityResourceRequest(
        request.advance(
          status: CommunityResourceRequestStatus.negotiating,
          atSeconds: _state.now.seconds,
          askerId: askerId,
          intermediaryId: intermediaryId,
          providerHouseholdId: providerHouseholdId,
          providerContactId: providerContactId,
        ),
      );
      schedule(
        due: _state.now.addSeconds(10 * 60),
        phase: EventPhase.intent,
        kind: 'community_resource_response',
        payload: <String, Object?>{
          'household_id': householdId,
          'resource': resource,
          'retry_after_introduction': true,
          'request_id': requestId,
        },
      );
    } else {
      _saveCommunityResourceRequest(
        request.advance(
          status: CommunityResourceRequestStatus.cancelled,
          atSeconds: _state.now.seconds,
        ),
        factKind: 'community_resource_response_cancelled',
        factDetail: 'resource=$resource reason=need_resolved_during_trip',
      );
    }
  }

  void _recordCommunityResourceResponseFailure(
    String householdId,
    String resource,
    String reason, {
    String? requestId,
  }) {
    CommunityResourceRequestState? request = _communityResourceRequest(
      requestId,
    );
    request ??= _state.communitySurvival?.resourceRequests.values
        .where(
          (CommunityResourceRequestState value) =>
              value.active &&
              value.householdId == householdId &&
              value.resource == resource,
        )
        .firstOrNull;
    if (request != null) {
      _saveCommunityResourceRequest(
        request.fail(
          atSeconds: _state.now.seconds,
          reason: reason,
          retryAfterSeconds: 2 * gameSecondsPerDay,
        ),
        factKind: 'community_resource_response_failed',
        factDetail: 'resource=$resource reason=$reason retry_days=2',
      );
      return;
    }
    _replace(
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'community_resource_response_failed',
          householdId,
          'resource=$resource reason=$reason request_missing=true',
        ),
      ],
    );
  }

  void _applyHouseholdPlanning(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final HouseholdState? household = _state.households[householdId];
    if (household == null) return;
    final int day = _state.now.day;
    final SimTime tomorrow = event.due.addDays(1);
    if (tomorrow.seconds < 30 * gameSecondsPerDay) {
      schedule(
        due: tomorrow,
        phase: EventPhase.intent,
        kind: 'household_planning',
        payload: event.payload,
      );
    }
    // Một đêm ngủ trước khi tính việc hôm nay.
    final Map<String, PersonState> rested = <String, PersonState>{
      ..._state.people,
    };
    bool anyRest = false;
    for (final String memberId in household.memberIds) {
      final PersonState? member = rested[memberId];
      final PersonAgenda? agenda = member?.agenda;
      if (member == null || agenda == null) continue;
      rested[memberId] = member.withAgenda(agenda.rest());
      anyRest = true;
    }
    if (anyRest) _replace(people: rested);
    final List<HouseholdNeed> needs = householdNeeds(
      householdId,
    ).where((HouseholdNeed need) => need.needed).toList();
    // Xóa kế hoạch hôm trước trước khi lập kế hoạch mới.
    final Map<String, PersonState> people = <String, PersonState>{
      ..._state.people,
    };
    final Map<String, List<RoutineBlock>> planned =
        <String, List<RoutineBlock>>{};
    for (final String memberId in household.memberIds) {
      final PersonState? member = people[memberId];
      if (member?.routine == null) continue;
      planned[memberId] = <RoutineBlock>[];
    }
    final List<String> lines = <String>[];
    for (final HouseholdNeed need in needs) {
      final (String, int, int, String)? work =
          _workByResource[need.resourceKey];
      if (work == null) continue;
      final String? itemId = household.resourceItemIds[need.resourceKey];
      if (itemId == null) continue;
      final String skillCode = _skillByResource[need.resourceKey] ?? '';
      final (String, PersonAgenda?)? offer = _offerWork(
        household: household,
        itemId: itemId,
        skillCode: skillCode,
        priority: need.priority,
        planned: planned,
      );
      final String? assignee = offer?.$1;
      if (assignee == null) {
        lines.add('${need.kind}:khong-co-nguoi');
        _replace(
          facts: <WorldFact>[
            ..._state.facts,
            _fact(
              'household_need_unstaffed',
              householdId,
              'need=${need.kind} days=${need.daysOfSupply} '
                  'urgency=${need.urgency} skill=$skillCode',
            ),
          ],
        );
        continue;
      }
      final int? startSecond = _freeSlot(
        person: people[assignee]!,
        planned: planned[assignee]!,
        durationSeconds: work.$2,
        priority: need.priority,
      );
      if (startSecond == null) {
        lines.add('${need.kind}:khong-con-gio');
        _replace(
          facts: <WorldFact>[
            ..._state.facts,
            _fact(
              'household_need_unscheduled',
              householdId,
              'need=${need.kind} actor=$assignee urgency=${need.urgency}',
            ),
          ],
        );
        continue;
      }
      final PersonState worker = _state.people[assignee]!;
      final String? workRoomId = _workRoomForHousehold(household, work.$4);
      final RoutineBlock block = RoutineBlock(
        id: 'GEN-${need.kind.toUpperCase()}-D$day',
        activity: work.$1,
        startSecondOfDay: startSecond,
        durationSeconds: work.$2,
        roomId: workRoomId,
        priority: need.priority,
        needKind: need.kind,
        outputResource: need.resourceKey,
        outputAmount: _plannedOutput(worker, skillCode, work.$3),
        planDay: day,
      );
      planned[assignee]!.add(block);
      if (offer!.$2 case final PersonAgenda accepted) {
        people[assignee] = worker.withAgenda(accepted);
        _replace(
          people: <String, PersonState>{
            ..._state.people,
            assignee: worker.withAgenda(accepted),
          },
        );
      }
      lines.add(
        '${need.kind}:$assignee@${startSecond ~/ 3600}h/p${need.priority}',
      );
    }
    for (final MapEntry<String, List<RoutineBlock>> entry in planned.entries) {
      final PersonState? member = _state.people[entry.key];
      final RoutineState? routine = member?.routine;
      if (member == null || routine == null) continue;
      people[entry.key] = member.withRoutine(
        routine.withGeneratedBlocks(entry.value),
      );
    }
    _replace(
      people: people,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'household_plan_made',
          householdId,
          'day=$day needs=${needs.length} '
              'plan=${lines.isEmpty ? 'khong-co-viec' : lines.join(',')}',
        ),
      ],
    );
    for (final MapEntry<String, List<RoutineBlock>> entry in planned.entries) {
      for (final RoutineBlock block in entry.value) {
        final int due =
            (_state.now.seconds ~/ gameSecondsPerDay) * gameSecondsPerDay +
            block.startSecondOfDay;
        if (due < _state.now.seconds) continue;
        schedule(
          due: SimTime(due),
          phase: EventPhase.intent,
          kind: 'routine_block_started',
          payload: <String, Object?>{
            'person_id': entry.key,
            'block_id': block.id,
          },
        );
      }
    }
  }

  /// Sản lượng dự kiến của một khối việc: tay nghề nhân với sức làm việc.
  ///
  /// Người sụt cân vì đói làm ra ít hơn dù tay nghề không đổi.
  int _plannedOutput(PersonState worker, String skillCode, int base) {
    final int bySkill = worker.skills?.output(skillCode, base) ?? base;
    if (worker.body == null) return bySkill;
    final int capability = _effectiveCapability(worker);
    if (capability >= 1000) return bySkill;
    return bySkill * capability ~/ 1000;
  }

  /// Chào việc lần lượt cho người đủ quyền và đủ tay nghề, theo thứ tự
  /// tay nghề cao trước rồi tới người còn rảnh hơn.
  ///
  /// Người có hồ sơ riêng được quyền từ chối khi đang quá mệt so với mức gấp
  /// của việc; khi đó việc được chào cho người tiếp theo.
  (String, PersonAgenda?)? _offerWork({
    required HouseholdState household,
    required String itemId,
    required String skillCode,
    required int priority,
    required Map<String, List<RoutineBlock>> planned,
  }) {
    final List<String> candidates =
        planned.keys.where((String personId) {
          final PersonState? person = _state.people[personId];
          if (person == null || person.infancy != null) return false;
          if (person.caregiverAgent?.available == false) return false;
          if (!household.canUse(personId, itemId)) return false;
          final PersonSkills? skills = person.skills;
          if (skills == null) return true;
          return skills.level(skillCode) >= _minimumWorkSkill;
        }).toList()..sort((String a, String b) {
          final PersonState left = _state.people[a]!;
          final PersonState right = _state.people[b]!;
          final int bySkill = (right.skills?.level(skillCode) ?? 0).compareTo(
            left.skills?.level(skillCode) ?? 0,
          );
          if (bySkill != 0) return bySkill;
          final int loadA = planned[a]!.fold(
            0,
            (int total, RoutineBlock block) => total + block.durationSeconds,
          );
          final int loadB = planned[b]!.fold(
            0,
            (int total, RoutineBlock block) => total + block.durationSeconds,
          );
          final int byLoad = loadA.compareTo(loadB);
          return byLoad != 0 ? byLoad : a.compareTo(b);
        });
    for (final String personId in candidates) {
      final PersonState person = _state.people[personId]!;
      final PersonAgenda? agenda = person.agenda;
      if (agenda == null) return (personId, null);
      // Người đang ốm càng nặng thì càng khó nhận việc.
      final IllnessState? sick = _activeIllness(personId);
      final int floor =
          agenda.acceptanceFloor + (sick == null ? 0 : sick.severity ~/ 10);
      if (priority >= floor) {
        return (personId, agenda.recordOffer(accepted: true));
      }
      // Hộ có theo dõi đói/tâm trạng thì lý do nói rõ cả ba trục.
      final String reason = household.wellbeing
          ? '${agenda.mainStrain} (mệt ${agenda.fatigue}, đói ${agenda.hunger}, '
                'tâm trạng ${agenda.mood}), chỉ nhận việc từ mức '
                '${agenda.acceptanceFloor}'
          : 'mệt ${agenda.fatigue}/1000, chỉ nhận việc từ mức '
                '${agenda.acceptanceFloor}';
      final String sickNote = sick == null
          ? ''
          : ' illness=${sick.kind} severity=${sick.severity}';
      _replace(
        people: <String, PersonState>{
          ..._state.people,
          personId: person.withAgenda(
            agenda.recordOffer(accepted: false, reason: reason),
          ),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'work_offer_refused',
            personId,
            'skill=$skillCode priority=$priority fatigue=${agenda.fatigue} '
                '${household.wellbeing ? 'hunger=${agenda.hunger} mood=${agenda.mood} ' : ''}'
                'floor=$floor'
                '${household.wellbeing ? ' strain=${agenda.mainStrain}' : ''}'
                '$sickNote',
          ),
        ],
      );
    }
    return null;
  }

  /// Giờ trống sớm nhất trong ngày.
  ///
  /// Khối cố định có ưu tiên thấp hơn việc đang xếp không được coi là vướng:
  /// việc gấp hơn được phép đè lên, và lúc chạy sẽ giành chỗ qua [RoutineState.outrank].
  /// Việc đã xếp trong cùng kế hoạch thì luôn là vướng, không tự chồng lên nhau.
  int? _freeSlot({
    required PersonState person,
    required List<RoutineBlock> planned,
    required int durationSeconds,
    required int priority,
    int earliest = 6 * 3600,
  }) {
    const int latest = 20 * 3600;
    final List<RoutineBlock> taken = <RoutineBlock>[
      ...person.routine!.fixedBlocks.where(
        (RoutineBlock block) => block.priority >= priority,
      ),
      ...planned,
    ];
    final int from = ((earliest + 1799) ~/ 1800) * 1800;
    for (int start = from; start + durationSeconds <= latest; start += 1800) {
      final RoutineBlock probe = RoutineBlock(
        id: 'probe',
        activity: 'probe',
        startSecondOfDay: start,
        durationSeconds: durationSeconds,
      );
      if (taken.every((RoutineBlock block) => !block.overlaps(probe))) {
        return start;
      }
    }
    return null;
  }

  void _applyRoutineBlockStarted(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String blockId = event.payload['block_id']! as String;
    final int attempt = event.payload['attempt'] as int? ?? 0;
    final PersonState? person = _state.people[personId];
    final RoutineState? routine = person?.routine;
    final RoutineBlock? block = routine?.blockById(blockId);
    if (person == null || routine == null || block == null) return;
    // Khối do kế hoạch sinh ra chỉ có hiệu lực trong ngày đã lập.
    if (block.planDay != null && block.planDay != _state.now.day) return;
    if (attempt == 0 && block.planDay == null) {
      final SimTime tomorrow = event.due.addDays(1);
      if (tomorrow.seconds < 30 * gameSecondsPerDay) {
        schedule(
          due: tomorrow,
          phase: EventPhase.intent,
          kind: 'routine_block_started',
          payload: <String, Object?>{
            'person_id': personId,
            'block_id': blockId,
          },
        );
      }
    }
    final String? competing = _competingObligation(person);
    if (competing != null) {
      _deferOrDropBlock(
        personId: personId,
        blockId: blockId,
        block: block,
        attempt: attempt,
        competing: competing,
      );
      return;
    }
    // Một khối khác đang chạy: phân xử bằng ưu tiên thay vì ghi đè im lặng.
    RoutineState working = routine;
    final RoutineBlock? active = routine.activeBlock;
    if (active != null && active.id != blockId) {
      final int plannedEnd =
          routine.activePlannedEndSeconds ?? _state.now.seconds;
      if (plannedEnd <= _state.now.seconds) {
        // Khối cũ đã hết giờ, đóng bình thường rồi mới sang khối mới.
        working = _finishBlock(personId, routine, active);
      } else if (block.priority > active.priority) {
        working = working.outrank(
          nowSeconds: _state.now.seconds,
          byActivity: block.activity,
          lostSeconds: plannedEnd - _state.now.seconds,
        );
        _replace(
          facts: <WorldFact>[
            ..._state.facts,
            _fact(
              'routine_block_outranked',
              personId,
              'block=${active.id} priority=${active.priority} '
                  'by=$blockId priority=${block.priority}',
            ),
          ],
        );
      } else {
        _deferOrDropBlock(
          personId: personId,
          blockId: blockId,
          block: block,
          attempt: attempt,
          competing: active.activity,
        );
        return;
      }
    }
    final int today =
        (_state.now.seconds ~/ gameSecondsPerDay) * gameSecondsPerDay;
    final int plannedEnd = today + block.endSecondOfDay;
    // Đọc lại người sau bước đóng khối cũ: mệt mỏi và tay nghề vừa được
    // cập nhật ở đó, không được dùng bản chụp cũ mà ghi đè mất.
    final PersonState current = _state.people[personId] ?? person;
    PersonState next = current.withRoutine(
      working.startBlock(
        blockId: blockId,
        nowSeconds: _state.now.seconds,
        plannedEndSeconds: plannedEnd > _state.now.seconds
            ? plannedEnd
            : _state.now.seconds + 60,
      ),
    );
    final RoomState? room = block.roomId == null
        ? null
        : _state.rooms[block.roomId];
    if (room != null) {
      next = next.withLocation(
        positionMm: room.anchorPositionMm,
        roomId: room.id,
      );
    }
    if (current.caregiverAgent != null) {
      next = next.withCaregiverAgent(
        current.caregiverAgent!.withActivity(block.activity),
      );
    }
    _replace(
      people: <String, PersonState>{..._state.people, personId: next},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'routine_block_started',
          personId,
          'block=$blockId activity=${block.activity} '
              'room=${block.roomId ?? 'unspecified'}'
              '${block.needKind != null ? ' need=${block.needKind}' : ''}'
              '${attempt > 0 ? ' late_attempt=$attempt' : ''}',
        ),
      ],
    );
    schedule(
      due: SimTime(
        plannedEnd > _state.now.seconds ? plannedEnd : _state.now.seconds + 60,
      ),
      phase: EventPhase.completion,
      kind: 'routine_block_ended',
      payload: <String, Object?>{'person_id': personId, 'block_id': blockId},
    );
  }

  void _deferOrDropBlock({
    required String personId,
    required String blockId,
    required RoutineBlock block,
    required int attempt,
    required String competing,
  }) {
    final PersonState person = _state.people[personId]!;
    final RoutineState routine = person.routine!;
    final bool canDefer = attempt < _routineMaxDeferrals;
    if (!canDefer &&
        !block.generated &&
        competing.startsWith('nghỉ vì ốm') &&
        _reassignSickWorkerBlock(personId, block)) {
      return;
    }
    if (!canDefer && _rescheduleBlock(personId, block)) return;
    final RoutineState next = canDefer
        ? routine.deferStart(
            nowSeconds: _state.now.seconds,
            blockId: blockId,
            competingActivity: competing,
          )
        : routine.dropStart(
            nowSeconds: _state.now.seconds,
            blockId: blockId,
            competingActivity: competing,
          );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: person.withRoutine(next),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          canDefer ? 'routine_block_deferred' : 'routine_block_dropped',
          personId,
          'block=$blockId planned=${block.activity} competing=$competing',
        ),
      ],
    );
    if (canDefer) {
      schedule(
        due: _state.now.addSeconds(_routineDeferSeconds),
        phase: EventPhase.intent,
        kind: 'routine_block_started',
        payload: <String, Object?>{
          'person_id': personId,
          'block_id': blockId,
          'attempt': attempt + 1,
        },
      );
    }
  }

  /// Chuyển một ca cố định của người đang nghỉ bệnh cho thành viên cùng hộ.
  ///
  /// Người nhận phải đang khỏe, có lịch, có quyền dùng kho đích, đủ tay nghề
  /// và còn một khoảng trống trong ngày. Hồ sơ cá nhân vẫn có quyền từ chối
  /// nếu mức ưu tiên của ca thấp hơn ngưỡng họ chấp nhận.
  bool _reassignSickWorkerBlock(String originalId, RoutineBlock block) {
    final PersonState? original = _state.people[originalId];
    final String? householdId = original?.householdId;
    final HouseholdState? household = householdId == null
        ? null
        : _state.households[householdId];
    if (original == null || household == null || !household.workSubstitution) {
      return false;
    }

    final String? itemId = block.outputResource == null
        ? null
        : household.resourceItemIds[block.outputResource];
    final String? skillCode =
        block.requiredSkill ??
        (block.needKind == null ? null : _skillByResource[block.needKind]);
    final List<String> candidates =
        household.memberIds.where((String id) {
          if (id == originalId) return false;
          final PersonState? person = _state.people[id];
          if (person == null ||
              person.infancy != null ||
              person.routine == null) {
            return false;
          }
          if (_competingObligation(person) != null) return false;
          if (itemId == null && block.outputResource != null) return false;
          if (itemId != null && !household.canUse(id, itemId)) return false;
          if (skillCode != null &&
              (person.skills?.level(skillCode) ?? 0) < _minimumWorkSkill) {
            return false;
          }
          return true;
        }).toList()..sort((String leftId, String rightId) {
          final PersonState left = _state.people[leftId]!;
          final PersonState right = _state.people[rightId]!;
          final int bySkill = (right.skills?.level(skillCode ?? '') ?? 0)
              .compareTo(left.skills?.level(skillCode ?? '') ?? 0);
          return bySkill != 0 ? bySkill : leftId.compareTo(rightId);
        });

    final int day = _state.now.day;
    final int secondOfDay = _state.now.seconds % gameSecondsPerDay;
    for (final String candidateId in candidates) {
      PersonState candidate = _state.people[candidateId]!;
      final PersonAgenda? agenda = candidate.agenda;
      if (agenda != null && block.priority < agenda.acceptanceFloor) {
        final String reason =
            'mệt ${agenda.fatigue}/1000, chỉ nhận việc từ mức '
            '${agenda.acceptanceFloor}; ca gánh thay mức ${block.priority}';
        _replace(
          people: <String, PersonState>{
            ..._state.people,
            candidateId: candidate.withAgenda(
              agenda.recordOffer(accepted: false, reason: reason),
            ),
          },
          facts: <WorldFact>[
            ..._state.facts,
            _fact(
              'work_substitution_refused',
              candidateId,
              'original=$originalId block=${block.id} '
                  'priority=${block.priority} floor=${agenda.acceptanceFloor}',
            ),
          ],
        );
        continue;
      }
      candidate = _state.people[candidateId]!;
      final RoutineState candidateRoutine = candidate.routine!;
      final int? slot = _freeSlot(
        person: candidate,
        planned: candidateRoutine.generatedBlocks,
        durationSeconds: block.durationSeconds,
        priority: block.priority,
        earliest: secondOfDay + 1800,
      );
      if (slot == null) continue;

      final RoutineBlock cover = RoutineBlock(
        id: 'COVER-${block.id}-BY-$candidateId-D$day',
        activity: block.activity,
        startSecondOfDay: slot,
        durationSeconds: block.durationSeconds,
        roomId: block.roomId,
        priority: block.priority,
        blocking: block.blocking,
        needKind: block.needKind,
        requiredSkill: block.requiredSkill,
        outputResource: block.outputResource,
        outputAmount: block.outputAmount,
        planDay: day,
      );
      final PersonState currentOriginal = _state.people[originalId]!;
      final RoutineState originalRoutine = currentOriginal.routine!;
      PersonState nextCandidate = candidate.withRoutine(
        candidateRoutine.withGeneratedBlocks(<RoutineBlock>[
          ...candidateRoutine.generatedBlocks,
          cover,
        ]),
      );
      if (agenda != null) {
        nextCandidate = nextCandidate.withAgenda(
          agenda.recordOffer(accepted: true),
        );
      }
      _replace(
        people: <String, PersonState>{
          ..._state.people,
          originalId: currentOriginal.withRoutine(
            originalRoutine.dropStart(
              nowSeconds: _state.now.seconds,
              blockId: block.id,
              competingActivity: 'đã chuyển cho $candidateId vì nghỉ bệnh',
            ),
          ),
          candidateId: nextCandidate,
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'routine_block_reassigned',
            originalId,
            'block=${block.id} substitute=$candidateId '
                'start=$slot duration=${block.durationSeconds} '
                'activity=${block.activity}',
          ),
        ],
      );
      schedule(
        due: SimTime(day * gameSecondsPerDay + slot),
        phase: EventPhase.intent,
        kind: 'routine_block_started',
        payload: <String, Object?>{
          'person_id': candidateId,
          'block_id': cover.id,
        },
      );
      return true;
    }

    _replace(
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'routine_block_reassignment_failed',
          originalId,
          'block=${block.id} candidates=${candidates.length}',
        ),
      ],
    );
    return false;
  }

  /// Xếp lại một khối đã lùi hết lượt vào giờ trống còn lại trong ngày.
  ///
  /// Bản xếp lại là một khối riêng chỉ sống trong ngày hôm đó, nên bảng giờ
  /// gốc không bị sửa. Bản đã xếp lại thì không xếp lại lần nữa.
  bool _rescheduleBlock(String personId, RoutineBlock block) {
    if (block.id.startsWith('RESCHED-')) return false;
    final PersonState? person = _state.people[personId];
    final RoutineState? routine = person?.routine;
    if (person == null || routine == null) return false;
    final int day = _state.now.day;
    final int secondOfDay = _state.now.seconds % gameSecondsPerDay;
    final int? slot = _freeSlot(
      person: person,
      planned: routine.generatedBlocks
          .where((RoutineBlock value) => value.id != block.id)
          .toList(),
      durationSeconds: block.durationSeconds,
      priority: block.priority,
      earliest: secondOfDay + 1800,
    );
    if (slot == null) return false;
    final RoutineBlock moved = RoutineBlock(
      id: 'RESCHED-${block.id}-D$day',
      activity: block.activity,
      startSecondOfDay: slot,
      durationSeconds: block.durationSeconds,
      roomId: block.roomId,
      priority: block.priority,
      blocking: block.blocking,
      needKind: block.needKind,
      requiredSkill: block.requiredSkill,
      outputResource: block.outputResource,
      outputAmount: block.outputAmount,
      planDay: day,
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: person.withRoutine(
          routine.withGeneratedBlocks(<RoutineBlock>[
            ...routine.generatedBlocks.where(
              (RoutineBlock value) => value.id != block.id,
            ),
            moved,
          ]),
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'routine_block_rescheduled',
          personId,
          'block=${block.id} moved_to=${slot ~/ 3600}h '
              'activity=${block.activity}',
        ),
      ],
    );
    schedule(
      due: SimTime(
        (_state.now.seconds ~/ gameSecondsPerDay) * gameSecondsPerDay + slot,
      ),
      phase: EventPhase.intent,
      kind: 'routine_block_started',
      payload: <String, Object?>{'person_id': personId, 'block_id': moved.id},
    );
    return true;
  }

  /// Đóng một khối đã hết giờ và giao sản lượng theo số giây thật sự làm.
  RoutineState _finishBlock(
    String personId,
    RoutineState routine,
    RoutineBlock block,
  ) {
    final int lost = routine.lostInActiveBlock(_state.now.seconds);
    final RoutineState ended = routine.endBlock(_state.now.seconds);
    final PersonState? worker = _state.people[personId];
    final PersonAgenda? agenda = worker?.agenda;
    if (worker != null && agenda != null) {
      final int worked = (block.durationSeconds - lost).clamp(
        0,
        block.durationSeconds,
      );
      final bool wellbeing = _wellbeing(worker);
      PersonAgenda nextAgenda = wellbeing
          ? agenda
                .tire(worked)
                .afterWork(workedSeconds: worked, lostSeconds: lost)
          : agenda.tire(worked);
      if (worker.body != null) nextAgenda = nextAgenda.logWork(worked);
      PersonState next = worker.withAgenda(nextAgenda);
      // Làm nghề nào thì lên tay nghề ấy, người mới lên nhanh hơn người giỏi.
      final String? skillCode = block.needKind == null
          ? null
          : _skillByResource[block.needKind];
      final PersonSkills? skills = worker.skills;
      if (wellbeing && skillCode != null && skills != null) {
        final int gain = skills.gainFrom(skillCode, worked);
        if (gain > 0) {
          next = next.withSkills(skills.improve(skillCode, gain));
          _replace(
            people: <String, PersonState>{..._state.people, personId: next},
            facts: <WorldFact>[
              ..._state.facts,
              _fact(
                'skill_improved',
                personId,
                'skill=$skillCode gain=$gain '
                    'level=${skills.level(skillCode) + gain} '
                    'worked_seconds=$worked',
              ),
            ],
          );
        } else {
          _replace(
            people: <String, PersonState>{..._state.people, personId: next},
          );
        }
      } else {
        _replace(
          people: <String, PersonState>{..._state.people, personId: next},
        );
      }
    }
    _deliverBlockOutput(personId, block, lost);
    _replace(
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'routine_block_ended',
          personId,
          'block=${block.id} lost_seconds=$lost',
        ),
      ],
    );
    return ended;
  }

  /// Sản lượng của khối việc đi thẳng vào kho hộ, trừ phần giờ đã mất.
  void _deliverBlockOutput(String personId, RoutineBlock block, int lost) {
    final String? resourceKey = block.outputResource;
    if (resourceKey == null || block.outputAmount <= 0) return;
    final PersonState? person = _state.people[personId];
    final String? householdId = person?.householdId;
    final HouseholdState? household = householdId == null
        ? null
        : _state.households[householdId];
    if (household == null) return;
    final String? itemId = household.resourceItemIds[resourceKey];
    final CareItemState? item = itemId == null ? null : _state.items[itemId];
    if (item == null) return;
    final int worked = (block.durationSeconds - lost).clamp(
      0,
      block.durationSeconds,
    );
    final int delivered = block.durationSeconds <= 0
        ? 0
        : (block.outputAmount * worked) ~/ block.durationSeconds;
    if (delivered <= 0) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'routine_work_lost',
            personId,
            'block=${block.id} resource=$resourceKey lost_seconds=$lost',
          ),
        ],
      );
      return;
    }
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        item.id: item.replenish(delivered),
      },
      households: <String, HouseholdState>{
        ..._state.households,
        householdId!: household.recordProduction(),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'routine_work_delivered',
          personId,
          'block=${block.id} resource=$resourceKey amount=$delivered '
              'planned=${block.outputAmount} lost_seconds=$lost',
        ),
      ],
    );
  }

  void _applyRoutineBlockEnded(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String blockId = event.payload['block_id']! as String;
    final PersonState? person = _state.people[personId];
    final RoutineState? routine = person?.routine;
    if (person == null || routine == null) return;
    if (routine.activeBlockId != blockId) return;
    final RoutineBlock? block = routine.blockById(blockId);
    if (block == null) return;
    final RoutineState ended = _finishBlock(personId, routine, block);
    final PersonState current = _state.people[personId]!;
    PersonState next = current.withRoutine(ended);
    if (current.caregiverAgent != null && !routine.preempted) {
      next = next.withCaregiverAgent(
        current.caregiverAgent!.withActivity('nghỉ giữa buổi'),
      );
    }
    _replace(people: <String, PersonState>{..._state.people, personId: next});
  }

  PersonState _preemptRoutine(PersonState person, String by) {
    final RoutineState? routine = person.routine;
    if (routine == null) return person;
    return person.withRoutine(
      routine.preempt(nowSeconds: _state.now.seconds, by: by),
    );
  }

  PersonState _resumeRoutine(PersonState person) {
    final RoutineState? routine = person.routine;
    if (routine == null) return person;
    return person.withRoutine(routine.resume(_state.now.seconds));
  }

  void _startCryResponse(String personId) {
    final PersonState? infant = _state.people[personId];
    final InfantState? infancy = infant?.infancy;
    if (infant == null || infancy == null || infancy.careResponsePending) {
      return;
    }
    final PersonState? caregiver = _selectAvailableCaregiver(
      infant,
      infancy.caregiverId,
    );
    final FamilyCareSupportRequestState? supportRequest =
        _recordFamilyCareCoverage(
          infant: infant,
          caregiver: caregiver,
          trigger: 'cry_response',
        );
    if (caregiver == null ||
        caregiver.caregiverAgent == null ||
        caregiver.positionMm == null ||
        infant.positionMm == null) {
      if (supportRequest?.status == FamilyCareSupportStatus.pending) {
        _waitForFamilyCareSupport(supportRequest!);
        return;
      }
      _failCareResponse(
        personId,
        'care_response_impossible',
        'no_actor_or_position',
      );
      return;
    }
    _beginCryResponse(infant: infant, infancy: infancy, caregiver: caregiver);
  }

  void _beginCryResponse({
    required PersonState infant,
    required InfantState infancy,
    required PersonState caregiver,
    int? requestedAtSeconds,
  }) {
    final String personId = infant.id;
    final int requestedAt = requestedAtSeconds ?? _state.now.seconds;
    final InfantCareExpectationState? expectation =
        infancy.careExpectations[caregiver.id];
    final int loudness =
        (900 +
                infancy.needs.distress ~/ 3 +
                (500 - (expectation?.safety ?? 500)) ~/ 2)
            .clamp(500, 1000);
    if (caregiver.id != infancy.caregiverId) {
      _recordCaregiverSubstitution(
        preferredId: infancy.caregiverId,
        substituteId: caregiver.id,
        reason: 'cry_response',
      );
    }
    final InfantState waiting = infancy.withCareResponsePending(true);
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: infant.withInfancy(waiting),
      },
    );
    final int distance = caregiver.point!.distanceTo(infant.point!);
    final int travelSeconds = (distance ~/ 340000).clamp(1, 60);
    schedule(
      due: _state.now.addSeconds(travelSeconds),
      phase: EventPhase.observation,
      kind: 'cry_signal_arrives',
      payload: <String, Object?>{
        'person_id': personId,
        'caregiver_id': caregiver.id,
        'preferred_caregiver_id': infancy.caregiverId,
        'requested_at_seconds': requestedAt,
        'origin_position_mm': infant.positionMm,
        if (infant.positionYMm != 0) 'origin_y_mm': infant.positionYMm,
        'loudness': loudness,
      },
    );
  }

  void _applyCrySignalArrives(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String caregiverId = event.payload['caregiver_id']! as String;
    final PersonState? infant = _state.people[personId];
    final PersonState? caregiver = _state.people[caregiverId];
    final CaregiverAgentState? agent = caregiver?.caregiverAgent;
    if (infant?.infancy == null ||
        caregiver == null ||
        agent == null ||
        !agent.available ||
        caregiver.positionMm == null ||
        infant!.positionMm == null) {
      _failCareResponse(personId, 'care_response_impossible', 'actor_changed');
      return;
    }
    final int originPosition = event.payload['origin_position_mm']! as int;
    final int soundDistance = caregiver.point!.distanceTo(
      WorldPoint(originPosition, event.payload['origin_y_mm'] as int? ?? 0),
    );
    final int perceived =
        (event.payload['loudness']! as int) - soundDistance ~/ 10;
    if (perceived < agent.hearingThreshold) {
      _failCareResponse(
        personId,
        'cry_not_heard',
        'perceived=$perceived threshold=${agent.hearingThreshold}',
      );
      return;
    }
    if (agent.movementSpeedMmPerSecond <= 0) {
      _failCareResponse(personId, 'caregiver_cannot_reach', caregiverId);
      return;
    }
    final CaregiverAgentState interrupted = agent.interruptForCare(
      _state.now.seconds,
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        caregiverId: _preemptRoutine(
          caregiver.withCaregiverAgent(interrupted),
          'chăm trẻ khóc',
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'cry_heard',
          caregiverId,
          'infant=$personId perceived=$perceived',
        ),
      ],
    );
    final int walkDistance = caregiver.point!.distanceTo(infant.point!);
    final int walkSeconds =
        (walkDistance + agent.movementSpeedMmPerSecond - 1) ~/
        agent.movementSpeedMmPerSecond;
    schedule(
      due: _state.now.addSeconds(walkSeconds.clamp(1, gameSecondsPerDay)),
      phase: EventPhase.movement,
      kind: 'caregiver_arrives',
      payload: <String, Object?>{
        'person_id': personId,
        'caregiver_id': caregiverId,
        if (event.payload['preferred_caregiver_id'] != null)
          'preferred_caregiver_id': event.payload['preferred_caregiver_id'],
        if (event.payload['requested_at_seconds'] != null)
          'requested_at_seconds': event.payload['requested_at_seconds'],
      },
    );
  }

  void _applyCaregiverArrives(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String caregiverId = event.payload['caregiver_id']! as String;
    final PersonState? infant = _state.people[personId];
    final PersonState? caregiver = _state.people[caregiverId];
    if (infant?.infancy == null ||
        infant!.positionMm == null ||
        caregiver?.caregiverAgent == null) {
      _failCareResponse(personId, 'caregiver_cannot_reach', 'actor_changed');
      return;
    }
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        caregiverId: infant.roomId == null
            ? caregiver!.withPosition(infant.positionMm!, infant.positionYMm)
            : caregiver!.withLocation(
                positionMm: infant.positionMm!,
                positionYMm: infant.positionYMm,
                roomId: infant.roomId!,
              ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact('caregiver_arrived', caregiverId, 'infant=$personId'),
      ],
    );
    schedule(
      due: _state.now.addSeconds(60),
      phase: EventPhase.transfer,
      kind: 'caregiver_uses_supplies',
      payload: <String, Object?>{
        'person_id': personId,
        'caregiver_id': caregiverId,
        if (event.payload['preferred_caregiver_id'] != null)
          'preferred_caregiver_id': event.payload['preferred_caregiver_id'],
        if (event.payload['requested_at_seconds'] != null)
          'requested_at_seconds': event.payload['requested_at_seconds'],
      },
    );
  }

  void _applyCaregiverUsesSupplies(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String caregiverId = event.payload['caregiver_id']! as String;
    final PersonState? infant = _state.people[personId];
    final PersonState? caregiver = _state.people[caregiverId];
    final InfantState? infancy = infant?.infancy;
    if (infant == null ||
        infancy == null ||
        caregiver?.caregiverAgent == null ||
        infant.positionMm == null) {
      _failCareResponse(personId, 'care_failed', 'actor_changed');
      return;
    }
    CareItemState? feed;
    CareItemState? cloth;
    for (final CareItemState item in _state.items.values) {
      if (!item.usable || item.positionMm != infant.positionMm) continue;
      if (!_canUseItem(caregiverId, item)) continue;
      if (item.kind == 'infant_feed' && feed == null) feed = item;
      if (item.kind == 'swaddling_cloth' && cloth == null) cloth = item;
    }
    if (feed == null && cloth == null) {
      final bool hasOwnedSupply = _state.items.values.any(
        (CareItemState item) =>
            item.usable &&
            item.positionMm == infant.positionMm &&
            (item.kind == 'infant_feed' || item.kind == 'swaddling_cloth'),
      );
      _failCareResponse(
        personId,
        hasOwnedSupply ? 'care_failed_no_right' : 'care_failed_missing_supply',
        caregiverId,
      );
      return;
    }
    final int offeredMl = feed == null ? 0 : feed.quantity.clamp(0, 60);
    final InfantFeedingStep feeding = infancy.feedAndComfort(
      offeredMl: offeredMl,
      energyKjPer100Ml: feed?.energyKjPer100Ml ?? 0,
      waterMlPer100Ml: feed?.waterMlPer100Ml ?? 0,
      comforted: cloth != null,
    );
    final Map<String, CareItemState> items = <String, CareItemState>{
      ..._state.items,
      if (feed != null) feed.id: feed.consume(feeding.consumedMl),
      if (cloth != null) cloth.id: cloth.wear(5),
    };
    final bool comforted = cloth != null;
    final int requestedAt =
        event.payload['requested_at_seconds'] as int? ?? _state.now.seconds;
    final int responseDelaySeconds = (_state.now.seconds - requestedAt).clamp(
      0,
      gameSecondsPerDay,
    );
    final bool attachmentLearning =
        infant.householdId != null &&
        _state.households[infant.householdId]?.infantAttachmentLearning == true;
    final InfantState learnedInfancy = attachmentLearning
        ? feeding.state.recordCareResponse(
            caregiverId: caregiverId,
            atSeconds: _state.now.seconds,
            delaySeconds: responseDelaySeconds,
          )
        : feeding.state;
    final Map<String, HouseholdState> households =
        _householdsAfterCareInterruption(caregiver!);
    final ({PersonState infant, PersonState caregiver}) remembered =
        _rememberFamilyCare(
          infant: infant.withInfancy(learnedInfancy),
          caregiver: _resumeRoutine(
            caregiver.withCaregiverAgent(
              caregiver.caregiverAgent!.resumeActivity(),
            ),
          ),
          preferredCaregiverId:
              event.payload['preferred_caregiver_id'] as String? ?? caregiverId,
          interruptedAtSeconds:
              caregiver.caregiverAgent!.interruptionStartedSeconds,
        );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: remembered.infant,
        caregiverId: remembered.caregiver,
      },
      items: items,
      households: households,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'caregiver_care',
          personId,
          'caregiver=$caregiverId consumed_ml=${feeding.consumedMl} '
              'energy_kj=${feeding.gainedEnergyKj} '
              'water_ml=${feeding.gainedWaterMl} comforted=$comforted',
        ),
        if (_state.households[caregiver.householdId]?.familyMemory == true)
          _fact(
            'family_care_remembered',
            caregiverId,
            'infant=$personId substitute='
                '${event.payload['preferred_caregiver_id'] != caregiverId}',
          ),
        if (attachmentLearning)
          _fact(
            'infant_caregiver_expectation_updated',
            personId,
            'caregiver=$caregiverId delay_seconds=$responseDelaySeconds '
                'safety=${learnedInfancy.careExpectations[caregiverId]?.safety} '
                'predictability=${learnedInfancy.careExpectations[caregiverId]?.predictability}',
          ),
      ],
    );
  }

  void _applyItemCreated(ScheduledEvent event) {
    final String itemId = event.payload['item_id']! as String;
    if (_state.items.containsKey(itemId)) return;
    final CareItemState item = CareItemState(
      id: itemId,
      kind: event.payload['kind']! as String,
      positionMm: event.payload['position_mm']! as int,
      positionYMm: event.payload['position_y_mm'] as int? ?? 0,
      quantity: event.payload['quantity']! as int,
      condition: event.payload['condition'] as int? ?? 1000,
      energyKjPer100Ml: event.payload['energy_kj_per_100ml'] as int? ?? 0,
      waterMlPer100Ml: event.payload['water_ml_per_100ml'] as int? ?? 0,
      unit: event.payload['unit'] as String? ?? 'count',
      ownerHouseholdId: event.payload['owner_household_id'] as String?,
      roomId: event.payload['room_id'] as String?,
    );
    _replace(
      items: <String, CareItemState>{..._state.items, itemId: item},
      facts: <WorldFact>[
        ..._state.facts,
        _fact('item_created', itemId, item.kind),
      ],
    );
  }

  void _applyHouseholdCreated(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    if (_state.households.containsKey(householdId)) return;
    final List<String> memberIds =
        (event.payload['member_ids']! as List<Object?>).cast<String>();
    if (memberIds.any((String id) => !_state.people.containsKey(id))) {
      throw StateError('Household $householdId references an unknown member.');
    }
    final Map<String, String> resources =
        (event.payload['resource_item_ids']! as Map).cast<String, String>();
    if (resources.values.any((String id) => !_state.items.containsKey(id))) {
      throw StateError('Household $householdId references an unknown item.');
    }
    final Map<String, Object?> rawRights =
        (event.payload['authorized_users_by_item_id']! as Map)
            .cast<String, Object?>();
    final HouseholdState household = HouseholdState(
      id: householdId,
      name: event.payload['name']! as String,
      memberIds: memberIds,
      resourceItemIds: resources,
      authorizedUsersByItemId: <String, Set<String>>{
        for (final MapEntry<String, Object?> entry in rawRights.entries)
          entry.key: (entry.value! as List<Object?>).cast<String>().toSet(),
      },
      scheduledWorkSecondsByPerson:
          (event.payload['scheduled_work_seconds_by_person']! as Map)
              .cast<String, int>(),
      wellbeing: event.payload['enable_v2_6'] == true,
      adultIllness: event.payload['enable_v2_11'] == true,
      workSubstitution: event.payload['enable_v2_13'] == true,
      birthCaregiverRole: event.payload['birth_caregiver_role'] as String?,
      familyOriginSummary: event.payload['family_origin_summary'] as String?,
      birthGenesisFingerprint:
          event.payload['birth_genesis_fingerprint'] as String?,
      birthFamilyRolesByPersonId:
          (event.payload['birth_family_roles_by_person_id'] as Map?)
              ?.cast<String, String>() ??
          const <String, String>{},
      familyCareScheduling: event.payload['family_care_scheduling'] == true,
      familyMemory: event.payload['family_memory'] == true,
      familyCareNegotiation: event.payload['family_care_negotiation'] == true,
      familyCareSupport: event.payload['family_care_support'] == true,
      familyCareResilience: event.payload['family_care_resilience'] == true,
      familyCareBurdenEnabled: event.payload['family_care_burden'] == true,
      familyCareConflictEnabled: event.payload['family_care_conflict'] == true,
      familyCarePromiseEnabled: event.payload['family_care_promise'] == true,
      familyCareReliabilityEnabled:
          event.payload['family_care_reliability'] == true,
      familyCareWitnessMemory:
          event.payload['family_care_witness_memory'] == true,
      infantAttachmentLearning:
          event.payload['infant_attachment_learning'] == true,
      familyCareSubjectId: event.payload['family_care_negotiation'] == true
          ? event.payload['infant_id'] as String?
          : null,
    );
    _replace(
      households: <String, HouseholdState>{
        ..._state.households,
        householdId: household,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact('household_created', householdId, household.name),
      ],
    );
    schedule(
      due: const SimTime(7 * 3600),
      phase: EventPhase.transfer,
      kind: 'household_meal',
      payload: <String, Object?>{
        'household_id': householdId,
        'actor_id': event.payload['meal_actor_id']! as String,
        'slot': 0,
      },
    );
    schedule(
      due: const SimTime(22 * 3600),
      phase: EventPhase.bookkeeping,
      kind: 'household_work_settlement',
      payload: <String, Object?>{'household_id': householdId},
    );
    if (event.payload['auto_plan'] == true) {
      schedule(
        due: const SimTime(5 * 3600),
        phase: EventPhase.intent,
        kind: 'household_planning',
        payload: <String, Object?>{'household_id': householdId},
      );
    }
    if (event.payload['enable_v2_1'] == true) {
      schedule(
        due: const SimTime(1 * gameSecondsPerDay + 18 * 3600),
        phase: EventPhase.completion,
        kind: 'household_production',
        payload: <String, Object?>{
          'household_id': householdId,
          'actor_id': event.payload['production_actor_id'] as String? ?? 'N03',
          'resource': 'fuel',
          'amount': 1200,
        },
      );
      schedule(
        due: const SimTime(3 * gameSecondsPerDay + 9 * 3600),
        phase: EventPhase.completion,
        kind: 'infant_illness_onset',
        payload: <String, Object?>{
          'person_id': event.payload['infant_id'] as String? ?? 'P00',
          'caregiver_id': event.payload['caregiver_id'] as String? ?? 'N01',
          'physiology_coupled': event.payload['enable_v2_2'] == true,
        },
      );
      if (event.payload['enable_v2_2'] == true) {
        schedule(
          due: const SimTime(3 * gameSecondsPerDay + 8 * 3600 + 30 * 60),
          phase: EventPhase.completion,
          kind: 'caregiver_availability_changed',
          payload: <String, Object?>{
            'person_id': event.payload['caregiver_id'] as String? ?? 'N01',
            'available': false,
            'reason': 'sudden_fever',
          },
        );
        schedule(
          due: const SimTime(3 * gameSecondsPerDay + 12 * 3600),
          phase: EventPhase.completion,
          kind: 'caregiver_availability_changed',
          payload: <String, Object?>{
            'person_id': event.payload['caregiver_id'] as String? ?? 'N01',
            'available': true,
            'reason': 'recovered_enough',
          },
        );
        schedule(
          due: const SimTime(4 * gameSecondsPerDay + 18 * 3600),
          phase: EventPhase.movement,
          kind: 'supply_journey_started',
          payload: <String, Object?>{
            'household_id': householdId,
            'carrier_id':
                event.payload['supply_carrier_id'] as String? ?? 'N04',
            'journey_index': 0,
            // Có tuyến thật thì đi tuyến; không thì giữ nhánh cũ với độ trễ fixture.
            if (event.payload['supply_route_id'] case final String routeId)
              'route_id': routeId
            else
              'delay_seconds': 6 * 3600,
          },
        );
      } else {
        schedule(
          due: const SimTime(5 * gameSecondsPerDay + 6 * 3600),
          phase: EventPhase.transfer,
          kind: 'household_supply_delivery',
          payload: <String, Object?>{'household_id': householdId},
        );
      }
    }
  }

  void _applyFamilyCarePlanReview(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final HouseholdState? household = _state.households[householdId];
    if (household?.familyCareNegotiation != true) return;
    final String? feedId = household!.resourceItemIds['infant_feed'];
    final String careSubjectId = household.familyCareSubjectId ?? 'P00';
    final List<PersonState> adults = <PersonState>[
      for (final String personId in household.birthFamilyRolesByPersonId.keys)
        if (_state.people[personId] case final PersonState person) person,
    ]..sort((PersonState a, PersonState b) => a.id.compareTo(b.id));
    final Map<String, int> assignedShifts = <String, int>{};
    final List<FamilyCareShiftState> shifts = <FamilyCareShiftState>[];
    final Map<String, PersonState> people = <String, PersonState>{
      ..._state.people,
    };
    final List<WorldFact> negotiationFacts = <WorldFact>[];
    for (int index = 0; index < 4; index++) {
      final int start = index * 6 * 3600;
      const int duration = 6 * 3600;
      final List<String> declined = <String>[];
      final List<PersonState> willing = <PersonState>[];
      for (final PersonState original in adults) {
        final PersonState person = people[original.id]!;
        final bool routineConflict =
            person.routine?.blocks.any(
              (RoutineBlock block) =>
                  block.blocking &&
                  block.startSecondOfDay < start + duration &&
                  start < block.endSecondOfDay,
            ) ??
            false;
        final String role =
            household.birthFamilyRolesByPersonId[person.id] ?? 'guardian';
        final int obligation =
            person.familyBonds[careSubjectId]?.careObligation ??
            (role == 'guardian' ? 760 : 860);
        final FamilyCareBurdenState burden =
            household.familyCareBurdenByPersonId[person.id] ??
            const FamilyCareBurdenState();
        final FamilyCareReliabilityState reliability =
            household.familyCareReliabilityByPersonId[person.id] ??
            const FamilyCareReliabilityState();
        final int witnessTrust = _familyWitnessTrust(
          household,
          person.id,
          people,
        );
        final FamilyCarePromiseState? duePromise = household.familyCarePromises
            .where(
              (FamilyCarePromiseState value) =>
                  value.status == FamilyCarePromiseStatus.active &&
                  value.debtorId == person.id &&
                  value.dueDay <= _state.now.day,
            )
            .firstOrNull;
        final int offerPriority =
            (45 +
                    obligation ~/ 20 +
                    burden.careDebt ~/ 20 -
                    burden.strain ~/ 25 +
                    (reliability.score - 500) ~/ 20 +
                    (witnessTrust - 500) ~/ 25 +
                    (duePromise == null ? 0 : 35))
                .clamp(0, 100);
        final bool canReceiveOffer =
            person.caregiverAgent?.available == true &&
            person.caregiverAgent!.careSkill >= 400 &&
            feedId != null &&
            household.canUse(person.id, feedId) &&
            !routineConflict;
        final bool acceptsOffer =
            canReceiveOffer && (person.agenda?.accepts(offerPriority) ?? true);
        if (acceptsOffer) {
          willing.add(person);
        } else {
          declined.add(person.id);
          if (canReceiveOffer && person.agenda != null) {
            final String reason =
                '${person.agenda!.mainStrain} ${person.agenda!.fatigue}/1000, '
                'ca mức $offerPriority';
            people[person.id] = person.withAgenda(
              person.agenda!.recordOffer(accepted: false, reason: reason),
            );
            negotiationFacts.add(
              _fact(
                'family_care_offer_refused',
                person.id,
                'household=$householdId shift=$index priority=$offerPriority '
                    'floor=${person.agenda!.acceptanceFloor}',
              ),
            );
          }
        }
      }
      willing.sort((PersonState a, PersonState b) {
        int score(PersonState person) {
          final String role =
              household.birthFamilyRolesByPersonId[person.id] ?? 'guardian';
          final FamilyBondState? bond = person.familyBonds[careSubjectId];
          final int obligation =
              bond?.careObligation ?? (role == 'guardian' ? 760 : 860);
          final FamilyCareBurdenState burden =
              household.familyCareBurdenByPersonId[person.id] ??
              const FamilyCareBurdenState();
          final FamilyCareReliabilityState reliability =
              household.familyCareReliabilityByPersonId[person.id] ??
              const FamilyCareReliabilityState();
          final int witnessTrust = _familyWitnessTrust(
            household,
            person.id,
            people,
          );
          final bool hasDuePromise = household.familyCarePromises.any(
            (FamilyCarePromiseState value) =>
                value.status == FamilyCarePromiseStatus.active &&
                value.debtorId == person.id &&
                value.dueDay <= _state.now.day,
          );
          return obligation +
              person.caregiverAgent!.careSkill -
              (person.agenda?.fatigue ?? 0) -
              (assignedShifts[person.id] ?? 0) * 260 -
              (bond?.careGiven ?? 0) * 12 +
              burden.careDebt -
              burden.strain +
              (reliability.score - 500) +
              (witnessTrust - 500) +
              (hasDuePromise ? 800 : 0);
        }

        final int byScore = score(b).compareTo(score(a));
        return byScore != 0 ? byScore : a.id.compareTo(b.id);
      });
      final PersonState? chosen = willing.firstOrNull;
      if (chosen != null) {
        assignedShifts[chosen.id] = (assignedShifts[chosen.id] ?? 0) + 1;
        if (chosen.agenda != null) {
          final PersonState current = people[chosen.id]!;
          people[chosen.id] = current.withAgenda(
            current.agenda!.recordOffer(accepted: true),
          );
        }
      }
      shifts.add(
        FamilyCareShiftState(
          id: 'CARE-$householdId-D${_state.now.day}-S$index',
          startSecondOfDay: start,
          durationSeconds: duration,
          caregiverId: chosen?.id,
          reason: chosen == null
              ? 'no_accepted_caregiver'
              : (assignedShifts.length > 1
                    ? 'care_burden_balanced'
                    : 'highest_care_commitment'),
          declinedPersonIds: declined,
        ),
      );
    }
    final FamilyCarePlanState plan = FamilyCarePlanState(
      day: _state.now.day,
      revision: (household.familyCarePlan?.revision ?? 0) + 1,
      negotiatedAtSeconds: _state.now.seconds,
      shifts: List<FamilyCareShiftState>.unmodifiable(shifts),
    );
    HouseholdState updatedHousehold = household
        .withFamilyCarePlan(plan)
        .settleFamilyCareBurden(assignedShifts);
    final List<FamilyCarePromiseState> promises = <FamilyCarePromiseState>[];
    for (final FamilyCarePromiseState promise in household.familyCarePromises) {
      if (promise.status != FamilyCarePromiseStatus.active ||
          promise.dueDay > _state.now.day) {
        promises.add(promise);
        continue;
      }
      final FamilyCarePromiseState settled = promise.settle(
        assignedShifts: assignedShifts[promise.debtorId] ?? 0,
        atSeconds: _state.now.seconds,
      );
      promises.add(settled);
      negotiationFacts.add(
        _fact(
          settled.status == FamilyCarePromiseStatus.fulfilled
              ? 'family_care_promise_fulfilled'
              : 'family_care_promise_broken',
          householdId,
          'promise=${settled.id} debtor=${settled.debtorId} '
          'beneficiary=${settled.beneficiaryId} '
          'assigned=${settled.assignedShifts} '
          'promised=${settled.promisedShifts}',
        ),
      );
      if (household.familyCareWitnessMemory) {
        int witnesses = 0;
        for (final String witnessId
            in household.birthFamilyRolesByPersonId.keys) {
          if (witnessId == settled.debtorId ||
              (settled.status == FamilyCarePromiseStatus.broken &&
                  witnessId == settled.beneficiaryId)) {
            continue;
          }
          final PersonState? witness = people[witnessId];
          if (witness == null) continue;
          final FamilyBondState observedBond =
              witness.familyBonds[settled.debtorId] ?? const FamilyBondState();
          people[witnessId] = witness.withFamilyBond(
            settled.debtorId,
            observedBond.recordReliabilityObservation(
              atSeconds: _state.now.seconds,
              keptPromise: settled.status == FamilyCarePromiseStatus.fulfilled,
            ),
          );
          witnesses++;
        }
        negotiationFacts.add(
          _fact(
            'family_care_reputation_witnessed',
            settled.debtorId,
            'promise=${settled.id} status=${settled.status.name} '
                'witnesses=$witnesses',
          ),
        );
      }
      if (settled.status == FamilyCarePromiseStatus.broken) {
        final PersonState? debtor = people[settled.debtorId];
        final PersonState? beneficiary = people[settled.beneficiaryId];
        if (debtor != null && beneficiary != null) {
          final int breachSeverity = 180 + settled.missingShifts * 70;
          people[debtor.id] = debtor.withFamilyBond(
            beneficiary.id,
            (debtor.familyBonds[beneficiary.id] ?? const FamilyBondState())
                .recordConflict(
                  atSeconds: _state.now.seconds,
                  severity: breachSeverity,
                ),
          );
          people[beneficiary.id] = beneficiary.withFamilyBond(
            debtor.id,
            (beneficiary.familyBonds[debtor.id] ?? const FamilyBondState())
                .recordConflict(
                  atSeconds: _state.now.seconds,
                  severity: breachSeverity,
                ),
          );
        }
      }
    }
    if (household.familyCarePromiseEnabled) {
      updatedHousehold = updatedHousehold.updateFamilyCarePromises(promises);
    }
    _replace(
      people: people,
      households: <String, HouseholdState>{
        ..._state.households,
        householdId: updatedHousehold,
      },
      facts: <WorldFact>[
        ..._state.facts,
        ...negotiationFacts,
        _fact(
          'family_care_plan_negotiated',
          householdId,
          'day=${plan.day} revision=${plan.revision} assignments='
              '${plan.shifts.map((FamilyCareShiftState shift) => '${shift.startSecondOfDay}:${shift.caregiverId ?? 'uncovered'}').join(',')}',
        ),
        if (household.familyCareBurdenEnabled)
          _fact(
            'family_care_burden_rebalanced',
            householdId,
            'assigned=${assignedShifts.entries.map((MapEntry<String, int> value) => '${value.key}:${value.value}').join(',')}',
          ),
      ],
    );
    schedule(
      due: _state.now.addDays(1),
      phase: EventPhase.bookkeeping,
      kind: 'family_care_plan_review',
      payload: event.payload,
    );
  }

  void _applyHouseholdMeal(ScheduledEvent event) {
    const int foodGrams = 500;
    const int waterMl = 2000;
    const int fuelGrams = 300;
    final String householdId = event.payload['household_id']! as String;
    final String actorId = event.payload['actor_id']! as String;
    final int slot = event.payload['slot']! as int;
    final HouseholdState? household = _state.households[householdId];
    if (household == null) return;
    final int plannedSeconds =
        event.payload['planned_seconds'] as int? ?? event.due.seconds;
    final int deferrals = event.payload['deferrals'] as int? ?? 0;
    final PersonState? actor = _state.people[actorId];
    final String? competing = actor == null
        ? null
        : _competingObligation(actor) ?? actor.routine?.blockingActivity;
    if (competing != null && deferrals < _routineMaxDeferrals) {
      _replace(
        people: actor!.routine == null
            ? null
            : <String, PersonState>{
                ..._state.people,
                actorId: actor.withRoutine(
                  actor.routine!.recordConflict(
                    ScheduleConflict(
                      atSeconds: _state.now.seconds,
                      plannedActivity: 'bữa ăn của hộ',
                      competingActivity: competing,
                      resolution: 'deferred',
                    ),
                  ),
                ),
              },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'household_meal_deferred',
            householdId,
            'actor=$actorId slot=$slot competing=$competing '
                'planned_seconds=$plannedSeconds',
          ),
        ],
      );
      schedule(
        due: _state.now.addSeconds(30 * 60),
        phase: EventPhase.transfer,
        kind: 'household_meal',
        payload: <String, Object?>{
          'household_id': householdId,
          'actor_id': actorId,
          'slot': slot,
          'planned_seconds': plannedSeconds,
          'deferrals': deferrals + 1,
        },
      );
      return;
    }
    final String? foodId = household.resourceItemIds['food'];
    final String? waterId = household.resourceItemIds['water'];
    final String? fuelId = household.resourceItemIds['fuel'];
    final CareItemState? food = foodId == null ? null : _state.items[foodId];
    final CareItemState? water = waterId == null ? null : _state.items[waterId];
    final CareItemState? fuel = fuelId == null ? null : _state.items[fuelId];
    HouseholdState nextHousehold = household;
    Map<String, CareItemState>? items;
    String kind;
    String detail;
    if (foodId == null ||
        waterId == null ||
        fuelId == null ||
        food == null ||
        water == null ||
        fuel == null) {
      nextHousehold = household.recordShortfall();
      kind = 'household_meal_missing_resources';
      detail =
          'food=${foodId ?? 'unassigned'} '
          'water=${waterId ?? 'unassigned'} fuel=${fuelId ?? 'unassigned'}';
    } else if (!household.canUse(actorId, foodId) ||
        !household.canUse(actorId, waterId) ||
        !household.canUse(actorId, fuelId)) {
      nextHousehold = household.recordUnauthorizedAttempt();
      kind = 'household_meal_unauthorized';
      detail = 'actor=$actorId';
    } else {
      if (food.quantity < foodGrams ||
          water.quantity < waterMl ||
          fuel.quantity < fuelGrams) {
        nextHousehold = household.recordShortfall();
        kind = 'household_meal_shortfall';
        detail =
            'food=${food.quantity} water=${water.quantity} fuel=${fuel.quantity}';
      } else {
        nextHousehold = household.recordMeal(
          foodGrams: foodGrams,
          waterMl: waterMl,
          fuelGrams: fuelGrams,
        );
        items = <String, CareItemState>{
          ..._state.items,
          foodId: food.consume(foodGrams),
          waterId: water.consume(waterMl),
          fuelId: fuel.consume(fuelGrams),
        };
        kind = 'household_meal_completed';
        detail =
            'actor=$actorId food_g=$foodGrams water_ml=$waterMl fuel_g=$fuelGrams';
      }
    }
    if (deferrals > 0) {
      detail =
          '$detail late_seconds=${_state.now.seconds - plannedSeconds} '
          'deferrals=$deferrals';
    }
    // Bữa ăn đi vào từng người: no thì hạ cơn đói, hụt bữa thì đói và bực thêm.
    Map<String, PersonState>? fedPeople;
    if (household.wellbeing) {
      final bool fed = kind == 'household_meal_completed';
      final Map<String, PersonState> updated = <String, PersonState>{
        ..._state.people,
      };
      // Suất ăn chia đều cho người lớn trong hộ.
      final List<String> eaters = household.memberIds
          .where(
            (String memberId) =>
                updated[memberId] != null &&
                updated[memberId]!.infancy == null &&
                updated[memberId]!.agenda != null,
          )
          .toList();
      final int shareEnergyKj = fed && eaters.isNotEmpty
          ? foodGrams * _kjPerHundredGramsFood ~/ 100 ~/ eaters.length
          : 0;
      final int shareWaterMl = fed && eaters.isNotEmpty
          ? waterMl ~/ eaters.length
          : 0;
      bool changed = false;
      for (final String memberId in eaters) {
        final PersonState member = updated[memberId]!;
        final PersonAgenda memberAgenda = member.agenda!;
        PersonState nextMember = member;
        PersonAgenda after = memberAgenda.atMeal(fed: fed);
        // Có cơ thể thì bữa ăn vào thẳng dự trữ, và cơn đói do cơ thể quyết định.
        final AdultBodyState? body = member.body;
        if (body != null) {
          final AdultBodyState nextBody = fed
              ? body.eat(energyKj: shareEnergyKj, waterMl: shareWaterMl)
              : body;
          nextMember = nextMember.withBody(nextBody);
          after = after.withHunger(nextBody.hunger);
        }
        if (identical(nextMember, member) &&
            after.hunger == memberAgenda.hunger &&
            after.mood == memberAgenda.mood) {
          continue;
        }
        updated[memberId] = nextMember.withAgenda(after);
        changed = true;
      }
      if (changed) fedPeople = updated;
    }
    _replace(
      people: fedPeople,
      households: <String, HouseholdState>{
        ..._state.households,
        householdId: nextHousehold,
      },
      items: items,
      facts: <WorldFact>[..._state.facts, _fact(kind, householdId, detail)],
    );
    final int delay = switch (slot) {
      0 => 5 * 3600,
      1 => 6 * 3600,
      _ => 13 * 3600,
    };
    final int nextSlot = switch (slot) {
      0 => 1,
      1 => 2,
      _ => 0,
    };
    final SimTime nextDue = SimTime(plannedSeconds).addSeconds(delay);
    if (nextDue.seconds < 30 * gameSecondsPerDay) {
      schedule(
        due: nextDue,
        phase: EventPhase.transfer,
        kind: 'household_meal',
        payload: <String, Object?>{
          'household_id': householdId,
          'actor_id': actorId,
          'slot': nextSlot,
        },
      );
    }
  }

  void _applyHouseholdWorkSettlement(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final HouseholdState? household = _state.households[householdId];
    if (household == null) return;
    if (household.wellbeing) _settleAdultBodies(household);
    final HouseholdState settled = _state.households[householdId]!
        .settleWorkDay();
    final List<MapEntry<String, int>> completedWork =
        settled.workCompletedSecondsByPerson.entries.toList()..sort(
          (MapEntry<String, int> a, MapEntry<String, int> b) =>
              a.key.compareTo(b.key),
        );
    final String completedWorkDetail =
        '{${completedWork.map((MapEntry<String, int> entry) => '${entry.key}: ${entry.value}').join(', ')}}';
    _replace(
      households: <String, HouseholdState>{
        ..._state.households,
        householdId: settled,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'household_work_settled',
          householdId,
          'completed_seconds=$completedWorkDetail',
        ),
      ],
    );
    final SimTime nextDue = event.due.addDays(1);
    if (nextDue.seconds < 30 * gameSecondsPerDay) {
      schedule(
        due: nextDue,
        phase: EventPhase.bookkeeping,
        kind: 'household_work_settlement',
        payload: event.payload,
      );
    }
  }

  void _applyRoomCreated(ScheduledEvent event) {
    final String roomId = event.payload['room_id']! as String;
    if (_state.rooms.containsKey(roomId)) return;
    final RoomState room = RoomState(
      id: roomId,
      name: event.payload['name']! as String,
      householdId: event.payload['household_id']! as String,
      anchorPositionMm: event.payload['anchor_position_mm']! as int,
      anchorPositionYMm: event.payload['anchor_position_y_mm'] as int? ?? 0,
    );
    _replace(
      rooms: <String, RoomState>{..._state.rooms, roomId: room},
      facts: <WorldFact>[
        ..._state.facts,
        _fact('room_created', roomId, room.name),
      ],
    );
  }

  void _applyInfantIllnessOnset(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final PersonState? person = _state.people[personId];
    if (person?.infancy == null || _state.illnesses.containsKey('ILL-P00-01')) {
      return;
    }
    final IllnessState illness = IllnessState(
      id: 'ILL-P00-01',
      personId: personId,
      kind: 'mild_respiratory_infection',
      onsetSeconds: _state.now.seconds,
      stage: IllnessStage.symptomatic,
      severity: 420,
      bodyTemperatureMilliC: 37800,
      symptoms: const <String>['runny_nose', 'light_cough', 'mild_fever'],
      physiologyCoupled: event.payload['physiology_coupled'] as bool? ?? false,
    );
    _replace(
      illnesses: <String, IllnessState>{
        ..._state.illnesses,
        illness.id: illness,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'illness_onset',
          personId,
          'illness=${illness.id} severity=${illness.severity} temp_millic=${illness.bodyTemperatureMilliC}',
        ),
      ],
    );
    schedule(
      due: _state.now.addSeconds(300),
      phase: EventPhase.observation,
      kind: 'illness_observed',
      payload: event.payload,
    );
    schedule(
      due: _state.now.addSeconds(6 * 3600),
      phase: EventPhase.bookkeeping,
      kind: 'illness_progress',
      payload: <String, Object?>{'illness_id': illness.id},
    );
  }

  void _applyIllnessObserved(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String preferredCaregiverId =
        event.payload['caregiver_id']! as String;
    final PersonState? infant = _state.people[personId];
    final PersonState? caregiver = infant == null
        ? null
        : _selectAvailableCaregiver(infant, preferredCaregiverId);
    final FamilyCareSupportRequestState? supportRequest = infant == null
        ? null
        : _recordFamilyCareCoverage(
            infant: infant,
            caregiver: caregiver,
            trigger: 'illness_care',
          );
    final CaregiverAgentState? agent = caregiver?.caregiverAgent;
    if (infant == null || caregiver == null || agent == null) {
      if (supportRequest?.status == FamilyCareSupportStatus.pending) {
        _waitForFamilyCareSupport(supportRequest!);
        return;
      }
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'illness_care_unstaffed',
            personId,
            'preferred=$preferredCaregiverId',
          ),
        ],
      );
      return;
    }
    _beginIllnessCareResponse(
      infant: infant,
      caregiver: caregiver,
      preferredCaregiverId: preferredCaregiverId,
      payload: event.payload,
    );
  }

  void _beginIllnessCareResponse({
    required PersonState infant,
    required PersonState caregiver,
    required String preferredCaregiverId,
    required Map<String, Object?> payload,
  }) {
    final CaregiverAgentState agent = caregiver.caregiverAgent!;
    final String personId = infant.id;
    final String caregiverId = caregiver.id;
    final IllnessState? illness = _state.illnesses['ILL-P00-01'];
    if (illness == null || !illness.active) return;
    if (caregiverId != preferredCaregiverId) {
      _recordCaregiverSubstitution(
        preferredId: preferredCaregiverId,
        substituteId: caregiverId,
        reason: illness.id,
      );
    }
    final CaregiverAgentState interrupted = agent.interruptForCare(
      _state.now.seconds,
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        caregiverId: _preemptRoutine(
          caregiver.withCaregiverAgent(interrupted),
          'chăm trẻ bệnh',
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'illness_detected',
          personId,
          'caregiver=$caregiverId severity=${illness.severity}',
        ),
        _fact(
          'caregiver_schedule_changed',
          caregiverId,
          'reason=${illness.id} suspended=${agent.currentActivity}',
        ),
      ],
    );
    final int distance = (caregiver.point ?? const WorldPoint(0)).distanceTo(
      infant.point ?? const WorldPoint(0),
    );
    final int travelSeconds = agent.movementSpeedMmPerSecond <= 0
        ? gameSecondsPerDay
        : ((distance + agent.movementSpeedMmPerSecond - 1) ~/
                  agent.movementSpeedMmPerSecond)
              .clamp(1, gameSecondsPerDay);
    schedule(
      due: _state.now.addSeconds(travelSeconds),
      phase: EventPhase.movement,
      kind: 'illness_caregiver_arrives',
      payload: <String, Object?>{
        ...payload,
        'caregiver_id': caregiverId,
        'preferred_caregiver_id': preferredCaregiverId,
      },
    );
  }

  void _applyIllnessCaregiverArrives(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String caregiverId = event.payload['caregiver_id']! as String;
    final PersonState? infant = _state.people[personId];
    final PersonState? caregiver = _state.people[caregiverId];
    if (infant == null || caregiver == null) return;
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        caregiverId: caregiver.withLocation(
          positionMm: infant.positionMm ?? 0,
          roomId: infant.roomId ?? 'ROOM-SLEEP',
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'illness_caregiver_arrived',
          caregiverId,
          'infant=$personId room=${infant.roomId ?? 'unknown'}',
        ),
      ],
    );
    schedule(
      due: _state.now.addSeconds(600),
      phase: EventPhase.transfer,
      kind: 'illness_care',
      payload: event.payload,
    );
  }

  void _applyIllnessCare(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String caregiverId = event.payload['caregiver_id']! as String;
    final PersonState? caregiver = _state.people[caregiverId];
    final PersonState? infant = _state.people[personId];
    final IllnessState? illness = _state.illnesses['ILL-P00-01'];
    final String? householdId = caregiver?.householdId;
    final HouseholdState? household = householdId == null
        ? null
        : _state.households[householdId];
    if (caregiver?.caregiverAgent == null ||
        infant == null ||
        illness == null ||
        household == null) {
      return;
    }
    final String? waterId = household.resourceItemIds['water'];
    final CareItemState? water = waterId == null ? null : _state.items[waterId];
    if (water == null ||
        water.quantity < 100 ||
        !household.canUse(caregiverId, water.id)) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact('illness_care_failed', personId, 'water_or_right_missing'),
        ],
      );
      return;
    }
    final Map<String, HouseholdState> households =
        _householdsAfterCareInterruption(caregiver!);
    final IllnessState cared = illness.afterCare(10);
    final ({PersonState infant, PersonState caregiver}) remembered =
        _rememberFamilyCare(
          infant: infant,
          caregiver: _resumeRoutine(
            caregiver.withCaregiverAgent(
              caregiver.caregiverAgent!.resumeActivity(),
            ),
          ),
          preferredCaregiverId:
              event.payload['preferred_caregiver_id'] as String? ?? caregiverId,
          interruptedAtSeconds:
              caregiver.caregiverAgent!.interruptionStartedSeconds,
        );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: remembered.infant,
        caregiverId: remembered.caregiver,
      },
      items: <String, CareItemState>{
        ..._state.items,
        water.id: water.consume(100),
      },
      households: households,
      illnesses: <String, IllnessState>{..._state.illnesses, illness.id: cared},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'illness_care_completed',
          personId,
          'caregiver=$caregiverId water_ml=100 severity=${cared.severity}',
        ),
        if (household.familyMemory)
          _fact(
            'family_care_remembered',
            caregiverId,
            'infant=$personId illness=${illness.id} substitute='
                '${event.payload['preferred_caregiver_id'] != caregiverId}',
          ),
      ],
    );
  }

  void _applyIllnessProgress(ScheduledEvent event) {
    final String illnessId = event.payload['illness_id']! as String;
    final IllnessState? illness = _state.illnesses[illnessId];
    if (illness == null || !illness.active) return;
    final IllnessState next = illness.progress();
    _replace(
      illnesses: <String, IllnessState>{..._state.illnesses, illnessId: next},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          next.active ? 'illness_progressed' : 'illness_resolved',
          next.personId,
          'illness=$illnessId severity=${next.severity} temp_millic=${next.bodyTemperatureMilliC}',
        ),
      ],
    );
    // Khỏi hẳn thì kỳ nghỉ kết thúc: từ khối kế tiếp người này đi làm lại.
    if (!next.active && _state.people[next.personId]?.routine != null) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'illness_rest_ended',
            next.personId,
            'illness=$illnessId severity=${next.severity}',
          ),
        ],
      );
    }
    if (next.active) {
      schedule(
        due: _state.now.addSeconds(6 * 3600),
        phase: EventPhase.bookkeeping,
        kind: 'illness_progress',
        payload: event.payload,
      );
    }
  }

  void _applyHouseholdSupplyDelivery(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final HouseholdState? household = _state.households[householdId];
    if (household == null) return;
    const Map<String, int> baseAmounts = <String, int>{
      'food': 7500,
      'water': 30000,
      'infant_feed': 1500,
    };
    final HistoricalLegacyState? legacy = _state.historicalLegacy;
    final int supplyMultiplier = legacy?.supplyDeliveryPerMille ?? 1000;
    final Map<String, int> amounts = <String, int>{
      for (final MapEntry<String, int> entry in baseAmounts.entries)
        entry.key: entry.value * supplyMultiplier ~/ 1000,
    };
    final Map<String, CareItemState> items = <String, CareItemState>{
      ..._state.items,
    };
    for (final MapEntry<String, int> entry in amounts.entries) {
      final String? itemId = household.resourceItemIds[entry.key];
      if (itemId != null && items[itemId] != null) {
        items[itemId] = items[itemId]!.replenish(entry.value);
      }
    }
    _replace(
      items: items,
      households: <String, HouseholdState>{
        ..._state.households,
        householdId: household.recordSupplyDelivery(),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'household_supply_delivered',
          householdId,
          legacy == null
              ? 'food_g=7500 water_ml=30000 infant_feed_ml=1500'
              : 'food_g=${amounts['food']} water_ml=${amounts['water']} '
                    'infant_feed_ml=${amounts['infant_feed']} '
                    'history_multiplier=$supplyMultiplier',
        ),
      ],
    );
    final SimTime nextDue = event.due.addDays(5);
    if (event.payload['single_delivery'] != true &&
        nextDue.seconds < 30 * gameSecondsPerDay) {
      schedule(
        due: nextDue,
        phase: EventPhase.transfer,
        kind: 'household_supply_delivery',
        payload: event.payload,
      );
    }
  }

  void _applyHouseholdProduction(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String actorId = event.payload['actor_id']! as String;
    final String resource = event.payload['resource']! as String;
    final int amount = event.payload['amount']! as int;
    final HouseholdState? household = _state.households[householdId];
    final PersonState? actor = _state.people[actorId];
    final String? itemId = household?.resourceItemIds[resource];
    final CareItemState? item = itemId == null ? null : _state.items[itemId];
    if (household == null ||
        actor?.householdId != householdId ||
        item == null) {
      return;
    }
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        item.id: item.replenish(amount),
      },
      households: <String, HouseholdState>{
        ..._state.households,
        householdId: household.recordProduction(),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'household_production_completed',
          householdId,
          'actor=$actorId resource=$resource amount=$amount',
        ),
      ],
    );
    final SimTime nextDue = event.due.addDays(1);
    if (nextDue.seconds < 30 * gameSecondsPerDay) {
      schedule(
        due: nextDue,
        phase: EventPhase.completion,
        kind: 'household_production',
        payload: event.payload,
      );
    }
  }

  void _applyCaregiverAvailabilityChanged(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final bool available = event.payload['available']! as bool;
    final PersonState? person = _state.people[personId];
    final CaregiverAgentState? agent = person?.caregiverAgent;
    if (person == null || agent == null) return;
    final String reason = event.payload['reason'] as String? ?? 'unknown';
    final PersonState updated = person.withCaregiverAgent(
      agent.withAvailability(available),
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: available
            ? _resumeRoutine(updated)
            : _preemptRoutine(updated, 'nghỉ vì $reason'),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          available ? 'caregiver_available' : 'caregiver_unavailable',
          personId,
          'reason=$reason',
        ),
      ],
    );
  }

  /// Khởi hành một chuyến trên tuyến thật.
  void _startRoutedJourney({
    required String journeyId,
    required String householdId,
    required String carrierId,
    required TradeRoute route,
  }) {
    const Map<String, int> cargo = <String, int>{
      'food': 7500,
      'water': 30000,
      'infant_feed': 1500,
    };
    final PersonState carrier = _state.people[carrierId]!;
    final int capability = _carrierCapability(carrier);
    // Người chở tự chọn đường nhanh nhất cho mình: chặng nào không đủ sức qua
    // thì bị loại, nên người yếu có thể phải đi đường vòng.
    final List<String> path = route.fastestPath(
      from: route.origin,
      to: route.destination,
      cargo: cargo,
      capabilityPerMille: capability,
      baseSpeed: _carrierBaseSpeed(carrier),
    );
    if (path.length < 2) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'supply_route_impassable',
            journeyId,
            'carrier=$carrierId route=${route.id} capability=$capability',
          ),
        ],
      );
      return;
    }
    final RouteWaypoint? origin = route.waypoint(path.first);
    // Giờ đến dự kiến tính theo đường bằng, người khỏe và tay không.
    final int nominalTotal = CarrierPace.travelSeconds(
      distanceMm: route.pathDistanceMm(path),
      speedMmPerSecond: _carrierBaseSpeed(carrier),
    );
    final SupplyJourneyState journey = SupplyJourneyState(
      id: journeyId,
      householdId: householdId,
      carrierId: carrierId,
      departureSeconds: _state.now.seconds,
      expectedArrivalSeconds: _state.now.seconds + nominalTotal,
      status: SupplyJourneyStatus.traveling,
      cargo: cargo,
      currentLeg: origin?.id ?? route.id,
      routeId: route.id,
      legCount: path.length - 1,
      pathWaypointIds: path,
    );
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        carrierId: origin == null
            ? carrier
            : carrier.withPosition(origin.positionMm, origin.positionYMm),
      },
      supplyJourneys: <String, SupplyJourneyState>{
        ..._state.supplyJourneys,
        journeyId: journey,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'supply_journey_started',
          journeyId,
          'carrier=$carrierId route=${route.id} legs=${path.length - 1} '
              'path=${path.join('>')} '
              'distance_mm=${route.pathDistanceMm(path)} '
              'expected_seconds=${journey.expectedArrivalSeconds} '
              'load_g=${CarrierPace.cargoMassGrams(cargo)} '
              'load_factor=${CarrierPace.loadFactorPerMille(cargo)} '
              'capability=$capability',
        ),
      ],
    );
    _scheduleRouteLeg(journey: journey, route: route, legIndex: 0);
  }

  void _applyRouteCreated(ScheduledEvent event) {
    final TradeRoute route = TradeRoute.fromJson(
      (event.payload['route']! as Map).cast<String, Object?>(),
    );
    if (_state.routes.containsKey(route.id)) return;
    _replace(
      routes: <String, TradeRoute>{..._state.routes, route.id: route},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'route_created',
          route.id,
          '${route.name} legs=${route.legs.length} '
              'distance_mm=${route.totalDistanceMm}',
        ),
      ],
    );
  }

  void _applyRegionCreated(ScheduledEvent event) {
    final String regionId =
        (event.payload['region_id'] ?? event.payload['id'])! as String;
    if (_state.regions.containsKey(regionId)) return;
    final WorldRegion region = WorldRegion(
      id: regionId,
      name: event.payload['name']! as String,
      minXMm: event.payload['min_x_mm'] as int? ?? 0,
      minYMm: event.payload['min_y_mm'] as int? ?? 0,
      widthMm: event.payload['width_mm']! as int,
      heightMm: event.payload['height_mm']! as int,
      valleyFloorElevationM:
          event.payload['valley_floor_elevation_m'] as int? ?? 0,
      rimElevationM: event.payload['rim_elevation_m'] as int? ?? 0,
      annualRainfallMm: event.payload['annual_rainfall_mm'] as int? ?? 0,
      climateCode: event.payload['climate_code'] as String? ?? 'unspecified',
    );
    if (region.widthMm <= 0 || region.heightMm <= 0) {
      throw StateError('Region $regionId must have positive dimensions.');
    }
    if (region.climateCode != 'unspecified' &&
        (region.valleyFloorElevationM <= 0 ||
            region.rimElevationM <= region.valleyFloorElevationM ||
            region.annualRainfallMm <= 0)) {
      throw StateError('Region $regionId has an invalid terrain profile.');
    }
    _replace(
      regions: <String, WorldRegion>{..._state.regions, regionId: region},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'region_created',
          regionId,
          '${region.name} width=${region.widthMm} height=${region.heightMm}'
              '${region.climateCode == 'unspecified' ? '' : ' floor_m=${region.valleyFloorElevationM} rim_m=${region.rimElevationM} rain_mm=${region.annualRainfallMm} climate=${region.climateCode}'}',
        ),
      ],
    );
  }

  void _applySiteCreated(ScheduledEvent event) {
    final String siteId =
        (event.payload['site_id'] ?? event.payload['id'])! as String;
    if (_state.sites.containsKey(siteId)) return;
    final String regionId = event.payload['region_id']! as String;
    final WorldRegion? region = _state.regions[regionId];
    if (region == null) {
      throw StateError('Site $siteId references an unknown region.');
    }
    final WorldSite site = WorldSite(
      id: siteId,
      regionId: regionId,
      name: event.payload['name']! as String,
      kind: event.payload['kind']! as String,
      center: WorldPoint(
        event.payload['center_x_mm']! as int,
        event.payload['center_y_mm'] as int? ?? 0,
      ),
      radiusMm: event.payload['radius_mm']! as int,
      terrainCode: event.payload['terrain_code'] as String? ?? 'unspecified',
      elevationM: event.payload['elevation_m'] as int? ?? 0,
      resourceDeposits:
          (event.payload['resource_deposits'] as List<Object?>? ??
                  const <Object?>[])
              .map(
                (Object? value) => NaturalResourceDeposit.fromJson(
                  (value! as Map).cast<String, Object?>(),
                ),
              )
              .toList(),
      ecologicalPopulations:
          (event.payload['ecological_populations'] as List<Object?>? ??
                  const <Object?>[])
              .map(
                (Object? value) => EcologicalPopulationState.fromJson(
                  (value! as Map).cast<String, Object?>(),
                ),
              )
              .toList(),
    );
    if (site.radiusMm <= 0) {
      throw StateError('Site $siteId must have a positive radius.');
    }
    if (!region.contains(site.center)) {
      throw StateError('Site $siteId lies outside region $regionId.');
    }
    if (site.terrainCode != 'unspecified' &&
        (site.elevationM < region.valleyFloorElevationM ||
            site.elevationM > region.rimElevationM)) {
      throw StateError('Site $siteId elevation lies outside its valley.');
    }
    final Set<String> resourceIds = <String>{};
    for (final NaturalResourceDeposit resource in site.resourceDeposits) {
      if (!resourceIds.add(resource.id) ||
          resource.quantity < 0 ||
          resource.capacity <= 0 ||
          resource.quantity > resource.capacity ||
          resource.quality < 0 ||
          resource.quality > 1000 ||
          resource.accessibility < 0 ||
          resource.accessibility > 1000 ||
          resource.annualRenewal < 0) {
        throw StateError('Site $siteId has an invalid natural resource.');
      }
    }
    final Set<String> populationIds = <String>{};
    for (final EcologicalPopulationState population
        in site.ecologicalPopulations) {
      if (!populationIds.add(population.id) ||
          population.population < 0 ||
          population.carryingCapacity <= 0 ||
          population.population > population.carryingCapacity ||
          population.health < 0 ||
          population.health > 1000 ||
          population.annualGrowthPerMille < 0 ||
          population.annualGrowthPerMille > 1000 ||
          population.annualMortalityPerMille < 0 ||
          population.annualMortalityPerMille > 1000) {
        throw StateError('Site $siteId has an invalid ecology population.');
      }
    }
    _replace(
      sites: <String, WorldSite>{..._state.sites, siteId: site},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'site_created',
          siteId,
          '${site.name} kind=${site.kind} region=$regionId '
              'x=${site.center.xMm} y=${site.center.yMm} '
              'radius=${site.radiusMm}'
              '${site.terrainCode == 'unspecified' ? '' : ' terrain=${site.terrainCode} elevation_m=${site.elevationM} resources=${site.resourceDeposits.length} ecology=${site.ecologicalPopulations.length}'}',
        ),
      ],
    );
  }

  void _applySettlementAssessed(ScheduledEvent event) {
    final String siteId = event.payload['site_id']! as String;
    final WorldSite? site = _state.sites[siteId];
    if (site == null) {
      throw StateError(
        'Settlement assessment references unknown site $siteId.',
      );
    }
    if (site.settlementAssessment != null) return;
    final SettlementAssessmentState assessment =
        SettlementAssessmentState.fromJson(event.payload);
    if (assessment.score < 0 ||
        assessment.score > 1000 ||
        assessment.reasons.isEmpty ||
        assessment.historyFingerprint.isEmpty ||
        (assessment.selectedForBirthHousehold && !assessment.viable)) {
      throw StateError('Site $siteId has an invalid settlement assessment.');
    }
    _replace(
      sites: <String, WorldSite>{
        ..._state.sites,
        siteId: site.withSettlementAssessment(assessment),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'settlement_assessed',
          siteId,
          'score=${assessment.score} viable=${assessment.viable} '
              'selected=${assessment.selectedForBirthHousehold} '
              'history=${assessment.historyFingerprint}',
        ),
      ],
    );
  }

  void _applyWorldGenesisCompleted(ScheduledEvent event) {
    if (_state.worldGenesis != null) return;
    final WorldGenesisRecord record = WorldGenesisRecord.fromJson(
      event.payload,
    );
    if (record.rootSeed != _state.seed) {
      throw StateError('World genesis seed does not match simulation seed.');
    }
    if (_state.regions.length != record.regionCount ||
        _state.sites.length != record.siteCount ||
        _state.regions.length != 1) {
      throw StateError('World genesis counts do not match materialized map.');
    }
    final WorldRegion region = _state.regions.values.single;
    final List<WorldSite> sites = _state.sites.values.toList()
      ..sort((WorldSite a, WorldSite b) => a.id.compareTo(b.id));
    final Set<String> resourceKinds = <String>{
      for (final WorldSite site in sites)
        for (final NaturalResourceDeposit resource in site.resourceDeposits)
          resource.kind,
    };
    final Set<String> species = <String>{
      for (final WorldSite site in sites)
        for (final EcologicalPopulationState population
            in site.ecologicalPopulations)
          population.speciesCode,
    };
    for (final WorldSite site in sites) {
      for (final EcologicalPopulationState population
          in site.ecologicalPopulations) {
        final String? required = population.requiredResourceKind;
        if (required != null && !resourceKinds.contains(required)) {
          throw StateError(
            'Population ${population.id} lacks resource $required.',
          );
        }
        final String? food = population.foodSpeciesCode;
        if (food != null && !species.contains(food)) {
          throw StateError('Population ${population.id} lacks food $food.');
        }
      }
    }
    final String fingerprint = WorldGenerator.fingerprintOf(
      rootSeed: record.rootSeed,
      generatorVersion: record.generatorVersion,
      configId: record.configId,
      region: region,
      sites: sites,
    );
    if (fingerprint != record.fingerprint) {
      throw StateError('World genesis fingerprint does not match the map.');
    }
    _replace(
      worldGenesis: record,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'world_genesis_completed',
          region.id,
          'seed=${record.rootSeed} version=${record.generatorVersion} '
              'config=${record.configId} fingerprint=${record.fingerprint} '
              'regions=${record.regionCount} sites=${record.siteCount}',
        ),
      ],
    );
  }

  void _applyNaturalResourceExtracted(ScheduledEvent event) {
    final String siteId = event.payload['site_id']! as String;
    final String resourceId = event.payload['resource_id']! as String;
    final int amount = event.payload['amount']! as int;
    final String outputItemId = event.payload['output_item_id']! as String;
    final String? actorId = event.payload['actor_id'] as String?;
    final String? ownerHouseholdId =
        event.payload['owner_household_id'] as String?;
    final WorldSite? site = _state.sites[siteId];
    if (site == null) throw StateError('Unknown site: $siteId');
    final NaturalResourceDeposit resource = site.resourceDeposits.firstWhere(
      (NaturalResourceDeposit value) => value.id == resourceId,
      orElse: () => throw StateError('Unknown resource: $resourceId'),
    );
    if (actorId != null) {
      final PersonState? actor = _state.people[actorId];
      if (actor?.point == null || !site.contains(actor!.point!)) {
        _replace(
          facts: <WorldFact>[
            ..._state.facts,
            _fact(
              'natural_resource_extraction_failed',
              resourceId,
              'site=$siteId actor=$actorId reason=actor_not_present',
            ),
          ],
        );
        return;
      }
    }
    if (amount <= 0 || amount > resource.quantity) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'natural_resource_extraction_failed',
            resourceId,
            'site=$siteId actor=${actorId ?? 'none'} '
                'requested=$amount available=${resource.quantity}',
          ),
        ],
      );
      return;
    }
    final String outputKind = switch (resource.kind) {
      'surface_water' => 'raw_surface_water',
      'fertile_topsoil' => 'fertile_soil',
      'timber_stand' => 'raw_timber',
      'mixed_stone_ore' => 'mixed_stone_ore',
      _ => 'raw_${resource.kind}',
    };
    final CareItemState? existing = _state.items[outputItemId];
    if (existing != null &&
        (existing.kind != outputKind || existing.unit != resource.unit)) {
      throw StateError('Extraction output $outputItemId is incompatible.');
    }
    if (existing != null &&
        (!site.contains(
              WorldPoint(existing.positionMm, existing.positionYMm),
            ) ||
            (ownerHouseholdId != null &&
                existing.ownerHouseholdId != ownerHouseholdId))) {
      throw StateError('Extraction output $outputItemId is at another ledger.');
    }
    final CareItemState output = existing == null
        ? CareItemState(
            id: outputItemId,
            kind: outputKind,
            positionMm: site.center.xMm,
            positionYMm: site.center.yMm,
            quantity: amount,
            condition: resource.quality,
            unit: resource.unit,
            ownerHouseholdId: ownerHouseholdId,
          )
        : existing.replenish(amount);
    _replace(
      sites: <String, WorldSite>{
        ..._state.sites,
        siteId: site.replaceResource(resource.extract(amount)),
      },
      items: <String, CareItemState>{..._state.items, outputItemId: output},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'natural_resource_extracted',
          resourceId,
          'site=$siteId actor=${actorId ?? 'none'} amount=$amount '
              'unit=${resource.unit} output=$outputItemId '
              'remaining=${resource.quantity - amount}',
        ),
      ],
    );
  }

  void _applyNaturalResourceYearlyRenewal(ScheduledEvent event) {
    final Map<String, WorldSite> sites = <String, WorldSite>{};
    final List<WorldFact> facts = <WorldFact>[..._state.facts];
    for (final WorldSite site in _state.sites.values) {
      final WorldSite renewed = site.renewResourcesOneYear();
      sites[site.id] = renewed;
      for (int index = 0; index < site.resourceDeposits.length; index++) {
        final NaturalResourceDeposit before = site.resourceDeposits[index];
        final NaturalResourceDeposit after = renewed.resourceDeposits[index];
        final int restored = after.quantity - before.quantity;
        if (restored > 0) {
          facts.add(
            _fact(
              'natural_resource_renewed',
              before.id,
              'site=${site.id} restored=$restored unit=${before.unit} '
                  'quantity=${after.quantity} capacity=${after.capacity}',
            ),
          );
        }
      }
    }
    _replace(sites: sites, facts: facts);
    schedule(
      due: _state.now.addDays(365),
      phase: EventPhase.transfer,
      kind: 'natural_resource_yearly_renewal',
    );
  }

  void _applyEcologyYearlyTick(ScheduledEvent event) {
    final Map<String, int> resourceQuantity = <String, int>{};
    final Map<String, int> resourceCapacity = <String, int>{};
    final Map<String, int> speciesPopulation = <String, int>{};
    final Map<String, int> speciesCapacity = <String, int>{};
    for (final WorldSite site in _state.sites.values) {
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
    int ratio(Map<String, int> values, Map<String, int> capacities, String id) {
      final int capacity = capacities[id] ?? 0;
      return capacity <= 0
          ? 0
          : ((values[id] ?? 0) * 1000 ~/ capacity).clamp(0, 1000).toInt();
    }

    final Map<String, WorldSite> sites = <String, WorldSite>{};
    final List<WorldFact> facts = <WorldFact>[..._state.facts];
    for (final WorldSite site in _state.sites.values) {
      final List<EcologicalPopulationState> populations =
          <EcologicalPopulationState>[];
      for (final EcologicalPopulationState before
          in site.ecologicalPopulations) {
        int support = 1000;
        final String? required = before.requiredResourceKind;
        if (required != null) {
          final int resourceSupport = ratio(
            resourceQuantity,
            resourceCapacity,
            required,
          );
          if (resourceSupport < support) support = resourceSupport;
        }
        final String? food = before.foodSpeciesCode;
        if (food != null) {
          final int foodSupport = ratio(
            speciesPopulation,
            speciesCapacity,
            food,
          );
          if (foodSupport < support) support = foodSupport;
        }
        final EcologicalPopulationState after = before.advanceYear(
          supportPerMille: support,
        );
        populations.add(after);
        facts.add(
          _fact(
            'ecological_population_advanced',
            before.id,
            'site=${site.id} species=${before.speciesCode} '
                'before=${before.population} after=${after.population} '
                'capacity=${after.carryingCapacity} support=$support '
                'health=${after.health}',
          ),
        );
      }
      sites[site.id] = site.withEcologicalPopulations(populations);
    }
    _replace(sites: sites, facts: facts);
    schedule(
      due: _state.now.addDays(365),
      phase: EventPhase.bookkeeping,
      kind: 'ecology_yearly_tick',
    );
  }

  /// Dưới mức đủ nước này thì cơ thể đổ bệnh.
  static const int _illnessHydrationFloor = 700;

  /// Từ mức mệt này trở lên thì kiệt sức thành bệnh.
  static const int _illnessFatigueCeiling = 900;

  /// Người lớn đổ bệnh khi cơ thể thật đã quá giới hạn.
  ///
  /// Không có hẹn giờ và không có xác suất: bệnh đến từ mất nước nặng hoặc
  /// kiệt sức, hai thứ đã là số thật trong cơ thể và sổ lao động. Bản đầu chưa
  /// có bộ sinh số ngẫu nhiên theo seed, nên ngưỡng xác định là cách trung
  /// thực nhất để chuỗi nhân quả kiểm chứng được.
  void _checkAdultIllnessOnset(String householdId, String personId) {
    final PersonState? person = _state.people[personId];
    final AdultBodyState? body = person?.body;
    final PersonAgenda? agenda = person?.agenda;
    if (person == null || body == null || agenda == null) return;
    if (person.infancy != null) return;
    if (_activeIllness(personId) != null) return;
    final String? cause = body.hydration <= _illnessHydrationFloor
        ? 'mat_nuoc'
        : agenda.fatigue >= _illnessFatigueCeiling
        ? 'kiet_suc'
        : null;
    if (cause == null) return;
    final int index = _state.illnesses.keys
        .where((String id) => id.startsWith('ILL-$personId-'))
        .length;
    final String illnessId = 'ILL-$personId-${index + 1}';
    // Mất nước nặng hơn kiệt sức, và càng thiếu thì càng nặng.
    final int severity = cause == 'mat_nuoc'
        ? (300 + (_illnessHydrationFloor - body.hydration)).clamp(300, 800)
        : (250 + (agenda.fatigue - _illnessFatigueCeiling)).clamp(250, 600);
    final IllnessState illness = IllnessState(
      id: illnessId,
      personId: personId,
      kind: cause == 'mat_nuoc' ? 'adult_dehydration' : 'adult_exhaustion',
      onsetSeconds: _state.now.seconds,
      stage: IllnessStage.symptomatic,
      severity: severity,
      bodyTemperatureMilliC: 37600,
      symptoms: cause == 'mat_nuoc'
          ? const <String>['dizzy', 'dry_mouth', 'weak_pulse']
          : const <String>['aching', 'heavy_limbs', 'poor_sleep'],
    );
    _replace(
      illnesses: <String, IllnessState>{
        ..._state.illnesses,
        illnessId: illness,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'adult_illness_onset',
          personId,
          'illness=$illnessId cause=$cause severity=$severity '
              'hydration=${body.hydration} fatigue=${agenda.fatigue}',
        ),
      ],
    );
    // Không cần dừng khối đang chạy ở đây: bệnh khởi phát lúc chốt ngày
    // 22:00, khi mọi khối việc trong ngày đã xong. Việc chặn nghỉ do
    // _competingObligation lo, và nó chặn từ khối đầu tiên của hôm sau.
    schedule(
      due: _state.now.addSeconds(1800),
      phase: EventPhase.observation,
      kind: 'adult_illness_observed',
      payload: <String, Object?>{
        'household_id': householdId,
        'person_id': personId,
        'illness_id': illnessId,
      },
    );
    schedule(
      due: _state.now.addSeconds(6 * 3600),
      phase: EventPhase.bookkeeping,
      kind: 'illness_progress',
      payload: <String, Object?>{'illness_id': illnessId},
    );
  }

  /// Người trong hộ nhận ra có người đang ốm và cử người tới chăm.
  void _applyAdultIllnessObserved(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String personId = event.payload['person_id']! as String;
    final String illnessId = event.payload['illness_id']! as String;
    final IllnessState? illness = _state.illnesses[illnessId];
    final HouseholdState? household = _state.households[householdId];
    if (illness == null || !illness.active || household == null) return;
    final String? waterId = household.resourceItemIds['water'];
    // Người chăm phải khác người bệnh, còn sức, và có quyền lấy nước.
    final List<String> carers =
        household.memberIds.where((String id) {
          if (id == personId) return false;
          final PersonState? candidate = _state.people[id];
          if (candidate == null || candidate.infancy != null) return false;
          if (_activeIllness(id) != null) return false;
          if (waterId != null && !household.canUse(id, waterId)) return false;
          return true;
        }).toList()..sort((String a, String b) {
          final int skillA = _state.people[a]!.caregiverAgent?.careSkill ?? 0;
          final int skillB = _state.people[b]!.caregiverAgent?.careSkill ?? 0;
          final int bySkill = skillB.compareTo(skillA);
          return bySkill != 0 ? bySkill : a.compareTo(b);
        });
    final String? carer = carers.firstOrNull;
    if (carer == null) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'adult_illness_unattended',
            personId,
            'illness=$illnessId severity=${illness.severity}',
          ),
        ],
      );
      return;
    }
    _replace(
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'adult_illness_detected',
          personId,
          'illness=$illnessId carer=$carer severity=${illness.severity}',
        ),
      ],
    );
    schedule(
      due: _state.now.addSeconds(600),
      phase: EventPhase.transfer,
      kind: 'adult_illness_care',
      payload: <String, Object?>{...event.payload, 'carer_id': carer},
    );
  }

  /// Chăm người ốm: tốn nước thật của hộ và hạ mức bệnh.
  void _applyAdultIllnessCare(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String personId = event.payload['person_id']! as String;
    final String illnessId = event.payload['illness_id']! as String;
    final String carerId = event.payload['carer_id']! as String;
    final IllnessState? illness = _state.illnesses[illnessId];
    final HouseholdState? household = _state.households[householdId];
    if (illness == null || !illness.active || household == null) return;
    const int careWaterMl = 400;
    final String? waterId = household.resourceItemIds['water'];
    final CareItemState? water = waterId == null ? null : _state.items[waterId];
    if (water == null ||
        water.quantity < careWaterMl ||
        !household.canUse(carerId, water.id)) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'adult_illness_care_failed',
            personId,
            'illness=$illnessId carer=$carerId reason=thieu_nuoc_hoac_quyen',
          ),
        ],
      );
      return;
    }
    // Nước uống vào cũng bù lại phần cơ thể đang thiếu.
    final PersonState? patient = _state.people[personId];
    final AdultBodyState? body = patient?.body;
    final IllnessState cared = illness.afterCare(20);
    _replace(
      people: patient == null || body == null
          ? null
          : <String, PersonState>{
              ..._state.people,
              personId: patient.withBody(body.drink(careWaterMl)),
            },
      items: <String, CareItemState>{
        ..._state.items,
        water.id: water.consume(careWaterMl),
      },
      illnesses: <String, IllnessState>{..._state.illnesses, illnessId: cared},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'adult_illness_care_completed',
          personId,
          'illness=$illnessId carer=$carerId water_ml=$careWaterMl '
              'severity=${cared.severity}',
        ),
      ],
    );
  }

  /// Bệnh đang hoạt động của một người, nếu có.
  IllnessState? _activeIllness(String personId) => _state.illnesses.values
      .where((IllnessState value) => value.personId == personId && value.active)
      .firstOrNull;

  /// Sức lực thật sau khi tính cả bệnh.
  ///
  /// Bệnh nặng 1000 lấy đi một nửa sức làm việc; không có cơ thể thì coi như
  /// đủ sức và bệnh không có gì để trừ vào.
  int _effectiveCapability(PersonState person) {
    final int base = person.body?.capability ?? 1000;
    final IllnessState? illness = _activeIllness(person.id);
    if (illness == null) return base;
    return base * (1000 - illness.severity ~/ 2) ~/ 1000;
  }

  /// Sức lực của người chở, phần nghìn; chưa có cơ thể thì coi như đủ sức.
  int _carrierCapability(PersonState carrier) => _effectiveCapability(carrier);

  /// Tốc độ đi trên đường bằng của người này.
  int _carrierBaseSpeed(PersonState carrier) =>
      carrier.caregiverAgent?.movementSpeedMmPerSecond ??
      CarrierPace.baseSpeedMmPerSecond;

  /// Xếp lịch cho người chở đi hết một chặng của tuyến.
  ///
  /// Thời gian đi ra từ quãng đường chia cho tốc độ thật, chứ không phải một
  /// giờ đến viết sẵn. Chặng nào chậm hơn dự kiến thì chuyến hàng trễ thêm.
  void _scheduleRouteLeg({
    required SupplyJourneyState journey,
    required TradeRoute route,
    required int legIndex,
  }) {
    final List<String> path = journey.pathWaypointIds;
    if (legIndex + 1 >= path.length) return;
    final RouteLeg? leg = route.legBetween(path[legIndex], path[legIndex + 1]);
    final PersonState? carrier = _state.people[journey.carrierId];
    if (leg == null || carrier == null) return;
    final int distance = route.legDistanceMm(leg);
    final int speed = CarrierPace.speedMmPerSecond(
      terrainSpeedPerMille: leg.terrainSpeedPerMille,
      cargo: journey.cargo,
      capabilityPerMille: _carrierCapability(carrier),
      baseSpeed: _carrierBaseSpeed(carrier),
    );
    final int seconds = CarrierPace.travelSeconds(
      distanceMm: distance,
      speedMmPerSecond: speed,
    );
    // Giờ đi nếu đường bằng, người khỏe và tay không: dùng để đo phần trễ.
    final int nominalSeconds = CarrierPace.travelSeconds(
      distanceMm: distance,
      speedMmPerSecond: _carrierBaseSpeed(carrier),
    );
    _replace(
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'route_leg_started',
          journey.id,
          'leg=${leg.fromId}->${leg.toId} terrain=${leg.terrain} '
              'distance_mm=$distance speed_mm_s=$speed '
              'seconds=$seconds nominal_seconds=$nominalSeconds',
        ),
      ],
    );
    schedule(
      due: _state.now.addSeconds(seconds < 1 ? 1 : seconds),
      phase: EventPhase.movement,
      kind: 'route_leg_arrived',
      payload: <String, Object?>{
        'journey_id': journey.id,
        'leg_index': legIndex,
        'nominal_seconds': nominalSeconds,
        'actual_seconds': seconds,
      },
    );
  }

  void _applyRouteLegArrived(ScheduledEvent event) {
    final String journeyId = event.payload['journey_id']! as String;
    final int legIndex = event.payload['leg_index']! as int;
    final SupplyJourneyState? journey = _state.supplyJourneys[journeyId];
    if (journey == null || journey.status == SupplyJourneyStatus.delivered) {
      return;
    }
    final TradeRoute? route = _state.routes[journey.routeId];
    final List<String> path = journey.pathWaypointIds;
    if (route == null || legIndex + 1 >= path.length) return;
    final RouteLeg? leg = route.legBetween(path[legIndex], path[legIndex + 1]);
    final RouteWaypoint? arrivedAt = route.waypoint(path[legIndex + 1]);
    final PersonState? carrier = _state.people[journey.carrierId];
    if (leg == null || arrivedAt == null || carrier == null) return;

    // Chặng đi lâu hơn mức đường bằng thì chuyến hàng trễ thêm bấy nhiêu.
    final int nominal = event.payload['nominal_seconds'] as int? ?? 0;
    final int actual = event.payload['actual_seconds'] as int? ?? 0;
    final int lost = (actual - nominal).clamp(0, gameSecondsPerDay);
    SupplyJourneyState next = journey.advanceLeg(
      legIndex: legIndex + 1,
      currentLeg: arrivedAt.id,
      travelledMm: journey.travelledMm + route.legDistanceMm(leg),
    );
    if (lost > 0) {
      next = next.slowedBy(seconds: lost, reason: leg.terrain);
    }
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        journey.carrierId: carrier.withPosition(
          arrivedAt.positionMm,
          arrivedAt.positionYMm,
        ),
      },
      supplyJourneys: <String, SupplyJourneyState>{
        ..._state.supplyJourneys,
        journeyId: next,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'route_leg_arrived',
          journeyId,
          'waypoint=${arrivedAt.id} name=${arrivedAt.name} '
              'position_mm=${arrivedAt.positionMm} '
              'travelled_mm=${next.travelledMm} late_seconds=$lost',
        ),
      ],
    );
    if (legIndex + 2 < path.length) {
      _scheduleRouteLeg(journey: next, route: route, legIndex: legIndex + 1);
      return;
    }
    // Hết chặng cuối thì giao hàng.
    schedule(
      due: _state.now,
      phase: EventPhase.transfer,
      kind: 'supply_journey_arrived',
      payload: <String, Object?>{
        'journey_id': journeyId,
        'household_id': journey.householdId,
        'carrier_id': journey.carrierId,
        'journey_index': 0,
      },
    );
  }

  void _applySupplyJourneyStarted(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String carrierId = event.payload['carrier_id']! as String;
    final int index = event.payload['journey_index']! as int;
    if (_state.households[householdId] == null ||
        _state.people[carrierId] == null) {
      return;
    }
    final String journeyId = 'SUP-$householdId-$index';
    final String? routeId = event.payload['route_id'] as String?;
    final TradeRoute? route = routeId == null ? null : _state.routes[routeId];
    if (route != null) {
      _startRoutedJourney(
        journeyId: journeyId,
        householdId: householdId,
        carrierId: carrierId,
        route: route,
      );
      _scheduleNextJourney(event);
      return;
    }
    final int expectedArrival = _state.now.seconds + 12 * 3600;
    final SupplyJourneyState journey = SupplyJourneyState(
      id: journeyId,
      householdId: householdId,
      carrierId: carrierId,
      departureSeconds: _state.now.seconds,
      expectedArrivalSeconds: expectedArrival,
      status: SupplyJourneyStatus.traveling,
      cargo: const <String, int>{
        'food': 7500,
        'water': 30000,
        'infant_feed': 1500,
      },
      currentLeg: 'eastern_mountain_road',
    );
    final PersonState carrier = _state.people[carrierId]!;
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        carrierId: carrier.withPosition(250000),
      },
      supplyJourneys: <String, SupplyJourneyState>{
        ..._state.supplyJourneys,
        journeyId: journey,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'supply_journey_started',
          journeyId,
          'carrier=$carrierId expected_seconds=$expectedArrival food_g=7500 water_ml=30000 infant_feed_ml=1500',
        ),
      ],
    );
    schedule(
      due: SimTime(expectedArrival),
      phase: EventPhase.observation,
      kind: 'supply_journey_checkpoint',
      payload: <String, Object?>{...event.payload, 'journey_id': journeyId},
    );
  }

  void _applySupplyJourneyCheckpoint(ScheduledEvent event) {
    final String journeyId = event.payload['journey_id']! as String;
    final SupplyJourneyState? journey = _state.supplyJourneys[journeyId];
    if (journey == null || journey.status == SupplyJourneyStatus.delivered) {
      return;
    }
    final int delaySeconds = event.payload['delay_seconds'] as int? ?? 0;
    if (delaySeconds > 0) {
      final SupplyJourneyState delayed = journey.delayed(
        seconds: delaySeconds,
        reason: 'muddy_mountain_road',
      );
      _replace(
        supplyJourneys: <String, SupplyJourneyState>{
          ..._state.supplyJourneys,
          journeyId: delayed,
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'supply_journey_delayed',
            journeyId,
            'reason=muddy_mountain_road delay_seconds=$delaySeconds carrier=${journey.carrierId}',
          ),
        ],
      );
    }
    schedule(
      due: _state.now.addSeconds(delaySeconds),
      phase: EventPhase.transfer,
      kind: 'supply_journey_arrived',
      payload: event.payload,
    );
  }

  void _applySupplyJourneyArrived(ScheduledEvent event) {
    final String journeyId = event.payload['journey_id']! as String;
    final SupplyJourneyState? journey = _state.supplyJourneys[journeyId];
    if (journey == null || journey.status == SupplyJourneyStatus.delivered) {
      return;
    }
    final SupplyJourneyState delivered = journey.delivered(_state.now.seconds);
    final PersonState? carrier = _state.people[journey.carrierId];
    final RoomState? yard = _state.rooms['ROOM-YARD'];
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        if (carrier != null)
          carrier.id: yard == null
              ? carrier.withPosition(12000)
              : carrier.withLocation(
                  positionMm: yard.anchorPositionMm,
                  roomId: yard.id,
                ),
      },
      supplyJourneys: <String, SupplyJourneyState>{
        ..._state.supplyJourneys,
        journeyId: delivered,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'supply_journey_arrived',
          journeyId,
          'carrier=${journey.carrierId} delay_seconds=${journey.delaySeconds}',
        ),
      ],
    );
    _applyHouseholdSupplyDelivery(
      ScheduledEvent(
        id: 'delivery-$journeyId',
        due: _state.now,
        phase: EventPhase.transfer,
        sequence: event.sequence,
        kind: 'household_supply_delivery',
        payload: <String, Object?>{
          'household_id': journey.householdId,
          'single_delivery': true,
          'journey_id': journeyId,
        },
      ),
    );
    final int nextIndex = (event.payload['journey_index']! as int) + 1;
    final SimTime nextDeparture = SimTime(
      journey.departureSeconds + 5 * gameSecondsPerDay,
    );
    if (nextDeparture.seconds < 30 * gameSecondsPerDay) {
      schedule(
        due: nextDeparture,
        phase: EventPhase.movement,
        kind: 'supply_journey_started',
        payload: <String, Object?>{
          'household_id': journey.householdId,
          'carrier_id': journey.carrierId,
          'journey_index': nextIndex,
          if (journey.routeId != null) 'route_id': journey.routeId,
          if (journey.routeId == null)
            'delay_seconds': nextIndex.isEven ? 6 * 3600 : 0,
        },
      );
    }
  }

  /// Xếp chuyến kế tiếp cho tuyến thật, năm ngày một lần như nhánh cũ.
  void _scheduleNextJourney(ScheduledEvent event) {
    final int nextIndex = (event.payload['journey_index']! as int) + 1;
    final SimTime nextDeparture = _state.now.addDays(5);
    if (nextDeparture.seconds >= 30 * gameSecondsPerDay) return;
    schedule(
      due: nextDeparture,
      phase: EventPhase.movement,
      kind: 'supply_journey_started',
      payload: <String, Object?>{...event.payload, 'journey_index': nextIndex},
    );
  }

  int _familyWitnessTrust(
    HouseholdState household,
    String personId, [
    Map<String, PersonState>? people,
  ]) {
    if (!household.familyCareWitnessMemory) return 500;
    final Map<String, PersonState> source = people ?? _state.people;
    final List<int> trust = <int>[
      for (final String witnessId in household.birthFamilyRolesByPersonId.keys)
        if (witnessId != personId && source[witnessId] != null)
          source[witnessId]!.familyBonds[personId]?.trust ?? 500,
    ];
    if (trust.isEmpty) return 500;
    return trust.fold(0, (int total, int value) => total + value) ~/
        trust.length;
  }

  PersonState? _selectAvailableCaregiver(
    PersonState infant,
    String preferredId,
  ) {
    final HouseholdState? household = infant.householdId == null
        ? null
        : _state.households[infant.householdId];
    bool canProvideCare(PersonState person) {
      if (person.caregiverAgent?.available != true) return false;
      if (household?.familyCareScheduling != true) return true;
      if (person.caregiverAgent!.careSkill < 400) return false;
      if (person.routine?.blockingActivity != null) return false;
      final String? feedId = household!.resourceItemIds['infant_feed'];
      return feedId != null && household.canUse(person.id, feedId);
    }

    final PersonState? preferred = _state.people[preferredId];
    if (household?.familyMemory != true &&
        preferred != null &&
        canProvideCare(preferred)) {
      return preferred;
    }
    final List<PersonState> candidates =
        _state.people.values
            .where(
              (PersonState person) =>
                  person.householdId == infant.householdId &&
                  person.id != infant.id &&
                  canProvideCare(person),
            )
            .toList()
          ..sort((PersonState a, PersonState b) {
            if (household?.familyMemory == true) {
              final String? plannedCaregiverId = household?.familyCarePlan
                  ?.shiftAt(_state.now.seconds)
                  ?.caregiverId;
              int willingness(PersonState person) {
                final FamilyBondState? bond = person.familyBonds[infant.id];
                return person.caregiverAgent!.careSkill +
                    (bond?.careCommitment ?? 0) +
                    ((household
                                ?.familyCareReliabilityByPersonId[person.id]
                                ?.score ??
                            500) -
                        500) +
                    (_familyWitnessTrust(household!, person.id) - 500) +
                    (person.id == plannedCaregiverId ? 900 : 0) +
                    (person.id == preferredId ? 40 : 0) -
                    (person.agenda?.fatigue ?? 0) ~/ 2;
              }

              final int byWillingness = willingness(
                b,
              ).compareTo(willingness(a));
              if (byWillingness != 0) return byWillingness;
            }
            final int bySkill = b.caregiverAgent!.careSkill.compareTo(
              a.caregiverAgent!.careSkill,
            );
            return bySkill != 0 ? bySkill : a.id.compareTo(b.id);
          });
    return candidates.firstOrNull;
  }

  FamilyCareSupportRequestState? _recordFamilyCareCoverage({
    required PersonState infant,
    required PersonState? caregiver,
    required String trigger,
  }) {
    final String? householdId = infant.householdId;
    final HouseholdState? household = householdId == null
        ? null
        : _state.households[householdId];
    if (household?.familyCareSupport != true) return null;
    final FamilyCareShiftState? shift = household!.familyCarePlan?.shiftAt(
      _state.now.seconds,
    );
    final String? plannedId = shift?.caregiverId;
    if (plannedId != null && caregiver?.id == plannedId) return null;
    final PersonState? planned = plannedId == null
        ? null
        : _state.people[plannedId];
    final String reason = shift == null
        ? 'care_plan_missing'
        : plannedId == null
        ? 'shift_uncovered'
        : planned == null
        ? 'planned_caregiver_missing'
        : planned.caregiverAgent?.available != true
        ? 'planned_caregiver_unavailable'
        : planned.routine?.blockingActivity != null
        ? 'planned_caregiver_busy'
        : 'planned_caregiver_ineligible';
    final bool waitForSupport =
        caregiver == null && household.familyCareResilience;
    final int? nextRetryAtSeconds = waitForSupport
        ? _state.now.seconds + 15 * 60
        : null;
    final FamilyCareSupportRequestState request = FamilyCareSupportRequestState(
      id:
          'SUPPORT-${household.id}-${_state.now.seconds}-'
          '${household.familyCareSupportRequests.length}',
      shiftId: shift?.id,
      infantId: infant.id,
      openedAtSeconds: _state.now.seconds,
      reason: reason,
      status: waitForSupport
          ? FamilyCareSupportStatus.pending
          : caregiver == null
          ? FamilyCareSupportStatus.failed
          : FamilyCareSupportStatus.fulfilled,
      trigger: trigger,
      plannedCaregiverId: plannedId,
      supporterId: caregiver?.id,
      lastAttemptAtSeconds: _state.now.seconds,
      nextRetryAtSeconds: nextRetryAtSeconds,
      resolvedAtSeconds: caregiver == null ? null : _state.now.seconds,
    );
    HouseholdState recordedHousehold = household.recordFamilyCareSupport(
      request,
    );
    FamilyCareConflictState? conflict;
    if (caregiver != null) {
      recordedHousehold = recordedHousehold.recordEmergencyCareBurden(
        plannedCaregiverId: plannedId,
        supporterId: caregiver.id,
        atSeconds: _state.now.seconds,
        delaySeconds: 0,
      );
      conflict = _newFamilyCareConflict(
        household: recordedHousehold,
        request: request,
        supporterId: caregiver.id,
      );
      if (conflict != null) {
        recordedHousehold = recordedHousehold.recordFamilyCareConflict(
          conflict,
        );
      }
    }
    _replace(
      households: <String, HouseholdState>{
        ..._state.households,
        household.id: recordedHousehold,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'family_care_shift_broken',
          household.id,
          'shift=${shift?.id ?? 'missing'} planned=${plannedId ?? 'none'} '
              'reason=$reason trigger=$trigger',
        ),
        _fact(
          waitForSupport
              ? 'family_care_support_waiting'
              : caregiver == null
              ? 'family_care_support_failed'
              : 'family_care_support_called',
          caregiver?.id ?? household.id,
          'request=${request.id} infant=${infant.id} '
          'planned=${plannedId ?? 'none'} reason=$reason trigger=$trigger',
        ),
        if (caregiver != null &&
            plannedId != caregiver.id &&
            household.familyCareBurdenEnabled)
          _fact(
            'family_care_debt_created',
            household.id,
            'planned=${plannedId ?? 'none'} supporter=${caregiver.id} '
                'delay_seconds=0',
          ),
        if (conflict != null)
          _fact(
            'family_care_conflict_opened',
            household.id,
            'conflict=${conflict.id} supporter=${conflict.supporterId} '
                'responsible=${conflict.responsibleId} '
                'severity=${conflict.severity}',
          ),
      ],
    );
    if (conflict != null) _scheduleFamilyCareConflict(conflict);
    return request;
  }

  void _waitForFamilyCareSupport(FamilyCareSupportRequestState request) {
    final PersonState? infant = _state.people[request.infantId];
    final InfantState? infancy = infant?.infancy;
    final int? retryAt = request.nextRetryAtSeconds;
    if (infant == null || infancy == null || retryAt == null) return;
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        infant.id: infant.withInfancy(infancy.withCareResponsePending(true)),
      },
    );
    schedule(
      due: SimTime(retryAt),
      phase: EventPhase.observation,
      kind: 'family_care_support_retry',
      payload: <String, Object?>{
        'household_id': infant.householdId,
        'request_id': request.id,
      },
    );
  }

  void _applyFamilyCareSupportRetry(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String requestId = event.payload['request_id']! as String;
    final HouseholdState? household = _state.households[householdId];
    final FamilyCareSupportRequestState? request = household
        ?.familyCareSupportRequests
        .where((FamilyCareSupportRequestState value) => value.id == requestId)
        .firstOrNull;
    if (household == null ||
        request == null ||
        request.status != FamilyCareSupportStatus.pending) {
      return;
    }
    final PersonState? infant = _state.people[request.infantId];
    final InfantState? infancy = infant?.infancy;
    if (infant == null || infancy == null) return;
    final String preferredId =
        request.plannedCaregiverId ?? infancy.caregiverId;
    final PersonState? caregiver = _selectAvailableCaregiver(
      infant,
      preferredId,
    );
    if (caregiver != null) {
      final FamilyCareSupportRequestState fulfilled = request.fulfill(
        supporterId: caregiver.id,
        atSeconds: _state.now.seconds,
      );
      HouseholdState updatedHousehold = household
          .updateFamilyCareSupport(fulfilled)
          .recordEmergencyCareBurden(
            plannedCaregiverId: request.plannedCaregiverId,
            supporterId: caregiver.id,
            atSeconds: _state.now.seconds,
            delaySeconds: fulfilled.responseDelaySeconds ?? 0,
          );
      final FamilyCareConflictState? conflict = _newFamilyCareConflict(
        household: updatedHousehold,
        request: fulfilled,
        supporterId: caregiver.id,
      );
      if (conflict != null) {
        updatedHousehold = updatedHousehold.recordFamilyCareConflict(conflict);
      }
      _replace(
        households: <String, HouseholdState>{
          ..._state.households,
          householdId: updatedHousehold,
        },
        people: <String, PersonState>{
          ..._state.people,
          infant.id: infant.withInfancy(infancy.withCareResponsePending(false)),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'family_care_support_arrived_late',
            caregiver.id,
            'request=${request.id} infant=${infant.id} '
                'delay_seconds=${fulfilled.responseDelaySeconds} '
                'attempts=${fulfilled.attempts}',
          ),
          if (household.familyCareBurdenEnabled &&
              request.plannedCaregiverId != caregiver.id)
            _fact(
              'family_care_debt_created',
              householdId,
              'planned=${request.plannedCaregiverId ?? 'none'} '
                  'supporter=${caregiver.id} '
                  'delay_seconds=${fulfilled.responseDelaySeconds ?? 0}',
            ),
          if (conflict != null)
            _fact(
              'family_care_conflict_opened',
              householdId,
              'conflict=${conflict.id} supporter=${conflict.supporterId} '
                  'responsible=${conflict.responsibleId} '
                  'severity=${conflict.severity}',
            ),
        ],
      );
      if (conflict != null) _scheduleFamilyCareConflict(conflict);
      final PersonState refreshedInfant = _state.people[infant.id]!;
      if (request.trigger == 'illness_care') {
        _beginIllnessCareResponse(
          infant: refreshedInfant,
          caregiver: caregiver,
          preferredCaregiverId: preferredId,
          payload: <String, Object?>{
            'person_id': infant.id,
            'caregiver_id': caregiver.id,
          },
        );
      } else {
        _beginCryResponse(
          infant: refreshedInfant,
          infancy: refreshedInfant.infancy!,
          caregiver: caregiver,
          requestedAtSeconds: request.openedAtSeconds,
        );
      }
      return;
    }

    if (request.attempts >= 3) {
      final FamilyCareSupportRequestState expired = request.expire(
        _state.now.seconds,
      );
      final int delaySeconds = _state.now.seconds - request.openedAtSeconds;
      InfantState harmed = infancy.markCareUnmet(delaySeconds: delaySeconds);
      if (household.infantAttachmentLearning) {
        harmed = harmed.recordMissedCare(
          caregiverId: request.plannedCaregiverId ?? infancy.caregiverId,
          atSeconds: _state.now.seconds,
          delaySeconds: delaySeconds,
        );
      }
      _replace(
        households: <String, HouseholdState>{
          ..._state.households,
          householdId: household.updateFamilyCareSupport(expired),
        },
        people: <String, PersonState>{
          ..._state.people,
          infant.id: infant.withInfancy(harmed),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'family_care_support_expired',
            infant.id,
            'request=${request.id} delay_seconds=$delaySeconds '
                'attempts=${expired.attempts}',
          ),
          _fact(
            'infant_care_delayed_harm',
            infant.id,
            'request=${request.id} attachment=${infancy.attachment}->'
                '${harmed.attachment}',
          ),
          if (household.infantAttachmentLearning)
            _fact(
              'infant_caregiver_expectation_missed',
              infant.id,
              'caregiver=${request.plannedCaregiverId ?? infancy.caregiverId} '
                  'delay_seconds=$delaySeconds',
            ),
        ],
      );
      return;
    }

    final int nextRetryAt = _state.now.seconds + 15 * 60;
    final FamilyCareSupportRequestState retrying = request.retryAt(
      atSeconds: _state.now.seconds,
      nextRetryAtSeconds: nextRetryAt,
    );
    _replace(
      households: <String, HouseholdState>{
        ..._state.households,
        householdId: household.updateFamilyCareSupport(retrying),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'family_care_support_still_waiting',
          householdId,
          'request=${request.id} attempts=${retrying.attempts}',
        ),
      ],
    );
    schedule(
      due: SimTime(nextRetryAt),
      phase: EventPhase.observation,
      kind: 'family_care_support_retry',
      payload: event.payload,
    );
  }

  FamilyCareConflictState? _newFamilyCareConflict({
    required HouseholdState household,
    required FamilyCareSupportRequestState request,
    required String supporterId,
  }) {
    final String? responsibleId = request.plannedCaregiverId;
    if (!household.familyCareConflictEnabled ||
        responsibleId == null ||
        responsibleId == supporterId) {
      return null;
    }
    final bool alreadyOpen = household.familyCareConflicts.any(
      (FamilyCareConflictState value) =>
          value.status == FamilyCareConflictStatus.open &&
          value.supporterId == supporterId &&
          value.responsibleId == responsibleId,
    );
    if (alreadyOpen) return null;
    final FamilyCareBurdenState supporterBurden =
        household.familyCareBurdenByPersonId[supporterId] ??
        const FamilyCareBurdenState();
    final FamilyCareBurdenState responsibleBurden =
        household.familyCareBurdenByPersonId[responsibleId] ??
        const FamilyCareBurdenState();
    final int severity =
        (supporterBurden.strain + responsibleBurden.careDebt) ~/ 2;
    if (severity < 240) return null;
    return FamilyCareConflictState(
      id:
          'CONFLICT-${household.id}-${_state.now.seconds}-'
          '${household.familyCareConflicts.length}',
      supporterId: supporterId,
      responsibleId: responsibleId,
      causeRequestId: request.id,
      openedAtSeconds: _state.now.seconds,
      severity: severity.clamp(0, 1000),
    );
  }

  void _scheduleFamilyCareConflict(FamilyCareConflictState conflict) {
    schedule(
      due: _state.now.addSeconds(2 * 3600),
      phase: EventPhase.intent,
      kind: 'family_care_conflict_conversation',
      payload: <String, Object?>{'conflict_id': conflict.id},
    );
  }

  void _applyFamilyCareConflictConversation(ScheduledEvent event) {
    final String conflictId = event.payload['conflict_id']! as String;
    HouseholdState? household;
    FamilyCareConflictState? conflict;
    for (final HouseholdState candidate in _state.households.values) {
      final FamilyCareConflictState? found = candidate.familyCareConflicts
          .where((FamilyCareConflictState value) => value.id == conflictId)
          .firstOrNull;
      if (found != null) {
        household = candidate;
        conflict = found;
        break;
      }
    }
    if (household == null ||
        conflict == null ||
        conflict.status != FamilyCareConflictStatus.open) {
      return;
    }
    final PersonState? supporter = _state.people[conflict.supporterId];
    final PersonState? responsible = _state.people[conflict.responsibleId];
    if (supporter == null || responsible == null) return;
    final FamilyBondState supporterBond =
        supporter.familyBonds[responsible.id] ?? const FamilyBondState();
    final FamilyBondState responsibleBond =
        responsible.familyBonds[supporter.id] ?? const FamilyBondState();
    final int mutualTrust = (supporterBond.trust + responsibleBond.trust) ~/ 2;
    final int mutualAffection =
        (supporterBond.affection + responsibleBond.affection) ~/ 2;
    final int fatigue =
        ((supporter.agenda?.fatigue ?? 0) +
            (responsible.agenda?.fatigue ?? 0)) ~/
        2;
    final int repairScore =
        mutualTrust + mutualAffection - conflict.severity - fatigue ~/ 2;
    final bool repaired = repairScore >= 620;
    final FamilyCareConflictState concluded = conflict.conclude(
      atSeconds: _state.now.seconds,
      repaired: repaired,
      outcome: repaired ? 'accepted_repayment' : 'blame_unresolved',
    );
    final FamilyBondState nextSupporterBond = repaired
        ? supporterBond.recordReconciliation(
            atSeconds: _state.now.seconds,
            strength: conflict.severity,
          )
        : supporterBond.recordConflict(
            atSeconds: _state.now.seconds,
            severity: conflict.severity,
          );
    final FamilyBondState nextResponsibleBond = repaired
        ? responsibleBond.recordReconciliation(
            atSeconds: _state.now.seconds,
            strength: conflict.severity,
          )
        : responsibleBond.recordConflict(
            atSeconds: _state.now.seconds,
            severity: conflict.severity,
          );
    FamilyCarePromiseState? promise;
    HouseholdState updatedHousehold = household.updateFamilyCareConflict(
      concluded,
    );
    if (repaired && household.familyCarePromiseEnabled) {
      promise = FamilyCarePromiseState(
        id:
            'PROMISE-${household.id}-${_state.now.seconds}-'
            '${household.familyCarePromises.length}',
        debtorId: responsible.id,
        beneficiaryId: supporter.id,
        sourceConflictId: conflict.id,
        madeAtSeconds: _state.now.seconds,
        dueDay: _state.now.day + 1,
        promisedShifts: 1 + conflict.severity ~/ 500,
      );
      updatedHousehold = updatedHousehold.recordFamilyCarePromise(promise);
    }
    _replace(
      households: <String, HouseholdState>{
        ..._state.households,
        household.id: updatedHousehold,
      },
      people: <String, PersonState>{
        ..._state.people,
        supporter.id: supporter.withFamilyBond(
          responsible.id,
          nextSupporterBond,
        ),
        responsible.id: responsible.withFamilyBond(
          supporter.id,
          nextResponsibleBond,
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          repaired
              ? 'family_care_conflict_repaired'
              : 'family_care_conflict_unresolved',
          household.id,
          'conflict=${conflict.id} supporter=${supporter.id} '
          'responsible=${responsible.id} severity=${conflict.severity} '
          'repair_score=$repairScore',
        ),
        if (promise != null)
          _fact(
            'family_care_promise_made',
            household.id,
            'promise=${promise.id} debtor=${promise.debtorId} '
                'beneficiary=${promise.beneficiaryId} '
                'due_day=${promise.dueDay} shifts=${promise.promisedShifts}',
          ),
      ],
    );
  }

  ({PersonState infant, PersonState caregiver}) _rememberFamilyCare({
    required PersonState infant,
    required PersonState caregiver,
    required String preferredCaregiverId,
    int? interruptedAtSeconds,
  }) {
    final HouseholdState? household = caregiver.householdId == null
        ? null
        : _state.households[caregiver.householdId];
    if (household?.familyMemory != true) {
      return (infant: infant, caregiver: caregiver);
    }
    final bool substituted = caregiver.id != preferredCaregiverId;
    final int interruptedAt = interruptedAtSeconds ?? _state.now.seconds - 60;
    final int careSeconds = (_state.now.seconds - interruptedAt).clamp(
      900,
      3600,
    );
    final FamilyBondState adultBond =
        caregiver.familyBonds[infant.id] ??
        FamilyBondState(
          affection: 600,
          trust: 600,
          careObligation: caregiver.familyRelationships[infant.id] == 'ward'
              ? 760
              : 860,
        );
    final FamilyBondState childBond =
        infant.familyBonds[caregiver.id] ??
        const FamilyBondState(affection: 600, trust: 650);
    PersonState nextCaregiver = caregiver.withFamilyBond(
      infant.id,
      adultBond.recordCareGiven(
        atSeconds: _state.now.seconds,
        durationSeconds: careSeconds,
        substituted: substituted,
      ),
    );
    final PersonAgenda? agenda = nextCaregiver.agenda;
    if (agenda != null) {
      nextCaregiver = nextCaregiver.withAgenda(
        agenda.tire(careSeconds).logWork(careSeconds),
      );
    }
    return (
      infant: infant.withFamilyBond(
        caregiver.id,
        childBond.recordCareReceived(
          atSeconds: _state.now.seconds,
          durationSeconds: careSeconds,
          substituted: substituted,
        ),
      ),
      caregiver: nextCaregiver,
    );
  }

  void _recordCaregiverSubstitution({
    required String preferredId,
    required String substituteId,
    required String reason,
  }) {
    final String? householdId = _state.people[substituteId]?.householdId;
    final HouseholdState? household = householdId == null
        ? null
        : _state.households[householdId];
    _replace(
      households: household == null
          ? null
          : <String, HouseholdState>{
              ..._state.households,
              householdId!: household.recordCaregiverSubstitution(),
            },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'caregiver_substituted',
          substituteId,
          'preferred=$preferredId substitute=$substituteId reason=$reason',
        ),
      ],
    );
  }

  bool _canUseItem(String personId, CareItemState item) {
    final String? householdId = item.ownerHouseholdId;
    if (householdId == null) return true;
    final PersonState? person = _state.people[personId];
    return person?.householdId == householdId &&
        (_state.households[householdId]?.canUse(personId, item.id) ?? false);
  }

  Map<String, HouseholdState> _householdsAfterCareInterruption(
    PersonState caregiver,
  ) {
    final int? started = caregiver.caregiverAgent?.interruptionStartedSeconds;
    final String? householdId = caregiver.householdId;
    final HouseholdState? household = householdId == null
        ? null
        : _state.households[householdId];
    if (started == null || household == null) return _state.households;
    final int duration = (_state.now.seconds - started).clamp(
      0,
      gameSecondsPerDay,
    );
    return <String, HouseholdState>{
      ..._state.households,
      householdId!: household.recordCareInterruption(caregiver.id, duration),
    };
  }

  void _failCareResponse(String personId, String kind, String detail) {
    final PersonState? infant = _state.people[personId];
    final InfantState? infancy = infant?.infancy;
    if (infant == null || infancy == null) return;
    final PersonState? caregiver = _state.people[infancy.caregiverId];
    final Map<String, HouseholdState> households = caregiver == null
        ? _state.households
        : _householdsAfterCareInterruption(caregiver);
    final bool attachmentLearning =
        infant.householdId != null &&
        _state.households[infant.householdId]?.infantAttachmentLearning == true;
    InfantState failedInfancy = infancy.markCareUnmet();
    if (attachmentLearning) {
      failedInfancy = failedInfancy.recordMissedCare(
        caregiverId: infancy.caregiverId,
        atSeconds: _state.now.seconds,
        delaySeconds: 0,
      );
    }
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: infant.withInfancy(failedInfancy),
        if (caregiver?.caregiverAgent != null)
          caregiver!.id: _resumeRoutine(
            caregiver.withCaregiverAgent(
              caregiver.caregiverAgent!.resumeActivity(),
            ),
          ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(kind, personId, detail),
        if (attachmentLearning)
          _fact(
            'infant_caregiver_expectation_missed',
            personId,
            'caregiver=${infancy.caregiverId} delay_seconds=0',
          ),
      ],
      households: households,
    );
  }

  void _applyWorldHistoryStarted(ScheduledEvent event) {
    if (_state.worldHistory != null) return;
    final WorldGenesisRecord? genesis = _state.worldGenesis;
    if (genesis == null) {
      throw StateError('World genesis must complete before prehistory.');
    }
    if (_state.worldEntry != null || _state.people.containsKey('P00')) {
      throw StateError('Prehistory cannot begin after the player exists.');
    }
    final int rootSeed = event.payload['root_seed']! as int;
    final String worldFingerprint =
        event.payload['world_fingerprint']! as String;
    if (rootSeed != _state.seed || worldFingerprint != genesis.fingerprint) {
      throw StateError(
        'World history provenance does not match world genesis.',
      );
    }
    final WorldHistoryState history = WorldHistoryState(
      rootSeed: rootSeed,
      worldFingerprint: worldFingerprint,
      generatorVersion: event.payload['generator_version']! as String,
      totalYears: event.payload['total_years']! as int,
      expectedEpochCount: event.payload['expected_epoch_count']! as int,
      planFingerprint: event.payload['plan_fingerprint']! as String,
      status: WorldHistoryStatus.simulating,
      epochs: const <HistoricalEpochResult>[],
    );
    if (history.totalYears < 300 || history.expectedEpochCount <= 0) {
      throw StateError('World history plan is too short or empty.');
    }
    _replace(
      worldHistory: history,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'world_history_started',
          genesis.fingerprint,
          'years=${history.totalYears} epochs=${history.expectedEpochCount} '
              'version=${history.generatorVersion}',
        ),
      ],
    );
  }

  void _applyHistoricalEpochSimulated(ScheduledEvent event) {
    final WorldHistoryState? history = _state.worldHistory;
    if (history == null || history.complete) {
      throw StateError('No active world history can accept this epoch.');
    }
    if (_state.worldEntry != null || _state.people.containsKey('P00')) {
      throw StateError('A player appeared during prehistory.');
    }
    final HistoricalEpochResult epoch = HistoricalEpochResult.fromJson(
      event.payload,
    );
    for (final HistoricalAnchor anchor in epoch.anchors) {
      final bool subjectExists =
          _state.regions.containsKey(anchor.subjectId) ||
          _state.sites.containsKey(anchor.subjectId) ||
          _state.routes.containsKey(anchor.subjectId);
      if (!subjectExists) {
        throw StateError(
          'Historical anchor references an unknown subject: '
          '${anchor.subjectId}.',
        );
      }
    }
    final WorldHistoryState next = history.applyEpoch(epoch);
    final HistoricalMetrics metrics = epoch.metricsAfter;
    _replace(
      worldHistory: next,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'historical_epoch_simulated',
          epoch.id,
          '${epoch.startYearsBeforePresent}-${epoch.endYearsBeforePresent} BP '
              'steps=${epoch.macroStepCount} population='
              '${metrics.populationEstimate} households='
              '${metrics.householdEstimate} trade=${metrics.tradeReach} '
              'pressure=${metrics.resourcePressure}',
        ),
      ],
    );
  }

  void _applyWorldHistoryCompleted(ScheduledEvent event) {
    final WorldHistoryState? history = _state.worldHistory;
    if (history == null) {
      throw StateError('World history was not started.');
    }
    if (_state.worldEntry != null || _state.people.containsKey('P00')) {
      throw StateError('A player appeared before prehistory completed.');
    }
    final WorldHistoryState complete = history.markComplete();
    final bool applyLegacy = event.payload['apply_legacy'] == true;
    GeneratedHistoricalLegacy? generatedLegacy;
    int feasibleBirthSites = 0;
    if (applyLegacy) {
      if (_state.historicalLegacy != null) {
        throw StateError('Historical legacy has already been applied.');
      }
      generatedLegacy = HistoricalLegacyGenerator.generate(
        history: complete,
        households: _state.households,
        items: _state.items,
        sites: _state.worldGenesis?.generatorVersion.startsWith('v5.') == true
            ? _state.sites
            : const <String, WorldSite>{},
      );
      feasibleBirthSites = _birthSiteCandidates(
        items: generatedLegacy.items,
        sites: generatedLegacy.sites.isEmpty
            ? _state.sites
            : generatedLegacy.sites,
      ).where((BirthSiteCandidate candidate) => candidate.feasible).length;
      if (feasibleBirthSites == 0) {
        throw StateError(
          'Historical legacy leaves no feasible birth site in the present.',
        );
      }
    }
    _replace(
      worldHistory: complete,
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'world_history_completed',
          complete.worldFingerprint,
          'years=${complete.totalYears} anchors=${complete.anchors.length} '
              'fingerprint=${complete.planFingerprint}',
        ),
        if (generatedLegacy != null)
          _fact(
            'historical_legacy_applied',
            complete.worldFingerprint,
            'adjustments=${generatedLegacy.state.adjustments.length} '
                '${generatedLegacy.state.naturalResourceAdjustments.isEmpty ? '' : 'natural=${generatedLegacy.state.naturalResourceAdjustments.length} ecology=${generatedLegacy.state.ecologyAdjustments.length} settlements=${generatedLegacy.state.settlementAdjustments.length} '}'
                'supply=${generatedLegacy.state.supplyDeliveryPerMille} '
                'flood=${generatedLegacy.state.floodDamagePerMille} '
                'feasible_birth_sites=$feasibleBirthSites',
          ),
      ],
      items: generatedLegacy?.items,
      sites: generatedLegacy?.sites.isEmpty == false
          ? generatedLegacy!.sites
          : null,
      historicalLegacy: generatedLegacy?.state,
    );
  }

  void _applyWorldEntryOpened(ScheduledEvent event) {
    if (_state.worldEntry != null) return;
    if (_state.worldGenesis == null) {
      throw StateError('World genesis must complete before world entry opens.');
    }
    final bool historyPending = _state.pendingEvents.any(
      (ScheduledEvent value) =>
          value.kind == 'world_history_started' ||
          value.kind == 'historical_epoch_simulated' ||
          value.kind == 'world_history_completed',
    );
    if (historyPending || _state.worldHistory?.complete == false) {
      throw StateError('World history must complete before world entry opens.');
    }
    final String playerPersonId = event.payload['player_person_id']! as String;
    if (_state.people.containsKey(playerPersonId)) {
      throw StateError('Player person already exists before world entry.');
    }
    final List<BirthSiteCandidate> candidates = birthSiteCandidates();
    final int feasibleCount = candidates
        .where((BirthSiteCandidate candidate) => candidate.feasible)
        .length;
    if (feasibleCount == 0) {
      throw StateError(
        'No feasible birth site exists in the generated world: '
        '${candidates.map((BirthSiteCandidate value) => '${value.siteId}=${value.reason}').join('; ')}',
      );
    }
    final String playerName = event.payload['player_name']! as String;
    _replace(
      worldEntry: WorldEntryState.awaiting(
        playerPersonId: playerPersonId,
        playerName: playerName,
      ),
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'world_entry_opened',
          playerPersonId,
          '$feasibleCount/${candidates.length} birth sites are feasible',
        ),
      ],
    );
  }

  void _applyBirthSiteSelected(ScheduledEvent event) {
    final WorldEntryState? entry = _state.worldEntry;
    if (entry == null || !entry.awaitingBirthSite) {
      throw StateError('World is not awaiting a birth site.');
    }
    final String siteId = event.payload['site_id']! as String;
    final BirthSiteCandidate? candidate = birthSiteCandidates()
        .where((BirthSiteCandidate value) => value.siteId == siteId)
        .firstOrNull;
    if (candidate == null || !candidate.feasible) {
      throw StateError(candidate?.reason ?? 'Birth site no longer exists.');
    }
    final RoomState room = _state.rooms[candidate.roomId]!;
    _replace(
      worldEntry: entry.select(
        siteId: candidate.siteId,
        selectedHouseholdId: candidate.householdId!,
        selectedRoomId: candidate.roomId!,
        selectedCaregiverId: candidate.caregiverId!,
        selectedCaregiverRole: candidate.caregiverRole ?? 'guardian',
        selectedFamilyOriginSummary:
            candidate.familyOriginSummary ??
            'Người chăm nhận trách nhiệm nuôi dưỡng đứa trẻ.',
      ),
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'birth_site_selected',
          entry.playerPersonId,
          '${candidate.siteId}|${candidate.householdId}|'
              '${candidate.roomId}|${candidate.caregiverId}',
        ),
      ],
    );
    schedule(
      due: event.due,
      phase: EventPhase.completion,
      kind: 'birth',
      payload: <String, Object?>{
        'person_id': entry.playerPersonId,
        'name': entry.playerName,
        'infant': true,
        'caregiver_id': candidate.caregiverId!,
        'position_mm': room.anchorPositionMm,
        'position_y_mm': room.anchorPositionYMm,
        'room_id': room.id,
        'household_id': candidate.householdId!,
        'caregiver_role': candidate.caregiverRole ?? 'guardian',
      },
    );
  }

  WorldFact _fact(String kind, String subjectId, String detail) => WorldFact(
    id: 'fact-' + (_state.revision + 1).toString(),
    time: _state.now,
    kind: kind,
    subjectId: subjectId,
    detail: detail,
  );

  void _replace({
    SimTime? now,
    int? nextSequence,
    Map<String, PersonState>? people,
    List<ScheduledEvent>? pendingEvents,
    List<WorldFact>? facts,
    Set<String>? acceptedCommandIds,
    Map<String, CareItemState>? items,
    Map<String, HouseholdState>? households,
    Map<String, RoomState>? rooms,
    Map<String, IllnessState>? illnesses,
    Map<String, SupplyJourneyState>? supplyJourneys,
    Map<String, CommunityExchangeState>? communityExchanges,
    Map<String, ProductionBatchState>? productionBatches,
    Map<String, ServiceAppointmentState>? serviceAppointments,
    Map<String, LaborOfferState>? laborOffers,
    Map<String, LaborCompensationClaim>? laborClaims,
    Map<String, MarketOfferState>? marketOffers,
    Map<String, MarketOrderState>? marketOrders,
    Map<String, MarketShipmentState>? marketShipments,
    Map<String, SupplyShockState>? supplyShocks,
    Map<String, TradeRoute>? routes,
    Map<String, WorldRegion>? regions,
    Map<String, WorldSite>? sites,
    WorldGenesisRecord? worldGenesis,
    WorldEntryState? worldEntry,
    WorldHistoryState? worldHistory,
    HistoricalLegacyState? historicalLegacy,
    CommunitySurvivalState? communitySurvival,
  }) {
    _state = WorldState(
      seed: _state.seed,
      now: now ?? _state.now,
      revision: _state.revision + 1,
      nextSequence: nextSequence ?? _state.nextSequence,
      people: Map<String, PersonState>.unmodifiable(people ?? _state.people),
      pendingEvents: List<ScheduledEvent>.unmodifiable(
        pendingEvents ?? _state.pendingEvents,
      ),
      facts: List<WorldFact>.unmodifiable(facts ?? _state.facts),
      acceptedCommandIds: Set<String>.unmodifiable(
        acceptedCommandIds ?? _state.acceptedCommandIds,
      ),
      items: Map<String, CareItemState>.unmodifiable(items ?? _state.items),
      households: Map<String, HouseholdState>.unmodifiable(
        households ?? _state.households,
      ),
      rooms: Map<String, RoomState>.unmodifiable(rooms ?? _state.rooms),
      illnesses: Map<String, IllnessState>.unmodifiable(
        illnesses ?? _state.illnesses,
      ),
      supplyJourneys: Map<String, SupplyJourneyState>.unmodifiable(
        supplyJourneys ?? _state.supplyJourneys,
      ),
      communityExchanges: Map<String, CommunityExchangeState>.unmodifiable(
        communityExchanges ?? _state.communityExchanges,
      ),
      productionBatches: Map<String, ProductionBatchState>.unmodifiable(
        productionBatches ?? _state.productionBatches,
      ),
      serviceAppointments: Map<String, ServiceAppointmentState>.unmodifiable(
        serviceAppointments ?? _state.serviceAppointments,
      ),
      laborOffers: Map<String, LaborOfferState>.unmodifiable(
        laborOffers ?? _state.laborOffers,
      ),
      laborClaims: Map<String, LaborCompensationClaim>.unmodifiable(
        laborClaims ?? _state.laborClaims,
      ),
      marketOffers: Map<String, MarketOfferState>.unmodifiable(
        marketOffers ?? _state.marketOffers,
      ),
      marketOrders: Map<String, MarketOrderState>.unmodifiable(
        marketOrders ?? _state.marketOrders,
      ),
      marketShipments: Map<String, MarketShipmentState>.unmodifiable(
        marketShipments ?? _state.marketShipments,
      ),
      supplyShocks: Map<String, SupplyShockState>.unmodifiable(
        supplyShocks ?? _state.supplyShocks,
      ),
      routes: Map<String, TradeRoute>.unmodifiable(routes ?? _state.routes),
      regions: Map<String, WorldRegion>.unmodifiable(regions ?? _state.regions),
      sites: Map<String, WorldSite>.unmodifiable(sites ?? _state.sites),
      worldGenesis: worldGenesis ?? _state.worldGenesis,
      worldEntry: worldEntry ?? _state.worldEntry,
      worldHistory: worldHistory ?? _state.worldHistory,
      historicalLegacy: historicalLegacy ?? _state.historicalLegacy,
      communitySurvival: communitySurvival ?? _state.communitySurvival,
    );
  }
}

Object? _canonicalize(Object? value) {
  if (value is Map) {
    final List<String> keys = value.keys.cast<String>().toList()..sort();
    return <String, Object?>{
      for (final String key in keys) key: _canonicalize(value[key]),
    };
  }
  if (value is List) return value.map<Object?>(_canonicalize).toList();
  return value;
}

String _fnv1a64(String input) {
  final BigInt mask = (BigInt.one << 64) - BigInt.one;
  BigInt hash = BigInt.parse('cbf29ce484222325', radix: 16);
  final BigInt prime = BigInt.parse('100000001b3', radix: 16);
  for (final int byte in utf8.encode(input)) {
    hash ^= BigInt.from(byte);
    hash = (hash * prime) & mask;
  }
  return hash.toRadixString(16).padLeft(16, '0');
}
