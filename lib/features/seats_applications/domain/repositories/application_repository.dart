import '../entities/seat_application.dart';

abstract class ApplicationRepository {
  Future<void> applyForSeat({required String seatId});
  Future<void> respondToApplication({
    required String applicationId,
    required bool accept,
  });
  Future<List<SeatApplication>> getMyApplications();
  Future<List<SeatApplication>> getApplicationsForMySeats();
  Future<List<SeatApplication>> getAllApplications({bool pendingOnly = false});
  Future<bool> hasActiveApplication();
  Future<List<String>> getMyAppliedSeatIds();
}
