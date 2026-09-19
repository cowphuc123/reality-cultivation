import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260919;
const SimTime _midBatch = SimTime(3600);
const SimTime _batchCompletion = SimTime(7200);

const ProductionRecipe _carryFrameRecipe = ProductionRecipe(
  id: 'RECIPE-CARRY-FRAME-01',
  name: 'đóng khung gùi gỗ',
  durationSeconds: 7200,
  inputs: <ProductionIngredient>[
    ProductionIngredient(kind: 'raw_timber', quantity: 1200, unit: 'g'),
    ProductionIngredient(kind: 'plant_fiber', quantity: 250, unit: 'g'),
  ],
  outputKind: 'carrying_frame',
  outputQuantity: 1,
  outputUnit: 'piece',
  toolKind: 'hand_axe',
  toolWear: 25,
);

/// Bằng chứng mã cho cổng sản xuất V6; chỉ chạy ở lượt kiểm chứng.
void main() {
  final Simulation continuous = _startedFixture()..advanceTo(_midBatch);
  final Simulation savePath = _startedFixture()..advanceTo(_midBatch);
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load giữa mẻ phải giữ nguyên workpiece và lịch hoàn tất.',
  );
  final Simulation replay = _startedFixture()..advanceTo(_midBatch);

  continuous.advanceTo(_batchCompletion);
  restored.advanceTo(_batchCompletion);
  replay.advanceTo(_batchCompletion);

  _assertCompleted(continuous);
  _assertCompleted(restored);
  _assertCompleted(replay);
  final String expectedHash = continuous.state.semanticHash();
  _expect(
    restored.state.semanticHash() == expectedHash &&
        replay.state.semanticHash() == expectedHash,
    'Chạy liền, save/load giữa mẻ và replay phải cùng snapshot cuối.',
  );

  print('V6 production workpiece verification passed.');
  print('Semantic hash: $expectedHash');
}

Simulation _startedFixture() {
  final Simulation simulation = _fixture()..advanceTo(const SimTime(0));
  final bool started = simulation.startProductionBatch(
    batchId: 'PB-CARRY-FRAME-01',
    recipe: _carryFrameRecipe,
    actorId: 'N01',
    householdId: 'H01',
    roomId: 'ROOM-WORKSHOP',
    inputItemIdsByKind: const <String, String>{
      'raw_timber': 'I-TIMBER-01',
      'plant_fiber': 'I-FIBER-01',
    },
    outputItemId: 'I-CARRY-FRAME-01',
    toolItemId: 'I-AXE-01',
  );
  _expect(started, 'Mẻ đầu phải bắt đầu khi đủ người, vật, quyền và chỗ.');
  _assertInProgress(simulation);

  final int timberAfterFirst = simulation.state.items['I-TIMBER-01']!.quantity;
  final int fiberAfterFirst = simulation.state.items['I-FIBER-01']!.quantity;
  final bool sharedToolStarted = simulation.startProductionBatch(
    batchId: 'PB-COMPETING-TOOL',
    recipe: _carryFrameRecipe,
    actorId: 'N02',
    householdId: 'H01',
    roomId: 'ROOM-WORKSHOP',
    inputItemIdsByKind: const <String, String>{
      'raw_timber': 'I-TIMBER-01',
      'plant_fiber': 'I-FIBER-01',
    },
    outputItemId: 'I-CARRY-FRAME-02',
    toolItemId: 'I-AXE-01',
  );
  _expect(!sharedToolStarted, 'Một công cụ không được phục vụ hai mẻ cùng lúc.');
  _expect(
    simulation.state.items['I-TIMBER-01']!.quantity == timberAfterFirst &&
        simulation.state.items['I-FIBER-01']!.quantity == fiberAfterFirst &&
        simulation.state.people['N02']!.timeCommitment == null,
    'Mẻ bị từ chối vì tranh công cụ không được rút vật hay giữ lao động.',
  );

  bool rejectedInsufficientInput = false;
  try {
    simulation.startProductionBatch(
      batchId: 'PB-COMPETING-MATERIAL',
      recipe: const ProductionRecipe(
        id: 'RECIPE-LARGE-FRAME',
        name: 'đóng khung gùi lớn',
        durationSeconds: 7200,
        inputs: <ProductionIngredient>[
          ProductionIngredient(
            kind: 'raw_timber',
            quantity: 2000,
            unit: 'g',
          ),
          ProductionIngredient(kind: 'plant_fiber', quantity: 250, unit: 'g'),
        ],
        outputKind: 'large_carrying_frame',
        outputQuantity: 1,
        outputUnit: 'piece',
        toolKind: 'hand_axe',
        toolWear: 35,
      ),
      actorId: 'N02',
      householdId: 'H01',
      roomId: 'ROOM-WORKSHOP',
      inputItemIdsByKind: const <String, String>{
        'raw_timber': 'I-TIMBER-01',
        'plant_fiber': 'I-FIBER-01',
      },
      outputItemId: 'I-LARGE-CARRY-FRAME-01',
      toolItemId: 'I-AXE-02',
    );
  } on StateError {
    rejectedInsufficientInput = true;
  }
  _expect(
    rejectedInsufficientInput &&
        simulation.state.items['I-TIMBER-01']!.quantity == timberAfterFirst &&
        simulation.state.people['N02']!.timeCommitment == null,
    'Nguyên liệu đã vào workpiece không được mẻ sau tiêu lại.',
  );
  return simulation;
}

void _assertInProgress(Simulation simulation) {
  final ProductionBatchState batch =
      simulation.state.productionBatches['PB-CARRY-FRAME-01']!;
  _expect(
    batch.status == ProductionBatchStatus.inProgress &&
        batch.materials.length == 2 &&
        batch.materials.any(
          (ProductionMaterialLot value) =>
              value.kind == 'raw_timber' && value.quantity == 1200,
        ) &&
        batch.materials.any(
          (ProductionMaterialLot value) =>
              value.kind == 'plant_fiber' && value.quantity == 250,
        ) &&
        simulation.state.items['I-TIMBER-01']!.quantity == 1800 &&
        simulation.state.items['I-FIBER-01']!.quantity == 550 &&
        simulation.state.items['I-CARRY-FRAME-01'] == null &&
        simulation.state.people['N01']!.timeCommitment?.relatedId == batch.id,
    'Mẻ đang làm phải giữ nguyên liệu/lao động và chưa tạo đầu ra.',
  );
}

void _assertCompleted(Simulation simulation) {
  final ProductionBatchState batch =
      simulation.state.productionBatches['PB-CARRY-FRAME-01']!;
  final CareItemState output = simulation.state.items['I-CARRY-FRAME-01']!;
  _expect(
    batch.status == ProductionBatchStatus.completed &&
        batch.finishedAtSeconds == _batchCompletion.seconds &&
        output.kind == 'carrying_frame' &&
        output.quantity == 1 &&
        output.unit == 'piece' &&
        output.condition == 737 &&
        output.ownerHouseholdId == 'H01' &&
        output.roomId == 'ROOM-WORKSHOP' &&
        simulation.state.items['I-AXE-01']!.condition == 825 &&
        simulation.state.people['N01']!.timeCommitment == null &&
        simulation.state.households['H01']!.productionRuns == 1 &&
        simulation.state.households['H01']!.canUse(
          'N01',
          'I-CARRY-FRAME-01',
        ),
    'Mẻ hoàn tất phải tạo đúng đầu ra/chất lượng, hao công cụ và trả lao động.',
  );
}

Simulation _fixture() {
  final Simulation simulation = Simulation.fromSeed(_seed)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: const <String, Object?>{
        'room_id': 'ROOM-WORKSHOP',
        'name': 'Xưởng hộ',
        'household_id': 'H01',
        'anchor_position_mm': 1000,
      },
    );
  for (final (String, String) person in <(String, String)>[
    ('N01', 'Thợ chính'),
    ('N02', 'Thợ phụ'),
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': person.$1,
        'name': person.$2,
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': 1000,
        'room_id': 'ROOM-WORKSHOP',
        'household_id': 'H01',
      },
    );
  }
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-TIMBER-01',
      'kind': 'raw_timber',
      'quantity': 3000,
      'condition': 720,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-FIBER-01',
      'kind': 'plant_fiber',
      'quantity': 800,
      'condition': 680,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-AXE-01',
      'kind': 'hand_axe',
      'quantity': 1,
      'condition': 850,
      'unit': 'piece',
    },
    <String, Object?>{
      'item_id': 'I-AXE-02',
      'kind': 'hand_axe',
      'quantity': 1,
      'condition': 800,
      'unit': 'piece',
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
        'position_mm': 1000,
        'room_id': 'ROOM-WORKSHOP',
        'owner_household_id': 'H01',
      },
    );
  }
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'household_created',
    payload: const <String, Object?>{
      'household_id': 'H01',
      'name': 'Hộ thợ mộc',
      'member_ids': <String>['N01', 'N02'],
      'meal_actor_id': 'N01',
      'resource_item_ids': <String, String>{},
      'authorized_users_by_item_id': <String, List<String>>{
        'I-TIMBER-01': <String>['N01', 'N02'],
        'I-FIBER-01': <String>['N01', 'N02'],
        'I-AXE-01': <String>['N01', 'N02'],
        'I-AXE-02': <String>['N01', 'N02'],
      },
      'scheduled_work_seconds_by_person': <String, int>{
        'N01': 0,
        'N02': 0,
      },
    },
  );
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
