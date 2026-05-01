import '../../domain/entities/roommate_request.dart';

class RoommateRequestModel {
  const RoommateRequestModel({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    this.fromUserName,
    this.toUserName,
  });

  factory RoommateRequestModel.fromJson(Map<String, dynamic> json) {
    return RoommateRequestModel(
      id: json['id'] as String,
      fromUserId: json['from_user_id'] as String,
      toUserId: json['to_user_id'] as String,
      status: json['status'] as String? ?? 'pending',
      fromUserName: json['from_profile'] is Map
          ? (json['from_profile'] as Map)['full_name'] as String?
          : null,
      toUserName: json['to_profile'] is Map
          ? (json['to_profile'] as Map)['full_name'] as String?
          : null,
    );
  }

  final String id;
  final String fromUserId;
  final String toUserId;
  final String status;
  final String? fromUserName;
  final String? toUserName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_user_id': fromUserId,
      'to_user_id': toUserId,
      'status': status,
    };
  }

  RoommateRequest toEntity() {
    return RoommateRequest(
      id: id,
      fromUserId: fromUserId,
      toUserId: toUserId,
      status: status,
      fromUserName: fromUserName,
      toUserName: toUserName,
    );
  }
}
