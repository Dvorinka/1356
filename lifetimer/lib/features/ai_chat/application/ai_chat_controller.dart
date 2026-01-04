import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/mistral_ai_service.dart';
import '../../../data/services/voice_recording_service.dart';
import '../../../bootstrap/env.dart';
import '../../countdown/application/countdown_controller.dart';
import '../../goals/application/goals_controller.dart';
import '../../../core/utils/date_time_utils.dart';

final aiChatControllerProvider = StateNotifierProvider<AIChatController, AIChatState>((ref) {
  final mistralService = MistralAIService(apiKey: Env.mistralApiKey);
  final voiceService = VoiceRecordingService(mistralService: mistralService);
  return AIChatController(ref, mistralService, voiceService);
});

class AIChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isRecording;
  final String? error;
  final String? currentTranscription;
  final bool privacyModeEnabled;

  AIChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isRecording = false,
    this.error,
    this.currentTranscription,
    this.privacyModeEnabled = true,
  });

  AIChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isRecording,
    String? error,
    String? currentTranscription,
    bool? privacyModeEnabled,
  }) {
    return AIChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isRecording: isRecording ?? this.isRecording,
      error: error ?? this.error,
      currentTranscription: currentTranscription ?? this.currentTranscription,
      privacyModeEnabled: privacyModeEnabled ?? this.privacyModeEnabled,
    );
  }
}

class AIChatController extends StateNotifier<AIChatState> {
  final Ref _ref;
  final MistralAIService _mistralService;
  final VoiceRecordingService _voiceService;

  static const String _privacyModePrefsKey = 'ai_chat_privacy_mode_enabled';

  AIChatController(this._ref, this._mistralService, this._voiceService)
      : super(AIChatState()) {
    _loadPrivacyMode();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    _mistralService.dispose();
    super.dispose();
  }

  void setPrivacyMode(bool enabled) {
    state = state.copyWith(privacyModeEnabled: enabled);
    _savePrivacyMode(enabled);
  }

  Future<void> _loadPrivacyMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getBool(_privacyModePrefsKey);
      if (stored != null) {
        state = state.copyWith(privacyModeEnabled: stored);
      }
    } catch (_) {}
  }

  Future<void> _savePrivacyMode(bool enabled) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_privacyModePrefsKey, enabled);
    } catch (_) {}
  }

  String _buildUserContextDescription() {
    final countdownState = _ref.read(countdownControllerProvider);
    final goalsState = _ref.read(goalsControllerProvider);

    final user = countdownState.user;

    if (user == null) {
      if (state.privacyModeEnabled) {
        return 'User privacy mode is ENABLED. No countdown data is available yet.';
      }

      return 'User privacy mode is DISABLED, but no countdown data could be loaded yet.';
    }

    final now = DateTime.now();
    final start = user.countdownStartDate;
    final end = user.countdownEndDate;

    String? countdownSummary;
    int? currentDay;
    int? daysRemaining;

    if (start != null && end != null) {
      final isFinished = DateTimeUtils.isCountdownFinished(end);
      if (isFinished) {
        countdownSummary =
            'Their 1356-day countdown challenge has already finished.';
      } else {
        final remainingDuration = DateTimeUtils.calculateRemainingTime(end);
        daysRemaining = remainingDuration.inDays;

        final totalDurationDays = end.difference(start).inDays;
        final elapsedDays = now.difference(start).inDays;

        if (totalDurationDays > 0) {
          currentDay = elapsedDays + 1;
        }

        final formattedRemaining =
            DateTimeUtils.formatCountdownCompact(remainingDuration);

        if (currentDay != null) {
          countdownSummary =
              'Currently on day $currentDay of ${DateTimeUtils.countdownDays} with about $formattedRemaining remaining (approximately $daysRemaining days left).';
        } else {
          countdownSummary =
              'A 1356-day countdown challenge is active with about $formattedRemaining remaining.';
        }
      }
    }

    if (state.privacyModeEnabled) {
      if (countdownSummary != null) {
        return 'User privacy mode is ENABLED. Only basic countdown information is shared. $countdownSummary';
      }

      return 'User privacy mode is ENABLED. The user has not started their 1356-day countdown yet.';
    }

    final buffer = StringBuffer();
    buffer.writeln(
        'User privacy mode is DISABLED. Use the following personal context to personalise your coaching:');
    buffer.writeln('Username: ${user.username}.');

    if (countdownSummary != null) {
      buffer.writeln(countdownSummary);
    } else {
      buffer.writeln(
          'The user has not started their 1356-day countdown challenge yet.');
    }

    final goals = goalsState.goals;

    if (goals.isNotEmpty) {
      buffer.writeln(
          'The user has ${goals.length} active bucket list goals. Here are some examples:');

      for (final goal in goals.take(3)) {
        buffer.writeln(
            '- Goal: "${goal.title}" (progress: ${goal.progress}%, completed: ${goal.completed}).');
      }

      final completedGoalsCount = goals.where((g) => g.completed).length;
      if (completedGoalsCount > 0) {
        buffer.writeln(
            'They have completed $completedGoalsCount goals so far in their challenge.');
      }
    } else {
      buffer.writeln(
          'The user currently has no saved goals, or they could not be loaded.');
    }

    return buffer.toString();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty || state.isLoading) return;

    final userMessage = ChatMessage(
      content: message.trim(),
      role: 'user',
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final userContextDescription = _buildUserContextDescription();
      final response = await _mistralService.chat(
        message: message,
        conversationHistory: state.messages,
        userContext: userContextDescription,
      );

      final aiMessage = ChatMessage(
        content: response,
        role: 'assistant',
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> startRecording() async {
    if (state.isRecording || state.isLoading) return;

    try {
      await _voiceService.startRecording();
      state = state.copyWith(isRecording: true, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> stopRecording() async {
    if (!state.isRecording) return;

    state = state.copyWith(isRecording: false, isLoading: true);

    try {
      final audioPath = await _voiceService.stopRecording();
      
      if (audioPath.isNotEmpty) {
        state = state.copyWith(currentTranscription: 'Transcribing...');
        
        final transcription = await _voiceService.transcribeRecording(
          audioFilePath: audioPath,
        );

        state = state.copyWith(currentTranscription: null);

        if (transcription.isNotEmpty) {
          await sendMessage(transcription);
        } else {
          state = state.copyWith(
            isLoading: false,
            error: 'No speech detected. Please try again.',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to save recording',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRecording: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelRecording() async {
    if (!state.isRecording) return;

    try {
      await _voiceService.cancelRecording();
      state = state.copyWith(isRecording: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearMessages() {
    state = state.copyWith(messages: []);
  }
}
