import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/empty_state.dart';
import '../application/achievements_controller.dart';
import '../../../data/models/achievement_model.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(achievementsControllerProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(achievementsControllerProvider);

    return AppScaffold(
      title: 'Achievements',
      body: state.isLoading
          ? const LoadingIndicator()
          : state.error != null
              ? _buildError(state.error!)
              : _buildContent(state),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error loading achievements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(achievementsControllerProvider.notifier).refresh();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AchievementsState state) {
    if (state.availableAchievements.isEmpty) {
      return const EmptyState(
        icon: Icons.emoji_events_outlined,
        title: 'No achievements available yet',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(achievementsControllerProvider.notifier).refresh();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressCard(state),
            const SizedBox(height: 24),
            _buildAchievementsList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(AchievementsState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Level ${state.level}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${state.unlockedCount}/${state.totalCount}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: state.completionPercentage / 100,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.completionPercentage.toStringAsFixed(0)}% Complete',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsList(AchievementsState state) {
    final unlockedIds = state.unlockedAchievements.map((a) => a.id).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Achievements',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        ...state.availableAchievements.map((achievement) {
          final isUnlocked = unlockedIds.contains(achievement.id);
          return _buildAchievementCard(achievement, isUnlocked);
        }),
      ],
    );
  }

  Widget _buildAchievementCard(Achievement achievement, bool isUnlocked) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.6,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isUnlocked
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.grey[200],
            radius: 28,
            child: Text(
              achievement.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          title: Text(
            achievement.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUnlocked
                  ? Theme.of(context).colorScheme.onSurface
                  : Colors.grey,
            ),
          ),
          subtitle: Text(
            achievement.description,
            style: TextStyle(
              color: isUnlocked
                  ? Theme.of(context).colorScheme.onSurfaceVariant
                  : Colors.grey,
            ),
          ),
          trailing: isUnlocked
              ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                )
              : const Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}
