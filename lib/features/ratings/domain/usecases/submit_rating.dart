import '../repositories/rating_repository.dart';

class SubmitRating {
  SubmitRating(this._repository);

  final RatingRepository _repository;

  Future<void> call({
    required String revieweeId,
    required int rating,
    String? reviewText,
  }) {
    return _repository.submitRating(
      revieweeId: revieweeId,
      rating: rating,
      reviewText: reviewText,
    );
  }
}
