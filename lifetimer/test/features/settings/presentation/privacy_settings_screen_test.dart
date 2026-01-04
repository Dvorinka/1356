// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/settings/presentation/privacy_settings_screen.dart';

void main() {
  group('PrivacySettingsScreen Widget', () {
    testWidgets('should display privacy settings title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: PrivacySettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Privacy Settings'), findsOneWidget);
    });

    testWidgets('should display profile visibility toggle',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: PrivacySettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Public Profile'), findsOneWidget);
    });

    testWidgets('should display visibility description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: PrivacySettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Make your profile visible'), findsOneWidget);
    });

    testWidgets('should display private profile description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: PrivacySettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Only you can see'), findsOneWidget);
    });

    testWidgets('should display public profile description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: PrivacySettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Others can see'), findsOneWidget);
    });

    testWidgets('should display visibility toggle switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: PrivacySettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should display save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: PrivacySettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });
  });
}
