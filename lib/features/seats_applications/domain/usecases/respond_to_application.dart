import '../repositories/application_repository.dart';

class RespondToApplication {
  RespondToApplication(this._repository);

  final ApplicationRepository _repository;

  Future<void> call({
    required String applicationId,
    required bool accept,
  }) {
    return _repository.respondToApplication(
      applicationId: applicationId,
      accept: accept,
    );
  }
}
