enum WorldEntryStatus { awaitingBirthSite, born }

/// Trạng thái nhập thế của nhân vật người chơi.
class WorldEntryState {
  const WorldEntryState({
    required this.playerPersonId,
    required this.playerName,
    required this.status,
    this.selectedSiteId,
    this.householdId,
    this.roomId,
    this.caregiverId,
  });

  factory WorldEntryState.awaiting({
    required String playerPersonId,
    required String playerName,
  }) => WorldEntryState(
    playerPersonId: playerPersonId,
    playerName: playerName,
    status: WorldEntryStatus.awaitingBirthSite,
  );

  final String playerPersonId;
  final String playerName;
  final WorldEntryStatus status;
  final String? selectedSiteId;
  final String? householdId;
  final String? roomId;
  final String? caregiverId;

  bool get awaitingBirthSite => status == WorldEntryStatus.awaitingBirthSite;
  bool get born => status == WorldEntryStatus.born;

  WorldEntryState select({
    required String siteId,
    required String selectedHouseholdId,
    required String selectedRoomId,
    required String selectedCaregiverId,
  }) => WorldEntryState(
    playerPersonId: playerPersonId,
    playerName: playerName,
    status: status,
    selectedSiteId: siteId,
    householdId: selectedHouseholdId,
    roomId: selectedRoomId,
    caregiverId: selectedCaregiverId,
  );

  WorldEntryState markBorn() {
    if (selectedSiteId == null ||
        householdId == null ||
        roomId == null ||
        caregiverId == null) {
      throw StateError('Birth site must be selected before birth.');
    }
    return WorldEntryState(
      playerPersonId: playerPersonId,
      playerName: playerName,
      status: WorldEntryStatus.born,
      selectedSiteId: selectedSiteId,
      householdId: householdId,
      roomId: roomId,
      caregiverId: caregiverId,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'player_person_id': playerPersonId,
    'player_name': playerName,
    'status': status.name,
    if (selectedSiteId != null) 'selected_site_id': selectedSiteId!,
    if (householdId != null) 'household_id': householdId!,
    if (roomId != null) 'room_id': roomId!,
    if (caregiverId != null) 'caregiver_id': caregiverId!,
  };

  factory WorldEntryState.fromJson(Map<String, Object?> json) =>
      WorldEntryState(
        playerPersonId: json['player_person_id']! as String,
        playerName: json['player_name']! as String,
        status: WorldEntryStatus.values.byName(json['status']! as String),
        selectedSiteId: json['selected_site_id'] as String?,
        householdId: json['household_id'] as String?,
        roomId: json['room_id'] as String?,
        caregiverId: json['caregiver_id'] as String?,
      );
}

/// Kết quả kiểm tra một địa điểm có thể đón nhân vật sơ sinh hay không.
class BirthSiteCandidate {
  const BirthSiteCandidate({
    required this.siteId,
    required this.siteName,
    required this.siteKind,
    required this.feasible,
    required this.reason,
    this.householdId,
    this.householdName,
    this.roomId,
    this.caregiverId,
    this.caregiverName,
    this.caregiverSkill,
    this.infantFeedQuantity,
    this.foodQuantity,
    this.waterQuantity,
    this.fuelQuantity,
    this.risks = const <String>[],
  });

  final String siteId;
  final String siteName;
  final String siteKind;
  final bool feasible;
  final String reason;
  final String? householdId;
  final String? householdName;
  final String? roomId;
  final String? caregiverId;
  final String? caregiverName;
  final int? caregiverSkill;
  final int? infantFeedQuantity;
  final int? foodQuantity;
  final int? waterQuantity;
  final int? fuelQuantity;
  final List<String> risks;
}
