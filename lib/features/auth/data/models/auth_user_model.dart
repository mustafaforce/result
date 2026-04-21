import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  const AuthUserModel({required this.id, required this.email, this.fullName});

  final String id;
  final String? email;
  final String? fullName;

  factory AuthUserModel.fromSupabase(User user) {
    return AuthUserModel(
      id: user.id,
      email: user.email,
      fullName: user.userMetadata?['full_name'] as String?,
    );
  }

  AuthUser toEntity() {
    return AuthUser(id: id, email: email, fullName: fullName);
  }
}
