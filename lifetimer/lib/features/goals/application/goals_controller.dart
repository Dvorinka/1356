import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/goal_model.dart';
import '../../../data/repositories/goals_repository.dart';
import '../../../bootstrap/supabase_client.dart';
import '../../../core/errors/failure.dart';
import '../../../core/services/analytics_service.dart';
import '../../auth/application/auth_controller.dart';

class GoalsController extends StateNotifier<GoalsState> {
  final GoalsRepository _repository;
  final String _userId;
  final AnalyticsService _analytics = AnalyticsService();

  GoalsController(this._repository, this._userId) : super(const GoalsState.initial()) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    state = const GoalsState.loading();
    try {
      final goals = await _repository.getGoals(_userId);
      state = GoalsState.loaded(goals);
    } catch (e) {
      state = GoalsState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'loadGoals');
    }
  }

  Future<void> createGoal(Goal goal) async {
    try {
      final currentGoalsCount = await _repository.getGoalsCount(_userId);
      if (currentGoalsCount >= GoalsRepository.maxGoals) {
        throw const ValidationFailure('You can only have up to ${GoalsRepository.maxGoals} goals in your bucket list');
      }

      await _repository.createGoal(goal);
      _analytics.logGoalCreated(
        goalId: goal.id,
        hasLocation: goal.hasLocation.toString(),
        hasImage: goal.hasImage.toString(),
      );
      await loadGoals();
    } on Failure catch (failure) {
      state = GoalsState.error(failure.message);
      _analytics.logError(error: failure.message, context: 'createGoal');
    } catch (e) {
      state = GoalsState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'createGoal');
    }
  }

  Future<void> updateGoal(Goal goal) async {
    try {
      await _repository.updateGoal(goal);
      _analytics.logGoalUpdated(goalId: goal.id);
      await loadGoals();
    } on Failure catch (failure) {
      state = GoalsState.error(failure.message);
      _analytics.logError(error: failure.message, context: 'updateGoal');
    } catch (e) {
      state = GoalsState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'updateGoal');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      final canModify = await _repository.canModifyGoals(_userId);
      if (!canModify) {
        throw const ValidationFailure('Cannot delete goals after countdown has started');
      }

      await _repository.deleteGoal(goalId);
      _analytics.logGoalDeleted(goalId: goalId);
      await loadGoals();
    } on Failure catch (failure) {
      state = GoalsState.error(failure.message);
      _analytics.logError(error: failure.message, context: 'deleteGoal');
    } catch (e) {
      state = GoalsState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'deleteGoal');
    }
  }

  Future<void> updateGoalProgress(String goalId, int progress) async {
    try {
      final goals = state.goals;
      final goal = goals.firstWhere((g) => g.id == goalId);
      final updatedGoal = goal.copyWith(progress: progress);
      await _repository.updateGoal(updatedGoal);
      await loadGoals();
    } on Failure catch (failure) {
      state = GoalsState.error(failure.message);
      _analytics.logError(error: failure.message, context: 'updateGoalProgress');
    } catch (e) {
      state = GoalsState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'updateGoalProgress');
    }
  }

  Future<void> markGoalAsCompleted(String goalId) async {
    try {
      final goals = state.goals;
      final goal = goals.firstWhere((g) => g.id == goalId);
      final updatedGoal = goal.copyWith(
        progress: 100,
        completed: true,
      );
      await _repository.updateGoal(updatedGoal);
      
      final daysInChallenge = goal.createdAt.difference(DateTime.now()).inDays.abs();
      _analytics.logGoalCompleted(
        goalId: goalId,
        daysInChallenge: daysInChallenge,
      );
      
      await loadGoals();
    } on Failure catch (failure) {
      state = GoalsState.error(failure.message);
      _analytics.logError(error: failure.message, context: 'markGoalAsCompleted');
    } catch (e) {
      state = GoalsState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'markGoalAsCompleted');
    }
  }

  bool get canAddMoreGoals {
    return state.goals.length < GoalsRepository.maxGoals;
  }

  int get remainingGoalsSlots {
    return GoalsRepository.maxGoals - state.goals.length;
  }
}

class GoalsState {
  final bool isLoading;
  final List<Goal> goals;
  final String? error;

  const GoalsState({
    this.isLoading = false,
    this.goals = const [],
    this.error,
  });

  const GoalsState.initial() : isLoading = false, goals = const [], error = null;

  const GoalsState.loading() : isLoading = true, goals = const [], error = null;

  const GoalsState.loaded(this.goals) : isLoading = false, error = null;

  const GoalsState.error(this.error) : isLoading = false, goals = const [];
}

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepository(supabaseClient);
});

final goalsControllerProvider = StateNotifierProvider<GoalsController, GoalsState>((ref) {
  final repository = ref.watch(goalsRepositoryProvider);
  final authController = ref.read(authControllerProvider.notifier);
  final userId = authController.currentUserId ?? '';
  
  if (userId.isEmpty) {
    return GoalsController(repository, 'placeholder_user_id');
  }
  
  return GoalsController(repository, userId);
});
