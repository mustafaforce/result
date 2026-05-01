import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class MatchingRemoteDataSource {
  SupabaseClient get _client => SupabaseService.client;

  Future<Map<String, dynamic>?> getMyPreferences() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return _client
        .from('matching_preferences')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();
  }

  Future<void> upsertMyPreferences(Map<String, dynamic> json) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    json['user_id'] = user.id;
    await _client.from('matching_preferences').upsert(json);
  }

  Future<Map<String, dynamic>?> getMyProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return _client
        .from('profiles')
        .select('''
          *,
          user_preferences (*),
          matching_preferences (*)
        ''')
        .eq('id', user.id)
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> getAllCandidates() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final profiles = await _client
        .from('profiles')
        .select('''
          *,
          user_preferences (*),
          matching_preferences (*)
        ''')
        .neq('id', user.id);

    return (profiles as List).cast<Map<String, dynamic>>();
  }
}
