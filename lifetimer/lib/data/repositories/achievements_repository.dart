import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/achievement_model.dart';
import '../../core/errors/failure.dart';

class AchievementsRepository {
  final supabase.SupabaseClient _client;

  AchievementsRepository(this._client);

  static final List<Achievement> _availableAchievements = [
    Achievement(
      id: 'first_goal',
      title: 'First Goal',
      description: 'Complete your first goal',
      icon: '🎯',
      type: AchievementType.firstGoal,
      threshold: 1,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'goals_5',
      title: '5 Goals Completed',
      description: 'Complete 5 goals',
      icon: '⭐',
      type: AchievementType.goalsCompleted5,
      threshold: 5,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'goals_10',
      title: '10 Goals Completed',
      description: 'Complete 10 goals',
      icon: '🌟',
      type: AchievementType.goalsCompleted10,
      threshold: 10,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'goals_20',
      title: '20 Goals Completed',
      description: 'Complete all 20 goals',
      icon: '💫',
      type: AchievementType.goalsCompleted20,
      threshold: 20,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'streak_7',
      title: '7 Day Streak',
      description: 'Update progress for 7 consecutive days',
      icon: '🔥',
      type: AchievementType.streak7Days,
      threshold: 7,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'streak_30',
      title: '30 Day Streak',
      description: 'Update progress for 30 consecutive days',
      icon: '🏆',
      type: AchievementType.streak30Days,
      threshold: 30,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'countdown_started',
      title: 'Challenge Started',
      description: 'Start your 1356-day countdown',
      icon: '🚀',
      type: AchievementType.countdownStarted,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'countdown_25',
      title: '25% Complete',
      description: 'Reach 25% of your countdown',
      icon: '📊',
      type: AchievementType.countdown25Percent,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'countdown_50',
      title: '50% Complete',
      description: 'Reach 50% of your countdown',
      icon: '📈',
      type: AchievementType.countdown50Percent,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'countdown_75',
      title: '75% Complete',
      description: 'Reach 75% of your countdown',
      icon: '📉',
      type: AchievementType.countdown75Percent,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'countdown_complete',
      title: 'Challenge Complete',
      description: 'Complete your 1356-day challenge',
      icon: '🎉',
      type: AchievementType.countdownCompleted,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'Update progress before 8 AM',
      icon: '🌅',
      type: AchievementType.earlyBird,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'night_owl',
      title: 'Night Owl',
      description: 'Update progress after 10 PM',
      icon: '🌙',
      type: AchievementType.nightOwl,
      unlockedAt: DateTime.now(),
    ),
    Achievement(
      id: 'social_butterfly',
      title: 'Social Butterfly',
      description: 'Follow 10 users',
      icon: '🦋',
      type: AchievementType.socialButterfly,
      threshold: 10,
      unlockedAt: DateTime.now(),
    ),
  ];

  Future<List<Achievement>> getAvailableAchievements() async {
    return _availableAchievements;
  }

  Future<List<Achievement>> getUserAchievements(String userId) async {
    try {
      final response = await _client
          .from('user_achievements')
          .select('*, achievements(*)')
          .eq('user_id', userId);

      return response.map((json) {
        final achievementData = json['achievements'] as Map<String, dynamic>;
        return Achievement.fromJson(achievementData).copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.parse(json['unlocked_at'] as String),
        );
      }).toList();
    } catch (e) {
      if (e is supabase.PostgrestException && e.code == '42P01') {
        return [];
      }
      throw _handleError(e);
    }
  }

  Future<void> unlockAchievement(String userId, String achievementId) async {
    try {
      await _client.from('user_achievements').insert({
        'user_id': userId,
        'achievement_id': achievementId,
        'unlocked_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Achievement?> checkAndUnlockAchievement(
    String userId,
    AchievementType type,
    int currentValue,
  ) async {
    final achievement = _availableAchievements.firstWhere(
      (a) => a.type == type,
    );

    if (achievement.threshold != null && currentValue >= achievement.threshold!) {
      final userAchievements = await getUserAchievements(userId);
      final alreadyUnlocked = userAchievements.any((a) => a.type == type);

      if (!alreadyUnlocked) {
        await unlockAchievement(userId, achievement.id);
        return achievement.copyWith(isUnlocked: true, unlockedAt: DateTime.now());
      }
    }

    return null;
  }

  Failure _handleError(dynamic error) {
    if (error is supabase.PostgrestException) {
      return ServerFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}
