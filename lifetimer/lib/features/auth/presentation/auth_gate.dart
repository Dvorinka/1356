import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/auth_controller.dart';
import '../../onboarding/application/onboarding_controller.dart';
import 'auth_showcase_screen.dart';
import '../../onboarding/presentation/onboarding_intro_screen.dart';
import '../../countdown/presentation/home_countdown_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final onboardingState = ref.watch(onboardingControllerProvider);

    if (authState == null) {
      return const AuthShowcaseScreen();
    }

    // If user is authenticated but hasn't completed onboarding
    if (!onboardingState) {
      return const OnboardingIntroScreen();
    }

    // User is authenticated and has completed onboarding
    return const HomeCountdownScreen();
  }
}
