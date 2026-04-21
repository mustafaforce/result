import '../repositories/auth_repository.dart';

class IsUserLoggedIn {
  IsUserLoggedIn(this._repository);

  final AuthRepository _repository;

  bool call() {
    return _repository.isLoggedIn;
  }
}
