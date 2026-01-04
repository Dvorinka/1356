import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/models/goal_model.dart';
import '../application/goals_controller.dart';
import 'location_picker_screen.dart';

enum GoalVerbType {
  travel,
  learn,
  experience,
  become,
  begin,
  create,
  love,
  earn,
}

class GoalTemplate {
  final String title;
  final String subtitle;
  final IconData icon;

  const GoalTemplate({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class LocationData {
  final double latitude;
  final double longitude;
  final String name;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.name,
  });
}

class BucketGoalCreateScreen extends ConsumerStatefulWidget {
  const BucketGoalCreateScreen({super.key});

  @override
  ConsumerState<BucketGoalCreateScreen> createState() => _BucketGoalCreateScreenState();
}

class _BucketGoalCreateScreenState extends ConsumerState<BucketGoalCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  GoalVerbType _selectedVerb = GoalVerbType.travel;
  bool _isSaving = false;
  LocationData? _selectedLocation;

  String? _selectedLearnFocus;
  String? _selectedProgrammingLanguage;

  double _earnMonthlyTarget = 1000;
  String _earnCurrency = '€';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _verbLabel(GoalVerbType verb) {
    switch (verb) {
      case GoalVerbType.travel:
        return 'travel';
      case GoalVerbType.learn:
        return 'learn';
      case GoalVerbType.experience:
        return 'experience';
      case GoalVerbType.become:
        return 'become';
      case GoalVerbType.begin:
        return 'begin';
      case GoalVerbType.create:
        return 'create';
      case GoalVerbType.love:
        return 'love';
      case GoalVerbType.earn:
        return 'earn';
    }
  }

  String _verbTagline(GoalVerbType verb) {
    switch (verb) {
      case GoalVerbType.travel:
        return 'Design unforgettable trips and dream destinations.';
      case GoalVerbType.learn:
        return 'Pick skills, languages, or subjects to master.';
      case GoalVerbType.experience:
        return 'Collect moments: events, adventures, and memories.';
      case GoalVerbType.become:
        return 'Shape who you want to be in 1356 days.';
      case GoalVerbType.begin:
        return 'Start habits, routines, or long-term projects.';
      case GoalVerbType.create:
        return 'Turn ideas into reality: books, films, products, art.';
      case GoalVerbType.love:
        return 'Nurture relationships, connection, and kindness.';
      case GoalVerbType.earn:
        return 'Set bold financial and career milestones.';
    }
  }

  List<GoalTemplate> _templatesForVerb(GoalVerbType verb) {
    switch (verb) {
      case GoalVerbType.travel:
        return const [
          GoalTemplate(
            title: 'Visit Japan for cherry blossom season',
            subtitle: 'Plan a two-week trip to Tokyo, Kyoto, and Osaka.',
            icon: Icons.flight_takeoff,
          ),
          GoalTemplate(
            title: 'Backpack across South America',
            subtitle: 'Explore at least three countries and capture the journey.',
            icon: Icons.terrain,
          ),
          GoalTemplate(
            title: 'Drive the Pacific Coast Highway',
            subtitle: 'Road trip from San Francisco to Los Angeles.',
            icon: Icons.directions_car,
          ),
          GoalTemplate(
            title: 'See the Northern Lights',
            subtitle: 'Travel to Iceland, Norway, or Finland in winter.',
            icon: Icons.nordic_walking,
          ),
        ];
      case GoalVerbType.learn:
        return const [
          GoalTemplate(
            title: 'Learn Spanish to conversational level',
            subtitle: 'Hold a 30-minute conversation entirely in Spanish.',
            icon: Icons.language,
          ),
          GoalTemplate(
            title: 'Learn Python programming',
            subtitle: 'Build and ship a real project using Python.',
            icon: Icons.code,
          ),
          GoalTemplate(
            title: 'Learn to play the piano',
            subtitle: 'Perform three complete songs for friends or family.',
            icon: Icons.piano,
          ),
          GoalTemplate(
            title: 'Master public speaking',
            subtitle: 'Deliver a confident talk in front of 50+ people.',
            icon: Icons.record_voice_over,
          ),
        ];
      case GoalVerbType.experience:
        return const [
          GoalTemplate(
            title: 'Run a marathon',
            subtitle: 'Train consistently and complete a full marathon.',
            icon: Icons.directions_run,
          ),
          GoalTemplate(
            title: 'Attend a major music festival',
            subtitle: 'See your favorite artists live with friends.',
            icon: Icons.music_note,
          ),
          GoalTemplate(
            title: 'Take a solo trip',
            subtitle: 'Spend at least five days traveling alone.',
            icon: Icons.person_pin_circle,
          ),
          GoalTemplate(
            title: 'Witness a sunrise from a mountain peak',
            subtitle: 'Hike early and reach the summit before sunrise.',
            icon: Icons.wb_sunny,
          ),
        ];
      case GoalVerbType.become:
        return const [
          GoalTemplate(
            title: 'Become a morning person',
            subtitle: 'Wake up before 6:30 AM for 60 consecutive days.',
            icon: Icons.wb_twilight,
          ),
          GoalTemplate(
            title: 'Become a confident leader',
            subtitle: 'Lead at least one project or team successfully.',
            icon: Icons.leaderboard,
          ),
          GoalTemplate(
            title: 'Become a published author',
            subtitle: 'Publish an article, essay, or book under your name.',
            icon: Icons.menu_book,
          ),
          GoalTemplate(
            title: 'Become financially independent',
            subtitle: 'Cover living expenses with passive or portfolio income.',
            icon: Icons.savings,
          ),
        ];
      case GoalVerbType.begin:
        return const [
          GoalTemplate(
            title: 'Begin a daily journaling habit',
            subtitle: 'Write for at least 10 minutes every day.',
            icon: Icons.edit_note,
          ),
          GoalTemplate(
            title: 'Begin strength training',
            subtitle: 'Train three times per week for six months.',
            icon: Icons.fitness_center,
          ),
          GoalTemplate(
            title: 'Begin a mindfulness practice',
            subtitle: 'Meditate for 5–10 minutes each day.',
            icon: Icons.self_improvement,
          ),
          GoalTemplate(
            title: 'Begin a creative side project',
            subtitle: 'Ship one small release every month.',
            icon: Icons.lightbulb_outline,
          ),
        ];
      case GoalVerbType.create:
        return const [
          GoalTemplate(
            title: 'Write a book',
            subtitle: 'Finish and self-publish a book or long-form project.',
            icon: Icons.auto_stories,
          ),
          GoalTemplate(
            title: 'Make a short film',
            subtitle: 'Write, shoot, and edit a 10–20 minute film.',
            icon: Icons.movie_creation_outlined,
          ),
          GoalTemplate(
            title: 'Launch an online course',
            subtitle: 'Teach a topic you know and enroll your first students.',
            icon: Icons.school,
          ),
          GoalTemplate(
            title: 'Create a personal brand website',
            subtitle: 'Design and publish a portfolio or personal site.',
            icon: Icons.web_asset,
          ),
        ];
      case GoalVerbType.love:
        return const [
          GoalTemplate(
            title: 'Plan a dream trip with my partner',
            subtitle: 'Design and enjoy a special getaway together.',
            icon: Icons.favorite,
          ),
          GoalTemplate(
            title: 'Host a monthly dinner with friends',
            subtitle: 'Create a recurring ritual to stay connected.',
            icon: Icons.group,
          ),
          GoalTemplate(
            title: 'Reconnect with family',
            subtitle: 'Visit or call close relatives every month.',
            icon: Icons.family_restroom,
          ),
          GoalTemplate(
            title: 'Practice daily gratitude for loved ones',
            subtitle: 'Send one message of appreciation every day.',
            icon: Icons.emoji_emotions,
          ),
        ];
      case GoalVerbType.earn:
        return const [
          GoalTemplate(
            title: 'Save an emergency fund of 3–6 months expenses',
            subtitle: 'Automatically set aside money every month.',
            icon: Icons.savings,
          ),
          GoalTemplate(
            title: 'Reach an extra 1,000/month in income',
            subtitle: 'Build a side income stream or raise your rates.',
            icon: Icons.trending_up,
          ),
          GoalTemplate(
            title: 'Pay off all high-interest debt',
            subtitle: 'Clear credit cards and loans within 1356 days.',
            icon: Icons.credit_score,
          ),
          GoalTemplate(
            title: 'Invest regularly in a long-term portfolio',
            subtitle: 'Invest every month according to a simple plan.',
            icon: Icons.show_chart,
          ),
        ];
    }
  }

  void _onLearnFocusSelected(String focus) {
    setState(() {
      _selectedLearnFocus = focus;
    });
  }

  void _onNaturalLanguageSelected(String language) {
    setState(() {
      _selectedProgrammingLanguage = language;
    });

    if (_titleController.text.trim().isEmpty) {
      _titleController.text = 'Learn $language to conversational level';
    }
    if (_descriptionController.text.trim().isEmpty) {
      _descriptionController.text =
          'Practice $language regularly and hold a 30-minute conversation.';
    }
  }

  void _onProgrammingLanguageSelected(String language) {
    setState(() {
      _selectedProgrammingLanguage = language;
    });

    if (_titleController.text.trim().isEmpty) {
      _titleController.text = 'Learn $language to a professional level';
    }
    if (_descriptionController.text.trim().isEmpty) {
      _descriptionController.text =
          'Study $language consistently and build at least one real project.';
    }
  }

  void _onEarnCurrencySelected(String currency) {
    setState(() {
      _earnCurrency = currency;
    });
    _updateEarnGoalText();
  }

  void _updateEarnGoalText() {
    if (_selectedVerb != GoalVerbType.earn) return;

    final target = _earnMonthlyTarget.round();

    if (_titleController.text.trim().isEmpty) {
      _titleController.text =
          'Reach an extra $_earnCurrency$target/month in income';
    }

    if (_descriptionController.text.trim().isEmpty) {
      _descriptionController.text =
          'Increase your income until you consistently earn '
          '$_earnCurrency$target per month through side projects, career growth, or investments.';
    }
  }

  Future<void> _selectLocation() async {
    final result = await context.push<LocationPickerResult>('/location-picker');
    if (!mounted) return;
    if (result == null) return;
    setState(() {
      _selectedLocation = LocationData(
        latitude: result.position.latitude,
        longitude: result.position.longitude,
        name: result.address,
      );
    });
  }

  void _applyTemplate(GoalTemplate template) {
    _titleController.text = template.title;
    if (_descriptionController.text.trim().isEmpty) {
      _descriptionController.text = template.subtitle;
    }
  }

  Future<void> _createGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final now = DateTime.now();
      final goal = Goal(
        id: now.millisecondsSinceEpoch.toString(),
        ownerId: 'current_user_id',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        progress: 0,
        locationLat: _selectedLocation?.latitude,
        locationLng: _selectedLocation?.longitude,
        locationName: _selectedLocation?.name,
        imageUrl: null,
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(goalsControllerProvider.notifier).createGoal(goal);

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating goal: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppScaffold(
      title: 'New Bucket Goal',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Design your next bucket list goal',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Start with a verb, explore smart suggestions, or type anything custom.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha:0.7),
                ),
              ),
              const SizedBox(height: 24),
              _buildVerbSelector(context),
              const SizedBox(height: 16),
              Text(
                _verbTagline(_selectedVerb),
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha:0.7),
                ),
              ),
              const SizedBox(height: 24),
              _buildTemplatesSection(context),
              if (_selectedVerb == GoalVerbType.travel) ...[
                const SizedBox(height: 24),
                _buildTravelLocationSection(context),
              ],
              if (_selectedVerb == GoalVerbType.learn) ...[
                const SizedBox(height: 24),
                _buildLearnSpecialSection(context),
              ],
              if (_selectedVerb == GoalVerbType.earn) ...[
                const SizedBox(height: 24),
                _buildEarnSpecialSection(context),
              ],
              const SizedBox(height: 32),
              _buildGoalForm(context),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Add to bucket list',
                onPressed: _createGoal,
                isLoading: _isSaving,
                isDisabled: _isSaving,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerbSelector(BuildContext context) {
    const verbs = GoalVerbType.values;
    final textTheme = Theme.of(context).textTheme;
    final accent = Theme.of(context).colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF020617)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'I want to',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: verbs.map((verb) {
                  final selected = verb == _selectedVerb;
                  final label = _verbLabel(verb);
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedVerb = verb;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected
                                  ? accent
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha:0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOut,
                            height: 3,
                            width: selected ? 28 : 0,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesSection(BuildContext context) {
    final templates = _templatesForVerb(_selectedVerb);
    if (templates.isEmpty) {
      return const SizedBox.shrink();
    }

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 700;
    final crossAxisCount = isWide ? 2 : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular ideas for ${_verbLabel(_selectedVerb)} goals',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: templates.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: isWide ? 3.4 : 3.0,
          ),
          itemBuilder: (context, index) {
            final template = templates[index];
            return InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _applyTemplate(template),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF020617)
                      : AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha:0.05),
                      blurRadius: 14,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withValues(alpha:0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(
                        template.icon,
                        size: 22,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.title,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            template.subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha:0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLearnSpecialSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final categories = <String>[
      'Languages',
      'Programming',
      'Creative',
      'Career',
      'Other',
    ];

    final naturalLanguages = <String>[
      'Spanish',
      'French',
      'German',
      'Japanese',
      'Chinese',
      'Portuguese',
      'Other',
    ];

    final programmingLanguages = <String>[
      'Python',
      'JavaScript',
      'TypeScript',
      'Swift',
      'Kotlin',
      'Dart',
      'Go',
      'Rust',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF020617)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learning focus (optional)',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categories.map((category) {
              final selected = _selectedLearnFocus == category;
              return ChoiceChip(
                label: Text(category),
                selected: selected,
                onSelected: (_) => _onLearnFocusSelected(category),
              );
            }).toList(),
          ),
          if (_selectedLearnFocus == null) ...[
            const SizedBox(height: 8),
            Text(
              'Choose a focus area to get more tailored suggestions.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha:0.7),
              ),
            ),
          ],
          if (_selectedLearnFocus == 'Languages') ...[
            const SizedBox(height: 16),
            Text(
              'Pick a language',
              style: textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: naturalLanguages.map((language) {
                final selected = _selectedProgrammingLanguage == language;
                return ChoiceChip(
                  avatar: const Icon(Icons.translate, size: 18),
                  label: Text(language),
                  selected: selected,
                  onSelected: (_) => _onNaturalLanguageSelected(language),
                );
              }).toList(),
            ),
          ],
          if (_selectedLearnFocus == 'Programming') ...[
            const SizedBox(height: 16),
            Text(
              'Programming languages',
              style: textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: programmingLanguages.map((language) {
                final selected = _selectedProgrammingLanguage == language;
                return ChoiceChip(
                  avatar: const Icon(Icons.code, size: 18),
                  label: Text(language),
                  selected: selected,
                  onSelected: (_) => _onProgrammingLanguageSelected(language),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEarnSpecialSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final currencies = <String>['€', '\$', '£'];
    final target = _earnMonthlyTarget.round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF020617)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Income target (optional)',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.trending_up,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Currency',
            style: textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: currencies.map((currency) {
              final selected = _earnCurrency == currency;
              return ChoiceChip(
                label: Text(currency),
                selected: selected,
                onSelected: (_) => _onEarnCurrencySelected(currency),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Monthly target',
            style: textTheme.labelMedium,
          ),
          Slider(
            value: _earnMonthlyTarget,
            min: 0,
            max: 10000,
            divisions: 100,
            label: '$target',
            onChanged: (value) {
              setState(() {
                _earnMonthlyTarget = value;
              });
              _updateEarnGoalText();
            },
          ),
          const SizedBox(height: 4),
          Text(
            'Target: $_earnCurrency$target per month',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha:0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelLocationSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF020617)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Destination (optional)',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.map_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedLocation == null)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectLocation,
                    icon: const Icon(Icons.public),
                    label: const Text('Pick on map'),
                  ),
                ),
              ],
            )
          else
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha:0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Icon(
                  Icons.place,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: Text(
                _selectedLocation!.name,
                style: textTheme.bodyLarge,
              ),
              subtitle: Text(
                '${_selectedLocation!.latitude.toStringAsFixed(4)}, ${_selectedLocation!.longitude.toStringAsFixed(4)}',
                style: textTheme.bodySmall,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _selectedLocation = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoalForm(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF020617)
            : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Describe your goal',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Goal title *',
              hintText: 'For example: Learn a programming language',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            validator: Validators.validateGoalTitle,
            enabled: !_isSaving,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Why this matters (optional)',
              hintText: 'Add context, motivation, or criteria for success.',
              prefixIcon: Icon(Icons.description_outlined),
            ),
            validator: Validators.validateGoalDescription,
            enabled: !_isSaving,
          ),
        ],
      ),
    );
  }
}
