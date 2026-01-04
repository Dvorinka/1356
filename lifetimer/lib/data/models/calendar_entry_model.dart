import 'package:equatable/equatable.dart';

class CalendarEntry extends Equatable {
  final String id;
  final String userId;
  final String? goalId;
  final DateTime entryDate;
  final String title;
  final String? note;
  final String entryType; // e.g. progress, milestone, reflection
  final DateTime createdAt;

  const CalendarEntry({
    required this.id,
    required this.userId,
    this.goalId,
    required this.entryDate,
    required this.title,
    this.note,
    required this.entryType,
    required this.createdAt,
  });

  CalendarEntry copyWith({
    String? id,
    String? userId,
    String? goalId,
    DateTime? entryDate,
    String? title,
    String? note,
    String? entryType,
    DateTime? createdAt,
  }) {
    return CalendarEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      goalId: goalId ?? this.goalId,
      entryDate: entryDate ?? this.entryDate,
      title: title ?? this.title,
      note: note ?? this.note,
      entryType: entryType ?? this.entryType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'goal_id': goalId,
      'entry_date': entryDate.toIso8601String().split('T').first,
      'title': title,
      'note': note,
      'entry_type': entryType,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CalendarEntry.fromJson(Map<String, dynamic> json) {
    return CalendarEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      goalId: json['goal_id'] as String?,
      entryDate: DateTime.parse(json['entry_date'] as String),
      title: json['title'] as String,
      note: json['note'] as String?,
      entryType: json['entry_type'] as String? ?? 'note',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        goalId,
        entryDate,
        title,
        note,
        entryType,
        createdAt,
      ];
}
