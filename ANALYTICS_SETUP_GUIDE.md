# App Performance Monitoring & Analytics Setup Guide

**Project:** LifeTimer  
**Version:** 1.0.0  
**Date:** 2026-01-03

## Overview

This guide covers setting up production-ready analytics and performance monitoring for the LifeTimer app. The current implementation includes a placeholder analytics service that needs to be replaced with a real analytics provider.

## Recommended Solutions

### 1. Firebase Analytics (Primary Recommendation)

**Why Firebase Analytics?**
- Free tier with generous limits
- Seamless integration with Flutter
- Real-time analytics
- User properties and event tracking
- Integration with Firebase Crashlytics
- Works well with Supabase

**Setup Steps:**

#### Step 1: Add Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
  firebase_crashlytics: ^3.4.9
  firebase_performance: ^0.9.3+11
```

#### Step 2: Initialize Firebase

Create `lib/bootstrap/firebase.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
  
  // Initialize Analytics
  FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  
  // Initialize Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  // Initialize Performance Monitoring
  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
}
```

Update `lib/bootstrap/bootstrap.dart`:
```dart
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initializeFirebase();
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
  
  initializeSupabaseClient();
}
```

#### Step 3: Update Analytics Service

Update `lib/core/services/analytics_service.dart`:
```dart
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  bool _isInitialized = false;

  Future<void> initialize() async {
    _isInitialized = true;
    await _analytics.setAnalyticsCollectionEnabled(true);
  }

  void setUserId(String userId) {
    _analytics.setUserId(id: userId);
  }

  void setUserProperty(String name, dynamic value) {
    _analytics.setUserProperty(name: name, value: value.toString());
  }

  void logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    _analytics.logEvent(
      name: eventName,
      parameters: parameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  void logSignUp({required String method}) {
    _analytics.logSignUp(signUpMethod: method);
  }

  void logSignIn({required String method}) {
    _analytics.logLogin(loginMethod: method);
  }

  void logSignOut() {
    // Firebase doesn't have a built-in sign out event
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
    logEvent('goal_updated', parameters: {'goal_id': goalId});
  }

  void logGoalCompleted({required String goalId, required int daysInChallenge}) {
    logEvent('goal_completed', parameters: {
      'goal_id': goalId,
      'days_in_challenge': daysInChallenge,
    });
  }

  void logGoalDeleted({required String goalId}) {
    logEvent('goal_deleted', parameters: {'goal_id': goalId});
  }

  void logCountdownStarted({required String startDate, required String endDate}) {
    logEvent('countdown_started', parameters: {
      'start_date': startDate,
      'end_date': endDate,
    });
  }

  void logCountdownViewed() {
    _analytics.logScreenView(screenName: 'home_countdown');
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
    _crashlytics.recordError(
      error,
      null,
      fatal: false,
      information: context != null ? [context] : null,
    );
  }

  void logScreenView({required String screenName}) {
    _analytics.logScreenView(screenName: screenName);
  }

  void reset() {
    _analytics.resetAnalyticsData();
  }
}
```

#### Step 4: Configure Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project: "LifeTimer"
3. Add Android app:
   - Package name: `com.lifetimer.app`
   - Download `google-services.json`
   - Place in `android/app/`
4. Add iOS app:
   - Bundle ID: `com.lifetimer.app`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`

#### Step 5: Configure Android

Update `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### Step 6: Configure iOS

Update `ios/Runner/Info.plist`:
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
```

### 2. Alternative: Mixpanel Analytics

**Why Mixpanel?**
- Advanced user segmentation
- Funnel analysis
- Cohort analysis
- Real-time insights

**Setup Steps:**

Add to `pubspec.yaml`:
```yaml
dependencies:
  mixpanel_flutter: ^2.2.0
```

Initialize in `lib/bootstrap/bootstrap.dart`:
```dart
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

Future<void> initializeMixpanel() async {
  final mixpanel = await Mixpanel.init('YOUR_MIXPANEL_TOKEN');
  mixpanel.track('app_opened');
}
```

### 3. Alternative: Sentry (Error Tracking)

**Why Sentry?**
- Excellent error tracking
- Performance monitoring
- Release tracking
- Breadcrumbs

**Setup Steps:**

Add to `pubspec.yaml`:
```yaml
dependencies:
  sentry_flutter: ^7.14.0
```

Initialize in `lib/bootstrap/bootstrap.dart`:
```dart
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> initializeSentry() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'YOUR_SENTRY_DSN';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
  );
}
```

## Recommended Implementation

**Primary Stack:**
- Firebase Analytics (user analytics)
- Firebase Crashlytics (crash reporting)
- Firebase Performance Monitoring (performance)

**Optional Add-ons:**
- Sentry (additional error tracking)
- Mixpanel (advanced user analytics)

## Key Events to Track

### User Acquisition
- `app_opened` - First app open
- `sign_up` - New user registration
- `sign_in` - User login
- `sign_out` - User logout

### Core Features
- `onboarding_completed` - User finishes onboarding
- `bucket_list_created` - User creates bucket list
- `countdown_started` - User starts countdown
- `goal_created` - User adds a goal
- `goal_updated` - User updates a goal
- `goal_completed` - User completes a goal
- `goal_deleted` - User deletes a goal

### Engagement
- `countdown_viewed` - User views countdown
- `goals_viewed` - User views goals list
- `profile_viewed` - User views profile
- `social_feed_viewed` - User views social feed
- `leaderboards_viewed` - User views leaderboards

### Settings
- `settings_changed` - User changes settings
- `notification_enabled` - User enables notifications
- `notification_disabled` - User disables notifications
- `theme_changed` - User changes theme

### Errors
- `error` - Any error occurrence
- `network_error` - Network-related errors
- `auth_error` - Authentication errors

## User Properties to Track

- `user_id` - Unique user identifier
- `sign_up_method` - Email, Google, or Apple
- `countdown_started` - Boolean, has countdown started
- `countdown_start_date` - Date countdown started
- `goals_count` - Number of goals
- `completed_goals_count` - Number of completed goals
- `is_public_profile` - Profile visibility
- `theme_preference` - Light, dark, or system
- `notification_enabled` - Notifications status

## Performance Metrics to Monitor

### App Performance
- App startup time
- Screen load time
- API response times
- Database query times
- Image loading times

### User Experience
- Crash-free users
- ANR (Application Not Responding) rate
- Session duration
- Screen flow analysis
- Drop-off points

### Business Metrics
- Daily Active Users (DAU)
- Monthly Active Users (MAU)
- Retention rate (Day 1, 7, 30)
- Conversion rate (signup to countdown start)
- Goal completion rate

## Logging Framework

Replace `print()` statements with proper logging:

Add to `pubspec.yaml`:
```yaml
dependencies:
  logger: ^2.0.2+1
```

Create `lib/core/utils/logger.dart`:
```dart
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

final loggerNoStack = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 0,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);
```

Usage:
```dart
// Instead of print('Analytics not initialized');
logger.w('Analytics not initialized');

// Instead of print('Analytics Event: $eventData');
logger.d('Analytics Event: $eventData');

// For errors
logger.e('Error syncing mutation', error: e, stackTrace: stackTrace);
```

## Privacy & Compliance

### Data Collection
- Only collect necessary data
- Anonymize user IDs where possible
- Provide opt-out options
- Follow GDPR and CCPA guidelines

### User Consent
- Add consent dialog on first launch
- Allow users to opt out of analytics
- Provide privacy policy link
- Implement data deletion on request

### Firebase Configuration
```dart
// Disable analytics collection for users who opt out
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

// Delete user data on account deletion
await FirebaseAnalytics.instance.resetAnalyticsData();
```

## Testing Analytics

### Local Testing
1. Use Firebase DebugView for real-time event verification
2. Test all event tracking flows
3. Verify user properties are set correctly
4. Test error reporting

### DebugView Setup
```dart
// Enable DebugView for development
await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
```

### Event Verification
```dart
// Test event tracking
AnalyticsService().logEvent('test_event', parameters: {'test': 'value'});
```

## Monitoring Dashboards

### Firebase Console Dashboards
1. **Overview Dashboard** - Key metrics overview
2. **Events Dashboard** - Event tracking
3. **Conversions Dashboard** - Funnel analysis
4. **Audiences Dashboard** - User segments
5. **Retention Dashboard** - User retention

### Custom Dashboards
Create custom dashboards for:
- Countdown start funnel
- Goal completion rate
- User engagement metrics
- Error rates
- Performance metrics

## Alerts & Notifications

### Set Up Alerts
1. **Crash Rate Alert** - Notify when crash rate exceeds threshold
2. **Error Rate Alert** - Notify when error rate spikes
3. **Performance Alert** - Notify when app performance degrades
4. **User Drop-off Alert** - Notify when drop-off increases

### Alert Configuration
- Set appropriate thresholds
- Configure notification channels (email, Slack, etc.)
- Define escalation procedures
- Document alert responses

## Documentation

### Analytics Documentation
- Document all events tracked
- Document user properties
- Document funnels and conversions
- Maintain analytics dictionary

### Team Training
- Train team on analytics tools
- Establish analytics review process
- Create analytics best practices guide
- Regular analytics reviews

## Implementation Checklist

### Firebase Setup
- [ ] Create Firebase project
- [ ] Add Android app to Firebase
- [ ] Add iOS app to Firebase
- [ ] Download configuration files
- [ ] Add dependencies to pubspec.yaml
- [ ] Initialize Firebase in bootstrap
- [ ] Configure Android build files
- [ ] Configure iOS Info.plist
- [ ] Test Firebase integration

### Analytics Implementation
- [ ] Update AnalyticsService with Firebase
- [ ] Implement all event tracking
- [ ] Set user properties
- [ ] Test event tracking
- [ ] Verify in Firebase DebugView

### Crashlytics Setup
- [ ] Initialize Crashlytics
- [ ] Configure error reporting
- [ ] Test crash reporting
- [ ] Verify in Firebase Console

### Performance Monitoring
- [ ] Initialize Performance Monitoring
- [ ] Add custom traces
- [ ] Monitor app startup
- [ ] Monitor screen loads
- [ ] Monitor API calls

### Logging Framework
- [ ] Add logger dependency
- [ ] Create logger utility
- [ ] Replace all print() statements
- [ ] Configure log levels

### Privacy & Compliance
- [ ] Add consent dialog
- [ ] Implement opt-out functionality
- [ ] Update privacy policy
- [ ] Test data deletion

### Monitoring & Alerts
- [ ] Set up Firebase dashboards
- [ ] Create custom dashboards
- [ ] Configure alerts
- [ ] Test alert notifications

### Documentation
- [ ] Document all events
- [ ] Create analytics dictionary
- [ ] Train team
- [ ] Establish review process

---

**Next Steps:**
1. Set up Firebase project
2. Add Firebase dependencies
3. Implement Firebase Analytics
4. Replace placeholder analytics service
5. Set up Crashlytics
6. Implement logging framework
7. Test all tracking
8. Configure monitoring dashboards
9. Set up alerts
10. Document analytics implementation
