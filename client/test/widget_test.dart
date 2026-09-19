import 'dart:convert';

import 'package:flutter/material.dart' hide Simulation;
import 'package:flutter_test/flutter_test.dart';
import 'package:reality_cultivation_client/main.dart';
import 'package:reality_cultivation_client/save_repository.dart';
import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  testWidgets('mobile navigation exposes play, body and household', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
      ),
    );

    expect(find.byKey(const Key('narrow-layout')), findsOneWidget);
    expect(find.byKey(const Key('mobile-navigation')), findsOneWidget);
    expect(find.text('Vô Danh'), findsOneWidget);
    expect(find.byKey(const Key('intent-attend_voice')), findsOneWidget);
    await tester.tap(find.byKey(const Key('intent-attend_voice')));
    await tester.pump();
    expect(
      find.text('Mục tiêu hiện tại: Lắng nghe giọng người chăm sóc'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('intent-cry_for_care')));
    await tester.pump();
    expect(find.byKey(const Key('care-response-pending')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-1')));
    await tester.pumpAndSettle();
    expect(find.text('Khối lượng: 3400 g'), findsOneWidget);
    expect(find.text('Dạ dày: 0/74 ml'), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('household-panel')), findsOneWidget);
    expect(find.text('16695 g'), findsWidgets);
    expect(find.byKey(const Key('member-profile-N01')), findsOneWidget);
    expect(find.byKey(const Key('item-profile-I-FOOD-01')), findsOneWidget);
    expect(find.byKey(const Key('production-batch-panel')), findsOneWidget);
    expect(
      find.byKey(const Key('production-batch-PB-CARRY-FRAME-01')),
      findsOneWidget,
    );
    expect(find.textContaining('Workpiece đang giữ 2 lô'), findsOneWidget);
    expect(find.textContaining('rìu tay · I-HAND-AXE-01'), findsWidgets);
    expect(find.textContaining('chưa xuất hiện trong kho'), findsWidgets);
    expect(find.byKey(const Key('service-appointment-panel')), findsOneWidget);
    expect(
      find.byKey(const Key('service-appointment-SA-COOKING-LESSON-01')),
      findsOneWidget,
    );
    expect(find.text('đã giữ lịch hai phía'), findsOneWidget);
    expect(find.textContaining('ngũ cốc thô 100 g'), findsWidgets);
    expect(find.textContaining('dịch vụ chưa hoàn tất'), findsOneWidget);
    expect(find.byKey(const Key('labor-offer-panel')), findsOneWidget);
    expect(
      find.byKey(const Key('labor-offer-LO-YARD-SORT-01')),
      findsOneWidget,
    );
    expect(find.textContaining('gạo trả công 300 g'), findsOneWidget);
    expect(find.text('đã nhận việc · Người làm công'), findsOneWidget);
    expect(
      find.byKey(const Key('labor-offer-LO-EXTRA-HAUL-01')),
      findsOneWidget,
    );
    expect(find.text('đã từ chối · Người làm công'), findsOneWidget);
    expect(find.byKey(const Key('market-panel')), findsOneWidget);
    expect(
      find.byKey(const Key('market-offer-MO-GRAIN-HERB-01')),
      findsOneWidget,
    );
    expect(find.textContaining('100/200 g'), findsOneWidget);
    expect(find.textContaining('50 g dược thảo khô'), findsOneWidget);
    expect(
      find.byKey(const Key('market-order-MO-GRAIN-HERB-01-ORDER-01')),
      findsOneWidget,
    );
    expect(find.text('đã thanh toán · Người đổi dược thảo'), findsOneWidget);
    expect(find.textContaining('Đã đổi chủ:'), findsOneWidget);
    expect(
      find.byKey(const Key('market-shipment-MS-GRAIN-M01-01')),
      findsOneWidget,
    );
    expect(find.text('đang vận chuyển · Người đổi dược thảo'), findsOneWidget);
    expect(find.textContaining('hàng đã rời kho đầu'), findsOneWidget);
    expect(find.byKey(const Key('supply-shock-panel')), findsOneWidget);
    expect(
      find.byKey(const Key('supply-shock-SS-GRAIN-RAIN-01')),
      findsOneWidget,
    );
    expect(
      find.textContaining('Phản ứng có bằng chứng (2/2 hộ)'),
      findsOneWidget,
    );
    expect(find.textContaining('H01: đổi sản xuất'), findsOneWidget);
    expect(find.textContaining('H-MERCHANT: đổi cách mua bán'), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('save-world')), findsOneWidget);
    expect(find.byKey(const Key('load-world')), findsOneWidget);
    expect(find.byKey(const Key('new-world')), findsOneWidget);
    expect(find.byKey(const Key('world-map')), findsOneWidget);
    expect(find.byKey(const Key('map-site-SITE-HOME')), findsOneWidget);
    expect(find.byKey(const Key('map-site-SITE-FIELD')), findsOneWidget);
    expect(find.text('Thung lũng An Khê'), findsOneWidget);
    expect(
      find.textContaining('0 người đang ngoài mọi địa điểm'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('new-world')));
    await tester.pumpAndSettle();
    expect(find.text('Tạo thế giới mới?'), findsOneWidget);
    await tester.tap(find.text('Giữ thế giới cũ'));
    await tester.pumpAndSettle();
    expect(find.text('Tạo thế giới mới?'), findsNothing);
  });

  testWidgets('desktop navigation exposes every implemented area', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
      ),
    );

    expect(find.byKey(const Key('wide-layout')), findsOneWidget);
    expect(find.byKey(const Key('intent-attend_voice')), findsOneWidget);
    expect(find.byKey(const Key('goal-field')), findsNothing);
    expect(find.text('THẾ GIỚI'), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('household-panel')), findsOneWidget);
    expect(
      find.byKey(const Key('production-batch-PB-CARRY-FRAME-01')),
      findsOneWidget,
    );
    expect(find.text('đóng khung gùi gỗ'), findsWidgets);
    expect(find.textContaining('Còn 120 phút'), findsOneWidget);
    expect(
      find.byKey(const Key('service-appointment-SA-COOKING-LESSON-01')),
      findsOneWidget,
    );
    expect(find.text('hướng dẫn nấu cháo ngũ cốc'), findsOneWidget);
    expect(find.textContaining('còn 180 phút tới giờ hẹn'), findsOneWidget);
    expect(find.text('phân loại gỗ và sợi trong sân'), findsOneWidget);
    expect(find.textContaining('còn 240 phút tới ca'), findsOneWidget);
    expect(find.text('gánh thêm gỗ cuối ngày'), findsOneWidget);
    expect(find.textContaining('mệt, đói, khát'), findsOneWidget);
    expect(find.text('ngũ cốc thô tại chợ'), findsOneWidget);
    expect(find.textContaining('Mỗi lot 100 g đổi 50 g'), findsOneWidget);
    expect(find.textContaining('Người đã biết offer:'), findsOneWidget);
    expect(
      find.textContaining('Lô hàng đã giữ: ngũ cốc thô 100 g'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Vật thanh toán đã giữ: dược thảo khô 50 g'),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('market-shipment-MS-GRAIN-M01-01')),
      findsOneWidget,
    );
    expect(find.textContaining('Tuyến RT-ANKHE-MARKET-RETURN'), findsOneWidget);
    expect(find.textContaining('hao dự kiến'), findsOneWidget);
    expect(find.text('Thiếu ngũ cốc thô'), findsOneWidget);
    expect(find.textContaining('mưa kéo dài làm ẩm mốc'), findsOneWidget);
    expect(
      find.byKey(
        const Key('supply-disruption-SS-GRAIN-RAIN-01-I-GRAIN-SERVICE-01'),
      ),
      findsOneWidget,
    );
    expect(
      find.text('Chưa tới lần đối chiếu cuối ngày đầu tiên.'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('nav-3')));
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử đã xảy ra'), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Hộ gia đình'));
    await tester.pump();
    expect(find.text('Hộ gia đình hình thành'), findsWidgets);
    expect(find.text('Nhân vật tồn tại'), findsNothing);
  });

  testWidgets('world exists before player chooses a feasible birth site', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('birth-site-selection')), findsOneWidget);
    expect(find.text('Chọn nơi bạn sẽ chào đời'), findsOneWidget);
    expect(find.byKey(const Key('world-history-summary')), findsOneWidget);
    expect(find.byKey(const Key('historical-legacy-summary')), findsOneWidget);
    expect(
      find.byKey(const Key('historical-compression-summary')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('legacy-adjustment-I-FOOD-01')),
      findsOneWidget,
    );
    expect(find.textContaining('741 năm tiền sử'), findsOneWidget);
    expect(find.textContaining('Tiếp tế mỗi chuyến 110.3%'), findsOneWidget);
    expect(
      find.byKey(const Key('history-epoch-EPOCH-FOUNDING')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('history-anchor-ANCHOR-HOME-FOUNDED')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('history-anchor-ANCHOR-ROUTE-ESTABLISHED')),
      findsOneWidget,
    );
    expect(find.textContaining('cư dân nền'), findsOneWidget);
    expect(find.byKey(const Key('birth-site-SITE-HOME')), findsOneWidget);
    expect(find.byKey(const Key('birth-site-SITE-RIVER')), findsOneWidget);
    expect(find.byKey(const Key('birth-site-SITE-FIELD')), findsOneWidget);
    expect(find.byKey(const Key('birth-site-SITE-MARKET')), findsOneWidget);
    expect(find.byKey(const Key('birth-risk-SITE-FIELD-0')), findsOneWidget);
    expect(find.byKey(const Key('birth-terrain-SITE-HOME')), findsOneWidget);
    expect(find.byKey(const Key('birth-resources-SITE-RIVER')), findsOneWidget);
    expect(find.byKey(const Key('birth-resources-SITE-FIELD')), findsOneWidget);
    expect(find.byKey(const Key('birth-ecology-SITE-FIELD')), findsOneWidget);
    expect(find.byKey(const Key('birth-ecology-SITE-PASS')), findsOneWidget);
    expect(find.byKey(const Key('birth-settlement-SITE-HOME')), findsOneWidget);
    expect(
      find.byKey(const Key('birth-settlement-SITE-FIELD')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('birth-settlement-SITE-MARKET')),
      findsOneWidget,
    );
    final GeneratedWorld generated = WorldGenerator.generate(
      rootSeed: 20260907,
      includeTerrainProfile: true,
    );
    final GeneratedWorldHistory generatedHistory =
        WorldHistoryGenerator.generate(
          rootSeed: generated.rootSeed,
          worldFingerprint: generated.fingerprint,
        );
    final GeneratedBirthHouseholds generatedFamilies =
        BirthHouseholdGenerator.generate(
          world: generated,
          history: generatedHistory,
          includeFamilyMembers: true,
        );
    for (final GeneratedBirthHousehold family in generatedFamilies.households) {
      expect(
        find.byKey(Key('birth-caregiver-${family.siteId}')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('birth-family-role-${family.siteId}')),
        findsOneWidget,
      );
      expect(
        find.byKey(Key('birth-family-origin-${family.siteId}')),
        findsOneWidget,
      );
      for (final GeneratedFamilyMember member in family.familyMembers) {
        expect(
          find.byKey(Key('birth-family-member-${family.siteId}-${member.id}')),
          findsOneWidget,
        );
      }
    }
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('choose-birth-SITE-HOME')))
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('choose-birth-SITE-FIELD')),
          )
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('choose-birth-SITE-MARKET')),
          )
          .onPressed,
      isNotNull,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('choose-birth-SITE-RIVER')),
          )
          .onPressed,
      isNull,
    );
    expect(find.byKey(const Key('mobile-navigation')), findsNothing);
    expect(find.text('Vô Danh'), findsNothing);

    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.byKey(const Key('birth-site-SITE-FIELD'))).dy,
      tester.getTopLeft(find.byKey(const Key('birth-site-SITE-HOME'))).dy,
    );
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('choose-birth-SITE-FIELD')),
    );
    await tester.tap(find.byKey(const Key('choose-birth-SITE-FIELD')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('birth-site-selection')), findsNothing);
    expect(find.byKey(const Key('mobile-navigation')), findsOneWidget);
    expect(find.text('Vô Danh'), findsOneWidget);
    expect(repository.value, contains('"status": "born"'));
    expect(repository.value, contains('"selected_site_id": "SITE-FIELD"'));
    expect(repository.value, contains('"household_id": "H02"'));
    expect(repository.value, contains('"caregiver_id": "N05"'));
    expect(repository.value, contains('"N07"'));
    expect(repository.value, contains('"family_care_scheduling": true'));
    expect(repository.value, contains('"family_relationships"'));
    expect(repository.value, contains('"world_history"'));
    expect(repository.value, contains('"historical_legacy"'));
    expect(repository.value, contains('"formula_version": "v5.0-dev.6"'));
    expect(
      repository.value,
      contains('"plan_fingerprint": "${generatedHistory.fingerprint}"'),
    );
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    final String selectedHouseholdName = generatedFamilies.households
        .singleWhere(
          (GeneratedBirthHousehold value) => value.householdId == 'H02',
        )
        .householdName;
    expect(find.text(selectedHouseholdName), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('world-history-summary')), findsOneWidget);
    await tester.ensureVisible(find.text('Vô Danh · P00'));
    await tester.tap(find.text('Vô Danh · P00'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('family-relationships-P00')), findsOneWidget);
  });

  testWidgets('new world seed regenerates and persists the map', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Seed 20260907'), findsOneWidget);

    await tester.tap(find.byKey(const Key('new-world')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('world-seed-field')), '0');
    await tester.tap(find.byKey(const Key('confirm-new-world')));
    await tester.pump();
    expect(find.text('Seed từ 1 đến 2147483646.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('world-seed-field')), '42');
    await tester.tap(find.byKey(const Key('confirm-new-world')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    final GeneratedWorld expected = WorldGenerator.generate(
      rootSeed: 42,
      includeTerrainProfile: true,
    );
    expect(find.textContaining('Seed 42'), findsOneWidget);
    expect(find.byKey(const Key('region-terrain-REG-ANKHE')), findsOneWidget);
    expect(find.textContaining(expected.fingerprint), findsOneWidget);
    expect(repository.value, contains('"seed": 42'));
    expect(repository.value, contains(expected.fingerprint));
  });

  testWidgets('manual save restores the exact earlier infant intent', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('intent-attend_voice')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();
    expect(repository.value, isNotNull);

    await tester.tap(find.byKey(const Key('nav-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('intent-cry_for_care')));
    await tester.pump();
    expect(
      find.text('Mục tiêu hiện tại: Khóc gọi người chăm sóc'),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('load-world')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-0')));
    await tester.pumpAndSettle();
    expect(
      find.text('Mục tiêu hiện tại: Lắng nghe giọng người chăm sóc'),
      findsOneWidget,
    );
  });

  testWidgets('lifecycle pause saves and next launch restores', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('intent-attend_voice')));
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pumpAndSettle();
    expect(repository.value, isNotNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        saveRepository: repository,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Mục tiêu hiện tại: Lắng nghe giọng người chăm sóc'),
      findsOneWidget,
    );
  });

  testWidgets('day four exposes room and active illness from simulation', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();
    final Simulation dayFour = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(4 * gameSecondsPerDay));
    expect(dayFour.state.illnesses, isNotEmpty);
    expect(SimulationHost(dayFour).person('P00')!.health, isNotNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: dayFour,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-1')));
    await tester.pumpAndSettle();
    expect(find.text('Vị trí: Gian ngủ'), findsOneWidget);
    expect(find.text('Nhiễm đường hô hấp nhẹ'), findsOneWidget);
    expect(find.text('Giai đoạn: đang hồi phục'), findsOneWidget);
    expect(
      find.textContaining('Đã được người chăm sóc phát hiện'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('illness-physiology-impact')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.text('Lượt sản xuất'), findsOneWidget);
    expect(find.text('Lần thay người'), findsOneWidget);
  });

  testWidgets('delayed supply journey is visible before its real arrival', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();
    final Simulation delayedJourney = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(4 * gameSecondsPerDay + 22 * 3600));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: delayedJourney,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.textContaining('SUP-H01-0'), findsOneWidget);
    // Chuyến chạy trên tuyến thật: hiện tên tuyến, chặng và quãng đã đi.
    expect(find.textContaining('Tuyến chợ An Khê'), findsOneWidget);
    expect(find.textContaining('km'), findsWidgets);
  });

  testWidgets('directory opens a profile for everyone and every item', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('people-directory')), findsOneWidget);
    expect(find.byKey(const Key('item-directory')), findsOneWidget);
    for (final String id in <String>[
      'P00',
      'N01',
      'N02',
      'N03',
      'N04',
      'N05',
      'N06',
      'N07',
      'N08',
    ]) {
      expect(find.byKey(Key('person-profile-$id')), findsOneWidget);
    }
    // N04 sống ngoài hộ nhưng vẫn có hồ sơ riêng.
    expect(find.textContaining('Ngoài hộ'), findsOneWidget);
    // Khăn quấn không nằm trong sổ kho nhưng vẫn được liệt kê.
    expect(
      find.byKey(const Key('world-item-profile-I-CLOTH-01')),
      findsOneWidget,
    );
    expect(find.textContaining('ngoài sổ kho'), findsWidgets);
    expect(
      find.textContaining('3 vật nằm ngoài sổ kho của hộ'),
      findsOneWidget,
    );
    expect(find.textContaining('1 người sống ngoài hộ'), findsOneWidget);
  });

  testWidgets('household needs generate work and priority settles clashes', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation morning = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(8 * 3600));

    // Hộ tự rà tồn kho rồi giao việc, không có ai viết sẵn lịch này.
    expect(
      morning.state.facts.any(
        (WorldFact fact) => fact.kind == 'household_plan_made',
      ),
      isTrue,
    );
    // Việc gấp hơn giành chỗ của khối cố định ưu tiên thấp hơn.
    expect(
      morning.state.people['N03']!.routine!.conflicts.any(
        (ScheduleConflict value) => value.resolution == 'outranked',
      ),
      isTrue,
    );
    // Khối bị nhường chỗ vẫn là việc do nhu cầu thật sinh ra.
    expect(
      morning.state.people['N03']!.routine!.activeBlock?.needKind,
      isNotNull,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: morning,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('plan-panel')), findsOneWidget);
    expect(find.textContaining('ngày dùng'), findsWidgets);
    expect(find.textContaining('vì thiếu'), findsWidgets);
    expect(find.text('Xung đột lịch'), findsOneWidget);
  });
  testWidgets('skills pick the worker and a tired person may refuse', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation morning = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(6 * 3600));

    // Người nấu ăn có quyền dùng kho củi nhưng không đủ tay nghề.
    expect(morning.state.households['H01']!.canUse('N02', 'I-FUEL-01'), isTrue);
    final WorldFact plan = morning.state.facts.lastWhere(
      (WorldFact fact) =>
          fact.kind == 'household_plan_made' && fact.subjectId == 'H01',
    );
    expect(plan.detail.contains('fuel:N03'), isTrue);

    // Người đang kiệt sức từ chối việc chưa đủ gấp.
    expect(
      morning.state.facts.any(
        (WorldFact fact) =>
            fact.kind == 'work_offer_refused' && fact.subjectId == 'N03',
      ),
      isTrue,
    );
    expect(morning.state.people['N03']!.agenda!.refusedOffers, greaterThan(0));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: morning,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.text('Từ chối việc'), findsOneWidget);

    // Hồ sơ riêng của người làm công cho thấy sức lực và lần từ chối.
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('person-profile-N03')), findsOneWidget);
  });
  testWidgets('working raises the skill and hunger reaches the profile', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation start = Simulation.fromSave(repository.value!);
    final int before = start.state.people['N03']!.skills!.level('gather_fuel');
    final Simulation afterWork = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(11 * 3600));

    // Làm xong khối việc thì tay nghề lên thật và có mốc ghi lại.
    expect(
      afterWork.state.people['N03']!.skills!.level('gather_fuel'),
      greaterThan(before),
    );
    expect(
      afterWork.state.facts.any(
        (WorldFact fact) => fact.kind == 'skill_improved',
      ),
      isTrue,
    );
    // Ba trục sức lực đều là số thật trên hồ sơ.
    final PersonAgenda agenda = afterWork.state.people['N03']!.agenda!;
    expect(agenda.fatigue, greaterThan(0));
    expect(agenda.acceptanceFloor, greaterThanOrEqualTo(agenda.fatigue ~/ 10));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: afterWork,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Nhịp sống'));
    await tester.pump();
    expect(find.text('Lên tay nghề'), findsWidgets);
  });
  testWidgets('meals feed real adult bodies and weight reaches the profile', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation start = Simulation.fromSave(repository.value!);
    // Ba người lớn có cơ thể riêng, trẻ sơ sinh thì không.
    expect(start.state.people['N01']!.body, isNotNull);
    expect(start.state.people['P00']!.body, isNull);
    final int reserveStart = start.state.people['N01']!.body!.energyReserveKj;

    final Simulation evening = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(23 * 3600));
    final AdultBodyState body = evening.state.people['N01']!.body!;
    // Bữa ăn đi vào cơ thể thật và một ngày trôi thì đốt năng lượng thật.
    expect(body.totalIntakeKj, greaterThan(0));
    expect(
      body.totalBurnedKj,
      greaterThanOrEqualTo(AdultBodyState.basalKjPerDay),
    );
    expect(body.energyReserveKj, isNot(equals(reserveStart)));
    expect(body.capability, inInclusiveRange(0, 1000));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: evening,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('person-profile-N01')), findsOneWidget);
    expect(find.byKey(const Key('person-profile-N03')), findsOneWidget);
  });
  testWidgets('adults drink from the household store and thirst has teeth', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation evening = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(23 * 3600));
    final AdultBodyState body = evening.state.people['N01']!.body!;

    // Uống nước thật, lấy từ kho hộ, và được ghi lại.
    expect(body.totalDrunkMl, greaterThan(0));
    expect(
      evening.state.facts.any((WorldFact fact) => fact.kind == 'body_drank'),
      isTrue,
    );
    // Sức làm việc do thứ nào thiếu hơn quyết định.
    expect(
      body.capability,
      equals(
        body.massCapability < body.waterCapability
            ? body.massCapability
            : body.waterCapability,
      ),
    );
    // Nhu cầu nước của hộ nay tính cả phần người uống.
    expect(
      SimulationHost(evening)
          .household('H01')!
          .needs
          .firstWhere((HouseholdNeed need) => need.kind == 'water')
          .dailyUse,
      greaterThan(6000),
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: evening,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('person-profile-N01')), findsOneWidget);
  });
  testWidgets('the carrier walks a real route through waypoints', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation start = Simulation.fromSave(repository.value!);
    final TradeRoute route = start.state.routes['RT-ANKHE']!;
    // Tuyến có ngã rẽ: từ chân đèo đi tiếp qua đèo hoặc vòng qua đồng ngoài.
    expect(route.legs.length, 5);
    expect(route.hasFork, isTrue);
    expect(route.legsFrom('WP-DEO').length, 2);

    // Đi được một chặng thì người chở phải đứng ở điểm mốc thật.
    final Simulation midway = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(4 * gameSecondsPerDay + 22 * 3600));
    final int carrierAt = midway.state.people['N04']!.positionMm!;
    expect(
      route.waypoints.map((RouteWaypoint w) => w.positionMm),
      contains(carrierAt),
    );
    expect(
      midway.state.facts.any(
        (WorldFact fact) => fact.kind == 'route_leg_arrived',
      ),
      isTrue,
    );

    // Đi hết tuyến thì trễ giờ phải sinh ra từ địa hình, không phải hằng số.
    final Simulation done = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(6 * gameSecondsPerDay));
    final SupplyJourneyState trip = done.state.supplyJourneys['SUP-H01-0']!;
    expect(trip.status, SupplyJourneyStatus.delivered);
    // Người chở khỏe chọn đường vòng bằng phẳng nên không leo đèo nữa,
    // và phần trễ còn lại đến từ 39 kg hàng trên lưng chứ không từ địa hình.
    expect(trip.pathWaypointIds, contains('WP-DONG'));
    expect(trip.pathWaypointIds, isNot(contains('WP-SUOI')));
    expect(trip.travelledMm, route.pathDistanceMm(trip.pathWaypointIds));
    expect(trip.delayReason, 'duong_bang');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: midway,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.textContaining('chặng'), findsWidgets);
  });
  testWidgets('two axes let a route fork, and the carrier picks a lane', (
    WidgetTester tester,
  ) async {
    // Khoảng cách hai chiều là số nguyên, và thế giới một chiều cũ không đổi.
    expect(
      const WorldPoint(0, 0).distanceTo(const WorldPoint(3000, 4000)),
      5000,
    );
    expect(const WorldPoint(12000).distanceTo(const WorldPoint(5000)), 7000);

    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation start = Simulation.fromSave(repository.value!);
    final TradeRoute route = start.state.routes['RT-ANKHE']!;

    // Điểm mốc lệch khỏi trục thì ngã rẽ mới có nghĩa.
    final RouteWaypoint plain = route.waypoint('WP-DONG')!;
    expect(plain.positionYMm, isNot(0));

    // Đường vòng dài hơn về mét nhưng nhanh hơn về giờ.
    const Map<String, int> cargo = <String, int>{
      'food': 7500,
      'water': 30000,
      'infant_feed': 1500,
    };
    const List<String> viaPass = <String>[
      'WP-CHO',
      'WP-DEO',
      'WP-SUOI',
      'WP-SAN',
    ];
    const List<String> viaPlain = <String>[
      'WP-CHO',
      'WP-DEO',
      'WP-DONG',
      'WP-SAN',
    ];
    expect(
      route.pathDistanceMm(viaPlain),
      greaterThan(route.pathDistanceMm(viaPass)),
    );
    expect(
      route.pathSeconds(path: viaPlain, cargo: cargo, capabilityPerMille: 1000),
      lessThan(
        route.pathSeconds(
          path: viaPass,
          cargo: cargo,
          capabilityPerMille: 1000,
        ),
      ),
    );

    // Người chở tự chọn lối nhanh hơn cho mình.
    expect(
      route.fastestPath(
        from: 'WP-CHO',
        to: 'WP-SAN',
        cargo: cargo,
        capabilityPerMille: 1000,
      ),
      viaPlain,
    );

    final Simulation midway = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(4 * gameSecondsPerDay + 22 * 3600));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: midway,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Đã chọn lối'), findsOneWidget);
    expect(find.textContaining('Đồng ngoài'), findsWidgets);
  });
  testWidgets('an adult falls ill from a real body state, not a timer', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    // Tới ngày 10: N03 kiệt sức trước, được nghỉ và khỏi, rồi mới mất nước —
    // vì nghỉ bệnh làm anh ta thôi cày mười hai tiếng nên mất nước chậm lại.
    final Simulation later = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(10 * gameSecondsPerDay));

    // Hai nguyên nhân đều là trạng thái cơ thể thật, không phải hẹn giờ.
    // N03 không có quyền lấy nước nên khát dần; N01 làm gần mười tiếng mỗi
    // ngày nên kiệt sức. Thứ tự ai ốm trước là hệ quả, không phải điều được
    // đặt sẵn, nên bài test tìm theo nguyên nhân chứ không theo thứ tự.
    final WorldFact onset = later.state.facts.firstWhere(
      (WorldFact fact) =>
          fact.kind == 'adult_illness_onset' &&
          fact.detail.contains('cause=mat_nuoc'),
    );
    expect(onset.subjectId, 'N03');
    // Nguyên nhân là con số cơ thể thật, được ghi kèm để truy được.
    expect(onset.detail, contains('hydration='));
    expect(
      later.state.facts.any(
        (WorldFact fact) =>
            fact.kind == 'adult_illness_onset' &&
            fact.detail.contains('cause=kiet_suc'),
      ),
      isTrue,
    );

    // N03 làm mười hai tiếng mỗi ngày nên còn ốm cả vì kiệt sức; lấy đúng
    // ca bệnh mà mốc khởi phát trên kia đã nêu, thay vì ca đầu tiên gặp được.
    final String illnessId = onset.detail
        .split(' ')
        .firstWhere((String part) => part.startsWith('illness='))
        .substring('illness='.length);
    expect(later.state.illnesses[illnessId]!.kind, 'adult_dehydration');
    expect(later.state.illnesses[illnessId]!.personId, 'N03');

    // Hộ nhận ra và cử người chăm, tiêu nước thật của kho.
    expect(
      later.state.facts.any(
        (WorldFact fact) => fact.kind == 'adult_illness_detected',
      ),
      isTrue,
    );
    expect(
      later.state.facts.any(
        (WorldFact fact) =>
            fact.kind == 'adult_illness_care_completed' &&
            fact.detail.contains('water_ml=400'),
      ),
      isTrue,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: later,
      ),
    );
    await tester.pumpAndSettle();
    // Cơ chế đã được chứng minh ở tầng mô phỏng phía trên. Nhật ký chỉ giữ
    // 50 mốc gần nhất và ở ngày 10 phần lớn là mốc sinh lý của trẻ, nên
    // không neo bài test vào chữ trong nhật ký; chỉ xác nhận giao diện dựng
    // được hồ sơ của người đã ốm.
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('person-profile-N03')), findsOneWidget);
    expect(find.byKey(const Key('person-profile-N01')), findsOneWidget);
  });
  testWidgets('a sick adult actually rests instead of working through it', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation week = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(6 * gameSecondsPerDay));

    // Đang ốm thì khối việc bị lùi rồi bỏ, chứ không cứ thế chạy.
    expect(
      week.state.facts.any(
        (WorldFact fact) =>
            fact.kind == 'routine_block_deferred' &&
            fact.detail.contains('competing=nghỉ vì ốm'),
      ),
      isTrue,
    );
    expect(
      week.state.facts.any(
        (WorldFact fact) =>
            fact.kind == 'routine_block_dropped' &&
            fact.detail.contains('competing=nghỉ vì ốm'),
      ),
      isTrue,
    );
    // Khỏi hẳn thì kỳ nghỉ kết thúc và có mốc ghi lại.
    expect(
      week.state.facts.any(
        (WorldFact fact) => fact.kind == 'illness_rest_ended',
      ),
      isTrue,
    );
    // Kỳ nghỉ để lại dấu thật trong sổ giờ mất.
    expect(week.state.people['N01']!.routine!.lostSeconds, greaterThan(0));
    expect(
      week.state.facts.any(
        (WorldFact fact) => fact.kind == 'routine_block_reassigned',
      ),
      isTrue,
    );

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: week,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.text('Xung đột lịch'), findsOneWidget);
    expect(find.text('Ca được gánh thay'), findsOneWidget);
  });

  testWidgets('mobile exposes V3 village survival knowledge and relations', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();

    final Simulation village = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(6 * gameSecondsPerDay));
    final PersonState informed = village.state.people.values.firstWhere(
      (PersonState person) =>
          person.beliefs.isNotEmpty && person.socialRelations.isNotEmpty,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: village,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('narrow-layout')), findsOneWidget);
    expect(find.byKey(const Key('community-survival-card')), findsOneWidget);
    expect(
      find.byKey(const Key('community-resource-request-summary')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('people-directory')), findsOneWidget);
    final Finder profile = find.byKey(Key('person-profile-${informed.id}'));
    await tester.ensureVisible(profile);
    await tester.tap(profile);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('knowledge-count-${informed.id}')), findsOneWidget);
    expect(find.byKey(Key('social-relations-${informed.id}')), findsOneWidget);
  });

  testWidgets('desktop exposes V3 village households and material flows', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();
    final Simulation village = Simulation.fromSave(repository.value!)
      ..advanceTo(const SimTime(6 * gameSecondsPerDay));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: village,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('wide-layout')), findsOneWidget);
    expect(find.byKey(const Key('community-survival-card')), findsOneWidget);
    expect(find.textContaining('chuyến hàng'), findsOneWidget);
    expect(find.byKey(const Key('people-directory')), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav-2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('household-panel')), findsOneWidget);
  });

  testWidgets('mobile exposes the complete V4 childhood record', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final Simulation childhood = await _v4GuiSimulation(tester);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: childhood,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('narrow-layout')), findsOneWidget);
    expect(find.byKey(const Key('child-intent-observe')), findsOneWidget);
    expect(find.byKey(const Key('child-intent-vocalize')), findsOneWidget);
    expect(
      find.byKey(const Key('child-intent-practice_reach')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('child-intent-floor_play')), findsOneWidget);

    await tester.tap(find.byKey(const Key('nav-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('child-development-stage')), findsOneWidget);
    expect(find.byKey(const Key('child-body-mass')), findsOneWidget);
    expect(find.byKey(const Key('child-activity-experience')), findsOneWidget);
    expect(
      find.byKey(const Key('child-physical-activity-summary')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('child-learning-activity-summary')),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byKey(const Key('child-memory-counts')));
    expect(find.byKey(const Key('child-memory-counts')), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const Key('child-caregiver-preference-N01')),
    );
    expect(
      find.byKey(const Key('child-caregiver-preference-N01')),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byKey(const Key('child-hazard-outcome')));
    expect(find.byKey(const Key('child-hazard-outcome')), findsOneWidget);
  });

  testWidgets('desktop exposes the complete V4 childhood record', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final Simulation childhood = await _v4GuiSimulation(tester);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
        requireBirthSelection: false,
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
        initialSimulation: childhood,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('wide-layout')), findsOneWidget);
    expect(find.byKey(const Key('child-intent-floor_play')), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav-1')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('child-development-stage')), findsOneWidget);
    expect(find.byKey(const Key('child-body-mass')), findsOneWidget);
    expect(find.byKey(const Key('child-activity-experience')), findsOneWidget);
    expect(
      find.byKey(const Key('child-physical-activity-summary')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('child-learning-activity-summary')),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byKey(const Key('child-memory-counts')));
    expect(find.byKey(const Key('child-memory-counts')), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const Key('child-caregiver-preference-N01')),
    );
    expect(
      find.byKey(const Key('child-caregiver-preference-N01')),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byKey(const Key('child-hazard-outcome')));
    expect(find.byKey(const Key('child-hazard-outcome')), findsOneWidget);
  });
}

Future<Simulation> _v4GuiSimulation(WidgetTester tester) async {
  final MemorySaveRepository repository = MemorySaveRepository();
  await tester.pumpWidget(
    RealityCultivationApp(
      requireBirthSelection: false,
      autoStart: false,
      autoRestore: false,
      saveRepository: repository,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('nav-4')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('save-world')));
  await tester.pumpAndSettle();

  final Simulation simulation = Simulation.fromSave(repository.value!)
    ..advanceTo(const SimTime(31 * gameSecondsPerDay + 60));
  final ChildhoodState base = simulation.state.people['P00']!.childhood!;
  final int now = simulation.state.now.seconds;
  final ChildhoodState representative = ChildhoodState(
    startedAtSeconds: base.startedAtSeconds,
    lastAdvancedAgeDays: 1100,
    security: 820,
    grossMotor: 510,
    fineMotor: 430,
    receptiveLanguage: 620,
    expressiveLanguage: 470,
    observationExperience: 18,
    movementPractice: 12,
    languageExposure: 9,
    playExperience: 7,
    body: const ChildBodyState(
      massGrams: 14920,
      expectedMassGrams: 15300,
      nutrition: 780,
      hydration: 840,
      totalFoodGrams: 198000,
      totalWaterMl: 742000,
      supportedGrowthDays: 814,
      constrainedGrowthDays: 256,
      lastFoodGrams: 310,
      lastWaterMl: 980,
      lastGrowthGrams: 5,
    ),
    maturationProgressPerMille: 1012000,
    completedPhysicalActivities: 19,
    successfulPhysicalActivities: 15,
    failedPhysicalActivities: 4,
    completedLearningActivities: 27,
    successfulLearningActivities: 21,
    failedLearningActivities: 6,
    lastIntent: ChildIntent.floorPlay,
    lastIntentAtSeconds: now - 3600,
    lastOutcome: 'failed',
    lastActivityRoomId: 'R-HOME',
    lastActivityItemId: 'I-CHILD-P00-PLAY-01',
    lastActivityDurationSeconds: ChildIntent.floorPlay.durationSeconds,
    lastLearnedConceptId: 'object:soft_play_object',
    lastLearningSourceId: 'I-CHILD-P00-PLAY-01',
    hazardIncidents: 3,
    hazardsNoticedBeforeHarm: 2,
    hazardsResolvedByCaregiver: 3,
    lastHazard: ChildHazardIncidentState(
      id: 'child-hazard-widget-fixture',
      kind: 'floor_balance_loss',
      detectedAtSeconds: now - 3500,
      noticedBeforeHarm: true,
      childReaction: 'stopped_and_reached_for_caregiver',
      severity: 180,
      outcome: 'soothed',
      caregiverId: 'N01',
      resolvedAtSeconds: now - 3400,
      securityChange: 35,
    ),
    recentMemories: <ChildMemoryEpisodeState>[
      ChildMemoryEpisodeState(
        id: 'memory-widget-recent',
        atSeconds: now - 3600,
        kind: ChildIntent.floorPlay.code,
        outcome: 'failed',
        summary: 'Mất thăng bằng khi chơi rồi tìm người chăm',
        importance: 650,
        sourceIds: const <String>['R-HOME', 'N01'],
      ),
    ],
    memoryAnchors: <ChildMemoryEpisodeState>[
      ChildMemoryEpisodeState(
        id: 'memory-widget-anchor',
        atSeconds: now - 12 * gameSecondsPerDay,
        kind: 'hazard_resolved',
        outcome: 'soothed',
        summary: 'Được người chăm trấn an sau nguy hiểm',
        importance: 800,
        sourceIds: const <String>['N01'],
      ),
    ],
    memorySummaries: <ChildMemorySummaryState>[
      ChildMemorySummaryState(
        periodIndex: 4,
        firstAtSeconds: now - 60 * gameSecondsPerDay,
        lastAtSeconds: now - 31 * gameSecondsPerDay,
        episodeCount: 23,
        successCount: 15,
        failureCount: 8,
        hazardCount: 2,
        kindCounts: const <String, int>{
          'observe': 10,
          'floor_play': 11,
          'hazard_resolved': 2,
        },
        sourceIds: const <String>['N01', 'I-CHILD-P00-PLAY-01'],
      ),
    ],
    compressedMemoryCount: 76,
  );
  final Map<String, Object?> save = (jsonDecode(simulation.state.save()) as Map)
      .cast<String, Object?>();
  final List<Object?> people = save['people']! as List<Object?>;
  final Map<String, Object?> player =
      (people.firstWhere((Object? value) => (value! as Map)['id'] == 'P00')!
              as Map)
          .cast<String, Object?>();
  player['childhood'] = representative.toJson();
  player['family_relationships'] = <String, String>{
    ...((player['family_relationships'] as Map?)?.cast<String, String>() ??
        const <String, String>{}),
    'N01': 'mother',
  };
  return Simulation.fromSave(jsonEncode(save));
}
