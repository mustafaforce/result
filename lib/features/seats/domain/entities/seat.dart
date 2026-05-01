class Seat {
  const Seat({
    required this.id,
    required this.ownerId,
    required this.title,
    this.description,
    required this.hallName,
    this.seatNumber,
    this.location,
    this.monthlyFee,
    this.isAvailable = true,
    this.capacity = 2,
    this.facilities = const [],
    this.occupantCount = 0,
  });

  final String id;
  final String ownerId;
  final String title;
  final String? description;
  final String hallName;
  final String? seatNumber;
  final String? location;
  final double? monthlyFee;
  final bool isAvailable;
  final int capacity;
  final List<String> facilities;
  final int occupantCount;
}
