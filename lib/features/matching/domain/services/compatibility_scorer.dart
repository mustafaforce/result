import '../entities/matching_preference.dart';
import '../../../profile/domain/entities/user_profile.dart';

class TraitScore {
  const TraitScore({
    required this.label,
    required this.mine,
    required this.theirs,
    required this.matchPercent,
    required this.weight,
  });

  final String label;
  final String mine;
  final String theirs;
  final double matchPercent;
  final double weight;
}

class ScoreResult {
  const ScoreResult({required this.overall, required this.traits});

  final double overall;
  final List<TraitScore> traits;
}

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

  /// Returns overall score (0-100) and per-trait breakdown.
  ScoreResult scoreWithBreakdown({
    required UserProfile myProfile,
    required MatchingPreference myPreferences,
    required UserProfile theirProfile,
    required MatchingPreference theirPreferences,
  }) {
    final traits = <TraitScore>[];

    traits.add(TraitScore(
      label: 'Smoking',
      mine: myProfile.isSmoker ? 'Smoker' : 'Non-smoker',
      theirs: theirProfile.isSmoker ? 'Smoker' : 'Non-smoker',
      matchPercent: myProfile.isSmoker == theirProfile.isSmoker ? 100 : 0,
      weight: 15,
    ));

    traits.add(TraitScore(
      label: 'Night owl',
      mine: myProfile.isNightOwl ? 'Yes' : 'No',
      theirs: theirProfile.isNightOwl ? 'Yes' : 'No',
      matchPercent: myProfile.isNightOwl == theirProfile.isNightOwl ? 100 : 0,
      weight: 10,
    ));

    traits.add(TraitScore(
      label: 'Cleanliness',
      mine: '${myProfile.cleanlinessLevel}/5',
      theirs: '${theirProfile.cleanlinessLevel}/5',
      matchPercent: _numericPercent(
          myProfile.cleanlinessLevel, theirProfile.cleanlinessLevel, 1, 5),
      weight: 15,
    ));

    traits.add(TraitScore(
      label: 'Study habit',
      mine: myPreferences.studyHabit,
      theirs: theirPreferences.studyHabit,
      matchPercent: _enumPercent(myPreferences.studyHabit,
          theirPreferences.studyHabit, _studyHabitDistance),
      weight: 15,
    ));

    traits.add(TraitScore(
      label: 'Guest frequency',
      mine: myPreferences.guestFrequency,
      theirs: theirPreferences.guestFrequency,
      matchPercent: _enumPercent(myPreferences.guestFrequency,
          theirPreferences.guestFrequency, _guestFrequencyDistance),
      weight: 10,
    ));

    traits.add(TraitScore(
      label: 'Noise tolerance',
      mine: '${myPreferences.noiseTolerance}/5',
      theirs: '${theirPreferences.noiseTolerance}/5',
      matchPercent: _numericPercent(myPreferences.noiseTolerance,
          theirPreferences.noiseTolerance, 1, 5),
      weight: 10,
    ));

    traits.add(TraitScore(
      label: 'Sleep time',
      mine: myPreferences.sleepTime,
      theirs: theirPreferences.sleepTime,
      matchPercent: _enumPercent(myPreferences.sleepTime,
          theirPreferences.sleepTime, _sleepTimeDistance),
      weight: 10,
    ));

    traits.add(TraitScore(
      label: 'Sharing',
      mine: myPreferences.sharingPreference,
      theirs: theirPreferences.sharingPreference,
      matchPercent: _enumPercent(myPreferences.sharingPreference,
          theirPreferences.sharingPreference, _sharingDistance),
      weight: 10,
    ));

    if (myProfile.academicYear != null && theirProfile.academicYear != null) {
      traits.add(TraitScore(
        label: 'Academic year',
        mine: 'Year ${myProfile.academicYear}',
        theirs: 'Year ${theirProfile.academicYear}',
        matchPercent: _numericPercent(
            myProfile.academicYear!, theirProfile.academicYear!, 1, 8),
        weight: 5,
      ));
    }

    double totalWeighted = 0;
    double totalWeight = 0;
    for (final t in traits) {
      totalWeighted += t.matchPercent * t.weight;
      totalWeight += t.weight;
    }
    final overall = totalWeight == 0 ? 0.0 : totalWeighted / totalWeight;
    return ScoreResult(overall: overall, traits: traits);
  }

  double _numericPercent(int mine, int theirs, int min, int max) {
    final range = (max - min).toDouble();
    if (range <= 0) return 100;
    final diff = (mine - theirs).abs().toDouble();
    return ((1.0 - (diff / range)) * 100).clamp(0.0, 100.0);
  }

  double _enumPercent(
      String mine, String theirs, int Function(String, String) distFn) {
    final d = distFn(mine, theirs);
    return ((1.0 - (d / 2.0)) * 100).clamp(0.0, 100.0);
  }
}
