import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260923;

/// Bằng chứng mã cho cổng vận tải hàng giao dịch V6; chỉ chạy ở lượt kiểm chứng.
void main() {
  final Simulation continuous = _dispatchedFixture();
  final int arrival = continuous
      .state
      .marketShipments['SHIPMENT-01']!
      .scheduledArrivalSeconds;
  final SimTime midpoint = SimTime(arrival ~/ 2);
  continuous.advanceTo(midpoint);

  final Simulation savePath = _dispatchedFixture()..advanceTo(midpoint);
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  final Simulation replay = _dispatchedFixture()..advanceTo(midpoint);
  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load giữa đường phải giữ chuyến, cargo, người chở và sự kiện đến.',
  );

  for (final Simulation simulation in <Simulation>[
    continuous,
    restored,
    replay,
  ]) {
    _assertInTransitAndUnavailable(simulation);
    simulation.advanceTo(SimTime(arrival));
    _assertDelivered(simulation);
  }
  final String expectedHash = continuous.state.semanticHash();
  _expect(
    restored.state.semanticHash() == expectedHash &&
        replay.state.semanticHash() == expectedHash,
    'Chạy liền, save/load giữa đường và replay phải cùng snapshot sau giao.',
  );

  final Simulation failed = _dispatchedFixture();
  final int failedArrival = failed
      .state
      .marketShipments['SHIPMENT-01']!
      .scheduledArrivalSeconds;
  failed.schedule(
    due: SimTime(failedArrival - 1),
    phase: EventPhase.completion,
    kind: 'item_created',
    payload: const <String, Object?>{
      'item_id': 'I-DESTINATION-GRAIN',
      'kind': 'stone',
      'quantity': 1,
      'condition': 900,
      'unit': 'piece',
      'position_mm': 10001000,
      'room_id': 'ROOM-STORE',
      'owner_household_id': 'H02',
    },
  );
  failed.advanceTo(SimTime(failedArrival));
  _assertFailedWithoutInventingStock(failed);

  print('V6 market transport verification passed.');
  print('Semantic hash: $expectedHash');
}

Simulation _dispatchedFixture() {
  final Simulation simulation = _fixture()..advanceTo(const SimTime(0));
  _expect(
    simulation.publishMarketOffer(
      offerId: 'OFFER-01',
      sellerPersonId: 'SELLER',
      sellerHouseholdId: 'H01',
      roomId: 'ROOM-MARKET',
      sourceItemId: 'I-SELLER-GRAIN',
      offeredQuantity: 100,
      lotQuantity: 100,
      paymentKind: 'dried_herb',
      paymentQuantityPerLot: 50,
      paymentUnit: 'g',
      visibleToPersonIds: const <String>['BUYER'],
    ),
    'Người bán phải đưa được lô ngũ cốc thật vào escrow.',
  );
  _expect(
    simulation.placeMarketOrder(
      orderId: 'ORDER-01',
      offerId: 'OFFER-01',
      buyerPersonId: 'BUYER',
      buyerHouseholdId: 'H02',
      paymentSourceItemId: 'I-BUYER-HERB',
      merchandiseQuantity: 100,
    ),
    'Người mua phải reserve được hàng và vật thanh toán.',
  );
  _expect(
    simulation.settleMarketOrder(
      orderId: 'ORDER-01',
      buyerTargetItemId: 'I-PURCHASED-GRAIN',
      sellerTargetItemId: 'I-SELLER-HERB',
    ),
    'Order phải đổi chủ trước khi vận chuyển.',
  );
  _expect(
    simulation.dispatchMarketShipment(
      shipmentId: 'SHIPMENT-01',
      orderId: 'ORDER-01',
      carrierId: 'BUYER',
      routeId: 'ROUTE-MARKET-STORE',
      fromWaypointId: 'WP-MARKET',
      toWaypointId: 'WP-STORE',
      originRoomId: 'ROOM-MARKET',
      destinationRoomId: 'ROOM-STORE',
      sourceItemId: 'I-PURCHASED-GRAIN',
      destinationItemId: 'I-DESTINATION-GRAIN',
    ),
    'Lô hàng đã mua phải khởi hành khi đủ người, tuyến và hai kho.',
  );
  return simulation;
}

void _assertInTransitAndUnavailable(Simulation simulation) {
  final MarketShipmentState shipment =
      simulation.state.marketShipments['SHIPMENT-01']!;
  _expect(
    shipment.status == MarketShipmentStatus.inTransit &&
        shipment.lateSeconds > 0 &&
        shipment.plannedConditionLoss > 0 &&
        simulation.state.items['I-PURCHASED-GRAIN']!.quantity == 0 &&
        simulation.state.items['I-DESTINATION-GRAIN'] == null &&
        simulation.state.people['BUYER']!.roomId == null &&
        simulation.state.people['BUYER']!.timeCommitment?.relatedId ==
            shipment.id,
    'Giữa đường, hàng chỉ được nằm trong cargo và người chở phải bị giữ lịch.',
  );

  final String beforeRejectedProduction = simulation.state.semanticHash();
  bool rejected = false;
  try {
    simulation.startProductionBatch(
      batchId: 'PB-HIDDEN-CARGO',
      recipe: const ProductionRecipe(
        id: 'RECIPE-GRAIN-CAKE',
        name: 'ép bánh ngũ cốc',
        durationSeconds: 600,
        inputs: <ProductionIngredient>[
          ProductionIngredient(kind: 'raw_grain', quantity: 50, unit: 'g'),
        ],
        outputKind: 'grain_cake',
        outputQuantity: 1,
        outputUnit: 'piece',
      ),
      actorId: 'WORKER',
      householdId: 'H02',
      roomId: 'ROOM-MARKET',
      inputItemIdsByKind: const <String, String>{
        'raw_grain': 'I-PURCHASED-GRAIN',
      },
      outputItemId: 'I-GRAIN-CAKE',
    );
  } on StateError {
    rejected = true;
  }
  _expect(
    rejected && simulation.state.semanticHash() == beforeRejectedProduction,
    'Hàng đang đi không được một mẻ sản xuất dùng ngầm hoặc làm đổi snapshot.',
  );
}

void _assertDelivered(Simulation simulation) {
  final MarketShipmentState shipment =
      simulation.state.marketShipments['SHIPMENT-01']!;
  final CareItemState destination =
      simulation.state.items['I-DESTINATION-GRAIN']!;
  _expect(
    shipment.status == MarketShipmentStatus.delivered &&
        shipment.arrivedAtSeconds == shipment.scheduledArrivalSeconds &&
        destination.kind == 'raw_grain' &&
        destination.quantity == 100 &&
        destination.condition == 800 - shipment.plannedConditionLoss &&
        destination.ownerHouseholdId == 'H02' &&
        destination.roomId == 'ROOM-STORE' &&
        simulation.state.people['BUYER']!.roomId == 'ROOM-STORE' &&
        simulation.state.people['BUYER']!.timeCommitment == null &&
        simulation.state.households['H02']!.canUse(
          'BUYER',
          destination.id,
        ),
    'Tới nơi phải ghi đúng hao, kho, chủ, quyền và trả lịch người chở.',
  );
  _expect(
    simulation.state.items['I-PURCHASED-GRAIN']!.quantity +
            destination.quantity ==
        100,
    'Vận tải không được nhân đôi hoặc làm mất lượng ngũ cốc.',
  );
}

void _assertFailedWithoutInventingStock(Simulation simulation) {
  final MarketShipmentState shipment =
      simulation.state.marketShipments['SHIPMENT-01']!;
  final CareItemState conflicting =
      simulation.state.items['I-DESTINATION-GRAIN']!;
  _expect(
    shipment.status == MarketShipmentStatus.failed &&
        shipment.failureReason == 'destination_ledger_changed' &&
        shipment.cargo.quantity == 100 &&
        shipment.cargo.condition == 800 - shipment.plannedConditionLoss &&
        conflicting.kind == 'stone' &&
        conflicting.quantity == 1 &&
        simulation.state.items['I-PURCHASED-GRAIN']!.quantity == 0 &&
        simulation.state.people['BUYER']!.timeCommitment == null,
    'Ledger đích sai phải giữ cargo hỏng trong chuyến, không bù hàng ảo.',
  );
}

Simulation _fixture() {
  final Simulation simulation = Simulation.fromSeed(_seed);
  for (final Map<String, Object?> room in <Map<String, Object?>>[
    <String, Object?>{
      'room_id': 'ROOM-MARKET',
      'name': 'Sạp giao dịch',
      'household_id': 'H02',
      'anchor_position_mm': 1000,
    },
    <String, Object?>{
      'room_id': 'ROOM-STORE',
      'name': 'Kho người mua',
      'household_id': 'H02',
      'anchor_position_mm': 10001000,
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: room,
    );
  }
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'route_created',
    payload: const <String, Object?>{
      'route': <String, Object?>{
        'id': 'ROUTE-MARKET-STORE',
        'name': 'Đường từ sạp về kho',
        'origin_id': 'WP-MARKET',
        'destination_id': 'WP-STORE',
        'waypoints': <Map<String, Object?>>[
          <String, Object?>{
            'id': 'WP-MARKET',
            'name': 'Sạp giao dịch',
            'position_mm': 1000,
          },
          <String, Object?>{
            'id': 'WP-MUD',
            'name': 'Bãi lầy',
            'position_mm': 5001000,
          },
          <String, Object?>{
            'id': 'WP-STORE',
            'name': 'Kho người mua',
            'position_mm': 10001000,
          },
        ],
        'legs': <Map<String, Object?>>[
          <String, Object?>{
            'from_id': 'WP-MARKET',
            'to_id': 'WP-MUD',
            'terrain': 'duong_dat',
            'terrain_speed_per_mille': 700,
          },
          <String, Object?>{
            'from_id': 'WP-MUD',
            'to_id': 'WP-STORE',
            'terrain': 'bai_lay',
            'terrain_speed_per_mille': 400,
          },
        ],
      },
    },
  );
  for (final Map<String, Object?> person in <Map<String, Object?>>[
    <String, Object?>{
      'person_id': 'SELLER',
      'name': 'Người bán',
      'household_id': 'H01',
    },
    <String, Object?>{
      'person_id': 'BUYER',
      'name': 'Người mua kiêm vận chuyển',
      'household_id': 'H02',
    },
    <String, Object?>{
      'person_id': 'WORKER',
      'name': 'Người chế biến',
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
        'movement_speed_mm_per_second': 1000,
        'adult_body': <String, Object?>{'mass_g': 50000},
      },
    );
  }
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-SELLER-GRAIN',
      'kind': 'raw_grain',
      'quantity': 100,
      'condition': 800,
      'owner_household_id': 'H01',
    },
    <String, Object?>{
      'item_id': 'I-BUYER-HERB',
      'kind': 'dried_herb',
      'quantity': 50,
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
        'name': 'Hộ bán ngũ cốc',
        'member_ids': <String>['SELLER'],
        'meal_actor_id': 'SELLER',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-SELLER-GRAIN': <String>['SELLER'],
        },
        'scheduled_work_seconds_by_person': <String, int>{'SELLER': 0},
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H02',
        'name': 'Hộ mua ngũ cốc',
        'member_ids': <String>['BUYER', 'WORKER'],
        'meal_actor_id': 'WORKER',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-BUYER-HERB': <String>['BUYER'],
        },
        'scheduled_work_seconds_by_person': <String, int>{
          'BUYER': 0,
          'WORKER': 0,
        },
      },
    );
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
