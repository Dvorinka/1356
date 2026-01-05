// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../data/models/user_model.dart';
import '../application/countdown_controller.dart';
import '../../achievements/application/achievements_controller.dart';

class HomeCountdownScreen extends ConsumerStatefulWidget {
  const HomeCountdownScreen({super.key});

  @override
  ConsumerState<HomeCountdownScreen> createState() => _HomeCountdownScreenState();
}

class _HomeCountdownScreenState extends ConsumerState<HomeCountdownScreen> {
  @override
  Widget build(BuildContext context) {
    final countdownState = ref.watch(countdownControllerProvider);
    final achievementsState = ref.watch(achievementsControllerProvider);
    final int? level = achievementsState.totalCount > 0
        ? achievementsState.level
        : null;

    return AppScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: countdownState.isLoading
            ? const Center(child: LoadingIndicator())
            : countdownState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${countdownState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.go('/'),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : countdownState.user == null || !countdownState.user!.hasCountdownStarted
                    ? _CountdownNotStartedScreen()
                    : _CountdownActiveScreen(
                        user: countdownState.user!,
                        level: level,
                      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ai-chat'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.psychology),
      ),
    );
  }
}

class _CountdownNotStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Countdown not started screen',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              label: 'Timer icon',
              child: const Icon(
                Icons.timer_outlined,
                size: 100,
                color: null,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Ready to Start?',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Ready to Start? Your 1356-day journey is waiting.',
            ),
            const SizedBox(height: 16),
            Text(
              'Your 1356-day journey is waiting.\nCreate your bucket list and begin your countdown.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Semantics(
              button: true,
              label: 'Create your goals button',
              hint: 'Tap to create your bucket list goals',
              child: PrimaryButton(
                onPressed: () => context.push('/goals'),
                text: 'Create Your Goals',
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              button: true,
              label: 'View existing goals button',
              hint: 'Tap to view your existing goals',
              child: OutlinedButton(
                onPressed: () => context.push('/goals'),
                child: const Text('View Existing Goals'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownActiveScreen extends StatelessWidget {
  final User user;
  final int? level;

  const _CountdownActiveScreen({required this.user, this.level});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDate = user.countdownEndDate!;
    final remaining = endDate.difference(now);
    
    if (remaining.isNegative) {
      return _CountdownCompletedScreen(user: user, level: level);
    }

    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    final totalDuration = endDate.difference(user.countdownStartDate!);
    final elapsed = now.difference(user.countdownStartDate!);
    final progress = elapsed.inSeconds / totalDuration.inSeconds;

    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 24.0, right: 24.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              Text(
                'Your Journey',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '1356-day challenge',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                ),
              ),
              if (level != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Level $level',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _TodayCalendarCard(),
              const SizedBox(height: 24),
              _CountdownDisplay(
                days: days,
                hours: hours,
                minutes: minutes,
                seconds: seconds,
              ),
              const SizedBox(height: 32),
              _ProgressRing(progress: progress.clamp(0.0, 1.0)),
              const SizedBox(height: 16),
              Text(
                '${(progress * 100).toStringAsFixed(1)}% Complete',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              _MotivationalMessage(progress: progress),
              const SizedBox(height: 32),
              PrimaryButton(
                onPressed: () => context.push('/goals'),
                text: 'View My Goals',
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.push('/profile'),
                icon: const Icon(Icons.person_outline),
                label: const Text('My Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodayCalendarCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayLabel = DateFormat('EEE').format(now);
    final dateLabel = DateFormat('d MMM').format(now);

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => context.push('/calendar'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.black.withOpacity(0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayLabel.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s plan',
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Tap to view your calendar',
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownCompletedScreen extends StatelessWidget {
  final User user;
  final int? level;

  const _CountdownCompletedScreen({required this.user, this.level});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.celebration,
            size: 100,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 32),
          Text(
            'Journey Complete!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          if (level != null) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Level $level',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'You\'ve completed your 1356-day challenge.\nCongratulations on your achievement!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          PrimaryButton(
            onPressed: () => context.push('/goals'),
            text: 'Review Your Journey',
          ),
        ],
      ),
    );
  }
}

class _CountdownDisplay extends StatelessWidget {
  final int days;
  final int hours;
  final int minutes;
  final int seconds;

  const _CountdownDisplay({
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final heroBackground = isDark ? const Color(0xFF020617) : colorScheme.surface;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          decoration: BoxDecoration(
            color: heroBackground,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 40,
                offset: const Offset(0, 24),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                days.toString(),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 96,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -3,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'days remaining',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimeUnit(value: hours, label: 'Hours'),
            const SizedBox(width: 12),
            _TimeUnit(value: minutes, label: 'Minutes'),
            const SizedBox(width: 12),
            _TimeUnit(value: seconds, label: 'Seconds'),
          ],
        ),
      ],
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;

  const _TimeUnit({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark
        ? const Color(0xFF020617)
        : const Color(0xFFF3F4F6);
    final borderColor = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);

    return Semantics(
      label: '$label: $value',
      value: value.toString(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.toString().padLeft(2, '0'),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double progress;

  const _ProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Progress ring',
      value: '${(progress * 100).toInt()} percent complete',
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            ExcludeSemantics(
              child: Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MotivationalMessage extends StatelessWidget {
  final double progress;

  const _MotivationalMessage({required this.progress});

  @override
  Widget build(BuildContext context) {
    String message;
    if (progress < 0.1) {
      message = 'Every great journey begins with a single step. Keep going!';
    } else if (progress < 0.25) {
      message = 'You\'re building momentum. Stay focused on your goals!';
    } else if (progress < 0.5) {
      message = 'You\'re making real progress. Halfway there!';
    } else if (progress < 0.75) {
      message = 'Amazing progress! Your goals are within reach.';
    } else if (progress < 0.9) {
      message = 'Almost there! Finish strong!';
    } else {
      message = 'The final stretch. Give it your all!';
    }

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
