import '../../domain/entities/rating.dart';

class RatingModel {
  const RatingModel({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.reviewText,
    this.revieweeName,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final reviewee = json['reviewee_profile'] as Map<String, dynamic>?;

    return RatingModel(
      id: json['id'] as String,
      reviewerId: json['reviewer_id'] as String,
      revieweeId: json['reviewee_id'] as String,
      rating: (json['rating'] as num).toInt(),
      reviewText: json['review_text'] as String?,
      revieweeName: reviewee?['full_name'] as String?,
    );
  }

  final String id;
  final String reviewerId;
  final String revieweeId;
  final int rating;
  final String? reviewText;
  final String? revieweeName;

  Map<String, dynamic> toInsertJson() {
    return {
      'reviewer_id': reviewerId,
      'reviewee_id': revieweeId,
      'rating': rating,
      'review_text': reviewText,
    };
  }

  Rating toEntity() {
    return Rating(
      id: id,
      reviewerId: reviewerId,
      revieweeId: revieweeId,
      rating: rating,
      reviewText: reviewText,
      revieweeName: revieweeName,
    );
  }
}
