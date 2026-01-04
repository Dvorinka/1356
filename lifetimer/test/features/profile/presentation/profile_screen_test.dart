// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/profile/presentation/profile_screen.dart';

void main() {
  group('ProfileScreen Widget', () {
    testWidgets('should display profile title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should display user avatar', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('should display username', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display username section
      expect(find.textContaining('Username'), findsOneWidget);
    });

    testWidgets('should display countdown information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Days Left'), findsOneWidget);
    });

    testWidgets('should display goals completed stat',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Goals Completed'), findsOneWidget);
    });

    testWidgets('should display edit profile button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('should display settings button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('should display sign out button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: ProfileScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Sign Out'), findsOneWidget);
    });
  });
}
