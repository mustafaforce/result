import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile?> getMyProfile();

  Future<void> upsertMyProfile(UserProfile profile);
}
