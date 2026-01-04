import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/validators.dart';
import '../application/profile_controller.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _twitterController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _websiteController = TextEditingController();
  
  dynamic _avatarFile;
  String? _avatarUrl;
  bool _isLoading = false;
  bool _isCheckingUsername = false;
  bool _isUsernameAvailable = true;
  String? _usernameError;

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickAvatar() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          if (kIsWeb) {
            _avatarFile = image;
          } else {
            _avatarFile = File(image.path);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<String?> _uploadAvatar() async {
    if (_avatarFile == null) return null;

    try {
      final client = supabase.Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) return null;

      String fileExt;
      String fileName;
      String filePath;
      
      if (kIsWeb && _avatarFile is XFile) {
        fileExt = (_avatarFile as XFile).path.split('.').last;
        fileName = '$userId/avatar.$fileExt';
        filePath = 'avatars/$fileName';
        
        final bytes = await (_avatarFile as XFile).readAsBytes();
        await client.storage.from('avatars').uploadBinary(
          filePath,
          bytes,
          fileOptions: supabase.FileOptions(contentType: 'image/$fileExt'),
        );
      } else {
        fileExt = (_avatarFile as File).path.split('.').last;
        fileName = '$userId/avatar.$fileExt';
        filePath = 'avatars/$fileName';
        
        await client.storage.from('avatars').upload(filePath, _avatarFile!);
      }
      
      final response = client.storage.from('avatars').getPublicUrl(filePath);
      return response;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload avatar: $e')),
        );
      }
      return null;
    }
  }

  Future<void> _checkUsernameAvailability(String username) async {
    if (username.length < 3) return;

    setState(() {
      _isCheckingUsername = true;
      _usernameError = null;
    });

    try {
      final client = supabase.Supabase.instance.client;
      final response = await client
          .from('users')
          .select('id')
          .eq('username', username)
          .maybeSingle();

      setState(() {
        _isUsernameAvailable = response == null;
        _isCheckingUsername = false;
        if (!_isUsernameAvailable) {
          _usernameError = 'Username is already taken';
        }
      });
    } catch (e) {
      setState(() {
        _isCheckingUsername = false;
      });
    }
  }

  Future<void> _handleCompleteSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final client = supabase.Supabase.instance.client;
      final userId = client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      String? uploadedAvatarUrl;
      if (_avatarFile != null) {
        uploadedAvatarUrl = await _uploadAvatar();
      }

      await ref.read(profileControllerProvider.notifier).completeProfileSetup(
            userId: userId,
            username: _usernameController.text.trim(),
            bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
            avatarUrl: uploadedAvatarUrl ?? _avatarUrl,
            twitterHandle: _twitterController.text.trim().isEmpty
                ? null
                : _twitterController.text.trim(),
            instagramHandle: _instagramController.text.trim().isEmpty
                ? null
                : _instagramController.text.trim(),
            tiktokHandle: _tiktokController.text.trim().isEmpty
                ? null
                : _tiktokController.text.trim(),
            websiteUrl: _websiteController.text.trim().isEmpty
                ? null
                : _websiteController.text.trim(),
          );

      if (mounted) {
        context.go('/onboarding');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to complete setup: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Complete Your Profile',
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _pickAvatar,
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 2,
                            ),
                          ),
                          child: _avatarFile != null
                              ? ClipOval(
                                  child: Image.file(
                                    _avatarFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : _avatarUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        _avatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                        ),
                        if (!_isLoading)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Tap to add a photo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  textCapitalization: TextCapitalization.none,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.alternate_email),
                    suffixIcon: _isCheckingUsername
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : _usernameController.text.isNotEmpty && !_isCheckingUsername
                            ? Icon(
                                _isUsernameAvailable ? Icons.check_circle : Icons.cancel,
                                color: _isUsernameAvailable ? Colors.green : Colors.red,
                              )
                            : null,
                    border: const OutlineInputBorder(),
                  ),
                  validator: Validators.validateUsername,
                  enabled: !_isLoading,
                  onChanged: (value) {
                    if (value.length >= 3) {
                      _checkUsernameAvailability(value.trim());
                    }
                  },
                ),
                if (_usernameError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _usernameError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  maxLength: 150,
                  decoration: const InputDecoration(
                    labelText: 'Bio (optional)',
                    prefixIcon: Icon(Icons.info_outline),
                    border: OutlineInputBorder(),
                    helperText: 'Tell others a bit about yourself',
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _twitterController,
                  decoration: const InputDecoration(
                    labelText: 'Twitter (optional)',
                    prefixIcon: Icon(Icons.alternate_email),
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _instagramController,
                  decoration: const InputDecoration(
                    labelText: 'Instagram (optional)',
                    prefixIcon: Icon(Icons.camera_alt_outlined),
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tiktokController,
                  decoration: const InputDecoration(
                    labelText: 'TikTok (optional)',
                    prefixIcon: Icon(Icons.music_note_outlined),
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Website (optional)',
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  onPressed: () {
                    if (!_isLoading) {
                      _handleCompleteSetup();
                    }
                  },
                  text: _isLoading ? 'Saving...' : 'Continue',
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          try {
                            await supabase.Supabase.instance.client.auth.signOut();
                            if (!context.mounted) return;
                            context.go('/');
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Sign out failed: $e')),
                            );
                          }
                        },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
