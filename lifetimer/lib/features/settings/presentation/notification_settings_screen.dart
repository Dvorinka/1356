import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';

final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsController, NotificationSettings>((ref) {
  return NotificationSettingsController();
});

class NotificationSettingsController extends StateNotifier<NotificationSettings> {
  NotificationSettingsController() : super(const NotificationSettings());

  void updateCountdownReminder(Frequency frequency) {
    state = state.copyWith(countdownReminderFrequency: frequency);
  }

  void updateGoalProgress(bool enabled) {
    state = state.copyWith(goalProgressNotifications: enabled);
  }

  void updateMilestoneAlerts(bool enabled) {
    state = state.copyWith(milestoneAlerts: enabled);
  }

  void updateCountdownCheckpoints(bool enabled) {
    state = state.copyWith(countdownCheckpoints: enabled);
  }
}

class NotificationSettings {
  final Frequency countdownReminderFrequency;
  final bool goalProgressNotifications;
  final bool milestoneAlerts;
  final bool countdownCheckpoints;

  const NotificationSettings({
    this.countdownReminderFrequency = Frequency.daily,
    this.goalProgressNotifications = true,
    this.milestoneAlerts = true,
    this.countdownCheckpoints = true,
  });

  NotificationSettings copyWith({
    Frequency? countdownReminderFrequency,
    bool? goalProgressNotifications,
    bool? milestoneAlerts,
    bool? countdownCheckpoints,
  }) {
    return NotificationSettings(
      countdownReminderFrequency: countdownReminderFrequency ?? this.countdownReminderFrequency,
      goalProgressNotifications: goalProgressNotifications ?? this.goalProgressNotifications,
      milestoneAlerts: milestoneAlerts ?? this.milestoneAlerts,
      countdownCheckpoints: countdownCheckpoints ?? this.countdownCheckpoints,
    );
  }
}

enum Frequency {
  never,
  daily,
  weekly,
  custom,
}

extension FrequencyExtension on Frequency {
  String get label {
    switch (this) {
      case Frequency.never:
        return 'Never';
      case Frequency.daily:
        return 'Daily';
      case Frequency.weekly:
        return 'Weekly';
      case Frequency.custom:
        return 'Custom';
    }
  }

  String get description {
    switch (this) {
      case Frequency.never:
        return 'No reminders';
      case Frequency.daily:
        return 'Receive daily countdown reminders';
      case Frequency.weekly:
        return 'Receive weekly countdown reminders';
      case Frequency.custom:
        return 'Set custom reminder schedule';
    }
  }
}

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);

    return AppScaffold(
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'Countdown Reminders',
            children: [
              _FrequencyTile(
                title: 'Reminder Frequency',
                subtitle: settings.countdownReminderFrequency.description,
                currentFrequency: settings.countdownReminderFrequency,
                onChanged: (frequency) {
                  ref.read(notificationSettingsProvider.notifier).updateCountdownReminder(frequency);
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Goal Notifications',
            children: [
              _SwitchTile(
                title: 'Goal Progress',
                subtitle: 'Get notified about goal updates',
                value: settings.goalProgressNotifications,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).updateGoalProgress(value);
                },
              ),
              _SwitchTile(
                title: 'Milestone Alerts',
                subtitle: 'Celebrate when you complete milestones',
                value: settings.milestoneAlerts,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).updateMilestoneAlerts(value);
                },
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Countdown Checkpoints',
            children: [
              _SwitchTile(
                title: 'Checkpoint Notifications',
                subtitle: 'Get notified at 50%, 25%, and 10% remaining',
                value: settings.countdownCheckpoints,
                onChanged: (value) {
                  ref.read(notificationSettingsProvider.notifier).updateCountdownCheckpoints(value);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification preferences saved')),
                );
                context.pop();
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Preferences'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _FrequencyTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Frequency currentFrequency;
  final ValueChanged<Frequency> onChanged;

  const _FrequencyTile({
    required this.title,
    required this.subtitle,
    required this.currentFrequency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: DropdownButton<Frequency>(
        value: currentFrequency,
        items: Frequency.values.map((frequency) {
          return DropdownMenuItem<Frequency>(
            value: frequency,
            child: Text(frequency.label),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}
