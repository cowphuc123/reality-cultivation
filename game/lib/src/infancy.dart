import 'infant_body.dart';

enum InfantIntent {
  attendVoice('attend_voice', 'Lắng nghe giọng người chăm sóc'),
  cryForCare('cry_for_care', 'Khóc gọi người chăm sóc'),
  sleep('sleep', 'Thả lỏng và ngủ'),
  reach('reach', 'Vươn tay về vật ở gần');

  const InfantIntent(this.code, this.label);

  final String code;
  final String label;

  static InfantIntent fromCode(String code) => values.firstWhere(
    (InfantIntent value) => value.code == code,
    orElse: () => throw FormatException('Unknown infant intent: $code'),
  );
}

class InfantNeeds {
  const InfantNeeds({
    required this.hunger,
    required this.thirst,
    required this.sleepPressure,
    required this.thermalStress,
  });

  const InfantNeeds.initial()
    : hunger = 100,
      thirst = 100,
      sleepPressure = 180,
      thermalStress = 80;

  final int hunger;
  final int thirst;
  final int sleepPressure;
  final int thermalStress;

  int get distress => <int>[
    hunger,
    thirst,
    sleepPressure,
    thermalStress,
  ].reduce((int a, int b) => a > b ? a : b);

  InfantNeeds passDay({required bool awake}) => InfantNeeds(
    hunger: _bounded(hunger + 220),
    thirst: _bounded(thirst + 180),
    sleepPressure: _bounded(sleepPressure + (awake ? 190 : -320)),
    thermalStress: _bounded(thermalStress + 25),
  );

  InfantNeeds afterCare() => InfantNeeds(
    hunger: _bounded(hunger - 520),
    thirst: _bounded(thirst - 460),
    sleepPressure: _bounded(sleepPressure - 280),
    thermalStress: _bounded(thermalStress - 180),
  );

  Map<String, Object> toJson() => <String, Object>{
    'hunger': hunger,
    'thirst': thirst,
    'sleep_pressure': sleepPressure,
    'thermal_stress': thermalStress,
  };

  factory InfantNeeds.fromJson(Map<String, Object?> json) => InfantNeeds(
    hunger: json['hunger']! as int,
    thirst: json['thirst']! as int,
    sleepPressure: json['sleep_pressure']! as int,
    thermalStress: json['thermal_stress']! as int,
  );
}

class InfantSenses {
  const InfantSenses({
    required this.visionRangeMm,
    required this.visualFocus,
    required this.hearing,
    required this.smell,
    required this.touch,
  });

  final int visionRangeMm;
  final int visualFocus;
  final int hearing;
  final int smell;
  final int touch;

  factory InfantSenses.forAgeDays(int ageDays) {
    final int day = ageDays.clamp(0, 30);
    return InfantSenses(
      visionRangeMm: 200 + day * 10,
      visualFocus: 180 + day * 8,
      hearing: 520 + day * 5,
      smell: 620 + day * 4,
      touch: 760 + day * 3,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'vision_range_mm': visionRangeMm,
    'visual_focus': visualFocus,
    'hearing': hearing,
    'smell': smell,
    'touch': touch,
  };

  factory InfantSenses.fromJson(Map<String, Object?> json) => InfantSenses(
    visionRangeMm: json['vision_range_mm']! as int,
    visualFocus: json['visual_focus']! as int,
    hearing: json['hearing']! as int,
    smell: json['smell']! as int,
    touch: json['touch']! as int,
  );
}

class InfantState {
  const InfantState({
    required this.caregiverId,
    required this.needs,
    required this.senses,
    required this.awake,
    required this.crying,
    required this.careInteractions,
    required this.attachment,
    required this.unmetCareEpisodes,
    required this.careResponsePending,
    required this.body,
  });

  factory InfantState.initial(String caregiverId) => InfantState(
    caregiverId: caregiverId,
    needs: const InfantNeeds.initial(),
    senses: InfantSenses.forAgeDays(0),
    awake: true,
    crying: false,
    careInteractions: 0,
    attachment: 100,
    unmetCareEpisodes: 0,
    careResponsePending: false,
    body: const InfantBodyState.newborn(),
  );

  final String caregiverId;
  final InfantNeeds needs;
  final InfantSenses senses;
  final bool awake;
  final bool crying;
  final int careInteractions;
  final int attachment;
  final int unmetCareEpisodes;
  final bool careResponsePending;
  final InfantBodyState? body;

  static List<InfantIntent> allowedIntents(int ageDays) => <InfantIntent>[
    InfantIntent.attendVoice,
    InfantIntent.cryForCare,
    InfantIntent.sleep,
    if (ageDays >= 14) InfantIntent.reach,
  ];

  InfantState passDay(int ageDays, {required bool caregiverAvailable}) {
    if (body != null) {
      final InfantBodyState grownBody = body!.growOneDay();
      return _copy(
        needs: _needsFromBody(grownBody, awake: awake),
        senses: InfantSenses.forAgeDays(ageDays),
        body: grownBody,
      );
    }
    final InfantNeeds nextNeeds = needs.passDay(awake: awake);
    return _copy(
      needs: nextNeeds,
      senses: InfantSenses.forAgeDays(ageDays),
      awake: awake || nextNeeds.sleepPressure < 700,
      crying: nextNeeds.distress >= 500,
      unmetCareEpisodes:
          unmetCareEpisodes +
          (nextNeeds.distress >= 500 && !caregiverAvailable ? 1 : 0),
    );
  }

  InfantPhysiologyStep advancePhysiologyHour(
    int ambientTemperatureMilliC, {
    int illnessSeverity = 0,
    int illnessFeverTargetMilliC = 37000,
  }) {
    if (body == null) return InfantPhysiologyStep(state: this);
    final InfantPhysiologyResult result = body!.advanceHour(
      awake: awake,
      ambientTemperatureMilliC: ambientTemperatureMilliC,
      illnessSeverity: illnessSeverity,
      illnessFeverTargetMilliC: illnessFeverTargetMilliC,
    );
    final InfantNeeds nextNeeds = _needsFromBody(
      result.body,
      awake: result.awake,
    );
    return InfantPhysiologyStep(
      state: _copy(
        body: result.body,
        needs: nextNeeds,
        awake: result.awake,
        crying: nextNeeds.distress >= 500,
      ),
      fellAsleep: result.fellAsleep,
      wokeUp: result.wokeUp,
      urineMl: result.urineMl,
      stoolGrams: result.stoolGrams,
    );
  }

  InfantFeedingStep feedAndComfort({
    required int offeredMl,
    required int energyKjPer100Ml,
    required int waterMlPer100Ml,
    required bool comforted,
  }) {
    if (body == null) {
      final bool fed = offeredMl > 0;
      return InfantFeedingStep(
        state: _copy(
          needs: InfantNeeds(
            hunger: fed ? _bounded(needs.hunger - 520) : needs.hunger,
            thirst: fed ? _bounded(needs.thirst - 460) : needs.thirst,
            sleepPressure: comforted
                ? _bounded(needs.sleepPressure - 280)
                : needs.sleepPressure,
            thermalStress: comforted
                ? _bounded(needs.thermalStress - 180)
                : needs.thermalStress,
          ),
          crying: !(fed && comforted),
          careInteractions: careInteractions + 1,
          attachment: _bounded(attachment + 25),
          careResponsePending: false,
        ),
        consumedMl: fed ? offeredMl : 0,
      );
    }
    final InfantFeedingResult result = body!.feed(
      offeredMl: offeredMl,
      energyKjPer100Ml: energyKjPer100Ml,
      waterMlPer100Ml: waterMlPer100Ml,
      wrapped: comforted,
    );
    final bool soothedToSleep = comforted && body!.sleepPressure >= 500;
    final bool nextAwake =
        !soothedToSleep && awake && result.body.sleepPressure < 700;
    final InfantNeeds nextNeeds = _needsFromBody(result.body, awake: nextAwake);
    return InfantFeedingStep(
      state: _copy(
        body: result.body,
        needs: nextNeeds,
        awake: nextAwake,
        crying: nextNeeds.distress >= 500,
        careInteractions: careInteractions + 1,
        attachment: _bounded(attachment + 25),
        careResponsePending: false,
      ),
      consumedMl: result.consumedMl,
      gainedEnergyKj: result.gainedEnergyKj,
      gainedWaterMl: result.gainedWaterMl,
    );
  }

  InfantState withCareResponsePending(bool value) =>
      _copy(careResponsePending: value);

  InfantState markCareUnmet() => _copy(
    unmetCareEpisodes: unmetCareEpisodes + 1,
    careResponsePending: false,
  );

  InfantState afterIntent(InfantIntent intent) {
    if (intent == InfantIntent.sleep && body != null) {
      final InfantBodyState nextBody = InfantBodyState(
        massGrams: body!.massGrams,
        bodyWaterMl: body!.bodyWaterMl,
        energyReserveKj: body!.energyReserveKj,
        stomachContentMl: body!.stomachContentMl,
        stomachEnergyKj: body!.stomachEnergyKj,
        stomachWaterMl: body!.stomachWaterMl,
        bodyTemperatureMilliC: body!.bodyTemperatureMilliC,
        sleepPressure: _bounded(body!.sleepPressure - 240),
        bladderMl: body!.bladderMl,
        digestiveWasteGrams: body!.digestiveWasteGrams,
        insulation: body!.insulation,
        suckFunction: body!.suckFunction,
        swallowFunction: body!.swallowFunction,
        totalFeedMl: body!.totalFeedMl,
        totalSleepMinutes: body!.totalSleepMinutes,
        totalUrineMl: body!.totalUrineMl,
        totalStoolGrams: body!.totalStoolGrams,
        illnessEnergyCostKj: body!.illnessEnergyCostKj,
        illnessWaterLossMl: body!.illnessWaterLossMl,
        illnessSleepDisruptionMinutes: body!.illnessSleepDisruptionMinutes,
      );
      return _copy(
        body: nextBody,
        needs: _needsFromBody(nextBody, awake: false),
        awake: false,
      );
    }
    return _copy(
      awake: intent != InfantIntent.sleep,
      crying: intent == InfantIntent.cryForCare,
    );
  }

  InfantState _copy({
    InfantNeeds? needs,
    InfantSenses? senses,
    bool? awake,
    bool? crying,
    int? careInteractions,
    int? attachment,
    int? unmetCareEpisodes,
    bool? careResponsePending,
    InfantBodyState? body,
  }) => InfantState(
    caregiverId: caregiverId,
    needs: needs ?? this.needs,
    senses: senses ?? this.senses,
    awake: awake ?? this.awake,
    crying: crying ?? this.crying,
    careInteractions: careInteractions ?? this.careInteractions,
    attachment: attachment ?? this.attachment,
    unmetCareEpisodes: unmetCareEpisodes ?? this.unmetCareEpisodes,
    careResponsePending: careResponsePending ?? this.careResponsePending,
    body: body ?? this.body,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'caregiver_id': caregiverId,
    'needs': needs.toJson(),
    'senses': senses.toJson(),
    'awake': awake,
    'crying': crying,
    'care_interactions': careInteractions,
    'attachment': attachment,
    'unmet_care_episodes': unmetCareEpisodes,
    'care_response_pending': careResponsePending,
    if (body != null) 'body': body!.toJson(),
  };

  factory InfantState.fromJson(Map<String, Object?> json) => InfantState(
    caregiverId: json['caregiver_id']! as String,
    needs: InfantNeeds.fromJson(
      (json['needs']! as Map).cast<String, Object?>(),
    ),
    senses: InfantSenses.fromJson(
      (json['senses']! as Map).cast<String, Object?>(),
    ),
    awake: json['awake']! as bool,
    crying: json['crying']! as bool,
    careInteractions: json['care_interactions']! as int,
    attachment: json['attachment']! as int,
    unmetCareEpisodes:
        json['unmet_care_episodes'] as int? ??
        json['unmet_care_days'] as int? ??
        0,
    careResponsePending: json['care_response_pending'] as bool? ?? false,
    body: json['body'] == null
        ? null
        : InfantBodyState.fromJson(
            (json['body']! as Map).cast<String, Object?>(),
          ),
  );
}

class InfantPhysiologyStep {
  const InfantPhysiologyStep({
    required this.state,
    this.fellAsleep = false,
    this.wokeUp = false,
    this.urineMl = 0,
    this.stoolGrams = 0,
  });

  final InfantState state;
  final bool fellAsleep;
  final bool wokeUp;
  final int urineMl;
  final int stoolGrams;
}

class InfantFeedingStep {
  const InfantFeedingStep({
    required this.state,
    required this.consumedMl,
    this.gainedEnergyKj = 0,
    this.gainedWaterMl = 0,
  });

  final InfantState state;
  final int consumedMl;
  final int gainedEnergyKj;
  final int gainedWaterMl;
}

InfantNeeds _needsFromBody(InfantBodyState body, {required bool awake}) =>
    InfantNeeds(
      hunger: body.hunger,
      thirst: body.thirst,
      sleepPressure: awake ? body.sleepPressure : 0,
      thermalStress: body.thermalStress,
    );

int _bounded(int value) => value.clamp(0, 1000);
