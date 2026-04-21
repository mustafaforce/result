import '../../core/services/supabase_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_auth_user.dart';
import '../../features/auth/domain/usecases/is_user_logged_in.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_out_user.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_my_profile.dart';
import '../../features/profile/domain/usecases/upsert_my_profile.dart';

class AppDependencies {
  AppDependencies._(
    AuthRepository authRepository,
    ProfileRepository profileRepository,
  ) : signInWithEmail = SignInWithEmail(authRepository),
      signUpWithEmail = SignUpWithEmail(authRepository),
      signOutUser = SignOutUser(authRepository),
      isUserLoggedIn = IsUserLoggedIn(authRepository),
      getCurrentAuthUser = GetCurrentAuthUser(authRepository),
      getMyProfile = GetMyProfile(profileRepository),
      upsertMyProfile = UpsertMyProfile(profileRepository);

  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOutUser signOutUser;
  final IsUserLoggedIn isUserLoggedIn;
  final GetCurrentAuthUser getCurrentAuthUser;
  final GetMyProfile getMyProfile;
  final UpsertMyProfile upsertMyProfile;

  static Future<AppDependencies> initialize() async {
    await SupabaseService.initialize();

    final remoteDataSource = AuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(remoteDataSource);
    final profileRemoteDataSource = ProfileRemoteDataSource();
    final profileRepository = ProfileRepositoryImpl(profileRemoteDataSource);

    return AppDependencies._(authRepository, profileRepository);
  }
}
