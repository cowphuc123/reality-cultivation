import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.14: vùng và địa điểm có ranh giới thật trên mặt phẳng hai chiều.
void main() {
  final Simulation world = _world();
  final WorldRegion region = world.state.regions['REG-ANKHE']!;
  _expect(region.contains(const WorldPoint(0, 0)), 'Góc vùng phải thuộc vùng.');
  _expect(
    region.contains(const WorldPoint(13000000, 3500000)),
    'Biên xa của vùng phải thuộc vùng.',
  );
  _expect(
    !region.contains(const WorldPoint(13000001, 0)),
    'Ra ngoài biên một milimét phải không còn thuộc vùng.',
  );

  final WorldSite home = world.state.sites['SITE-HOME']!;
  _expect(
    home.contains(const WorldPoint(112000, 0)),
    'Điểm đúng trên bán kính phải còn thuộc địa điểm.',
  );
  _expect(
    !home.contains(const WorldPoint(112001, 0)),
    'Điểm vượt bán kính một milimét phải nằm ngoài địa điểm.',
  );

  final WorldMapView map = SimulationHost(world).worldMap();
  _expect(map.regions.length == 1, 'Bản đồ phải có đúng một vùng thử.');
  _expect(map.siteCount == 5, 'Vùng An Khê phải có năm địa điểm thật.');
  final SiteMapView homeView = _site(map, 'SITE-HOME');
  _expect(
    homeView.peopleNames.contains('Người ở hộ') &&
        homeView.roomNames.contains('Gian chính') &&
        homeView.itemKinds.contains('rice_store'),
    'Người, phòng và vật tại cùng tọa độ phải được quy về Hộ ven suối.',
  );
  final SiteMapView fieldView = _site(map, 'SITE-FIELD');
  _expect(
    fieldView.peopleNames.single == 'Người ngoài đồng' &&
        fieldView.itemKinds.single == 'field_tools',
    'Trục y của người và vật phải thật sự quyết định địa điểm.',
  );
  _expect(
    map.unplacedPeople == 1,
    'Người ở giữa vùng nhưng ngoài mọi địa điểm phải được đếm riêng.',
  );
  _expect(
    world.state.facts
            .where((WorldFact fact) => fact.kind == 'site_created')
            .length ==
        5,
    'Mỗi địa điểm hình thành phải có một mốc lịch sử.',
  );

  final String save = world.state.save();
  final Simulation restored = Simulation.fromSave(save);
  _expect(
    restored.state.semanticHash() == world.state.semanticHash(),
    'Lưu và nạp phải giữ nguyên bản đồ.',
  );
  _expect(
    restored.state.items['I-FIELD']!.positionYMm == 3000000,
    'Trục y của vật phẩm phải đi qua bản lưu.',
  );

  final Simulation invalid = Simulation.fromSeed(14)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'region_created',
      payload: const <String, Object?>{
        'region_id': 'REG-SMALL',
        'name': 'Vùng nhỏ',
        'width_mm': 1000,
        'height_mm': 1000,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'site_created',
      payload: const <String, Object?>{
        'site_id': 'SITE-OUT',
        'region_id': 'REG-SMALL',
        'name': 'Điểm ngoài biên',
        'kind': 'invalid',
        'center_x_mm': 1001,
        'radius_mm': 10,
      },
    );
  bool rejected = false;
  try {
    invalid.advanceTo(const SimTime(0));
  } on StateError {
    rejected = true;
  }
  _expect(rejected, 'Không được tạo địa điểm có tâm nằm ngoài vùng.');

  print('V2.14 region map verification passed.');
  print('Map hash: ${world.state.semanticHash()}');
  print(
    '${region.name}: ${map.siteCount} địa điểm, '
    '${map.unplacedPeople} người chưa thuộc địa điểm.',
  );
}

SiteMapView _site(WorldMapView map, String id) => map.regions
    .expand((RegionMapView region) => region.sites)
    .singleWhere((SiteMapView view) => view.site.id == id);

Simulation _world() {
  final Simulation world = Simulation.fromSeed(20260910);
  world.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'region_created',
    payload: const <String, Object?>{
      'region_id': 'REG-ANKHE',
      'name': 'Thung lũng An Khê',
      'width_mm': 13000000,
      'height_mm': 3500000,
    },
  );
  for (final Map<String, Object?> site in _sites) {
    world.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'site_created',
      payload: site,
    );
  }
  for (final Map<String, Object?> person in <Map<String, Object?>>[
    <String, Object?>{
      'person_id': 'N-HOME',
      'name': 'Người ở hộ',
      'position_mm': 12000,
    },
    <String, Object?>{
      'person_id': 'N-MARKET',
      'name': 'Người ở chợ',
      'position_mm': 12012000,
    },
    <String, Object?>{
      'person_id': 'N-FIELD',
      'name': 'Người ngoài đồng',
      'position_mm': 4012000,
      'position_y_mm': 3000000,
    },
    <String, Object?>{
      'person_id': 'N-ROAD',
      'name': 'Người giữa đường',
      'position_mm': 6000000,
      'position_y_mm': 1500000,
    },
  ]) {
    world.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        ...person,
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
      },
    );
  }
  world.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'room_created',
    payload: const <String, Object?>{
      'room_id': 'ROOM-HOME',
      'name': 'Gian chính',
      'household_id': 'H-MAP',
      'anchor_position_mm': 12000,
    },
  );
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-HOME',
      'kind': 'rice_store',
      'position_mm': 12000,
    },
    <String, Object?>{
      'item_id': 'I-FIELD',
      'kind': 'field_tools',
      'position_mm': 4012000,
      'position_y_mm': 3000000,
    },
  ]) {
    world.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{...item, 'quantity': 1, 'condition': 1000},
    );
  }
  world.advanceTo(const SimTime(0));
  return world;
}

const List<Map<String, Object?>> _sites = <Map<String, Object?>>[
  <String, Object?>{
    'site_id': 'SITE-HOME',
    'region_id': 'REG-ANKHE',
    'name': 'Hộ ven suối',
    'kind': 'household',
    'center_x_mm': 12000,
    'radius_mm': 100000,
  },
  <String, Object?>{
    'site_id': 'SITE-RIVER',
    'region_id': 'REG-ANKHE',
    'name': 'Khúc lội suối',
    'kind': 'river',
    'center_x_mm': 4012000,
    'radius_mm': 300000,
  },
  <String, Object?>{
    'site_id': 'SITE-FIELD',
    'region_id': 'REG-ANKHE',
    'name': 'Đồng ngoài',
    'kind': 'field',
    'center_x_mm': 4012000,
    'center_y_mm': 3000000,
    'radius_mm': 500000,
  },
  <String, Object?>{
    'site_id': 'SITE-PASS',
    'region_id': 'REG-ANKHE',
    'name': 'Chân đèo',
    'kind': 'pass',
    'center_x_mm': 8012000,
    'radius_mm': 400000,
  },
  <String, Object?>{
    'site_id': 'SITE-MARKET',
    'region_id': 'REG-ANKHE',
    'name': 'Chợ An Khê',
    'kind': 'market',
    'center_x_mm': 12012000,
    'radius_mm': 600000,
  },
];

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
