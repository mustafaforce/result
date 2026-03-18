import '../repositories/auth_repository.dart';

class SignInWithEmail {
  SignInWithEmail(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
