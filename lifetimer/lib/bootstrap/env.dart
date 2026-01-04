class Env {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  static const String unsplashAccessKey = String.fromEnvironment(
    'UNSPLASH_ACCESS_KEY',
    defaultValue: 'your-unsplash-access-key',
  );

  static const String unsplashSecretKey = String.fromEnvironment(
    'UNSPLASH_SECRET_KEY',
    defaultValue: '',
  );

  static const String unsplashMode = String.fromEnvironment(
    'UNSPLASH_MODE',
    defaultValue: 'TRUE',
  );

  static const String pexelsApiKey = String.fromEnvironment(
    'PEXELS_API_KEY',
    defaultValue: 'your-pexels-api-key',
  );

  static const String pexelsMode = String.fromEnvironment(
    'PEXELS_MODE',
    defaultValue: 'TRUE',
  );

  static const String mistralApiKey = String.fromEnvironment(
    'MISTRAL_API_KEY',
    defaultValue: 'your-mistral-api-key',
  );

  static const String mistralChatModel = String.fromEnvironment(
    'MISTRAL_CHAT_MODEL',
    defaultValue: 'ministral-14b-latest',
  );

  static const String mistralVoiceModel = String.fromEnvironment(
    'MISTRAL_VOICE_MODEL',
    defaultValue: 'voxtral-mini-latest',
  );

  static const String iosAppGroupId = String.fromEnvironment(
    'IOS_APP_GROUP_ID',
    defaultValue: '',
  );

  static bool get unsplashEnabled =>
      unsplashMode.toUpperCase() == 'TRUE' &&
      unsplashAccessKey.isNotEmpty &&
      unsplashAccessKey != 'your-unsplash-access-key';

  static bool get pexelsEnabled =>
      pexelsMode.toUpperCase() == 'TRUE' &&
      pexelsApiKey.isNotEmpty &&
      pexelsApiKey != 'your-pexels-api-key';

  static bool get mistralEnabled =>
      mistralApiKey.isNotEmpty &&
      mistralApiKey != 'your-mistral-api-key';
}
