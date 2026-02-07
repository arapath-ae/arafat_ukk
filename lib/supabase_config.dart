import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://sqhppuqezjqsxmmqljwl.supabase.co';
  static const String anonKey = 'sb_publishable_aRPVmuvtdsnlOel2AOfr4w_J5cC2IBr';

  static Future<void> init() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }
}

// Variabel ini yang dicari oleh login.dart
final supabase = Supabase.instance.client;