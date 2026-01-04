import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/models/goal_model.dart';
import '../application/goals_controller.dart';

class GoalDetailScreen extends ConsumerStatefulWidget {
  final String goalId;

  const GoalDetailScreen({super.key, required this.goalId});

  @override
  ConsumerState<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
  bool _isLoading = false;

  Goal? get goal {
    final goalsState = ref.watch(goalsControllerProvider);
    return goalsState.goals.firstWhere((g) => g.id == widget.goalId);
  }

  Future<void> _updateProgress(int progress) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(goalsControllerProvider.notifier).updateGoalProgress(
            widget.goalId,
            progress,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating progress: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _markAsCompleted() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(goalsControllerProvider.notifier).markGoalAsCompleted(
            widget.goalId,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal completed! 🎉')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalsState = ref.watch(goalsControllerProvider);

    if (goalsState.isLoading) {
      return const AppScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (goalsState.error != null) {
      return AppScaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${goalsState.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(goalsControllerProvider.notifier).loadGoals(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final currentGoal = goal;

    if (currentGoal == null) {
      return const AppScaffold(
        body: Center(child: Text('Goal not found')),
      );
    }

    return AppScaffold(
      title: currentGoal.title,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (currentGoal.hasImage)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(currentGoal.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: currentGoal.progress / 100,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${currentGoal.progress}% Complete',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (currentGoal.description != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(currentGoal.description!),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (currentGoal.hasLocation)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            currentGoal.locationName ?? 'Location set',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                'Update Progress',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Slider(
                value: currentGoal.progress.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                label: '${currentGoal.progress}%',
                onChanged: _isLoading
                    ? null
                    : (value) => _updateProgress(value.toInt()),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.push('/calendar?goalId=${currentGoal.id}'),
                icon: const Icon(Icons.calendar_today_outlined),
                label: const Text('Add event to calendar'),
              ),
              const SizedBox(height: 24),
              if (!currentGoal.completed)
                PrimaryButton(
                  onPressed: _isLoading ? () {} : _markAsCompleted,
                  text: 'Mark as Completed',
                  isLoading: _isLoading,
                ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.push('/goals/${currentGoal.id}/edit'),
                child: const Text('Edit Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
