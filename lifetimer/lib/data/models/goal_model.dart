import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final String id;
  final String ownerId;
  final String title;
  final String? description;
  final int progress;
  final double? locationLat;
  final double? locationLng;
  final String? locationName;
  final String? imageUrl;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Goal({
    required this.id,
    required this.ownerId,
    required this.title,
    this.description,
    this.progress = 0,
    this.locationLat,
    this.locationLng,
    this.locationName,
    this.imageUrl,
    this.completed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasLocation => locationLat != null && locationLng != null;
  
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  Goal copyWith({
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
  }) {
    return Goal(
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
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        title,
        description,
        progress,
        locationLat,
        locationLng,
        locationName,
        imageUrl,
        completed,
        createdAt,
        updatedAt,
      ];
}
