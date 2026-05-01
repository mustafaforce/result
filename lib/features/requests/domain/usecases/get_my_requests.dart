import '../entities/roommate_request.dart';
import '../repositories/request_repository.dart';

class GetMyRequests {
  GetMyRequests(this._repository);

  final RequestRepository _repository;

  Future<List<RoommateRequest>> sent() => _repository.getMySentRequests();
  Future<List<RoommateRequest>> received() =>
      _repository.getMyReceivedRequests();
}
