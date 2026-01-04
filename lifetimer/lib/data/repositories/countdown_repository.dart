import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user_model.dart' as app;
import '../../core/utils/date_time_utils.dart';
import '../../core/errors/failure.dart';

class CountdownRepository {
  final supabase.SupabaseClient _client;

  CountdownRepository(this._client);

  Future<app.User> startCountdown(String userId) async {
    try {
      final user = await getCountdownInfo(userId);
      if (user.countdownStartDate != null) {
        throw const ValidationFailure('Countdown has already started and cannot be restarted');
      }

      final startDate = DateTime.now();
      final endDate = DateTimeUtils.calculateEndDate(startDate);

      final response = await _client
          .from('users')
          .update({
            'countdown_start_date': startDate.toIso8601String(),
            'countdown_end_date': endDate.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .single();

      return app.User.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<app.User> getCountdownInfo(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return app.User.fromJson(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> hasCountdownStarted(String userId) async {
    try {
      final user = await getCountdownInfo(userId);
      return user.countdownStartDate != null;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Failure _handleError(dynamic error) {
    if (error is supabase.PostgrestException) {
      return ServerFailure(error.message);
    }
    return UnknownFailure(error.toString());
  }
}
