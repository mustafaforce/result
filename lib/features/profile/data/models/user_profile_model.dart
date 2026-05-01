import '../../domain/entities/user_profile.dart';

class UserProfileModel {
  const UserProfileModel({
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

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final prefs = json['user_preferences'] as Map<String, dynamic>?;
    return UserProfileModel(
      fullName: (json['full_name'] as String?) ?? '',
      department: json['department'] as String?,
      academicYear: json['academic_year'] as int?,
      monthlyBudget: (json['budget_max'] as num?)?.toDouble(),
      bio: json['bio'] as String?,
      isSmoker: (prefs?['is_smoker'] as bool?) ?? false,
      isNightOwl: (prefs?['is_night_owl'] as bool?) ?? false,
      cleanlinessLevel: (prefs?['cleanliness_level'] as int?) ?? 3,
    );
  }

  factory UserProfileModel.fromRows({
    required Map<String, dynamic> profileRow,
    required Map<String, dynamic>? preferencesRow,
  }) {
    return UserProfileModel(
      fullName: (profileRow['full_name'] as String?) ?? '',
      department: profileRow['department'] as String?,
      academicYear: profileRow['academic_year'] as int?,
      monthlyBudget: (profileRow['budget_max'] as num?)?.toDouble(),
      bio: profileRow['bio'] as String?,
      isSmoker: (preferencesRow?['is_smoker'] as bool?) ?? false,
      isNightOwl: (preferencesRow?['is_night_owl'] as bool?) ?? false,
      cleanlinessLevel: (preferencesRow?['cleanliness_level'] as int?) ?? 3,
    );
  }

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      fullName: profile.fullName,
      department: profile.department,
      academicYear: profile.academicYear,
      monthlyBudget: profile.monthlyBudget,
      bio: profile.bio,
      isSmoker: profile.isSmoker,
      isNightOwl: profile.isNightOwl,
      cleanlinessLevel: profile.cleanlinessLevel,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      fullName: fullName,
      department: department,
      academicYear: academicYear,
      monthlyBudget: monthlyBudget,
      bio: bio,
      isSmoker: isSmoker,
      isNightOwl: isNightOwl,
      cleanlinessLevel: cleanlinessLevel,
    );
  }

  Map<String, dynamic> toProfileRow({required String userId}) {
    return {
      'id': userId,
      'full_name': fullName,
      'department': department,
      'academic_year': academicYear,
      'budget_max': monthlyBudget,
      'bio': bio,
    };
  }

  Map<String, dynamic> toPreferencesRow({required String userId}) {
    return {
      'user_id': userId,
      'is_smoker': isSmoker,
      'is_night_owl': isNightOwl,
      'cleanliness_level': cleanlinessLevel,
    };
  }
}
