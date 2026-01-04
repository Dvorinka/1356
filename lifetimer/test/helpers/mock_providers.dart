import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lifetimer/data/repositories/auth_repository.dart';
import 'package:lifetimer/data/repositories/goals_repository.dart';
import 'package:lifetimer/data/repositories/countdown_repository.dart';
import 'package:lifetimer/data/repositories/user_repository.dart';
import 'package:lifetimer/data/repositories/social_repository.dart';
import 'package:lifetimer/data/repositories/notifications_repository.dart';
import 'package:lifetimer/features/auth/application/auth_controller.dart';
import 'package:lifetimer/features/goals/application/goals_controller.dart';
import 'package:lifetimer/features/countdown/application/countdown_controller.dart';
import 'package:lifetimer/features/settings/application/settings_controller.dart';
import 'package:lifetimer/features/social/application/social_controller.dart';

// Note: Run 'flutter pub run build_runner build' to generate mocks
@GenerateMocks([
  AuthRepository,
  GoalsRepository,
  CountdownRepository,
  UserRepository,
  SocialRepository,
  NotificationsRepository,
])
import 'mock_providers.mocks.dart';

/// Helper to create mock repositories for testing
class MockRepositories {
  late MockAuthRepository authRepository;
  late MockGoalsRepository goalsRepository;
  late MockCountdownRepository countdownRepository;
  late MockUserRepository userRepository;
  late MockSocialRepository socialRepository;
  late MockNotificationsRepository notificationsRepository;

  MockRepositories() {
    authRepository = MockAuthRepository();
    goalsRepository = MockGoalsRepository();
    countdownRepository = MockCountdownRepository();
    userRepository = MockUserRepository();
    socialRepository = MockSocialRepository();
    notificationsRepository = MockNotificationsRepository();
  }

  /// Get all repository overrides
  List<Override> get overrides => [
        authRepositoryProvider.overrideWithValue(authRepository),
        goalsRepositoryProvider.overrideWithValue(goalsRepository),
        countdownRepositoryProvider.overrideWithValue(countdownRepository),
        userRepositoryProvider.overrideWithValue(userRepository),
        socialRepositoryProvider.overrideWithValue(socialRepository),
        notificationsRepositoryProvider.overrideWithValue(notificationsRepository),
      ];
}

/// Helper to create a mock Supabase client
class MockSupabaseClient extends Mock implements SupabaseClient {}

/// Helper to create a mock Supabase auth
class MockSupabaseAuth extends Mock implements GoTrueClient {}

/// Helper to create a mock Supabase database
class MockSupabaseDatabase extends Mock implements PostgrestClient {}
