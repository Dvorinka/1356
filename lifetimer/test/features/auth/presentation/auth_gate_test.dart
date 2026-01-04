import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifetimer/features/auth/application/auth_controller.dart';
import 'package:lifetimer/features/auth/presentation/auth_gate.dart';
import 'package:lifetimer/features/auth/presentation/auth_choice_screen.dart';
import 'package:lifetimer/features/onboarding/presentation/onboarding_intro_screen.dart';
import 'package:lifetimer/data/models/user_model.dart';
import 'package:lifetimer/data/repositories/auth_repository.dart';

class MockAuthRepository extends AuthRepository {
  bool _isAuthenticated = false;

  MockAuthRepository() : super(null);

  @override
  User? get currentUser => _isAuthenticated ? TestData.createTestUser() : null;

  @override
  Stream<User?> get authStateChanges => Stream.value(currentUser);

  @override
  bool get isAuthenticated => _isAuthenticated;

  @override
  String? get currentUserId => currentUser?.id;

  @override
  Future<void> signInWithEmail(String email, String password) async {}

  @override
  Future<void> signUpWithEmail(String email, String password, String username) async {}

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signInWithApple() async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> resetPassword(String email) async {}

  @override
  Future<bool> isSessionValid() async => true;

  @override
  Future<void> refreshSession() async {}

  @override
  Future<void> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
    bool? isPublicProfile,
  }) async {}

  @override
  void dispose() {}
}

class TestData {
  static User createTestUser() {
    return User(
      id: 'test-user-id',
      username: 'testuser',
      email: 'test@example.com',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

void main() {
  group('AuthGate Widget', () {
    testWidgets('should show AuthChoiceScreen when user is not authenticated',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(MockAuthRepository()),
          ],
          child: const MaterialApp(
            home: AuthGate(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(AuthChoiceScreen), findsOneWidget);
      expect(find.byType(OnboardingIntroScreen), findsNothing);
    });

    testWidgets('should show OnboardingIntroScreen when user is authenticated',
        (WidgetTester tester) async {
      final mockRepo = MockAuthRepository();
      mockRepo._isAuthenticated = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: AuthGate(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(OnboardingIntroScreen), findsOneWidget);
      expect(find.byType(AuthChoiceScreen), findsNothing);
    });
  });
}
