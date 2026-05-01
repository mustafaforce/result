import '../../domain/entities/matching_preference.dart';

class MatchingPreferenceModel {
  const MatchingPreferenceModel({
    required this.studyHabit,
    required this.guestFrequency,
    required this.noiseTolerance,
    required this.sleepTime,
    required this.sharingPreference,
  });

  factory MatchingPreferenceModel.fromJson(Map<String, dynamic> json) {
    return MatchingPreferenceModel(
      studyHabit: json['study_habit'] as String? ?? 'moderate',
      guestFrequency: json['guest_frequency'] as String? ?? 'occasional',
      noiseTolerance: (json['noise_tolerance'] as num?)?.toInt() ?? 3,
      sleepTime: json['sleep_time'] as String? ?? 'flexible',
      sharingPreference: json['sharing_preference'] as String? ?? 'flexible',
    );
  }

  final String studyHabit;
  final String guestFrequency;
  final int noiseTolerance;
  final String sleepTime;
  final String sharingPreference;

  Map<String, dynamic> toJson() {
    return {
      'study_habit': studyHabit,
      'guest_frequency': guestFrequency,
      'noise_tolerance': noiseTolerance,
      'sleep_time': sleepTime,
      'sharing_preference': sharingPreference,
    };
  }

  MatchingPreference toEntity() {
    return MatchingPreference(
      studyHabit: studyHabit,
      guestFrequency: guestFrequency,
      noiseTolerance: noiseTolerance,
      sleepTime: sleepTime,
      sharingPreference: sharingPreference,
    );
  }

  factory MatchingPreferenceModel.fromEntity(MatchingPreference entity) {
    return MatchingPreferenceModel(
      studyHabit: entity.studyHabit,
      guestFrequency: entity.guestFrequency,
      noiseTolerance: entity.noiseTolerance,
      sleepTime: entity.sleepTime,
      sharingPreference: entity.sharingPreference,
    );
  }
}
