class CaregiverAgentState {
  const CaregiverAgentState({
    required this.hearingThreshold,
    required this.movementSpeedMmPerSecond,
    required this.currentActivity,
    this.suspendedActivity,
    this.interruptionStartedSeconds,
    this.available = true,
    this.careSkill = 700,
  });

  final int hearingThreshold;
  final int movementSpeedMmPerSecond;
  final String currentActivity;
  final String? suspendedActivity;
  final int? interruptionStartedSeconds;
  final bool available;
  final int careSkill;

  CaregiverAgentState interruptForCare(int nowSeconds) => CaregiverAgentState(
    hearingThreshold: hearingThreshold,
    movementSpeedMmPerSecond: movementSpeedMmPerSecond,
    currentActivity: 'respond_to_infant',
    suspendedActivity: currentActivity,
    interruptionStartedSeconds: nowSeconds,
    available: available,
    careSkill: careSkill,
  );

  CaregiverAgentState resumeActivity() => CaregiverAgentState(
    hearingThreshold: hearingThreshold,
    movementSpeedMmPerSecond: movementSpeedMmPerSecond,
    currentActivity: suspendedActivity ?? 'idle',
    available: available,
    careSkill: careSkill,
  );

  /// Đổi việc đang làm theo nhịp sống; chỉ dùng khi không bị cắt ngang.
  CaregiverAgentState withActivity(String value) => CaregiverAgentState(
    hearingThreshold: hearingThreshold,
    movementSpeedMmPerSecond: movementSpeedMmPerSecond,
    currentActivity: value,
    available: available,
    careSkill: careSkill,
  );

  CaregiverAgentState withAvailability(bool value) => CaregiverAgentState(
    hearingThreshold: hearingThreshold,
    movementSpeedMmPerSecond: movementSpeedMmPerSecond,
    currentActivity: currentActivity,
    suspendedActivity: suspendedActivity,
    interruptionStartedSeconds: interruptionStartedSeconds,
    available: value,
    careSkill: careSkill,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'hearing_threshold': hearingThreshold,
    'movement_speed_mm_per_second': movementSpeedMmPerSecond,
    'current_activity': currentActivity,
    'suspended_activity': suspendedActivity,
    if (interruptionStartedSeconds != null)
      'interruption_started_seconds': interruptionStartedSeconds,
    if (!available) 'available': false,
    if (careSkill != 700) 'care_skill': careSkill,
  };

  factory CaregiverAgentState.fromJson(Map<String, Object?> json) =>
      CaregiverAgentState(
        hearingThreshold: json['hearing_threshold']! as int,
        movementSpeedMmPerSecond: json['movement_speed_mm_per_second']! as int,
        currentActivity: json['current_activity']! as String,
        suspendedActivity: json['suspended_activity'] as String?,
        interruptionStartedSeconds:
            json['interruption_started_seconds'] as int?,
        available: json['available'] as bool? ?? true,
        careSkill: json['care_skill'] as int? ?? 700,
      );
}

class CareItemState {
  const CareItemState({
    required this.id,
    required this.kind,
    required this.positionMm,
    this.positionYMm = 0,
    required this.quantity,
    required this.condition,
    this.energyKjPer100Ml = 0,
    this.waterMlPer100Ml = 0,
    this.unit = 'count',
    this.ownerHouseholdId,
    this.roomId,
  });

  final String id;
  final String kind;
  final int positionMm;
  final int positionYMm;
  final int quantity;
  final int condition;
  final int energyKjPer100Ml;
  final int waterMlPer100Ml;
  final String unit;
  final String? ownerHouseholdId;
  final String? roomId;

  bool get usable => quantity > 0 && condition > 0;

  CareItemState consume(int amount) => CareItemState(
    id: id,
    kind: kind,
    positionMm: positionMm,
    positionYMm: positionYMm,
    quantity: (quantity - amount).clamp(0, quantity),
    condition: condition,
    energyKjPer100Ml: energyKjPer100Ml,
    waterMlPer100Ml: waterMlPer100Ml,
    unit: unit,
    ownerHouseholdId: ownerHouseholdId,
    roomId: roomId,
  );

  CareItemState wear(int amount) => CareItemState(
    id: id,
    kind: kind,
    positionMm: positionMm,
    positionYMm: positionYMm,
    quantity: quantity,
    condition: (condition - amount).clamp(0, 1000),
    energyKjPer100Ml: energyKjPer100Ml,
    waterMlPer100Ml: waterMlPer100Ml,
    unit: unit,
    ownerHouseholdId: ownerHouseholdId,
    roomId: roomId,
  );

  CareItemState replenish(int amount) => CareItemState(
    id: id,
    kind: kind,
    positionMm: positionMm,
    positionYMm: positionYMm,
    quantity: quantity + amount,
    condition: condition,
    energyKjPer100Ml: energyKjPer100Ml,
    waterMlPer100Ml: waterMlPer100Ml,
    unit: unit,
    ownerHouseholdId: ownerHouseholdId,
    roomId: roomId,
  );

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'kind': kind,
    'position_mm': positionMm,
    if (positionYMm != 0) 'position_y_mm': positionYMm,
    'quantity': quantity,
    'condition': condition,
    if (energyKjPer100Ml > 0) 'energy_kj_per_100ml': energyKjPer100Ml,
    if (waterMlPer100Ml > 0) 'water_ml_per_100ml': waterMlPer100Ml,
    if (unit != 'count') 'unit': unit,
    if (ownerHouseholdId != null) 'owner_household_id': ownerHouseholdId!,
    if (roomId != null) 'room_id': roomId!,
  };

  factory CareItemState.fromJson(Map<String, Object?> json) => CareItemState(
    id: json['id']! as String,
    kind: json['kind']! as String,
    positionMm: json['position_mm']! as int,
    positionYMm: json['position_y_mm'] as int? ?? 0,
    quantity: json['quantity']! as int,
    condition: json['condition']! as int,
    energyKjPer100Ml: json['energy_kj_per_100ml'] as int? ?? 0,
    waterMlPer100Ml: json['water_ml_per_100ml'] as int? ?? 0,
    unit: json['unit'] as String? ?? 'count',
    ownerHouseholdId: json['owner_household_id'] as String?,
    roomId: json['room_id'] as String?,
  );
}
