import 'dart:convert';

import 'care.dart';
import 'domestic.dart';
import 'household.dart';
import 'infancy.dart';
import 'routine.dart';

const int gameSecondsPerDay = 86400;
const int realMillisecondsPerGameDay = 5000;

enum EventPhase {
  intent(20),
  movement(30),
  transfer(50),
  completion(60),
  observation(70),
  bookkeeping(80);

  const EventPhase(this.order);
  final int order;
}

class SimTime implements Comparable<SimTime> {
  const SimTime(this.seconds);

  final int seconds;
  int get day => seconds ~/ gameSecondsPerDay;

  SimTime addSeconds(int value) => SimTime(seconds + value);
  SimTime addDays(int value) => addSeconds(value * gameSecondsPerDay);

  @override
  int compareTo(SimTime other) => seconds.compareTo(other.seconds);

  Map<String, Object> toJson() => <String, Object>{'seconds': seconds};

  factory SimTime.fromJson(Map<String, Object?> json) =>
      SimTime(json['seconds']! as int);
}

class ScheduledEvent implements Comparable<ScheduledEvent> {
  const ScheduledEvent({
    required this.id,
    required this.due,
    required this.phase,
    required this.sequence,
    required this.kind,
    this.payload = const <String, Object?>{},
  });

  final String id;
  final SimTime due;
  final EventPhase phase;
  final int sequence;
  final String kind;
  final Map<String, Object?> payload;

  @override
  int compareTo(ScheduledEvent other) {
    final int byTime = due.compareTo(other.due);
    if (byTime != 0) return byTime;
    final int byPhase = phase.order.compareTo(other.phase.order);
    if (byPhase != 0) return byPhase;
    return sequence.compareTo(other.sequence);
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'due': due.toJson(),
    'phase': phase.name,
    'sequence': sequence,
    'kind': kind,
    'payload': payload,
  };

  factory ScheduledEvent.fromJson(Map<String, Object?> json) => ScheduledEvent(
    id: json['id']! as String,
    due: SimTime.fromJson((json['due']! as Map).cast<String, Object?>()),
    phase: EventPhase.values.byName(json['phase']! as String),
    sequence: json['sequence']! as int,
    kind: json['kind']! as String,
    payload: (json['payload']! as Map).cast<String, Object?>(),
  );
}

class PersonState {
  const PersonState({
    required this.id,
    required this.name,
    required this.birthTime,
    this.activeGoal,
    this.infancy,
    this.positionMm,
    this.caregiverAgent,
    this.householdId,
    this.roomId,
    this.routine,
  });

  final String id;
  final String name;
  final SimTime birthTime;
  final String? activeGoal;
  final InfantState? infancy;
  final int? positionMm;
  final CaregiverAgentState? caregiverAgent;
  final String? householdId;
  final String? roomId;
  final RoutineState? routine;

  PersonState withGoal(String goal) => _copy(activeGoal: goal);

  PersonState withInfancy(InfantState value, {String? goal}) =>
      _copy(infancy: value, activeGoal: goal ?? activeGoal);

  PersonState withPosition(int value) => _copy(positionMm: value);

  PersonState withCaregiverAgent(CaregiverAgentState value) =>
      _copy(caregiverAgent: value);

  PersonState withLocation({required int positionMm, required String roomId}) =>
      _copy(positionMm: positionMm, roomId: roomId);

  PersonState withRoutine(RoutineState value) => _copy(routine: value);

  PersonState _copy({
    String? activeGoal,
    InfantState? infancy,
    int? positionMm,
    CaregiverAgentState? caregiverAgent,
    String? roomId,
    RoutineState? routine,
  }) => PersonState(
    id: id,
    name: name,
    birthTime: birthTime,
    activeGoal: activeGoal ?? this.activeGoal,
    infancy: infancy ?? this.infancy,
    positionMm: positionMm ?? this.positionMm,
    caregiverAgent: caregiverAgent ?? this.caregiverAgent,
    householdId: householdId,
    roomId: roomId ?? this.roomId,
    routine: routine ?? this.routine,
  );

  Map<String, Object?> toJson() {
    final Map<String, Object?> result = <String, Object?>{
      'id': id,
      'name': name,
      'birth_time': birthTime.toJson(),
      'active_goal': activeGoal,
    };
    if (infancy != null) result['infancy'] = infancy!.toJson();
    if (positionMm != null) result['position_mm'] = positionMm;
    if (caregiverAgent != null) {
      result['caregiver_agent'] = caregiverAgent!.toJson();
    }
    if (householdId != null) result['household_id'] = householdId;
    if (roomId != null) result['room_id'] = roomId;
    if (routine != null) result['routine'] = routine!.toJson();
    return result;
  }

  factory PersonState.fromJson(Map<String, Object?> json) => PersonState(
    id: json['id']! as String,
    name: json['name']! as String,
    birthTime: SimTime.fromJson(
      (json['birth_time']! as Map).cast<String, Object?>(),
    ),
    activeGoal: json['active_goal'] as String?,
    infancy: json['infancy'] == null
        ? null
        : InfantState.fromJson(
            (json['infancy']! as Map).cast<String, Object?>(),
          ),
    positionMm: json['position_mm'] as int?,
    caregiverAgent: json['caregiver_agent'] == null
        ? null
        : CaregiverAgentState.fromJson(
            (json['caregiver_agent']! as Map).cast<String, Object?>(),
          ),
    householdId: json['household_id'] as String?,
    roomId: json['room_id'] as String?,
    routine: json['routine'] == null
        ? null
        : RoutineState.fromJson(
            (json['routine']! as Map).cast<String, Object?>(),
          ),
  );
}

class WorldFact {
  const WorldFact({
    required this.id,
    required this.time,
    required this.kind,
    required this.subjectId,
    required this.detail,
  });

  final String id;
  final SimTime time;
  final String kind;
  final String subjectId;
  final String detail;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'time': time.toJson(),
    'kind': kind,
    'subject_id': subjectId,
    'detail': detail,
  };

  factory WorldFact.fromJson(Map<String, Object?> json) => WorldFact(
    id: json['id']! as String,
    time: SimTime.fromJson((json['time']! as Map).cast<String, Object?>()),
    kind: json['kind']! as String,
    subjectId: json['subject_id']! as String,
    detail: json['detail']! as String,
  );
}

class WorldState {
  const WorldState({
    required this.seed,
    required this.now,
    required this.revision,
    required this.nextSequence,
    required this.people,
    required this.pendingEvents,
    required this.facts,
    required this.acceptedCommandIds,
    required this.items,
    required this.households,
    required this.rooms,
    required this.illnesses,
    required this.supplyJourneys,
  });

  factory WorldState.initial(int seed) => WorldState(
    seed: seed,
    now: const SimTime(0),
    revision: 0,
    nextSequence: 0,
    people: const <String, PersonState>{},
    pendingEvents: const <ScheduledEvent>[],
    facts: const <WorldFact>[],
    acceptedCommandIds: const <String>{},
    items: const <String, CareItemState>{},
    households: const <String, HouseholdState>{},
    rooms: const <String, RoomState>{},
    illnesses: const <String, IllnessState>{},
    supplyJourneys: const <String, SupplyJourneyState>{},
  );

  final int seed;
  final SimTime now;
  final int revision;
  final int nextSequence;
  final Map<String, PersonState> people;
  final List<ScheduledEvent> pendingEvents;
  final List<WorldFact> facts;
  final Set<String> acceptedCommandIds;
  final Map<String, CareItemState> items;
  final Map<String, HouseholdState> households;
  final Map<String, RoomState> rooms;
  final Map<String, IllnessState> illnesses;
  final Map<String, SupplyJourneyState> supplyJourneys;

  Map<String, Object?> toJson() {
    final List<PersonState> sortedPeople = people.values.toList()
      ..sort((PersonState a, PersonState b) => a.id.compareTo(b.id));
    final List<ScheduledEvent> sortedEvents = pendingEvents.toList()..sort();
    final List<String> commands = acceptedCommandIds.toList()..sort();
    final Map<String, Object?> result = <String, Object?>{
      'schema_version': 1,
      'seed': seed,
      'now': now.toJson(),
      'revision': revision,
      'next_sequence': nextSequence,
      'people': sortedPeople
          .map((PersonState value) => value.toJson())
          .toList(),
      'pending_events': sortedEvents
          .map((ScheduledEvent value) => value.toJson())
          .toList(),
      'facts': facts.map((WorldFact value) => value.toJson()).toList(),
      'accepted_command_ids': commands,
    };
    if (items.isNotEmpty) {
      final List<CareItemState> sortedItems = items.values.toList()
        ..sort((CareItemState a, CareItemState b) => a.id.compareTo(b.id));
      result['items'] = sortedItems
          .map((CareItemState value) => value.toJson())
          .toList();
    }
    if (households.isNotEmpty) {
      final List<HouseholdState> sorted = households.values.toList()
        ..sort((HouseholdState a, HouseholdState b) => a.id.compareTo(b.id));
      result['households'] = sorted
          .map((HouseholdState value) => value.toJson())
          .toList();
    }
    if (rooms.isNotEmpty) {
      final List<RoomState> sorted = rooms.values.toList()
        ..sort((RoomState a, RoomState b) => a.id.compareTo(b.id));
      result['rooms'] = sorted
          .map((RoomState value) => value.toJson())
          .toList();
    }
    if (illnesses.isNotEmpty) {
      final List<IllnessState> sorted = illnesses.values.toList()
        ..sort((IllnessState a, IllnessState b) => a.id.compareTo(b.id));
      result['illnesses'] = sorted
          .map((IllnessState value) => value.toJson())
          .toList();
    }
    if (supplyJourneys.isNotEmpty) {
      final List<SupplyJourneyState> sorted = supplyJourneys.values.toList()
        ..sort(
          (SupplyJourneyState a, SupplyJourneyState b) => a.id.compareTo(b.id),
        );
      result['supply_journeys'] = sorted
          .map((SupplyJourneyState value) => value.toJson())
          .toList();
    }
    return result;
  }

  String save() => const JsonEncoder.withIndent('  ').convert(toJson());

  String semanticHash() => _fnv1a64(jsonEncode(_canonicalize(toJson())));

  factory WorldState.load(String source) {
    final Map<String, Object?> json = (jsonDecode(source) as Map)
        .cast<String, Object?>();
    if (json['schema_version'] != 1) {
      throw FormatException(
        'Unsupported save schema: ' + json['schema_version'].toString(),
      );
    }
    return WorldState(
      seed: json['seed']! as int,
      now: SimTime.fromJson((json['now']! as Map).cast<String, Object?>()),
      revision: json['revision']! as int,
      nextSequence: json['next_sequence']! as int,
      people: <String, PersonState>{
        for (final Object? item in json['people']! as List<Object?>)
          PersonState.fromJson((item! as Map).cast<String, Object?>()).id:
              PersonState.fromJson((item as Map).cast<String, Object?>()),
      },
      pendingEvents: <ScheduledEvent>[
        for (final Object? item in json['pending_events']! as List<Object?>)
          ScheduledEvent.fromJson((item! as Map).cast<String, Object?>()),
      ],
      facts: <WorldFact>[
        for (final Object? item in json['facts']! as List<Object?>)
          WorldFact.fromJson((item! as Map).cast<String, Object?>()),
      ],
      acceptedCommandIds: (json['accepted_command_ids']! as List<Object?>)
          .cast<String>()
          .toSet(),
      items: <String, CareItemState>{
        for (final Object? item
            in (json['items'] as List<Object?>? ?? const <Object?>[]))
          CareItemState.fromJson((item! as Map).cast<String, Object?>()).id:
              CareItemState.fromJson((item as Map).cast<String, Object?>()),
      },
      households: <String, HouseholdState>{
        for (final Object? item
            in (json['households'] as List<Object?>? ?? const <Object?>[]))
          HouseholdState.fromJson((item! as Map).cast<String, Object?>()).id:
              HouseholdState.fromJson((item as Map).cast<String, Object?>()),
      },
      rooms: <String, RoomState>{
        for (final Object? item
            in (json['rooms'] as List<Object?>? ?? const <Object?>[]))
          RoomState.fromJson((item! as Map).cast<String, Object?>()).id:
              RoomState.fromJson((item as Map).cast<String, Object?>()),
      },
      illnesses: <String, IllnessState>{
        for (final Object? item
            in (json['illnesses'] as List<Object?>? ?? const <Object?>[]))
          IllnessState.fromJson((item! as Map).cast<String, Object?>()).id:
              IllnessState.fromJson((item as Map).cast<String, Object?>()),
      },
      supplyJourneys: <String, SupplyJourneyState>{
        for (final Object? item
            in (json['supply_journeys'] as List<Object?>? ?? const <Object?>[]))
          SupplyJourneyState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: SupplyJourneyState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
    );
  }
}

sealed class SimCommand {
  const SimCommand(this.id);
  final String id;
}

class SetGoalCommand extends SimCommand {
  const SetGoalCommand({
    required String id,
    required this.personId,
    required this.goal,
  }) : super(id);

  final String personId;
  final String goal;
}

class InfantIntentCommand extends SimCommand {
  const InfantIntentCommand({
    required String id,
    required this.personId,
    required this.intent,
  }) : super(id);

  final String personId;
  final InfantIntent intent;
}

class Simulation {
  Simulation.fromSeed(int seed) : _state = WorldState.initial(seed);
  Simulation.fromSave(String source) : _state = WorldState.load(source);

  WorldState _state;
  WorldState get state => _state;

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
      );
      _applyEvent(event);
    }
    if (_state.now.compareTo(target) < 0) _replace(now: target);
  }

  void _applyEvent(ScheduledEvent event) {
    switch (event.kind) {
      case 'birth':
        final String personId = event.payload['person_id']! as String;
        final String name = event.payload['name']! as String;
        if (_state.people.containsKey(personId)) return;
        final bool isInfant = event.payload['infant'] == true;
        final String caregiverId =
            event.payload['caregiver_id'] as String? ?? '';
        _replace(
          people: <String, PersonState>{
            ..._state.people,
            personId: PersonState(
              id: personId,
              name: name,
              birthTime: event.due,
              infancy: isInfant ? InfantState.initial(caregiverId) : null,
              positionMm: event.payload['position_mm'] as int?,
              householdId: event.payload['household_id'] as String?,
              roomId: event.payload['room_id'] as String?,
            ),
          },
          facts: <WorldFact>[
            ..._state.facts,
            _fact('birth', personId, name + ' was born'),
          ],
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
      case 'item_created':
        _applyItemCreated(event);
      case 'household_created':
        _applyHouseholdCreated(event);
      case 'household_meal':
        _applyHouseholdMeal(event);
      case 'household_work_settlement':
        _applyHouseholdWorkSettlement(event);
      case 'room_created':
        _applyRoomCreated(event);
      case 'infant_illness_onset':
        _applyInfantIllnessOnset(event);
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
    final List<RoutineBlock> blocks = <RoutineBlock>[
      for (final Object? raw in payload)
        RoutineBlock.fromJson((raw! as Map).cast<String, Object?>()),
    ];
    if (blocks.isEmpty) return null;
    return RoutineState(blocks: blocks);
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

  /// Điều đang giữ chân một người khỏi cam kết mới, nếu có.
  String? _competingObligation(PersonState person) {
    final RoutineState? routine = person.routine;
    if (routine?.preemptedBy != null) return routine!.preemptedBy;
    if (person.caregiverAgent?.available == false) {
      return 'không đủ sức làm việc';
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
    if (attempt == 0) {
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
      final bool canDefer = attempt < _routineMaxDeferrals;
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
      return;
    }
    PersonState next = person.withRoutine(
      routine.startBlock(blockId, _state.now.seconds),
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
    if (person.caregiverAgent != null) {
      next = next.withCaregiverAgent(
        person.caregiverAgent!.withActivity(block.activity),
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
              '${attempt > 0 ? ' late_attempt=$attempt' : ''}',
        ),
      ],
    );
    final int today =
        (_state.now.seconds ~/ gameSecondsPerDay) * gameSecondsPerDay;
    final int plannedEnd = today + block.endSecondOfDay;
    schedule(
      due: SimTime(
        plannedEnd > _state.now.seconds ? plannedEnd : _state.now.seconds + 60,
      ),
      phase: EventPhase.completion,
      kind: 'routine_block_ended',
      payload: <String, Object?>{'person_id': personId, 'block_id': blockId},
    );
  }

  void _applyRoutineBlockEnded(ScheduledEvent event) {
    final String personId = event.payload['person_id']! as String;
    final String blockId = event.payload['block_id']! as String;
    final PersonState? person = _state.people[personId];
    final RoutineState? routine = person?.routine;
    if (person == null || routine == null) return;
    if (routine.activeBlockId != blockId) return;
    final RoutineState ended = routine.endBlock(_state.now.seconds);
    PersonState next = person.withRoutine(ended);
    if (person.caregiverAgent != null && !routine.preempted) {
      next = next.withCaregiverAgent(
        person.caregiverAgent!.withActivity('nghỉ giữa buổi'),
      );
    }
    _replace(
      people: <String, PersonState>{..._state.people, personId: next},
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'routine_block_ended',
          personId,
          'block=$blockId lost_seconds=${ended.lostSeconds - routine.lostSeconds}',
        ),
      ],
    );
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
    if (caregiver == null ||
        caregiver.caregiverAgent == null ||
        caregiver.positionMm == null ||
        infant.positionMm == null) {
      _failCareResponse(
        personId,
        'care_response_impossible',
        'no_actor_or_position',
      );
      return;
    }
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
    final int distance = (caregiver.positionMm! - infant.positionMm!).abs();
    final int travelSeconds = (distance ~/ 340000).clamp(1, 60);
    schedule(
      due: _state.now.addSeconds(travelSeconds),
      phase: EventPhase.observation,
      kind: 'cry_signal_arrives',
      payload: <String, Object?>{
        'person_id': personId,
        'caregiver_id': caregiver.id,
        'origin_position_mm': infant.positionMm,
        'loudness': 900,
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
    final int soundDistance = (caregiver.positionMm! - originPosition).abs();
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
    final int walkDistance = (caregiver.positionMm! - infant.positionMm!).abs();
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
            ? caregiver!.withPosition(infant.positionMm!)
            : caregiver!.withLocation(
                positionMm: infant.positionMm!,
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
    final Map<String, HouseholdState> households =
        _householdsAfterCareInterruption(caregiver!);
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: infant.withInfancy(feeding.state),
        caregiverId: _resumeRoutine(
          caregiver.withCaregiverAgent(
            caregiver.caregiverAgent!.resumeActivity(),
          ),
        ),
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
        people: <String, PersonState>{
          ..._state.people,
          actorId: actor!.withRoutine(
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
    final String foodId = household.resourceItemIds['food']!;
    final String waterId = household.resourceItemIds['water']!;
    final String fuelId = household.resourceItemIds['fuel']!;
    final bool authorized =
        household.canUse(actorId, foodId) &&
        household.canUse(actorId, waterId) &&
        household.canUse(actorId, fuelId);
    HouseholdState nextHousehold = household;
    Map<String, CareItemState>? items;
    String kind;
    String detail;
    if (!authorized) {
      nextHousehold = household.recordUnauthorizedAttempt();
      kind = 'household_meal_unauthorized';
      detail = 'actor=$actorId';
    } else {
      final CareItemState food = _state.items[foodId]!;
      final CareItemState water = _state.items[waterId]!;
      final CareItemState fuel = _state.items[fuelId]!;
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
    _replace(
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
    final HouseholdState settled = household.settleWorkDay();
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
          'completed_seconds=${settled.workCompletedSecondsByPerson}',
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
      physiologyCoupled:
          event.payload['physiology_coupled'] as bool? ?? false,
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
    final CaregiverAgentState? agent = caregiver?.caregiverAgent;
    if (infant == null || caregiver == null || agent == null) {
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
    final int distance =
        ((caregiver.positionMm ?? 0) - (infant.positionMm ?? 0)).abs();
    final int travelSeconds = agent.movementSpeedMmPerSecond <= 0
        ? gameSecondsPerDay
        : ((distance + agent.movementSpeedMmPerSecond - 1) ~/
                  agent.movementSpeedMmPerSecond)
              .clamp(1, gameSecondsPerDay);
    schedule(
      due: _state.now.addSeconds(travelSeconds),
      phase: EventPhase.movement,
      kind: 'illness_caregiver_arrives',
      payload: <String, Object?>{...event.payload, 'caregiver_id': caregiverId},
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
    final IllnessState? illness = _state.illnesses['ILL-P00-01'];
    final String? householdId = caregiver?.householdId;
    final HouseholdState? household = householdId == null
        ? null
        : _state.households[householdId];
    if (caregiver?.caregiverAgent == null ||
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
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        caregiverId: _resumeRoutine(
          caregiver.withCaregiverAgent(
            caregiver.caregiverAgent!.resumeActivity(),
          ),
        ),
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
    const Map<String, int> amounts = <String, int>{
      'food': 7500,
      'water': 30000,
      'infant_feed': 1500,
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
          'food_g=7500 water_ml=30000 infant_feed_ml=1500',
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
    final String reason =
        event.payload['reason'] as String? ?? 'unknown';
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

  void _applySupplyJourneyStarted(ScheduledEvent event) {
    final String householdId = event.payload['household_id']! as String;
    final String carrierId = event.payload['carrier_id']! as String;
    final int index = event.payload['journey_index']! as int;
    if (_state.households[householdId] == null ||
        _state.people[carrierId] == null) {
      return;
    }
    final String journeyId = 'SUP-$householdId-$index';
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
          'delay_seconds': nextIndex.isEven ? 6 * 3600 : 0,
        },
      );
    }
  }

  PersonState? _selectAvailableCaregiver(
    PersonState infant,
    String preferredId,
  ) {
    final PersonState? preferred = _state.people[preferredId];
    if (preferred?.caregiverAgent?.available == true &&
        preferred!.caregiverAgent!.careSkill >= 400) {
      return preferred;
    }
    final List<PersonState> candidates =
        _state.people.values
            .where(
              (PersonState person) =>
                  person.householdId == infant.householdId &&
                  person.id != infant.id &&
                  person.caregiverAgent?.available == true &&
                  person.caregiverAgent!.careSkill >= 400,
            )
            .toList()
          ..sort((PersonState a, PersonState b) {
            final int bySkill = b.caregiverAgent!.careSkill.compareTo(
              a.caregiverAgent!.careSkill,
            );
            return bySkill != 0 ? bySkill : a.id.compareTo(b.id);
          });
    return candidates.firstOrNull;
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
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        personId: infant.withInfancy(infancy.markCareUnmet()),
        if (caregiver?.caregiverAgent != null)
          caregiver!.id: _resumeRoutine(
            caregiver.withCaregiverAgent(
              caregiver.caregiverAgent!.resumeActivity(),
            ),
          ),
      },
      facts: <WorldFact>[..._state.facts, _fact(kind, personId, detail)],
      households: households,
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
