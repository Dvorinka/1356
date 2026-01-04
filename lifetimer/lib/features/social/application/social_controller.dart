import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/user_model.dart' as app;
import '../../../data/models/activity_model.dart';
import '../../../data/repositories/social_repository.dart';
import '../../../bootstrap/supabase_client.dart';
import '../../auth/application/auth_controller.dart';

class SocialController extends StateNotifier<SocialState> {
  final SocialRepository _repository;
  final String _currentUserId;

  SocialController(this._repository, this._currentUserId)
      : super(const SocialState.initial());

  Future<void> loadFollowers(String userId) async {
    state = const SocialState.loading();
    try {
      final followers = await _repository.getFollowers(userId);
      state = SocialState.followersLoaded(followers);
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }

  Future<void> loadFollowing(String userId) async {
    state = const SocialState.loading();
    try {
      final following = await _repository.getFollowing(userId);
      state = SocialState.followingLoaded(following);
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }

  Future<void> loadActivityFeed(String userId) async {
    state = const SocialState.loading();
    try {
      final activities = await _repository.getActivityFeed(userId);
      state = SocialState.feedLoaded(activities);
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }

  Future<void> followUser(String targetUserId) async {
    try {
      await _repository.followUser(_currentUserId, targetUserId);
      await _repository.logActivity(
        userId: _currentUserId,
        type: 'followed_user',
        payload: {'target_user_id': targetUserId},
      );
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }

  Future<void> unfollowUser(String targetUserId) async {
    try {
      await _repository.unfollowUser(_currentUserId, targetUserId);
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }

  Future<bool> isFollowing(String targetUserId) async {
    try {
      return await _repository.isFollowing(_currentUserId, targetUserId);
    } catch (e) {
      return false;
    }
  }

  Future<void> loadLeaderboard({required String sortBy, int limit = 50}) async {
    state = const SocialState.loading();
    try {
      final leaderboard = await _repository.getLeaderboard(
        sortBy: sortBy,
        limit: limit,
      );
      state = SocialState.leaderboardLoaded(leaderboard);
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }

  Future<void> logGoalCompletion(String goalId) async {
    try {
      await _repository.logActivity(
        userId: _currentUserId,
        type: 'goal_completed',
        payload: {'goal_id': goalId},
      );
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }

  Future<void> logMilestoneCompletion(String goalId, String milestone) async {
    try {
      await _repository.logActivity(
        userId: _currentUserId,
        type: 'milestone_completed',
        payload: {
          'goal_id': goalId,
          'milestone': milestone,
        },
      );
    } catch (e) {
      state = SocialState.error(e.toString());
    }
  }
}

class SocialState {
  final bool isLoading;
  final List<app.User>? followers;
  final List<app.User>? following;
  final List<Activity>? feed;
  final List<app.User>? leaderboard;
  final String? error;

  const SocialState({
    this.isLoading = false,
    this.followers,
    this.following,
    this.feed,
    this.leaderboard,
    this.error,
  });

  const SocialState.initial() : isLoading = false, followers = null, following = null, feed = null, leaderboard = null, error = null;

  const SocialState.loading() : isLoading = true, followers = null, following = null, feed = null, leaderboard = null, error = null;

  const SocialState.followersLoaded(this.followers) : isLoading = false, following = null, feed = null, leaderboard = null, error = null;

  const SocialState.followingLoaded(this.following) : isLoading = false, followers = null, feed = null, leaderboard = null, error = null;

  const SocialState.feedLoaded(this.feed) : isLoading = false, followers = null, following = null, leaderboard = null, error = null;

  const SocialState.leaderboardLoaded(this.leaderboard) : isLoading = false, followers = null, following = null, feed = null, error = null;

  const SocialState.error(this.error) : isLoading = false, followers = null, following = null, feed = null, leaderboard = null;
}

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(supabaseClient);
});

final socialControllerProvider = StateNotifierProvider<SocialController, SocialState>((ref) {
  final repository = ref.watch(socialRepositoryProvider);
  final authController = ref.read(authControllerProvider.notifier);
  final currentUserId = authController.currentUserId ?? '';
  
  if (currentUserId.isEmpty) {
    return SocialController(repository, 'placeholder_user_id');
  }
  
  return SocialController(repository, currentUserId);
});
