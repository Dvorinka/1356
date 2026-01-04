// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../goals/application/goals_controller.dart';
import '../application/countdown_controller.dart';
import 'countdown_start_confirmation_dialog.dart';

class BucketListConfirmationScreen extends ConsumerWidget {
  const BucketListConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(goalsControllerProvider);

    if (goalsState.isLoading) {
      return const AppScaffold(
        title: 'Confirm Your Bucket List',
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (goalsState.error != null) {
      return AppScaffold(
        title: 'Confirm Your Bucket List',
        body: Center(
          child: Text('Error: ${goalsState.error}'),
        ),
      );
    }

    final goals = goalsState.goals;

    if (goals.isEmpty) {
      return const AppScaffold(
        title: 'Confirm Your Bucket List',
        body: Center(
          child: Text('No goals in your bucket list'),
        ),
      );
    }

    return AppScaffold(
      title: 'Confirm Your Bucket List',
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: goals.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Icon(
                          Icons.checklist_rounded,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your Bucket List',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${goals.length} goal${goals.length != 1 ? 's' : ''} ready',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                      ],
                    );
                  }

                  final goal = goals[index - 1];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: goal.completed
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Icon(
                          goal.completed ? Icons.check : Icons.flag_outlined,
                          color: goal.completed
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      title: Text(
                        goal.title,
                        style: TextStyle(
                          decoration: goal.completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: goal.description != null && goal.description!.isNotEmpty
                          ? Text(
                              goal.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          : null,
                      trailing: goal.progress > 0
                          ? Text('${goal.progress}%')
                          : null,
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Review your goals carefully. Once confirmed, you cannot make changes.',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onTertiaryContainer,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          child: const Text('Edit Goals'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => CountdownStartConfirmationDialog(
                                goalCount: goals.length,
                              ),
                            );

                            if (confirmed == true && context.mounted) {
                              ref.read(countdownControllerProvider.notifier).loadCountdown();
                              if (context.mounted) {
                                context.go('/home');
                              }
                            }
                          },
                          text: 'Confirm & Start',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
