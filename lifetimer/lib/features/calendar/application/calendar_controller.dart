import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bootstrap/supabase_client.dart';
import '../../../data/models/calendar_entry_model.dart';
import '../../../data/repositories/calendar_repository.dart';
import '../../auth/application/auth_controller.dart';

class CalendarState {
  final DateTime selectedDate;
  final bool isLoading;
  final List<CalendarEntry> entries;
  final String? error;

  const CalendarState({
    required this.selectedDate,
    this.isLoading = false,
    this.entries = const [],
    this.error,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    bool? isLoading,
    List<CalendarEntry>? entries,
    String? error,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
      error: error,
    );
  }
}

class CalendarController extends StateNotifier<CalendarState> {
  final CalendarRepository _repository;
  final String _userId;

  CalendarController(this._repository, this._userId)
      : super(CalendarState(selectedDate: DateTime.now())) {
    _loadForSelectedDate();
  }

  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date);
    await _loadForSelectedDate();
  }

  Future<void> refresh() async {
    await _loadForSelectedDate();
  }

  Future<void> addEntry({
    required String title,
    String? note,
    String entryType = 'note',
    String? goalId,
  }) async {
    if (title.trim().isEmpty) return;

    try {
      final entry = await _repository.addEntry(
        userId: _userId,
        date: state.selectedDate,
        title: title.trim(),
        note: note?.trim().isEmpty == true ? null : note?.trim(),
        entryType: entryType,
        goalId: goalId,
      );

      final updated = [...state.entries, entry];
      state = state.copyWith(entries: updated, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> _loadForSelectedDate() async {
    if (_userId.isEmpty) return;

    try {
      state = state.copyWith(isLoading: true, error: null);
      final entries = await _repository.getEntriesForDate(
        userId: _userId,
        date: state.selectedDate,
      );
      state = state.copyWith(isLoading: false, entries: entries);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  return CalendarRepository(supabaseClient);
});

final calendarControllerProvider =
    StateNotifierProvider<CalendarController, CalendarState>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  final authController = ref.read(authControllerProvider.notifier);
  final userId = authController.currentUserId ?? '';
  return CalendarController(repo, userId);
});
