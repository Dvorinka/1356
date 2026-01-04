import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/widgets/app_scaffold.dart';

class AboutChallengeScreen extends StatelessWidget {
  const AboutChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16),
          Center(
            child: Icon(
              Icons.timer_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'The 1356-Day Challenge',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'What is it?',
            content: 'The 1356-Day Challenge is a personal commitment to achieve your goals within exactly 1356 days (approximately 3 years, 8 months, and 11 days). Once you start your countdown, there is no stopping, pausing, or extending it.',
          ),
          _buildSection(
            context,
            title: 'How it works',
            content: '1. Create your bucket list with 1-20 goals\n'
                '2. Add milestones and track your progress\n'
                '3. Finalize your list to start the countdown\n'
                '4. Work towards completing your goals before time runs out',
          ),
          _buildSection(
            context,
            title: 'The Rules',
            content: '• You can create between 1 and 20 goals\n'
                '• The countdown only starts after you finalize your list\n'
                '• Once started, the countdown cannot be paused or reset\n'
                '• You can track progress but cannot change the duration\n'
                '• After 1356 days, the challenge ends',
          ),
          _buildSection(
            context,
            title: 'Why 1356 days?',
            content: '1356 days represents approximately 3.7 years - a meaningful timeframe that\'s long enough to achieve significant life goals but short enough to maintain urgency and motivation. It\'s the perfect balance between ambition and achievability.',
          ),
          _buildSection(
            context,
            title: 'Tips for Success',
            content: '• Choose goals that truly matter to you\n'
                '• Break large goals into smaller milestones\n'
                '• Update your progress regularly\n'
                '• Stay motivated by tracking your achievements\n'
                '• Share your journey with others (optional)',
          ),
          _buildSection(
            context,
            title: 'Privacy',
            content: 'Your goals and progress are private by default. You can choose to make your profile public to share your achievements with the community, but your detailed goal information remains private.',
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'About Project 1356',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: 'Origin of Project 1356',
            content:
                'Project 1356 began in April 2022 as a mysterious social media countdown created by Armin Mehdizadeh. Every day, he posted a short video erasing a number on a whiteboard and writing the next lower number, counting down from 1,356 to zero. The countdown was set to end on January 1, 2026, exactly 1,356 days after it began - a number chosen after asking Google how many days were left until that date.',
          ),
          _buildSection(
            context,
            title: 'The Reveal',
            content:
                'On January 1, 2026, Armin revealed that Project 1356 was a personal challenge: achieve six major life goals in 1,356 days or face public embarrassment. The goals included reaching 100,000 YouTube subscribers, earning \$10,000 per month, building a business that makes \$10,000 monthly, reaching a weight of 185 pounds, earning a business administration degree, and becoming a skilled music producer. In the end, he achieved two of the goals related to income and business revenue but did not complete the others.',
          ),
          _buildSection(
            context,
            title: 'More Than One Person\'s Story',
            content:
                'Over time, the project grew far beyond Armin\'s personal journey. Thousands of followers started using the countdown idea to track their own milestones - quitting alcohol, improving fitness, getting married, changing careers, and more. The real value was not just reaching zero, but the transformation that happened during the 1,356 days.',
          ),
          _buildSection(
            context,
            title: 'Project 1356 - Part 2',
            content:
                'On January 7, 2026, Armin announced Project 1356 Part 2. Instead of everyone watching his countdown, he invited people to set their own six life-changing goals for the next 1,356 days. Participants do not have to reveal their goals publicly, but they commit to the long-term journey of accountability and growth.',
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Follow Project 1356 & Armin',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'To follow the creator and the ongoing community around Project 1356:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _openLink(
                          context,
                          'https://www.instagram.com/project.1356/',
                        ),
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Instagram'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _openLink(
                          context,
                          'https://www.youtube.com/@arminmehdiz',
                        ),
                        icon: const Icon(Icons.ondemand_video_outlined),
                        label: const Text('YouTube'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.check),
            label: const Text('Got it!'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required String content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open link')),
      );
    }
  }
}
