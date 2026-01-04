import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/countdown/presentation/home_countdown_screen.dart';

void main() {
  group('HomeCountdownScreen Widget', () {
    testWidgets('should display countdown timer', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeCountdownScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display countdown components
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display days remaining', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeCountdownScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display large countdown display
      expect(find.textContaining('days'), findsOneWidget);
    });

    testWidgets('should display progress indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeCountdownScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should have progress visualization
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display motivational message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeCountdownScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should show motivational text
      expect(find.textContaining('Make every day count'), findsOneWidget);
    });

    testWidgets('should display view goals button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeCountdownScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('View My Goals'), findsOneWidget);
    });

    testWidgets('should display hours, minutes, seconds breakdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeCountdownScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display time breakdown
      expect(find.textContaining('h'), findsOneWidget);
      expect(find.textContaining('m'), findsOneWidget);
      expect(find.textContaining('s'), findsOneWidget);
    });

    testWidgets('should display percentage completed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomeCountdownScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('%'), findsOneWidget);
    });
  });
}
