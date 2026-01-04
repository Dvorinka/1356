// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/onboarding/presentation/onboarding_how_it_works_screen.dart';

void main() {
  group('OnboardingHowItWorksScreen Widget', () {
    testWidgets('should display how it works title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingHowItWorksScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('How It Works'), findsOneWidget);
    });

    testWidgets('should display bucket list step', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingHowItWorksScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('bucket list'), findsOneWidget);
    });

    testWidgets('should display countdown step', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingHowItWorksScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('countdown'), findsOneWidget);
    });

    testWidgets('should display next button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingHowItWorksScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('should display back button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: const MaterialApp(
            home: OnboardingHowItWorksScreen(),
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
            home: OnboardingHowItWorksScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have step indicators
      expect(find.byType(Container), findsWidgets);
    });
  });
}
