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

  /// Số điểm nghề lên được sau khi làm ngần này giây.
  ///
  /// Người mới lên nhanh, người đã giỏi lên chậm: trọn tám giờ cho 50 điểm
  /// ở mức 0 nhưng chỉ 7 điểm ở mức 850.
  int gainFrom(String code, int workedSeconds) {
    if (workedSeconds <= 0) return 0;
    final int current = level(code);
    if (current >= 1000) return 0;
    return (workedSeconds * (1000 - current)) ~/ 576000;
  }

  PersonSkills improve(String code, int gain) {
    if (gain <= 0) return this;
    return PersonSkills(<String, int>{
      ...levels,
      code: (level(code) + gain).clamp(0, 1000),
    });
  }

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
    this.hunger = 0,
    this.mood = 1000,
    this.nightRecovery = 250,
    this.workedSecondsToday = 0,
    this.acceptedOffers = 0,
    this.refusedOffers = 0,
    this.lastRefusalReason,
  });

  /// Mệt mỏi tích lũy, thang 0–1000.
  final int fatigue;

  /// Cơn đói tích lũy, thang 0–1000; ăn được bữa thì hạ xuống.
  final int hunger;

  /// Tâm trạng, thang 0–1000; 1000 là chưa có chuyện gì đáng bực.
  final int mood;

  /// Số điểm mệt hồi lại sau một đêm.
  final int nightRecovery;

  /// Số giây đã lao động kể từ đầu ngày, dùng để tính tiêu hao của cơ thể.
  final int workedSecondsToday;

  final int acceptedOffers;
  final int refusedOffers;
  final String? lastRefusalReason;

  /// Ngưỡng ưu tiên tối thiểu để đồng ý nhận việc.
  ///
  /// Mệt nặng nhất, đói bằng nửa mệt, tâm trạng xấu nhẹ hơn nữa. Người khỏe,
  /// no và không bực thì ngưỡng bằng 0 và nhận mọi việc.
  int get acceptanceFloor =>
      fatigue ~/ 10 + hunger ~/ 20 + (1000 - mood) ~/ 25;

  /// Lý do lớn nhất khiến người này khó nhận việc lúc này.
  String get mainStrain {
    final int byFatigue = fatigue ~/ 10;
    final int byHunger = hunger ~/ 20;
    final int byMood = (1000 - mood) ~/ 25;
    if (byFatigue >= byHunger && byFatigue >= byMood) return 'mệt';
    if (byHunger >= byMood) return 'đói';
    return 'bực';
  }

  bool accepts(int priority) => priority >= acceptanceFloor;

  /// Làm việc thì mệt thêm; trọn tám giờ cộng 400 điểm.
  PersonAgenda tire(int workedSeconds) {
    if (workedSeconds <= 0) return this;
    final int added = (workedSeconds * 400) ~/ 28800;
    return _copy(fatigue: (fatigue + added).clamp(0, 1000));
  }

  /// Ghi giờ lao động vào sổ ngày; chỉ cần khi người này có cơ thể để nuôi.
  PersonAgenda logWork(int workedSeconds) => workedSeconds <= 0
      ? this
      : _copy(workedSecondsToday: workedSecondsToday + workedSeconds);

  /// Một đêm ngủ: bớt mệt, nguôi bớt bực và mở sổ lao động ngày mới.
  PersonAgenda rest() => _copy(
    fatigue: (fatigue - nightRecovery).clamp(0, 1000),
    mood: (mood + 50).clamp(0, 1000),
    workedSecondsToday: 0,
  );

  /// Cơn đói do cơ thể quyết định thay vì đếm bữa.
  PersonAgenda withHunger(int value) => _copy(hunger: value.clamp(0, 1000));

  /// Thời gian trôi giữa hai bữa và phần được ăn nếu bữa nấu xong.
  PersonAgenda atMeal({required bool fed}) => _copy(
    hunger: (hunger + 220 - (fed ? 400 : 0)).clamp(0, 1000),
    mood: fed ? mood : (mood - 60).clamp(0, 1000),
  );

  /// Việc trôi chảy thì dễ chịu, bị cắt ngang thì bực theo phần giờ đã mất.
  PersonAgenda afterWork({required int workedSeconds, required int lostSeconds}) {
    final int total = workedSeconds + lostSeconds;
    if (total <= 0) return this;
    if (lostSeconds == 0) return _copy(mood: (mood + 20).clamp(0, 1000));
    return _copy(
      mood: (mood - (40 * lostSeconds) ~/ total).clamp(0, 1000),
    );
  }

  PersonAgenda recordOffer({required bool accepted, String? reason}) => _copy(
    acceptedOffers: accepted ? acceptedOffers + 1 : acceptedOffers,
    refusedOffers: accepted ? refusedOffers : refusedOffers + 1,
    lastRefusalReason: accepted ? lastRefusalReason : reason,
  );

  PersonAgenda _copy({
    int? fatigue,
    int? hunger,
    int? mood,
    int? workedSecondsToday,
    int? acceptedOffers,
    int? refusedOffers,
    String? lastRefusalReason,
  }) => PersonAgenda(
    fatigue: fatigue ?? this.fatigue,
    hunger: hunger ?? this.hunger,
    mood: mood ?? this.mood,
    nightRecovery: nightRecovery,
    workedSecondsToday: workedSecondsToday ?? this.workedSecondsToday,
    acceptedOffers: acceptedOffers ?? this.acceptedOffers,
    refusedOffers: refusedOffers ?? this.refusedOffers,
    lastRefusalReason: lastRefusalReason ?? this.lastRefusalReason,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    if (fatigue > 0) 'fatigue': fatigue,
    if (hunger > 0) 'hunger': hunger,
    if (mood != 1000) 'mood': mood,
    if (nightRecovery != 250) 'night_recovery': nightRecovery,
    if (workedSecondsToday > 0) 'worked_seconds_today': workedSecondsToday,
    if (acceptedOffers > 0) 'accepted_offers': acceptedOffers,
    if (refusedOffers > 0) 'refused_offers': refusedOffers,
    if (lastRefusalReason != null) 'last_refusal_reason': lastRefusalReason,
  };

  factory PersonAgenda.fromJson(Map<String, Object?> json) => PersonAgenda(
    fatigue: json['fatigue'] as int? ?? 0,
    hunger: json['hunger'] as int? ?? 0,
    mood: json['mood'] as int? ?? 1000,
    nightRecovery: json['night_recovery'] as int? ?? 250,
    workedSecondsToday: json['worked_seconds_today'] as int? ?? 0,
    acceptedOffers: json['accepted_offers'] as int? ?? 0,
    refusedOffers: json['refused_offers'] as int? ?? 0,
    lastRefusalReason: json['last_refusal_reason'] as String?,
  );
}
