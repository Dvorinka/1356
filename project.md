# LifeTimer App (1356-Day Countdown) — Project Plan (Supabase Edition)

## 1. Project Overview

**App Name (Working):** LifeTimer

**Concept:**
LifeTimer is a gamified life countdown app. Each user creates a personal bucket list (up to 20 entries), and the 1356-day countdown begins **only after they finalize all goals**. The countdown cannot be stopped, paused, extended, or changed once started.

Users can track their progress, visualize remaining time, and optionally share achievements or milestones with the community. Some bucket list entries may include map locations or images pulled from external APIs.

**Target Platforms:**

* Android (Play Store)
* iOS (App Store)

**Target Audience:**

* Users motivated by time-limited personal challenges.
* People who enjoy gamification, life planning, and social inspiration.

---

## 2. Core Features

### 2.1 User Management

* Sign up / login (email, Google, Apple ID) via Supabase Auth
* User profile: avatar, username, bio
* Online status indicator

### 2.2 1356-Day Countdown

* **Countdown starts only after the user completes their bucket list (up to 20 items)**
* Each user has exactly 1356 days (≈3 years 8 months 11 days)
* Cannot be paused, reset, or modified
* Display as a live countdown (days, hours, minutes, seconds)
* Optional progress bar showing percentage of time passed

### 2.3 Bucket List & Goal Tracking

* Users can add up to **20 bucket list entries**
* Each goal has:

  * Title and optional description
  * Progress tracker (completed steps or milestones)
  * Optional location (integrated with Maps APIs)
  * Optional image/media (pulled from input or APIs based on title)
* Goals serve as motivation; they do not affect countdown duration
* Visual indication of goal progress relative to countdown

### 2.4 Social / Online Interaction

* Share milestones or completed goals with other users
* View other users’ public progress (optional)
* Leaderboards for motivation (e.g., most goals completed within 1356 days)

### 2.5 Notifications

* Countdown reminders (daily, weekly, milestone alerts)
* Achievement & streak notifications

### 2.6 Analytics & Insights

* Daily/weekly stats of goals completed
* Progress visualization vs countdown
* Simple motivational messages based on progress

---

## 3. UI/UX Inspiration

* Clean and minimal UI with light/pastel colors
* Use cards to show goals and countdown progress
* Bottom navigation: Home / Goals / Social / Profile
* Large visual display for countdown (center of home screen)
* Progress bars, charts, or line graphs for milestone tracking

**Suggested Screens:**

1. **Onboarding:** Explanation of the 1356-day challenge, motivational text
2. **Bucket List Creation:**

   * Add up to 20 goals
   * Optional images and map locations for each entry
   * Countdown cannot start until list is complete
3. **Home Screen:**

   * Live countdown timer
   * Progress circle/bar
   * Motivational messages
4. **Goals Screen:** List of bucket list items and progress
5. **Social Screen:** Optional leaderboard or public milestones
6. **Profile Screen:** Avatar, username, start date, days left, achievements
7. **Settings:** Notifications, privacy, theme preferences

---

## 4. Tech Stack

### 4.1 Mobile Framework

* Flutter (cross-platform, beginner-friendly)

### 4.2 Backend / API

* **Supabase**: full backend replacement for Firebase

  * **Auth:** Email, Google, Apple ID
  * **Database:** PostgreSQL for users, goals, and social interactions
  * **Realtime:** Supabase Realtime for live updates (goal progress, social feed)
  * **Storage:** Media storage for goal images/videos
* External APIs:

  * Maps (Google Maps / OpenStreetMap) for location-based goals
  * Image APIs (Unsplash, Pexels, or AI-generated)

### 4.3 State Management

* Flutter: Provider or Riverpod

### 4.4 Notifications

* Local push notifications (Flutter local_notifications package)
* Optional server-side notifications via Supabase Edge Functions

### 4.5 Analytics

* Supabase logs + optional third-party analytics (e.g., Mixpanel)

### 4.6 Design System

* Material 3 / Cupertino widgets
* Custom color themes for progress stages

---

## 5. Database Structure (Supabase PostgreSQL Example)

**Tables:**

```sql
users
  id (uuid, primary key)
  username
  email
  avatar_url
  bio
  countdown_start_date (null until bucket list completed)
  countdown_end_date (calculated automatically as start + 1356 days)
  created_at
  updated_at

goals
  id (uuid, primary key)
  owner_id (foreign key → users.id)
  title
  description
  progress (0-100)
  location_lat
  location_lng
  location_name
  image_url
  completed (boolean)
  created_at
  updated_at

followers
  id (uuid, primary key)
  user_id (foreign key → users.id)
  follower_id (foreign key → users.id)
```

---

## 6. App Architecture

* MVVM / Clean Architecture
* **Model:** User, Goal
* **View:** Screens & Widgets (Flutter UI)
* **ViewModel:** State management (Provider/Riverpod)
* **Repository:** Supabase API calls (Auth, Postgres, Storage)
* Real-time updates: Supabase Realtime for goal progress and social feed

---

## 7. Implementation Roadmap

### Phase 1 — MVP

* User authentication & profile via Supabase
* Bucket list creation (limit 20 goals)
* Countdown starts **after bucket list completion**
* Live countdown and percentage progress
* Add goal progress tracking

### Phase 2 — Social & Motivation

* Share milestones or goals publicly
* View other users’ progress (optional)
* Leaderboards & achievements
* Push notifications for milestones

### Phase 3 — Advanced Features

* Graphs & charts for progress visualization
* Media uploads & API-based images
* Map integration for location-based goals
* Offline support & caching
* Daily motivational messages

---

## 8. Recommended Tools & Learning Resources

* Flutter: [https://flutter.dev/docs](https://flutter.dev/docs)
* Supabase: [https://supabase.com/docs](https://supabase.com/docs)
* UI Design: Figma / Adobe XD
* State Management: Riverpod tutorials
* Version Control: Git + GitHub

---

## 9. Summary

LifeTimer now uses **Supabase** as a complete backend solution. Users finalize a bucket list of up to 20 goals, then a **fixed 1356-day countdown starts**. Optional images and maps integration make goal tracking engaging. Countdown cannot be stopped or modified, emphasizing commitment, while social and motivational features encourage progress and community support. Flutter + Supabase enables cross-platform support and real-time updates for a dynamic experience.
