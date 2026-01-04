import 'package:uuid/uuid.dart';

enum MutationType {
  createGoal,
  updateGoal,
  deleteGoal,
  updateGoalProgress,
}

class OfflineMutation {
  final String id;
  final MutationType type;
  final String? goalId;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final bool isSynced;

  OfflineMutation({
    required this.id,
    required this.type,
    this.goalId,
    this.data,
    required this.createdAt,
    this.syncedAt,
    this.isSynced = false,
  });

  OfflineMutation copyWith({
    String? id,
    MutationType? type,
    String? goalId,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? syncedAt,
    bool? isSynced,
  }) {
    return OfflineMutation(
      id: id ?? this.id,
      type: type ?? this.type,
      goalId: goalId ?? this.goalId,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'goal_id': goalId,
      'data': data,
      'created_at': createdAt.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'is_synced': isSynced,
    };
  }

  factory OfflineMutation.fromJson(Map<String, dynamic> json) {
    return OfflineMutation(
      id: json['id'] as String,
      type: MutationType.values.firstWhere(
        (e) => e.name == json['type'] as String,
      ),
      goalId: json['goal_id'] as String?,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      syncedAt: json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null,
      isSynced: json['is_synced'] as bool,
    );
  }

  static OfflineMutation createGoalMutation({
    required String goalId,
    required Map<String, dynamic> goalData,
  }) {
    return OfflineMutation(
      id: const Uuid().v4(),
      type: MutationType.createGoal,
      goalId: goalId,
      data: goalData,
      createdAt: DateTime.now(),
    );
  }

  static OfflineMutation updateGoalMutation({
    required String goalId,
    required Map<String, dynamic> goalData,
  }) {
    return OfflineMutation(
      id: const Uuid().v4(),
      type: MutationType.updateGoal,
      goalId: goalId,
      data: goalData,
      createdAt: DateTime.now(),
    );
  }

  static OfflineMutation deleteGoalMutation({
    required String goalId,
  }) {
    return OfflineMutation(
      id: const Uuid().v4(),
      type: MutationType.deleteGoal,
      goalId: goalId,
      createdAt: DateTime.now(),
    );
  }

  static OfflineMutation updateProgressMutation({
    required String goalId,
    required int progress,
  }) {
    return OfflineMutation(
      id: const Uuid().v4(),
      type: MutationType.updateGoalProgress,
      goalId: goalId,
      data: {'progress': progress},
      createdAt: DateTime.now(),
    );
  }
}
