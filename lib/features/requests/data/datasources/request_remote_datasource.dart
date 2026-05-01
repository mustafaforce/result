import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class RequestRemoteDataSource {
  SupabaseClient get _client => SupabaseService.client;

  Future<void> sendRequest({required String toUserId}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('roommate_requests').insert({
      'from_user_id': user.id,
      'to_user_id': toUserId,
    });
  }

  Future<void> respondToRequest({
    required String requestId,
    required bool accept,
  }) async {
    await _client
        .from('roommate_requests')
        .update({'status': accept ? 'accepted' : 'rejected'})
        .eq('id', requestId);
  }

  Future<List<Map<String, dynamic>>> getMySentRequests() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('roommate_requests')
        .select('''
          *,
          to_profile:to_user_id (full_name)
        ''')
        .eq('from_user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getMyReceivedRequests() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('roommate_requests')
        .select('''
          *,
          from_profile:from_user_id (full_name)
        ''')
        .eq('to_user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }
}
