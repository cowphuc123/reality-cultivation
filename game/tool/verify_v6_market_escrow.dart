import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260922;

/// Bằng chứng mã cho cổng chợ V6; chỉ chạy ở lượt kiểm chứng.
void main() {
  final Simulation continuous = _reservedFixture();
  final Simulation savePath = _reservedFixture();
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  final Simulation replay = _reservedFixture();

  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load phải giữ nguyên offer, lượng còn lại và hai escrow của order.',
  );
  for (final Simulation simulation in <Simulation>[
    continuous,
    restored,
    replay,
  ]) {
    _assertReserved(simulation);
    _settleAfterBadTarget(simulation);
  }

  final String expectedHash = continuous.state.semanticHash();
  _expect(
    restored.state.semanticHash() == expectedHash &&
        replay.state.semanticHash() == expectedHash,
    'Chạy liền, save/load và replay phải cùng snapshot sau settlement.',
  );

  print('V6 market escrow verification passed.');
  print('Semantic hash: $expectedHash');
}

Simulation _reservedFixture() {
  final Simulation simulation = _fixture()..advanceTo(const SimTime(0));
  _expect(
    simulation.publishMarketOffer(
      offerId: 'MO-GRAIN-01',
      sellerPersonId: 'SELLER',
      sellerHouseholdId: 'H01',
      roomId: 'ROOM-MARKET',
      sourceItemId: 'I-GRAIN',
      offeredQuantity: 300,
      lotQuantity: 100,
      paymentKind: 'dried_herb',
      paymentQuantityPerLot: 50,
      paymentUnit: 'g',
      visibleToPersonIds: const <String>['BUYER'],
    ),
    'Người bán phải đăng được ba lot ngũ cốc có thật.',
  );
  _expect(
    simulation.state.items['I-GRAIN']!.quantity == 200 &&
        simulation.state.marketOffers['MO-GRAIN-01']!.merchandise.quantity ==
            300,
    'Đăng bán phải chuyển đúng 300 g từ kho sang escrow offer.',
  );

  final bool unseenOrder = simulation.placeMarketOrder(
    orderId: 'ORDER-UNSEEN',
    offerId: 'MO-GRAIN-01',
    buyerPersonId: 'UNSEEN',
    buyerHouseholdId: 'H02',
    paymentSourceItemId: 'I-HERB',
    merchandiseQuantity: 100,
  );
  _expect(
    !unseenOrder && simulation.state.items['I-HERB']!.quantity == 300,
    'Người chưa biết offer không được giữ hàng hoặc mất vật thanh toán.',
  );

  _expect(
    simulation.placeMarketOrder(
      orderId: 'ORDER-01',
      offerId: 'MO-GRAIN-01',
      buyerPersonId: 'BUYER',
      buyerHouseholdId: 'H02',
      paymentSourceItemId: 'I-HERB',
      merchandiseQuantity: 200,
    ),
    'Người biết offer phải đặt được hai lot khi có đủ vật thanh toán.',
  );
  final bool duplicateReservation = simulation.placeMarketOrder(
    orderId: 'ORDER-OVERSELL',
    offerId: 'MO-GRAIN-01',
    buyerPersonId: 'BUYER',
    buyerHouseholdId: 'H02',
    paymentSourceItemId: 'I-HERB',
    merchandiseQuantity: 200,
  );
  _expect(
    !duplicateReservation &&
        simulation.state.items['I-HERB']!.quantity == 200 &&
        simulation.state.marketOffers['MO-GRAIN-01']!.merchandise.quantity ==
            100,
    'Đơn vượt lượng còn lại không được giữ trùng hàng hay trừ thêm thanh toán.',
  );
  _expectStateError(
    () => simulation.publishMarketOffer(
      offerId: 'MO-GRAIN-DUPLICATE',
      sellerPersonId: 'SELLER',
      sellerHouseholdId: 'H01',
      roomId: 'ROOM-MARKET',
      sourceItemId: 'I-GRAIN',
      offeredQuantity: 300,
      lotQuantity: 100,
      paymentKind: 'dried_herb',
      paymentQuantityPerLot: 50,
      paymentUnit: 'g',
      visibleToPersonIds: const <String>['BUYER'],
    ),
    'Phần hàng đã nằm trong offer không được đăng bán lần nữa.',
  );
  return simulation;
}

void _assertReserved(Simulation simulation) {
  final MarketOfferState offer = simulation.state.marketOffers['MO-GRAIN-01']!;
  final MarketOrderState order = simulation.state.marketOrders['ORDER-01']!;
  _expect(
    offer.status == MarketOfferStatus.open &&
        offer.merchandise.quantity == 100 &&
        order.status == MarketOrderStatus.reserved &&
        order.merchandise.quantity == 200 &&
        order.payment.quantity == 100 &&
        simulation.state.items['I-GRAIN']!.quantity == 200 &&
        simulation.state.items['I-HERB']!.quantity == 200,
    'Trước settlement phải có 100 g trong offer và hai phía trong order.',
  );
}

void _settleAfterBadTarget(Simulation simulation) {
  final String beforeBadTarget = simulation.state.semanticHash();
  final bool badTarget = simulation.settleMarketOrder(
    orderId: 'ORDER-01',
    buyerTargetItemId: 'I-WRONG-TARGET',
    sellerTargetItemId: 'I-SELLER-HERB',
  );
  _expect(
    !badTarget && simulation.state.semanticHash() == beforeBadTarget,
    'Target không tương thích phải giữ nguyên toàn bộ order đã reserve.',
  );
  _expect(
    simulation.settleMarketOrder(
      orderId: 'ORDER-01',
      buyerTargetItemId: 'I-BUYER-GRAIN',
      sellerTargetItemId: 'I-SELLER-HERB',
    ),
    'Hai target hợp lệ phải settlement được order.',
  );
  final MarketOrderState order = simulation.state.marketOrders['ORDER-01']!;
  _expect(
    order.status == MarketOrderStatus.settled &&
        simulation.state.items['I-BUYER-GRAIN']!.quantity == 200 &&
        simulation.state.items['I-BUYER-GRAIN']!.ownerHouseholdId == 'H02' &&
        simulation.state.items['I-SELLER-HERB']!.quantity == 100 &&
        simulation.state.items['I-SELLER-HERB']!.ownerHouseholdId == 'H01' &&
        simulation.state.households['H02']!.canUse(
          'BUYER',
          'I-BUYER-GRAIN',
        ) &&
        simulation.state.households['H01']!.canUse(
          'SELLER',
          'I-SELLER-HERB',
        ),
    'Settlement phải đổi đúng chủ và quyền dùng của hai vật.',
  );
  final int conservedGrain = simulation.state.items['I-GRAIN']!.quantity +
      simulation.state.marketOffers['MO-GRAIN-01']!.merchandise.quantity +
      simulation.state.items['I-BUYER-GRAIN']!.quantity;
  final int conservedHerb = simulation.state.items['I-HERB']!.quantity +
      simulation.state.items['I-SELLER-HERB']!.quantity;
  _expect(
    conservedGrain == 500 && conservedHerb == 300,
    'Tổng ngũ cốc và dược thảo hoạt động phải được bảo toàn sau đổi chủ.',
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
        'name': 'Sạp đổi hàng',
        'household_id': 'H01',
        'anchor_position_mm': 1000,
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
      'name': 'Người mua đã biết',
      'household_id': 'H02',
    },
    <String, Object?>{
      'person_id': 'UNSEEN',
      'name': 'Người chưa biết',
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
      'item_id': 'I-GRAIN',
      'kind': 'raw_grain',
      'quantity': 500,
      'condition': 800,
      'owner_household_id': 'H01',
    },
    <String, Object?>{
      'item_id': 'I-HERB',
      'kind': 'dried_herb',
      'quantity': 300,
      'condition': 700,
      'owner_household_id': 'H02',
    },
    <String, Object?>{
      'item_id': 'I-WRONG-TARGET',
      'kind': 'stone',
      'quantity': 1,
      'condition': 900,
      'owner_household_id': 'H02',
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
        'unit': item['kind'] == 'stone' ? 'piece' : 'g',
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
          'I-GRAIN': <String>['SELLER'],
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
        'name': 'Hộ đổi dược thảo',
        'member_ids': <String>['BUYER', 'UNSEEN'],
        'meal_actor_id': 'BUYER',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-HERB': <String>['BUYER', 'UNSEEN'],
        },
        'scheduled_work_seconds_by_person': <String, int>{
          'BUYER': 0,
          'UNSEEN': 0,
        },
      },
    );
  return simulation;
}

void _expectStateError(void Function() action, String message) {
  try {
    action();
  } on StateError {
    return;
  }
  throw StateError(message);
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
