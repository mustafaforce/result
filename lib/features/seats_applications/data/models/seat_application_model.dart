import '../../domain/entities/seat_application.dart';

class SeatApplicationModel {
  const SeatApplicationModel({
    required this.id,
    required this.seatId,
    required this.applicantId,
    required this.status,
    this.seatTitle,
    this.hallName,
    this.applicantName,
  });

  factory SeatApplicationModel.fromJson(Map<String, dynamic> json) {
    final seat = json['seat'] as Map<String, dynamic>?;
    final applicant = json['applicant_profile'] as Map<String, dynamic>?;

    return SeatApplicationModel(
      id: json['id'] as String,
      seatId: json['seat_id'] as String,
      applicantId: json['applicant_id'] as String,
      status: json['status'] as String? ?? 'pending',
      seatTitle: seat?['title'] as String?,
      hallName: seat?['hall_name'] as String?,
      applicantName: applicant?['full_name'] as String?,
    );
  }

  final String id;
  final String seatId;
  final String applicantId;
  final String status;
  final String? seatTitle;
  final String? hallName;
  final String? applicantName;

  SeatApplication toEntity() {
    return SeatApplication(
      id: id,
      seatId: seatId,
      applicantId: applicantId,
      status: status,
      seatTitle: seatTitle,
      hallName: hallName,
      applicantName: applicantName,
    );
  }
}
