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
    expect(find.text('15000 g'), findsWidgets);
    expect(find.byKey(const Key('member-profile-N01')), findsOneWidget);
    expect(find.byKey(const Key('item-profile-I-FOOD-01')), findsOneWidget);
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('save-world')), findsOneWidget);
    expect(find.byKey(const Key('load-world')), findsOneWidget);
    expect(find.byKey(const Key('new-world')), findsOneWidget);
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
    await tester.tap(find.byKey(const Key('nav-3')));
    await tester.pumpAndSettle();
    expect(find.text('Lịch sử đã xảy ra'), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Hộ gia đình'));
    await tester.pump();
    expect(find.text('Hộ gia đình hình thành'), findsOneWidget);
    expect(find.text('Nhân vật tồn tại'), findsNothing);
  });

  testWidgets('manual save restores the exact earlier infant intent', (
    WidgetTester tester,
  ) async {
    final MemorySaveRepository repository = MemorySaveRepository();
    await tester.pumpWidget(
      RealityCultivationApp(
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
      RealityCultivationApp(autoStart: false, saveRepository: repository),
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
        autoStart: false,
        autoRestore: false,
        saveRepository: repository,
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-world')));
    await tester.pumpAndSettle();
    final Simulation delayedJourney = Simulation.fromSave(
      repository.value!,
    )..advanceTo(const SimTime(5 * gameSecondsPerDay + gameSecondsPerDay ~/ 3));

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      RealityCultivationApp(
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
    expect(find.textContaining('đang bị trễ'), findsOneWidget);
    expect(find.textContaining('trễ 6 giờ'), findsOneWidget);
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
        autoStart: false,
        autoRestore: false,
        saveRepository: MemorySaveRepository(),
      ),
    );
    await tester.tap(find.byKey(const Key('nav-4')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('people-directory')), findsOneWidget);
    expect(find.byKey(const Key('item-directory')), findsOneWidget);
    for (final String id in <String>['P00', 'N01', 'N02', 'N03', 'N04']) {
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
      find.textContaining('1 vật nằm ngoài sổ kho của hộ'),
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

    await tester.tap(find.byKey(const Key('nav-3')));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Nhịp sống'));
    await tester.pump();
    expect(find.text('Hộ lập kế hoạch trong ngày'), findsWidgets);
    expect(find.text('Hộ hoàn tất bữa ăn'), findsNothing);
  });
}
