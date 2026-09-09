import 'adult_body.dart';
import 'agenda.dart';
import 'care.dart';
import 'domestic.dart';
import 'household.dart';
import 'infancy.dart';
import 'route.dart';
import 'routine.dart';
import 'simulation.dart';

enum CommandStatus { accepted, duplicate, rejected }

class CommandResult {
  const CommandResult({
    required this.commandId,
    required this.status,
    required this.message,
    required this.revision,
  });

  final String commandId;
  final CommandStatus status;
  final String message;
  final int revision;

  bool get accepted => status == CommandStatus.accepted;
}

abstract interface class CommandPort {
  CommandResult submit(SimCommand command);
}

class WorldView {
  const WorldView({
    required this.time,
    required this.revision,
    required this.personCount,
    required this.pendingEventCount,
    required this.factCount,
    required this.semanticHash,
  });

  final SimTime time;
  final int revision;
  final int personCount;
  final int pendingEventCount;
  final int factCount;
  final String semanticHash;
}

class PersonView {
  const PersonView({
    required this.id,
    required this.name,
    required this.ageSeconds,
    required this.activeGoal,
    required this.infancy,
    required this.roomName,
    required this.health,
  });

  final String id;
  final String name;
  final int ageSeconds;
  final String? activeGoal;
  final InfantView? infancy;
  final String? roomName;
  final HealthView? health;
}

class HealthView {
  const HealthView({
    required this.kind,
    required this.stage,
    required this.severity,
    required this.bodyTemperatureMilliC,
    required this.symptoms,
    required this.detected,
    required this.careMinutes,
  });

  final String kind;
  final IllnessStage stage;
  final int severity;
  final int bodyTemperatureMilliC;
  final List<String> symptoms;
  final bool detected;
  final int careMinutes;
}

class InfantView {
  const InfantView({
    required this.caregiverId,
    required this.hunger,
    required this.thirst,
    required this.sleepPressure,
    required this.thermalStress,
    required this.distress,
    required this.visionRangeMm,
    required this.visualFocus,
    required this.hearing,
    required this.smell,
    required this.touch,
    required this.awake,
    required this.crying,
    required this.careInteractions,
    required this.attachment,
    required this.unmetCareEpisodes,
    required this.allowedIntents,
    required this.careResponsePending,
    required this.caregiverDistanceMm,
    required this.caregiverActivity,
    required this.feedRemaining,
    required this.clothCondition,
    required this.massGrams,
    required this.bodyWaterMl,
    required this.energyReserveKj,
    required this.stomachContentMl,
    required this.stomachCapacityMl,
    required this.stomachEnergyKj,
    required this.stomachWaterMl,
    required this.bodyTemperatureMilliC,
    required this.bladderMl,
    required this.digestiveWasteGrams,
    required this.suckFunction,
    required this.swallowFunction,
    required this.totalFeedMl,
    required this.totalSleepMinutes,
    required this.totalUrineMl,
    required this.totalStoolGrams,
    required this.illnessEnergyCostKj,
    required this.illnessWaterLossMl,
    required this.illnessSleepDisruptionMinutes,
  });

  final String caregiverId;
  final int hunger;
  final int thirst;
  final int sleepPressure;
  final int thermalStress;
  final int distress;
  final int visionRangeMm;
  final int visualFocus;
  final int hearing;
  final int smell;
  final int touch;
  final bool awake;
  final bool crying;
  final int careInteractions;
  final int attachment;
  final int unmetCareEpisodes;
  final List<InfantIntent> allowedIntents;
  final bool careResponsePending;
  final int? caregiverDistanceMm;
  final String? caregiverActivity;
  final int feedRemaining;
  final int? clothCondition;
  final int? massGrams;
  final int? bodyWaterMl;
  final int? energyReserveKj;
  final int? stomachContentMl;
  final int? stomachCapacityMl;
  final int? stomachEnergyKj;
  final int? stomachWaterMl;
  final int? bodyTemperatureMilliC;
  final int? bladderMl;
  final int? digestiveWasteGrams;
  final int? suckFunction;
  final int? swallowFunction;
  final int? totalFeedMl;
  final int? totalSleepMinutes;
  final int? totalUrineMl;
  final int? totalStoolGrams;
  final int? illnessEnergyCostKj;
  final int? illnessWaterLossMl;
  final int? illnessSleepDisruptionMinutes;
}

class HouseholdView {
  const HouseholdView({
    required this.id,
    required this.name,
    required this.memberNames,
    required this.resourceQuantities,
    required this.resourceUnits,
    required this.mealsCompleted,
    required this.mealShortfalls,
    required this.unauthorizedAttempts,
    required this.totalCareInterruptionSecondsByPerson,
    required this.workCompletedSecondsByPerson,
    required this.supplyDeliveries,
    required this.productionRuns,
    required this.caregiverSubstitutions,
    required this.reassignedBlocks,
    required this.supplyJourneys,
    required this.members,
    required this.items,
    required this.needs,
  });

  final String id;
  final String name;
  final List<String> memberNames;
  final Map<String, int> resourceQuantities;
  final Map<String, String> resourceUnits;
  final int mealsCompleted;
  final int mealShortfalls;
  final int unauthorizedAttempts;
  final Map<String, int> totalCareInterruptionSecondsByPerson;
  final Map<String, int> workCompletedSecondsByPerson;
  final int supplyDeliveries;
  final int productionRuns;
  final int caregiverSubstitutions;
  final int reassignedBlocks;
  final List<SupplyJourneyView> supplyJourneys;
  final List<HouseholdMemberView> members;
  final List<HouseholdItemView> items;

  /// Nhu cầu vật chất suy từ tồn kho thật, đã xếp theo mức gấp.
  final List<HouseholdNeed> needs;

  /// Các khối việc do kế hoạch của hộ sinh ra cho hôm nay.
  List<(String, RoutineBlock)> get plannedWork =>
      <(String, RoutineBlock)>[
        for (final HouseholdMemberView member in members)
          for (final RoutineBlock block
              in member.routine?.blocks.where(
                    (RoutineBlock block) => block.generated,
                  ) ??
                  const <RoutineBlock>[])
            (member.name, block),
      ]..sort(
        ((String, RoutineBlock) a, (String, RoutineBlock) b) =>
            a.$2.startSecondOfDay.compareTo(b.$2.startSecondOfDay),
      );

  /// Số lần thành viên từ chối việc hộ giao.
  int get refusedOffers => members.fold(
    0,
    (int total, HouseholdMemberView member) =>
        total + (member.agenda?.refusedOffers ?? 0),
  );

  int get scheduleConflicts => members.fold(
    0,
    (int total, HouseholdMemberView member) =>
        total + (member.routine?.conflictCount ?? 0),
  );
}

class HouseholdMemberView {
  const HouseholdMemberView({
    required this.id,
    required this.name,
    required this.roomName,
    required this.activity,
    required this.available,
    required this.careSkill,
    this.routine,
    this.agenda,
    this.body,
  });

  final String id;
  final String name;
  final String? roomName;
  final String? activity;
  final bool? available;
  final int? careSkill;
  final RoutineSummaryView? routine;
  final PersonAgenda? agenda;
  final AdultBodyState? body;
}

/// Nhịp sống của một người và những lần lịch bị xung đột thật.
class RoutineSummaryView {
  const RoutineSummaryView({
    required this.blocks,
    required this.currentActivity,
    required this.preemptedBy,
    required this.completedBlocks,
    required this.deferredStarts,
    required this.droppedBlocks,
    required this.outrankedBlocks,
    required this.lostSeconds,
    required this.conflictCount,
    required this.conflicts,
  });

  factory RoutineSummaryView.of(RoutineState state) => RoutineSummaryView(
    blocks: List<RoutineBlock>.unmodifiable(state.blocks),
    currentActivity: state.currentActivity,
    preemptedBy: state.preemptedBy,
    completedBlocks: state.completedBlocks,
    deferredStarts: state.deferredStarts,
    droppedBlocks: state.droppedBlocks,
    outrankedBlocks: state.outrankedBlocks,
    lostSeconds: state.lostSeconds,
    conflictCount: state.conflictCount,
    conflicts: List<ScheduleConflict>.unmodifiable(state.conflicts),
  );

  final List<RoutineBlock> blocks;
  final String? currentActivity;
  final String? preemptedBy;
  final int completedBlocks;
  final int deferredStarts;
  final int droppedBlocks;
  final int outrankedBlocks;
  final int lostSeconds;
  final int conflictCount;
  final List<ScheduleConflict> conflicts;

  ScheduleConflict? get lastConflict =>
      conflicts.isEmpty ? null : conflicts.last;
}

/// Hồ sơ một người bất kỳ trong thế giới, kể cả người ngoài hộ.
class PersonProfileView {
  const PersonProfileView({
    required this.id,
    required this.name,
    required this.ageDays,
    required this.householdId,
    required this.householdName,
    required this.roomName,
    required this.positionMm,
    required this.activity,
    required this.available,
    required this.careSkill,
    required this.isInfant,
    required this.illnessKind,
    required this.illnessStage,
    required this.routine,
    required this.skills,
    required this.agenda,
    required this.body,
  });

  final String id;
  final String name;
  final int ageDays;
  final String? householdId;
  final String? householdName;
  final String? roomName;
  final int? positionMm;
  final String? activity;
  final bool? available;
  final int? careSkill;
  final bool isInfant;
  final String? illnessKind;
  final IllnessStage? illnessStage;
  final RoutineSummaryView? routine;

  /// Tay nghề theo mã việc, nếu người này có hồ sơ nghề.
  final PersonSkills? skills;

  /// Sức lực và thái độ nhận việc, nếu người này có tiếng nói riêng.
  final PersonAgenda? agenda;

  /// Cơ thể người lớn, nếu đã được vật chất hóa.
  final AdultBodyState? body;

  bool get inHousehold => householdId != null;
}

/// Hồ sơ một vật phẩm bất kỳ, kể cả vật không nằm trong sổ kho của hộ.
class ItemProfileView {
  const ItemProfileView({
    required this.id,
    required this.kind,
    required this.quantity,
    required this.unit,
    required this.condition,
    required this.roomName,
    required this.positionMm,
    required this.ownerHouseholdId,
    required this.ownerHouseholdName,
    required this.resourceKey,
    required this.authorizedUserNames,
  });

  final String id;
  final String kind;
  final int quantity;
  final String unit;
  final int condition;
  final String? roomName;
  final int positionMm;
  final String? ownerHouseholdId;
  final String? ownerHouseholdName;

  /// Khóa sổ kho của hộ nếu vật này là nguồn lực được ghi sổ.
  final String? resourceKey;
  final List<String> authorizedUserNames;

  bool get inHouseholdLedger => resourceKey != null;
}

/// Danh bạ toàn thế giới đã được vật chất hóa.
class WorldDirectoryView {
  const WorldDirectoryView({required this.people, required this.items});

  final List<PersonProfileView> people;
  final List<ItemProfileView> items;

  List<PersonProfileView> get outsideHousehold => people
      .where((PersonProfileView person) => !person.inHousehold)
      .toList(growable: false);

  List<ItemProfileView> get outsideLedger => items
      .where((ItemProfileView item) => !item.inHouseholdLedger)
      .toList(growable: false);
}

class HouseholdItemView {
  const HouseholdItemView({
    required this.id,
    required this.kind,
    required this.quantity,
    required this.unit,
    required this.condition,
    required this.roomName,
  });
  final String id;
  final String kind;
  final int quantity;
  final String unit;
  final int condition;
  final String? roomName;
}

class SupplyJourneyView {
  const SupplyJourneyView({
    required this.id,
    required this.carrierName,
    required this.status,
    required this.currentLeg,
    required this.expectedArrivalSeconds,
    required this.actualArrivalSeconds,
    required this.delaySeconds,
    required this.delayReason,
    required this.cargo,
    required this.route,
    required this.legIndex,
    required this.legCount,
    required this.travelledMm,
    required this.pathWaypointIds,
  });

  final String id;
  final String carrierName;
  final SupplyJourneyStatus status;
  final String currentLeg;
  final int expectedArrivalSeconds;
  final int? actualArrivalSeconds;
  final int delaySeconds;
  final String? delayReason;
  final Map<String, int> cargo;

  /// Tuyến đang đi, nếu chuyến này chạy trên tuyến thật.
  final TradeRoute? route;

  final int legIndex;
  final int legCount;
  final int travelledMm;

  /// Dãy điểm mốc người chở đã chọn đi.
  final List<String> pathWaypointIds;

  bool get onRoute => route != null;

  /// Tên các điểm mốc trên đường đã chọn, để hiện thành lộ trình đọc được.
  List<String> get pathNames => <String>[
    for (final String id in pathWaypointIds) route?.waypoint(id)?.name ?? id,
  ];

  /// Tuyến này có ngã rẽ nên đường đã chọn là một quyết định thật.
  bool get chosenAmongForks => route?.hasFork ?? false;

  /// Phần đường đã đi, phần nghìn; dùng cho thanh tiến độ trên giao diện.
  int get progressPerMille {
    final int total = route?.pathDistanceMm(pathWaypointIds) ?? 0;
    if (total <= 0) return 0;
    return (travelledMm * 1000 ~/ total).clamp(0, 1000);
  }

  /// Tổng chiều dài đường đã chọn, không phải toàn bộ tuyến.
  int get pathDistanceMm => route?.pathDistanceMm(pathWaypointIds) ?? 0;

  /// Tên điểm mốc đang đứng, nếu đọc được từ tuyến.
  String? get currentWaypointName => route?.waypoint(currentLeg)?.name;
}

abstract interface class QueryPort {
  WorldView world();
  PersonView? person(String id);
  HouseholdView? household(String id);
  WorldDirectoryView directory();
  List<WorldFact> recentFacts({int limit = 20});
}

class SimulationHost implements CommandPort, QueryPort {
  SimulationHost(this.simulation);

  final Simulation simulation;

  @override
  CommandResult submit(SimCommand command) {
    if (simulation.state.acceptedCommandIds.contains(command.id)) {
      return CommandResult(
        commandId: command.id,
        status: CommandStatus.duplicate,
        message: 'Lệnh đã được tiếp nhận trước đó.',
        revision: simulation.state.revision,
      );
    }
    try {
      final bool accepted = simulation.issue(command);
      return CommandResult(
        commandId: command.id,
        status: accepted ? CommandStatus.accepted : CommandStatus.rejected,
        message: accepted
            ? 'Lệnh đã có hiệu lực.'
            : 'Loại lệnh chưa được hỗ trợ.',
        revision: simulation.state.revision,
      );
    } on StateError catch (error) {
      return CommandResult(
        commandId: command.id,
        status: CommandStatus.rejected,
        message: error.message.toString(),
        revision: simulation.state.revision,
      );
    }
  }

  @override
  WorldView world() {
    final WorldState state = simulation.state;
    return WorldView(
      time: state.now,
      revision: state.revision,
      personCount: state.people.length,
      pendingEventCount: state.pendingEvents.length,
      factCount: state.facts.length,
      semanticHash: state.semanticHash(),
    );
  }

  @override
  PersonView? person(String id) {
    final PersonState? state = simulation.state.people[id];
    if (state == null) return null;
    final int ageSeconds =
        simulation.state.now.seconds - state.birthTime.seconds;
    final InfantState? infancy = state.infancy;
    final IllnessState? illness = simulation.state.illnesses.values
        .where((IllnessState value) => value.personId == id)
        .firstOrNull;
    final PersonState? caregiver = infancy == null
        ? null
        : simulation.state.people[infancy.caregiverId];
    final List<CareItemState> nearbyItems =
        infancy == null || state.positionMm == null
        ? const <CareItemState>[]
        : simulation.state.items.values
              .where(
                (CareItemState item) => item.positionMm == state.positionMm,
              )
              .toList();
    return PersonView(
      id: state.id,
      name: state.name,
      ageSeconds: ageSeconds,
      activeGoal: state.activeGoal,
      infancy: infancy == null
          ? null
          : InfantView(
              caregiverId: infancy.caregiverId,
              hunger: infancy.needs.hunger,
              thirst: infancy.needs.thirst,
              sleepPressure: infancy.needs.sleepPressure,
              thermalStress: infancy.needs.thermalStress,
              distress: infancy.needs.distress,
              visionRangeMm: infancy.senses.visionRangeMm,
              visualFocus: infancy.senses.visualFocus,
              hearing: infancy.senses.hearing,
              smell: infancy.senses.smell,
              touch: infancy.senses.touch,
              awake: infancy.awake,
              crying: infancy.crying,
              careInteractions: infancy.careInteractions,
              attachment: infancy.attachment,
              unmetCareEpisodes: infancy.unmetCareEpisodes,
              allowedIntents: List<InfantIntent>.unmodifiable(
                InfantState.allowedIntents(ageSeconds ~/ gameSecondsPerDay),
              ),
              careResponsePending: infancy.careResponsePending,
              caregiverDistanceMm:
                  caregiver?.positionMm == null || state.positionMm == null
                  ? null
                  : (caregiver!.positionMm! - state.positionMm!).abs(),
              caregiverActivity: caregiver?.caregiverAgent?.currentActivity,
              feedRemaining: nearbyItems
                  .where((CareItemState item) => item.kind == 'infant_feed')
                  .fold(
                    0,
                    (int total, CareItemState item) => total + item.quantity,
                  ),
              clothCondition: nearbyItems
                  .where((CareItemState item) => item.kind == 'swaddling_cloth')
                  .firstOrNull
                  ?.condition,
              massGrams: infancy.body?.massGrams,
              bodyWaterMl: infancy.body?.bodyWaterMl,
              energyReserveKj: infancy.body?.energyReserveKj,
              stomachContentMl: infancy.body?.stomachContentMl,
              stomachCapacityMl: infancy.body?.stomachCapacityMl,
              stomachEnergyKj: infancy.body?.stomachEnergyKj,
              stomachWaterMl: infancy.body?.stomachWaterMl,
              bodyTemperatureMilliC: infancy.body?.bodyTemperatureMilliC,
              bladderMl: infancy.body?.bladderMl,
              digestiveWasteGrams: infancy.body?.digestiveWasteGrams,
              suckFunction: infancy.body?.suckFunction,
              swallowFunction: infancy.body?.swallowFunction,
              totalFeedMl: infancy.body?.totalFeedMl,
              totalSleepMinutes: infancy.body?.totalSleepMinutes,
              totalUrineMl: infancy.body?.totalUrineMl,
              totalStoolGrams: infancy.body?.totalStoolGrams,
              illnessEnergyCostKj: infancy.body?.illnessEnergyCostKj,
              illnessWaterLossMl: infancy.body?.illnessWaterLossMl,
              illnessSleepDisruptionMinutes:
                  infancy.body?.illnessSleepDisruptionMinutes,
            ),
      roomName: state.roomId == null
          ? null
          : simulation.state.rooms[state.roomId]?.name ?? state.roomId,
      health: illness == null
          ? null
          : HealthView(
              kind: illness.kind,
              stage: illness.stage,
              severity: illness.severity,
              bodyTemperatureMilliC: illness.bodyTemperatureMilliC,
              symptoms: List<String>.unmodifiable(illness.symptoms),
              detected: illness.detected,
              careMinutes: illness.careMinutes,
            ),
    );
  }

  @override
  WorldDirectoryView directory() {
    final WorldState state = simulation.state;
    final Map<String, String> resourceKeyByItemId = <String, String>{};
    final Map<String, Set<String>> authorizedByItemId = <String, Set<String>>{};
    for (final HouseholdState household in state.households.values) {
      for (final MapEntry<String, String> entry
          in household.resourceItemIds.entries) {
        resourceKeyByItemId[entry.value] = entry.key;
      }
      for (final MapEntry<String, Set<String>> entry
          in household.authorizedUsersByItemId.entries) {
        authorizedByItemId
            .putIfAbsent(entry.key, () => <String>{})
            .addAll(entry.value);
      }
    }
    final List<PersonState> people = state.people.values.toList()
      ..sort((PersonState a, PersonState b) => a.id.compareTo(b.id));
    final List<CareItemState> items = state.items.values.toList()
      ..sort((CareItemState a, CareItemState b) => a.id.compareTo(b.id));
    return WorldDirectoryView(
      people: List<PersonProfileView>.unmodifiable(<PersonProfileView>[
        for (final PersonState person in people)
          () {
            final IllnessState? illness = state.illnesses.values
                .where(
                  (IllnessState value) =>
                      value.personId == person.id && value.active,
                )
                .firstOrNull;
            return PersonProfileView(
              id: person.id,
              name: person.name,
              ageDays:
                  (state.now.seconds - person.birthTime.seconds) ~/
                  gameSecondsPerDay,
              householdId: person.householdId,
              householdName: person.householdId == null
                  ? null
                  : state.households[person.householdId]?.name,
              roomName: person.roomId == null
                  ? null
                  : state.rooms[person.roomId]?.name ?? person.roomId,
              positionMm: person.positionMm,
              activity:
                  person.routine?.currentActivity ??
                  person.caregiverAgent?.currentActivity,
              available: person.caregiverAgent?.available,
              careSkill: person.caregiverAgent?.careSkill,
              isInfant: person.infancy != null,
              illnessKind: illness?.kind,
              illnessStage: illness?.stage,
              routine: person.routine == null
                  ? null
                  : RoutineSummaryView.of(person.routine!),
              skills: person.skills,
              agenda: person.agenda,
              body: person.body,
            );
          }(),
      ]),
      items: List<ItemProfileView>.unmodifiable(<ItemProfileView>[
        for (final CareItemState item in items)
          ItemProfileView(
            id: item.id,
            kind: item.kind,
            quantity: item.quantity,
            unit: item.unit,
            condition: item.condition,
            roomName: item.roomId == null
                ? null
                : state.rooms[item.roomId]?.name ?? item.roomId,
            positionMm: item.positionMm,
            ownerHouseholdId: item.ownerHouseholdId,
            ownerHouseholdName: item.ownerHouseholdId == null
                ? null
                : state.households[item.ownerHouseholdId]?.name,
            resourceKey: resourceKeyByItemId[item.id],
            authorizedUserNames: List<String>.unmodifiable(<String>[
              for (final String personId
                  in (authorizedByItemId[item.id]?.toList() ?? <String>[])
                    ..sort())
                state.people[personId]?.name ?? personId,
            ]),
          ),
      ]),
    );
  }

  @override
  List<WorldFact> recentFacts({int limit = 20}) {
    if (limit < 0) throw ArgumentError.value(limit, 'limit');
    final List<WorldFact> facts = simulation.state.facts;
    final int start = facts.length > limit ? facts.length - limit : 0;
    return List<WorldFact>.unmodifiable(facts.sublist(start));
  }

  @override
  HouseholdView? household(String id) {
    final household = simulation.state.households[id];
    if (household == null) return null;
    final Map<String, int> quantities = <String, int>{};
    final Map<String, String> units = <String, String>{};
    for (final MapEntry<String, String> entry
        in household.resourceItemIds.entries) {
      final CareItemState? item = simulation.state.items[entry.value];
      if (item == null) continue;
      quantities[entry.key] = item.quantity;
      units[entry.key] = item.unit;
    }
    return HouseholdView(
      id: household.id,
      name: household.name,
      memberNames: <String>[
        for (final String memberId in household.memberIds)
          simulation.state.people[memberId]?.name ?? memberId,
      ],
      resourceQuantities: Map<String, int>.unmodifiable(quantities),
      resourceUnits: Map<String, String>.unmodifiable(units),
      mealsCompleted: household.mealsCompleted,
      mealShortfalls: household.mealShortfalls,
      unauthorizedAttempts: household.unauthorizedAttempts,
      totalCareInterruptionSecondsByPerson: Map<String, int>.unmodifiable(
        household.totalCareInterruptionSecondsByPerson,
      ),
      workCompletedSecondsByPerson: Map<String, int>.unmodifiable(
        household.workCompletedSecondsByPerson,
      ),
      supplyDeliveries: household.supplyDeliveries,
      productionRuns: household.productionRuns,
      caregiverSubstitutions: household.caregiverSubstitutions,
      reassignedBlocks: simulation.state.facts
          .where(
            (WorldFact fact) =>
                fact.kind == 'routine_block_reassigned' &&
                household.memberIds.contains(fact.subjectId),
          )
          .length,
      supplyJourneys:
          <SupplyJourneyView>[
            for (final SupplyJourneyState journey
                in simulation.state.supplyJourneys.values.where(
                  (SupplyJourneyState value) => value.householdId == id,
                ))
              SupplyJourneyView(
                id: journey.id,
                carrierName:
                    simulation.state.people[journey.carrierId]?.name ??
                    journey.carrierId,
                status: journey.status,
                currentLeg: journey.currentLeg,
                expectedArrivalSeconds: journey.expectedArrivalSeconds,
                actualArrivalSeconds: journey.actualArrivalSeconds,
                delaySeconds: journey.delaySeconds,
                delayReason: journey.delayReason,
                cargo: Map<String, int>.unmodifiable(journey.cargo),
                route: journey.routeId == null
                    ? null
                    : simulation.state.routes[journey.routeId],
                legIndex: journey.legIndex,
                legCount: journey.legCount,
                travelledMm: journey.travelledMm,
                pathWaypointIds: List<String>.unmodifiable(
                  journey.pathWaypointIds,
                ),
              ),
          ]..sort(
            (SupplyJourneyView a, SupplyJourneyView b) => b.id.compareTo(a.id),
          ),
      members: <HouseholdMemberView>[
        for (final String memberId in household.memberIds)
          if (simulation.state.people[memberId] case final PersonState person)
            HouseholdMemberView(
              id: person.id,
              name: person.name,
              roomName: person.roomId == null
                  ? null
                  : simulation.state.rooms[person.roomId]?.name,
              activity:
                  person.routine?.currentActivity ??
                  person.caregiverAgent?.currentActivity,
              available: person.caregiverAgent?.available,
              careSkill: person.caregiverAgent?.careSkill,
              routine: person.routine == null
                  ? null
                  : RoutineSummaryView.of(person.routine!),
              agenda: person.agenda,
              body: person.body,
            ),
      ],
      needs: simulation.householdNeeds(id),
      items: <HouseholdItemView>[
        for (final String itemId in household.resourceItemIds.values)
          if (simulation.state.items[itemId] case final CareItemState item)
            HouseholdItemView(
              id: item.id,
              kind: item.kind,
              quantity: item.quantity,
              unit: item.unit,
              condition: item.condition,
              roomName: item.roomId == null
                  ? null
                  : simulation.state.rooms[item.roomId]?.name,
            ),
      ],
    );
  }
}
