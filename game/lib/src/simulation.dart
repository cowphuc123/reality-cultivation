import 'dart:convert';

import 'adult_body.dart';
import 'agenda.dart';
import 'care.dart';
import 'domestic.dart';
import 'geometry.dart';
import 'household.dart';
import 'infancy.dart';
import 'route.dart';
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
    this.positionYMm = 0,
    this.caregiverAgent,
    this.householdId,
    this.roomId,
    this.routine,
    this.skills,
    this.agenda,
    this.body,
  });

  final String id;
  final String name;
  final SimTime birthTime;
  final String? activeGoal;
  final InfantState? infancy;
  final int? positionMm;

  /// Trục thứ hai của vị trí; 0 nghĩa là vẫn nằm trên trục cũ.
  final int positionYMm;

  final CaregiverAgentState? caregiverAgent;
  final String? householdId;
  final String? roomId;
  final RoutineState? routine;

  /// Tay nghề theo mã việc; người không có hồ sơ này làm ra sản lượng gốc.
  final PersonSkills? skills;

  /// Trạng thái riêng quyết định nhận hay từ chối việc được giao.
  final PersonAgenda? agenda;

  /// Cơ thể người lớn ở độ phân giải ngày, nếu người này đã trưởng thành.
  final AdultBodyState? body;

  PersonState withGoal(String goal) => _copy(activeGoal: goal);

  PersonState withInfancy(InfantState value, {String? goal}) =>
      _copy(infancy: value, activeGoal: goal ?? activeGoal);

  PersonState withPosition(int value, [int? yValue]) =>
      _copy(positionMm: value, positionYMm: yValue);

  /// Vị trí hai chiều, nếu người này đã được đặt vào thế giới.
  WorldPoint? get point =>
      positionMm == null ? null : WorldPoint(positionMm!, positionYMm);

  PersonState withCaregiverAgent(CaregiverAgentState value) =>
      _copy(caregiverAgent: value);

  PersonState withLocation({
    required int positionMm,
    required String roomId,
    int? positionYMm,
  }) => _copy(
    positionMm: positionMm,
    positionYMm: positionYMm,
    roomId: roomId,
  );

  PersonState withRoutine(RoutineState value) => _copy(routine: value);

  PersonState withAgenda(PersonAgenda value) => _copy(agenda: value);

  PersonState withSkills(PersonSkills value) => _copy(skills: value);

  PersonState withBody(AdultBodyState value) => _copy(body: value);

  PersonState _copy({
    String? activeGoal,
    InfantState? infancy,
    int? positionMm,
    int? positionYMm,
    CaregiverAgentState? caregiverAgent,
    String? roomId,
    RoutineState? routine,
    PersonSkills? skills,
    PersonAgenda? agenda,
    AdultBodyState? body,
  }) => PersonState(
    id: id,
    name: name,
    birthTime: birthTime,
    activeGoal: activeGoal ?? this.activeGoal,
    infancy: infancy ?? this.infancy,
    positionMm: positionMm ?? this.positionMm,
    positionYMm: positionYMm ?? this.positionYMm,
    caregiverAgent: caregiverAgent ?? this.caregiverAgent,
    householdId: householdId,
    roomId: roomId ?? this.roomId,
    routine: routine ?? this.routine,
    skills: skills ?? this.skills,
    agenda: agenda ?? this.agenda,
    body: body ?? this.body,
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
    if (positionYMm != 0) result['position_y_mm'] = positionYMm;
    if (caregiverAgent != null) {
      result['caregiver_agent'] = caregiverAgent!.toJson();
    }
    if (householdId != null) result['household_id'] = householdId;
    if (roomId != null) result['room_id'] = roomId;
    if (routine != null) result['routine'] = routine!.toJson();
    if (skills != null) result['skills'] = skills!.toJson();
    if (agenda != null) result['agenda'] = agenda!.toJson();
    if (body != null) result['adult_body'] = body!.toJson();
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
    positionYMm: json['position_y_mm'] as int? ?? 0,
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
    skills: json['skills'] == null
        ? null
        : PersonSkills.fromJson((json['skills']! as Map).cast<String, Object?>()),
    agenda: json['agenda'] == null
        ? null
        : PersonAgenda.fromJson((json['agenda']! as Map).cast<String, Object?>()),
    body: json['adult_body'] == null
        ? null
        : AdultBodyState.fromJson(
            (json['adult_body']! as Map).cast<String, Object?>(),
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
    this.routes = const <String, TradeRoute>{},
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
    routes: const <String, TradeRoute>{},
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

  /// Các tuyến đường đã được vật chất hóa trong thế giới này.
  final Map<String, TradeRoute> routes;

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
    if (routes.isNotEmpty) {
      final List<TradeRoute> sorted = routes.values.toList()
        ..sort((TradeRoute a, TradeRoute b) => a.id.compareTo(b.id));
      result['routes'] = sorted
          .map((TradeRoute value) => value.toJson())
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
      routes: <String, TradeRoute>{
        for (final Object? item
            in (json['routes'] as List<Object?>? ?? const <Object?>[]))
          TradeRoute.fromJson((item! as Map).cast<String, Object?>()).id:
              TradeRoute.fromJson((item as Map).cast<String, Object?>()),
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
        routes: _state.routes,
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
              positionYMm: event.payload['position_y_mm'] as int? ?? 0,
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
      case 'route_created':
        _applyRouteCreated(event);
      case 'route_leg_arrived':
        _applyRouteLegArrived(event);
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
      final AdultBodyDayResult result = body.advanceDay(
        workedSeconds: agenda.workedSecondsToday,
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
    final RoutineState? routine = person.routine;
    if (routine?.preemptedBy != null) return routine!.preemptedBy;
    if (person.caregiverAgent?.available == false) {
      return 'không đủ sức làm việc';
    }
    return null;
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
      final RoutineBlock block = RoutineBlock(
        id: 'GEN-${need.kind.toUpperCase()}-D$day',
        activity: work.$1,
        startSecondOfDay: startSecond,
        durationSeconds: work.$2,
        roomId: work.$4,
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
    final AdultBodyState? body = worker.body;
    if (body == null || body.capability >= 1000) return bySkill;
    return bySkill * body.capability ~/ 1000;
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
      if (agenda.accepts(priority)) {
        return (personId, agenda.recordOffer(accepted: true));
      }
      // Hộ có theo dõi đói/tâm trạng thì lý do nói rõ cả ba trục.
      final String reason = household.wellbeing
          ? '${agenda.mainStrain} (mệt ${agenda.fatigue}, đói ${agenda.hunger}, '
                'tâm trạng ${agenda.mood}), chỉ nhận việc từ mức '
                '${agenda.acceptanceFloor}'
          : 'mệt ${agenda.fatigue}/1000, chỉ nhận việc từ mức '
                '${agenda.acceptanceFloor}';
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
                'floor=${agenda.acceptanceFloor}'
                '${household.wellbeing ? ' strain=${agenda.mainStrain}' : ''}',
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
      payload: <String, Object?>{
        'person_id': personId,
        'block_id': moved.id,
      },
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
          ? agenda.tire(worked).afterWork(workedSeconds: worked, lostSeconds: lost)
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
    final int distance = caregiver.point!.distanceTo(infant.point!);
    final int travelSeconds = (distance ~/ 340000).clamp(1, 60);
    schedule(
      due: _state.now.addSeconds(travelSeconds),
      phase: EventPhase.observation,
      kind: 'cry_signal_arrives',
      payload: <String, Object?>{
        'person_id': personId,
        'caregiver_id': caregiver.id,
        'origin_position_mm': infant.positionMm,
        if (infant.positionYMm != 0) 'origin_y_mm': infant.positionYMm,
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
      wellbeing: event.payload['enable_v2_6'] == true,
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
      final int shareWaterMl =
          fed && eaters.isNotEmpty ? waterMl ~/ eaters.length : 0;
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
    final HouseholdState settled = _state.households[householdId]!.settleWorkDay();
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

  /// Sức lực của người chở, phần nghìn; chưa có cơ thể thì coi như đủ sức.
  int _carrierCapability(PersonState carrier) =>
      carrier.body?.capability ?? 1000;

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
      _scheduleRouteLeg(
        journey: next,
        route: route,
        legIndex: legIndex + 1,
      );
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
      payload: <String, Object?>{
        ...event.payload,
        'journey_index': nextIndex,
      },
    );
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
    Map<String, TradeRoute>? routes,
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
      routes: Map<String, TradeRoute>.unmodifiable(routes ?? _state.routes),
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
