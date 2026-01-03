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
}
