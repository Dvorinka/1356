import 'package:hive_flutter/hive_flutter.dart';
import '../models/cached_goal_model.dart';

class OfflineCacheService {
  static const String _goalsBoxName = 'cached_goals';
  static const String _userBoxName = 'cached_user';
  static const String _countdownBoxName = 'cached_countdown';

  late Box<CachedGoal> _goalsBox;
  late Box _userBox;
  late Box _countdownBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CachedGoalAdapter());
    }
    
    _goalsBox = await Hive.openBox<CachedGoal>(_goalsBoxName);
    _userBox = await Hive.openBox(_userBoxName);
    _countdownBox = await Hive.openBox(_countdownBoxName);
  }

  Future<void> cacheGoals(List<CachedGoal> goals) async {
    await _goalsBox.clear();
    for (var goal in goals) {
      await _goalsBox.put(goal.id, goal);
    }
  }

  Future<List<CachedGoal>> getCachedGoals() async {
    return _goalsBox.values.toList();
  }

  Future<CachedGoal?> getCachedGoal(String goalId) async {
    return _goalsBox.get(goalId);
  }

  Future<void> cacheGoal(CachedGoal goal) async {
    await _goalsBox.put(goal.id, goal);
  }

  Future<void> deleteCachedGoal(String goalId) async {
    await _goalsBox.delete(goalId);
  }

  Future<void> markGoalAsDirty(String goalId) async {
    final goal = _goalsBox.get(goalId);
    if (goal != null) {
      await _goalsBox.put(goalId, goal.copyWith(isDirty: true));
    }
  }

  Future<List<CachedGoal>> getDirtyGoals() async {
    return _goalsBox.values.where((goal) => goal.isDirty).toList();
  }

  Future<void> clearDirtyFlag(String goalId) async {
    final goal = _goalsBox.get(goalId);
    if (goal != null) {
      await _goalsBox.put(goalId, goal.copyWith(isDirty: false));
    }
  }

  Future<void> cacheUserData(Map<String, dynamic> userData) async {
    await _userBox.putAll(userData);
  }

  Future<Map<String, dynamic>> getCachedUserData() async {
    return Map<String, dynamic>.from(_userBox.toMap());
  }

  Future<void> cacheCountdownData(Map<String, dynamic> countdownData) async {
    await _countdownBox.putAll(countdownData);
  }

  Future<Map<String, dynamic>> getCachedCountdownData() async {
    return Map<String, dynamic>.from(_countdownBox.toMap());
  }

  Future<void> clearAllCache() async {
    await _goalsBox.clear();
    await _userBox.clear();
    await _countdownBox.clear();
  }

  Future<void> close() async {
    await _goalsBox.close();
    await _userBox.close();
    await _countdownBox.close();
  }
}
