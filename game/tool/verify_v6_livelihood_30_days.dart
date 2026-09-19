import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260925;
const SimTime _checkpoint = SimTime(15 * gameSecondsPerDay);
const SimTime _end = SimTime(30 * gameSecondsPerDay);

/// Bằng chứng tổng hợp 30 ngày cho cổng 7 V6; chỉ chạy ở lượt kiểm chứng.
void main() {
  final Simulation continuous = _preparedFixture()..advanceTo(_checkpoint);
  final Simulation savePath = _preparedFixture()..advanceTo(_checkpoint);
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  final Simulation replay = _preparedFixture()..advanceTo(_checkpoint);
  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load ngày 15 phải giữ toàn bộ ledger và lịch còn lại.',
  );

  for (final Simulation simulation in <Simulation>[
    continuous,
    restored,
    replay,
  ]) {
    _assertIntegratedState(simulation, expectedDay: 15);
    simulation.advanceTo(_end);
    _assertIntegratedState(simulation, expectedDay: 30);
  }
  final String expectedHash = continuous.state.semanticHash();
  if (restored.state.semanticHash() != expectedHash) {
    _printStructuralDifference(
      continuous.state.toJson(),
      restored.state.toJson(),
      r'$world',
    );
  }
  _expect(
    restored.state.semanticHash() == expectedHash &&
        replay.state.semanticHash() == expectedHash,
    'Chạy liền, save/load ngày 15 và replay phải cùng snapshot ngày 30: '
    'continuous=$expectedHash restored=${restored.state.semanticHash()} '
    'replay=${replay.state.semanticHash()}.',
  );

  print('V6 livelihood 30-day verification passed.');
  print('Semantic hash: $expectedHash');
}

Simulation _preparedFixture() {
  final Simulation simulation = _fixture()..advanceTo(const SimTime(0));

  _expect(
    simulation.startProductionBatch(
      batchId: 'PB-FRAME',
      recipe: const ProductionRecipe(
        id: 'RECIPE-FRAME',
        name: 'đóng khung gùi',
        durationSeconds: 2 * 3600,
        inputs: <ProductionIngredient>[
          ProductionIngredient(kind: 'raw_timber', quantity: 1000, unit: 'g'),
          ProductionIngredient(kind: 'plant_fiber', quantity: 200, unit: 'g'),
        ],
        outputKind: 'carrying_frame',
        outputQuantity: 1,
        outputUnit: 'piece',
        toolKind: 'hand_axe',
        toolWear: 20,
      ),
      actorId: 'CRAFT',
      householdId: 'H01',
      roomId: 'ROOM-MARKET',
      inputItemIdsByKind: const <String, String>{
        'raw_timber': 'I-TIMBER',
        'plant_fiber': 'I-FIBER',
      },
      outputItemId: 'I-FRAME',
      toolItemId: 'I-AXE',
    ),
    'Mẻ khung gùi phải bắt đầu từ gỗ, sợi, rìu và lao động thật.',
  );
  _expect(
    simulation.bookServiceAppointment(
      appointmentId: 'SA-LESSON',
      definition: const ServiceDefinition(
        id: 'SERVICE-LESSON',
        name: 'hướng dẫn bảo quản ngũ cốc',
        durationSeconds: 3600,
        resultClaimKind: 'grain_storage_instruction',
        inputs: <ProductionIngredient>[
          ProductionIngredient(kind: 'raw_grain', quantity: 100, unit: 'g'),
        ],
      ),
      providerId: 'TEACHER',
      recipientId: 'STUDENT',
      providerHouseholdId: 'H01',
      recipientHouseholdId: 'H02',
      roomId: 'ROOM-MARKET',
      startsAtSeconds: 3 * 3600,
      inputItemIdsByKind: const <String, String>{
        'raw_grain': 'I-SERVICE-GRAIN',
      },
    ),
    'Dịch vụ phải giữ lịch hai hộ và 100 g vật tư.',
  );
  _expect(
    simulation.createLaborOffer(
          offerId: 'LO-HAUL',
          activity: 'phân loại và chuyển vật liệu',
          skillCode: 'haul',
          minimumSkill: 600,
          priority: 80,
          employerId: 'EMPLOYER',
          workerId: 'WORKER',
          employerHouseholdId: 'H01',
          workerHouseholdId: 'H02',
          roomId: 'ROOM-MARKET',
          startsAtSeconds: 5 * 3600,
          durationSeconds: 3600,
          compensation: const LaborCompensationTerms(
            itemKind: 'labor_rice',
            quantity: 300,
            unit: 'g',
          ),
        ) &&
        simulation.considerLaborOffer('LO-HAUL'),
    'Người đủ kỹ năng phải nhận ca có quyền lợi hiện vật.',
  );

  _expect(
    simulation.beginSupplyShock(
      shockId: 'SHOCK-30D',
      resourceKind: 'raw_grain',
      unit: 'g',
      cause: 'mưa ẩm kéo dài làm hỏng hai kho',
      durationSeconds: 5 * gameSecondsPerDay,
      affectedHouseholdIds: const <String>['H01', 'H02'],
      disruptedQuantityByItemId: const <String, int>{
        'I-SHOCK-GRAIN-H01': 400,
        'I-SHOCK-GRAIN-H02': 350,
      },
    ),
    'Cú sốc phải lấy lượng thật khỏi hai kho.',
  );
  _expect(
    simulation.startProductionBatch(
          batchId: 'PB-ROOT-FOOD',
          recipe: const ProductionRecipe(
            id: 'RECIPE-ROOT-FOOD',
            name: 'hong củ làm lương thực thay thế',
            durationSeconds: 3600,
            inputs: <ProductionIngredient>[
              ProductionIngredient(kind: 'raw_root', quantity: 600, unit: 'g'),
            ],
            outputKind: 'dried_root_food',
            outputQuantity: 400,
            outputUnit: 'g',
          ),
          actorId: 'ADAPTER',
          householdId: 'H01',
          roomId: 'ROOM-MARKET',
          inputItemIdsByKind: const <String, String>{'raw_root': 'I-ROOT'},
          outputItemId: 'I-ROOT-FOOD',
        ) &&
        simulation.recordSupplyShockResponse(
          shockId: 'SHOCK-30D',
          householdId: 'H01',
          kind: SupplyShockResponseKind.production,
          evidenceId: 'PB-ROOT-FOOD',
        ),
    'H01 phải đổi sang mẻ thực phẩm củ có bằng chứng.',
  );

  simulation.advanceTo(const SimTime(3600));
  _expect(
    simulation.publishMarketOffer(
          offerId: 'MO-ROOT-FOOD',
          sellerPersonId: 'ADAPTER',
          sellerHouseholdId: 'H01',
          roomId: 'ROOM-MARKET',
          sourceItemId: 'I-ROOT-FOOD',
          offeredQuantity: 400,
          lotQuantity: 200,
          paymentKind: 'dried_herb',
          paymentQuantityPerLot: 100,
          paymentUnit: 'g',
          visibleToPersonIds: const <String>['BUYER'],
        ) &&
        simulation.placeMarketOrder(
          orderId: 'ORDER-ROOT-FOOD',
          offerId: 'MO-ROOT-FOOD',
          buyerPersonId: 'BUYER',
          buyerHouseholdId: 'H02',
          paymentSourceItemId: 'I-HERB',
          merchandiseQuantity: 200,
        ),
    'H02 phải reserve được thực phẩm thay thế và dược thảo thật.',
  );
  _expect(
    simulation.recordSupplyShockResponse(
          shockId: 'SHOCK-30D',
          householdId: 'H02',
          kind: SupplyShockResponseKind.marketExchange,
          evidenceId: 'ORDER-ROOT-FOOD',
        ) &&
        simulation.settleMarketOrder(
          orderId: 'ORDER-ROOT-FOOD',
          buyerTargetItemId: 'I-ROOT-FOOD-BOUGHT',
          sellerTargetItemId: 'I-HERB-EARNED',
        ),
    'Giao dịch thích ứng phải được ghi và settlement trước vận tải.',
  );
  _expect(
    simulation.dispatchMarketShipment(
      shipmentId: 'SHIP-ROOT-FOOD',
      orderId: 'ORDER-ROOT-FOOD',
      carrierId: 'BUYER',
      routeId: 'ROUTE-MARKET-STORE',
      fromWaypointId: 'WP-MARKET',
      toWaypointId: 'WP-STORE',
      originRoomId: 'ROOM-MARKET',
      destinationRoomId: 'ROOM-STORE',
      sourceItemId: 'I-ROOT-FOOD-BOUGHT',
      destinationItemId: 'I-ROOT-FOOD-STORE',
    ),
    'Hàng mua phải rời kho và đi trên tuyến thật.',
  );

  simulation.advanceTo(const SimTime(6 * 3600));
  _expect(
    simulation.settleLaborCompensation(
      claimId: 'labor-claim-LO-HAUL',
      sourceItemId: 'I-WAGE',
      targetItemId: 'I-WORKER-WAGE',
    ),
    'Sau khi công hoàn tất, 300 g quyền lợi phải được chuyển sang H02.',
  );
  return simulation;
}

void _assertIntegratedState(Simulation simulation, {required int expectedDay}) {
  _expect(
    simulation.state.now.day == expectedDay,
    'Snapshot phải ở đúng ngày $expectedDay.',
  );
  final ProductionBatchState frame =
      simulation.state.productionBatches['PB-FRAME']!;
  final ProductionBatchState substitute =
      simulation.state.productionBatches['PB-ROOT-FOOD']!;
  final ServiceAppointmentState service =
      simulation.state.serviceAppointments['SA-LESSON']!;
  final LaborOfferState labor = simulation.state.laborOffers['LO-HAUL']!;
  final LaborCompensationClaim wage =
      simulation.state.laborClaims['labor-claim-LO-HAUL']!;
  final MarketOrderState order =
      simulation.state.marketOrders['ORDER-ROOT-FOOD']!;
  final MarketShipmentState shipment =
      simulation.state.marketShipments['SHIP-ROOT-FOOD']!;
  final SupplyShockState shock = simulation.state.supplyShocks['SHOCK-30D']!;
  _expect(
    frame.status == ProductionBatchStatus.completed &&
        substitute.status == ProductionBatchStatus.completed &&
        service.status == ServiceAppointmentStatus.completed &&
        service.resultClaim?.kind == 'grain_storage_instruction' &&
        labor.status == LaborOfferStatus.completed &&
        wage.status == LaborClaimStatus.settled &&
        order.status == MarketOrderStatus.settled &&
        shipment.status == MarketShipmentStatus.delivered &&
        shock.status == SupplyShockStatus.resolved &&
        shock.responses.length == 2 &&
        shock.householdDays.length == 10,
    'Ngày $expectedDay phải giữ kết quả hoàn tất của mọi sinh kế đại diện.',
  );

  final int timberLedger =
      simulation.state.items['I-TIMBER']!.quantity +
      frame.materials
          .where((ProductionMaterialLot value) => value.kind == 'raw_timber')
          .fold<int>(
            0,
            (int total, ProductionMaterialLot value) => total + value.quantity,
          );
  final int fiberLedger =
      simulation.state.items['I-FIBER']!.quantity +
      frame.materials
          .where((ProductionMaterialLot value) => value.kind == 'plant_fiber')
          .fold<int>(
            0,
            (int total, ProductionMaterialLot value) => total + value.quantity,
          );
  final int grainLedger =
      simulation.state.items.values
          .where((CareItemState value) => value.kind == 'raw_grain')
          .fold<int>(
            0,
            (int total, CareItemState value) => total + value.quantity,
          ) +
      service.materials.fold<int>(
        0,
        (int total, ProductionMaterialLot value) => total + value.quantity,
      ) +
      shock.disruptedLots.fold<int>(
        0,
        (int total, SupplyDisruptionLot value) => total + value.quantity,
      );
  final int rootFoodLedger =
      simulation.state.items.values
          .where((CareItemState value) => value.kind == 'dried_root_food')
          .fold<int>(
            0,
            (int total, CareItemState value) => total + value.quantity,
          ) +
      simulation.state.marketOffers['MO-ROOT-FOOD']!.merchandise.quantity;
  final int herbLedger = simulation.state.items.values
      .where((CareItemState value) => value.kind == 'dried_herb')
      .fold<int>(0, (int total, CareItemState value) => total + value.quantity);
  final int wageLedger = simulation.state.items.values
      .where((CareItemState value) => value.kind == 'labor_rice')
      .fold<int>(0, (int total, CareItemState value) => total + value.quantity);
  _expect(
    timberLedger == 1200 &&
        fiberLedger == 300 &&
        grainLedger == 1100 &&
        rootFoodLedger == 400 &&
        herbLedger == 200 &&
        wageLedger == 500 &&
        simulation.state.items['I-FRAME']!.quantity == 1 &&
        simulation.state.items['I-ROOT-FOOD-STORE']!.quantity == 200 &&
        simulation.state.items['I-WORKER-WAGE']!.quantity == 300 &&
        simulation.state.items.values.every(
          (CareItemState value) => value.quantity >= 0,
        ),
    'Nguồn–process–đích phải đối chiếu đủ, không nhân đôi hoặc làm kho âm.',
  );
  _expect(
    simulation.state.productionBatches.values.every(
          (ProductionBatchState value) =>
              value.status != ProductionBatchStatus.inProgress,
        ) &&
        simulation.state.serviceAppointments.values.every(
          (ServiceAppointmentState value) =>
              value.status != ServiceAppointmentStatus.booked &&
              value.status != ServiceAppointmentStatus.inProgress,
        ) &&
        simulation.state.laborClaims.values.every(
          (LaborCompensationClaim value) =>
              value.status != LaborClaimStatus.outstanding,
        ) &&
        simulation.state.marketShipments.values.every(
          (MarketShipmentState value) =>
              value.status != MarketShipmentStatus.inTransit,
        ) &&
        simulation.state.pendingEvents.every(
          (ScheduledEvent value) =>
              <String>{
                'production_batch_completed',
                'service_appointment_started',
                'service_appointment_completed',
                'labor_work_started',
                'labor_work_completed',
                'market_shipment_arrived',
                'supply_shock_audit',
              }.contains(value.kind) ==
              false,
        ),
    'Ngày $expectedDay không được còn process, nghĩa vụ hoặc chuyến V6 mắc kẹt.',
  );
}

Simulation _fixture() {
  final Simulation simulation = Simulation.fromSeed(_seed);
  for (final Map<String, Object?> room in <Map<String, Object?>>[
    <String, Object?>{
      'room_id': 'ROOM-MARKET',
      'name': 'Nhà chung ven chợ',
      'household_id': 'H01',
      'anchor_position_mm': 1000,
    },
    <String, Object?>{
      'room_id': 'ROOM-STORE',
      'name': 'Kho H02',
      'household_id': 'H02',
      'anchor_position_mm': 1001000,
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
        'name': 'Đường từ chợ về kho H02',
        'origin_id': 'WP-MARKET',
        'destination_id': 'WP-STORE',
        'waypoints': <Map<String, Object?>>[
          <String, Object?>{
            'id': 'WP-MARKET',
            'name': 'Nhà chung ven chợ',
            'position_mm': 1000,
          },
          <String, Object?>{
            'id': 'WP-STORE',
            'name': 'Kho H02',
            'position_mm': 1001000,
          },
        ],
        'legs': <Map<String, Object?>>[
          <String, Object?>{
            'from_id': 'WP-MARKET',
            'to_id': 'WP-STORE',
            'terrain': 'duong_dat_am',
            'terrain_speed_per_mille': 600,
          },
        ],
      },
    },
  );
  for (final Map<String, Object?> person in <Map<String, Object?>>[
    _person('CRAFT', 'Thợ đóng gùi', 'H01'),
    _person('ADAPTER', 'Người hong củ', 'H01'),
    _person('TEACHER', 'Người hướng dẫn', 'H01'),
    _person('EMPLOYER', 'Người thuê công', 'H01'),
    _person('STUDENT', 'Người học', 'H02'),
    _person('WORKER', 'Người làm thuê', 'H02', skill: 'haul'),
    _person('BUYER', 'Người mua kiêm vận chuyển', 'H02'),
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
        'agenda': <String, Object?>{'fatigue': 0},
        'adult_body': <String, Object?>{'mass_g': 50000},
      },
    );
  }
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    _item('I-TIMBER', 'raw_timber', 1200, 'g', 'H01', 720),
    _item('I-FIBER', 'plant_fiber', 300, 'g', 'H01', 680),
    _item('I-AXE', 'hand_axe', 1, 'piece', 'H01', 850),
    _item('I-SERVICE-GRAIN', 'raw_grain', 200, 'g', 'H01', 760),
    _item('I-SHOCK-GRAIN-H01', 'raw_grain', 500, 'g', 'H01', 730),
    _item('I-SHOCK-GRAIN-H02', 'raw_grain', 400, 'g', 'H02', 710),
    _item('I-ROOT', 'raw_root', 600, 'g', 'H01', 700),
    _item('I-HERB', 'dried_herb', 200, 'g', 'H02', 720),
    _item('I-WAGE', 'labor_rice', 500, 'g', 'H01', 800),
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
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
        'name': 'Hộ sản xuất',
        'member_ids': <String>['CRAFT', 'ADAPTER', 'TEACHER', 'EMPLOYER'],
        'meal_actor_id': 'TEACHER',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-TIMBER': <String>['CRAFT'],
          'I-FIBER': <String>['CRAFT'],
          'I-AXE': <String>['CRAFT'],
          'I-SERVICE-GRAIN': <String>['TEACHER'],
          'I-SHOCK-GRAIN-H01': <String>['ADAPTER'],
          'I-ROOT': <String>['ADAPTER'],
          'I-WAGE': <String>['EMPLOYER'],
        },
        'scheduled_work_seconds_by_person': <String, int>{
          'CRAFT': 0,
          'ADAPTER': 0,
          'TEACHER': 0,
          'EMPLOYER': 0,
        },
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H02',
        'name': 'Hộ dịch vụ và vận chuyển',
        'member_ids': <String>['STUDENT', 'WORKER', 'BUYER'],
        'meal_actor_id': 'STUDENT',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-SHOCK-GRAIN-H02': <String>['BUYER'],
          'I-HERB': <String>['BUYER'],
        },
        'scheduled_work_seconds_by_person': <String, int>{
          'STUDENT': 0,
          'WORKER': 0,
          'BUYER': 0,
        },
      },
    );
  return simulation;
}

Map<String, Object?> _person(
  String id,
  String name,
  String householdId, {
  String? skill,
}) => <String, Object?>{
  'person_id': id,
  'name': name,
  'household_id': householdId,
  if (skill != null) 'skills': <String, int>{skill: 800},
};

Map<String, Object?> _item(
  String id,
  String kind,
  int quantity,
  String unit,
  String householdId,
  int condition,
) => <String, Object?>{
  'item_id': id,
  'kind': kind,
  'quantity': quantity,
  'unit': unit,
  'owner_household_id': householdId,
  'condition': condition,
};

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}

bool _printStructuralDifference(Object? left, Object? right, String path) {
  if (left is Map && right is Map) {
    final List<String> keys = <String>{
      ...left.keys.cast<String>(),
      ...right.keys.cast<String>(),
    }.toList()..sort();
    for (final String key in keys) {
      if (!left.containsKey(key) || !right.containsKey(key)) {
        print('Different key at $path.$key: ${left[key]} / ${right[key]}');
        return true;
      }
      if (_printStructuralDifference(left[key], right[key], '$path.$key')) {
        return true;
      }
    }
    return false;
  }
  if (left is List && right is List) {
    if (left.length != right.length) {
      print('Different list length at $path: ${left.length} / ${right.length}');
      return true;
    }
    for (int index = 0; index < left.length; index++) {
      if (_printStructuralDifference(
        left[index],
        right[index],
        '$path[$index]',
      )) {
        return true;
      }
    }
    return false;
  }
  if (left != right) {
    print('Different value at $path: $left / $right');
    return true;
  }
  return false;
}
