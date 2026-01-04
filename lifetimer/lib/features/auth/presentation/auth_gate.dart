import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/auth_controller.dart';
import 'auth_showcase_screen.dart';
import '../../onboarding/presentation/onboarding_intro_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    if (authState == null) {
      return const AuthShowcaseScreen();
    }

    return const OnboardingIntroScreen();
  }
}
