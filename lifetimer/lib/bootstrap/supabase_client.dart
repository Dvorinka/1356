import 'package:supabase_flutter/supabase_flutter.dart';

void initializeSupabaseClient() {
  // Additional client setup if needed
  // For now, we use the default Supabase.instance.client
}

SupabaseClient get supabaseClient => Supabase.instance.client;
