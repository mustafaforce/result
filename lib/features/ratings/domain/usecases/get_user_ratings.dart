import '../entities/rating.dart';
import '../repositories/rating_repository.dart';

class GetUserRatings {
  GetUserRatings(this._repository);

  final RatingRepository _repository;

  Future<List<Rating>> call(String userId) =>
      _repository.getRatingsForUser(userId);
}
