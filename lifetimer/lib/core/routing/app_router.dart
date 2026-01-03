import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/auth_gate.dart';
import '../../features/onboarding/presentation/onboarding_intro_screen.dart';
import '../../features/countdown/presentation/home_countdown_screen.dart';
import '../../features/goals/presentation/goals_list_screen.dart';
import '../../features/social/presentation/social_feed_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingIntroScreen(),
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
        path: '/social',
        builder: (context, state) => const SocialFeedScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsHomeScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
