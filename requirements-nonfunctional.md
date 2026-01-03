# LifeTimer  Non functional Requirements

This document describes quality attributes of the app.

## 1. Performance

- NFR 1.1 The home screen countdown updates smoothly at least once per second without blocking user interactions.
- NFR 1.2 Normal operations should complete within one second on a typical mobile connection when the network is healthy.
- NFR 1.3 Screens should be usable on low end devices with limited memory.

## 2. Reliability and availability

- NFR 2.1 The app should degrade gracefully when offline, caching recent data for read only access.
- NFR 2.2 Operations that change data are queued and retried when the connection is restored, where possible.
- NFR 2.3 Critical data such as goals and countdown timestamps are stored in Supabase and never only on device.

## 3. Security and privacy

- NFR 3.1 All traffic between app and Supabase uses HTTPS.
- NFR 3.2 Access to tables is controlled by Row Level Security policies in Supabase.
- NFR 3.3 Private goals and milestones are not readable by other users.
- NFR 3.4 Authentication tokens are stored securely using platform secure storage.
- NFR 3.5 Data export and deletion can be supported in later phases to comply with privacy expectations.
 - NFR 3.6 Supabase service role keys are never embedded in the mobile app; only the public anon key is shipped to clients.
 - NFR 3.7 RLS policies are covered by automated tests and code review to prevent accidental data exposure.
 - NFR 3.8 Logs and analytics events do not contain secrets (passwords, tokens) or unnecessary personal data.

## 4. Usability and accessibility

- NFR 4.1 App follows platform accessibility guidelines for text size, color contrast, and touch target sizes.
- NFR 4.2 Primary flows are fully usable with screen readers.
- NFR 4.3 Color alone is not the only way to convey critical information.

## 5. Maintainability and scalability

- NFR 5.1 Codebase follows modular feature based structure with clear separation of presentation, state management, and data layers.
- NFR 5.2 Business logic is covered by automated tests at unit or widget level where it brings value.
- NFR 5.3 Supabase schema migrations are version controlled.

## 6. Localization

- NFR 6.1 The app is designed to support multiple languages via Flutter localization.
- NFR 6.2 All user facing strings live in localization files, not hard coded in widgets.

## 7. Analytics and observability

- NFR 7.1 Basic analytics events are sent for key actions such as creating goals, starting the countdown, and completing milestones.
- NFR 7.2 Error logging captures stack traces and anonymized context to help debugging.
