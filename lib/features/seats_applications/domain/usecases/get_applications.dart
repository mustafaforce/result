import '../entities/seat_application.dart';
import '../repositories/application_repository.dart';

class GetApplications {
  GetApplications(this._repository);

  final ApplicationRepository _repository;

  Future<List<SeatApplication>> mine() =>
      _repository.getMyApplications();

  Future<List<SeatApplication>> forMySeats() =>
      _repository.getApplicationsForMySeats();

  Future<List<SeatApplication>> all({bool pendingOnly = false}) =>
      _repository.getAllApplications(pendingOnly: pendingOnly);

  Future<bool> hasActive() => _repository.hasActiveApplication();

  Future<List<String>> myAppliedSeatIds() => _repository.getMyAppliedSeatIds();
}
