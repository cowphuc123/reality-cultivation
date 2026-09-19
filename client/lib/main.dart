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
    final GeneratedWorld generated = WorldGenerator.generate(
      rootSeed: seed,
      includeTerrainProfile: true,
    );
    final GeneratedWorldHistory history = WorldHistoryGenerator.generate(
      rootSeed: seed,
      worldFingerprint: generated.fingerprint,
    );
    final GeneratedBirthHouseholds birthHouseholds =
        BirthHouseholdGenerator.generate(
          world: generated,
          history: history,
          includeFamilyMembers: true,
          includeFamilyMemory: true,
          includeFamilyCareNegotiation: true,
          includeFamilyCareSupport: true,
          includeFamilyCareResilience: true,
          includeFamilyCareBurden: true,
          includeFamilyCareConflict: true,
          includeFamilyCarePromise: true,
          includeFamilyCareReliability: true,
          includeFamilyCareWitnessMemory: true,
          includeInfantAttachmentLearning: true,
        );
    final GeneratedSettlementPopulation settlementPopulation =
        SettlementPopulationGenerator.generate(
          world: generated,
          history: history,
          existingDetailedPersonCount: 8,
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
          'room_id': 'ROOM-MERCHANT-STORE',
          'name': 'Kho hộ đổi dược thảo tại chợ An Khê',
          'household_id': 'H-MERCHANT',
          'anchor_position_mm': market.center.xMm,
          'anchor_position_y_mm': market.center.yMm,
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
        kind: 'route_created',
        payload: <String, Object?>{
          'route': <String, Object?>{
            'id': 'RT-ANKHE-MARKET-RETURN',
            'name': 'Tuyến giao ngũ cốc An Khê',
            'origin_id': 'WP-BEP-H01',
            'destination_id': 'WP-KHO-THAO-DUOC',
            'waypoints': <Map<String, Object?>>[
              <String, Object?>{
                'id': 'WP-BEP-H01',
                'name': 'Gian bếp hộ ven suối',
                'position_mm': home.center.xMm + 5000,
                'position_y_mm': home.center.yMm,
              },
              <String, Object?>{
                'id': 'WP-DUONG-DONG',
                'name': 'Đường qua đồng ngoài',
                'position_mm': field.center.xMm,
                'position_y_mm': field.center.yMm,
              },
              <String, Object?>{
                'id': 'WP-KHO-THAO-DUOC',
                'name': 'Kho dược thảo tại chợ',
                'position_mm': market.center.xMm,
                'position_y_mm': market.center.yMm,
              },
            ],
            'legs': <Map<String, Object?>>[
              <String, Object?>{
                'from_id': 'WP-BEP-H01',
                'to_id': 'WP-DUONG-DONG',
                'terrain': 'duong_dat_am',
                'terrain_speed_per_mille': 700,
              },
              <String, Object?>{
                'from_id': 'WP-DUONG-DONG',
                'to_id': 'WP-KHO-THAO-DUOC',
                'terrain': 'duong_cho_ghep_ghenh',
                'terrain_speed_per_mille': 520,
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
        kind: 'person_created',
        payload: <String, Object?>{
          'person_id': 'M01',
          'name': 'Người đổi dược thảo',
          'birth_seconds': -37 * 365 * gameSecondsPerDay,
          'position_mm': home.center.xMm + 5000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-KITCHEN',
          'household_id': 'H-MERCHANT',
          'agenda': <String, Object?>{'fatigue': 100},
          'adult_body': <String, Object?>{'mass_g': 51000},
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
          'item_id': 'I-TIMBER-CRAFT-01',
          'kind': 'raw_timber',
          'position_mm': home.center.xMm + 12000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-YARD',
          'quantity': 3000,
          'condition': 720,
          'unit': 'g',
          'owner_household_id': 'H01',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': 'I-ROOT-SHORTAGE-01',
          'kind': 'raw_root',
          'position_mm': home.center.xMm + 5000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-KITCHEN',
          'quantity': 900,
          'condition': 690,
          'unit': 'g',
          'owner_household_id': 'H01',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': 'I-MERCHANT-GRAIN-RESERVE',
          'kind': 'raw_grain',
          'position_mm': home.center.xMm + 5000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-KITCHEN',
          'quantity': 300,
          'condition': 710,
          'unit': 'g',
          'owner_household_id': 'H-MERCHANT',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': 'I-MARKET-HERB-01',
          'kind': 'dried_herb',
          'position_mm': home.center.xMm + 5000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-KITCHEN',
          'quantity': 300,
          'condition': 740,
          'unit': 'g',
          'owner_household_id': 'H-MERCHANT',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': 'I-FIBER-CRAFT-01',
          'kind': 'plant_fiber',
          'position_mm': home.center.xMm + 12000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-YARD',
          'quantity': 800,
          'condition': 680,
          'unit': 'g',
          'owner_household_id': 'H01',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': 'I-HAND-AXE-01',
          'kind': 'hand_axe',
          'position_mm': home.center.xMm + 12000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-YARD',
          'quantity': 1,
          'condition': 850,
          'unit': 'piece',
          'owner_household_id': 'H01',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': 'I-GRAIN-SERVICE-01',
          'kind': 'raw_grain',
          'position_mm': home.center.xMm + 5000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-KITCHEN',
          'quantity': 500,
          'condition': 760,
          'unit': 'g',
          'owner_household_id': 'H01',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'item_created',
        payload: <String, Object?>{
          'item_id': 'I-LABOR-RICE-01',
          'kind': 'labor_rice',
          'position_mm': home.center.xMm + 12000,
          'position_y_mm': home.center.yMm,
          'room_id': 'ROOM-YARD',
          'quantity': 1000,
          'condition': 800,
          'unit': 'g',
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
            'I-TIMBER-CRAFT-01': <String>['N03'],
            'I-FIBER-CRAFT-01': <String>['N03'],
            'I-HAND-AXE-01': <String>['N03'],
            'I-GRAIN-SERVICE-01': <String>['N02'],
            'I-ROOT-SHORTAGE-01': <String>['N02'],
            'I-LABOR-RICE-01': <String>['N01'],
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
          'birth_caregiver_role': 'mother',
          'family_origin_summary':
              'Người chăm sóc là mẹ ruột; đứa trẻ sinh vào hộ ven suối đã tồn tại từ thời lập cư.',
          'production_actor_id': 'N03',
          'supply_carrier_id': 'N04',
          'supply_route_id': 'RT-ANKHE',
        },
      )
      ..schedule(
        due: const SimTime(0),
        phase: EventPhase.completion,
        kind: 'household_created',
        payload: const <String, Object?>{
          'household_id': 'H-MERCHANT',
          'name': 'Hộ đổi dược thảo',
          'member_ids': <String>['M01'],
          'resource_item_ids': <String, String>{},
          'authorized_users_by_item_id': <String, List<String>>{
            'I-MARKET-HERB-01': <String>['M01'],
            'I-MERCHANT-GRAIN-RESERVE': <String>['M01'],
          },
          'scheduled_work_seconds_by_person': <String, int>{'M01': 0},
          'meal_actor_id': 'M01',
        },
      );

    simulation
      ..materializeSettlementPopulation(settlementPopulation, history: history)
      ..materializeBirthHouseholds(birthHouseholds, history: history)
      ..simulatePrehistory(history, applyLegacy: true)
      ..openWorldEntry();

    simulation.advanceTo(const SimTime(0));
    simulation.startProductionBatch(
      batchId: 'PB-CARRY-FRAME-01',
      recipe: const ProductionRecipe(
        id: 'RECIPE-CARRY-FRAME-01',
        name: 'đóng khung gùi gỗ',
        durationSeconds: 2 * 3600,
        inputs: <ProductionIngredient>[
          ProductionIngredient(kind: 'raw_timber', quantity: 1200, unit: 'g'),
          ProductionIngredient(kind: 'plant_fiber', quantity: 250, unit: 'g'),
        ],
        outputKind: 'carrying_frame',
        outputQuantity: 1,
        outputUnit: 'piece',
        toolKind: 'hand_axe',
        toolWear: 25,
      ),
      actorId: 'N03',
      householdId: 'H01',
      roomId: 'ROOM-YARD',
      inputItemIdsByKind: const <String, String>{
        'raw_timber': 'I-TIMBER-CRAFT-01',
        'plant_fiber': 'I-FIBER-CRAFT-01',
      },
      outputItemId: 'I-CARRY-FRAME-01',
      toolItemId: 'I-HAND-AXE-01',
    );
    simulation.bookServiceAppointment(
      appointmentId: 'SA-COOKING-LESSON-01',
      definition: const ServiceDefinition(
        id: 'SERVICE-COOKING-LESSON-01',
        name: 'hướng dẫn nấu cháo ngũ cốc',
        durationSeconds: 3600,
        resultClaimKind: 'cooking_instruction_completed',
        inputs: <ProductionIngredient>[
          ProductionIngredient(kind: 'raw_grain', quantity: 100, unit: 'g'),
        ],
      ),
      providerId: 'N02',
      recipientId: 'N01',
      providerHouseholdId: 'H01',
      recipientHouseholdId: 'H01',
      roomId: 'ROOM-KITCHEN',
      startsAtSeconds: 3 * 3600,
      inputItemIdsByKind: const <String, String>{
        'raw_grain': 'I-GRAIN-SERVICE-01',
      },
    );
    simulation.createLaborOffer(
      offerId: 'LO-YARD-SORT-01',
      activity: 'phân loại gỗ và sợi trong sân',
      skillCode: 'gather_fuel',
      minimumSkill: 700,
      priority: 100,
      employerId: 'N01',
      workerId: 'N03',
      employerHouseholdId: 'H01',
      workerHouseholdId: 'H01',
      roomId: 'ROOM-YARD',
      startsAtSeconds: 4 * 3600,
      durationSeconds: 1800,
      compensation: const LaborCompensationTerms(
        itemKind: 'labor_rice',
        quantity: 300,
        unit: 'g',
      ),
    );
    simulation.considerLaborOffer('LO-YARD-SORT-01');
    simulation.createLaborOffer(
      offerId: 'LO-EXTRA-HAUL-01',
      activity: 'gánh thêm gỗ cuối ngày',
      skillCode: 'gather_fuel',
      minimumSkill: 700,
      priority: 50,
      employerId: 'N01',
      workerId: 'N03',
      employerHouseholdId: 'H01',
      workerHouseholdId: 'H01',
      roomId: 'ROOM-YARD',
      startsAtSeconds: 19 * 3600,
      durationSeconds: 3600,
      compensation: const LaborCompensationTerms(
        itemKind: 'labor_rice',
        quantity: 250,
        unit: 'g',
      ),
    );
    simulation.considerLaborOffer('LO-EXTRA-HAUL-01');
    simulation.beginSupplyShock(
      shockId: 'SS-GRAIN-RAIN-01',
      resourceKind: 'raw_grain',
      unit: 'g',
      cause: 'mưa kéo dài làm ẩm mốc kho ngũ cốc ven suối và kho chợ',
      durationSeconds: 5 * gameSecondsPerDay,
      affectedHouseholdIds: const <String>['H01', 'H-MERCHANT'],
      disruptedQuantityByItemId: const <String, int>{
        'I-GRAIN-SERVICE-01': 150,
        'I-MERCHANT-GRAIN-RESERVE': 250,
      },
    );
    simulation.startProductionBatch(
      batchId: 'PB-SHORTAGE-ROOT-01',
      recipe: const ProductionRecipe(
        id: 'RECIPE-DRIED-ROOT-01',
        name: 'thái và hong củ dự trữ thay ngũ cốc',
        durationSeconds: 3600,
        inputs: <ProductionIngredient>[
          ProductionIngredient(kind: 'raw_root', quantity: 600, unit: 'g'),
        ],
        outputKind: 'dried_root_food',
        outputQuantity: 450,
        outputUnit: 'g',
      ),
      actorId: 'N02',
      householdId: 'H01',
      roomId: 'ROOM-KITCHEN',
      inputItemIdsByKind: const <String, String>{
        'raw_root': 'I-ROOT-SHORTAGE-01',
      },
      outputItemId: 'I-DRIED-ROOT-FOOD-01',
    );
    simulation.recordSupplyShockResponse(
      shockId: 'SS-GRAIN-RAIN-01',
      householdId: 'H01',
      kind: SupplyShockResponseKind.production,
      evidenceId: 'PB-SHORTAGE-ROOT-01',
    );
    simulation.publishMarketOffer(
      offerId: 'MO-GRAIN-HERB-01',
      sellerPersonId: 'N02',
      sellerHouseholdId: 'H01',
      roomId: 'ROOM-KITCHEN',
      sourceItemId: 'I-GRAIN-SERVICE-01',
      offeredQuantity: 200,
      lotQuantity: 100,
      paymentKind: 'dried_herb',
      paymentQuantityPerLot: 50,
      paymentUnit: 'g',
      visibleToPersonIds: const <String>['M01'],
    );
    simulation.placeMarketOrder(
      orderId: 'MO-GRAIN-HERB-01-ORDER-01',
      offerId: 'MO-GRAIN-HERB-01',
      buyerPersonId: 'M01',
      buyerHouseholdId: 'H-MERCHANT',
      paymentSourceItemId: 'I-MARKET-HERB-01',
      merchandiseQuantity: 100,
    );
    simulation.recordSupplyShockResponse(
      shockId: 'SS-GRAIN-RAIN-01',
      householdId: 'H-MERCHANT',
      kind: SupplyShockResponseKind.marketExchange,
      evidenceId: 'MO-GRAIN-HERB-01-ORDER-01',
    );
    simulation.settleMarketOrder(
      orderId: 'MO-GRAIN-HERB-01-ORDER-01',
      buyerTargetItemId: 'I-MARKET-GRAIN-M01',
      sellerTargetItemId: 'I-MARKET-HERB-H01',
    );
    simulation.dispatchMarketShipment(
      shipmentId: 'MS-GRAIN-M01-01',
      orderId: 'MO-GRAIN-HERB-01-ORDER-01',
      carrierId: 'M01',
      routeId: 'RT-ANKHE-MARKET-RETURN',
      fromWaypointId: 'WP-BEP-H01',
      toWaypointId: 'WP-KHO-THAO-DUOC',
      originRoomId: 'ROOM-KITCHEN',
      destinationRoomId: 'ROOM-MERCHANT-STORE',
      sourceItemId: 'I-MARKET-GRAIN-M01',
      destinationItemId: 'I-MERCHANT-GRAIN-STORE',
    );
    if (!awaitBirthSelection) {
      simulation.issue(
        const ChooseBirthSiteCommand(
          id: 'bootstrap-birth-site',
          siteId: 'SITE-HOME',
        ),
      );
      simulation.advanceTo(const SimTime(0));
      simulation.enableChildhoodDevelopment('P00');
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
          if (_simulation.state.people['P00']?.infancy != null) {
            _simulation.enableChildhoodDevelopment('P00');
          }
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

  void _submitChildIntent(ChildIntent intent) {
    final String commandId =
        'ui-child-${_simulation.state.revision}-$_commandSequence';
    _commandSequence++;
    final CommandResult result = _host.submit(
      ChildIntentCommand(id: commandId, personId: 'P00', intent: intent),
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
    _simulation.enableChildhoodDevelopment('P00');
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
        builder: (BuildContext context, StateSetter setDialogState) => AlertDialog(
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
                  setDialogState(() => seedError = 'Hãy nhập một số nguyên.');
                  return;
                }
                if (value < minimumWorldSeed || value > maximumWorldSeed) {
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
    final HouseholdView? household = _host.household(
      entry?.state.householdId ?? 'H01',
    );
    final List<WorldFact> facts = _host.recentFacts(limit: 50);
    final List<ProductionBatchState> productionBatches =
        _simulation.state.productionBatches.values
            .where(
              (ProductionBatchState value) =>
                  value.householdId == (household?.id ?? 'H01'),
            )
            .toList()
          ..sort(
            (ProductionBatchState a, ProductionBatchState b) =>
                a.id.compareTo(b.id),
          );
    final List<ServiceAppointmentState> serviceAppointments =
        _simulation.state.serviceAppointments.values
            .where(
              (ServiceAppointmentState value) =>
                  value.providerHouseholdId == (household?.id ?? 'H01') ||
                  value.recipientHouseholdId == (household?.id ?? 'H01'),
            )
            .toList()
          ..sort(
            (ServiceAppointmentState a, ServiceAppointmentState b) =>
                a.startsAtSeconds.compareTo(b.startsAtSeconds),
          );
    final List<LaborOfferState> laborOffers =
        _simulation.state.laborOffers.values
            .where(
              (LaborOfferState value) =>
                  value.employerHouseholdId == (household?.id ?? 'H01') ||
                  value.workerHouseholdId == (household?.id ?? 'H01'),
            )
            .toList()
          ..sort(
            (LaborOfferState a, LaborOfferState b) =>
                a.startsAtSeconds.compareTo(b.startsAtSeconds),
          );
    final Map<String, LaborCompensationClaim> laborClaims =
        <String, LaborCompensationClaim>{
          for (final LaborCompensationClaim value
              in _simulation.state.laborClaims.values)
            if (value.debtorHouseholdId == (household?.id ?? 'H01') ||
                value.creditorHouseholdId == (household?.id ?? 'H01'))
              value.id: value,
        };
    final List<MarketOfferState> marketOffers =
        _simulation.state.marketOffers.values
            .where(
              (MarketOfferState value) =>
                  value.sellerHouseholdId == (household?.id ?? 'H01') ||
                  _simulation.state.marketOrders.values.any(
                    (MarketOrderState order) =>
                        order.offerId == value.id &&
                        order.buyerHouseholdId == (household?.id ?? 'H01'),
                  ),
            )
            .toList()
          ..sort(
            (MarketOfferState a, MarketOfferState b) =>
                a.createdAtSeconds.compareTo(b.createdAtSeconds),
          );
    final List<MarketOrderState> marketOrders =
        _simulation.state.marketOrders.values
            .where(
              (MarketOrderState value) =>
                  value.sellerHouseholdId == (household?.id ?? 'H01') ||
                  value.buyerHouseholdId == (household?.id ?? 'H01'),
            )
            .toList()
          ..sort(
            (MarketOrderState a, MarketOrderState b) =>
                a.createdAtSeconds.compareTo(b.createdAtSeconds),
          );
    final Set<String> visibleMarketOrderIds = marketOrders
        .map((MarketOrderState value) => value.id)
        .toSet();
    final List<MarketShipmentState> marketShipments =
        _simulation.state.marketShipments.values
            .where(
              (MarketShipmentState value) =>
                  visibleMarketOrderIds.contains(value.orderId),
            )
            .toList()
          ..sort(
            (MarketShipmentState a, MarketShipmentState b) =>
                a.departedAtSeconds.compareTo(b.departedAtSeconds),
          );
    final List<SupplyShockState> supplyShocks =
        _simulation.state.supplyShocks.values
            .where(
              (SupplyShockState value) =>
                  value.affectedHouseholdIds.contains(household?.id ?? 'H01'),
            )
            .toList()
          ..sort(
            (SupplyShockState a, SupplyShockState b) =>
                a.startsAtSeconds.compareTo(b.startsAtSeconds),
          );
    final Map<String, String> personNames = <String, String>{
      for (final PersonState person in _simulation.state.people.values)
        person.id: person.name,
    };
    final _CommandPanel command = _CommandPanel(
      controller: _goalController,
      onSubmit: _submitGoal,
      infancy: player.infancy,
      childhood: player.childhood,
      onInfantIntent: _submitInfantIntent,
      onChildIntent: _submitChildIntent,
      currentSeconds: world.time.seconds,
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
        child: _HouseholdPanel(
          household: household,
          productionBatches: productionBatches,
          serviceAppointments: serviceAppointments,
          laborOffers: laborOffers,
          laborClaims: laborClaims,
          marketOffers: marketOffers,
          marketOrders: marketOrders,
          marketShipments: marketShipments,
          supplyShocks: supplyShocks,
          personNames: personNames,
          currentSeconds: world.time.seconds,
        ),
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
    final ChildhoodView? childhood = player.childhood;
    final String state = childhood != null
        ? childhood.stage.label
        : infant == null
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
                    '${childhood?.stage.label ?? 'Sơ sinh'} · '
                    '${player.ageSeconds ~/ gameSecondsPerDay} ngày tuổi · Hộ ven suối',
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
          if (world.communitySurvival
              case final CommunitySurvivalState audit) ...<Widget>[
            const SizedBox(height: 10),
            Text(
              'Theo dõi làng: ${audit.recordedDays}/${audit.targetDays} ngày · '
              '${audit.daysRequiringUnsupportedRescue} ngày có điểm nguy cấp',
              key: const Key('community-survival-progress'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
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
    final ChildhoodView? childhood = player.childhood;
    final bool pending =
        childhood == null && (infant?.careResponsePending ?? false);
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
                  : childhood != null
                  ? 'Đang hình thành năng lực'
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
                  : childhood != null
                  ? 'Trưởng thành tạo nền, còn quan sát và luyện tập thật mới mở các hoạt động tiếp theo.'
                  : ill
                  ? '${_illnessKindLabel(health.kind)} ở mức ${health.severity}/1000; '
                        'thân nhiệt ${(health.bodyTemperatureMilliC / 1000).toStringAsFixed(2)} °C.'
                  : 'Các nhu cầu vẫn thay đổi theo sinh lý. Thế giới sẽ tạo cảnh báo khi có nguyên nhân đáng chú ý.',
            ),
            if (childhood != null) ...<Widget>[
              const SizedBox(height: 18),
              Text(
                'Quan sát ${childhood.observationExperience} · '
                'vận động ${childhood.movementPractice} · '
                'ngôn ngữ ${childhood.languageExposure} · '
                'chơi ${childhood.playExperience}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ] else if (infant != null) ...<Widget>[
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
        if (world.communitySurvival
            case final CommunitySurvivalState audit) ...<Widget>[
          const SizedBox(height: 14),
          _CommunitySurvivalCard(audit: audit),
        ],
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

class _CommunitySurvivalCard extends StatelessWidget {
  const _CommunitySurvivalCard({required this.audit});

  final CommunitySurvivalState audit;

  @override
  Widget build(BuildContext context) {
    final CommunityDaySnapshot? latest = audit.latest;
    final List<HouseholdSurvivalSnapshot> pressured = latest == null
        ? const <HouseholdSurvivalSnapshot>[]
        : latest.households
              .where(
                (HouseholdSurvivalSnapshot household) =>
                    household.underPressure,
              )
              .toList();
    final List<CommunityResourceRequestState> requests =
        audit.resourceRequests.values.toList()..sort(
          (CommunityResourceRequestState a, CommunityResourceRequestState b) =>
              b.updatedAtSeconds.compareTo(a.updatedAtSeconds),
        );
    return Card(
      key: const Key('community-survival-card'),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _SectionLabel(label: 'SỨC SỐNG CỦA LÀNG'),
            const SizedBox(height: 7),
            Text(
              '${audit.recordedDays}/${audit.targetDays} ngày đã được ghi'
              '${audit.complete ? ' · đã đủ chu kỳ' : ' · đang tiếp tục'}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${audit.daysRequiringUnsupportedRescue} ngày có điểm nguy cấp cần cơ chế tự giải quyết.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (latest != null) ...<Widget>[
              const SizedBox(height: 9),
              Text(
                'Ngày ${latest.day}: ${latest.pressuredHouseholds} hộ chịu áp lực, '
                '${latest.criticalHouseholds} hộ nguy cấp · '
                '${latest.travelingExchanges} chuyến hàng đang đi, '
                '${latest.overdueExchanges} chuyến quá hạn.',
              ),
              if (pressured.isEmpty)
                const Text(
                  'Không có hộ nào chạm ngưỡng cảnh báo trong ngày này.',
                )
              else
                for (final HouseholdSurvivalSnapshot household
                    in pressured.take(6))
                  Text(
                    '• ${household.householdId}: '
                    '${household.criticalReasons.isEmpty ? 'áp lực ${household.pressureKinds.join(', ')}' : 'nguy cấp ${household.criticalReasons.join(', ')}'} · '
                    'người làm ${household.availableAdultWorkers}, '
                    'ốm ${household.activeIllnesses}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
            ],
            if (requests.isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              Text(
                'Yêu cầu tài nguyên: '
                '${requests.where((CommunityResourceRequestState value) => value.active).length} đang xử lý · '
                '${requests.where((CommunityResourceRequestState value) => value.status == CommunityResourceRequestStatus.resolved).length} đã giải quyết · '
                '${requests.where((CommunityResourceRequestState value) => value.status == CommunityResourceRequestStatus.failed).length} thất bại',
                key: const Key('community-resource-request-summary'),
              ),
              for (final CommunityResourceRequestState request in requests.take(
                6,
              ))
                Text(
                  '• ${request.householdId} cần ${_needLabel(request.resource)}: '
                  '${_resourceRequestStatusLabel(request.status)} · '
                  'đã thử ${request.attemptCount} lần'
                  '${request.providerHouseholdId == null ? '' : ' · nguồn ${request.providerHouseholdId}'}'
                  '${request.lastFailureReason == null ? '' : ' · ${request.lastFailureReason}'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

String _resourceRequestStatusLabel(CommunityResourceRequestStatus status) =>
    switch (status) {
      CommunityResourceRequestStatus.detected => 'vừa phát hiện',
      CommunityResourceRequestStatus.seeking => 'đang tìm nguồn',
      CommunityResourceRequestStatus.inquiring => 'đang đi hỏi',
      CommunityResourceRequestStatus.introductionTravel =>
        'đang được dẫn tới hộ nguồn',
      CommunityResourceRequestStatus.negotiating => 'đang thương lượng',
      CommunityResourceRequestStatus.goodsInTransit => 'hàng đang đi',
      CommunityResourceRequestStatus.resolved => 'đã nhận hàng',
      CommunityResourceRequestStatus.failed => 'tạm thất bại',
      CommunityResourceRequestStatus.cancelled => 'đã hủy',
    };

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
      parts.add(
        'dân số ${effect.populationDelta > 0 ? '+' : ''}${effect.populationDelta}',
      );
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
            const SizedBox(height: 8),
            Text(
              '${history.macroStepCount} bước vĩ mô đã được nén vào '
              '${history.completedEpochCount} bản tóm tắt epoch; chỉ giữ '
              '${history.anchors.length} biến cố neo và cửa sổ '
              '${history.recentAnchors.length} biến cố gần nhất.',
              key: const Key('historical-compression-summary'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: <Widget>[
                for (final HistoricalAnchor anchor in history.recentAnchors)
                  Chip(
                    key: Key('recent-history-anchor-${anchor.id}'),
                    label: Text(
                      '${anchor.yearsBeforePresent} năm · ${anchor.kind}',
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
            if (history.legacy
                case final HistoricalLegacyState legacy) ...<Widget>[
              const SizedBox(height: 12),
              Container(
                key: const Key('historical-legacy-summary'),
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff9a8fc3).withValues(alpha: .09),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xff9a8fc3).withValues(alpha: .28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'HẬU QUẢ CÒN LẠI TRONG ĐỜI SỐNG HIỆN TẠI',
                      style: TextStyle(
                        color: Color(0xffc6a56a),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.05,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đất canh tác, giao thương và áp lực tài nguyên đã tác '
                      'động tới ${legacy.adjustments.length} kho hộ, '
                      '${legacy.naturalResourceAdjustments.length} nguồn tự nhiên, '
                      '${legacy.ecologyAdjustments.length} quần thể và '
                      '${legacy.settlementAdjustments.length} địa điểm dân cư.',
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: <Widget>[
                        Text('Lương thực ${legacy.foodReservePerMille / 10}%'),
                        Text('Nước ${legacy.waterReservePerMille / 10}%'),
                        Text('Củi ${legacy.fuelReservePerMille / 10}%'),
                        Text(
                          'Sữa trẻ nhỏ '
                          '${legacy.infantFeedReservePerMille / 10}%',
                        ),
                        Text(
                          'Tiếp tế mỗi chuyến '
                          '${legacy.supplyDeliveryPerMille / 10}%',
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    for (final HistoricalResourceAdjustment adjustment
                        in legacy.adjustments)
                      Text(
                        '${adjustment.resourceKey}: '
                        '${adjustment.beforeQuantity} → '
                        '${adjustment.afterQuantity}',
                        key: Key('legacy-adjustment-${adjustment.itemId}'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: 5),
                    Text(
                      'Thiệt hại lũ ${legacy.floodDamagePerMille}/1000 · '
                      'công thức ${legacy.formulaVersion}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
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
              if (site.terrainCode != 'unspecified')
                Text(
                  '${_terrainProfileLabel(site.terrainCode)} · cao ${site.elevationM} m',
                  key: Key('birth-terrain-${candidate.siteId}'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (site.resourceDeposits.isNotEmpty)
                Text(
                  'Nguồn tự nhiên: ${site.resourceDeposits.map((NaturalResourceDeposit value) => _naturalResourceLabel(value.kind)).join(', ')}',
                  key: Key('birth-resources-${candidate.siteId}'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              if (site.ecologicalPopulations.isNotEmpty)
                Text(
                  'Sinh thái: ${site.ecologicalPopulations.map((EcologicalPopulationState value) => _ecologicalSpeciesLabel(value.speciesCode)).join(', ')}',
                  key: Key('birth-ecology-${candidate.siteId}'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
            if (candidate.settlementScore != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                'Khả năng hình thành khu dân cư: '
                '${candidate.settlementScore}/1000',
                key: Key('birth-settlement-${candidate.siteId}'),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              for (final String reason in candidate.settlementReasons)
                Text('• $reason', style: Theme.of(context).textTheme.bodySmall),
            ],
            if (candidate.feasible) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                '${candidate.householdName ?? candidate.householdId} · '
                'phòng ${candidate.roomId}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: accent),
              ),
              const SizedBox(height: 5),
              Text(
                'Người chăm ${candidate.caregiverName ?? candidate.caregiverId} '
                '· kỹ năng ${candidate.caregiverSkill ?? 0}/1000',
                key: Key('birth-caregiver-${candidate.siteId}'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (candidate.caregiverRole != null) ...<Widget>[
                const SizedBox(height: 5),
                Text(
                  'Quan hệ: ${_familyRoleLabel(candidate.caregiverRole!)}',
                  key: Key('birth-family-role-${candidate.siteId}'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (candidate.familyOriginSummary != null) ...<Widget>[
                const SizedBox(height: 5),
                Text(
                  candidate.familyOriginSummary!,
                  key: Key('birth-family-origin-${candidate.siteId}'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (candidate.familyMembers.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Text(
                  'Người lớn trong nhà',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                for (final BirthFamilyMemberSummary member
                    in candidate.familyMembers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      '${member.name} · ${_familyRoleLabel(member.roleToChild)} '
                      '· chăm sóc ${member.careSkill}/1000 · '
                      '${member.currentActivity ?? 'đang rảnh'} · '
                      '${member.canUseInfantFeed ? 'có quyền dùng sữa' : 'không có quyền dùng sữa'}',
                      key: Key(
                        'birth-family-member-${candidate.siteId}-${member.personId}',
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
              const SizedBox(height: 7),
              Wrap(
                spacing: 10,
                runSpacing: 5,
                children: <Widget>[
                  Text('Sữa ${candidate.infantFeedQuantity ?? 0} ml'),
                  Text('Ăn ${candidate.foodQuantity ?? 0} g'),
                  Text('Nước ${candidate.waterQuantity ?? 0} ml'),
                  Text('Củi ${candidate.fuelQuantity ?? 0} g'),
                ],
              ),
              const SizedBox(height: 7),
              if (candidate.risks.isEmpty)
                const Text(
                  'Không có cảnh báo nguồn lực ban đầu.',
                  style: TextStyle(color: Color(0xff9dbb73), fontSize: 12),
                )
              else
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: <Widget>[
                    for (int index = 0; index < candidate.risks.length; index++)
                      Chip(
                        key: Key('birth-risk-${candidate.siteId}-$index'),
                        avatar: const Icon(Icons.warning_amber, size: 15),
                        label: Text(candidate.risks[index]),
                      ),
                  ],
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
            if (worldMap.genesis
                case final WorldGenesisRecord genesis) ...<Widget>[
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
              if (region.region.climateCode != 'unspecified')
                Text(
                  '${_climateLabel(region.region.climateCode)} · '
                  'đáy ${region.region.valleyFloorElevationM} m · '
                  'vành ${region.region.rimElevationM} m · '
                  'mưa ${region.region.annualRainfallMm} mm/năm',
                  key: Key('region-terrain-${region.region.id}'),
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
                      '${site.population} người · ${site.itemCount} vật'
                      '${site.site.terrainCode == 'unspecified' ? '' : ' · cao ${site.site.elevationM} m'}',
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tọa độ: (${_km(site.site.center.xMm)}, '
                          '${_km(site.site.center.yMm)}) km\n'
                          'Bán kính: ${_km(site.site.radiusMm)} km\n'
                          '${site.site.terrainCode == 'unspecified' ? '' : 'Địa hình: ${_terrainProfileLabel(site.site.terrainCode)} · cao ${site.site.elevationM} m\n'}'
                          '${site.site.resourceDeposits.isEmpty ? '' : 'Nguồn tự nhiên:\n${site.site.resourceDeposits.map(_naturalResourceSummary).join('\n')}\n'}'
                          '${site.site.ecologicalPopulations.isEmpty ? '' : 'Quần thể sinh thái:\n${site.site.ecologicalPopulations.map(_ecologicalPopulationSummary).join('\n')}\n'}'
                          '${site.site.settlementAssessment == null ? '' : '${_settlementAssessmentSummary(site.site.settlementAssessment!)}\n'}'
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

String _terrainProfileLabel(String terrain) => switch (terrain) {
  'alluvial_terrace' => 'Bậc phù sa',
  'river_channel' => 'Lòng suối',
  'floodplain' => 'Bãi bồi',
  'mountain_pass' => 'Đèo núi',
  _ => terrain,
};

String _climateLabel(String climate) => switch (climate) {
  'humid_monsoon_valley' => 'Thung lũng gió mùa ẩm',
  'seasonal_monsoon_valley' => 'Thung lũng gió mùa theo mùa',
  'dry_monsoon_valley' => 'Thung lũng gió mùa khô',
  _ => climate,
};

String _naturalResourceLabel(String kind) => switch (kind) {
  'surface_water' => 'Nước mặt',
  'fertile_topsoil' => 'Đất màu',
  'timber_stand' => 'Rừng gỗ',
  'mixed_stone_ore' => 'Đá và quặng hỗn hợp',
  _ => kind,
};

String _naturalResourceSummary(NaturalResourceDeposit resource) =>
    '${_naturalResourceLabel(resource.kind)}: '
    '${resource.quantity}/${resource.capacity} ${resource.unit} · '
    'chất lượng ${resource.quality}/1000 · '
    'tiếp cận ${resource.accessibility}/1000 · '
    '${resource.renewable ? 'phục hồi ${resource.annualRenewal} ${resource.unit}/năm' : 'không tái tạo'}';

String _ecologicalSpeciesLabel(String species) => switch (species) {
  'river_reed' => 'Sậy ven sông',
  'meadow_grass' => 'Cỏ đồng',
  'field_hare' => 'Thỏ đồng',
  'upland_pine' => 'Thông sườn cao',
  'muntjac_deer' => 'Mang rừng',
  _ => species,
};

String _ecologicalPopulationSummary(EcologicalPopulationState population) =>
    '${_ecologicalSpeciesLabel(population.speciesCode)}: '
    '${population.population}/${population.carryingCapacity} cá thể · '
    'sức khỏe ${population.health}/1000'
    '${population.requiredResourceKind == null ? '' : ' · cần ${_naturalResourceLabel(population.requiredResourceKind!)}'}'
    '${population.foodSpeciesCode == null ? '' : ' · ăn ${_ecologicalSpeciesLabel(population.foodSpeciesCode!)}'}';

String _settlementAssessmentSummary(SettlementAssessmentState assessment) =>
    'Khu dân cư: ${assessment.score}/1000 · '
    '${assessment.viable ? 'đủ nền tảng' : 'chưa đủ nền tảng'} · '
    '${assessment.selectedForBirthHousehold ? 'được lịch sử chọn cho hộ mới' : 'không được chọn cho hộ mới'}\n'
    '${assessment.reasons.map((String value) => '• $value').join('\n')}';

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
                if (person.occupationName != null)
                  Text('Nghề chính: ${person.occupationName}'),
                if (person.originSummary != null) ...<Widget>[
                  const SizedBox(height: 5),
                  Text(person.originSummary!, style: small),
                ],
                if (person.beliefs.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'Điều đã biết: ${person.beliefs.length} bằng chứng',
                    key: Key('knowledge-count-${person.id}'),
                  ),
                  for (final BeliefState belief in person.recentBeliefs)
                    Text(
                      '• ${belief.summary} · '
                      '${belief.acquisition == KnowledgeAcquisition.observation ? 'tự thấy' : 'nghe từ ${belief.sourcePersonId}'} · '
                      'tin cậy ${belief.confidence}/1000 · '
                      '${belief.transmissionCount} chặng truyền',
                      style: small,
                    ),
                ],
                if (person.socialRelations.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'Quan hệ ngoài hộ: ${person.socialRelations.length} người',
                    key: Key('social-relations-${person.id}'),
                  ),
                  for (final MapEntry<String, SocialRelationState> relation
                      in person.socialRelations.entries)
                    Text(
                      '${relation.key}: quen ${relation.value.familiarity}, '
                      'tin đổi hàng ${relation.value.tradeTrust}, '
                      'tin lời ${relation.value.informationTrust}, '
                      'thiện cảm ${relation.value.goodwill}, '
                      'bất mãn ${relation.value.resentment} · '
                      'gặp ${relation.value.encounterCount} lần, '
                      'đổi thành công ${relation.value.successfulTrades} lần'
                      '${relation.value.failedTrades > 0 ? ', hỏng ${relation.value.failedTrades} lần' : ''} · '
                      'nhận ${relation.value.receivedReports} tin'
                      '${relation.value.refusedResourceAid > 0 ? ' · bị từ chối giúp ${relation.value.refusedResourceAid} lần' : ''}',
                      key: Key(
                        'social-relation-${person.id}-${relation.value.otherPersonId}',
                      ),
                      style: small,
                    ),
                ],
                if (person.positionMm != null)
                  Text('Vị trí: ${person.positionMm} mm trên trục nhà'),
                if (person.careSkill != null)
                  Text(
                    'Chăm sóc: ${person.available == false ? 'đang gián đoạn' : 'sẵn sàng'}'
                    ' · kỹ năng ${person.careSkill}/1000',
                  ),
                if (person.familyRelationships.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    'Gia đình: ${person.familyRelationships.entries.map((MapEntry<String, String> value) => '${_familyRoleLabel(value.value)} ${value.key}').join(' · ')}',
                    key: Key('family-relationships-${person.id}'),
                    style: small,
                  ),
                ],
                if (person.familyBonds.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 5),
                  for (final MapEntry<String, FamilyBondState> bond
                      in person.familyBonds.entries)
                    Text(
                      '${bond.key}: tình cảm ${bond.value.affection}, '
                      'tin cậy ${bond.value.trust}, nghĩa vụ chăm sóc '
                      '${bond.value.careObligation} · đã chăm '
                      '${bond.value.careGiven} lần, được chăm '
                      '${bond.value.careReceived} lần · chứng kiến giữ lời '
                      '${bond.value.witnessedPromisesKept}, thất hứa '
                      '${bond.value.witnessedPromisesBroken}',
                      key: Key('family-bond-${person.id}-${bond.key}'),
                      style: small,
                    ),
                ],
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

String _familyRoleLabel(String role) => switch (role) {
  'mother' => 'mẹ ruột',
  'father' => 'cha ruột',
  'guardian' => 'người giám hộ',
  'child' => 'con',
  'ward' => 'con nuôi',
  _ => role,
};

String _careAgreementReason(String reason) => switch (reason) {
  'care_burden_balanced' => 'Chia đều gánh nặng chăm sóc',
  'highest_care_commitment' => 'Ưu tiên người có cam kết chăm sóc cao nhất',
  'no_accepted_caregiver' => 'Chưa ai chấp nhận hoặc đủ điều kiện nhận ca',
  _ => reason,
};

String _careSupportReason(String reason) => switch (reason) {
  'care_plan_missing' => 'Chưa có kế hoạch chăm cho giờ này',
  'shift_uncovered' => 'Ca chưa có người nhận',
  'planned_caregiver_missing' => 'Người trực không còn trong thế giới',
  'planned_caregiver_unavailable' => 'Người trực tạm thời không sẵn sàng',
  'planned_caregiver_busy' => 'Người trực mắc nghĩa vụ khác',
  'planned_caregiver_ineligible' => 'Người trực không còn đủ điều kiện',
  _ => reason,
};

String _careSupportStatus(FamilyCareSupportStatus status) => switch (status) {
  FamilyCareSupportStatus.pending => 'đang chờ người nhận',
  FamilyCareSupportStatus.fulfilled => 'đã có người hỗ trợ',
  FamilyCareSupportStatus.failed => 'không tìm được người hỗ trợ',
  FamilyCareSupportStatus.expired => 'đã chờ quá hạn',
};

String _careConflictStatus(FamilyCareConflictStatus status) => switch (status) {
  FamilyCareConflictStatus.open => 'đang chờ đối thoại',
  FamilyCareConflictStatus.repaired => 'đã hòa giải',
  FamilyCareConflictStatus.unresolved => 'chưa giải quyết được',
};

String _carePromiseStatus(FamilyCarePromiseStatus status) => switch (status) {
  FamilyCarePromiseStatus.active => 'đang có hiệu lực',
  FamilyCarePromiseStatus.fulfilled => 'đã giữ lời',
  FamilyCarePromiseStatus.broken => 'đã thất hứa',
};

String _householdMemberName(HouseholdView household, String personId) =>
    household.members
        .where((HouseholdMemberView member) => member.id == personId)
        .map((HouseholdMemberView member) => member.name)
        .firstOrNull ??
    personId;

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
            detail: 'Đã mở vùng, địa điểm, seed và tiền sử vĩ mô',
          ),
          const _RoadmapLine(
            icon: Icons.self_improvement_outlined,
            title: 'Tu luyện và công pháp',
            detail: 'Chưa mở trong bản hiện tại',
          ),
          const _RoadmapLine(
            icon: Icons.groups_outlined,
            title: 'Quan hệ và tổ chức',
            detail: 'Đã mở gia đình tối thiểu; xã hội sâu đang chờ',
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
        player.childhood != null
            ? player.childhood!.stage.label
            : player.infancy?.crying == true
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
          if (player.childhood case final ChildhoodView childhood) ...<Widget>[
            const Divider(height: 24),
            Text(
              'Giai đoạn phát triển: ${childhood.stage.label}',
              key: const Key('child-development-stage'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _NeedLine(label: 'An toàn', value: childhood.security),
            _NeedLine(label: 'Vận động lớn', value: childhood.grossMotor),
            _NeedLine(label: 'Vận động tinh', value: childhood.fineMotor),
            _NeedLine(
              label: 'Hiểu ngôn ngữ',
              value: childhood.receptiveLanguage,
            ),
            _NeedLine(label: 'Tạo lời', value: childhood.expressiveLanguage),
            const SizedBox(height: 12),
            const _SectionLabel(label: 'CƠ THỂ VÀ DINH DƯỠNG'),
            const SizedBox(height: 6),
            Text(
              'Khối lượng ${(childhood.body.massGrams / 1000).toStringAsFixed(2)} kg · '
              'mốc khỏe ${(childhood.body.expectedMassGrams / 1000).toStringAsFixed(2)} kg',
              key: const Key('child-body-mass'),
            ),
            _NeedLine(label: 'Dinh dưỡng', value: childhood.body.nutrition),
            _NeedLine(label: 'Đủ nước', value: childhood.body.hydration),
            Text(
              'Hỗ trợ phát triển: ${childhood.body.developmentSupport}/1000 · '
              'tuổi trưởng thành tương đương ${childhood.maturationEquivalentDays} ngày',
            ),
            Text(
              'Khẩu phần gần nhất: ${childhood.body.lastFoodGrams} g thức ăn · '
              '${childhood.body.lastWaterMl} ml nước · '
              'tăng ${childhood.body.lastGrowthGrams} g',
            ),
            Text(
              'Ngày tăng trưởng đủ điều kiện ${childhood.body.supportedGrowthDays} · '
              'bị hạn chế ${childhood.body.constrainedGrowthDays}',
            ),
            const SizedBox(height: 8),
            Text(
              'Kinh nghiệm: quan sát ${childhood.observationExperience} · '
              'vận động ${childhood.movementPractice} · '
              'ngôn ngữ ${childhood.languageExposure} · '
              'chơi ${childhood.playExperience}',
              key: const Key('child-activity-experience'),
            ),
            Text(
              childhood.lastIntent == null
                  ? 'Chưa có hoạt động tuổi thơ do người chơi chọn.'
                  : 'Hoạt động gần nhất: ${childhood.lastIntent!.label}',
            ),
            Text(
              'Vận động/chơi đã xong: ${childhood.completedPhysicalActivities} · '
              'thành công ${childhood.successfulPhysicalActivities} · '
              'chưa thành công ${childhood.failedPhysicalActivities}',
              key: const Key('child-physical-activity-summary'),
            ),
            Text(
              'Quan sát/ngôn ngữ đã xong: ${childhood.completedLearningActivities} · '
              'học được ${childhood.successfulLearningActivities} · '
              'chưa học được ${childhood.failedLearningActivities}',
              key: const Key('child-learning-activity-summary'),
            ),
            if (childhood.lastOutcome != null)
              Text(
                'Kết quả gần nhất: '
                '${childhood.lastOutcome == 'succeeded' ? 'thành công' : 'chưa thành công'} · '
                'phòng ${childhood.lastActivityRoomId ?? 'không rõ'} · '
                'vật ${childhood.lastActivityItemId ?? 'không dùng'} · '
                '${(childhood.lastActivityDurationSeconds ?? 0) ~/ 60} phút',
              ),
            if (childhood.activeActivity != null)
              Text(
                'Đang thực hiện: ${childhood.activeActivity} · còn '
                '${((childhood.activeActivityEndsAtSeconds! - world.time.seconds).clamp(0, 86400) / 60).ceil()} phút',
                key: const Key('child-activity-active'),
              ),
            if (childhood.learningRecords.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              const _SectionLabel(label: 'ĐIỀU ĐÃ HỌC CÓ NGUỒN'),
              const SizedBox(height: 6),
              for (final ChildLearningView learning
                  in childhood.learningRecords.take(4))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    learning.sourceObjectId == null
                        ? Icons.record_voice_over_outlined
                        : Icons.visibility_outlined,
                  ),
                  title: Text(learning.summary),
                  subtitle: Text(
                    'Qua ${learning.activity == 'observe' ? 'quan sát' : 'đáp lời'} · '
                    'nguồn ${learning.sourceObjectId ?? learning.sourcePersonId} · '
                    'tin cậy ${learning.confidence}/1000',
                  ),
                ),
            ],
            if (childhood.recentMemories.isNotEmpty ||
                childhood.memoryAnchors.isNotEmpty ||
                childhood.memorySummaries.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              const _SectionLabel(label: 'KÝ ỨC TUỔI THƠ'),
              const SizedBox(height: 6),
              Text(
                'Chi tiết gần đây ${childhood.recentMemories.length} · '
                'ký ức nổi bật ${childhood.memoryAnchors.length} · '
                'giai đoạn đã tóm tắt ${childhood.memorySummaries.length} · '
                'đã nén ${childhood.compressedMemoryCount} lần nhớ',
                key: const Key('child-memory-counts'),
              ),
              for (final ChildMemoryEpisodeState memory
                  in childhood.recentMemories.take(3))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: Text(memory.summary),
                  subtitle: Text(
                    'Cách đây '
                    '${((world.time.seconds - memory.atSeconds).clamp(0, 1 << 62)) ~/ gameSecondsPerDay} ngày · '
                    'nguồn ${memory.sourceIds.isEmpty ? 'không có' : memory.sourceIds.join(', ')}',
                  ),
                ),
              for (final ChildMemoryEpisodeState memory
                  in childhood.memoryAnchors.take(3))
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bookmark_outline),
                  title: Text(memory.summary),
                  subtitle: Text(
                    'Ký ức nổi bật · mức ${memory.importance}/1000 · '
                    'cách đây '
                    '${((world.time.seconds - memory.atSeconds).clamp(0, 1 << 62)) ~/ gameSecondsPerDay} ngày',
                  ),
                ),
              if (childhood.memorySummaries.firstOrNull
                  case final ChildMemorySummaryState summary)
                Text(
                  summary.periodIndex < 0
                      ? 'Thời kỳ cũ: ${summary.episodeCount} lần nhớ · '
                            '${summary.successCount} thành công · '
                            '${summary.failureCount} chưa thành công · '
                            '${summary.hazardCount} liên quan nguy hiểm'
                      : 'Tháng tuổi thơ ${summary.periodIndex + 1}: '
                            '${summary.episodeCount} lần nhớ · '
                            '${summary.successCount} thành công · '
                            '${summary.failureCount} chưa thành công · '
                            '${summary.hazardCount} liên quan nguy hiểm',
                ),
            ],
            if (childhood.caregiverPreferenceScores.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              const _SectionLabel(label: 'NGƯỜI TRẺ CÓ XU HƯỚNG TÌM ĐẾN'),
              const SizedBox(height: 6),
              for (final MapEntry<String, int> preference
                  in (childhood.caregiverPreferenceScores.entries.toList()
                    ..sort(
                      (MapEntry<String, int> a, MapEntry<String, int> b) =>
                          b.value.compareTo(a.value),
                    )))
                Text(
                  '${preference.key}: ${preference.value} điểm trải nghiệm',
                  key: Key('child-caregiver-preference-${preference.key}'),
                ),
            ],
            if (childhood.lastHazard
                case final ChildHazardIncidentState hazard) ...<Widget>[
              const SizedBox(height: 12),
              const _SectionLabel(label: 'NGUY HIỂM TUỔI THƠ GẦN NHẤT'),
              const SizedBox(height: 6),
              Text(
                'Mất thăng bằng trên nền · mức ${hazard.severity}/1000 · '
                '${hazard.noticedBeforeHarm ? 'đã nhận ra trước khi ngã' : 'không nhận ra kịp'}',
              ),
              Text(
                'Phản ứng: ${hazard.childReaction == 'fell_and_cried' ? 'ngã và khóc' : 'dừng lại, tìm người an toàn'}',
              ),
              Text(
                'Người được tìm đến: ${hazard.caregiverId ?? 'không có'} · '
                'kết quả ${hazard.outcome == 'pending'
                    ? 'đang chờ'
                    : hazard.outcome == 'soothed'
                    ? 'được trấn an'
                    : 'không được đáp ứng'} · '
                'an toàn ${hazard.securityChange >= 0 ? '+' : ''}${hazard.securityChange}',
                key: const Key('child-hazard-outcome'),
              ),
              Text(
                'Tổng sự cố ${childhood.hazardIncidents} · nhận ra sớm '
                '${childhood.hazardsNoticedBeforeHarm} · được người chăm giải quyết '
                '${childhood.hazardsResolvedByCaregiver}',
              ),
            ],
          ],
          if ((player.childhood == null ? player.infancy : null)
              case final InfantView infancy) ...<Widget>[
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
            if (infancy.careExpectations.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              const _SectionLabel(label: 'KỲ VỌNG VỀ TỪNG NGƯỜI CHĂM'),
              const SizedBox(height: 6),
              for (final InfantCareExpectationState expectation
                  in infancy.careExpectations.values)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.psychology_alt_outlined),
                  title: Text('Người chăm ${expectation.caregiverId}'),
                  subtitle: Text(
                    'An toàn ${expectation.safety}/1000 · dễ đoán '
                    '${expectation.predictability}/1000 · đáp ứng '
                    '${expectation.successfulResponses}, muộn '
                    '${expectation.delayedResponses}, bỏ lỡ '
                    '${expectation.missedResponses} · chờ trung bình '
                    '${expectation.averageResponseSeconds ~/ 60} phút',
                  ),
                ),
            ],
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
  const _HouseholdPanel({
    required this.household,
    required this.productionBatches,
    required this.serviceAppointments,
    required this.laborOffers,
    required this.laborClaims,
    required this.marketOffers,
    required this.marketOrders,
    required this.marketShipments,
    required this.supplyShocks,
    required this.personNames,
    required this.currentSeconds,
  });

  final HouseholdView? household;
  final List<ProductionBatchState> productionBatches;
  final List<ServiceAppointmentState> serviceAppointments;
  final List<LaborOfferState> laborOffers;
  final Map<String, LaborCompensationClaim> laborClaims;
  final List<MarketOfferState> marketOffers;
  final List<MarketOrderState> marketOrders;
  final List<MarketShipmentState> marketShipments;
  final List<SupplyShockState> supplyShocks;
  final Map<String, String> personNames;
  final int currentSeconds;

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
                  if (value.familyCarePlan
                      case final FamilyCarePlanState carePlan) ...<Widget>[
                    const Divider(height: 28),
                    const _SectionLabel(label: 'PHÂN CA CHĂM TRẺ'),
                    const SizedBox(height: 8),
                    Text(
                      'Ngày ${carePlan.day} · lần thương lượng ${carePlan.revision}',
                      key: const Key('family-care-plan'),
                    ),
                    const SizedBox(height: 8),
                    for (final FamilyCareShiftState shift in carePlan.shifts)
                      ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.schedule_outlined),
                        title: Text(
                          '${_clock(shift.startSecondOfDay)}–'
                          '${_clock(shift.endSecondOfDay)} · '
                          '${value.members.where((HouseholdMemberView member) => member.id == shift.caregiverId).map((HouseholdMemberView member) => member.name).firstOrNull ?? 'Chưa có người nhận'}',
                        ),
                        subtitle: Text(
                          shift.declinedPersonIds.isEmpty
                              ? _careAgreementReason(shift.reason)
                              : '${_careAgreementReason(shift.reason)} · '
                                    '${shift.declinedPersonIds.length} người không nhận được ca',
                        ),
                      ),
                    if (value.familyCareSupportRequests.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        'Ca vỡ gần nhất',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Builder(
                        builder: (BuildContext context) {
                          final FamilyCareSupportRequestState request =
                              value.familyCareSupportRequests.last;
                          final String supporter =
                              value.members
                                  .where(
                                    (HouseholdMemberView member) =>
                                        member.id == request.supporterId,
                                  )
                                  .map(
                                    (HouseholdMemberView member) => member.name,
                                  )
                                  .firstOrNull ??
                              _careSupportStatus(request.status);
                          final int? delay = request.responseDelaySeconds;
                          return Text(
                            '${_careSupportReason(request.reason)} · $supporter'
                            '${delay == null ? '' : ' · chờ ${delay ~/ 60} phút'}'
                            ' · ${request.attempts} lần tìm',
                            key: const Key('family-care-support-latest'),
                          );
                        },
                      ),
                    ],
                    if (value
                        .familyCareReliabilityByPersonId
                        .isNotEmpty) ...<Widget>[
                      const SizedBox(height: 14),
                      Text(
                        'Độ đáng tin khi chăm sóc',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      for (final MapEntry<String, FamilyCareReliabilityState>
                          entry
                          in value.familyCareReliabilityByPersonId.entries)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.verified_user_outlined),
                          title: Text(_householdMemberName(value, entry.key)),
                          subtitle: Text(
                            '${entry.value.score}/1000 · ứng cứu '
                            '${entry.value.emergencyResponses} · giữ lời '
                            '${entry.value.promisesKept}/${entry.value.promisesMade} · '
                            'thất hứa ${entry.value.promisesBroken}',
                          ),
                        ),
                    ],
                    if (value
                        .familyCareBurdenByPersonId
                        .isNotEmpty) ...<Widget>[
                      const SizedBox(height: 14),
                      Text(
                        'Gánh nặng và nghĩa vụ bù',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      for (final MapEntry<String, FamilyCareBurdenState> entry
                          in value.familyCareBurdenByPersonId.entries)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.balance_outlined),
                          title: Text(
                            value.members
                                    .where(
                                      (HouseholdMemberView member) =>
                                          member.id == entry.key,
                                    )
                                    .map(
                                      (HouseholdMemberView member) =>
                                          member.name,
                                    )
                                    .firstOrNull ??
                                entry.key,
                          ),
                          subtitle: Text(
                            'Nghĩa vụ bù ${entry.value.careDebt}/1000 · '
                            'quá tải ${entry.value.strain}/1000 · '
                            'gánh khẩn cấp ${entry.value.emergencyShiftsTaken} · '
                            'bỏ ca ${entry.value.missedPlannedShifts}',
                          ),
                        ),
                    ],
                    if (value.familyCareConflicts.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 14),
                      Text(
                        'Mâu thuẫn do phân ca',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      for (final FamilyCareConflictState conflict
                          in value.familyCareConflicts.reversed.take(3))
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            conflict.status == FamilyCareConflictStatus.repaired
                                ? Icons.handshake_outlined
                                : Icons.record_voice_over_outlined,
                          ),
                          title: Text(
                            '${_householdMemberName(value, conflict.supporterId)} ↔ '
                            '${_householdMemberName(value, conflict.responsibleId)}',
                          ),
                          subtitle: Text(
                            '${_careConflictStatus(conflict.status)} · '
                            'mức ${conflict.severity}/1000',
                          ),
                        ),
                    ],
                    if (value.familyCarePromises.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 14),
                      Text(
                        'Lời hứa bù ca',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      for (final FamilyCarePromiseState promise
                          in value.familyCarePromises.reversed.take(3))
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            promise.status == FamilyCarePromiseStatus.fulfilled
                                ? Icons.task_alt_outlined
                                : Icons.assignment_outlined,
                          ),
                          title: Text(
                            '${_householdMemberName(value, promise.debtorId)} hứa bù '
                            '${promise.promisedShifts} ca cho '
                            '${_householdMemberName(value, promise.beneficiaryId)}',
                          ),
                          subtitle: Text(
                            '${_carePromiseStatus(promise.status)} · '
                            'hạn ngày ${promise.dueDay} · '
                            'đã nhận ${promise.assignedShifts}/${promise.promisedShifts}',
                          ),
                        ),
                    ],
                  ],
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
                  if (productionBatches.isNotEmpty) ...<Widget>[
                    const Divider(height: 28),
                    const _SectionLabel(label: 'MẺ SẢN XUẤT & WORKPIECE'),
                    const SizedBox(height: 10),
                    _ProductionBatchPanel(
                      household: value,
                      batches: productionBatches,
                      currentSeconds: currentSeconds,
                    ),
                  ],
                  if (serviceAppointments.isNotEmpty) ...<Widget>[
                    const Divider(height: 28),
                    const _SectionLabel(label: 'LỊCH DỊCH VỤ'),
                    const SizedBox(height: 10),
                    _ServiceAppointmentPanel(
                      household: value,
                      appointments: serviceAppointments,
                      currentSeconds: currentSeconds,
                    ),
                  ],
                  if (laborOffers.isNotEmpty) ...<Widget>[
                    const Divider(height: 28),
                    const _SectionLabel(label: 'LỜI MỜI & NGHĨA VỤ LAO ĐỘNG'),
                    const SizedBox(height: 10),
                    _LaborOfferPanel(
                      household: value,
                      offers: laborOffers,
                      claims: laborClaims,
                      currentSeconds: currentSeconds,
                    ),
                  ],
                  if (marketOffers.isNotEmpty) ...<Widget>[
                    const Divider(height: 28),
                    const _SectionLabel(label: 'CHỢ ĐỊA PHƯƠNG & ESCROW'),
                    const SizedBox(height: 10),
                    _MarketPanel(
                      offers: marketOffers,
                      orders: marketOrders,
                      shipments: marketShipments,
                      personNames: personNames,
                    ),
                  ],
                  if (supplyShocks.isNotEmpty) ...<Widget>[
                    const Divider(height: 28),
                    const _SectionLabel(label: 'THIẾU HÀNG & THÍCH ỨNG'),
                    const SizedBox(height: 10),
                    _SupplyShockPanel(
                      household: value,
                      shocks: supplyShocks,
                      currentSeconds: currentSeconds,
                    ),
                  ],
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
                        label: 'Ca chăm bị vỡ',
                        value: '${value.familyCareSupportRequests.length}',
                        icon: Icons.event_busy_outlined,
                      ),
                      _MetricTile(
                        label: 'Lần gọi hỗ trợ thành công',
                        value:
                            '${value.familyCareSupportRequests.where((FamilyCareSupportRequestState request) => request.status == FamilyCareSupportStatus.fulfilled).length}',
                        icon: Icons.support_agent_outlined,
                      ),
                      _MetricTile(
                        label: 'Đang chờ hỗ trợ',
                        value:
                            '${value.familyCareSupportRequests.where((FamilyCareSupportRequestState request) => request.status == FamilyCareSupportStatus.pending).length}',
                        icon: Icons.hourglass_top_outlined,
                      ),
                      _MetricTile(
                        label: 'Chờ quá hạn',
                        value:
                            '${value.familyCareSupportRequests.where((FamilyCareSupportRequestState request) => request.status == FamilyCareSupportStatus.expired).length}',
                        icon: Icons.person_off_outlined,
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

class _ProductionBatchPanel extends StatelessWidget {
  const _ProductionBatchPanel({
    required this.household,
    required this.batches,
    required this.currentSeconds,
  });

  final HouseholdView household;
  final List<ProductionBatchState> batches;
  final int currentSeconds;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('production-batch-panel'),
    children: <Widget>[
      for (final ProductionBatchState batch in batches)
        Card(
          key: Key('production-batch-${batch.id}'),
          color: const Color(0xff111611),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      switch (batch.status) {
                        ProductionBatchStatus.inProgress =>
                          Icons.precision_manufacturing_outlined,
                        ProductionBatchStatus.completed =>
                          Icons.inventory_2_outlined,
                        ProductionBatchStatus.blocked =>
                          Icons.report_problem_outlined,
                      },
                      color: switch (batch.status) {
                        ProductionBatchStatus.inProgress => const Color(
                          0xffc6a56a,
                        ),
                        ProductionBatchStatus.completed => const Color(
                          0xff83b993,
                        ),
                        ProductionBatchStatus.blocked => const Color(
                          0xffd49a68,
                        ),
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            batch.recipe.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${_productionStatusLabel(batch.status)} · '
                            '${_productionActorName(household, batch.actorId)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  batch.status == ProductionBatchStatus.inProgress
                      ? 'Còn ${((batch.completesAtSeconds - currentSeconds).clamp(0, batch.recipe.durationSeconds) / 60).ceil()} phút trong game'
                      : 'Bắt đầu ${_absoluteGameTime(batch.startedAtSeconds)} · '
                            'kết thúc ${_absoluteGameTime(batch.finishedAtSeconds ?? batch.completesAtSeconds)}',
                  key: Key('production-time-${batch.id}'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Workpiece đang giữ ${batch.materials.length} lô nguyên liệu:',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: <Widget>[
                    for (final ProductionMaterialLot lot in batch.materials)
                      Chip(
                        key: Key(
                          'production-material-${batch.id}-${lot.itemId}',
                        ),
                        avatar: const Icon(Icons.category_outlined, size: 15),
                        label: Text(
                          '${_itemKindLabel(lot.kind)} ${lot.quantity} ${lot.unit} · chất lượng ${lot.condition}/1000',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Công cụ: ${batch.toolItemId == null ? 'không cần' : '${_itemKindLabel(batch.recipe.toolKind!)} · ${batch.toolItemId} · hao ${batch.recipe.toolWear}/1000'}',
                  key: Key('production-tool-${batch.id}'),
                ),
                const SizedBox(height: 4),
                Text(
                  'Đầu ra: ${_itemKindLabel(batch.recipe.outputKind)} '
                  '${batch.recipe.outputQuantity} ${batch.recipe.outputUnit} · '
                  '${batch.status == ProductionBatchStatus.completed ? 'đã vào kho ${batch.outputItemId}' : 'chưa xuất hiện trong kho'}',
                  key: Key('production-output-${batch.id}'),
                ),
                if (batch.failureReason != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    'Bị chặn: ${_productionFailureLabel(batch.failureReason!)}. '
                    'Nguyên liệu vẫn nằm trong workpiece.',
                    key: Key('production-blocked-${batch.id}'),
                    style: const TextStyle(color: Color(0xffd49a68)),
                  ),
                ],
              ],
            ),
          ),
        ),
    ],
  );
}

String _productionActorName(HouseholdView household, String actorId) =>
    household.members
        .where((HouseholdMemberView value) => value.id == actorId)
        .map((HouseholdMemberView value) => value.name)
        .firstOrNull ??
    actorId;

String _productionStatusLabel(ProductionBatchStatus status) => switch (status) {
  ProductionBatchStatus.inProgress => 'đang chế tác',
  ProductionBatchStatus.completed => 'đã hoàn tất',
  ProductionBatchStatus.blocked => 'bị chặn',
};

String _productionFailureLabel(String reason) => switch (reason) {
  'labor_commitment_missing' => 'người làm không còn giữ ca',
  'actor_left_workplace' => 'người làm đã rời nơi chế tác',
  'tool_unavailable' => 'công cụ không còn dùng được tại chỗ',
  'output_ledger_changed' => 'kho đầu ra đã đổi sai loại hoặc quyền sở hữu',
  _ => reason,
};

String _absoluteGameTime(int seconds) {
  final int day = seconds ~/ gameSecondsPerDay;
  final int secondOfDay = seconds % gameSecondsPerDay;
  return 'ngày $day ${_clock(secondOfDay)}';
}

class _ServiceAppointmentPanel extends StatelessWidget {
  const _ServiceAppointmentPanel({
    required this.household,
    required this.appointments,
    required this.currentSeconds,
  });

  final HouseholdView household;
  final List<ServiceAppointmentState> appointments;
  final int currentSeconds;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('service-appointment-panel'),
    children: <Widget>[
      for (final ServiceAppointmentState appointment in appointments)
        Card(
          key: Key('service-appointment-${appointment.id}'),
          color: const Color(0xff111611),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      switch (appointment.status) {
                        ServiceAppointmentStatus.booked =>
                          Icons.event_available_outlined,
                        ServiceAppointmentStatus.inProgress =>
                          Icons.people_alt_outlined,
                        ServiceAppointmentStatus.completed =>
                          Icons.verified_outlined,
                        ServiceAppointmentStatus.blocked =>
                          Icons.event_busy_outlined,
                      },
                      color: switch (appointment.status) {
                        ServiceAppointmentStatus.booked => const Color(
                          0xffc6a56a,
                        ),
                        ServiceAppointmentStatus.inProgress => const Color(
                          0xff8fb6d9,
                        ),
                        ServiceAppointmentStatus.completed => const Color(
                          0xff83b993,
                        ),
                        ServiceAppointmentStatus.blocked => const Color(
                          0xffd49a68,
                        ),
                      },
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            appointment.definition.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            _serviceStatusLabel(appointment.status),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Người cung cấp: ${_productionActorName(household, appointment.providerId)} · '
                  'người nhận: ${_productionActorName(household, appointment.recipientId)}',
                  key: Key('service-participants-${appointment.id}'),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_absoluteGameTime(appointment.startsAtSeconds)}–'
                  '${_absoluteGameTime(appointment.endsAtSeconds)}'
                  '${appointment.status == ServiceAppointmentStatus.booked ? ' · còn ${((appointment.startsAtSeconds - currentSeconds).clamp(0, appointment.startsAtSeconds) / 60).ceil()} phút tới giờ hẹn' : ''}',
                  key: Key('service-time-${appointment.id}'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Vật tư đã giữ: ${appointment.materials.isEmpty ? 'không có' : '${appointment.materials.length} lô'}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                if (appointment.materials.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: <Widget>[
                      for (final ProductionMaterialLot lot
                          in appointment.materials)
                        Chip(
                          key: Key(
                            'service-material-${appointment.id}-${lot.itemId}',
                          ),
                          avatar: const Icon(
                            Icons.inventory_outlined,
                            size: 15,
                          ),
                          label: Text(
                            '${_itemKindLabel(lot.kind)} ${lot.quantity} ${lot.unit} · chất lượng ${lot.condition}/1000',
                          ),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  appointment.resultClaim == null
                      ? 'Kết quả: chưa có claim; dịch vụ chưa hoàn tất.'
                      : 'Kết quả: ${_serviceClaimLabel(appointment.resultClaim!.kind)} · '
                            '${appointment.resultClaim!.id}',
                  key: Key('service-claim-${appointment.id}'),
                ),
                if (appointment.failureReason != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    'Bị chặn: ${_serviceFailureLabel(appointment.failureReason!)}. '
                    'Vật tư vẫn còn trong hồ sơ cuộc hẹn.',
                    key: Key('service-blocked-${appointment.id}'),
                    style: const TextStyle(color: Color(0xffd49a68)),
                  ),
                ],
              ],
            ),
          ),
        ),
    ],
  );
}

String _serviceStatusLabel(ServiceAppointmentStatus status) => switch (status) {
  ServiceAppointmentStatus.booked => 'đã giữ lịch hai phía',
  ServiceAppointmentStatus.inProgress => 'đang thực hiện',
  ServiceAppointmentStatus.completed => 'đã hoàn tất',
  ServiceAppointmentStatus.blocked => 'bị chặn',
};

String _serviceClaimLabel(String kind) => switch (kind) {
  'cooking_instruction_completed' => 'đã hoàn thành hướng dẫn nấu cháo',
  _ => kind,
};

String _serviceFailureLabel(String reason) => switch (reason) {
  'provider_absent' => 'người cung cấp vắng mặt',
  'recipient_absent' => 'người nhận vắng mặt',
  'participant_unavailable' => 'một người đang bận nghĩa vụ khác',
  'provider_commitment_missing' => 'người cung cấp không giữ trọn lịch',
  'recipient_commitment_missing' => 'người nhận không giữ trọn lịch',
  'provider_left_venue' => 'người cung cấp rời địa điểm',
  'recipient_left_venue' => 'người nhận rời địa điểm',
  _ => reason,
};

class _LaborOfferPanel extends StatelessWidget {
  const _LaborOfferPanel({
    required this.household,
    required this.offers,
    required this.claims,
    required this.currentSeconds,
  });

  final HouseholdView household;
  final List<LaborOfferState> offers;
  final Map<String, LaborCompensationClaim> claims;
  final int currentSeconds;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('labor-offer-panel'),
    children: <Widget>[
      for (final LaborOfferState offer in offers)
        Builder(
          builder: (BuildContext context) {
            final LaborCompensationClaim? claim =
                offer.compensationClaimId == null
                ? null
                : claims[offer.compensationClaimId];
            return Card(
              key: Key('labor-offer-${offer.id}'),
              color: const Color(0xff111611),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          switch (offer.status) {
                            LaborOfferStatus.offered =>
                              Icons.mark_email_unread_outlined,
                            LaborOfferStatus.accepted =>
                              Icons.assignment_turned_in_outlined,
                            LaborOfferStatus.refused =>
                              Icons.do_not_disturb_alt_outlined,
                            LaborOfferStatus.inProgress =>
                              Icons.engineering_outlined,
                            LaborOfferStatus.completed =>
                              Icons.task_alt_outlined,
                            LaborOfferStatus.blocked =>
                              Icons.warning_amber_outlined,
                          },
                          color:
                              offer.status == LaborOfferStatus.refused ||
                                  offer.status == LaborOfferStatus.blocked
                              ? const Color(0xffd49a68)
                              : offer.status == LaborOfferStatus.completed
                              ? const Color(0xff83b993)
                              : const Color(0xffc6a56a),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                offer.activity,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                '${_laborStatusLabel(offer.status)} · '
                                '${_productionActorName(household, offer.workerId)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Người thuê: ${_productionActorName(household, offer.employerId)} · '
                      'kỹ năng ${offer.skillCode} tối thiểu ${offer.minimumSkill}/1000 · '
                      'ưu tiên ${offer.priority}',
                      key: Key('labor-terms-${offer.id}'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_absoluteGameTime(offer.startsAtSeconds)}–'
                      '${_absoluteGameTime(offer.endsAtSeconds)}'
                      '${offer.status == LaborOfferStatus.accepted ? ' · còn ${((offer.startsAtSeconds - currentSeconds).clamp(0, offer.startsAtSeconds) / 60).ceil()} phút tới ca' : ''}',
                      key: Key('labor-time-${offer.id}'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quyền lợi đã hứa: ${_itemKindLabel(offer.compensation.itemKind)} '
                      '${offer.compensation.quantity} ${offer.compensation.unit}',
                      key: Key('labor-compensation-${offer.id}'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      claim == null
                          ? offer.status == LaborOfferStatus.refused ||
                                    offer.status == LaborOfferStatus.blocked
                                ? 'Khoản phải trả: không phát sinh vì công chưa hoàn tất.'
                                : 'Khoản phải trả: chưa phát sinh; công chưa hoàn tất.'
                          : 'Khoản phải trả ${claim.id}: '
                                '${claim.status == LaborClaimStatus.outstanding ? 'chưa thanh toán' : 'đã thanh toán'}',
                      key: Key('labor-claim-${offer.id}'),
                    ),
                    if (offer.decisionReason != null) ...<Widget>[
                      const SizedBox(height: 4),
                      Text(
                        'Lý do quyết định: ${_laborReasonLabel(offer.decisionReason!)}',
                        key: Key('labor-reason-${offer.id}'),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
    ],
  );
}

String _laborStatusLabel(LaborOfferStatus status) => switch (status) {
  LaborOfferStatus.offered => 'đang chờ quyết định',
  LaborOfferStatus.accepted => 'đã nhận việc',
  LaborOfferStatus.refused => 'đã từ chối',
  LaborOfferStatus.inProgress => 'đang làm',
  LaborOfferStatus.completed => 'đã làm xong',
  LaborOfferStatus.blocked => 'ca bị chặn',
};

String _laborReasonLabel(String reason) => switch (reason) {
  'conditions_met' => 'đủ kỹ năng, sức và lịch trống',
  'insufficient_skill' => 'chưa đủ kỹ năng tối thiểu',
  'schedule_conflict' => 'trùng một lịch đã nhận',
  'worker_strain' => 'mệt, đói, khát hoặc tâm trạng không đáp ứng mức ưu tiên',
  'currently_unavailable' => 'đang bận hoặc không đủ sức',
  'worker_absent' => 'không có mặt tại nơi làm',
  'worker_unavailable' => 'bị một nghĩa vụ khác giữ thời gian',
  'labor_commitment_missing' => 'không giữ trọn cam kết lao động',
  'worker_left_venue' => 'rời nơi làm trước khi xong',
  _ => reason,
};

class _MarketPanel extends StatelessWidget {
  const _MarketPanel({
    required this.offers,
    required this.orders,
    required this.shipments,
    required this.personNames,
  });

  final List<MarketOfferState> offers;
  final List<MarketOrderState> orders;
  final List<MarketShipmentState> shipments;
  final Map<String, String> personNames;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('market-panel'),
    children: <Widget>[
      for (final MarketOfferState offer in offers)
        Card(
          key: Key('market-offer-${offer.id}'),
          color: const Color(0xff111611),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      offer.status == MarketOfferStatus.open
                          ? Icons.storefront_outlined
                          : Icons.inventory_2_outlined,
                      color: offer.status == MarketOfferStatus.open
                          ? const Color(0xffc6a56a)
                          : const Color(0xff83b993),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${_itemKindLabel(offer.merchandise.kind)} tại chợ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${_marketOfferStatusLabel(offer.status)} · '
                            '${personNames[offer.sellerPersonId] ?? offer.sellerPersonId}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Hàng thật còn trong offer: ${offer.merchandise.quantity}/'
                  '${offer.offeredQuantity} ${offer.merchandise.unit} · '
                  'chất lượng ${offer.merchandise.condition}/1000',
                  key: Key('market-stock-${offer.id}'),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mỗi lot ${offer.lotQuantity} ${offer.merchandise.unit} đổi '
                  '${offer.paymentQuantityPerLot} ${offer.paymentUnit} '
                  '${_itemKindLabel(offer.paymentKind)}',
                  key: Key('market-price-${offer.id}'),
                ),
                const SizedBox(height: 4),
                Text(
                  'Người đã biết offer: ${offer.knownByPersonIds.map((String id) => personNames[id] ?? id).join(', ')}',
                  key: Key('market-known-${offer.id}'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                for (final MarketOrderState order in orders.where(
                  (MarketOrderState value) => value.offerId == offer.id,
                )) ...<Widget>[
                  const Divider(height: 22),
                  Container(
                    key: Key('market-order-${order.id}'),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xff0b100c),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${_marketOrderStatusLabel(order.status)} · '
                          '${personNames[order.buyerPersonId] ?? order.buyerPersonId}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lô hàng đã giữ: ${_itemKindLabel(order.merchandise.kind)} '
                          '${order.merchandise.quantity} ${order.merchandise.unit}',
                          key: Key('market-order-goods-${order.id}'),
                        ),
                        Text(
                          'Vật thanh toán đã giữ: ${_itemKindLabel(order.payment.kind)} '
                          '${order.payment.quantity} ${order.payment.unit}',
                          key: Key('market-order-payment-${order.id}'),
                        ),
                        Text(
                          order.status == MarketOrderStatus.settled
                              ? 'Đã đổi chủ: ${order.buyerTargetItemId} ↔ ${order.sellerTargetItemId}'
                              : 'Hai phía còn nằm trong escrow, chưa đổi chủ.',
                          key: Key('market-order-result-${order.id}'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        for (final MarketShipmentState shipment
                            in shipments.where(
                              (MarketShipmentState value) =>
                                  value.orderId == order.id,
                            )) ...<Widget>[
                          const Divider(height: 18),
                          Container(
                            key: Key('market-shipment-${shipment.id}'),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xff151d17),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    shipment.status ==
                                        MarketShipmentStatus.failed
                                    ? const Color(0xff8f5b50)
                                    : const Color(0xff34483a),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${_marketShipmentStatusLabel(shipment.status)} · '
                                  '${personNames[shipment.carrierId] ?? shipment.carrierId}',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tuyến ${shipment.routeId}: '
                                  '${shipment.pathWaypointIds.join(' → ')}',
                                  key: Key(
                                    'market-shipment-route-${shipment.id}',
                                  ),
                                ),
                                Text(
                                  '${_km(shipment.distanceMm)} km · dự kiến '
                                  '${(shipment.expectedArrivalSeconds - shipment.departedAtSeconds + 59) ~/ 60} phút · '
                                  'thực tế ${(shipment.scheduledArrivalSeconds - shipment.departedAtSeconds + 59) ~/ 60} phút '
                                  '(trễ ${(shipment.lateSeconds + 59) ~/ 60} phút)',
                                  key: Key(
                                    'market-shipment-time-${shipment.id}',
                                  ),
                                ),
                                Text(
                                  'Hàng đang giữ: ${_itemKindLabel(shipment.cargo.kind)} '
                                  '${shipment.cargo.quantity} ${shipment.cargo.unit} · '
                                  'chất lượng ${shipment.cargo.condition}/1000 · '
                                  'hao dự kiến ${shipment.plannedConditionLoss}',
                                  key: Key(
                                    'market-shipment-cargo-${shipment.id}',
                                  ),
                                ),
                                Text(
                                  shipment.status ==
                                          MarketShipmentStatus.delivered
                                      ? 'Đã vào ${shipment.destinationItemId} tại ${shipment.destinationRoomId}.'
                                      : shipment.status ==
                                            MarketShipmentStatus.failed
                                      ? 'Giao thất bại: ${_marketShipmentFailureLabel(shipment.failureReason)}; hàng vẫn nằm trong hồ sơ chuyến.'
                                      : 'Đích: ${shipment.destinationRoomId}; hàng đã rời kho đầu và chưa vào kho đích.',
                                  key: Key(
                                    'market-shipment-result-${shipment.id}',
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
    ],
  );
}

String _marketOfferStatusLabel(MarketOfferStatus status) => switch (status) {
  MarketOfferStatus.open => 'đang mở',
  MarketOfferStatus.exhausted => 'đã được giữ hết',
  MarketOfferStatus.cancelled => 'đã hủy',
};

String _marketOrderStatusLabel(MarketOrderStatus status) => switch (status) {
  MarketOrderStatus.reserved => 'đã giữ hai phía',
  MarketOrderStatus.settled => 'đã thanh toán',
  MarketOrderStatus.cancelled => 'đã hủy',
};

String _marketShipmentStatusLabel(MarketShipmentStatus status) =>
    switch (status) {
      MarketShipmentStatus.inTransit => 'đang vận chuyển',
      MarketShipmentStatus.delivered => 'đã giao vào kho',
      MarketShipmentStatus.failed => 'giao thất bại',
    };

String _marketShipmentFailureLabel(String? reason) => switch (reason) {
  'carrier_commitment_missing' => 'người chở mất cam kết hành trình',
  'destination_unavailable' => 'kho đích không còn hợp lệ',
  'destination_ledger_changed' => 'sổ vật tại kho đích đã đổi loại hoặc chủ',
  null => 'chưa rõ nguyên nhân',
  _ => reason,
};

class _SupplyShockPanel extends StatelessWidget {
  const _SupplyShockPanel({
    required this.household,
    required this.shocks,
    required this.currentSeconds,
  });

  final HouseholdView household;
  final List<SupplyShockState> shocks;
  final int currentSeconds;

  @override
  Widget build(BuildContext context) => Column(
    key: const Key('supply-shock-panel'),
    children: <Widget>[
      for (final SupplyShockState shock in shocks)
        Card(
          key: Key('supply-shock-${shock.id}'),
          color: const Color(0xff111611),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      shock.status == SupplyShockStatus.active
                          ? Icons.warning_amber_outlined
                          : Icons.task_alt_outlined,
                      color: shock.status == SupplyShockStatus.active
                          ? const Color(0xffd4a35c)
                          : const Color(0xff83b993),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Thiếu ${_itemKindLabel(shock.resourceKind)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            shock.status == SupplyShockStatus.active
                                ? 'đang kéo dài · còn ${((shock.endsAtSeconds - currentSeconds).clamp(0, shock.endsAtSeconds) / gameSecondsPerDay).ceil()} ngày'
                                : 'đã kết thúc tại ngày ${(shock.resolvedAtSeconds ?? shock.endsAtSeconds) ~/ gameSecondsPerDay}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('Nguyên nhân: ${shock.cause}'),
                Text(
                  'Hộ bị ảnh hưởng: ${shock.affectedHouseholdIds.join(', ')}',
                  key: Key('supply-shock-households-${shock.id}'),
                ),
                const SizedBox(height: 8),
                for (final SupplyDisruptionLot lot in shock.disruptedLots)
                  Text(
                    '${lot.householdId == household.id ? 'Hộ này' : lot.householdId}: '
                    '${lot.quantity} ${lot.unit} từ ${lot.itemId} không còn dùng được '
                    '(chất lượng lúc mất ${lot.condition}/1000)',
                    key: Key('supply-disruption-${shock.id}-${lot.itemId}'),
                  ),
                const SizedBox(height: 8),
                if (shock.householdDays.isEmpty)
                  const Text('Chưa tới lần đối chiếu cuối ngày đầu tiên.')
                else
                  for (final SupplyShockHouseholdDay day
                      in shock.householdDays.where(
                        (SupplyShockHouseholdDay value) =>
                            value.day == shock.householdDays.last.day,
                      ))
                    Text(
                      'Ngày ${day.day} · ${day.householdId}: '
                      '${day.availableQuantity} ${shock.unit} trong kho, '
                      '${day.inTransitQuantity} ${shock.unit} đang đi',
                      key: Key(
                        'supply-shock-latest-${shock.id}-${day.householdId}',
                      ),
                    ),
                const Divider(height: 20),
                Text(
                  'Phản ứng có bằng chứng (${shock.responses.map((SupplyShockResponse value) => value.householdId).toSet().length}/${shock.affectedHouseholdIds.length} hộ)',
                  key: Key('supply-shock-response-count-${shock.id}'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                for (final SupplyShockResponse response in shock.responses)
                  Text(
                    '${response.householdId}: ${_supplyShockResponseLabel(response.kind)} · ${response.evidenceId}',
                    key: Key(
                      'supply-shock-response-${shock.id}-${response.householdId}-${response.evidenceId}',
                    ),
                  ),
              ],
            ),
          ),
        ),
    ],
  );
}

String _supplyShockResponseLabel(SupplyShockResponseKind kind) =>
    switch (kind) {
      SupplyShockResponseKind.production => 'đổi sản xuất',
      SupplyShockResponseKind.service => 'đổi dịch vụ',
      SupplyShockResponseKind.marketExchange => 'đổi cách mua bán',
    };

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

String _personalCommitmentLabel(String? kind) => switch (kind) {
  'resource_inquiry' => 'việc đi hỏi nguồn hàng',
  'resource_introduction' => 'việc dẫn người đi gặp hộ nguồn',
  'community_exchange' => 'việc vận chuyển hàng đổi giữa các hộ',
  'need_driven_exchange' => 'việc mang hàng giải quyết nhu cầu của hộ',
  _ => 'một hành trình',
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
    required this.childhood,
    required this.onInfantIntent,
    required this.onChildIntent,
    required this.currentSeconds,
    required this.enabled,
  });

  final TextEditingController controller;
  final VoidCallback onSubmit;
  final InfantView? infancy;
  final ChildhoodView? childhood;
  final ValueChanged<InfantIntent> onInfantIntent;
  final ValueChanged<ChildIntent> onChildIntent;
  final int currentSeconds;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            infancy == null && childhood == null
                ? 'Giao mục tiêu'
                : 'Hoạt động có thể thực hiện',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (childhood case final ChildhoodView value) ...<Widget>[
            const Text(
              'Năng lực mở dần từ trưởng thành cơ thể và những gì nhân vật đã thật sự luyện tập.',
            ),
            const SizedBox(height: 12),
            if (value.activeActivity != null) ...<Widget>[
              Text(
                'Đang thực hiện: ${value.activeActivity} · còn '
                '${((value.activeActivityEndsAtSeconds! - currentSeconds).clamp(0, 86400) / 60).ceil()} phút trong game.',
              ),
              const SizedBox(height: 12),
            ],
            for (final ChildIntent intent in value.allowedIntents)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: FilledButton.tonal(
                  key: Key('child-intent-${intent.code}'),
                  onPressed: enabled ? () => onChildIntent(intent) : null,
                  child: Text(
                    '${intent.label} · ${intent.durationSeconds ~/ 60} phút',
                  ),
                ),
              ),
          ] else if (infancy case final InfantView value) ...<Widget>[
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
          fact.kind.startsWith('production_') ||
          fact.kind.startsWith('service_appointment_') ||
          fact.kind.startsWith('labor_') ||
          fact.kind.startsWith('market_') ||
          fact.kind.startsWith('community_exchange') ||
          fact.kind.startsWith('community_resource') ||
          fact.kind.startsWith('community_survival') ||
          fact.kind.startsWith('social_') ||
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
          fact.kind == 'item_created' ||
          fact.kind.startsWith('knowledge_'),
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
  if (kind.startsWith('knowledge_')) return const Color(0xff80a9c7);
  if (kind.startsWith('social_')) return const Color(0xffb091c7);
  if (kind.startsWith('child')) return const Color(0xff83b993);
  if (kind.startsWith('personal_time_')) return const Color(0xffc7a66f);
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
    'community_exchange_departed' =>
      'Hai hộ đã giao hàng cho người vận chuyển; hàng đang đi trong '
          '${values['travel_seconds'] ?? '?'} giây game.',
    'community_exchange_completed' =>
      'Đổi hàng hoàn tất: ${values['first'] ?? 'hộ thứ nhất'} nhận '
          '${values['received'] ?? 'hàng đã thỏa thuận'}.',
    'community_exchange_cancelled' =>
      'Chuyến đổi hàng bị hủy; hàng đã rút khỏi kho được hoàn lại.',
    'knowledge_observed' =>
      '${values['count'] ?? '?'} người trực tiếp ghi nhớ sự việc.',
    'knowledge_shared' =>
      '${values['speaker'] ?? 'Một người'} kể lại tin cho người nghe; '
          'độ tin cậy còn ${values['confidence'] ?? '?'}/1000.',
    'social_relation_started' =>
      '${values['first'] ?? 'Hai người'} và ${values['second'] ?? 'người kia'} '
          'bắt đầu ghi nhớ nhau sau một lần gặp thật.',
    'social_encounter_recorded' =>
      '${values['first'] ?? 'Hai người'} và ${values['second'] ?? 'người kia'} '
          'ghi thêm một lần gặp thật vào quan hệ.',
    'social_trade_trust_changed' =>
      'Kết quả đổi hàng làm lòng tin bạn hàng thay đổi; '
          'thành công: ${values['succeeded'] ?? '?'}.',
    'social_resource_aid_refused' =>
      '${fact.subjectId} ghi nhớ ${values['contact'] ?? 'người quen'} đã từ chối '
          'giúp ${_needLabel(values['resource'] ?? '')} khi nhu cầu khẩn '
          '${values['urgency'] ?? '?'}/100; bất mãn hiện là '
          '${values['resentment'] ?? '?'}/1000.',
    'community_resource_response_started' =>
      '${values['actor'] ?? 'Một người'} tìm ${values['contact'] ?? 'người quen'} '
          'để đổi lấy ${values['received'] ?? '?'} đơn vị '
          '${_needLabel(values['resource'] ?? '')}.',
    'community_resource_request_opened' =>
      'Hộ mở yêu cầu ${_needLabel(values['resource'] ?? '')} ở mức khẩn '
          '${values['urgency'] ?? '?'}/100.',
    'community_resource_request_resolved' =>
      'Hàng của yêu cầu đã tới nơi qua chuyến '
          '${values['exchange'] ?? '?'}; nhận ${values['amount'] ?? '?'} đơn vị.',
    'community_resource_response_failed' =>
      'Hộ cần ${_needLabel(values['resource'] ?? '')} nhưng chưa tự thu xếp được: '
          '${values['reason'] ?? 'không rõ nguyên nhân'}.',
    'community_resource_response_cancelled' =>
      'Nhu cầu ${_needLabel(values['resource'] ?? '')} đã được giải quyết trước khi phải nhờ người quen.',
    'community_resource_inquiry_started' =>
      '${values['asker'] ?? 'Một người'} đang tìm đến '
          '${values['intermediary'] ?? 'người quen'} để hỏi nguồn '
          '${_needLabel(values['resource'] ?? '')}.',
    'community_resource_inquiry_answered' =>
      '${values['intermediary'] ?? 'Người quen'} trả lời từ điều họ thật sự biết; '
          'người hỏi nhận bằng chứng với độ tin cậy '
          '${values['confidence'] ?? '?'}/1000.',
    'community_resource_introduction_started' =>
      '${values['intermediary'] ?? 'Người quen'} đang dẫn '
          '${values['asker'] ?? 'người hỏi'} tới gặp '
          '${values['provider_contact'] ?? 'người của hộ nguồn'}.',
    'community_resource_introduction_arrived' =>
      '${values['asker'] ?? 'Người cần hàng'} đã gặp '
          '${values['provider_contact'] ?? 'người của hộ nguồn'} qua lời giới thiệu; '
          'hai người bắt đầu ghi nhớ nhau.',
    'personal_time_committed' =>
      '${fact.subjectId} dành thời gian cho ${_personalCommitmentLabel(values['kind'])}; '
          'cam kết kéo dài tới giây ${values['ends_at'] ?? '?'}.',
    'personal_time_released' =>
      '${fact.subjectId} kết thúc hành trình sau '
          '${values['elapsed_seconds'] ?? '?'} giây game và trở lại nhịp sống.',
    'community_survival_day_recorded' =>
      'Đã ghi ngày ${values['day'] ?? '?'} của chu kỳ 30 ngày: '
          '${values['pressured'] ?? '?'} hộ chịu áp lực, '
          '${values['critical'] ?? '?'} hộ nguy cấp.',
    'community_survival_audit_completed' =>
      'Đã ghi đủ chu kỳ cộng đồng; có '
          '${values['rescue_days'] ?? '?'} ngày xuất hiện điểm cần cứu hộ.',
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
    'historical_legacy_applied' =>
      'Lịch sử đã đổi ${values['adjustments'] ?? '?'} kho, '
          '${values['natural'] ?? '0'} nguồn, ${values['ecology'] ?? '0'} quần thể '
          'và ${values['settlements'] ?? '0'} nơi dân cư; năng lực tiếp tế '
          '${values['supply'] ?? '?'}/1000 và còn '
          '${values['feasible_birth_sites'] ?? '?'} nơi sinh khả thi.',
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
    'production_batch_started' =>
      '${values['actor'] ?? 'Người làm'} bắt đầu ${values['recipe'] ?? 'mẻ sản xuất'}; '
          'nguyên liệu đã rời kho và nằm trong workpiece tới mốc ${values['completes_at'] ?? '?'}.',
    'production_batch_completed' =>
      'Mẻ ${values['recipe'] ?? fact.subjectId} hoàn tất, tạo '
          '${values['quantity'] ?? '?'} ${values['unit'] ?? ''} vào ${values['output'] ?? 'kho đầu ra'} '
          'với chất lượng ${values['quality'] ?? '?'}/1000.',
    'production_batch_blocked' =>
      'Mẻ ${values['recipe'] ?? fact.subjectId} bị chặn vì '
          '${_productionFailureLabel(values['reason'] ?? '')}; '
          '${values['inputs_held'] ?? '?'} lô nguyên liệu vẫn nằm trong workpiece.',
    'service_appointment_booked' =>
      '${values['provider'] ?? 'Người cung cấp'} và '
          '${values['recipient'] ?? 'người nhận'} đã giữ lịch dịch vụ '
          '${values['service'] ?? fact.subjectId} tới mốc ${values['ends_at'] ?? '?'}.',
    'service_appointment_started' =>
      '${values['provider'] ?? 'Người cung cấp'} bắt đầu phục vụ '
          '${values['recipient'] ?? 'người nhận'}; cả hai cùng bị giữ lịch.',
    'service_appointment_completed' =>
      'Dịch vụ ${values['service'] ?? fact.subjectId} hoàn tất và tạo claim '
          '${values['claim'] ?? '?'} (${_serviceClaimLabel(values['claim_kind'] ?? '')}).',
    'service_appointment_blocked' =>
      'Dịch vụ ${values['service'] ?? fact.subjectId} bị chặn vì '
          '${_serviceFailureLabel(values['reason'] ?? '')}.',
    'labor_offer_created' =>
      '${values['employer'] ?? 'Người thuê'} mời ${values['worker'] ?? 'người làm'} '
          'nhận ${values['activity'] ?? 'một công việc'}; quyền lợi '
          '${values['compensation_quantity'] ?? '?'} ${values['compensation_unit'] ?? ''} '
          '${_itemKindLabel(values['compensation_kind'] ?? '')}.',
    'labor_offer_accepted' =>
      '${values['worker'] ?? 'Người làm'} nhận việc sau khi đối chiếu kỹ năng, sức và lịch.',
    'labor_offer_refused' =>
      '${values['worker'] ?? 'Người làm'} từ chối lời mời vì '
          '${_laborReasonLabel(values['reason'] ?? '')}.',
    'labor_work_started' =>
      '${values['worker'] ?? 'Người làm'} bắt đầu ${values['activity'] ?? 'ca lao động'} '
          'và bị giữ thời gian tới mốc ${values['ends_at'] ?? '?'}.',
    'labor_work_completed' =>
      '${values['worker'] ?? 'Người làm'} hoàn tất ${values['activity'] ?? 'công việc'}; '
          'khoản phải trả ${values['claim'] ?? '?'} đã phát sinh.',
    'labor_work_blocked' =>
      'Ca lao động bị chặn vì ${_laborReasonLabel(values['reason'] ?? '')}; '
          'không tự sinh claim trả công.',
    'labor_payment_failed' =>
      'Chưa trả được ${values['quantity'] ?? '?'} ${values['unit'] ?? ''}; '
          'claim ${fact.subjectId} vẫn còn.',
    'labor_payment_settled' =>
      'Đã chuyển ${values['quantity'] ?? '?'} ${values['unit'] ?? ''} '
          '${_itemKindLabel(values['kind'] ?? '')} để tất toán ${fact.subjectId}.',
    'market_offer_published' =>
      '${values['seller'] ?? 'Người bán'} đưa ${values['quantity'] ?? '?'} '
          '${values['unit'] ?? ''} ${_itemKindLabel(values['kind'] ?? '')} '
          'vào escrow của chợ.',
    'market_order_reserved' =>
      '${values['buyer'] ?? 'Người mua'} giữ ${values['merchandise_quantity'] ?? '?'} '
          '${values['merchandise_unit'] ?? ''} '
          '${_itemKindLabel(values['merchandise_kind'] ?? '')} và '
          '${values['payment_quantity'] ?? '?'} ${values['payment_unit'] ?? ''} '
          '${_itemKindLabel(values['payment_kind'] ?? '')}.',
    'market_order_settled' =>
      'Đơn ${fact.subjectId} đổi chủ ${values['merchandise_quantity'] ?? '?'} '
          '${_itemKindLabel(values['merchandise_kind'] ?? '')} lấy '
          '${values['payment_quantity'] ?? '?'} '
          '${_itemKindLabel(values['payment_kind'] ?? '')}.',
    'market_shipment_departed' =>
      '${values['carrier'] ?? 'Người chở'} rời kho với '
          '${values['quantity'] ?? '?'} ${values['unit'] ?? ''} '
          '${_itemKindLabel(values['kind'] ?? '')}; đi '
          '${((int.tryParse(values['distance_mm'] ?? '') ?? 0) / 1000000).toStringAsFixed(2)} km '
          'và dự kiến trễ ${((int.tryParse(values['late_seconds'] ?? '') ?? 0) / 60).ceil()} phút.',
    'market_shipment_delivered' =>
      'Chuyến ${fact.subjectId} đã đưa ${values['quantity'] ?? '?'} '
          '${values['unit'] ?? ''} ${_itemKindLabel(values['kind'] ?? '')} '
          'vào ${values['destination'] ?? 'kho đích'} với chất lượng '
          '${values['condition'] ?? '?'}/1000.',
    'market_shipment_failed' =>
      'Chuyến ${fact.subjectId} giao thất bại vì '
          '${_marketShipmentFailureLabel(values['reason'])}; hàng vẫn được giữ trong hồ sơ chuyến.',
    'supply_shock_started' =>
      'Cú sốc ${fact.subjectId} làm thiếu ${_itemKindLabel(values['kind'] ?? '')} '
          'ở các hộ ${values['households'] ?? '?'} tới mốc ${values['ends_at'] ?? '?'}.',
    'supply_shock_response_recorded' =>
      '${values['household'] ?? 'Một hộ'} thay đổi sinh kế bằng '
          '${values['response'] ?? '?'}; bằng chứng ${values['evidence'] ?? '?'}.',
    'supply_shock_day_recorded' =>
      'Ngày ${values['day'] ?? '?'} của cú sốc: kho + hàng đang đi '
          '${values['stocks'] ?? '?'}; ${values['adapted_households'] ?? '0'} hộ đã phản ứng.',
    'supply_shock_resolved' =>
      'Cú sốc kết thúc sau đối chiếu ngày ${values['day'] ?? '?'}; '
          '${values['adapted_households'] ?? '0'} hộ có phản ứng thật.',
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
    'family_care_remembered' =>
      '${fact.subjectId} ghi nhớ lần chăm ${values['infant'] ?? 'trẻ'}'
          '${values['substitute'] == 'true' ? ' khi gánh thay người khác' : ''}.',
    'family_care_plan_negotiated' =>
      'Hộ đã chia lại bốn ca chăm cho ngày ${values['day'] ?? '?'}, '
          'bản thỏa thuận ${values['revision'] ?? '?'}.',
    'family_care_offer_refused' =>
      '${fact.subjectId} từ chối ca chăm vì ngưỡng nhận việc '
          '${values['floor'] ?? '?'} cao hơn mức ca ${values['priority'] ?? '?'}.',
    'family_care_shift_broken' =>
      'Ca ${values['shift'] ?? '?'} bị vỡ vì '
          '${_careSupportReason(values['reason'] ?? '')}.',
    'family_care_support_called' =>
      '${fact.subjectId} được gọi gánh ca chăm ${values['infant'] ?? 'trẻ'}.',
    'family_care_support_failed' =>
      'Không tìm được người gánh ca chăm ${values['infant'] ?? 'trẻ'}.',
    'family_care_support_waiting' =>
      'Chưa có ai nhận ca; hộ bắt đầu tìm người khác theo từng đợt.',
    'family_care_support_still_waiting' =>
      'Hộ vẫn chưa tìm được người hỗ trợ sau ${values['attempts'] ?? '?'} lần.',
    'family_care_support_arrived_late' =>
      '${fact.subjectId} nhận ca sau khi trẻ đã chờ '
          '${((int.tryParse(values['delay_seconds'] ?? '') ?? 0) ~/ 60)} phút.',
    'family_care_support_expired' =>
      'Yêu cầu hỗ trợ hết hạn sau '
          '${((int.tryParse(values['delay_seconds'] ?? '') ?? 0) ~/ 60)} phút.',
    'infant_care_delayed_harm' =>
      'Việc bị bỏ chờ làm mức gắn bó đổi từ ${values['attachment'] ?? '?'}.',
    'family_care_debt_created' =>
      '${values['supporter'] ?? 'Một người thân'} phải gánh thay '
          '${values['planned'] ?? 'người trực ca'} và gia đình ghi nhận nghĩa vụ bù.',
    'family_care_burden_rebalanced' =>
      'Gánh nặng và nghĩa vụ bù đã tác động tới lịch chăm mới.',
    'family_care_conflict_opened' =>
      'Hai thành viên bắt đầu đối chất về ca chăm bị bỏ, mức căng thẳng '
          '${values['severity'] ?? '?'}/1000.',
    'family_care_conflict_repaired' =>
      'Hai thành viên đạt thỏa thuận bù ca và khôi phục một phần lòng tin.',
    'family_care_conflict_unresolved' =>
      'Cuộc đối chất không giải quyết được bất đồng; lòng tin và tình cảm giảm.',
    'family_care_promise_made' =>
      '${values['debtor'] ?? 'Một thành viên'} hứa nhận '
          '${values['shifts'] ?? '?'} ca trước ngày ${values['due_day'] ?? '?'}.',
    'family_care_promise_fulfilled' =>
      '${values['debtor'] ?? 'Một thành viên'} đã giữ lời bù '
          '${values['assigned'] ?? '?'} ca chăm.',
    'family_care_promise_broken' =>
      '${values['debtor'] ?? 'Một thành viên'} không thực hiện đủ lời hứa; '
          'lòng tin giữa hai người giảm.',
    'family_care_reputation_witnessed' =>
      '${values['witnesses'] ?? '0'} thành viên đã ghi nhớ việc '
          '${values['status'] == 'fulfilled' ? 'giữ lời' : 'thất hứa'} này.',
    'infant_caregiver_expectation_updated' =>
      'Trẻ ghi nhớ ${values['caregiver'] ?? 'người chăm'} đã đáp ứng sau '
          '${((int.tryParse(values['delay_seconds'] ?? '') ?? 0) ~/ 60)} phút.',
    'infant_caregiver_expectation_missed' =>
      'Trẻ ghi nhớ ${values['caregiver'] ?? 'người chăm'} đã không đến.',
    'infant_cry' => 'Căng thẳng đạt ${values['distress'] ?? '?'}/1000.',
    'infant_elimination' =>
      'Bài tiết ${values['urine_ml'] ?? '0'} ml nước tiểu và ${values['stool_g'] ?? '0'} g phân.',
    'child_activity_started' =>
      '${fact.subjectId} bắt đầu ${values['intent'] ?? 'một hoạt động'} trong '
          '${((int.tryParse(values['duration_seconds'] ?? '') ?? 0) ~/ 60)} phút tại '
          '${values['room'] ?? 'không gian hiện tại'}.',
    'child_activity_succeeded' =>
      '${fact.subjectId} hoàn thành ${values['intent'] ?? 'hoạt động'}; '
          'năng lực ${values['score'] ?? '?'}/${values['threshold'] ?? '?'}.',
    'child_activity_failed' =>
      '${fact.subjectId} chưa hoàn thành ${values['intent'] ?? 'hoạt động'}; '
          'nguyên nhân ${values['reason'] ?? 'chưa rõ'}.',
    'child_activity_cancelled' =>
      'Hoạt động của ${fact.subjectId} bị dừng vì cam kết thời gian không còn hiệu lực.',
    'child_learning_succeeded' =>
      '${fact.subjectId} học được ${values['concept'] ?? 'một điều mới'} từ '
          '${values['source'] ?? 'nguồn không rõ'}; tin hiệu quả '
          '${values['score'] ?? '?'}/${values['threshold'] ?? '?'}.',
    'child_learning_failed' =>
      '${fact.subjectId} chưa học được qua ${values['intent'] ?? 'hoạt động'}; '
          'nguyên nhân ${values['reason'] ?? 'chưa rõ'}.',
    'child_hazard_detected' =>
      '${fact.subjectId} mất thăng bằng, '
          '${values['noticed'] == 'true' ? 'nhận ra sớm' : 'không nhận ra kịp'}; '
          'đã tìm ${values['caregiver'] ?? 'không ai'} theo mức ưu tiên '
          '${values['preference'] ?? '?'}.',
    'child_hazard_soothed' =>
      '${values['caregiver'] ?? 'Người chăm'} đã đến trấn an ${fact.subjectId}; '
          'cảm giác an toàn đổi ${values['security_change'] ?? '0'} điểm.',
    'child_hazard_unattended' =>
      '${fact.subjectId} không được đáp ứng sau sự cố; cảm giác an toàn đổi '
          '${values['security_change'] ?? '?'} điểm.',
    'child_memories_compressed' =>
      '${fact.subjectId} đã chuyển ${values['compressed'] ?? '0'} lần nhớ cũ '
          'thành tóm tắt; còn ${values['recent'] ?? '0'} ký ức gần, '
          '${values['anchors'] ?? '0'} ký ức nổi bật và '
          '${values['summaries'] ?? '0'} giai đoạn tóm tắt.',
    'child_daily_nutrition' =>
      '${fact.subjectId} nhận ${values['food_g'] ?? '0'}/${values['food_need_g'] ?? '?'} g thức ăn và '
          '${values['water_ml'] ?? '0'}/${values['water_need_ml'] ?? '?'} ml nước; '
          'khối lượng ${values['mass_g'] ?? '?'} g, hỗ trợ phát triển '
          '${values['development_support'] ?? '?'}/1000.',
    _ => fact.detail,
  };
}

String _itemKindLabel(String kind) => switch (kind) {
  'staple_food' => 'lương thực',
  'clean_water' => 'nước sạch',
  'firewood' => 'củi',
  'infant_feed' => 'dịch dinh dưỡng',
  'swaddling_cloth' => 'khăn quấn',
  'child_play_object' => 'vật chơi mềm',
  'raw_timber' => 'gỗ thô',
  'plant_fiber' => 'sợi thực vật',
  'hand_axe' => 'rìu tay',
  'carrying_frame' => 'khung gùi gỗ',
  'raw_grain' => 'ngũ cốc thô',
  'raw_root' => 'củ tươi dự trữ',
  'dried_root_food' => 'lương thực củ hong',
  'labor_rice' => 'gạo trả công',
  'dried_herb' => 'dược thảo khô',
  _ => kind,
};

String _factLabel(String kind) => switch (kind) {
  'infant_cry' => 'Trẻ khóc',
  'cry_heard' => 'Người chăm sóc nghe thấy',
  'cry_not_heard' => 'Không ai nghe thấy tiếng khóc',
  'caregiver_arrived' => 'Người chăm sóc đã đến',
  'caregiver_care' => 'Hoàn tất chăm sóc',
  'family_care_remembered' => 'Gia đình ghi nhớ lần chăm trẻ',
  'family_care_plan_negotiated' => 'Gia đình phân lại ca chăm trẻ',
  'family_care_offer_refused' => 'Thành viên từ chối ca chăm',
  'family_care_shift_broken' => 'Ca chăm bị vỡ',
  'family_care_support_called' => 'Đã gọi người hỗ trợ',
  'family_care_support_failed' => 'Không gọi được người hỗ trợ',
  'family_care_support_waiting' => 'Đang tìm người hỗ trợ',
  'family_care_support_still_waiting' => 'Vẫn chưa có người hỗ trợ',
  'family_care_support_arrived_late' => 'Người hỗ trợ đến muộn',
  'family_care_support_expired' => 'Yêu cầu hỗ trợ hết hạn',
  'infant_care_delayed_harm' => 'Trẻ chịu hậu quả vì chờ lâu',
  'family_care_debt_created' => 'Phát sinh nghĩa vụ bù ca',
  'family_care_burden_rebalanced' => 'Phân lại gánh nặng chăm sóc',
  'family_care_conflict_opened' => 'Phát sinh mâu thuẫn phân ca',
  'family_care_conflict_repaired' => 'Gia đình hòa giải',
  'family_care_conflict_unresolved' => 'Mâu thuẫn chưa được giải quyết',
  'family_care_promise_made' => 'Đã hứa bù ca',
  'family_care_promise_fulfilled' => 'Đã giữ lời bù ca',
  'family_care_promise_broken' => 'Đã thất hứa bù ca',
  'family_care_reputation_witnessed' => 'Danh tiếng được người thân ghi nhớ',
  'infant_caregiver_expectation_updated' => 'Trẻ học được sự đáp ứng',
  'infant_caregiver_expectation_missed' => 'Trẻ ghi nhớ lần không được đáp ứng',
  'caregiver_cannot_reach' => 'Người chăm sóc không thể đến',
  'care_failed_missing_supply' => 'Thiếu vật dụng chăm sóc',
  'care_failed_no_right' => 'Không có quyền dùng vật dụng',
  'care_response_impossible' => 'Không thể bắt đầu chăm sóc',
  'infant_intent' => 'Ý định của trẻ',
  'infant_fell_asleep' => 'Trẻ chìm vào giấc ngủ',
  'infant_woke_up' => 'Trẻ thức dậy',
  'infant_elimination' => 'Bài tiết',
  'childhood_started' => 'Bước qua tháng sơ sinh',
  'child_development_stage_changed' => 'Sang giai đoạn phát triển mới',
  'child_activity_started' => 'Bắt đầu hoạt động tuổi thơ',
  'child_activity_completed' => 'Hoàn tất hoạt động tuổi thơ',
  'child_activity_succeeded' => 'Hoạt động tuổi thơ thành công',
  'child_activity_failed' => 'Hoạt động tuổi thơ chưa thành công',
  'child_activity_cancelled' => 'Hoạt động tuổi thơ bị dừng',
  'child_learning_succeeded' => 'Trẻ học được điều có nguồn',
  'child_learning_failed' => 'Trẻ chưa học được',
  'child_hazard_detected' => 'Trẻ gặp nguy hiểm',
  'child_hazard_soothed' => 'Người chăm đã trấn an',
  'child_hazard_unattended' => 'Nguy hiểm không được đáp ứng',
  'child_memories_compressed' => 'Ký ức tuổi thơ được tóm tắt',
  'child_daily_nutrition' => 'Cơ thể trẻ nhận khẩu phần ngày',
  'birth' => 'Ra đời',
  'person_created' => 'Nhân vật tồn tại',
  'item_created' => 'Vật phẩm tồn tại',
  'household_created' => 'Hộ gia đình hình thành',
  'community_exchange_departed' => 'Hàng đổi đã rời kho',
  'community_exchange_completed' => 'Đổi hàng liên hộ hoàn tất',
  'community_exchange_cancelled' => 'Đổi hàng liên hộ bị hủy',
  'knowledge_observed' => 'NPC trực tiếp quan sát',
  'knowledge_shared' => 'NPC truyền tin',
  'social_relation_started' => 'Quan hệ ngoài hộ hình thành',
  'social_encounter_recorded' => 'Gặp lại người quen',
  'social_trade_trust_changed' => 'Lòng tin bạn hàng thay đổi',
  'social_resource_aid_refused' => 'NPC ghi nhớ một lần bị từ chối',
  'community_resource_response_started' => 'NPC tự tìm người đổi hàng',
  'community_resource_request_opened' => 'Hộ mở yêu cầu tài nguyên',
  'community_resource_request_resolved' => 'Yêu cầu tài nguyên đã xong',
  'community_resource_response_failed' => 'NPC chưa tìm được nguồn hàng',
  'community_resource_response_cancelled' => 'Nhu cầu đã tự hết',
  'community_resource_inquiry_started' => 'NPC đi hỏi nguồn hàng',
  'community_resource_inquiry_answered' => 'Người quen trả lời',
  'community_resource_introduction_started' =>
    'Đang đi gặp nguồn được giới thiệu',
  'community_resource_introduction_arrived' => 'Đã gặp người của hộ nguồn',
  'personal_time_committed' => 'Bắt đầu cam kết thời gian',
  'personal_time_released' => 'Kết thúc cam kết thời gian',
  'community_survival_day_recorded' => 'Ghi sức sống cuối ngày',
  'community_survival_audit_completed' => 'Hoàn tất hồ sơ 30 ngày',
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
  'historical_legacy_applied' => 'Lịch sử để lại hậu quả vật chất',
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
  'production_batch_started' => 'Mẻ chế tác bắt đầu',
  'production_batch_completed' => 'Mẻ chế tác hoàn tất',
  'production_batch_blocked' => 'Mẻ chế tác bị chặn',
  'service_appointment_booked' => 'Đã đặt lịch dịch vụ',
  'service_appointment_started' => 'Dịch vụ bắt đầu',
  'service_appointment_completed' => 'Dịch vụ hoàn tất',
  'service_appointment_blocked' => 'Dịch vụ bị chặn',
  'labor_offer_created' => 'Lời mời lao động được đưa ra',
  'labor_offer_accepted' => 'Người làm nhận việc',
  'labor_offer_refused' => 'Người làm từ chối',
  'labor_work_started' => 'Ca lao động bắt đầu',
  'labor_work_completed' => 'Công việc hoàn tất',
  'labor_work_blocked' => 'Ca lao động bị chặn',
  'labor_payment_failed' => 'Chưa trả được quyền lợi',
  'labor_payment_settled' => 'Quyền lợi đã được thanh toán',
  'market_offer_published' => 'Hàng thật được đăng tại chợ',
  'market_order_reserved' => 'Đơn chợ đã giữ hai phía',
  'market_order_settled' => 'Đơn chợ đã đổi chủ',
  'market_shipment_departed' => 'Hàng giao dịch rời kho',
  'market_shipment_delivered' => 'Hàng giao dịch tới kho',
  'market_shipment_failed' => 'Chuyến giao hàng thất bại',
  'supply_shock_started' => 'Cú sốc thiếu hàng bắt đầu',
  'supply_shock_response_recorded' => 'Hộ thay đổi sinh kế',
  'supply_shock_day_recorded' => 'Đối chiếu thiếu hàng cuối ngày',
  'supply_shock_resolved' => 'Cú sốc thiếu hàng kết thúc',
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
