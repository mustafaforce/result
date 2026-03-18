import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/env_keys.dart';

class SupabaseService {
  const SupabaseService._();

  static Future<void> initialize() async {
    final url = dotenv.env[EnvKeys.supabaseUrl];
    final anonKey = dotenv.env[EnvKeys.supabaseAnonKey];

    if (url == null || url.isEmpty) {
      throw Exception('Missing SUPABASE_URL in .env file');
    }

    if (anonKey == null || anonKey.isEmpty) {
      throw Exception('Missing SUPABASE_ANON_KEY in .env file');
    }

    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
