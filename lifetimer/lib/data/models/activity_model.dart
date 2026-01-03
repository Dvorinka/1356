import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final String id;
  final String userId;
  final String type;
  final Map<String, dynamic>? payload;
  final DateTime createdAt;

  const Activity({
    required this.id,
    required this.userId,
    required this.type,
    this.payload,
    required this.createdAt,
  });

  Activity copyWith({
    String? id,
    String? userId,
    String? type,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'payload': payload,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [id, userId, type, payload, createdAt];
}
