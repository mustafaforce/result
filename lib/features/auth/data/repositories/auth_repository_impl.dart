import '../../domain/entities/auth_user.dart';
import '../../domain/errors/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _remoteDataSource.signIn(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      return response.session == null;
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  bool get isLoggedIn => _remoteDataSource.currentUser != null;

  AuthUserModel? get _currentUserModel {
    final user = _remoteDataSource.currentUser;
    if (user == null) {
      return null;
    }
    return AuthUserModel.fromSupabase(user);
  }

  @override
  AuthUser? get currentUser => _currentUserModel?.toEntity();
}
