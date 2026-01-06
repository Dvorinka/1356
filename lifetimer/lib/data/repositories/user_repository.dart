import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user_model.dart' as app;
import '../../core/errors/failure.dart';

class UserRepository {
  final supabase.SupabaseClient _client;

  UserRepository(this._client);

  Future<app.User> getProfile(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return app.User.fromJson(response);
      } else {
        throw const ServerFailure('User profile not found');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<app.User> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    String? bio,
    bool? isPublicProfile,
    String? twitterHandle,
    String? instagramHandle,
    String? tiktokHandle,
    String? websiteUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;
      if (isPublicProfile != null) updates['is_public_profile'] = isPublicProfile;
      if (twitterHandle != null) updates['twitter_handle'] = twitterHandle;
      if (instagramHandle != null) updates['instagram_handle'] = instagramHandle;
      if (tiktokHandle != null) updates['tiktok_handle'] = tiktokHandle;
      if (websiteUrl != null) updates['website_url'] = websiteUrl;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select();

      if (response.isNotEmpty) {
        return app.User.fromJson(response.first);
      } else {
        throw const ServerFailure('Failed to update profile');
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    try {
      final response = await _client
          .from('users')
          .select('id')
          .eq('username', username)
          .maybeSingle();

      return response == null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteAccount(String userId) async {
    try {
      await _client.from('users').delete().eq('id', userId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(dynamic error) {
    if (error is supabase.PostgrestException) {
      if (error.code == '23505') {
        return const ValidationFailure('Username already taken');
      }
      return ServerFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}
