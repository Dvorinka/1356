-- Function to automatically log goal creation activity
CREATE OR REPLACE FUNCTION log_goal_created()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.activities (user_id, type, payload)
    VALUES (
        NEW.owner_id,
        'goal_created',
        jsonb_build_object(
            'goal_id', NEW.id,
            'goal_title', NEW.title
        )
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for goal creation
CREATE TRIGGER on_goal_created
    AFTER INSERT ON public.goals
    FOR EACH ROW
    EXECUTE FUNCTION log_goal_created();

-- Function to automatically log goal completion activity
CREATE OR REPLACE FUNCTION log_goal_completed()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.completed = true AND (OLD.completed IS NULL OR OLD.completed = false) THEN
        INSERT INTO public.activities (user_id, type, payload)
        VALUES (
            NEW.owner_id,
            'goal_completed',
            jsonb_build_object(
                'goal_id', NEW.id,
                'goal_title', NEW.title,
                'progress', NEW.progress
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for goal completion
CREATE TRIGGER on_goal_completed
    AFTER UPDATE ON public.goals
    FOR EACH ROW
    WHEN (NEW.completed IS DISTINCT FROM OLD.completed)
    EXECUTE FUNCTION log_goal_completed();

-- Function to automatically log countdown start activity
CREATE OR REPLACE FUNCTION log_countdown_started()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.countdown_start_date IS NOT NULL AND (OLD.countdown_start_date IS NULL) THEN
        INSERT INTO public.activities (user_id, type, payload)
        VALUES (
            NEW.id,
            'countdown_started',
            jsonb_build_object(
                'start_date', NEW.countdown_start_date,
                'end_date', NEW.countdown_end_date
            )
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for countdown start
CREATE TRIGGER on_countdown_started
    AFTER UPDATE ON public.users
    FOR EACH ROW
    WHEN (NEW.countdown_start_date IS DISTINCT FROM OLD.countdown_start_date)
    EXECUTE FUNCTION log_countdown_started();
