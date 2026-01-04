import 'package:hive/hive.dart';

part 'cached_goal.g.dart';

@HiveType(typeId: 0)
class CachedGoal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ownerId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final int progress;

  @HiveField(5)
  final double? locationLat;

  @HiveField(6)
  final double? locationLng;

  @HiveField(7)
  final String? locationName;

  @HiveField(8)
  final String? imageUrl;

  @HiveField(9)
  final bool completed;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final DateTime updatedAt;

  @HiveField(12)
  final bool isDirty;

  CachedGoal({
    required this.id,
    required this.ownerId,
    required this.title,
    this.description,
    required this.progress,
    this.locationLat,
    this.locationLng,
    this.locationName,
    this.imageUrl,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
    this.isDirty = false,
  });

  CachedGoal copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? description,
    int? progress,
    double? locationLat,
    double? locationLng,
    String? locationName,
    String? imageUrl,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDirty,
  }) {
    return CachedGoal(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      locationName: locationName ?? this.locationName,
      imageUrl: imageUrl ?? this.imageUrl,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'title': title,
      'description': description,
      'progress': progress,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'location_name': locationName,
      'image_url': imageUrl,
      'completed': completed,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory CachedGoal.fromJson(Map<String, dynamic> json) {
    return CachedGoal(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      progress: json['progress'] as int,
      locationLat: json['location_lat'] as double?,
      locationLng: json['location_lng'] as double?,
      locationName: json['location_name'] as String?,
      imageUrl: json['image_url'] as String?,
      completed: json['completed'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
