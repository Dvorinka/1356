import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../models/calendar_entry_model.dart';
import '../../core/errors/failure.dart';

class CalendarRepository {
  final supabase.SupabaseClient _client;

  CalendarRepository(this._client);

  Future<List<CalendarEntry>> getEntriesForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T').first;

      final response = await _client
          .from('calendar_entries')
          .select()
          .eq('user_id', userId)
          .eq('entry_date', dateStr)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => CalendarEntry.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<CalendarEntry> addEntry({
    required String userId,
    required DateTime date,
    required String title,
    String? note,
    String entryType = 'note',
    String? goalId,
  }) async {
    try {
      final dateStr = date.toIso8601String().split('T').first;

      final response = await _client
          .from('calendar_entries')
          .insert({
            'user_id': userId,
            'goal_id': goalId,
            'entry_date': dateStr,
            'title': title,
            'note': note,
            'entry_type': entryType,
          })
          .select()
          .single();

      return CalendarEntry.fromJson(response);
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
