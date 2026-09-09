/// Nhịp sống hằng ngày của một người và các xung đột lịch có thật.
///
/// Một khối nhịp sống là cam kết thời gian có địa điểm. Khi một nghĩa vụ khác
/// chen vào đúng lúc khối đang chạy, thời gian mất đi được ghi lại thành
/// [ScheduleConflict] thay vì biến mất im lặng.
class RoutineBlock {
  const RoutineBlock({
    required this.id,
    required this.activity,
    required this.startSecondOfDay,
    required this.durationSeconds,
    this.roomId,
    this.priority = 50,
    this.blocking = false,
    this.needKind,
    this.requiredSkill,
    this.outputResource,
    this.outputAmount = 0,
    this.planDay,
  });

  final String id;
  final String activity;
  final int startSecondOfDay;
  final int durationSeconds;

  /// Phòng người này phải có mặt trong suốt khối, nếu có.
  final String? roomId;

  /// Ưu tiên khi hai cam kết trùng giờ; số lớn hơn được giữ.
  final int priority;

  /// Khối khiến người này không thể nhận nghĩa vụ khác của hộ.
  final bool blocking;

  /// Nhu cầu của hộ đã sinh ra khối này, nếu khối do kế hoạch tạo.
  final String? needKind;

  /// Tay nghề tối thiểu để một người khác có thể gánh thay khối này.
  final String? requiredSkill;

  /// Khóa nguồn lực mà khối này bổ sung cho hộ khi làm xong.
  final String? outputResource;

  /// Sản lượng nếu làm trọn khối; làm dở thì chia theo số giây thật sự làm.
  final int outputAmount;

  /// Ngày kế hoạch sinh ra khối; khối cố định không có giá trị này.
  final int? planDay;

  /// Khối do kế hoạch của hộ sinh ra thay vì bảng giờ cố định.
  bool get generated => planDay != null;

  int get endSecondOfDay => startSecondOfDay + durationSeconds;

  bool overlaps(RoutineBlock other) =>
      startSecondOfDay < other.endSecondOfDay &&
      other.startSecondOfDay < endSecondOfDay;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'activity': activity,
    'start_second_of_day': startSecondOfDay,
    'duration_seconds': durationSeconds,
    if (roomId != null) 'room_id': roomId,
    if (priority != 50) 'priority': priority,
    if (blocking) 'blocking': true,
    if (needKind != null) 'need_kind': needKind,
    if (requiredSkill != null) 'required_skill': requiredSkill,
    if (outputResource != null) 'output_resource': outputResource,
    if (outputAmount > 0) 'output_amount': outputAmount,
    if (planDay != null) 'plan_day': planDay,
  };

  factory RoutineBlock.fromJson(Map<String, Object?> json) => RoutineBlock(
    id: json['id']! as String,
    activity: json['activity']! as String,
    startSecondOfDay: json['start_second_of_day']! as int,
    durationSeconds: json['duration_seconds']! as int,
    roomId: json['room_id'] as String?,
    priority: json['priority'] as int? ?? 50,
    blocking: json['blocking'] as bool? ?? false,
    needKind: json['need_kind'] as String?,
    requiredSkill: json['required_skill'] as String?,
    outputResource: json['output_resource'] as String?,
    outputAmount: json['output_amount'] as int? ?? 0,
    planDay: json['plan_day'] as int?,
  );
}

/// Một lần hai cam kết cùng đòi thời gian của một người.
class ScheduleConflict {
  const ScheduleConflict({
    required this.atSeconds,
    required this.plannedActivity,
    required this.competingActivity,
    required this.resolution,
    this.blockId,
    this.lostSeconds = 0,
  });

  final int atSeconds;
  final String plannedActivity;
  final String competingActivity;

  /// `preempted` việc đang làm bị cắt, `deferred` việc phải lùi giờ,
  /// `dropped` việc mất hẳn trong ngày.
  final String resolution;
  final String? blockId;
  final int lostSeconds;

  Map<String, Object?> toJson() => <String, Object?>{
    'at_seconds': atSeconds,
    'planned_activity': plannedActivity,
    'competing_activity': competingActivity,
    'resolution': resolution,
    if (blockId != null) 'block_id': blockId,
    if (lostSeconds > 0) 'lost_seconds': lostSeconds,
  };

  factory ScheduleConflict.fromJson(Map<String, Object?> json) =>
      ScheduleConflict(
        atSeconds: json['at_seconds']! as int,
        plannedActivity: json['planned_activity']! as String,
        competingActivity: json['competing_activity']! as String,
        resolution: json['resolution']! as String,
        blockId: json['block_id'] as String?,
        lostSeconds: json['lost_seconds'] as int? ?? 0,
      );
}

class RoutineState {
  const RoutineState({
    required this.blocks,
    this.activeBlockId,
    this.activeSinceSeconds,
    this.activePlannedEndSeconds,
    this.activeLostSeconds = 0,
    this.preemptedBy,
    this.preemptedAtSeconds,
    this.completedBlocks = 0,
    this.deferredStarts = 0,
    this.droppedBlocks = 0,
    this.outrankedBlocks = 0,
    this.lostSeconds = 0,
    this.conflictCount = 0,
    this.conflicts = const <ScheduleConflict>[],
  });

  /// Số xung đột gần nhất còn giữ chi tiết trong bản lưu.
  static const int retainedConflicts = 24;

  final List<RoutineBlock> blocks;
  final String? activeBlockId;
  final int? activeSinceSeconds;

  /// Giờ khối đang chạy lẽ ra phải kết thúc, tính theo giây tuyệt đối.
  final int? activePlannedEndSeconds;

  /// Số giây đã mất riêng trong khối đang chạy, dùng để chia sản lượng.
  final int activeLostSeconds;

  final String? preemptedBy;
  final int? preemptedAtSeconds;
  final int completedBlocks;
  final int deferredStarts;
  final int droppedBlocks;
  final int outrankedBlocks;
  final int lostSeconds;
  final int conflictCount;
  final List<ScheduleConflict> conflicts;

  bool get preempted => preemptedBy != null;

  RoutineBlock? blockById(String id) =>
      blocks.where((RoutineBlock block) => block.id == id).firstOrNull;

  RoutineBlock? get activeBlock =>
      activeBlockId == null ? null : blockById(activeBlockId!);

  List<RoutineBlock> get fixedBlocks =>
      blocks.where((RoutineBlock block) => !block.generated).toList();

  List<RoutineBlock> get generatedBlocks =>
      blocks.where((RoutineBlock block) => block.generated).toList();

  /// Hoạt động đang khiến người này không nhận được nghĩa vụ khác.
  String? get blockingActivity {
    final RoutineBlock? block = activeBlock;
    if (block == null || !block.blocking) return null;
    return block.activity;
  }

  /// Điều đang chiếm thời gian của người này, nếu có.
  String? get currentActivity => preemptedBy ?? activeBlock?.activity;

  /// Số giây đã mất trong khối đang chạy, kể cả lần cắt ngang chưa kết thúc.
  int lostInActiveBlock(int nowSeconds) {
    final int pending = preempted && preemptedAtSeconds != null
        ? (nowSeconds - preemptedAtSeconds!).clamp(0, 86400)
        : 0;
    return activeLostSeconds + pending;
  }

  RoutineState startBlock({
    required String blockId,
    required int nowSeconds,
    required int plannedEndSeconds,
  }) => _copy(
    activeBlockId: blockId,
    activeSinceSeconds: nowSeconds,
    activePlannedEndSeconds: plannedEndSeconds,
    activeLostSeconds: 0,
    clearActive: false,
  );

  RoutineState endBlock(int nowSeconds) {
    if (activeBlockId == null) return this;
    if (preempted && preemptedAtSeconds != null) {
      final int lost = (nowSeconds - preemptedAtSeconds!).clamp(0, 86400);
      return _withConflict(
        ScheduleConflict(
          atSeconds: nowSeconds,
          plannedActivity: activeBlock?.activity ?? activeBlockId!,
          competingActivity: preemptedBy!,
          resolution: 'preempted',
          blockId: activeBlockId,
          lostSeconds: lost,
        ),
      )._copy(
        clearActive: true,
        preemptedAtSeconds: nowSeconds,
        completedBlocks: completedBlocks + 1,
        lostSeconds: lostSeconds + lost,
      );
    }
    return _copy(clearActive: true, completedBlocks: completedBlocks + 1);
  }

  /// Khối đang chạy bị một cam kết ưu tiên cao hơn giành mất chỗ.
  RoutineState outrank({
    required int nowSeconds,
    required String byActivity,
    required int lostSeconds,
  }) {
    if (activeBlockId == null) return this;
    return _withConflict(
      ScheduleConflict(
        atSeconds: nowSeconds,
        plannedActivity: activeBlock?.activity ?? activeBlockId!,
        competingActivity: byActivity,
        resolution: 'outranked',
        blockId: activeBlockId,
        lostSeconds: lostSeconds,
      ),
    )._copy(
      clearActive: true,
      outrankedBlocks: outrankedBlocks + 1,
      lostSeconds: this.lostSeconds + lostSeconds,
    );
  }

  /// Đánh dấu người này bị một nghĩa vụ khác chiếm chỗ.
  RoutineState preempt({required int nowSeconds, required String by}) {
    if (preempted) return this;
    return _copy(
      preemptedBy: by,
      preemptedAtSeconds: nowSeconds,
      clearActive: false,
    );
  }

  /// Trả người này về khối đang dở và ghi lại thời gian đã mất.
  RoutineState resume(int nowSeconds) {
    if (!preempted) return this;
    final String competing = preemptedBy!;
    final int lost = preemptedAtSeconds == null
        ? 0
        : (nowSeconds - preemptedAtSeconds!).clamp(0, 86400);
    final RoutineBlock? block = activeBlock;
    if (block == null) {
      return _copy(clearPreemption: true);
    }
    return _withConflict(
      ScheduleConflict(
        atSeconds: nowSeconds,
        plannedActivity: block.activity,
        competingActivity: competing,
        resolution: 'preempted',
        blockId: block.id,
        lostSeconds: lost,
      ),
    )._copy(
      clearPreemption: true,
      lostSeconds: lostSeconds + lost,
      activeLostSeconds: activeLostSeconds + lost,
    );
  }

  /// Khối phải lùi giờ vì người này còn vướng việc khác.
  RoutineState deferStart({
    required int nowSeconds,
    required String blockId,
    required String competingActivity,
  }) => _withConflict(
    ScheduleConflict(
      atSeconds: nowSeconds,
      plannedActivity: blockById(blockId)?.activity ?? blockId,
      competingActivity: competingActivity,
      resolution: 'deferred',
      blockId: blockId,
    ),
  )._copy(deferredStarts: deferredStarts + 1);

  /// Khối mất hẳn trong ngày vì không còn giờ để bù.
  RoutineState dropStart({
    required int nowSeconds,
    required String blockId,
    required String competingActivity,
  }) {
    final RoutineBlock? block = blockById(blockId);
    return _withConflict(
      ScheduleConflict(
        atSeconds: nowSeconds,
        plannedActivity: block?.activity ?? blockId,
        competingActivity: competingActivity,
        resolution: 'dropped',
        blockId: blockId,
        lostSeconds: block?.durationSeconds ?? 0,
      ),
    )._copy(
      droppedBlocks: droppedBlocks + 1,
      lostSeconds: lostSeconds + (block?.durationSeconds ?? 0),
    );
  }

  /// Thay toàn bộ khối do kế hoạch sinh ra, giữ nguyên bảng giờ cố định.
  RoutineState withGeneratedBlocks(List<RoutineBlock> generated) =>
      _copy(blocks: <RoutineBlock>[...fixedBlocks, ...generated]);

  /// Ghi một xung đột do nghĩa vụ ngoài nhịp sống, ví dụ bữa ăn của hộ.
  RoutineState recordConflict(ScheduleConflict conflict) =>
      _withConflict(conflict);

  RoutineState _withConflict(ScheduleConflict conflict) {
    final List<ScheduleConflict> next = <ScheduleConflict>[
      ...conflicts,
      conflict,
    ];
    return _copy(
      conflicts: next.length > retainedConflicts
          ? next.sublist(next.length - retainedConflicts)
          : next,
      conflictCount: conflictCount + 1,
    );
  }

  RoutineState _copy({
    List<RoutineBlock>? blocks,
    String? activeBlockId,
    int? activeSinceSeconds,
    int? activePlannedEndSeconds,
    int? activeLostSeconds,
    String? preemptedBy,
    int? preemptedAtSeconds,
    int? completedBlocks,
    int? deferredStarts,
    int? droppedBlocks,
    int? outrankedBlocks,
    int? lostSeconds,
    int? conflictCount,
    List<ScheduleConflict>? conflicts,
    bool clearActive = false,
    bool clearPreemption = false,
  }) => RoutineState(
    blocks: blocks ?? this.blocks,
    activeBlockId: clearActive ? null : (activeBlockId ?? this.activeBlockId),
    activeSinceSeconds: clearActive
        ? null
        : (activeSinceSeconds ?? this.activeSinceSeconds),
    activePlannedEndSeconds: clearActive
        ? null
        : (activePlannedEndSeconds ?? this.activePlannedEndSeconds),
    activeLostSeconds: clearActive
        ? 0
        : (activeLostSeconds ?? this.activeLostSeconds),
    preemptedBy: clearPreemption ? null : (preemptedBy ?? this.preemptedBy),
    preemptedAtSeconds: clearPreemption
        ? null
        : (preemptedAtSeconds ?? this.preemptedAtSeconds),
    completedBlocks: completedBlocks ?? this.completedBlocks,
    deferredStarts: deferredStarts ?? this.deferredStarts,
    droppedBlocks: droppedBlocks ?? this.droppedBlocks,
    outrankedBlocks: outrankedBlocks ?? this.outrankedBlocks,
    lostSeconds: lostSeconds ?? this.lostSeconds,
    conflictCount: conflictCount ?? this.conflictCount,
    conflicts: conflicts ?? this.conflicts,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'blocks': <Map<String, Object?>>[
      for (final RoutineBlock block in blocks) block.toJson(),
    ],
    if (activeBlockId != null) 'active_block_id': activeBlockId,
    if (activeSinceSeconds != null) 'active_since_seconds': activeSinceSeconds,
    if (activePlannedEndSeconds != null)
      'active_planned_end_seconds': activePlannedEndSeconds,
    if (activeLostSeconds > 0) 'active_lost_seconds': activeLostSeconds,
    if (preemptedBy != null) 'preempted_by': preemptedBy,
    if (preemptedAtSeconds != null) 'preempted_at_seconds': preemptedAtSeconds,
    if (completedBlocks > 0) 'completed_blocks': completedBlocks,
    if (deferredStarts > 0) 'deferred_starts': deferredStarts,
    if (droppedBlocks > 0) 'dropped_blocks': droppedBlocks,
    if (outrankedBlocks > 0) 'outranked_blocks': outrankedBlocks,
    if (lostSeconds > 0) 'lost_seconds': lostSeconds,
    if (conflictCount > 0) 'conflict_count': conflictCount,
    if (conflicts.isNotEmpty)
      'conflicts': <Map<String, Object?>>[
        for (final ScheduleConflict conflict in conflicts) conflict.toJson(),
      ],
  };

  factory RoutineState.fromJson(Map<String, Object?> json) => RoutineState(
    blocks: <RoutineBlock>[
      for (final Object? block in json['blocks']! as List<Object?>)
        RoutineBlock.fromJson((block! as Map).cast<String, Object?>()),
    ],
    activeBlockId: json['active_block_id'] as String?,
    activeSinceSeconds: json['active_since_seconds'] as int?,
    activePlannedEndSeconds: json['active_planned_end_seconds'] as int?,
    activeLostSeconds: json['active_lost_seconds'] as int? ?? 0,
    preemptedBy: json['preempted_by'] as String?,
    preemptedAtSeconds: json['preempted_at_seconds'] as int?,
    completedBlocks: json['completed_blocks'] as int? ?? 0,
    deferredStarts: json['deferred_starts'] as int? ?? 0,
    droppedBlocks: json['dropped_blocks'] as int? ?? 0,
    outrankedBlocks: json['outranked_blocks'] as int? ?? 0,
    lostSeconds: json['lost_seconds'] as int? ?? 0,
    conflictCount: json['conflict_count'] as int? ?? 0,
    conflicts: <ScheduleConflict>[
      for (final Object? conflict
          in (json['conflicts'] as List<Object?>? ?? const <Object?>[]))
        ScheduleConflict.fromJson((conflict! as Map).cast<String, Object?>()),
    ],
  );
}

/// Một nhu cầu vật chất của hộ, suy ra từ tồn kho thật chứ không viết sẵn.
class HouseholdNeed {
  const HouseholdNeed({
    required this.kind,
    required this.resourceKey,
    required this.quantity,
    required this.dailyUse,
    required this.horizonDays,
  });

  final String kind;
  final String resourceKey;
  final int quantity;
  final int dailyUse;
  final int horizonDays;

  /// Số ngày còn dùng được với nhịp tiêu thụ hiện tại.
  int get daysOfSupply => dailyUse <= 0 ? horizonDays : quantity ~/ dailyUse;

  /// 0 khi còn đủ dùng, tiến tới 100 khi sắp cạn.
  int get urgency {
    if (horizonDays <= 0) return 0;
    final int remaining = daysOfSupply.clamp(0, horizonDays);
    return ((horizonDays - remaining) * 100) ~/ horizonDays;
  }

  bool get needed => urgency > 0;

  /// Ưu tiên của khối việc sinh ra từ nhu cầu này.
  int get priority => 40 + (urgency * 50) ~/ 100;

  Map<String, Object?> toJson() => <String, Object?>{
    'kind': kind,
    'resource_key': resourceKey,
    'quantity': quantity,
    'daily_use': dailyUse,
    'days_of_supply': daysOfSupply,
    'urgency': urgency,
    'priority': priority,
  };
}
