import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper to create a ProviderScope with mocked providers for testing
ProviderScope createTestProviderScope({
  required Widget child,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      home: child,
    ),
  );
}

/// Helper to pump and settle a widget with ProviderScope
Future<void> pumpTestWidget(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    createTestProviderScope(
      child: child,
      overrides: overrides,
    ),
  );
  await tester.pumpAndSettle();
}

/// Helper to find a widget by type and key
Finder findWidgetByKey<T extends Widget>(Key key) {
  return find.byWidgetPredicate((widget) =>
      widget is T && widget.key == key);
}

/// Helper to verify a widget exists and has specific text
void expectWidgetWithText<T extends Widget>(String text) {
  expect(find.text(text), findsOneWidget);
}

/// Helper to verify a widget doesn't exist
void expectNoWidgetWithText<T extends Widget>(String text) {
  expect(find.text(text), findsNothing);
}

/// Helper to tap a widget with specific text
Future<void> tapWidgetWithText(WidgetTester tester, String text) async {
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

/// Helper to tap a widget by type
Future<void> tapWidgetByType<T extends Widget>(WidgetTester tester) async {
  await tester.tap(find.byType(T));
  await tester.pumpAndSettle();
}

/// Helper to enter text in a text field
Future<void> enterTextInField(
  WidgetTester tester,
  Finder finder,
  String text,
) async {
  await tester.enterText(finder, text);
  await tester.pumpAndSettle();
}

/// Helper to scroll until a widget is found
Future<void> scrollUntilVisible(
  WidgetTester tester,
  Finder finder, {
  Finder? scrollable,
}) async {
  final scrollableFinder = scrollable ?? find.byType(Scrollable);
  await tester.scrollUntilVisible(
    finder,
    500.0,
    scrollable: scrollableFinder,
  );
  await tester.pumpAndSettle();
}

/// Helper to wait for a specific duration
Future<void> waitFor(Duration duration) async {
  await Future.delayed(duration);
}
