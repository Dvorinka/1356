import 'package:equatable/equatable.dart';

class GoalStep extends Equatable {
  final String id;
  final String goalId;
  final String title;
  final bool isDone;
  final int orderIndex;
  final DateTime createdAt;

  const GoalStep({
    required this.id,
    required this.goalId,
    required this.title,
    required this.isDone,
    required this.orderIndex,
    required this.createdAt,
  });

  GoalStep copyWith({
    String? id,
    String? goalId,
    String? title,
    bool? isDone,
    int? orderIndex,
    DateTime? createdAt,
  }) {
    return GoalStep(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      orderIndex: orderIndex ?? this.orderIndex,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goal_id': goalId,
      'title': title,
      'is_done': isDone,
      'order_index': orderIndex,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory GoalStep.fromJson(Map<String, dynamic> json) {
    return GoalStep(
      id: json['id'] as String,
      goalId: json['goal_id'] as String,
      title: json['title'] as String,
      isDone: json['is_done'] as bool? ?? false,
      orderIndex: json['order_index'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, goalId, title, isDone, orderIndex, createdAt];
}
