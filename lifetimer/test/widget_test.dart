// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifetimer/bootstrap/bootstrap.dart';
import 'package:lifetimer/main.dart';

void main() {
  testWidgets('LifeTimerApp builds without crashing', (WidgetTester tester) async {
    // Ensure app services (e.g., Supabase) are initialized similar to production.
    await bootstrap();

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(
      child: LifeTimerApp(),
    ));

    // Pump a few frames to allow initial build/layout without waiting for
    // all animations/streams to settle indefinitely.
    await tester.pump(const Duration(seconds: 1));
  });
}
