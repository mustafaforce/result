import '../entities/matching_preference.dart';
import '../repositories/matching_repository.dart';

class GetMyPreferences {
  GetMyPreferences(this._repository);

  final MatchingRepository _repository;

  Future<MatchingPreference?> call() => _repository.getMyPreferences();
}
