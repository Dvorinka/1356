import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/countdown_repository.dart';
import '../../../bootstrap/supabase_client.dart';
import '../../../core/services/analytics_service.dart';
import '../../../core/utils/date_time_utils.dart';
import '../../../data/services/home_screen_widget_service.dart';
import '../../auth/application/auth_controller.dart';

class CountdownController extends StateNotifier<CountdownState> {
  final CountdownRepository _repository;
  final String _userId;
  final AnalyticsService _analytics = AnalyticsService();
  Timer? _timer;
  DateTime? _lastUpdateTime;
  final HomeScreenWidgetService _widgetService = HomeScreenWidgetService();

  CountdownController(this._repository, this._userId) : super(const CountdownState.initial()) {
    _loadCountdown();
    _startTimer();
  }

  void _loadCountdown() async {
    state = const CountdownState.loading();
    try {
      final user = await _repository.getCountdownInfo(_userId);
      state = CountdownState.loaded(user);
      _analytics.logCountdownViewed();
      await _updateHomeScreenWidget(user);
    } catch (e) {
      state = CountdownState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'loadCountdown');
    }
  }

  void loadCountdown() {
    _loadCountdown();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state is CountdownLoaded) {
        final loadedState = state as CountdownLoaded;
        final now = DateTime.now();
        
        // Only update state if the seconds have actually changed
        if (_lastUpdateTime == null || 
            _lastUpdateTime!.second != now.second ||
            _lastUpdateTime!.minute != now.minute) {
          final user = loadedState.user;
          final countdownEnd = user?.countdownEndDate;

          if (countdownEnd != null) {
            final remaining = countdownEnd.difference(now);

            if (remaining.isNegative) {
              state = CountdownState.completed(user);
              _timer?.cancel();
            }
          }
          _lastUpdateTime = now;
        }
      }
    });
  }

  Future<void> startCountdown() async {
    try {
      final user = await _repository.startCountdown(_userId);
      _analytics.logCountdownStarted(
        startDate: user.countdownStartDate!.toIso8601String(),
        endDate: user.countdownEndDate!.toIso8601String(),
      );
      state = CountdownState.loaded(user);
      await _updateHomeScreenWidget(user);
    } catch (e) {
      state = CountdownState.error(e.toString());
      _analytics.logError(error: e.toString(), context: 'startCountdown');
    }
  }

  Future<void> _updateHomeScreenWidget(User? user) async {
    try {
      if (user == null || user.countdownEndDate == null) {
        await _widgetService.updateNextCountdownWidget(
          title: '1356-day challenge',
          timeLeft: 'Not started',
          subtitle: 'Open Lifetimer to begin your journey',
        );
        return;
      }

      final endDate = user.countdownEndDate!;
      final now = DateTime.now();
      final remaining = endDate.difference(now);

      if (remaining.isNegative) {
        await _widgetService.updateNextCountdownWidget(
          title: '1356-day challenge',
          timeLeft: 'Completed',
          subtitle: 'Open Lifetimer to review your journey',
        );
        return;
      }

      final compact = DateTimeUtils.formatCountdownCompact(remaining);
      final subtitle = 'Ends on ${DateTimeUtils.formatDate(endDate)}';

      await _widgetService.updateNextCountdownWidget(
        title: '1356-day challenge',
        timeLeft: compact,
        subtitle: subtitle,
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class CountdownState {
  final bool isLoading;
  final User? user;
  final String? error;

  const CountdownState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  const CountdownState.initial() : isLoading = false, user = null, error = null;

  const CountdownState.loading() : isLoading = true, user = null, error = null;

  const CountdownState.loaded(this.user) : isLoading = false, error = null;

  const CountdownState.completed(this.user) : isLoading = false, error = null;

  const CountdownState.error(this.error) : isLoading = false, user = null;
}

class CountdownLoaded extends CountdownState {
  const CountdownLoaded(User user) : super(user: user);
}

final countdownRepositoryProvider = Provider<CountdownRepository>((ref) {
  return CountdownRepository(supabaseClient);
});

final countdownControllerProvider = StateNotifierProvider<CountdownController, CountdownState>((ref) {
  final repository = ref.watch(countdownRepositoryProvider);
  final authController = ref.read(authControllerProvider.notifier);
  final userId = authController.currentUserId ?? '';
  
  if (userId.isEmpty) {
    return CountdownController(repository, 'placeholder_user_id');
  }
  
  return CountdownController(repository, userId);
});
