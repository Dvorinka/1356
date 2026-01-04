import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../bootstrap/env.dart';

class ChatMessage {
  final String content;
  final String role;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.role,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'role': role,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      content: json['content'] as String,
      role: json['role'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class MistralAIException implements Exception {
  final String message;
  final int? statusCode;

  MistralAIException(this.message, [this.statusCode]);

  @override
  String toString() => 'MistralAIException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class MistralAIService {
  final String _apiKey;
  final http.Client _client;

  MistralAIService({
    required String apiKey,
    http.Client? client,
  })  : _apiKey = apiKey,
        _client = client ?? http.Client();

  Future<String> chat({
    required String message,
    String model = Env.mistralChatModel,
    List<ChatMessage>? conversationHistory,
    String? userContext,
  }) async {
    try {
      final messages = <Map<String, String>>[];
      
      // Add system prompt for LifeTimer context
      messages.add({
        'role': 'system',
        'content': '''You are an AI assistant for LifeTimer, a gamified life countdown app where users create a bucket list and start a 1356-day countdown.
Your role is to help users with:
1. Goal setting and bucket list inspiration
2. Motivation and encouragement
3. Life advice and productivity tips
4. Creative ideas for experiences
Be inspiring, practical, and encouraging. Keep responses concise but meaningful.
If user context is provided, use it to personalise your responses while respecting any stated privacy limitations.''',
      });

      // Add optional structured user context as a separate system message
      if (userContext != null && userContext.trim().isNotEmpty) {
        messages.add({
          'role': 'system',
          'content': 'Current user context for this conversation: ${userContext.trim()}',
        });
      }

      // Add conversation history if provided
      if (conversationHistory != null) {
        final recentMessages = conversationHistory.length > 10 
            ? conversationHistory.sublist(conversationHistory.length - 10)
            : conversationHistory;
        for (final msg in recentMessages) { // Keep last 10 messages for context
          messages.add({
            'role': msg.role,
            'content': msg.content,
          });
        }
      }

      // Add current message
      messages.add({
        'role': 'user',
        'content': message,
      });

      final uri = Uri.https('api.mistral.ai', '/v1/chat/completions');

      final response = await _client.post(
        uri,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List;
        final firstChoice = choices.first as Map<String, dynamic>;
        final message = firstChoice['message'] as Map<String, dynamic>;
        return message['content'] as String;
      } else {
        throw MistralAIException(
          'Failed to get chat response',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is MistralAIException) rethrow;
      throw MistralAIException('Error in chat: $e');
    }
  }

  Future<String> transcribeAudio({
    required String audioFilePath,
    String model = Env.mistralVoiceModel,
  }) async {
    try {
      final uri = Uri.https('api.mistral.ai', '/v1/audio/transcriptions');

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $_apiKey'
        ..fields['model'] = model
        ..files.add(await http.MultipartFile.fromPath('file', audioFilePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        return data['text'] as String;
      } else {
        throw MistralAIException(
          'Failed to transcribe audio',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is MistralAIException) rethrow;
      throw MistralAIException('Error in transcription: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
