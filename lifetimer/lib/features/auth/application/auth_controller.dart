import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../core/services/analytics_service.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthController extends StateNotifier<User?> {
  final AuthRepository _authRepository;
  final AnalyticsService _analytics = AnalyticsService();

  AuthController(this._authRepository) : super(null) {
    _init();
  }

  void _init() {
    state = _authRepository.currentUser;
    _authRepository.authStateChanges.listen((user) {
      state = user;
      if (user != null) {
        _analytics.setUserId(user.id);
      }
    });
  }

  bool get isAuthenticated => _authRepository.isAuthenticated;

  String? get currentUserId => _authRepository.currentUserId;

  Future<bool> isSessionValid() async {
    return await _authRepository.isSessionValid();
  }

  Future<void> refreshSession() async {
    await _authRepository.refreshSession();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _authRepository.signInWithEmail(email, password);
    _analytics.logSignIn(method: 'email');
  }

  Future<void> signUpWithEmail(String email, String password, String username) async {
    await _authRepository.signUpWithEmail(email, password, username);
    _analytics.logSignUp(method: 'email');
  }

  Future<void> signInWithGoogle() async {
    await _authRepository.signInWithGoogle();
    _analytics.logSignIn(method: 'google');
  }

  Future<void> signInWithApple() async {
    await _authRepository.signInWithApple();
    _analytics.logSignIn(method: 'apple');
  }

  Future<void> signInWithGithub() async {
    await _authRepository.signInWithGithub();
    _analytics.logSignIn(method: 'github');
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    state = null;
    _analytics.logSignOut();
    _analytics.reset();
  }

  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }

  Future<void> updateProfile({
    String? username,
    String? bio,
    String? avatarUrl,
    bool? isPublicProfile,
  }) async {
    final updatedFields = <String>[];
    if (username != null) updatedFields.add('username');
    if (bio != null) updatedFields.add('bio');
    if (avatarUrl != null) updatedFields.add('avatar');
    if (isPublicProfile != null) {
      updatedFields.add('visibility');
      _analytics.logProfileVisibilityChanged(isPublic: isPublicProfile);
    }
    
    await _authRepository.updateProfile(
      username: username,
      bio: bio,
      avatarUrl: avatarUrl,
      isPublicProfile: isPublicProfile,
    );
    
    if (updatedFields.isNotEmpty) {
      _analytics.logProfileUpdated(fieldsUpdated: updatedFields.join(','));
    }
  }

  @override
  void dispose() {
    _authRepository.dispose();
    super.dispose();
  }
}
