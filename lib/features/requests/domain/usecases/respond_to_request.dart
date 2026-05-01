import '../repositories/request_repository.dart';

class RespondToRequest {
  RespondToRequest(this._repository);

  final RequestRepository _repository;

  Future<void> call({
    required String requestId,
    required bool accept,
  }) {
    return _repository.respondToRequest(requestId: requestId, accept: accept);
  }
}
