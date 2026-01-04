import 'dart:async';
import '../models/user_model.dart';
import '../../bootstrap/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final supabase.SupabaseClient _client;
  StreamSubscription<supabase.AuthState>? _authStateSubscription;

  AuthRepository([supabase.SupabaseClient? client]) : _client = client ?? supabaseClient;

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

  bool get isAuthenticated => _client.auth.currentUser != null;

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<bool> isSessionValid() async {
    final session = _client.auth.currentSession;
    if (session == null) return false;
    
    final now = DateTime.now();
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return true;
    
    return now.isBefore(DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000));
  }

  Future<void> refreshSession() async {
    try {
      await _client.auth.refreshSession();
    } catch (e) {
      throw Exception('Failed to refresh session: $e');
    }
  }

  Future<supabase.Session?> getCurrentSession() async {
    return _client.auth.currentSession;
  }

  void listenToAuthStateChanges(Function(User?) callback) {
    _authStateSubscription = _client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session?.user != null) {
        callback(_mapSupabaseUserToAppUser(session!.user));
      } else {
        callback(null);
      }
    });
  }

  void dispose() {
    _authStateSubscription?.cancel();
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
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;

    if (idToken == null) {
      throw Exception('No ID token from Google sign-in');
    }

    final response = await _client.auth.signInWithIdToken(
      provider: supabase.OAuthProvider.google,
      idToken: idToken,
    );

    if (response.user != null) {
      await _ensureUserProfileExists(response.user!.id, response.user!);
    }
  }

  Future<void> signInWithGithub() async {
    await _client.auth.signInWithOAuth(
      supabase.OAuthProvider.github,
    );
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

  Future<void> _ensureUserProfileExists(String userId, dynamic supabaseUser) async {
    final existingProfile = await _client
        .from('users')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (existingProfile == null) {
      final username = supabaseUser.userMetadata?['username'] ??
          'user_${userId.substring(0, 8)}';
      final email = supabaseUser.email ?? '';
      await _createUserProfile(userId, username, email);
    }
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
