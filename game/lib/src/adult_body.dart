/// Cơ thể người lớn ở độ phân giải ngày.
///
/// Trẻ sơ sinh chạy từng giờ vì mọi thứ đổi nhanh; người lớn chạy theo ngày
/// vì trong một ngày ăn ba bữa và làm một buổi thì các số chỉ đổi chậm.
/// Mọi phép tính đều là số nguyên để lượt chạy tái hiện được.
class AdultBodyState {
  const AdultBodyState({
    required this.massGrams,
    required this.healthyMassGrams,
    required this.energyReserveKj,
    required this.bodyWaterMl,
    this.totalIntakeKj = 0,
    this.totalBurnedKj = 0,
    this.totalDrunkMl = 0,
    this.massLostGrams = 0,
  });

  /// Người trưởng thành khỏe mạnh trong fixture: 52 kg, dự trữ vài ngày.
  factory AdultBodyState.healthy({int massGrams = 52000}) => AdultBodyState(
    massGrams: massGrams,
    healthyMassGrams: massGrams,
    energyReserveKj: reserveCapacityKj,
    bodyWaterMl: massGrams * 60 ~/ 100,
  );

  /// Trần dự trữ năng lượng; đầy là còn khoảng mười ngày không ăn.
  static const int reserveCapacityKj = 60000;

  /// Tiêu hao nền mỗi ngày kể cả nằm không.
  static const int basalKjPerDay = 5500;

  /// Tiêu hao thêm cho mỗi giờ lao động.
  static const int workKjPerHour = 200;

  /// Mất nước nền mỗi ngày và thêm theo giờ lao động.
  static const int basalWaterMlPerDay = 2000;
  static const int workWaterMlPerHour = 300;

  /// Thiếu ngần này kilojoule thì mất một gam khối lượng.
  static const int kjPerGramLost = 30;

  /// Thừa ngần này kilojoule mới lên được một gam.
  static const int kjPerGramGained = 45;

  /// Nước chiếm ngần này phần nghìn khối lượng khi đủ nước.
  static const int waterPerMilleOfMass = 600;

  /// Uống nhiều nhất ngần này mỗi ngày, dù thiếu bao nhiêu đi nữa.
  static const int maxDailyDrinkMl = 3500;

  final int massGrams;
  final int healthyMassGrams;
  final int energyReserveKj;
  final int bodyWaterMl;
  final int totalIntakeKj;
  final int totalBurnedKj;
  final int totalDrunkMl;
  final int massLostGrams;

  /// Lượng nước khi đủ nước, suy từ khối lượng hiện tại.
  int get healthyWaterMl => massGrams * waterPerMilleOfMass ~/ 1000;

  /// Mức đủ nước, thang 0–1000.
  int get hydration {
    final int target = healthyWaterMl;
    if (target <= 0) return 1000;
    return (bodyWaterMl * 1000 ~/ target).clamp(0, 1000);
  }

  /// Cơn khát suy từ mức đủ nước.
  int get thirst => 1000 - hydration;

  /// Sức làm việc theo cân nặng: đủ cân 1000, còn 85% thì một nửa, 70% thì kiệt.
  int get massCapability {
    if (healthyMassGrams <= 0) return 1000;
    final int ratio = massGrams * 1000 ~/ healthyMassGrams;
    return ((ratio - 700) * 1000 ~/ 300).clamp(0, 1000);
  }

  /// Sức làm việc theo nước: mất nước hạ sức nhanh hơn nhiều so với sụt cân.
  ///
  /// Đủ nước 1000; còn 90% thì một nửa; xuống 80% là kiệt.
  int get waterCapability => ((hydration - 800) * 1000 ~/ 200).clamp(0, 1000);

  /// Sức làm việc thật: thứ nào thiếu hơn thì thứ đó quyết định.
  int get capability =>
      massCapability < waterCapability ? massCapability : waterCapability;

  /// Thiếu nước tới mức đã ăn vào sức làm việc.
  ///
  /// Mốc 900 là chỗ sức làm việc theo nước đã tụt còn một nửa, nên tính luôn
  /// cả mức biên chứ không chờ thấp hơn nữa.
  bool get dehydrated => hydration <= 900;

  /// Số mililít cần uống để đủ nước trở lại, đã chặn theo mức uống mỗi ngày.
  int get drinkNeedMl =>
      (healthyWaterMl - bodyWaterMl).clamp(0, maxDailyDrinkMl);

  /// Uống vào ngần này nước.
  AdultBodyState drink(int ml) => ml <= 0
      ? this
      : _copy(
          bodyWaterMl: (bodyWaterMl + ml).clamp(0, massGrams),
          totalDrunkMl: totalDrunkMl + ml,
        );

  /// Cơn đói suy từ dự trữ còn lại, để dùng chung thang với các trục khác.
  int get hunger =>
      (1000 - energyReserveKj * 1000 ~/ reserveCapacityKj).clamp(0, 1000);

  bool get underweight => massGrams < healthyMassGrams;

  /// Ăn một phần bữa: năng lượng vào dự trữ, nước vào cơ thể.
  AdultBodyState eat({required int energyKj, required int waterMl}) => _copy(
    energyReserveKj: (energyReserveKj + energyKj).clamp(0, reserveCapacityKj),
    bodyWaterMl: (bodyWaterMl + waterMl).clamp(0, massGrams),
    totalIntakeKj: totalIntakeKj + energyKj,
  );

  /// Một ngày trôi qua với ngần này giây lao động.
  ///
  /// Đốt hết dự trữ rồi mới ăn vào khối lượng; còn dư thì tích lại, đầy trần
  /// mới lên cân.
  AdultBodyDayResult advanceDay({
    required int workedSeconds,
    int illnessSeverity = 0,
  }) {
    final int workHours = workedSeconds ~/ 3600;
    // Bệnh nặng 1000 đốt thêm một nghìn kilojoule và mất thêm một lít nước.
    final int illnessKj = illnessSeverity;
    final int illnessWaterMl = illnessSeverity;
    final int burned =
        basalKjPerDay + workKjPerHour * workHours + illnessKj;
    final int waterLost =
        basalWaterMlPerDay + workWaterMlPerHour * workHours + illnessWaterMl;
    final int fromReserve = burned.clamp(0, energyReserveKj);
    final int deficit = burned - fromReserve;
    int nextMass = massGrams;
    int lostGrams = 0;
    if (deficit > 0) {
      lostGrams = deficit ~/ kjPerGramLost;
      nextMass = (massGrams - lostGrams).clamp(0, massGrams);
    }
    final int nextReserve = energyReserveKj - fromReserve;
    final AdultBodyState next = _copy(
      massGrams: nextMass,
      energyReserveKj: nextReserve,
      bodyWaterMl: (bodyWaterMl - waterLost).clamp(0, massGrams),
      totalBurnedKj: totalBurnedKj + burned,
      massLostGrams: massLostGrams + lostGrams,
    );
    return AdultBodyDayResult(
      body: next,
      burnedKj: burned,
      lostGrams: lostGrams,
      workHours: workHours,
    );
  }

  /// Dư dả thì hồi lại cân đã sụt, mỗi ngày một ít.
  AdultBodyState recover() {
    if (massGrams >= healthyMassGrams) return this;
    final int spare = energyReserveKj - reserveCapacityKj * 3 ~/ 4;
    if (spare <= 0) return this;
    final int gain = (spare ~/ kjPerGramGained).clamp(
      0,
      healthyMassGrams - massGrams,
    );
    if (gain <= 0) return this;
    return _copy(
      massGrams: massGrams + gain,
      energyReserveKj: energyReserveKj - gain * kjPerGramGained,
    );
  }

  AdultBodyState _copy({
    int? massGrams,
    int? energyReserveKj,
    int? bodyWaterMl,
    int? totalIntakeKj,
    int? totalBurnedKj,
    int? totalDrunkMl,
    int? massLostGrams,
  }) => AdultBodyState(
    massGrams: massGrams ?? this.massGrams,
    healthyMassGrams: healthyMassGrams,
    energyReserveKj: energyReserveKj ?? this.energyReserveKj,
    bodyWaterMl: bodyWaterMl ?? this.bodyWaterMl,
    totalIntakeKj: totalIntakeKj ?? this.totalIntakeKj,
    totalBurnedKj: totalBurnedKj ?? this.totalBurnedKj,
    totalDrunkMl: totalDrunkMl ?? this.totalDrunkMl,
    massLostGrams: massLostGrams ?? this.massLostGrams,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'mass_g': massGrams,
    'healthy_mass_g': healthyMassGrams,
    'energy_reserve_kj': energyReserveKj,
    'body_water_ml': bodyWaterMl,
    if (totalIntakeKj > 0) 'total_intake_kj': totalIntakeKj,
    if (totalBurnedKj > 0) 'total_burned_kj': totalBurnedKj,
    if (totalDrunkMl > 0) 'total_drunk_ml': totalDrunkMl,
    if (massLostGrams > 0) 'mass_lost_g': massLostGrams,
  };

  factory AdultBodyState.fromJson(Map<String, Object?> json) => AdultBodyState(
    massGrams: json['mass_g']! as int,
    healthyMassGrams: json['healthy_mass_g']! as int,
    energyReserveKj: json['energy_reserve_kj']! as int,
    bodyWaterMl: json['body_water_ml']! as int,
    totalIntakeKj: json['total_intake_kj'] as int? ?? 0,
    totalBurnedKj: json['total_burned_kj'] as int? ?? 0,
    totalDrunkMl: json['total_drunk_ml'] as int? ?? 0,
    massLostGrams: json['mass_lost_g'] as int? ?? 0,
  );
}

class AdultBodyDayResult {
  const AdultBodyDayResult({
    required this.body,
    required this.burnedKj,
    required this.lostGrams,
    required this.workHours,
  });

  final AdultBodyState body;
  final int burnedKj;
  final int lostGrams;
  final int workHours;
}
