import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_scaffold.dart';
import '../application/voice_recording_controller.dart';

class VoiceRecordingScreen extends ConsumerWidget {
  const VoiceRecordingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(voiceRecordingControllerProvider);
    final controller = ref.read(voiceRecordingControllerProvider.notifier);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final elapsedText = _formatDuration(state.elapsed);

    return AppScaffold(
      title: 'Recording',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              state.isRecording ? 'Recording in progress' : 'Voice notes',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha:0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                elapsedText,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _Waveform(state: state),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.black.withValues(alpha:0.04),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: state.isRecording
                                  ? colorScheme.error
                                  : colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            state.isRecording
                                ? 'Listening...'
                                : state.isProcessing
                                    ? 'Transcribing your note'
                                    : 'Transcript',
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha:0.7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.transcript ??
                            (state.isRecording
                                ? 'Start speaking to capture your thoughts.'
                                : 'When you finish recording, your words will appear here as clean text.'),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha:0.9),
                        ),
                      ),
                      if (state.error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.error!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onErrorContainer,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: controller.clearError,
                                icon: const Icon(Icons.close, size: 16),
                                color: colorScheme.onErrorContainer,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Row(
            children: [
              _CircleIconButton(
                icon: Icons.delete_outline,
                onPressed: state.isRecording || state.isProcessing
                    ? null
                    : () => controller.reset(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.isProcessing
                        ? null
                        : () {
                            if (state.isRecording) {
                              controller.stopRecording();
                            } else {
                              controller.startRecording();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isRecording
                          ? colorScheme.error
                          : colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: state.isProcessing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                state.isRecording ? Icons.stop : Icons.mic,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.isRecording ? 'Stop' : 'Start',
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _CircleIconButton(
                icon: Icons.check,
                onPressed: state.transcript != null &&
                        !state.isRecording &&
                        !state.isProcessing
                    ? () => _copyTranscript(context, state.transcript!)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  final VoiceRecordingState state;

  const _Waveform({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final levels = state.levels.isNotEmpty
        ? state.levels
        : List<double>.filled(40, 0.2);

    return SizedBox(
      height: 96,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final level in levels)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Container(
                  height: 24 + level * 60,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _CircleIconButton({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: onPressed == null
            ? colorScheme.surfaceContainerHighest.withValues(alpha:0.4)
            : colorScheme.surface,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Icon(
            icon,
            size: 22,
            color: onPressed == null
                ? colorScheme.onSurface.withValues(alpha:0.3)
                : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  final centiseconds =
      (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
  return '$minutes:$seconds:$centiseconds';
}

Future<void> _copyTranscript(BuildContext context, String transcript) async {
  await Clipboard.setData(ClipboardData(text: transcript));
  if (!context.mounted) {
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Transcription copied to clipboard')),
  );
}
