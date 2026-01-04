// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/settings/presentation/notification_settings_screen.dart';

void main() {
  group('NotificationSettingsScreen Widget', () {
    testWidgets('should display notification settings title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: NotificationSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Notification Settings'), findsOneWidget);
    });

    testWidgets('should display daily reminder option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: NotificationSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Daily Reminder'), findsOneWidget);
    });

    testWidgets('should display weekly reminder option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: NotificationSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Weekly Reminder'), findsOneWidget);
    });

    testWidgets('should display milestone notifications option',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: NotificationSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Milestone Notifications'), findsOneWidget);
    });

    testWidgets('should display countdown checkpoint notifications',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: NotificationSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Countdown Checkpoints'), findsOneWidget);
    });

    testWidgets('should display toggle switches', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: NotificationSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsWidgets);
    });

    testWidgets('should display save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: NotificationSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });
  });
}
