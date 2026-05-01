class Rating {
  const Rating({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.reviewText,
    this.revieweeName,
  });

  final String id;
  final String reviewerId;
  final String revieweeId;
  final int rating;
  final String? reviewText;
  final String? revieweeName;
}
