# LifeTimer — Flutter Project Structure

This document describes the recommended folder and file structure for the LifeTimer Flutter app, aligned with the architecture and flows.

Assumption: you will start from a standard `flutter create lifetimer` project, then adapt the `lib/` directory as follows.

---

## 1. High level layout

- `lib/`
  - `main.dart` — app entrypoint, initializes Supabase and runs `LifeTimerApp`.
  - `bootstrap/` — initialization helpers (Supabase client, dependency injection, env config).
  - `core/` — cross cutting concerns (theme, routing, localization, widgets, utils, error handling).
  - `data/` — shared data layer code (models, repositories, Supabase clients).
  - `features/` — feature modules (auth, onboarding, goals, countdown, social, profile, settings, analytics).

---

## 2. lib/main.dart

Responsibilities:

- Ensure Flutter bindings are initialized.
- Initialize Supabase client (using config from `bootstrap/`).
- Run the `LifeTimerApp` widget.

File:

- `lib/main.dart`

---

## 3. Bootstrap and configuration

Folder:

- `lib/bootstrap/`
  - `bootstrap.dart` — high level `bootstrap()` function called from `main.dart` (sets up Supabase, error handlers, env).
  - `supabase_client.dart` — creates and exposes a configured Supabase client instance.
  - `env.dart` — holds environment configuration (Supabase URL, anon key, build flavor hooks).

---

## 4. Core module

Folder:

- `lib/core/`
  - `theme/`
    - `app_theme.dart` — light/dark theme definitions, colors, typography.
  - `routing/`
    - `app_router.dart` — central route definitions and navigation helpers.
  - `localization/`
    - `l10n.dart` — localization setup (generated or custom wrapper).
  - `widgets/`
    - `primary_button.dart` — reusable CTA button.
    - `app_scaffold.dart` — base scaffold with consistent background and app bar style.
    - `bottom_nav_scaffold.dart` — scaffold wiring bottom navigation.
    - `loading_indicator.dart` — standard loading widget.
    - `empty_state.dart` — reusable empty state widget.
  - `errors/`
    - `failure.dart` — domain error types.
    - `error_mapper.dart` — maps Supabase / network errors to user friendly messages.
  - `utils/`
    - `date_time_utils.dart` — countdown calculations, formatting.
    - `validators.dart` — input validation helpers.
  - `state/` (if using Riverpod/Provider wrappers)
    - `providers.dart` — top level providers (Supabase client, theme mode, auth state).

---

## 5. Data layer

Folder:

- `lib/data/`
  - `supabase/`
    - `supabase_client_provider.dart` — exposes Supabase client to the app (e.g., via Riverpod/Provider).
  - `models/`
    - `user_model.dart` — app level User model.
    - `goal_model.dart` — Goal model.
    - `goal_step_model.dart` — GoalStep model.
    - `activity_model.dart` — Activity model.
  - `repositories/`
    - `auth_repository.dart` — login, logout, token refresh.
    - `user_repository.dart` — profile read/update, visibility toggle.
    - `goals_repository.dart` — CRUD for goals and steps, enforce 1–20 limit.
    - `countdown_repository.dart` — start countdown, compute remaining time.
    - `social_repository.dart` — followers, feeds, leaderboards (Phase 2+).
    - `notifications_repository.dart` — notification preferences and tokens.

Repositories hide Supabase queries behind a clean API, so features do not talk to Supabase directly.

---

## 6. Feature modules

Each feature lives under `lib/features/<feature_name>/` with a simple structure:

- `presentation/` — screens and widgets.
- `application/` — state management (view models, controllers, providers).
- `domain/` (optional) — feature specific entities and logic.

### 6.1 Auth feature

- `lib/features/auth/presentation/`
  - `auth_gate.dart` — decides whether to show auth screens or main app based on session.
  - `sign_in_screen.dart`
  - `sign_up_screen.dart`
  - `auth_loading_screen.dart` — transient during OAuth redirects.
- `lib/features/auth/application/`
  - `auth_controller.dart` — wraps `auth_repository`, exposes current user/session state.

### 6.2 Onboarding feature

- `lib/features/onboarding/presentation/`
  - `onboarding_intro_screen.dart`
  - `onboarding_how_it_works_screen.dart`
  - `onboarding_motivation_screen.dart`
- `lib/features/onboarding/application/`
  - `onboarding_controller.dart` — tracks whether onboarding is completed.

### 6.3 Goals feature

- `lib/features/goals/presentation/`
  - `goals_list_screen.dart` — list of goals, empty state, add/edit buttons.
  - `goal_edit_screen.dart` — create/edit goal (title, description, location, image, milestones).
  - `goal_detail_screen.dart` — view and update progress, mark as completed.
- `lib/features/goals/application/`
  - `goals_controller.dart` — loads goals, enforces max 20, exposes list/state.
  - `goal_detail_controller.dart` — state for a single goal.

### 6.4 Countdown feature

- `lib/features/countdown/presentation/`
  - `home_countdown_screen.dart` — main world-time inspired countdown UI.
  - `countdown_summary_screen.dart` — shown after countdown ends, summary stats.
- `lib/features/countdown/application/`
  - `countdown_controller.dart` — calculates remaining time, exposes streams/timers.

### 6.5 Social feature (Phase 2+)

- `lib/features/social/presentation/`
  - `social_feed_screen.dart`
  - `leaderboards_screen.dart`
  - `public_profile_screen.dart`
- `lib/features/social/application/`
  - `social_feed_controller.dart`
  - `leaderboards_controller.dart`

### 6.6 Profile feature

- `lib/features/profile/presentation/`
  - `profile_screen.dart` — shows own profile, countdown info, stats.
- `lib/features/profile/application/`
  - `profile_controller.dart` — loads and updates profile, visibility, avatar.

### 6.7 Settings feature

- `lib/features/settings/presentation/`
  - `settings_home_screen.dart`
  - `account_settings_screen.dart`
  - `appearance_settings_screen.dart`
  - `notification_settings_screen.dart`
  - `privacy_settings_screen.dart` — global Public/Private toggle, blocking.
  - `about_challenge_screen.dart`
- `lib/features/settings/application/`
  - `settings_controller.dart` — wraps repositories for user preferences.

### 6.8 Analytics / insights (Phase 3)

- `lib/features/analytics/presentation/`
  - `insights_screen.dart` — charts and stats.
- `lib/features/analytics/application/`
  - `insights_controller.dart`

---

## 7. Navigation and route names

- Central router file: `lib/core/routing/app_router.dart`.
- Define named routes for key screens, grouped by feature, e.g.:
  - `/` → `AuthGate` (decides between auth vs main app).
  - `/onboarding/*` for onboarding screens.
  - `/home` → `HomeCountdownScreen`.
  - `/goals`, `/goals/:id`, `/goals/:id/edit`.
  - `/social`, `/social/leaderboards`, `/u/:username`.
  - `/settings/*` for settings sections.

The router uses the navigation library you choose (Navigator 2.0, go_router, etc.); this file is the single source of truth for destinations.

---

## 8. State management

If you use Riverpod or Provider:

- Global providers in `lib/core/state/providers.dart`:
  - `supabaseClientProvider`
  - `authControllerProvider`
  - `themeModeProvider`
- Feature specific providers next to controllers in their `application/` folders.

---

## 9. Testing structure

Mirror the feature structure under `test/`:

- `test/core/` — utilities, date/time tests, error mapping tests.
- `test/data/` — repository tests with mocked Supabase client.
- `test/features/<feature_name>/` — unit and widget tests for each feature.

This structure keeps the app modular and makes it easy to grow features (e.g., adding more social or analytics functionality) without losing clarity.
