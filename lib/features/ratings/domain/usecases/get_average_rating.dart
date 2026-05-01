import '../repositories/rating_repository.dart';

class GetAverageRating {
  GetAverageRating(this._repository);

  final RatingRepository _repository;

  Future<double?> call(String userId) =>
      _repository.getAverageRating(userId);
}
