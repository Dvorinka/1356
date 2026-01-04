import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementType type;
  final int? threshold;
  final DateTime unlockedAt;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    this.threshold,
    required this.unlockedAt,
    this.isUnlocked = false,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    AchievementType? type,
    int? threshold,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      threshold: threshold ?? this.threshold,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        type,
        threshold,
        unlockedAt,
        isUnlocked,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'type': type.toString(),
      'threshold': threshold,
      'unlocked_at': unlockedAt.toIso8601String(),
      'is_unlocked': isUnlocked,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AchievementType.custom,
      ),
      threshold: json['threshold'] as int?,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'] as String)
          : DateTime.now(),
      isUnlocked: json['is_unlocked'] as bool? ?? false,
    );
  }
}

enum AchievementType {
  firstGoal,
  goalsCompleted5,
  goalsCompleted10,
  goalsCompleted20,
  streak7Days,
  streak30Days,
  countdownStarted,
  countdown25Percent,
  countdown50Percent,
  countdown75Percent,
  countdownCompleted,
  earlyBird,
  nightOwl,
  socialButterfly,
  custom,
}

extension AchievementTypeExtension on AchievementType {
  String get displayName {
    switch (this) {
      case AchievementType.firstGoal:
        return 'First Goal';
      case AchievementType.goalsCompleted5:
        return '5 Goals';
      case AchievementType.goalsCompleted10:
        return '10 Goals';
      case AchievementType.goalsCompleted20:
        return '20 Goals';
      case AchievementType.streak7Days:
        return '7 Day Streak';
      case AchievementType.streak30Days:
        return '30 Day Streak';
      case AchievementType.countdownStarted:
        return 'Challenge Started';
      case AchievementType.countdown25Percent:
        return '25% Complete';
      case AchievementType.countdown50Percent:
        return '50% Complete';
      case AchievementType.countdown75Percent:
        return '75% Complete';
      case AchievementType.countdownCompleted:
        return 'Challenge Complete';
      case AchievementType.earlyBird:
        return 'Early Bird';
      case AchievementType.nightOwl:
        return 'Night Owl';
      case AchievementType.socialButterfly:
        return 'Social Butterfly';
      case AchievementType.custom:
        return 'Custom';
    }
  }

  String get iconEmoji {
    switch (this) {
      case AchievementType.firstGoal:
        return '🎯';
      case AchievementType.goalsCompleted5:
        return '⭐';
      case AchievementType.goalsCompleted10:
        return '🌟';
      case AchievementType.goalsCompleted20:
        return '💫';
      case AchievementType.streak7Days:
        return '🔥';
      case AchievementType.streak30Days:
        return '🏆';
      case AchievementType.countdownStarted:
        return '🚀';
      case AchievementType.countdown25Percent:
        return '📊';
      case AchievementType.countdown50Percent:
        return '📈';
      case AchievementType.countdown75Percent:
        return '📉';
      case AchievementType.countdownCompleted:
        return '🎉';
      case AchievementType.earlyBird:
        return '🌅';
      case AchievementType.nightOwl:
        return '🌙';
      case AchievementType.socialButterfly:
        return '🦋';
      case AchievementType.custom:
        return '🏅';
    }
  }
}
