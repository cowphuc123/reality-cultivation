enum CommunityExchangeStatus { traveling, completed, cancelled }

/// Một cuộc đổi hàng giữa hai hộ. Hàng bị rút khỏi hai kho khi khởi hành và
/// nằm trong hồ sơ này cho tới lúc tới nơi, nên save giữa đường không làm mất
/// hoặc nhân đôi vật chất.
class CommunityExchangeState {
  const CommunityExchangeState({
    required this.id,
    required this.firstHouseholdId,
    required this.secondHouseholdId,
    required this.firstCarrierId,
    required this.secondCarrierId,
    required this.firstResource,
    required this.firstAmount,
    required this.secondResource,
    required this.secondAmount,
    required this.departedAtSeconds,
    required this.expectedArrivalSeconds,
    required this.status,
    this.completedAtSeconds,
    this.cancelReason,
    this.resourceRequestId,
  });

  final String id;
  final String firstHouseholdId;
  final String secondHouseholdId;
  final String firstCarrierId;
  final String secondCarrierId;
  final String firstResource;
  final int firstAmount;
  final String secondResource;
  final int secondAmount;
  final int departedAtSeconds;
  final int expectedArrivalSeconds;
  final CommunityExchangeStatus status;
  final int? completedAtSeconds;
  final String? cancelReason;
  final String? resourceRequestId;

  CommunityExchangeState complete(int atSeconds) => _copy(
    status: CommunityExchangeStatus.completed,
    completedAtSeconds: atSeconds,
  );

  CommunityExchangeState cancel(int atSeconds, String reason) => _copy(
    status: CommunityExchangeStatus.cancelled,
    completedAtSeconds: atSeconds,
    cancelReason: reason,
  );

  CommunityExchangeState _copy({
    required CommunityExchangeStatus status,
    int? completedAtSeconds,
    String? cancelReason,
  }) => CommunityExchangeState(
    id: id,
    firstHouseholdId: firstHouseholdId,
    secondHouseholdId: secondHouseholdId,
    firstCarrierId: firstCarrierId,
    secondCarrierId: secondCarrierId,
    firstResource: firstResource,
    firstAmount: firstAmount,
    secondResource: secondResource,
    secondAmount: secondAmount,
    departedAtSeconds: departedAtSeconds,
    expectedArrivalSeconds: expectedArrivalSeconds,
    status: status,
    completedAtSeconds: completedAtSeconds,
    cancelReason: cancelReason,
    resourceRequestId: resourceRequestId,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'first_household_id': firstHouseholdId,
    'second_household_id': secondHouseholdId,
    'first_carrier_id': firstCarrierId,
    'second_carrier_id': secondCarrierId,
    'first_resource': firstResource,
    'first_amount': firstAmount,
    'second_resource': secondResource,
    'second_amount': secondAmount,
    'departed_at_seconds': departedAtSeconds,
    'expected_arrival_seconds': expectedArrivalSeconds,
    'status': status.name,
    if (completedAtSeconds != null) 'completed_at_seconds': completedAtSeconds,
    if (cancelReason != null) 'cancel_reason': cancelReason,
    if (resourceRequestId != null) 'resource_request_id': resourceRequestId,
  };

  factory CommunityExchangeState.fromJson(Map<String, Object?> json) =>
      CommunityExchangeState(
        id: json['id']! as String,
        firstHouseholdId: json['first_household_id']! as String,
        secondHouseholdId: json['second_household_id']! as String,
        firstCarrierId: json['first_carrier_id']! as String,
        secondCarrierId: json['second_carrier_id']! as String,
        firstResource: json['first_resource']! as String,
        firstAmount: json['first_amount']! as int,
        secondResource: json['second_resource']! as String,
        secondAmount: json['second_amount']! as int,
        departedAtSeconds: json['departed_at_seconds']! as int,
        expectedArrivalSeconds: json['expected_arrival_seconds']! as int,
        status: CommunityExchangeStatus.values.byName(
          json['status']! as String,
        ),
        completedAtSeconds: json['completed_at_seconds'] as int?,
        cancelReason: json['cancel_reason'] as String?,
        resourceRequestId: json['resource_request_id'] as String?,
      );
}
