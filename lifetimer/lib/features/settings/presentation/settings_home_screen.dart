import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../core/widgets/app_scaffold.dart';

class SettingsHomeScreen extends ConsumerWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      body: ListView(
        children: [
          _buildSection(
            context,
            title: 'Account',
            children: [
              _SettingsTile(
                icon: Icons.person,
                title: 'Edit Profile',
                subtitle: 'Update your avatar, username, or bio',
                onTap: () => context.push('/profile/edit'),
              ),
              _SettingsTile(
                icon: Icons.email,
                title: 'Email',
                subtitle: supabase.Supabase.instance.client.auth.currentUser?.email ?? '',
                onTap: () => context.push('/settings/account'),
              ),
              _SettingsTile(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your password',
                onTap: () => context.push('/settings/account/password'),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Preferences',
            children: [
              _SettingsTile(
                icon: Icons.palette,
                title: 'Appearance',
                subtitle: 'Theme, time format',
                onTap: () => context.push('/settings/appearance'),
              ),
              _SettingsTile(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Reminders and alerts',
                onTap: () => context.push('/settings/notifications'),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Privacy',
            children: [
              _SettingsTile(
                icon: Icons.visibility,
                title: 'Profile Visibility',
                subtitle: 'Public or Private profile',
                onTap: () => context.push('/settings/privacy'),
              ),
              _SettingsTile(
                icon: Icons.block,
                title: 'Blocked Users',
                subtitle: 'Manage blocked accounts',
                onTap: () => context.push('/settings/privacy/blocked'),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'About',
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About the Challenge',
                subtitle: 'Learn about the 1356-day challenge',
                onTap: () => context.push('/settings/about'),
              ),
              _SettingsTile(
                icon: Icons.description,
                title: 'Terms of Service',
                subtitle: 'Legal terms and conditions',
                onTap: () => _showTermsOfService(context),
              ),
              _SettingsTile(
                icon: Icons.privacy_tip,
                title: 'Privacy Policy',
                subtitle: 'How we handle your data',
                onTap: () => _showPrivacyPolicy(context),
              ),
            ],
          ),
          _buildSection(
            context,
            title: 'Danger Zone',
            children: [
              _SettingsTile(
                icon: Icons.delete_forever,
                title: 'Delete Account',
                subtitle: 'Permanently delete your account and data',
                onTap: () => _showDeleteAccountDialog(context),
                isDestructive: true,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'LifeTimer v1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
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

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Semantics(
        label: 'Terms of Service dialog',
        child: AlertDialog(
          title: const Text('Terms of Service'),
          content: const SingleChildScrollView(
            child: Text(
              'LifeTimer Terms of Service\n\n'
              '1. Acceptance of Terms\n'
              'By using LifeTimer, you agree to these terms.\n\n'
              '2. User Responsibilities\n'
              'Users are responsible for maintaining the security of their account.\n\n'
              '3. Content\n'
              'Users own their goals and progress data.\n\n'
              '4. Service Availability\n'
              'We strive to keep the service available but cannot guarantee 100% uptime.\n\n'
              '5. Changes to Terms\n'
              'We may update these terms from time to time.',
            ),
          ),
          actions: [
            Semantics(
              button: true,
              label: 'Close terms of service',
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'LifeTimer Privacy Policy\n\n'
            '1. Data Collection\n'
            'We collect only the data necessary to provide the service.\n\n'
            '2. Data Usage\n'
            'Your data is used to track your goals and countdown progress.\n\n'
            '3. Data Security\n'
            'We use industry-standard security measures to protect your data.\n\n'
            '4. Public Profiles\n'
            'You can choose to make your profile public or private.\n\n'
            '5. Data Deletion\n'
            'You can request deletion of your account and associated data.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Semantics(
        label: 'Delete account confirmation dialog',
        child: AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
          ),
          actions: [
            Semantics(
              button: true,
              label: 'Cancel account deletion',
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            Semantics(
              button: true,
              label: 'Confirm account deletion',
              hint: 'This action cannot be undone',
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account deletion requires confirmation via email')),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('Delete'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      hint: subtitle,
      child: ListTile(
        leading: Icon(
          icon,
          color: isDestructive
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isDestructive
                ? Theme.of(context).colorScheme.error
                : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
