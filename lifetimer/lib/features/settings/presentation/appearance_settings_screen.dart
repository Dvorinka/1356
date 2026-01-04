// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/app_scaffold.dart';

enum ThemeMode { light, dark, system }
enum TimeFormat { twelveHour, twentyFourHour }

class AppearanceSettingsScreen extends ConsumerStatefulWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  ConsumerState<AppearanceSettingsScreen> createState() => _AppearanceSettingsScreenState();
}

class _AppearanceSettingsScreenState extends ConsumerState<AppearanceSettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  TimeFormat _timeFormat = TimeFormat.twelveHour;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('theme_mode') ?? 2;
    final timeFormatIndex = prefs.getInt('time_format') ?? 0;
    
    setState(() {
      _themeMode = ThemeMode.values[themeModeIndex];
      _timeFormat = TimeFormat.values[timeFormatIndex];
      _isLoading = false;
    });
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    setState(() => _themeMode = mode);
  }

  Future<void> _saveTimeFormat(TimeFormat format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('time_format', format.index);
    setState(() => _timeFormat = format);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Appearance',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildSection(
                  context,
                  title: 'Theme',
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('Light'),
                      subtitle: const Text('Always use light theme'),
                      value: ThemeMode.light,
                      groupValue: _themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          _saveThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('Dark'),
                      subtitle: const Text('Always use dark theme'),
                      value: ThemeMode.dark,
                      groupValue: _themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          _saveThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('System Default'),
                      subtitle: const Text('Follow device theme settings'),
                      value: ThemeMode.system,
                      groupValue: _themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          _saveThemeMode(value);
                        }
                      },
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  title: 'Time Format',
                  children: [
                    RadioListTile<TimeFormat>(
                      title: const Text('12-hour'),
                      subtitle: const Text('e.g., 3:30 PM'),
                      value: TimeFormat.twelveHour,
                      groupValue: _timeFormat,
                      onChanged: (value) {
                        if (value != null) {
                          _saveTimeFormat(value);
                        }
                      },
                    ),
                    RadioListTile<TimeFormat>(
                      title: const Text('24-hour'),
                      subtitle: const Text('e.g., 15:30'),
                      value: TimeFormat.twentyFourHour,
                      groupValue: _timeFormat,
                      onChanged: (value) {
                        if (value != null) {
                          _saveTimeFormat(value);
                        }
                      },
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  title: 'Preview',
                  children: [
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Countdown Preview',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatTimePreview(),
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Days remaining in your challenge',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  String _formatTimePreview() {
    final now = DateTime.now();
    final hours = now.hour;
    final minutes = now.minute.toString().padLeft(2, '0');
    
    if (_timeFormat == TimeFormat.twentyFourHour) {
      return '$hours:$minutes';
    } else {
      final period = hours >= 12 ? 'PM' : 'AM';
      final displayHours = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
      return '$displayHours:$minutes $period';
    }
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...children,
      ],
    );
  }
}
