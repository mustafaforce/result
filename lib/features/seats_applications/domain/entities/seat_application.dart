class SeatApplication {
  const SeatApplication({
    required this.id,
    required this.seatId,
    required this.applicantId,
    required this.status,
    this.seatTitle,
    this.hallName,
    this.applicantName,
  });

  final String id;
  final String seatId;
  final String applicantId;
  final String status;
  final String? seatTitle;
  final String? hallName;
  final String? applicantName;

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}
