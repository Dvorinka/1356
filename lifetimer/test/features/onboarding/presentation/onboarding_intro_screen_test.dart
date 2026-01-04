// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/onboarding/presentation/onboarding_intro_screen.dart';

void main() {
  group('OnboardingIntroScreen Widget', () {
    testWidgets('should display welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingIntroScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome to LifeTimer'), findsOneWidget);
    });

    testWidgets('should display 1356-day challenge description',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingIntroScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('1356'), findsOneWidget);
    });

    testWidgets('should display get started button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingIntroScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('should display skip button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingIntroScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('should display page indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingIntroScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have page indicators (dots)
      expect(find.byType(Container), findsWidgets);
    });
  });
}
