import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.16: thế giới tồn tại trước, người chơi chọn nơi sinh rồi P00 mới ra đời.
void main() {
  final Simulation world = _preparedWorld(includeFeed: true);
  final SimulationHost host = SimulationHost(world);

  _expect(
    world.state.people['P00'] == null,
    'P00 chưa được tồn tại trước chọn.',
  );
  _expect(
    world.state.worldEntry?.awaitingBirthSite == true,
    'Thế giới phải dừng ở giai đoạn chờ chọn nơi sinh.',
  );
  final List<BirthSiteCandidate> candidates = world.birthSiteCandidates();
  _expect(candidates.length == 5, 'Cả năm địa điểm phải được trình bày.');
  final List<BirthSiteCandidate> feasible = candidates
      .where((BirthSiteCandidate candidate) => candidate.feasible)
      .toList();
  _expect(
    feasible.length == 1 && feasible.single.siteId == 'SITE-HOME',
    'Chỉ địa điểm có hộ, phòng, người chăm và sữa mới được mở.',
  );
  _expect(
    candidates
        .where((BirthSiteCandidate candidate) => !candidate.feasible)
        .every((BirthSiteCandidate candidate) => candidate.reason.isNotEmpty),
    'Mỗi nơi bị khóa phải có lý do đọc được.',
  );

  final CommandResult invalid = host.submit(
    const ChooseBirthSiteCommand(id: 'choose-invalid', siteId: 'SITE-RIVER'),
  );
  _expect(
    invalid.status == CommandStatus.rejected &&
        !world.state.acceptedCommandIds.contains('choose-invalid'),
    'Nơi không đủ điều kiện phải bị từ chối mà không nhận lệnh.',
  );

  final CommandResult accepted = host.submit(
    const ChooseBirthSiteCommand(id: 'choose-home', siteId: 'SITE-HOME'),
  );
  _expect(accepted.accepted, 'Nơi sinh hợp lệ phải nhận lệnh.');
  _expect(
    world.state.people['P00'] == null,
    'Nhận lệnh chưa được tự ý bỏ qua hàng đợi sự kiện.',
  );
  world.advanceTo(world.state.now);

  final PersonState player = world.state.people['P00']!;
  final WorldEntryState entry = world.state.worldEntry!;
  final RoomState room = world.state.rooms['ROOM-SLEEP']!;
  _expect(
    entry.born && entry.selectedSiteId == 'SITE-HOME',
    'Nơi sinh được lưu.',
  );
  _expect(
    player.householdId == 'H01' &&
        player.roomId == room.id &&
        player.infancy?.caregiverId == 'N01' &&
        player.positionMm == room.anchorPositionMm &&
        player.positionYMm == room.anchorPositionYMm,
    'P00 phải sinh đúng hộ, phòng, người chăm và tọa độ đã chọn.',
  );
  _expect(
    world.state.households['H01']!.memberIds.contains('P00'),
    'P00 chỉ được thêm vào hộ khi sự kiện sinh hoàn tất.',
  );
  final int selectionIndex = world.state.facts.indexWhere(
    (WorldFact fact) => fact.kind == 'birth_site_selected',
  );
  final int birthIndex = world.state.facts.indexWhere(
    (WorldFact fact) => fact.kind == 'birth' && fact.subjectId == 'P00',
  );
  _expect(
    selectionIndex >= 0 && birthIndex > selectionIndex,
    'Mốc chọn nơi phải xảy ra trước mốc sinh.',
  );

  final CommandResult duplicate = host.submit(
    const ChooseBirthSiteCommand(id: 'choose-home', siteId: 'SITE-HOME'),
  );
  _expect(
    duplicate.status == CommandStatus.duplicate,
    'Lệnh chọn nơi đã nhận phải giữ tính idempotent.',
  );
  final String hash = world.state.semanticHash();
  final Simulation restored = Simulation.fromSave(world.state.save());
  _expect(
    restored.state.semanticHash() == hash &&
        restored.state.worldEntry?.born == true &&
        restored.state.worldEntry?.selectedSiteId == 'SITE-HOME',
    'Lưu và nạp phải giữ nguyên nguồn gốc nhập thế.',
  );

  bool noSiteRejected = false;
  try {
    _preparedWorld(includeFeed: false);
  } on StateError {
    noSiteRejected = true;
  }
  _expect(
    noSiteRejected,
    'Không được mở nhập thế nếu chưa có bất kỳ nơi sinh khả thi nào.',
  );

  final Simulation premature = Simulation.fromSeed(20260907)..openWorldEntry();
  bool prematureRejected = false;
  try {
    premature.advanceTo(const SimTime(0));
  } on StateError {
    prematureRejected = true;
  }
  _expect(
    prematureRejected,
    'Không được mở nhập thế trước khi worldgen hoàn tất.',
  );

  print('V2.16 world entry verification passed.');
  print('World hash: $hash');
  print('Birth site: ${entry.selectedSiteId}, caregiver ${entry.caregiverId}.');
}

Simulation _preparedWorld({required bool includeFeed}) {
  const int seed = 20260907;
  final GeneratedWorld generated = WorldGenerator.generate(rootSeed: seed);
  final WorldSite home = generated.site('SITE-HOME');
  final Simulation simulation = Simulation.fromSeed(seed)
    ..materializeWorld(generated)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: <String, Object?>{
        'room_id': 'ROOM-SLEEP',
        'name': 'Gian ngủ',
        'household_id': 'H01',
        'anchor_position_mm': home.center.xMm,
        'anchor_position_y_mm': home.center.yMm,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': 'N01',
        'name': 'Người chăm sóc',
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'household_id': 'H01',
        'caregiver_agent': true,
        'care_skill': 800,
      },
    );
  if (includeFeed) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': 'I-FEED-01',
        'kind': 'infant_feed',
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': 1000,
        'energy_kj_per_100ml': 300,
        'water_ml_per_100ml': 92,
        'unit': 'ml',
        'owner_household_id': 'H01',
      },
    );
  }
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'household_created',
    payload: <String, Object?>{
      'household_id': 'H01',
      'name': 'Hộ ven suối',
      'member_ids': <String>['N01'],
      'resource_item_ids': <String, String>{
        if (includeFeed) 'infant_feed': 'I-FEED-01',
      },
      'authorized_users_by_item_id': <String, List<String>>{
        if (includeFeed) 'I-FEED-01': <String>['N01'],
      },
      'scheduled_work_seconds_by_person': <String, int>{},
      'meal_actor_id': 'N01',
    },
  );
  simulation.openWorldEntry();
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
