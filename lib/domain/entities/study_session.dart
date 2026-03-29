class StudySession {
  final int id;
  final DateTime startedAt;
  final DateTime? endedAt;

  StudySession({
    required this.id,
    required this.startedAt,
    this.endedAt,
  });

  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}
