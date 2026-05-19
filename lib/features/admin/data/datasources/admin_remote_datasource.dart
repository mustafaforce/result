import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';

class AdminRemoteDataSource {
  SupabaseClient get _client => SupabaseService.client;

  Future<int> getUserCount() async {
    final response = await _client.from('profiles').select('id');
    return (response as List).length;
  }

  Future<int> getSeatCount() async {
    final response = await _client.from('seats').select('id');
    return (response as List).length;
  }

  Future<int> getPendingSeatApplications() async {
    final response = await _client
        .from('seat_applications')
        .select('id')
        .eq('status', 'pending');
    return (response as List).length;
  }

  Future<int> getPendingRoommateRequests() async {
    final response = await _client
        .from('roommate_requests')
        .select('id')
        .eq('status', 'pending');
    return (response as List).length;
  }

  Future<List<Map<String, dynamic>>> getRecentUsers({int limit = 5}) async {
    final response = await _client
        .from('profiles')
        .select('id, full_name, department, academic_year, created_at, is_verified, is_flagged')
        .order('created_at', ascending: false)
        .limit(limit);
    final users = (response as List).cast<Map<String, dynamic>>();
    return _attachAssignedSeats(users);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _client
        .from('profiles')
        .select('id, full_name, department, academic_year, created_at, is_verified, is_flagged')
        .order('created_at', ascending: false);
    final users = (response as List).cast<Map<String, dynamic>>();
    return _attachAssignedSeats(users);
  }

  /// For each user, attaches an `assigned_seat` map ({hall_name, seat_number, title})
  /// if they have an approved seat_application. Null otherwise.
  Future<List<Map<String, dynamic>>> _attachAssignedSeats(
    List<Map<String, dynamic>> users,
  ) async {
    if (users.isEmpty) return users;
    final ids = users.map((u) => u['id'] as String).toList();

    final apps = await _client
        .from('seat_applications')
        .select('applicant_id, seat:seat_id (hall_name, seat_number, title)')
        .eq('status', 'approved')
        .inFilter('applicant_id', ids);

    final byUser = <String, Map<String, dynamic>>{};
    for (final a in (apps as List)) {
      final seat = a['seat'] as Map<String, dynamic>?;
      if (seat != null) {
        byUser[a['applicant_id'] as String] = seat;
      }
    }

    for (final u in users) {
      u['assigned_seat'] = byUser[u['id']];
    }
    return users;
  }

  Future<Map<String, dynamic>?> getProfileById(String userId) async {
    final response = await _client
        .from('profiles')
        .select(
            '*, user_preferences (*), matching_preferences (*)')
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  Future<void> setUserVerified({required String userId, required bool verified}) async {
    await _client.from('profiles').update({'is_verified': verified}).eq('id', userId);
  }

  Future<void> setUserFlagged({required String userId, required bool flagged}) async {
    await _client.from('profiles').update({'is_flagged': flagged}).eq('id', userId);
  }
  
  Future<List<Map<String, dynamic>>> getPerSeatCapacity() async {
    final seats = await _client
        .from('seats')
        .select('id, title, hall_name, seat_number, capacity')
        .order('hall_name', ascending: true);

    final approved = await _client
        .from('seat_applications')
        .select('seat_id')
        .eq('status', 'approved');

    final occupiedCounts = <String, int>{};
    for (final r in (approved as List)) {
      final id = r['seat_id'] as String;
      occupiedCounts[id] = (occupiedCounts[id] ?? 0) + 1;
    }

    return (seats as List).map((s) {
      final id = s['id'] as String;
      final capacity = (s['capacity'] as num?)?.toInt() ?? 0;
      final occupied = occupiedCounts[id] ?? 0;
      final free = (capacity - occupied).clamp(0, capacity);
      return {
        'seat_id': id,
        'title': s['title'],
        'hall_name': s['hall_name'],
        'seat_number': s['seat_number'],
        'capacity': capacity,
        'occupied': occupied,
        'free': free,
      };
    }).toList();
  }

  /// Returns (totalCapacity, occupied, free) across all seats.
  /// occupied = count of approved seat_applications.
  Future<({int total, int occupied, int free})> getCapacityStats() async {
    final seats = await _client.from('seats').select('id, capacity');
    final total = (seats as List).fold<int>(
      0,
      (sum, s) => sum + ((s['capacity'] as num?)?.toInt() ?? 0),
    );

    final approved = await _client
        .from('seat_applications')
        .select('id')
        .eq('status', 'approved');
    final occupied = (approved as List).length;

    final free = (total - occupied).clamp(0, total);
    return (total: total, occupied: occupied, free: free);
  }
}
