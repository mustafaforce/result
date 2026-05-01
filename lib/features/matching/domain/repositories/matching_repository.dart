import '../entities/matching_preference.dart';
import '../../../profile/domain/entities/user_profile.dart';

class CandidateData {
  const CandidateData({
    required this.userId,
    required this.profile,
    required this.preferences,
  });

  final String userId;
  final UserProfile profile;
  final MatchingPreference preferences;
}

abstract class MatchingRepository {
  Future<MatchingPreference?> getMyPreferences();
  Future<void> upsertMyPreferences(MatchingPreference preferences);

  /// Returns current user's full data (profile + prefs) for self-scoring
  Future<CandidateData?> getMyCandidateData();

  /// Returns all other users' profile + matching prefs for scoring
  Future<List<CandidateData>> getAllCandidates();
}
