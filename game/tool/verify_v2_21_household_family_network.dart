import 'package:reality_cultivation/reality_cultivation.dart';

/// V2.21: hộ nơi sinh có nhiều người lớn, quan hệ nội bộ và ca chăm trẻ thật.
void main() {
  final GeneratedBirthHouseholds legacy = _generate(20260907);
  final GeneratedBirthHouseholds first = _generate(20260907, extended: true);
  final GeneratedBirthHouseholds repeated = _generate(20260907, extended: true);
  final GeneratedBirthHouseholds different = _generate(42, extended: true);

  _expect(
    legacy.generatorVersion == birthHouseholdGeneratorVersion &&
        legacy.fingerprint == '9555c85967aed7fa',
    'Chế độ mặc định phải giữ nguyên dấu vân tay V2.20.',
  );
  _expect(
    first.generatorVersion == extendedBirthHouseholdGeneratorVersion &&
        first.fingerprint == repeated.fingerprint &&
        first.fingerprint != different.fingerprint,
    'Gia đình mở rộng phải tất định theo seed và tách biệt seed khác.',
  );
  _expect(
    first.households.every(
      (GeneratedBirthHousehold household) =>
          household.familyMembers.length == 1 &&
          household.caregiverRoutine.isNotEmpty &&
          household.familyMembers.single.routine.isNotEmpty,
    ),
    'Mỗi hộ sinh mở rộng phải có hai người lớn và hai ca khác nhau.',
  );

  final Simulation awaiting = _prepared(20260907);
  _expect(
    awaiting.state.people.keys.toSet().containsAll(<String>{
      'N05',
      'N06',
      'N07',
      'N08',
    }),
    'Bốn người lớn của hai hộ phải tồn tại trước khi P00 ra đời.',
  );
  for (final GeneratedBirthHousehold plan in first.households) {
    final GeneratedFamilyMember supporter = plan.familyMembers.single;
    final PersonState primary = awaiting.state.people[plan.caregiverId]!;
    final PersonState secondary = awaiting.state.people[supporter.id]!;
    final HouseholdState household =
        awaiting.state.households[plan.householdId]!;
    _expect(
      primary.familyRelationships[supporter.id] ==
              supporter.relationshipToCaregiver &&
          secondary.familyRelationships[primary.id] ==
              supporter.relationshipToCaregiver &&
          household.memberIds.toSet().containsAll(<String>[
            primary.id,
            secondary.id,
          ]) &&
          household.familyCareScheduling &&
          household.canUse(
            secondary.id,
            household.resourceItemIds['infant_feed']!,
          ),
      'Quan hệ nội bộ, thành viên hộ và quyền dùng sữa phải tồn tại trước P00.',
    );
  }

  final List<BirthSiteCandidate> candidates = awaiting
      .birthSiteCandidates()
      .where((BirthSiteCandidate value) => value.feasible)
      .toList();
  _expect(
    candidates.length == 2 &&
        candidates.every(
          (BirthSiteCandidate candidate) =>
              candidate.familyMembers.length == 2 &&
              candidate.familyMembers.every(
                (BirthFamilyMemberSummary member) => member.canUseInfantFeed,
              ),
        ),
    'Màn chọn nơi sinh phải công bố đủ hai người lớn và quyền chăm trẻ.',
  );

  for (final BirthSiteCandidate candidate in candidates) {
    final Simulation branch = _prepared(20260907)
      ..issue(
        ChooseBirthSiteCommand(
          id: 'choose-${candidate.siteId}',
          siteId: candidate.siteId,
        ),
      )
      ..advanceTo(const SimTime(0));
    final PersonState child = branch.state.people['P00']!;
    final HouseholdState household =
        branch.state.households[child.householdId]!;
    _expect(
      child.familyRelationships.length == 2 &&
          household.birthFamilyRolesByPersonId.entries.every(
            (MapEntry<String, String> relation) =>
                child.familyRelationships[relation.key] == relation.value &&
                branch.state.people[relation.key]!.familyRelationships['P00'] ==
                    (relation.value == 'guardian' ? 'ward' : 'child'),
          ),
      'P00 phải nối quan hệ hai chiều với mọi người lớn trong hộ.',
    );
    final Simulation restored = Simulation.fromSave(branch.state.save());
    _expect(
      restored.state.semanticHash() == branch.state.semanticHash() &&
          restored.state.households[household.id]!.familyCareScheduling,
      'Save/load phải giữ nguyên mạng gia đình và quy tắc ca chăm trẻ.',
    );
  }

  final BirthSiteCandidate field = candidates.singleWhere(
    (BirthSiteCandidate value) => value.siteId == 'SITE-FIELD',
  );
  final Simulation care = _prepared(20260907)
    ..issue(
      const ChooseBirthSiteCommand(
        id: 'choose-field-for-care',
        siteId: 'SITE-FIELD',
      ),
    )
    ..advanceTo(const SimTime(7 * 3600));
  final HouseholdState careHousehold = care.state.households['H02']!;
  final String substituteId = careHousehold.memberIds.singleWhere(
    (String id) => id != 'P00' && id != field.caregiverId,
  );
  _expect(
    care.state.people[field.caregiverId]!.routine?.blockingActivity != null &&
        care.state.people[substituteId]!.routine?.blockingActivity == null,
    'Bảy giờ sáng phải là ca bận của người chăm chính và ca rảnh của người kia.',
  );
  care
    ..issue(
      const InfantIntentCommand(
        id: 'cry-during-primary-shift',
        personId: 'P00',
        intent: InfantIntent.cryForCare,
      ),
    )
    ..advanceTo(const SimTime(7 * 3600 + 120));
  _expect(
    care.state.facts.any(
          (WorldFact fact) =>
              fact.kind == 'caregiver_substituted' &&
              fact.subjectId == substituteId,
        ) &&
        care.state.households['H02']!.caregiverSubstitutions > 0,
    'Người đang rảnh và có quyền dùng sữa phải thực sự thay ca chăm trẻ.',
  );

  print('V2.21 household family network verification passed.');
  print('Family fingerprint: ${first.fingerprint}');
  print('Care substitute: $substituteId');
  print('Final hash: ${care.state.semanticHash()}');
}

GeneratedBirthHouseholds _generate(int seed, {bool extended = false}) {
  final GeneratedWorld world = WorldGenerator.generate(rootSeed: seed);
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: seed,
    worldFingerprint: world.fingerprint,
  );
  return BirthHouseholdGenerator.generate(
    world: world,
    history: history,
    includeFamilyMembers: extended,
  );
}

Simulation _prepared(int seed) {
  final GeneratedWorld world = WorldGenerator.generate(rootSeed: seed);
  final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
    rootSeed: seed,
    worldFingerprint: world.fingerprint,
  );
  final GeneratedBirthHouseholds families = BirthHouseholdGenerator.generate(
    world: world,
    history: history,
    includeFamilyMembers: true,
  );
  final WorldSite market = world.site('SITE-MARKET');
  final WorldSite home = world.site('SITE-HOME');
  return Simulation.fromSeed(seed)
    ..materializeWorld(world)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'route_created',
      payload: <String, Object?>{
        'route': <String, Object?>{
          'id': 'RT-ANKHE',
          'name': 'Tuyến chợ An Khê',
          'origin_id': 'WP-MARKET',
          'destination_id': 'WP-HOME',
          'waypoints': <Map<String, Object?>>[
            <String, Object?>{
              'id': 'WP-MARKET',
              'name': 'Chợ An Khê',
              'position_mm': market.center.xMm,
              'position_y_mm': market.center.yMm,
            },
            <String, Object?>{
              'id': 'WP-HOME',
              'name': 'Hộ ven suối',
              'position_mm': home.center.xMm,
              'position_y_mm': home.center.yMm,
            },
          ],
          'legs': <Map<String, Object?>>[
            <String, Object?>{
              'from_id': 'WP-MARKET',
              'to_id': 'WP-HOME',
              'terrain': 'duong_bang',
              'terrain_speed_per_mille': 1000,
            },
          ],
        },
      },
    )
    ..materializeBirthHouseholds(families, history: history)
    ..simulatePrehistory(history, applyLegacy: true)
    ..openWorldEntry()
    ..advanceTo(const SimTime(0));
}

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
