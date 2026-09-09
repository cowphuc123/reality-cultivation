import 'geometry.dart';

/// Một vùng chữ nhật của thế giới, dùng đơn vị milimét như mọi vị trí khác.
class WorldRegion {
  const WorldRegion({
    required this.id,
    required this.name,
    required this.minXMm,
    required this.minYMm,
    required this.widthMm,
    required this.heightMm,
  });

  final String id;
  final String name;
  final int minXMm;
  final int minYMm;
  final int widthMm;
  final int heightMm;

  int get maxXMm => minXMm + widthMm;
  int get maxYMm => minYMm + heightMm;

  bool contains(WorldPoint point) =>
      point.xMm >= minXMm &&
      point.xMm <= maxXMm &&
      point.yMm >= minYMm &&
      point.yMm <= maxYMm;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'min_x_mm': minXMm,
    'min_y_mm': minYMm,
    'width_mm': widthMm,
    'height_mm': heightMm,
  };

  factory WorldRegion.fromJson(Map<String, Object?> json) => WorldRegion(
    id: json['id']! as String,
    name: json['name']! as String,
    minXMm: json['min_x_mm']! as int,
    minYMm: json['min_y_mm']! as int,
    widthMm: json['width_mm']! as int,
    heightMm: json['height_mm']! as int,
  );
}

/// Một địa điểm có vùng ảnh hưởng thật trên bản đồ, không chỉ là nhãn.
class WorldSite {
  const WorldSite({
    required this.id,
    required this.regionId,
    required this.name,
    required this.kind,
    required this.center,
    required this.radiusMm,
  });

  final String id;
  final String regionId;
  final String name;

  /// Mã loại địa điểm, ví dụ `household`, `market`, `river`, `field`.
  final String kind;
  final WorldPoint center;
  final int radiusMm;

  bool contains(WorldPoint point) {
    final int dx = point.xMm - center.xMm;
    final int dy = point.yMm - center.yMm;
    return dx * dx + dy * dy <= radiusMm * radiusMm;
  }

  int distanceTo(WorldPoint point) => center.distanceTo(point);

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'region_id': regionId,
    'name': name,
    'kind': kind,
    'center_x_mm': center.xMm,
    'center_y_mm': center.yMm,
    'radius_mm': radiusMm,
  };

  factory WorldSite.fromJson(Map<String, Object?> json) => WorldSite(
    id: json['id']! as String,
    regionId: json['region_id']! as String,
    name: json['name']! as String,
    kind: json['kind']! as String,
    center: WorldPoint(
      json['center_x_mm']! as int,
      json['center_y_mm']! as int,
    ),
    radiusMm: json['radius_mm']! as int,
  );
}
