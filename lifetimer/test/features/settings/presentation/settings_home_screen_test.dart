// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/settings/presentation/settings_home_screen.dart';

void main() {
  group('SettingsHomeScreen Widget', () {
    testWidgets('should display settings title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should display account section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('should display preferences section',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Preferences'), findsOneWidget);
    });

    testWidgets('should display privacy section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Privacy'), findsOneWidget);
    });

    testWidgets('should display about section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('About'), findsOneWidget);
    });

    testWidgets('should display account settings option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Account Settings'), findsOneWidget);
    });

    testWidgets('should display notification settings option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('should display privacy settings option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Privacy Settings'), findsOneWidget);
    });

    testWidgets('should display about challenge option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: SettingsHomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('About the Challenge'), findsOneWidget);
    });
  });
}
