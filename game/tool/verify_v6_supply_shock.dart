import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260924;
const SimTime _checkpoint = SimTime(2 * gameSecondsPerDay);
const SimTime _shockEnd = SimTime(5 * gameSecondsPerDay);

/// Bằng chứng mã cho cổng cú sốc thiếu hàng V6; chỉ chạy ở lượt kiểm chứng.
void main() {
  final Simulation continuous = _adaptedFixture()..advanceTo(_checkpoint);
  final Simulation savePath = _adaptedFixture()..advanceTo(_checkpoint);
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  final Simulation replay = _adaptedFixture()..advanceTo(_checkpoint);
  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load giữa cú sốc phải giữ lô mất, phản ứng và audit đang chờ.',
  );

  for (final Simulation simulation in <Simulation>[
    continuous,
    restored,
    replay,
  ]) {
    _assertMidShock(simulation);
    simulation.advanceTo(_shockEnd);
    _assertResolved(simulation);
  }
  final String expectedHash = continuous.state.semanticHash();
  _expect(
    restored.state.semanticHash() == expectedHash &&
        replay.state.semanticHash() == expectedHash,
    'Chạy liền, save/load ngày 2 và replay phải cùng snapshot ngày 5.',
  );

  print('V6 supply shock verification passed.');
  print('Semantic hash: $expectedHash');
}

Simulation _adaptedFixture() {
  final Simulation simulation = _fixture()..advanceTo(const SimTime(0));
  _expect(
    simulation.beginSupplyShock(
      shockId: 'SHOCK-GRAIN-01',
      resourceKind: 'raw_grain',
      unit: 'g',
      cause: 'mưa kéo dài làm mốc hai kho ngũ cốc',
      durationSeconds: _shockEnd.seconds,
      affectedHouseholdIds: const <String>['H01', 'H02'],
      disruptedQuantityByItemId: const <String, int>{
        'I-GRAIN-H01': 450,
        'I-GRAIN-H02': 350,
      },
    ),
    'Cú sốc phải rút được lô thật của cả hai hộ.',
  );
  _expect(
    simulation.state.items['I-GRAIN-H01']!.quantity == 50 &&
        simulation.state.items['I-GRAIN-H02']!.quantity == 50,
    'Hai kho phải giảm đúng lượng bị mốc, không được chỉ gắn nhãn thiếu.',
  );

  final String beforeFakeResponse = simulation.state.semanticHash();
  _expect(
    !simulation.recordSupplyShockResponse(
      shockId: 'SHOCK-GRAIN-01',
      householdId: 'H01',
      kind: SupplyShockResponseKind.production,
      evidenceId: 'PB-NOT-REAL',
    ) &&
        simulation.state.semanticHash() == beforeFakeResponse,
    'Phản ứng không có batch thật phải bị từ chối mà không đổi snapshot.',
  );

  _expect(
    simulation.startProductionBatch(
      batchId: 'PB-ROOT-SUBSTITUTE',
      recipe: const ProductionRecipe(
        id: 'RECIPE-ROOT-SUBSTITUTE',
        name: 'hong củ thay ngũ cốc',
        durationSeconds: 3600,
        inputs: <ProductionIngredient>[
          ProductionIngredient(kind: 'raw_root', quantity: 600, unit: 'g'),
        ],
        outputKind: 'dried_root_food',
        outputQuantity: 400,
        outputUnit: 'g',
      ),
      actorId: 'PRODUCER',
      householdId: 'H01',
      roomId: 'ROOM-MARKET',
      inputItemIdsByKind: const <String, String>{
        'raw_root': 'I-ROOT-H01',
      },
      outputItemId: 'I-ROOT-FOOD-H01',
    ),
    'H01 phải khởi động được mẻ lương thực thay thế từ củ có thật.',
  );
  _expect(
    simulation.recordSupplyShockResponse(
      shockId: 'SHOCK-GRAIN-01',
      householdId: 'H01',
      kind: SupplyShockResponseKind.production,
      evidenceId: 'PB-ROOT-SUBSTITUTE',
    ),
    'Batch được tạo sau cú sốc phải làm bằng chứng đổi sản xuất của H01.',
  );

  simulation.advanceTo(const SimTime(3600));
  _expect(
    simulation.publishMarketOffer(
      offerId: 'OFFER-ROOT-FOOD',
      sellerPersonId: 'PRODUCER',
      sellerHouseholdId: 'H01',
      roomId: 'ROOM-MARKET',
      sourceItemId: 'I-ROOT-FOOD-H01',
      offeredQuantity: 400,
      lotQuantity: 200,
      paymentKind: 'dried_herb',
      paymentQuantityPerLot: 100,
      paymentUnit: 'g',
      visibleToPersonIds: const <String>['BUYER'],
    ),
    'H01 phải đưa được thực phẩm thay thế thật lên chợ.',
  );
  _expect(
    simulation.placeMarketOrder(
      orderId: 'ORDER-ROOT-FOOD',
      offerId: 'OFFER-ROOT-FOOD',
      buyerPersonId: 'BUYER',
      buyerHouseholdId: 'H02',
      paymentSourceItemId: 'I-HERB-H02',
      merchandiseQuantity: 200,
    ),
    'H02 phải đổi dược thảo thật lấy một lot thực phẩm thay thế.',
  );
  _expect(
    simulation.recordSupplyShockResponse(
      shockId: 'SHOCK-GRAIN-01',
      householdId: 'H02',
      kind: SupplyShockResponseKind.marketExchange,
      evidenceId: 'ORDER-ROOT-FOOD',
    ),
    'Order được tạo sau cú sốc phải làm bằng chứng đổi giao dịch của H02.',
  );
  _expect(
    simulation.settleMarketOrder(
      orderId: 'ORDER-ROOT-FOOD',
      buyerTargetItemId: 'I-ROOT-FOOD-H02',
      sellerTargetItemId: 'I-HERB-H01',
    ),
    'Giao dịch thích ứng phải settlement bằng hai escrow thật.',
  );
  return simulation;
}

void _assertMidShock(Simulation simulation) {
  final SupplyShockState shock = simulation.state.supplyShocks['SHOCK-GRAIN-01']!;
  _expect(
    shock.status == SupplyShockStatus.active &&
        shock.disruptedLots.length == 2 &&
        shock.responses.length == 2 &&
        shock.responses
                .map((SupplyShockResponse value) => value.householdId)
                .toSet()
                .length ==
            2 &&
        shock.householdDays.length == 4,
    'Ngày 2 phải còn thiếu hàng, có hai phản ứng thật và hai audit cho mỗi hộ.',
  );
  _assertLedgers(simulation);
}

void _assertResolved(Simulation simulation) {
  final SupplyShockState shock = simulation.state.supplyShocks['SHOCK-GRAIN-01']!;
  _expect(
    shock.status == SupplyShockStatus.resolved &&
        shock.resolvedAtSeconds == _shockEnd.seconds &&
        shock.householdDays.length == 10 &&
        shock.householdDays.map((SupplyShockHouseholdDay value) => value.day).toSet()
            .containsAll(<int>{1, 2, 3, 4, 5}),
    'Cú sốc phải kết thúc đúng ngày 5 với chuỗi audit hữu hạn đầy đủ.',
  );
  _assertLedgers(simulation);
  _expect(
    simulation.state.pendingEvents.every(
      (ScheduledEvent value) =>
          !(value.kind == 'supply_shock_audit' &&
              value.payload['shock_id'] == 'SHOCK-GRAIN-01'),
    ),
    'Sau khi resolved không được còn audit cú sốc mắc kẹt.',
  );
}

void _assertLedgers(Simulation simulation) {
  final SupplyShockState shock = simulation.state.supplyShocks['SHOCK-GRAIN-01']!;
  final int activeGrain = simulation.state.items.values
      .where(
        (CareItemState value) =>
            value.kind == 'raw_grain' && value.unit == 'g',
      )
      .fold<int>(0, (int total, CareItemState value) => total + value.quantity);
  final int disruptedGrain = shock.disruptedLots.fold<int>(
    0,
    (int total, SupplyDisruptionLot value) => total + value.quantity,
  );
  final int rootFood = simulation.state.items.values
          .where((CareItemState value) => value.kind == 'dried_root_food')
          .fold<int>(0, (int total, CareItemState value) => total + value.quantity) +
      simulation.state.marketOffers['OFFER-ROOT-FOOD']!.merchandise.quantity;
  final int herb = simulation.state.items.values
      .where((CareItemState value) => value.kind == 'dried_herb')
      .fold<int>(0, (int total, CareItemState value) => total + value.quantity);
  _expect(
    activeGrain == 100 &&
        disruptedGrain == 800 &&
        activeGrain + disruptedGrain == 900 &&
        rootFood == 400 &&
        herb == 200 &&
        simulation.state.items['I-ROOT-FOOD-H02']!.quantity == 200 &&
        simulation.state.items.values.every((CareItemState value) => value.quantity >= 0),
    'Ledger phải bảo toàn ngũ cốc, thực phẩm thay thế và dược thảo, không kho âm.',
  );
  _expect(
    simulation.state.facts
        .where(
          (WorldFact value) =>
              value.kind == 'item_created' && value.time.seconds > 0,
        )
        .isEmpty,
    'Kịch bản không được sinh item cứu hộ vô căn cứ sau lúc khởi tạo.',
  );
}

Simulation _fixture() {
  final Simulation simulation = Simulation.fromSeed(_seed)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: const <String, Object?>{
        'room_id': 'ROOM-MARKET',
        'name': 'Nhà chung ven chợ',
        'household_id': 'H01',
        'anchor_position_mm': 1000,
      },
    );
  for (final Map<String, Object?> person in <Map<String, Object?>>[
    <String, Object?>{
      'person_id': 'PRODUCER',
      'name': 'Người hong củ',
      'household_id': 'H01',
    },
    <String, Object?>{
      'person_id': 'BUYER',
      'name': 'Người đổi dược thảo',
      'household_id': 'H02',
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        ...person,
        'birth_seconds': -30 * 365 * gameSecondsPerDay,
        'position_mm': 1000,
        'room_id': 'ROOM-MARKET',
      },
    );
  }
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-GRAIN-H01',
      'kind': 'raw_grain',
      'quantity': 500,
      'condition': 780,
      'owner_household_id': 'H01',
    },
    <String, Object?>{
      'item_id': 'I-GRAIN-H02',
      'kind': 'raw_grain',
      'quantity': 400,
      'condition': 740,
      'owner_household_id': 'H02',
    },
    <String, Object?>{
      'item_id': 'I-ROOT-H01',
      'kind': 'raw_root',
      'quantity': 600,
      'condition': 700,
      'owner_household_id': 'H01',
    },
    <String, Object?>{
      'item_id': 'I-HERB-H02',
      'kind': 'dried_herb',
      'quantity': 200,
      'condition': 720,
      'owner_household_id': 'H02',
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
        'unit': 'g',
        'position_mm': 1000,
        'room_id': 'ROOM-MARKET',
      },
    );
  }
  simulation
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H01',
        'name': 'Hộ chế biến',
        'member_ids': <String>['PRODUCER'],
        'meal_actor_id': 'PRODUCER',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-GRAIN-H01': <String>['PRODUCER'],
          'I-ROOT-H01': <String>['PRODUCER'],
        },
        'scheduled_work_seconds_by_person': <String, int>{'PRODUCER': 0},
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H02',
        'name': 'Hộ dược thảo',
        'member_ids': <String>['BUYER'],
        'meal_actor_id': 'BUYER',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-GRAIN-H02': <String>['BUYER'],
          'I-HERB-H02': <String>['BUYER'],
        },
        'scheduled_work_seconds_by_person': <String, int>{'BUYER': 0},
      },
    );
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
