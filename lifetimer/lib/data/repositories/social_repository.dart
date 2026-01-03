import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user_model.dart' as app;
import '../models/activity_model.dart';
import '../../core/errors/failure.dart';

class SocialRepository {
  final supabase.SupabaseClient _client;

  SocialRepository(this._client);

  Future<void> followUser(String userId, String targetUserId) async {
    try {
      await _client.from('followers').insert({
        'user_id': targetUserId,
        'follower_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> unfollowUser(String userId, String targetUserId) async {
    try {
      await _client
          .from('followers')
          .delete()
          .eq('user_id', targetUserId)
          .eq('follower_id', userId);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> isFollowing(String userId, String targetUserId) async {
    try {
      final response = await _client
          .from('followers')
          .select('id')
          .eq('user_id', targetUserId)
          .eq('follower_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<app.User>> getFollowers(String userId) async {
    try {
      final response = await _client
          .from('followers')
          .select('follower_id, users!followers_follower_id_fkey(*)')
          .eq('user_id', userId);

      return (response as List)
          .map((json) => app.User.fromJson(json['users']))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<app.User>> getFollowing(String userId) async {
    try {
      final response = await _client
          .from('followers')
          .select('user_id, users!followers_user_id_fkey(*)')
          .eq('follower_id', userId);

      return (response as List)
          .map((json) => app.User.fromJson(json['users']))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Activity>> getActivityFeed(String userId) async {
    try {
      final response = await _client
          .from('activities')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);

      return (response as List).map((json) => Activity.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Activity> logActivity({
    required String userId,
    required String type,
    Map<String, dynamic>? payload,
  }) async {
    try {
      final response = await _client
          .from('activities')
          .insert({
            'user_id': userId,
            'type': type,
            'payload': payload,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return Activity.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<app.User>> getLeaderboard({
    required String sortBy,
    int limit = 50,
  }) async {
    try {
      String orderBy;
      switch (sortBy) {
        case 'goals_completed':
          orderBy = 'goals_completed_count';
          break;
        case 'streak':
          orderBy = 'streak_days';
          break;
        default:
          orderBy = 'created_at';
      }

      final response = await _client
          .from('users')
          .select()
          .eq('is_public_profile', true)
          .order(orderBy, ascending: false)
          .limit(limit);

      return (response as List).map((json) => app.User.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(dynamic error) {
    if (error is supabase.PostgrestException) {
      return ServerFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}
