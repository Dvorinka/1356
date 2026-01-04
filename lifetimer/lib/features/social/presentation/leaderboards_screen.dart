// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/bottom_nav_scaffold.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/models/user_model.dart' as app;
import '../application/social_controller.dart';

class LeaderboardsScreen extends ConsumerStatefulWidget {
  const LeaderboardsScreen({super.key});

  @override
  ConsumerState<LeaderboardsScreen> createState() => _LeaderboardsScreenState();
}

class _LeaderboardsScreenState extends ConsumerState<LeaderboardsScreen> {
  String _selectedSort = 'goals_completed';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLeaderboard();
    });
  }

  Future<void> _loadLeaderboard() async {
    await ref.read(socialControllerProvider.notifier).loadLeaderboard(
          sortBy: _selectedSort,
          limit: 50,
        );
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      _selectedSort = sortBy;
    });
    _loadLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialControllerProvider);

    return BottomNavScaffold(
      child: AppScaffold(
        title: 'Leaderboards',
        body: Column(
          children: [
            _SortTabs(
              selectedSort: _selectedSort,
              onSortChanged: _onSortChanged,
            ),
            Expanded(child: _buildBody(socialState)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(SocialState state) {
    if (state.isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLeaderboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.leaderboard == null || state.leaderboard!.isEmpty) {
      return const EmptyState(
        icon: Icons.emoji_events_outlined,
        title: 'No Leaderboard Yet',
        subtitle: 'Be the first to complete goals and appear on the leaderboard!',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLeaderboard,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.leaderboard!.length,
        itemBuilder: (context, index) {
          final user = state.leaderboard![index];
          return _LeaderboardEntry(
            user: user,
            rank: index + 1,
          );
        },
      ),
    );
  }
}

class _SortTabs extends StatelessWidget {
  final String selectedSort;
  final Function(String) onSortChanged;

  const _SortTabs({
    required this.selectedSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SegmentedButton<String>(
        segments: const [
          ButtonSegment(
            value: 'goals_completed',
            label: Text('Goals'),
            icon: Icon(Icons.flag),
          ),
          ButtonSegment(
            value: 'streak',
            label: Text('Streak'),
            icon: Icon(Icons.local_fire_department),
          ),
        ],
        selected: {selectedSort},
        onSelectionChanged: (Set<String> selected) {
          onSortChanged(selected.first);
        },
      ),
    );
  }
}

class _LeaderboardEntry extends StatelessWidget {
  final app.User user;
  final int rank;

  const _LeaderboardEntry({
    required this.user,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    Color rankColor;
    IconData rankIcon;

    if (rank == 1) {
      rankColor = Colors.amber;
      rankIcon = Icons.emoji_events;
    } else if (rank == 2) {
      rankColor = Colors.grey;
      rankIcon = Icons.military_tech;
    } else if (rank == 3) {
      rankColor = Colors.brown;
      rankIcon = Icons.workspace_premium;
    } else {
      rankColor = Theme.of(context).colorScheme.primary;
      rankIcon = Icons.numbers;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: rankColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Icon(
              rankIcon,
              color: rankColor,
              size: 28,
            ),
          ),
        ),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Member since ${user.createdAt.year}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#$rank',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
