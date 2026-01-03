# LifeTimer — Navigation and User Flows

This document describes the main screens, navigation, and user journeys for the LifeTimer app.

---

## 1. Screen map and navigation

### 1.1 Global structure

- **Splash / Launch**
  - Lightweight loading and environment check.
  - Determines whether to show onboarding or go directly to the app.

- **Onboarding flow**
  - `OnboardingIntro` — explain the 1356‑day challenge concept.
  - `OnboardingHowItWorks` — steps: set 1–20 goals → lock list → 1356‑day countdown.
  - `OnboardingMotivation` — motivational examples, visuals.
  - Final screen leads to authentication.

- **Authentication**
  - `AuthChoice` — sign up / log in buttons, Google and Apple options.
  - `SignUpEmail` — email + password registration.
  - `SignInEmail` — email + password login.
  - `OAuthRedirect` — transient screen while completing Google / Apple sign‑in.
  - After auth, go to profile or home depending on completion state.

- **Profile setup (first time)**
  - `CreateProfile` — avatar, username (unique), short bio.
  - Once done, proceed to bucket list intro.

- **Main app shell**
  - Bottom navigation with 4–5 tabs:
    - **Home** — countdown and high‑level summary.
    - **Goals** — bucket list and goal management.
    - **Social** — feed, leaderboards (Phase 2+).
    - **Profile** — own profile, stats, settings entry.
    - **Insights (optional)** — charts and analytics (Phase 3).

The bottom nav is persistent after login; individual flows push screens on top of the tab stacks.

---

## 2. Core journey: new user to active countdown

### 2.1 First session flow

1. **Launch → Onboarding**
   - `Splash` → `OnboardingIntro`.
   - User swipes or taps Next through 2–3 explanatory screens.
   - Final onboarding screen CTA: **Get started** → `AuthChoice`.

2. **Authentication**
   - Choose **Sign up with email**, **Google**, or **Apple**.
   - On success, navigate to `CreateProfile`.

3. **Profile setup**
   - Enter avatar (optional), username (required, uniqueness validated), and short bio.
   - CTA **Continue** → `BucketListIntro`.

4. **Bucket list introduction**
   - `BucketListIntro` explains rules:
     - You can create between 1 and 20 goals.
     - Countdown only starts when your list is finalized and you have at least one goal.
     - Once started, cannot be paused or reset.
   - CTA **Start creating my list** → `GoalsListEdit` (empty state).

5. **Creating goals**
   - `GoalsListEdit` (tab: Goals) shows empty state card: “No goals yet. Add your first goal”.
   - Tap **Add goal** → `GoalEdit` screen.

6. **Goal edit flow**
   - Fields: Title (required), Description, Location, Image, Milestones.
   - User can add milestones / steps.
   - CTA **Save goal** returns to `GoalsListEdit`.
   - User repeats Add goal until satisfied (up to 20; UI shows **x / 20 goals created**; the countdown start action becomes available once x ≥ 1).

7. **Confirming the bucket list**
   - When user has created at least one goal, a prominent CTA appears: **Finalize list and start 1356‑day challenge**.
   - Tapping CTA opens `ConfirmBucketListDialog`:
     - Summary: number of goals, explanation of irreversible start.
     - Options:
       - **Start countdown** — sets `countdown_start_date` and `countdown_end_date`, navigates to `HomeCountdown`.
       - **Review goals** — returns to `GoalsListEdit`.

8. **First countdown view**
   - `HomeCountdown` shows:
     - Very large remaining days (world‑clock inspired layout).
     - Smaller breakdown: days, hours, minutes, seconds.
     - Progress ring or bar showing percentage of time elapsed.
     - Short motivational message.
   - Primary CTA: **View my goals** (to Goals tab).

### 2.2 If bucket list is not finalized

- If a user leaves the app before finalizing:
  - On next login, `Home` shows “Your challenge hasn’t started yet” with progress in creating goals (e.g., 5 / 20 goals completed) and a CTA to **Finish my list** → `GoalsListEdit`.

---

## 3. Daily usage: updating progress

1. User opens app.
2. `Splash` quickly forwards to last state; for active users this is `HomeCountdown`.
3. On `HomeCountdown`:
   - User sees remaining time and high‑level completion percentage across all goals.
   - CTA **Update progress** → `GoalsList`.
4. In `GoalsList`:
   - Each goal card shows title, image, small progress bar, and possibly remaining time highlight.
   - Tap a goal → `GoalDetail`.
5. In `GoalDetail`:
   - User marks milestones as done or adjusts progress slider.
   - Optional note field for journal‑style comments.
   - CTA **Mark goal as completed** when all steps are done.
6. On completion:
   - Show lightweight celebration overlay.
   - Offer **Share to community** if social features are enabled.

---

## 4. Social and community flows (Phase 2+)

### 4.1 Opting into sharing

- From `Profile` or `Settings > Privacy`:
  - Global toggle **Make my profile public** (account visibility: Public / Private).
  - Optional privacy explanation sheet before first activation, explaining which data becomes visible.

### 4.2 Browsing the feed

1. Tap **Social** tab.
2. `SocialFeed` shows a list of public milestones and completed goals.
   - Cards: user avatar + name, goal title, completion date, days remaining.
3. Tap a card → `PublicMilestoneDetail`.
4. From `PublicMilestoneDetail`:
   - CTA **Follow user** → adds follower row.
   - View **User profile** → `PublicProfile`.

Only users with Public accounts appear in the social feed or can be followed.

### 4.3 Leaderboards

- From `SocialFeed`, user can switch tabs:
  - `Feed`, `Leaderboards`.
- `Leaderboards` shows rankings (goals completed, streaks, etc.).
- Tap an entry → `PublicProfile`.

Only users with Public accounts appear on leaderboards.

---

## 5. Settings and notifications

### 5.1 Accessing settings

- From **Profile** tab, button **Settings** → `SettingsHome`.

### 5.2 Settings subsections

- `AccountSettings` — email, password, delete account.
- `AppearanceSettings` — light/dark, time format (12/24h).
- `NotificationSettings` — reminder frequency, categories.
- `PrivacySettings` — global public/private account visibility toggle and blocking.
- `AboutChallenge` — re‑explain rules and philosophy.

### 5.3 Notification flows

- When user taps a push notification:
  - Reminder about time remaining → deep link to `HomeCountdown`.
  - Goal progress reminder → deep link to `GoalDetail` for that goal.
  - Social notification → deep link to `SocialFeed` or `PublicMilestoneDetail`.

---

## 6. Edge cases and empty states

- **No internet connection**
  - Show cached countdown and goals with offline banner.
  - Disable actions that require network or queue them.

- **No goals yet (new user)**
  - `GoalsList` shows illustrative empty state with CTA **Add your first goal**.

- **Countdown finished**
  - `HomeCountdown` switches to a summary view:
    - “1356 days completed”
    - Stats: goals completed, streaks, favorite milestones.
    - CTA to review journey or share a reflection.

This document should be kept in sync with the UI spec and roadmap as features are added or removed.
