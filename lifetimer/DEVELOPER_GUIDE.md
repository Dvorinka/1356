# LifeTimer - Developer Documentation

## Table of Contents

1. [Project Overview](#project-overview)
2. [Getting Started](#getting-started)
3. [Architecture](#architecture)
4. [Project Structure](#project-structure)
5. [Development Setup](#development-setup)
6. [Key Components](#key-components)
7. [State Management](#state-management)
8. [API Integration](#api-integration)
9. [Testing](#testing)
10. [Deployment](#deployment)
11. [Contributing](#contributing)

---

## Project Overview

LifeTimer is a Flutter-based mobile application that helps users achieve their goals through a focused 1356-day countdown challenge. The app uses Supabase for backend services including authentication, database, storage, and real-time features.

### Tech Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart 3.0+
- **Backend**: Supabase (PostgreSQL, Auth, Storage, Realtime)
- **State Management**: Riverpod
- **Navigation**: go_router
- **Authentication**: Email, Google, Apple
- **Database**: PostgreSQL via Supabase
- **Storage**: Supabase Storage
- **Analytics**: Supabase Analytics
- **Maps**: Google Maps, OpenStreetMap
- **Images**: Unsplash, Pexels APIs

---

## Getting Started

### Prerequisites

- Flutter SDK 3.10 or higher
- Dart SDK 3.0 or higher
- Android Studio or VS Code
- Xcode (for iOS development, macOS only)
- Supabase account
- Google Cloud Console account (for Google Maps)
- Unsplash API key
- Pexels API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/lifetimer.git
   cd lifetimer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## Architecture

LifeTimer follows a Clean Architecture pattern with clear separation of concerns:

### Layers

1. **Presentation Layer** (`lib/features/*/presentation/`)
   - Screens and widgets
   - UI components
   - User interactions

2. **Application Layer** (`lib/features/*/application/`)
   - Controllers and view models
   - State management
   - Business logic

3. **Domain Layer** (`lib/features/*/domain/`)
   - Entities and value objects
   - Business rules
   - Use cases

4. **Data Layer** (`lib/data/`)
   - Models and DTOs
   - Repositories
   - API clients
   - Data sources

### Key Principles

- **Single Responsibility**: Each component has one clear purpose
- **Dependency Inversion**: Depend on abstractions, not concretions
- **Open/Closed**: Open for extension, closed for modification
- **Interface Segregation**: Small, focused interfaces

---

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── bootstrap/                # Initialization
│   ├── bootstrap.dart       # Bootstrap function
│   ├── supabase_client.dart # Supabase client setup
│   └── env.dart             # Environment configuration
├── core/                     # Cross-cutting concerns
│   ├── theme/              # App theming
│   ├── routing/            # Navigation
│   ├── widgets/            # Reusable widgets
│   ├── errors/             # Error handling
│   ├── utils/              # Utilities
│   └── services/           # Core services
├── data/                    # Data layer
│   ├── models/             # Data models
│   ├── repositories/       # Data repositories
│   ├── services/           # Data services
│   └── providers/          # Dependency providers
└── features/                # Feature modules
    ├── auth/               # Authentication
    ├── onboarding/         # Onboarding
    ├── goals/              # Goals management
    ├── countdown/          # Countdown feature
    ├── social/             # Social features
    ├── profile/            # User profile
    ├── settings/           # Settings
    ├── analytics/          # Analytics & insights
    └── achievements/       # Achievements system
```

---

## Development Setup

### Environment Configuration

Create a `.env` file in the project root:

```env
# Supabase
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Google Maps (optional)
GOOGLE_MAPS_API_KEY=your_google_maps_key

# Image APIs
UNSPLASH_ACCESS_KEY=your_unsplash_key
PEXELS_API_KEY=your_pexels_key
```

### Supabase Setup

1. **Create a Supabase project**
   - Go to https://supabase.com
   - Create a new project
   - Get your project URL and anon key

2. **Run database migrations**
   ```bash
   # Apply migrations from supabase/migrations/
   ```

3. **Configure authentication**
   - Enable Email auth
   - Enable Google OAuth
   - Enable Apple OAuth (iOS)

4. **Set up storage**
   - Create storage buckets
   - Configure RLS policies

### Code Generation

Run code generation for Riverpod providers:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Key Components

### Authentication

**Location**: `lib/features/auth/`

**Components**:
- `AuthGate`: Routes based on auth state
- `SignInScreen`: Email/password sign in
- `SignUpScreen`: Email/password sign up
- `AuthController`: Manages auth state

**Usage**:
```dart
final authController = ref.watch(authControllerProvider);
final user = authController.currentUser;
```

### Goals Management

**Location**: `lib/features/goals/`

**Components**:
- `GoalsListScreen`: Lists all goals
- `GoalEditScreen`: Create/edit goals
- `GoalDetailScreen`: View goal details
- `GoalsController`: Manages goals state

**Usage**:
```dart
final goalsController = ref.watch(goalsControllerProvider);
final goals = goalsController.goals;
```

### Countdown

**Location**: `lib/features/countdown/`

**Components**:
- `HomeCountdownScreen`: Main countdown display
- `CountdownController`: Manages countdown state

**Usage**:
```dart
final countdownController = ref.watch(countdownControllerProvider);
final remaining = countdownController.remainingTime;
```

### Social Features

**Location**: `lib/features/social/`

**Components**:
- `SocialFeedScreen`: Activity feed
- `LeaderboardsScreen`: Rankings
- `PublicProfileScreen`: User profiles
- `SocialController`: Manages social state

---

## State Management

LifeTimer uses Riverpod for state management.

### Providers

**StateNotifierProvider** (for complex state):
```dart
final goalsControllerProvider = StateNotifierProvider<GoalsController, GoalsState>((ref) {
  final repository = ref.watch(goalsRepositoryProvider);
  final authController = ref.watch(authControllerProvider);
  return GoalsController(repository, authController);
});
```

**Provider** (for services):
```dart
final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return GoalsRepository(client);
});
```

### Watching State

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(goalsControllerProvider);
  
  return state.isLoading 
    ? LoadingIndicator()
    : GoalsList(goals: state.goals);
}
```

### Reading State (without rebuilding)

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final controller = ref.read(goalsControllerProvider.notifier);
  
  return ElevatedButton(
    onPressed: () => controller.loadGoals(),
    child: Text('Load Goals'),
  );
}
```

---

## API Integration

### Supabase Client

**Location**: `lib/bootstrap/supabase_client.dart`

**Usage**:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

// Query data
final response = await client
  .from('goals')
  .select()
  .eq('owner_id', userId);

// Insert data
await client.from('goals').insert(goal.toJson());

// Update data
await client.from('goals').update({'progress': 50}).eq('id', goalId);
```

### Repository Pattern

**Example**:
```dart
class GoalsRepository {
  final SupabaseClient _client;
  
  GoalsRepository(this._client);
  
  Future<List<Goal>> getGoals(String userId) async {
    final response = await _client
      .from('goals')
      .select()
      .eq('owner_id', userId)
      .order('created_at', ascending: false);
    
    return (response as List).map((json) => Goal.fromJson(json)).toList();
  }
}
```

---

## Testing

### Unit Tests

**Location**: `test/`

**Example**:
```dart
test('should calculate remaining days correctly', () {
  final start = DateTime(2026, 1, 1);
  final end = DateTime(2029, 9, 17); // 1356 days later
  final now = DateTime(2026, 1, 15);
  
  final remaining = end.difference(now).inDays;
  
  expect(remaining, equals(1341));
});
```

### Widget Tests

**Example**:
```dart
testWidgets('should display countdown', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        countdownControllerProvider.overrideWith((ref) => mockController),
      ],
      child: MaterialApp(home: HomeCountdownScreen()),
    ),
  );
  
  expect(find.text('Your Journey'), findsOneWidget);
});
```

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/countdown/countdown_controller_test.dart
```

---

## Deployment

### iOS Deployment

1. **Configure signing**
   - Open `ios/Runner.xcworkspace`
   - Select your team and bundle identifier
   - Configure signing certificates

2. **Build for release**
   ```bash
   flutter build ios --release
   ```

3. **Upload to App Store Connect**
   - Use Xcode or Transporter
   - Follow App Store submission process

### Android Deployment

1. **Configure signing**
   - Create keystore
   - Configure `android/key.properties`
   - Update `android/app/build.gradle`

2. **Build app bundle**
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Play Console**
   - Upload `build/app/outputs/bundle/release/app-release.aab`
   - Follow Play Store submission process

---

## Contributing

### Code Style

Follow Flutter/Dart style guidelines:
- Use `dart format` to format code
- Use `flutter analyze` to check for issues
- Follow effective Dart guidelines

### Commit Messages

Use conventional commits:
```
feat: add goal completion celebration
fix: resolve countdown timer not updating
docs: update README with new features
test: add unit tests for goal repository
```

### Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Update documentation
6. Submit a pull request
7. Address review feedback

### Branch Naming

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `test/` - Tests
- `refactor/` - Code refactoring

---

## Common Tasks

### Adding a New Feature

1. Create feature directory: `lib/features/your-feature/`
2. Add presentation layer: `presentation/your_screen.dart`
3. Add application layer: `application/your_controller.dart`
4. Add repository if needed: `lib/data/repositories/your_repository.dart`
5. Add route: `lib/core/routing/app_router.dart`
6. Write tests: `test/features/your-feature/`
7. Update documentation

### Adding a New Model

1. Create model: `lib/data/models/your_model.dart`
2. Add JSON serialization
3. Add to repository
4. Write tests
5. Update documentation

### Adding a New Route

1. Add route definition in `app_router.dart`
2. Add route to navigation helpers
3. Update navigation documentation
4. Test navigation flow

---

## Troubleshooting

### Build Issues

**Problem**: Build fails with dependency errors
**Solution**:
```bash
flutter clean
flutter pub get
flutter pub upgrade
```

**Problem**: iOS build fails
**Solution**:
```bash
cd ios
pod install
cd ..
flutter clean
flutter build ios
```

### Runtime Issues

**Problem**: App crashes on startup
**Solution**:
- Check environment variables
- Verify Supabase configuration
- Check logs in Flutter DevTools

**Problem**: State not updating
**Solution**:
- Ensure you're using `ref.watch()` for state
- Check that providers are properly configured
- Verify state mutations are correct

---

## Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Supabase Documentation](https://supabase.com/docs)
- [go_router Documentation](https://gorouter.dev)

### Tools
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview)
- [Supabase Dashboard](https://supabase.com/dashboard)
- [DartPad](https://dartpad.dev)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Supabase Discord](https://supabase.com/discord)
- [Riverpod Discord](https://discord.gg/EeQDgU2)

---

## License

This project is licensed under the MIT License.

---

## Support

For development support:
- GitHub Issues: https://github.com/your-org/lifetimer/issues
- Email: dev@lifetimer.app
- Discord: https://discord.gg/lifetimer

---

**Version**: 1.0.0
**Last Updated**: January 3, 2026
