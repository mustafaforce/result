import '../entities/matching_preference.dart';
import '../../../profile/domain/entities/user_profile.dart';

class CompatibilityScorer {
  double score({
    required UserProfile myProfile,
    required MatchingPreference myPreferences,
    required UserProfile theirProfile,
    required MatchingPreference theirPreferences,
  }) {
    final scores = <double>[];
    final weights = <double>[];

    _addBoolScore(
      scores, weights,
      myProfile.isSmoker == theirProfile.isSmoker,
      15,
    );

    _addBoolScore(
      scores, weights,
      myProfile.isNightOwl == theirProfile.isNightOwl,
      10,
    );

    _addNumericScore(
      scores, weights,
      myProfile.cleanlinessLevel,
      theirProfile.cleanlinessLevel,
      1, 5,
      15,
    );

    _addEnumScore(
      scores, weights,
      myPreferences.studyHabit,
      theirPreferences.studyHabit,
      _studyHabitDistance,
      15,
    );

    _addEnumScore(
      scores, weights,
      myPreferences.guestFrequency,
      theirPreferences.guestFrequency,
      _guestFrequencyDistance,
      10,
    );

    _addNumericScore(
      scores, weights,
      myPreferences.noiseTolerance,
      theirPreferences.noiseTolerance,
      1, 5,
      10,
    );

    _addEnumScore(
      scores, weights,
      myPreferences.sleepTime,
      theirPreferences.sleepTime,
      _sleepTimeDistance,
      10,
    );

    _addEnumScore(
      scores, weights,
      myPreferences.sharingPreference,
      theirPreferences.sharingPreference,
      _sharingDistance,
      10,
    );

    if (myProfile.academicYear != null && theirProfile.academicYear != null) {
      _addNumericScore(
        scores, weights,
        myProfile.academicYear!,
        theirProfile.academicYear!,
        1, 8,
        5,
      );
    }

    if (scores.isEmpty) return 0.0;

    double totalWeighted = 0;
    double totalWeight = 0;
    for (var i = 0; i < scores.length; i++) {
      totalWeighted += scores[i] * weights[i];
      totalWeight += weights[i];
    }

    return totalWeighted / totalWeight * 100;
  }

  void _addBoolScore(
    List<double> scores,
    List<double> weights,
    bool match,
    double weight,
  ) {
    scores.add(match ? 1.0 : 0.0);
    weights.add(weight);
  }

  void _addNumericScore(
    List<double> scores,
    List<double> weights,
    int mine,
    int theirs,
    int min,
    int max,
    double weight,
  ) {
    final range = (max - min).toDouble();
    final diff = (mine - theirs).abs().toDouble();
    final normalized = range > 0 ? 1.0 - (diff / range) : 1.0;
    scores.add(normalized.clamp(0.0, 1.0));
    weights.add(weight);
  }

  void _addEnumScore(
    List<double> scores,
    List<double> weights,
    String mine,
    String theirs,
    int Function(String a, String b) distanceFn,
    double weight,
  ) {
    final distance = distanceFn(mine, theirs);
    final normalized = 1.0 - (distance / 2.0);
    scores.add(normalized.clamp(0.0, 1.0));
    weights.add(weight);
  }

  int _studyHabitDistance(String a, String b) {
    if (a == b) return 0;
    if ((a == 'quiet' && b == 'social') || (a == 'social' && b == 'quiet')) {
      return 2;
    }
    return 1;
  }

  int _guestFrequencyDistance(String a, String b) {
    if (a == b) return 0;
    if ((a == 'never' && b == 'frequent') || (a == 'frequent' && b == 'never')) {
      return 2;
    }
    return 1;
  }

  int _sleepTimeDistance(String a, String b) {
    if (a == b) return 0;
    if ((a == 'early_bird' && b == 'night_owl') ||
        (a == 'night_owl' && b == 'early_bird')) {
      return 2;
    }
    return 1;
  }

  int _sharingDistance(String a, String b) {
    if (a == b) return 0;
    if ((a == 'private' && b == 'okay_shared') ||
        (a == 'okay_shared' && b == 'private')) {
      return 2;
    }
    return 1;
  }
}
