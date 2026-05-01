import '../repositories/request_repository.dart';

class SendRoommateRequest {
  SendRoommateRequest(this._repository);

  final RequestRepository _repository;

  Future<void> call({required String toUserId}) {
    return _repository.sendRequest(toUserId: toUserId);
  }
}
