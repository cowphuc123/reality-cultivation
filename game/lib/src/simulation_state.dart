part of 'simulation.dart';

/// Dữ liệu lõi của hàng đợi sự kiện và snapshot thế giới.
/// Tách khỏi bộ điều phối để save/load và trạng thái có ranh giới riêng.
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
    this.childhood,
    this.positionMm,
    this.positionYMm = 0,
    this.caregiverAgent,
    this.householdId,
    this.roomId,
    this.routine,
    this.timeCommitment,
    this.skills,
    this.agenda,
    this.body,
    this.occupationCode,
    this.occupationName,
    this.originSummary,
    this.beliefs = const <String, BeliefState>{},
    this.socialRelations = const <String, SocialRelationState>{},
    this.familyRelationships = const <String, String>{},
    this.familyBonds = const <String, FamilyBondState>{},
  });

  final String id;
  final String name;
  final SimTime birthTime;
  final String? activeGoal;
  final InfantState? infancy;
  final ChildhoodState? childhood;
  final int? positionMm;

  /// Trục thứ hai của vị trí; 0 nghĩa là vẫn nằm trên trục cũ.
  final int positionYMm;

  final CaregiverAgentState? caregiverAgent;
  final String? householdId;
  final String? roomId;
  final RoutineState? routine;

  /// Chuyến đi hoặc nghĩa vụ phát sinh đang giữ thời gian của người này.
  final PersonalTimeCommitment? timeCommitment;

  /// Tay nghề theo mã việc; người không có hồ sơ này làm ra sản lượng gốc.
  final PersonSkills? skills;

  /// Trạng thái riêng quyết định nhận hay từ chối việc được giao.
  final PersonAgenda? agenda;

  /// Cơ thể người lớn ở độ phân giải ngày, nếu người này đã trưởng thành.
  final AdultBodyState? body;

  /// Nghề hiện tại và xuất thân được sinh cùng dân làng, có mặt trong bản lưu.
  final String? occupationCode;
  final String? occupationName;
  final String? originSummary;

  /// Mã bằng chứng nguồn -> điều người này đã quan sát hoặc được kể.
  final Map<String, BeliefState> beliefs;

  /// Mã người khác -> quan hệ một chiều hình thành qua tiếp xúc thật.
  final Map<String, SocialRelationState> socialRelations;

  /// Mã người thân -> vai trò của người đó đối với nhân vật này.
  final Map<String, String> familyRelationships;

  /// Mã người thân -> trạng thái gắn bó và ký ức một chiều.
  final Map<String, FamilyBondState> familyBonds;

  PersonState withGoal(String goal) => _copy(activeGoal: goal);

  PersonState withInfancy(InfantState value, {String? goal}) =>
      _copy(infancy: value, activeGoal: goal ?? activeGoal);

  PersonState withChildhood(ChildhoodState value, {String? goal}) =>
      _copy(childhood: value, activeGoal: goal ?? activeGoal);

  PersonState withPosition(int value, [int? yValue]) =>
      _copy(positionMm: value, positionYMm: yValue);

  /// Đặt người trên tuyến ngoài mọi phòng trong lúc đang di chuyển.
  PersonState withTransitPosition(int value, [int? yValue]) => _copy(
    positionMm: value,
    positionYMm: yValue,
    clearRoom: true,
  );

  /// Vị trí hai chiều, nếu người này đã được đặt vào thế giới.
  WorldPoint? get point =>
      positionMm == null ? null : WorldPoint(positionMm!, positionYMm);

  PersonState withCaregiverAgent(CaregiverAgentState value) =>
      _copy(caregiverAgent: value);

  PersonState withLocation({
    required int positionMm,
    required String roomId,
    int? positionYMm,
  }) => _copy(positionMm: positionMm, positionYMm: positionYMm, roomId: roomId);

  PersonState withRoutine(RoutineState value) => _copy(routine: value);

  PersonState withTimeCommitment(PersonalTimeCommitment value) =>
      _copy(timeCommitment: value);

  PersonState clearTimeCommitment() => _copy(clearTimeCommitment: true);

  PersonState withAgenda(PersonAgenda value) => _copy(agenda: value);

  PersonState withSkills(PersonSkills value) => _copy(skills: value);

  PersonState withBody(AdultBodyState value) => _copy(body: value);

  PersonState learn(BeliefState belief) {
    final BeliefState? existing = beliefs[belief.id];
    // Nghe lại đúng bằng chứng gốc không làm độ chắc tăng vô hạn. Bản trực tiếp
    // hoặc bản ít chặng hơn được giữ nếu hai đường truyền gặp nhau.
    if (existing != null &&
        (existing.confidence > belief.confidence ||
            (existing.confidence == belief.confidence &&
                existing.transmissionCount <= belief.transmissionCount))) {
      return this;
    }
    return _copy(beliefs: <String, BeliefState>{...beliefs, belief.id: belief});
  }

  PersonState withFamilyRelationship(String personId, String role) => _copy(
    familyRelationships: <String, String>{
      ...familyRelationships,
      personId: role,
    },
  );

  PersonState withSocialRelation(
    String personId,
    SocialRelationState relation,
  ) => _copy(
    socialRelations: <String, SocialRelationState>{
      ...socialRelations,
      personId: relation,
    },
  );

  PersonState withFamilyBond(String personId, FamilyBondState bond) => _copy(
    familyBonds: <String, FamilyBondState>{...familyBonds, personId: bond},
  );

  PersonState _copy({
    String? activeGoal,
    InfantState? infancy,
    ChildhoodState? childhood,
    int? positionMm,
    int? positionYMm,
    CaregiverAgentState? caregiverAgent,
    String? roomId,
    RoutineState? routine,
    PersonalTimeCommitment? timeCommitment,
    PersonSkills? skills,
    PersonAgenda? agenda,
    AdultBodyState? body,
    Map<String, BeliefState>? beliefs,
    Map<String, SocialRelationState>? socialRelations,
    Map<String, String>? familyRelationships,
    Map<String, FamilyBondState>? familyBonds,
    bool clearTimeCommitment = false,
    bool clearRoom = false,
  }) => PersonState(
    id: id,
    name: name,
    birthTime: birthTime,
    activeGoal: activeGoal ?? this.activeGoal,
    infancy: infancy ?? this.infancy,
    childhood: childhood ?? this.childhood,
    positionMm: positionMm ?? this.positionMm,
    positionYMm: positionYMm ?? this.positionYMm,
    caregiverAgent: caregiverAgent ?? this.caregiverAgent,
    householdId: householdId,
    roomId: clearRoom ? null : roomId ?? this.roomId,
    routine: routine ?? this.routine,
    timeCommitment: clearTimeCommitment
        ? null
        : (timeCommitment ?? this.timeCommitment),
    skills: skills ?? this.skills,
    agenda: agenda ?? this.agenda,
    body: body ?? this.body,
    occupationCode: occupationCode,
    occupationName: occupationName,
    originSummary: originSummary,
    beliefs: beliefs ?? this.beliefs,
    socialRelations: socialRelations ?? this.socialRelations,
    familyRelationships: familyRelationships ?? this.familyRelationships,
    familyBonds: familyBonds ?? this.familyBonds,
  );

  Map<String, Object?> toJson() {
    final Map<String, Object?> result = <String, Object?>{
      'id': id,
      'name': name,
      'birth_time': birthTime.toJson(),
      'active_goal': activeGoal,
    };
    if (infancy != null) result['infancy'] = infancy!.toJson();
    if (childhood != null) result['childhood'] = childhood!.toJson();
    if (positionMm != null) result['position_mm'] = positionMm;
    if (positionYMm != 0) result['position_y_mm'] = positionYMm;
    if (caregiverAgent != null) {
      result['caregiver_agent'] = caregiverAgent!.toJson();
    }
    if (householdId != null) result['household_id'] = householdId;
    if (roomId != null) result['room_id'] = roomId;
    if (routine != null) result['routine'] = routine!.toJson();
    if (timeCommitment != null) {
      result['time_commitment'] = timeCommitment!.toJson();
    }
    if (skills != null) result['skills'] = skills!.toJson();
    if (agenda != null) result['agenda'] = agenda!.toJson();
    if (body != null) result['adult_body'] = body!.toJson();
    if (occupationCode != null) result['occupation_code'] = occupationCode;
    if (occupationName != null) result['occupation_name'] = occupationName;
    if (originSummary != null) result['origin_summary'] = originSummary;
    if (beliefs.isNotEmpty) {
      result['beliefs'] = <String, Object?>{
        for (final String key in beliefs.keys.toList()..sort())
          key: beliefs[key]!.toJson(),
      };
    }
    if (socialRelations.isNotEmpty) {
      result['social_relations'] = <String, Object?>{
        for (final String key in socialRelations.keys.toList()..sort())
          key: socialRelations[key]!.toJson(),
      };
    }
    if (familyRelationships.isNotEmpty) {
      result['family_relationships'] = <String, String>{
        for (final String key in familyRelationships.keys.toList()..sort())
          key: familyRelationships[key]!,
      };
    }
    if (familyBonds.isNotEmpty) {
      result['family_bonds'] = <String, Object?>{
        for (final String key in familyBonds.keys.toList()..sort())
          key: familyBonds[key]!.toJson(),
      };
    }
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
    childhood: json['childhood'] == null
        ? null
        : ChildhoodState.fromJson(
            (json['childhood']! as Map).cast<String, Object?>(),
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
    timeCommitment: json['time_commitment'] == null
        ? null
        : PersonalTimeCommitment.fromJson(
            (json['time_commitment']! as Map).cast<String, Object?>(),
          ),
    skills: json['skills'] == null
        ? null
        : PersonSkills.fromJson(
            (json['skills']! as Map).cast<String, Object?>(),
          ),
    agenda: json['agenda'] == null
        ? null
        : PersonAgenda.fromJson(
            (json['agenda']! as Map).cast<String, Object?>(),
          ),
    body: json['adult_body'] == null
        ? null
        : AdultBodyState.fromJson(
            (json['adult_body']! as Map).cast<String, Object?>(),
          ),
    occupationCode: json['occupation_code'] as String?,
    occupationName: json['occupation_name'] as String?,
    originSummary: json['origin_summary'] as String?,
    beliefs: <String, BeliefState>{
      for (final MapEntry<String, Object?> entry
          in ((json['beliefs'] as Map?)?.cast<String, Object?>() ??
                  const <String, Object?>{})
              .entries)
        entry.key: BeliefState.fromJson(
          (entry.value! as Map).cast<String, Object?>(),
        ),
    },
    socialRelations: <String, SocialRelationState>{
      for (final MapEntry<String, Object?> entry
          in ((json['social_relations'] as Map?)?.cast<String, Object?>() ??
                  const <String, Object?>{})
              .entries)
        entry.key: SocialRelationState.fromJson(
          (entry.value! as Map).cast<String, Object?>(),
        ),
    },
    familyRelationships:
        (json['family_relationships'] as Map?)?.cast<String, String>() ??
        const <String, String>{},
    familyBonds: <String, FamilyBondState>{
      for (final MapEntry<String, Object?> entry
          in ((json['family_bonds'] as Map?)?.cast<String, Object?>() ??
                  const <String, Object?>{})
              .entries)
        entry.key: FamilyBondState.fromJson(
          (entry.value! as Map).cast<String, Object?>(),
        ),
    },
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
    required this.communityExchanges,
    this.productionBatches = const <String, ProductionBatchState>{},
    this.serviceAppointments = const <String, ServiceAppointmentState>{},
    this.laborOffers = const <String, LaborOfferState>{},
    this.laborClaims = const <String, LaborCompensationClaim>{},
    this.marketOffers = const <String, MarketOfferState>{},
    this.marketOrders = const <String, MarketOrderState>{},
    this.marketShipments = const <String, MarketShipmentState>{},
    this.supplyShocks = const <String, SupplyShockState>{},
    this.communitySurvival,
    this.routes = const <String, TradeRoute>{},
    this.regions = const <String, WorldRegion>{},
    this.sites = const <String, WorldSite>{},
    this.worldGenesis,
    this.worldEntry,
    this.worldHistory,
    this.historicalLegacy,
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
    communityExchanges: const <String, CommunityExchangeState>{},
    productionBatches: const <String, ProductionBatchState>{},
    serviceAppointments: const <String, ServiceAppointmentState>{},
    laborOffers: const <String, LaborOfferState>{},
    laborClaims: const <String, LaborCompensationClaim>{},
    marketOffers: const <String, MarketOfferState>{},
    marketOrders: const <String, MarketOrderState>{},
    marketShipments: const <String, MarketShipmentState>{},
    supplyShocks: const <String, SupplyShockState>{},
    communitySurvival: null,
    routes: const <String, TradeRoute>{},
    regions: const <String, WorldRegion>{},
    sites: const <String, WorldSite>{},
    worldGenesis: null,
    worldEntry: null,
    worldHistory: null,
    historicalLegacy: null,
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
  final Map<String, CommunityExchangeState> communityExchanges;
  final Map<String, ProductionBatchState> productionBatches;
  final Map<String, ServiceAppointmentState> serviceAppointments;
  final Map<String, LaborOfferState> laborOffers;
  final Map<String, LaborCompensationClaim> laborClaims;
  final Map<String, MarketOfferState> marketOffers;
  final Map<String, MarketOrderState> marketOrders;
  final Map<String, MarketShipmentState> marketShipments;
  final Map<String, SupplyShockState> supplyShocks;
  final CommunitySurvivalState? communitySurvival;

  /// Các tuyến đường đã được vật chất hóa trong thế giới này.
  final Map<String, TradeRoute> routes;

  /// Các vùng và địa điểm đã được vật chất hóa trên bản đồ thế giới.
  final Map<String, WorldRegion> regions;
  final Map<String, WorldSite> sites;

  /// Dấu vết của bộ sinh đã công bố bản đồ này, nếu thế giới dùng worldgen.
  final WorldGenesisRecord? worldGenesis;

  /// Luồng chọn nơi sinh, chỉ có ở thế giới đã bật nhập thế V2.16.
  final WorldEntryState? worldEntry;

  /// Lịch sử vĩ mô đã chạy trước khi nhân vật người chơi ra đời.
  final WorldHistoryState? worldHistory;

  /// Hậu quả vật chất mà tiền sử để lại trong snapshot bắt đầu chơi.
  final HistoricalLegacyState? historicalLegacy;

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
    if (communityExchanges.isNotEmpty) {
      final List<CommunityExchangeState> sorted =
          communityExchanges.values.toList()..sort(
            (CommunityExchangeState a, CommunityExchangeState b) =>
                a.id.compareTo(b.id),
          );
      result['community_exchanges'] = sorted
          .map((CommunityExchangeState value) => value.toJson())
          .toList();
    }
    if (productionBatches.isNotEmpty) {
      final List<ProductionBatchState> sorted = productionBatches.values
          .toList()
        ..sort(
          (ProductionBatchState a, ProductionBatchState b) =>
              a.id.compareTo(b.id),
        );
      result['production_batches'] = sorted
          .map((ProductionBatchState value) => value.toJson())
          .toList();
    }
    if (serviceAppointments.isNotEmpty) {
      final List<ServiceAppointmentState> sorted = serviceAppointments.values
          .toList()
        ..sort(
          (ServiceAppointmentState a, ServiceAppointmentState b) =>
              a.id.compareTo(b.id),
        );
      result['service_appointments'] = sorted
          .map((ServiceAppointmentState value) => value.toJson())
          .toList();
    }
    if (laborOffers.isNotEmpty) {
      final List<LaborOfferState> sorted = laborOffers.values.toList()
        ..sort(
          (LaborOfferState a, LaborOfferState b) => a.id.compareTo(b.id),
        );
      result['labor_offers'] = sorted
          .map((LaborOfferState value) => value.toJson())
          .toList();
    }
    if (laborClaims.isNotEmpty) {
      final List<LaborCompensationClaim> sorted = laborClaims.values.toList()
        ..sort(
          (LaborCompensationClaim a, LaborCompensationClaim b) =>
              a.id.compareTo(b.id),
        );
      result['labor_claims'] = sorted
          .map((LaborCompensationClaim value) => value.toJson())
          .toList();
    }
    if (marketOffers.isNotEmpty) {
      final List<MarketOfferState> sorted = marketOffers.values.toList()
        ..sort(
          (MarketOfferState a, MarketOfferState b) => a.id.compareTo(b.id),
        );
      result['market_offers'] = sorted
          .map((MarketOfferState value) => value.toJson())
          .toList();
    }
    if (marketOrders.isNotEmpty) {
      final List<MarketOrderState> sorted = marketOrders.values.toList()
        ..sort(
          (MarketOrderState a, MarketOrderState b) => a.id.compareTo(b.id),
        );
      result['market_orders'] = sorted
          .map((MarketOrderState value) => value.toJson())
          .toList();
    }
    if (marketShipments.isNotEmpty) {
      final List<MarketShipmentState> sorted = marketShipments.values.toList()
        ..sort(
          (MarketShipmentState a, MarketShipmentState b) =>
              a.id.compareTo(b.id),
        );
      result['market_shipments'] = sorted
          .map((MarketShipmentState value) => value.toJson())
          .toList();
    }
    if (supplyShocks.isNotEmpty) {
      final List<SupplyShockState> sorted = supplyShocks.values.toList()
        ..sort((SupplyShockState a, SupplyShockState b) => a.id.compareTo(b.id));
      result['supply_shocks'] = sorted
          .map((SupplyShockState value) => value.toJson())
          .toList();
    }
    if (communitySurvival != null) {
      result['community_survival'] = communitySurvival!.toJson();
    }
    if (routes.isNotEmpty) {
      final List<TradeRoute> sorted = routes.values.toList()
        ..sort((TradeRoute a, TradeRoute b) => a.id.compareTo(b.id));
      result['routes'] = sorted
          .map((TradeRoute value) => value.toJson())
          .toList();
    }
    if (regions.isNotEmpty) {
      final List<WorldRegion> sorted = regions.values.toList()
        ..sort((WorldRegion a, WorldRegion b) => a.id.compareTo(b.id));
      result['regions'] = sorted
          .map((WorldRegion value) => value.toJson())
          .toList();
    }
    if (sites.isNotEmpty) {
      final List<WorldSite> sorted = sites.values.toList()
        ..sort((WorldSite a, WorldSite b) => a.id.compareTo(b.id));
      result['sites'] = sorted
          .map((WorldSite value) => value.toJson())
          .toList();
    }
    if (worldGenesis != null) {
      result['world_genesis'] = worldGenesis!.toJson();
    }
    if (worldEntry != null) {
      result['world_entry'] = worldEntry!.toJson();
    }
    if (worldHistory != null) {
      result['world_history'] = worldHistory!.toJson();
    }
    if (historicalLegacy != null) {
      result['historical_legacy'] = historicalLegacy!.toJson();
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
      communityExchanges: <String, CommunityExchangeState>{
        for (final Object? item
            in (json['community_exchanges'] as List<Object?>? ??
                const <Object?>[]))
          CommunityExchangeState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: CommunityExchangeState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      productionBatches: <String, ProductionBatchState>{
        for (final Object? item
            in (json['production_batches'] as List<Object?>? ??
                const <Object?>[]))
          ProductionBatchState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: ProductionBatchState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      serviceAppointments: <String, ServiceAppointmentState>{
        for (final Object? item
            in (json['service_appointments'] as List<Object?>? ??
                const <Object?>[]))
          ServiceAppointmentState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: ServiceAppointmentState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      laborOffers: <String, LaborOfferState>{
        for (final Object? item
            in (json['labor_offers'] as List<Object?>? ?? const <Object?>[]))
          LaborOfferState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: LaborOfferState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      laborClaims: <String, LaborCompensationClaim>{
        for (final Object? item
            in (json['labor_claims'] as List<Object?>? ?? const <Object?>[]))
          LaborCompensationClaim.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: LaborCompensationClaim.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      marketOffers: <String, MarketOfferState>{
        for (final Object? item
            in (json['market_offers'] as List<Object?>? ?? const <Object?>[]))
          MarketOfferState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: MarketOfferState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      marketOrders: <String, MarketOrderState>{
        for (final Object? item
            in (json['market_orders'] as List<Object?>? ?? const <Object?>[]))
          MarketOrderState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: MarketOrderState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      marketShipments: <String, MarketShipmentState>{
        for (final Object? item in (json['market_shipments'] as List<Object?>? ??
            const <Object?>[]))
          MarketShipmentState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: MarketShipmentState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      supplyShocks: <String, SupplyShockState>{
        for (final Object? item
            in (json['supply_shocks'] as List<Object?>? ?? const <Object?>[]))
          SupplyShockState.fromJson(
            (item! as Map).cast<String, Object?>(),
          ).id: SupplyShockState.fromJson(
            (item as Map).cast<String, Object?>(),
          ),
      },
      communitySurvival: json['community_survival'] == null
          ? null
          : CommunitySurvivalState.fromJson(
              (json['community_survival']! as Map).cast<String, Object?>(),
            ),
      routes: <String, TradeRoute>{
        for (final Object? item
            in (json['routes'] as List<Object?>? ?? const <Object?>[]))
          TradeRoute.fromJson((item! as Map).cast<String, Object?>()).id:
              TradeRoute.fromJson((item as Map).cast<String, Object?>()),
      },
      regions: <String, WorldRegion>{
        for (final Object? item
            in (json['regions'] as List<Object?>? ?? const <Object?>[]))
          WorldRegion.fromJson((item! as Map).cast<String, Object?>()).id:
              WorldRegion.fromJson((item as Map).cast<String, Object?>()),
      },
      sites: <String, WorldSite>{
        for (final Object? item
            in (json['sites'] as List<Object?>? ?? const <Object?>[]))
          WorldSite.fromJson((item! as Map).cast<String, Object?>()).id:
              WorldSite.fromJson((item as Map).cast<String, Object?>()),
      },
      worldGenesis: json['world_genesis'] == null
          ? null
          : WorldGenesisRecord.fromJson(
              (json['world_genesis']! as Map).cast<String, Object?>(),
            ),
      worldEntry: json['world_entry'] == null
          ? null
          : WorldEntryState.fromJson(
              (json['world_entry']! as Map).cast<String, Object?>(),
            ),
      worldHistory: json['world_history'] == null
          ? null
          : WorldHistoryState.fromJson(
              (json['world_history']! as Map).cast<String, Object?>(),
            ),
      historicalLegacy: json['historical_legacy'] == null
          ? null
          : HistoricalLegacyState.fromJson(
              (json['historical_legacy']! as Map).cast<String, Object?>(),
            ),
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

class ChildIntentCommand extends SimCommand {
  const ChildIntentCommand({
    required String id,
    required this.personId,
    required this.intent,
  }) : super(id);

  final String personId;
  final ChildIntent intent;
}

class ChooseBirthSiteCommand extends SimCommand {
  const ChooseBirthSiteCommand({required String id, required this.siteId})
    : super(id);

  final String siteId;
}
