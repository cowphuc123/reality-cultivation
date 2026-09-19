enum KnowledgeAcquisition { observation, testimony }

/// Một bằng chứng nằm trong hiểu biết riêng của một người, không phải sự thật
/// toàn tri của thế giới.
class BeliefState {
  const BeliefState({
    required this.id,
    required this.claimId,
    required this.topic,
    required this.subjectId,
    required this.summary,
    required this.eventAtSeconds,
    required this.learnedAtSeconds,
    required this.acquisition,
    required this.sourcePersonId,
    required this.originPersonId,
    required this.originEvidenceId,
    required this.confidence,
    this.transmissionCount = 0,
    this.sourceObjectId,
    this.learningActivity,
  });

  final String id;
  final String claimId;
  final String topic;
  final String subjectId;
  final String summary;
  final int? eventAtSeconds;
  final int learnedAtSeconds;
  final KnowledgeAcquisition acquisition;
  final String sourcePersonId;
  final String originPersonId;

  /// Không đổi khi lời kể đi qua người khác; dùng để chặn vòng lặp tin đồn tự
  /// biến thành nhiều nguồn độc lập.
  final String originEvidenceId;
  final int confidence;
  final int transmissionCount;

  /// Vật thật làm nguồn học trực tiếp, nếu bằng chứng đến từ quan sát vật.
  final String? sourceObjectId;

  /// Hoạt động đã tạo ra hiểu biết này; để trống với tri thức xã hội cũ.
  final String? learningActivity;

  BeliefState relayedBy({
    required String speakerId,
    required int learnedAtSeconds,
  }) {
    final int nextConfidence = (confidence - 80).clamp(50, 1000);
    return BeliefState(
      id: id,
      claimId: claimId,
      topic: topic,
      subjectId: subjectId,
      summary: summary,
      eventAtSeconds: eventAtSeconds,
      learnedAtSeconds: learnedAtSeconds,
      acquisition: KnowledgeAcquisition.testimony,
      sourcePersonId: speakerId,
      originPersonId: originPersonId,
      originEvidenceId: originEvidenceId,
      confidence: nextConfidence,
      transmissionCount: transmissionCount + 1,
      sourceObjectId: sourceObjectId,
      learningActivity: learningActivity,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'claim_id': claimId,
    'topic': topic,
    'subject_id': subjectId,
    'summary': summary,
    if (eventAtSeconds != null) 'event_at_seconds': eventAtSeconds,
    'learned_at_seconds': learnedAtSeconds,
    'acquisition': acquisition.name,
    'source_person_id': sourcePersonId,
    'origin_person_id': originPersonId,
    'origin_evidence_id': originEvidenceId,
    'confidence': confidence,
    if (transmissionCount > 0) 'transmission_count': transmissionCount,
    if (sourceObjectId != null) 'source_object_id': sourceObjectId,
    if (learningActivity != null) 'learning_activity': learningActivity,
  };

  factory BeliefState.fromJson(Map<String, Object?> json) => BeliefState(
    id: json['id']! as String,
    claimId: json['claim_id']! as String,
    topic: json['topic']! as String,
    subjectId: json['subject_id']! as String,
    summary: json['summary']! as String,
    eventAtSeconds: json['event_at_seconds'] as int?,
    learnedAtSeconds: json['learned_at_seconds']! as int,
    acquisition: KnowledgeAcquisition.values.byName(
      json['acquisition']! as String,
    ),
    sourcePersonId: json['source_person_id']! as String,
    originPersonId: json['origin_person_id']! as String,
    originEvidenceId: json['origin_evidence_id']! as String,
    confidence: json['confidence']! as int,
    transmissionCount: json['transmission_count'] as int? ?? 0,
    sourceObjectId: json['source_object_id'] as String?,
    learningActivity: json['learning_activity'] as String?,
  );
}
