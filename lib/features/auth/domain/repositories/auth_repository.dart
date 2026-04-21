import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();

  bool get isLoggedIn;
  AuthUser? get currentUser;
}
