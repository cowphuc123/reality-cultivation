enum ProductionBatchStatus { inProgress, completed, blocked }

class ProductionIngredient {
  const ProductionIngredient({
    required this.kind,
    required this.quantity,
    required this.unit,
  });

  final String kind;
  final int quantity;
  final String unit;

  Map<String, Object> toJson() => <String, Object>{
    'kind': kind,
    'quantity': quantity,
    'unit': unit,
  };

  factory ProductionIngredient.fromJson(Map<String, Object?> json) =>
      ProductionIngredient(
        kind: json['kind']! as String,
        quantity: json['quantity']! as int,
        unit: json['unit']! as String,
      );
}

/// Một lô nguyên liệu đã rời kho và đang nằm trong workpiece của mẻ sản xuất.
class ProductionMaterialLot {
  const ProductionMaterialLot({
    required this.itemId,
    required this.kind,
    required this.quantity,
    required this.unit,
    required this.condition,
  });

  final String itemId;
  final String kind;
  final int quantity;
  final String unit;
  final int condition;

  Map<String, Object> toJson() => <String, Object>{
    'item_id': itemId,
    'kind': kind,
    'quantity': quantity,
    'unit': unit,
    'condition': condition,
  };

  factory ProductionMaterialLot.fromJson(Map<String, Object?> json) =>
      ProductionMaterialLot(
        itemId: json['item_id']! as String,
        kind: json['kind']! as String,
        quantity: json['quantity']! as int,
        unit: json['unit']! as String,
        condition: json['condition']! as int,
      );
}

/// Công thức cụ thể được chép vào mẻ để save không phụ thuộc registry bên ngoài.
class ProductionRecipe {
  const ProductionRecipe({
    required this.id,
    required this.name,
    required this.durationSeconds,
    required this.inputs,
    required this.outputKind,
    required this.outputQuantity,
    required this.outputUnit,
    this.toolKind,
    this.toolWear = 0,
  });

  final String id;
  final String name;
  final int durationSeconds;
  final List<ProductionIngredient> inputs;
  final String outputKind;
  final int outputQuantity;
  final String outputUnit;
  final String? toolKind;
  final int toolWear;

  void validate() {
    if (id.isEmpty || name.isEmpty || outputKind.isEmpty || outputUnit.isEmpty) {
      throw StateError('Production recipe contains an empty identity field.');
    }
    if (durationSeconds <= 0 || outputQuantity <= 0) {
      throw StateError('Production duration and output must be positive.');
    }
    if (inputs.isEmpty ||
        inputs.any(
          (ProductionIngredient value) =>
              value.kind.isEmpty || value.unit.isEmpty || value.quantity <= 0,
        ) ||
        inputs.map((ProductionIngredient value) => value.kind).toSet().length !=
            inputs.length) {
      throw StateError('Production inputs must be positive and unique by kind.');
    }
    if (toolWear < 0 || toolWear > 1000) {
      throw StateError('Production tool wear must be within 0..1000.');
    }
    if (toolKind == null && toolWear != 0) {
      throw StateError('A recipe without a tool cannot wear one.');
    }
  }

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'duration_seconds': durationSeconds,
    'inputs': inputs
        .map((ProductionIngredient value) => value.toJson())
        .toList(),
    'output_kind': outputKind,
    'output_quantity': outputQuantity,
    'output_unit': outputUnit,
    if (toolKind != null) 'tool_kind': toolKind!,
    if (toolWear != 0) 'tool_wear': toolWear,
  };

  factory ProductionRecipe.fromJson(Map<String, Object?> json) =>
      ProductionRecipe(
        id: json['id']! as String,
        name: json['name']! as String,
        durationSeconds: json['duration_seconds']! as int,
        inputs: <ProductionIngredient>[
          for (final Object? value in json['inputs']! as List<Object?>)
            ProductionIngredient.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
        outputKind: json['output_kind']! as String,
        outputQuantity: json['output_quantity']! as int,
        outputUnit: json['output_unit']! as String,
        toolKind: json['tool_kind'] as String?,
        toolWear: json['tool_wear'] as int? ?? 0,
      );
}

/// Workpiece bền qua save/load: nguyên liệu đã rút không biến mất khi công việc
/// bị chặn, và đầu ra chỉ được ghi sau sự kiện hoàn tất.
class ProductionBatchState {
  const ProductionBatchState({
    required this.id,
    required this.recipe,
    required this.actorId,
    required this.householdId,
    required this.roomId,
    required this.outputItemId,
    required this.startedAtSeconds,
    required this.completesAtSeconds,
    required this.materials,
    required this.status,
    this.toolItemId,
    this.finishedAtSeconds,
    this.failureReason,
  });

  final String id;
  final ProductionRecipe recipe;
  final String actorId;
  final String householdId;
  final String roomId;
  final String outputItemId;
  final String? toolItemId;
  final int startedAtSeconds;
  final int completesAtSeconds;
  final List<ProductionMaterialLot> materials;
  final ProductionBatchStatus status;
  final int? finishedAtSeconds;
  final String? failureReason;

  ProductionBatchState complete(int atSeconds) => _copy(
    status: ProductionBatchStatus.completed,
    finishedAtSeconds: atSeconds,
  );

  ProductionBatchState block(int atSeconds, String reason) => _copy(
    status: ProductionBatchStatus.blocked,
    finishedAtSeconds: atSeconds,
    failureReason: reason,
  );

  ProductionBatchState _copy({
    required ProductionBatchStatus status,
    required int finishedAtSeconds,
    String? failureReason,
  }) => ProductionBatchState(
    id: id,
    recipe: recipe,
    actorId: actorId,
    householdId: householdId,
    roomId: roomId,
    outputItemId: outputItemId,
    toolItemId: toolItemId,
    startedAtSeconds: startedAtSeconds,
    completesAtSeconds: completesAtSeconds,
    materials: materials,
    status: status,
    finishedAtSeconds: finishedAtSeconds,
    failureReason: failureReason,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'recipe': recipe.toJson(),
    'actor_id': actorId,
    'household_id': householdId,
    'room_id': roomId,
    'output_item_id': outputItemId,
    if (toolItemId != null) 'tool_item_id': toolItemId,
    'started_at_seconds': startedAtSeconds,
    'completes_at_seconds': completesAtSeconds,
    'materials': materials
        .map((ProductionMaterialLot value) => value.toJson())
        .toList(),
    'status': status.name,
    if (finishedAtSeconds != null) 'finished_at_seconds': finishedAtSeconds,
    if (failureReason != null) 'failure_reason': failureReason,
  };

  factory ProductionBatchState.fromJson(Map<String, Object?> json) =>
      ProductionBatchState(
        id: json['id']! as String,
        recipe: ProductionRecipe.fromJson(
          (json['recipe']! as Map).cast<String, Object?>(),
        ),
        actorId: json['actor_id']! as String,
        householdId: json['household_id']! as String,
        roomId: json['room_id']! as String,
        outputItemId: json['output_item_id']! as String,
        toolItemId: json['tool_item_id'] as String?,
        startedAtSeconds: json['started_at_seconds']! as int,
        completesAtSeconds: json['completes_at_seconds']! as int,
        materials: <ProductionMaterialLot>[
          for (final Object? value in json['materials']! as List<Object?>)
            ProductionMaterialLot.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
        status: ProductionBatchStatus.values.byName(
          json['status']! as String,
        ),
        finishedAtSeconds: json['finished_at_seconds'] as int?,
        failureReason: json['failure_reason'] as String?,
      );
}

enum ServiceAppointmentStatus { booked, inProgress, completed, blocked }

/// Loại dịch vụ được chép vào cuộc hẹn để bản lưu không phụ thuộc catalog.
class ServiceDefinition {
  const ServiceDefinition({
    required this.id,
    required this.name,
    required this.durationSeconds,
    required this.resultClaimKind,
    this.inputs = const <ProductionIngredient>[],
  });

  final String id;
  final String name;
  final int durationSeconds;
  final String resultClaimKind;
  final List<ProductionIngredient> inputs;

  void validate() {
    if (id.isEmpty || name.isEmpty || resultClaimKind.isEmpty) {
      throw StateError('Service definition contains an empty identity field.');
    }
    if (durationSeconds <= 0 ||
        inputs.any(
          (ProductionIngredient value) =>
              value.kind.isEmpty || value.unit.isEmpty || value.quantity <= 0,
        ) ||
        inputs.map((ProductionIngredient value) => value.kind).toSet().length !=
            inputs.length) {
      throw StateError('Service duration and inputs must be valid.');
    }
  }

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'name': name,
    'duration_seconds': durationSeconds,
    'result_claim_kind': resultClaimKind,
    'inputs': inputs
        .map((ProductionIngredient value) => value.toJson())
        .toList(),
  };

  factory ServiceDefinition.fromJson(Map<String, Object?> json) =>
      ServiceDefinition(
        id: json['id']! as String,
        name: json['name']! as String,
        durationSeconds: json['duration_seconds']! as int,
        resultClaimKind: json['result_claim_kind']! as String,
        inputs: <ProductionIngredient>[
          for (final Object? value
              in (json['inputs'] as List<Object?>? ?? const <Object?>[]))
            ProductionIngredient.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
      );
}

/// Chứng cứ bền qua save/load rằng một dịch vụ cụ thể đã được thực hiện.
class ServiceResultClaim {
  const ServiceResultClaim({
    required this.id,
    required this.kind,
    required this.appointmentId,
    required this.providerId,
    required this.recipientId,
    required this.createdAtSeconds,
  });

  final String id;
  final String kind;
  final String appointmentId;
  final String providerId;
  final String recipientId;
  final int createdAtSeconds;

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'kind': kind,
    'appointment_id': appointmentId,
    'provider_id': providerId,
    'recipient_id': recipientId,
    'created_at_seconds': createdAtSeconds,
  };

  factory ServiceResultClaim.fromJson(Map<String, Object?> json) =>
      ServiceResultClaim(
        id: json['id']! as String,
        kind: json['kind']! as String,
        appointmentId: json['appointment_id']! as String,
        providerId: json['provider_id']! as String,
        recipientId: json['recipient_id']! as String,
        createdAtSeconds: json['created_at_seconds']! as int,
      );
}

/// Cuộc hẹn giữ lịch hai phía. Nguyên liệu đã đặt cho dịch vụ nằm trong hồ sơ
/// này; kết quả chỉ có mặt sau sự kiện hoàn tất.
class ServiceAppointmentState {
  const ServiceAppointmentState({
    required this.id,
    required this.definition,
    required this.providerId,
    required this.recipientId,
    required this.providerHouseholdId,
    required this.recipientHouseholdId,
    required this.roomId,
    required this.startsAtSeconds,
    required this.endsAtSeconds,
    required this.materials,
    required this.status,
    this.resultClaim,
    this.failureReason,
  });

  final String id;
  final ServiceDefinition definition;
  final String providerId;
  final String recipientId;
  final String providerHouseholdId;
  final String recipientHouseholdId;
  final String roomId;
  final int startsAtSeconds;
  final int endsAtSeconds;
  final List<ProductionMaterialLot> materials;
  final ServiceAppointmentStatus status;
  final ServiceResultClaim? resultClaim;
  final String? failureReason;

  bool reservesPerson(String personId, int start, int end) =>
      status != ServiceAppointmentStatus.completed &&
      status != ServiceAppointmentStatus.blocked &&
      (providerId == personId || recipientId == personId) &&
      start < endsAtSeconds &&
      end > startsAtSeconds;

  ServiceAppointmentState begin() => _copy(
    status: ServiceAppointmentStatus.inProgress,
  );

  ServiceAppointmentState complete(ServiceResultClaim claim) => _copy(
    status: ServiceAppointmentStatus.completed,
    resultClaim: claim,
  );

  ServiceAppointmentState block(String reason) => _copy(
    status: ServiceAppointmentStatus.blocked,
    failureReason: reason,
  );

  ServiceAppointmentState _copy({
    required ServiceAppointmentStatus status,
    ServiceResultClaim? resultClaim,
    String? failureReason,
  }) => ServiceAppointmentState(
    id: id,
    definition: definition,
    providerId: providerId,
    recipientId: recipientId,
    providerHouseholdId: providerHouseholdId,
    recipientHouseholdId: recipientHouseholdId,
    roomId: roomId,
    startsAtSeconds: startsAtSeconds,
    endsAtSeconds: endsAtSeconds,
    materials: materials,
    status: status,
    resultClaim: resultClaim ?? this.resultClaim,
    failureReason: failureReason ?? this.failureReason,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'definition': definition.toJson(),
    'provider_id': providerId,
    'recipient_id': recipientId,
    'provider_household_id': providerHouseholdId,
    'recipient_household_id': recipientHouseholdId,
    'room_id': roomId,
    'starts_at_seconds': startsAtSeconds,
    'ends_at_seconds': endsAtSeconds,
    'materials': materials
        .map((ProductionMaterialLot value) => value.toJson())
        .toList(),
    'status': status.name,
    if (resultClaim != null) 'result_claim': resultClaim!.toJson(),
    if (failureReason != null) 'failure_reason': failureReason,
  };

  factory ServiceAppointmentState.fromJson(Map<String, Object?> json) =>
      ServiceAppointmentState(
        id: json['id']! as String,
        definition: ServiceDefinition.fromJson(
          (json['definition']! as Map).cast<String, Object?>(),
        ),
        providerId: json['provider_id']! as String,
        recipientId: json['recipient_id']! as String,
        providerHouseholdId: json['provider_household_id']! as String,
        recipientHouseholdId: json['recipient_household_id']! as String,
        roomId: json['room_id']! as String,
        startsAtSeconds: json['starts_at_seconds']! as int,
        endsAtSeconds: json['ends_at_seconds']! as int,
        materials: <ProductionMaterialLot>[
          for (final Object? value
              in (json['materials'] as List<Object?>? ?? const <Object?>[]))
            ProductionMaterialLot.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
        status: ServiceAppointmentStatus.values.byName(
          json['status']! as String,
        ),
        resultClaim: json['result_claim'] == null
            ? null
            : ServiceResultClaim.fromJson(
                (json['result_claim']! as Map).cast<String, Object?>(),
              ),
        failureReason: json['failure_reason'] as String?,
      );
}

enum LaborOfferStatus {
  offered,
  accepted,
  refused,
  inProgress,
  completed,
  blocked,
}

enum LaborClaimStatus { outstanding, settled }

/// Quyền lợi hiện vật đã hứa trước khi người lao động nhận việc.
class LaborCompensationTerms {
  const LaborCompensationTerms({
    required this.itemKind,
    required this.quantity,
    required this.unit,
  });

  final String itemKind;
  final int quantity;
  final String unit;

  void validate() {
    if (itemKind.isEmpty || unit.isEmpty || quantity <= 0) {
      throw StateError('Labor compensation terms must be positive.');
    }
  }

  Map<String, Object> toJson() => <String, Object>{
    'item_kind': itemKind,
    'quantity': quantity,
    'unit': unit,
  };

  factory LaborCompensationTerms.fromJson(Map<String, Object?> json) =>
      LaborCompensationTerms(
        itemKind: json['item_kind']! as String,
        quantity: json['quantity']! as int,
        unit: json['unit']! as String,
      );
}

/// Lời mời lao động giữ cả điều kiện đã chào lẫn quyết định của người nhận.
class LaborOfferState {
  const LaborOfferState({
    required this.id,
    required this.activity,
    required this.skillCode,
    required this.minimumSkill,
    required this.priority,
    required this.employerId,
    required this.workerId,
    required this.employerHouseholdId,
    required this.workerHouseholdId,
    required this.roomId,
    required this.startsAtSeconds,
    required this.endsAtSeconds,
    required this.compensation,
    required this.status,
    this.decisionReason,
    this.finishedAtSeconds,
    this.compensationClaimId,
  });

  final String id;
  final String activity;
  final String skillCode;
  final int minimumSkill;
  final int priority;
  final String employerId;
  final String workerId;
  final String employerHouseholdId;
  final String workerHouseholdId;
  final String roomId;
  final int startsAtSeconds;
  final int endsAtSeconds;
  final LaborCompensationTerms compensation;
  final LaborOfferStatus status;
  final String? decisionReason;
  final int? finishedAtSeconds;
  final String? compensationClaimId;

  bool reservesWorker(String personId, int start, int end) =>
      (status == LaborOfferStatus.accepted ||
          status == LaborOfferStatus.inProgress) &&
      workerId == personId &&
      start < endsAtSeconds &&
      end > startsAtSeconds;

  LaborOfferState accept(String reason) => _copy(
    status: LaborOfferStatus.accepted,
    decisionReason: reason,
  );

  LaborOfferState refuse(String reason) => _copy(
    status: LaborOfferStatus.refused,
    decisionReason: reason,
  );

  LaborOfferState begin() => _copy(status: LaborOfferStatus.inProgress);

  LaborOfferState complete(int atSeconds, String claimId) => _copy(
    status: LaborOfferStatus.completed,
    finishedAtSeconds: atSeconds,
    compensationClaimId: claimId,
  );

  LaborOfferState block(int atSeconds, String reason) => _copy(
    status: LaborOfferStatus.blocked,
    decisionReason: reason,
    finishedAtSeconds: atSeconds,
  );

  LaborOfferState _copy({
    required LaborOfferStatus status,
    String? decisionReason,
    int? finishedAtSeconds,
    String? compensationClaimId,
  }) => LaborOfferState(
    id: id,
    activity: activity,
    skillCode: skillCode,
    minimumSkill: minimumSkill,
    priority: priority,
    employerId: employerId,
    workerId: workerId,
    employerHouseholdId: employerHouseholdId,
    workerHouseholdId: workerHouseholdId,
    roomId: roomId,
    startsAtSeconds: startsAtSeconds,
    endsAtSeconds: endsAtSeconds,
    compensation: compensation,
    status: status,
    decisionReason: decisionReason ?? this.decisionReason,
    finishedAtSeconds: finishedAtSeconds ?? this.finishedAtSeconds,
    compensationClaimId: compensationClaimId ?? this.compensationClaimId,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'activity': activity,
    'skill_code': skillCode,
    'minimum_skill': minimumSkill,
    'priority': priority,
    'employer_id': employerId,
    'worker_id': workerId,
    'employer_household_id': employerHouseholdId,
    'worker_household_id': workerHouseholdId,
    'room_id': roomId,
    'starts_at_seconds': startsAtSeconds,
    'ends_at_seconds': endsAtSeconds,
    'compensation': compensation.toJson(),
    'status': status.name,
    if (decisionReason != null) 'decision_reason': decisionReason,
    if (finishedAtSeconds != null) 'finished_at_seconds': finishedAtSeconds,
    if (compensationClaimId != null)
      'compensation_claim_id': compensationClaimId,
  };

  factory LaborOfferState.fromJson(Map<String, Object?> json) =>
      LaborOfferState(
        id: json['id']! as String,
        activity: json['activity']! as String,
        skillCode: json['skill_code']! as String,
        minimumSkill: json['minimum_skill']! as int,
        priority: json['priority']! as int,
        employerId: json['employer_id']! as String,
        workerId: json['worker_id']! as String,
        employerHouseholdId: json['employer_household_id']! as String,
        workerHouseholdId: json['worker_household_id']! as String,
        roomId: json['room_id']! as String,
        startsAtSeconds: json['starts_at_seconds']! as int,
        endsAtSeconds: json['ends_at_seconds']! as int,
        compensation: LaborCompensationTerms.fromJson(
          (json['compensation']! as Map).cast<String, Object?>(),
        ),
        status: LaborOfferStatus.values.byName(json['status']! as String),
        decisionReason: json['decision_reason'] as String?,
        finishedAtSeconds: json['finished_at_seconds'] as int?,
        compensationClaimId: json['compensation_claim_id'] as String?,
      );
}

/// Khoản phải trả chỉ xuất hiện sau khi công thật đã hoàn tất.
class LaborCompensationClaim {
  const LaborCompensationClaim({
    required this.id,
    required this.offerId,
    required this.debtorHouseholdId,
    required this.creditorHouseholdId,
    required this.creditorPersonId,
    required this.terms,
    required this.createdAtSeconds,
    required this.status,
    this.settledAtSeconds,
    this.paymentSourceItemId,
    this.paymentTargetItemId,
  });

  final String id;
  final String offerId;
  final String debtorHouseholdId;
  final String creditorHouseholdId;
  final String creditorPersonId;
  final LaborCompensationTerms terms;
  final int createdAtSeconds;
  final LaborClaimStatus status;
  final int? settledAtSeconds;
  final String? paymentSourceItemId;
  final String? paymentTargetItemId;

  LaborCompensationClaim settle({
    required int atSeconds,
    required String sourceItemId,
    required String targetItemId,
  }) => LaborCompensationClaim(
    id: id,
    offerId: offerId,
    debtorHouseholdId: debtorHouseholdId,
    creditorHouseholdId: creditorHouseholdId,
    creditorPersonId: creditorPersonId,
    terms: terms,
    createdAtSeconds: createdAtSeconds,
    status: LaborClaimStatus.settled,
    settledAtSeconds: atSeconds,
    paymentSourceItemId: sourceItemId,
    paymentTargetItemId: targetItemId,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'offer_id': offerId,
    'debtor_household_id': debtorHouseholdId,
    'creditor_household_id': creditorHouseholdId,
    'creditor_person_id': creditorPersonId,
    'terms': terms.toJson(),
    'created_at_seconds': createdAtSeconds,
    'status': status.name,
    if (settledAtSeconds != null) 'settled_at_seconds': settledAtSeconds,
    if (paymentSourceItemId != null)
      'payment_source_item_id': paymentSourceItemId,
    if (paymentTargetItemId != null)
      'payment_target_item_id': paymentTargetItemId,
  };

  factory LaborCompensationClaim.fromJson(Map<String, Object?> json) =>
      LaborCompensationClaim(
        id: json['id']! as String,
        offerId: json['offer_id']! as String,
        debtorHouseholdId: json['debtor_household_id']! as String,
        creditorHouseholdId: json['creditor_household_id']! as String,
        creditorPersonId: json['creditor_person_id']! as String,
        terms: LaborCompensationTerms.fromJson(
          (json['terms']! as Map).cast<String, Object?>(),
        ),
        createdAtSeconds: json['created_at_seconds']! as int,
        status: LaborClaimStatus.values.byName(json['status']! as String),
        settledAtSeconds: json['settled_at_seconds'] as int?,
        paymentSourceItemId: json['payment_source_item_id'] as String?,
        paymentTargetItemId: json['payment_target_item_id'] as String?,
      );
}

enum MarketOfferStatus { open, exhausted, cancelled }

enum MarketOrderStatus { reserved, settled, cancelled }

/// Một lượng vật đã rời kho thường và đang được chợ giữ riêng.
class MarketEscrowLot {
  const MarketEscrowLot({
    required this.sourceItemId,
    required this.kind,
    required this.quantity,
    required this.condition,
    required this.unit,
    this.energyKjPer100Ml = 0,
    this.waterMlPer100Ml = 0,
  });

  final String sourceItemId;
  final String kind;
  final int quantity;
  final int condition;
  final String unit;
  final int energyKjPer100Ml;
  final int waterMlPer100Ml;

  MarketEscrowLot withQuantity(int value) => MarketEscrowLot(
    sourceItemId: sourceItemId,
    kind: kind,
    quantity: value,
    condition: condition,
    unit: unit,
    energyKjPer100Ml: energyKjPer100Ml,
    waterMlPer100Ml: waterMlPer100Ml,
  );

  MarketEscrowLot withCondition(int value) => MarketEscrowLot(
    sourceItemId: sourceItemId,
    kind: kind,
    quantity: quantity,
    condition: value.clamp(0, 1000),
    unit: unit,
    energyKjPer100Ml: energyKjPer100Ml,
    waterMlPer100Ml: waterMlPer100Ml,
  );

  Map<String, Object> toJson() => <String, Object>{
    'source_item_id': sourceItemId,
    'kind': kind,
    'quantity': quantity,
    'condition': condition,
    'unit': unit,
    if (energyKjPer100Ml > 0) 'energy_kj_per_100ml': energyKjPer100Ml,
    if (waterMlPer100Ml > 0) 'water_ml_per_100ml': waterMlPer100Ml,
  };

  factory MarketEscrowLot.fromJson(Map<String, Object?> json) =>
      MarketEscrowLot(
        sourceItemId: json['source_item_id']! as String,
        kind: json['kind']! as String,
        quantity: json['quantity']! as int,
        condition: json['condition']! as int,
        unit: json['unit']! as String,
        energyKjPer100Ml: json['energy_kj_per_100ml'] as int? ?? 0,
        waterMlPer100Ml: json['water_ml_per_100ml'] as int? ?? 0,
      );
}

/// Hàng đăng bán đã được rút khỏi item nguồn nên không thể bị dùng hai lần.
class MarketOfferState {
  const MarketOfferState({
    required this.id,
    required this.sellerPersonId,
    required this.sellerHouseholdId,
    required this.roomId,
    required this.offeredQuantity,
    required this.lotQuantity,
    required this.paymentKind,
    required this.paymentQuantityPerLot,
    required this.paymentUnit,
    required this.merchandise,
    required this.knownByPersonIds,
    required this.createdAtSeconds,
    required this.status,
  });

  final String id;
  final String sellerPersonId;
  final String sellerHouseholdId;
  final String roomId;
  final int offeredQuantity;
  final int lotQuantity;
  final String paymentKind;
  final int paymentQuantityPerLot;
  final String paymentUnit;
  final MarketEscrowLot merchandise;
  final List<String> knownByPersonIds;
  final int createdAtSeconds;
  final MarketOfferStatus status;

  int paymentFor(int quantity) {
    if (quantity <= 0 || quantity % lotQuantity != 0) {
      throw ArgumentError('Market quantity must contain whole lots.');
    }
    return (quantity ~/ lotQuantity) * paymentQuantityPerLot;
  }

  bool isKnownBy(String personId) => knownByPersonIds.contains(personId);

  MarketOfferState reserve(int quantity) {
    final int remaining = merchandise.quantity - quantity;
    if (quantity <= 0 || remaining < 0 || quantity % lotQuantity != 0) {
      throw StateError('Market offer cannot reserve this quantity.');
    }
    return MarketOfferState(
      id: id,
      sellerPersonId: sellerPersonId,
      sellerHouseholdId: sellerHouseholdId,
      roomId: roomId,
      offeredQuantity: offeredQuantity,
      lotQuantity: lotQuantity,
      paymentKind: paymentKind,
      paymentQuantityPerLot: paymentQuantityPerLot,
      paymentUnit: paymentUnit,
      merchandise: merchandise.withQuantity(remaining),
      knownByPersonIds: knownByPersonIds,
      createdAtSeconds: createdAtSeconds,
      status: remaining == 0
          ? MarketOfferStatus.exhausted
          : MarketOfferStatus.open,
    );
  }

  Map<String, Object> toJson() => <String, Object>{
    'id': id,
    'seller_person_id': sellerPersonId,
    'seller_household_id': sellerHouseholdId,
    'room_id': roomId,
    'offered_quantity': offeredQuantity,
    'lot_quantity': lotQuantity,
    'payment_kind': paymentKind,
    'payment_quantity_per_lot': paymentQuantityPerLot,
    'payment_unit': paymentUnit,
    'merchandise': merchandise.toJson(),
    'known_by_person_ids': knownByPersonIds,
    'created_at_seconds': createdAtSeconds,
    'status': status.name,
  };

  factory MarketOfferState.fromJson(Map<String, Object?> json) =>
      MarketOfferState(
        id: json['id']! as String,
        sellerPersonId: json['seller_person_id']! as String,
        sellerHouseholdId: json['seller_household_id']! as String,
        roomId: json['room_id']! as String,
        offeredQuantity: json['offered_quantity']! as int,
        lotQuantity: json['lot_quantity']! as int,
        paymentKind: json['payment_kind']! as String,
        paymentQuantityPerLot: json['payment_quantity_per_lot']! as int,
        paymentUnit: json['payment_unit']! as String,
        merchandise: MarketEscrowLot.fromJson(
          (json['merchandise']! as Map).cast<String, Object?>(),
        ),
        knownByPersonIds: (json['known_by_person_ids']! as List<Object?>)
            .cast<String>(),
        createdAtSeconds: json['created_at_seconds']! as int,
        status: MarketOfferStatus.values.byName(json['status']! as String),
      );
}

/// Một đơn đã giữ cả hàng mua lẫn vật thanh toán trước khi settlement.
class MarketOrderState {
  const MarketOrderState({
    required this.id,
    required this.offerId,
    required this.sellerPersonId,
    required this.sellerHouseholdId,
    required this.buyerPersonId,
    required this.buyerHouseholdId,
    required this.roomId,
    required this.merchandise,
    required this.payment,
    required this.createdAtSeconds,
    required this.status,
    this.settledAtSeconds,
    this.buyerTargetItemId,
    this.sellerTargetItemId,
  });

  final String id;
  final String offerId;
  final String sellerPersonId;
  final String sellerHouseholdId;
  final String buyerPersonId;
  final String buyerHouseholdId;
  final String roomId;
  final MarketEscrowLot merchandise;
  final MarketEscrowLot payment;
  final int createdAtSeconds;
  final MarketOrderStatus status;
  final int? settledAtSeconds;
  final String? buyerTargetItemId;
  final String? sellerTargetItemId;

  MarketOrderState settle({
    required int atSeconds,
    required String buyerTargetItemId,
    required String sellerTargetItemId,
  }) => MarketOrderState(
    id: id,
    offerId: offerId,
    sellerPersonId: sellerPersonId,
    sellerHouseholdId: sellerHouseholdId,
    buyerPersonId: buyerPersonId,
    buyerHouseholdId: buyerHouseholdId,
    roomId: roomId,
    merchandise: merchandise,
    payment: payment,
    createdAtSeconds: createdAtSeconds,
    status: MarketOrderStatus.settled,
    settledAtSeconds: atSeconds,
    buyerTargetItemId: buyerTargetItemId,
    sellerTargetItemId: sellerTargetItemId,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'offer_id': offerId,
    'seller_person_id': sellerPersonId,
    'seller_household_id': sellerHouseholdId,
    'buyer_person_id': buyerPersonId,
    'buyer_household_id': buyerHouseholdId,
    'room_id': roomId,
    'merchandise': merchandise.toJson(),
    'payment': payment.toJson(),
    'created_at_seconds': createdAtSeconds,
    'status': status.name,
    if (settledAtSeconds != null) 'settled_at_seconds': settledAtSeconds,
    if (buyerTargetItemId != null) 'buyer_target_item_id': buyerTargetItemId,
    if (sellerTargetItemId != null) 'seller_target_item_id': sellerTargetItemId,
  };

  factory MarketOrderState.fromJson(Map<String, Object?> json) =>
      MarketOrderState(
        id: json['id']! as String,
        offerId: json['offer_id']! as String,
        sellerPersonId: json['seller_person_id']! as String,
        sellerHouseholdId: json['seller_household_id']! as String,
        buyerPersonId: json['buyer_person_id']! as String,
        buyerHouseholdId: json['buyer_household_id']! as String,
        roomId: json['room_id']! as String,
        merchandise: MarketEscrowLot.fromJson(
          (json['merchandise']! as Map).cast<String, Object?>(),
        ),
        payment: MarketEscrowLot.fromJson(
          (json['payment']! as Map).cast<String, Object?>(),
        ),
        createdAtSeconds: json['created_at_seconds']! as int,
        status: MarketOrderStatus.values.byName(json['status']! as String),
        settledAtSeconds: json['settled_at_seconds'] as int?,
        buyerTargetItemId: json['buyer_target_item_id'] as String?,
        sellerTargetItemId: json['seller_target_item_id'] as String?,
      );
}

enum MarketShipmentStatus { inTransit, delivered, failed }

/// Hàng sau giao dịch đang đi trên một tuyến thật, tách khỏi kho hai đầu.
class MarketShipmentState {
  const MarketShipmentState({
    required this.id,
    required this.orderId,
    required this.ownerHouseholdId,
    required this.ownerPersonId,
    required this.carrierId,
    required this.routeId,
    required this.pathWaypointIds,
    required this.originRoomId,
    required this.destinationRoomId,
    required this.destinationItemId,
    required this.cargo,
    required this.departedAtSeconds,
    required this.expectedArrivalSeconds,
    required this.scheduledArrivalSeconds,
    required this.distanceMm,
    required this.lateSeconds,
    required this.plannedConditionLoss,
    required this.status,
    this.arrivedAtSeconds,
    this.failureReason,
  });

  final String id;
  final String orderId;
  final String ownerHouseholdId;
  final String ownerPersonId;
  final String carrierId;
  final String routeId;
  final List<String> pathWaypointIds;
  final String originRoomId;
  final String destinationRoomId;
  final String destinationItemId;
  final MarketEscrowLot cargo;
  final int departedAtSeconds;
  final int expectedArrivalSeconds;
  final int scheduledArrivalSeconds;
  final int distanceMm;
  final int lateSeconds;
  final int plannedConditionLoss;
  final MarketShipmentStatus status;
  final int? arrivedAtSeconds;
  final String? failureReason;

  MarketShipmentState deliver(int atSeconds) => MarketShipmentState(
    id: id,
    orderId: orderId,
    ownerHouseholdId: ownerHouseholdId,
    ownerPersonId: ownerPersonId,
    carrierId: carrierId,
    routeId: routeId,
    pathWaypointIds: pathWaypointIds,
    originRoomId: originRoomId,
    destinationRoomId: destinationRoomId,
    destinationItemId: destinationItemId,
    cargo: cargo.withCondition(cargo.condition - plannedConditionLoss),
    departedAtSeconds: departedAtSeconds,
    expectedArrivalSeconds: expectedArrivalSeconds,
    scheduledArrivalSeconds: scheduledArrivalSeconds,
    distanceMm: distanceMm,
    lateSeconds: lateSeconds,
    plannedConditionLoss: plannedConditionLoss,
    status: MarketShipmentStatus.delivered,
    arrivedAtSeconds: atSeconds,
  );

  MarketShipmentState fail(int atSeconds, String reason) =>
      MarketShipmentState(
        id: id,
        orderId: orderId,
        ownerHouseholdId: ownerHouseholdId,
        ownerPersonId: ownerPersonId,
        carrierId: carrierId,
        routeId: routeId,
        pathWaypointIds: pathWaypointIds,
        originRoomId: originRoomId,
        destinationRoomId: destinationRoomId,
        destinationItemId: destinationItemId,
        cargo: cargo.withCondition(cargo.condition - plannedConditionLoss),
        departedAtSeconds: departedAtSeconds,
        expectedArrivalSeconds: expectedArrivalSeconds,
        scheduledArrivalSeconds: scheduledArrivalSeconds,
        distanceMm: distanceMm,
        lateSeconds: lateSeconds,
        plannedConditionLoss: plannedConditionLoss,
        status: MarketShipmentStatus.failed,
        arrivedAtSeconds: atSeconds,
        failureReason: reason,
      );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'order_id': orderId,
    'owner_household_id': ownerHouseholdId,
    'owner_person_id': ownerPersonId,
    'carrier_id': carrierId,
    'route_id': routeId,
    'path_waypoint_ids': pathWaypointIds,
    'origin_room_id': originRoomId,
    'destination_room_id': destinationRoomId,
    'destination_item_id': destinationItemId,
    'cargo': cargo.toJson(),
    'departed_at_seconds': departedAtSeconds,
    'expected_arrival_seconds': expectedArrivalSeconds,
    'scheduled_arrival_seconds': scheduledArrivalSeconds,
    'distance_mm': distanceMm,
    'late_seconds': lateSeconds,
    'planned_condition_loss': plannedConditionLoss,
    'status': status.name,
    if (arrivedAtSeconds != null) 'arrived_at_seconds': arrivedAtSeconds,
    if (failureReason != null) 'failure_reason': failureReason,
  };

  factory MarketShipmentState.fromJson(Map<String, Object?> json) =>
      MarketShipmentState(
        id: json['id']! as String,
        orderId: json['order_id']! as String,
        ownerHouseholdId: json['owner_household_id']! as String,
        ownerPersonId: json['owner_person_id']! as String,
        carrierId: json['carrier_id']! as String,
        routeId: json['route_id']! as String,
        pathWaypointIds: (json['path_waypoint_ids']! as List<Object?>)
            .cast<String>(),
        originRoomId: json['origin_room_id']! as String,
        destinationRoomId: json['destination_room_id']! as String,
        destinationItemId: json['destination_item_id']! as String,
        cargo: MarketEscrowLot.fromJson(
          (json['cargo']! as Map).cast<String, Object?>(),
        ),
        departedAtSeconds: json['departed_at_seconds']! as int,
        expectedArrivalSeconds: json['expected_arrival_seconds']! as int,
        scheduledArrivalSeconds: json['scheduled_arrival_seconds']! as int,
        distanceMm: json['distance_mm']! as int,
        lateSeconds: json['late_seconds']! as int,
        plannedConditionLoss: json['planned_condition_loss']! as int,
        status: MarketShipmentStatus.values.byName(json['status']! as String),
        arrivedAtSeconds: json['arrived_at_seconds'] as int?,
        failureReason: json['failure_reason'] as String?,
      );
}

enum SupplyShockStatus { active, resolved }

enum SupplyShockResponseKind { production, service, marketExchange }

/// Phần vật thật mất khả dụng khi cú sốc bắt đầu; giữ nguồn để đối chiếu ledger.
class SupplyDisruptionLot {
  const SupplyDisruptionLot({
    required this.itemId,
    required this.householdId,
    required this.kind,
    required this.quantity,
    required this.unit,
    required this.condition,
  });

  final String itemId;
  final String householdId;
  final String kind;
  final int quantity;
  final String unit;
  final int condition;

  Map<String, Object> toJson() => <String, Object>{
    'item_id': itemId,
    'household_id': householdId,
    'kind': kind,
    'quantity': quantity,
    'unit': unit,
    'condition': condition,
  };

  factory SupplyDisruptionLot.fromJson(Map<String, Object?> json) =>
      SupplyDisruptionLot(
        itemId: json['item_id']! as String,
        householdId: json['household_id']! as String,
        kind: json['kind']! as String,
        quantity: json['quantity']! as int,
        unit: json['unit']! as String,
        condition: json['condition']! as int,
      );
}

/// Một thay đổi sinh kế chỉ được ghi khi có đối tượng mô phỏng thật làm chứng.
class SupplyShockResponse {
  const SupplyShockResponse({
    required this.householdId,
    required this.kind,
    required this.evidenceId,
    required this.recordedAtSeconds,
  });

  final String householdId;
  final SupplyShockResponseKind kind;
  final String evidenceId;
  final int recordedAtSeconds;

  Map<String, Object> toJson() => <String, Object>{
    'household_id': householdId,
    'kind': kind.name,
    'evidence_id': evidenceId,
    'recorded_at_seconds': recordedAtSeconds,
  };

  factory SupplyShockResponse.fromJson(Map<String, Object?> json) =>
      SupplyShockResponse(
        householdId: json['household_id']! as String,
        kind: SupplyShockResponseKind.values.byName(json['kind']! as String),
        evidenceId: json['evidence_id']! as String,
        recordedAtSeconds: json['recorded_at_seconds']! as int,
      );
}

/// Ảnh chụp hằng ngày, tách hàng trong kho khỏi hàng còn đang trên đường.
class SupplyShockHouseholdDay {
  const SupplyShockHouseholdDay({
    required this.day,
    required this.recordedAtSeconds,
    required this.householdId,
    required this.availableQuantity,
    required this.inTransitQuantity,
    required this.responseKinds,
  });

  final int day;
  final int recordedAtSeconds;
  final String householdId;
  final int availableQuantity;
  final int inTransitQuantity;
  final List<SupplyShockResponseKind> responseKinds;

  Map<String, Object> toJson() => <String, Object>{
    'day': day,
    'recorded_at_seconds': recordedAtSeconds,
    'household_id': householdId,
    'available_quantity': availableQuantity,
    'in_transit_quantity': inTransitQuantity,
    'response_kinds': responseKinds
        .map((SupplyShockResponseKind value) => value.name)
        .toList(),
  };

  factory SupplyShockHouseholdDay.fromJson(Map<String, Object?> json) =>
      SupplyShockHouseholdDay(
        day: json['day']! as int,
        recordedAtSeconds: json['recorded_at_seconds']! as int,
        householdId: json['household_id']! as String,
        availableQuantity: json['available_quantity']! as int,
        inTransitQuantity: json['in_transit_quantity']! as int,
        responseKinds: <SupplyShockResponseKind>[
          for (final Object? value in json['response_kinds']! as List<Object?>)
            SupplyShockResponseKind.values.byName(value! as String),
        ],
      );
}

/// Cú sốc hữu hạn theo dõi lượng mất, tồn kho mỗi ngày và phản ứng có bằng chứng.
class SupplyShockState {
  const SupplyShockState({
    required this.id,
    required this.resourceKind,
    required this.unit,
    required this.cause,
    required this.startsAtSeconds,
    required this.endsAtSeconds,
    required this.affectedHouseholdIds,
    required this.disruptedLots,
    required this.status,
    this.responses = const <SupplyShockResponse>[],
    this.householdDays = const <SupplyShockHouseholdDay>[],
    this.resolvedAtSeconds,
  });

  final String id;
  final String resourceKind;
  final String unit;
  final String cause;
  final int startsAtSeconds;
  final int endsAtSeconds;
  final List<String> affectedHouseholdIds;
  final List<SupplyDisruptionLot> disruptedLots;
  final SupplyShockStatus status;
  final List<SupplyShockResponse> responses;
  final List<SupplyShockHouseholdDay> householdDays;
  final int? resolvedAtSeconds;

  SupplyShockState addResponse(SupplyShockResponse response) => _copy(
    responses: <SupplyShockResponse>[...responses, response],
  );

  SupplyShockState recordDays(List<SupplyShockHouseholdDay> values) => _copy(
    householdDays: <SupplyShockHouseholdDay>[...householdDays, ...values],
  );

  SupplyShockState resolve(int atSeconds) => _copy(
    status: SupplyShockStatus.resolved,
    resolvedAtSeconds: atSeconds,
  );

  SupplyShockState _copy({
    List<SupplyShockResponse>? responses,
    List<SupplyShockHouseholdDay>? householdDays,
    SupplyShockStatus? status,
    int? resolvedAtSeconds,
  }) => SupplyShockState(
    id: id,
    resourceKind: resourceKind,
    unit: unit,
    cause: cause,
    startsAtSeconds: startsAtSeconds,
    endsAtSeconds: endsAtSeconds,
    affectedHouseholdIds: affectedHouseholdIds,
    disruptedLots: disruptedLots,
    status: status ?? this.status,
    responses: responses ?? this.responses,
    householdDays: householdDays ?? this.householdDays,
    resolvedAtSeconds: resolvedAtSeconds ?? this.resolvedAtSeconds,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'resource_kind': resourceKind,
    'unit': unit,
    'cause': cause,
    'starts_at_seconds': startsAtSeconds,
    'ends_at_seconds': endsAtSeconds,
    'affected_household_ids': affectedHouseholdIds,
    'disrupted_lots': disruptedLots
        .map((SupplyDisruptionLot value) => value.toJson())
        .toList(),
    'status': status.name,
    'responses': responses
        .map((SupplyShockResponse value) => value.toJson())
        .toList(),
    'household_days': householdDays
        .map((SupplyShockHouseholdDay value) => value.toJson())
        .toList(),
    if (resolvedAtSeconds != null) 'resolved_at_seconds': resolvedAtSeconds,
  };

  factory SupplyShockState.fromJson(Map<String, Object?> json) =>
      SupplyShockState(
        id: json['id']! as String,
        resourceKind: json['resource_kind']! as String,
        unit: json['unit']! as String,
        cause: json['cause']! as String,
        startsAtSeconds: json['starts_at_seconds']! as int,
        endsAtSeconds: json['ends_at_seconds']! as int,
        affectedHouseholdIds:
            (json['affected_household_ids']! as List<Object?>).cast<String>(),
        disruptedLots: <SupplyDisruptionLot>[
          for (final Object? value in json['disrupted_lots']! as List<Object?>)
            SupplyDisruptionLot.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
        status: SupplyShockStatus.values.byName(json['status']! as String),
        responses: <SupplyShockResponse>[
          for (final Object? value
              in (json['responses'] as List<Object?>? ?? const <Object?>[]))
            SupplyShockResponse.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
        householdDays: <SupplyShockHouseholdDay>[
          for (final Object? value in (json['household_days']
                  as List<Object?>? ??
              const <Object?>[]))
            SupplyShockHouseholdDay.fromJson(
              (value! as Map).cast<String, Object?>(),
            ),
        ],
        resolvedAtSeconds: json['resolved_at_seconds'] as int?,
      );
}
