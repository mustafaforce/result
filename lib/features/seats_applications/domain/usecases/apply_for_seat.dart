import '../repositories/application_repository.dart';

class ApplyForSeat {
  ApplyForSeat(this._repository);

  final ApplicationRepository _repository;

  Future<void> call({required String seatId}) {
    return _repository.applyForSeat(seatId: seatId);
  }
}
