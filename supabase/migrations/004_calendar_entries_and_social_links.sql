-- Calendar entries table for user progress and smaller achievements
CREATE TABLE IF NOT EXISTS public.calendar_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    goal_id UUID REFERENCES public.goals(id) ON DELETE SET NULL,
    entry_date DATE NOT NULL,
    title TEXT NOT NULL,
    note TEXT,
    entry_type TEXT NOT NULL DEFAULT 'note', -- e.g. 'progress', 'milestone', 'reflection'
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_calendar_entries_user_date
    ON public.calendar_entries(user_id, entry_date);

ALTER TABLE public.calendar_entries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read their calendar entries"
ON public.calendar_entries FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their calendar entries"
ON public.calendar_entries FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their calendar entries"
ON public.calendar_entries FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their calendar entries"
ON public.calendar_entries FOR DELETE
USING (auth.uid() = user_id);

-- Optional social media links on users
ALTER TABLE public.users
    ADD COLUMN IF NOT EXISTS twitter_handle TEXT,
    ADD COLUMN IF NOT EXISTS instagram_handle TEXT,
    ADD COLUMN IF NOT EXISTS tiktok_handle TEXT,
    ADD COLUMN IF NOT EXISTS website_url TEXT;

-- Expose social links in the public profiles view for public accounts only
CREATE OR REPLACE VIEW public.public_profiles AS
SELECT
    id,
    username,
    avatar_url,
    bio,
    is_public_profile,
    countdown_start_date,
    countdown_end_date,
    created_at,
    twitter_handle,
    instagram_handle,
    tiktok_handle,
    website_url
FROM public.users
WHERE is_public_profile = true;

GRANT SELECT ON public.public_profiles TO authenticated;
