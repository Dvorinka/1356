// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/onboarding_controller.dart';

class OnboardingMotivationScreen extends ConsumerWidget {
  const OnboardingMotivationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(onboardingControllerProvider.notifier);
    
    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(
                Icons.psychology_outlined,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                'Your Time is Now',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '1356 days is approximately 3 years and 8 months.\n\n'
                'That\'s enough time to transform your life, learn new skills, '
                'build meaningful relationships, and achieve your biggest dreams.\n\n'
                'Every day counts. Every step matters. Your journey begins now.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const _MotivationCard(
                icon: Icons.trending_up,
                title: 'Track Progress',
                description: 'Watch yourself grow as you complete goals and milestones.',
              ),
              const SizedBox(height: 16),
              const _MotivationCard(
                icon: Icons.people,
                title: 'Join Community',
                description: 'Connect with others on similar journeys (optional).',
              ),
              const SizedBox(height: 16),
              const _MotivationCard(
                icon: Icons.celebration,
                title: 'Celebrate Wins',
                description: 'Every achievement is worth celebrating.',
              ),
              const Spacer(),
              PrimaryButton(
                onPressed: () async {
                  controller.completeStep('motivation');
                  await controller.completeOnboarding();
                  if (context.mounted) {
                    context.push('/profile/create');
                  }
                },
                text: 'Get Started',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _MotivationCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
