import '../repositories/auth_repository.dart';

class SignOutUser {
  SignOutUser(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.signOut();
  }
}
