// ignore_for_file: unused_field

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/notifications_repository.dart';
import '../../../data/repositories/social_repository.dart';
import '../../../bootstrap/supabase_client.dart';
import '../../auth/application/auth_controller.dart';

class SocialNotificationsState {
  final bool isLoading;
  final String? error;
  final bool followNotificationsEnabled;
  final bool milestoneNotificationsEnabled;
  final bool leaderboardNotificationsEnabled;

  const SocialNotificationsState({
    this.isLoading = false,
    this.error,
    this.followNotificationsEnabled = true,
    this.milestoneNotificationsEnabled = true,
    this.leaderboardNotificationsEnabled = true,
  });

  SocialNotificationsState copyWith({
    bool? isLoading,
    String? error,
    bool? followNotificationsEnabled,
    bool? milestoneNotificationsEnabled,
    bool? leaderboardNotificationsEnabled,
  }) {
    return SocialNotificationsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      followNotificationsEnabled: followNotificationsEnabled ?? this.followNotificationsEnabled,
      milestoneNotificationsEnabled: milestoneNotificationsEnabled ?? this.milestoneNotificationsEnabled,
      leaderboardNotificationsEnabled: leaderboardNotificationsEnabled ?? this.leaderboardNotificationsEnabled,
    );
  }
}

class SocialNotificationsController extends StateNotifier<SocialNotificationsState> {
  final NotificationsRepository _notificationsRepository;
  final SocialRepository _socialRepository;
  final AuthController _authController;

  SocialNotificationsController(
    this._notificationsRepository,
    this._socialRepository,
    this._authController,
  ) : super(const SocialNotificationsState());

  Future<void> toggleFollowNotifications(bool enabled) async {
    state = state.copyWith(isLoading: true);
    try {
      state = state.copyWith(
        isLoading: false,
        followNotificationsEnabled: enabled,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleMilestoneNotifications(bool enabled) async {
    state = state.copyWith(isLoading: true);
    try {
      state = state.copyWith(
        isLoading: false,
        milestoneNotificationsEnabled: enabled,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleLeaderboardNotifications(bool enabled) async {
    state = state.copyWith(isLoading: true);
    try {
      state = state.copyWith(
        isLoading: false,
        leaderboardNotificationsEnabled: enabled,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> sendFollowNotification(String followerUserId, String followerUsername) async {
    if (!state.followNotificationsEnabled) return;

    try {
      await _notificationsRepository.showNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'New Follower!',
        body: '$followerUsername started following you',
        payload: 'follow_notification',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendMilestoneNotification(
    String userId,
    String username,
    String goalTitle,
  ) async {
    if (!state.milestoneNotificationsEnabled) return;

    try {
      await _notificationsRepository.showNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'Milestone Completed!',
        body: '$username completed: $goalTitle',
        payload: 'milestone_notification',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendLeaderboardNotification(String message) async {
    if (!state.leaderboardNotificationsEnabled) return;

    try {
      await _notificationsRepository.showNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'Leaderboard Update',
        body: message,
        payload: 'leaderboard_notification',
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final socialNotificationsControllerProvider =
    StateNotifierProvider<SocialNotificationsController, SocialNotificationsState>((ref) {
  final notificationsRepository = ref.watch(notificationsRepositoryProvider);
  final socialRepository = ref.watch(socialRepositoryProvider);
  final authController = ref.watch(authControllerProvider.notifier);

  return SocialNotificationsController(
    notificationsRepository,
    socialRepository,
    authController,
  );
});

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(supabaseClient);
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository();
});
