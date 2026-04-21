import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthException, PostgrestException;

import '../../domain/entities/user_profile.dart';
import '../../domain/errors/profile_failure.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile?> getMyProfile() async {
    try {
      final (profileRow, preferencesRow) = await _remoteDataSource
          .getMyProfileRows();

      if (profileRow == null) {
        return null;
      }

      final model = UserProfileModel.fromRows(
        profileRow: profileRow,
        preferencesRow: preferencesRow,
      );
      return model.toEntity();
    } on AuthException catch (e) {
      throw ProfileFailure(e.message);
    } on PostgrestException catch (e) {
      throw ProfileFailure(_mapDatabaseError(e));
    }
  }

  @override
  Future<void> upsertMyProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel.fromEntity(profile);
      final userId = _remoteDataSource.currentUserId;
      await _remoteDataSource.upsertProfileRows(
        profileRow: model.toProfileRow(userId: userId),
        preferencesRow: model.toPreferencesRow(userId: userId),
      );
    } on AuthException catch (e) {
      throw ProfileFailure(e.message);
    } on PostgrestException catch (e) {
      throw ProfileFailure(_mapDatabaseError(e));
    }
  }

  String _mapDatabaseError(PostgrestException error) {
    final message = error.message.toLowerCase();
    if (message.contains('profiles_academic_year_check')) {
      return 'Academic year must be between 1 and 8.';
    }
    return error.message;
  }
}
