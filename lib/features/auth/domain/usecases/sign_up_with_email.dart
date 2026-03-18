import '../repositories/auth_repository.dart';

class SignUpWithEmail {
  SignUpWithEmail(this._repository);

  final AuthRepository _repository;

  Future<bool> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _repository.signUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
