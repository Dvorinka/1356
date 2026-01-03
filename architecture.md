# LifeTimer  Technical Architecture

This document describes how the Flutter app and Supabase backend are structured.

## 1. Overall approach

- Mobile first, built with Flutter for Android and iOS.
- Supabase used for authentication, Postgres database, storage, and real time features.
- MVVM or Clean Architecture style separation
  - Presentation, screens and widgets.
  - View models, state management using Provider or Riverpod.
  - Data layer, repositories that talk to Supabase clients.

## 2. Flutter project structure

Suggested feature based folder layout

- lib
  - core
    - theme, routing, localization, error handling, utilities
  - data
    - supabase client setup, repositories, models, mappers
  - features
    - auth
    - onboarding
    - goals
    - countdown
    - social
    - profile
    - settings
    - analytics

Each feature contains its own presentation widgets, view models, and sub repositories where needed.

## 3. Data flow

- UI widgets send user intents to view models.
- View models call repositories for data access or mutations.
- Repositories call Supabase client methods
  - auth api for login, logout, and account management
  - Postgres queries or rpc calls for business data
  - storage for media uploads
  - realtime channels for live updates
- Results flow back up through view models to update state and rebuild widgets.

## 4. Supabase integration

- Single Supabase client instance configured at app start.
- Environment configuration uses separate projects or keys for development, staging, and production.
- Row Level Security used to protect tables so that users only see their own data, unless a profile is explicitly marked public, in which case only a limited subset of non sensitive fields is readable by others.
- Edge functions may be added later for
  - computed metrics
  - scheduled notifications
  - heavy or sensitive operations.

## 5. Offline and caching

- Local persistence of last known state for
  - active countdown values
  - list of goals and their progress
- Use local database or key value storage package such as Hive or Shared Preferences for small amounts of data.
- Mark pending writes and retry them when connectivity is back.

## 6. Error handling and logging

- Centralized error handler that maps Supabase and network errors to user friendly messages.
- Non fatal errors are logged to an analytics or crash reporting service.
- Critical failures show a fallback screen with safe retry options.

## 7. Testing

- Unit tests for
  - countdown calculations
  - rules around starting and locking the countdown
  - goal progress calculations
- Widget tests for
  - goal cards
  - countdown screen
  - onboarding flow
- Basic integration tests for sign up, creating goals, and starting the countdown.

## 8. Security and privacy architecture

- Use Supabase Auth for all authentication; never store passwords or session tokens outside the auth system.
- Ship only the public anon key in the mobile app; keep the service role key strictly on the server or in Supabase Edge Functions.
- Enforce Row Level Security on all tables, with policies that
  - restrict reads and writes to `auth.uid()` for private accounts;
  - allow limited read only access to selected fields when `users.is_public_profile = true`.
- Store access tokens only in platform secure storage APIs and never log them.
- Validate all untrusted input on the server side and avoid constructing dynamic SQL from user data.
- Minimize personally identifiable information stored in the database and support account deletion.
- Use structured logging that avoids sensitive fields and route logs to a secure destination.
