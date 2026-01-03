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
          .single();

      return app.User.fromJson(response);
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
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;
      if (isPublicProfile != null) updates['is_public_profile'] = isPublicProfile;
      updates['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('users')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return app.User.fromJson(response);
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
