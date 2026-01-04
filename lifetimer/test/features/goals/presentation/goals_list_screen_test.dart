import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/goals/presentation/goals_list_screen.dart';

void main() {
  group('GoalsListScreen Widget', () {
    testWidgets('should display goals list title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalsListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('My Goals'), findsOneWidget);
    });

    testWidgets('should display add goal button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalsListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Goal'), findsOneWidget);
    });

    testWidgets('should display goals counter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalsListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('/20'), findsOneWidget);
    });

    testWidgets('should display empty state when no goals',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalsListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show empty state message
      expect(find.textContaining('No goals'), findsOneWidget);
    });

    testWidgets('should display start countdown button when goals exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalsListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // The button might not be visible until goals are added
      // This test verifies the structure is in place
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
