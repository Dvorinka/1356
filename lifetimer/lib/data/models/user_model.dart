import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final bool isPublicProfile;
  final DateTime? countdownStartDate;
  final DateTime? countdownEndDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.isPublicProfile = false,
    this.countdownStartDate,
    this.countdownEndDate,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasCountdownStarted => countdownStartDate != null;
  
  bool get isCountdownActive {
    if (!hasCountdownStarted || countdownEndDate == null) return false;
    return DateTime.now().isBefore(countdownEndDate!);
  }

  int? get daysRemaining {
    if (!isCountdownActive) return null;
    return countdownEndDate!.difference(DateTime.now()).inDays;
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    bool? isPublicProfile,
    DateTime? countdownStartDate,
    DateTime? countdownEndDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isPublicProfile: isPublicProfile ?? this.isPublicProfile,
      countdownStartDate: countdownStartDate ?? this.countdownStartDate,
      countdownEndDate: countdownEndDate ?? this.countdownEndDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        avatarUrl,
        bio,
        isPublicProfile,
        countdownStartDate,
        countdownEndDate,
        createdAt,
        updatedAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'is_public_profile': isPublicProfile,
      'countdown_start_date': countdownStartDate?.toIso8601String(),
      'countdown_end_date': countdownEndDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      isPublicProfile: json['is_public_profile'] as bool? ?? false,
      countdownStartDate: json['countdown_start_date'] != null
          ? DateTime.parse(json['countdown_start_date'] as String)
          : null,
      countdownEndDate: json['countdown_end_date'] != null
          ? DateTime.parse(json['countdown_end_date'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
