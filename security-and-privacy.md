# LifeTimer — Security and Privacy Design

This document describes how LifeTimer should be built to reduce the risk of hacking, data leaks, and misuse.

## 1. Goals

- Protect user data (goals, milestones, countdown, email, profile).
- Make it hard for attackers to access or modify data they do not own.
- Limit damage even if a single part of the system is compromised.

---

## 2. Privacy model

- Each user chooses a single **account visibility** setting:
  - **Private account** (default)
    - Only the user can see their goals, milestones, countdown, and stats.
    - Account never appears in feeds, search, or leaderboards.
  - **Public account**
    - Other users can see a **limited public view**: avatar, username, high level stats, and public milestones.
    - Sensitive data (email, internal IDs, detailed logs) never leaves the backend.
- Visibility is implemented via a boolean flag `users.is_public_profile`.

---

## 3. Access control and Row Level Security (RLS)

High level rules for Supabase/Postgres:

- **General principles**
  - Every table that contains user data has RLS enabled.
  - There is no unauthenticated read access to private data.
  - Service role key is used only in secure server environments, not in the mobile app.

- **users table**
  - A user can `SELECT` and `UPDATE` only their own row.
  - Other users can `SELECT` a limited subset of columns (username, avatar_url, is_public_profile, high level stats) **only when** `is_public_profile = true`.
  - Email and other sensitive fields are never exposed in public queries.

- **goals, goal_steps, activities, notifications tables**
  - Reads and writes are allowed only when `owner_id = auth.uid()` (or `user_id = auth.uid()`), regardless of public/private setting.
  - Public feeds and leaderboards do **not** expose full goal records; they use derived or aggregated views that expose only non sensitive data.

- **followers and social features**
  - Follow relationships can only be created for public accounts.
  - Queries that build feeds or leaderboards always join through `users` and require `is_public_profile = true`.

- **Testing RLS**
  - For each table, add tests that simulate different users:
    - Owner can read/write their rows.
    - Other users cannot read private rows.
    - Other users can read only allowed fields for public accounts.

---

## 4. Authentication and session security

- Use Supabase Auth for all login and sign up flows.
- Enforce strong password rules for email/password sign up.
- Use OAuth flows (Google, Apple) via official SDKs only.
- Store access and refresh tokens only via platform secure storage APIs.
- Provide logout that clears tokens from secure storage and memory.
- Optionally add app level lock (PIN or biometrics) before opening sensitive screens on a shared device.

---

## 5. Key and configuration management

- Store Supabase keys and environment URLs only in configuration files, not hard coded in code.
- Ship **only** the public anon key in the mobile app.
- Keep the Supabase service role key in server side environments (CI, Edge Functions) and protect it with secret managers.
- Rotate keys if a leak is suspected.

---

## 6. Network and API security

- Enforce HTTPS for all communication with Supabase.
- Optionally enable certificate pinning in the mobile app for additional protection.
- Validate data on the server side (for example inside Edge Functions) for any complex operations.
- Use pagination and rate limiting on endpoints that can be abused for scraping.

---

## 7. Secure coding guidelines

- Use parameterized queries and the official Supabase client instead of building raw queries from strings.
- Never log passwords, tokens, or full request/response bodies that may contain secrets.
- Sanitize and validate user input before using it in business logic.
- Handle errors with generic messages for users and more detailed logs on the backend.

---

## 8. Logging, monitoring, and incident response

- Send errors to a crash/analytics service with anonymized context.
- Monitor for unusual patterns (for example many failed login attempts from one IP).
- Have a procedure for
  - disabling compromised accounts,
  - rotating keys,
  - notifying affected users when needed.

---

## 9. Data lifecycle

- Store only data that is necessary for the product to work.
- Allow users to delete their accounts; deletion should remove or anonymize their data where possible.
- Consider providing data export in later phases so users can keep a copy of their progress.

This document should be kept in sync with `requirements-nonfunctional.md`, `database-schema.md`, and `architecture.md` as the system evolves.
