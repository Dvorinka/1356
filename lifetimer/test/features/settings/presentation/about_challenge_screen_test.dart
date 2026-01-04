// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/settings/presentation/about_challenge_screen.dart';

void main() {
  group('AboutChallengeScreen Widget', () {
    testWidgets('should display about challenge title',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: AboutChallengeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('About the 1356-Day Challenge'), findsOneWidget);
    });

    testWidgets('should display challenge description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: AboutChallengeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('1356'), findsOneWidget);
      expect(find.textContaining('days'), findsOneWidget);
    });

    testWidgets('should display bucket list explanation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: AboutChallengeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('bucket list'), findsOneWidget);
    });

    testWidgets('should display countdown rules', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: AboutChallengeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('cannot be paused'), findsOneWidget);
      expect(find.textContaining('cannot be reset'), findsOneWidget);
    });

    testWidgets('should display motivation section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: AboutChallengeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Make every day count'), findsOneWidget);
    });

    testWidgets('should display close button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: AboutChallengeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Close'), findsOneWidget);
    });
  });
}
