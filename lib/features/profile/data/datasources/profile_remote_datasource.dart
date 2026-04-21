import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class ProfileRemoteDataSource {
  SupabaseClient get _client => SupabaseService.client;

  String get _userId {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('User is not logged in.');
    }
    return user.id;
  }

  Future<(Map<String, dynamic>?, Map<String, dynamic>?)>
  getMyProfileRows() async {
    final userId = _userId;

    final profileRow = await _client
        .from('profiles')
        .select('full_name, department, academic_year, budget_max, bio')
        .eq('id', userId)
        .maybeSingle();

    final preferencesRow = await _client
        .from('user_preferences')
        .select('is_smoker, is_night_owl, cleanliness_level')
        .eq('user_id', userId)
        .maybeSingle();

    return (profileRow, preferencesRow);
  }

  Future<void> upsertProfileRows({
    required Map<String, dynamic> profileRow,
    required Map<String, dynamic> preferencesRow,
  }) async {
    await _client.from('profiles').upsert(profileRow, onConflict: 'id');
    await _client
        .from('user_preferences')
        .upsert(preferencesRow, onConflict: 'user_id');
  }

  String get currentUserId => _userId;
}
