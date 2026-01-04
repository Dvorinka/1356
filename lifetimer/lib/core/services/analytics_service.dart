import 'dart:developer' as developer;

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  bool _isInitialized = false;
  final Map<String, dynamic> _userProperties = {};

  Future<void> initialize() async {
    _isInitialized = true;
  }

  void setUserId(String userId) {
    _userProperties['user_id'] = userId;
  }

  void setUserProperty(String name, dynamic value) {
    _userProperties[name] = value;
  }

  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (!_isInitialized) {
      developer.log(
        'Analytics not initialized. Event: $eventName',
        name: 'AnalyticsService',
        level: 900, // warning
      );
      return;
    }

    final eventData = {
      'event_name': eventName,
      'timestamp': DateTime.now().toIso8601String(),
      ..._userProperties,
      if (parameters != null) ...parameters,
    };

    developer.log(
      'Analytics Event: $eventData',
      name: 'AnalyticsService',
      level: 800, // info
    );
  }

  void logSignUp({required String method}) {
    logEvent('sign_up', parameters: {
      'method': method,
    });
  }

  void logSignIn({required String method}) {
    logEvent('sign_in', parameters: {
      'method': method,
    });
  }

  void logSignOut() {
    logEvent('sign_out');
  }

  void logGoalCreated({required String goalId, required String hasLocation, required String hasImage}) {
    logEvent('goal_created', parameters: {
      'goal_id': goalId,
      'has_location': hasLocation,
      'has_image': hasImage,
    });
  }

  void logGoalUpdated({required String goalId}) {
    logEvent('goal_updated', parameters: {
      'goal_id': goalId,
    });
  }

  void logGoalCompleted({required String goalId, required int daysInChallenge}) {
    logEvent('goal_completed', parameters: {
      'goal_id': goalId,
      'days_in_challenge': daysInChallenge,
    });
  }

  void logGoalDeleted({required String goalId}) {
    logEvent('goal_deleted', parameters: {
      'goal_id': goalId,
    });
  }

  void logCountdownStarted({required String startDate, required String endDate}) {
    logEvent('countdown_started', parameters: {
      'start_date': startDate,
      'end_date': endDate,
    });
  }

  void logCountdownViewed() {
    logEvent('countdown_viewed');
  }

  void logProfileUpdated({required String fieldsUpdated}) {
    logEvent('profile_updated', parameters: {
      'fields_updated': fieldsUpdated,
    });
  }

  void logProfileVisibilityChanged({required bool isPublic}) {
    logEvent('profile_visibility_changed', parameters: {
      'is_public': isPublic,
    });
  }

  void logOnboardingCompleted() {
    logEvent('onboarding_completed');
  }

  void logOnboardingStepCompleted({required String stepName}) {
    logEvent('onboarding_step_completed', parameters: {
      'step_name': stepName,
    });
  }

  void logSettingsChanged({required String settingName, required String value}) {
    logEvent('settings_changed', parameters: {
      'setting_name': settingName,
      'value': value,
    });
  }

  void logNotificationEnabled({required String notificationType}) {
    logEvent('notification_enabled', parameters: {
      'notification_type': notificationType,
    });
  }

  void logNotificationDisabled({required String notificationType}) {
    logEvent('notification_disabled', parameters: {
      'notification_type': notificationType,
    });
  }

  void logError({required String error, String? context}) {
    logEvent('error', parameters: {
      'error_message': error,
      if (context != null) 'context': context,
    });
  }

  void logScreenView({required String screenName}) {
    logEvent('screen_view', parameters: {
      'screen_name': screenName,
    });
  }

  void reset() {
    _userProperties.clear();
  }
}
