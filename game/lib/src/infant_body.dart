class InfantBodyState {
  const InfantBodyState({
    required this.massGrams,
    required this.bodyWaterMl,
    required this.energyReserveKj,
    required this.stomachContentMl,
    required this.stomachEnergyKj,
    required this.stomachWaterMl,
    required this.bodyTemperatureMilliC,
    required this.sleepPressure,
    required this.bladderMl,
    required this.digestiveWasteGrams,
    required this.insulation,
    required this.suckFunction,
    required this.swallowFunction,
    required this.totalFeedMl,
    required this.totalSleepMinutes,
    required this.totalUrineMl,
    required this.totalStoolGrams,
    this.illnessEnergyCostKj = 0,
    this.illnessWaterLossMl = 0,
    this.illnessSleepDisruptionMinutes = 0,
  });

  const InfantBodyState.newborn()
    : massGrams = 3400,
      bodyWaterMl = 2475,
      energyReserveKj = 900,
      stomachContentMl = 0,
      stomachEnergyKj = 0,
      stomachWaterMl = 0,
      bodyTemperatureMilliC = 37000,
      sleepPressure = 180,
      bladderMl = 0,
      digestiveWasteGrams = 0,
      insulation = 250,
      suckFunction = 800,
      swallowFunction = 850,
      totalFeedMl = 0,
      totalSleepMinutes = 0,
      totalUrineMl = 0,
      totalStoolGrams = 0,
      illnessEnergyCostKj = 0,
      illnessWaterLossMl = 0,
      illnessSleepDisruptionMinutes = 0;

  final int massGrams;
  final int bodyWaterMl;
  final int energyReserveKj;
  final int stomachContentMl;
  final int stomachEnergyKj;
  final int stomachWaterMl;
  final int bodyTemperatureMilliC;
  final int sleepPressure;
  final int bladderMl;
  final int digestiveWasteGrams;
  final int insulation;
  final int suckFunction;
  final int swallowFunction;
  final int totalFeedMl;
  final int totalSleepMinutes;
  final int totalUrineMl;
  final int totalStoolGrams;
  final int illnessEnergyCostKj;
  final int illnessWaterLossMl;
  final int illnessSleepDisruptionMinutes;

  int get hunger => ((1000 - energyReserveKj) * 1000 ~/ 1000).clamp(0, 1000);

  int get thirst {
    final int targetWater = massGrams * 73 ~/ 100;
    final int deficit = targetWater - bodyWaterMl;
    return (deficit * 1000 ~/ 250).clamp(0, 1000);
  }

  int get thermalStress =>
      ((bodyTemperatureMilliC - 37000).abs() ~/ 2).clamp(0, 1000);

  int get stomachCapacityMl => (massGrams * 22 ~/ 1000).clamp(60, 120);

  InfantPhysiologyResult advanceHour({
    required bool awake,
    required int ambientTemperatureMilliC,
    int illnessSeverity = 0,
    int illnessFeverTargetMilliC = 37000,
  }) {
    final int emptiedMl = stomachContentMl.clamp(0, 15);
    final int nextStomach = stomachContentMl - emptiedMl;
    final int absorbedEnergy = stomachContentMl == 0
        ? 0
        : stomachEnergyKj * emptiedMl ~/ stomachContentMl;
    final int absorbedWater = stomachContentMl == 0
        ? 0
        : stomachWaterMl * emptiedMl ~/ stomachContentMl;
    final int nextStomachEnergy = stomachEnergyKj - absorbedEnergy;
    final int nextStomachWater = stomachWaterMl - absorbedWater;
    final int illnessEnergyCost = illnessSeverity ~/ 50;
    final int illnessWaterLoss = illnessSeverity ~/ 200;
    final int sleepDisruption = illnessSeverity ~/ 20;
    final int metabolicCost = (awake ? 25 : 18) + illnessEnergyCost;
    final int nextEnergy = (energyReserveKj - metabolicCost + absorbedEnergy)
        .clamp(0, 1400);
    final int waterAfterInsensibleLoss =
        (bodyWaterMl - (awake ? 3 : 2) - illnessWaterLoss + absorbedWater)
            .clamp(0, 4000);
    final int nextSleepPressure =
        (sleepPressure + (awake ? 80 : -30) + sleepDisruption).clamp(0, 1000);
    bool nextAwake = awake;
    bool fellAsleep = false;
    bool wokeUp = false;
    if (awake && nextSleepPressure >= 700) {
      nextAwake = false;
      fellAsleep = true;
    } else if (!awake && nextSleepPressure <= 180) {
      nextAwake = true;
      wokeUp = true;
    }

    final int exposureDelta =
        (ambientTemperatureMilliC - bodyTemperatureMilliC) *
        (1000 - insulation) ~/
        1000 ~/
        200;
    final int regulationDelta = (37000 - bodyTemperatureMilliC) ~/ 20;
    final int metabolicHeat = nextAwake ? 20 : 18;
    final int illnessHeat =
        (illnessFeverTargetMilliC - bodyTemperatureMilliC) *
        illnessSeverity ~/
        1000 ~/
        8;
    final int nextTemperature =
        (bodyTemperatureMilliC +
                exposureDelta +
                regulationDelta +
                metabolicHeat +
                illnessHeat)
            .clamp(34000, 40000);

    int nextBladder = bladderMl + absorbedWater * 3 ~/ 5;
    int nextWaste = digestiveWasteGrams + emptiedMl ~/ 10;
    int urineMl = 0;
    int stoolGrams = 0;
    if (nextBladder >= 45) {
      urineMl = 40;
      nextBladder -= urineMl;
    }
    if (nextWaste >= 20) {
      stoolGrams = 15;
      nextWaste -= stoolGrams;
    }
    final int nextWater = (waterAfterInsensibleLoss - urineMl).clamp(0, 4000);

    return InfantPhysiologyResult(
      body: InfantBodyState(
        massGrams: massGrams,
        bodyWaterMl: nextWater,
        energyReserveKj: nextEnergy,
        stomachContentMl: nextStomach,
        stomachEnergyKj: nextStomachEnergy,
        stomachWaterMl: nextStomachWater,
        bodyTemperatureMilliC: nextTemperature,
        sleepPressure: nextSleepPressure,
        bladderMl: nextBladder,
        digestiveWasteGrams: nextWaste,
        insulation: insulation,
        suckFunction: suckFunction,
        swallowFunction: swallowFunction,
        totalFeedMl: totalFeedMl,
        totalSleepMinutes: totalSleepMinutes + (awake ? 0 : 60),
        totalUrineMl: totalUrineMl + urineMl,
        totalStoolGrams: totalStoolGrams + stoolGrams,
        illnessEnergyCostKj: illnessEnergyCostKj + illnessEnergyCost,
        illnessWaterLossMl: illnessWaterLossMl + illnessWaterLoss,
        illnessSleepDisruptionMinutes:
            illnessSleepDisruptionMinutes + sleepDisruption,
      ),
      awake: nextAwake,
      fellAsleep: fellAsleep,
      wokeUp: wokeUp,
      urineMl: urineMl,
      stoolGrams: stoolGrams,
    );
  }

  InfantFeedingResult feed({
    required int offeredMl,
    required int energyKjPer100Ml,
    required int waterMlPer100Ml,
    required bool wrapped,
  }) {
    final int freeCapacity = (stomachCapacityMl - stomachContentMl).clamp(
      0,
      stomachCapacityMl,
    );
    final int oralLimit =
        offeredMl *
        (suckFunction < swallowFunction ? suckFunction : swallowFunction) ~/
        1000;
    final int consumedMl = <int>[
      offeredMl,
      freeCapacity,
      oralLimit,
    ].reduce((int a, int b) => a < b ? a : b);
    final int gainedEnergy = consumedMl * energyKjPer100Ml ~/ 100;
    final int gainedWater = consumedMl * waterMlPer100Ml ~/ 100;
    return InfantFeedingResult(
      body: InfantBodyState(
        massGrams: massGrams,
        bodyWaterMl: bodyWaterMl,
        energyReserveKj: energyReserveKj,
        stomachContentMl: stomachContentMl + consumedMl,
        stomachEnergyKj: stomachEnergyKj + gainedEnergy,
        stomachWaterMl: stomachWaterMl + gainedWater,
        bodyTemperatureMilliC: bodyTemperatureMilliC,
        sleepPressure: wrapped
            ? (sleepPressure - 80).clamp(0, 1000)
            : sleepPressure,
        bladderMl: bladderMl,
        digestiveWasteGrams: digestiveWasteGrams,
        insulation: wrapped ? 700 : insulation,
        suckFunction: suckFunction,
        swallowFunction: swallowFunction,
        totalFeedMl: totalFeedMl + consumedMl,
        totalSleepMinutes: totalSleepMinutes,
        totalUrineMl: totalUrineMl,
        totalStoolGrams: totalStoolGrams,
        illnessEnergyCostKj: illnessEnergyCostKj,
        illnessWaterLossMl: illnessWaterLossMl,
        illnessSleepDisruptionMinutes: illnessSleepDisruptionMinutes,
      ),
      consumedMl: consumedMl,
      gainedEnergyKj: gainedEnergy,
      gainedWaterMl: gainedWater,
    );
  }

  InfantBodyState growOneDay() {
    final int targetWater = massGrams * 73 ~/ 100;
    final int availableWaterDeficit =
        targetWater - (bodyWaterMl + stomachWaterMl);
    final int availableThirst = (availableWaterDeficit * 1000 ~/ 250).clamp(
      0,
      1000,
    );
    final bool supported =
        energyReserveKj + stomachEnergyKj >= 520 && availableThirst < 500;
    final int growthGrams = supported ? 22 : 4;
    final int growthEnergy = supported ? 44 : 8;
    final int energyFromReserve = growthEnergy.clamp(0, energyReserveKj);
    final int energyFromStomach = growthEnergy - energyFromReserve;
    return InfantBodyState(
      massGrams: massGrams + growthGrams,
      bodyWaterMl: bodyWaterMl,
      energyReserveKj: energyReserveKj - energyFromReserve,
      stomachContentMl: stomachContentMl,
      stomachEnergyKj: (stomachEnergyKj - energyFromStomach).clamp(
        0,
        stomachEnergyKj,
      ),
      stomachWaterMl: stomachWaterMl,
      bodyTemperatureMilliC: bodyTemperatureMilliC,
      sleepPressure: sleepPressure,
      bladderMl: bladderMl,
      digestiveWasteGrams: digestiveWasteGrams,
      insulation: insulation,
      suckFunction: (suckFunction + 2).clamp(0, 1000),
      swallowFunction: (swallowFunction + 1).clamp(0, 1000),
      totalFeedMl: totalFeedMl,
      totalSleepMinutes: totalSleepMinutes,
      totalUrineMl: totalUrineMl,
      totalStoolGrams: totalStoolGrams,
      illnessEnergyCostKj: illnessEnergyCostKj,
      illnessWaterLossMl: illnessWaterLossMl,
      illnessSleepDisruptionMinutes: illnessSleepDisruptionMinutes,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'mass_g': massGrams,
    'body_water_ml': bodyWaterMl,
    'energy_reserve_kj': energyReserveKj,
    'stomach_content_ml': stomachContentMl,
    'stomach_energy_kj': stomachEnergyKj,
    'stomach_water_ml': stomachWaterMl,
    'body_temperature_millic': bodyTemperatureMilliC,
    'sleep_pressure': sleepPressure,
    'bladder_ml': bladderMl,
    'digestive_waste_g': digestiveWasteGrams,
    'insulation': insulation,
    'suck_function': suckFunction,
    'swallow_function': swallowFunction,
    'total_feed_ml': totalFeedMl,
    'total_sleep_minutes': totalSleepMinutes,
    'total_urine_ml': totalUrineMl,
    'total_stool_g': totalStoolGrams,
    if (illnessEnergyCostKj > 0) 'illness_energy_cost_kj': illnessEnergyCostKj,
    if (illnessWaterLossMl > 0) 'illness_water_loss_ml': illnessWaterLossMl,
    if (illnessSleepDisruptionMinutes > 0)
      'illness_sleep_disruption_minutes': illnessSleepDisruptionMinutes,
  };

  factory InfantBodyState.fromJson(Map<String, Object?> json) =>
      InfantBodyState(
        massGrams: json['mass_g']! as int,
        bodyWaterMl: json['body_water_ml']! as int,
        energyReserveKj: json['energy_reserve_kj']! as int,
        stomachContentMl: json['stomach_content_ml']! as int,
        stomachEnergyKj: json['stomach_energy_kj'] as int? ?? 0,
        stomachWaterMl: json['stomach_water_ml'] as int? ?? 0,
        bodyTemperatureMilliC: json['body_temperature_millic']! as int,
        sleepPressure: json['sleep_pressure']! as int,
        bladderMl: json['bladder_ml']! as int,
        digestiveWasteGrams: json['digestive_waste_g']! as int,
        insulation: json['insulation']! as int,
        suckFunction: json['suck_function']! as int,
        swallowFunction: json['swallow_function']! as int,
        totalFeedMl: json['total_feed_ml']! as int,
        totalSleepMinutes: json['total_sleep_minutes']! as int,
        totalUrineMl: json['total_urine_ml']! as int,
        totalStoolGrams: json['total_stool_g']! as int,
        illnessEnergyCostKj: json['illness_energy_cost_kj'] as int? ?? 0,
        illnessWaterLossMl: json['illness_water_loss_ml'] as int? ?? 0,
        illnessSleepDisruptionMinutes:
            json['illness_sleep_disruption_minutes'] as int? ?? 0,
      );
}

class InfantPhysiologyResult {
  const InfantPhysiologyResult({
    required this.body,
    required this.awake,
    required this.fellAsleep,
    required this.wokeUp,
    required this.urineMl,
    required this.stoolGrams,
  });

  final InfantBodyState body;
  final bool awake;
  final bool fellAsleep;
  final bool wokeUp;
  final int urineMl;
  final int stoolGrams;
}

class InfantFeedingResult {
  const InfantFeedingResult({
    required this.body,
    required this.consumedMl,
    required this.gainedEnergyKj,
    required this.gainedWaterMl,
  });

  final InfantBodyState body;
  final int consumedMl;
  final int gainedEnergyKj;
  final int gainedWaterMl;
}
