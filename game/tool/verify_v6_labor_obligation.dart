import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260921;
const SimTime _workStart = SimTime(3600);
const SimTime _midWork = SimTime(5400);
const SimTime _workEnd = SimTime(7200);

const LaborCompensationTerms _wage = LaborCompensationTerms(
  itemKind: 'labor_rice',
  quantity: 300,
  unit: 'g',
);

/// Bằng chứng mã cho cổng lao động V6; chỉ chạy ở lượt kiểm chứng.
void main() {
  final Simulation continuous = _acceptedFixture()..advanceTo(_midWork);
  final Simulation savePath = _acceptedFixture()..advanceTo(_midWork);
  final String checkpointHash = savePath.state.semanticHash();
  final Simulation restored = Simulation.fromSave(savePath.state.save());
  _expect(
    restored.state.semanticHash() == checkpointHash,
    'Save/load giữa ca phải giữ lời mời, lịch và cam kết lao động.',
  );
  final Simulation replay = _acceptedFixture()..advanceTo(_midWork);

  _assertInProgress(continuous);
  _assertInProgress(restored);
  _assertInProgress(replay);
  for (final Simulation simulation in <Simulation>[
    continuous,
    restored,
    replay,
  ]) {
    simulation.advanceTo(_workEnd);
    _assertOutstandingAfterWork(simulation);
    _settleAfterFailedAttempt(simulation);
  }

  final String expectedHash = continuous.state.semanticHash();
  _expect(
    restored.state.semanticHash() == expectedHash &&
        replay.state.semanticHash() == expectedHash,
    'Chạy liền, save/load giữa ca và replay phải cùng snapshot đã trả công.',
  );

  print('V6 labor obligation verification passed.');
  print('Semantic hash: $expectedHash');
}

Simulation _acceptedFixture() {
  final Simulation simulation = _fixture()..advanceTo(const SimTime(0));
  final bool created = simulation.createLaborOffer(
    offerId: 'LO-CARRY-01',
    activity: 'chuyển gỗ vào xưởng',
    skillCode: 'haul',
    minimumSkill: 600,
    priority: 80,
    employerId: 'EMPLOYER',
    workerId: 'WORKER-ACCEPT',
    employerHouseholdId: 'H01',
    workerHouseholdId: 'H02',
    roomId: 'ROOM-YARD',
    startsAtSeconds: _workStart.seconds,
    durationSeconds: 3600,
    compensation: _wage,
  );
  _expect(
    created && simulation.considerLaborOffer('LO-CARRY-01'),
    'Người đủ kỹ năng, sức và lịch phải nhận lời mời.',
  );

  final bool refusedCreated = simulation.createLaborOffer(
    offerId: 'LO-REFUSED-01',
    activity: 'gánh thêm hàng cuối ngày',
    skillCode: 'haul',
    minimumSkill: 600,
    priority: 50,
    employerId: 'EMPLOYER',
    workerId: 'WORKER-REFUSE',
    employerHouseholdId: 'H01',
    workerHouseholdId: 'H02',
    roomId: 'ROOM-YARD',
    startsAtSeconds: 4 * 3600,
    durationSeconds: 3600,
    compensation: _wage,
  );
  _expect(
    refusedCreated && !simulation.considerLaborOffer('LO-REFUSED-01'),
    'Người quá mệt phải có thể từ chối dù đủ kỹ năng.',
  );
  _expect(
    simulation.state.laborOffers['LO-REFUSED-01']!.status ==
            LaborOfferStatus.refused &&
        simulation.state.laborOffers['LO-REFUSED-01']!.decisionReason ==
            'worker_strain',
    'Lời mời bị từ chối phải giữ nguyên lý do và không sinh ca làm.',
  );
  return simulation;
}

void _assertInProgress(Simulation simulation) {
  final LaborOfferState offer = simulation.state.laborOffers['LO-CARRY-01']!;
  _expect(
    offer.status == LaborOfferStatus.inProgress &&
        offer.compensationClaimId == null &&
        simulation.state.people['WORKER-ACCEPT']!.timeCommitment?.relatedId ==
            offer.id &&
        simulation.state.laborClaims.isEmpty,
    'Giữa ca phải giữ thời gian người làm và chưa được sinh claim.',
  );
}

void _assertOutstandingAfterWork(Simulation simulation) {
  final LaborOfferState offer = simulation.state.laborOffers['LO-CARRY-01']!;
  final LaborCompensationClaim claim =
      simulation.state.laborClaims['labor-claim-LO-CARRY-01']!;
  _expect(
    offer.status == LaborOfferStatus.completed &&
        offer.finishedAtSeconds == _workEnd.seconds &&
        offer.compensationClaimId == claim.id &&
        claim.status == LaborClaimStatus.outstanding &&
        simulation.state.people['WORKER-ACCEPT']!.timeCommitment == null,
    'Công hoàn tất phải được giữ riêng và tạo khoản phải trả chưa tất toán.',
  );
}

void _settleAfterFailedAttempt(Simulation simulation) {
  const String claimId = 'labor-claim-LO-CARRY-01';
  final bool shortPayment = simulation.settleLaborCompensation(
    claimId: claimId,
    sourceItemId: 'I-PAY-SHORT',
    targetItemId: 'I-WORKER-WAGE',
  );
  _expect(
    !shortPayment &&
        simulation.state.laborOffers['LO-CARRY-01']!.status ==
            LaborOfferStatus.completed &&
        simulation.state.laborClaims[claimId]!.status ==
            LaborClaimStatus.outstanding &&
        simulation.state.items['I-PAY-SHORT']!.quantity == 200,
    'Trả thiếu không được xóa công, claim hoặc tự rút phần hàng còn có.',
  );
  final bool settled = simulation.settleLaborCompensation(
    claimId: claimId,
    sourceItemId: 'I-PAY-FULL',
    targetItemId: 'I-WORKER-WAGE',
  );
  _expect(
    settled &&
        simulation.state.laborOffers['LO-CARRY-01']!.status ==
            LaborOfferStatus.completed &&
        simulation.state.laborClaims[claimId]!.status ==
            LaborClaimStatus.settled &&
        simulation.state.items['I-PAY-FULL']!.quantity == 200 &&
        simulation.state.items['I-WORKER-WAGE']!.quantity == 300 &&
        simulation.state.items['I-WORKER-WAGE']!.ownerHouseholdId == 'H02' &&
        simulation.state.households['H02']!.canUse(
          'WORKER-ACCEPT',
          'I-WORKER-WAGE',
        ),
    'Đủ hàng phải chuyển đúng 300 g sang hộ người làm và tất toán claim.',
  );
}

Simulation _fixture() {
  final Simulation simulation = Simulation.fromSeed(_seed)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: const <String, Object?>{
        'room_id': 'ROOM-YARD',
        'name': 'Sân thuê công',
        'household_id': 'H01',
        'anchor_position_mm': 1000,
      },
    );
  for (final Map<String, Object?> person in <Map<String, Object?>>[
    <String, Object?>{
      'person_id': 'EMPLOYER',
      'name': 'Người thuê',
      'household_id': 'H01',
      'skills': <String, int>{'manage': 800},
      'agenda': <String, Object?>{'fatigue': 0},
    },
    <String, Object?>{
      'person_id': 'WORKER-ACCEPT',
      'name': 'Người nhận việc',
      'household_id': 'H02',
      'skills': <String, int>{'haul': 800},
      'agenda': <String, Object?>{'fatigue': 100},
    },
    <String, Object?>{
      'person_id': 'WORKER-REFUSE',
      'name': 'Người từ chối',
      'household_id': 'H02',
      'skills': <String, int>{'haul': 800},
      'agenda': <String, Object?>{'fatigue': 900},
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        ...person,
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': 1000,
        'room_id': 'ROOM-YARD',
      },
    );
  }
  for (final Map<String, Object?> item in <Map<String, Object?>>[
    <String, Object?>{
      'item_id': 'I-PAY-SHORT',
      'kind': 'labor_rice',
      'quantity': 200,
    },
    <String, Object?>{
      'item_id': 'I-PAY-FULL',
      'kind': 'labor_rice',
      'quantity': 500,
    },
  ]) {
    simulation.schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        ...item,
        'condition': 800,
        'unit': 'g',
        'position_mm': 1000,
        'room_id': 'ROOM-YARD',
        'owner_household_id': 'H01',
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
        'name': 'Hộ thuê công',
        'member_ids': <String>['EMPLOYER'],
        'meal_actor_id': 'EMPLOYER',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{
          'I-PAY-SHORT': <String>['EMPLOYER'],
          'I-PAY-FULL': <String>['EMPLOYER'],
        },
        'scheduled_work_seconds_by_person': <String, int>{'EMPLOYER': 0},
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H02',
        'name': 'Hộ người làm',
        'member_ids': <String>['WORKER-ACCEPT', 'WORKER-REFUSE'],
        'meal_actor_id': 'WORKER-ACCEPT',
        'resource_item_ids': <String, String>{},
        'authorized_users_by_item_id': <String, List<String>>{},
        'scheduled_work_seconds_by_person': <String, int>{
          'WORKER-ACCEPT': 0,
          'WORKER-REFUSE': 0,
        },
      },
    );
  return simulation;
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
