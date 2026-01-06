import 'package:supabase_flutter/supabase_flutter.dart';

void initializeSupabaseClient() {
  // Additional client setup if needed
  // For now, we use the default Supabase.instance.client
}

SupabaseClient get supabaseClient => Supabase.instance.client;

// Service role client for admin operations (like creating user profiles)
// This should be used server-side or with proper security measures
SupabaseClient? _serviceRoleClient;

SupabaseClient getServiceRoleClient() {
  if (_serviceRoleClient != null) return _serviceRoleClient!;
  
  // Note: In a production app, the service role key should be stored securely
  // This is typically handled server-side via Edge Functions or similar
  // For now, we'll fall back to the regular client if service role is not available
  try {
    const serviceRoleKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY');
    const url = String.fromEnvironment('SUPABASE_URL');
    
    if (serviceRoleKey.isNotEmpty && url.isNotEmpty) {
      _serviceRoleClient = SupabaseClient(url, serviceRoleKey);
      return _serviceRoleClient!;
    }
  } catch (e) {
    // Service role key not available, will use regular client
  }
  
  return supabaseClient;
}
