class UserProfile {
  const UserProfile({
    required this.fullName,
    this.department,
    this.academicYear,
    this.monthlyBudget,
    this.bio,
    required this.isSmoker,
    required this.isNightOwl,
    required this.cleanlinessLevel,
  });

  final String fullName;
  final String? department;
  final int? academicYear;
  final double? monthlyBudget;
  final String? bio;
  final bool isSmoker;
  final bool isNightOwl;
  final int cleanlinessLevel;
}
