import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/services/analytics_service.dart';

class OnboardingController extends StateNotifier<bool> {
  final AnalyticsService _analytics = AnalyticsService();
  static const String _onboardingKey = 'onboarding_completed';
  
  OnboardingController() : super(false) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    try {
      final box = await Hive.openBox('app_settings');
      final completed = box.get(_onboardingKey, defaultValue: false);
      state = completed;
    } catch (e) {
      state = false;
    }
  }

  Future<void> completeOnboarding() async {
    try {
      final box = await Hive.openBox('app_settings');
      await box.put(_onboardingKey, true);
      state = true;
      _analytics.logOnboardingCompleted();
    } catch (e) {
      _analytics.logError(error: e.toString(), context: 'completeOnboarding');
    }
  }

  Future<void> skipOnboarding() async {
    try {
      final box = await Hive.openBox('app_settings');
      await box.put(_onboardingKey, true);
      state = true;
      _analytics.logOnboardingCompleted();
    } catch (e) {
      _analytics.logError(error: e.toString(), context: 'skipOnboarding');
    }
  }

  void completeStep(String stepName) {
    _analytics.logOnboardingStepCompleted(stepName: stepName);
  }

  Future<void> resetOnboarding() async {
    try {
      final box = await Hive.openBox('app_settings');
      await box.put(_onboardingKey, false);
      state = false;
    } catch (e) {
      _analytics.logError(error: e.toString(), context: 'resetOnboarding');
    }
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, bool>((ref) {
  return OnboardingController();
});
