import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/goal_model.dart';
import '../../../data/repositories/goals_repository.dart';
import '../../../data/repositories/countdown_repository.dart';
import '../../../bootstrap/supabase_client.dart';
import '../../auth/application/auth_controller.dart';

class InsightsState {
  final bool isLoading;
  final String? error;
  final List<Goal> goals;
  final int totalGoals;
  final int completedGoals;
  final int activeGoals;
  final double overallProgress;
  final int currentStreak;
  final int longestStreak;
  final DateTime? countdownStartDate;
  final DateTime? countdownEndDate;
  final int daysRemaining;
  final double timeElapsedPercentage;

  const InsightsState({
    this.isLoading = false,
    this.error,
    this.goals = const [],
    this.totalGoals = 0,
    this.completedGoals = 0,
    this.activeGoals = 0,
    this.overallProgress = 0.0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.countdownStartDate,
    this.countdownEndDate,
    this.daysRemaining = 0,
    this.timeElapsedPercentage = 0.0,
  });

  InsightsState copyWith({
    bool? isLoading,
    String? error,
    List<Goal>? goals,
    int? totalGoals,
    int? completedGoals,
    int? activeGoals,
    double? overallProgress,
    int? currentStreak,
    int? longestStreak,
    DateTime? countdownStartDate,
    DateTime? countdownEndDate,
    int? daysRemaining,
    double? timeElapsedPercentage,
  }) {
    return InsightsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      goals: goals ?? this.goals,
      totalGoals: totalGoals ?? this.totalGoals,
      completedGoals: completedGoals ?? this.completedGoals,
      activeGoals: activeGoals ?? this.activeGoals,
      overallProgress: overallProgress ?? this.overallProgress,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      countdownStartDate: countdownStartDate ?? this.countdownStartDate,
      countdownEndDate: countdownEndDate ?? this.countdownEndDate,
      daysRemaining: daysRemaining ?? this.daysRemaining,
      timeElapsedPercentage: timeElapsedPercentage ?? this.timeElapsedPercentage,
    );
  }
}

class InsightsController extends StateNotifier<InsightsState> {
  final GoalsRepository _goalsRepository;
  final CountdownRepository _countdownRepository;
  final AuthController _authController;

  InsightsController(
    this._goalsRepository,
    this._countdownRepository,
    this._authController,
  ) : super(const InsightsState()) {
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final userId = _authController.currentUserId;
    if (userId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final goals = await _goalsRepository.getGoals(userId);
      final countdown = await _countdownRepository.getCountdownInfo(userId);

      final totalGoals = goals.length;
      final completedGoals = goals.where((g) => g.completed).length;
      final activeGoals = totalGoals - completedGoals;
      final overallProgress = totalGoals > 0
          ? (completedGoals / totalGoals) * 100
          : 0.0;

      final currentStreak = _calculateCurrentStreak(goals);
      final longestStreak = _calculateLongestStreak(goals);

      final daysRemaining = countdown.daysRemaining ?? 0;
      final totalDays = countdown.countdownEndDate != null && countdown.countdownStartDate != null
          ? countdown.countdownEndDate!.difference(countdown.countdownStartDate!).inDays
          : 0;
      final elapsedDays = countdown.countdownStartDate != null
          ? DateTime.now().difference(countdown.countdownStartDate!).inDays.clamp(0, totalDays)
          : 0;
      final timeElapsedPercentage = totalDays > 0
          ? (elapsedDays / totalDays) * 100
          : 0.0;

      state = state.copyWith(
        isLoading: false,
        goals: goals,
        totalGoals: totalGoals,
        completedGoals: completedGoals,
        activeGoals: activeGoals,
        overallProgress: overallProgress,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        countdownStartDate: countdown.countdownStartDate,
        countdownEndDate: countdown.countdownEndDate,
        daysRemaining: daysRemaining,
        timeElapsedPercentage: timeElapsedPercentage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  int _calculateCurrentStreak(List<Goal> goals) {
    if (goals.isEmpty) return 0;

    final now = DateTime.now();
    int streak = 0;
    DateTime currentDate = now;

    for (int i = 0; i < 365; i++) {
      final hasActivityOnDay = goals.any((goal) {
        final updatedDate = goal.updatedAt;
        return updatedDate.year == currentDate.year &&
            updatedDate.month == currentDate.month &&
            updatedDate.day == currentDate.day;
      });

      if (hasActivityOnDay) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateLongestStreak(List<Goal> goals) {
    if (goals.isEmpty) return 0;

    final allDates = goals
        .map((g) => g.updatedAt)
        .whereType<DateTime>()
        .toSet()
        .toList()
      ..sort();

    if (allDates.isEmpty) return 0;

    int longestStreak = 1;
    int currentStreak = 1;

    for (int i = 1; i < allDates.length; i++) {
      final difference = allDates[i].difference(allDates[i - 1]).inDays;
      if (difference == 1) {
        currentStreak++;
      } else if (difference > 1) {
        longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;
        currentStreak = 1;
      }
    }

    return longestStreak > currentStreak ? longestStreak : currentStreak;
  }

  List<Map<String, dynamic>> getGoalCompletionTrends() {
    final goals = state.goals;
    if (goals.isEmpty) return [];

    final now = DateTime.now();
    final trends = <Map<String, dynamic>>[];

    for (int i = 6; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: i * 7));
      final weekEnd = weekStart.add(const Duration(days: 7));

      final completedInWeek = goals.where((goal) {
        final updated = goal.updatedAt;
        return goal.completed &&
            updated.isAfter(weekStart) &&
            updated.isBefore(weekEnd);
      }).length;

      trends.add({
        'week': 'Week ${7 - i}',
        'completed': completedInWeek,
      });
    }

    return trends;
  }

  List<Map<String, dynamic>> getProgressVsTimeData() {
    if (state.countdownStartDate == null || state.countdownEndDate == null) {
      return [];
    }

    final start = state.countdownStartDate!;
    final end = state.countdownEndDate!;
    final totalDays = end.difference(start).inDays;
    final elapsedDays = DateTime.now().difference(start).inDays.clamp(0, totalDays);

    final data = <Map<String, dynamic>>[];
    const int intervals = 10;

    for (int i = 0; i <= intervals; i++) {
      final day = (totalDays * i / intervals).round();
      final date = start.add(Duration(days: day));
      final expectedProgress = (i / intervals) * 100;
      final actualProgress = i <= (elapsedDays / totalDays * intervals).round()
          ? state.overallProgress
          : 0.0;

      data.add({
        'day': day,
        'date': date,
        'expected': expectedProgress,
        'actual': actualProgress,
      });
    }

    return data;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> refresh() async {
    await _loadInsights();
  }
}

final insightsControllerProvider =
    StateNotifierProvider<InsightsController, InsightsState>((ref) {
  final goalsRepository = ref.watch(goalsRepositoryProvider);
  final countdownRepository = ref.watch(countdownRepositoryProvider);
  final authController = ref.watch(authControllerProvider.notifier);

  return InsightsController(
    goalsRepository,
    countdownRepository,
    authController,
  );
});

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  return GoalsRepository(supabaseClient);
});

final countdownRepositoryProvider = Provider<CountdownRepository>((ref) {
  return CountdownRepository(supabaseClient);
});
