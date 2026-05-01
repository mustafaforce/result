import '../entities/seat.dart';
import '../repositories/seat_repository.dart';

class UpdateSeat {
  UpdateSeat(this._repository);

  final SeatRepository _repository;

  Future<void> call(Seat seat) => _repository.updateSeat(seat);
}
