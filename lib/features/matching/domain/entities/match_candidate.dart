class MatchCandidate {
  const MatchCandidate({
    required this.userId,
    required this.fullName,
    this.department,
    this.academicYear,
    this.score,
  });

  final String userId;
  final String fullName;
  final String? department;
  final int? academicYear;
  final double? score;
}
