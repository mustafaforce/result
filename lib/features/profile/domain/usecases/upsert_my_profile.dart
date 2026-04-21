import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpsertMyProfile {
  UpsertMyProfile(this._repository);

  final ProfileRepository _repository;

  Future<void> call(UserProfile profile) {
    return _repository.upsertMyProfile(profile);
  }
}
