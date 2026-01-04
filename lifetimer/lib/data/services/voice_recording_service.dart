import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'mistral_ai_service.dart';

class VoiceRecordingException implements Exception {
  final String message;

  VoiceRecordingException(this.message);

  @override
  String toString() => 'VoiceRecordingException: $message';
}

class VoiceRecordingService {
  final AudioRecorder _recorder = AudioRecorder();
  final MistralAIService _mistralService;
  String? _currentRecordingPath;
  bool _isRecording = false;

  VoiceRecordingService({required MistralAIService mistralService})
      : _mistralService = mistralService;

  bool get isRecording => _isRecording;

  Future<bool> requestPermissions() async {
    try {
      final microphoneStatus = await Permission.microphone.request();
      await Permission.storage.request();
      
      return microphoneStatus == PermissionStatus.granted ||
             microphoneStatus == PermissionStatus.limited;
    } catch (e) {
      throw VoiceRecordingException('Failed to request permissions: $e');
    }
  }

  Future<void> startRecording() async {
    try {
      if (_isRecording) {
        throw VoiceRecordingException('Recording is already in progress');
      }

      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        throw VoiceRecordingException('Microphone permission denied');
      }

      final directory = await getTemporaryDirectory();
      _currentRecordingPath = '${directory.path}/voice_recording_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentRecordingPath!,
      );

      _isRecording = true;
    } catch (e) {
      if (e is VoiceRecordingException) rethrow;
      throw VoiceRecordingException('Failed to start recording: $e');
    }
  }

  Future<String> stopRecording() async {
    try {
      if (!_isRecording) {
        throw VoiceRecordingException('No recording in progress');
      }

      final path = await _recorder.stop();
      _isRecording = false;

      if (path == null) {
        throw VoiceRecordingException('Failed to save recording');
      }

      _currentRecordingPath = path;
      return path;
    } catch (e) {
      if (e is VoiceRecordingException) rethrow;
      throw VoiceRecordingException('Failed to stop recording: $e');
    }
  }

  Future<String> transcribeRecording({String? audioFilePath}) async {
    try {
      final filePath = audioFilePath ?? _currentRecordingPath;
      
      if (filePath == null) {
        throw VoiceRecordingException('No audio file available for transcription');
      }

      final file = File(filePath);
      if (!await file.exists()) {
        throw VoiceRecordingException('Audio file does not exist');
      }

      final transcription = await _mistralService.transcribeAudio(
        audioFilePath: filePath,
      );

      // Clean up the temporary file
      try {
        await file.delete();
      } catch (e) {
        // Ignore cleanup errors
      }

      _currentRecordingPath = null;
      return transcription;
    } catch (e) {
      if (e is VoiceRecordingException || e is MistralAIException) rethrow;
      throw VoiceRecordingException('Failed to transcribe recording: $e');
    }
  }

  Future<String> recordAndTranscribe() async {
    try {
      await startRecording();
      // Note: The caller should handle the timing of when to stop recording
      // This method is just a convenience wrapper
      throw VoiceRecordingException(
        'Use startRecording() and stopRecording() separately, then call transcribeRecording()',
      );
    } catch (e) {
      if (e is VoiceRecordingException) rethrow;
      throw VoiceRecordingException('Failed in record and transcribe flow: $e');
    }
  }

  Future<void> cancelRecording() async {
    try {
      if (_isRecording) {
        await _recorder.stop();
        _isRecording = false;
        
        // Clean up the file if it exists
        if (_currentRecordingPath != null) {
          final file = File(_currentRecordingPath!);
          try {
            await file.delete();
          } catch (e) {
            // Ignore cleanup errors
          }
          _currentRecordingPath = null;
        }
      }
    } catch (e) {
      throw VoiceRecordingException('Failed to cancel recording: $e');
    }
  }

  void dispose() {
    if (_isRecording) {
      cancelRecording();
    }
    _recorder.dispose();
  }
}
