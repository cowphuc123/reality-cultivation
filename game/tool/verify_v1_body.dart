import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  const InfantBodyState newborn = InfantBodyState.newborn();
  _expect(newborn.massGrams == 3400, 'Sai khối lượng khởi tạo fixture.');
  _expect(
    newborn.stomachCapacityMl == 74,
    'Dung tích dạ dày phải suy từ khối lượng.',
  );

  final InfantPhysiologyResult firstHour = newborn.advanceHour(
    awake: true,
    ambientTemperatureMilliC: 24000,
  );
  _expect(
    firstHour.body.energyReserveKj == 875,
    'Thức một giờ phải tiêu 25 kJ.',
  );
  _expect(
    firstHour.body.bodyWaterMl == 2472,
    'Thức một giờ phải mất 3 ml nước vô hình.',
  );
  _expect(
    firstHour.body.sleepPressure == 260,
    'Áp lực ngủ phải tăng theo giờ thức.',
  );
  _expect(
    firstHour.body.bodyTemperatureMilliC >= 36950 &&
        firstHour.body.bodyTemperatureMilliC <= 37050,
    'Điều nhiệt giờ đầu không được chạy khỏi vùng ổn định.',
  );

  final InfantFeedingResult feeding = firstHour.body.feed(
    offeredMl: 60,
    energyKjPer100Ml: 300,
    waterMlPer100Ml: 92,
    wrapped: true,
  );
  _expect(
    feeding.consumedMl == 48,
    'Chức năng bú 800/1000 phải giới hạn lượng nhận.',
  );
  _expect(
    feeding.gainedEnergyKj == 144,
    'Năng lượng ăn vào phải theo ml thực nhận.',
  );
  _expect(feeding.gainedWaterMl == 44, 'Nước ăn vào phải theo ml thực nhận.');
  _expect(
    feeding.body.stomachContentMl == 48,
    'Dịch phải tồn tại trong dạ dày.',
  );
  _expect(
    feeding.body.energyReserveKj == firstHour.body.energyReserveKj &&
        feeding.body.stomachEnergyKj == 144,
    'Năng lượng phải vào dạ dày trước khi được hấp thu.',
  );

  InfantBodyState cycling = feeding.body;
  bool urinated = false;
  bool defecated = false;
  bool awake = true;
  for (int hour = 0; hour < 48; hour++) {
    if (cycling.stomachContentMl == 0) {
      final InfantFeedingResult refill = cycling.feed(
        offeredMl: 60,
        energyKjPer100Ml: 300,
        waterMlPer100Ml: 92,
        wrapped: true,
      );
      cycling = refill.body;
    }
    final InfantPhysiologyResult step = cycling.advanceHour(
      awake: awake,
      ambientTemperatureMilliC: 24000,
    );
    cycling = step.body;
    awake = step.awake;
    urinated = urinated || step.urineMl > 0;
    defecated = defecated || step.stoolGrams > 0;
  }
  _expect(urinated, 'Chuỗi ăn–tiêu hóa phải tạo nước tiểu.');
  _expect(defecated, 'Chuỗi ăn–tiêu hóa phải tạo phân.');
  _expect(cycling.totalSleepMinutes > 0, 'Chu kỳ 48 giờ phải có giấc ngủ.');

  final InfantBodyState supportedGrowth = feeding.body.growOneDay();
  _expect(
    supportedGrowth.massGrams == 3422,
    'Đủ nguồn lực phải tăng 22 g/ngày fixture.',
  );
  final InfantBodyState deprived = InfantBodyState(
    massGrams: 3400,
    bodyWaterMl: 2200,
    energyReserveKj: 100,
    stomachContentMl: 0,
    stomachEnergyKj: 0,
    stomachWaterMl: 0,
    bodyTemperatureMilliC: 37000,
    sleepPressure: 180,
    bladderMl: 0,
    digestiveWasteGrams: 0,
    insulation: 250,
    suckFunction: 800,
    swallowFunction: 850,
    totalFeedMl: 0,
    totalSleepMinutes: 0,
    totalUrineMl: 0,
    totalStoolGrams: 0,
  ).growOneDay();
  _expect(
    deprived.massGrams == 3404,
    'Thiếu nguồn lực không được tăng trưởng đầy đủ.',
  );

  final Simulation month = _monthWorld()
    ..advanceTo(const SimTime(30 * gameSecondsPerDay));
  final InfantView view = SimulationHost(month).person('P00')!.infancy!;
  _expect(
    view.massGrams! >= 4000 && view.massGrams! <= 4060,
    'Tăng trưởng tháng đầu phải phản ánh các ngày đủ và thiếu dự trữ.',
  );
  _expect(
    view.totalSleepMinutes! > 0,
    'Tháng đầu phải tích lũy thời gian ngủ.',
  );
  _expect(
    view.totalSleepMinutes! >= 30 * 12 * 60 &&
        view.totalSleepMinutes! <= 30 * 18 * 60,
    'Thời gian ngủ tháng đầu đã chạy khỏi dải fixture 12–18 giờ/ngày.',
  );
  _expect(view.totalUrineMl! > 0, 'Tháng đầu phải có bài tiết nước.');
  _expect(view.totalStoolGrams! > 0, 'Tháng đầu phải có bài tiết tiêu hóa.');
  _expect(
    view.bodyTemperatureMilliC! >= 36500 &&
        view.bodyTemperatureMilliC! <= 37500,
    'Thân nhiệt ngày 30 phải còn trong vùng fixture ổn định.',
  );
  _expect(
    10000 - view.feedRemaining == view.totalFeedMl,
    'Dịch mất khỏi item phải bằng tổng ml cơ thể đã nhận.',
  );
  _expect(
    view.careInteractions >= 90 && view.careInteractions <= 160,
    'Tần suất chăm sóc tháng đầu đã chạy khỏi dải fixture.',
  );

  final Simulation checkpoint = _monthWorld()
    ..advanceTo(const SimTime(12 * 3600));
  final Simulation restored = Simulation.fromSave(checkpoint.state.save());
  final Simulation continuous = _monthWorld()
    ..advanceTo(const SimTime(12 * 3600));
  restored.advanceTo(const SimTime(2 * gameSecondsPerDay));
  continuous.advanceTo(const SimTime(2 * gameSecondsPerDay));
  _expect(
    restored.state.semanticHash() == continuous.state.semanticHash(),
    'Lưu giữa các tick sinh lý phải tiếp tục đúng kết quả.',
  );

  print('V1.2 infant-body verification passed.');
  print('Day 30 semantic hash: ${month.state.semanticHash()}');
  print(
    'Day 30: ${view.massGrams}g, ${view.totalFeedMl}ml feed, '
    '${view.totalSleepMinutes} sleep minutes, ${view.careInteractions} care episodes.',
  );
}

Simulation _monthWorld() => Simulation.fromSeed(20260907)
  ..schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'person_created',
    payload: const <String, Object?>{
      'person_id': 'N01',
      'name': 'Người chăm sóc',
      'birth_seconds': -25 * 365 * gameSecondsPerDay,
      'position_mm': 5000,
      'caregiver_agent': true,
      'hearing_threshold': 300,
      'movement_speed_mm_per_second': 1000,
      'current_activity': 'prepare_meal',
    },
  )
  ..schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'birth',
    payload: const <String, Object?>{
      'person_id': 'P00',
      'name': 'Vô Danh',
      'infant': true,
      'caregiver_id': 'N01',
      'position_mm': 0,
      'ambient_temperature_millic': 24000,
    },
  )
  ..schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'item_created',
    payload: const <String, Object?>{
      'item_id': 'I-FEED-01',
      'kind': 'infant_feed',
      'position_mm': 0,
      'quantity': 10000,
      'energy_kj_per_100ml': 300,
      'water_ml_per_100ml': 92,
    },
  )
  ..schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'item_created',
    payload: const <String, Object?>{
      'item_id': 'I-CLOTH-01',
      'kind': 'swaddling_cloth',
      'position_mm': 0,
      'quantity': 1,
      'condition': 1000,
    },
  )
  ..advanceTo(const SimTime(0));

void _expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}
