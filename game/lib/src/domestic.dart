class RoomState {
  const RoomState({
    required this.id,
    required this.name,
    required this.householdId,
    required this.anchorPositionMm,
    this.anchorPositionYMm = 0,
  });

  final String id;
  final String name;
  final String householdId;
  final int anchorPositionMm;

  /// Trục thứ hai của mốc phòng; 0 nghĩa là vẫn nằm trên trục cũ.
  final int anchorPositionYMm;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'household_id': householdId,
    'anchor_position_mm': anchorPositionMm,
    if (anchorPositionYMm != 0) 'anchor_position_y_mm': anchorPositionYMm,
  };

  factory RoomState.fromJson(Map<String, Object?> json) => RoomState(
    id: json['id']! as String,
    name: json['name']! as String,
    householdId: json['household_id']! as String,
    anchorPositionMm: json['anchor_position_mm']! as int,
    anchorPositionYMm: json['anchor_position_y_mm'] as int? ?? 0,
  );
}

enum SupplyJourneyStatus { traveling, delayed, delivered }

class SupplyJourneyState {
  const SupplyJourneyState({
    required this.id,
    required this.householdId,
    required this.carrierId,
    required this.departureSeconds,
    required this.expectedArrivalSeconds,
    required this.status,
    required this.cargo,
    required this.currentLeg,
    this.delaySeconds = 0,
    this.delayReason,
    this.actualArrivalSeconds,
    this.routeId,
    this.legIndex = 0,
    this.legCount = 0,
    this.travelledMm = 0,
    this.worstLegLostSeconds = 0,
    this.pathWaypointIds = const <String>[],
  });

  final String id;
  final String householdId;
  final String carrierId;
  final int departureSeconds;
  final int expectedArrivalSeconds;
  final SupplyJourneyStatus status;
  final Map<String, int> cargo;
  final String currentLeg;
  final int delaySeconds;
  final String? delayReason;
  final int? actualArrivalSeconds;

  /// Tuyến đường đang đi, nếu chuyến này chạy trên tuyến thật.
  final String? routeId;

  /// Chặng thứ mấy trong tuyến, đếm từ 0.
  final int legIndex;

  /// Tổng số chặng của tuyến.
  final int legCount;

  /// Quãng đường đã đi được, tính bằng mm.
  final int travelledMm;

  /// Số giây mất thêm của chặng tốn giờ nhất, dùng để quy trách nhiệm đúng chỗ.
  final int worstLegLostSeconds;

  /// Dãy điểm mốc người chở đã chọn đi, từ nơi khởi hành tới đích.
  final List<String> pathWaypointIds;

  bool get onRoute => routeId != null;

  SupplyJourneyState delayed({required int seconds, required String reason}) =>
      _copy(
        status: SupplyJourneyStatus.delayed,
        currentLeg: 'mountain_road_delayed',
        delaySeconds: seconds,
        delayReason: reason,
      );

  SupplyJourneyState delivered(int nowSeconds) => _copy(
    status: SupplyJourneyStatus.delivered,
    currentLeg: 'household_yard',
    actualArrivalSeconds: nowSeconds,
  );

  /// Sang chặng kế tiếp của tuyến.
  SupplyJourneyState advanceLeg({
    required int legIndex,
    required String currentLeg,
    required int travelledMm,
  }) => _copy(
    currentLeg: currentLeg,
    legIndex: legIndex,
    travelledMm: travelledMm,
  );

  /// Ghi nhận chuyến đi lâu hơn dự kiến vì địa hình, tải hoặc sức người chở.
  ///
  /// Lý do luôn trỏ về chặng tốn giờ nhất, không phải chặng gần đây nhất.
  SupplyJourneyState slowedBy({required int seconds, required String reason}) {
    final bool worst = seconds > worstLegLostSeconds;
    return _copy(
      status: SupplyJourneyStatus.delayed,
      delaySeconds: delaySeconds + seconds,
      delayReason: worst ? reason : delayReason,
      worstLegLostSeconds: worst ? seconds : worstLegLostSeconds,
    );
  }

  SupplyJourneyState _copy({
    SupplyJourneyStatus? status,
    String? currentLeg,
    int? delaySeconds,
    String? delayReason,
    int? actualArrivalSeconds,
    int? legIndex,
    int? travelledMm,
    int? worstLegLostSeconds,
    List<String>? pathWaypointIds,
  }) => SupplyJourneyState(
    id: id,
    householdId: householdId,
    carrierId: carrierId,
    departureSeconds: departureSeconds,
    expectedArrivalSeconds: expectedArrivalSeconds,
    status: status ?? this.status,
    cargo: cargo,
    currentLeg: currentLeg ?? this.currentLeg,
    delaySeconds: delaySeconds ?? this.delaySeconds,
    delayReason: delayReason ?? this.delayReason,
    actualArrivalSeconds: actualArrivalSeconds ?? this.actualArrivalSeconds,
    routeId: routeId,
    legIndex: legIndex ?? this.legIndex,
    legCount: legCount,
    travelledMm: travelledMm ?? this.travelledMm,
    worstLegLostSeconds: worstLegLostSeconds ?? this.worstLegLostSeconds,
    pathWaypointIds: pathWaypointIds ?? this.pathWaypointIds,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'household_id': householdId,
    'carrier_id': carrierId,
    'departure_seconds': departureSeconds,
    'expected_arrival_seconds': expectedArrivalSeconds,
    'status': status.name,
    'cargo': <String, int>{
      for (final String key in cargo.keys.toList()..sort()) key: cargo[key]!,
    },
    'current_leg': currentLeg,
    if (delaySeconds > 0) 'delay_seconds': delaySeconds,
    if (delayReason != null) 'delay_reason': delayReason,
    if (actualArrivalSeconds != null)
      'actual_arrival_seconds': actualArrivalSeconds,
    if (routeId != null) 'route_id': routeId,
    if (legIndex > 0) 'leg_index': legIndex,
    if (legCount > 0) 'leg_count': legCount,
    if (travelledMm > 0) 'travelled_mm': travelledMm,
    if (worstLegLostSeconds > 0) 'worst_leg_lost_seconds': worstLegLostSeconds,
    if (pathWaypointIds.isNotEmpty) 'path_waypoint_ids': pathWaypointIds,
  };

  factory SupplyJourneyState.fromJson(Map<String, Object?> json) =>
      SupplyJourneyState(
        id: json['id']! as String,
        householdId: json['household_id']! as String,
        carrierId: json['carrier_id']! as String,
        departureSeconds: json['departure_seconds']! as int,
        expectedArrivalSeconds: json['expected_arrival_seconds']! as int,
        status: SupplyJourneyStatus.values.byName(json['status']! as String),
        cargo: (json['cargo']! as Map).cast<String, int>(),
        currentLeg: json['current_leg']! as String,
        delaySeconds: json['delay_seconds'] as int? ?? 0,
        delayReason: json['delay_reason'] as String?,
        actualArrivalSeconds: json['actual_arrival_seconds'] as int?,
        routeId: json['route_id'] as String?,
        legIndex: json['leg_index'] as int? ?? 0,
        legCount: json['leg_count'] as int? ?? 0,
        travelledMm: json['travelled_mm'] as int? ?? 0,
        worstLegLostSeconds: json['worst_leg_lost_seconds'] as int? ?? 0,
        pathWaypointIds:
            (json['path_waypoint_ids'] as List<Object?>?)?.cast<String>() ??
            const <String>[],
      );
}

enum IllnessStage { symptomatic, recovering, resolved }

class IllnessState {
  const IllnessState({
    required this.id,
    required this.personId,
    required this.kind,
    required this.onsetSeconds,
    required this.stage,
    required this.severity,
    required this.bodyTemperatureMilliC,
    required this.symptoms,
    this.detected = false,
    this.careMinutes = 0,
    this.physiologyCoupled = false,
  });

  final String id;
  final String personId;
  final String kind;
  final int onsetSeconds;
  final IllnessStage stage;
  final int severity;
  final int bodyTemperatureMilliC;
  final List<String> symptoms;
  final bool detected;
  final int careMinutes;
  final bool physiologyCoupled;

  bool get active => stage != IllnessStage.resolved;

  IllnessState afterCare(int minutes) => _copy(
    stage: IllnessStage.recovering,
    detected: true,
    careMinutes: careMinutes + minutes,
    severity: (severity - 120).clamp(0, 1000),
    bodyTemperatureMilliC: (bodyTemperatureMilliC - 180).clamp(36500, 42000),
  );

  IllnessState progress() {
    if (!active) return this;
    final int nextSeverity = detected
        ? (severity - 35).clamp(0, 1000)
        : (severity + 50).clamp(0, 1000);
    final bool resolved = nextSeverity == 0;
    return _copy(
      stage: resolved
          ? IllnessStage.resolved
          : detected
          ? IllnessStage.recovering
          : IllnessStage.symptomatic,
      severity: nextSeverity,
      bodyTemperatureMilliC: resolved
          ? 37000
          : detected
          ? (bodyTemperatureMilliC - 90).clamp(37000, 42000)
          : (bodyTemperatureMilliC + 80).clamp(36500, 42000),
    );
  }

  IllnessState _copy({
    IllnessStage? stage,
    int? severity,
    int? bodyTemperatureMilliC,
    bool? detected,
    int? careMinutes,
  }) => IllnessState(
    id: id,
    personId: personId,
    kind: kind,
    onsetSeconds: onsetSeconds,
    stage: stage ?? this.stage,
    severity: severity ?? this.severity,
    bodyTemperatureMilliC: bodyTemperatureMilliC ?? this.bodyTemperatureMilliC,
    symptoms: symptoms,
    detected: detected ?? this.detected,
    careMinutes: careMinutes ?? this.careMinutes,
    physiologyCoupled: physiologyCoupled,
  );

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'person_id': personId,
    'kind': kind,
    'onset_seconds': onsetSeconds,
    'stage': stage.name,
    'severity': severity,
    'body_temperature_millic': bodyTemperatureMilliC,
    'symptoms': symptoms,
    'detected': detected,
    'care_minutes': careMinutes,
    if (physiologyCoupled) 'physiology_coupled': true,
  };

  factory IllnessState.fromJson(Map<String, Object?> json) => IllnessState(
    id: json['id']! as String,
    personId: json['person_id']! as String,
    kind: json['kind']! as String,
    onsetSeconds: json['onset_seconds']! as int,
    stage: IllnessStage.values.byName(json['stage']! as String),
    severity: json['severity']! as int,
    bodyTemperatureMilliC: json['body_temperature_millic']! as int,
    symptoms: (json['symptoms']! as List<Object?>).cast<String>(),
    detected: json['detected'] as bool? ?? false,
    careMinutes: json['care_minutes'] as int? ?? 0,
    physiologyCoupled: json['physiology_coupled'] as bool? ?? false,
  );
}
