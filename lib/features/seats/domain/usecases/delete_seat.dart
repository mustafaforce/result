import '../repositories/seat_repository.dart';

class DeleteSeat {
  DeleteSeat(this._repository);

  final SeatRepository _repository;

  Future<void> call(String seatId) => _repository.deleteSeat(seatId);
}
