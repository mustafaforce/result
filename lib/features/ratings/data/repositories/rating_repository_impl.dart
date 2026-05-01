import '../../domain/entities/rating.dart';
import '../../domain/errors/rating_failure.dart';
import '../../domain/repositories/rating_repository.dart';
import '../datasources/rating_remote_datasource.dart';
import '../models/rating_model.dart';

class RatingRepositoryImpl implements RatingRepository {
  RatingRepositoryImpl(this._remoteDataSource);

  final RatingRemoteDataSource _remoteDataSource;

  @override
  Future<void> submitRating({
    required String revieweeId,
    required int rating,
    String? reviewText,
  }) async {
    try {
      await _remoteDataSource.submitRating({
        'reviewee_id': revieweeId,
        'rating': rating,
        'review_text': reviewText,
      });
    } on RatingFailure {
      rethrow;
    } catch (e) {
      throw const RatingFailure('Failed to submit rating.');
    }
  }

  @override
  Future<List<Rating>> getRatingsForUser(String userId) async {
    try {
      final rows = await _remoteDataSource.getRatingsForUser(userId);
      return rows
          .map((r) => RatingModel.fromJson(r).toEntity())
          .toList();
    } catch (e) {
      throw const RatingFailure('Failed to load ratings.');
    }
  }

  @override
  Future<double?> getAverageRating(String userId) async {
    try {
      final avg = await _remoteDataSource.getAverageRating(userId);
      return avg?.toDouble();
    } catch (e) {
      return null;
    }
  }
}
