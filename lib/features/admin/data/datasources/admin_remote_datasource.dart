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
    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await _client
        .from('profiles')
        .select('id, full_name, department, academic_year, created_at, is_verified, is_flagged')
        .order('created_at', ascending: false);
    return (response as List).cast<Map<String, dynamic>>();
  }

  Future<void> setUserVerified({required String userId, required bool verified}) async {
    await _client.from('profiles').update({'is_verified': verified}).eq('id', userId);
  }

  Future<void> setUserFlagged({required String userId, required bool flagged}) async {
    await _client.from('profiles').update({'is_flagged': flagged}).eq('id', userId);
  }
}
