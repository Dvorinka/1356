# LifeTimer  Development Roadmap

This roadmap breaks down the phases from project.md into concrete milestones.

## Phase 0  Planning and foundations

Status, in progress

- [x] Clarify product vision and constraints.
- [x] Create high level project plan and documentation.
- [ ] Set up Flutter project with base folder structure.
- [ ] Configure Supabase project, environment variables, and basic tables.
- [ ] Set up version control and basic continuous integration.

## Phase 1  MVP core experience

Goal, a private personal countdown with a bucket list of up to 20 goals.

- [ ] Implement authentication and profile editing.
- [ ] Implement bucket list creation and editing, limited to 20 goals.
- [ ] Implement confirmation flow that locks the bucket list and starts the countdown.
- [ ] Implement home countdown screen with large timer and percentage of time elapsed.
- [ ] Implement basic goals list and goal detail with progress and completion.
- [ ] Implement local notifications for daily or weekly reminders.
- [ ] Add simple analytics events for key actions.

Exit criteria

- A user can sign up, create and confirm a bucket list, see the countdown, and track progress on their goals on at least one platform.

## Phase 2  Social and motivation

Goal, optional social layer that motivates users without forcing them to share.

- [ ] Implement following system and basic public profiles.
- [ ] Implement activity feed of public milestones.
- [ ] Implement leaderboards for goals completed and active streaks.
- [ ] Add achievements and badges.
- [ ] Extend notification logic for social events.

Exit criteria

- Users can opt in to sharing and see others public progress in a simple, motivating feed.

## Phase 3  Advanced experience

Goal, make the app richer and more insightful.

- [ ] Add charts and insights for progress versus time.
- [ ] Integrate image APIs for automatic goal cover images.
- [ ] Add map integration for location based goals.
- [ ] Improve offline support and caching.
- [ ] Extend settings, themes, and personalization.

## Phase 4  Polish and release

- [ ] Accessibility review and improvements.
- [ ] Performance tuning on low end devices.
- [ ] App Store and Play Store preparation, listings, screenshots, and policies.
- [ ] Beta testing and bug fixing.
- [ ] Public release and monitoring.
