// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/bottom_nav_scaffold.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../data/models/activity_model.dart';
import '../../auth/application/auth_controller.dart';
import '../application/social_controller.dart';

class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFeed();
    });
  }

  Future<void> _loadFeed() async {
    final authController = ref.read(authControllerProvider.notifier);
    final userId = authController.currentUserId;
    if (userId != null) {
      await ref.read(socialControllerProvider.notifier).loadActivityFeed(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialControllerProvider);

    return BottomNavScaffold(
      child: AppScaffold(
        title: 'Social Feed',
        body: _buildBody(socialState),
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
              onPressed: _loadFeed,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.feed == null || state.feed!.isEmpty) {
      return const EmptyState(
        icon: Icons.feed_outlined,
        title: 'No Activity Yet',
        subtitle: 'Follow users to see their progress and milestones here.',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFeed,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.feed!.length,
        itemBuilder: (context, index) {
          final activity = state.feed![index];
          return _ActivityCard(activity: activity);
        },
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;

  const _ActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    String title;
    String? subtitle;

    switch (activity.type) {
      case 'goal_completed':
        icon = Icons.celebration;
        iconColor = Colors.green;
        title = 'Completed a goal!';
        subtitle = activity.payload?['goal_title'] as String?;
        break;
      case 'milestone_completed':
        icon = Icons.flag;
        iconColor = Colors.blue;
        title = 'Reached a milestone';
        subtitle = activity.payload?['milestone'] as String?;
        break;
      case 'followed_user':
        icon = Icons.person_add;
        iconColor = Colors.purple;
        title = 'Started following someone';
        break;
      case 'countdown_started':
        icon = Icons.timer;
        iconColor = Colors.orange;
        title = 'Started their 1356-day journey!';
        break;
      default:
        icon = Icons.info_outline;
        iconColor = Colors.grey;
        title = 'Activity';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(title),
        subtitle: subtitle != null
            ? Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis)
            : null,
        trailing: Text(
          DateTimeUtils.formatRelativeTime(activity.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
