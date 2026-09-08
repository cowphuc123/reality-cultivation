import 'geometry.dart';

/// Tuyến đường thật giữa các điểm mốc, có địa hình và quãng đường.
///
/// Trước V2.9 một chuyến hàng chỉ là một nhãn chặng và một giờ đến cố định.
/// Nay đường đi gồm nhiều chặng nối các điểm mốc có vị trí thật, và thời gian
/// đi ra từ quãng đường chia cho tốc độ thật của người chở.
class RouteWaypoint {
  const RouteWaypoint({
    required this.id,
    required this.name,
    required this.positionMm,
    this.positionYMm = 0,
  });

  final String id;
  final String name;
  final int positionMm;

  /// Trục thứ hai; 0 nghĩa là điểm mốc vẫn nằm trên trục cũ.
  final int positionYMm;

  WorldPoint get point => WorldPoint(positionMm, positionYMm);

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'position_mm': positionMm,
    if (positionYMm != 0) 'position_y_mm': positionYMm,
  };

  factory RouteWaypoint.fromJson(Map<String, Object?> json) => RouteWaypoint(
    id: json['id']! as String,
    name: json['name']! as String,
    positionMm: json['position_mm']! as int,
    positionYMm: json['position_y_mm'] as int? ?? 0,
  );
}

/// Một chặng nối hai điểm mốc.
class RouteLeg {
  const RouteLeg({
    required this.fromId,
    required this.toId,
    required this.terrain,
    required this.terrainSpeedPerMille,
    this.minCapabilityPerMille = 0,
  });

  final String fromId;
  final String toId;

  /// Mã địa hình, ví dụ `duong_bang`, `duong_nui`, `loi_suoi`.
  final String terrain;

  /// Tốc độ đi được trên địa hình này, phần nghìn so với đường bằng.
  final int terrainSpeedPerMille;

  /// Sức lực tối thiểu để qua được chặng này; 0 nghĩa là ai cũng đi được.
  ///
  /// Khúc lội suối hay đèo dốc có thể chặn người đã kiệt sức, buộc họ đi
  /// đường vòng thay vì cứ thế bò qua.
  final int minCapabilityPerMille;

  bool passableBy(int capabilityPerMille) =>
      capabilityPerMille >= minCapabilityPerMille;

  Map<String, Object?> toJson() => <String, Object?>{
    'from_id': fromId,
    'to_id': toId,
    'terrain': terrain,
    'terrain_speed_per_mille': terrainSpeedPerMille,
    if (minCapabilityPerMille > 0)
      'min_capability_per_mille': minCapabilityPerMille,
  };

  factory RouteLeg.fromJson(Map<String, Object?> json) => RouteLeg(
    fromId: json['from_id']! as String,
    toId: json['to_id']! as String,
    terrain: json['terrain']! as String,
    terrainSpeedPerMille: json['terrain_speed_per_mille']! as int,
    minCapabilityPerMille: json['min_capability_per_mille'] as int? ?? 0,
  );
}

class TradeRoute {
  const TradeRoute({
    required this.id,
    required this.name,
    required this.waypoints,
    required this.legs,
    this.originId,
    this.destinationId,
  });

  final String id;
  final String name;
  final List<RouteWaypoint> waypoints;
  final List<RouteLeg> legs;

  /// Điểm khởi hành; để trống thì lấy điểm mốc đầu danh sách.
  final String? originId;

  /// Điểm đến; để trống thì lấy điểm mốc cuối danh sách.
  final String? destinationId;

  String get origin => originId ?? waypoints.first.id;
  String get destination => destinationId ?? waypoints.last.id;

  RouteWaypoint? waypoint(String id) =>
      waypoints.where((RouteWaypoint value) => value.id == id).firstOrNull;

  /// Các chặng rời khỏi một điểm mốc; nhiều hơn một là có ngã rẽ.
  List<RouteLeg> legsFrom(String waypointId) =>
      legs.where((RouteLeg leg) => leg.fromId == waypointId).toList();

  /// Chặng nối đúng hai điểm mốc này, nếu có.
  RouteLeg? legBetween(String fromId, String toId) => legs
      .where((RouteLeg leg) => leg.fromId == fromId && leg.toId == toId)
      .firstOrNull;

  bool get hasFork =>
      waypoints.any((RouteWaypoint value) => legsFrom(value.id).length > 1);

  /// Đường đi nhanh nhất theo giờ, chứ không phải ngắn nhất theo mét.
  ///
  /// Trả về dãy điểm mốc từ [from] tới [to]. Chặng nào người này không đủ sức
  /// qua thì bị loại khỏi lựa chọn, nên người yếu có thể phải đi đường vòng.
  /// Trả về danh sách rỗng nếu không có đường nào đi được.
  List<String> fastestPath({
    required String from,
    required String to,
    required Map<String, int> cargo,
    required int capabilityPerMille,
    int baseSpeed = CarrierPace.baseSpeedMmPerSecond,
  }) {
    final Map<String, int> best = <String, int>{from: 0};
    final Map<String, String> cameFrom = <String, String>{};
    final Set<String> settled = <String>{};
    while (true) {
      String? current;
      int currentCost = -1;
      // Chọn điểm chưa chốt có tổng giờ nhỏ nhất; id nhỏ hơn thắng khi bằng
      // nhau để lượt chạy tái hiện được.
      for (final String id in best.keys.toList()..sort()) {
        if (settled.contains(id)) continue;
        final int cost = best[id]!;
        if (current == null || cost < currentCost) {
          current = id;
          currentCost = cost;
        }
      }
      if (current == null) break;
      if (current == to) break;
      settled.add(current);
      for (final RouteLeg leg in legsFrom(current)) {
        if (!leg.passableBy(capabilityPerMille)) continue;
        final int seconds = CarrierPace.travelSeconds(
          distanceMm: legDistanceMm(leg),
          speedMmPerSecond: CarrierPace.speedMmPerSecond(
            terrainSpeedPerMille: leg.terrainSpeedPerMille,
            cargo: cargo,
            capabilityPerMille: capabilityPerMille,
            baseSpeed: baseSpeed,
          ),
        );
        final int candidate = currentCost + seconds;
        final int? known = best[leg.toId];
        if (known == null || candidate < known) {
          best[leg.toId] = candidate;
          cameFrom[leg.toId] = current;
        }
      }
    }
    if (!best.containsKey(to)) return const <String>[];
    final List<String> path = <String>[to];
    String cursor = to;
    while (cursor != from) {
      final String? previous = cameFrom[cursor];
      if (previous == null) return const <String>[];
      path.insert(0, previous);
      cursor = previous;
    }
    return path;
  }

  /// Tổng giờ đi của một dãy điểm mốc đã chọn.
  int pathSeconds({
    required List<String> path,
    required Map<String, int> cargo,
    required int capabilityPerMille,
    int baseSpeed = CarrierPace.baseSpeedMmPerSecond,
  }) {
    int total = 0;
    for (int index = 0; index + 1 < path.length; index++) {
      final RouteLeg? leg = legBetween(path[index], path[index + 1]);
      if (leg == null) continue;
      total += CarrierPace.travelSeconds(
        distanceMm: legDistanceMm(leg),
        speedMmPerSecond: CarrierPace.speedMmPerSecond(
          terrainSpeedPerMille: leg.terrainSpeedPerMille,
          cargo: cargo,
          capabilityPerMille: capabilityPerMille,
          baseSpeed: baseSpeed,
        ),
      );
    }
    return total;
  }

  /// Tổng quãng đường của một dãy điểm mốc.
  int pathDistanceMm(List<String> path) {
    int total = 0;
    for (int index = 0; index + 1 < path.length; index++) {
      final RouteLeg? leg = legBetween(path[index], path[index + 1]);
      if (leg != null) total += legDistanceMm(leg);
    }
    return total;
  }

  /// Quãng đường của một chặng, suy từ vị trí hai đầu.
  int legDistanceMm(RouteLeg leg) {
    final RouteWaypoint? from = waypoint(leg.fromId);
    final RouteWaypoint? to = waypoint(leg.toId);
    if (from == null || to == null) return 0;
    return from.point.distanceTo(to.point);
  }

  int get totalDistanceMm =>
      legs.fold(0, (int total, RouteLeg leg) => total + legDistanceMm(leg));

  /// Chặng chậm nhất, dùng để giải thích vì sao chuyến hàng trễ.
  RouteLeg? get slowestLeg {
    RouteLeg? worst;
    for (final RouteLeg leg in legs) {
      if (worst == null ||
          leg.terrainSpeedPerMille < worst.terrainSpeedPerMille) {
        worst = leg;
      }
    }
    return worst;
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    if (originId != null) 'origin_id': originId,
    if (destinationId != null) 'destination_id': destinationId,
    'waypoints': <Map<String, Object?>>[
      for (final RouteWaypoint value in waypoints) value.toJson(),
    ],
    'legs': <Map<String, Object?>>[
      for (final RouteLeg value in legs) value.toJson(),
    ],
  };

  factory TradeRoute.fromJson(Map<String, Object?> json) => TradeRoute(
    id: json['id']! as String,
    name: json['name']! as String,
    originId: json['origin_id'] as String?,
    destinationId: json['destination_id'] as String?,
    waypoints: <RouteWaypoint>[
      for (final Object? value in json['waypoints']! as List<Object?>)
        RouteWaypoint.fromJson((value! as Map).cast<String, Object?>()),
    ],
    legs: <RouteLeg>[
      for (final Object? value in json['legs']! as List<Object?>)
        RouteLeg.fromJson((value! as Map).cast<String, Object?>()),
    ],
  );
}

/// Cách tính tốc độ đi thật của một người chở hàng.
class CarrierPace {
  const CarrierPace._();

  /// Tốc độ đi trên đường bằng khi tay không, tính bằng mm mỗi giây.
  static const int baseSpeedMmPerSecond = 1200;

  /// Người chở mang được ngần này gam trước khi coi là đầy tải.
  static const int loadCapacityGrams = 40000;

  /// Đầy tải thì chậm đi tối đa ngần này phần nghìn.
  static const int maxLoadPenaltyPerMille = 400;

  /// Tổng khối lượng hàng, quy nước và dịch về gam theo tỉ lệ một trên một.
  static int cargoMassGrams(Map<String, int> cargo) =>
      cargo.values.fold(0, (int total, int value) => total + value);

  /// Phần nghìn tốc độ còn lại sau khi tính tải.
  static int loadFactorPerMille(Map<String, int> cargo) {
    final int mass = cargoMassGrams(cargo);
    if (mass <= 0) return 1000;
    final int penalty =
        (mass * maxLoadPenaltyPerMille ~/ loadCapacityGrams).clamp(
          0,
          maxLoadPenaltyPerMille,
        );
    return 1000 - penalty;
  }

  /// Tốc độ thật trên một chặng: địa hình, tải và sức lực người chở.
  ///
  /// [capabilityPerMille] lấy từ cơ thể người chở nếu có; người chưa có cơ thể
  /// thì coi như đủ sức.
  static int speedMmPerSecond({
    required int terrainSpeedPerMille,
    required Map<String, int> cargo,
    required int capabilityPerMille,
    int baseSpeed = baseSpeedMmPerSecond,
  }) {
    final int afterTerrain = baseSpeed * terrainSpeedPerMille ~/ 1000;
    final int afterLoad = afterTerrain * loadFactorPerMille(cargo) ~/ 1000;
    final int afterBody = afterLoad * capabilityPerMille ~/ 1000;
    return afterBody < 1 ? 1 : afterBody;
  }

  /// Số giây đi hết một quãng với tốc độ đã cho, làm tròn lên.
  static int travelSeconds({
    required int distanceMm,
    required int speedMmPerSecond,
  }) {
    if (distanceMm <= 0) return 0;
    final int speed = speedMmPerSecond < 1 ? 1 : speedMmPerSecond;
    return (distanceMm + speed - 1) ~/ speed;
  }
}
