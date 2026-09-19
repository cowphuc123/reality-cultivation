part of 'simulation.dart';

/// Các quy trình sinh kế V6 dùng chung hàng đợi sự kiện và WorldState.
/// Simulation giữ vai trò điều phối; phần này sở hữu sản xuất, dịch vụ, lao
/// động, chợ, vận tải và cú sốc nguồn cung.
extension LivelihoodSimulationOperations on Simulation {
  /// Khởi động một mẻ sản xuất có nguyên liệu, công cụ và thời gian thật.
  ///
  /// Nguyên liệu được rút khỏi kho ngay khi bắt đầu và nằm trong workpiece của
  /// [ProductionBatchState]. Vì vậy hai mẻ không thể cùng tiêu một số lượng.
  bool startProductionBatch({
    required String batchId,
    required ProductionRecipe recipe,
    required String actorId,
    required String householdId,
    required String roomId,
    required Map<String, String> inputItemIdsByKind,
    required String outputItemId,
    String? toolItemId,
  }) {
    recipe.validate();
    if (batchId.isEmpty || outputItemId.isEmpty) {
      throw ArgumentError('Production batch and output IDs cannot be empty.');
    }
    if (_state.productionBatches.containsKey(batchId) ||
        _state.pendingEvents.any(
          (ScheduledEvent event) =>
              event.kind == 'production_batch_completed' &&
              event.payload['batch_id'] == batchId,
        )) {
      return false;
    }
    final HouseholdState? household = _state.households[householdId];
    final PersonState? actor = _state.people[actorId];
    final RoomState? room = _state.rooms[roomId];
    if (household == null ||
        actor?.householdId != householdId ||
        actor?.roomId != roomId ||
        room?.householdId != householdId) {
      throw StateError('Production actor, household and room do not match.');
    }
    if (_competingObligation(actor!) != null) return false;

    final List<ProductionMaterialLot> lots = <ProductionMaterialLot>[];
    final Set<String> usedItemIds = <String>{};
    for (final ProductionIngredient ingredient in recipe.inputs) {
      final String? itemId = inputItemIdsByKind[ingredient.kind];
      final CareItemState? item = itemId == null ? null : _state.items[itemId];
      if (item == null ||
          !usedItemIds.add(item.id) ||
          item.kind != ingredient.kind ||
          item.unit != ingredient.unit ||
          item.quantity < ingredient.quantity ||
          item.ownerHouseholdId != householdId ||
          item.roomId != roomId ||
          !household.canUse(actorId, item.id)) {
        throw StateError(
          'Missing usable production input: ${ingredient.kind}.',
        );
      }
      lots.add(
        ProductionMaterialLot(
          itemId: item.id,
          kind: item.kind,
          quantity: ingredient.quantity,
          unit: item.unit,
          condition: item.condition,
        ),
      );
    }
    if (inputItemIdsByKind.keys
        .toSet()
        .difference(
          recipe.inputs.map((ProductionIngredient value) => value.kind).toSet(),
        )
        .isNotEmpty) {
      throw StateError('Production received an input not required by recipe.');
    }
    CareItemState? tool;
    if (recipe.toolKind != null) {
      tool = toolItemId == null ? null : _state.items[toolItemId];
      if (tool != null &&
          _state.productionBatches.values.any(
            (ProductionBatchState value) =>
                value.status == ProductionBatchStatus.inProgress &&
                value.toolItemId == tool!.id,
          )) {
        return false;
      }
      if (tool == null ||
          usedItemIds.contains(tool.id) ||
          tool.kind != recipe.toolKind ||
          !tool.usable ||
          tool.ownerHouseholdId != householdId ||
          tool.roomId != roomId ||
          !household.canUse(actorId, tool.id)) {
        throw StateError('Missing usable production tool: ${recipe.toolKind}.');
      }
    } else if (toolItemId != null) {
      throw StateError('This production recipe does not use a tool.');
    }
    if (usedItemIds.contains(outputItemId) || outputItemId == toolItemId) {
      throw StateError('Production output needs its own item ledger.');
    }
    final CareItemState? existingOutput = _state.items[outputItemId];
    if (existingOutput != null &&
        (existingOutput.kind != recipe.outputKind ||
            existingOutput.unit != recipe.outputUnit ||
            existingOutput.ownerHouseholdId != householdId ||
            existingOutput.roomId != roomId)) {
      throw StateError('Production output ledger is incompatible.');
    }

    final int completesAt = _state.now.seconds + recipe.durationSeconds;
    final bool committed = _beginPersonalCommitments(
      personIds: <String>[actorId],
      commitmentId: 'production-$batchId',
      kind: 'production',
      activity: recipe.name,
      endsAtSeconds: completesAt,
      relatedId: batchId,
    );
    if (!committed) return false;
    final Map<String, CareItemState> items = <String, CareItemState>{
      ..._state.items,
    };
    for (final ProductionMaterialLot lot in lots) {
      items[lot.itemId] = items[lot.itemId]!.consume(lot.quantity);
    }
    final ProductionBatchState batch = ProductionBatchState(
      id: batchId,
      recipe: recipe,
      actorId: actorId,
      householdId: householdId,
      roomId: roomId,
      outputItemId: outputItemId,
      toolItemId: tool?.id,
      startedAtSeconds: _state.now.seconds,
      completesAtSeconds: completesAt,
      materials: List<ProductionMaterialLot>.unmodifiable(lots),
      status: ProductionBatchStatus.inProgress,
    );
    _replace(
      items: items,
      productionBatches: <String, ProductionBatchState>{
        ..._state.productionBatches,
        batchId: batch,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'production_batch_started',
          batchId,
          'recipe=${recipe.id} actor=$actorId household=$householdId '
              'input_lots=${batch.materials.length} output=$outputItemId '
              'completes_at=$completesAt',
        ),
      ],
    );
    schedule(
      due: SimTime(completesAt),
      phase: EventPhase.completion,
      kind: 'production_batch_completed',
      payload: <String, Object?>{'batch_id': batchId},
    );
    return true;
  }

  /// Đặt một dịch vụ có lịch hai phía và giữ vật tư ngay khi hai bên chốt hẹn.
  bool bookServiceAppointment({
    required String appointmentId,
    required ServiceDefinition definition,
    required String providerId,
    required String recipientId,
    required String providerHouseholdId,
    required String recipientHouseholdId,
    required String roomId,
    required int startsAtSeconds,
    Map<String, String> inputItemIdsByKind = const <String, String>{},
  }) {
    definition.validate();
    if (appointmentId.isEmpty || providerId == recipientId) {
      throw ArgumentError('Service needs an ID and two distinct people.');
    }
    if (_state.serviceAppointments.containsKey(appointmentId)) return false;
    final int endsAtSeconds = startsAtSeconds + definition.durationSeconds;
    if (startsAtSeconds < _state.now.seconds) {
      throw StateError('A service cannot be booked in the past.');
    }
    final PersonState? provider = _state.people[providerId];
    final PersonState? recipient = _state.people[recipientId];
    final HouseholdState? providerHousehold =
        _state.households[providerHouseholdId];
    final RoomState? room = _state.rooms[roomId];
    if (provider?.householdId != providerHouseholdId ||
        recipient?.householdId != recipientHouseholdId ||
        providerHousehold == null ||
        room?.householdId != providerHouseholdId ||
        provider?.roomId != roomId ||
        recipient?.roomId != roomId) {
      throw StateError('Service people, households and venue do not match.');
    }
    for (final String personId in <String>[providerId, recipientId]) {
      final PersonState person = _state.people[personId]!;
      final PersonalTimeCommitment? commitment = person.timeCommitment;
      if ((commitment != null &&
              startsAtSeconds < commitment.endsAtSeconds &&
              endsAtSeconds > commitment.startedAtSeconds) ||
          _state.serviceAppointments.values.any(
            (ServiceAppointmentState value) =>
                value.reservesPerson(personId, startsAtSeconds, endsAtSeconds),
          ) ||
          _state.laborOffers.values.any(
            (LaborOfferState value) =>
                value.reservesWorker(personId, startsAtSeconds, endsAtSeconds),
          )) {
        return false;
      }
    }

    final List<ProductionMaterialLot> materials = <ProductionMaterialLot>[];
    final Set<String> usedItemIds = <String>{};
    for (final ProductionIngredient ingredient in definition.inputs) {
      final String? itemId = inputItemIdsByKind[ingredient.kind];
      final CareItemState? item = itemId == null ? null : _state.items[itemId];
      if (item == null ||
          !usedItemIds.add(item.id) ||
          item.kind != ingredient.kind ||
          item.unit != ingredient.unit ||
          item.quantity < ingredient.quantity ||
          item.ownerHouseholdId != providerHouseholdId ||
          item.roomId != roomId ||
          !providerHousehold.canUse(providerId, item.id)) {
        throw StateError('Missing usable service input: ${ingredient.kind}.');
      }
      materials.add(
        ProductionMaterialLot(
          itemId: item.id,
          kind: item.kind,
          quantity: ingredient.quantity,
          unit: item.unit,
          condition: item.condition,
        ),
      );
    }
    if (inputItemIdsByKind.keys
        .toSet()
        .difference(
          definition.inputs
              .map((ProductionIngredient value) => value.kind)
              .toSet(),
        )
        .isNotEmpty) {
      throw StateError('Service received an input it does not require.');
    }
    final Map<String, CareItemState> items = <String, CareItemState>{
      ..._state.items,
    };
    for (final ProductionMaterialLot material in materials) {
      items[material.itemId] = items[material.itemId]!.consume(
        material.quantity,
      );
    }
    final ServiceAppointmentState appointment = ServiceAppointmentState(
      id: appointmentId,
      definition: definition,
      providerId: providerId,
      recipientId: recipientId,
      providerHouseholdId: providerHouseholdId,
      recipientHouseholdId: recipientHouseholdId,
      roomId: roomId,
      startsAtSeconds: startsAtSeconds,
      endsAtSeconds: endsAtSeconds,
      materials: List<ProductionMaterialLot>.unmodifiable(materials),
      status: ServiceAppointmentStatus.booked,
    );
    _replace(
      items: items,
      serviceAppointments: <String, ServiceAppointmentState>{
        ..._state.serviceAppointments,
        appointmentId: appointment,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'service_appointment_booked',
          appointmentId,
          'service=${definition.id} provider=$providerId '
              'recipient=$recipientId starts_at=$startsAtSeconds '
              'ends_at=$endsAtSeconds input_lots=${materials.length}',
        ),
      ],
    );
    schedule(
      due: SimTime(startsAtSeconds),
      phase: EventPhase.completion,
      kind: 'service_appointment_started',
      payload: <String, Object?>{'appointment_id': appointmentId},
    );
    return true;
  }

  /// Ghi một lời mời lao động có điều kiện và quyền lợi hiện vật đã định trước.
  bool createLaborOffer({
    required String offerId,
    required String activity,
    required String skillCode,
    required int minimumSkill,
    required int priority,
    required String employerId,
    required String workerId,
    required String employerHouseholdId,
    required String workerHouseholdId,
    required String roomId,
    required int startsAtSeconds,
    required int durationSeconds,
    required LaborCompensationTerms compensation,
  }) {
    compensation.validate();
    if (offerId.isEmpty ||
        activity.isEmpty ||
        skillCode.isEmpty ||
        employerId == workerId ||
        minimumSkill < 0 ||
        minimumSkill > 1000 ||
        priority < 0 ||
        priority > 1000 ||
        durationSeconds <= 0 ||
        startsAtSeconds < _state.now.seconds) {
      throw ArgumentError('Labor offer terms are invalid.');
    }
    if (_state.laborOffers.containsKey(offerId)) return false;
    final PersonState? employer = _state.people[employerId];
    final PersonState? worker = _state.people[workerId];
    final RoomState? room = _state.rooms[roomId];
    if (employer?.householdId != employerHouseholdId ||
        worker?.householdId != workerHouseholdId ||
        room?.householdId != employerHouseholdId ||
        !_state.households.containsKey(employerHouseholdId) ||
        !_state.households.containsKey(workerHouseholdId)) {
      throw StateError(
        'Labor offer people, households and venue do not match.',
      );
    }
    final LaborOfferState offer = LaborOfferState(
      id: offerId,
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
      endsAtSeconds: startsAtSeconds + durationSeconds,
      compensation: compensation,
      status: LaborOfferStatus.offered,
    );
    _replace(
      laborOffers: <String, LaborOfferState>{
        ..._state.laborOffers,
        offerId: offer,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'labor_offer_created',
          offerId,
          'employer=$employerId worker=$workerId activity=$activity '
              'skill=$skillCode minimum_skill=$minimumSkill '
              'priority=$priority starts_at=$startsAtSeconds '
              'ends_at=${offer.endsAtSeconds} '
              'compensation_kind=${compensation.itemKind} '
              'compensation_quantity=${compensation.quantity} '
              'compensation_unit=${compensation.unit}',
        ),
      ],
    );
    return true;
  }

  /// Để người được mời tự cân nhắc theo kỹ năng, trạng thái và lịch thật.
  bool considerLaborOffer(String offerId) {
    final LaborOfferState? offer = _state.laborOffers[offerId];
    if (offer == null || offer.status != LaborOfferStatus.offered) return false;
    final PersonState worker = _state.people[offer.workerId]!;
    final int skill = worker.skills?.level(offer.skillCode) ?? 0;
    String? refusalReason;
    if (skill < offer.minimumSkill) {
      refusalReason = 'insufficient_skill';
    } else {
      final PersonalTimeCommitment? commitment = worker.timeCommitment;
      final bool commitmentOverlap =
          commitment != null &&
          offer.startsAtSeconds < commitment.endsAtSeconds &&
          offer.endsAtSeconds > commitment.startedAtSeconds;
      final bool serviceOverlap = _state.serviceAppointments.values.any(
        (ServiceAppointmentState value) => value.reservesPerson(
          offer.workerId,
          offer.startsAtSeconds,
          offer.endsAtSeconds,
        ),
      );
      final bool laborOverlap = _state.laborOffers.values.any(
        (LaborOfferState value) =>
            value.id != offer.id &&
            value.reservesWorker(
              offer.workerId,
              offer.startsAtSeconds,
              offer.endsAtSeconds,
            ),
      );
      if (commitmentOverlap || serviceOverlap || laborOverlap) {
        refusalReason = 'schedule_conflict';
      } else if (worker.agenda != null &&
          !worker.agenda!.accepts(offer.priority)) {
        refusalReason = 'worker_strain';
      } else if (_competingObligation(worker) != null &&
          offer.startsAtSeconds == _state.now.seconds) {
        refusalReason = 'currently_unavailable';
      }
    }
    final bool accepted = refusalReason == null;
    final LaborOfferState decided = accepted
        ? offer.accept('conditions_met')
        : offer.refuse(refusalReason);
    final PersonState decidedWorker = worker.agenda == null
        ? worker
        : worker.withAgenda(
            worker.agenda!.recordOffer(
              accepted: accepted,
              reason: refusalReason,
            ),
          );
    _replace(
      people: <String, PersonState>{..._state.people, worker.id: decidedWorker},
      laborOffers: <String, LaborOfferState>{
        ..._state.laborOffers,
        offer.id: decided,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          accepted ? 'labor_offer_accepted' : 'labor_offer_refused',
          offer.id,
          'worker=${offer.workerId} employer=${offer.employerId} '
          'skill=${offer.skillCode} level=$skill '
          'minimum_skill=${offer.minimumSkill} priority=${offer.priority} '
          'reason=${accepted ? 'conditions_met' : refusalReason}',
        ),
      ],
    );
    if (accepted) {
      schedule(
        due: SimTime(offer.startsAtSeconds),
        phase: EventPhase.completion,
        kind: 'labor_work_started',
        payload: <String, Object?>{'offer_id': offer.id},
      );
    }
    return accepted;
  }

  /// Chuyển hiện vật để tất toán claim; thiếu hàng giữ nguyên khoản phải trả.
  bool settleLaborCompensation({
    required String claimId,
    required String sourceItemId,
    required String targetItemId,
  }) {
    final LaborCompensationClaim? claim = _state.laborClaims[claimId];
    if (claim == null || claim.status != LaborClaimStatus.outstanding) {
      return false;
    }
    final LaborOfferState offer = _state.laborOffers[claim.offerId]!;
    final CareItemState? source = _state.items[sourceItemId];
    final CareItemState? existingTarget = _state.items[targetItemId];
    final HouseholdState debtor = _state.households[claim.debtorHouseholdId]!;
    final PersonState creditor = _state.people[claim.creditorPersonId]!;
    final bool sourceValid =
        sourceItemId != targetItemId &&
        source != null &&
        source.kind == claim.terms.itemKind &&
        source.unit == claim.terms.unit &&
        source.quantity >= claim.terms.quantity &&
        source.ownerHouseholdId == claim.debtorHouseholdId &&
        source.roomId == creditor.roomId &&
        debtor.canUse(offer.employerId, source.id);
    final bool targetValid =
        existingTarget == null ||
        (existingTarget.kind == claim.terms.itemKind &&
            existingTarget.unit == claim.terms.unit &&
            existingTarget.ownerHouseholdId == claim.creditorHouseholdId &&
            existingTarget.roomId == creditor.roomId);
    if (!sourceValid || !targetValid) {
      _replace(
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'labor_payment_failed',
            claimId,
            'offer=${claim.offerId} source=$sourceItemId '
                'quantity=${claim.terms.quantity} unit=${claim.terms.unit}',
          ),
        ],
      );
      return false;
    }
    final CareItemState paymentSource = source;
    final CareItemState payment = existingTarget == null
        ? CareItemState(
            id: targetItemId,
            kind: paymentSource.kind,
            positionMm: paymentSource.positionMm,
            positionYMm: paymentSource.positionYMm,
            quantity: claim.terms.quantity,
            condition: paymentSource.condition,
            unit: paymentSource.unit,
            ownerHouseholdId: claim.creditorHouseholdId,
            roomId: paymentSource.roomId,
          )
        : CareItemState(
            id: existingTarget.id,
            kind: existingTarget.kind,
            positionMm: existingTarget.positionMm,
            positionYMm: existingTarget.positionYMm,
            quantity: existingTarget.quantity + claim.terms.quantity,
            condition:
                (existingTarget.condition * existingTarget.quantity +
                    paymentSource.condition * claim.terms.quantity) ~/
                (existingTarget.quantity + claim.terms.quantity),
            energyKjPer100Ml: existingTarget.energyKjPer100Ml,
            waterMlPer100Ml: existingTarget.waterMlPer100Ml,
            unit: existingTarget.unit,
            ownerHouseholdId: existingTarget.ownerHouseholdId,
            roomId: existingTarget.roomId,
          );
    final HouseholdState creditorHousehold = _state
        .households[claim.creditorHouseholdId]!
        .authorizeItem(targetItemId, <String>[claim.creditorPersonId]);
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        paymentSource.id: paymentSource.consume(claim.terms.quantity),
        targetItemId: payment,
      },
      households: <String, HouseholdState>{
        ..._state.households,
        creditorHousehold.id: creditorHousehold,
      },
      laborClaims: <String, LaborCompensationClaim>{
        ..._state.laborClaims,
        claimId: claim.settle(
          atSeconds: _state.now.seconds,
          sourceItemId: sourceItemId,
          targetItemId: targetItemId,
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'labor_payment_settled',
          claimId,
          'offer=${claim.offerId} source=$sourceItemId target=$targetItemId '
              'kind=${claim.terms.itemKind} quantity=${claim.terms.quantity} '
              'unit=${claim.terms.unit}',
        ),
      ],
    );
    return true;
  }

  void _applyProductionBatchCompleted(ScheduledEvent event) {
    final String batchId = event.payload['batch_id']! as String;
    final ProductionBatchState? batch = _state.productionBatches[batchId];
    if (batch == null || batch.status != ProductionBatchStatus.inProgress) {
      return;
    }
    final PersonState? actor = _state.people[batch.actorId];
    final RoomState? room = _state.rooms[batch.roomId];
    final CareItemState? tool = batch.toolItemId == null
        ? null
        : _state.items[batch.toolItemId];
    final CareItemState? existingOutput = _state.items[batch.outputItemId];
    String? blockedReason;
    if (actor?.timeCommitment?.id != 'production-$batchId') {
      blockedReason = 'labor_commitment_missing';
    } else if (actor?.roomId != batch.roomId ||
        room?.householdId != batch.householdId) {
      blockedReason = 'actor_left_workplace';
    } else if (batch.recipe.toolKind != null &&
        (tool == null ||
            tool.kind != batch.recipe.toolKind ||
            !tool.usable ||
            tool.ownerHouseholdId != batch.householdId ||
            tool.roomId != batch.roomId)) {
      blockedReason = 'tool_unavailable';
    } else if (existingOutput != null &&
        (existingOutput.kind != batch.recipe.outputKind ||
            existingOutput.unit != batch.recipe.outputUnit ||
            existingOutput.ownerHouseholdId != batch.householdId ||
            existingOutput.roomId != batch.roomId)) {
      blockedReason = 'output_ledger_changed';
    }

    _endPersonalCommitments(<String>[batch.actorId], 'production-$batchId');
    if (blockedReason != null) {
      _replace(
        productionBatches: <String, ProductionBatchState>{
          ..._state.productionBatches,
          batchId: batch.block(_state.now.seconds, blockedReason),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'production_batch_blocked',
            batchId,
            'recipe=${batch.recipe.id} reason=$blockedReason '
                'inputs_held=${batch.materials.length}',
          ),
        ],
      );
      return;
    }

    final RoomState workplace = room!;
    final int materialQuality =
        batch.materials.fold<int>(
          0,
          (int total, ProductionMaterialLot lot) => total + lot.condition,
        ) ~/
        batch.materials.length;
    final int batchQuality = tool == null
        ? materialQuality
        : (materialQuality * 3 + tool.condition) ~/ 4;
    final CareItemState output = existingOutput == null
        ? CareItemState(
            id: batch.outputItemId,
            kind: batch.recipe.outputKind,
            positionMm: workplace.anchorPositionMm,
            positionYMm: workplace.anchorPositionYMm,
            quantity: batch.recipe.outputQuantity,
            condition: batchQuality,
            unit: batch.recipe.outputUnit,
            ownerHouseholdId: batch.householdId,
            roomId: batch.roomId,
          )
        : CareItemState(
            id: existingOutput.id,
            kind: existingOutput.kind,
            positionMm: existingOutput.positionMm,
            positionYMm: existingOutput.positionYMm,
            quantity: existingOutput.quantity + batch.recipe.outputQuantity,
            condition:
                (existingOutput.condition * existingOutput.quantity +
                    batchQuality * batch.recipe.outputQuantity) ~/
                (existingOutput.quantity + batch.recipe.outputQuantity),
            energyKjPer100Ml: existingOutput.energyKjPer100Ml,
            waterMlPer100Ml: existingOutput.waterMlPer100Ml,
            unit: existingOutput.unit,
            ownerHouseholdId: existingOutput.ownerHouseholdId,
            roomId: existingOutput.roomId,
          );
    final Map<String, CareItemState> items = <String, CareItemState>{
      ..._state.items,
      batch.outputItemId: output,
      if (tool != null) tool.id: tool.wear(batch.recipe.toolWear),
    };
    final HouseholdState household = _state.households[batch.householdId]!
        .authorizeItem(batch.outputItemId, <String>[batch.actorId]);
    _replace(
      items: items,
      households: <String, HouseholdState>{
        ..._state.households,
        household.id: household.recordProduction(),
      },
      productionBatches: <String, ProductionBatchState>{
        ..._state.productionBatches,
        batchId: batch.complete(_state.now.seconds),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'production_batch_completed',
          batchId,
          'recipe=${batch.recipe.id} actor=${batch.actorId} '
              'output=${batch.outputItemId} '
              'quantity=${batch.recipe.outputQuantity} '
              'unit=${batch.recipe.outputUnit} quality=$batchQuality '
              'tool_wear=${batch.recipe.toolWear}',
        ),
      ],
    );
  }

  void _applyServiceAppointmentStarted(ScheduledEvent event) {
    final String appointmentId = event.payload['appointment_id']! as String;
    final ServiceAppointmentState? appointment =
        _state.serviceAppointments[appointmentId];
    if (appointment == null ||
        appointment.status != ServiceAppointmentStatus.booked) {
      return;
    }
    final PersonState? provider = _state.people[appointment.providerId];
    final PersonState? recipient = _state.people[appointment.recipientId];
    String? blockedReason;
    if (provider?.roomId != appointment.roomId) {
      blockedReason = 'provider_absent';
    } else if (recipient?.roomId != appointment.roomId) {
      blockedReason = 'recipient_absent';
    } else {
      final bool begun = _beginPersonalCommitments(
        personIds: <String>[appointment.providerId, appointment.recipientId],
        commitmentId: 'service-$appointmentId',
        kind: 'service',
        activity: appointment.definition.name,
        endsAtSeconds: appointment.endsAtSeconds,
        relatedId: appointmentId,
        serviceReservationId: appointmentId,
      );
      if (!begun) blockedReason = 'participant_unavailable';
    }
    if (blockedReason != null) {
      _replace(
        serviceAppointments: <String, ServiceAppointmentState>{
          ..._state.serviceAppointments,
          appointmentId: appointment.block(blockedReason),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'service_appointment_blocked',
            appointmentId,
            'service=${appointment.definition.id} reason=$blockedReason '
                'inputs_held=${appointment.materials.length}',
          ),
        ],
      );
      return;
    }
    _replace(
      serviceAppointments: <String, ServiceAppointmentState>{
        ..._state.serviceAppointments,
        appointmentId: appointment.begin(),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'service_appointment_started',
          appointmentId,
          'service=${appointment.definition.id} '
              'provider=${appointment.providerId} '
              'recipient=${appointment.recipientId} '
              'ends_at=${appointment.endsAtSeconds}',
        ),
      ],
    );
    schedule(
      due: SimTime(appointment.endsAtSeconds),
      phase: EventPhase.completion,
      kind: 'service_appointment_completed',
      payload: <String, Object?>{'appointment_id': appointmentId},
    );
  }

  void _applyServiceAppointmentCompleted(ScheduledEvent event) {
    final String appointmentId = event.payload['appointment_id']! as String;
    final ServiceAppointmentState? appointment =
        _state.serviceAppointments[appointmentId];
    if (appointment == null ||
        appointment.status != ServiceAppointmentStatus.inProgress) {
      return;
    }
    final String commitmentId = 'service-$appointmentId';
    final PersonState? provider = _state.people[appointment.providerId];
    final PersonState? recipient = _state.people[appointment.recipientId];
    String? blockedReason;
    if (provider?.timeCommitment?.id != commitmentId) {
      blockedReason = 'provider_commitment_missing';
    } else if (recipient?.timeCommitment?.id != commitmentId) {
      blockedReason = 'recipient_commitment_missing';
    } else if (provider?.roomId != appointment.roomId) {
      blockedReason = 'provider_left_venue';
    } else if (recipient?.roomId != appointment.roomId) {
      blockedReason = 'recipient_left_venue';
    }
    _endPersonalCommitments(<String>[
      appointment.providerId,
      appointment.recipientId,
    ], commitmentId);
    if (blockedReason != null) {
      _replace(
        serviceAppointments: <String, ServiceAppointmentState>{
          ..._state.serviceAppointments,
          appointmentId: appointment.block(blockedReason),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'service_appointment_blocked',
            appointmentId,
            'service=${appointment.definition.id} reason=$blockedReason '
                'inputs_consumed=${appointment.materials.length}',
          ),
        ],
      );
      return;
    }
    final ServiceResultClaim claim = ServiceResultClaim(
      id: 'service-claim-$appointmentId',
      kind: appointment.definition.resultClaimKind,
      appointmentId: appointmentId,
      providerId: appointment.providerId,
      recipientId: appointment.recipientId,
      createdAtSeconds: _state.now.seconds,
    );
    _replace(
      serviceAppointments: <String, ServiceAppointmentState>{
        ..._state.serviceAppointments,
        appointmentId: appointment.complete(claim),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'service_appointment_completed',
          appointmentId,
          'service=${appointment.definition.id} '
              'provider=${appointment.providerId} '
              'recipient=${appointment.recipientId} claim=${claim.id} '
              'claim_kind=${claim.kind}',
        ),
      ],
    );
  }

  void _applyLaborWorkStarted(ScheduledEvent event) {
    final String offerId = event.payload['offer_id']! as String;
    final LaborOfferState? offer = _state.laborOffers[offerId];
    if (offer == null || offer.status != LaborOfferStatus.accepted) return;
    final PersonState? worker = _state.people[offer.workerId];
    String? blockedReason;
    if (worker?.roomId != offer.roomId) {
      blockedReason = 'worker_absent';
    } else {
      final bool begun = _beginPersonalCommitments(
        personIds: <String>[offer.workerId],
        commitmentId: 'labor-$offerId',
        kind: 'labor',
        activity: offer.activity,
        endsAtSeconds: offer.endsAtSeconds,
        relatedId: offerId,
        laborReservationId: offerId,
      );
      if (!begun) blockedReason = 'worker_unavailable';
    }
    if (blockedReason != null) {
      _replace(
        laborOffers: <String, LaborOfferState>{
          ..._state.laborOffers,
          offerId: offer.block(_state.now.seconds, blockedReason),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'labor_work_blocked',
            offerId,
            'worker=${offer.workerId} reason=$blockedReason claim=none',
          ),
        ],
      );
      return;
    }
    _replace(
      laborOffers: <String, LaborOfferState>{
        ..._state.laborOffers,
        offerId: offer.begin(),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'labor_work_started',
          offerId,
          'worker=${offer.workerId} activity=${offer.activity} '
              'ends_at=${offer.endsAtSeconds}',
        ),
      ],
    );
    schedule(
      due: SimTime(offer.endsAtSeconds),
      phase: EventPhase.completion,
      kind: 'labor_work_completed',
      payload: <String, Object?>{'offer_id': offerId},
    );
  }

  void _applyLaborWorkCompleted(ScheduledEvent event) {
    final String offerId = event.payload['offer_id']! as String;
    final LaborOfferState? offer = _state.laborOffers[offerId];
    if (offer == null || offer.status != LaborOfferStatus.inProgress) return;
    final String commitmentId = 'labor-$offerId';
    final PersonState? worker = _state.people[offer.workerId];
    String? blockedReason;
    if (worker?.timeCommitment?.id != commitmentId) {
      blockedReason = 'labor_commitment_missing';
    } else if (worker?.roomId != offer.roomId) {
      blockedReason = 'worker_left_venue';
    }
    _endPersonalCommitments(<String>[offer.workerId], commitmentId);
    if (blockedReason != null) {
      _replace(
        laborOffers: <String, LaborOfferState>{
          ..._state.laborOffers,
          offerId: offer.block(_state.now.seconds, blockedReason),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'labor_work_blocked',
            offerId,
            'worker=${offer.workerId} reason=$blockedReason claim=none',
          ),
        ],
      );
      return;
    }
    final String claimId = 'labor-claim-$offerId';
    final LaborCompensationClaim claim = LaborCompensationClaim(
      id: claimId,
      offerId: offerId,
      debtorHouseholdId: offer.employerHouseholdId,
      creditorHouseholdId: offer.workerHouseholdId,
      creditorPersonId: offer.workerId,
      terms: offer.compensation,
      createdAtSeconds: _state.now.seconds,
      status: LaborClaimStatus.outstanding,
    );
    _replace(
      laborOffers: <String, LaborOfferState>{
        ..._state.laborOffers,
        offerId: offer.complete(_state.now.seconds, claimId),
      },
      laborClaims: <String, LaborCompensationClaim>{
        ..._state.laborClaims,
        claimId: claim,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'labor_work_completed',
          offerId,
          'worker=${offer.workerId} activity=${offer.activity} '
              'claim=$claimId compensation_kind=${offer.compensation.itemKind} '
              'compensation_quantity=${offer.compensation.quantity} '
              'compensation_unit=${offer.compensation.unit}',
        ),
      ],
    );
  }

  /// Đăng một lượng hàng thật và rút nó khỏi kho thường vào escrow của chợ.
  bool publishMarketOffer({
    required String offerId,
    required String sellerPersonId,
    required String sellerHouseholdId,
    required String roomId,
    required String sourceItemId,
    required int offeredQuantity,
    required int lotQuantity,
    required String paymentKind,
    required int paymentQuantityPerLot,
    required String paymentUnit,
    required Iterable<String> visibleToPersonIds,
  }) {
    if (offerId.isEmpty ||
        paymentKind.isEmpty ||
        paymentUnit.isEmpty ||
        offeredQuantity <= 0 ||
        lotQuantity <= 0 ||
        offeredQuantity % lotQuantity != 0 ||
        paymentQuantityPerLot <= 0) {
      throw ArgumentError('Market offer terms are invalid.');
    }
    if (_state.marketOffers.containsKey(offerId)) return false;
    final PersonState? seller = _state.people[sellerPersonId];
    final HouseholdState? household = _state.households[sellerHouseholdId];
    final CareItemState? source = _state.items[sourceItemId];
    if (seller?.householdId != sellerHouseholdId ||
        seller?.roomId != roomId ||
        household == null ||
        source == null ||
        source.ownerHouseholdId != sellerHouseholdId ||
        source.roomId != roomId ||
        source.quantity < offeredQuantity ||
        !household.canUse(sellerPersonId, sourceItemId)) {
      throw StateError('Market seller cannot reserve the offered stock.');
    }
    final List<String> knownBy = <String>{
      sellerPersonId,
      ...visibleToPersonIds,
    }.toList()..sort();
    if (knownBy.any((String id) => _state.people[id]?.roomId != roomId)) {
      throw StateError('A market offer can only be observed at its venue.');
    }
    final MarketEscrowLot merchandise = MarketEscrowLot(
      sourceItemId: source.id,
      kind: source.kind,
      quantity: offeredQuantity,
      condition: source.condition,
      unit: source.unit,
      energyKjPer100Ml: source.energyKjPer100Ml,
      waterMlPer100Ml: source.waterMlPer100Ml,
    );
    final MarketOfferState offer = MarketOfferState(
      id: offerId,
      sellerPersonId: sellerPersonId,
      sellerHouseholdId: sellerHouseholdId,
      roomId: roomId,
      offeredQuantity: offeredQuantity,
      lotQuantity: lotQuantity,
      paymentKind: paymentKind,
      paymentQuantityPerLot: paymentQuantityPerLot,
      paymentUnit: paymentUnit,
      merchandise: merchandise,
      knownByPersonIds: knownBy,
      createdAtSeconds: _state.now.seconds,
      status: MarketOfferStatus.open,
    );
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        source.id: source.consume(offeredQuantity),
      },
      marketOffers: <String, MarketOfferState>{
        ..._state.marketOffers,
        offerId: offer,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'market_offer_published',
          offerId,
          'seller=$sellerPersonId household=$sellerHouseholdId room=$roomId '
              'kind=${source.kind} quantity=$offeredQuantity unit=${source.unit} '
              'lot=$lotQuantity payment_kind=$paymentKind '
              'payment_quantity=$paymentQuantityPerLot '
              'payment_unit=$paymentUnit known_by=${knownBy.join(',')}',
        ),
      ],
    );
    return true;
  }

  /// Giữ đồng thời phần hàng đặt mua và vật thanh toán của người mua.
  bool placeMarketOrder({
    required String orderId,
    required String offerId,
    required String buyerPersonId,
    required String buyerHouseholdId,
    required String paymentSourceItemId,
    required int merchandiseQuantity,
  }) {
    if (orderId.isEmpty || merchandiseQuantity <= 0) {
      throw ArgumentError('Market order terms are invalid.');
    }
    if (_state.marketOrders.containsKey(orderId)) return false;
    final MarketOfferState? offer = _state.marketOffers[offerId];
    if (offer == null || offer.status != MarketOfferStatus.open) return false;
    final PersonState? buyer = _state.people[buyerPersonId];
    final HouseholdState? household = _state.households[buyerHouseholdId];
    if (buyer?.householdId != buyerHouseholdId ||
        buyer?.roomId != offer.roomId ||
        household == null ||
        buyerHouseholdId == offer.sellerHouseholdId ||
        !offer.isKnownBy(buyerPersonId) ||
        merchandiseQuantity % offer.lotQuantity != 0 ||
        merchandiseQuantity > offer.merchandise.quantity) {
      return false;
    }
    final int paymentQuantity = offer.paymentFor(merchandiseQuantity);
    final CareItemState? paymentSource = _state.items[paymentSourceItemId];
    if (paymentSource == null ||
        paymentSource.kind != offer.paymentKind ||
        paymentSource.unit != offer.paymentUnit ||
        paymentSource.quantity < paymentQuantity ||
        paymentSource.ownerHouseholdId != buyerHouseholdId ||
        paymentSource.roomId != offer.roomId ||
        !household.canUse(buyerPersonId, paymentSource.id)) {
      return false;
    }
    final MarketOrderState order = MarketOrderState(
      id: orderId,
      offerId: offerId,
      sellerPersonId: offer.sellerPersonId,
      sellerHouseholdId: offer.sellerHouseholdId,
      buyerPersonId: buyerPersonId,
      buyerHouseholdId: buyerHouseholdId,
      roomId: offer.roomId,
      merchandise: offer.merchandise.withQuantity(merchandiseQuantity),
      payment: MarketEscrowLot(
        sourceItemId: paymentSource.id,
        kind: paymentSource.kind,
        quantity: paymentQuantity,
        condition: paymentSource.condition,
        unit: paymentSource.unit,
        energyKjPer100Ml: paymentSource.energyKjPer100Ml,
        waterMlPer100Ml: paymentSource.waterMlPer100Ml,
      ),
      createdAtSeconds: _state.now.seconds,
      status: MarketOrderStatus.reserved,
    );
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        paymentSource.id: paymentSource.consume(paymentQuantity),
      },
      marketOffers: <String, MarketOfferState>{
        ..._state.marketOffers,
        offerId: offer.reserve(merchandiseQuantity),
      },
      marketOrders: <String, MarketOrderState>{
        ..._state.marketOrders,
        orderId: order,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'market_order_reserved',
          orderId,
          'offer=$offerId buyer=$buyerPersonId '
              'merchandise_kind=${order.merchandise.kind} '
              'merchandise_quantity=${order.merchandise.quantity} '
              'merchandise_unit=${order.merchandise.unit} '
              'payment_kind=${order.payment.kind} '
              'payment_quantity=${order.payment.quantity} '
              'payment_unit=${order.payment.unit}',
        ),
      ],
    );
    return true;
  }

  /// Hoàn tất đổi chủ hai escrow tại chợ; target sai giữ nguyên đơn đã reserve.
  bool settleMarketOrder({
    required String orderId,
    required String buyerTargetItemId,
    required String sellerTargetItemId,
  }) {
    final MarketOrderState? order = _state.marketOrders[orderId];
    if (order == null || order.status != MarketOrderStatus.reserved) {
      return false;
    }
    final PersonState? seller = _state.people[order.sellerPersonId];
    final PersonState? buyer = _state.people[order.buyerPersonId];
    if (buyerTargetItemId.isEmpty ||
        sellerTargetItemId.isEmpty ||
        buyerTargetItemId == sellerTargetItemId ||
        seller?.roomId != order.roomId ||
        buyer?.roomId != order.roomId ||
        seller?.positionMm == null ||
        buyer?.positionMm == null) {
      return false;
    }
    final CareItemState? buyerTarget = _state.items[buyerTargetItemId];
    final CareItemState? sellerTarget = _state.items[sellerTargetItemId];
    bool compatible(
      CareItemState? target,
      MarketEscrowLot lot,
      String householdId,
    ) =>
        target == null ||
        (target.kind == lot.kind &&
            target.unit == lot.unit &&
            target.ownerHouseholdId == householdId &&
            target.roomId == order.roomId);
    if (!compatible(buyerTarget, order.merchandise, order.buyerHouseholdId) ||
        !compatible(sellerTarget, order.payment, order.sellerHouseholdId)) {
      return false;
    }
    CareItemState deposit(
      CareItemState? target,
      String targetId,
      MarketEscrowLot lot,
      String householdId,
      PersonState owner,
    ) {
      if (target == null) {
        return CareItemState(
          id: targetId,
          kind: lot.kind,
          positionMm: owner.positionMm!,
          positionYMm: owner.positionYMm,
          quantity: lot.quantity,
          condition: lot.condition,
          energyKjPer100Ml: lot.energyKjPer100Ml,
          waterMlPer100Ml: lot.waterMlPer100Ml,
          unit: lot.unit,
          ownerHouseholdId: householdId,
          roomId: order.roomId,
        );
      }
      final int combinedQuantity = target.quantity + lot.quantity;
      return CareItemState(
        id: target.id,
        kind: target.kind,
        positionMm: target.positionMm,
        positionYMm: target.positionYMm,
        quantity: combinedQuantity,
        condition:
            (target.condition * target.quantity +
                lot.condition * lot.quantity) ~/
            combinedQuantity,
        energyKjPer100Ml:
            (target.energyKjPer100Ml * target.quantity +
                lot.energyKjPer100Ml * lot.quantity) ~/
            combinedQuantity,
        waterMlPer100Ml:
            (target.waterMlPer100Ml * target.quantity +
                lot.waterMlPer100Ml * lot.quantity) ~/
            combinedQuantity,
        unit: target.unit,
        ownerHouseholdId: target.ownerHouseholdId,
        roomId: target.roomId,
      );
    }

    final CareItemState purchased = deposit(
      buyerTarget,
      buyerTargetItemId,
      order.merchandise,
      order.buyerHouseholdId,
      buyer!,
    );
    final CareItemState proceeds = deposit(
      sellerTarget,
      sellerTargetItemId,
      order.payment,
      order.sellerHouseholdId,
      seller!,
    );
    final HouseholdState buyerHousehold = _state
        .households[order.buyerHouseholdId]!
        .authorizeItem(buyerTargetItemId, <String>[order.buyerPersonId]);
    final HouseholdState sellerHousehold = _state
        .households[order.sellerHouseholdId]!
        .authorizeItem(sellerTargetItemId, <String>[order.sellerPersonId]);
    _replace(
      items: <String, CareItemState>{
        ..._state.items,
        buyerTargetItemId: purchased,
        sellerTargetItemId: proceeds,
      },
      households: <String, HouseholdState>{
        ..._state.households,
        buyerHousehold.id: buyerHousehold,
        sellerHousehold.id: sellerHousehold,
      },
      marketOrders: <String, MarketOrderState>{
        ..._state.marketOrders,
        orderId: order.settle(
          atSeconds: _state.now.seconds,
          buyerTargetItemId: buyerTargetItemId,
          sellerTargetItemId: sellerTargetItemId,
        ),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'market_order_settled',
          orderId,
          'offer=${order.offerId} buyer=${order.buyerPersonId} '
              'seller=${order.sellerPersonId} '
              'merchandise_kind=${order.merchandise.kind} '
              'merchandise_quantity=${order.merchandise.quantity} '
              'payment_kind=${order.payment.kind} '
              'payment_quantity=${order.payment.quantity}',
        ),
      ],
    );
    return true;
  }

  /// Đưa toàn bộ hàng mua của một order đã settlement lên tuyến thật.
  bool dispatchMarketShipment({
    required String shipmentId,
    required String orderId,
    required String carrierId,
    required String routeId,
    required String fromWaypointId,
    required String toWaypointId,
    required String originRoomId,
    required String destinationRoomId,
    required String sourceItemId,
    required String destinationItemId,
  }) {
    if (shipmentId.isEmpty || destinationItemId.isEmpty) {
      throw ArgumentError('Market shipment IDs cannot be empty.');
    }
    if (_state.marketShipments.containsKey(shipmentId) ||
        _state.marketShipments.values.any(
          (MarketShipmentState value) => value.orderId == orderId,
        )) {
      return false;
    }
    final MarketOrderState? order = _state.marketOrders[orderId];
    final TradeRoute? route = _state.routes[routeId];
    final PersonState? carrier = _state.people[carrierId];
    final RoomState? originRoom = _state.rooms[originRoomId];
    final RoomState? destinationRoom = _state.rooms[destinationRoomId];
    final RouteWaypoint? origin = route?.waypoint(fromWaypointId);
    final RouteWaypoint? destination = route?.waypoint(toWaypointId);
    final CareItemState? source = _state.items[sourceItemId];
    final CareItemState? existingDestination = _state.items[destinationItemId];
    if (order == null || order.status != MarketOrderStatus.settled)
      return false;
    if (route == null ||
        carrier?.householdId != order.buyerHouseholdId ||
        carrier?.roomId != originRoomId ||
        originRoom == null ||
        destinationRoom?.householdId != order.buyerHouseholdId ||
        origin == null ||
        destination == null ||
        originRoom.anchorPositionMm != origin.positionMm ||
        originRoom.anchorPositionYMm != origin.positionYMm ||
        destinationRoom!.anchorPositionMm != destination.positionMm ||
        destinationRoom.anchorPositionYMm != destination.positionYMm ||
        sourceItemId != order.buyerTargetItemId ||
        source == null ||
        source.kind != order.merchandise.kind ||
        source.unit != order.merchandise.unit ||
        source.quantity < order.merchandise.quantity ||
        source.ownerHouseholdId != order.buyerHouseholdId ||
        source.roomId != originRoomId ||
        !_state.households[order.buyerHouseholdId]!.canUse(
          carrierId,
          sourceItemId,
        ) ||
        destinationItemId == sourceItemId ||
        (existingDestination != null &&
            (existingDestination.kind != source.kind ||
                existingDestination.unit != source.unit ||
                existingDestination.ownerHouseholdId !=
                    order.buyerHouseholdId ||
                existingDestination.roomId != destinationRoomId))) {
      return false;
    }
    final Map<String, int> cargoMass = <String, int>{
      source.kind: order.merchandise.quantity,
    };
    final int capability = _carrierCapability(carrier!);
    final int baseSpeed = _carrierBaseSpeed(carrier);
    final List<String> path = route.fastestPath(
      from: fromWaypointId,
      to: toWaypointId,
      cargo: cargoMass,
      capabilityPerMille: capability,
      baseSpeed: baseSpeed,
    );
    if (path.length < 2) return false;
    int actualSeconds = 0;
    int nominalSeconds = 0;
    int conditionLoss = 0;
    for (int index = 0; index + 1 < path.length; index++) {
      final RouteLeg? leg = route.legBetween(path[index], path[index + 1]);
      if (leg == null) return false;
      final int distance = route.legDistanceMm(leg);
      actualSeconds += CarrierPace.travelSeconds(
        distanceMm: distance,
        speedMmPerSecond: CarrierPace.speedMmPerSecond(
          terrainSpeedPerMille: leg.terrainSpeedPerMille,
          cargo: cargoMass,
          capabilityPerMille: capability,
          baseSpeed: baseSpeed,
        ),
      );
      nominalSeconds += CarrierPace.travelSeconds(
        distanceMm: distance,
        speedMmPerSecond: baseSpeed,
      );
      conditionLoss += (1000 - leg.terrainSpeedPerMille).clamp(0, 1000) ~/ 40;
    }
    actualSeconds = actualSeconds < 1 ? 1 : actualSeconds;
    nominalSeconds = nominalSeconds < 1 ? 1 : nominalSeconds;
    final int arrivesAt = _state.now.seconds + actualSeconds;
    final bool committed = _beginPersonalCommitments(
      personIds: <String>[carrierId],
      commitmentId: 'market-shipment-$shipmentId',
      kind: 'market_transport',
      activity: 'chở hàng giao dịch',
      endsAtSeconds: arrivesAt,
      relatedId: shipmentId,
    );
    if (!committed) return false;
    final MarketShipmentState shipment = MarketShipmentState(
      id: shipmentId,
      orderId: orderId,
      ownerHouseholdId: order.buyerHouseholdId,
      ownerPersonId: order.buyerPersonId,
      carrierId: carrierId,
      routeId: routeId,
      pathWaypointIds: path,
      originRoomId: originRoomId,
      destinationRoomId: destinationRoomId,
      destinationItemId: destinationItemId,
      cargo: MarketEscrowLot(
        sourceItemId: source.id,
        kind: source.kind,
        quantity: order.merchandise.quantity,
        condition: source.condition,
        unit: source.unit,
        energyKjPer100Ml: source.energyKjPer100Ml,
        waterMlPer100Ml: source.waterMlPer100Ml,
      ),
      departedAtSeconds: _state.now.seconds,
      expectedArrivalSeconds: _state.now.seconds + nominalSeconds,
      scheduledArrivalSeconds: arrivesAt,
      distanceMm: route.pathDistanceMm(path),
      lateSeconds: (actualSeconds - nominalSeconds).clamp(0, actualSeconds),
      plannedConditionLoss: conditionLoss.clamp(0, 1000),
      status: MarketShipmentStatus.inTransit,
    );
    final PersonState committedCarrier = _state.people[carrierId]!;
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        carrierId: committedCarrier.withTransitPosition(
          origin.positionMm,
          origin.positionYMm,
        ),
      },
      items: <String, CareItemState>{
        ..._state.items,
        source.id: source.consume(order.merchandise.quantity),
      },
      marketShipments: <String, MarketShipmentState>{
        ..._state.marketShipments,
        shipmentId: shipment,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'market_shipment_departed',
          shipmentId,
          'order=$orderId carrier=$carrierId route=$routeId '
              'path=${path.join('>')} distance_mm=${shipment.distanceMm} '
              'kind=${shipment.cargo.kind} quantity=${shipment.cargo.quantity} '
              'unit=${shipment.cargo.unit} expected=${shipment.expectedArrivalSeconds} '
              'scheduled=${shipment.scheduledArrivalSeconds} '
              'late_seconds=${shipment.lateSeconds} '
              'condition_loss=${shipment.plannedConditionLoss}',
        ),
      ],
    );
    schedule(
      due: SimTime(arrivesAt),
      phase: EventPhase.transfer,
      kind: 'market_shipment_arrived',
      payload: <String, Object?>{'shipment_id': shipmentId},
    );
    return true;
  }

  void _applyMarketShipmentArrived(ScheduledEvent event) {
    final String shipmentId = event.payload['shipment_id']! as String;
    final MarketShipmentState? shipment = _state.marketShipments[shipmentId];
    if (shipment == null || shipment.status != MarketShipmentStatus.inTransit) {
      return;
    }
    final String commitmentId = 'market-shipment-$shipmentId';
    final PersonState? carrier = _state.people[shipment.carrierId];
    final RoomState? destinationRoom = _state.rooms[shipment.destinationRoomId];
    final CareItemState? target = _state.items[shipment.destinationItemId];
    String? failureReason;
    if (carrier?.timeCommitment?.id != commitmentId) {
      failureReason = 'carrier_commitment_missing';
    } else if (destinationRoom?.householdId != shipment.ownerHouseholdId) {
      failureReason = 'destination_unavailable';
    } else if (target != null &&
        (target.kind != shipment.cargo.kind ||
            target.unit != shipment.cargo.unit ||
            target.ownerHouseholdId != shipment.ownerHouseholdId ||
            target.roomId != shipment.destinationRoomId)) {
      failureReason = 'destination_ledger_changed';
    }
    _endPersonalCommitments(<String>[shipment.carrierId], commitmentId);
    if (failureReason != null) {
      _replace(
        marketShipments: <String, MarketShipmentState>{
          ..._state.marketShipments,
          shipmentId: shipment.fail(_state.now.seconds, failureReason),
        },
        facts: <WorldFact>[
          ..._state.facts,
          _fact(
            'market_shipment_failed',
            shipmentId,
            'order=${shipment.orderId} reason=$failureReason '
                'cargo_retained=true',
          ),
        ],
      );
      return;
    }
    final MarketShipmentState delivered = shipment.deliver(_state.now.seconds);
    final MarketEscrowLot cargo = delivered.cargo;
    final int combinedQuantity = (target?.quantity ?? 0) + cargo.quantity;
    final CareItemState deposited = target == null
        ? CareItemState(
            id: shipment.destinationItemId,
            kind: cargo.kind,
            positionMm: destinationRoom!.anchorPositionMm,
            positionYMm: destinationRoom.anchorPositionYMm,
            quantity: cargo.quantity,
            condition: cargo.condition,
            energyKjPer100Ml: cargo.energyKjPer100Ml,
            waterMlPer100Ml: cargo.waterMlPer100Ml,
            unit: cargo.unit,
            ownerHouseholdId: shipment.ownerHouseholdId,
            roomId: shipment.destinationRoomId,
          )
        : CareItemState(
            id: target.id,
            kind: target.kind,
            positionMm: target.positionMm,
            positionYMm: target.positionYMm,
            quantity: combinedQuantity,
            condition:
                (target.condition * target.quantity +
                    cargo.condition * cargo.quantity) ~/
                combinedQuantity,
            energyKjPer100Ml:
                (target.energyKjPer100Ml * target.quantity +
                    cargo.energyKjPer100Ml * cargo.quantity) ~/
                combinedQuantity,
            waterMlPer100Ml:
                (target.waterMlPer100Ml * target.quantity +
                    cargo.waterMlPer100Ml * cargo.quantity) ~/
                combinedQuantity,
            unit: target.unit,
            ownerHouseholdId: target.ownerHouseholdId,
            roomId: target.roomId,
          );
    final HouseholdState household = _state
        .households[shipment.ownerHouseholdId]!
        .authorizeItem(shipment.destinationItemId, <String>[
          shipment.ownerPersonId,
          shipment.carrierId,
        ]);
    final PersonState currentCarrier = _state.people[shipment.carrierId]!;
    _replace(
      people: <String, PersonState>{
        ..._state.people,
        shipment.carrierId: currentCarrier.withLocation(
          positionMm: destinationRoom!.anchorPositionMm,
          positionYMm: destinationRoom.anchorPositionYMm,
          roomId: destinationRoom.id,
        ),
      },
      items: <String, CareItemState>{
        ..._state.items,
        shipment.destinationItemId: deposited,
      },
      households: <String, HouseholdState>{
        ..._state.households,
        household.id: household,
      },
      marketShipments: <String, MarketShipmentState>{
        ..._state.marketShipments,
        shipmentId: delivered,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'market_shipment_delivered',
          shipmentId,
          'order=${shipment.orderId} destination=${shipment.destinationRoomId} '
              'kind=${cargo.kind} quantity=${cargo.quantity} unit=${cargo.unit} '
              'condition=${cargo.condition} late_seconds=${shipment.lateSeconds}',
        ),
      ],
    );
  }

  /// Bắt đầu một cú sốc hữu hạn bằng cách làm mất khả dụng các lô vật thật.
  /// Mỗi hộ bị ảnh hưởng phải có ít nhất một lô bị gián đoạn, nên cú sốc không
  /// thể chỉ là nhãn kể chuyện gắn lên snapshot.
  bool beginSupplyShock({
    required String shockId,
    required String resourceKind,
    required String unit,
    required String cause,
    required int durationSeconds,
    required List<String> affectedHouseholdIds,
    required Map<String, int> disruptedQuantityByItemId,
  }) {
    if (shockId.isEmpty ||
        resourceKind.isEmpty ||
        unit.isEmpty ||
        cause.isEmpty ||
        durationSeconds < 2 * gameSecondsPerDay) {
      throw ArgumentError('Supply shock identity or duration is invalid.');
    }
    if (_state.supplyShocks.containsKey(shockId)) return false;
    final List<String> households = affectedHouseholdIds.toSet().toList()
      ..sort();
    if (households.length < 2 || disruptedQuantityByItemId.isEmpty) {
      throw StateError('A supply shock must materially affect two households.');
    }
    if (households.any((String id) => !_state.households.containsKey(id))) {
      throw StateError('Supply shock references an unknown household.');
    }

    final List<SupplyDisruptionLot> lots = <SupplyDisruptionLot>[];
    final Set<String> materiallyAffected = <String>{};
    final Map<String, CareItemState> items = <String, CareItemState>{
      ..._state.items,
    };
    final List<String> itemIds = disruptedQuantityByItemId.keys.toList()
      ..sort();
    for (final String itemId in itemIds) {
      final CareItemState? item = _state.items[itemId];
      final int quantity = disruptedQuantityByItemId[itemId] ?? 0;
      if (item == null ||
          quantity <= 0 ||
          item.kind != resourceKind ||
          item.unit != unit ||
          item.ownerHouseholdId == null ||
          !households.contains(item.ownerHouseholdId) ||
          item.quantity < quantity) {
        throw StateError(
          'Supply disruption lot is not backed by stock: $itemId.',
        );
      }
      lots.add(
        SupplyDisruptionLot(
          itemId: item.id,
          householdId: item.ownerHouseholdId!,
          kind: item.kind,
          quantity: quantity,
          unit: item.unit,
          condition: item.condition,
        ),
      );
      materiallyAffected.add(item.ownerHouseholdId!);
      items[item.id] = item.consume(quantity);
    }
    if (!materiallyAffected.containsAll(households)) {
      throw StateError('Every affected household needs a disrupted stock lot.');
    }

    final int endsAt = _state.now.seconds + durationSeconds;
    final SupplyShockState shock = SupplyShockState(
      id: shockId,
      resourceKind: resourceKind,
      unit: unit,
      cause: cause,
      startsAtSeconds: _state.now.seconds,
      endsAtSeconds: endsAt,
      affectedHouseholdIds: List<String>.unmodifiable(households),
      disruptedLots: List<SupplyDisruptionLot>.unmodifiable(lots),
      status: SupplyShockStatus.active,
    );
    final String disrupted = households
        .map(
          (String householdId) =>
              '$householdId:${lots.where((SupplyDisruptionLot value) => value.householdId == householdId).fold<int>(0, (int total, SupplyDisruptionLot value) => total + value.quantity)}',
        )
        .join(',');
    _replace(
      items: items,
      supplyShocks: <String, SupplyShockState>{
        ..._state.supplyShocks,
        shockId: shock,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'supply_shock_started',
          shockId,
          'kind=$resourceKind unit=$unit cause=$cause ends_at=$endsAt '
              'households=${households.join(',')} disrupted=$disrupted',
        ),
      ],
    );
    schedule(
      due: _state.now.addDays(1),
      phase: EventPhase.bookkeeping,
      kind: 'supply_shock_audit',
      payload: <String, Object?>{'shock_id': shockId},
    );
    return true;
  }

  /// Gắn một phản ứng vào cú sốc chỉ khi batch/appointment/order thật tồn tại.
  bool recordSupplyShockResponse({
    required String shockId,
    required String householdId,
    required SupplyShockResponseKind kind,
    required String evidenceId,
  }) {
    final SupplyShockState? shock = _state.supplyShocks[shockId];
    if (shock == null ||
        shock.status != SupplyShockStatus.active ||
        _state.now.seconds > shock.endsAtSeconds ||
        !shock.affectedHouseholdIds.contains(householdId)) {
      return false;
    }
    final int shockFactIndex = _state.facts.lastIndexWhere(
      (WorldFact value) =>
          value.kind == 'supply_shock_started' && value.subjectId == shockId,
    );
    bool hasLaterFact(String factKind) {
      if (shockFactIndex < 0) return false;
      for (
        int index = shockFactIndex + 1;
        index < _state.facts.length;
        index++
      ) {
        final WorldFact fact = _state.facts[index];
        if (fact.kind == factKind && fact.subjectId == evidenceId) return true;
      }
      return false;
    }

    final bool validEvidence = switch (kind) {
      SupplyShockResponseKind.production => () {
        final ProductionBatchState? batch =
            _state.productionBatches[evidenceId];
        return batch?.householdId == householdId &&
            batch!.startedAtSeconds >= shock.startsAtSeconds &&
            hasLaterFact('production_batch_started');
      }(),
      SupplyShockResponseKind.service => () {
        final ServiceAppointmentState? appointment =
            _state.serviceAppointments[evidenceId];
        return appointment != null &&
            (appointment.providerHouseholdId == householdId ||
                appointment.recipientHouseholdId == householdId) &&
            appointment.startsAtSeconds >= shock.startsAtSeconds &&
            hasLaterFact('service_appointment_booked');
      }(),
      SupplyShockResponseKind.marketExchange => () {
        final MarketOrderState? order = _state.marketOrders[evidenceId];
        return order != null &&
            (order.sellerHouseholdId == householdId ||
                order.buyerHouseholdId == householdId) &&
            order.createdAtSeconds >= shock.startsAtSeconds &&
            hasLaterFact('market_order_reserved');
      }(),
    };
    if (!validEvidence ||
        shock.responses.any(
          (SupplyShockResponse value) =>
              value.householdId == householdId &&
              value.kind == kind &&
              value.evidenceId == evidenceId,
        )) {
      return false;
    }
    final SupplyShockResponse response = SupplyShockResponse(
      householdId: householdId,
      kind: kind,
      evidenceId: evidenceId,
      recordedAtSeconds: _state.now.seconds,
    );
    _replace(
      supplyShocks: <String, SupplyShockState>{
        ..._state.supplyShocks,
        shockId: shock.addResponse(response),
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          'supply_shock_response_recorded',
          shockId,
          'household=$householdId response=${kind.name} evidence=$evidenceId',
        ),
      ],
    );
    return true;
  }

  void _applySupplyShockAudit(ScheduledEvent event) {
    final String shockId = event.payload['shock_id']! as String;
    final SupplyShockState? current = _state.supplyShocks[shockId];
    if (current == null || current.status != SupplyShockStatus.active) return;
    final int day =
        (_state.now.seconds - current.startsAtSeconds) ~/ gameSecondsPerDay;
    final List<SupplyShockHouseholdDay> records = <SupplyShockHouseholdDay>[];
    for (final String householdId in current.affectedHouseholdIds) {
      final int available = _state.items.values
          .where(
            (CareItemState value) =>
                value.ownerHouseholdId == householdId &&
                value.kind == current.resourceKind &&
                value.unit == current.unit,
          )
          .fold<int>(
            0,
            (int total, CareItemState value) => total + value.quantity,
          );
      final int inTransit = _state.marketShipments.values
          .where(
            (MarketShipmentState value) =>
                value.ownerHouseholdId == householdId &&
                value.status == MarketShipmentStatus.inTransit &&
                value.cargo.kind == current.resourceKind &&
                value.cargo.unit == current.unit,
          )
          .fold<int>(
            0,
            (int total, MarketShipmentState value) =>
                total + value.cargo.quantity,
          );
      final List<SupplyShockResponseKind> responses =
          current.responses
              .where(
                (SupplyShockResponse value) => value.householdId == householdId,
              )
              .map((SupplyShockResponse value) => value.kind)
              .toSet()
              .toList()
            ..sort(
              (SupplyShockResponseKind a, SupplyShockResponseKind b) =>
                  a.index.compareTo(b.index),
            );
      records.add(
        SupplyShockHouseholdDay(
          day: day,
          recordedAtSeconds: _state.now.seconds,
          householdId: householdId,
          availableQuantity: available,
          inTransitQuantity: inTransit,
          responseKinds: List<SupplyShockResponseKind>.unmodifiable(responses),
        ),
      );
    }
    SupplyShockState updated = current.recordDays(records);
    final bool ending = _state.now.seconds >= current.endsAtSeconds;
    if (ending) updated = updated.resolve(_state.now.seconds);
    final int adaptedHouseholds = updated.responses
        .map((SupplyShockResponse value) => value.householdId)
        .toSet()
        .length;
    _replace(
      supplyShocks: <String, SupplyShockState>{
        ..._state.supplyShocks,
        shockId: updated,
      },
      facts: <WorldFact>[
        ..._state.facts,
        _fact(
          ending ? 'supply_shock_resolved' : 'supply_shock_day_recorded',
          shockId,
          'day=$day kind=${current.resourceKind} '
          'stocks=${records.map((SupplyShockHouseholdDay value) => '${value.householdId}:${value.availableQuantity}+${value.inTransitQuantity}').join(',')} '
          'adapted_households=$adaptedHouseholds',
        ),
      ],
    );
    if (!ending) {
      final int candidate = _state.now.seconds + gameSecondsPerDay;
      final int nextSeconds = candidate > current.endsAtSeconds
          ? current.endsAtSeconds
          : candidate;
      schedule(
        due: SimTime(nextSeconds),
        phase: EventPhase.bookkeeping,
        kind: 'supply_shock_audit',
        payload: <String, Object?>{'shock_id': shockId},
      );
    }
  }
}
