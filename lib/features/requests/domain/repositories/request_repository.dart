import '../entities/roommate_request.dart';

abstract class RequestRepository {
  Future<void> sendRequest({required String toUserId});
  Future<void> respondToRequest({
    required String requestId,
    required bool accept,
  });
  Future<List<RoommateRequest>> getMySentRequests();
  Future<List<RoommateRequest>> getMyReceivedRequests();
}
