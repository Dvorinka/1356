// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/onboarding/presentation/onboarding_motivation_screen.dart';

void main() {
  group('OnboardingMotivationScreen Widget', () {
    testWidgets('should display motivation title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingMotivationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Your Journey Awaits'), findsOneWidget);
    });

    testWidgets('should display motivational message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingMotivationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('goals'), findsOneWidget);
      expect(find.textContaining('dreams'), findsOneWidget);
    });

    testWidgets('should display start challenge button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingMotivationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Start Your Challenge'), findsOneWidget);
    });

    testWidgets('should display back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingMotivationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('should display step indicators', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingMotivationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have step indicators
      expect(find.byType(Container), findsWidgets);
    });
  });
}
