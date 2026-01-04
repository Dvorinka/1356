import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/goals/presentation/goal_detail_screen.dart';

void main() {
  group('GoalDetailScreen Widget', () {
    testWidgets('should display goal detail title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalDetailScreen(goalId: 'test-goal-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display goal detail view
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display progress slider', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalDetailScreen(goalId: 'test-goal-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have progress controls
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('should display mark as completed button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalDetailScreen(goalId: 'test-goal-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mark as Completed'), findsOneWidget);
    });

    testWidgets('should display edit button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalDetailScreen(goalId: 'test-goal-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should display delete button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalDetailScreen(goalId: 'test-goal-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('should display milestones list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalDetailScreen(goalId: 'test-goal-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Milestones'), findsOneWidget);
    });

    testWidgets('should display progress percentage',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalDetailScreen(goalId: 'test-goal-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('%'), findsOneWidget);
    });
  });
}
