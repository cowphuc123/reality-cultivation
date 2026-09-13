import 'dart:convert';

import 'package:reality_cultivation/reality_cultivation.dart';

const int _seed = 20260907;
const SimTime _midpoint = SimTime(15 * gameSecondsPerDay);
const SimTime _settledEnd = SimTime(32 * gameSecondsPerDay);

/// Cổng đóng V3: một làng chi tiết tự vận hành đủ chu kỳ 30 ngày.
void main() {
  final Simulation continuous = _prepared(_seed)..advanceTo(_settledEnd);

  final Simulation throughSave = _prepared(_seed)..advanceTo(_midpoint);
  final String midpointHash = throughSave.state.semanticHash();
  final Simulation restored = Simulation.fromSave(throughSave.state.save());
  _expect(
    restored.state.semanticHash() == midpointHash,
    'Save/load giữa kỳ phải giữ nguyên semantic hash.',
  );
  restored.advanceTo(_settledEnd);

  final Simulation replay = _prepared(_seed)..advanceTo(_settledEnd);
  final WorldState state = continuous.state;
  final CommunitySurvivalState? survival = state.communitySurvival;
  final List<CommunityExchangeState> completedExchanges = state
      .communityExchanges
      .values
      .where(
        (CommunityExchangeState exchange) =>
            exchange.status == CommunityExchangeStatus.completed,
      )
      .toList();
  final List<BeliefState> beliefs = state.people.values
      .expand((PersonState person) => person.beliefs.values)
      .toList();
  final List<SocialRelationState> crossHouseholdRelations =
      <SocialRelationState>[
        for (final PersonState person in state.people.values)
          for (final SocialRelationState relation
              in person.socialRelations.values)
            if (state.people[relation.otherPersonId]?.householdId !=
                person.householdId)
              relation,
      ];

  _expect(
    state.people.length >= 20 && state.people.length <= 50,
    'Làng phải có từ 20 đến 50 NPC chi tiết.',
  );
  _expect(
    state.households.length >= 2 &&
        state.people.values.every(
          (PersonState person) =>
              person.householdId != null &&
              person.body != null &&
              person.routine != null &&
              person.skills != null &&
              person.agenda != null,
        ),
    'Mỗi NPC phải thuộc một hộ và có cơ thể, lịch, nghề cùng trạng thái cá nhân.',
  );
  _expect(
    survival != null && survival.complete && survival.recordedDays == 30,
    'Hồ sơ sức sống cộng đồng phải có đúng chu kỳ 30 ngày hoàn tất.',
  );
  if (survival!.daysRequiringUnsupportedRescue > 0) {
    for (final CommunityDaySnapshot day in survival.days.where(
      (CommunityDaySnapshot value) => value.requiresUnsupportedRescue,
    )) {
      print(
        'Rescue day ${day.day}: overdue=${day.overdueExchanges} '
        '${day.households.where((HouseholdSurvivalSnapshot household) => household.critical).map((HouseholdSurvivalSnapshot household) => '${household.householdId}:${household.criticalReasons.join(',')}').join(' | ')}',
      );
    }
    for (final WorldFact fact
        in state.facts
            .where(
              (WorldFact value) => value.kind == 'household_meal_shortfall',
            )
            .take(20)) {
      print(
        'Meal shortfall ${fact.time.day} ${fact.subjectId}: ${fact.detail}',
      );
    }
  }
  _expect(
    survival.daysRequiringUnsupportedRescue == 0,
    'Điều kiện bình thường không được cần cứu hộ vô căn cứ.',
  );
  _expect(
    completedExchanges.isNotEmpty,
    'Phải có ít nhất một cuộc đổi hàng liên hộ hoàn tất.',
  );
  _expect(
    state.items.values.every((CareItemState item) => item.quantity >= 0),
    'Không kho vật chất nào được âm.',
  );
  _expect(
    state.communityExchanges.values.every(
          (CommunityExchangeState exchange) =>
              exchange.status != CommunityExchangeStatus.traveling,
        ) &&
        state.people.values.every(
          (PersonState person) => person.timeCommitment == null,
        ) &&
        survival.resourceRequests.values.every(
          (CommunityResourceRequestState request) => !request.active,
        ),
    'Sau thời gian lắng, không được còn chuyến hàng, cam kết hoặc yêu cầu mắc kẹt.',
  );
  _expect(
    beliefs.isNotEmpty &&
        beliefs.every(
          (BeliefState belief) =>
              belief.sourcePersonId.isNotEmpty &&
              belief.originPersonId.isNotEmpty &&
              belief.originEvidenceId.isNotEmpty &&
              belief.confidence >= 0 &&
              belief.confidence <= 1000,
        ),
    'Tri thức liên hộ phải tồn tại và mọi bằng chứng phải giữ nguồn.',
  );
  _expect(
    crossHouseholdRelations.isNotEmpty &&
        crossHouseholdRelations.every(
          (SocialRelationState relation) =>
              relation.encounterCount > 0 &&
              relation.lastInteractionAtSeconds != null,
        ),
    'Quan hệ xuyên hộ chỉ được tồn tại sau tiếp xúc có thời điểm.',
  );
  if (state.semanticHash() != restored.state.semanticHash()) {
    print('Continuous hash: ${state.semanticHash()}');
    print('Restored hash: ${restored.state.semanticHash()}');
    _printStructuralDifference(
      jsonDecode(state.save()),
      jsonDecode(restored.state.save()),
      r'$',
    );
  }
  _expect(
    state.semanticHash() == restored.state.semanticHash(),
    'Chạy liền và save/load giữa kỳ phải tới cùng semantic hash.',
  );
  _expect(
    state.semanticHash() == replay.state.semanticHash(),
    'Replay cùng seed và lệnh phải tới cùng semantic hash.',
  );

  print('V3 village 30-day verification passed.');
  print('Population: ${state.people.length}');
  print('Households: ${state.households.length}');
  print('Completed exchanges: ${completedExchanges.length}');
  print('Beliefs: ${beliefs.length}');
  print('Cross-household relations: ${crossHouseholdRelations.length}');
  print('Resource requests: ${survival.resourceRequests.length}');
  print('Rescue days: ${survival.daysRequiringUnsupportedRescue}');
  print('Final hash: ${state.semanticHash()}');
}

Simulation _prepared(int seed) {
  final GeneratedWorld world = WorldGenerator.generate(rootSeed: seed);
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: seed,
    worldFingerprint: world.fingerprint,
  );
  final GeneratedSettlementPopulation population =
      SettlementPopulationGenerator.generate(world: world, history: history);
  return Simulation.fromSeed(seed)
    ..materializeWorld(world)
    ..materializeSettlementPopulation(population, history: history)
    ..advanceTo(const SimTime(0));
}

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
