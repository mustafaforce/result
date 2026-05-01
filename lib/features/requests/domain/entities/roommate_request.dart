class RoommateRequest {
  const RoommateRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    this.fromUserName,
    this.toUserName,
  });

  final String id;
  final String fromUserId;
  final String toUserId;
  final String status;
  final String? fromUserName;
  final String? toUserName;

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}
