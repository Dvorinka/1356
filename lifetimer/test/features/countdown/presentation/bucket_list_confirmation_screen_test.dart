import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/countdown/presentation/bucket_list_confirmation_screen.dart';

void main() {
  group('BucketListConfirmationScreen Widget', () {
    testWidgets('should display confirmation title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BucketListConfirmationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Finalize Your Bucket List'), findsOneWidget);
    });

    testWidgets('should display goals count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BucketListConfirmationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('goals'), findsOneWidget);
    });

    testWidgets('should display warning message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BucketListConfirmationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('cannot be paused'), findsOneWidget);
      expect(find.textContaining('cannot be reset'), findsOneWidget);
    });

    testWidgets('should display start countdown button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BucketListConfirmationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Start 1356-Day Challenge'), findsOneWidget);
    });

    testWidgets('should display review goals button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BucketListConfirmationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Review Goals'), findsOneWidget);
    });

    testWidgets('should display countdown duration info',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BucketListConfirmationScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('1356'), findsOneWidget);
      expect(find.textContaining('years'), findsOneWidget);
    });
  });
}
