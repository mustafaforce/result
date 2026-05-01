import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class RatingRemoteDataSource {
  SupabaseClient get _client => SupabaseService.client;

  Future<void> submitRating(Map<String, dynamic> json) async {
    await _client.from('ratings').insert(json);
  }

  Future<List<Map<String, dynamic>>> getRatingsForUser(String userId) async {
    final response = await _client
        .from('ratings')
        .select('*, reviewee_profile:reviewee_id (full_name)')
        .eq('reviewee_id', userId)
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<num?> getAverageRating(String userId) async {
    final response = await _client
        .from('ratings')
        .select('rating')
        .eq('reviewee_id', userId);

    final ratings = (response as List)
        .map((r) => (r['rating'] as num).toDouble())
        .toList();

    if (ratings.isEmpty) return null;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }
}
