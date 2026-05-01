import '../repositories/seat_repository.dart';

class GetOccupants {
  GetOccupants(this._repository);

  final SeatRepository _repository;

  Future<List<Map<String, dynamic>>> call(String seatId) =>
      _repository.getOccupants(seatId);

  Future<Map<String, Map<String, dynamic>>> callUserPrefs(
          List<String> userIds) =>
      _repository.getOccupantPrefs(userIds);

  Future<Map<String, Map<String, dynamic>>> callMatchingPrefs(
          List<String> userIds) =>
      _repository.getOccupantMatchingPrefs(userIds);
}
