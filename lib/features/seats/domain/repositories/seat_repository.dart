import '../entities/seat.dart';

abstract class SeatRepository {
  Future<List<Seat>> getAllAvailable();
  Future<List<Seat>> getMySeats();
  Future<void> createSeat(Seat seat);
  Future<void> updateSeat(Seat seat);
  Future<void> deleteSeat(String seatId);
  Future<List<Map<String, dynamic>>> getOccupants(String seatId);
  Future<Map<String, Map<String, dynamic>>> getOccupantPrefs(
      List<String> userIds);
  Future<Map<String, Map<String, dynamic>>> getOccupantMatchingPrefs(
      List<String> userIds);
}
