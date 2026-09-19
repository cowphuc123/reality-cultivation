import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260920;
const SimTime _serviceStart = SimTime(3600);
const SimTime _midService = SimTime(5400);
const SimTime _serviceEnd = SimTime(7200);

const ServiceDefinition _lesson = ServiceDefinition(
  id: 'SERVICE-COOKING-LESSON-01',
  name: 'hướng dẫn nấu cháo ngũ cốc',
  durationSeconds: 3600,
  resultClaimKind: 'cooking_instruction_completed',
  inputs: <ProductionIngredient>[
    ProductionIngredient(kind: 'raw_grain', quantity: 100, unit: 'g'),
  ],
);

/// Bằng chứng mã cho cổng dịch vụ V6; chỉ chạy ở lượt kiểm chứng.
void main() {
  final Simulation continuous = _bookedFixture()..advanceTo(_midService);
  final Simulation savePath = _bookedFixture()..advanceTo(_midService);
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load giữa buổi phải giữ lịch, vật tư và cam kết hai phía.',
  );
  final Simulation replay = _bookedFixture()..advanceTo(_midService);

  _assertInProgress(continuous);
  _assertInProgress(restored);
  _assertInProgress(replay);
  continuous.advanceTo(_serviceEnd);
  restored.advanceTo(_serviceEnd);
  replay.advanceTo(_serviceEnd);

  _assertCompleted(continuous);
  _assertCompleted(restored);
  _assertCompleted(replay);
  final String expectedHash = continuous.state.semanticHash();
  _expect(
    restored.state.semanticHash() == expectedHash &&
        replay.state.semanticHash() == expectedHash,
    'Chạy liền, save/load giữa buổi và replay phải cùng snapshot cuối.',
  );

  print('V6 service appointment verification passed.');
  print('Semantic hash: $expectedHash');
}

Simulation _bookedFixture() {
  final Simulation simulation = _fixture()..advanceTo(const SimTime(0));
  final bool booked = simulation.bookServiceAppointment(
    appointmentId: 'SA-LESSON-01',
    definition: _lesson,
    providerId: 'N01',
    recipientId: 'N02',
    providerHouseholdId: 'H01',
    recipientHouseholdId: 'H01',
    roomId: 'ROOM-KITCHEN',
    startsAtSeconds: _serviceStart.seconds,
    inputItemIdsByKind: const <String, String>{
      'raw_grain': 'I-GRAIN-01',
    },
  );
  _expect(booked, 'Cuộc hẹn đầu phải giữ được lịch và vật tư.');
  final ServiceAppointmentState appointment =
      simulation.state.serviceAppointments['SA-LESSON-01']!;
  _expect(
    appointment.status == ServiceAppointmentStatus.booked &&
        appointment.resultClaim == null &&
        appointment.materials.single.quantity == 100 &&
        simulation.state.items['I-GRAIN-01']!.quantity == 400,
    'Hẹn đã đặt phải có vật tư riêng và chưa được sinh claim.',
  );

  final bool providerOverbooked = simulation.bookServiceAppointment(
    appointmentId: 'SA-PROVIDER-OVERLAP',
    definition: _lesson,
    providerId: 'N01',
    recipientId: 'N03',
    providerHouseholdId: 'H01',
    recipientHouseholdId: 'H01',
    roomId: 'ROOM-KITCHEN',
    startsAtSeconds: 4500,
    inputItemIdsByKind: const <String, String>{
      'raw_grain': 'I-GRAIN-01',
    },
  );
  final bool recipientOverbooked = simulation.bookServiceAppointment(
    appointmentId: 'SA-RECIPIENT-OVERLAP',
    definition: _lesson,
    providerId: 'N03',
    recipientId: 'N02',
    providerHouseholdId: 'H01',
    recipientHouseholdId: 'H01',
    roomId: 'ROOM-KITCHEN',
    startsAtSeconds: 4500,
    inputItemIdsByKind: const <String, String>{
      'raw_grain': 'I-GRAIN-01',
    },
  );
  _expect(
    !providerOverbooked &&
        !recipientOverbooked &&
        simulation.state.items['I-GRAIN-01']!.quantity == 400,
    'Trùng lịch ở bất kỳ phía nào phải bị từ chối trước khi rút thêm vật.',
  );

  final bool competingProduction = simulation.startProductionBatch(
    batchId: 'PB-OVERLAPS-SERVICE',
    recipe: const ProductionRecipe(
      id: 'RECIPE-TIMBER-PRACTICE',
      name: 'tập đẽo gỗ',
      durationSeconds: 5400,
      inputs: <ProductionIngredient>[
        ProductionIngredient(kind: 'raw_timber', quantity: 500, unit: 'g'),
      ],
      outputKind: 'wooden_blank',
      outputQuantity: 1,
      outputUnit: 'piece',
      toolKind: 'hand_axe',
      toolWear: 10,
    ),
    actorId: 'N01',
    householdId: 'H01',
    roomId: 'ROOM-KITCHEN',
    inputItemIdsByKind: const <String, String>{
      'raw_timber': 'I-TIMBER-01',
    },
    outputItemId: 'I-WOODEN-BLANK-01',
    toolItemId: 'I-AXE-01',
  );
  _expect(
    !competingProduction &&
        simulation.state.items['I-TIMBER-01']!.quantity == 1000 &&
        !simulation.state.productionBatches.containsKey(
          'PB-OVERLAPS-SERVICE',
        ),
    'Một việc mới kéo dài qua giờ hẹn không được giữ người hay rút vật.',
  );
  return simulation;
}

void _assertInProgress(Simulation simulation) {
  final ServiceAppointmentState appointment =
      simulation.state.serviceAppointments['SA-LESSON-01']!;
  _expect(
    appointment.status == ServiceAppointmentStatus.inProgress &&
        appointment.resultClaim == null &&
        simulation.state.people['N01']!.timeCommitment?.relatedId ==
            appointment.id &&
        simulation.state.people['N02']!.timeCommitment?.relatedId ==
            appointment.id,
    'Giữa buổi, cả người cung cấp và người nhận phải cùng bị giữ lịch.',
  );
}

void _assertCompleted(Simulation simulation) {
  final ServiceAppointmentState appointment =
      simulation.state.serviceAppointments['SA-LESSON-01']!;
  final ServiceResultClaim? claim = appointment.resultClaim;
  _expect(
    appointment.status == ServiceAppointmentStatus.completed &&
        claim?.id == 'service-claim-SA-LESSON-01' &&
        claim?.kind == 'cooking_instruction_completed' &&
        claim?.providerId == 'N01' &&
        claim?.recipientId == 'N02' &&
        claim?.createdAtSeconds == _serviceEnd.seconds &&
        simulation.state.items['I-GRAIN-01']!.quantity == 400 &&
        simulation.state.people['N01']!.timeCommitment == null &&
        simulation.state.people['N02']!.timeCommitment == null,
    'Hoàn tất phải tạo đúng claim, giữ đúng ledger vật và trả lịch hai phía.',
  );
}

Simulation _fixture() {
  final Simulation simulation = Simulation.fromSeed(_seed)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: const <String, Object?>{
        'room_id': 'ROOM-KITCHEN',
        'name': 'Gian bếp thử nghiệm',
        'household_id': 'H01',
        'anchor_position_mm': 1000,
      },
    );
  for (final (String, String) person in <(String, String)>[
    ('N01', 'Người hướng dẫn'),
    ('N02', 'Người học'),
    ('N03', 'Người dự phòng'),
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
        'room_id': 'ROOM-KITCHEN',
        'household_id': 'H01',
      },
    );
  }
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-GRAIN-01',
      'kind': 'raw_grain',
      'quantity': 500,
      'condition': 760,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-TIMBER-01',
      'kind': 'raw_timber',
      'quantity': 1000,
      'condition': 700,
      'unit': 'g',
    },
    <String, Object?>{
      'item_id': 'I-AXE-01',
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
        'room_id': 'ROOM-KITCHEN',
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
      'name': 'Hộ thử dịch vụ',
      'member_ids': <String>['N01', 'N02', 'N03'],
      'meal_actor_id': 'N01',
      'resource_item_ids': <String, String>{},
      'authorized_users_by_item_id': <String, List<String>>{
        'I-GRAIN-01': <String>['N01', 'N03'],
        'I-TIMBER-01': <String>['N01'],
        'I-AXE-01': <String>['N01'],
      },
      'scheduled_work_seconds_by_person': <String, int>{
        'N01': 0,
        'N02': 0,
        'N03': 0,
      },
    },
  );
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
