import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bootstrap/env.dart';
import '../../../data/services/mistral_ai_service.dart';
import '../../../data/services/voice_recording_service.dart';

final voiceRecordingControllerProvider =
    StateNotifierProvider<VoiceRecordingController, VoiceRecordingState>((ref) {
  final mistralService = MistralAIService(apiKey: Env.mistralApiKey);
  final voiceService = VoiceRecordingService(mistralService: mistralService);
  return VoiceRecordingController(voiceService, mistralService);
});

class VoiceRecordingState {
  final bool isRecording;
  final bool isProcessing;
  final Duration elapsed;
  final String? transcript;
  final String? error;
  final List<double> levels;

  const VoiceRecordingState({
    this.isRecording = false,
    this.isProcessing = false,
    this.elapsed = Duration.zero,
    this.transcript,
    this.error,
    this.levels = const [],
  });

  VoiceRecordingState copyWith({
    bool? isRecording,
    bool? isProcessing,
    Duration? elapsed,
    String? transcript,
    String? error,
    List<double>? levels,
  }) {
    return VoiceRecordingState(
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      elapsed: elapsed ?? this.elapsed,
      transcript: transcript ?? this.transcript,
      error: error ?? this.error,
      levels: levels ?? this.levels,
    );
  }
}

class VoiceRecordingController extends StateNotifier<VoiceRecordingState> {
  final VoiceRecordingService _voiceService;
  final MistralAIService _mistralService;
  final Random _random = Random();

  Timer? _ticker;

  VoiceRecordingController(this._voiceService, this._mistralService)
      : super(const VoiceRecordingState());

  Future<void> startRecording() async {
    if (state.isRecording || state.isProcessing) {
      return;
    }

    try {
      await _voiceService.startRecording();
      _startTicker();
      state = state.copyWith(
        isRecording: true,
        isProcessing: false,
        elapsed: Duration.zero,
        error: null,
        transcript: null,
        levels: _generateWaveform(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> stopRecording() async {
    if (!state.isRecording) {
      return;
    }

    _stopTicker();

    state = state.copyWith(
      isRecording: false,
      isProcessing: true,
      error: null,
    );

    try {
      final audioPath = await _voiceService.stopRecording();
      if (audioPath.isEmpty) {
        state = state.copyWith(
          isProcessing: false,
          error: 'Failed to save recording',
        );
        return;
      }

      final transcription = await _voiceService.transcribeRecording(
        audioFilePath: audioPath,
      );

      state = state.copyWith(
        isProcessing: false,
        transcript: transcription.isNotEmpty
            ? transcription
            : 'No speech detected. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  Future<void> cancelRecording() async {
    if (!state.isRecording) {
      return;
    }

    try {
      await _voiceService.cancelRecording();
    } catch (_) {}

    _stopTicker();

    state = state.copyWith(
      isRecording: false,
      isProcessing: false,
      elapsed: Duration.zero,
      levels: const [],
    );
  }

  void reset() {
    state = const VoiceRecordingState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  List<double> _generateWaveform() {
    return List<double>.generate(40, (index) {
      final base = 0.2 + _random.nextDouble() * 0.6;
      final wave = sin(index / 2).abs();
      return (base + wave) / 2;
    });
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 120), (_) {
      final newElapsed = state.elapsed + const Duration(milliseconds: 120);
      state = state.copyWith(
        elapsed: newElapsed,
        levels: _generateWaveform(),
      );
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    _voiceService.dispose();
    _mistralService.dispose();
    super.dispose();
  }
}
