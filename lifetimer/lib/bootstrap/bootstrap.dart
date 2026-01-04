import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'env.dart';
import 'supabase_client.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Env.iosAppGroupId.isNotEmpty) {
    await HomeWidget.setAppGroupId(Env.iosAppGroupId);
  }

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
    debug: true,
  );
  
  initializeSupabaseClient();
}
