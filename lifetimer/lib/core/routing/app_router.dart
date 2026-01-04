import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../features/auth/presentation/auth_gate.dart';
import '../../features/auth/presentation/auth_choice_screen.dart';
import '../../features/auth/presentation/sign_in_screen.dart';
import '../../features/auth/presentation/sign_up_screen.dart';
import '../../features/auth/presentation/auth_loading_screen.dart';
import '../../features/onboarding/presentation/onboarding_intro_screen.dart';
import '../../features/onboarding/presentation/onboarding_how_it_works_screen.dart';
import '../../features/onboarding/presentation/onboarding_motivation_screen.dart';
import '../../features/countdown/presentation/home_countdown_screen.dart';
import '../../features/goals/presentation/goals_list_screen.dart';
import '../../features/goals/presentation/goal_edit_screen.dart';
import '../../features/goals/presentation/bucket_goal_create_screen.dart';
import '../../features/goals/presentation/goal_detail_screen.dart';
import '../../features/goals/presentation/location_picker_screen.dart';
import '../../features/goals/presentation/osm_location_picker_screen.dart';
import '../../features/social/presentation/social_feed_screen.dart';
import '../../features/social/presentation/leaderboards_screen.dart';
import '../../features/social/presentation/public_profile_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/profile_setup_screen.dart';
import '../../features/countdown/presentation/bucket_list_confirmation_screen.dart';
import '../../features/settings/presentation/settings_home_screen.dart';
import '../../features/settings/presentation/appearance_settings_screen.dart';
import '../../features/settings/presentation/notification_settings_screen.dart';
import '../../features/settings/presentation/privacy_settings_screen.dart';
import '../../features/settings/presentation/about_challenge_screen.dart';
import '../../features/achievements/presentation/achievements_screen.dart';
import '../../features/analytics/presentation/insights_screen.dart';
import '../../features/ai_chat/presentation/ai_chat_screen.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/voice_recording/presentation/voice_recording_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/auth-choice',
        builder: (context, state) => const AuthChoiceScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/auth-loading',
        builder: (context, state) => const AuthLoadingScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingIntroScreen(),
      ),
      GoRoute(
        path: '/onboarding/how-it-works',
        builder: (context, state) => const OnboardingHowItWorksScreen(),
      ),
      GoRoute(
        path: '/onboarding/motivation',
        builder: (context, state) => const OnboardingMotivationScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: '/bucket-list-confirmation',
        builder: (context, state) => const BucketListConfirmationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeCountdownScreen(),
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsListScreen(),
      ),
      GoRoute(
        path: '/goals/create',
        builder: (context, state) => const BucketGoalCreateScreen(),
      ),
      GoRoute(
        path: '/goals/:id',
        builder: (context, state) {
          final goalId = state.pathParameters['id']!;
          return GoalDetailScreen(goalId: goalId);
        },
      ),
      GoRoute(
        path: '/goals/:id/edit',
        builder: (context, state) {
          final goalId = state.pathParameters['id']!;
          return GoalEditScreen(goalId: goalId);
        },
      ),
      GoRoute(
        path: '/location-picker',
        builder: (context, state) {
          final lat = state.uri.queryParameters['lat'];
          final lng = state.uri.queryParameters['lng'];
          LatLng? initialPosition;
          if (lat != null && lng != null) {
            initialPosition = LatLng(
              double.parse(lat),
              double.parse(lng),
            );
          }
          return LocationPickerScreen(initialPosition: initialPosition);
        },
      ),
      GoRoute(
        path: '/osm-location-picker',
        builder: (context, state) {
          final lat = state.uri.queryParameters['lat'];
          final lng = state.uri.queryParameters['lng'];
          return OsmLocationPickerScreen(
            initialLatitude: lat != null ? double.tryParse(lat) : null,
            initialLongitude: lng != null ? double.tryParse(lng) : null,
          );
        },
      ),
      GoRoute(
        path: '/social',
        builder: (context, state) => const SocialFeedScreen(),
      ),
      GoRoute(
        path: '/social/leaderboards',
        builder: (context, state) => const LeaderboardsScreen(),
      ),
      GoRoute(
        path: '/u/:userId',
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return PublicProfileScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsHomeScreen(),
      ),
      GoRoute(
        path: '/settings/appearance',
        builder: (context, state) => const AppearanceSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        builder: (context, state) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/privacy',
        builder: (context, state) => const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/about',
        builder: (context, state) => const AboutChallengeScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => const AIChatScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => CalendarScreen(
          initialGoalId: state.uri.queryParameters['goalId'],
        ),
      ),
      GoRoute(
        path: '/recording',
        builder: (context, state) => const VoiceRecordingScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
