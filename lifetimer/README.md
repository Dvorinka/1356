# LifeTimer Flutter Project

## Overview

LifeTimer is a gamified life countdown app where users create a bucket list (up to 20 entries) and start a 1356-day countdown once they finalize their goals. The countdown cannot be stopped, paused, or extended.

**Status**: Phase 4 (Polish and Release) - Preparing for v1.0.0 launch

## Project Structure

This Flutter project follows a clean architecture with feature-based organization:

```
lib/
├── main.dart                    # App entry point
├── bootstrap/                   # Initialization
│   ├── bootstrap.dart
│   ├── env.dart
│   └── supabase_client.dart
├── core/                        # Cross-cutting concerns
│   ├── theme/
│   │   └── app_theme.dart
│   ├── routing/
│   │   └── app_router.dart
│   ├── widgets/
│   │   ├── primary_button.dart
│   │   ├── app_scaffold.dart
│   │   ├── loading_indicator.dart
│   │   └── empty_state.dart
│   ├── errors/
│   │   ├── failure.dart
│   │   └── error_mapper.dart
│   ├── utils/
│   │   ├── date_time_utils.dart
│   │   └── validators.dart
│   └── services/
│       ├── analytics_service.dart
│       ├── notification_service.dart
│       └── image_cache_service.dart
├── data/                        # Data layer
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── goal_model.dart
│   │   ├── goal_step_model.dart
│   │   ├── activity_model.dart
│   │   └── achievement_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── user_repository.dart
│   │   ├── goals_repository.dart
│   │   ├── countdown_repository.dart
│   │   ├── social_repository.dart
│   │   ├── notifications_repository.dart
│   │   └── achievements_repository.dart
│   └── services/
│       ├── image_search_service.dart
│       ├── pexels_image_search_service.dart
│       └── offline_cache_service.dart
└── features/                    # Feature modules
    ├── auth/
    │   ├── presentation/
    │   │   ├── auth_gate.dart
    │   │   ├── sign_in_screen.dart
    │   │   ├── sign_up_screen.dart
    │   │   └── auth_loading_screen.dart
    │   └── application/
    │       └── auth_controller.dart
    ├── onboarding/
    │   ├── presentation/
    │   │   ├── onboarding_intro_screen.dart
    │   │   ├── onboarding_how_it_works_screen.dart
    │   │   └── onboarding_motivation_screen.dart
    │   └── application/
    │       └── onboarding_controller.dart
    ├── goals/
    │   ├── presentation/
    │   │   ├── goals_list_screen.dart
    │   │   ├── goal_edit_screen.dart
    │   │   └── goal_detail_screen.dart
    │   └── application/
    │       ├── goals_controller.dart
    │       └── goal_detail_controller.dart
    ├── countdown/
    │   ├── presentation/
    │   │   ├── home_countdown_screen.dart
    │   │   ├── bucket_list_confirmation_screen.dart
    │   │   └── countdown_summary_screen.dart
    │   └── application/
    │       └── countdown_controller.dart
    ├── social/
    │   ├── presentation/
    │   │   ├── social_feed_screen.dart
    │   │   ├── leaderboards_screen.dart
    │   │   └── public_profile_screen.dart
    │   └── application/
    │       └── social_controller.dart
    ├── profile/
    │   ├── presentation/
    │   │   ├── profile_screen.dart
    │   │   └── profile_edit_screen.dart
    │   └── application/
    │       └── profile_controller.dart
    ├── settings/
    │   ├── presentation/
    │   │   ├── settings_home_screen.dart
    │   │   ├── appearance_settings_screen.dart
    │   │   ├── notification_settings_screen.dart
    │   │   ├── privacy_settings_screen.dart
    │   │   └── about_challenge_screen.dart
    │   └── application/
    │       └── settings_controller.dart
    ├── analytics/
    │   ├── presentation/
    │   │   └── insights_screen.dart
    │   └── application/
    │       └── insights_controller.dart
    └── achievements/
        ├── presentation/
        │   └── achievements_screen.dart
        └── application/
            └── achievements_controller.dart
```

## Tech Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart 3.0+
- **State Management**: Riverpod
- **Backend**: Supabase (Auth, Database, Storage, Realtime)
- **Navigation**: Go Router
- **Local Storage**: Hive
- **Maps**: Google Maps Flutter, OpenStreetMap
- **Notifications**: Flutter Local Notifications
- **Charts**: fl_chart
- **Images**: Unsplash API, Pexels API, cached_network_image
- **OAuth**: google_sign_in, sign_in_with_apple
- **Location**: geolocator

## Getting Started

### Prerequisites

1. Flutter SDK (>=3.10.0)
2. Dart SDK (>=3.0.0)
3. Supabase project
4. Google Maps API key (optional)
5. Unsplash API key (optional)
6. Pexels API key (optional)

### Setup

1. Clone this repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Key Features

### Phase 1 (MVP) ✅
- [x] User authentication (email, Google, Apple)
- [x] Bucket list creation (up to 20 goals)
- [x] 1356-day countdown timer
- [x] Goal progress tracking
- [x] Profile management
- [x] Notifications (daily, weekly, milestones)
- [x] Analytics tracking

### Phase 2 (Social) ✅
- [x] Public/private profiles
- [x] Social feed
- [x] Leaderboards
- [x] Following system
- [x] Achievements system

### Phase 3 (Advanced) ✅
- [x] Charts and analytics
- [x] Image API integration (Unsplash, Pexels)
- [x] Map integration for location-based goals (Google Maps, OSM)
- [x] Offline support with caching
- [x] Appearance settings (theme, time format)

### Phase 4 (Polish and Release) 🚧
- [x] Accessibility improvements
- [x] Performance optimizations
- [x] App store documentation
- [x] Beta testing plan
- [x] Security audit checklist
- [x] Code review checklist
- [x] Release notes
- [x] User guide and FAQ
- [x] Developer documentation
- [ ] Beta testing execution
- [ ] App store submission

## Database Schema

The app uses Supabase PostgreSQL with the following main tables:

- `users` - User profiles and countdown data
- `goals` - Bucket list items
- `goal_steps` - Granular goal milestones
- `followers` - Social relationships
- `activities` - Timeline events
- `notifications` - Notification history
- `achievements` - User achievements

## Architecture Patterns

- **MVVM/Clean Architecture** with clear separation of concerns
- **Repository Pattern** for data access
- **Riverpod StateNotifier** for state management
- **Feature-based organization** for scalability
- **Dependency Injection** via providers

## Documentation

- [Release Notes](RELEASE_NOTES.md)
- [User Guide](USER_GUIDE.md)
- [FAQ](FAQ.md)
- [Developer Guide](DEVELOPER_GUIDE.md)
- [App Store Assets](app_store_assets/)
  - [Release Preparation Checklist](app_store_assets/release_preparation_checklist.md)
  - [Beta Testing Plan](app_store_assets/beta_testing_plan.md)
  - [Security Audit Checklist](app_store_assets/security_audit_checklist.md)
  - [Code Review Checklist](app_store_assets/code_review_checklist.md)
  - [App Icon Guidelines](app_store_assets/app_icon_guidelines.md)
  - [Screenshot Guidelines](app_store_assets/screenshot_guidelines.md)
  - [Post-Launch Planning](app_store_assets/post_launch_planning.md)

## Testing

The project includes comprehensive test coverage:

- **Unit Tests**: Core utilities, models, repositories
- **Widget Tests**: Screen components and interactions
- **Integration Tests**: End-to-end user flows

Run tests:
```bash
flutter test
```

## Development Status

**Current Version**: 1.0.0 (Pre-release)

The project is in Phase 4 (Polish and Release) with all core features implemented. The app is ready for beta testing and app store submission.

## Contributing

Please see [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for contribution guidelines.

## License

This project is licensed under the MIT License.

## Support

- **Email**: support@lifetimer.app
- **Twitter**: @LifeTimerApp
- **Discord**: https://discord.gg/lifetimer
- **Website**: https://lifetimer.app
