import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );

    return response.session == null;
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
  }

  @override
  bool get isLoggedIn => _remoteDataSource.currentUser != null;

  @override
  User? get currentUser => _remoteDataSource.currentUser;
}
