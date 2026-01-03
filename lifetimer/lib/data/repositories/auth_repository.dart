import '../models/user_model.dart';
import '../../bootstrap/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository([SupabaseClient? client]) : _client = client ?? supabaseClient;

  Stream<User?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((data) {
      final session = data.session;
      if (session?.user != null) {
        return _mapSupabaseUserToAppUser(session!.user);
      }
      return null;
    });
  }

  User? get currentUser {
    final user = _client.auth.currentUser;
    return user != null ? _mapSupabaseUserToAppUser(user) : null;
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUpWithEmail(String email, String password, String username) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
    
    if (response.user != null) {
      await _createUserProfile(response.user!.id, username, email);
    }
  }

  Future<void> signInWithGoogle() async {
    // TODO: Implement Google OAuth
    // await _client.auth.signInWithOAuth(OAuthProvider.google);
    throw UnimplementedError('Google OAuth not implemented yet');
  }

  Future<void> signInWithApple() async {
    // TODO: Implement Apple OAuth
    // await _client.auth.signInWithOAuth(OAuthProvider.apple);
    throw UnimplementedError('Apple OAuth not implemented yet');
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
    bool? isPublicProfile,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final updates = <String, dynamic>{};
    if (username != null) updates['username'] = username;
    if (bio != null) updates['bio'] = bio;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (isPublicProfile != null) updates['is_public_profile'] = isPublicProfile;
    updates['updated_at'] = DateTime.now().toIso8601String();

    await _client
        .from('users')
        .update(updates)
        .eq('id', userId);
  }

  Future<User> _createUserProfile(String userId, String username, String email) async {
    final now = DateTime.now().toIso8601String();
    
    final response = await _client.from('users').insert({
      'id': userId,
      'username': username,
      'email': email,
      'created_at': now,
      'updated_at': now,
    }).select().single();

    return _mapSupabaseDataToUser(response);
  }

  User _mapSupabaseUserToAppUser(dynamic supabaseUser) {
    return User(
      id: supabaseUser.id,
      username: supabaseUser.userMetadata?['username'] ?? '',
      email: supabaseUser.email ?? '',
      createdAt: DateTime.tryParse(supabaseUser.createdAt ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(supabaseUser.updatedAt ?? '') ?? DateTime.now(),
    );
  }

  User _mapSupabaseDataToUser(Map<String, dynamic> data) {
    return User(
      id: data['id'],
      username: data['username'],
      email: data['email'],
      avatarUrl: data['avatar_url'],
      bio: data['bio'],
      isPublicProfile: data['is_public_profile'] ?? false,
      countdownStartDate: data['countdown_start_date'] != null 
          ? DateTime.parse(data['countdown_start_date'])
          : null,
      countdownEndDate: data['countdown_end_date'] != null
          ? DateTime.parse(data['countdown_end_date'])
          : null,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }
}
