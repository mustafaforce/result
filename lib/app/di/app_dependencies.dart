import '../../core/services/supabase_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_out_user.dart';
import '../../features/auth/domain/usecases/sign_up_with_email.dart';

class AppDependencies {
  AppDependencies._({required this.authRepository})
    : signInWithEmail = SignInWithEmail(authRepository),
      signUpWithEmail = SignUpWithEmail(authRepository),
      signOutUser = SignOutUser(authRepository);

  final AuthRepository authRepository;
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOutUser signOutUser;

  static Future<AppDependencies> initialize() async {
    await SupabaseService.initialize();

    final remoteDataSource = AuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(remoteDataSource);

    return AppDependencies._(authRepository: authRepository);
  }
}
