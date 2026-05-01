import '../../domain/entities/matching_preference.dart';
import '../../domain/errors/matching_failure.dart';
import '../../domain/repositories/matching_repository.dart';
import '../../data/models/matching_preference_model.dart';
import '../../../profile/data/models/user_profile_model.dart';
import '../datasources/matching_remote_datasource.dart';

class MatchingRepositoryImpl implements MatchingRepository {
  MatchingRepositoryImpl(this._remoteDataSource);

  final MatchingRemoteDataSource _remoteDataSource;

  @override
  Future<MatchingPreference?> getMyPreferences() async {
    try {
      final json = await _remoteDataSource.getMyPreferences();
      if (json == null) return null;
      return MatchingPreferenceModel.fromJson(json).toEntity();
    } on MatchingFailure {
      rethrow;
    } catch (e) {
      throw const MatchingFailure('Failed to load preferences.');
    }
  }

  @override
  Future<void> upsertMyPreferences(MatchingPreference preferences) async {
    try {
      final model = MatchingPreferenceModel.fromEntity(preferences);
      await _remoteDataSource.upsertMyPreferences(model.toJson());
    } on MatchingFailure {
      rethrow;
    } catch (e) {
      throw const MatchingFailure('Failed to save preferences.');
    }
  }

  @override
  Future<CandidateData?> getMyCandidateData() async {
    try {
      final json = await _remoteDataSource.getMyProfile();
      if (json == null) return null;

      final uid = json['id'] as String?;
      if (uid == null) return null;

      final profileModel = UserProfileModel.fromJson(json);
      final prefsJson = json['matching_preferences'] as Map<String, dynamic>?;
      if (prefsJson == null) return null;

      final prefsModel = MatchingPreferenceModel.fromJson(prefsJson);
      return CandidateData(
        userId: uid,
        profile: profileModel.toEntity(),
        preferences: prefsModel.toEntity(),
      );
    } catch (e) {
      throw const MatchingFailure('Failed to load profile data.');
    }
  }

  @override
  Future<List<CandidateData>> getAllCandidates() async {
    try {
      final rows = await _remoteDataSource.getAllCandidates();
      final candidates = <CandidateData>[];

      for (final row in rows) {
        final uid = row['id'] as String?;
        if (uid == null) continue;

        final profileModel = UserProfileModel.fromJson(row);
        final prefsJson = row['matching_preferences'] as Map<String, dynamic>?;
        if (prefsJson == null) continue;

        try {
          final prefsModel = MatchingPreferenceModel.fromJson(prefsJson);
          candidates.add(CandidateData(
            userId: uid,
            profile: profileModel.toEntity(),
            preferences: prefsModel.toEntity(),
          ));
        } catch (_) {
          continue;
        }
      }

      return candidates;
    } catch (e) {
      throw const MatchingFailure('Failed to load candidates.');
    }
  }
}
