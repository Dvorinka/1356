import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../application/calendar_controller.dart';
import '../../goals/application/goals_controller.dart';

class CalendarScreen extends ConsumerWidget {
  final String? initialGoalId;

  const CalendarScreen({super.key, this.initialGoalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarControllerProvider);
    final controller = ref.read(calendarControllerProvider.notifier);

    final selectedDate = state.selectedDate;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final monthText = DateFormat('MMMM').format(selectedDate);
    final yearText = DateFormat('yyyy').format(selectedDate);
    final dayLabel = DateFormat('EEE, d MMM').format(selectedDate);

    return AppScaffold(
      title: 'Calendar',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthText,
              style: textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              yearText,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dayLabel,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            _DaySelector(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                controller.selectDate(date);
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _ScheduleList(state: state),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddCalendarEntrySheet(
          context,
          ref,
          state,
          initialGoalId: initialGoalId,
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add note'),
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _DaySelector({
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // Start of week (Sunday) based on the selected date
    final weekdayIndex = selectedDate.weekday % 7;
    final weekStart = selectedDate.subtract(Duration(days: weekdayIndex));
    final days = List.generate(7, (index) => weekStart.add(Duration(days: index)));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(days.length, (index) {
          final date = days[index];
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;

          final backgroundColor = isSelected
              ? colorScheme.primary.withValues(alpha: 0.06)
              : theme.colorScheme.surface;
          final borderColor = isSelected
              ? colorScheme.primary.withValues(alpha: 0.4)
              : Colors.black.withValues(alpha: 0.04);

          final label = DateFormat('EEE').format(date);
          final dayText = DateFormat('d').format(date);

          return Padding(
            padding: EdgeInsets.only(right: index == days.length - 1 ? 0 : 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => onDateSelected(date),
              child: Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        dayText,
                        style: textTheme.titleMedium?.copyWith(
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Dot(color: colorScheme.primary.withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        _Dot(color: colorScheme.secondary.withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        _Dot(color: Theme.of(context).colorScheme.error.withValues(alpha: 0.8)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final CalendarState state;

  const _ScheduleList({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entries = state.entries;

    if (state.isLoading && entries.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (entries.isEmpty) {
      return Center(
        child: Text(
          'No notes for this day yet.\nAdd a small progress update or reflection.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final items = entries.map((entry) {
      final timeOfDay = TimeOfDay.fromDateTime(entry.createdAt);
      final formatted = timeOfDay.format(context);
      String startTime;
      String meridiem;
      final parts = formatted.split(' ');
      if (parts.length == 2) {
        startTime = parts[0];
        meridiem = parts[1];
      } else {
        startTime = formatted;
        meridiem = '';
      }

      String accentLabel;
      Color accentColor;
      switch (entry.entryType) {
        case 'progress':
          accentLabel = 'Progress';
          accentColor = theme.colorScheme.primary;
          break;
        case 'milestone':
          accentLabel = 'Milestone';
          accentColor = theme.colorScheme.secondary;
          break;
        default:
          accentLabel = 'Note';
          accentColor = theme.colorScheme.primary;
      }

      final hasGoal = entry.goalId != null;

      return _ScheduleItemData(
        startTime: startTime,
        meridiem: meridiem,
        title: entry.title,
        subtitle: entry.note ?? '',
        accentLabel: accentLabel,
        accentColor: accentColor,
        hasGoal: hasGoal,
      );
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 8),
      itemBuilder: (context, index) {
        return _ScheduleItem(data: items[index]);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: items.length,
    );
  }
}

class _ScheduleItemData {
  final String startTime;
  final String meridiem;
  final String title;
  final String subtitle;
  final String accentLabel;
  final Color accentColor;
  final bool hasGoal;

  _ScheduleItemData({
    required this.startTime,
    required this.meridiem,
    required this.title,
    required this.subtitle,
    required this.accentLabel,
    required this.accentColor,
    this.hasGoal = false,
  });
}

class _ScheduleItem extends StatelessWidget {
  final _ScheduleItemData data;

  const _ScheduleItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.startTime,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.meridiem,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.04),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: data.accentColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.accentLabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: data.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (data.subtitle.isNotEmpty)
                  Text(
                    data.subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                if (data.hasGoal) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          size: 14,
                          color: colorScheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Linked to a goal',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _showAddCalendarEntrySheet(
  BuildContext context,
  WidgetRef ref,
  CalendarState state, {
  String? initialGoalId,
}) async {
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final bottomInset = MediaQuery.of(sheetContext).viewInsets.bottom;
      final goalsState = ref.read(goalsControllerProvider);
      String? selectedGoalId = initialGoalId;

      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16 + bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Add note for your day',
                  style:
                      Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Details (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                if (!goalsState.isLoading && goalsState.goals.isNotEmpty) ...[
                  DropdownButtonFormField<String>(
                    initialValue: selectedGoalId,
                    decoration: const InputDecoration(
                      labelText: 'Related goal (optional)',
                      border: OutlineInputBorder(),
                    ),
                    items: goalsState.goals
                        .map(
                          (g) => DropdownMenuItem<String>(
                            value: g.id,
                            child: Text(
                              g.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setModalState(() {
                        selectedGoalId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                ] else ...[
                  const SizedBox(height: 16),
                ],
                ElevatedButton(
                  onPressed: () async {
                    await ref
                        .read(calendarControllerProvider.notifier)
                        .addEntry(
                          title: titleController.text,
                          note: noteController.text,
                          goalId: selectedGoalId,
                        );
                    if (Navigator.of(sheetContext).canPop()) {
                      Navigator.of(sheetContext).pop();
                    }
                  },
                  child: const Text('Save to calendar'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

