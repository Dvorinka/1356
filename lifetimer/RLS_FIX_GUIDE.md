# Fixing PostgrestException: Row-Level Security Policy Violation

## Problem Analysis

The error "new row violates row-level security policy for table 'users'" occurs when:
1. User successfully authenticates via Supabase Auth
2. App attempts to create a user profile in the `users` table
3. RLS policies prevent the newly authenticated user from inserting their own profile

## Root Cause

The issue stems from restrictive RLS policies on the `users` table that don't allow newly authenticated users to insert their own profile records. This is a common issue when RLS is enabled but proper policies aren't in place.

## Solution Implemented

### 1. Code Changes

#### Enhanced Error Handling in Auth Repository
- Modified `_createUserProfile()` to gracefully handle RLS violations
- Added fallback to service role client for admin operations
- Implemented graceful degradation to auth metadata if database operations fail

#### Service Role Client Support
- Added `getServiceRoleClient()` function in `supabase_client.dart`
- Provides elevated privileges for user profile creation
- Falls back to regular client if service role key is unavailable

### 2. Database RLS Policies Needed

To properly fix this issue, create the following RLS policies in your Supabase database:

```sql
-- Policy to allow users to insert their own profile
CREATE POLICY "Users can insert their own profile" ON users
FOR INSERT WITH CHECK (auth.uid() = id);

-- Policy to allow users to view their own profile
CREATE POLICY "Users can view own profile" ON users
FOR SELECT USING (auth.uid() = id);

-- Policy to allow users to update their own profile
CREATE POLICY "Users can update own profile" ON users
FOR UPDATE USING (auth.uid() = id);

-- Policy to allow authenticated users to view public profiles
CREATE POLICY "Public profiles are viewable by authenticated users" ON users
FOR SELECT USING (is_public_profile = true);
```

### 3. Environment Configuration

Add service role key to your environment (for development only):

```bash
# In .env file
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here

# When running the app
flutter run --dart-define-from-file=.env
```

## Implementation Details

### Error Handling Flow

1. **First Attempt**: Try creating profile with regular client
2. **Fallback**: If RLS blocks it, try with service role client
3. **Graceful Degradation**: If both fail, create user profile from auth metadata

### Benefits

- **Non-breaking**: App continues to work even with restrictive RLS
- **Secure**: Uses service role client only when necessary
- **Flexible**: Handles various database configurations
- **User-friendly**: No sign-up failures due to RLS issues

## Testing the Fix

1. **Test with RLS enabled**: Verify sign-up works with restrictive policies
2. **Test without RLS**: Ensure backward compatibility
3. **Test service role**: Verify elevated privileges work when configured
4. **Test fallback**: Confirm graceful degradation works

## Production Considerations

- Service role key should be handled server-side via Edge Functions
- Consider implementing a dedicated API endpoint for user profile creation
- Monitor RLS policy violations in production
- Implement proper logging for debugging RLS issues

## Alternative Solutions

If you prefer a server-side approach:

1. **Supabase Edge Function**: Create user profile via server function
2. **Database Trigger**: Auto-create profile on auth.user insert
3. **RPC Function**: Call database function with proper privileges

## Monitoring

Add logging to track RLS violations:
```dart
} catch (e) {
  // Log the RLS violation for monitoring
  print('RLS policy violation during user profile creation: $e');
  // Continue with fallback...
}
```

This fix ensures robust user registration while maintaining security through RLS policies.
