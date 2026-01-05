import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';

class AuthShowcaseScreen extends ConsumerWidget {
  const AuthShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container
                  (
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color:
                            colorScheme.onSurface.withValues(alpha:0.06),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '1356 days. One focused challenge.',
                          style: theme.textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Make every day\ncount down.',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '1356 helps you design a 1356-day experiment, focus on a small set of meaningful goals, and see time as a single bold countdown.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha:0.7),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Row(
                    children: [
                      _ShowcaseStatCard(
                        label: 'Days in your challenge',
                        value: '1356',
                      ),
                      SizedBox(width: 12),
                      _ShowcaseStatCard(
                        label: 'Goals you can track',
                        value: '1 - 20',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _ShowcaseFeatureCard(
                    icon: Icons.flag_outlined,
                    title: 'Set sharp goals',
                    description:
                        'Capture a concise bucket list that is realistic but ambitious.',
                  ),
                  const SizedBox(height: 12),
                  const _ShowcaseFeatureCard(
                    icon: Icons.timer_outlined,
                    title: 'See the countdown',
                    description:
                        'A single timer keeps you aware of how many days are left.',
                  ),
                  const SizedBox(height: 12),
                  const _ShowcaseFeatureCard(
                    icon: Icons.trending_up,
                    title: 'Track your progress',
                    description:
                        'Reflect on wins, see streaks, and keep momentum over years.',
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Start your 1356-day journey',
                    onPressed: () => context.push('/auth-choice'),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => context.push('/sign-in'),
                      child: const Text('Already have an account? Sign in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShowcaseStatCard extends StatelessWidget {
  final String label;
  final String value;

  const _ShowcaseStatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha:0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha:0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ShowcaseFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha:0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha:0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        colorScheme.onSurface.withValues(alpha:0.7),
                    height: 1.5,
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
