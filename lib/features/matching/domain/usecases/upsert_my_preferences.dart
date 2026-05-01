import '../entities/matching_preference.dart';
import '../repositories/matching_repository.dart';

class UpsertMyPreferences {
  UpsertMyPreferences(this._repository);

  final MatchingRepository _repository;

  Future<void> call(MatchingPreference preferences) =>
      _repository.upsertMyPreferences(preferences);
}
