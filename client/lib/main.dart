import 'dart:async';

import 'package:flutter/material.dart' hide Simulation;
import 'package:reality_cultivation/reality_cultivation.dart';

import 'save_repository.dart';

void main() => runApp(const RealityCultivationApp());

class RealityCultivationApp extends StatelessWidget {
  const RealityCultivationApp({
    super.key,
    this.autoStart = true,
    this.autoRestore = true,
    this.requireBirthSelection = true,
    this.saveRepository,
    this.initialSimulation,
  });

  final bool autoStart;
  final bool autoRestore;
  final bool requireBirthSelection;
  final SaveRepository? saveRepository;
  final Simulation? initialSimulation;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Reality Cultivation',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xffc6a56a),
        brightness: Brightness.dark,
        surface: const Color(0xff171b16),
      ),
      scaffoldBackgroundColor: const Color(0xff0d100d),
      cardTheme: CardThemeData(
        color: const Color(0xff171c17),
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Color(0xff2b342b)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff101410),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Color(0xff111611),
        indicatorColor: Color(0xff3b4430),
        height: 70,
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: Color(0xff101410),
        indicatorColor: Color(0xff3b4430),
        useIndicator: true,
      ),
      dividerTheme: const DividerThemeData(color: Color(0xff2b342b)),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xff111611),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xff30382b),
      ),
      useMaterial3: true,
    ),
    home: GameScreen(
      autoStart: autoStart,
      autoRestore: autoRestore,
      requireBirthSelection: requireBirthSelection,
      saveRepository: saveRepository ?? SharedPreferencesSaveRepository(),
      initialSimulation: initialSimulation,
    ),
  );
}

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.autoStart,
    required this.autoRestore,
    required this.requireBirthSelection,
    required this.saveRepository,
    this.initialSimulation,
  });

  final bool autoStart;
  final bool autoRestore;
  final bool requireBirthSelection;
  final SaveRepository saveRepository;
  final Simulation? initialSimulation;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  late Simulation _simulation;
  late SimulationHost _host;
  late SimulationClock _clock;
  late RealTimeSimulationRunner _runner;
  final TextEditingController _goalController = TextEditingController();
  int _commandSequence = 0;
  bool _resumeAfterLifecycle = false;
  bool _bound = false;
  bool _ready = false;
  int _sectionIndex = 0;
  String _saveStatus = 'Chưa có bản lưu trong phiên này.';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bindSimulation(
      widget.initialSimulation ??
          _newSimulation(awaitBirthSelection: widget.requireBirthSelection),
    );
    unawaited(_initialize());
  }

  Simulation _newSimulation({
    int seed = 20260907,
    bool awaitBirthSelection = true,
  }) {
    final GeneratedWorld generated = WorldGenerator.generate(rootSeed: seed);
    final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
      rootSeed: seed,
      worldFingerprint: generated.fingerprint,
    );
    final WorldSite home = generated.site('SITE-HOME');
    final WorldSite river = generated.site('SITE-RIVER');
    final WorldSite field = generated.site('SITE-FIELD');
    final WorldSite pass = generated.site('SITE-PASS');
    final WorldSite market = generated.site('SITE-MARKET');
    final Simulation simulation = Simulation.fromSeed(seed)
      ..materializeWorld(generated)
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: <String, Object?>{
        'room_id': 'ROOM-SLEEP',
        'name': 'Gian ngủ',
        'household_id': 'H01',
        'anchor_position_mm': home.center.xMm,
        'anchor_position_y_mm': home.center.yMm,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: <String, Object?>{
        'room_id': 'ROOM-KITCHEN',
        'name': 'Gian bếp',
        'household_id': 'H01',
        'anchor_position_mm': home.center.xMm + 5000,
        'anchor_position_y_mm': home.center.yMm,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'room_created',
      payload: <String, Object?>{
        'room_id': 'ROOM-YARD',
        'name': 'Sân và kho củi',
        'household_id': 'H01',
        'anchor_position_mm': home.center.xMm + 12000,
        'anchor_position_y_mm': home.center.yMm,
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'route_created',
      payload: <String, Object?>{
        'route': <String, Object?>{
          'id': 'RT-ANKHE',
          'name': 'Tuyến chợ An Khê',
          'origin_id': 'WP-CHO',
          'destination_id': 'WP-SAN',
          'waypoints': <Map<String, Object?>>[
            <String, Object?>{
              'id': 'WP-CHO',
              'name': 'Chợ An Khê',
              'position_mm': market.center.xMm,
              'position_y_mm': market.center.yMm,
            },
            <String, Object?>{
              'id': 'WP-DEO',
              'name': 'Chân đèo',
              'position_mm': pass.center.xMm,
              'position_y_mm': pass.center.yMm,
            },
            <String, Object?>{
              'id': 'WP-SUOI',
              'name': 'Khúc lội suối',
              'position_mm': river.center.xMm,
              'position_y_mm': river.center.yMm,
            },
            <String, Object?>{
              'id': 'WP-DONG',
              'name': 'Đồng ngoài',
              'position_mm': field.center.xMm,
              'position_y_mm': field.center.yMm,
            },
            <String, Object?>{
              'id': 'WP-SAN',
              'name': 'Sân hộ',
              'position_mm': home.center.xMm + 12000,
              'position_y_mm': home.center.yMm,
            },
          ],
          'legs': <Map<String, Object?>>[
            <String, Object?>{
              'from_id': 'WP-CHO',
              'to_id': 'WP-DEO',
              'terrain': 'duong_bang',
              'terrain_speed_per_mille': 1000,
            },
            <String, Object?>{
              'from_id': 'WP-DEO',
              'to_id': 'WP-SUOI',
              'terrain': 'duong_nui',
              'terrain_speed_per_mille': 400,
            },
            <String, Object?>{
              'from_id': 'WP-SUOI',
              'to_id': 'WP-SAN',
              'terrain': 'loi_suoi',
              'terrain_speed_per_mille': 600,
            },
            // Ngã rẽ: từ chân đèo có thể đi vòng qua đồng ngoài, dài hơn
            // nhưng bằng phẳng nên thường nhanh hơn.
            <String, Object?>{
              'from_id': 'WP-DEO',
              'to_id': 'WP-DONG',
              'terrain': 'duong_bang',
              'terrain_speed_per_mille': 1000,
            },
            <String, Object?>{
              'from_id': 'WP-DONG',
              'to_id': 'WP-SAN',
              'terrain': 'duong_bang',
              'terrain_speed_per_mille': 1000,
            },
          ],
        },
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': 'N01',
        'name': 'Người chăm sóc',
        'birth_seconds': -25 * 365 * gameSecondsPerDay,
        'position_mm': home.center.xMm + 5000,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-KITCHEN',
        'household_id': 'H01',
        'caregiver_agent': true,
        'hearing_threshold': 300,
        'movement_speed_mm_per_second': 1000,
        'current_activity': 'chuẩn bị bữa ăn',
        'care_skill': 800,
        'routine': _routineN01,
        'skills': <String, int>{'fetch_water': 700, 'gather_food': 300},
        'agenda': <String, Object?>{'fatigue': 0},
        'adult_body': <String, Object?>{'mass_g': 52000},
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': 'N02',
        'name': 'Người nấu ăn',
        'birth_seconds': -31 * 365 * gameSecondsPerDay,
        'position_mm': home.center.xMm + 5000,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-KITCHEN',
        'household_id': 'H01',
        'caregiver_agent': true,
        'care_skill': 520,
        'current_activity': 'chuẩn bị bữa ăn',
        'routine': _routineN02,
        'skills': <String, int>{
          'cook': 900,
          'gather_fuel': 150,
          'fetch_water': 400,
          'gather_food': 400,
        },
        'agenda': <String, Object?>{'fatigue': 0},
        'adult_body': <String, Object?>{'mass_g': 49000},
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': 'N03',
        'name': 'Người làm công',
        'birth_seconds': -28 * 365 * gameSecondsPerDay,
        'position_mm': home.center.xMm + 12000,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-YARD',
        'household_id': 'H01',
        'routine': _routineN03,
        'skills': <String, int>{
          'gather_fuel': 850,
          'gather_food': 700,
          'fetch_water': 600,
        },
        'agenda': <String, Object?>{'fatigue': 850},
        'adult_body': <String, Object?>{
          'mass_g': 55000,
          'energy_reserve_kj': 30000,
        },
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'person_created',
      payload: <String, Object?>{
        'person_id': 'N04',
        'name': 'Người vận chuyển',
        'birth_seconds': -34 * 365 * gameSecondsPerDay,
        'position_mm': market.center.xMm,
        'position_y_mm': market.center.yMm,
        'adult_body': <String, Object?>{'mass_g': 54000},
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': 'I-FEED-01',
        'kind': 'infant_feed',
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': 10000,
        'energy_kj_per_100ml': 300,
        'water_ml_per_100ml': 92,
        'unit': 'ml',
        'owner_household_id': 'H01',
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': 'I-CLOTH-01',
        'kind': 'swaddling_cloth',
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': 1,
        'condition': 1000,
        'owner_household_id': 'H01',
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': 'I-FOOD-01',
        'kind': 'staple_food',
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': 15000,
        'unit': 'g',
        'owner_household_id': 'H01',
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': 'I-WATER-01',
        'kind': 'clean_water',
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': 48000,
        'unit': 'ml',
        'owner_household_id': 'H01',
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'item_created',
      payload: <String, Object?>{
        'item_id': 'I-FUEL-01',
        'kind': 'firewood',
        'position_mm': home.center.xMm,
        'position_y_mm': home.center.yMm,
        'room_id': 'ROOM-SLEEP',
        'quantity': 4500,
        'unit': 'g',
        'owner_household_id': 'H01',
      },
    )
    ..schedule(
      due: const SimTime(0),
      phase: EventPhase.completion,
      kind: 'household_created',
      payload: const <String, Object?>{
        'household_id': 'H01',
        'name': 'Hộ ven suối',
        'member_ids': <String>['N01', 'N02', 'N03'],
        'resource_item_ids': <String, String>{
          'food': 'I-FOOD-01',
          'water': 'I-WATER-01',
          'fuel': 'I-FUEL-01',
          'infant_feed': 'I-FEED-01',
        },
        'authorized_users_by_item_id': <String, List<String>>{
          'I-FOOD-01': <String>['N02', 'N03'],
          // N03 chưa được ghi quyền lấy nước, nên sẽ khát dần rồi đổ bệnh.
          'I-WATER-01': <String>['N01', 'N02'],
          'I-FUEL-01': <String>['N02', 'N03'],
          'I-FEED-01': <String>['N01', 'N02'],
          'I-CLOTH-01': <String>['N01', 'N02'],
        },
        'scheduled_work_seconds_by_person': <String, int>{
          'N01': 28800,
          'N02': 28800,
          'N03': 28800,
        },
        'meal_actor_id': 'N02',
        'enable_v2_1': true,
        'enable_v2_2': true,
        'auto_plan': true,
        'enable_v2_6': true,
        'enable_v2_11': true,
        'enable_v2_13': true,
        'infant_id': 'P00',
        'caregiver_id': 'N01',
        'production_actor_id': 'N03',
        'supply_carrier_id': 'N04',
        'supply_route_id': 'RT-ANKHE',
      },
    )
    ..simulatePrehistory(history)
    ..openWorldEntry();

    simulation.advanceTo(const SimTime(0));
    if (!awaitBirthSelection) {
      simulation.issue(
        const ChooseBirthSiteCommand(
          id: 'bootstrap-birth-site',
          siteId: 'SITE-HOME',
        ),
      );
      simulation.advanceTo(const SimTime(0));
    }

    return simulation;
  }

  void _bindSimulation(Simulation simulation) {
    if (_bound) _runner.stop();
    _simulation = simulation;
    _host = SimulationHost(_simulation);
    _clock = SimulationClock(simulation: _simulation);
    _runner = RealTimeSimulationRunner(
      clock: _clock,
      onPulse: (_) {
        if (mounted) setState(() {});
      },
    );
    _bound = true;
  }

  Future<void> _initialize() async {
    if (widget.autoRestore) {
      try {
        final String? source = await widget.saveRepository.readLatest();
        if (!mounted) return;
        if (source != null) {
          _bindSimulation(Simulation.fromSave(source));
          _saveStatus = 'Đã khôi phục bản lưu gần nhất.';
        }
      } on Object catch (error) {
        _saveStatus = 'Không thể khôi phục: $error';
      }
    }
    _ready = true;
    if (!mounted) return;
    if (widget.autoStart && _host.person('P00') != null) _runner.start();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_resumeAfterLifecycle) _runner.start();
      _resumeAfterLifecycle = false;
      return;
    }
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _resumeAfterLifecycle = _resumeAfterLifecycle || _runner.running;
      _runner.pause();
      if (_ready) unawaited(_save(announce: false));
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _runner.stop();
    _goalController.dispose();
    super.dispose();
  }

  void _toggleClock() {
    if (!_ready) return;
    setState(() {
      if (_runner.running) {
        _runner.pause();
      } else {
        _runner.start();
      }
    });
  }

  void _submitGoal() {
    final String goal = _goalController.text.trim();
    if (goal.isEmpty) return;
    final String commandId =
        'ui-goal-${_simulation.state.revision}-$_commandSequence';
    _commandSequence++;
    final CommandResult result = _host.submit(
      SetGoalCommand(id: commandId, personId: 'P00', goal: goal),
    );
    setState(() {
      if (result.accepted) _goalController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _submitInfantIntent(InfantIntent intent) {
    final String commandId =
        'ui-infant-${_simulation.state.revision}-$_commandSequence';
    _commandSequence++;
    final CommandResult result = _host.submit(
      InfantIntentCommand(id: commandId, personId: 'P00', intent: intent),
    );
    setState(() {});
    _showMessage(result.message);
  }

  Future<void> _chooseBirthSite(String siteId) async {
    if (!_ready) return;
    final String commandId =
        'ui-birth-site-${_simulation.state.revision}-$_commandSequence';
    _commandSequence++;
    final CommandResult result = _host.submit(
      ChooseBirthSiteCommand(id: commandId, siteId: siteId),
    );
    if (!result.accepted) {
      if (mounted) _showMessage(result.message);
      return;
    }
    _simulation.advanceTo(_simulation.state.now);
    Object? saveError;
    try {
      await widget.saveRepository.writeLatest(_simulation.state.save());
    } on Object catch (error) {
      saveError = error;
    }
    if (!mounted) return;
    if (widget.autoStart) _runner.start();
    setState(() {
      _saveStatus = saveError == null
          ? 'Đã sinh vào ngày 0 · ${_simulation.state.semanticHash()}'
          : 'Đã sinh nhưng lưu thất bại: $saveError';
    });
    _showMessage(
      saveError == null
          ? 'Bạn đã sinh ra trong thế giới này.'
          : 'Bạn đã sinh ra, nhưng chưa lưu được thế giới.',
    );
  }

  Future<void> _save({bool announce = true}) async {
    final String snapshot = _simulation.state.save();
    final int savedDay = _simulation.state.now.day;
    final String hash = _simulation.state.semanticHash();
    try {
      await widget.saveRepository.writeLatest(snapshot);
      if (!mounted) return;
      setState(() {
        _saveStatus = 'Đã lưu ngày $savedDay · $hash';
      });
      if (announce) _showMessage('Đã lưu thế giới.');
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _saveStatus = 'Lưu thất bại: $error');
      if (announce) _showMessage('Không thể lưu thế giới.');
    }
  }

  Future<void> _load() async {
    final bool wasRunning = _runner.running;
    _runner.pause();
    try {
      final String? source = await widget.saveRepository.readLatest();
      if (!mounted) return;
      if (source == null) {
        if (wasRunning) _runner.start();
        if (mounted) _showMessage('Chưa có bản lưu để tải.');
        return;
      }
      final Simulation restored = Simulation.fromSave(source);
      _bindSimulation(restored);
      if (wasRunning && _host.person('P00') != null) _runner.start();
      setState(() {
        _saveStatus =
            'Đã tải ngày ${restored.state.now.day} · ${restored.state.semanticHash()}';
      });
      _showMessage('Đã tải bản lưu gần nhất.');
    } on Object catch (error) {
      if (wasRunning) _runner.start();
      if (!mounted) return;
      setState(() => _saveStatus = 'Tải thất bại: $error');
      _showMessage('Bản lưu không hợp lệ.');
    }
  }

  Future<void> _confirmNewWorld() async {
    String seedText = _simulation.state.seed.toString();
    String? seedError;
    final int? seed = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) =>
            AlertDialog(
              title: const Text('Tạo thế giới mới?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Seed quyết định kích thước vùng, vị trí và bán kính địa điểm. '
                    'Dùng lại cùng seed sẽ sinh đúng cùng một bản đồ.',
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const Key('world-seed-field'),
                    onChanged: (String value) => seedText = value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Seed thế giới',
                      hintText: seedText,
                      errorText: seedError,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Giữ thế giới cũ'),
                ),
                FilledButton(
                  key: const Key('confirm-new-world'),
                  onPressed: () {
                    final int? value = int.tryParse(seedText.trim());
                    if (value == null) {
                      setDialogState(
                        () => seedError = 'Hãy nhập một số nguyên.',
                      );
                      return;
                    }
                    if (value < minimumWorldSeed ||
                        value > maximumWorldSeed) {
                      setDialogState(
                        () => seedError =
                            'Seed từ $minimumWorldSeed đến $maximumWorldSeed.',
                      );
                      return;
                    }
                    Navigator.pop(context, value);
                  },
                  child: const Text('Tạo mới'),
                ),
              ],
            ),
      ),
    );
    if (seed == null || !mounted) return;
    final bool wasRunning = _runner.running;
    _runner.stop();
    _bindSimulation(
      _newSimulation(
        seed: seed,
        awaitBirthSelection: widget.requireBirthSelection,
      ),
    );
    _commandSequence = 0;
    await widget.saveRepository.writeLatest(_simulation.state.save());
    if (!mounted) return;
    if (wasRunning && _host.person('P00') != null) _runner.start();
    setState(() {
      _sectionIndex = 0;
      _saveStatus = 'Đã tạo và lưu thế giới seed $seed từ ngày 0.';
    });
    _showMessage('Đã tạo thế giới mới từ seed $seed.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final WorldView world = _host.world();
    final WorldEntryView? entry = _host.worldEntry();
    final PersonView? playerState = _host.person('P00');
    if (entry?.state.awaitingBirthSite == true && playerState == null) {
      return _BirthSelectionScreen(
        entry: entry!,
        world: world,
        worldMap: _host.worldMap(),
        history: _host.worldHistory(),
        ready: _ready,
        onChoose: (String siteId) => unawaited(_chooseBirthSite(siteId)),
        onNewWorld: () => unawaited(_confirmNewWorld()),
      );
    }
    if (playerState == null) {
      return const Scaffold(
        body: Center(child: Text('Bản lưu không có nhân vật người chơi.')),
      );
    }
    final PersonView player = playerState;
    final HouseholdView? household = _host.household('H01');
    final List<WorldFact> facts = _host.recentFacts(limit: 50);
    final _CommandPanel command = _CommandPanel(
      controller: _goalController,
      onSubmit: _submitGoal,
      infancy: player.infancy,
      onInfantIntent: _submitInfantIntent,
      enabled: _ready,
    );
    final _SavePanel saves = _SavePanel(
      status: _saveStatus,
      enabled: _ready,
      onSave: () => unawaited(_save()),
      onLoad: () => unawaited(_load()),
      onNewWorld: () => unawaited(_confirmNewWorld()),
    );
    final List<Widget> pages = <Widget>[
      _OverviewPage(
        key: const ValueKey<int>(0),
        world: world,
        player: player,
        household: household,
        command: command,
        facts: facts,
      ),
      _PageFrame(
        key: const ValueKey<int>(1),
        eyebrow: 'HỒ SƠ SỐNG',
        title: 'Nhân vật',
        subtitle: 'Sinh lý, giác quan và trạng thái mà nhân vật có thể biết.',
        child: _StatusPanel(world: world, player: player),
      ),
      _PageFrame(
        key: const ValueKey<int>(2),
        eyebrow: 'ĐỜI SỐNG CHUNG',
        title: 'Hộ gia đình',
        subtitle: 'Con người, kho vật chất, quyền sử dụng và công việc.',
        child: _HouseholdPanel(household: household),
      ),
      _PageFrame(
        key: const ValueKey<int>(3),
        eyebrow: 'DẤU VẾT THẾ GIỚI',
        title: 'Nhật ký',
        subtitle: 'Những việc đã thật sự xảy ra trong mô phỏng.',
        child: _HistoryPanel(facts: facts),
      ),
      _ProfilePage(
        key: const ValueKey<int>(4),
        saves: saves,
        world: world,
        directory: _host.directory(),
        worldMap: _host.worldMap(),
        history: _host.worldHistory(),
      ),
    ];
    final int secondsOfDay = world.time.seconds % gameSecondsPerDay;
    final String clockText =
        '${(secondsOfDay ~/ 3600).toString().padLeft(2, '0')}:'
        '${((secondsOfDay % 3600) ~/ 60).toString().padLeft(2, '0')}';
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: MediaQuery.sizeOf(context).width < 600
            ? const Text('Tu tiên', style: TextStyle(fontSize: 17))
            : Row(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xffc6a56a).withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xff5d5137)),
                    ),
                    child: const Icon(Icons.auto_awesome, size: 19),
                  ),
                  const SizedBox(width: 11),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Reality Cultivation',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'PHÀM GIỚI · HỘ VEN SUỐI',
                        style: TextStyle(fontSize: 9, letterSpacing: 1.4),
                      ),
                    ],
                  ),
                ],
              ),
        actions: <Widget>[
          if (MediaQuery.sizeOf(context).width >= 600)
            _TopTime(day: world.time.day, time: clockText),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 12),
            child: FilledButton.tonalIcon(
              key: const Key('clock-toggle'),
              onPressed: _ready ? _toggleClock : null,
              icon: Icon(_runner.running ? Icons.pause : Icons.play_arrow),
              label: Text(_runner.running ? 'Dừng' : 'Chạy'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget page = AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: pages[_sectionIndex],
            );
            if (constraints.maxWidth < 760) {
              return Container(
                key: const Key('narrow-layout'),
                color: const Color(0xff0d100d),
                child: page,
              );
            }
            final bool extended = constraints.maxWidth >= 1160;
            return Row(
              key: const Key('wide-layout'),
              children: <Widget>[
                NavigationRail(
                  extended: extended,
                  minExtendedWidth: 214,
                  selectedIndex: _sectionIndex,
                  onDestinationSelected: (int value) =>
                      setState(() => _sectionIndex = value),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: _RunIndicator(running: _runner.running),
                  ),
                  destinations: <NavigationRailDestination>[
                    for (int index = 0; index < _destinations.length; index++)
                      NavigationRailDestination(
                        icon: Icon(
                          _destinations[index].icon,
                          key: Key('nav-$index'),
                        ),
                        selectedIcon: Icon(
                          _destinations[index].selectedIcon,
                          key: Key('nav-selected-$index'),
                        ),
                        label: Text(_destinations[index].label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: page),
                if (constraints.maxWidth >= 1080) ...<Widget>[
                  const VerticalDivider(width: 1),
                  SizedBox(
                    width: 260,
                    child: _WorldSidebar(
                      world: world,
                      player: player,
                      household: household,
                      running: _runner.running,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 760
          ? NavigationBar(
              key: const Key('mobile-navigation'),
              selectedIndex: _sectionIndex,
              onDestinationSelected: (int value) =>
                  setState(() => _sectionIndex = value),
              destinations: <NavigationDestination>[
                for (int index = 0; index < _destinations.length; index++)
                  NavigationDestination(
                    icon: Icon(
                      _destinations[index].icon,
                      key: Key('nav-$index'),
                    ),
                    selectedIcon: Icon(
                      _destinations[index].selectedIcon,
                      key: Key('nav-selected-$index'),
                    ),
                    label: _destinations[index].shortLabel,
                  ),
              ],
            )
          : null,
    );
  }
}

/// Nhịp sống hằng ngày của hộ ven suối. Giờ giấc và mức ưu tiên là fixture
/// kỹ thuật để xung đột lịch quan sát được, chưa phải cân bằng đã chốt.
const List<Map<String, Object?>> _routineN01 = <Map<String, Object?>>[
  <String, Object?>{
    'id': 'R-N01-SAN',
    'activity': 'quét sân',
    'start_second_of_day': 22500,
    'duration_seconds': 1800,
    'room_id': 'ROOM-YARD',
    'priority': 20,
  },
  <String, Object?>{
    'id': 'R-N01-VA',
    'activity': 'may vá',
    'start_second_of_day': 25200,
    'duration_seconds': 35400,
    'room_id': 'ROOM-KITCHEN',
    'priority': 30,
  },
];

const List<Map<String, Object?>> _routineN02 = <Map<String, Object?>>[
  <String, Object?>{
    'id': 'R-N02-SANG',
    'activity': 'nấu bữa sáng',
    'start_second_of_day': 21600,
    'duration_seconds': 5400,
    'room_id': 'ROOM-KITCHEN',
    'priority': 70,
  },
  <String, Object?>{
    'id': 'R-N02-TOI',
    'activity': 'nấu bữa tối',
    'start_second_of_day': 61200,
    'duration_seconds': 7200,
    'room_id': 'ROOM-KITCHEN',
    'priority': 70,
  },
];

const List<Map<String, Object?>> _routineN03 = <Map<String, Object?>>[
  <String, Object?>{
    'id': 'R-N03-DUNG-CU',
    'activity': 'kiểm tra dụng cụ',
    'start_second_of_day': 18000,
    'duration_seconds': 1800,
    'room_id': 'ROOM-YARD',
    'priority': 80,
  },
  <String, Object?>{
    'id': 'R-N03-MAI',
    'activity': 'sửa mái',
    'start_second_of_day': 21600,
    'duration_seconds': 43200,
    'room_id': 'ROOM-YARD',
    'priority': 25,
  },
];

class _Destination {
  const _Destination(this.label, this.shortLabel, this.icon, this.selectedIcon);

  final String label;
  final String shortLabel;
  final IconData icon;
  final IconData selectedIcon;
}

const List<_Destination> _destinations = <_Destination>[
  _Destination('Hiện tại', 'Hiện tại', Icons.home_outlined, Icons.home),
  _Destination('Nhân vật', 'Nhân vật', Icons.person_outline, Icons.person),
  _Destination('Hộ gia đình', 'Hộ', Icons.cottage_outlined, Icons.cottage),
  _Destination('Nhật ký', 'Nhật ký', Icons.menu_book_outlined, Icons.menu_book),
  _Destination('Hồ sơ', 'Hồ sơ', Icons.inventory_2_outlined, Icons.inventory_2),
];

class _TopTime extends StatelessWidget {
  const _TopTime({required this.day, required this.time});

  final int day;
  final String time;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xff171c17),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xff2b342b)),
    ),
    child: Text(
      'Ngày $day  ·  $time',
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    ),
  );
}

class _RunIndicator extends StatelessWidget {
  const _RunIndicator({required this.running});

  final bool running;

  @override
  Widget build(BuildContext context) => Semantics(
    label: running ? 'Thế giới đang chạy' : 'Thế giới đang dừng',
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: running ? const Color(0xff183024) : const Color(0xff30271b),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            running ? Icons.play_circle_fill : Icons.pause_circle_filled,
            size: 16,
            color: running ? const Color(0xff82c99a) : const Color(0xffd4ae72),
          ),
          const SizedBox(width: 7),
          Text(
            running ? 'ĐANG CHẠY' : 'ĐANG DỪNG',
            style: const TextStyle(fontSize: 10, letterSpacing: 1),
          ),
        ],
      ),
    ),
  );
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage({
    super.key,
    required this.world,
    required this.player,
    required this.household,
    required this.command,
    required this.facts,
  });

  final WorldView world;
  final PersonView player;
  final HouseholdView? household;
  final Widget command;
  final List<WorldFact> facts;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    key: const Key('overview-scroll'),
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _HeroCard(world: world, player: player),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget attention = _AttentionCard(player: player);
                if (constraints.maxWidth < 680) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      command,
                      const SizedBox(height: 14),
                      attention,
                    ],
                  );
                }
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(flex: 3, child: command),
                      const SizedBox(width: 14),
                      Expanded(flex: 2, child: attention),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _ResourceStrip(household: household),
            const SizedBox(height: 14),
            _RecentStoryCard(facts: facts),
          ],
        ),
      ),
    ),
  );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.world, required this.player});

  final WorldView world;
  final PersonView player;

  @override
  Widget build(BuildContext context) {
    final InfantView? infant = player.infancy;
    final String state = infant == null
        ? 'Đang sinh hoạt'
        : infant.crying
        ? 'Đang khóc'
        : infant.awake
        ? 'Đang thức'
        : 'Đang ngủ';
    final double dayProgress =
        (world.time.seconds % gameSecondsPerDay) / gameSecondsPerDay;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xff24261b), Color(0xff172019)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: const Color(0xff4a4933)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'HIỆN TẠI',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 2,
              color: Color(0xffc6a56a),
            ),
          ),
          const SizedBox(height: 9),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Widget identity = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    player.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sơ sinh · ${player.ageSeconds ~/ gameSecondsPerDay} ngày tuổi · Hộ ven suối',
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Mục tiêu hiện tại: ${player.activeGoal ?? 'Chưa có'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
              final Widget pill = _StatusPill(
                label: state,
                urgent: infant?.crying ?? false,
              );
              if (constraints.maxWidth < 360) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    identity,
                    const SizedBox(height: 10),
                    pill,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: identity),
                  pill,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: dayProgress,
              minHeight: 5,
              backgroundColor: const Color(0xff101410),
              color: const Color(0xffc6a56a),
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: <Widget>[
              Text(
                'Ngày ${world.time.day}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${world.pendingEventCount} sự kiện đang chờ',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, this.urgent = false});

  final String label;
  final bool urgent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: urgent ? const Color(0xff4a2420) : const Color(0xff243326),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: urgent ? const Color(0xff8f4b43) : const Color(0xff3e5d45),
      ),
    ),
    child: Text(label, style: const TextStyle(fontSize: 12)),
  );
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({required this.player});

  final PersonView player;

  @override
  Widget build(BuildContext context) {
    final InfantView? infant = player.infancy;
    final bool pending = infant?.careResponsePending ?? false;
    final HealthView? health = player.health;
    final bool ill = health != null && health.stage != IllnessStage.resolved;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              pending
                  ? Icons.notifications_active_outlined
                  : Icons.spa_outlined,
              color: const Color(0xffc6a56a),
            ),
            const SizedBox(height: 14),
            Text(
              pending
                  ? 'Đang chờ chăm sóc'
                  : ill
                  ? 'Đang theo dõi bệnh nhẹ'
                  : 'Chưa có việc khẩn',
              key: pending ? const Key('care-response-pending') : null,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              pending
                  ? 'Tín hiệu đã đi vào thế giới. Người chăm sóc cần nghe, di chuyển và dùng đúng vật tư.'
                  : ill
                  ? '${_illnessKindLabel(health.kind)} ở mức ${health.severity}/1000; '
                        'thân nhiệt ${(health.bodyTemperatureMilliC / 1000).toStringAsFixed(2)} °C.'
                  : 'Các nhu cầu vẫn thay đổi theo sinh lý. Thế giới sẽ tạo cảnh báo khi có nguyên nhân đáng chú ý.',
            ),
            if (infant != null) ...<Widget>[
              const SizedBox(height: 18),
              Text(
                'Căng thẳng ${infant.distress}/1000 · Đã chăm ${infant.careInteractions} lần',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResourceStrip extends StatelessWidget {
  const _ResourceStrip({required this.household});

  final HouseholdView? household;

  @override
  Widget build(BuildContext context) {
    final HouseholdView? value = household;
    if (value == null) return const SizedBox.shrink();
    const Map<String, (String, IconData)> labels = <String, (String, IconData)>{
      'food': ('Lương thực', Icons.rice_bowl_outlined),
      'water': ('Nước sạch', Icons.water_drop_outlined),
      'fuel': ('Củi', Icons.local_fire_department_outlined),
      'infant_feed': ('Dinh dưỡng', Icons.local_drink_outlined),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Kho của hộ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '${value.mealsCompleted} bữa đã hoàn tất',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 13),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                for (final MapEntry<String, (String, IconData)> entry
                    in labels.entries)
                  _ResourceChip(
                    icon: entry.value.$2,
                    label: entry.value.$1,
                    value:
                        '${value.resourceQuantities[entry.key] ?? 0} ${value.resourceUnits[entry.key] ?? ''}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResourceChip extends StatelessWidget {
  const _ResourceChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 150),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xff111611),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18, color: const Color(0xff9fbd82)),
        const SizedBox(width: 9),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    ),
  );
}

class _RecentStoryCard extends StatelessWidget {
  const _RecentStoryCard({required this.facts});

  final List<WorldFact> facts;

  @override
  Widget build(BuildContext context) {
    final List<WorldFact> recent = facts.reversed.take(4).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Diễn biến gần đây',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final WorldFact fact in recent)
              Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xffc6a56a),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Ngày ${fact.time.day} · ${_factLabel(fact.kind)}',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              eyebrow,
              style: const TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                color: Color(0xffc6a56a),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xffaeb6aa)),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    ),
  );
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({
    super.key,
    required this.saves,
    required this.world,
    required this.directory,
    required this.worldMap,
    required this.history,
  });

  final Widget saves;
  final WorldView world;
  final WorldDirectoryView directory;
  final WorldMapView worldMap;
  final WorldHistoryView? history;

  @override
  Widget build(BuildContext context) => _PageFrame(
    eyebrow: 'THẾ GIỚI & HỆ THỐNG',
    title: 'Hồ sơ',
    subtitle:
        'Mọi người và mọi vật đã tồn tại, kể cả ngoài hộ, cùng bản lưu của thế giới.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        saves,
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Nhận dạng thế giới',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                SelectableText(
                  'Hash  ${world.semanticHash}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
                Text(
                  'Revision ${world.revision} · ${world.personCount} người · ${world.factCount} sự kiện đã ghi',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _WorldMapPanel(worldMap: worldMap),
        if (history != null) ...<Widget>[
          const SizedBox(height: 14),
          _WorldHistorySummary(
            history: history!,
            materializedPersonCount: world.personCount,
          ),
        ],
        const SizedBox(height: 14),
        Card(
          key: const Key('people-directory'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17, 17, 17, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _SectionLabel(label: 'NGƯỜI TRONG THẾ GIỚI'),
                const SizedBox(height: 6),
                Text(
                  '${directory.people.length} người đã được vật chất hóa · '
                  '${directory.outsideHousehold.length} người sống ngoài hộ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                for (final PersonProfileView person in directory.people)
                  _PersonProfileCard(person: person),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          key: const Key('item-directory'),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17, 17, 17, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _SectionLabel(label: 'VẬT PHẨM TRONG THẾ GIỚI'),
                const SizedBox(height: 6),
                Text(
                  '${directory.items.length} vật đã được vật chất hóa · '
                  '${directory.outsideLedger.length} vật nằm ngoài sổ kho của hộ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                for (final ItemProfileView item in directory.items)
                  _ItemProfileCard(item: item),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const _RoadmapCard(),
      ],
    ),
  );
}

class _BirthSelectionScreen extends StatelessWidget {
  const _BirthSelectionScreen({
    required this.entry,
    required this.world,
    required this.worldMap,
    required this.history,
    required this.ready,
    required this.onChoose,
    required this.onNewWorld,
  });

  final WorldEntryView entry;
  final WorldView world;
  final WorldMapView worldMap;
  final WorldHistoryView? history;
  final bool ready;
  final ValueChanged<String> onChoose;
  final VoidCallback onNewWorld;

  SiteMapView? _mapSite(String id) {
    for (final RegionMapView region in worldMap.regions) {
      for (final SiteMapView site in region.sites) {
        if (site.site.id == id) return site;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final WorldGenesisRecord? genesis = worldMap.genesis;
    return Scaffold(
      key: const Key('birth-site-selection'),
      appBar: AppBar(
        title: const Text('Reality Cultivation'),
        actions: <Widget>[
          TextButton.icon(
            key: const Key('entry-new-world'),
            onPressed: ready ? onNewWorld : null,
            icon: const Icon(Icons.casino_outlined),
            label: const Text('Seed khác'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compact = constraints.maxWidth < 760;
            final double contentWidth =
                (constraints.maxWidth - (compact ? 32 : 56))
                    .clamp(0, 1180)
                    .toDouble();
            final double cardWidth = compact
                ? contentWidth
                : (contentWidth - 16) / 2;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                compact ? 16 : 28,
                24,
                compact ? 16 : 28,
                40,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'THẾ GIỚI ĐÃ SỐNG TRƯỚC KHI BẠN ĐẾN',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: const Color(0xffc6a56a),
                              letterSpacing: 1.5,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Chọn nơi bạn sẽ chào đời',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Bản đồ, cư dân, căn phòng và vật tư đã được tạo trước. '
                        'Một nơi chỉ mở khi thật sự có hộ ở, người chăm và nguồn sữa.',
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Icon(Icons.public, size: 20),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Text(
                                      'Tạo thế giới hoàn tất · seed ${worldMap.genesis?.rootSeed ?? '-'}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${entry.feasibleSiteCount}/${entry.sites.length} nơi có thể sinh',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const LinearProgressIndicator(value: 1),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 14,
                                runSpacing: 7,
                                children: <Widget>[
                                  Text('${worldMap.regions.length} vùng'),
                                  Text('${worldMap.siteCount} địa điểm'),
                                  Text('${world.personCount} cư dân nền'),
                                  if (genesis != null)
                                    Text('Dấu sinh ${genesis.fingerprint}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (history != null) ...<Widget>[
                        _WorldHistorySummary(
                          history: history!,
                          materializedPersonCount: world.personCount,
                        ),
                        const SizedBox(height: 22),
                      ],
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: <Widget>[
                          for (final BirthSiteCandidate candidate
                              in entry.sites)
                            SizedBox(
                              width: cardWidth,
                              child: _BirthSiteCard(
                                key: Key('birth-site-${candidate.siteId}'),
                                candidate: candidate,
                                mapSite: _mapSite(candidate.siteId),
                                enabled: ready,
                                onChoose: () => onChoose(candidate.siteId),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorldHistorySummary extends StatelessWidget {
  const _WorldHistorySummary({
    required this.history,
    required this.materializedPersonCount,
  });

  final WorldHistoryView history;
  final int materializedPersonCount;

  String _effectText(HistoricalEffect effect) {
    final List<String> parts = <String>[];
    if (effect.populationDelta != 0) {
      parts.add('dân số ${effect.populationDelta > 0 ? '+' : ''}${effect.populationDelta}');
    }
    if (effect.cultivatedLandDelta != 0) {
      parts.add(
        'đất canh tác ${effect.cultivatedLandDelta > 0 ? '+' : ''}'
        '${effect.cultivatedLandDelta}',
      );
    }
    if (effect.tradeReachDelta != 0) {
      parts.add('giao thương +${effect.tradeReachDelta}');
    }
    if (effect.resourcePressureDelta != 0) {
      parts.add(
        'áp lực tài nguyên ${effect.resourcePressureDelta > 0 ? '+' : ''}'
        '${effect.resourcePressureDelta}',
      );
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final HistoricalMetrics? metrics = history.currentMetrics;
    return Card(
      key: const Key('world-history-summary'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.history, color: Color(0xffc6a56a)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${history.state.totalYears} năm tiền sử đã được mô phỏng',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  '${history.completedEpochCount}/${history.expectedEpochCount} epoch',
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: history.expectedEpochCount == 0
                  ? 0
                  : history.completedEpochCount / history.expectedEpochCount,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final HistoricalEpochResult epoch in history.state.epochs)
                  Chip(
                    key: Key('history-epoch-${epoch.id}'),
                    avatar: const Icon(Icons.check, size: 16),
                    label: Text(
                      '${epoch.name} · ${epoch.startYearsBeforePresent}–'
                      '${epoch.endYearsBeforePresent} năm trước',
                    ),
                  ),
              ],
            ),
            if (metrics != null) ...<Widget>[
              const SizedBox(height: 12),
              Wrap(
                spacing: 14,
                runSpacing: 7,
                children: <Widget>[
                  Text('Dân số vùng ước tính ${metrics.populationEstimate}'),
                  Text('Khoảng ${metrics.householdEstimate} hộ'),
                  Text('Đất canh tác ${metrics.cultivatedLandMu} mẫu'),
                  Text('Giao thương ${metrics.tradeReach}/1000'),
                  Text('Áp lực tài nguyên ${metrics.resourcePressure}/1000'),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Dân số trên là cohort vĩ mô; $materializedPersonCount người '
                'hiện đã có hồ sơ Person chi tiết.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 4),
            Text(
              'BIẾN CỐ NEO CÒN DẤU TRONG HIỆN TẠI',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.1,
                color: const Color(0xffc6a56a),
              ),
            ),
            const SizedBox(height: 8),
            for (final HistoricalAnchor anchor in history.anchors)
              Padding(
                key: Key('history-anchor-${anchor.id}'),
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 92,
                      child: Text(
                        '${anchor.yearsBeforePresent} năm trước',
                        style: const TextStyle(
                          color: Color(0xffc6a56a),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(anchor.summary),
                          const SizedBox(height: 3),
                          Text(
                            '${anchor.subjectId} · ${_effectText(anchor.effect)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 4),
            Text(
              'Dấu lịch sử ${history.state.planFingerprint}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _BirthSiteCard extends StatelessWidget {
  const _BirthSiteCard({
    super.key,
    required this.candidate,
    required this.mapSite,
    required this.enabled,
    required this.onChoose,
  });

  final BirthSiteCandidate candidate;
  final SiteMapView? mapSite;
  final bool enabled;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final WorldSite? site = mapSite?.site;
    final Color accent = candidate.feasible
        ? const Color(0xff9dbb73)
        : const Color(0xff8d9288);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: accent.withValues(alpha: .14),
                  foregroundColor: accent,
                  child: Icon(_siteIcon(candidate.siteKind), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        candidate.siteName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(_siteKindLabel(candidate.siteKind)),
                    ],
                  ),
                ),
                Icon(
                  candidate.feasible ? Icons.lock_open : Icons.lock_outline,
                  color: accent,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(candidate.reason),
            if (site != null) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                'Tọa độ ${_km(site.center.xMm)} km, '
                '${_km(site.center.yMm)} km · '
                '${mapSite!.population} người · ${mapSite!.roomNames.length} phòng',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (candidate.feasible) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                'Hộ ${candidate.householdId} · phòng ${candidate.roomId} · '
                'người chăm ${candidate.caregiverId}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: accent),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: Key('choose-birth-${candidate.siteId}'),
                onPressed: enabled && candidate.feasible ? onChoose : null,
                icon: Icon(
                  candidate.feasible ? Icons.child_care : Icons.lock_outline,
                ),
                label: Text(
                  candidate.feasible ? 'Sinh tại đây' : 'Chưa đủ điều kiện',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorldMapPanel extends StatelessWidget {
  const _WorldMapPanel({required this.worldMap});

  final WorldMapView worldMap;

  @override
  Widget build(BuildContext context) {
    if (worldMap.regions.isEmpty) {
      return const Card(
        key: Key('world-map'),
        child: Padding(
          padding: EdgeInsets.all(17),
          child: Text('Thế giới này chưa có vùng địa lý được vật chất hóa.'),
        ),
      );
    }
    return Card(
      key: const Key('world-map'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(17, 17, 17, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _SectionLabel(label: 'BẢN ĐỒ VÙNG'),
            const SizedBox(height: 6),
            Text(
              '${worldMap.regions.length} vùng · ${worldMap.siteCount} địa điểm · '
              '${worldMap.unplacedPeople} người đang ngoài mọi địa điểm',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (worldMap.genesis case final WorldGenesisRecord genesis) ...<Widget>[
              const SizedBox(height: 5),
              Text(
                'Seed ${genesis.rootSeed} · bộ sinh ${genesis.generatorVersion}\n'
                'Dấu vân tay ${genesis.fingerprint}',
                key: const Key('world-genesis'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            for (final RegionMapView region in worldMap.regions) ...<Widget>[
              Text(
                region.region.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${_km(region.region.widthMm)} km × '
                '${_km(region.region.heightMm)} km · '
                '${region.sites.length} địa điểm',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  for (final SiteMapView site in region.sites)
                    Chip(
                      avatar: Icon(_siteIcon(site.site.kind), size: 17),
                      label: Text(site.site.name),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              for (final SiteMapView site in region.sites)
                Card(
                  key: Key('map-site-${site.site.id}'),
                  color: const Color(0xff111611),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    leading: Icon(_siteIcon(site.site.kind)),
                    title: Text(site.site.name),
                    subtitle: Text(
                      '${_siteKindLabel(site.site.kind)} · '
                      '${site.population} người · ${site.itemCount} vật',
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tọa độ: (${_km(site.site.center.xMm)}, '
                          '${_km(site.site.center.yMm)}) km\n'
                          'Bán kính: ${_km(site.site.radiusMm)} km\n'
                          'Người: ${site.peopleNames.isEmpty ? 'không có' : site.peopleNames.join(', ')}\n'
                          'Phòng: ${site.roomNames.isEmpty ? 'không có' : site.roomNames.join(', ')}\n'
                          'Vật: ${site.itemKinds.isEmpty ? 'không có' : site.itemKinds.map(_itemKindLabel).join(', ')}',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

String _km(int millimetres) => (millimetres / 1000000).toStringAsFixed(2);

String _siteKindLabel(String kind) => switch (kind) {
  'household' => 'Khu cư trú',
  'market' => 'Chợ',
  'river' => 'Sông suối',
  'field' => 'Đồng ruộng',
  'pass' => 'Đèo',
  _ => kind,
};

IconData _siteIcon(String kind) => switch (kind) {
  'household' => Icons.cottage_outlined,
  'market' => Icons.storefront_outlined,
  'river' => Icons.water_outlined,
  'field' => Icons.grass_outlined,
  'pass' => Icons.landscape_outlined,
  _ => Icons.place_outlined,
};

class _PersonProfileCard extends StatelessWidget {
  const _PersonProfileCard({required this.person});

  final PersonProfileView person;

  @override
  Widget build(BuildContext context) {
    final TextStyle? small = Theme.of(context).textTheme.bodySmall;
    return Card(
      key: Key('person-profile-${person.id}'),
      color: const Color(0xff111611),
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text('${person.name} · ${person.id}'),
        subtitle: Text(
          person.inHousehold
              ? '${person.householdName ?? 'trong hộ'} · ${person.roomName ?? 'chưa rõ phòng'}'
              : 'Ngoài hộ · ${person.roomName ?? 'ngoài khu nhà'}',
          style: small,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tuổi: ${person.ageDays} ngày${person.isInfant ? ' (sơ sinh)' : ''}',
                ),
                Text(
                  'Đang làm: ${person.activity ?? 'chưa có việc được giao'}',
                ),
                if (person.positionMm != null)
                  Text('Vị trí: ${person.positionMm} mm trên trục nhà'),
                if (person.careSkill != null)
                  Text(
                    'Chăm sóc: ${person.available == false ? 'đang gián đoạn' : 'sẵn sàng'}'
                    ' · kỹ năng ${person.careSkill}/1000',
                  ),
                if (person.illnessKind != null) ...<Widget>[
                  Text(
                    'Sức khỏe: ${_illnessKindLabel(person.illnessKind!)}'
                    '${person.illnessStage == null ? '' : ' (${_illnessStageLabel(person.illnessStage!)})'}',
                  ),
                  if (!person.isInfant)
                    Text(
                      'Đang nghỉ bệnh, chưa nhận việc cho tới khi khỏi.',
                      style: small,
                    ),
                ],
                if (person.agenda case final PersonAgenda agenda) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'Sức lực: mệt ${agenda.fatigue} · đói ${agenda.hunger} · '
                    'khát ${agenda.thirst} · tâm trạng ${agenda.mood}',
                  ),
                  Text(
                    'Chỉ nhận việc từ mức ${agenda.acceptanceFloor} '
                    '(chủ yếu vì ${agenda.mainStrain})',
                  ),
                  Text(
                    'Việc được chào: nhận ${agenda.acceptedOffers}, '
                    'từ chối ${agenda.refusedOffers}',
                    style: small,
                  ),
                  if (agenda.lastRefusalReason != null)
                    Text(
                      'Lần từ chối gần nhất: ${agenda.lastRefusalReason}',
                      style: small,
                    ),
                ],
                if (person.body case final AdultBodyState body) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'Cơ thể: ${body.massGrams} g'
                    '${body.underweight ? ' (thiếu ${body.healthyMassGrams - body.massGrams} g so với lúc khỏe)' : ''}',
                  ),
                  Text(
                    'Dự trữ ${body.energyReserveKj} kJ · '
                    'đủ nước ${body.hydration}/1000'
                    '${body.dehydrated ? ' (đang thiếu nước)' : ''}',
                    style: small,
                  ),
                  Text(
                    'Sức làm việc ${body.capability}/1000 — '
                    '${body.waterCapability < body.massCapability ? 'bị nước chặn' : 'bị cân nặng chặn'}',
                    style: small,
                  ),
                  if (body.totalDrunkMl > 0)
                    Text(
                      'Đã uống tổng cộng ${body.totalDrunkMl} ml',
                      style: small,
                    ),
                  if (body.massLostGrams > 0)
                    Text(
                      'Đã sụt tổng cộng ${body.massLostGrams} g vì thiếu ăn',
                      style: small,
                    ),
                ],
                if (person.skills case final PersonSkills skills)
                  if (skills.levels.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      'Tay nghề: ${(skills.levels.keys.toList()..sort()).map((String code) => '${_skillLabel(code)} ${skills.level(code)}').join(' · ')}',
                      style: small,
                    ),
                  ],
                if (person.routine != null) ...<Widget>[
                  const SizedBox(height: 10),
                  _RoutineDetail(routine: person.routine!),
                ] else ...<Widget>[
                  const SizedBox(height: 8),
                  Text('Chưa có nhịp sống lao động.', style: small),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineDetail extends StatelessWidget {
  const _RoutineDetail({required this.routine});

  final RoutineSummaryView routine;

  @override
  Widget build(BuildContext context) {
    final TextStyle? small = Theme.of(context).textTheme.bodySmall;
    final ScheduleConflict? last = routine.lastConflict;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const _SectionLabel(label: 'NHỊP SỐNG'),
        const SizedBox(height: 6),
        for (final RoutineBlock block in routine.blocks)
          Text(
            '${_clock(block.startSecondOfDay)}–${_clock(block.endSecondOfDay)} · '
            '${block.activity}'
            '${block.blocking ? ' (không nhận việc khác)' : ''}',
            style: small,
          ),
        const SizedBox(height: 8),
        Text('Đã xong ${routine.completedBlocks} khối việc'),
        Text(
          'Xung đột lịch: ${routine.conflictCount} lần · '
          'mất ${(routine.lostSeconds / 60).round()} phút công'
          '${routine.deferredStarts > 0 ? ' · lùi giờ ${routine.deferredStarts} lần' : ''}'
          '${routine.droppedBlocks > 0 ? ' · bỏ hẳn ${routine.droppedBlocks} khối' : ''}',
        ),
        if (routine.preemptedBy != null)
          Text('Đang bị cắt ngang bởi: ${routine.preemptedBy}', style: small),
        if (last != null)
          Text(
            'Gần nhất: ngày ${last.atSeconds ~/ gameSecondsPerDay} lúc '
            '${_clock(last.atSeconds)} — ${last.plannedActivity} '
            '${_resolutionLabel(last.resolution)} vì ${last.competingActivity}'
            '${last.lostSeconds > 0 ? ' (mất ${(last.lostSeconds / 60).round()} phút)' : ''}',
            style: small,
          ),
      ],
    );
  }
}

class _ItemProfileCard extends StatelessWidget {
  const _ItemProfileCard({required this.item});

  final ItemProfileView item;

  @override
  Widget build(BuildContext context) {
    final TextStyle? small = Theme.of(context).textTheme.bodySmall;
    return Card(
      key: Key('world-item-profile-${item.id}'),
      color: const Color(0xff111611),
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text('${_itemKindLabel(item.kind)} · ${item.id}'),
        subtitle: Text(
          '${item.quantity} ${item.unit}'
          '${item.inHouseholdLedger ? ' · trong sổ kho' : ' · ngoài sổ kho'}',
          style: small,
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Tình trạng: ${item.condition}/1000'),
                Text(
                  'Vị trí: ${item.roomName ?? 'ngoài khu nhà'} · ${item.positionMm} mm',
                ),
                Text('Chủ sở hữu: ${item.ownerHouseholdName ?? 'chưa có chủ'}'),
                Text(
                  item.resourceKey == null
                      ? 'Không nằm trong sổ nguồn lực của hộ.'
                      : 'Khóa sổ nguồn lực: ${item.resourceKey}',
                ),
                Text(
                  item.authorizedUserNames.isEmpty
                      ? 'Chưa ai được ghi quyền dùng.'
                      : 'Được phép dùng: ${item.authorizedUserNames.join(', ')}',
                  style: small,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _clock(int secondOfDay) {
  final int wrapped = secondOfDay % gameSecondsPerDay;
  return '${(wrapped ~/ 3600).toString().padLeft(2, '0')}:'
      '${((wrapped % 3600) ~/ 60).toString().padLeft(2, '0')}';
}

String _resolutionLabel(String resolution) => switch (resolution) {
  'preempted' => 'bị cắt ngang',
  'deferred' => 'phải lùi giờ',
  'dropped' => 'mất hẳn trong ngày',
  _ => resolution,
};

class _RoadmapCard extends StatelessWidget {
  const _RoadmapCard();

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Các hệ tiếp theo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          const _RoadmapLine(
            icon: Icons.health_and_safety_outlined,
            title: 'Bệnh lý và thương tích',
            detail: 'Đã mở bệnh nhẹ có diễn tiến và chăm sóc',
          ),
          const _RoadmapLine(
            icon: Icons.map_outlined,
            title: 'Bản đồ và thế giới sinh',
            detail: 'Chưa mở trong bản hiện tại',
          ),
          const _RoadmapLine(
            icon: Icons.self_improvement_outlined,
            title: 'Tu luyện và công pháp',
            detail: 'Chưa mở trong bản hiện tại',
          ),
          const _RoadmapLine(
            icon: Icons.groups_outlined,
            title: 'Quan hệ và tổ chức',
            detail: 'Chưa mở trong bản hiện tại',
          ),
        ],
      ),
    ),
  );
}

class _RoadmapLine extends StatelessWidget {
  const _RoadmapLine({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(
      children: <Widget>[
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xff222822),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title),
              Text(detail, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    ),
  );
}

class _WorldSidebar extends StatelessWidget {
  const _WorldSidebar({
    required this.world,
    required this.player,
    required this.household,
    required this.running,
  });

  final WorldView world;
  final PersonView player;
  final HouseholdView? household;
  final bool running;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: <Widget>[
      const Text(
        'THẾ GIỚI',
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 2,
          color: Color(0xffc6a56a),
        ),
      ),
      const SizedBox(height: 12),
      _RunIndicator(running: running),
      const SizedBox(height: 18),
      _SideMetric(label: 'Thời gian', value: 'Ngày ${world.time.day}'),
      _SideMetric(label: 'Nhân vật', value: '${world.personCount} người'),
      _SideMetric(label: 'Sự kiện chờ', value: '${world.pendingEventCount}'),
      _SideMetric(label: 'Dấu vết', value: '${world.factCount}'),
      const Divider(height: 30),
      const Text(
        'NHÂN VẬT',
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 2,
          color: Color(0xffc6a56a),
        ),
      ),
      const SizedBox(height: 12),
      Text(player.name, style: Theme.of(context).textTheme.titleMedium),
      Text(
        player.infancy?.crying == true
            ? 'Đang khóc'
            : player.infancy?.awake == true
            ? 'Đang thức'
            : 'Đang ngủ',
      ),
      const Divider(height: 30),
      const Text(
        'HỘ GIA ĐÌNH',
        style: TextStyle(
          fontSize: 10,
          letterSpacing: 2,
          color: Color(0xffc6a56a),
        ),
      ),
      const SizedBox(height: 12),
      Text(household?.name ?? 'Chưa có'),
      Text('${household?.memberNames.length ?? 0} thành viên'),
      Text('${household?.mealsCompleted ?? 0} bữa hoàn tất'),
      const SizedBox(height: 18),
      Text(
        '5 giây thật = 1 ngày game',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ],
  );
}

class _SideMetric extends StatelessWidget {
  const _SideMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.world, required this.player});

  final WorldView world;
  final PersonView player;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Ngày ${world.time.day}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 6),
          Text(
            '5 giây thật = 1 ngày trong game',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Divider(height: 24),
          Text(player.name, style: Theme.of(context).textTheme.titleLarge),
          Text('Tuổi: ${player.ageSeconds ~/ gameSecondsPerDay} ngày'),
          Text('Vị trí: ${player.roomName ?? 'chưa xác định'}'),
          const SizedBox(height: 8),
          Text('Mục tiêu hiện tại: ${player.activeGoal ?? 'Chưa có'}'),
          const SizedBox(height: 8),
          Text('Sự kiện đang chờ: ${world.pendingEventCount}'),
          if (player.infancy case final InfantView infancy) ...<Widget>[
            const Divider(height: 24),
            Text(
              infancy.crying
                  ? 'Trạng thái: đang khóc'
                  : infancy.awake
                  ? 'Trạng thái: đang thức'
                  : 'Trạng thái: đang ngủ',
              key: const Key('infant-state'),
            ),
            const SizedBox(height: 10),
            _NeedLine(label: 'Đói', value: infancy.hunger),
            _NeedLine(label: 'Khát', value: infancy.thirst),
            _NeedLine(label: 'Buồn ngủ', value: infancy.sleepPressure),
            _NeedLine(label: 'Khó chịu vì nhiệt', value: infancy.thermalStress),
            const SizedBox(height: 8),
            Text('Căng thẳng tổng: ${infancy.distress}/1000'),
            Text('Được chăm sóc: ${infancy.careInteractions} lần'),
            Text('Gắn bó với người chăm sóc: ${infancy.attachment}/1000'),
            Text('Tầm nhìn rõ gần: ${infancy.visionRangeMm} mm'),
            Text(
              infancy.caregiverDistanceMm == null
                  ? 'Khoảng cách người chăm sóc: chưa biết'
                  : 'Khoảng cách người chăm sóc: ${infancy.caregiverDistanceMm} mm',
            ),
            Text(
              'Việc của người chăm sóc: ${infancy.caregiverActivity ?? 'chưa biết'}',
            ),
            Text('Dịch dinh dưỡng còn lại: ${infancy.feedRemaining} ml'),
            Text(
              'Tình trạng khăn: ${infancy.clothCondition?.toString() ?? 'không có'}',
            ),
            if (player.health case final HealthView health) ...<Widget>[
              const Divider(height: 24),
              Text(
                'Sức khỏe và bệnh lý',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(_illnessKindLabel(health.kind)),
              Text('Giai đoạn: ${_illnessStageLabel(health.stage)}'),
              Text('Mức bệnh: ${health.severity}/1000'),
              Text(
                'Thân nhiệt bệnh lý: ${(health.bodyTemperatureMilliC / 1000).toStringAsFixed(2)} °C',
              ),
              Text(
                'Triệu chứng: ${health.symptoms.map(_symptomLabel).join(', ')}',
              ),
              Text(
                health.detected
                    ? 'Đã được người chăm sóc phát hiện · ${health.careMinutes} phút chăm sóc'
                    : 'Chưa được người chăm sóc phát hiện',
              ),
            ],
            if (infancy.massGrams != null) ...<Widget>[
              const Divider(height: 24),
              Text(
                'Cơ thể sơ sinh',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text('Khối lượng: ${infancy.massGrams} g'),
              Text('Nước cơ thể: ${infancy.bodyWaterMl} ml'),
              Text('Dự trữ năng lượng: ${infancy.energyReserveKj} kJ'),
              Text(
                'Dạ dày: ${infancy.stomachContentMl}/${infancy.stomachCapacityMl} ml',
              ),
              Text(
                'Trong dạ dày: ${infancy.stomachEnergyKj} kJ · ${infancy.stomachWaterMl} ml nước',
              ),
              Text(
                'Thân nhiệt: ${(infancy.bodyTemperatureMilliC! / 1000).toStringAsFixed(2)} °C',
              ),
              Text('Bàng quang: ${infancy.bladderMl} ml'),
              Text('Chất thải tiêu hóa: ${infancy.digestiveWasteGrams} g'),
              Text(
                'Chức năng bú/nuốt: ${infancy.suckFunction}/${infancy.swallowFunction}',
              ),
              Text('Đã ăn: ${infancy.totalFeedMl} ml'),
              Text('Đã ngủ: ${infancy.totalSleepMinutes} phút'),
              Text(
                'Đã bài tiết: ${infancy.totalUrineMl} ml nước tiểu · ${infancy.totalStoolGrams} g phân',
              ),
              if ((infancy.illnessEnergyCostKj ?? 0) > 0) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  'Ảnh hưởng tích lũy của bệnh: tốn thêm ${infancy.illnessEnergyCostKj} kJ · '
                  'mất thêm ${infancy.illnessWaterLossMl} ml nước · '
                  'nhiễu giấc ngủ ${infancy.illnessSleepDisruptionMinutes} phút',
                  key: const Key('illness-physiology-impact'),
                ),
              ],
            ],
            if (infancy.careResponsePending)
              const Text(
                'Tín hiệu chăm sóc đang chờ được xử lý…',
                key: Key('care-response-pending'),
              ),
          ],
        ],
      ),
    ),
  );
}

class _HouseholdPanel extends StatelessWidget {
  const _HouseholdPanel({required this.household});

  final HouseholdView? household;

  @override
  Widget build(BuildContext context) {
    final HouseholdView? value = household;
    return Card(
      key: const Key('household-panel'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: value == null
            ? const Text('Chưa thuộc hộ nào.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xff293126),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.cottage_outlined,
                          color: Color(0xffc6a56a),
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              value.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              '${value.memberNames.length} người cùng chung nguồn lực',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  const _SectionLabel(label: 'THÀNH VIÊN'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final String name in value.memberNames)
                        Chip(
                          avatar: CircleAvatar(
                            backgroundColor: const Color(0xff3c4737),
                            child: Text(
                              name.characters.first,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          label: Text(name),
                          side: const BorderSide(color: Color(0xff344034)),
                          backgroundColor: const Color(0xff111611),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (final HouseholdMemberView member in value.members)
                    Card(
                      key: Key('member-profile-${member.id}'),
                      color: const Color(0xff111611),
                      child: ExpansionTile(
                        title: Text('${member.name} · ${member.id}'),
                        subtitle: Text(member.roomName ?? 'Chưa rõ vị trí'),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          14,
                        ),
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  member.activity == null
                                      ? 'Hoạt động: sinh hoạt trong hộ'
                                      : 'Hoạt động: ${member.activity}',
                                ),
                                if (member.careSkill != null)
                                  Text(
                                    'Chăm sóc: ${member.available == true ? 'sẵn sàng' : 'đang gián đoạn'}'
                                    ' · kỹ năng ${member.careSkill}/1000',
                                  ),
                                if (member.routine != null) ...<Widget>[
                                  const SizedBox(height: 10),
                                  _RoutineDetail(routine: member.routine!),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 28),
                  const _SectionLabel(label: 'KHO VẬT CHẤT'),
                  const SizedBox(height: 10),
                  _HouseResourceRow(
                    icon: Icons.rice_bowl_outlined,
                    label: 'Lương thực',
                    value: _resourceValue(value, 'food'),
                  ),
                  _HouseResourceRow(
                    icon: Icons.water_drop_outlined,
                    label: 'Nước sạch',
                    value: _resourceValue(value, 'water'),
                  ),
                  _HouseResourceRow(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Nhiên liệu',
                    value: _resourceValue(value, 'fuel'),
                  ),
                  _HouseResourceRow(
                    icon: Icons.local_drink_outlined,
                    label: 'Dịch dinh dưỡng',
                    value: _resourceValue(value, 'infant_feed'),
                  ),
                  const SizedBox(height: 10),
                  for (final HouseholdItemView item in value.items)
                    Card(
                      key: Key('item-profile-${item.id}'),
                      color: const Color(0xff111611),
                      child: ExpansionTile(
                        title: Text(
                          '${_itemKindLabel(item.kind)} · ${item.id}',
                        ),
                        subtitle: Text('${item.quantity} ${item.unit}'),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          14,
                        ),
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tình trạng: ${item.condition}/1000\n'
                              'Vị trí: ${item.roomName ?? 'chưa xác định'}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 28),
                  const _SectionLabel(label: 'NHU CẦU & KẾ HOẠCH HÔM NAY'),
                  const SizedBox(height: 10),
                  _PlanPanel(household: value),
                  const Divider(height: 28),
                  const _SectionLabel(label: 'NHỊP SỐNG & LAO ĐỘNG'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: <Widget>[
                      _MetricTile(
                        label: 'Bữa hoàn tất',
                        value: '${value.mealsCompleted}',
                        icon: Icons.restaurant_outlined,
                      ),
                      _MetricTile(
                        label: 'Thiếu vật tư',
                        value: '${value.mealShortfalls}',
                        icon: Icons.warning_amber_outlined,
                      ),
                      _MetricTile(
                        label: 'Từ chối quyền',
                        value: '${value.unauthorizedAttempts}',
                        icon: Icons.lock_outline,
                      ),
                      _MetricTile(
                        label: 'Chuyến tiếp tế',
                        value: '${value.supplyDeliveries}',
                        icon: Icons.local_shipping_outlined,
                      ),
                      _MetricTile(
                        label: 'Lượt sản xuất',
                        value: '${value.productionRuns}',
                        icon: Icons.handyman_outlined,
                      ),
                      _MetricTile(
                        label: 'Lần thay người',
                        value: '${value.caregiverSubstitutions}',
                        icon: Icons.swap_horiz,
                      ),
                      _MetricTile(
                        label: 'Ca được gánh thay',
                        value: '${value.reassignedBlocks}',
                        icon: Icons.group_work_outlined,
                      ),
                      _MetricTile(
                        label: 'Xung đột lịch',
                        value: '${value.scheduleConflicts}',
                        icon: Icons.event_busy_outlined,
                      ),
                      _MetricTile(
                        label: 'Từ chối việc',
                        value: '${value.refusedOffers}',
                        icon: Icons.front_hand_outlined,
                      ),
                    ],
                  ),
                  if (value.supplyJourneys.isNotEmpty) ...<Widget>[
                    const Divider(height: 28),
                    const _SectionLabel(label: 'HÀNH TRÌNH TIẾP TẾ'),
                    const SizedBox(height: 10),
                    for (final SupplyJourneyView journey
                        in value.supplyJourneys.take(2))
                      _SupplyJourneyCard(journey: journey),
                  ],
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color(0xff111611),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.child_care_outlined,
                          color: Color(0xffc6a56a),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Công chăm sóc của N01'),
                              Text(
                                '${value.totalCareInterruptionSecondsByPerson['N01'] ?? 0} giây đã rời công việc',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  String _resourceValue(HouseholdView value, String key) =>
      '${value.resourceQuantities[key] ?? 0} ${value.resourceUnits[key] ?? ''}';
}

class _PlanPanel extends StatelessWidget {
  const _PlanPanel({required this.household});

  final HouseholdView household;

  @override
  Widget build(BuildContext context) {
    final TextStyle? small = Theme.of(context).textTheme.bodySmall;
    final List<HouseholdNeed> pressing = household.needs
        .where((HouseholdNeed need) => need.needed)
        .toList();
    final List<(String, RoutineBlock)> work = household.plannedWork;
    return Container(
      key: const Key('plan-panel'),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xff111611),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final HouseholdNeed need in household.needs)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: <Widget>[
                  Icon(
                    need.needed
                        ? Icons.trending_down
                        : Icons.check_circle_outline,
                    size: 15,
                    color: need.needed
                        ? const Color(0xffd49a68)
                        : const Color(0xff83b993),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      '${_needLabel(need.kind)}: còn ${need.daysOfSupply} ngày dùng'
                      '${need.needed ? ' · cần bổ sung (ưu tiên ${need.priority})' : ' · còn đủ'}',
                    ),
                  ),
                ],
              ),
            ),
          if (pressing.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('Hôm nay hộ chưa thiếu gì.', style: small),
            ),
          if (work.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text('Việc đã giao', style: small),
            const SizedBox(height: 4),
            for (final (String, RoutineBlock) entry in work)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  '${_clock(entry.$2.startSecondOfDay)}–'
                  '${_clock(entry.$2.endSecondOfDay)} · ${entry.$1}: '
                  '${entry.$2.activity}'
                  '${entry.$2.needKind == null ? '' : ' (vì thiếu ${_needLabel(entry.$2.needKind!)})'}',
                  style: small,
                ),
              ),
          ] else ...<Widget>[
            const SizedBox(height: 8),
            Text(
              'Chưa có việc nào được kế hoạch giao cho hôm nay.',
              style: small,
            ),
          ],
        ],
      ),
    );
  }
}

String _skillLabel(String code) => switch (code) {
  'gather_fuel' => 'kiếm củi',
  'fetch_water' => 'gánh nước',
  'gather_food' => 'kiếm lương thực',
  'cook' => 'nấu ăn',
  _ => code,
};

String _causeLabel(String cause) => switch (cause) {
  'mat_nuoc' => 'mất nước',
  'kiet_suc' => 'kiệt sức',
  _ => cause,
};

String _needLabel(String kind) => switch (kind) {
  'food' => 'lương thực',
  'water' => 'nước sạch',
  'fuel' => 'củi',
  _ => kind,
};

String _terrainLabel(String terrain) => switch (terrain) {
  'duong_bang' => 'đường bằng',
  'duong_nui' => 'đường núi',
  'loi_suoi' => 'khúc lội suối',
  _ => terrain,
};

class _SupplyJourneyCard extends StatelessWidget {
  const _SupplyJourneyCard({required this.journey});

  final SupplyJourneyView journey;

  @override
  Widget build(BuildContext context) {
    final int arrival =
        journey.actualArrivalSeconds ?? journey.expectedArrivalSeconds;
    final int day = arrival ~/ gameSecondsPerDay;
    final int seconds = arrival % gameSecondsPerDay;
    final String time =
        '${(seconds ~/ 3600).toString().padLeft(2, '0')}:'
        '${((seconds % 3600) ~/ 60).toString().padLeft(2, '0')}';
    return Container(
      key: Key('supply-journey-${journey.id}'),
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xff111611),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xff303a30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            journey.status == SupplyJourneyStatus.delayed
                ? Icons.warning_amber
                : journey.status == SupplyJourneyStatus.delivered
                ? Icons.inventory_2_outlined
                : Icons.local_shipping_outlined,
            color: journey.status == SupplyJourneyStatus.delayed
                ? const Color(0xffd49a68)
                : const Color(0xff83b993),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${journey.id} · ${_journeyStatusLabel(journey.status)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  journey.onRoute
                      ? '${journey.carrierName} · ${journey.currentWaypointName ?? journey.currentLeg}'
                      : '${journey.carrierName} · ${_journeyLegLabel(journey.currentLeg)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (journey.onRoute) ...<Widget>[
                  Text(
                    'Tuyến ${journey.route!.name}: chặng '
                    '${journey.legIndex.clamp(0, journey.legCount)}/${journey.legCount} · '
                    'đã đi ${(journey.travelledMm / 1000000).toStringAsFixed(1)} '
                    'trên ${(journey.pathDistanceMm / 1000000).toStringAsFixed(1)} km',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (journey.pathNames.length > 1)
                    Text(
                      '${journey.chosenAmongForks ? 'Đã chọn lối' : 'Lộ trình'}: '
                      '${journey.pathNames.join(' → ')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
                Text(
                  'Mốc đến: ngày $day lúc $time'
                  '${journey.delaySeconds > 0 ? ' · chậm ${(journey.delaySeconds / 3600).toStringAsFixed(1)} giờ vì ${_terrainLabel(journey.delayReason ?? '')}' : ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      fontSize: 10,
      letterSpacing: 1.6,
      color: Color(0xff9ca795),
    ),
  );
}

class _HouseResourceRow extends StatelessWidget {
  const _HouseResourceRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xff111611),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 19, color: const Color(0xff9fbd82)),
          const SizedBox(width: 11),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    ),
  );
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 150,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xff111611),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 18, color: const Color(0xffc6a56a)),
        const SizedBox(height: 9),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}

class _NeedLine extends StatelessWidget {
  const _NeedLine({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(
      children: <Widget>[
        SizedBox(width: 112, child: Text(label)),
        Expanded(child: LinearProgressIndicator(value: value / 1000)),
        const SizedBox(width: 8),
        SizedBox(width: 34, child: Text('$value')),
      ],
    ),
  );
}

class _CommandPanel extends StatelessWidget {
  const _CommandPanel({
    required this.controller,
    required this.onSubmit,
    required this.infancy,
    required this.onInfantIntent,
    required this.enabled,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;
  final InfantView? infancy;
  final ValueChanged<InfantIntent> onInfantIntent;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            infancy == null ? 'Giao mục tiêu' : 'Ý định có thể thực hiện',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (infancy case final InfantView value) ...<Widget>[
            const Text(
              'Ở tuổi này nhân vật chưa hiểu mệnh lệnh bằng lời. Bạn điều khiển sự chú ý và phản ứng cơ thể.',
            ),
            const SizedBox(height: 12),
            for (final InfantIntent intent in value.allowedIntents)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilledButton.tonal(
                  key: Key('intent-${intent.code}'),
                  onPressed: enabled ? () => onInfantIntent(intent) : null,
                  child: Text(intent.label),
                ),
              ),
          ] else ...<Widget>[
            TextField(
              key: const Key('goal-field'),
              controller: controller,
              enabled: enabled,
              onSubmitted: enabled ? (_) => onSubmit() : null,
              decoration: const InputDecoration(
                labelText: 'Mục tiêu của nhân vật',
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              key: const Key('submit-goal'),
              onPressed: enabled ? onSubmit : null,
              icon: const Icon(Icons.flag_outlined),
              label: const Text('Giao mục tiêu'),
            ),
          ],
        ],
      ),
    ),
  );
}

class _SavePanel extends StatelessWidget {
  const _SavePanel({
    required this.status,
    required this.enabled,
    required this.onSave,
    required this.onLoad,
    required this.onNewWorld,
  });

  final String status;
  final bool enabled;
  final VoidCallback onSave;
  final VoidCallback onLoad;
  final VoidCallback onNewWorld;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Bản lưu', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(status, key: const Key('save-status')),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              FilledButton.tonalIcon(
                key: const Key('save-world'),
                onPressed: enabled ? onSave : null,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Lưu'),
              ),
              OutlinedButton.icon(
                key: const Key('load-world'),
                onPressed: enabled ? onLoad : null,
                icon: const Icon(Icons.restore),
                label: const Text('Tải lại'),
              ),
              OutlinedButton.icon(
                key: const Key('new-world'),
                onPressed: enabled ? onNewWorld : null,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Tạo thế giới mới'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _HistoryPanel extends StatefulWidget {
  const _HistoryPanel({required this.facts});

  final List<WorldFact> facts;

  @override
  State<_HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<_HistoryPanel> {
  String _filter = 'all';

  bool _matches(WorldFact fact) => switch (_filter) {
    'care' =>
      fact.kind.startsWith('body_') ||
          fact.kind.startsWith('adult_illness') ||
          fact.kind == 'illness_rest_ended' ||
          fact.kind.contains('infant') ||
          fact.kind.contains('cry') ||
          fact.kind.contains('care') ||
          fact.kind.contains('illness'),
    'household' =>
      fact.kind.startsWith('household') ||
          fact.kind.startsWith('supply_journey') ||
          fact.kind.startsWith('route_') ||
          fact.kind == 'supply_route_impassable',
    'routine' =>
      fact.kind.startsWith('routine') ||
          fact.kind == 'skill_improved' ||
          fact.kind == 'work_offer_refused' ||
          fact.kind == 'household_plan_made' ||
          fact.kind.startsWith('household_need'),
    'world' =>
      fact.kind == 'birth' ||
          fact.kind == 'person_created' ||
          fact.kind == 'item_created',
    _ => true,
  };

  @override
  Widget build(BuildContext context) {
    final List<WorldFact> shown = widget.facts
        .where(_matches)
        .toList()
        .reversed
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xff293126),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(Icons.history, color: Color(0xffc6a56a)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Lịch sử đã xảy ra',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${widget.facts.length} dấu vết gần nhất',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _filterChip('all', 'Tất cả'),
                  _filterChip('care', 'Chăm sóc'),
                  _filterChip('household', 'Hộ gia đình'),
                  _filterChip('routine', 'Nhịp sống'),
                  _filterChip('world', 'Thế giới'),
                ],
              ),
            ),
            const Divider(height: 26),
            if (shown.isEmpty)
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xff111611),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Text('Chưa có sự kiện trong nhóm này.'),
              )
            else
              for (int index = 0; index < shown.length; index++)
                _TimelineEntry(
                  fact: shown[index],
                  last: index == shown.length - 1,
                ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String value, String label) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: _filter == value,
      onSelected: (_) => setState(() => _filter = value),
    ),
  );
}

class _TimelineEntry extends StatelessWidget {
  const _TimelineEntry({required this.fact, required this.last});

  final WorldFact fact;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final int secondsOfDay = fact.time.seconds % gameSecondsPerDay;
    final String time =
        '${(secondsOfDay ~/ 3600).toString().padLeft(2, '0')}:'
        '${((secondsOfDay % 3600) ~/ 60).toString().padLeft(2, '0')}';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 28,
          child: Column(
            children: <Widget>[
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: _factColor(fact.kind),
                  shape: BoxShape.circle,
                ),
              ),
              if (!last)
                Container(width: 1, height: 58, color: const Color(0xff344034)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _factLabel(fact.kind),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      'N${fact.time.day} · $time',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _factDetail(fact),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Color _factColor(String kind) {
  if (kind.contains('failed') ||
      kind.contains('shortfall') ||
      kind.contains('not_heard')) {
    return const Color(0xffd47968);
  }
  if (kind.startsWith('household')) return const Color(0xffc6a56a);
  if (kind.startsWith('supply_journey')) return const Color(0xff78a9b7);
  if (kind.contains('history') || kind.contains('historical')) {
    return const Color(0xff9a8fc3);
  }
  if (kind.contains('illness')) return const Color(0xffd49a68);
  if (kind.contains('care') || kind.contains('infant')) {
    return const Color(0xff83b993);
  }
  return const Color(0xff89958a);
}

String _factDetail(WorldFact fact) {
  final Map<String, String> values = <String, String>{
    for (final String part in fact.detail.split(' '))
      if (part.contains('=')) part.split('=').first: part.split('=').last,
  };
  return switch (fact.kind) {
    'birth' => '${fact.detail.replaceAll(' was born', '')} chào đời.',
    'person_created' => '${fact.detail} đã tồn tại trong thế giới.',
    'item_created' =>
      'Ghi nhận ${_itemKindLabel(fact.detail)} (${fact.subjectId}).',
    'household_created' => '${fact.detail} bắt đầu được mô phỏng như một hộ.',
    'household_meal_completed' =>
      '${values['actor'] ?? 'Một thành viên'} dùng ${values['food_g'] ?? '?'} g lương thực, '
          '${values['water_ml'] ?? '?'} ml nước và ${values['fuel_g'] ?? '?'} g củi.',
    'household_work_settled' =>
      'Đã chốt công lao động tích lũy của các thành viên.',
    'household_meal_deferred' =>
      'Bữa ăn phải chờ vì ${values['actor'] ?? 'người nấu'} đang vướng ${values['competing'] ?? 'việc khác'}.',
    'household_plan_made' =>
      'Hộ rà tồn kho và giao việc: ${values['plan'] ?? 'chưa có việc'}.',
    'household_need_unstaffed' =>
      'Thiếu ${_needLabel(values['need'] ?? '')} nhưng không ai có quyền nhận việc.',
    'household_need_unscheduled' =>
      'Thiếu ${_needLabel(values['need'] ?? '')} nhưng ${values['actor'] ?? 'người được giao'} không còn giờ trống.',
    'routine_block_outranked' =>
      'Việc đang làm bị nhường chỗ cho việc ưu tiên ${values['priority'] ?? 'cao hơn'}.',
    'routine_work_delivered' =>
      'Nhập kho ${values['amount'] ?? '0'} ${_needLabel(values['resource'] ?? '')}'
          '${values['lost_seconds'] == '0' ? ' đúng kế hoạch' : ', hụt so với kế hoạch ${values['planned'] ?? '?'} vì mất giờ'}.',
    'routine_work_lost' =>
      'Công việc bị cắt ngang hết giờ nên không thu được gì.',
    'adult_illness_onset' =>
      '${fact.subjectId} đổ bệnh vì ${_causeLabel(values['cause'] ?? '')} '
          '(mức ${values['severity'] ?? '?'}/1000, đủ nước ${values['hydration'] ?? '?'}, '
          'mệt ${values['fatigue'] ?? '?'}).',
    'adult_illness_detected' =>
      '${values['carer'] ?? 'Một người'} nhận ra ${fact.subjectId} đang ốm '
          'ở mức ${values['severity'] ?? '?'}/1000.',
    'adult_illness_care_completed' =>
      '${values['carer'] ?? 'Người chăm'} cho ${fact.subjectId} '
          '${values['water_ml'] ?? '0'} ml nước; mức bệnh còn '
          '${values['severity'] ?? '?'}/1000.',
    'adult_illness_care_failed' =>
      'Không chăm được ${fact.subjectId}: thiếu nước hoặc thiếu quyền dùng kho.',
    'illness_rest_ended' =>
      '${fact.subjectId} đã khỏi và trở lại nhịp làm việc bình thường.',
    'adult_illness_unattended' =>
      'Không ai đủ điều kiện trông ${fact.subjectId} lúc này.',
    'body_drank' =>
      '${fact.subjectId} uống ${values['ml'] ?? '?'} ml trên ${values['wanted'] ?? '?'} ml cần; '
          'đủ nước ${values['hydration'] ?? '?'}/1000.',
    'body_dehydrated' =>
      '${fact.subjectId} thiếu nước ở mức ${values['hydration'] ?? '?'}/1000; '
          'sức làm việc còn ${values['capability'] ?? '?'}/1000.',
    'body_mass_lost' =>
      '${fact.subjectId} sụt ${values['lost_g'] ?? '?'} g, còn ${values['mass_g'] ?? '?'} g; '
          'sức làm việc còn ${values['capability'] ?? '?'}/1000.',
    'skill_improved' =>
      '${fact.subjectId} khá lên ${values['gain'] ?? '?'} điểm nghề '
          '${_skillLabel(values['skill'] ?? '')}, nay ở mức ${values['level'] ?? '?'}.',
    'work_offer_refused' =>
      '${fact.subjectId} từ chối vì đang mệt ${values['fatigue'] ?? '?'}/1000, '
          'chỉ nhận việc từ mức ${values['floor'] ?? '?'} trở lên.',
    'work_substitution_refused' =>
      '${fact.subjectId} từ chối gánh ca ${values['block'] ?? ''} của '
          '${values['original'] ?? 'người đang nghỉ bệnh'} vì mức ưu tiên chưa đủ.',
    'routine_block_reassigned' =>
      '${values['substitute'] ?? 'Một thành viên'} gánh thay '
          '${values['activity'] ?? 'công việc'} của ${fact.subjectId} trong '
          '${((int.tryParse(values['duration'] ?? '') ?? 0) ~/ 3600)} giờ.',
    'routine_block_reassignment_failed' =>
      'Không tìm được người đủ điều kiện gánh ca ${values['block'] ?? ''} của ${fact.subjectId}.',
    'region_created' =>
      'Vùng ${fact.detail.split(' width=').first} được vật chất hóa trên bản đồ.',
    'site_created' =>
      'Địa điểm ${fact.detail.split(' kind=').first} xuất hiện tại '
          '(${_km(int.tryParse(values['x'] ?? '') ?? 0)}, '
          '${_km(int.tryParse(values['y'] ?? '') ?? 0)}) km.',
    'world_genesis_completed' =>
      'Bản đồ seed ${values['seed'] ?? ''} đã được sinh bằng '
          '${values['version'] ?? ''}; dấu vân tay ${values['fingerprint'] ?? ''}.',
    'world_history_started' =>
      'Bắt đầu mô phỏng ${values['years'] ?? '?'} năm tiền sử '
          'qua ${values['epochs'] ?? '?'} epoch vĩ mô.',
    'historical_epoch_simulated' =>
      'Epoch ${fact.subjectId} hoàn tất sau ${values['steps'] ?? '?'} bước; '
          'dân số vùng ước tính ${values['population'] ?? '?'}, '
          '${values['households'] ?? '?'} hộ.',
    'world_history_completed' =>
      'Đã đi hết ${values['years'] ?? '?'} năm tiền sử và giữ '
          '${values['anchors'] ?? '?'} biến cố neo.',
    'routine_block_rescheduled' =>
      'Việc bị lùi hết lượt được xếp lại sang ${values['moved_to'] ?? 'giờ khác'}.',
    'routine_block_started' =>
      '${fact.subjectId} bắt đầu ${values['activity'] ?? 'công việc'} tại ${values['room'] ?? 'chỗ làm'}.',
    'routine_block_ended' =>
      '${fact.subjectId} kết thúc khối việc; mất ${((int.tryParse(values['lost_seconds'] ?? '') ?? 0) ~/ 60)} phút vì bị cắt ngang.',
    'routine_block_deferred' =>
      '${fact.subjectId} phải lùi ${values['planned'] ?? 'công việc'} vì '
          '${fact.detail.contains('competing=nghỉ vì ốm') ? 'đang nghỉ bệnh' : values['competing'] ?? 'việc khác'}.',
    'routine_block_dropped' =>
      '${fact.subjectId} mất hẳn ${values['planned'] ?? 'công việc'} hôm nay vì '
          '${fact.detail.contains('competing=nghỉ vì ốm') ? 'phải nghỉ bệnh' : values['competing'] ?? 'việc khác'}.',
    'room_created' => 'Ghi nhận không gian ${fact.detail}.',
    'illness_onset' =>
      'Bệnh nhẹ khởi phát với mức ${values['severity'] ?? '?'}/1000 và thân nhiệt ${_milliC(values['temp_millic'])}.',
    'illness_detected' =>
      '${values['caregiver'] ?? 'Người chăm sóc'} phát hiện dấu hiệu bệnh ở mức ${values['severity'] ?? '?'}/1000.',
    'caregiver_schedule_changed' =>
      '${fact.subjectId} tạm dừng công việc để xử lý ${values['reason'] ?? 'việc chăm sóc'}.',
    'illness_caregiver_arrived' =>
      '${fact.subjectId} đã tới ${values['room'] ?? 'chỗ trẻ'} để kiểm tra.',
    'illness_care_completed' =>
      '${values['caregiver'] ?? 'Người chăm sóc'} dùng ${values['water_ml'] ?? '0'} ml nước; mức bệnh còn ${values['severity'] ?? '?'}/1000.',
    'illness_progressed' =>
      'Bệnh diễn tiến còn ${values['severity'] ?? '?'}/1000; thân nhiệt ${_milliC(values['temp_millic'])}.',
    'illness_resolved' =>
      'Các dấu hiệu bệnh đã lui và thân nhiệt trở về ổn định.',
    'household_supply_delivered' =>
      'Hộ nhận ${values['food_g'] ?? '0'} g lương thực, ${values['water_ml'] ?? '0'} ml nước và ${values['infant_feed_ml'] ?? '0'} ml dinh dưỡng.',
    'household_production_completed' =>
      '${values['actor'] ?? 'Một thành viên'} bổ sung ${values['amount'] ?? '0'} đơn vị ${values['resource'] == 'fuel' ? 'củi' : values['resource'] ?? 'vật chất'}.',
    'caregiver_unavailable' =>
      '${fact.subjectId} tạm không thể nhận việc chăm sóc vì ${_reasonLabel(values['reason'])}.',
    'caregiver_available' =>
      '${fact.subjectId} đã có thể nhận lại việc chăm sóc.',
    'caregiver_substituted' =>
      '${values['substitute'] ?? fact.subjectId} thay ${values['preferred'] ?? 'người chăm sóc chính'} vì ${_reasonLabel(values['reason'])}.',
    'illness_care_unstaffed' =>
      'Không tìm được người đủ khả năng thay ${values['preferred'] ?? 'người chăm sóc chính'}.',
    'supply_journey_started' =>
      '${values['carrier'] ?? 'Người vận chuyển'} khởi hành với lương thực, nước và dinh dưỡng cho hộ.',
    'supply_journey_delayed' =>
      'Chuyến hàng trễ ${((int.tryParse(values['delay_seconds'] ?? '') ?? 0) ~/ 3600)} giờ vì ${_reasonLabel(values['reason'])}.',
    'supply_route_impassable' =>
      'Không lối nào qua nổi với sức lực ${values['capability'] ?? '?'}/1000, '
          'nên chuyến hàng không khởi hành.',
    'route_created' =>
      'Ghi nhận tuyến ${fact.detail.split(' legs=').first} dài '
          '${((int.tryParse(values['distance_mm'] ?? '') ?? 0) / 1000000).toStringAsFixed(1)} km.',
    'route_leg_started' =>
      'Đi ${_terrainLabel(values['terrain'] ?? '')}, '
          'dự tính ${((int.tryParse(values['seconds'] ?? '') ?? 0) / 3600).toStringAsFixed(1)} giờ.',
    'route_leg_arrived' =>
      'Tới ${values['name'] ?? 'điểm mốc'}'
          '${values['late_seconds'] == '0' ? ' đúng nhịp' : ', chậm hơn đường bằng ${((int.tryParse(values['late_seconds'] ?? '') ?? 0) / 3600).toStringAsFixed(1)} giờ'}.',
    'supply_journey_arrived' =>
      'Chuyến hàng đã tới hộ${values['delay_seconds'] == '0' ? ' đúng lịch' : ' sau thời gian trễ'}.',
    'cry_heard' =>
      '${fact.subjectId} nghe thấy ${values['infant'] ?? 'trẻ'}; cường độ cảm nhận ${values['perceived'] ?? '?'}.',
    'caregiver_arrived' =>
      '${fact.subjectId} đã tới chỗ ${values['infant'] ?? 'trẻ'}.',
    'caregiver_care' =>
      '${values['caregiver'] ?? 'Người chăm sóc'} giúp trẻ nhận ${values['consumed_ml'] ?? '0'} ml dinh dưỡng.',
    'infant_cry' => 'Căng thẳng đạt ${values['distress'] ?? '?'}/1000.',
    'infant_elimination' =>
      'Bài tiết ${values['urine_ml'] ?? '0'} ml nước tiểu và ${values['stool_g'] ?? '0'} g phân.',
    _ => fact.detail,
  };
}

String _itemKindLabel(String kind) => switch (kind) {
  'staple_food' => 'lương thực',
  'clean_water' => 'nước sạch',
  'firewood' => 'củi',
  'infant_feed' => 'dịch dinh dưỡng',
  'swaddling_cloth' => 'khăn quấn',
  _ => kind,
};

String _factLabel(String kind) => switch (kind) {
  'infant_cry' => 'Trẻ khóc',
  'cry_heard' => 'Người chăm sóc nghe thấy',
  'cry_not_heard' => 'Không ai nghe thấy tiếng khóc',
  'caregiver_arrived' => 'Người chăm sóc đã đến',
  'caregiver_care' => 'Hoàn tất chăm sóc',
  'caregiver_cannot_reach' => 'Người chăm sóc không thể đến',
  'care_failed_missing_supply' => 'Thiếu vật dụng chăm sóc',
  'care_failed_no_right' => 'Không có quyền dùng vật dụng',
  'care_response_impossible' => 'Không thể bắt đầu chăm sóc',
  'infant_intent' => 'Ý định của trẻ',
  'infant_fell_asleep' => 'Trẻ chìm vào giấc ngủ',
  'infant_woke_up' => 'Trẻ thức dậy',
  'infant_elimination' => 'Bài tiết',
  'birth' => 'Ra đời',
  'person_created' => 'Nhân vật tồn tại',
  'item_created' => 'Vật phẩm tồn tại',
  'household_created' => 'Hộ gia đình hình thành',
  'household_meal_completed' => 'Hộ hoàn tất bữa ăn',
  'household_meal_deferred' => 'Bữa ăn phải lùi giờ',
  'household_plan_made' => 'Hộ lập kế hoạch trong ngày',
  'household_need_unstaffed' => 'Không ai đủ quyền nhận việc',
  'household_need_unscheduled' => 'Không còn giờ trống cho việc cần làm',
  'routine_block_outranked' => 'Việc gấp hơn giành mất chỗ',
  'routine_work_delivered' => 'Làm xong và nhập kho',
  'routine_work_lost' => 'Mất trắng công việc',
  'work_offer_refused' => 'Từ chối việc được giao',
  'work_substitution_refused' => 'Từ chối gánh việc',
  'routine_block_reassigned' => 'Hộ chuyển ca cho người khác',
  'routine_block_reassignment_failed' => 'Không chuyển được ca',
  'region_created' => 'Một vùng được tạo',
  'site_created' => 'Một địa điểm được tạo',
  'world_genesis_completed' => 'Hoàn tất sinh thế giới',
  'world_history_started' => 'Bắt đầu mô phỏng tiền sử',
  'historical_epoch_simulated' => 'Một epoch lịch sử hoàn tất',
  'world_history_completed' => 'Tiền sử đi tới hiện tại',
  'skill_improved' => 'Lên tay nghề',
  'body_mass_lost' => 'Sụt cân vì thiếu ăn',
  'body_drank' => 'Uống nước từ kho hộ',
  'body_dehydrated' => 'Thiếu nước',
  'adult_illness_onset' => 'Người lớn đổ bệnh',
  'adult_illness_detected' => 'Hộ phát hiện người ốm',
  'adult_illness_care_completed' => 'Đã chăm người ốm',
  'adult_illness_care_failed' => 'Không chăm được người ốm',
  'adult_illness_unattended' => 'Không ai trông người ốm',
  'illness_rest_ended' => 'Khỏi bệnh, đi làm lại',
  'routine_block_rescheduled' => 'Xếp lại việc sang giờ khác',
  'routine_block_started' => 'Bắt đầu một khối việc trong ngày',
  'routine_block_ended' => 'Kết thúc một khối việc',
  'routine_block_deferred' => 'Khối việc bị lùi giờ',
  'routine_block_dropped' => 'Khối việc mất hẳn trong ngày',
  'household_meal_shortfall' => 'Hộ thiếu vật tư cho bữa ăn',
  'household_meal_unauthorized' => 'Người nấu không có quyền dùng kho',
  'household_work_settled' => 'Chốt sổ lao động trong ngày',
  'room_created' => 'Không gian trong nhà hình thành',
  'illness_onset' => 'Bệnh nhẹ khởi phát',
  'illness_detected' => 'Phát hiện dấu hiệu bệnh',
  'caregiver_schedule_changed' => 'Người chăm sóc đổi lịch',
  'illness_caregiver_arrived' => 'Đến kiểm tra bệnh',
  'illness_care_completed' => 'Chăm sóc bệnh hoàn tất',
  'illness_care_failed' => 'Không thể chăm sóc bệnh',
  'illness_progressed' => 'Bệnh đang diễn tiến',
  'illness_resolved' => 'Bệnh đã lui',
  'household_supply_delivered' => 'Hộ nhận tiếp tế',
  'household_production_completed' => 'Hộ hoàn tất sản xuất',
  'caregiver_unavailable' => 'Người chăm sóc bị gián đoạn',
  'caregiver_available' => 'Người chăm sóc trở lại',
  'caregiver_substituted' => 'Hộ thay người chăm sóc',
  'illness_care_unstaffed' => 'Không có người chăm sóc thay thế',
  'supply_journey_started' => 'Chuyến tiếp tế khởi hành',
  'supply_journey_delayed' => 'Chuyến tiếp tế bị trễ',
  'supply_journey_arrived' => 'Chuyến tiếp tế đã tới',
  'route_created' => 'Tuyến đường hình thành',
  'route_leg_started' => 'Bắt đầu một chặng đường',
  'route_leg_arrived' => 'Tới một điểm mốc',
  'supply_route_impassable' => 'Không có đường nào đi được',
  _ => kind,
};

String _illnessKindLabel(String kind) => switch (kind) {
  'mild_respiratory_infection' => 'Nhiễm đường hô hấp nhẹ',
  'adult_dehydration' => 'Kiệt nước',
  'adult_exhaustion' => 'Kiệt sức vì làm quá',
  _ => kind,
};

String _illnessStageLabel(IllnessStage stage) => switch (stage) {
  IllnessStage.symptomatic => 'đang có triệu chứng',
  IllnessStage.recovering => 'đang hồi phục',
  IllnessStage.resolved => 'đã lui',
};

String _symptomLabel(String symptom) => switch (symptom) {
  'runny_nose' => 'chảy mũi',
  'light_cough' => 'ho nhẹ',
  'mild_fever' => 'sốt nhẹ',
  _ => symptom,
};

String _milliC(String? value) {
  final int? raw = int.tryParse(value ?? '');
  return raw == null ? 'chưa rõ' : '${(raw / 1000).toStringAsFixed(2)} °C';
}

String _journeyStatusLabel(SupplyJourneyStatus status) => switch (status) {
  SupplyJourneyStatus.traveling => 'đang vận chuyển',
  SupplyJourneyStatus.delayed => 'đang bị trễ',
  SupplyJourneyStatus.delivered => 'đã giao',
};

String _journeyLegLabel(String leg) => switch (leg) {
  'eastern_mountain_road' => 'đường núi phía đông',
  'mountain_road_delayed' => 'đang mắc lại trên đường lầy',
  'household_yard' => 'đã tới sân hộ',
  _ => leg,
};

String _reasonLabel(String? reason) => switch (reason) {
  'sudden_fever' => 'sốt đột ngột',
  'recovered_enough' => 'đã hồi phục đủ',
  'muddy_mountain_road' => 'đường núi lầy',
  'cry_response' => 'tiếng khóc cần phản ứng',
  'ILL-P00-01' => 'đợt bệnh của trẻ',
  null => 'nguyên nhân chưa rõ',
  _ => reason,
};
