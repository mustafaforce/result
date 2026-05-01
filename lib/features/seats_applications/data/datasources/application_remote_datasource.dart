import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class ApplicationRemoteDataSource {
  SupabaseClient get _client => SupabaseService.client;

  Future<void> applyForSeat({required String seatId}) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _client.from('seat_applications').insert({
      'seat_id': seatId,
      'applicant_id': user.id,
    });
  }

  Future<void> respondToApplication({
    required String applicationId,
    required bool accept,
  }) async {
    await _client
        .from('seat_applications')
        .update({'status': accept ? 'approved' : 'rejected'})
        .eq('id', applicationId);
  }

  Future<List<Map<String, dynamic>>> getMyApplications() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final response = await _client
        .from('seat_applications')
        .select('*, seat:seat_id (title, hall_name)')
        .eq('applicant_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getApplicationsForMySeats() async {
    final user = _client.auth.currentUser;
    if (user == null) return [];

    final ownerSeats = await _client
        .from('seats')
        .select('id')
        .eq('owner_id', user.id);

    final seatIds = (ownerSeats as List)
        .map((s) => s['id'] as String)
        .toList();

    if (seatIds.isEmpty) return [];

    final response = await _client
        .from('seat_applications')
        .select(
            '*, seat:seat_id (title, hall_name), applicant_profile:applicant_id (full_name)')
        .filter('seat_id', 'in', '(${seatIds.join(',')})')
        .order('created_at', ascending: false);

    return (response as List).cast<Map<String, dynamic>>();
  }
}
