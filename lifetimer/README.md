# LifeTimer Flutter Project

## Overview

LifeTimer is a gamified life countdown app where users create a bucket list (up to 20 entries) and start a 1356-day countdown once they finalize their goals. The countdown cannot be stopped, paused, or extended.

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
│   │   └── primary_button.dart
│   └── state/
│       └── providers.dart
├── data/                        # Data layer
│   ├── models/
│   │   ├── user_model.dart
│   │   └── goal_model.dart
│   └── repositories/
│       └── auth_repository.dart
└── features/                    # Feature modules
    ├── auth/
    ├── onboarding/
    ├── goals/
    ├── countdown/
    ├── social/
    ├── profile/
    └── settings/
```

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Backend**: Supabase (Auth, Database, Storage, Realtime)
- **Navigation**: Go Router
- **Local Storage**: Hive
- **Maps**: Google Maps Flutter
- **Notifications**: Flutter Local Notifications

## Getting Started

### Prerequisites

1. Flutter SDK (>=3.10.0)
2. Dart SDK (>=3.0.0)
3. Supabase project

### Setup

1. Clone this repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up environment variables:
   Create a `.env` file or use build arguments:
   ```bash
   flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Key Features

### Phase 1 (MVP)
- [x] User authentication (email, Google, Apple)
- [x] Bucket list creation (up to 20 goals)
- [x] 1356-day countdown timer
- [x] Goal progress tracking
- [x] Basic profile management

### Phase 2 (Social)
- [ ] Public/private profiles
- [ ] Social feed
- [ ] Leaderboards
- [ ] Following system

### Phase 3 (Advanced)
- [ ] Charts and analytics
- [ ] Image API integration
- [ ] Map integration for location-based goals
- [ ] Offline support

## Database Schema

The app uses Supabase PostgreSQL with the following main tables:

- `users` - User profiles and countdown data
- `goals` - Bucket list items
- `goal_steps` - Granular goal milestones
- `followers` - Social relationships
- `activities` - Timeline events

## Architecture Patterns

- **MVVM/Clean Architecture** with clear separation of concerns
- **Repository Pattern** for data access
- **Provider/StateNotifier** for state management
- **Feature-based organization** for scalability

## Development Notes

- All screens are currently placeholder implementations
- Core structure and dependencies are set up
- Authentication flow is partially implemented
- Database models and repositories are defined
- Navigation structure is in place

## Next Steps

1. Complete authentication implementation
2. Implement bucket list creation and management
3. Build countdown timer functionality
4. Add goal progress tracking
5. Implement social features (Phase 2)
6. Add advanced analytics (Phase 3)
