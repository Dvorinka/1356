import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/achievement_model.dart';
import '../../../data/repositories/achievements_repository.dart';
import '../../../bootstrap/supabase_client.dart';
import '../../auth/application/auth_controller.dart';

class AchievementsState {
  final bool isLoading;
  final String? error;
  final List<Achievement> availableAchievements;
  final List<Achievement> unlockedAchievements;
  final Achievement? newlyUnlocked;

  const AchievementsState({
    this.isLoading = false,
    this.error,
    this.availableAchievements = const [],
    this.unlockedAchievements = const [],
    this.newlyUnlocked,
  });

  int get unlockedCount => unlockedAchievements.length;
  int get totalCount => availableAchievements.length;
  double get completionPercentage =>
      totalCount > 0 ? (unlockedCount / totalCount) * 100 : 0;

  int get level {
    if (unlockedCount <= 0) {
      return 1;
    }
    return 1 + (unlockedCount ~/ 3);
  }

  AchievementsState copyWith({
    bool? isLoading,
    String? error,
    List<Achievement>? availableAchievements,
    List<Achievement>? unlockedAchievements,
    Achievement? newlyUnlocked,
  }) {
    return AchievementsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      availableAchievements: availableAchievements ?? this.availableAchievements,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      newlyUnlocked: newlyUnlocked,
    );
  }
}

class AchievementsController extends StateNotifier<AchievementsState> {
  final AchievementsRepository _repository;
  final AuthController _authController;

  AchievementsController(
    this._repository,
    this._authController,
  ) : super(const AchievementsState()) {
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final userId = _authController.currentUserId;
    if (userId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final available = await _repository.getAvailableAchievements();
      final unlocked = await _repository.getUserAchievements(userId);

      state = state.copyWith(
        isLoading: false,
        availableAchievements: available,
        unlockedAchievements: unlocked,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Achievement?> checkAndUnlockAchievement(
    AchievementType type,
    int currentValue,
  ) async {
    final userId = _authController.currentUserId;
    if (userId == null) return null;

    try {
      final newlyUnlocked = await _repository.checkAndUnlockAchievement(
        userId,
        type,
        currentValue,
      );

      if (newlyUnlocked != null) {
        final updatedUnlocked = [...state.unlockedAchievements, newlyUnlocked];
        state = state.copyWith(
          unlockedAchievements: updatedUnlocked,
          newlyUnlocked: newlyUnlocked,
        );
        return newlyUnlocked;
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }

    return null;
  }

  void clearNewlyUnlocked() {
    state = state.copyWith(newlyUnlocked: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refresh() async {
    await _loadAchievements();
  }
}

final achievementsControllerProvider =
    StateNotifierProvider<AchievementsController, AchievementsState>((ref) {
  final achievementsRepository = ref.watch(achievementsRepositoryProvider);
  final authController = ref.watch(authControllerProvider.notifier);

  return AchievementsController(
    achievementsRepository,
    authController,
  );
});

final achievementsRepositoryProvider = Provider<AchievementsRepository>((ref) {
  return AchievementsRepository(supabaseClient);
});
