import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../data/models/user_model.dart' as app;
import '../../../data/repositories/user_repository.dart';
import '../../../core/errors/failure.dart';

final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final client = supabase.Supabase.instance.client;
  final repository = UserRepository(client);
  return ProfileController(repository);
});

class ProfileController extends StateNotifier<ProfileState> {
  final UserRepository _repository;

  ProfileController(this._repository) : super(const ProfileState.initial());

  Future<void> loadProfile(String userId) async {
    state = const ProfileState.loading();
    try {
      final user = await _repository.getProfile(userId);
      state = ProfileState.loaded(user);
    } on Failure catch (failure) {
      state = ProfileState.error(failure.message);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> updateUsername(String userId, String username) async {
    state = const ProfileState.loading();
    try {
      final isAvailable = await _repository.isUsernameAvailable(username);
      if (!isAvailable) {
        state = const ProfileState.error('Username is already taken');
        return;
      }

      final updatedUser = await _repository.updateProfile(
        userId: userId,
        username: username,
      );
      state = ProfileState.loaded(updatedUser);
    } on Failure catch (failure) {
      state = ProfileState.error(failure.message);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> updateBio(String userId, String bio) async {
    state = const ProfileState.loading();
    try {
      final updatedUser = await _repository.updateProfile(
        userId: userId,
        bio: bio,
      );
      state = ProfileState.loaded(updatedUser);
    } on Failure catch (failure) {
      state = ProfileState.error(failure.message);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
    state = const ProfileState.loading();
    try {
      final updatedUser = await _repository.updateProfile(
        userId: userId,
        avatarUrl: avatarUrl,
      );
      state = ProfileState.loaded(updatedUser);
    } on Failure catch (failure) {
      state = ProfileState.error(failure.message);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> toggleProfileVisibility(String userId) async {
    final currentState = state;
    if (currentState.user == null) return;
    
    state = const ProfileState.loading();
    try {
      final updatedUser = await _repository.updateProfile(
        userId: userId,
        isPublicProfile: !currentState.user!.isPublicProfile,
      );
      state = ProfileState.loaded(updatedUser);
    } on Failure catch (failure) {
      state = ProfileState.error(failure.message);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<void> completeProfileSetup({
    required String userId,
    required String username,
    String? bio,
    String? avatarUrl,
    String? twitterHandle,
    String? instagramHandle,
    String? tiktokHandle,
    String? websiteUrl,
  }) async {
    state = const ProfileState.loading();
    try {
      final isAvailable = await _repository.isUsernameAvailable(username);
      if (!isAvailable) {
        state = const ProfileState.error('Username is already taken');
        return;
      }

      final updatedUser = await _repository.updateProfile(
        userId: userId,
        username: username,
        bio: bio,
        avatarUrl: avatarUrl,
        twitterHandle: twitterHandle,
        instagramHandle: instagramHandle,
        tiktokHandle: tiktokHandle,
        websiteUrl: websiteUrl,
      );
      state = ProfileState.loaded(updatedUser);
    } on Failure catch (failure) {
      state = ProfileState.error(failure.message);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }
}

class ProfileState {
  final bool isLoading;
  final app.User? user;
  final String? errorMessage;

  const ProfileState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  const ProfileState.initial() : isLoading = false, user = null, errorMessage = null;

  const ProfileState.loading() : isLoading = true, user = null, errorMessage = null;

  const ProfileState.loaded(this.user)
      : isLoading = false,
        errorMessage = null;

  const ProfileState.error(this.errorMessage)
      : isLoading = false,
        user = null;
}

typedef ProfileStateLoaded = ProfileState;
