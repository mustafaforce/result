import '../entities/rating.dart';

abstract class RatingRepository {
  Future<void> submitRating({
    required String revieweeId,
    required int rating,
    String? reviewText,
  });
  Future<List<Rating>> getRatingsForUser(String userId);
  Future<double?> getAverageRating(String userId);
}
