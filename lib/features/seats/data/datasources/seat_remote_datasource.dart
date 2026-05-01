import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class SeatRemoteDataSource {
  SupabaseClient get _client => SupabaseService.client;

  Future<List<Map<String, dynamic>>> getAllAvailable() async {
    final response = await _client
        .from('seats')
        .select()
        .eq('is_available', true)
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getMySeats() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('seats')
        .select()
        .eq('owner_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<void> createSeat(Map<String, dynamic> json) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');
    json['owner_id'] = user.id;
    await _client.from('seats').insert(json);
  }

  Future<void> updateSeat(Map<String, dynamic> json) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');
    json['owner_id'] = user.id;
    await _client.from('seats').upsert(json);
  }

  Future<void> deleteSeat(String seatId) async {
    await _client.from('seats').delete().eq('id', seatId);
  }

  Future<Map<String, int>> getOccupantCounts(List<String> seatIds) async {
    if (seatIds.isEmpty) return {};

    final response = await _client
        .from('seat_applications')
        .select('seat_id')
        .filter('seat_id', 'in', '(${seatIds.join(',')})')
        .eq('status', 'approved');

    final counts = <String, int>{};
    for (final id in seatIds) {
      counts[id] = 0;
    }
    for (final row in response as List) {
      final sid = row['seat_id'] as String;
      counts[sid] = (counts[sid] ?? 0) + 1;
    }
    return counts;
  }

  Future<List<Map<String, dynamic>>> getOccupants(String seatId) async {
    final response = await _client
        .from('seat_applications')
        .select('applicant_id, applicant_profile:applicant_id (full_name, department, academic_year)')
        .eq('seat_id', seatId)
        .eq('status', 'approved');

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, Map<String, dynamic>>> getOccupantPrefs(
      List<String> userIds) async {
    if (userIds.isEmpty) return {};

    final response = await _client
        .from('user_preferences')
        .select('user_id, is_smoker, is_night_owl, cleanliness_level')
        .filter('user_id', 'in', '(${userIds.join(',')})');

    final result = <String, Map<String, dynamic>>{};
    for (final row in (response as List).cast<Map<String, dynamic>>()) {
      result[row['user_id'] as String] = row;
    }
    return result;
  }

  Future<Map<String, Map<String, dynamic>>> getOccupantMatchingPrefs(
      List<String> userIds) async {
    if (userIds.isEmpty) return {};

    final response = await _client
        .from('matching_preferences')
        .select('user_id, study_habit, guest_frequency, noise_tolerance, sleep_time, sharing_preference')
        .filter('user_id', 'in', '(${userIds.join(',')})');

    final result = <String, Map<String, dynamic>>{};
    for (final row in (response as List).cast<Map<String, dynamic>>()) {
      result[row['user_id'] as String] = row;
    }
    return result;
  }
}
