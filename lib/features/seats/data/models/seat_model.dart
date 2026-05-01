import '../../domain/entities/seat.dart';

class SeatModel {
  const SeatModel({
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

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      hallName: json['hall_name'] as String? ?? '',
      seatNumber: json['seat_number'] as String?,
      location: json['location'] as String?,
      monthlyFee: (json['monthly_fee'] as num?)?.toDouble(),
      isAvailable: json['is_available'] as bool? ?? true,
      capacity: (json['capacity'] as num?)?.toInt() ?? 2,
      facilities: (json['facilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      occupantCount: (json['occupant_count'] as num?)?.toInt() ?? 0,
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'owner_id': ownerId,
      'title': title,
      'description': description,
      'hall_name': hallName,
      'seat_number': seatNumber,
      'location': location,
      'monthly_fee': monthlyFee,
      'is_available': isAvailable,
      'capacity': capacity,
      'facilities': facilities,
    };
  }

  Seat toEntity() {
    return Seat(
      id: id,
      ownerId: ownerId,
      title: title,
      description: description,
      hallName: hallName,
      seatNumber: seatNumber,
      location: location,
      monthlyFee: monthlyFee,
      isAvailable: isAvailable,
      capacity: capacity,
      facilities: facilities,
      occupantCount: occupantCount,
    );
  }

  factory SeatModel.fromEntity(Seat entity) {
    return SeatModel(
      id: entity.id,
      ownerId: entity.ownerId,
      title: entity.title,
      description: entity.description,
      hallName: entity.hallName,
      seatNumber: entity.seatNumber,
      location: entity.location,
      monthlyFee: entity.monthlyFee,
      isAvailable: entity.isAvailable,
      capacity: entity.capacity,
      facilities: entity.facilities,
      occupantCount: entity.occupantCount,
    );
  }
}
