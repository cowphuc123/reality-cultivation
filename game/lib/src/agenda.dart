/// Kỹ năng nghề và tiếng nói riêng của một người khi hộ giao việc.
///
/// Người không có hai hồ sơ này giữ nguyên hành vi cũ: nhận mọi việc và
/// làm ra đúng sản lượng gốc.
class PersonSkills {
  const PersonSkills(this.levels);

  /// Mức kỹ năng theo mã nghề, thang 0–1000.
  final Map<String, int> levels;

  int level(String code) => levels[code] ?? 0;

  /// Sản lượng thật của một khối việc theo tay nghề.
  ///
  /// Tay nghề 0 vẫn làm được 60% mức gốc; tay nghề 1000 làm đủ 100%.
  int output(String code, int base) =>
      (base * (600 + (400 * level(code)) ~/ 1000)) ~/ 1000;

  Map<String, Object?> toJson() => <String, Object?>{
    for (final String key in levels.keys.toList()..sort()) key: levels[key],
  };

  factory PersonSkills.fromJson(Map<String, Object?> json) =>
      PersonSkills(json.cast<String, int>());
}

/// Trạng thái riêng khiến một người có thể nhận hoặc từ chối việc được giao.
class PersonAgenda {
  const PersonAgenda({
    this.fatigue = 0,
    this.nightRecovery = 250,
    this.acceptedOffers = 0,
    this.refusedOffers = 0,
    this.lastRefusalReason,
  });

  /// Mệt mỏi tích lũy, thang 0–1000.
  final int fatigue;

  /// Số điểm mệt hồi lại sau một đêm.
  final int nightRecovery;

  final int acceptedOffers;
  final int refusedOffers;
  final String? lastRefusalReason;

  /// Càng mệt thì càng chỉ nhận việc gấp: ngưỡng ưu tiên tối thiểu để đồng ý.
  int get acceptanceFloor => fatigue ~/ 10;

  bool accepts(int priority) => priority >= acceptanceFloor;

  /// Làm việc thì mệt thêm; trọn tám giờ cộng 400 điểm.
  PersonAgenda tire(int workedSeconds) {
    if (workedSeconds <= 0) return this;
    final int added = (workedSeconds * 400) ~/ 28800;
    return _copy(fatigue: (fatigue + added).clamp(0, 1000));
  }

  PersonAgenda rest() =>
      _copy(fatigue: (fatigue - nightRecovery).clamp(0, 1000));

  PersonAgenda recordOffer({required bool accepted, String? reason}) => _copy(
    acceptedOffers: accepted ? acceptedOffers + 1 : acceptedOffers,
    refusedOffers: accepted ? refusedOffers : refusedOffers + 1,
    lastRefusalReason: accepted ? lastRefusalReason : reason,
  );

  PersonAgenda _copy({
    int? fatigue,
    int? acceptedOffers,
    int? refusedOffers,
    String? lastRefusalReason,
  }) => PersonAgenda(
    fatigue: fatigue ?? this.fatigue,
    nightRecovery: nightRecovery,
    acceptedOffers: acceptedOffers ?? this.acceptedOffers,
    refusedOffers: refusedOffers ?? this.refusedOffers,
    lastRefusalReason: lastRefusalReason ?? this.lastRefusalReason,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    if (fatigue > 0) 'fatigue': fatigue,
    if (nightRecovery != 250) 'night_recovery': nightRecovery,
    if (acceptedOffers > 0) 'accepted_offers': acceptedOffers,
    if (refusedOffers > 0) 'refused_offers': refusedOffers,
    if (lastRefusalReason != null) 'last_refusal_reason': lastRefusalReason,
  };

  factory PersonAgenda.fromJson(Map<String, Object?> json) => PersonAgenda(
    fatigue: json['fatigue'] as int? ?? 0,
    nightRecovery: json['night_recovery'] as int? ?? 250,
    acceptedOffers: json['accepted_offers'] as int? ?? 0,
    refusedOffers: json['refused_offers'] as int? ?? 0,
    lastRefusalReason: json['last_refusal_reason'] as String?,
  );
}
