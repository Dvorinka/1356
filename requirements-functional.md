# LifeTimer  Functional Requirements

This document expands on project.md and defines functional requirements for the LifeTimer app.

## Legend

- FR x.y = Functional Requirement

## 1. User accounts and profiles

- FR 1.1 Users can sign up and sign in using email and password via Supabase Auth.
- FR 1.2 Users can sign in using Google.
- FR 1.3 Users can sign in using Apple ID on iOS.
- FR 1.4 Users can edit a profile containing avatar, username that is unique, and short bio.
- FR 1.5 The app displays online or last active status where relevant, for example social screens.
- FR 1.6 Users can delete their account and associated data.

## 2. Bucket list and goals

- FR 2.1 Each user can create between 1 and 20 goals in their bucket list. The countdown can only start once at least one goal exists, and no more than 20 goals can ever be created.
- FR 2.2 For each goal, the user can enter title, required, and description, optional.
- FR 2.3 For each goal, the user can optionally attach
  - a location, map picker or search,
  - one cover image, either uploaded or fetched from an image API based on title.
- FR 2.4 Users can define milestones or steps per goal and mark each step as completed.
- FR 2.5 Users can mark a goal as completed; overall progress is derived from milestones and completion flag.
- FR 2.6 Users can edit or delete a goal until the 1356 day countdown has started.
- FR 2.7 After the countdown has started, goals remain visible but cannot be deleted; limited edits, for example description, may be allowed, but title and count of goals are locked.

## 3. 1356 day countdown

- FR 3.1 The app calculates the countdown start date when the user confirms their bucket list as final.
- FR 3.2 The app stores countdown end date as start date plus 1356 days.
- FR 3.3 The home screen shows a live countdown, days, hours, minutes, seconds.
- FR 3.4 Users can view the percentage of time that has elapsed, visualized via a progress bar or circle.
- FR 3.5 The countdown cannot be paused, reset, or extended by the user.
- FR 3.6 If the end date is in the past, the app shows that the challenge is finished and surfaces summary statistics.

## 4. Progress tracking and insights

- FR 4.1 Users can see a list of goals with per goal progress and overall completion stats.
- FR 4.2 The app shows simple charts or indicators of progress versus remaining time, for example line chart, bar chart, or summary cards.
- FR 4.3 The app shows motivational messages based on the user current progress and remaining time.

## 5. Social and community, optional and opt in

- FR 5.1 Each user can set their overall account visibility to either **Public** or **Private** via a single global toggle.
- FR 5.2 When an account is **Private**, only the owning user can see their goals, milestones, countdown, and statistics. Private accounts never appear in social feeds or leaderboards.
- FR 5.3 When an account is **Public**, other users can see a restricted public view of that user: avatar, username, high level stats, public milestones, and goal summaries, but never email or other sensitive data.
- FR 5.4 Users can follow other users with public accounts and see a feed of their public milestones.
- FR 5.5 Leaderboards surface rankings such as
  - most goals completed,
  - streak of active days,
  - recently completed milestones,
  but only for public accounts.
- FR 5.6 Users can unfollow or block other users.

## 6. Notifications

- FR 6.1 Users can configure reminder frequency, daily, weekly, custom, for the countdown.
- FR 6.2 Users receive push or local notifications for
  - upcoming milestones or deadlines they set,
  - streaks such as three days in a row of updating progress,
  - major countdown checkpoints, for example 50 percent or 25 percent time remaining.
- FR 6.3 Users can mute or customize specific notification categories.
- FR 6.4 Notification preferences sync across devices.

## 7. Onboarding and education

- FR 7.1 New users see an onboarding flow explaining the 1356 day challenge and rules.
- FR 7.2 Onboarding includes at least one screen that visually represents the countdown, inspired by the world time style mockups.
- FR 7.3 Users can revisit an About the challenge screen later from Settings.

## 8. Settings

- FR 8.1 Users can switch between light and dark themes.
- FR 8.2 Users can choose 12 hour or 24 hour time formats.
- FR 8.3 Users can update language if localization is implemented.
- FR 8.4 Users can manage privacy and social visibility options.

## 9. Admin and operations, later phase

- FR 9.1 An admin user can moderate reported content and block abusive accounts.
- FR 9.2 Admin tooling may be provided via Supabase dashboard or a separate admin UI.
