import '../entities/seat.dart';
import '../repositories/seat_repository.dart';

class CreateSeat {
  CreateSeat(this._repository);

  final SeatRepository _repository;

  Future<void> call(Seat seat) => _repository.createSeat(seat);
}
