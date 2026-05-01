import '../entities/seat.dart';
import '../repositories/seat_repository.dart';

class GetMySeats {
  GetMySeats(this._repository);

  final SeatRepository _repository;

  Future<List<Seat>> call() => _repository.getMySeats();
}
