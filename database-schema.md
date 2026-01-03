# LifeTimer  Database Schema, Supabase

This document expands the schema sketch in project.md into a more detailed proposal for Postgres tables.

Note, naming and exact types can be adjusted when creating migrations.

## 1. users

Core user record.

- id, uuid, primary key
- auth_provider_id, text or json, optional mapping to external providers
- username, text, unique, required
- email, text, unique, required
- avatar_url, text, nullable
- bio, text, nullable
 - is_public_profile, boolean, default false
- countdown_start_date, timestamptz, nullable until bucket list is confirmed
- countdown_end_date, timestamptz, nullable until challenge has started
- created_at, timestamptz, default now
- updated_at, timestamptz, default now

Row Level Security

- Users can select and update only their own row.
- Public profile fields such as username and avatar, plus limited stats, can be exposed to other users only when `is_public_profile` is true.

## 2. goals

Represents one goal in the bucket list.

- id, uuid, primary key
- owner_id, uuid, foreign key to users.id
- title, text, required
- description, text, nullable
- progress, integer, 0 to 100, default 0
- location_lat, double precision, nullable
- location_lng, double precision, nullable
- location_name, text, nullable
- image_url, text, nullable
- completed, boolean, default false
- created_at, timestamptz, default now
- updated_at, timestamptz, default now

Constraints

- Each user can have at most 20 goals in total. The countdown can start once there is at least one goal.

## 3. goal_steps

Optional more granular checklist per goal.

- id, uuid, primary key
- goal_id, uuid, foreign key to goals.id
- title, text
- is_done, boolean, default false
- order_index, integer
- created_at, timestamptz, default now

## 4. followers

Social graph between users.

- id, uuid, primary key
- user_id, uuid, the user being followed
- follower_id, uuid, the user who follows
- created_at, timestamptz, default now

Constraint

- unique user_id, follower_id

## 5. activities

Timeline of events used for feeds and analytics.

- id, uuid, primary key
- user_id, uuid, foreign key to users.id
- type, text, for example goal_created, goal_completed, countdown_started
- payload, jsonb, optional extra data
- created_at, timestamptz, default now

## 6. notifications

Optional table for storing notifications when server side delivery is needed.

- id, uuid, primary key
- user_id, uuid, foreign key to users.id
- type, text
- title, text
- body, text
- scheduled_for, timestamptz, nullable
- delivered_at, timestamptz, nullable

## 7. indexes and performance

- Index on goals.owner_id.
- Index on activities.user_id and created_at for feed queries.
- Index on followers.user_id and followers.follower_id.

## 8. Example Row Level Security (RLS) policies

The following snippets show how to enforce the privacy model using PostgreSQL RLS in Supabase.

### 8.1 Enable RLS on tables

```sql
alter table public.users         enable row level security;
alter table public.goals         enable row level security;
alter table public.goal_steps    enable row level security;
alter table public.followers     enable row level security;
alter table public.activities    enable row level security;
alter table public.notifications enable row level security;
```

### 8.2 users

Users can only see and update their own profile row.

```sql
create policy "Users can select their own profile"
on public.users
for select
using ( auth.uid() = id );

create policy "Users can update their own profile"
on public.users
for update
using ( auth.uid() = id )
with check ( auth.uid() = id );
```

Social and leaderboard queries should **not** select directly from `public.users` with broad access. Instead, implement read-only views or RPC functions that expose only non-sensitive fields for public profiles and are called from secure backend code (for example Supabase Edge Functions using the service role key).

### 8.3 goals

Goals are always private to their owner.

```sql
create policy "Users can read their own goals"
on public.goals
for select
using ( auth.uid() = owner_id );

create policy "Users can insert their own goals"
on public.goals
for insert
with check ( auth.uid() = owner_id );

create policy "Users can update their own goals"
on public.goals
for update
using ( auth.uid() = owner_id )
with check ( auth.uid() = owner_id );

create policy "Users can delete their own goals"
on public.goals
for delete
using ( auth.uid() = owner_id );
```

### 8.4 goal_steps

Access to goal steps is tied to ownership of the parent goal.

```sql
create policy "Users can read steps for their own goals"
on public.goal_steps
for select
using (
  exists (
    select 1 from public.goals g
    where g.id = goal_id and g.owner_id = auth.uid()
  )
);

create policy "Users can insert steps for their own goals"
on public.goal_steps
for insert
with check (
  exists (
    select 1 from public.goals g
    where g.id = goal_id and g.owner_id = auth.uid()
  )
);

create policy "Users can update steps for their own goals"
on public.goal_steps
for update
using (
  exists (
    select 1 from public.goals g
    where g.id = goal_id and g.owner_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.goals g
    where g.id = goal_id and g.owner_id = auth.uid()
  )
);

create policy "Users can delete steps for their own goals"
on public.goal_steps
for delete
using (
  exists (
    select 1 from public.goals g
    where g.id = goal_id and g.owner_id = auth.uid()
  )
);
```

### 8.5 followers

Follow relationships are visible only to the users involved. Either side can remove a relationship.

```sql
create policy "Users can read their follower relationships"
on public.followers
for select
using ( auth.uid() = user_id or auth.uid() = follower_id );

create policy "Users can follow others"
on public.followers
for insert
with check ( auth.uid() = follower_id );

create policy "Users can unfollow or remove followers"
on public.followers
for delete
using ( auth.uid() = user_id or auth.uid() = follower_id );
```

### 8.6 activities

Users see only their own activity timeline. Public feeds and leaderboards should use separate, read-only views or RPC functions that return aggregated activity for public profiles only.

```sql
create policy "Users can read their own activity"
on public.activities
for select
using ( auth.uid() = user_id );

create policy "Users can insert their own activity events"
on public.activities
for insert
with check ( auth.uid() = user_id );
```

### 8.7 notifications

Notifications are private to the recipient user.

```sql
create policy "Users can read their own notifications"
on public.notifications
for select
using ( auth.uid() = user_id );

create policy "Users can receive their own notifications"
on public.notifications
for insert
with check ( auth.uid() = user_id );

create policy "Users can delete their own notifications"
on public.notifications
for delete
using ( auth.uid() = user_id );
```

