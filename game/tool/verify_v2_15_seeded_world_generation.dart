import 'dart:convert';

import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.15: seed sinh hình học vùng và địa điểm theo cách tái lập được.
void main() {
  final GeneratedWorld first = WorldGenerator.generate(rootSeed: 20260907);
  final GeneratedWorld repeated = WorldGenerator.generate(rootSeed: 20260907);
  final GeneratedWorld other = WorldGenerator.generate(rootSeed: 20260908);

  _expect(
    first.fingerprint == repeated.fingerprint &&
        jsonEncode(first.region.toJson()) ==
            jsonEncode(repeated.region.toJson()) &&
        jsonEncode(first.sites.map((WorldSite site) => site.toJson()).toList()) ==
            jsonEncode(
              repeated.sites.map((WorldSite site) => site.toJson()).toList(),
            ),
    'Cùng seed, config và phiên bản phải sinh đúng cùng một bản đồ.',
  );
  _expect(
    first.fingerprint == '247ad223a40016d6' &&
        first.region.widthMm == 13618519 &&
        first.region.heightMm == 4195124,
    'Fixture seed mặc định phải giữ đúng hợp đồng V2.15 đã công bố.',
  );
  _expect(
    first.fingerprint != other.fingerprint,
    'Seed khác phải tạo dấu vân tay bản đồ khác.',
  );
  _expect(
    first.region.widthMm >= WorldGenerationConfig.anKhe.minWidthMm &&
        first.region.widthMm <= WorldGenerationConfig.anKhe.maxWidthMm &&
        first.region.heightMm >= WorldGenerationConfig.anKhe.minHeightMm &&
        first.region.heightMm <= WorldGenerationConfig.anKhe.maxHeightMm,
    'Kích thước vùng phải nằm trong khoảng của cấu hình.',
  );
  _expect(
    first.sites.indexed.any(((int, WorldSite) entry) {
      final WorldSite alternate = other.sites[entry.$1];
      return entry.$2.center.xMm != alternate.center.xMm ||
          entry.$2.center.yMm != alternate.center.yMm;
    }),
    'Seed khác phải đổi tọa độ của ít nhất một địa điểm.',
  );
  _expect(
    first.sites.indexed.any(((int, WorldSite) entry) {
      return entry.$2.radiusMm != other.sites[entry.$1].radiusMm;
    }),
    'Seed khác phải đổi bán kính của ít nhất một địa điểm.',
  );
  _expect(
    first.generatorVersion == worldGeneratorVersion &&
        first.configId == WorldGenerationConfig.anKhe.id,
    'Kết quả phải mang đúng phiên bản bộ sinh và cấu hình.',
  );
  bool seedRangeRejected = false;
  try {
    WorldGenerator.generate(rootSeed: 0);
  } on RangeError {
    seedRangeRejected = true;
  }
  _expect(
    seedRangeRejected,
    'Seed ngoài miền 31-bit dương phải bị từ chối trên mọi nền tảng.',
  );
  _expect(first.sites.length == 5, 'Vùng thử phải sinh năm địa điểm.');
  _expect(
    first.sites.map((WorldSite site) => site.kind).toSet().containsAll(
      <String>{'household', 'river', 'field', 'pass', 'market'},
    ),
    'Năm vai trò địa điểm bắt buộc phải hiện diện.',
  );
  for (final WorldSite site in first.sites) {
    _expect(
      first.region.contains(site.center),
      '${site.id} phải có tâm nằm trong vùng.',
    );
    _expect(
      site.center.xMm - site.radiusMm >= first.region.minXMm &&
          site.center.xMm + site.radiusMm <= first.region.maxXMm &&
          site.center.yMm - site.radiusMm >= first.region.minYMm &&
          site.center.yMm + site.radiusMm <= first.region.maxYMm,
      'Toàn bộ bán kính của ${site.id} phải nằm trong vùng.',
    );
  }

  final Simulation world = Simulation.fromSeed(first.rootSeed)
    ..materializeWorld(first)
    ..advanceTo(const SimTime(0));
  _expect(
    world.state.worldGenesis?.fingerprint == first.fingerprint,
    'Provenance worldgen phải được công bố vào WorldState.',
  );
  _expect(
    world.state.regions.length == 1 && world.state.sites.length == 5,
    'Materialize phải tạo đủ vùng và địa điểm.',
  );
  _expect(
    world.state.facts.last.kind == 'world_genesis_completed',
    'Chỉ được ghi hoàn tất sau khi vùng và địa điểm đã tồn tại.',
  );
  final WorldMapView map = SimulationHost(world).worldMap();
  _expect(
    map.genesis?.rootSeed == first.rootSeed &&
        map.genesis?.generatorVersion == worldGeneratorVersion,
    'Cổng bản đồ phải đưa seed và phiên bản cho giao diện.',
  );

  final Simulation restored = Simulation.fromSave(world.state.save());
  _expect(
    restored.state.semanticHash() == world.state.semanticHash() &&
        restored.state.worldGenesis?.fingerprint == first.fingerprint,
    'Lưu/nạp phải giữ nguyên bản đồ và provenance.',
  );

  final Simulation wrongSeed = Simulation.fromSeed(1);
  bool seedRejected = false;
  try {
    wrongSeed.materializeWorld(first);
  } on StateError {
    seedRejected = true;
  }
  _expect(
    seedRejected && wrongSeed.state.pendingEvents.isEmpty,
    'Sai seed phải bị từ chối trước khi ghi một phần vào hàng đợi.',
  );

  bool duplicateRejected = false;
  try {
    world.materializeWorld(first);
  } on StateError {
    duplicateRejected = true;
  }
  _expect(duplicateRejected, 'Không được công bố worldgen lần hai.');

  final Simulation tampered = Simulation.fromSeed(first.rootSeed);
  _scheduleGeneratedMap(tampered, first);
  tampered.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'world_genesis_completed',
    payload: <String, Object?>{
      ...first.record.toJson(),
      'fingerprint': '0000000000000000',
    },
  );
  bool fingerprintRejected = false;
  try {
    tampered.advanceTo(const SimTime(0));
  } on StateError {
    fingerprintRejected = true;
  }
  _expect(
    fingerprintRejected,
    'Dấu vân tay không khớp bản đồ phải bị từ chối.',
  );

  print('V2.15 seeded world generation verification passed.');
  print('World hash: ${world.state.semanticHash()}');
  print(
    'Seed ${first.rootSeed}: ${first.region.widthMm} x '
    '${first.region.heightMm} mm, fingerprint ${first.fingerprint}.',
  );
}

void _scheduleGeneratedMap(Simulation simulation, GeneratedWorld generated) {
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'region_created',
    payload: generated.region.toJson(),
  );
  for (final WorldSite site in generated.sites) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'site_created',
      payload: site.toJson(),
    );
  }
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
