-- Create a view for public profile information
-- This view exposes only non-sensitive information for public profiles
CREATE OR REPLACE VIEW public.public_profiles AS
SELECT
    id,
    username,
    avatar_url,
    bio,
    is_public_profile,
    countdown_start_date,
    countdown_end_date,
    created_at
FROM public.users
WHERE is_public_profile = true;

-- Grant access to the view for authenticated users
GRANT SELECT ON public.public_profiles TO authenticated;

-- Function to get public leaderboard
CREATE OR REPLACE FUNCTION get_leaderboard(sort_by TEXT DEFAULT 'created_at', limit_count INTEGER DEFAULT 50)
RETURNS TABLE (
    id UUID,
    username TEXT,
    avatar_url TEXT,
    bio TEXT,
    countdown_start_date TIMESTAMPTZ,
    countdown_end_date TIMESTAMPTZ,
    goals_completed_count INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        u.id,
        u.username,
        u.avatar_url,
        u.bio,
        u.countdown_start_date,
        u.countdown_end_date,
        COALESCE(
            (SELECT COUNT(*) FROM public.goals g WHERE g.owner_id = u.id AND g.completed = true),
            0
        ) as goals_completed_count
    FROM public.users u
    WHERE u.is_public_profile = true
    ORDER BY
        CASE sort_by
            WHEN 'goals_completed' THEN COALESCE(
                (SELECT COUNT(*) FROM public.goals g WHERE g.owner_id = u.id AND g.completed = true),
                0
            )
            ELSE u.created_at
        END DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute on the function
GRANT EXECUTE ON FUNCTION get_leaderboard(TEXT, INTEGER) TO authenticated;
