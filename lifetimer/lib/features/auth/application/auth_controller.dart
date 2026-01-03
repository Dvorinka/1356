import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(/* SupabaseClient instance will be injected */);
});

class AuthController extends StateNotifier<User?> {
  final AuthRepository _authRepository;

  AuthController(this._authRepository) : super(null) {
    _init();
  }

  void _init() {
    state = _authRepository.currentUser;
    _authRepository.authStateChanges.listen((user) {
      state = user;
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    await _authRepository.signInWithEmail(email, password);
  }

  Future<void> signUpWithEmail(String email, String password, String username) async {
    await _authRepository.signUpWithEmail(email, password, username);
  }

  Future<void> signInWithGoogle() async {
    await _authRepository.signInWithGoogle();
  }

  Future<void> signInWithApple() async {
    await _authRepository.signInWithApple();
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
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
    await _authRepository.updateProfile(
      username: username,
      bio: bio,
      avatarUrl: avatarUrl,
      isPublicProfile: isPublicProfile,
    );
  }
}
