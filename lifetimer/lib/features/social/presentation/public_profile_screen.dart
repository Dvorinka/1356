import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../data/models/user_model.dart' as app;
import '../../auth/application/auth_controller.dart';
import '../application/social_controller.dart';
import '../../profile/application/profile_controller.dart';

class PublicProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const PublicProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends ConsumerState<PublicProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
      _checkFollowingStatus();
    });
  }

  Future<void> _loadProfile() async {
    await ref.read(profileControllerProvider.notifier).loadProfile(widget.userId);
  }

  Future<void> _checkFollowingStatus() async {
    await ref.read(socialControllerProvider.notifier).isFollowing(widget.userId);
  }

  Future<void> _toggleFollow() async {
    final controller = ref.read(socialControllerProvider.notifier);
    final isFollowing = await controller.isFollowing(widget.userId);

    if (isFollowing) {
      await controller.unfollowUser(widget.userId);
    } else {
      await controller.followUser(widget.userId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final authController = ref.watch(authControllerProvider);
    final isOwnProfile = authController?.id == widget.userId;

    return AppScaffold(
      title: 'Profile',
      body: _buildBody(profileState, isOwnProfile),
    );
  }

  Widget _buildBody(ProfileState state, bool isOwnProfile) {
    if (state.isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.errorMessage}'),
          ],
        ),
      );
    }

    final user = state.user;
    if (user == null) {
      return const Center(child: Text('User not found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadProfile();
        await _checkFollowingStatus();
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _ProfileHeader(
              user: user,
              isOwnProfile: isOwnProfile,
              onToggleFollow: isOwnProfile ? () {} : _toggleFollow,
            ),
          ),
          SliverToBoxAdapter(
            child: _StatsSection(user: user),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final app.User user;
  final bool isOwnProfile;
  final VoidCallback onToggleFollow;

  const _ProfileHeader({
    required this.user,
    required this.isOwnProfile,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            backgroundImage: user.avatarUrl != null
                ? CachedNetworkImageProvider(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? Text(
                    user.username.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user.username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          if (user.bio != null && user.bio!.isNotEmpty)
            Text(
              user.bio!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 8),
          if (user.isPublicProfile &&
              ((user.twitterHandle != null && user.twitterHandle!.isNotEmpty) ||
                  (user.instagramHandle != null && user.instagramHandle!.isNotEmpty) ||
                  (user.tiktokHandle != null && user.tiktokHandle!.isNotEmpty) ||
                  (user.websiteUrl != null && user.websiteUrl!.isNotEmpty)))
            Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.center,
              children: [
                if (user.twitterHandle != null && user.twitterHandle!.isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.alternate_email, size: 16),
                    label: Text(user.twitterHandle!),
                  ),
                if (user.instagramHandle != null && user.instagramHandle!.isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.camera_alt_outlined, size: 16),
                    label: Text(user.instagramHandle!),
                  ),
                if (user.tiktokHandle != null && user.tiktokHandle!.isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.music_note_outlined, size: 16),
                    label: Text(user.tiktokHandle!),
                  ),
                if (user.websiteUrl != null && user.websiteUrl!.isNotEmpty)
                  Chip(
                    avatar: const Icon(Icons.link, size: 16),
                    label: Text(user.websiteUrl!),
                  ),
              ],
            ),
          const SizedBox(height: 16),
          if (!isOwnProfile)
            _FollowButton(onToggleFollow: onToggleFollow),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final VoidCallback onToggleFollow;

  const _FollowButton({required this.onToggleFollow});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onToggleFollow,
      icon: const Icon(Icons.person_add),
      label: const Text('Follow'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 40),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final app.User user;

  const _StatsSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Journey Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          if (user.countdownStartDate != null) ...[
            _StatCard(
              icon: Icons.timer,
              title: 'Challenge Started',
              value: DateTimeUtils.formatShortDate(user.countdownStartDate!),
            ),
            const SizedBox(height: 12),
            if (user.daysRemaining != null)
              _StatCard(
                icon: Icons.hourglass_empty,
                title: 'Days Remaining',
                value: '${user.daysRemaining} days',
              ),
            const SizedBox(height: 12),
          ],
          _StatCard(
            icon: Icons.calendar_today,
            title: 'Member Since',
            value: DateTimeUtils.formatShortDate(user.createdAt),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
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
