import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/goals/presentation/goal_edit_screen.dart';

void main() {
  group('GoalEditScreen Widget', () {
    testWidgets('should display goal edit title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Goal'), findsOneWidget);
    });

    testWidgets('should display title field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Title'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });

    testWidgets('should display description field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Save Goal'), findsOneWidget);
    });

    testWidgets('should display cancel button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should validate title field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Try to save without title
      final saveButton = find.text('Save Goal');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Goal title is required'), findsOneWidget);
    });

    testWidgets('should display location picker', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Location'), findsOneWidget);
    });

    testWidgets('should display image picker', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Add Image'), findsOneWidget);
    });

    testWidgets('should display milestones section',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: GoalEditScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Milestones'), findsOneWidget);
      expect(find.text('Add Milestone'), findsOneWidget);
    });
  });
}
