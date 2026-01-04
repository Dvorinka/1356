import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/notifications_repository.dart';
import '../../../bootstrap/supabase_client.dart';
import '../../auth/application/auth_controller.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(supabaseClient);
});

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  return NotificationsRepository();
});

class SettingsState {
  final bool isLoading;
  final String? error;
  final bool notificationsEnabled;

  const SettingsState({
    this.isLoading = false,
    this.error,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    bool? isLoading,
    String? error,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  final UserRepository _userRepository;
  final NotificationsRepository _notificationsRepository;
  final AuthController _authController;

  SettingsController(
    this._userRepository,
    this._notificationsRepository,
    this._authController,
  ) : super(const SettingsState());

  Future<void> toggleNotifications(bool enabled) async {
    state = state.copyWith(isLoading: true);
    try {
      state = state.copyWith(
        isLoading: false,
        notificationsEnabled: enabled,
      );
      if (!enabled) {
        await _notificationsRepository.cancelAllNotifications();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isLoading: true);
    try {
      final userId = _authController.currentUserId;
      if (userId != null) {
        await _userRepository.deleteAccount(userId);
        await _authController.signOut();
        state = const SettingsState();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, SettingsState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final notificationsRepository = ref.watch(notificationsRepositoryProvider);
  final authController = ref.watch(authControllerProvider.notifier);

  return SettingsController(
    userRepository,
    notificationsRepository,
    authController,
  );
});
